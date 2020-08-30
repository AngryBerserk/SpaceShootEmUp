unit GameLayouts;

interface

uses
  sysutils, Mover,controls, UnitFactory, windows, Hero, Bonus, Layout, SimpleEnemy;

type
  TGameLayout=class(TLayout)
      Hero:TMover;
      class var EndLevelCinematic:Boolean;
      class var levelprogress:Word;
      class var HP:Integer;
      procedure GameOver;
      procedure MoverDies(Sender:TObject);Dynamic;
      procedure onMouseDown(Sender:TObject);override;
      procedure MouseDown(const x,y:Integer;const Button:TMouseButton);override;
      procedure DetectCollision(from:Word);virtual;
      procedure KeyDown(const Key:Word);override;
      procedure MouseMoved(const x,y:Integer);override;
      procedure OnScoreChange(Sender:TObject);
      procedure Tic(const params:Array of Integer);override;
      constructor Create;override;
  end;

  TLevel1Layout=class(TGameLayout)
      procedure Tic(const params:Array of Integer);override;
      constructor Create;override;
  end;

  TLevel2Layout=class(TGameLayout)
      procedure Tic(const params:Array of Integer);override;
      constructor Create;override;
  end;

  TLevel3Layout=class(TGameLayout)
      Boss:TMover;
      counter:Word;
      BossKilled:Boolean;
      procedure Tic(const params:Array of Integer);override;
      constructor Create;override;
  end;

  TLevel4Layout=class(TGameLayout)
      procedure Tic(const params:Array of Integer);override;
      constructor Create;override;
  end;

implementation

///
//tGameLayout
///

constructor TGameLayout.Create;
begin
   EndLevelCinematic:=false;
   TSpeedPowerup.duration:=0;
   TWeaponPowerup.power:=0;
   levelprogress:=0;
   inherited;
   Hero:=TFactory.Construct(uHero,width div 2,height-40,onMouseDown);
   Objects.Add(Hero);
end;

procedure TGameLayout.KeyDown(const key:Word);
begin
  if key=VK_ESCAPE then
    isPause:=true;
end;

procedure TGameLayout.MoverDies(Sender: TObject);
begin
  With Sender as TMover do
    Objects.Add(TFactory.Construct(uExplosion,x,y,nil))
end;

procedure TGameLayout.onMouseDown(Sender: TObject);
 var P:TMover;
begin
 if Not EndLevelCinematic then
  Begin
    P:=(Sender as TSocket).getObject;
    if P<>nil then
      Begin
        if score>abs((Sender as TMover).scorePoints) then
          Begin
            Objects.add(P);
            TMover.Sound('laser.wav');
            (Sender as TMover).scoreChanged;
          End else P.Destroy;
      End;
  End;
end;

procedure TGameLayout.GameOver;
begin
  disable:=true;
  Objects.Add(TFactory.Construct(uExplosion,Hero.x,Hero.y,nil));
  if Highscore.IsInHighscores(Round(score)) then
      isShowHighscores:=true
        else
          isGameOver:=true;
end;

procedure TGameLayout.MouseMoved(const x: Integer; const y: Integer);
begin
 if not EndLevelCinematic then
   Begin
    (Hero as THero).GoToX:=x;
    (Hero as THero).GoToY:=y;
   End;
end;

procedure TGameLayout.MouseDown(const x,y:Integer;const Button:TMouseButton);
 var T:TMover;
Begin
 if not EndLevelCinematic then
   for T in Objects do
        T.MouseDown(x,y);
end;

procedure TGameLayout.OnScoreChange (Sender : TObject);
begin
  score:=score+(Sender as TMover).scorePoints;
end;

procedure TGameLayout.DetectCollision(from:Word);
 var z:Word;O:TMover;
Begin
 O:=Objects[from];
 if (O.x+O.width div 2>0)and(O.x-O.width div 2<width)and(O.y+O.height div 2>0)and(O.y-O.height div 2<height) then

    for z := 0 to Objects.Count-1 do
        if (Objects[z].isAlive)and((not O.passive))and (O<>objects[z]){or(not Objects[z].passive))} then
            if O.hitTest(Objects[z].x,Objects[z].y,Objects[z].width,Objects[z].height) then O.Hits(Objects[z]);
End;

procedure TGameLayout.Tic(const params: array of Integer);
 var z:Integer;
begin
  Score:=Score+0.035;
  HP:=Hero.hp;
  z:=0;
   repeat
      if Objects[z].isAlive then Objects[z].logic([width,height]);
  //detect collision
      if (Objects[z].isAlive)and(not EndLevelCinematic) then detectCollision(z);
      if Objects[z].isAlive then inc(z)
        else
          Begin
            if Objects[z]=Hero then Begin GameOver;exit end else
              Begin
                Objects[z].Destroy;
                Objects.Delete(z);
              end;
          end;
   until z>Objects.Count-1;
   levelprogress:=levelProgress+1;
