unit Highscores;

interface

uses
  classes,sysutils, Math;

type
  THighscores=class
      Table:TStringList;
    public
      constructor Create;
      destructor Destroy;override;
      function IsInHighscores(const v: Integer):Boolean;
      procedure addScore(const s:String;const score:Integer);
      function getName(const i:Byte):String;
      function getScore(const i:Byte):String;
      function getHighscore(const i:Byte):String;
  end;

implementation

destructor THighscores.Destroy;
begin
  Table.Destroy;
end;

procedure THighscores.addScore(const s: string;const score: Integer);
 var z:Word;
begin
  if Table.Count>0 then
      for z := 0 to Min(Table.Count-1,10) do
        if StrToInt(Table.ValueFromIndex[z])<score then break;
  Table.Insert(z,s+'='+IntToStr(score));
  Table.SaveToFile('C:\Highscores.dat');
end;

function THighscores.getScore(const i: Byte):String;
begin
  result:=Table.ValueFromIndex[i];
end;

function THighscores.getName(const i: Byte):String;
begin
  result:=Table.Names[i];
end;

function THighscores.getHighscore(const i: Byte):String;
 var n,s:String;c:Byte;
begin
  n:=Table.Names[i];
  s:=Table.ValueFromIndex[i];
  for c := 0 to 24-(Length(n)+Length(s)) do
   n:=n+'.';
  result:=n+s;
end;

function THighScores.IsInHighscores;
 var z:Word;
begin
 result:=false;
 if Table.Count>0 then
 Begin
  for z := 0 to Min(Table.Count-1,10) do
    if StrToInt(Table.ValueFromIndex[z])<v then
      Begin
        result:=true;
        exit
      End;
 End else result:=true;
end;

constructor THighScores.Create;
begin
  Table:=TStringList.Create;
  if fileExists('\\192.168.2.2\Exchange\Chertushkin\HS\Highscores.dat') then
    Table.LoadFromFile('\\192.168.2.2\Exchange\Chertushkin\HS\Highscores.dat');
end;

end.
