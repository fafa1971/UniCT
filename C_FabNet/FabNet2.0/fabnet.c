/****************************************************************************/
/*                                                                          */
/*                        FAB NET  -  di Fabrizio Fazzino                   */
/*                                                                          */
/*  Simulazione, valutazione e confronto delle prestazioni dei protocolli   */
/*        TokenBus / TokenRing / FDDI  per le reti di calcolatori.          */
/*                                                                          */
/****************************************************************************/

#include <stdlib.h>
#include <stdio.h>
#include <conio.h>
#include <math.h>
#include <time.h>
#include <graphics.h>
#include <c:\tc\faber\intro.c>

#define TOKEN_BUS  0
#define TOKEN_RING 1
#define FDDI       2

#define EXTRA_POINT 8

/*************** PARAMETRI DELLA RETE INSERIBILI DALL'UTENTE ****************/

extern unsigned Nodi;       	        	          /* numero di nodi */
extern float Percorso;         		        /* distanza tra i nodi [Km] */
extern float Data_Rate;		         /* velocit… della sottorete [Mbps] */
extern unsigned long Lunghezza;           /* lunghezza media messaggi [bit] */
extern float T_Pri[4];                /* tempi di possesso del token [msec] */
extern float T_Simul;                           /* durata della simulazione */

/********* VARIABILI AUSILIARIE PER IL CALCOLO DELLE PRESTAZIONI ************/

float Time;            	                  /* variabile tempo globale [msec] */
float ThroughPut,TP_max;		               /* throughput [Mbps] */
float Access_Delay,AD_max ;			          /* ritardo [msec] */
float WorkLoad[4],WL_max;           /* WorkLoad di saturazione [frames/sec] */

struct nodo
{                                /* struttura di un singolo nodo della rete */
  float istante[4];                 /* istante di generazione del messaggio */
  unsigned long lunghezza[4];                    /* lunghezza del messaggio */
  unsigned long msg_spediti[9];           /* num.msg.spediti dalla stazione */
  float last_token;                                    /* per calcolare TRT */
} *Coda;                             /* puntatore alla struttura della rete */

struct
{                  /* matrice per memorizzare i risultati delle simulazioni */
  float workload[9];          /* valori di WL a cui eseguire le simulazioni */
  float throughput[9][3];                         /* array di TP risultanti */
  float access_delay[9][3];                       /* array di AD risultanti */
  unsigned long intervallo_ritardi[9][3][16];/* contatore per distribuzione */
} Matrice;

/***************************** PROGRAMMA ************************************/

/* COME TUTTI I PROGRAMMI IN LINGUAGGIO "C" BISOGNA RICORDARSI CHE LA LETTURA
   DEL LISTATO VA EFFETTUATA DAL BASSO VERSO L'ALTO, INIZIANDO DALLA FINE
   (CON LA PROCEDURA PRINCIPALE "MAIN") E RISALENDO MAN MANO CHE SI
   INCONTRANO LE VARIE CHIAMATE DI PROCEDURA. */

float Exp(float WL)
/* SIMULA LA GENERAZIONE ESPONENZIALE DEGLI INTERARRIVI CON PARAMETRO "WL".
   FORNENDO INFATTI IL WORKLOAD "WL" [frames/sec] RESTITUISCE LA VARIABILE
   TEMPORALE "EXP" [msec] CON DISTRIBUZIONE ESPONENZIALE. */
{
  float Var;
  Var=1000*log(1/(1-(random(32e3)/32e3)))/WL;
  return Var;
}

void Point_Reset(void)
/* DEVE ESSERE ESEGUITA PER INIZIALIZZARE LE OPPORTUNE VARIABILI PRIMA DI
   UNA QUALUNQUE SIMULAZIONE IN CONDIZIONI PREFISSATE; AD ESEMPIO ESEGUENDO
   LA CLASSICA CAMPAGNA DI SIMULAZIONI TALE PROCEDURA DOVRA' ESSERE ESEGUITA
   PER OGNUNO DEGLI 8 PUNTI. */
{
  unsigned Indice,Livello;

  for(Indice=0;Indice<Nodi;Indice++,Coda++)          /* inizializza le code */
  {
    for(Livello=0;Livello<4;Livello++)
    {
      (*Coda).istante[Livello]=Exp(WorkLoad[Livello]);
      (*Coda).lunghezza[Livello]=floor(Lunghezza/2)+random(Lunghezza);
    }
    (*Coda).last_token=0;
  }
  Coda-=Nodi;
}

void Screen_Reset(void)
/* INIZIALIZZA LE VARIABILI CHE RICHIEDONO DI ESSERE RESETTATE SOLO PRIMA
   DI OGNI CAMPAGNA DI SIMULAZIONI. */
{
  unsigned Punto,Banda,Colonna,Indice;

  for(Punto=0;Punto<9;Punto++)
  {
    Matrice.workload[Punto]=0;

    for(Banda=0;Banda<3;Banda++)
    {
      Matrice.throughput[Punto][Banda]=0;
      Matrice.access_delay[Punto][Banda]=0;

      for(Colonna=0;Colonna<16;Colonna++)
	Matrice.intervallo_ritardi[Punto][Banda][Colonna]=0;
    }

    for(Indice=0;Indice<Nodi;Indice++,Coda++)
      (*Coda).msg_spediti[Punto]=0;
    Coda-=Nodi;
  }
}

void Indicatori_Avanzamento(unsigned Punto, unsigned Parziale)
/* VISUALIZZA GLI INDICATORI DI AVANZAMENTO TOTALI E PARZIALI ALL'INTERNO
   DELLA CAMPAGNA DI SIMULAZIONI.
   L'INDICATORE PARZIALE E' UN RETTANGOLO CHE ARRIVA A RIEMPIRSI QUANDO
   SI CONCLUDE LA SIMULAZIONE NEL SINGOLO PUNTO, MENTRE L'INDICATORE
   TOTALE E' UNA TORTA CHE SI RIEMPIE COL PROCEDERE DI TUTTA LA CAMPAGNA
   DI SIMULAZIONI. */
{
  unsigned gradi_totali;

  setfillstyle(SOLID_FILL,RED);                       /* avanzamento totale */
  setlinestyle(SOLID_LINE,SOLID_FILL,NORM_WIDTH);
  setcolor(RED);
  gradi_totali=45*(Punto-1)+5.625*Parziale;
  if(gradi_totali<=90)
    pieslice(550,390,90-gradi_totali,90,67);
  else
  {
    pieslice(550,390,0,90,67);
    pieslice(550,390,360-(gradi_totali-90),360,67);
  }

  if(Parziale==0)                                       /* rettangolo vuoto */
  {
    setfillstyle(SOLID_FILL,GREEN);
    bar(200,320,400,350);
    setcolor(YELLOW);
    setlinestyle(SOLID_LINE,SOLID_FILL,THICK_WIDTH);
    rectangle(200,320,400,350);
  }
  else
  {
    setfillstyle(SOLID_FILL,RED);            /* riempie indicatore parziale */
    bar(202,322,198+25*Parziale,348);
  }
}

