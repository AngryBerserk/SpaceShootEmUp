unit Layout;

interface

uses
  system.SysUtils, Mover,system.Generics.collections, controls,
  Graphics, Backbuffer, windows, UnitFactory,
  GraphicControl, Highscores, SoundPlayer, Bonus;

type
  TLayoutType=(lGame, lEnterName, lGUI, lHighscores, lMainMenu, lOptions, lPause, lBriefing, lDebriefing);
  TLayout=class
    public
      disable:Boolean;
      Objects:TList<TMover>;
      class var width:Integer;
      class var height:Integer;
      class var score:Real;
      class var isGameOver:Boolean;
      class var isPause:Boolean;
      class var isOptions:Boolean;
      class var isResume:Boolean;
      class var isQuit:Boolean;
      class var isNewGame:Boolean;
      class var isMute:Boolean;
      class var isStartLevel:Boolean;
      class var isShowBriefing:Boolean;
      class var isShowDebriefing:Boolean;
      class var isShowHighscores:Boolean;
      class var isGameReset:Boolean;
      class var Highscore:THighscores;
      class var LevelNumber:Word;
      procedure onShow;virtual;
      procedure onMouseDown(Sender:TObject);virtual;
      procedure Tic(const params:Array of Integer);virtual;
      procedure Render(Surface:TBackBuffer);virtual;
      procedure MouseMoved(const x,y:Integer);virtual;
      procedure KeyDown(const Key:Word);virtual;
      procedure KeyPress(const Key:char);virtual;
      procedure MouseDown(const x,y:Integer;const Button:TMouseButton);virtual;
      destructor Destroy;override;
      class constructor Create;
      class destructor Destroy;
      constructor Create;virtual;
  end;

  TEnterNameLayout=class(TLayout)
      activeEditBox:TGraphEditBox;
      procedure Tic(const params:Array of Integer);override;
      procedure MouseDown(const x,y:Integer;const Button:TMouseButton);override;
      procedure KeyDown(const key:Word);override;
      procedure KeyPress(const key:char);override;
      constructor Create;override;
  end;

  TGUILayout=class(TLayout)
      procedure Tic(const params:Array of Integer);override;
      procedure Render(Surface:TBackBuffer);override;
      constructor Create;override;
  end;

  THighscoresLayout=class(TLayout)
      procedure Tic(const params:Array of Integer);override;
      constructor Create;override;
  end;

  TMainMenuLayout=class(TLayout)
      procedure Tic(const params:Array of Integer);override;
      procedure onShow;override;
      constructor Create;override;
  end;

  TOptionsLayout=class(TLayout)
      procedure Tic(const params:Array of Integer);override;
      procedure ToggleYN(T:TAbstractGraphControl);
      procedure onShow;override;
      constructor Create;override;
  end;

  TPauseLayout=class(TLayout)
      procedure Tic(const params:Array of Integer);override;
      procedure ToggleYN(T:TAbstractGraphControl);
      procedure KeyDown(const Key:Word);override;
      procedure onShow;override;
      constructor Create;override;
  end;

  TBriefingLayout=class(TLayout)
      procedure Tic(const params:Array of Integer);override;
      constructor Create;override;
  end;

  TDeBriefingLayout=class(TLayout)
      procedure Tic(const params:Array of Integer);override;
      constructor Create;override;
  end;

  TLayoutConstructor=class
      class function Construct(const n:TLayoutType):TLayout;
    strict private
      class function ConstructGameLevel:TLayout;
      class function ConstructBriefing:TLayout;
      class function ConstructDebriefing:TLayout;
  end;

implementation

uses
  GameLayouts;

class constructor TLayout.create;
Begin
  Highscore:=THighscores.create;
  LevelNumber:=1;
End;

class destructor TLayout.Destroy;
Begin
  Highscore.Destroy;
End;

procedure TLayout.onShow;
begin
  //
end;

procedure TLayout.MouseDown(const x,y:Integer;const Button:TMouseButton);
  var T:TMover;
begin
  for T in Objects do
    if T.hitTest(x+T.width div 2,y+T.height div 2,1,1) then
      (T as TAbstractGraphControl).mouseDown(x,y);
end;

procedure TLayout.MouseMoved(const x: Integer; const y: Integer);
begin
  //
end;

procedure TLayout.KeyDown(const key:Word);
begin
  //
end;

procedure TLayout.KeyPress(const key:char);
begin
  //
