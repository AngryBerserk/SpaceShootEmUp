unit BackBuffer;

interface

uses classes,Graphics;

type TBackBuffer=class(TBitmap)
  public
    B:TBitmap;
    constructor Create(const x,y:Word);reintroduce;
    destructor Destroy;override;
    procedure paint(const x,y:Integer;const scale:Real;const G:TGraphic=nil);
    function GetCanvas:TGraphic;
    procedure SetColor(const c:TColor);
    procedure Clear;
  private
    procedure paintRect(const x,y:Integer;const scale:Real);
end;

implementation

destructor TBackBuffer.Destroy;
begin
  B.Destroy;
  inherited destroy;
end;

procedure TBackBuffer.Clear;
begin
 Canvas.Brush.Color:=clBlack;
 Canvas.FillRect(rect(0,0,width,height));
end;

procedure TBackBuffer.SetColor(const c: TColor);
begin
  canvas.Pen.Color:=c;
  canvas.Brush.Color:=c;
end;

function TBackBuffer.GetCanvas:TGraphic;
begin
 B.Canvas.Draw(0,0,self);
 result:=B;
 Clear
end;

procedure TBackBuffer.paint;
begin
 if G=nil then
  paintRect(x,y,scale)
    else
        Canvas.Draw(x,y,G);
end;

procedure TBackBuffer.paintRect;
begin
 Canvas.Rectangle(round((x-1)*scale),Round((y-1)*scale),Round(x*scale),Round(y*scale));
end;

constructor TBackBuffer.Create(const x: Word;const y: Word);
begin
  inherited create();
  width:=x;
  height:=y;
  B:=TBitmap.Create;
  B.Width:=x;
  B.Height:=y;
end;

end.