void TokenBus(unsigned Priority, unsigned Punto, unsigned Curva)
/* SIMULA IL RELATIVO PROTOCOLLO TOKEN BUS, E OLTRE ALLE VARIBILI GLOBALI
   (COI DATI DELLA RETE) HA BISOGNO CHE LE SIANO PASSATE LE INFORMAZIONI
   RELATIVE ALLA ATTUALE SIMULAZIONE DA COMPIERE, IN MODO DA POTERE
   VISUALIZZARE CORRETTAMENTE I RISULTATI DELLE SIMULAZIONI.
   "PRIORITY" INDICA INFATTI IL LIVELLO DI PRIORITA' DI CUI VALUTARE LE
   PRESTAZIONI, "PUNTO" INDICA DI QUALE PUNTO DA INTERPOLARE SI STIA
   EFFETTUANDO LA SIMULAZIONE (OPPURE SE NON BISOGNA VISUALIZZARE NULLA SE
   SI STA EFFETTUANDO UNA SIMULAZIONE SINGOLA E IL PARAMETRO ASSUME IL
   VALORE "EXTRA_POINT"), "CURVA" INDICA L'OCCUPAZIONE DEI LIVELLI
   A PRIORITA' SUPERIORE (SIMULO UNA OCCUPAZIONE DEL 25%, 50%, 75% DELLA
   BANDA MA SOLO NEL CASO IN CUI "PRIORITY" NON SIA LA MASSIMA). */
{                                                  																				 /* con carico [frames/sec]. */
  float Start;
  float sum_ritardi=0;
  float TRT,THT;
  unsigned Indice,Livello;
  unsigned long num_ritardi=0;
  unsigned colonna;
  unsigned long bit_trasmessi=0;
  unsigned Avanzamento_Parziale=0,Nuovo_Parziale; /* indicatori avanzamento */

  THT=T_Pri[0]/(float)Nodi;
  Time=T_Pri[0];           /* per ogni simulazione resetto il tempo globale */
  while(Time<T_Pri[0]+T_Simul)                      /* tempo di simulazione */
  {
    for(Indice=0;Indice<Nodi;Indice++,Coda++)           /* scandisce i nodi */
    {
      Time+=12*8/(1000*Data_Rate)+Percorso/400;              /* trasm.token */
      TRT=Time-(*Coda).last_token;               /* calcola TRT ultimo giro */
      (*Coda).last_token=Time;                /* aziona timer prossimo giro */

      Start=Time;                           /* fa partire il timer del nodo */
      for(Livello=0;Livello<4;Livello++)         /* scandisce le 4 priorit… */
      {
	while( ((*Coda).istante[Livello]<Time) &&
	       ((Livello==0 && Time-Start<THT)
		||(Livello!=0 && TRT<T_Pri[Livello])) )
	{                          /* se ha token + coda piena => trasmette */
	  if(Livello==Priority)                       /* aggiorna parametri */
	  {
	    sum_ritardi+=Time-(*Coda).istante[Priority];          /* per AD */
	    num_ritardi++;

	    bit_trasmessi+=(*Coda).lunghezza[Priority]-12*8;      /* per TP */

	    if(Punto!=EXTRA_POINT)
	    {
	      if(Time-(*Coda).istante[Priority]<1) colonna=0;
	      else colonna=floor(4*log10(Time-(*Coda).istante[Priority]));
	      if(colonna>=16) colonna=15;
	      Matrice.intervallo_ritardi[Punto][Curva][colonna]++; /*ritardi*/
	      (*Coda).msg_spediti[Punto]++;                       /*Fairness*/
	    }
	  }
		   /* aumenta tempo globale e TRT del tempo di trasmissione */
	  Time+=((float)(*Coda).lunghezza[Livello])/(1000*Data_Rate)+
		 Percorso/200;
	  TRT +=((float)(*Coda).lunghezza[Livello])/(1000*Data_Rate)+
		 Percorso/200;

						 /* riempie daccapo la coda */
	  (*Coda).lunghezza[Livello]=floor(Lunghezza/2)+random(Lunghezza);
	  (*Coda).istante[Livello]+=Exp(WorkLoad[Livello]);
	}
				      /* aggiorna indicatori di avanzamento */
	if(Punto!=EXTRA_POINT)
	{
	  if(Priority==0)
	    Nuovo_Parziale=floor(8*(Time-T_Pri[0])/T_Simul);
	  else Nuovo_Parziale=
	    floor(8*(Time-T_Pri[0])*(Curva+1)/(3*T_Simul));
	  if(Nuovo_Parziale>7) Nuovo_Parziale=7;
	  if(Nuovo_Parziale>Avanzamento_Parziale)
	  {
	    Avanzamento_Parziale=Nuovo_Parziale;
	    Indicatori_Avanzamento(Punto,Avanzamento_Parziale);
	  }
	}
      }
    }
    Coda-=Nodi;
  }

  if (num_ritardi!=0) Access_Delay=sum_ritardi/(float)num_ritardi;
    else Access_Delay=0;                                 /* AD=[frames/sec] */
  ThroughPut=((float)bit_trasmessi)/(1000*Time);                 /*TP=[Mbps]*/
}

void TokenRing(unsigned Priority, unsigned Punto, unsigned Curva)
/* SIMULA IL PROTOCOLLO TOKEN RING UTILIZZANDO LE STESSE VARIABILI DEL
   PRECEDENTE CASO TOKEN BUS, MA E' ALQUANTO PIU' LABORIOSA E LENTA,
   IN QUANTO AD OGNI PASSAGGIO DI TOKEN BISOGNA DETERMINARE QUALE E' IL
   MESSAGGIO A PRIORITA' PIU' ELEVATA TRA QUELLI PRESENTI IN TUTTE LE
   STAZIONI. */
{
  float Start;              
  float sum_ritardi=0;
  float THT;
  unsigned Indice,IndPrior,Livello;
  unsigned long num_ritardi=0;
  unsigned colonna;
  unsigned long bit_trasmessi=0;
  unsigned Prior=3,Rent;
  unsigned Nodo_Impilatore[3],Prior_Precedente[3];
  unsigned Avanzamento_Parziale=0,Nuovo_Parziale; /* indicatori avanzamento */

  THT=T_Pri[0]/(float)Nodi;
  Time=T_Pri[0];           /* per ogni simulazione resetto il tempo globale */
  while(Time<T_Pri[0]+T_Simul)                      /* tempo di simulazione */
  {
    for(Indice=0;Indice<Nodi;Indice++,Coda++)
    {
      Time+=3*8/(1000*Data_Rate)+Percorso/((float)Nodi*200); /* trasm.token */
      Start=Time;                           /* fa partire il timer del nodo */

	     /* calcola la priorit… pi— elevata dei messaggi in coda (Rent) */
      Rent=3;
      Coda-=Indice;
      for(IndPrior=0;IndPrior<Nodi;IndPrior++,Coda++)
      {
	for(Livello=0;Livello<Rent;Livello++)
	{
	  if((*Coda).istante[Livello]<Time)
	  {
	    Rent=Livello;
	    break;
          }
	}
	if(Prior==0) break;
      }
      Coda-=IndPrior;
      Coda+=Indice;
		      /* confronta la priorit… attuale con quella prenotata */
      if(Rent<Prior)          /* aumenta la priorit… e impila la precedente */
      {
	Nodo_Impilatore[Rent]=Indice;
	Prior_Precedente[Rent]=Prior;
	Prior=Rent;
      }
      if((Rent>Prior)&&(Indice==Nodo_Impilatore[Prior]))
      {   /* la stazione che aveva impilato riabbassa alla prior.precedente */
	Prior=Prior_Precedente[Prior];
      }

      for(Livello=0;Livello<Prior+1;Livello++)
      {
	while(((*Coda).istante[Livello]<Time)&&(Time-Start<THT))
	{		           /* se ha token + coda piena => trasmette */
	  if(Livello==Priority)
	  {                                           /* aggiorna parametri */
	    sum_ritardi+=Time-(*Coda).istante[Priority];          /* per AD */
	    num_ritardi++;

	    bit_trasmessi+=(*Coda).lunghezza[Priority]-13*8;      /* per TP */

	    if(Punto!=EXTRA_POINT)
	    {
	      if(Time-(*Coda).istante[Priority]<1) colonna=0;
	      else colonna=floor(4*log10(Time-(*Coda).istante[Priority]));
	      if(colonna>=16) colonna=15;
	      Matrice.intervallo_ritardi[Punto][Curva][colonna]++; /*ritardi*/
	      (*Coda).msg_spediti[Punto]++;                       /*Fairness*/
	    }
	  }
		      /* aumenta il tempo globale del tempo di trasmissione */
	  Time+=((float)(*Coda).lunghezza[Livello])/(1000*Data_Rate);
						 /* riempie daccapo la coda */
	  (*Coda).lunghezza[Livello]=floor(Lunghezza/2)+random(Lunghezza);
	  (*Coda).istante[Livello]+=Exp(WorkLoad[Livello]);
	}
				      /* aggiorna indicatori di avanzamento */
	if(Punto!=EXTRA_POINT)
	{
	  if(Priority==0)
	    Nuovo_Parziale=floor(8*(Time-T_Pri[0])/T_Simul);
	  else Nuovo_Parziale=
	    floor(8*(Time-T_Pri[0])*(Curva+1)/(3*T_Simul));
	  if(Nuovo_Parziale>7) Nuovo_Parziale=7;
	  if(Nuovo_Parziale>Avanzamento_Parziale)
	  {
	    Avanzamento_Parziale=Nuovo_Parziale;
	    Indicatori_Avanzamento(Punto,Avanzamento_Parziale);
	  }
	}
      }
      Time+=Percorso/200;         /* tempo richiesto per arrivo tutte frame */
    }
    Coda-=Nodi;
  }

  if (num_ritardi!=0) Access_Delay=sum_ritardi/(float)num_ritardi;
    else Access_Delay=0;                                 /* AD=[frames/sec] */
  ThroughPut=((float)bit_trasmessi)/(1000*Time);                 /*TP=[Mbps]*/
}