end;

//////
//  TLevel1Layout
//////

constructor TLevel1Layout.Create;
 var z:Integer;T:TMover;
begin
   inherited;
   Hero.AttachSocket(TFactory.Construct(uBasicGun,Hero.x,Hero.y,onMouseDown));
   Hero.AttachSocket(TFactory.Construct(uBasicGun,Hero.x,Hero.y,onMouseDown));
   for T in Hero.Sockets do
    T.OnScoreChange:=onScoreChange;
   Objects.Add(TFactory.construct(uDebris,Random(width),-20,onMouseDown));
   Objects[1].OnObjectDies:=MoverDies;
   for z := 0 Downto -13863 do
     Begin
      if z>-6344 then
        Begin
          if Random((8000+z)div 300)=0 then
            Objects.Add(TFactory.construct(uDebris,Random(width),z, onMouseDown));
        End
          else
            if (z>-12228)and(z>-13000) then
               Begin
                  if Random(abs(4000+z) div 300)=0 then
                    Objects.Add(TFactory.construct(uDebris,Random(width),z, onMouseDown));
               End;
         //spawn bonus
       if z>-13000 then
          Begin
            if Random(1500)=0 then
              Objects.Add(TFactory.construct(uSpeedPowerup,Random(width),z, onMouseDown));
            if Random(1500)=0 then
              Objects.Add(TFactory.construct(uWeaponPowerup,Random(width),z, onMouseDown));
          End;
     End;
   Objects.Insert(0,TFactory.Construct(uMothership,width div 2,-14250,onMouseDown));
end;

procedure TLevel1Layout.Tic(const params:Array of Integer);
begin
 if not disable then
 Begin
   if (levelProgress=13000)and(not EndLevelCinematic) then
      Begin
        EndLevelCinematic:=true;
        (Hero as THero).GoToX:=width div 2;
        (Hero as THero).GoToY:=-40;
      End
        else
          if levelProgress=13863 then
            Begin
              isShowDebriefing:=true;
            End;
   inherited;
 End;
end;

//////
//  TLevel2Layout
//////

constructor TLevel2Layout.Create;
 var z,mx,dx:Integer;gapWidth:Word;c:Real;
begin
   inherited;
   dx:=0;
   mx:=Width div 2;
   c:=((Width-50) / 2 - 50) / 750;
   for z := 0 Downto -750 do
     Begin
        gapWidth:=Round(c*(750-abs(z)))+40;
        if Random(5)=0 then
          dx:=Random(2)-1;
        if (dx=0) and (mx+gapWidth>width-20) then dx:=-1
          else
            if (dx=-1) and (mx-gapWidth<20) then dx:=0;
      if dx=0 then mx:=mx+random(3)+5
        else mx:=mx-random(3)-5;
      Objects.Add(TFactory.construct(uBomb,mx-gapWidth,z*20, onMouseDown));
      Objects[Objects.Count-1].OnObjectDies:=MoverDies;
      Objects[Objects.Count-1].speed:=4;
      Objects.Add(TFactory.construct(uBomb,mx+gapWidth,z*20, onMouseDown));
      Objects[Objects.Count-1].speed:=4;
     End;
   Objects.Insert(0,TFactory.Construct(uMothership,width div 2,-5000,onMouseDown));
end;

procedure TLevel2Layout.Tic(const params:Array of Integer);
begin
 if not disable then
 Begin
   if (levelProgress=3900)and(not EndLevelCinematic) then
      Begin
        EndLevelCinematic:=true;
        (Hero as THero).GoToX:=width div 2;
        (Hero as THero).GoToY:=-40;
      End
        else
          if levelProgress=4300 then
            Begin
              isShowDebriefing:=true;
            End;
   inherited;
 End;
end;

//////
//  TLevel3Layout
//////

constructor TLevel3Layout.Create;
 var z:Integer;T:TMover;
