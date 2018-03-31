Program Onde(input,output);

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
'FIGURE DI LISSAJOUS...........',            {f:fi                          }
'..............................',
'USCITA........................');

procedure ONDA (x1,y1,r:integer; w:real; i:integer; n:integer; f:real);

var px,py,x,y,ad:integer;
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

procedure LISSAJOUS (v1, v2, risol:integer);

var
r,x,y,px, py, lk:integer;


begin
       r:=0;
       x:=70;
       y:=200;

       setcolor (15);

       lk:=1;

       { NOTA: 24, 25: frequenze dei moti. 1000 risoluzione. 100 fattore di ingrandimento}

       while r<=risol+1 do

       begin

       r:=r+1;

       if lk=0 then begin
       px:=200-x;
       py:=80+y;
       end;


        x:=trunc (140*sin (2*pi*v1*(r/risol)));
        y:=trunc ( 65*cos (2*pi*v2*(r/risol)));

        if lk=0 then begin
        moveto (px,py);
        lineto (200-x,80+y);
        end;

        lk:=0;

       {putpixel (200-x,200+y,15);}
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
        setfillstyle (SolidFill,0);
        bar (x1,y1,x1+14*i,y1+8);
        outtextxy (x1,y1,t+'-');
        end;

      if k=#8 then
       if i>0 then
        begin
        setfillstyle (SolidFill,0);
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
        setfillstyle (SolidFill,0);
        bar (x1,y1,x1+14*i,y1+8);
        outtextxy (x1,y1,t+'-');
        end;

        end;

val (t,p,cod);
inserisci:=p;
setfillstyle (SolidFill,0);
bar (x1,y1,x1+14*i,y1+8);
outtextxy (x1,y1,t);


end;


procedure scrivi (x1,y1:integer; c: string; color:integer); {simula macchina da scrivere}
    var
     i,s:integer;

    begin
     setcolor(color);
     settextstyle (0,Horizdir,1);
     s:=textwidth('a');

     for i:=1 to length(c) do
     begin
     outtextxy (x1+s*i,y1,copy (c,i,1));
     delay (1);
     end;
    end;

procedure TITOLO (s: string);
var
i:integer;

begin
      setcolor (15);
      SetTextStyle (0, HorizDir,1);
      i:=TextWidth (s);
      OutTextXY(trunc((GetMaxX-i)/2),0,s);

      setcolor (3);
      line (0,13,getmaxx,13);

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
setcolor (15);
Rectangle (x1, y1, x2, y2);

end;


PROCEDURE reverse(elem, Wx1, Wy1:integer);

var
s:integer;

begin
s:=Wy1+elem*14;

setfillstyle(1,4);
bar(Wx1+5,s,Wx1+5+TextWidth (scelta[elem]),s+textheight (scelta[elem]));
setcolor(0);
settextstyle (0,Horizdir,1);
outtextxy(Wx1+5,s,scelta[elem]);
setcolor(15);

end;


PROCEDURE normale(elem, Wx1, Wy1:integer);

var
s:integer;

begin
s:=Wy1+elem*14;

setfillstyle(1,0);
bar(Wx1+5,s,Wx1+5+TextWidth (scelta[elem]),s+textheight (scelta[elem]));
setcolor(15);
settextstyle (0,Horizdir,1);
outtextxy(Wx1+5,s,scelta[elem]);
setcolor(15);

end;

{********************************************************************}
{                       PROGRAMMA PRINCIPALE                         }

