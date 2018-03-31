Program Ondega(input,output);
uses dos, crt, graph;
const
   sn:integer=1;
   scelta: array [1..10] of string[30]=(
'INTRODUZIONE..................',
'MOTO ARMONICO SEMPLICE........',
'INTERFERENZA..................',
'BATTIMENTI....................',
'ONDE ARMONICHE................',
'ONDE COMPLESSE................',
'..............................',            {w:freq, i:colore, n:num. cicli}
'..............................',            {f:fi                          }
'..............................',
'USCITA........................');

procedure ONDA (x1,y1,r:integer; w:real; i:integer; n:integer; f:real);
var
px,py,x,y,ad:integer;
ang:real;
begin
       ang:=0;
       x:=x1;
       y:=y1;
       ad:=3;  {grandezza del grafico}
       setcolor (i);
       {NOTA: dovrebbe essere ...ang<=6.28/ad... ma cos si considera solo un}
       {      ciclo 2pi, invece  ...(ad/2)... raddoppia il ciclo e disegna fino a 4pi}
       while ang<=6.28/(ad/n) do
         begin
         ang:=ang+0.01;
         px:=x;
         py:=y;
         x:=x+1;        {attenzione!!! ad deve essere riportato in while ang<=6.28/ad do}
         y:=y1-trunc (r*sin(ang*ad*w+f));
         moveto (px,py);
         lineto (x,y);
       end;
end;


procedure ARMONICA (x1,y1,r:integer; w:real; i:integer;arm:integer);
                   {x1,y1: coord. iniziali, r:ampiezza, w:periodo della fondamentale i:colore, arm:tipo arm.}
var
px,py,x,y,ad:integer;
ang:real;
begin
       ang:=0;
       x:=x1;
       y:=y1;
       ad:=3;  {grandezza del grafico}
       setcolor (i);
       {NOTA: dovrebbe essere ...ang<=6.28/ad... ma cos si considera solo un}
       {      ciclo 2pi, invece  ...(ad/2)... raddoppia il ciclo e disegna fino a 4pi}
       while ang<=6.28/(ad/2) do
       begin
       ang:=ang+0.01;
       px:=x;
       py:=y;
       x:=x+1;        {attenzione!!! ad deve essere riportato in while ang<=6.28/ad do}
       y:=y1-trunc (r*sin(ad*ang*w)+(r/2)*sin(arm*w*ang*ad));
       moveto (px,py);
       lineto (x,y);
       end;
end;

procedure BATTIMENTI (x1,y1,r:integer; w1,w2: integer; i:integer);
                   {x1,y1: coord. iniziali, r:ampiezza, w:periodo della fondamentale i:colore, arm:tipo arm.}
var
px,py,x,y,ad:integer;
ang:real;
begin
       ang:=0;
       x:=x1;
       y:=y1;
       ad:=3;  {grandezza del grafico}
       setcolor (i);
       {NOTA: dovrebbe essere ...ang<=6.28/ad... ma cos si considera solo un}
       {      ciclo 2pi, invece  ...(ad/2)... raddoppia il ciclo e disegna fino a 4pi}
       while ang<=6.28/(ad/2) do
       begin
       ang:=ang+0.01;
       px:=x;
       py:=y;
       x:=x+1;        {attenzione!!! ad deve essere riportato in while ang<=6.28/ad do}
       y:=y1-trunc (r*sin(ad*w1*ang)+r*sin(ad*w2*ang));
       moveto (px,py);
       lineto (x,y);
       end;
end;

function inserisci(x1,y1:integer):real;
var
i, cod:integer;
p:real;
ciclo:integer;      {ciclo=1 -> si / ciclo=0 ->no}
t:string[5];
k:char;
begin
       i:=0;
       t:='';
       outtextxy (x1,y1,'-');
       ciclo:=1;
     while ciclo=1 do
      begin
       k:=readkey;
       if (ord(k)>=48) and (ord(K)<=57) then
        if i<=4 then
        begin
        t:=t+k;
        i:=i+1;
        setfillstyle (SolidFill,1);
        bar (x1,y1,x1+14*i,y1+8);
        outtextxy (x1,y1,t+'-');
        end;
      if k=#8 then
       if i>0 then
        begin
        setfillstyle (SolidFill,1);
        bar (x1,y1,x1+14*i,y1+8);
        i:=i-1;
        t:=copy (t, 1,i);
        outtextxy (x1,y1,t+'-');
       end;
       if k=#13 then
       begin
       if i>0 then
       ciclo:=0
       else
       sound (900);delay(100);nosound
       end;
       if k=#46 then
        begin
        t:=t+k;
        i:=i+1;
        setfillstyle (SolidFill,1);
        bar (x1,y1,x1+14*i,y1+8);
        outtextxy (x1,y1,t+'-');
        end;
        end;