void FDDI_Protocol(unsigned Priority, unsigned Punto, unsigned Curva)
/* SIMULA IL PROTOCOLLO FDDI IN MANIERA MOLTO SIMILE AL TOKEN BUS. */
{																			 /* con carico [frames/sec]. */
  float Start;		         
  float sum_ritardi=0;
  float TRT;
  unsigned Indice,Livello;
  unsigned long num_ritardi=0;
  unsigned colonna;
  unsigned long bit_trasmessi=0;
  unsigned Avanzamento_Parziale=0,Nuovo_Parziale; /* indicatori avanzamento */


  Time=T_Pri[0];           /* per ogni simulazione resetto il tempo globale */
  while(Time<T_Pri[0]+T_Simul)                      /* tempo di simulazione */
  {
    for(Indice=0;Indice<Nodi;Indice++,Coda++)
    {
      Time+=11*8/(1000*Data_Rate)+Percorso/((float)Nodi*200); /* trasm.token*/
      TRT=Time-(*Coda).last_token;               /* calcola TRT ultimo giro */
      (*Coda).last_token=Time;                /* aziona timer prossimo giro */

      for(Livello=0;Livello<4;Livello++)     /* scandisce 4 code a priorit… */
      {                                  /* meccanismo a soglia ( T_Pri[] ) */
	while(((*Coda).istante[Livello]<Time)&(TRT<T_Pri[Livello]))
	{		           /* se ha token + coda piena => trasmette */
	  if(Livello==Priority)
	  {                                           /* aggiorna parametri */
	    sum_ritardi+=Time-(*Coda).istante[Priority];          /* per AD */
	    num_ritardi++;

	    bit_trasmessi+=(*Coda).lunghezza[Priority]-21*8;      /* per TP */

	    if(Punto!=EXTRA_POINT)
	    {
	      if(Time-(*Coda).istante[Priority]<1) colonna=0;
	      else colonna=floor(4*log10(Time-(*Coda).istante[Priority]));
	      if(colonna>=16) colonna=15;
	      Matrice.intervallo_ritardi[Punto][Curva][colonna]++; /*ritardi*/
	      (*Coda).msg_spediti[Punto]++;                       /*Fairness*/
	    }
	  }
		   /* aumenta tempo globale e TRT del tempo di trasmissione */
	  Time+=((float)(*Coda).lunghezza[Livello])/(1000*Data_Rate);
	  TRT+=((float)(*Coda).lunghezza[Livello])/(1000*Data_Rate);

						 /* riempie daccapo la coda */
	  (*Coda).lunghezza[Livello]=floor(Lunghezza/2)+random(Lunghezza);
	  (*Coda).istante[Livello]+=Exp(WorkLoad[Livello]);
	}
				      /* aggiorna indicatori di avanzamento */
	if(Punto!=EXTRA_POINT)
	{
	  if(Priority==0)
	    Nuovo_Parziale=floor(8*(Time-T_Pri[0])/T_Simul);
	  else Nuovo_Parziale=
	    floor(8*(Time-T_Pri[0])*(Curva+1)/(3*T_Simul));
	  if(Nuovo_Parziale>7) Nuovo_Parziale=7;
	  if(Nuovo_Parziale>Avanzamento_Parziale)
	  {
	    Avanzamento_Parziale=Nuovo_Parziale;
	    Indicatori_Avanzamento(Punto,Avanzamento_Parziale);
	  }
	}
      }
    }
    Coda-=Nodi;
  }

  if (num_ritardi!=0) Access_Delay=sum_ritardi/(float)num_ritardi;
    else Access_Delay=0;                                 /* AD=[frames/sec] */
  ThroughPut=((float)bit_trasmessi)/(1000*Time);                 /*TP=[Mbps]*/
}

void Protocollo(unsigned Priority,unsigned Protocol,unsigned Punto,unsigned Curva)
/* E' LA FUNZIONE CHE IN BASE ALLE SCELTE INIZIALI DA MENU PROVVEDE A
   SELEZIONARE IL PRESCELTO PROTOCOLLO DA SIMULARE.
   I PARAMETRI DA PASSARE SONO GLI STESSI DELLE TRE PROCEDURE TOKEN BUS,
   TOKEN RING E FDDI, COSI' COME DESCRITTI ALL'INIZIO DEL TOKEN BUS;
   E' ALTRESI' PRESENTE UN ULTERIORE PARAMETRO "PROTOCOL" CHE PROVVEDE
   APPUNTO A SELEZIONARE IL PROTOCOLLO PRESCELTO DALL'UTENTE. */
{
  Point_Reset();                    /* setta istante,lunghezza e last_token */

  switch(Protocol)
  {
    case TOKEN_BUS: TokenBus(Priority,Punto,Curva); break;
    case TOKEN_RING: TokenRing(Priority,Punto,Curva); break;
    case FDDI: FDDI_Protocol(Priority,Punto,Curva); break;
  }
}