end;

procedure TLayout.Tic(const params:Array of Integer);
begin
  //
end;

constructor TLayout.Create;
begin
  Objects:=TList<TMover>.Create;
end;

destructor TLayout.Destroy;
 var T:TMover;
begin
 if Objects.Count>0 then
  for T in Objects do
    T.Destroy;
  Objects.Destroy;
  inherited Destroy
end;

procedure TLayout.Render(Surface:TBackBuffer);
 var T:TMover;
Begin
 for T in Objects do
     if (T.x+T.width>0)and(T.x<width)and(T.y+T.height>0)and(T.y-T.height<height) then
      T.DrawFrame(surface);
End;

procedure TLayout.onMouseDown(Sender: TObject);
begin

end;

///
// tEnterNameLayout
///

procedure TEnterNameLayout.MouseDown(const x,y:Integer;const Button:TMouseButton);
 var z:Word;
begin
 for z := Objects.Count-1 Downto 0 do
   if Objects[z].hitTest(x+Objects[z].width div 2,y+Objects[z].height div 2,1,1) then
      Begin
        if Objects[z].ClassName='TGraphEditBox' then
            activeEditBox:=Objects[z] as TGraphEditBox;
        (Objects[z] as TAbstractGraphControl).mouseDown(x,y);
      End;
end;

procedure TEnterNameLayout.KeyDown(const key: Word);
 var s:String;
begin
  if key=VK_RETURN then
    Begin
      Highscore.addScore(ActiveEditBox.Text,Round(score));
      isGameOver:=true;
    End;
  if key=VK_BACK then
    Begin
      s:=activeEditBox.Text;
      Delete(s,Length(activeEditBox.Text),1);
      activeEditBox.Text:=s;
    End;
end;

procedure TEnterNameLayout.KeyPress(const key: char);
begin
  if (ord(key)>31) and (ord(key)<127) and (key<>'=') then
    if length(activeEditBox.Text)<12 then
      activeEditBox.Text:=activeEditBox.Text+key;
end;

constructor TEnterNameLayout.Create;
begin
   inherited;
   Objects.Add(TFactory.construct(uPanel,width div 2,height div 2, onMouseDown));
   Objects.Add(TFactory.construct(uEditBox,width div 2-40,height div 2+20, onMouseDown));
   (Objects[1] as TGraphEditBox).text:='Dude';
   activeEditBox:=(Objects[1] as TGraphEditBox);
   Objects.Add(TFactory.construct(uButton,width div 2+100,height div 2+20, onMouseDown));
   Objects.Add(TFactory.construct(uText,width div 2-120,height div 2-38, onMouseDown));
   (Objects[3] as TAbstractGraphControl).text:='Congratulations!';
   Objects.Add(TFactory.construct(uText,width div 2-114,height div 2-16, onMouseDown));
   (Objects[4] as TAbstractGraphControl).text:='Enter your name';
end;

procedure TEnterNameLayout.tic;
 var T:TMover;
Begin
 for T in Objects do
  T.logic([]);
 (Objects[Objects.IndexOf(activeEditBox)] as TGraphEditBox).textField.text:=(Objects[Objects.IndexOf(activeEditBox)] as TAbstractGraphControl).text;
 if (Objects[2]as TAbstractGraphControl).MousePressed then
    Begin
      Highscore.addScore(ActiveEditBox.Text,Round(score));
      isGameOver:=True;
      (Objects[2]as TAbstractGraphControl).MousePressed:=false;
    End;
End;

///
// tGUILayout
///

constructor TGUILayout.Create;
begin
   inherited;
   Objects.Add(TFactory.construct(uText,5,5, onMouseDown));
   (Objects[0] as TAbstractGraphControl).text:='SCORE: 0';
   //add bonuses
   Objects.Add(TFactory.construct(uSpeedPowerup,20,700, onMouseDown));
   (Objects[1] as TMover).isGUI:=true;
   Objects.Add(TFactory.construct(uWeaponPowerup,20,740, onMouseDown));
   (Objects[2] as TMover).isGUI:=true;
   Objects.Add(TFactory.construct(uImage,20,40, onMouseDown));
   (Objects[3] as TGraphImage).SetImage('Heart');
   Objects.Add(TFactory.construct(uText,33,32, onMouseDown));
   (Objects[4] as TAbstractGraphControl).text:=':3';
end;