val (t,p,cod);
inserisci:=p;
setfillstyle (SolidFill,1);
bar (x1,y1,x1+14*i,y1+8);
outtextxy (x1,y1,t);
end;

Procedure SCRIVI (x1,y1:integer; c: string; color:integer); {simula macchina da scrivere}
    Var i,s:integer;
    Begin
     SetColor(color);
     SetTextStyle (0,Horizdir,1);
     s:=textwidth('a');
     For i:=1 to length(c) do
     begin
       OutTextXY (x1+s*i,y1,copy (c,i,1));
       Delay (5);
       end;
    end;

procedure TITOLO (s: string);
var
i:integer;
begin
      setcolor (15);
      SetTextStyle (3, HorizDir,4);
      i:=TextWidth (s);
      OutTextXY(trunc((GetMaxX-i)/2),0,s);
      setcolor (3);
      line (0,35,getmaxx,35);
end;

procedure Ptasto;  {Premere il tasto <RETURN>}
var
i:integer;
k:char;
begin
      setcolor (14);
      line (0,(getmaxy-20),getmaxX,(getmaxy-20));
      SetTextStyle (0, HorizDir,1);
      i:=TextWidth ('premere <RETURN>');
      OutTextXY(trunc((GetMaxX-i)),getmaxy-15,'premere <RETURN>');
      repeat
      k:=readkey;
      until k=#13;
end;