void Grafici(unsigned Priority,unsigned Protocol)
/* PREPARA LA SCHERMATA SU CUI VISUALIZZARE I RISULTATI GRAFICI DELLA
   SIMULAZIONE. */
{
  char Stampa[20];
  float Scala;
  unsigned x;

  setfillstyle(SOLID_FILL,RED);                      /* riquadro ThroughPut */
  bar(250,25,610,205);
  setfillstyle(SOLID_FILL,DARKGRAY);               /* riquadro Access Delay */
  bar(250,225,610,405);
  setfillstyle(SOLID_FILL,MAGENTA);                      /* riquadro titolo */
  bar(10,20,158,80);

  setcolor(YELLOW);                                   /* bordi dei riquadri */
  setlinestyle(SOLID_LINE,SOLID_FILL,3);
  rectangle(249,23,611,207);
  rectangle(249,223,611,407);
  rectangle(10,20,158,80);

  setcolor(WHITE);
  setlinestyle(DOTTED_LINE,SOLID_FILL,1);
  for(x=0;x<5;x++) line(250+90*x,25,250+90*x,405);        /* linee workload */
  for(x=0;x<3;x++) line(250,25+45*(x+1),610,25+45*(x+1));/* linee throughp. */
  for(x=0;x<3;x++) line(250,225+45*(x+1),610,225+45*(x+1));/* linee acc-del.*/

  if(Priority!=0)
  {
    setcolor(WHITE);
    settextstyle(SMALL_FONT,HORIZ_DIR,4);
    outtextxy(255,25,"Banda occupata");
    outtextxy(300,37,"25%");
    outtextxy(300,47,"50%");
    outtextxy(300,57,"75%");
    setlinestyle(SOLID_LINE,SOLID_FILL,THICK_WIDTH);
    setcolor(BLUE); line(270,42,290,42);
    setcolor(GREEN); line(270,52,290,52);
    setcolor(CYAN); line(270,62,290,62);
  }

  setcolor(WHITE);                                            /* didascalie */
  settextstyle(TRIPLEX_FONT,HORIZ_DIR,2);
  switch(Protocol)
  {
    case TOKEN_BUS : outtextxy(30,25,"Token Bus");  break;
    case TOKEN_RING: outtextxy(27,25,"Token Ring"); break;
    case FDDI      : outtextxy(50,25,"F D D I");    break;
  }
  outtextxy(35,48,"priorit…");
  itoa(4-Priority,Stampa,10);
  outtextxy(123,48,Stampa);

  settextstyle(SMALL_FONT,HORIZ_DIR,5);
  setcolor(WHITE);
  outtextxy(345,5,"WorkLoad");
  outtextxy(247-textwidth("ThroughPut"),30,"ThroughPut");
  outtextxy(247-textwidth("Access"),234,"Access");
  outtextxy(247-textwidth("Delay"),249,"Delay");
  outtextxy(40,406,"Access Delay");
  setcolor(GREEN);
  outtextxy(430,5,"[frames/sec]");
  outtextxy(247-textwidth("[Mbps]"),45,"[Mbps]");
  outtextxy(247-textwidth("[msec]"),280,"[msec]");
  outtextxy(25-textwidth("[%]"),277,"[%]");
  outtextxy(155,406,"[msec]");

  setcolor(CYAN);

  for(x=0;x<5;x++)                                    /* scala del WorkLoad */
  {
    Scala=x*(WL_max)/4;
    gcvt(Scala,4,Stampa);
    outtextxy(253+x*90,207,Stampa);
  }

  for(x=0;x<4;x++)                                  /* scala del ThroughPut */
  {
    Scala=TP_max*(4-x)/4;
    if(Scala>0)
    {
      gcvt(Scala,2+ceil(log10(Scala)),Stampa);
      outtextxy(247-textwidth(Stampa),16+x*45,Stampa);
    }
  }
  outtextxy(234,196,"0");

  for(x=0;x<4;x++)                               /* scala dell'Access Delay */
  {
    Scala=AD_max*(4-x)/4;
    if(Scala>=1)
    {
      gcvt(Scala,1+ceil(log10(Scala)),Stampa);
      outtextxy(247-textwidth(Stampa),220+x*45,Stampa);
    }
  }
  outtextxy(234,400,"0");

  for(x=0;x<5;x++)                       /* percentuali della distribuzione */
  {
    Scala=25*x;
    gcvt(Scala,3,Stampa);
    outtextxy(25-textwidth(Stampa),382-x*30,Stampa);
  }

  for(x=0;x<5;x++)                           /* secondi della distribuzione */
  {
    Scala=pow10(x);
    gcvt(Scala,10,Stampa);
    outtextxy(22+x*40,393,Stampa);
  }
}

void Plotter(unsigned Curva)
/* TRACCIA GRAFICAMENTE I RISULTATI MEMORIZZATI NELLA TABELLA "MATRICE"
   SUI SISTEMI DI ASSI CARTESIANI DI THROUGHPUT E ACCESS-DELAY. */
{                         /* traccia graficamente i risultati della tabella */
  unsigned Punto;
  long TP_new,AD_new,TP_old=205,AD_old=405;

  setlinestyle(SOLID_LINE,SOLID_FILL,THICK_WIDTH);
  for(Punto=1;Punto<9;Punto++)
  {
    TP_new=205-floor(180*Matrice.throughput[Punto][Curva]/TP_max);
    if(TP_new<26) TP_new=26;
    if(TP_new>204) TP_new=204;
/*    if(TP_new>TP_old) TP_new=TP_old;      /* rende funzione non decrescente */

    AD_new=405-floor(180*Matrice.access_delay[Punto][Curva]/AD_max);
    if(AD_new<226) AD_new=226;
    if(AD_new>404) AD_new=404;
/*    if(AD_new>AD_old) AD_new=AD_old;      /* rende funzione non decrescente */

    line(250+(Punto-1)*45,TP_old,250+Punto*45,TP_new);
/*  if(AD_old!=225)*/ line(250+(Punto-1)*45,AD_old,250+Punto*45,AD_new);

    TP_old=TP_new;
    AD_old=AD_new;
  }
}

void Distribuzione(unsigned Punto, unsigned Curva)
/* VISUALIZZA L'ISTOGRAMMA CON LA DISTRIBUZIONE DEI RITARDI. */
{
  unsigned Altezza;
  unsigned long Somma=0;
  unsigned Colonna;

  setfillstyle(SOLID_FILL,BLACK);
  bar(28,270,190,392);

  setlinestyle(SOLID_LINE,SOLID_FILL,3);        /* assi della distribuzione */
  setcolor(WHITE);
  line(28,392,190,392);
  line(28,392,28,270);

  for(Colonna=0;Colonna<16;Colonna++)
    Somma+=Matrice.intervallo_ritardi[Punto][Curva][Colonna];

  if(Somma)
  {
    for(Colonna=0;Colonna<16;Colonna++)
    {
      if(Colonna==WHITE) setfillstyle(SOLID_FILL,GREEN);
      else setfillstyle(SOLID_FILL,Colonna+1);
      Altezza=floor(120*Matrice.intervallo_ritardi[Punto][Curva][Colonna]/Somma);
      bar(30+Colonna*10,390,39+Colonna*10,390-Altezza);
    }
  }
}

