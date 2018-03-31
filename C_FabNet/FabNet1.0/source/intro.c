/********************* INTRO.C - Introduzione di FabNet *********************/
#define PAUSA 99
#define DURATA 95
#define FINE 0

unsigned Nodi=30;       	        	          /* numero di nodi */
float Percorso=1;         		        /* distanza tra i nodi [Km] */
float Data_Rate=1;     		         /* velocit… della sottorete [Mbps] */
unsigned long Lunghezza=1000;             /* lunghezza media messaggi [bit] */
float T_Pri[4]={50,40,30,15};        /* tempi di rotazione del token [msec] */

int Opzione=0,OpzPreced;
int Tasto;
char *Riga[20];

int XOpz[]={180,200,220,240,260};
int YOpz[]={210,250,290,330,370};

char *TestoOpzioni[]={"  Introduzione","  Data  Input","  Token Bus",
		      "  Token Ring","     FDDI"};

/***************************** PROGRAMMA ************************************/

void Inizializza(void)
{
  int GraphDriver=VGA, GraphMode=VGAHI;
  initgraph(&GraphDriver,&GraphMode, "c:\tc\bgi");
  randomize();
}

void Beep(void)
{
  sound(40); delay(15); nosound();
  sound(200); delay(15); nosound();
  sound(100); delay(15); nosound();
  sound(40); delay(15); nosound();
}

void Stella(int x,int y,int rmax)
{
  int rmin,punti[20];

  rmin=rmax*0.375;
  punti[0]=x;
  punti[1]=y-rmax;
    punti[2]=x+rmin*0.59;      /* cos,sen(54) */
    punti[3]=y-rmin*0.8;
  punti[4]=x+rmax*0.95;	       /* cos,sen(18) */
  punti[5]=y-rmax*0.3;
    punti[6]=x+rmin*0.95;      /* cos,sen(18) */
    punti[7]=y+rmin*0.3;
  punti[8]=x+rmax*0.59;        /* cos,sen(54) */
  punti[9]=y+rmax*0.8;
    punti[10]=x;
    punti[11]=y+rmin;
  punti[12]=x-rmax*0.59;       /* cos,sen(54) */
  punti[13]=y+rmax*0.8;
    punti[14]=x-rmin*0.95;     /* cos,sen(18) */
    punti[15]=y+rmin*0.3;
  punti[16]=x-rmax*0.95;       /* cos,sen(18) */
  punti[17]=y-rmax*0.3;
    punti[18]=x-rmin*0.59;     /* cos,sen(54) */
    punti[19]=y-rmin*0.8;
  fillpoly(10,punti);
}