procedure TGUILayout.Render;
  var dy:Integer;
Begin
  dy:=740;
  Objects[0].DrawFrame(surface);
  if (Objects[1] as TSpeedPowerup).duration>0 then
    Begin
      Objects[1].y:=dy;
      dy:=dy-40;
      Objects[1].DrawFrame(surface,1);
    End;
  if (Objects[2] as TWeaponPowerup).power>0 then
    Begin
      Objects[2].y:=dy;
      Objects[2].DrawFrame(surface,1);
    End;
  Objects[3].DrawFrame(surface);
  Objects[4].DrawFrame(surface);
End;

procedure TGUILayout.Tic(const params: array of Integer);
 var T:TMover;
begin
  (Objects[0] as TGraphText).text:='SCORE: '+IntToStr(Round(score));
  (Objects[4] as TGraphText).text:=': '+IntToStr(TGameLayout.HP-1);
  for T in Objects do
    T.logic([]);
end;

///
// tHighscoresLayout
///

constructor THighscoresLayout.Create;
 var z:Word;
begin
   inherited;
   Objects.Add(TFactory.construct(uText,width div 2-90,40, onMouseDown));
   (Objects[0]as TAbstractGraphControl).text:='HIGHSCORES';
   for z := 0 to 9 do
    Begin
      Objects.Add(TFactory.construct(uText,width div 2-190,150+z*30, onMouseDown));
      (Objects[z+1]as TAbstractGraphControl).text:=Highscore.getHighscore(z);
    End;
   Objects.Add(TFactory.construct(uButton,width div 2,700, onMouseDown));
end;

procedure THighscoresLayout.Tic(const params:Array of Integer);
begin
 if (Objects[Objects.Count-1] as TAbstractGraphControl).MousePressed then
  Begin
    isGameReset:=true;
    (Objects[Objects.Count-1] as TAbstractGraphControl).MousePressed:=false;
  End;
end;

///
// tMainMenuLayout
///

constructor TMainMenuLayout.Create;
begin
   inherited;
   Objects.Add(TFactory.construct(uImage,width div 2,100, onMouseDown));
   (Objects[0] as TGraphImage).SetImage('GUI\logo');
   Objects.Add(TFactory.construct(uText,width div 2-70,200, onMouseDown));
   (Objects[1] as TAbstractGraphControl).text:='NEW GAME';
   Objects.Add(TFactory.construct(uText,width div 2-70,240, onMouseDown));
   (Objects[2] as TAbstractGraphControl).text:='OPTIONS';
   Objects.Add(TFactory.construct(uText,width div 2-70,280, onMouseDown));
   (Objects[3] as TAbstractGraphControl).text:='HIGHSCORES';
   Objects.Add(TFactory.construct(uText,width div 2-70,320, onMouseDown));
   (Objects[4] as TAbstractGraphControl).text:='QUIT';
end;

procedure TMainMenuLayout.onShow;
begin
 Score:=0;
 inherited;
end;

procedure TMainMenuLayout.Tic(const params:Array of Integer);
begin
  if (Objects[1] as TAbstractGraphControl).MousePressed then
  Begin
    isShowBriefing:=true;
    (Objects[1] as TAbstractGraphControl).MousePressed:=false;
  End else
    if (Objects[2] as TAbstractGraphControl).MousePressed then
    Begin
      isOptions:=true;
      (Objects[2] as TAbstractGraphControl).MousePressed:=false;
    End else
        if (Objects[3] as TAbstractGraphControl).MousePressed then
        Begin
          isGameOver:=true;
          (Objects[3] as TAbstractGraphControl).MousePressed:=false;
        End else
            if (Objects[4] as TAbstractGraphControl).MousePressed then
            Begin
              isQuit:=true;
              (Objects[4] as TAbstractGraphControl).MousePressed:=false;
            End;
end;

///
// tOptionsLayout
///

