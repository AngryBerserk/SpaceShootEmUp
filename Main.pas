unit Main;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, system.Generics.collections,
  BackBuffer, Background, Layout, SoundPlayer;

const
  screenwidth=480;
  screenheight=800;

type
  TForm1 = class(TForm)
    Timer1: TTimer;
    procedure FormShow(Sender: TObject);
    procedure FormMouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure FormMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormKeyDown(Sender: TObject; var Key: Word; Shift: TShiftState);
    procedure FormKeyPress(Sender: TObject; var Key: Char);
    procedure Timer1Timer(Sender: TObject);
  private
    MainMenuLayout,
    GameLayout,
    GUILayout,
    EnterNameLayout,
    HighscoresLayout,
    OptionsLayout,
    BriefingLayout,
    DeBriefingLayout,
    PauseLayout:TLayout;
    currentLayouts:TList<TLayout>;
    Background:TBackground;
    BackBuffer:TBackBuffer;
    procedure Render;
    procedure Restart;
    procedure LogicTic;
    procedure ScreenSelector;
    procedure ShowLayout(Layouts:Array of TLayout);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  freeAndNil(MainMenuLayout);
  freeAndNil(GameLayout);
  freeAndNil(GUILayout);
  freeAndNil(EnterNameLayout);
  freeAndNil(OptionsLayout);
  freeAndNil(PauseLayout);
  freeAndNil(HighscoresLayout);
  freeAndNil(BriefingLayout);
  freeAndNil(DeBriefingLayout);
  Background.Destroy;
  BackBuffer.Destroy;
  currentLayouts.Destroy;
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
 var T:TLayout;
begin
  for T in currentLayouts do
    T.KeyDown(Key);
end;

procedure TForm1.FormKeyPress(Sender: TObject; var Key: Char);
 var T:TLayout;
begin
  for T in currentLayouts do
    T.KeyPress(Key);
end;

procedure TForm1.FormMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
 var T:TLayout;
begin
  for T in currentLayouts do
    T.MouseDown(x,y,Button);
end;

procedure TForm1.FormMouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
 var T:TLayout;
begin
  for T in currentLayouts do
    T.MouseMoved(x,y);
end;

procedure TForm1.FormShow(Sender: TObject);
begin
 //Cursor:=crNone;
 TLayout.levelNumber:=1;
 TLayout.width:=screenwidth;
 TLayout.height:=screenheight;
 MainMenuLayout:=TLayoutConstructor.Construct(lMainMenu);
 EnterNameLayout:=TLayoutConstructor.Construct(lEnterName);
 OptionsLayout:=TLayoutConstructor.Construct(lOptions);
 BriefingLayout:=TLayoutConstructor.Construct(lBriefing);
 DeBriefingLayout:=TLayoutConstructor.Construct(lDebriefing);
 PauseLayout:=TLayoutConstructor.Construct(lPause);
 BackBuffer:=TBAckBuffer.Create(width,height);
 Background:=TBackground.Create(width,height);
 GameLayout.isGameOver:=false;
 currentLayouts:=TList<TLayout>.create;
 currentLayouts.Add(MainMenuLayout);
 TSoundPlayer.PlaySound('MOO2 - Galactic Theme 1.mp3',Music,true);
end;

procedure TForm1.Restart;
Begin
 //Cursor:=crNone;
 FreeAndNil(GameLayout);
 FreeAndNil(GUILayout);
 FreeAndNil(HighscoresLayout);
 GameLayout:=TLayoutConstructor.Construct(lGame);
 GUILayout:=TLayoutConstructor.Construct(lGUI);
 ShowLayout([GameLayout,GUILayout]);
End;

procedure TForm1.ShowLayout;
 var T:TLayout;
Begin
  currentLayouts.Clear;
  for T in Layouts do
    Begin
      currentLayouts.add(T);
      T.onShow
    End;
End;

procedure TForm1.ScreenSelector;
begin
 if TLayout.isQuit then
   Begin
    Form1.Close;
    halt;
   End else
     if TLayout.isShowBriefing then ShowLayout([BriefingLayout])
       else
         if TLayout.isShowDebriefing then ShowLayout([DeBriefingLayout])
            else
              if TLayout.isStartLevel then Restart
                else
                  if TLayout.isOptions then ShowLayout([OptionsLayout])
                    else
                      if TLayout.isGameReset then ShowLayout([MainMenuLayout])//MainMenu
                       else
                        if TLayout.isShowHighscores then ShowLayout([EnterNameLayout])
                            else
                              if TLayout.isGameOver then
                                Begin
                                  HighscoresLayout:=TLayoutConstructor.Construct(lHighscores);
                                  ShowLayout([HighScoresLayout]);
                                End
                                  else
                                    if TLayout.isPause then ShowLayout([PauseLayout])
                                      else
                                        if TLayout.isResume then ShowLayout([GameLayout,GUILayout]);
  TLayout.isGameOver:=false;
  TLayout.isShowHighscores:=false;
  TLayout.isGameReset:=false;
  TLayout.isStartLevel:=false;
  TLayout.isShowBriefing:=false;
  TLayout.isShowDebriefing:=false;
  TLayout.isQuit:=false;
  TLayout.isOptions:=false;
  TLayout.isPause:=false;
  TLayout.isResume:=false;
end;

procedure TForm1.Render;
 var T:TLayout;
begin
  BackBuffer.paint(0,0,0,Background.tic);
  for T in currentLayouts do
    T.Render(BackBuffer);
  Canvas.Draw(0,0,Backbuffer.GetCanvas);
end;

procedure TForm1.LogicTic;
 var T:TLayout;
begin
  for T in currentLayouts do
    T.tic([screenwidth,screenheight]);
end;

procedure TForm1.Timer1Timer(Sender: TObject);
begin
 if Form1.Active then
  Begin
   ScreenSelector;
   LogicTic;
  End;
 Render;
end;

end.
