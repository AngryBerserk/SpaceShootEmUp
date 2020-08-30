unit Alphabet;

interface

uses
  Spritesheet, PNGImage;

type
  TAlphabet=class
    private
      class var height:Word;
      class var width:Word;
      class var sSheet:TSpriteSheet;
      class var letters:Array[1..93]of TPNGImage;
      class function getChar(const c:Char):TPNGImage;
    public
      class constructor Create;
      class destructor Destroy;
      class function getString(const s:String):TPNGImage;
  end;

implementation

class destructor TAlphabet.Destroy;
 var z:Word;
begin
  for z := 1 to 93 do
   letters[z].Destroy;
  sSheet.Destroy;
end;

class constructor TAlphabet.Create;
 var z:Word;

  function getWidth(x:Word):Word;
  Begin
    result:=(x-1)*width+1
  End;

  function getHeight(y:Word):Word;
  Begin
    result:=(y-1)*height+1
  End;

Begin
  height:=15;
  width:=15;
  sSheet:=TSpritesheet.create('Alphabet.png');
  for z := 1 to 26 do
    Begin
      letters[z]:=sSheet.getSprite((z-1)*17+1,1,width,height)
    End;
  for z := 1 to 26 do
    Begin
      letters[26+z]:=sSheet.getSprite((z-1)*17+1,17,width,height)
    End;
  for z := 1 to 10 do
    Begin
      letters[52+z]:=sSheet.getSprite((z-1)*17+1,17*2-1,width,height)
    End;
  for z := 1 to 31 do
    Begin
      letters[62+z]:=sSheet.getSprite((z-1)*17+1,17*3-2,width,height)
    End;
End;

class function TAlphabet.getChar;
begin
 if (c>='A') and (c<='Z') then result:=letters[(ord(c)-ord('A'))+1] else
 if (c>='a') and (c<='z') then result:=letters[26+(ord(c)-ord('a'))+1] else
 if (c>='0') and (c<='9') then result:=letters[52+(ord(c)-ord('0'))+1] else
 case c of
   '[':result:=letters[63];
   ']':result:=letters[64];
   '|':result:=letters[65];
   '\':result:=letters[66];
   ':':result:=letters[67];
   ';':result:=letters[68];
   '"':result:=letters[69];
   '''':result:=letters[70];
   '<':result:=letters[71];
   '>':result:=letters[72];
   ',':result:=letters[73];
   '.':result:=letters[74];
   '?':result:=letters[75];
   '/':result:=letters[76];
   '~':result:=letters[77];
   '!':result:=letters[78];
   '@':result:=letters[79];
   '#':result:=letters[80];
   '$':result:=letters[81];
   '%':result:=letters[82];
   '^':result:=letters[83];
   '&':result:=letters[84];
   '*':result:=letters[85];
   '(':result:=letters[86];
   ')':result:=letters[87];
   '_':result:=letters[88];
   '-':result:=letters[89];
   '+':result:=letters[90];
   '=':result:=letters[91];
   '{':result:=letters[92];
   '}':result:=letters[93];
    else result:=nil;
 end;
end;

class function TAlphabet.getString;
 var z:Word;
Begin
  result:=TPNGImage.CreateBlank(COLOR_RGB, 8, width*length(s), height);
  result.Transparent:=true;
  result.TransparentColor:=0;
  for z := 1 to Length(s) do
   Begin
    result.Canvas.Draw((z-1)*width,0,getChar(s[z]));
   End;
End;

end.
