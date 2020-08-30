unit GameLog;

interface

uses
  SysUtils;

type
  TGameLog=class
      class var f:TextFile;
    public
      class procedure writeLog(const s:String);
      class constructor Create;
      class destructor Destroy;
  end;

implementation

class constructor TGameLog.create;
Begin
 AssignFile(f,'game.log');
 Rewrite(f);
End;

class procedure TGameLog.writeLog(const s: string);
begin
 writeln(f,DateToStr(Now)+' :  '+s);
end;

class destructor TGameLog.Destroy;
Begin
  CloseFile(f);
End;

end.