var

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
{inizializza il modo grafico CGA}
   gd :=CGA;
   gm :=CGAHi;
   InitGraph(gd,gm,'');

      {presentazione iniziale e titoli}
      SetBkColor (0);

      setcolor (15);
      SetTextStyle (3, HorizDir,4);
      i:=TextWidth ('OSCILLAZIONI ED ONDE');
      OutTextXY(trunc((GetMaxX-i)/2),100,'OSCILLAZIONI ED ONDE');

      setcolor (15);
      line (trunc((GetMaxX-i)/2),140,trunc((GetMaxX-i)/2)+i,140);

      setcolor (15);
      SetTextStyle (0, HorizDir,1);
      i:=TextWidth ('(C)1991 Stefano Fazzino Soft');
      OutTextXY(trunc((GetMaxX-i)/2),142,'(C)1991 Stefano Fazzino Soft');


      setcolor (15);
      SetTextStyle (0, HorizDir,1);
      i:=TextWidth ('VERSIONE 0.92 (beta test EGA64k)');
      OutTextXY(trunc((GetMaxX-i)/2),40,'VERSIONE 0.92 (beta test CGA)');


      setcolor (15);
      SetTextStyle (0, HorizDir,1);
      str(sn:4,ss);
      i:=TextWidth ('Serial N. '+ss);
      OutTextXY(trunc((GetMaxX-i)/2),53,'Serial N. '+ss);

      Ptasto;  {premere RETURN}
      lp:=1;

      {MENU PRINCIPALE}
      while lp=1 do begin
      cleardevice;

      setcolor (15);
      titolo  ('MENU PRINCIPALE');

      WLA:=250;
      WLU:=140;

      wx1:=trunc ((GETMAXX-WLA)/2);
      wy1:=10;
      wx2:=trunc ((GETMAXX-WLA)/2)+WLA;
      wy2:=trunc ((GETMAXY-WLU)/2)+WLU;

      Mwindow (wx1,18, wx2,wy2,0);

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
       scrivi (55, 15,'Tutti i possibili movimenti oscillatori si possono ridurre alla',7);
       scrivi (55, 28,'composizione di due o pi— moti armonici semplici.',7);
       scrivi (55, 42,'Un punto si muove di moto armonico semplice quando, ad ogni',15);
       scrivi (55, 55,'istante Š la proiezione sopra un diametro di un punto dota-',15);
       scrivi (55, 68,'to di moto circolare uniforme.',15);
       ptasto;

       cleardevice;
       titolo ('INTRODUZIONE');
       setcolor(15);
       scrivi (55, 15,'EQUAZIONE ORARIA DEL MOTO:',15);
       scrivi (55, 28,'s=rsen(wt)',15);
       scrivi (55, 42,'Lo spostamento s nel moto armonico Š funzione sinusoidale',15);
       scrivi (55, 55,'del tempo.',15);
       scrivi (55, 68,'L'+#39+'angolo à=wt Š detto angolo di fase, o pi— semplicemente',15);
       scrivi (55, 81,'fase del moto.',15);
       scrivi (55, 94,'La grandezza r viene detta ampiezza del moto.',15);
       ptasto;

       cleardevice;
       titolo ('INTRODUZIONE');
       setcolor(15);
       scrivi (55, 15,'EQUAZIONE ORARIA DEL MOTO:',15);

       scrivi (240,28,'Si supponga ora che all'+#39+'istante t=0 il punto p',7);
       scrivi (240,42,'sia nella posizione iniziale I. In tal caso si',7);
       scrivi (240,55,'dice che il moto armonico presenta una fase i-',7);
       scrivi (240,68,'niziale é.',7);

       ptasto;
       end;

       if m=2 then
       begin
       cleardevice;
       titolo ('MOTO ARMONICO SEMPLICE');
       setcolor(15);
       scrivi (55, 15,'EQUAZIONE ORARIA DEL MOTO: s=r sen (wt+é)',15);

       setcolor (15);
       line (70,30,70,160);
       line (0,105,550,105);

       ang:=0;
       x:=70;
       y:=105;

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
       y:=105-trunc (r*sin(ad*ang));

       moveto (px,py);
       lineto (x,y);
       end;
       {disegna la griglia}
                                  {NOTA: (6.28/ad) rappresenta 2pi e quindi}
       ang:=(6.28/ad)/4;          {      pi/2 Š (6.28/ad)/4.}
       y:=105-trunc (r*sin(ad*ang));
       setlinestyle (1,1,1);
       line (70,y,488,y);
       py:=105+trunc (r*sin(ad*ang));
       line (70,py,488,py);
       line (279,y,279,py);
       line (488,y,488,py);
       setcolor (15);
       outtextxy(285,108,'T'+#39);
       outtextxy(494,108,'T'+#39+#39);
       setlinestyle (0,1,1);

       outtextxy(60,108,'O');
       outtextxy(60,y,'A');
       outtextxy(540,108,'t');
       outtextxy(60,30,'s');
       scrivi (400,40,'OA = ampiezza r',15);
       ptasto;

       {2}
       cleardevice;
       setcolor (15);
       line (70,30,70,160);
       line (0,105,550,105);
       titolo ('MOTO ARMONICO SEMPLICE');
       setcolor(15);
       scrivi (25,15,'EQUAZIONE ORARIA DEL MOTO: s=r sen (2ãvt+é)',15);

       lk:=1;   {ciclo}

  while lk=1 do begin    {200,250,400,300}
       setfillstyle (SolidFill,0);
       bar (400,15,605,55);


       scrivi (400,15,'r:',15);
       scrivi (400,28,'v:',15);
       scrivi (400,42,'é:',15);

     r:=trunc (inserisci (426,15));
       while r>80 do begin
       sound (900); delay (100); nosound;
       setfillstyle (SolidFill,0);
       bar (426,15,426+14*10,51+15);
       r:=trunc (inserisci (426,15));
       end;

     w:=trunc (inserisci (426,28));

     f:=inserisci(426,42);

     i:=15;


       setfillstyle (SolidFill,0);
       bar (400,15,605,55);

       ONDA (70,105,r,w,i,2,f);
       outtextxy(285,108,'T'+#39);

       scrivi (400,15,'Altri Grafici? (S/N)',15);
       k:=readkey;
       if (k=#78) or (k=#110) then lk:=0;

   end;
     end;

       if m=5 then
       begin
       cleardevice;
       titolo ('ONDE ARMONICHE');
       setcolor(15);
       scrivi (55, 15,'UN ONDA E'+#39+' ARMONICA DI UN ALTRA, DETTA FONDAMENTALE,',15);
       scrivi (55, 28,'SE LA SUA FREQUENZA E'+#39+' MULTIPLA SECONDO UN NUMERO INTERO',15);
       scrivi (55, 42,'DELLA FREQUENZA DELLA PRIMA.',15);
       scrivi (55, 55,'In generale: se un moto oscillatorio ha frequenza v1, le sue',13);
       scrivi (55, 68,'armoniche hanno frequenza v=kv1.',13);
       scrivi (55, 81,'Precisamente, per k=2, 3, 4... si hanno rispettivamente la',13);
       scrivi (55, 94,'seconda, la terza, la quarta armonica.',13);
       scrivi (55,107,'Se le oscillazioni armoniche hanno la stessa direzione, il moto',7);
       scrivi (55,120,'risultante Š periodico, ma il diagramma della risultante varia',7);
       scrivi (55,133,'col variare della specie delle armoniche componenti.',7);
       PTASTO;

       cleardevice;
       titolo ('ONDE ARMONICHE');

       setcolor (15);
       line (70,30,70,160);
       line (0,105,550,105);

       ONDA (70,105,60,1,15,2,0);
       scrivi (270,15,'FONDAMENTALE     y=60 sen(2ã1 t)',15);

       ONDA (70,105,40,2,15,2,0);
       scrivi (270,28,'SECONDA ARMONICA y=40 sen(2ã2 t)',15);

       ARMONICA (70,105,60,1,15,2);
       scrivi (270,42,'RISULATANTE  y=60 sen(2ã1 t)+ 40 sen (2ã2 t)',15);

       ptasto;


       cleardevice;
       titolo ('ONDE ARMONICHE');

       setcolor (15);
       line (70,30,70,160);
       line (0,105,550,105);


       ONDA (70,105,80,1,15,2,0);
       scrivi (270,15,'FONDAMENTALE   y=60 sen(2ã1 t)',9);

       ONDA (70,105,40,3,15,2,0);
       scrivi (270,28,'TERZA ARMONICA y=40 sen(2ã3 t)',5);

       ARMONICA (70,105,80,1,15,3);
       scrivi (270,42,'RISULATANTE    y=60 sen(2ã1 t)+ 40 sen(2ã3 t)',15);

       ptasto;

       lk:=1;

       while lk=1 do
       begin

       cleardevice;
       titolo ('ONDE ARMONICHE');

       setcolor (15);
       line (70,30,70,160);
       line (0,105,550,105);

       scrivi (400,15,'TIPO DI ARMONICA:',15);
       i:=trunc(inserisci(543,15));

       ARMONICA (70,105,60,1,15,i);

       setfillstyle (SolidFill,0);
       bar (400,15,605,55);

       scrivi (400,15,'Altri Grafici? (S/N)',15);
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

       setcolor (15);


       line (70,87,70,171);
       line (0,129,500,129);

       line (70,204,70,292);
       line (70,248,500,248);


       ONDA (70,129,40,8,15,2,0); {70,43}
       ONDA (70,129,40,9,12,2,0);
       ptasto;
       cleardevice;
       titolo('BATTIMENTI');
       setcolor (15);
       line (70,30,70,160);
       line (0,105,550,105);

       battimenti (70,105,40,8,9,14);


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

       setcolor (15);
       line (70,30,70,160);
       line (0,105,550,105);

       onda (70,105,30,1,10,2,0);
       onda (70,105,50,1,12,2,0);
       onda (70,105,80,1,15,2,0);

       scrivi (350, 15,'INTERFERENZA POSITIVA O COSTRUTTIVA  y=y1+y2',15);
       scrivi (350, 28,'Equazione: y1=r1 sen (wt+é)',10);
       scrivi (350, 42,'Equazione: y2=r2 sen (wt+é)',12);
       scrivi (350, 55,'Risultante: y=(r1+r2) sen (wt+é)',15);

       ptasto;

       cleardevice;
       titolo ('INTERFERENZA');


       setcolor (15);
       line (70,30,70,160);
       line (0,105,550,105);

       onda (70,105,70,1,10,2,0);
       onda (70,105,30,1,12,2,3.14);
       onda (70,105,40,1,15,2,0);

       scrivi (350, 15,'INTERFERENZA NEGATIVA O DISTRUTTIVA y=y1-y2',15);
       scrivi (350, 28,'Equazione: y1=r1 sen (wt+é)',10);
       scrivi (350, 42,'Equazione: y2=r2 sen [(wt+é)+ã]',12);
       scrivi (350, 55,'Risultante: y=(r1-r2) sen (wt+é)',15);


       ptasto;

       cleardevice;
       titolo ('INTERFERENZA');

       setcolor (15);
       line (70,30,70,160);
       line (0,105,550,105);

       onda (70,105,70,1,10,2,0);
       onda (70,105,70,1,12,2,3.14);
       onda (70,105,0,1,15,2,0);

       scrivi (350, 15,'INTERFERENZA COMPLETA y=0',15);
       scrivi (350, 28,'Equazione: y1=r sen (wt+é)',10);
       scrivi (350, 42,'Equazione: y2=r sen [(wt+é)+ã]',12);
       scrivi (350, 55,'Risultante: y=(r-r) sen (wt+é)',15);

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

       setcolor (15);
       line (70,30,70,160);
       line (0,105,550,105);


       onda(70,105,40,1,9,2,0);
       onda(70,105,40,3,5,2,0);
       onda(70,105,40,5,6,2,pi/2);

       scrivi (350,15,'ONDE COMPONENTI',15);
       ptasto;

       cleardevice;
       titolo('ONDE COMPLESSE');
       scrivi (350,15,'ONDA RISULTANTE',15);

       setcolor (15);
       line (70,30,70,160);
       line (0,105,550,105);

       ang:=0;
       x:=70;
       y:=105;

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
       y:=105-trunc (30*sin(ad*ang*1)+40*sin(ad*ang*3)+40*sin(ad*ang*5+pi/2));

       moveto (px,py);
       lineto (x,y);
       end;

       ptasto;
       end;


       if m=8 then begin
       cleardevice;

       titolo ('FIGURE DI LISSAJOUS');
       scrivi(20,20,'Componendo due oscillazioni ortogonali di periodo diverso,',15);
       scrivi(20,36,'le traiettorie risultanti sono le famose figure di LISSAJOUS',15);
       scrivi(20,50,'x=r1 sen (2ãv1)',15);
       scrivi(20,63,'y=r2 cos (2ãv2)',15);

       ptasto;


       lk:=1;

       while lk=1 do
       begin

       cleardevice;
       titolo('FIGURE DI LISSAJOUS');


       scrivi (400,15,'v1:',15);
       px:=trunc(inserisci(435,15));

       scrivi (400,30,'v2:',15);
       py:=trunc(inserisci(435,30));

       scrivi (400,45,'RIS:',15);
       r:=trunc(inserisci(455,45));

       lissajous (px, py,r);

       setfillstyle (SolidFill,0);
       bar (400,15,605,55);

       scrivi (400,15,'Altri Grafici? (S/N)',15);
       k:=readkey;
       if (k=#78) or (k=#110) then lk:=0;
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