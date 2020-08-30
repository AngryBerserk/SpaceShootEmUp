unit GraphicControl;

interface

uses
  PNGImage,Mover, Alphabet, graphics;

type
  TAbstractGraphControl=class(TMover)
    private
      ftext:String;
      procedure setText(const s:String);virtual;
    public
      visible:Boolean;
      property text:String read ftext write setText;
      function hitTest(const x1,y1,w,h:Integer):Boolean;override;
      procedure MouseDown(const mx,my:Integer);override;
      constructor Create(const cx,cy:Integer);override;
      destructor Destroy;override;
      procedure logic(const params:Array of Integer);override;
  end;
  TGraphButton=class(TAbstractGraphControl)
    public
      constructor Create(const cx,cy:Integer);override;
  end;
  TGraphPanel=class(TAbstractGraphControl)
    public
      constructor Create(const cx,cy:Integer);override;
  end;
  TGraphText=class(TAbstractGraphControl)
      procedure setText(const s:String);override;
      function getHeight:Word;override;
      function getWidth:Word;override;
      constructor Create(const cx,cy:Integer;const s:String);reintroduce;
      procedure DrawFrame(canvas:TBitmap;const N:Integer=-1);override;
      function hitTest(const x1,y1,w,h:Integer):Boolean;override;
  end;
  TGraphEditBox=class(TAbstractGraphControl)
    public
      textField:TGraphText;
      align:(aleft,acenter, aright);
      procedure DrawFrame(canvas:TBitmap;const N:Integer=-1);override;
      constructor Create(const cx,cy:Integer);override;
      destructor Destroy;override;
  end;
  TGraphImage=class(TAbstractGraphControl)
      procedure DrawFrame(canvas:TBitmap;const N:Integer=-1);override;
      procedure SetImage(const s:String);
      destructor Destroy;override;
  end;

implementation

function TAbstractGraphControl.hitTest(const x1,y1,w,h:Integer):Boolean;
 var o1x,o2x,o1y,o2y,o1w,o2w,o1h,o2h:Integer;
begin
  o1x:=x1;
  o2x:=x;
  o1y:=y1;
  o2y:=y;
  o1w:=w;
  o2w:=width;
  o1h:=h;
  o2h:=height;
  o1x:=o1x+o1w div 2;
  o2x:=o2x+o2w div 2;
  o1y:=o1y+o1h div 2;
  o2y:=o2y+o2h div 2;
  o1w:=o1w div 2 + o2w div 2;
  o1h:=o1h div 2 + o2h div 2;
  if (abs(o1x-o2x)<o1w)and(abs(o1y-o2y)<o1h) then result:=true
    else result:=false
end;

procedure TAbstractGraphControl.setText(const s: string);
begin
  ftext:=s;
end;

procedure TAbstractGraphControl.mouseDown;
begin
  Mousepressed:=true;
end;

procedure TAbstractGraphControl.logic;
begin
  //pressed:=false;
end;

destructor TAbstractGraphControl.Destroy;
begin
 inherited
end;

constructor TAbstractGraphControl.Create;
begin
 inherited
end;

constructor TGraphButton.Create;
begin
 inherited;
 Animation:=CreateAnimation('GUI\OK');
 isAlive:=false;
end;

//
//TGraphPanel
//

constructor TGraphPanel.Create;
begin
  inherited;
  Animation:=CreateAnimation('GUI\Panel');
end;

//
//TGraphText
//

procedure TGraphText.setText(const s:String);
 var P:TPNGImage;
Begin
 inherited;
 P:=TAlphabet.getString(text);
 fwidth:=P.Width;
 fheight:=P.Height;
 P.Destroy;
End;

function TGraphText.getHeight;
begin
  result:=fheight;
end;

function TGraphText.getWidth;
begin
  result:=fwidth;
end;

constructor TGraphText.Create;
Begin
 inherited Create(cx,cy);
 text:=s;
End;

procedure TGraphText.DrawFrame(canvas: TBitmap;const N:Integer=-1);
 var P:TPNGImage;
begin
  P:=TAlphabet.getString(text);
  canvas.Canvas.Draw(x,y,P);
  P.Destroy;
end;

function TGraphText.hitTest(const x1,y1,w,h:Integer):Boolean;
 var o1x,o1y:Integer;
begin
  o1x:=x1-width div 2;
  //o2x:=o2x-o2w div 2;
  o1y:=y1-height div 2;
  //o2y:=o2y-o2h div 2;
  if (o1x>=x)and(o1x<=x+width)and(o1y>=y)and(o1y<=y+height) then result:=true
    else result:=false
End;

//
//TGraphEditBox
//

constructor TGraphEditBox.Create;
begin
  inherited;
  align:=acenter;
  Animation:=CreateAnimation('GUI\EditBox');
  textField:=TGraphText.Create(cx,cy,text);
end;

procedure TGraphEditBox.DrawFrame(canvas:TBitmap;const N:Integer=-1);
 var P:TPNGImage;
begin
  inherited;
  P:=TAlphabet.getString(text);
  if align = aleft then
   Begin
    textField.x:=x+7;
    textField.y:=y-height div 2+7;
   End else
         if align = aright then
           Begin
            textField.x:=x+width-P.width-7;
            textField.y:=y-height div 2+7;
           End
            else
               Begin
                textField.x:=x+width div 2-P.Width div 2;
                textField.y:=y-height div 2+7;
               End;
  canvas.Canvas.Draw(textField.x-width div 2,textField.y,P);
  P.Destroy;
End;

destructor TGraphEditBox.Destroy;
begin
 textField.Destroy;
 inherited Destroy
end;

//
//TGraphImage
//

procedure TGraphImage.SetImage(const s: string);
begin
  Animation:=CreateAnimation(s);
end;

procedure TGraphImage.DrawFrame(canvas:TBitmap;const N:Integer=-1);
begin
 if Animation<>nil then inherited
end;

destructor TGraphImage.Destroy;
begin
  inherited;
end;

end.
