#include "stdio.h"            ///////////////////////////////////////////
#include "stdlib.h"           //                                       //
#include "conio.h"            //      F I S I C A    T E C N I C A     //
#include "graphics.h"         //                                       //
#include "dos.h"              //          di Fabrizio Fazzino          //
#include "c:\bc\faber\ft1.c"  //                                       //
#include "c:\bc\faber\ft2.c"  //  Programma Didattico in Borland C++   //
#include "c:\bc\faber\ft3.c"  //                                       //
#include "c:\bc\faber\ft4.c"  ///////////////////////////////////////////
#include "c:\bc\faber\fttext.c"
#include "c:\bc\faber\fttrcol.c"

#define OFF 0
#define ON 1
#define PAUSA 99
#define DURATA 95
#define FINE 0

int Opzione=0,OpzPreced;
int Tasto,indice=0,SuonoOnOff=ON;

int XOpz[]={ 50,50,50,50,
	     240,240,240,240,
	     430,430,430,430 };

int YOpz[]={ 230,270,300,330,
	     230,270,300,330,
	     230,270,300,330 };

char *TestoOpzioni[]={ "   Introduzione    ",  /* prima colonna (0-3) */
		       "   TERMODINAMICA   ",
		       "   Cicli Diretti   ",
		       "   Cicli Inversi   ",

		       "   Musica Accesa   ",  /* sec.colonna (4-7) */
		       "  CONDIZIONAMENTO  ",
		       "  Condiz.Invernale ",
		       "  Condiz. Estivo   ",

		       "   Torna al DOS    ",  /* terza colonna (8-11) */
       		       "TRASMISSIONE CALORE",
		       "     ACUSTICA      ",
		       "  ILLUMINOTECNICA  " };


void Inizializza(void);
void Sfondo(void);
void Scritte(void);
void Menu(void);
void Stella(int x,int y,int rmax);

void Inizializza(void)
{
  int GraphDriver=VGA, GraphMode=VGAHI;
  initgraph(&GraphDriver,&GraphMode, "c:\bc\bgi");
}

void Sfondo(void)
{
  float f;
  setbkcolor(BLACK);
  setcolor(BLUE);
  setfillstyle(SOLID_FILL,BLUE);
  bar(10,10,630,40);
  bar(10,440,630,470);
  bar(10,40,40,440);
  bar(600,40,630,440);
  setcolor(YELLOW);
  setfillstyle(SOLID_FILL,YELLOW);
  for(f=25;f<616;f+=73.75)
  { Stella(f,25,14);
    Stella(f,455,14); }
  for(f=96.66;f<431;f+=71.66)
  { Stella(25,f,14);
    Stella(615,f,14); }
}

void Scritte(void)
{
  int i;
  setfillstyle(SOLID_FILL,RED);
  bar(120,60,520,125);
  setcolor(YELLOW);
  setlinestyle(SOLID_LINE,EMPTY_FILL,3);
  rectangle(120,60,520,125);
  setcolor(WHITE);
  settextstyle(TRIPLEX_FONT,HORIZ_DIR,6);
  outtextxy(145,60,"Fisica Tecnica");
  setcolor(YELLOW);
  settextstyle(TRIPLEX_FONT,HORIZ_DIR,4);
  outtextxy(173,130,"di Fabrizio Fazzino");

  setfillstyle(SOLID_FILL,MAGENTA);
  bar(45,215,595,260);
  setfillstyle(SOLID_FILL,CYAN);
  bar(45,260,595,355);
  rectangle(45,215,595,355);
  line(45,260,595,260);

  setcolor(BROWN);
  settextstyle(TRIPLEX_FONT,HORIZ_DIR,1);
  outtextxy(44,400,"Utilizzare i tasti cursore e Return per confermare l'opzione");

  setcolor(WHITE);
  setfillstyle(SOLID_FILL,BLUE);
  settextstyle(DEFAULT_FONT,HORIZ_DIR,0);
  for(i=0;i<12;i++)
  {
  bar(XOpz[i],YOpz[i],XOpz[i]+160,YOpz[i]+15);
  outtextxy(XOpz[i]+7,YOpz[i]+5,TestoOpzioni[i]);
  }
  setfillstyle(SOLID_FILL,RED);
  bar(XOpz[Opzione],YOpz[Opzione],XOpz[Opzione]+160,YOpz[Opzione]+15);
  outtextxy(XOpz[Opzione]+7,YOpz[Opzione]+5,TestoOpzioni[Opzione]);
}