begin
   inherited;
   BossKilled:=False;
   Hero.AttachSocket(TFactory.Construct(uBasicGun,Hero.x,Hero.y,onMouseDown));
   Hero.AttachSocket(TFactory.Construct(uBasicGun,Hero.x,Hero.y,onMouseDown));
   for T in Hero.Sockets do
    T.OnScoreChange:=onScoreChange;
   Objects.Add(TFactory.construct(uSimpleEnemy,Random(width),-20,onMouseDown));
   Objects[1].OnObjectDies:=MoverDies;
   Objects.Add(TFactory.construct(uBomb,Random(width),-20,onMouseDown));
   Objects[2].OnObjectDies:=MoverDies;
   Objects.Add(TFactory.construct(uDebris,Random(width),-20,onMouseDown));
   Objects[3].OnObjectDies:=MoverDies;
   for z := 0 Downto -13863 do
     Begin
      if z>-6344 then
        Begin
          if Random((8000+z)div 300)=0 then
            Begin
              if Random(2)=0 then
                Objects.Add(TFactory.construct(uSimpleEnemy,Random(width),z, onMouseDown))
                  else
                    if Random(2)=0 then
                      Objects.Add(TFactory.construct(uBomb,Random(width),z, onMouseDown))
                          else
                            Objects.Add(TFactory.construct(uDebris,Random(width),z, onMouseDown))
            End;
        End
          else
            if (z>-12228)and(z>-13000) then
               Begin
                  if Random(abs(4000+z) div 300)=0 then
                    Begin
                      if Random(2)=0 then
                        Objects.Add(TFactory.construct(uSimpleEnemy,Random(width),z, onMouseDown))
                          else
                            if Random(2)=0 then
                              Objects.Add(TFactory.construct(uBomb,Random(width),z, onMouseDown))
                                  else
                                    Objects.Add(TFactory.construct(uDebris,Random(width),z, onMouseDown))
                    End;
               End;
         //spawn bonus
       if z>-13000 then
          Begin
            if Random(1500)=0 then
              Objects.Add(TFactory.construct(uSpeedPowerup,Random(width),z, onMouseDown));
            if Random(1500)=0 then
              Objects.Add(TFactory.construct(uWeaponPowerup,Random(width),z, onMouseDown));
          End;
     End;
end;

procedure TLevel3Layout.Tic(const params:Array of Integer);
begin
 if not disable then
 Begin
   if levelProgress=13000 then
    Begin
      Boss:=TFactory.Construct(uBoss1,params[0] div 2,-100,onMouseDown);
      Objects.Add(Boss);
      Boss.OnObjectDies:=MoverDies;
    End;
   if (levelProgress>13001)and(Not Boss.isAlive)and(counter>200) then
      Begin
        GameOver
      End
        else
         if (levelProgress>13001)and(not Boss.isAlive) then
            Begin
              counter:=counter+1;
            End;
   inherited;
 End;
end;

//////
//  TLevel4Layout
//////

constructor TLevel4Layout.Create;
 var z,x:Integer;T:TMover;dir:Boolean;
begin
   inherited;
   //BossKilled:=False;
   Hero.AttachSocket(TFactory.Construct(uBasicGun,Hero.x,Hero.y,onMouseDown));
   Hero.AttachSocket(TFactory.Construct(uBasicGun,Hero.x,Hero.y,onMouseDown));
   for T in Hero.Sockets do
    T.OnScoreChange:=onScoreChange;
   Objects.Add(TFactory.construct(uRoamingBomb,width div 2,height,onMouseDown));
   Objects[1].OnObjectDies:=MoverDies;
   for z := 0 Downto -12300 do
      Begin
          if Random(70)=0 then
                  Objects.Add(TFactory.construct(uSimpleEnemy,Random(width),z, onMouseDown));
          if Random(600)=0 then
              Begin
                dir:=Boolean(Random(2));
                for x := 1 to random(20)+10 do
                  Begin
                    Objects.Add(TFactory.construct(uRoamingBomb,width div 2,z-x*10,onMouseDown));
                    (Objects[Objects.Count-1] as TRoamingBomb).t:=(10-x)/10;
                    (Objects[Objects.Count-1] as TRoamingBomb).dir:=dir;
                  End;
              End;
          if Random(50)=0 then
                  Objects.Add(TFactory.construct(uDebris,Random(width),z, onMouseDown));
         //spawn bonus
       if z>-13000 then
          Begin
            if Random(1500)=0 then
              Objects.Add(TFactory.construct(uSpeedPowerup,Random(width),z, onMouseDown));
            if Random(1500)=0 then
              Objects.Add(TFactory.construct(uWeaponPowerup,Random(width),z, onMouseDown));
          End;
     End;
   Objects.Insert(0,TFactory.Construct(uMothership,width div 2,-14250,onMouseDown));
end;

procedure TLevel4Layout.Tic(const params:Array of Integer);
begin
 if not disable then
 Begin
   if (levelProgress=13000)and(not EndLevelCinematic) then
      Begin
        EndLevelCinematic:=true;
        (Hero as THero).GoToX:=width div 2;
        (Hero as THero).GoToY:=-40;
      End
        else
          if levelProgress=13863 then
            Begin
              isShowDebriefing:=true;
            End;
   inherited;
 End;
end;

end.
