unit Bonus;

interface

uses
  sysUtils, Graphics, Mover, PNGImage, Alphabet;
type
  TAbstractBonus=class(TMover)
      isPickedUp:Boolean;
      parent:TMover;
      class var duration:Real;
      procedure DrawGUI(canvas:TBitmap;const N:Word=0);virtual;abstract;
      procedure GUILogic(const params:Array of Integer);virtual;abstract;
      procedure MakeDamage(Target:TMover);override;
      constructor Create(const cx,cy:Integer);override;
      procedure logic(const params:Array of Integer);override;
  end;

  TSpeedPowerup=class(TAbstractBonus)
    public
      acceleration:Integer;
      class var duration:Real;
      constructor Create(const cx,cy:Integer);override;
      destructor Destroy;override;
      procedure MakeDamage(Target:TMover);override;
      procedure DrawFrame(canvas:TBitmap;const N:Integer=-1);override;
      Procedure DrawGUI(canvas:TBitmap;const N:Word=0);override;
      procedure logic(const params:Array of Integer);override;
      procedure GUILogic(const params:Array of Integer);override;
  end;

  TWeaponPowerup=class(TAbstractBonus)
      class var power:Integer;
      constructor Create(const cx,cy:Integer);override;
      procedure MakeDamage(Target:TMover);override;
      Procedure DrawGUI(canvas:TBitmap;const N:Word=0);override;
      procedure logic(const params:Array of Integer);override;
      procedure GUILogic(const params:Array of Integer);override;
      procedure DrawFrame(canvas:TBitmap;const N:Integer=-1);override;
  end;

implementation

uses
  UnitFactory;

procedure TAbstractBonus.MakeDamage(Target: TMover);
begin
  isAlive:=false;
  Sound('Powerup.wav');
end;

constructor TAbstractBonus.Create;
begin
  inherited;
  damage:=1;
end;

procedure TAbstractBonus.logic;
Begin
 if isAlive then
      if y<Params[1]+20 then y:=y+speed else isAlive:=false;
End;

/////////

procedure TSpeedPowerup.GUILogic(const params: array of Integer);
begin
  if Duration>0 then Duration:=Duration-0.01;
end;

procedure TSpeedPowerup.logic;
Begin
  if isGUI then GUILogic(params)
    else
      if isPickedUp then
        Begin
          parent.speed:=parent.speed+acceleration;
          if Duration<=0 then
            Begin
              isAlive:=false;
              Sound('Powerup_off.wav');
            End;

        End else
          inherited
End;

procedure TSpeedPowerup.DrawFrame(canvas: TBitmap; const N: Integer = -1);
begin
  if isGUI then DrawGUI(canvas,N)
    else inherited;
end;

procedure TSpeedPowerup.DrawGUI(canvas: TBitmap;const N:Word=0);
 var P:TPNGImage;
begin
  inherited DrawFrame(canvas,N);
  P:=TAlphabet.getString(':'+IntToStr(Round(Duration)));
  canvas.Canvas.Draw(x+3,y-7,P);
  P.Destroy;
end;

procedure TSpeedPowerup.MakeDamage(Target:TMover);
 var T:TAbstractBonus;
begin
  if (not Target.passive)and(Target.Bonuses<>nil) then
    Begin
      T:=TFactory.Construct(uSpeedPowerup,Target.x,Target.y,nil) as TAbstractBonus;
      Target.Bonuses.Add(T);
      T.isPickedUp:=true;
      T.parent:=Target;
      Duration:=10;
      inherited;
    End
      else Target.hp:=damage
end;

destructor TSpeedPowerup.Destroy;
Begin
if isPickedUp then
  parent.speed:=parent.speed-acceleration;
 inherited
End;

constructor TSpeedPowerup.Create;
begin
  inherited;
  //Duration:=1;
  Animation:=CreateAnimation('Bonus\Speed');
  passive:=true;
  acceleration:=1;
end;

/////////////////////
//TWeaponPowerup
/////////////////////

procedure TWeaponPowerup.DrawGUI(canvas: TBitmap;const N:Word=0);
 var P:TPNGImage;
begin
  inherited DrawFrame(canvas,N);
  P:=TAlphabet.getString(':'+IntToStr(power));
  canvas.Canvas.Draw(x+3,y-7,P);
  P.Destroy;
end;

procedure TWeaponPowerup.DrawFrame(canvas: TBitmap; const N: Integer = -1);
begin
  if isGUI then DrawGUI(canvas,N)
    else inherited;
end;

procedure TWeaponPowerup.GUILogic(const params: array of Integer);
begin
  //if Duration>0 then Duration:=Duration-0.01;
end;

procedure TWeaponPowerup.logic;
Begin
  if isGUI then GUILogic(params)
    else
      if isPickedUp then
        Begin
          //parent.joint.hp:=-1;
        End else
          inherited
End;

procedure TWeaponPowerup.MakeDamage(Target:TMover);
 var T:TAbstractBonus;J:TMover;
begin
  if (not Target.passive)and(Target.Bonuses<>nil) then
    Begin
      T:=TFactory.Construct(uWeaponPowerup,Target.x,Target.y,nil) as TAbstractBonus;
      Target.Bonuses.Add(T);
      T.isPickedUp:=true;
      T.parent:=Target;
      For J in T.Parent.Sockets do
        Begin
          J.setHitpoints(J.hp+1);
          power:=J.hp;
        End;
      inherited;
    End
      else Target.hp:=damage
end;

constructor TWeaponPowerup.Create;
begin
  inherited;
  Animation:=CreateAnimation('Bonus\Weapon');
  passive:=true;
end;

end.