void Fairness(unsigned Punto)
/* VISUALIZZA L'ISTOGRAMMA DELLA FAIRNESS, OVVERO RAFFIGURANTE QUANTI
   MESSAGGI HA SPEDITO OGNI STAZIONE RISPETTO AL VALOR MEDIO (QUANTO PIU'
   PICCOLI SONO GLI SCOSTAMENTI DALLA MEDIA, TANTO MAGGIORE SARA'
   L'EQUANIMITA' DI TRATTAMENTO DEL PROTOCOLLO ADOPERATO). */
{
  unsigned Indice;
  unsigned Larghezza,Altezza,Media;
  unsigned long Somma=0;
  unsigned NodiFair;

  for(Indice=0;Indice<Nodi;Indice++,Coda++)
    Somma+=(*Coda).msg_spediti[Punto];
  Coda-=Nodi;
  Media=Somma/Nodi;

  if(Media)
  {
    if(Nodi>180) NodiFair=180;
    else NodiFair=Nodi;

    Larghezza=ceil(180/NodiFair);

    setfillstyle(SOLID_FILL,GREEN);
    bar(10,100,10+Larghezza*NodiFair,250);
    setcolor(YELLOW);
    rectangle(8,98,12+Larghezza*NodiFair,252);

    for(Indice=0;Indice<NodiFair;Indice++,Coda++)
    {
      if(((float)(Indice))/2-(float)(Indice/2))
	setfillstyle(SOLID_FILL,BROWN);
      else setfillstyle(SOLID_FILL,BLUE);
      Altezza=75*(*Coda).msg_spediti[Punto]/Media;
      if(Altezza>150) Altezza=150;
      bar(10+Larghezza*Indice,250,10+Larghezza*(Indice+1),250-Altezza);
    }
    Coda-=NodiFair;

    setcolor(WHITE);
    setlinestyle(DOTTED_LINE,SOLID_FILL,NORM_WIDTH);
    line(10,175,10+Larghezza*NodiFair,175);
    setlinestyle(SOLID_LINE,SOLID_FILL,THICK_WIDTH);

    settextstyle(SMALL_FONT,HORIZ_DIR,5);
    outtextxy(10+(Larghezza*NodiFair-textwidth("Fairness"))/2,220,"Fairness");
  }
  setlinestyle(SOLID_LINE,SOLID_FILL,THICK_WIDTH);
}

unsigned Priority_Input(unsigned Protocol)
/* AD INIZIO DI SIMULAZIONE RICHIEDE QUALE SIA LA PRIORITA' CHE SI DESIDERA
   VALUTARE. */
{
  int Priority;
  char Stampa[5];

  cleardevice();                                                 /* cornice */
  setfillstyle(SOLID_FILL,RED);
  bar(100,10,540,125);
  setcolor(YELLOW);
  rectangle(100,10,540,125);

  setcolor(WHITE);                                            /* didascalie */
  settextstyle(TRIPLEX_FONT,HORIZ_DIR,5);
  outtextxy(320-textwidth("Selezione Priorit…")/2,70,"Selezione Priorit…");
  switch(Protocol)
  {
    case TOKEN_BUS:
      outtextxy(320-textwidth("Token Bus")/2,15,"Token Bus"); break;
    case TOKEN_RING:
      outtextxy(320-textwidth("Token Ring")/2,10,"Token Ring"); break;
    case FDDI:
      outtextxy(320-textwidth("F D D I")/2,10,"F D D I"); break;
  }

  settextstyle(TRIPLEX_FONT,HORIZ_DIR,4);
  setcolor(WHITE);
  outtextxy(35,150,"Seleziona la priorit… di cui vuoi");
  outtextxy(35,180,"valutare le prestazioni mediante");
  outtextxy(35,210,"i tasti freccia destra/sinistra,");
  outtextxy(35,240,"e confermando con Invio :");
  outtextxy(35,380,"(la priorit… 4 Š la pi— elevata)");
  outtextxy(35,410,"(Esc torna al menu principale)");

  setcolor(CYAN);
  settextstyle(TRIPLEX_FONT,HORIZ_DIR,6);
  for(Priority=0;Priority<4;Priority++)
  {
    itoa(4-Priority,Stampa,10);
    outtextxy(120+100*Priority,300,Stampa);
  }

  Beep();
  setlinestyle(SOLID_LINE,SOLID_FILL,THICK_WIDTH);
  setcolor(MAGENTA);
  Priority=0;
  circle(133+100*Priority,334,35);

  do
  {
    Tasto=getch();

    if(Tasto==75 & Priority!=0)
    {
      setcolor(BLACK);
      circle(133+100*Priority,334,35);
      Priority--;
      setcolor(MAGENTA);
      circle(133+100*Priority,334,35);
      Beep();
    }

    if(Tasto==77 & Priority!=3)
    {
      setcolor(BLACK);
      circle(133+100*Priority,334,35);
      Priority++;
      setcolor(MAGENTA);
      circle(133+100*Priority,334,35);
      Beep();
    }
  } while(Tasto!=13 & Tasto!=27);

  if(Tasto==13) return(Priority);
  else return(4);
}

void Tabulatore(unsigned Tab)
/* DISEGNA SULL'ASSE DEL WORKLOAD UN TRIANGOLO CHE INDICA A QUALE CARICO
   CORRISPONDONO I DUE ISTOGRAMMI DELLA FAIRNESS E DELLA DISTRIBUZIONE DEI
   RITARDI (PUO' ESSERE SPOSTATO A CON LE FRECCE SX/DX). */
{
  int Triangolo[6];

  Triangolo[0]=250+45*Tab;
  Triangolo[1]=410;
  Triangolo[2]=240+45*Tab;
  Triangolo[3]=423;
  Triangolo[4]=260+45*Tab;
  Triangolo[5]=423;

  setcolor(BLACK);
  setlinestyle(SOLID_LINE,SOLID_FILL,NORM_WIDTH);
  fillpoly(3,Triangolo);
}