constructor TOptionsLayout.Create;
begin
   inherited;
   Objects.Add(TFactory.construct(uText,width div 2-60,40, onMouseDown));
   (Objects[0] as TAbstractGraphControl).text:='OPTIONS';
   //sound on
   Objects.Add(TFactory.construct(uText,width div 2-80,240, onMouseDown));
   (Objects[1] as TAbstractGraphControl).text:='Sound:';
   Objects.Add(TFactory.construct(uText,width div 2+40,240, onMouseDown));
   //music on
   Objects.Add(TFactory.construct(uText,width div 2-80,320, onMouseDown));
   (Objects[3] as TAbstractGraphControl).text:='Music:';
   Objects.Add(TFactory.construct(uText,width div 2+40,320, onMouseDown));
   //back
   Objects.Add(TFactory.construct(uText,width div 2-40,600, onMouseDown));
   (Objects[5] as TAbstractGraphControl).text:='BACK';
   //sound volume
   Objects.Add(TFactory.construct(uText,width div 2-120,280, onMouseDown));
   (Objects[6] as TAbstractGraphControl).text:='Sound volume:';
   Objects.Add(TFactory.construct(uText,width div 2+80,280, onMouseDown));
   //music volume
   Objects.Add(TFactory.construct(uText,width div 2-120,360, onMouseDown));
   (Objects[8] as TAbstractGraphControl).text:='Music volume:';
   Objects.Add(TFactory.construct(uText,width div 2+80,360, onMouseDown));
end;

procedure TOptionsLayout.ToggleYN(T:TAbstractGraphControl);
Begin
  if T.text='On' then T.text:='Off' else T.text:='On';

End;

procedure TOptionsLayout.Tic(const params: array of Integer);
begin
  //mute sound
  if (Objects[1] as TAbstractGraphControl).MousePressed then
  Begin
    TSoundPlayer.Mute(Sound);
    ToggleYN(Objects[2] as TAbstractGraphControl);
    (Objects[1] as TAbstractGraphControl).MousePressed:=false;
  End;
  if (Objects[2] as TAbstractGraphControl).MousePressed then
  Begin
    TSoundPlayer.Mute(Sound);
    ToggleYN(Objects[2] as TAbstractGraphControl);
    (Objects[2] as TAbstractGraphControl).MousePressed:=false;
  End;
  //mute music
  if (Objects[3] as TAbstractGraphControl).MousePressed then
  Begin
    TSoundPlayer.Mute(Music);
    ToggleYN(Objects[4] as TAbstractGraphControl);
    (Objects[3] as TAbstractGraphControl).MousePressed:=false;
  End;
  if (Objects[4] as TAbstractGraphControl).MousePressed then
  Begin
    TSoundPlayer.Mute(Music);
    ToggleYN(Objects[4] as TAbstractGraphControl);
    (Objects[4] as TAbstractGraphControl).MousePressed:=false;
  End;
  if (Objects[5] as TAbstractGraphControl).MousePressed then
  //exit menu
  Begin
    isGameReset:=true;
    (Objects[5] as TAbstractGraphControl).MousePressed:=false;
  End;
  //volume music
  if (Objects[8] as TAbstractGraphControl).MousePressed then
  Begin
    TSoundPlayer.VolumeUP(Music);
    (Objects[9] as TAbstractGraphControl).text:=IntToStr(TSoundPlayer.MusicVolume)+'%';
    (Objects[8] as TAbstractGraphControl).MousePressed:=false;
  End;
  if (Objects[9] as TAbstractGraphControl).MousePressed then
  Begin
    TSoundPlayer.VolumeUP(Music);
    (Objects[9] as TAbstractGraphControl).text:=IntToStr(TSoundPlayer.MusicVolume)+'%';
    (Objects[9] as TAbstractGraphControl).MousePressed:=false;
  End;
  //volume sound
  if (Objects[6] as TAbstractGraphControl).MousePressed then
  Begin
    TSoundPlayer.VolumeUP(Sound);
    (Objects[7] as TAbstractGraphControl).text:=IntToStr(TSoundPlayer.SoundVolume)+'%';
    (Objects[6] as TAbstractGraphControl).MousePressed:=false;
  End;
  if (Objects[7] as TAbstractGraphControl).MousePressed then
  Begin
    TSoundPlayer.VolumeUP(Sound);
    (Objects[7] as TAbstractGraphControl).text:=IntToStr(TSoundPlayer.SoundVolume)+'%';
    (Objects[7] as TAbstractGraphControl).MousePressed:=false;
  End;
end;

procedure TOptionsLayout.onShow;
Begin
  if TSoundPlayer.isMuteSound then
    (Objects[2] as TAbstractGraphControl).text:='Off'
      else
        (Objects[2] as TAbstractGraphControl).text:='On';
  if TSoundPlayer.isMuteMusic then
    (Objects[4] as TAbstractGraphControl).text:='Off'
      else
        (Objects[4] as TAbstractGraphControl).text:='On';
  (Objects[7] as TAbstractGraphControl).text:=IntToStr(TSoundPlayer.SoundVolume)+'%';
  (Objects[9] as TAbstractGraphControl).text:=IntToStr(TSoundPlayer.MusicVolume)+'%';
