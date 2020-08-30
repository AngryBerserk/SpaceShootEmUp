unit Cannon;

interface

uses
  Mover, Projective;

type
  TAbstractCannon=class(TSocket)
    private
      Bullets:TUnitType;
    public
      reverse:Boolean;
      constructor Create(const cx,cy:Integer);override;
      destructor Destroy;override;
  end;

  TBasicCannon=class(TAbstractCannon)
    public
      procedure MouseDown(const mx,my:Integer);override;
      procedure logic(const params:Array of Integer);override;
      constructor Create(const cx,cy:Integer);override;
      function getObject:TMover;override;
  end;

  TEnemyBasicCannon=class(TAbstractCannon)
    public
      constructor Create(const cx,cy:Integer);override;
      function getObject:TMover;override;
  end;

implementation

uses
  UnitFactory;

constructor TAbstractCannon.Create;
begin
  inherited;
  name:='cannon';
  visual:=false;
  isjoint:=true;
  px:=1;
  py:=24;
end;

destructor TAbstractCannon.Destroy;
begin
  inherited;
end;

/////////////////

procedure TBasicCannon.MouseDown(const mx: Integer; const my: Integer);
begin
  MousePressed:=true;
end;

constructor TBasicCannon.Create;
begin
  inherited;
  Animation:=CreateAnimation('Cannons\c1');
  bullets:=uProjective;
  visual:=true;
  fscorepoints:=-5;
end;

procedure TBasicCannon.logic(const params: array of Integer);
begin
if MousePressed then
  Begin
    pMousePressed;
    MousePressed:=false;
  End;
end;

function TBasicCannon.getObject:TMover;
begin
  result:=TFactory.Construct(Bullets,x-px,y-py-20,nil);
  result.setHitpoints(hp);
end;

////////////////////

constructor TEnemyBasicCannon.Create;
begin
  inherited;
  Animation:=CreateAnimation('Cannons\c1');
  bullets:=uEnemyProjective;
  visual:=false;
end;

function TEnemyBasicCannon.getObject:TMover;
begin
  result:=TFactory.Construct(Bullets,x-px,y-py+20,nil);
  result.setHitpoints(hp);
end;

end.