void Intro(void)
{
  int count,color,indice;
  static int note[]={ 131,147,165,174,196,220,250,
		      262,294,330,350,392,440,494 };

  static int canzone[]={ 9,10,11,11,10,9,8,7,7,8,9,9,8,8,
			 9,10,11,11,10,9,8,7,7,8,9,8,7,7,
			 8,9,7,8,9,10,9,7,8,9,10,9,8,7,8,4,PAUSA,
			 9,10,11,11,10,9,8,7,7,8,9,8,7,7,FINE };

  static int lunghezza[]={ 4,2,2,2,2,2,2,2,2,2,2,3,1,4,
			   4,2,2,2,2,2,2,2,2,2,2,3,1,4,
			   4,2,2,2,1,1,2,2,2,1,1,2,2,2,2,2,2,
			   4,2,2,2,2,2,2,2,2,2,2,3,1,2,2 };

  setcolor(YELLOW);                          /* campi colorati alto e basso */
  setbkcolor(BLACK);
  setfillstyle(SOLID_FILL,BLUE);
  bar(0,0,640,200);
  setfillstyle(SOLID_FILL,RED);
  bar(0,240,640,480);
  line(0,200,640,200);
  line(0,240,640,240);

  settextstyle(TRIPLEX_FONT,HORIZ_DIR,4);             /* scritte scorrevoli */
  setfillstyle(SOLID_FILL,BLACK);
  for(count=-200;count<200;count+=5)
  {
    setcolor(BLACK);
    outtextxy(count+25,200,"Fabrizio");
    outtextxy(575-count,200,"Fazzino");
    setcolor(YELLOW);
    outtextxy(count+30,200,"Fabrizio");
    outtextxy(570-count,200,"Fazzino");
  }

  setcolor(YELLOW);			                /* stelle tricolori */
  setlinestyle(SOLID_LINE,EMPTY_FILL,3);
  setfillstyle(SOLID_FILL,LIGHTRED);
  Stella(180,300,100);
  setfillstyle(SOLID_FILL,WHITE);
  Stella(140,340,100);
  setfillstyle(SOLID_FILL,GREEN);
  Stella(100,380,100);

  setcolor(CYAN);                                               /* presenta */
  settextstyle(TRIPLEX_FONT,HORIZ_DIR,3);
  outtextxy(310,246,"presenta");

  setfillstyle(SOLID_FILL,MAGENTA);                  /* riquadro col titolo */
  bar(250,300,590,440);
  setcolor(YELLOW);
  setlinestyle(SOLID_LINE,SOLID_FILL,3);
  rectangle(250,300,590,440);
  setcolor(WHITE);
  settextstyle(TRIPLEX_FONT,HORIZ_DIR,8);
  outtextxy(270,300,"Fab Net");
  setcolor(YELLOW);                                      /* sottotitolo */
  settextstyle(TRIPLEX_FONT,HORIZ_DIR,4);
  outtextxy(270,390,"Network Simulator");
  settextstyle(SMALL_FONT,HORIZ_DIR,5);
  moveto(5,460);
  outtext("Simulatore TokenBus/TokenRing/FDDI");
  outtext(" - Facolt… di Ingegneria - Universit… di Catania");

  setcolor(YELLOW);                         /* suona musica e stampa stelle */
  setfillstyle(SOLID_FILL,YELLOW);
  randomize();
  for(indice=0;indice<59;indice++)
  {
    if(canzone[indice]!=PAUSA) sound(note[canzone[indice]]);
    delay(lunghezza[indice]*DURATA);
    nosound();
    Stella(random(640),random(172),8);
    if(canzone[indice]==FINE) break;
    if(kbhit()) {getch(); break;}
  }
  nosound();
}

void Sfondo(void)
{
  float f;
  cleardevice();
  setbkcolor(BLACK);

  setcolor(GREEN);                                     /* scritte verticali */
  settextstyle(TRIPLEX_FONT,VERT_DIR,4);
  outtextxy(56,95,"'Reti di Calcolatori'");
  outtextxy(100,75,"Corso dell'A.A. 94/95");
  outtextxy(490,75,"Prof. Orazio Mirabella");
  outtextxy(540,75,"Universit… di Catania");

  setfillstyle(SOLID_FILL,BLUE);                        /* bordo con stelle */
  bar(10,10,630,40);
  bar(10,440,630,470);
  bar(10,40,40,440);
  bar(600,40,630,440);
  setcolor(YELLOW);
  setfillstyle(SOLID_FILL,YELLOW);
  setlinestyle(SOLID_LINE,EMPTY_FILL,1);
  for(f=25;f<616;f+=73.75)
  { Stella(f,25,14);
    Stella(f,455,14); }
  for(f=96.66;f<431;f+=71.66)
  { Stella(25,f,14);
    Stella(615,f,14); }

  setfillstyle(SOLID_FILL,MAGENTA);  		    /* titolo e sottotitolo */
  bar(160,60,480,174);
  setcolor(YELLOW);
  setlinestyle(SOLID_LINE,EMPTY_FILL,3);
  rectangle(160,60,480,174);
  setcolor(WHITE);
  settextstyle(TRIPLEX_FONT,HORIZ_DIR,7);
  outtextxy(195,56,"Fab Net");
  setcolor(YELLOW);
  settextstyle(TRIPLEX_FONT,HORIZ_DIR,4);
  outtextxy(320-textwidth("Network Simulator")/2,130,"Network Simulator");

  setfillstyle(SOLID_FILL,CYAN);		         /* sfondo del menu */
  bar(160,190,480,420);
  rectangle(160,190,480,420);
}