void Stampa_Matrice(unsigned Priority, unsigned Protocol)
/* STAMPA LA TABELLA CON I RISULTATI NUMERICI DELLA SIMULAZIONE
   E GLI SFONDI PER GLI INDICATORI DI AVANZAMENTO TOTALI E PARZIALI. */
{
  char Stampa[20];
  unsigned Pallino,Curva;

  cleardevice();                           /* stampa il riquadro del titolo */
  setfillstyle(SOLID_FILL,RED);
  bar(100,20,540,70);
  setlinestyle(SOLID_LINE,SOLID_FILL,THICK_WIDTH);
  setcolor(YELLOW);
  rectangle(100,20,540,70);
  setcolor(WHITE);
  settextstyle(TRIPLEX_FONT,HORIZ_DIR,4);
  switch(Protocol)
  {
    case TOKEN_BUS:
      moveto(320-textwidth("Token Bus - Priorit… X")/2,25);
      outtext("Token Bus - Priorit… ");
      gcvt(4-Priority,2,Stampa);
      outtext(Stampa); break;
    case TOKEN_RING:
      moveto(320-textwidth("Token Ring - Priorit… X")/2,25);
      outtext("Token Ring - Priorit… ");
      gcvt(4-Priority,2,Stampa);
      outtext(Stampa); break;
    case FDDI:
      moveto(320-textwidth("F D D I - Priorit… X")/2,25);
      outtext("F D D I - Priorit… ");
      gcvt(4-Priority,2,Stampa);
      outtext(Stampa); break;
  }

  setfillstyle(SOLID_FILL,MAGENTA);                   /* disegna la matrice */
  bar(100,90,620,120);
  setfillstyle(SOLID_FILL,LIGHTGRAY);
  bar(100,120,620,300);
  setcolor(BLUE);
  setlinestyle(SOLID_LINE,SOLID_FILL,THICK_WIDTH);
  rectangle(100,90,620,300);
  line(100,120,620,120);
  line(220,90,220,300);
  line(420,90,420,300);
  setlinestyle(DOTTED_LINE,SOLID_FILL,NORM_WIDTH);
  for(Pallino=1;Pallino<9;Pallino++)
    line(100,120+20*Pallino,620,120+20*Pallino);
  line(287,120,287,300);
  line(353,120,353,300);
  line(487,120,487,300);
  line(553,120,553,300);

  settextstyle(SMALL_FONT,HORIZ_DIR,5);       /* intestazione della matrice */
  setcolor(WHITE);
  outtextxy(160-textwidth("WorkLoad")/2,90,"WorkLoad");
  outtextxy(320-textwidth("ThroughPut")/2,90,"ThroughPut");
  outtextxy(520-textwidth("Access-Delay")/2,90,"Access-Delay");
  settextstyle(SMALL_FONT,HORIZ_DIR,5);
  setcolor(LIGHTGREEN);
  outtextxy(160-textwidth("[frames/sec]")/2,103,"[frames/sec]");
  outtextxy(320-textwidth("[Mbps]")/2,103,"[Mbps]");
  outtextxy(520-textwidth("[msec]")/2,103,"[msec]");

  setfillstyle(SOLID_FILL,RED);              /* disegna i pallini dei punti */
  settextstyle(SMALL_FONT,HORIZ_DIR,5);
  setlinestyle(SOLID_LINE,SOLID_FILL,THICK_WIDTH);
  for(Pallino=0;Pallino<9;Pallino++)
  {
    setcolor(YELLOW);
    fillellipse(75,100+40*Pallino,6,6);
    setcolor(WHITE);
    moveto(5,92+40*Pallino);
    outtext("Punto ");
    gcvt(Pallino,3,Stampa);
    outtext(Stampa);
  }

  setcolor(GREEN);                      /* taglia il pallino del punto zero */
  setlinestyle(SOLID_LINE,SOLID_FILL,THICK_WIDTH);
  line(65,90,85,110);
  line(65,110,85,90);

  settextstyle(SMALL_FONT,HORIZ_DIR,5);
  setcolor(BLACK);
  outtextxy(200-textwidth("0"),122,"0");
  if(Priority==0)
  {
    outtextxy(350-textwidth("0"),122,"0");
    outtextxy(550-textwidth("0"),122,"0");
  }
  else for(Curva=0;Curva<3;Curva++)
  {
    outtextxy(284+66*Curva-textwidth("0"),122,"0");
    outtextxy(484+66*Curva-textwidth("0"),122,"0");
  }

  setcolor(YELLOW);                        /* indicatore avanzamento totale */
  setfillstyle(SOLID_FILL,CYAN);
  fillellipse(550,390,70,70);
  setfillstyle(SOLID_FILL,RED);
  setlinestyle(SOLID_LINE,SOLID_FILL,NORM_WIDTH);
  settextstyle(SMALL_FONT,HORIZ_DIR,5);
  setcolor(WHITE);
  outtextxy(420,320,"Avanzamento");
  outtextxy(430,335,"Totale :");

  setfillstyle(SOLID_FILL,GREEN);        /* indicatore avanzamento parziale */
  bar(200,320,400,350);
  setcolor(BLUE);
  setlinestyle(SOLID_LINE,SOLID_FILL,THICK_WIDTH);
  rectangle(200,320,400,350);
  setcolor(WHITE);
  outtextxy(195-textwidth("Avanzamento"),320,"Avanzamento");
  outtextxy(195-textwidth("Parziale :"),335,"Parziale :");

  setcolor(CYAN);
  settextstyle(TRIPLEX_FONT,HORIZ_DIR,5);
  outtextxy(155,375,"Thinking...");
}

void Aggiorna_Matrice(unsigned Priority, unsigned Punto)
/* MAN MANO CHE LA SIMULAZIONE PROCEDE AGGIORNA LA TABELLA DEI RISULTATI
   IN TEMPO REALE. */
{
  char Stampa[20];
  unsigned Curva;

  setfillstyle(SOLID_FILL,GREEN);         /* indicatore avanzamento parziale */
  bar(200,320,400,350);
  setcolor(BLUE);
  setlinestyle(SOLID_LINE,SOLID_FILL,THICK_WIDTH);
  rectangle(200,320,400,350);

  setcolor(GREEN);                           /* taglia il pallino del punto */
  setlinestyle(SOLID_LINE,SOLID_FILL,THICK_WIDTH);
  line(65,90+40*Punto,85,110+40*Punto);
  line(65,110+40*Punto,85,90+40*Punto);

  settextstyle(SMALL_FONT,HORIZ_DIR,5);
  setcolor(BLACK);
  gcvt(Matrice.workload[Punto],4,Stampa);
  outtextxy(200-textwidth(Stampa),122+20*Punto,Stampa);

  if(Priority==0)
  {
    if(Matrice.throughput[Punto][0]>0)
      gcvt(Matrice.throughput[Punto][0],
	3+ceil(log10(Matrice.throughput[Punto][0])),Stampa);
    else gcvt(0,2,Stampa);
    outtextxy(350-textwidth(Stampa),122+20*Punto,Stampa);

    if(Matrice.access_delay[Punto][0]>0)
      gcvt(Matrice.access_delay[Punto][0],
	1+ceil(log10(Matrice.access_delay[Punto][0])),Stampa);
    else gcvt(0,2,Stampa);
    outtextxy(550-textwidth(Stampa),122+20*Punto,Stampa);
  }
  else for(Curva=0;Curva<3;Curva++)
  {
    if(Matrice.throughput[Punto][Curva]>0)
      gcvt(Matrice.throughput[Punto][Curva],
	2+ceil(log10(Matrice.throughput[Punto][Curva])),Stampa);
    else gcvt(0,2,Stampa);
    outtextxy(284+66*Curva-textwidth(Stampa),122+20*Punto,Stampa);

    if(Matrice.access_delay[Punto][Curva]>0)
      gcvt(Matrice.access_delay[Punto][Curva],
	1+ceil(log10(Matrice.access_delay[Punto][Curva])),Stampa);
    else gcvt(0,2,Stampa);
    outtextxy(484+66*Curva-textwidth(Stampa),122+20*Punto,Stampa);
  }
}

void Stampa_Tasti_Matrice(unsigned Priority)
/* ALLA FINE DELLA SIMULAZIONE VISUALIZZA IL RIQUADRO CON LE OPZIONI
   SUCCESSIVE. */
{
  setfillstyle(SOLID_FILL,RED);              /* completa avanzamento totale */
  setcolor(YELLOW);
  setlinestyle(SOLID_LINE,SOLID_FILL,THICK_WIDTH);
  fillellipse(550,390,70,70);

  setfillstyle(SOLID_FILL,BLUE);              /* rettangolo con indicazioni */
  bar(100,320,400,460);
  setcolor(YELLOW);
  rectangle(100,320,400,460);

  if(Priority==0)
  {
    settextstyle(SMALL_FONT,HORIZ_DIR,6);
    moveto(108,350);
    setcolor(LIGHTRED); outtext("SPAZIO - ");
    setcolor(WHITE); outtext("Mostra i grafici");
    moveto(108,400);
    setcolor(LIGHTRED); outtext("Esc - ");
    setcolor(WHITE); outtext("Torna al menu principale");
  }
  else
  {
    settextstyle(SMALL_FONT,HORIZ_DIR,5);
    setcolor(LIGHTGREEN);
    moveto(113,320); outtext("Nota: ");
    setcolor(WHITE);
    outtext("per simulazioni di priorit…");
    outtextxy(113,335,"inferiori alla 4, le colonne dei");
    outtextxy(113,350,"risultati sono triple perch‚ si");
    outtextxy(113,365,"riferiscono rispettivamente ai casi");
    outtextxy(113,380,"in cui la banda Š occupata per il");
    outtextxy(113,395,"25,50 e 75% dalle priorit… superiori.");
 
    moveto(120,420);
    setcolor(LIGHTRED); outtext("SPAZIO - ");
    setcolor(WHITE); outtext("Mostra i grafici");
    moveto(120,435);
    setcolor(LIGHTRED); outtext("Esc - ");
    setcolor(WHITE); outtext("Torna al menu principale");
  }
}

