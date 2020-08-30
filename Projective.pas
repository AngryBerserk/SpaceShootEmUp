unit Projective;

interface

uses
  Mover;

type
  TProjective=class(TMover)
    public
      property alive:Boolean read falive write setAlive;
      procedure logic(const params:Array of Integer);override;
      procedure setHP(v:Integer);override;
      constructor Create(const cx,cy:Integer);override;
  end;

  TenemyProjective=class(TProjective)
      procedure logic(const params:Array of Integer);override;
  end;

implementation

procedure TProjective.setHP(v: Integer);
begin
  fhp:=fhp-v;
  if fhp<=0 then isAlive:=false
end;

procedure TProjective.logic;
begin
  if y>0 then y:=y-speed else Alive:=false
end;

constructor TProjective.Create;
begin
  inherited create(cx,cy);
  name:='Projective';
  Bonuses.Destroy;
  Bonuses:=nil;
  Animation:=CreateAnimation('Projectives\p1');
  alive:=true;
  speed:=2;
  damage:=1;
end;

procedure TEnemyProjective.logic(const params: array of Integer);
begin
  if y<params[1] then y:=y+speed else Alive:=false
end;

end.