void Menu(void)
{
  int i;

  Beep();
  setcolor(WHITE);
  setfillstyle(SOLID_FILL,GREEN);
  settextstyle(TRIPLEX_FONT,HORIZ_DIR,3);
  for(i=0;i<5;i++)
  {
    bar(XOpz[i],YOpz[i],XOpz[i]+200,YOpz[i]+30);
    setcolor(MAGENTA);
    rectangle(XOpz[i],YOpz[i],XOpz[i]+200,YOpz[i]+30);
    setcolor(WHITE);
    outtextxy(XOpz[i]+10,YOpz[i],TestoOpzioni[i]);
  }
  setfillstyle(SOLID_FILL,RED);
  bar(XOpz[Opzione],YOpz[Opzione],XOpz[Opzione]+200,YOpz[Opzione]+30);
  setcolor(YELLOW);
  rectangle(XOpz[Opzione],YOpz[Opzione],XOpz[Opzione]+200,YOpz[Opzione]+30);
  setcolor(WHITE);
  outtextxy(XOpz[Opzione]+10,YOpz[Opzione],TestoOpzioni[Opzione]);

  do
  {
    Tasto=getch();
    Beep();
    OpzPreced=Opzione;

    if (Tasto==27)
    {
      closegraph();
      restorecrtmode();
      exit(EXIT_SUCCESS);
    }
    if (Tasto==80|Tasto==77)           /* gi— */
      if ((++Opzione)==5) Opzione=0;
    if (Tasto==72|Tasto==75)           /* su */
      if ((--Opzione)==-1) Opzione=4;

    if (Opzione!=OpzPreced)
    {
      setfillstyle(SOLID_FILL,GREEN);
      bar(XOpz[OpzPreced],YOpz[OpzPreced],XOpz[OpzPreced]+200,YOpz[OpzPreced]+30);
      setcolor(MAGENTA);
      rectangle(XOpz[OpzPreced],YOpz[OpzPreced],XOpz[OpzPreced]+200,YOpz[OpzPreced]+30);
      setcolor(WHITE);
      outtextxy(XOpz[OpzPreced]+10,YOpz[OpzPreced],TestoOpzioni[OpzPreced]);
      setfillstyle(SOLID_FILL,RED);
      bar(XOpz[Opzione],YOpz[Opzione],XOpz[Opzione]+200,YOpz[Opzione]+30);
      setcolor(YELLOW);
      rectangle(XOpz[Opzione],YOpz[Opzione],XOpz[Opzione]+200,YOpz[Opzione]+30);
      setcolor(WHITE);
      outtextxy(XOpz[Opzione]+10,YOpz[Opzione],TestoOpzioni[Opzione]);
    }
  } while (Tasto!=13);
}

void Pagina_1(void)                              /* Introduzione - Pag.1/3 */
{
  Riga[0]="   Questo programma Š un simulatore : esso pu• essere";
  Riga[1]="utilizzato per valutare le prestazioni offerte da una";
  Riga[2]="rete locale utilizzante uno dei protocolli di accesso";
  Riga[3]="al mezzo fisico mediante token (Token Bus, Token Ring";
  Riga[4]="oppure FDDI).";
  Riga[5]="   Ognuno dei protocolli presi in esame consente di";
  Riga[6]="implementare sulla propria rete dei meccanismi di";
  Riga[7]="priorit…, per fare in modo ad esempio che la trasmissione";
  Riga[8]="di messaggi urgenti all'interno di un nodo non venga";
  Riga[9]="ostacolata dalla presenza di messaggi meno urgenti :";
  Riga[10]="questo simulatore simula allora all'interno di ogni";
  Riga[11]="nodo la presenza di 4 code a priorit… differenti,";
  Riga[12]="contenenti i messaggi pronti per essere spediti.";
  Riga[13]="   Inoltre Š possibile simulare il comportamento";
  Riga[14]="di reti con parametri fisici scelti dall'utente.";
}

