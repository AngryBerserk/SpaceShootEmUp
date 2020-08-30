unit UnitFactory;

interface

uses
  Classes, Mover, SimpleEnemy, Hero, Bonus, Projective, GraphicControl, Cannon, Explosion, Bosses;

type
  TFactory=class
    class function Construct(const s:TUnitType; const cx,cy:Integer; onMouseDown:TNotifyEvent):TMover;
    class constructor Create;
    //class destructor Destroy;
  end;

implementation

class constructor TFactory.Create;
 var M:TMover;
begin
  M:=TSimpleEnemy.Create(0,0);
  M.Destroy;
  M:=THero.Create(0,0,nil);
  M.Destroy;
  M:=TBomb.Create(0,0);
  M.Destroy;
  M:=TRoamingBomb.Create(0,0);
  M.Destroy;
  M:=TDebris.Create(0,0);
  M.Destroy;
  M:=TBoss1.Create(0,0,nil);
  M.Destroy;
  M:=TMothership.Create(0,0);
  M.Destroy;
  M:=TSpeedPowerup.Create(0,0);
  M.Destroy;
  M:=TWeaponPowerup.Create(0,0);
  M.Destroy;
  M:=TProjective.Create(0,0);
  M.Destroy;
  M:=TEnemyProjective.Create(0,0);
  M.Destroy;
  M:=TBasicCannon.Create(0,0);
  M.Destroy;
  M:=TEnemyBasicCannon.Create(0,0);
  M.Destroy;
  M:=TExplosion.Create(0,0);
  M.Destroy;
  M:=TGraphButton.Create(0,0);
  M.Destroy;
  M:=TGraphPanel.Create(0,0);
  M.Destroy;
  M:=TGraphText.Create(0,0,'');
  M.Destroy;
  M:=TGraphEditBox.Create(0,0);
  M.Destroy;
  M:=TGraphImage.Create(0,0);
  M.Destroy;
end;

class function TFactory.Construct(const s: TUnitType; const cx,cy:Integer; onMouseDown:TNotifyEvent):TMover;
begin
  //if s='Mover' then result:=TMover.Create else
  if s=uSimpleEnemy then result:=TSimpleEnemy.Create(cx,cy) else
  if s=uBomb then result:=TBomb.Create(cx,cy) else
  if s=uRoamingBomb then result:=TRoamingBomb.Create(cx,cy) else
  if s=uDebris then result:=TDebris.Create(cx,cy) else
  if s=uBoss1 then result:=TBoss1.Create(cx,cy,onMouseDown) else
  if s=uHero then result:=THero.Create(cx,cy,onMouseDown) else
  if s=uMothership then result:=TMothership.Create(cx,cy) else
  if s=uSpeedPowerup then result:=TSpeedPowerup.Create(cx,cy) else
  if s=uWeaponPowerup then result:=TWeaponPowerup.Create(cx,cy) else
  if s=uProjective then result:=TProjective.Create(cx,cy) else
  if s=uEnemyProjective then result:=TEnemyProjective.Create(cx,cy) else
  if s=uBasicGun then result:=TBasicCannon.Create(cx,cy) else
  if s=uEnemyBasicGun then result:=TEnemyBasicCannon.Create(cx,cy) else
  if s=uExplosion then result:=TExplosion.Create(cx,cy) else
  if s=uButton then result:=TGraphButton.Create(cx,cy) else
  if s=uPanel then result:=TGraphPanel.Create(cx,cy) else
  if s=uText then result:=TGraphText.Create(cx,cy,'') else
  if s=uEditBox then result:=TGraphEditBox.Create(cx,cy) else
  if s=uImage then result:=TGraphImage.Create(cx,cy) else
    result:=nil;
  result.onMouseDown:=onMouseDown;
end;

end.