End;

///
// tPauseLayout
///

constructor TPauseLayout.Create;
begin
   inherited;
   Objects.Add(TFactory.construct(uText,width div 2-40,40, onMouseDown));
   (Objects[0] as TAbstractGraphControl).text:='PAUSED';
   //sound on
   Objects.Add(TFactory.construct(uText,width div 2-80,240, onMouseDown));
   (Objects[1] as TAbstractGraphControl).text:='Sound:';
   Objects.Add(TFactory.construct(uText,width div 2+40,240, onMouseDown));
   //music on
   Objects.Add(TFactory.construct(uText,width div 2-80,320, onMouseDown));
   (Objects[3] as TAbstractGraphControl).text:='Music:';
   Objects.Add(TFactory.construct(uText,width div 2+40,320, onMouseDown));
   //back
   Objects.Add(TFactory.construct(uText,width div 2-60,600, onMouseDown));
   (Objects[5] as TAbstractGraphControl).text:='CONTINUE';
   //sound volume
   Objects.Add(TFactory.construct(uText,width div 2-120,280, onMouseDown));
   (Objects[6] as TAbstractGraphControl).text:='Sound volume:';
   Objects.Add(TFactory.construct(uText,width div 2+80,280, onMouseDown));
   //music volume
   Objects.Add(TFactory.construct(uText,width div 2-120,360, onMouseDown));
   (Objects[8] as TAbstractGraphControl).text:='Music volume:';
   Objects.Add(TFactory.construct(uText,width div 2+80,360, onMouseDown));
   //back
   Objects.Add(TFactory.construct(uText,width div 2-90,660, onMouseDown));
   (Objects[10] as TAbstractGraphControl).text:='Exit to menu';
end;

procedure TPauseLayout.ToggleYN(T:TAbstractGraphControl);
Begin
  if T.text='On' then T.text:='Off' else T.text:='On';

End;

procedure TPauseLayout.Tic(const params: array of Integer);
begin
  //mute sound
  if (Objects[1] as TAbstractGraphControl).MousePressed then
  Begin
    TSoundPlayer.Mute(Sound);
    ToggleYN(Objects[2] as TAbstractGraphControl);
    (Objects[1] as TAbstractGraphControl).MousePressed:=false;
  End;
  if (Objects[2] as TAbstractGraphControl).MousePressed then
  Begin
    TSoundPlayer.Mute(Sound);
    ToggleYN(Objects[2] as TAbstractGraphControl);
    (Objects[2] as TAbstractGraphControl).MousePressed:=false;
  End;
  //mute music
  if (Objects[3] as TAbstractGraphControl).MousePressed then
  Begin
    TSoundPlayer.Mute(Music);
    ToggleYN(Objects[4] as TAbstractGraphControl);
    (Objects[3] as TAbstractGraphControl).MousePressed:=false;
  End;
  if (Objects[4] as TAbstractGraphControl).MousePressed then
  Begin
    TSoundPlayer.Mute(Music);
    ToggleYN(Objects[4] as TAbstractGraphControl);
    (Objects[4] as TAbstractGraphControl).MousePressed:=false;
  End;
  //quit to title
  if (Objects[5] as TAbstractGraphControl).MousePressed then
  Begin
    isResume:=true;
    (Objects[5] as TAbstractGraphControl).MousePressed:=false;
  End;
  //volume music
  if (Objects[8] as TAbstractGraphControl).MousePressed then
  Begin
    TSoundPlayer.VolumeUP(Music);
    (Objects[9] as TAbstractGraphControl).text:=IntToStr(TSoundPlayer.MusicVolume)+'%';
    (Objects[8] as TAbstractGraphControl).MousePressed:=false;
  End;
  if (Objects[9] as TAbstractGraphControl).MousePressed then
  Begin
    TSoundPlayer.VolumeUP(Music);
    (Objects[9] as TAbstractGraphControl).text:=IntToStr(TSoundPlayer.MusicVolume)+'%';
    (Objects[9] as TAbstractGraphControl).MousePressed:=false;
  End;
  //volume sound
  if (Objects[6] as TAbstractGraphControl).MousePressed then
  Begin
    TSoundPlayer.VolumeUP(Sound);
    (Objects[7] as TAbstractGraphControl).text:=IntToStr(TSoundPlayer.SoundVolume)+'%';
    (Objects[6] as TAbstractGraphControl).MousePressed:=false;
  End;
  if (Objects[7] as TAbstractGraphControl).MousePressed then
  Begin
    TSoundPlayer.VolumeUP(Sound);
    (Objects[7] as TAbstractGraphControl).text:=IntToStr(TSoundPlayer.SoundVolume)+'%';
    (Objects[7] as TAbstractGraphControl).MousePressed:=false;
  End;
  //continue game
  if (Objects[10] as TAbstractGraphControl).MousePressed then
  Begin
    isGameReset:=true;
    (Objects[10] as TAbstractGraphControl).MousePressed:=false;
  End;
