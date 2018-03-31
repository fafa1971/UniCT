// Condizionamento Estivo (ft4.c) //

void Titolo(char *stringa);
void Ambiente(int x,int y);
void Ventilatore(int x,int y);
void Espelli_e_Ricircola(void);
void Miscelazione(void);
void Filtro(int x,int y);
void Batteria(int x,int y);
void Deumidificatore(int x,int y);
void ImpCondizInv(void);
void Grafico(void);
void Animazione(void);
void SpiegaTrasf(void);
void CondizEstivo(void);

void Deumidificatore(int x,int y)
{
  bar(x,y,x+80,y+40);
  rectangle(x,y,x+80,y+40);
  line(x,y+40,x+80,y);
  line(x,y,x+80,y+40);
  line(x+37,y+11,x+43,y+11);
  circle(x+40,y+11,7);

  rectangle(x-10,y+50,x+90,y+60); /* vaschetta condensato */
  line(x-10,y+55,x+90,y+55);      /* linea di mezzo */
  line(x-10,y+50,x-10,y+45);      /* bordo sinistro */
  line(x+90,y+50,x+90,y+45);      /* bordo destro */
}

void ImpCondizEst(void)
{
  setcolor(YELLOW);
  setbkcolor(BLACK);
  setfillstyle(SOLID_FILL,BLACK);
  setlinestyle(SOLID_LINE,SOLID_FILL,3);

  line(10,120,50,120);   /* al primo ventil */
  line(80,110,100,110);  /* fra ventil e ambiente */
  line(220,150,260,150); /* fra ambiente e ventil n.2 */
  line(290,140,360,140); /* dal ventil n.2 all'espulsione */
  line(10,120,10,280);   /* sulla sx verso il basso */
  line(10,280,360,280);  /* tutta la linea orizzontale */
  line(320,140,320,280); /* sulla dx verso il basso (ricircolo) */

  line(350,140,340,130); /* freccia dell'espulsione (rinnovo) */
  line(350,140,340,150);
  line(340,280,350,270); /* freccia dall'esterno */
  line(340,280,350,290);
  line(320,270,310,260); /* freccia verso il basso (ricircolo) */
  line(320,270,330,260);
  line(10,130,0,140);    /* freccia verso l'alto */
  line(10,130,20,140);
  line(290,280,300,270); /* freccia miscelazione */
  line(290,280,300,290);

  Ventilatore(50,120);
  Ambiente(100,90);
  Ventilatore(260,150);

  Batteria(50,260);
  Deumidificatore(120,260);
  Filtro(260,260);

  settextstyle(TRIPLEX_FONT,HORIZ_DIR,2);
  outtextxy(300,160,"A");
  outtextxy(350,290,"E");
  outtextxy(280,290,"M");
  outtextxy(20,160,"I");
}

void GraficoCondEst(void)
{
  int verticex[]={580,295,580,305,588,300};
  int verticey[]={395,100,405,100,400,92};

  setcolor(WHITE);           /* disegna gli assi */
  setlinestyle(SOLID_LINE,SOLID_FILL,1);
  line(400,300,580,300);
  line(400,300,400,100);
  fillpoly(3,verticex);
  fillpoly(3,verticey);
  settextstyle(TRIPLEX_FONT,HORIZ_DIR,2);
  outtextxy(385,100,"h");
  outtextxy(555,300,"(x)");

  setcolor(CYAN);
  line(480,150,450,260);     /* retta di esercizio */
  line(480,150,560,110);     /* retta di miscelazione */

  setlinestyle(SOLID_LINE,SOLID_FILL,3);
  line(520,130,460,270);     /* deumidificazione */
  line(460,270,460,223);     /* post-riscaldamento */

  setcolor(WHITE);
  outtextxy(550,85,"E");
  outtextxy(510,105,"M");
  outtextxy(470,125,"A");
  outtextxy(450,200,"I");
}

