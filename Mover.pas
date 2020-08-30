unit Mover;

interface

uses
  System.Generics.collections, Animation, classes, Graphics, mmsystem, SoundPlayer;

type
  TUnitType=(uSimpleEnemy, uHero, uMothership, uDebris,
             uSpeedPowerup, uWeaponPowerup, uBomb, uRoamingBomb,
             uBoss1, uProjective, uEnemyProjective,
             uBasicGun, uEnemyBasicGun,
             uButton, uPanel, uText, uEditBox,
             uExplosion, uImage);
  TMover = class
   strict protected
    name:String;
    isjoint:Boolean;
    fhp:Integer;
    falive:Boolean;
    fwidth:Word;
    fheight:Word;
    fx:Integer;
    fy:Integer;
    oldX:Integer;
    oldY:Integer;
    fonScoreChange:TNotifyEvent;
    fonMouseDown:TNotifyEvent;
    damage:integer;
    staticAnimation:Word;
    fscorePoints:Integer;
    fspeed:Integer;
    class var fonDeath:TNotifyEvent;
    procedure ObjectDies;
    procedure setSpeed(v:Integer);virtual;
    procedure setHP(v:integer);virtual;
    procedure setX(v:Integer);
    procedure setY(v:Integer);
    function getWidth:Word;virtual;
    function getHeight:Word;virtual;
    procedure setAlive(v:Boolean);virtual;
   public
    Animation:TTimelineAnimation;
    mousePressed:Boolean;
    visual:Boolean;
    Sockets:TList<TMover>;
    Bonuses:TList<TMover>;
    passive:Boolean;
    isGUI:Boolean;
    class procedure Sound(const s:String);virtual;
    procedure pMousePressed; dynamic;
    procedure ScoreChanged; dynamic;
    property speed:Integer read fspeed write setSpeed;
    property onMouseDown:TNotifyEvent read fonMouseDown write fonMouseDown;
    property OnScoreChange:TNotifyEvent read fonScoreChange write fonScoreChange;
    property isAlive:Boolean read falive write setAlive;
    property width:Word read getWidth;
    property height:Word read getHeight;
    property x:Integer read fx write setX;
    property y:Integer read fy write setY;
    property scorePoints:Integer read fscorePoints;
    constructor Create(const cx,cy:Integer);virtual;
    destructor Destroy;reintroduce;virtual;
    function hitTest(const x1,y1,w,h:Integer):Boolean;virtual;
    procedure logic(const params:Array of Integer);virtual;
    procedure Hits(Target:TMover);virtual;
    procedure MakeDamage(Target:TMover);virtual;
    property hp:Integer read fhp write setHP;
    procedure DrawFrame(canvas:TBitmap;const N:integer=-1);virtual;
    procedure MouseDown(const mx,my:Integer);virtual;
    procedure setHitpoints(v:Integer);
    procedure AttachSocket(Obj:TMover);virtual;
    class property OnObjectDies:TNotifyEvent read fonDeath write fonDeath;
    class function createAnimation(const filename:String):TTimelineAnimation;
  end;
  TSocket=class(TMover)
    px,
    py:Integer;
    function getObject:TMover;virtual;abstract;
    procedure DrawFrame(canvas:TBitmap;const N:Integer=-1);override;
  end;

implementation

constructor TMover.Create;
begin
  isAlive:=true;
  setHitpoints(1);
  speed:=1;
  damage:=0;
  passive:=false;
  visual:=true;
  x:=cx;
  y:=cy;
  fscorePoints:=0;
  Bonuses:=TList<TMover>.create;
  Sockets:=TList<TMover>.create;
end;

class function TMover.createAnimation(const filename:String):TTimelineAnimation;
begin
  result:=TTimelineAnimation.Create(filename);
end;

class procedure TMover.Sound;
begin
    TSoundPlayer.PlaySound(s);
end;

procedure TMover.AttachSocket(Obj: TMover);
begin
  Sockets.Add(Obj);
end;

procedure TMover.setHitpoints(v: Integer);
begin
  fhp:=v;
end;

procedure TMover.setSpeed(v: Integer);
begin
  fspeed:=v;
end;

procedure TMover.logic(const params: array of Integer);
 var T:TMover;
begin
  for T in Sockets do
    Begin
      T.x:=x;
      T.y:=y;
      T.logic(params);
    End;
  for T in Bonuses do
    Begin
        T.logic(params);
        if not T.isAlive then
          Begin
            Bonuses.Delete(Bonuses.IndexOf(T));
            T.Destroy;
          End;
    End;

end;

procedure TMover.MouseDown(const mx: Integer; const my: Integer);
 var T:TMover;
begin
  for T in Sockets do
    T.MouseDown(mx,my);
end;

procedure TMover.setHP(v: Integer);
begin
  if v>0 then
    Begin
      fhp:=fhp-v;
      if fhp<=0 then isAlive:=false
        else Sound('Hit.wav');
    End;
end;

procedure TMover.MakeDamage(Target:TMover);
begin
 Target.hp:=damage;
end;

procedure TMover.Hits(Target: TMover);
begin
  Target.MakeDamage(Self);
  Self.MakeDamage(Target);
end;

function TMover.getWidth;
begin
  result:=Animation.width;
end;

function TMover.getHeight;
begin
  result:=Animation.height;
end;

destructor TMover.Destroy;
 var T:TMover;
begin
  for T in Sockets do
    T.Destroy;
  Sockets.Destroy;
  if Bonuses<>nil then
   Begin
      for T in Bonuses do
        T.Destroy;
      Bonuses.Destroy;
   End;
  if Animation<>nil then
    Animation.Destroy;
end;

procedure TMover.ObjectDies;
begin
  if Assigned(fonDeath) then fonDeath(Self);
end;

procedure TMover.pMousePressed;
begin
  if Assigned(fonMouseDown) then fonMouseDown(Self);
end;

procedure TMover.ScoreChanged;
begin
  if Assigned(fonScoreChange) then fonScoreChange(Self);
end;

procedure TMover.setAlive;
begin
 if not v then
  fAlive:=false
 else fAlive:=true;
end;

function TMover.hitTest(const x1,y1,w,h:Integer):Boolean;
 var o1x,o2x,o1y,o2y,o1w,o2w,o1h,o2h:Integer;
begin
  o1x:=x1;
  o1y:=y1;
  o1w:=w;
  o1h:=h;

  o2x:=x;
  o2y:=y;
  o2w:=width;
  o2h:=height;
 {
  o1x:=o1x-o1w div 2;
  o1y:=o1y-o1h div 2;

  o2x:=o2x-o2w div 2;
  o2y:=o2y-o2h div 2;
  }
  o1w:=o1w div 2 + o2w div 2;
  o1h:=o1h div 2 + o2h div 2;
  if (abs(o1x-o2x)<o1w/1.5)and(abs(o1y-o2y)<o1h/1.5) then result:=true
    else result:=false
end;

procedure TMover.setX(v: Integer);
begin
  fx:=v
end;

procedure TMover.setY(v: Integer);
begin
  fy:=v
end;

procedure TMover.DrawFrame(canvas: TBitmap;const N:Integer=-1);
 var T:TMover;
begin
  if visual then
    Begin
      canvas.Canvas.Draw(x-width div 2,y-height div 2,Animation.getFrame(N).image);
      for T in Sockets do
        T.DrawFrame(canvas);
    End;
end;

procedure TSocket.DrawFrame(canvas: TBitmap; const N: Integer = -1);
begin
  if visual then
    canvas.Canvas.Draw(x-width div 2 - px,y-height div 2 - py,Animation.getFrame(N).image);
end;

end.