void Pagina_2(void)                              /* Introduzione - Pag.2/3 */
{
  Riga[0]="   Prima di eseguire una qualunque simulazione sar… utile";
  Riga[1]="inserire i parametri fisici della rete mediante l'opzione";
  Riga[2]="Data-Input; non Š comunque una operazione obbligatoria,";
  Riga[3]="in quanto il programma dispone gi… di valori di default";
  Riga[4]="che possono andare bene per una simulazione di una rete";
  Riga[5]="generica.";
  Riga[6]="   Volendo invece modificare i parametri per avvicinarsi";
  Riga[7]="ad un caso reale o per valutare la sensitivit… della rete";
  Riga[8]="verso alcuni di essi, si potranno modificare il numero";
  Riga[9]="di nodi connessi alla rete, la lunghezza fisica del";
  Riga[10]="percorso complessivo della rete (sia essa un bus, come";
  Riga[11]="nel caso del Token Bus, che un anello, come per il Token";
  Riga[12]="Ring e l'FDDI), la velocit… a cui i dati possono essere";
  Riga[13]="trasmessi (Data-Rate), la lunghezza media dei messaggi";
  Riga[14]="e i tempi di rotazione del token richiesti (TTRT).";
}

void Pagina_3(void)                              /* Introduzione - Pag.3/3 */
{
  Riga[0]="   Per avviare una simulazione Š sufficiente scegliere uno";
  Riga[1]="dei 3 protocolli (Token Bus, Token Ring, FDDI) dal menu";
  Riga[2]="principale ; il programma chieder… dunque di quale livello";
  Riga[3]="di priorit… si vuole simulare il comportamento, chiedendo";
  Riga[4]="di selezionare un numero dall'1 al 4 (dove la priorit… 4";
  Riga[5]="Š la pi— elevata).";
  Riga[6]="   Da notare che ogni livello di priorit… non Š influenzato";
  Riga[7]="dai livelli inferiori ma solo dai superiori, per cui ad";
  Riga[8]="esempio il livello 2 Š penalizzato dal carico (numero di";
  Riga[9]="messaggi da spedire) dei livelli 3 e 4, ma non dell'1 (il";
  Riga[10]="livello 4 non dipende dunque da nessuno degli altri).";
  Riga[11]="   In virt— di questo fatto, selezionando le priorit… 3,2 o 1";
  Riga[12]="il simulatore provveder… ad effettuare tre campagne di";
  Riga[13]="simulazioni a seconda che i livelli superiori a quello";
  Riga[14]="selezionato occupino la banda per il 25%, 50% o il 75%.";
}

void Pagina_4(void)                              /* Introduzione - Pag.4/4 */
{
  Riga[0]="   Avviata la simulazione del protocollo prescelto e della";
  Riga[1]="priorit… desiderata, il simulatore provveder… a fare una";
  Riga[2]="campagna di simulazioni nell'intorno del carico di";
  Riga[3]="saturazione, mostrando i risultati in una tabella a mano";
  Riga[4]="a mano che i calcoli vengono svolti.";
  Riga[5]="   La tabella mostra numericamente il ThroughPut";
  Riga[6]="(messaggi effettivamente spediti nell'unit… di tempo) e";
  Riga[7]="l'Access-Delay (il ritardo medio con cui i vari pacchetti";
  Riga[8]="vengono inoltrati dall'istante della loro generazione).";
  Riga[9]="   Premendo la barra-spazio sar… possibile accedere ai grafici";
  Riga[10]="degli stessi indici prestazionali in funzione del carico";
  Riga[11]="(WorkLoad, cio‚ pacchetti generati nell'unit… di tempo), e";
  Riga[12]="saranno inoltre presenti due istogrammi relativi alla Fairness";
  Riga[13]="(equanimit… del protocollo verso tutte le stazioni) e alla";
  Riga[14]="distribuzione percentuale dei ritardi.";
}

