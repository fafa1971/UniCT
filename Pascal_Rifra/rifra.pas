{*************************************************************************
*                                                                        *
*    R I F R A  -  Programma di Fisica II sugli effetti della Rifrazione *
*      di Fabrizio Fazzino, Ingegneria Informatica - Prof F.Falciglia    *
*                                                                        *
*************************************************************************}

Program Rifra(input,output);
Uses Graph,Crt;
Const t=0.424;   { t=teta1-teta2 (teta2 RICAVABILE DALLA LEGGE DI SNELL) }
      rapp=2;    { RAPPORTO TRA LE VELOCITA' (rapp=v1/v2) }
      vel=0.2;   { velocit… di esecuzione del programma }
Type Punto=Record x,y:real;
                  xint,yint:integer;
                  infangato:boolean; end;
     Banda=Array[1..24] of Punto;  { banda composta da 24 suonatori }
Var Suonatore:Banda;
    n:integer;
    Tasto:char;

Procedure Introduzione;          { SCHERMATA INTRODUTTIVA }
Var Display,Modo:integer;
Begin
Display:=EGA;
Modo:=EGAHi;
InitGraph(Display,Modo,'');
SetBkColor(3);                   { disegna il parallelepipedo }
SetColor(14);
SetFillStyle(EmptyFill,14);
Bar3d(190,35,430,110,20,true);
SetFillStyle(SolidFill,1);
FloodFill(200,100,14);
SetColor(14);
SetTextStyle(1,0,8);
OutTextXY(220,30,'Rifra');
SetFillStyle(SlashFill,5);
FloodFill(200,30,14);
FloodFill(440,100,14);
SetFillStyle(SolidFill,5);     { disegna la barra lunga }
Bar(20,130,620,165);
Rectangle(20,130,620,165);
SetTextStyle(1,0,4);
OutTextXY(35,130,'Tesina di Fisica II - Prof. F.Falciglia');
SetFillStyle(solidFill,4);     { disegna il quadrante a sinistra }
Bar(20,185,200,330);
Rectangle(20,185,200,330);
SetColor(15);
SetTextStyle(1,0,4);
OutTextXY(50,189,'Fabrizio');
OutTextXY(55,219,'Fazzino');
SetTextStyle(1,0,2);
SetColor(10);
OutTextXY(51,256,'Matr.176709');
SetColor(13);
SetTextStyle(1,0,3);
OutTextXY(54,277,'Ingegneria');
OutTextXY(48,300,'Informatica');
SetColor(8);                { stampa le spiegazioni }
SetTextStyle(1,0,1);
OutTextXY(250,190,'Il programma simula gli effetti della');
OutTextXY(230,210,'rifrazione: una banda musicale, composta');
OutTextXY(230,230,'da 24 suonatori, marcia su un campo di');
OutTextXY(230,250,'calcio in parte infangato. Poiche'' nella');
OutTextXY(230,270,'parte infangata la velocita'' di marcia viene');
OutTextXY(230,290,'dimezzata, per la Legge di Snell la banda');
OutTextXY(230,310,'devia.');
SetColor(4);
OutTextXY(290,310,'Premere un tasto.');
end;

Procedure DisegnaCampo;     { DISEGNA IL CAMPO DI CALCIO }
Begin
ClearDevice;
Setbkcolor(2);
SetColor(6);
Line(250,349,600,0);        { DISEGNA LA LINEA DI RIFRAZIONE (m=teta1) }
SetFillStyle(SolidFill,6);
FloodFill(600,300,6);       { riempie la parte infangata }
SetColor(15);
Rectangle(0,0,639,349);     { linee di bordocampo }
Line(320,0,320,349);        { linea di centrocampo }
Circle(320,175,60);         { cerchio di centrocampo }
Arc(0,0,270,0,8);           {   lunette del   }
Arc(0,349,0,90,8);          { calcio d'angolo }
Arc(639,0,180,270,8);
Arc(639,349,90,180,8);
Rectangle(0,85,100,265);    { area di rigore }
Rectangle(539,85,639,265);
Rectangle(0,132,30,218);    { area della rimessa del portiere }
Rectangle(609,132,639,218);
PutPixel(65,175,15);        { dischetto del rigore }
PutPixel(574,175,15);
Arc(65,175,306,54,60);      { lunetta del rigore }
Arc(574,175,126,234,60); end;

Procedure PosizioniIniziali;   { INIZIALIZZA POSIZIONI DEI SUONATORI }
Begin
For n:=1 to 6 do begin
    Suonatore[n].y:=193;    Suonatore[n].x:=(12*n);          { 1ø riga }
    Suonatore[n+6].y:=181;  Suonatore[n+6].x:=(12*n);        { 2ø riga }
    Suonatore[n+12].y:=169; Suonatore[n+12].x:=(12*n);       { 3ø riga }
    Suonatore[n+18].y:=157; Suonatore[n+18].x:=(12*n); end;  { 4ø riga }
For n:=1 to 24 do begin
    Suonatore[n].xint:=trunc(Suonatore[n].x);
    Suonatore[n].yint:=trunc(Suonatore[n].y);
    Suonatore[n].Infangato:=false; end; end;

Procedure Visualizza;          { VISUALIZZA NELLE POSIZIONI CORRENTI }
Begin
For n:=1 to 24 do begin
    Suonatore[n].xint:=trunc(Suonatore[n].x);
    Suonatore[n].yint:=trunc(Suonatore[n].y);
    Putpixel(Suonatore[n].xint,Suonatore[n].yint,15); end; end;

Procedure Verifica(n:integer);  { VERIFICA SE IL PUNTO E' INFANGATO }
Begin
If Suonatore[n].infangato then else begin
    If Getpixel(Suonatore[n].xint,Suonatore[n].yint+1)=6 then
        Suonatore[n].Infangato:=true; end;
    end;

Procedure Calcola;    { CALCOLA LE NUOVE POSIZIONI DEI PUNTI }
Begin
For n:=1 to 24 do begin
    Verifica(n);
    If Suonatore[n].Infangato then begin
        Suonatore[n].x:=Suonatore[n].x+vel*cos(t);
        Suonatore[n].y:=Suonatore[n].y+vel*sin(t); end
    else Suonatore[n].x:=Suonatore[n].x+rapp*vel; end; end;

Procedure Cancella;   { CANCELLA I PUNTI DALLA LORO VECCHIA POSIZIONE }
Begin
For n:=1 to 24 do begin
    Verifica(n);
    If Suonatore[n].Infangato then
        Putpixel(Suonatore[n].xint,Suonatore[n].yint,6)
    else Putpixel(Suonatore[n].xint,Suonatore[n].yint,2); end; end;

Begin                 { PROGRAMMA PRINCIPALE }
Introduzione;
Tasto:=Readkey;
DisegnaCampo;
PosizioniIniziali;
Repeat Visualizza;
       Calcola;
       Cancella;
Until ((Suonatore[6].xint>625) or keypressed);
Visualizza;
Tasto:=Readkey;
CloseGraph;
RestoreCrtMode;
end.