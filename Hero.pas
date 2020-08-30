unit Hero;

interface

uses
  Classes,Mover,Projective,Animation, sysUtils, system.Math;

type
  THero = class(TMover)
      dx:Integer;
      oldDx:Integer;
      fsx:Integer;
      fsy:Integer;
      leftAnimation:Word;
      rightAnimation:Word;
      procedure setSpeed(v:Integer);override;
      function changedDx:Boolean;
    public
      property GoToX:integer read fsx write fsx;
      property GoToY:integer read fsy write fsy;
      constructor Create(const cx,cy:Integer; omd:TNotifyEvent);reintroduce;
      destructor Destroy;override;
      procedure logic(const params:Array of Integer);override;
      procedure ChangeAnimation(const dx:Integer);
      procedure AttachSocket(Obj:TMover);override;
  end;
  TMothership=class(TMover)
      constructor Create(const cx,cy:Integer);override;
      procedure logic(const params:Array of Integer);override;
      procedure setHP(v:Integer);override;
  end;

implementation

uses
  UnitFactory;

procedure THero.AttachSocket(Obj: TMover);
begin
  inherited;
  Case Sockets.Count of
    1:
      Begin
          (Sockets[0]as TSocket).px:=-16;
          (Sockets[0]as TSocket).py:=13;
      End;
    2:
      Begin
          (Sockets[1]as TSocket).px:=16;
          (Sockets[1]as TSocket).py:=13;
      End;
  End;
end;

procedure THero.setSpeed(v: Integer);
begin
  if v<=2 then
    fspeed:=v
end;

function THero.changedDx:Boolean;
Begin
 if sign(dx)=sign(oldDx) then result:=false
  else result:=true
End;

procedure THero.ChangeAnimation(const dx:Integer);
Begin
 if changedDx then
  Begin
    if dx<0 then
      Animation.goToFrame(leftAnimation)
        else
          if dx>0 then
            Animation.goToFrame(rightAnimation)
            else Animation.goToFrame(staticAnimation);
  End;
End;

procedure THero.logic;
begin
  inherited;
  dx:=(GoToX-x);
  ChangeAnimation(dx);
  oldDx:=dx;
  if x>(GoToX+speed) then x:=x-speed
    else if x<(GoToX-speed) then x:=x+speed else x:=GoToX;
  if y>(GoToY+speed) then y:=y-speed
    else if y<(GoToY-speed) then y:=y+speed else y:=GoToY
end;

destructor THero.Destroy;
begin
  inherited Destroy;
end;

constructor THero.Create;
begin
  inherited create(cx,cy);
  name:='Hero';
  onMouseDown:=omd;
  Animation:=CreateAnimation('Hero');
  staticAnimation:=Animation.Animations[0];
  rightAnimation:=Animation.Animations[1];
  leftAnimation:=Animation.Animations[2];
  Animation.Frame:=staticAnimation;
  Animation.speed:=1;
  damage:=1;
  fhp:=4;
end;

//////////
//TMothership
//////////

constructor TMothership.Create(const cx: Integer; const cy: Integer);
begin
  inherited;
  Animation:=CreateAnimation('Mothership');
  passive:=true;
end;

procedure TMothership.logic;
Begin
 if isAlive then
      if y<Params[1] then y:=y+speed else isAlive:=false;
End;

procedure TMothership.setHP(v: Integer);
begin
//
end;

end.
