program G1;

uses
  Vcl.Forms,
  Main in 'Main.pas' {Form1},
  SoundPlayer in 'SoundPlayer.pas',
  Animation in 'Animation.pas',
  Mover in 'Mover.pas',
  BackBuffer in 'BackBuffer.pas',
  Background in 'Background.pas',
  Highscores in 'Highscores.pas',
  Spritesheet in 'Spritesheet.pas',
  Alphabet in 'Alphabet.pas',
  GraphicControl in 'GraphicControl.pas',
  Layout in 'Layout.pas',
  Hero in 'Hero.pas',
  UnitFactory in 'UnitFactory.pas',
  simpleEnemy in 'simpleEnemy.pas',
  Projective in 'Projective.pas',
  Cannon in 'Cannon.pas',
  Explosion in 'Explosion.pas',
  Bonus in 'Bonus.pas',
  bass in 'bass.pas',
  GameLog in 'GameLog.pas',
  GameLayouts in 'GameLayouts.pas',
  Bosses in 'Bosses.pas';

{$R *.res}

begin
  System.ReportMemoryLeaksOnShutdown:=true;
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.