void Stampa_Grafici(unsigned Priority,unsigned Protocol,unsigned Tab)
/* NEL CASO IN CUI SIA STATO RICHIESTO VISUALIZZA I GRAFICI DI TUTTE LE
   SIMULAZIONI PRECEDENTEMENTE EFFETTUATE I CUI RISULTATI NUMERICI ERANO
   STATI VISUALIZZATI NELLA TABELLA. */
{
  unsigned Curva,Tasto;

  TP_max=Data_Rate;                                               /* TP_max */
  if(Priority==0) AD_max=Matrice.access_delay[4][0];
  else AD_max=Matrice.access_delay[4][1];
  if(AD_max<100) AD_max=100;

  cleardevice();
  Grafici(Priority,Protocol);
  if(Priority==0)
  {
    setcolor(CYAN);
    Plotter(0);
  }
  else for(Curva=0;Curva<3;Curva++)
  {
    setcolor(Curva+1);
    Plotter(Curva);
  }
  setfillstyle(SOLID_FILL,LIGHTGRAY);
  Tabulatore(Tab);
  if(Priority==0) Distribuzione(Tab,0);
  else Distribuzione(Tab,1);
  Fairness(Tab);
  Beep();
}

void Stampa_Tasti_Grafici(unsigned Priority)
/* VISUALIZZA LE OPZIONI SUCCESSIVE ALLA STAMPA DEI GRAFICI. */
{
  setfillstyle(SOLID_FILL,BLACK);
  bar(0,425,640,480);
  settextstyle(SMALL_FONT,HORIZ_DIR,5);
  if(Priority!=0)
  {
    moveto(1,425);
    setcolor(LIGHTRED); outtext("Frecce - "); setcolor(WHITE);
    outtext("modificano WorkLoad e Occup.Banda a cui visualizzare istogrammi");

    moveto(1,440);
    setcolor(LIGHTRED); outtext("Spazio - ");
    setcolor(WHITE); outtext("ritorna alla tabella dei dati");
    moveto(1,455);
    setcolor(LIGHTRED); outtext("Esc - ");
    setcolor(WHITE); outtext("torna al menu principale");

    moveto(320,440);
    setcolor(LIGHTRED); outtext("F1 - ");
    setcolor(WHITE); outtext("simulazione singola");
  }
  else
  {
    moveto(1,425);
    setcolor(LIGHTRED); outtext("Freccie - "); setcolor(WHITE);
    outtext("modificano il WorkLoad a cui visualizzare istogrammi");

    moveto(1,440);
    setcolor(LIGHTRED); outtext("Spazio - ");
    setcolor(WHITE); outtext("ritorna alla tabella dei dati");
    moveto(1,455);
    setcolor(LIGHTRED); outtext("Esc - ");
    setcolor(WHITE); outtext("torna al menu principale");

    moveto(320,440);
    setcolor(LIGHTRED); outtext("F1 - ");
    setcolor(WHITE); outtext("simulazione singola");
  }
}

void Simulazione_Singola(void)
/* QUESTA OPZIONE PUO' ESSERE VISUALIZZATA DALLA PAGINA DEI GRAFICI PER
   EFFETTUARE NON UNA CAMPAGNA DI SIMULAZIONI MA UNA SIMULAZIONE SINGOLA,
   CIOE' AD UN WORKLOAD PREFISSATO. */
{
  char Buffer[20];
  unsigned Tasto,Setta_WL;
  float WL;
  unsigned Priority,Protocol,Curva;

  Beep();
  settextstyle(SMALL_FONT,HORIZ_DIR,5);
  setcolor(WHITE);

  setfillstyle(SOLID_FILL,BLACK); bar(0,425,640,480);
  outtextxy(10,430,"Premi il tasto corrispondente al Protocollo da simulare :");
  outtextxy(100,450,"1=TokenBus , 2=TokenRing , 3=FDDI");
  do Tasto=getch();
  while(Tasto!=49 && Tasto!=50 && Tasto!=51);
  Beep();
  Protocol=Tasto-49;

  setfillstyle(SOLID_FILL,BLACK); bar(0,425,640,480);
  outtextxy(10,430,"Premi il tasto corrispondente alla Priorit… da simulare :");
  outtextxy(100,450,"1  -  2  -  3  -  4");
  do Tasto=getch();
  while(Tasto<49 && Tasto>52);
  Beep();
  Priority=52-Tasto;

  if(Priority==0)
    Curva=0;
  else
  {
    setfillstyle(SOLID_FILL,BLACK); bar(0,425,640,480);
    outtextxy(10,430,"Premi il tasto corrispondente all'occupazione desiderata della banda :");
    outtextxy(100,450,"1=25% , 2=50% , 3=75%");
    do Tasto=getch();
    while(Tasto!=49 && Tasto!=50 && Tasto!=51);
    Beep();
    Curva=Tasto-49;
  }

  setfillstyle(SOLID_FILL,BLACK); bar(0,425,640,480);
  setcolor(WHITE);
  outtextxy(10,430,"Inserisci il WorkLoad a cui vuoi effettuare la simulazione");
  outtextxy(10,450,"( il prompt Š in alto nella pagina sopra il titolo )");
  gotoxy(1,1); printf(" > ");
  WL=atof(gets(Buffer));
  Beep();
  gotoxy(1,1); printf("               ");

  if(Priority==0) WL_max=2*1e6*Data_Rate/(float)(Nodi*Lunghezza);
    else WL_max=1e6*Data_Rate/(float)(Nodi*Lunghezza);
  for(Setta_WL=0;Setta_WL<4;Setta_WL++) WorkLoad[Setta_WL]=1;

  setfillstyle(SOLID_FILL,BLACK); bar(0,425,640,480);
  setcolor(LIGHTRED);
  moveto(10,425); outtext("Simulazione effettuata a WorkLoad = ");
  gcvt(WL,5,Buffer); setcolor(WHITE);
  outtext(Buffer); outtext(" frames/sec ");
  setcolor(LIGHTGRAY); outtext("(premi tasto per comandi):");

  if(Priority==0)           /* effettua la simulazione e stampa i risultati */
  {
    WorkLoad[0]=WL;
    Protocollo(Priority,Protocol,EXTRA_POINT,0);
  }
  else
  {
    WorkLoad[0]=WL_max*0.25*(float)(Curva+1);
    WorkLoad[Priority]=WL;
    Protocollo(Priority,Protocol,EXTRA_POINT,Curva);
  }

  setcolor(LIGHTGREEN);
  moveto(100,440); outtext("ThroughPut = ");
  gcvt(ThroughPut,5,Buffer); setcolor(WHITE);
  outtext(Buffer); outtext(" Mbps");

  setcolor(LIGHTGREEN);
  moveto(100,455); outtext("Access-Delay = ");
  gcvt(Access_Delay,5,Buffer); setcolor(WHITE);
  outtext(Buffer); outtext(" msec");

  getch();
}