void Menu(void)
{
  static int note[]={ 131,147,165,174,196,220,250,
		    262,294,330,350,392,440,494 };

  static int canzone[]={ 9,10,11,    11,10,9,8,
			 7,7,8,9,    9,8,8,
			 9,10,11,    11,10,9,8,
			 7,7,8,9,    8,7,7,
			 8,9,7,      8,9,10,9,7,
			 8,9,10,9,8, 7,8,4,PAUSA,
			 9,10,11,    11,10,9,8,
			 7,7,8,9,    8,7,7,FINE };

  static int lunghezza[]={ 4,2,2,     2,2,2,2,
			   2,2,2,2,   3,1,4,
			   4,2,2,     2,2,2,2,
			   2,2,2,2,   3,1,4,
			   4,2,2,     2,1,1,2,2,
			   2,1,1,2,2, 2,2,2,2,
			   4,2,2,     2,2,2,2,
			   2,2,2,2,   3,1,2,2 };
  do
  {
    while(!kbhit())
    {
      if (SuonoOnOff)
      {
	if(canzone[indice]!=PAUSA, canzone[indice]!=FINE)
	  sound(note[canzone[indice]]);
	delay(lunghezza[indice]*DURATA);
	nosound();
	if (canzone[indice]==FINE) indice=-1;
	indice++;
      }
    }
    Tasto=getch();
    OpzPreced=Opzione;

    if (Tasto==80)           /* gi— */
    { Opzione++;
      if (Opzione==4|Opzione==8) Opzione-=4;
      if (Opzione==12) Opzione=8; }
    if (Tasto==72)           /* su */
    { Opzione--;
      if (Opzione==3|Opzione==7) Opzione+=4;
      if (Opzione==-1) Opzione=3; }
    if (Tasto==77)           /* dx */
    { Opzione+=4;
      if (Opzione>11) Opzione-=12; }
    if (Tasto==75)           /* sx */
    { Opzione-=4;
      if (Opzione<0) Opzione+=12; }

    if (Opzione!=OpzPreced)
    {
      setfillstyle(SOLID_FILL,BLUE);
      bar(XOpz[OpzPreced],YOpz[OpzPreced],XOpz[OpzPreced]+160,YOpz[OpzPreced]+15);
      outtextxy(XOpz[OpzPreced]+7,YOpz[OpzPreced]+5,TestoOpzioni[OpzPreced]);
      setfillstyle(SOLID_FILL,RED);
      bar(XOpz[Opzione],YOpz[Opzione],XOpz[Opzione]+160,YOpz[Opzione]+15);
      outtextxy(XOpz[Opzione]+7,YOpz[Opzione]+5,TestoOpzioni[Opzione]);
    }
  } while (Tasto!=13);
}

void Stella(int x,int y,int rmax)
{
  int rmin,punti[20];
  setcolor(YELLOW);
  setlinestyle(SOLID_LINE,EMPTY_FILL,1);
  setfillstyle(SOLID_FILL,YELLOW);
  rmin=rmax*0.375;
  punti[0]=x;
  punti[1]=y-rmax;
    punti[2]=x+rmin*0.59;      /* cos,sen(54) */
    punti[3]=y-rmin*0.8;
  punti[4]=x+rmax*0.95;	   /* cos,sen(18) */
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

void main(void)
{
  Inizializza();
INIZIO: Sfondo();
  Scritte();
  Menu();
  switch (Opzione)
  {
    case 0: cleardevice(); Titolo("Introduzione");
            Pagina0(); Stampa(); getch();
            cleardevice(); break;
    case 1: cleardevice(); Titolo("Termodinamica");
            Pagina1(); Stampa(); getch();
            cleardevice(); Titolo("Cicli Termodinamici");
            Pagina2(); Stampa(); getch();
            cleardevice(); break;
    case 2: CicliDiretti(); break;
    case 3: CicliInversi(); break;
    case 4:
      if (SuonoOnOff)
      { SuonoOnOff=OFF;
	TestoOpzioni[4]="   Musica Spenta   "; }
      else
      { SuonoOnOff=ON;
	TestoOpzioni[4]="   Musica Accesa   "; }
      setfillstyle(SOLID_FILL,RED);
      bar(XOpz[4],YOpz[4],XOpz[4]+160,YOpz[4]+15);
      outtextxy(XOpz[4]+7,YOpz[4]+5,TestoOpzioni[4]);
      break;
    case 5: cleardevice(); Titolo("Condizionamento dell'Aria");
            Pagina3(); Stampa(); getch();
            cleardevice(); Titolo("Condizioni di Immissione");
            Pagina4(); Stampa(); getch();
            cleardevice(); break;
    case 6: CondizInvernale(); break;
    case 7: CondizEstivo(); break;
    case 8: closegraph(); exit(EXIT_SUCCESS); break;
    case 9: cleardevice(); Titolo("Trasmissione del Calore");
            Pagina5(); Stampa(); getch();
            cleardevice(); Titolo("Meccanismi Combinati");
            Pagina6(); Stampa(); Profilo(); getch();
            cleardevice(); break;
    case 10: cleardevice(); Titolo("Acustica Fisiologica");
            Pagina7(); Stampa(); getch();
            cleardevice(); Titolo("Ascolto di Suoni Puri");
            Pagina8(); Stampa(); Sound();
            cleardevice(); Titolo("Acustica delle Sale");
            Pagina9(); Stampa(); Sabine(); getch();
            cleardevice(); break;
    case 11: cleardevice(); Titolo("Percezione della Luce");
            Pagina10(); Stampa(); getch();
            cleardevice(); Titolo("Triangolo dei Colori");
            TriangoloColori(); TestoColori(); getch();
            cleardevice(); Titolo("Illuminamento Ottimale");
            Pagina11(); Stampa(); getch();
            cleardevice(); break;
  }
  goto INIZIO;
}