procedure Vtasti;  {Visualizza tasti frecce/ <RETURN>}
var
i:integer;
k:char;
begin
      setcolor (14);
      line (0,(getmaxy-20),getmaxX,(getmaxy-20));
      SetTextStyle (0, HorizDir,1);
      i:=TextWidth ('usa i tasti x x x x <RETURN> per confermare');
      OutTextXY(trunc((GetMaxX-i)),getmaxy-15,'usa i tasti '+#27+' '+#26+' '+#24+' '+#25+' <RETURN> per confermare');
end;

procedure Mwindow(x1, y1, x2, y2 :integer; c:integer);
begin
setcolor (c);
setfillstyle (SolidFill,1);
bar (x1,y1,x2,y2);
Rectangle (x1, y1, x2, y2);
setfillstyle (SolidFill,15);
bar (x1+4,y2+1, x2+4,y2+4);
bar (x2+1,y1+4,x2+5,y2+4);
end;

PROCEDURE reverse(elem, Wx1, Wy1:integer);
var
s:integer;
begin
s:=Wy1+elem*14;
setfillstyle(1,4);
bar(Wx1+5,s,Wx1+5+TextWidth (scelta[elem]),s+textheight (scelta[elem]));
setcolor(15);
settextstyle (0,Horizdir,1);
outtextxy(Wx1+5,s,scelta[elem]);
setcolor(15);
end;

PROCEDURE normale(elem, Wx1, Wy1:integer);
var
s:integer;
begin
s:=Wy1+elem*14;
setfillstyle(1,1);
bar(Wx1+5,s,Wx1+5+TextWidth (scelta[elem]),s+textheight (scelta[elem]));
setcolor(15);
settextstyle (0,Horizdir,1);
outtextxy(Wx1+5,s,scelta[elem]);
setcolor(15);
end;

Var                            { PROGRAMMA PRINCIPALE }
gd, gm:integer;
ErrCode: integer;
i:integer;
s:integer;
ss:string[4];

wlu, wla: integer;             {LUnghezza e LArghezza della WINDOW}
wx1, wy1, wx2, wy2: integer;   {coordinate logiche della WINDOW}

m:integer;    {scelta menu}
pm:integer;   {scelta menu vecchia}

lp:integer;  {ciclo principale}
lm:integer;  {ciclo tasti menu}
lk:integer;  {ciclo generico}

k:char; {variabile tasto}
f:real; {fi}

c:string;

CoordArco: ArcCoordsType;

ang:real;
r, w, x, y, px, py:integer;
ad:integer; {valore grandezza/zoom del grafico}
t:string[3]; {stringa dati dei parametri}

begin
{inizializza il modo grafico EGA 640x350 16 col 2 pagine}
   gd := 9;
   gm := 1;
   InitGraph(gd,gm,'');
   ErrCode := GraphResult;
   if ErrCode <> grOk then
      begin
       writeln ('SCHEDA GRAFICA EGA 64k NON PRESENTE');
       repeat until keypressed;
      end;

      {presentazione iniziale e titoli}
      SetBkColor (1);

      setcolor (15);
      SetTextStyle (3, HorizDir,4);
      i:=TextWidth ('OSCILLAZIONI ED ONDE');
      OutTextXY(trunc((GetMaxX-i)/2),100,'OSCILLAZIONI ED ONDE');

      setcolor (3);
      line (trunc((GetMaxX-i)/2),140,trunc((GetMaxX-i)/2)+i,140);

      setcolor (15);
      SetTextStyle (0, HorizDir,1);
      i:=TextWidth ('(C)1991 Stefano Fazzino Soft');
      OutTextXY(trunc((GetMaxX-i)/2),142,'(C)1991 Stefano Fazzino Soft');


      setcolor (3);
      SetTextStyle (0, HorizDir,1);
      i:=TextWidth ('VERSIONE 0.92 (beta test EGA64k)');
      OutTextXY(trunc((GetMaxX-i)/2),290,'VERSIONE 0.92 (beta test EGA64k)');


      setcolor (15);
      SetTextStyle (0, HorizDir,1);
      str(sn:4,ss);
      i:=TextWidth ('Serial N. '+ss);
      OutTextXY(trunc((GetMaxX-i)/2),300,'Serial N. '+ss);

      Ptasto;  {premere RETURN}
      lp:=1;

      {MENU PRINCIPALE}
      while lp=1 do begin
      cleardevice;

      setcolor (15);
      SetTextStyle (3, HorizDir,4);
      i:=TextWidth ('MENU PRINCIPALE');
      OutTextXY(trunc((GetMaxX-i)/2),0,'MENU PRINCIPALE');

      WLA:=250;
      WLU:=160;

      wx1:=trunc ((GETMAXX-WLA)/2);
      wy1:=trunc ((GETMAXY-WLU)/2);
      wx2:=trunc ((GETMAXX-WLA)/2)+WLA;
      wy2:=trunc ((GETMAXY-WLU)/2)+WLU;

      Mwindow (wx1,wy1, wx2,wy2,15);

      {display menu}
      Vtasti;
      setcolor (15);
      settextstyle (0,Horizdir,1);
      for i:=1 to 10 do
      begin
      s:=Wy1+i*14;
      outtextxy(Wx1+5,s,scelta[i]);
      end;

      {seleziona menu}
      lm:=0;     {controllo ciclo menu}
      m:=1;
      pm:=1;
      reverse (m,Wx1,Wy1);
    repeat
      k:=readkey;
      pm:=m;
      normale (pm,Wx1,Wy1);

     if k=#13 then
      begin
      sound(900);
      delay(10); nosound;
      lm:=1
      end;

      if k=#0 then
       begin
         k:=readkey;
          if k=#80 then m:=m+1;
          if k=#72 then m:=m-1;
         if m<1 then m:=10;
         if m>10 then m:=1;
         reverse (m,Wx1,Wy1);
         lm:=0;
       end
      else
       reverse (m,Wx1,Wy1);

     until (lm=1);

     if m=1 then
      begin
       cleardevice;
       titolo ('INTRODUZIONE');
       setcolor(15);
       scrivi (55, 60,'Tutti i possibili movimenti oscillatori si possono ridurre alla',7);
       scrivi (55, 73,'composizione di due o pi— moti armonici semplici.',7);
       scrivi (55, 89,'Un punto si muove di moto armonico semplice quando, ad ogni',15);
       scrivi (55,102,'istante Š la proiezione sopra un diametro di un punto dota-',15);
       scrivi (55,115,'to di moto circolare uniforme.',15);
       ptasto;

       cleardevice;
       titolo ('INTRODUZIONE');
       setcolor(15);
       scrivi (55,60,'EQUAZIONE ORARIA DEL MOTO:',15);
       scrivi (240,226,'Il punto P percorre la circonferenza in senso',7);
       scrivi (240,239,'antiorario con moto uniforme.',7);
       scrivi (240,252,'La sua proiezione M, il cui moto sar… quello',7);
       scrivi (240,265,'armonico semplice, percorre il diametro ver-',7);
       scrivi (240,278,'ticale AB.',7);

       setcolor (7);
       line (50,200,350,200);   {asse X}
       line (175,100,175,300);  {asse Y}

       circle (175,200,70);
       setcolor (15);
       arc (175,200,10,70,100);
       GetArcCoords (CoordArco);
       with CoordArco do line (Xend,Yend,Xend+10,Yend+10);
       with CoordArco do line (Xend,Yend,Xend+15,Yend-5);

       setcolor (15);
       putpixel (235,172,15);
       setlinestyle (1,1,1);
       line (175,200,235,172);
       line (235,172,175,172);
       setlinestyle (0,1,1);
       outtextxy (162,205,'O');
       outtextxy (240,165,'P');
       outtextxy (162,165,'M');
       outtextxy (250,190,'C');
       outtextxy (92,190,'D');
       outtextxy (161,136,'A');
       outtextxy (161,260,'B');
       scrivi (280,110,'OM = spostamento o elongazione',15);
       scrivi (280,123,'OA = spostamento positivo',15);
       scrivi (280,136,'OB = spostamento negativo',15);
       scrivi (280,149,' O = origine degli spazi',15);
       ptasto;

       setfillstyle (SolidFill,1);
       bar (240,226,640,300);
       bar (0,GetMaxY-20,GetMaxX,GetMaxY);
       scrivi (240,226,'All'+#39+'origine dei tempi, cioŠ per t=0, il punto',7);
       scrivi (240,239,'M passa per l'+#39+'origine degli spazi O. Dopo un ',7);
       scrivi (240,252,'intervallo di tempo t, il punto P avr… per-',7);
       scrivi (240,265,'corso l'+#39+'arco CP e il punto M il tratto OM di',7);
       scrivi (240,278,'spostamento s.',7);
       ptasto;

       cleardevice;
       titolo ('INTRODUZIONE');
       setcolor(15);
       scrivi (55, 60,'EQUAZIONE ORARIA DEL MOTO:',15);
       scrivi (55, 78,'s=rsen(wt)',15);
       scrivi (55, 96,'Lo spostamento s nel moto armonico Š funzione sinusoidale',15);
       scrivi (55,109,'del tempo.',15);
       scrivi (55,127,'L'+#39+'angolo à=wt Š detto angolo di fase, o pi— semplicemente',15);
       scrivi (55,140,'fase del moto.',15);
       scrivi (55,158,'La grandezza r viene detta ampiezza del moto.',15);
       ptasto;

       cleardevice;
       titolo ('INTRODUZIONE');
       setcolor(15);
       scrivi (55, 60,'EQUAZIONE ORARIA DEL MOTO:',15);

       scrivi (240,226,'Si supponga ora che all'+#39+'istante t=0 il punto p',7);
       scrivi (240,239,'sia nella posizione iniziale I. In tal caso si',7);
       scrivi (240,252,'dice che il moto armonico presenta una fase i-',7);
       scrivi (240,265,'niziale é.',7);

       setcolor (7);
       line (50,200,350,200);   {asse X}
       line (175,100,175,300);  {asse Y}

       circle (175,200,70);
       setcolor (15);
       arc (175,200,10,70,100);
       GetArcCoords (CoordArco);
       with CoordArco do line (Xend,Yend,Xend+10,Yend+10);
       with CoordArco do line (Xend,Yend,Xend+15,Yend-5);

       setcolor (15);
       putpixel (241,182,15);
       setlinestyle (1,1,1);
       line (175,200,241,182);
       line (241,182,175,182);
       setlinestyle (0,1,1);
       outtextxy (162,205,'O');
       outtextxy (245,175,'I');
       outtextxy (162,175,'I'+#39);
       outtextxy (250,190,'C');
       outtextxy (92,190,'D');
       outtextxy (161,136,'A');
       outtextxy (161,260,'B');
       putpixel (222,160,15);
       setlinestyle (1,1,1);
       line (175,200,222,160);
       line (222,160,175,160);
       outtextxy (230,153,'P');
       outtextxy (162,153,'M');
       setfillstyle (SolidFill,4);
       pieslice (175,200,20,47,70);
       line (175,200,241,182);
       line (241,182,175,182);
       setlinestyle (0,1,1);
       scrivi (280,110,'Ang. POI=à - Ang. IOC=é',15);
       scrivi (280,123,'s=r sen (à+é)',7);
       scrivi (280,136,'s=r sen (wt+é)',15);
       ptasto;

       end;

       if m=2 then
       begin
       cleardevice;
       titolo ('MOTO ARMONICO SEMPLICE');
       setcolor(15);
       scrivi (55, 60,'EQUAZIONE ORARIA DEL MOTO: s=r sen (wt+é)',15);

       setcolor (7);
       line (70,120,70,270);
       line (0,200,550,200);

       ang:=0;
       x:=70;
       y:=200;

       r:=45;  {ampiezza}
       ad:=3;  {grandezza del grafico}

       setcolor (15);

       {NOTA: dovrebbe essere ...ang<=6.28/ad... ma cos si considera solo un}
       {      ciclo 2pi, invece  ...(ad/2)... raddoppia il ciclo e disegna fino a 4pi}
       while ang<=6.28/(ad/2) do

       begin
       ang:=ang+0.01;

       px:=x;
       py:=y;

       x:=x+1;        {attenzione!!! ad deve essere riportato in while ang<=6.28/ad do}
       y:=200-trunc (r*sin(ad*ang));

       moveto (px,py);
       lineto (x,y);
       end;
       {disegna la griglia}
                                  {NOTA: (6.28/ad) rappresenta 2pi e quindi}
       ang:=(6.28/ad)/4;          {      pi/2 Š (6.28/ad)/4.}
       y:=200-trunc (r*sin(ad*ang));
       setlinestyle (1,1,1);
       line (70,y,488,y);
       py:=200+trunc (r*sin(ad*ang));
       line (70,py,488,py);
       line (279,y,279,py);
       line (488,y,488,py);
       setcolor (15);
       outtextxy(285,203,'T'+#39);
       outtextxy(494,203,'T'+#39+#39);
       setlinestyle (0,1,1);

       outtextxy(60,203,'O');
       outtextxy(60,y,'A');
       outtextxy(540,203,'t');
       outtextxy(60,120,'s');
       scrivi (400,110,'OA = ampiezza r',15);
       ptasto;

       {2}
       cleardevice;
       setcolor (7);
       line (70,120,70,270);
       line (0,200,550,200);
       titolo ('MOTO ARMONICO SEMPLICE');
       setcolor(15);
       scrivi (45, 60,'EQUAZIONE ORARIA DEL MOTO: s=r sen (2ãvt+é)',15);

       lk:=1;   {ciclo}

  while lk=1 do begin    {200,250,400,300}

       Mwindow (400,50,600,100,7);
       scrivi (400,51,'r:',15);
       scrivi (400,63,'v:',15);
       scrivi (400,76,'é:',15);
       scrivi (400,89,'COLORE:',15);

     r:=trunc (inserisci (426,51));
       while r>80 do begin
       sound (900); delay (100); nosound;
       setfillstyle (SolidFill,1);
       bar (426,50,426+14*10,51+8);
       r:=trunc (inserisci (426,51));
       end;

     w:=trunc (inserisci (426,63));

     f:=inserisci(426,76);

     i:=trunc (inserisci (468,89));
       while i>15 do begin
       sound (900); delay (100); nosound;
       setfillstyle (SolidFill,1);
       bar (468,89,468+14*7,89+8);
       i:=trunc (inserisci (468,89));
       end;


       setfillstyle (SolidFill,1);
       bar (400,50,605,105);

       ONDA (70,200,r,w,i,2,f);
       outtextxy(285,203,'T'+#39);

       Mwindow (400,50,600,100,7);
       scrivi (400,75,'Altri Grafici? (S/N)',15);
       k:=readkey;
       if (k=#78) or (k=#110) then lk:=0;

   end;
     end;

       if m=5 then
       begin
       cleardevice;
       titolo ('ONDE ARMONICHE');
       setcolor(15);
       scrivi (55, 60,'UN ONDA E'+#39+' ARMONICA DI UN ALTRA, DETTA FONDAMENTALE,',15);
       scrivi (55, 73,'SE LA SUA FREQUENZA E'+#39+' MULTIPLA SECONDO UN NUMERO INTERO',15);
       scrivi (55, 86,'DELLA FREQUENZA DELLA PRIMA.',15);
       scrivi (55,103,'In generale: se un moto oscillatorio ha frequenza v1, le sue',13);
       scrivi (55,116,'armoniche hanno frequenza v=kv1.',13);
       scrivi (55,129,'Precisamente, per k=2, 3, 4... si hanno rispettivamente la',13);
       scrivi (55,142,'seconda, la terza, la quarta armonica.',13);
       scrivi (55,159,'Se le oscillazioni armoniche hanno la stessa direzione, il moto',7);
       scrivi (55,172,'risultante Š periodico, ma il diagramma della risultante varia',7);
       scrivi (55,185,'col variare della specie delle armoniche componenti.',7);
       PTASTO;

       cleardevice;
       titolo ('ONDE ARMONICHE');

       setcolor (7);
       line (70,120,70,270);
       line (0,200,550,200);

       ONDA (70,200,80,1,9,2,0);
       scrivi (270,50,'FONDAMENTALE     y=80 sen(2ã1 t)',9);

       ONDA (70,200,40,2,5,2,0);
       scrivi (270,63,'SECONDA ARMONICA y=40 sen(2ã2 t)',5);

       ARMONICA (70,200,80,1,15,2);
       scrivi (270,76,'RISULATANTE  y=80 sen(2ã1 t)+ 40 sen (2ã2 t)',15);

       ptasto;


       cleardevice;
       titolo ('ONDE ARMONICHE');

       setcolor (7);
       line (70,120,70,270);
       line (0,200,550,200);

       ONDA (70,200,80,1,9,2,0);
       scrivi (270,50,'FONDAMENTALE   y=80 sen(2ã1 t)',9);

       ONDA (70,200,40,3,5,2,0);
       scrivi (270,63,'TERZA ARMONICA y=40 sen(2ã3 t)',5);

       ARMONICA (70,200,80,1,15,3);
       scrivi (270,76,'RISULATANTE    y=80 sen(2ã1 t)+ 40 sen(2ã3 t)',15);

       ptasto;

       lk:=1;

       while lk=1 do
       begin

       cleardevice;
       titolo ('ONDE ARMONICHE');

       setcolor (7);
       line (70,120,70,270);
       line (0,200,550,200);

       Mwindow (400,50,600,100,7);
       scrivi (400,75,'TIPO DI ARMONICA:',15);
       i:=trunc (inserisci(543,75));

       ARMONICA (70,200,80,1,15,i);

       Mwindow (400,50,600,100,7);
       scrivi (400,75,'Altri Grafici? (S/N)',15);
       k:=readkey;
       if (k=#78) or (k=#110) then lk:=0;
       end;
       end;

       if m=4 then begin
       cleardevice;
       titolo ('BATTIMENTI');

       scrivi (26, 50,'Se si fanno vibrare due lamine con periodo leggermente diverso',7);
       scrivi (26, 63,'l'+#39+'ampiezza delle oscillazioni risultanti va alternativamente',7);
       scrivi (26, 76,'aumentando e diminuendo. Tale condizione si pu• anche verifi-',7);
       scrivi (26, 89,'care, ad esempio, quando due tasti adiacenti di un pianoforte',7);
       scrivi (26,102,'sono battuti simultaneamente.',7);

       ptasto;
       cleardevice;
       titolo ('BATTIMENTI');

       scrivi (26,50,'Equazione y1=r sen (2ãv1t+é)',15);
       scrivi (26,63,'Equazione y2=r sen (2ãv2t+é)',12);

       setcolor (7);

      {line (70,1,70,85);
       line (0,43,500,43);}

       line (70,87,70,171);
       line (0,129,500,129);

       line (70,204,70,292);
       line (70,248,500,248);

       ONDA (70,129,40,8,15,2,0); {70,43}
       ONDA (70,129,40,9,12,2,0);

       battimenti (70,248,40,8,9,14);


       ptasto;

       end;

       if m=3 then begin

       cleardevice;
       titolo ('INTERFERENZA');

       scrivi (26, 50,'L'+#39+'interferenza consiste nella composizione di due moti armonici',15);
       scrivi (26, 63,'semplici della stessa direzione e dello stesso periodo.',15);
       scrivi (26, 76,'Se le oscillazioni componenti sono in concordanza di fase, le',15);
       scrivi (26, 89,'loro ampiezze si sommano.',15);
       scrivi (26,102,'Se invece sono in opposizione di fase, si sottraggono e in que-',15);
       scrivi (26,115,'sto caso si elidono completamente se inizialmente avevano la stes-',15);
       scrivi (26,128,'sa ampiezza.',15);
       ptasto;

       cleardevice;
       titolo ('INTERFERENZA');

       setcolor (7);
       line (70,120,70,270);
       line (0,200,550,200);

       onda (70,200,30,1,10,2,0);
       onda (70,200,50,1,12,2,0);
       onda (70,200,80,1,15,2,0);

       scrivi (26, 50,'INTERFERENZA POSITIVA O COSTRUTTIVA  y=y1+y2',15);
       scrivi (26, 63,'Equazione: y1=r1 sen (wt+é)',10);
       scrivi (26, 76,'Equazione: y2=r2 sen (wt+é)',12);
       scrivi (26, 89,'Risultante: y=(r1+r2) sen (wt+é)',15);

       ptasto;

       cleardevice;
       titolo ('INTERFERENZA');

       setcolor (7);
       line (70,120,70,270);
       line (0,200,550,200);

       onda (70,200,70,1,10,2,0);
       onda (70,200,30,1,12,2,3.14);
       onda (70,200,40,1,15,2,0);

       scrivi (26, 50,'INTERFERENZA NEGATIVA O DISTRUTTIVA y=y1-y2',15);
       scrivi (26, 63,'Equazione: y1=r1 sen (wt+é)',10);
       scrivi (26, 76,'Equazione: y2=r2 sen [(wt+é)+ã]',12);
       scrivi (26, 89,'Risultante: y=(r1-r2) sen (wt+é)',15);


       ptasto;

       cleardevice;
       titolo ('INTERFERENZA');

       setcolor (7);
       line (70,120,70,270);
       line (0,200,550,200);

       onda (70,200,70,1,10,2,0);
       onda (70,200,70,1,12,2,3.14);
       onda (70,200,0,1,15,2,0);

       scrivi (26, 50,'INTERFERENZA COMPLETA y=0',15);
       scrivi (26, 63,'Equazione: y1=r sen (wt+é)',10);
       scrivi (26, 76,'Equazione: y2=r sen [(wt+é)+ã]',12);
       scrivi (26, 89,'Risultante: y=(r-r) sen (wt+é) -> y=0',15);

       ptasto

       end;

       if m=6 then begin
       cleardevice;
       titolo ('ONDE COMPLESSE');

       scrivi (26, 63,'Le onde sino ad ora considerate sono del tipo armonico, nel quale',15);
       scrivi (26, 76,'gli spostamenti ad un qualsiasi istante sono rappresentati da una',15);
       scrivi (26, 89,'funzione sinusoidale. Abbiamo visto che la sovrapposizione di onde',15);
       scrivi (26,102,'di frequenza e di velocit… eguali, e di ampiezza e fasi arbitrarie,',15);
       scrivi (26,115,'d… ancora luogo ad un onda risultante dello stesso tipo.',15);
       scrivi (26,128,'Se invece si sovrappongono onde di frequenza diversa, l'+#39+'onda risul-',15);
       scrivi (26,141,'tante Š complessa, e il movimento delle particelle non Š pi— un moto',15);
       scrivi (26,154,'armonico, e la forma dell'+#39+'onda non Š pi— una funzione sinusoidale.',15);
       ptasto;

       cleardevice;
       titolo('ONDE COMPLESSE');

       onda(70,200,40,1,9,2,0);
       onda(70,200,40,3,5,2,0);
       onda(70,200,40,5,6,2,pi/2);



       setcolor (7);
       line (70,120,70,270);
       line (0,200,550,200);

       ang:=0;
       x:=70;
       y:=200;

       r:=45;  {ampiezza}
       ad:=3;  {grandezza del grafico}

       setcolor (15);

       {NOTA: dovrebbe essere ...ang<=6.28/ad... ma cos si considera solo un}
       {      ciclo 2pi, invece  ...(ad/2)... raddoppia il ciclo e disegna fino a 4pi}
       while ang<=6.28/(ad/2) do

       begin
       ang:=ang+0.01;

       px:=x;
       py:=y;

       x:=x+1;        {attenzione!!! ad deve essere riportato in while ang<=6.28/ad do}
       y:=200-trunc (30*sin(ad*ang*1)+40*sin(ad*ang*3)+40*sin(ad*ang*5+pi/2));

       moveto (px,py);
       lineto (x,y);
       end;

       ptasto;
       end;

       if m=10 then begin
       closegraph;
       lp:=0;
       end;

   end;
   end.