void Pagina_5(void)                              /* Introduzione - Pag.5/5 */
{
  Riga[0]="   La lettura dei risultati Š chiaramente molto pi— agevole";
  Riga[1]="per via grafica; ad esempio il ThroughPut Š normalizzato";
  Riga[2]="in funzione della capacit… nominale della banda, per cui";
  Riga[3]="Š possibile vedere se la stessa viene sfruttata bene ed in";
  Riga[4]="che misura da ogni livello.";
  Riga[5]="   L'istogramma della fairness rappresenta su ogni colonna";
  Riga[6]="il numero di messaggi spediti da ogni stazione, per cui";
  Riga[7]="visivamente ci si pu• rendere conto che se esso si discosta";
  Riga[8]="di molto dal suo valor medio il protocollo Š poco equo, nel";
  Riga[9]="senso che privilegia alcune stazioni rispetto ad altre.";
  Riga[10]="   I due istogrammi sono stati valutati punto per punto,";
  Riga[11]="per cui premendo le frecce sinistra/destra Š possibile";
  Riga[12]="spostare il cursore su differenti valori di WorkLoad.";
  Riga[13]="   In ogni caso Š sempre possibile alla tabella coi valori";
  Riga[14]="numerici prima di ritornare al menu principale.";
}

void Pagina_6(void)                              /* Introduzione - Pag.6/6 */
{
  Riga[0]="   I vari protocolli nella pratica non vengono utilizzati";
  Riga[1]="uno indifferentemente al posto dell'altro, ma anzi operano";
  Riga[2]="con mezzi fisici molto differenti ; ad esempio il Token Bus";
  Riga[3]="Š usato solitamente per trasmissioni su cavo coassiale a 1,";
  Riga[4]="5 o 10 Mbps, mentre il Token Ring adotta il pi— economico";
  Riga[5]="doppino telefonico a 1 o 4 Mbps, mentre infine l'FDDI usa";
  Riga[6]="le velocissime (e costose) fibre ottiche a 100 Mbps.";
  Riga[7]="   Il programma pu• dunque servire a verificare come mai";
  Riga[8]="per una determinata configurazione sia stato scelto proprio";
  Riga[9]="quel particolare protocollo : e la simulazione fornisce la";
  Riga[10]="verifica che ogni protocollo si adatta meglio degli altri";
  Riga[11]="al proprio mezzo fisico, anche per quanto riguarda la";
  Riga[12]="gestione delle varie priorit… nei casi pratici in cui";
  Riga[13]="queste reti locali vengono utilizzate.";
  Riga[14]="                Fabrizio Fazzino - CdL Ingegneria Informatica";
}

void Stampa_Pagina(unsigned Pagina)
{
  unsigned Inizio,riga;
  char *Titolo;
  char Numero[4];

  cleardevice();
  settextstyle(TRIPLEX_FONT,HORIZ_DIR,4);
  switch(Pagina)
  {
    case 1: Titolo="Scopo del Programma";
	    Pagina_1(); break;
    case 2: Titolo="Parametri Fisici della Rete";
	    Pagina_2(); break;
    case 3: Titolo="Avvio della Simulazione";
	    Pagina_3(); break;
    case 4: Titolo="Risultati della Simulazione";
	    Pagina_4(); break;
    case 5: Titolo="Lettura Grafica dei Risultati";
	    Pagina_5(); break;
    case 6: Titolo="Comparazione dei Protocolli";
	    Pagina_6(); break;
  }
  Inizio=320-textwidth(Titolo)/2;
  setfillstyle(SOLID_FILL,RED);
  bar(Inizio-20,5,640-Inizio+20,55);
  setcolor(YELLOW);
  setlinestyle(SOLID_LINE,SOLID_FILL,3);
  rectangle(Inizio-20,5,640-Inizio+20,55);
  setcolor(WHITE);
  outtextxy(Inizio,10,Titolo);
  settextstyle(TRIPLEX_FONT,HORIZ_DIR,2);
  for(riga=0;riga<15;riga++)
  {
    outtextxy(5,riga*25+60,Riga[riga]);
    sound(100+riga*200); delay(5); nosound();
  }
  setcolor(GREEN);
  moveto(20,435); outtext("Pagina ");
  itoa(Pagina,Numero,10); outtext(Numero); outtext("/6  ");
  setcolor(RED);
  outtext("Freccia destra/sinistra per avanzare/recedere.");
}

