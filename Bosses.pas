unit Bosses;

interface

uses
  Mover, classes, Cannon;

Type
  TBoss1=class(TMover)
      fsx:Integer;
      fsy:Integer;
    public
      property GoToX:integer read fsx write fsx;
      property GoToY:integer read fsy write fsy;
      procedure logic(const params:Array of Integer);override;
      procedure setHP(v:Integer);override;
      procedure AttachSocket(Obj:TMover);override;
      constructor Create(const cx,cy:Integer; omd:TNotifyEvent);reintroduce;
  end;

implementation

uses
  UnitFactory, GameLog, sysutils;

procedure TBoss1.logic(const params: array of Integer);
begin
  inherited;
  if y<80 then
     y:=y+speed
      else
        Begin
            if x=GoToX then
              Begin
                GoToX:=Random(params[0])-width div 2;
              End
                else
                  if x<GoToX then x:=x+speed
                    else
                      x:=x-speed;
            if random(30)=0 then
              Sockets[Random(3)].pMousePressed;
        End;
end;

procedure TBoss1.AttachSocket(Obj: TMover);
begin
  inherited;
  Case Sockets.Count of
    1:
      Begin
          (Sockets[0]as TSocket).px:=0;
          (Sockets[0]as TSocket).py:=-80;
      End;
    2:
      Begin
          (Sockets[1]as TSocket).px:=-35;
          (Sockets[1]as TSocket).py:=-80;
      End;
    3:
      Begin
          (Sockets[1]as TSocket).px:=35;
          (Sockets[1]as TSocket).py:=-80;
      End;
  End;
end;

procedure TBoss1.setHP(v: Integer);
begin
  fhp:=fhp-v;
  if fhp<=0 then
    Begin
      isAlive:=false;
      ObjectDies;
    End
      else Sound('Hit.wav');
end;

constructor TBoss1.Create;
begin
  inherited create(cx,cy);
  name:='Boss lvl3';
  Animation:=CreateAnimation('Bosses\lvl3');
  Animation.speed:=10;
  fhp:=200;
  damage:=1;
  passive:=true;
  AttachSocket(TFactory.construct(uEnemyBasicGun,x,y,omd));
  AttachSocket(TFactory.construct(uEnemyBasicGun,x,y,omd));
  AttachSocket(TFactory.construct(uEnemyBasicGun,x,y,omd));
end;

end.
