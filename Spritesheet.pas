unit Spritesheet;

interface

uses
  PNGImage,classes, types, windows;

type
  TSpritesheet=class(TPNGImage)
    public
      constructor create(const s:String);reintroduce;
      function getSprite(const x,y,w,h:Word):TPNGImage;
  end;

implementation

constructor TSpritesheet.create(const s: string);
begin
  inherited create;
  LoadFromFile('RES\Images\'+s);
end;

function TSpriteSheet.getSprite(const x,y,w,h:Word): TPNGImage;
Var
  i: integer;
Begin
  Result := TPNGImage.CreateBlank(COLOR_RGBALPHA, 8, w, h);
  BitBlt(Result.Canvas.Handle, 0, 0, w, h, Self.Canvas.Handle, x, y, SRCCOPY);
  For i := 0 to h-1 do
    CopyMemory(Result.AlphaScanline[i], pByte(dword(self.AlphaScanline[i+y])+x), w);
End;

end.