void Stampa_Testo(void)
{
  unsigned Pagina=1;

  Stampa_Pagina(1);
  do
  {
    Tasto=getch();
    if(Tasto==75)
    {
      Pagina--;
      if(Pagina<1) Pagina=1;
      else Stampa_Pagina(Pagina);
    }
    if(Tasto==77)
    {
      Pagina++;
      if(Pagina>6) Pagina=6;
      else Stampa_Pagina(Pagina);
    }
  } while(Tasto!=27);
}

void Stampa_Dati_Attuali(unsigned Evidenziato)
{
  char Stampa[20];
  unsigned IndPrior;

  if(T_Pri[0]<((float)(Nodi*Lunghezza))/(Data_Rate*1000))
    T_Pri[0]=((float)(Nodi*Lunghezza))/(Data_Rate*1000);

  setfillstyle(SOLID_FILL,LIGHTGRAY);
  bar(20,185,620,430);
  setcolor(YELLOW);
  rectangle(20,185,620,430);

  setfillstyle(SOLID_FILL,RED);
  bar(30,210+40*Evidenziato,600,240+40*Evidenziato);

  settextstyle(TRIPLEX_FONT,HORIZ_DIR,3);

  if(Evidenziato==0) setcolor(WHITE); else setcolor(BLUE);
  moveto(40,210); outtext("Numero di Nodi = ");
  itoa(Nodi,Stampa,10); outtext(Stampa);

  if(Evidenziato==1) setcolor(WHITE); else setcolor(BLUE);
  moveto(40,250); outtext("Lunghezza del percorso della rete = ");
  gcvt(Percorso,5,Stampa); outtext(Stampa); outtext(" Km");

  if(Evidenziato==2) setcolor(WHITE); else setcolor(BLUE);
  moveto(40,290); outtext("Data-Rate = ");
  gcvt(Data_Rate,4,Stampa); outtext(Stampa); outtext(" Mbps");

  if(Evidenziato==3) setcolor(WHITE); else setcolor(BLUE);
  moveto(40,330); outtext("Lunghezza media messaggi = ");
  gcvt(Lunghezza,5,Stampa); outtext(Stampa); outtext(" bit");

  if(Evidenziato==4) setcolor(WHITE); else setcolor(BLUE);
  moveto(40,370); outtext("TTRT (priorit… 4..1) = ");
  for(IndPrior=0;IndPrior<4;IndPrior++)
  {
    gcvt(T_Pri[IndPrior],5,Stampa);
    if(IndPrior>0) outtext(">");
    outtext(Stampa);
  }
  outtext(" msec");

  setfillstyle(SOLID_FILL,RED);
  bar(90,125,550,145);
  setcolor(YELLOW);
  rectangle(90,125,550,145);
  gotoxy(13,9);
  printf("Usare frecce su/gi— ed Enter per modificare. Esc esce.");
}

