// Condizionamento Invernale (ft3.c) //

extern void Titolo(char *stringa);
void Ambiente(int x,int y);
void Ventilatore(int x,int y);
void Espelli_e_Ricircola(void);
void Miscelazione(void);
void Filtro(int x,int y);
void Batteria(int x,int y);
void Umidificatore(int x,int y);
void ImpCondizInv(void);
void GraficoCondInv(void);
void AnimazCondInv(void);
void SpiegaTrasfCondInv(void);
void CondizInvernale(void);

char *Spiega1[9];
char *Spiega2[9];
char *Spiega3[9];

void Ambiente(int x,int y)
{
  bar(x,y,x+120,y+80);
  rectangle(x,y,x+120,y+80);
  settextstyle(TRIPLEX_FONT,HORIZ_DIR,3);
  outtextxy(x+7,y+22,"Ambiente");
}

void Ventilatore(int x,int y)
{
  fillellipse(x,y,20,20);
  bar(x,y-20,x+30,y);
  line(x,y-20,x+30,y-20);
  line(x+30,y-20,x+30,y);
  line(x+20,y,x+30,y);
}

void Espelli_e_Ricircola(void)
{
  line(320,140,360,140); /* all'espulsione */
  line(320,140,320,280); /* sulla dx verso il basso (ricircolo) */
  line(350,140,340,130); /* freccia dell'espulsione */
  line(350,140,340,150);
  line(320,270,310,260); /* freccia verso il basso (ricircolo) */
  line(320,270,330,260);
}

void Miscelazione(void)
{
  line(320,140,320,280); /* sulla dx verso il basso (ricircolo) */
  line(270,280,360,280); /* dall'esterno alla miscelazione */
  line(320,270,310,260); /* freccia verso il basso (ricircolo) */
  line(320,270,330,260);
  line(340,280,350,270); /* freccia dall'esterno (rinnovo) */
  line(340,280,350,290);
  line(290,280,300,270); /* freccia miscelazione */
  line(290,280,300,290);
}

void Filtro(int x,int y)
{
  setfillstyle(CLOSE_DOT_FILL,YELLOW);
  bar(x,y,x+10,y+40);
  rectangle(x,y,x+10,y+40);
}

void Batteria(int x,int y)
{
  bar(x,y,x+15,y+40);
  rectangle(x,y,x+15,y+40);
  line(x,y,x+15,y+40);
  line(x,y+40,x+15,y);
}

void Umidificatore(int x,int y)
{
  bar(x,y,x+80,y+40);
  rectangle(x,y,x+80,y+40);
  line(x,y+8,x+80,y+8);

  line(x+20,y+8,x+10,y+20); /* disegna il primo spruzzo */
  line(x+20,y+8,x+20,y+26);
  line(x+20,y+8,x+30,y+20);

  line(x+60,y+8,x+50,y+20); /* disegna il secondo spruzzo */
  line(x+60,y+8,x+60,y+26);
  line(x+60,y+8,x+70,y+20);
}

void ImpCondizInv(void)
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
  Umidificatore(100,260);
  Batteria(215,260);
  Filtro(260,260);

  settextstyle(TRIPLEX_FONT,HORIZ_DIR,2);
  outtextxy(300,160,"A");
  outtextxy(350,290,"E");
  outtextxy(280,290,"M");
  outtextxy(20,160,"I");
}

void GraficoCondInv(void)
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
  line(430,100,530,170);     /* retta di esercizio */
  line(430,280,530,170);     /* retta di miscelazione */

  setlinestyle(SOLID_LINE,SOLID_FILL,3);
  line(480,225,480,165);     /* primo riscaldamento */
  line(480,165,500,185);     /* umidificazione */
  line(500,185,500,149);     /* secondo riscaldamento */

  setcolor(WHITE);
  outtextxy(440,270,"E");
  outtextxy(480,225,"M");
  outtextxy(530,170,"A");
  outtextxy(500,125,"I");
}

void AnimazCondInv(void)
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
	    setfillstyle(SOLID_FILL,RED); Batteria(215,260);
	    break;
    case 6: setfillstyle(SOLID_FILL,BLACK); Batteria(215,260);
	    setfillstyle(SOLID_FILL,RED); Umidificatore(100,260);
	    break;
    case 7: setfillstyle(SOLID_FILL,BLACK); Umidificatore(100,260);
	    setfillstyle(SOLID_FILL,RED); Batteria(50,260);
	    break;
    case 8: setfillstyle(SOLID_FILL,BLACK); Batteria(50,260);
	    setfillstyle(SOLID_FILL,RED); Ventilatore(50,120);
	    break;
  }

  switch(trasformazione)
  { case 0: setcolor(CYAN);
	    setlinestyle(SOLID_LINE,SOLID_FILL,1);
	    line(500,149,530,170);     /* retta di esercizio */
	    break;
    case 1: break;
    case 2: break;
    case 3: setcolor(RED);
	    line(430,280,530,170);     /* retta di miscelazione */
	    break;
    case 4: setcolor(CYAN);
	    line(430,280,530,170);     /* retta di miscelazione */
	    break;
    case 5: setcolor(RED);
	    setlinestyle(SOLID_LINE,SOLID_FILL,3);
	    line(480,225,480,165);     /* primo riscaldamento */
	    break;
    case 6: setcolor(CYAN);
	    line(480,225,480,165);     /* primo riscaldamento */
	    setcolor(RED);
	    line(480,165,500,185);     /* umidificazione */
	    break;
    case 7: setcolor(CYAN);
	    line(480,165,500,185);     /* umidificazione */
	    setcolor(RED);
	    line(500,185,500,149);     /* secondo riscaldamento */
	    break;
    case 8: setcolor(CYAN);
	    line(500,185,500,149);     /* secondo riscaldamento */
	    setcolor(RED);
	    setlinestyle(SOLID_LINE,SOLID_FILL,1);
	    line(500,149,530,170);     /* retta di esercizio */
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

void SpiegaTrasfCondInv(void)
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

  Spiega1[5]="Nella BATTERIA DI PRERISCALDAMENTO l'aria viene";
  Spiega2[5]="riscaldata prima di entrare nell'umidificatore.";
  Spiega3[5]="";

  Spiega1[6]="Nell'UMIDIFICATORE ADIABATICO l'aria subisce";
  Spiega2[6]="l'aumento di umidit… richiesto per le condizioni";
  Spiega3[6]="di immissione.";

  Spiega1[7]="Nella BATTERIA DI POSTRISCALDAMENTO l'aria viene";
  Spiega2[7]="nuovamente riscaldata per raggiungere la";
  Spiega3[7]="temperatura richiesta per l'immissione (I).";

  Spiega1[8]="Il VENTILATORE DI MANDATA provvede infine ad";
  Spiega2[8]="immettere nell'ambiente (A) l'aria nelle";
  Spiega3[8]="condizioni di immissione (I).";
}

void CondizInvernale(void)
{
  cleardevice();
  Titolo("Impianto di Condizionamento Invernale");
  ImpCondizInv();
  GraficoCondInv();
  SpiegaTrasfCondInv();
  for(trasformazione=0;trasformazione<9;trasformazione++)
    {
      AnimazCondInv();
      sound(trasformazione*500+1000);
      delay(30);
      nosound();
      getch();
    }
  cleardevice();
}