void Stampa_Punto(unsigned Tab,unsigned Curva,unsigned Colore,unsigned Priority)
/* STAMPA SUL GRAFICO IL PUNTO CHE SARA' POSSIBILE MUOVERE SULLE CURVE CON
   I TASTI CURSORE MODIFICANDO IL WORKLOAD E L'OCCUPAZIONE DELLA BANDA. */
{
  unsigned TP,AD;

  if(Priority==0)
  {
    Curva=0;
    if(Colore!=WHITE) Colore=CYAN;
  }

  TP=205-floor(180*Matrice.throughput[Tab][Curva]/TP_max);
  if(TP<26||TP>205) TP=26;
  if(TP==205) TP=204;

  AD=405-floor(180*Matrice.access_delay[Tab][Curva]/AD_max);
  if(AD<226||AD>405) AD=226;
  if(AD==405) AD=404;

  setlinestyle(SOLID_LINE,SOLID_FILL,THICK_WIDTH);
  setcolor(Colore);
  circle(250+Tab*45,TP,1);
  circle(250+Tab*45,AD,1);
}

void Simulatore(unsigned Protocol)
/* QUESTA FUNZIONE E' IL VERO CERVELLO DELLA SIMULAZIONE, IN QUANTO
   CORRISPONDE ALL'OPZIONE CHE DA MENU LANCIA UNA DELLE TRE SIMULAZIONI
   (PASSO INFATTI IL PARAMETRO Protocol). ESSA PROVVEDE A CHIEDERE QUALE
   LIVELLO DI PRIORITA' SIMULARE, DOPODICHE' EFFETTUA LA CAMPAGNA DI
   SIMULAZIONI MEMORIZZANDO TUTTI I RISULTATI NELLA STRUTTURA Matrice,
   E VISUALIZZANDOLI NEL CONTEMPO SULLO SCHERMO NELLA TABELLA.
   LA CAMPAGNA DI SIMULAZIONI VIENE ESEGUITA MEDIANTE CHIAMATE ALLA
   FUNZIONE Protocollo, E LA MATRICE VIENE PERIODICAMENTE AGGIORNATA
   CON Aggiorna_Matrice. ALLA FINE DELLA CAMPAGNA DI SIMULAZIONI E'
   POSSIBILE, MEDIANTE LA PRESSIONE DELLA BARRA SPAZIO, ESEGUIRE PIU'
   SWITCH TRA LA PAGINA DEI GRAFICI E LA PAGINA DELLA TABELLA. */
{
  unsigned Priority,Punto,Curva,Setta_WL,Switch=0,Tab=4;
  char Tasto;

  Coda=(struct nodo *) calloc(Nodi,sizeof(struct nodo));
  if(Coda==NULL)
  {
    printf("\nMemoria insufficiente.\n\n");
    exit(EXIT_FAILURE);
  }

  Priority=Priority_Input(Protocol);
  if(Priority!=4)                   /* se non premo Esc scegliendo priorit… */
  {
    Screen_Reset();               /* setta msg_spediti e intervallo-ritardi */
    Stampa_Matrice(Priority,Protocol);
    Beep();

    if(Priority==0) WL_max=2*1e6*Data_Rate/(float)(Nodi*Lunghezza);
    else WL_max=1e6*Data_Rate/(float)(Nodi*Lunghezza);
    for(Setta_WL=0;Setta_WL<4;Setta_WL++) WorkLoad[Setta_WL]=1;

    for(Punto=1;Punto<9;Punto++)
    {
      Matrice.workload[Punto]=WL_max*((float)Punto)/8;
      WorkLoad[Priority]=Matrice.workload[Punto];
      if(Priority==0)
      {
	Protocollo(Priority,Protocol,Punto,0);
	Matrice.throughput[Punto][0]=ThroughPut;
	Matrice.access_delay[Punto][0]=Access_Delay;
      }
      else for(Curva=0;Curva<3;Curva++)           /* 3 curve banda occupata */
      {
	WorkLoad[0]=WL_max*0.25*(float)(Curva+1); /* carico del 25%,50%,75% */
	Protocollo(Priority,Protocol,Punto,Curva);
	Matrice.throughput[Punto][Curva]=ThroughPut;
	Matrice.access_delay[Punto][Curva]=Access_Delay;
      }
      Aggiorna_Matrice(Priority,Punto);
      Beep();
    }
    Stampa_Tasti_Matrice(Priority);

    do Tasto=getch();
    while(Tasto!=27 & Tasto!=32);

    do
    {
      if(Tasto==32)
      {
	if(Switch==1)
	{
	  Beep();
	  Stampa_Matrice(Priority,Protocol);
	  for(Punto=1;Punto<9;Punto++)
	  {
	    Aggiorna_Matrice(Priority,Punto);
	  }
	  Stampa_Tasti_Matrice(Priority);
	  do Tasto=getch();
	  while(Tasto!=27 & Tasto!=32);
	}

	if(Switch==0)
	{
	  Beep();
	  Stampa_Grafici(Priority,Protocol,Tab);
	  Stampa_Tasti_Grafici(Priority);
	  Curva=1;
	  Stampa_Punto(Tab,Curva,WHITE,Priority);

	  do
	  {
	    Tasto=getch();
	    if(Tasto==75||Tasto==77||Tasto==72||Tasto==80||      /* cursore */
	       Tasto==59)                                             /* F1 */
	    {
	      if(Tasto==59)
	      {
		Simulazione_Singola();
		Stampa_Tasti_Grafici(Priority);
	      }

	      setfillstyle(SOLID_FILL,BLACK); Tabulatore(Tab);
	      if(Tasto==75 && Tab!=1)
	      {
		Stampa_Punto(Tab,Curva,Curva+1,Priority);
		Tab--;
		Stampa_Punto(Tab,Curva,WHITE,Priority);
	      }
	      if(Tasto==77 && Tab!=8)
	      {
		Stampa_Punto(Tab,Curva,Curva+1,Priority);
		Tab++;
		Stampa_Punto(Tab,Curva,WHITE,Priority);
	      }
	      setfillstyle(SOLID_FILL,LIGHTGRAY); Tabulatore(Tab);

	      if(Priority==0)
		Distribuzione(Tab,0);
	      else
	      {
		if(Tasto==80 && Curva!=2)
		{
		  Stampa_Punto(Tab,Curva,Curva+1,Priority);
		  Curva++;
		  Stampa_Punto(Tab,Curva,WHITE,Priority);
		}
		if(Tasto==72 && Curva!=0)
		{
		  Stampa_Punto(Tab,Curva,Curva+1,Priority);
		  Curva--;
		  Stampa_Punto(Tab,Curva,WHITE,Priority);
		}
		Distribuzione(Tab,Curva);
	      }

	      Fairness(Tab);
	      Beep();
	    }
	  } while(Tasto!=27 & Tasto!=32);
	}
	switch(Switch)
	{
	  case 0: Switch=1; break;
	  case 1: Switch=0; break;
	}
      }                                              /* fine premuto SPAZIO */
    } while(Tasto!=27);
  }
  free(Coda);
}

void main(void)
/* PROCEDURA PRINCIPALE CHE VISUALIZZA INTRODUZIONE E MENU ED EFFETTUA
   LA SELEZIONE DI UNA DELLE OPZIONI. */
{
  Inizializza();
  Intro();
  do
  {
    Sfondo();
    Menu();
    switch (Opzione)
    {
      case 0: Stampa_Testo(); break;
      case 1: Data_Input(); break;
      case 2: Simulatore(TOKEN_BUS); break;
      case 3: Simulatore(TOKEN_RING);break;
      case 4: Simulatore(FDDI);      break;
    }
  } while(1);                  /* repeat until doomsday (vedi Tanenbaum...) */
}