void Data_Input(void)
{
  int Parametro=0;
  char Tasto,Buffer[20];          /* buffer di input */

  cleardevice();
  setbkcolor(RED);
  setfillstyle(SOLID_FILL,BLUE);
  bar(0,0,640,480);
  setcolor(YELLOW);
  rectangle(1,1,638,478);

  setfillstyle(SOLID_FILL,MAGENTA);
  bar(50,40,590,90);
  rectangle(50,40,590,90);
  setcolor(WHITE);
  settextstyle(TRIPLEX_FONT,HORIZ_DIR,4);
  outtextxy(57,45,"Inserimento parametri della rete");

  Stampa_Dati_Attuali(0);

  do
  {
    do Tasto=getch();
    while(Tasto!=13 && Tasto!=27 && Tasto!=72 && Tasto!=80);
    Beep();

    if(Tasto==72)
    {
      Parametro--;
      if(Parametro<0) Parametro=4;
      Stampa_Dati_Attuali(Parametro);
    }
    if(Tasto==80)
    {
      Parametro++;
      if(Parametro>4) Parametro=0;
      Stampa_Dati_Attuali(Parametro);
    }

    if(Tasto==13)
    {
      setfillstyle(SOLID_FILL,RED);
      bar(90,125,550,145);
      setcolor(YELLOW);
      rectangle(90,125,550,145);
      gotoxy(13,9);
							
      switch(Parametro)
      {
	case 0 : printf("Numero di Nodi: ");
		 Nodi=atoi(gets(Buffer));
		 if(Nodi==0) Nodi=30;
		 if(Nodi<2) Nodi=2; break;
	case 1 : printf("Percorso tra i nodi (max 1000 Km): ");
		 Percorso=atof(gets(Buffer));
		 if(Percorso==0) Percorso=1;
		 if(Percorso<0) Percorso=0;
		 if(Percorso>1000) Percorso=1000; break;
	case 2 : printf("Data-Rate (da 1 a 200 Mbps): ");
		 Data_Rate=atof(gets(Buffer));
		 if(Data_Rate<1) Data_Rate=1;
		 if(Data_Rate>200) Data_Rate=200; break;
	case 3 : printf("Lunghezza media messaggi (max 64000 bit): ");
		 Lunghezza=atof(gets(Buffer));
		 if(Lunghezza==0) Lunghezza=1000;
		 if(Lunghezza<100) Lunghezza=100;
		 if(Lunghezza>64000) Lunghezza=64000; break;
	case 4 : printf("TTRT[4] [msec] (=THT*Nodi) (min.%g) : ",
			((float)(Nodi*Lunghezza))/(Data_Rate*1000));
		 T_Pri[0]=atof(gets(Buffer)); Beep();
		 if(T_Pri[0]==0) T_Pri[0]=50;
		 Stampa_Dati_Attuali(Parametro);

		 setfillstyle(SOLID_FILL,RED);
		 bar(90,125,550,145);
		 setcolor(YELLOW);
		 rectangle(90,125,550,145);
		 gotoxy(13,9);
		 printf("TTRT[3] [msec] (Token-Bus e FDDI) (max.%g) : ",
			T_Pri[0]);
		 T_Pri[1]=atof(gets(Buffer)); Beep();
		 if(T_Pri[1]==0 | T_Pri[1]>T_Pri[0]) T_Pri[1]=T_Pri[0];
		 Stampa_Dati_Attuali(Parametro);

		 setfillstyle(SOLID_FILL,RED);
		 bar(90,125,550,145);
		 setcolor(YELLOW);
		 rectangle(90,125,550,145);
		 gotoxy(13,9);
		 printf("TTRT[2] [msec] (Token-Bus e FDDI) (max.%g) : ",
			T_Pri[1]);
		 T_Pri[2]=atof(gets(Buffer)); Beep();
		 if(T_Pri[2]==0 | T_Pri[2]>T_Pri[1]) T_Pri[2]=T_Pri[1];
		 Stampa_Dati_Attuali(Parametro);

		 setfillstyle(SOLID_FILL,RED);
		 bar(90,125,550,145);
		 setcolor(YELLOW);
		 rectangle(90,125,550,145);
		 gotoxy(13,9);
		 printf("TTRT[1] [msec] (Token-Bus e FDDI) (max.%g) : ",
			T_Pri[3]);
		 T_Pri[3]=atof(gets(Buffer));
		 if(T_Pri[3]==0 | T_Pri[3]>T_Pri[2]) T_Pri[3]=T_Pri[2];
		 break;
      }
      Beep();
      Stampa_Dati_Attuali(Parametro);
    }
  } while(Tasto!=27);
  Beep();
  setbkcolor(BLACK);
}
