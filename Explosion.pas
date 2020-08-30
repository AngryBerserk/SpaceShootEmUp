unit Explosion;

interface

uses
  Mover, Animation, Graphics;

type
  TExplosion=class(TMover)
    constructor Create(const cx,cy:Integer);override;
    procedure DrawFrame(canvas:TBitmap;const N:Integer=-1);override;
    procedure setHP(v:Integer);override;
  end;

implementation

constructor TExplosion.create;
Begin
  inherited;
  name:='Explosion';
  Animation:=CreateAnimation('Explosion');
  passive:=true;
  if x<>0 then
    Sound('Explosion.wav');
End;

procedure TExplosion.setHP(v: Integer);
begin
  //
end;

procedure TExplosion.DrawFrame(canvas: TBitmap; const N: Integer = -1);
begin
  if Animation.frame=Animation.frameCount then isAlive:=false
   else Inherited

end;

end.