end;

procedure TPauseLayout.onShow;
Begin
  if TSoundPlayer.isMuteSound then
    (Objects[2] as TAbstractGraphControl).text:='Off'
      else
        (Objects[2] as TAbstractGraphControl).text:='On';
  if TSoundPlayer.isMuteMusic then
    (Objects[4] as TAbstractGraphControl).text:='Off'
      else
        (Objects[4] as TAbstractGraphControl).text:='On';
  (Objects[7] as TAbstractGraphControl).text:=IntToStr(TSoundPlayer.SoundVolume)+'%';
  (Objects[9] as TAbstractGraphControl).text:=IntToStr(TSoundPlayer.MusicVolume)+'%';
End;

procedure TPauseLayout.KeyDown(const key:Word);
begin
  if key=VK_ESCAPE then
    isResume:=true;
end;

///
// tBriefingLayout
///

constructor TBriefingLayout.Create;
begin
  inherited;
  Objects.Add(TFactory.Construct(uImage,width div 2,height div 2,onMouseDown));
  (Objects[0] as TGraphImage).SetImage('lvl1\Briefing');
end;

procedure TBriefingLayout.Tic(const params: array of Integer);
begin
  //mute sound
  if (Objects[0] as TAbstractGraphControl).MousePressed then
      Begin
        isStartLevel:=true;
        (Objects[0] as TAbstractGraphControl).MousePressed:=false;
      End;
End;

///
// tDeBriefingLayout
///

constructor TDeBriefingLayout.Create;
begin
  inherited;
  Objects.Add(TFactory.Construct(uImage,width div 2,height div 2,onMouseDown));
  (Objects[0] as TGraphImage).SetImage('lvl1\DeBriefing');
end;

procedure TDeBriefingLayout.Tic(const params: array of Integer);
begin
  //mute sound
  if (Objects[0] as TAbstractGraphControl).MousePressed then
      Begin
        LevelNumber:=LevelNumber+1;
        isShowBriefing:=true;
        (Objects[0] as TAbstractGraphControl).MousePressed:=false;
      End;
End;

///
// tLayoutConstructor
///

class function TLayoutConstructor.Construct(const n:TLayoutType):TLayout;
begin
  case n of
   lEnterName:result:=TEnterNameLayout.Create;
   lGUI:result:=TGUILayout.Create;
   lHighscores:result:=THighscoresLayout.Create;
   lMainMenu:result:=TMainMenuLayout.Create;
   lOptions:result:=TOptionsLayout.Create;
   lPause:result:=TPauseLayout.Create;
   lBriefing:result:=ConstructBriefing;
   lDebriefing:result:=ConstructDeBriefing;
   lGame:result:=ConstructGameLevel;
   else result:=nil;
  end
end;

class function TLayoutConstructor.ConstructGameLevel:TLayout;
begin
 case TLayout.LevelNumber of
   1:result:=TLevel1Layout.Create;
   2:result:=TLevel2Layout.Create;
   3:result:=TLevel3Layout.Create;
   4:result:=TLevel4Layout.Create;
   else result:=nil
 end;
end;

class function TLayoutConstructor.ConstructBriefing:TLayout;
begin
 case TLayout.LevelNumber of
   1:result:=TBriefingLayout.Create;
   else result:=TBriefingLayout.Create
 end;
end;

class function TLayoutConstructor.ConstructDeBriefing:TLayout;
begin
 case TLayout.LevelNumber of
   1:result:=TDeBriefingLayout.Create;
   else result:=TDeBriefingLayout.Create
 end;
end;

end.
