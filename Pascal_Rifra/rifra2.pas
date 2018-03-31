{*************************************************************************
*                                                                        *
*                 R I F R A  2.0  di Fabrizio Fazzino                    *
*                                                                        *
*              Programma in Turbo Pascal sulla Rifrazione                *
*                                                                        *
*************************************************************************}

Program Rifra(input,output);
Uses Graph,Crt;
Type Punto=Record x,y:real;
                  xint,yint:integer;
                  rifratto:boolean; end;
     Punti=Array[1..16] of Punto;
Var Vertice:Punti;
    t1,t2:real;
    t1rad,t2rad:real;
    rapp:real;
    k:real;
    Scarto,ScartoNorm:real;
    ScartoInt,ScartoNormInt:integer;
    n:integer;
    Opzione,OpzPreced:integer;
    Tasto:char;

Procedure Inizializza;               { INIZIALIZZA IL VIDEO E LE VARIABILI }
Var Display,Modo:integer;
Begin
Display:=Ega; Modo:=EgaHi;
Initgraph(Display,Modo,'');
t1:=45;          { angolo di incidenza }
rapp:=0.5;       { rapporto tra le velocit… v2/v1 }
Opzione:=1;      { opzione del menu iniziale }
end;

Procedure Presentazione;                 { MOSTRA IL MENU DI PRESENTAZIONE }
Begin
ClearDevice;
SetBkColor(0);
SetFillStyle(SolidFill,5);
Bar(150,20,460,110);
SetFillStyle(SolidFill,1);
Bar(160,30,450,100);
SetColor(14);
SetLineStyle(0,1,1);
Rectangle(150,20,460,110);
Rectangle(160,30,450,100);
SetTextStyle(1,0,7);
OutTextXY(180,30,'Rifra 2.0');
SetTextStyle(1,0,4);
OutTextXY(160,120,'di Fabrizio Fazzino');
SetFillStyle( 8,14);
Bar(170,180,440,330);
SetFillStyle(SolidFill,1);
Bar(180,190,430,320);
SetFillStyle(SolidFill,4);
Bar(187,Opzione*30+175,420,Opzione*30+185);
SetTextStyle(0,0,0);
SetColor(15);
OutTextXY(192,207,'Introduzione alla Rifrazione');
OutTextXY(192,237,'Inserimento dati iniziali...');
OutTextXY(192,267,'Esegue il programma.........');
OutTextXY(192,297,'Ritorna al Sistema Operativo');
Repeat                                     { seleziona l'opzione richiesta }
    OpzPreced:=Opzione;
    Tasto:=Readkey;
    If Tasto=#80 then Opzione:=Opzione+1;
    If Tasto=#72 then Opzione:=Opzione-1;
    If Opzione>4 then Opzione:=1;
    If Opzione<1 then Opzione:=4;
    If Opzione<>OpzPreced then begin
        SetFillStyle(SolidFill,4);
        Bar(187,Opzione*30+175,420,Opzione*30+185);
        SetFillStyle(SolidFill,1);
        Bar(187,OpzPreced*30+175,420,OpzPreced*30+185);
        SetTextStyle(0,0,0);
        SetColor(15);
        OutTextXY(192,207,'Introduzione alla Rifrazione');
        OutTextXY(192,237,'Inserimento dati iniziali...');
        OutTextXY(192,267,'Esegue il programma.........');
        OutTextXY(192,297,'Ritorna al Sistema Operativo');
        end;
Until Tasto=#13;
end;

Procedure Introduzione;        { FORNISCE UNA INTRODUZIONE ALLA RIFRAZIONE }
Begin
ClearDevice;                                                  { Pagina 1/3 }
SetBkColor(0);
SetColor(4);
SetTextStyle(1,0,5);
OutTextXY(160,20,'La Rifrazione');
SetLineStyle(0,1,3);
SetColor(1);
Rectangle(120,20,460,65);
SetColor(15);
SetTextStyle(1,0,4);
OutTextXY(30,80,'La Rifrazione e'' la variazione di dire-');
OutTextXY(5,110,'zione di una onda elastica che passa da');
OutTextXY(5,140,'un mezzo a un altro : essa si verifica');
OutTextXY(5,170,'quando i due mezzi sono caratterizzati');
OutTextXY(5,200,'da una diversa velocita'' di propagazione');
OutTextXY(5,230,'della perturbazione, e quando il raggio');
OutTextXY(5,260,'incidente non e'' perpendicolare alla');
OutTextXY(5,290,'superficie di separazione dei due mezzi.');
SetTextStyle(1,0,1);
SetColor(3);
OutTextXY(580,330,'(Tasto)');
Tasto:=ReadKey;
ClearDevice;                                                  { Pagina 2/3 }
SetColor(4);
SetTextStyle(1,0,4);
OutTextXY(50,15,'Leggi geometriche della Rifrazione');
SetLineStyle(0,1,3);
SetColor(1);
Rectangle(20,15,615,50);
SetColor(15);
SetTextStyle(1,0,3);
OutTextXY(20,60,'Le leggi geometriche della Rifrazione sono date dalle');
SetColor(5);
OutTextXY(150,85,'Leggi di Snellius-Cartesio');
SetColor(15);
OutTextXY(5,110,'- Raggio incidente, raggio rifratto e normale alla');
OutTextXY(5,135,'   superficie di separazione dei due mezzi nel punto');
OutTextXY(5,160,'   di incidenza giacciono sullo stesso piano.');
OutTextXY(5,185,'- L''angolo di incidenza t1 e l''angolo di rifrazione t2');
OutTextXY(5,210,'   ( formati dai raggi e dalla normale alla superficie');
OutTextXY(5,235,'   di separazione ) sono legati dalla relazione :');
SetColor(14);
OutTextXY(200,265,'sen t1   sen t2');
OutTextXY(200,285,'  v1       v2');
OutTextXY(279,274,'=');
SetLineStyle(0,1,1);
Line(197,289,267,289);
Line(304,289,374,289);
SetLineStyle(0,1,3);
SetColor(4);
Rectangle(178,267,393,310);
SetColor(15);
OutTextXY(40,315,'dove v1,v2 sono le velocita'' di propagazione.');
SetTextStyle(1,0,1);
SetColor(3);
OutTextXY(580,330,'(Tasto)');
Tasto:=ReadKey;
ClearDevice;
SetTextStyle(1,0,5);                                          { Pagina 3/3 }
SetColor(4);
OutTextXY(128,15,'Riflessione Totale');
SetLineStyle(0,1,3);
SetColor(1);
Rectangle(80,18,520,57);
SetTextStyle(1,0,3);
SetColor(15);
OutTextXY(20,60,'Quando un''onda passa da un mezzo con velocita'' di');
OutTextXY(5,85,'propagazione della perturbazione piu''bassa a un mezzo');
OutTextXY(5,110,'con velocita'' piu'' elevata accade che, per un certo');
OutTextXY(5,135,'valore dell''angolo di incidenza, l''angolo di rifrazione');
OutTextXY(5,160,'sia retto, cioe'' il raggio rifratto sia parallelo alla');
OutTextXY(5,185,'superficie di separazione dei due mezzi.');
OutTextXY(20,210,'Tale valore dell''angolo di incidenza e'' chiamato');
SetColor(14);
OutTextXY(5,235,'Angolo Limite');
SetColor(15);
OutTextXY(170,235,', perche'' per angoli di incidenza');
OutTextXY(5,260,'maggiori il raggio non viene piu'' rifratto ma viene');
OutTextXY(5,285,'interamente riflesso : tale fenomeno viene chiamato');
SetColor(14);
OutTextXY(5,310,'Riflessione Totale.');
SetTextStyle(1,0,1);
SetColor(3);
OutTextXY(580,330,'(Tasto)');
Tasto:=ReadKey;
end;

Procedure InserisciDati;                        { IMMISSIONE DATI INIZIALI }
Var Stringa1,Stringa2:string[6];
Begin
Repeat                                             { mostra i dati attuali }
  SetBkColor(0);
  ClearDevice;
  SetColor(4);
  SetTextStyle(1,0,5);
  OutTextXY(50,20,'Inserimento Dati Iniziali');
  SetColor(1);
  SetLineStyle(0,1,3);
  Rectangle(25,15,580,65);
  SetColor(15);
  SetTextStyle(1,0,3);
  OutTextXY(30,100,'I dati attuali sono i seguenti :');
  OutTextXY(30,150,'- Angolo di incidenza (in gradi) : t1=');
  Str(t1:3:2,Stringa1);
  OutTextXY(466,150,Stringa1);
  OutTextXY(30,200,'- Rapporto tra le velocita'' :   v2/v1=');
  Str(rapp:3:2,Stringa2);
  OutTextXY(466,200,Stringa2);
  OutTextXY(30,250,'Vuoi modificare questi dati ?   (S/N)');
  Tasto:=ReadKey;
  If Tasto='s' then begin              { modifica i dati inserendone nuovi }
    ClearDevice;
    SetColor(4);
    SetTextStyle(1,0,5);
    OutTextXY(50,20,'Inserimento Dati Iniziali');
    SetColor(1);
    SetLineStyle(0,1,3);
    Rectangle(25,15,580,65);
    SetColor(15);
    SetTextStyle(1,0,3);
    OutTextXY(30,105,'Inserisci i nuovi dati :');
    OutTextXY(30,160,'Angolo di incidenza (in gradi) : t1=');
    TextColor(15);
    Repeat
      GoToXY(56,13);
      Read(t1);
    Until ((t1>=0) and (t1<90));
    OutTextXY(30,215,'Rapporto tra le velocita'' :   v2/v1=');
    Repeat
      GoToXY(56,17);
      Read(rapp);
    Until ((rapp>0) and (rapp<10));
  end;
Until (Tasto='n');
end;

Procedure DisegnaLinea;                   { DISEGNA LA LINEA DI RIFRAZIONE }
Begin
SetColor(4);
SetLineStyle(0,0,3);
ScartoInt:=trunc(Scarto/2);
Line(320+ScartoInt,0,320-ScartoInt,350);
end;

Procedure PosizioniIniziali;           { INIZIALIZZA POSIZIONI DEI VERTICI }
Begin
For n:=0 to 7 do begin
    Vertice[n*2+1].x:=(5-n)*30;
    Vertice[n*2+2].x:=(5-n)*30-16; end;
For n:=1 to 16 do begin
    Vertice[n].y:=175;
    Vertice[n].rifratto:=False; end;
end;

Procedure Visualizza;                 { VISUALIZZA NELLE POSIZIONI CORRENTI }
Begin
For n:=1 to 16 do begin
  Vertice[n].xint:=trunc(Vertice[n].x);
  Vertice[n].yint:=trunc(Vertice[n].y); end;
SetColor(14);
SetLineStyle(0,0,3);
For n:=0 to 7 do begin
  If ((Vertice[n*2+1].xint>320) and (Vertice[n*2+2].xint<320)) then begin
    Line(Vertice[n*2+1].xint,Vertice[n*2+1].yint,320,175);
    Line(320,175,Vertice[n*2+2].xint,Vertice[n*2+2].yint); end
  else Line(Vertice[n*2+1].xint,Vertice[n*2+1].yint,
            Vertice[n*2+2].xint,Vertice[n*2+2].yint);
end;
end;

Procedure Verifica(n:integer);           { VERIFICA SE IL PUNTO E'RIFRATTO }
Begin
If Vertice[n].xint>319 then Vertice[n].rifratto:=true;
end;

Procedure Calcola;                  { CALCOLA LE NUOVE POSIZIONI DEI PUNTI }
Begin
For n:=1 to 16 do begin
    Verifica(n);
    If Vertice[n].rifratto then begin
        Vertice[n].x:=Vertice[n].x+rapp*cos(t1rad-t2rad);
        Vertice[n].y:=Vertice[n].y+rapp*sin(t1rad-t2rad); end
    else Vertice[n].x:=Vertice[n].x+1;
    end;
end;

Procedure Cancella;        { CANCELLA I PUNTI DALLA LORO VECCHIA POSIZIONE }
Begin
SetColor(1);
For n:=0 to 7 do begin
  If ((Vertice[n*2+1].xint>320) and (Vertice[n*2+2].xint<320)) then begin
    Line(Vertice[n*2+1].xint,Vertice[n*2+1].yint,320,175);
    Line(320,175,Vertice[n*2+2].xint,Vertice[n*2+2].yint); end
  else Line(Vertice[n*2+1].xint,Vertice[n*2+1].yint,
            Vertice[n*2+2].xint,Vertice[n*2+2].yint);
end;
end;

Procedure Esegui;                        { MOSTRA LA RIFRAZIONE DEL RAGGIO }
Var Stringa,Stringa1,Stringa2:string[6];
    AngoloLimite,AngoloLimiteRad:real;
Begin
ClearDevice;
SetBkColor(1);
t1rad:=t1/180*pi;
k:=rapp*sin(t1rad);
If k<1 then begin
  t2rad:=arctan(k/sqrt(1-k*k));
  t2:=t2rad/pi*180;
  Scarto:=350*sin(t1rad)/cos(t1rad);
  DisegnaLinea;
  PosizioniIniziali;
  Repeat Visualizza;
         Calcola;
         Delay(5);
         DisegnaLinea;
         Cancella;
  Until (Vertice[9].xint>315);
  Visualizza;
  SetLineStyle(1,1,1);
  SetColor(10);
  If t1rad>0 then begin
    ScartoNorm:=350*cos(t1rad)/sin(t1rad);
    ScartoNormInt:=trunc(ScartoNorm/4);
    Line(320-ScartoNormInt,87,320+ScartoNormInt,262); end
  else Line(100,175,540,175);
  SetTextStyle(1,0,4);
  SetColor(14);
  Str(rapp:3:2,Stringa);
  Str(t1:3:2,Stringa1);
  Str(t2:3:2,Stringa2);
  OutTextXY(150,10,'Rapporto v2/v1=');
  OutTextXY(416,10,Stringa);
  SetColor(2);
  OutTextXY(10,160,'t1=');
  OutTextXY(65,160,Stringa1);
  OutTextXY(500,160,'t2=');
  OutTextXY(555,160,Stringa2);
  SetColor(15);
  If t2<t1 then begin
    OutTextXY(120,270,'Poiche'' v2<v1 il raggio si e''');
    OutTextXY(150,300,'accostato alla normale.'); end;
  If t2>t1 then begin
    OutTextXY(120,270,'Poiche'' v2>v1 il raggio si e''');
    OutTextXY(120,300,'allontanato dalla normale.'); end;
  If t1=0 then begin
    OutTextXY(120,270,'Poiche'' l''angolo di incidenza e'' nullo');
    OutTextXY(120,300,'non si e'' verificata alcuna rifrazione.'); end;
end
else begin                                { nel caso di riflessione totale }
  SetTextStyle(1,0,4);
  SetColor(15);
  OutTextXY(30,50,'In questo caso avviene la riflessione');
  OutTextXY(30,80,'totale, in quanto l''angolo di incidenza');
  OutTextXY(30,110,'supera l''angolo limite calcolato per');
  OutTextXY(30,140,'quelle determinate sostanze.');
  SetColor(14);
  OutTextXY(30,230,'Angolo di incidenza:    t1=');
  OutTextXY(30,280,'Angolo Limite:           t=');
  AngoloLimiteRad:=arctan(1/(rapp*sqrt(1-(1/(rapp*rapp)))));
  AngoloLimite:=AngoloLimiteRad/pi*180;
  Str(t1:3:2,Stringa1);
  Str(AngoloLimite:3:2,Stringa2);
  OutTextXY(500,230,Stringa1);
  OutTextXY(500,280,Stringa2);
end;
Tasto:=Readkey;
end;

Begin                                               { PROGRAMMA PRINCIPALE }
Inizializza;
Repeat
  Presentazione;
  Case Opzione of
    1:Introduzione;
    2:InserisciDati;
    3:Esegui;
  end;
Until (Opzione=4);
CloseGraph;
RestoreCrtMode;
end.