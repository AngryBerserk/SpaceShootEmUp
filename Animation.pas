unit Animation;

interface

uses
  windows, classes, sysutils, system.generics.collections,PNGImage, dateutils, GameLog;

type
  Tsprite = class
    name:String;
    image:TPNGImage;
    constructor Create(s:String);
    destructor Destroy;override;
  end;

  TLoopStatus=(lsStart,lsEnd,lsNone);

  TAnimFrame=class
      image:TSprite;
      Loop:TLoopStatus;
      width,
      height:Integer;
     public
      constructor Create(const s:String;const L:TLoopStatus);
  end;

  TTimeLineAnimation=class
    private
      FrameToGo:Integer;
      loopStart:Integer;
      lastTime:TTime;
      fframe:word;
      Fspeed:Word;
      Fwidth:Word;
      Fheight:Word;
      Frames:TList<TAnimFrame>;
      class var ResManager:TList<TSprite>;
      class function AddImageToResManager(const s:String):TSprite;
      procedure setFrame(v:Word);
      function getFrameCount:Word;
      class constructor Create;
      class destructor Destroy;
    public
      Animations:TList<Word>;
      property frameCount:Word read getFrameCount;
      property speed:Word read fspeed write fspeed;
      property frame:word read fframe write setFrame;
      property width:word read Fwidth write Fwidth;
      property height:word read Fheight write Fheight;
      function getFrame(const N:integer=-1):TSprite;
      procedure goToFrame(const N:Word);
      constructor Create(const filename:String);
      destructor Destroy;override;
  end;

implementation

function TTimeLineAnimation.getFrameCount:Word;
begin
  result:=Frames.Count-1;
end;

procedure TTimeLineAnimation.goToFrame(const N: Word);
begin
  FrameToGo:=N;
end;

function TTimeLineAnimation.getFrame(const N:integer=-1):TSprite;
begin
  result:=nil;
  if Frames.Count>0 then
   Begin
    if N=-1 then result:=Frames[frame].image else result:=Frames[N].image;
    if (now-lastTime)>fSpeed/100000000 then
      Begin
         //TGameLog.writeLog(IntToStr(frame)+':   :'+IntToStr(loopStart));
         if Frames[frame].Loop=lsStart then LoopStart:=frame;
         if frameToGo>-1 then
           Begin
              if frameToGo>frame then frame:=frame+1
                else if frameToGo<frame then frame:=frame-1
                  else frameToGo:=-1;
           End
            else
              Begin
                if Frames[frame].Loop=lsEnd then frame:=loopStart
                  else frame:=frame+1
              End;
         lastTime:=now;
      End;
   End;
end;

procedure TTimeLineAnimation.setFrame(v: Word);
begin
  if Frames.Count>1 then
    if fframe=Frames.Count then fframe:=0
          else
            fframe:=v;
end;

constructor TAnimFrame.Create(const s: string; const L: TLoopStatus);
begin
  Image:=TTimeLineAnimation.AddImageToResManager(s);
  Width:=Image.image.Width;
  Height:=Image.image.Height;
  Loop:=L;
end;

class function TTimeLineAnimation.AddImageToResManager;
 var z:Word;
begin
 if ResManager=nil then
  ResManager:=TList<TSprite>.create;
 //look for an instance
 if ResManager.Count>0 then
   Begin
     for z := 0 to ResManager.Count-1 do
      if ResManager[z].name=s then
        Begin
          result:=ResManager[z];
          Exit;
        End;
   End;
 ResManager.add(TSprite.Create(s));
 result:=ResManager[ResManager.Count-1];
end;

constructor TTimeLineAnimation.Create(const filename: string);
 var L:TStringList;z:Word;Loop:TLoopStatus;
begin
 loopStart:=-1;
 Loop:=lsNone;
 Frames:=TList<TAnimFrame>.create;
 Animations:=TList<Word>.create;
 L:=TStringList.Create;
 L.LoadFromFile('RES\Images\'+filename+'\Animation.dat');
 for z:= 0 to L.Count-1 do
  Begin
    if L[z]<>'' then
     Begin
      if L.Names[z]='s' then Loop:=lsStart
        else
          if L.Names[z]='e' then Loop:=lsEnd
            else
              if L.Names[z]='f' then Loop:=lsNone
                else
                  Begin
                    if L.Names[z]='a' then Animations.Add(StrToInt(L.ValueFromIndex[z]));
                    continue
                  End;
      Frames.Add(TAnimFrame.Create(filename+'\'+L.ValueFromIndex[z],Loop));
     End;
  End;
 L.Destroy;
 fSpeed:=100;
 fframe:=0;
 width:=Frames[0].width;
 height:=Frames[0].height;
end;

destructor TTimeLineAnimation.Destroy;
 var F:TAnimFrame;
begin
 for F in Frames do
   F.Destroy;
 Frames.Destroy;
 Animations.Destroy;
end;

class constructor TTimeLineAnimation.create;
Begin
  ResManager:=TList<TSprite>.create;
End;

class destructor TTimeLineAnimation.Destroy;
 var T:TSprite;
begin
 For T in ResManager do
  T.Destroy;
 ResManager.Destroy;
end;

////////////////////////////////////////////////

constructor Tsprite.create(s: string);
begin
   name:=s;
   if s<>'' then
    Begin
      image:=TPNGImage.create;
      image.LoadFromFile('RES\Images\'+s);
    End;
end;

destructor TSprite.Destroy;
begin
  image.Destroy;
end;

end.
