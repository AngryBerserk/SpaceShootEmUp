unit Background;

interface

uses
  types, classes, Graphics, system.Generics.collections;

const
  stars_num=500;

type
  TStar=class
    x,y:Word;
    Speed:Byte;
    public
      constructor Create(const w,h:Word);
  End;
  TBackground=class (TBitmap)
      Map:TList<TStar>;
    public
      constructor Create(const w,h:Word);reintroduce;
      destructor Destroy;override;
      function tic:TBitmap;
  end;

implementation

destructor TBackground.Destroy;
 var z:Word;
begin
 for z := 0 to stars_num do
  Map[z].Destroy;
 Map.Destroy;
 inherited destroy;
end;

constructor TStar.Create;
begin
  x:=Random(w);
  y:=Random(h);
  speed:=1+Random(3);
end;

constructor TBackground.Create;
 var z:Word;
begin
 inherited create;
 width:=w;
 height:=h;
 canvas.Brush.Color:=clBlack;
 canvas.Pen.Color:=clWhite;
 Map:=TList<TStar>.create;
 for z := 0 to stars_num do
  Map.Add(TStar.Create(width,height))
end;

function TBackground.tic;
 var P:TStar;
begin
 canvas.FillRect(rect(0,0,width,height));
 for P in Map do
  Begin
    canvas.Pixels[P.X,P.y]:=clWhite;
    P.y:=P.Y+P.Speed;
    if P.y>height then P.Y:=0;
  End;
 result:=self;
end;

end.