void AnimazCondEst(void)
{
  setcolor(YELLOW);
  setlinestyle(SOLID_LINE,SOLID_FILL,3);
  switch(trasformazione)
  { case 0: setfillstyle(SOLID_FILL,BLACK); Ventilatore(50,120);
	    setfillstyle(SOLID_FILL,RED); Ambiente(100,90);
	    break;
    case 1: setfillstyle(SOLID_FILL,BLACK); Ambiente(100,90);
	    setfillstyle(SOLID_FILL,RED); Ventilatore(260,150);
	    break;
    case 2: setfillstyle(SOLID_FILL,BLACK); Ventilatore(260,150);
	    setcolor(RED); Espelli_e_Ricircola();
	    break;
    case 3: setcolor(YELLOW); Espelli_e_Ricircola();
	    setcolor(RED); Miscelazione();
	    break;
    case 4: setcolor(YELLOW); Miscelazione();
	    setcolor(RED); Filtro(260,260);
	    break;
    case 5: setcolor(YELLOW); Filtro(260,260);
	    setfillstyle(SOLID_FILL,RED); Deumidificatore(120,260);
	    break;
    case 6: setfillstyle(SOLID_FILL,BLACK); Deumidificatore(120,260);
	    setfillstyle(SOLID_FILL,RED); Batteria(50,260);
	    break;
    case 7: setfillstyle(SOLID_FILL,BLACK); Batteria(50,260);
	    setfillstyle(SOLID_FILL,RED); Ventilatore(50,120);
	    break;
  }

  switch(trasformazione)
  { case 0: setcolor(CYAN);
	    setlinestyle(SOLID_LINE,SOLID_FILL,1);
	    line(480,150,460,223);     /* retta di esercizio */
	    break;
    case 1: break;
    case 2: break;
    case 3: setcolor(RED);
	    setlinestyle(SOLID_LINE,SOLID_FILL,1);
            line(480,150,560,110);     /* retta di miscelazione */
	    break;
    case 4: setcolor(CYAN);
            setlinestyle(SOLID_LINE,SOLID_FILL,1);
	    line(480,150,560,110);     /* retta di miscelazione */
	    break;
    case 5: setcolor(RED);
	    setlinestyle(SOLID_LINE,SOLID_FILL,3);
            line(520,130,460,270);     /* deumidificazione */
	    break;
    case 6: setcolor(CYAN);
            line(520,130,460,270);     /* deumidificazione */
	    setcolor(RED);
            line(460,270,460,223);     /* post-riscaldamento */
	    break;
    case 7: setcolor(CYAN);
            line(460,270,460,223);     /* post-riscaldamento */
	    setcolor(RED);
	    setlinestyle(SOLID_LINE,SOLID_FILL,1);
            line(480,150,460,223);     /* retta di esercizio */
	    break;
  }

  setfillstyle(SOLID_FILL,BLACK);
  bar(0,350,640,440);      /* cancella la parte bassa dello schermo */
  setcolor(WHITE);	   /* scrive la spiegazione delle trasformazioni */
  settextstyle(TRIPLEX_FONT,HORIZ_DIR,3);

  outtextxy(10,350,Spiega1[trasformazione]);
  outtextxy(10,380,Spiega2[trasformazione]);
  outtextxy(10,410,Spiega3[trasformazione]);
}

void SpiegaTrasfCondEst(void)
{
  Spiega1[0]="Nell'AMBIENTE devono essere mantenute";
  Spiega2[0]="le condizioni desiderate di temperatura";
  Spiega3[0]="e umidit….";

  Spiega1[1]="Il VENTILATORE DI ESTRAZIONE provvede a estrarre";
  Spiega2[1]="dall'ambiente una certa portata di aria necessaria";
  Spiega3[1]="per il rinnovo.";

  Spiega1[2]="Una parte dell'aria estratta viene espulsa,";
  Spiega2[2]="e un'altra parte viene fatta ricircolare";
  Spiega3[2]="( portata di ricircolo ).";

  Spiega1[3]="L'aria di ricircolo (A) viene miscelata con";
  Spiega2[3]="l'aria di rinnovo esterna (E), ottenendo aria";
  Spiega3[3]="nelle nuove condizioni (M).";

  Spiega1[4]="Il FILTRO provvede a trattenere eventuali";
  Spiega2[4]="impurit… dell'aria.";
  Spiega3[4]="";

  Spiega1[5]="Nella BATTERIA DI RAFFREDDAMENTO E";
  Spiega2[5]="DEUMIDIFICAZIONE vengono contemporaneamente";
  Spiega3[5]="diminuite la temperatura e l'umidit… dell'aria.";

  Spiega1[6]="Nella BATTERIA DI POSTRISCALDAMENTO l'aria viene";
  Spiega2[6]="nuovamente riscaldata per raggiungere la";
  Spiega3[6]="temperatura richiesta per l'immissione (I).";

  Spiega1[7]="Il VENTILATORE DI MANDATA provvede infine ad";
  Spiega2[7]="immettere nell'ambiente (A) l'aria nelle";
  Spiega3[7]="condizioni di immissione (I).";
}

void CondizEstivo(void)
{
  cleardevice();
  Titolo("Impianto di Condizionamento Estivo");
  ImpCondizEst();
  GraficoCondEst();
  SpiegaTrasfCondEst();
  for(trasformazione=0;trasformazione<8;trasformazione++)
    {
      AnimazCondEst();
      sound(trasformazione*500+1500);
      delay(30);
      nosound();
      getch();
    }
  cleardevice();
}
