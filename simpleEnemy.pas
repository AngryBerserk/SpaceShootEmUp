unit simpleEnemy;

interface

uses
  Mover;

type
  TSimpleEnemy=class(TMover)
    public
      constructor Create(const cx,cy:Integer);override;
      procedure setHP(v:Integer);override;
      procedure logic(const params:Array of Integer);override;
  end;

  TBomb=class(TMover)
    public
      constructor Create(const cx,cy:Integer);override;
      procedure setHP(v:Integer);override;
      procedure logic(const params:Array of Integer);override;
  end;

  TDebris=class(TMover)
    public
      constructor Create(const cx,cy:Integer);override;
      procedure setHP(v:Integer);override;
      procedure logic(const params:Array of Integer);override;
  end;

  TRoamingBomb=class(TMover)
    public
      t:Real;
      dir:Boolean;
      constructor Create(const cx,cy:Integer);override;
      procedure setHP(v:Integer);override;
      procedure logic(const params:Array of Integer);override;
  end;

implementation

procedure TSimpleEnemy.logic;
Begin
 if isAlive then
      if y<Params[1] then
        Begin
          if y<=-1 then y:=y+1 else y:=y+speed
        end
          else isAlive:=false;
End;

procedure TSimpleEnemy.setHP(v: Integer);
begin
  fhp:=fhp-v;
  if fhp<=0 then
    Begin
      isAlive:=false;
      ObjectDies;
    End;
end;

constructor TSimpleEnemy.Create;
begin
  inherited create(cx,cy);
  Animation:=CreateAnimation('Enemies\E1');
  Animation.speed:=1;
  speed:=2;
  damage:=1;
  passive:=true;
end;

//////
///  TBomb
/////

constructor TBomb.Create;
begin
  inherited create(cx,cy);
  Animation:=CreateAnimation('Enemies\Bomb');
  Animation.speed:=100;
  damage:=1;
  //speed:=4;
  passive:=true;
end;

procedure TBomb.setHP(v: Integer);
begin
  fhp:=fhp-v;
  if fhp<=0 then
    Begin
      isAlive:=false;
      ObjectDies;
    End;
end;

procedure TBomb.logic;
Begin
 if isAlive then
      if y<Params[1] then y:=y+speed else isAlive:=false;
End;

//////
///  TDebris
/////

constructor TDebris.Create;
begin
  inherited create(cx,cy);
  Animation:=CreateAnimation('Enemies\Debris');
  name:='Debris';
  Animation.speed:=100;
  damage:=1;
  //speed:=4;
  passive:=true;
end;

procedure TDebris.setHP(v: Integer);
begin
  fhp:=fhp-v;
  if fhp<=0 then
    Begin
      isAlive:=false;
      ObjectDies;
    End;
end;

procedure TDebris.logic;
Begin
 if isAlive then
      if y<Params[1] then y:=y+speed else isAlive:=false;
End;

//////
///  TRoamingBomb
/////

constructor TRoamingBomb.Create;
begin
  inherited create(cx,cy);
  Animation:=CreateAnimation('Enemies\Bomb');
  Animation.speed:=100;
  damage:=1;
  //speed:=4;
  passive:=true;
  Dir:=true;
  //t:=cy/100;
end;

procedure TRoamingBomb.setHP(v: Integer);
begin
  fhp:=fhp-v;
  if fhp<=0 then
    Begin
      isAlive:=false;
      ObjectDies;
    End;
end;

procedure TRoamingBomb.logic;
Begin
 if isAlive then
      if y<Params[1] then
        Begin
          t:=t+0.02;
          y:=y+speed;
          if dir then
            x:=params[0] div 2+Round(sin(t)*params[0]/2)
              else
                x:=params[0] div 2-Round(sin(t)*params[0]/2);
        End
          else isAlive:=false;
End;

end.
