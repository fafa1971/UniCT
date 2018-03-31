/****************************************************************************/
/*                          >>>  Fab Net 3.0  <<<                           */
/*            Command line version - Written in Portable ANSI C		    */
/*      		(C) 1996 by Fabrizio Fazzino			    */
/*									    */
/*  Simulazione, valutazione e confronto delle prestazioni dei protocolli   */
/*        TokenBus / TokenRing / FDDI  per le reti di calcolatori.          */
/****************************************************************************/

#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <time.h>

#define TOKEN_BUS  0
#define TOKEN_RING 1
#define FDDI       2

/*************** PARAMETRI DELLA RETE INSERIBILI DALL'UTENTE ****************/
unsigned Protocol=TOKEN_BUS;  /* protocollo da adoperare per la simulazione */
unsigned Priority=0;	  /* priorit… di cui valutare le prestazioni [0..3] */
unsigned Nodi=30;       	        	          /* numero di nodi */
float Percorso=1;         		        /* distanza tra i nodi [Km] */
float Data_Rate=1;     		         /* velocit… della sottorete [Mbps] */
unsigned long Lunghezza=1000;             /* lunghezza media messaggi [bit] */
float T_Simul=3000;           /* tempo virtuale di durata della simulazione */
float T_Pri[4]={50,40,30,15};        /* tempi di rotazione del token [msec] */

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

/* SIMULA LA GENERAZIONE ESPONENZIALE DEGLI INTERARRIVI CON PARAMETRO "WL".
   FORNENDO INFATTI IL WORKLOAD "WL" [frames/sec] RESTITUISCE LA VARIABILE
   TEMPORALE "EXP" [msec] CON DISTRIBUZIONE ESPONENZIALE. */
float Exp(float WL)
{
  float Var;
  Var=1000*log((double)((1/(1-((float)((long)rand())/(RAND_MAX+1))))))/WL;
  return Var;
}

/* DEVE ESSERE ESEGUITA PER INIZIALIZZARE LE OPPORTUNE VARIABILI PRIMA DI
   UNA QUALUNQUE SIMULAZIONE IN CONDIZIONI PREFISSATE; AD ESEMPIO ESEGUENDO
   LA CLASSICA CAMPAGNA DI SIMULAZIONI TALE PROCEDURA DOVRA' ESSERE ESEGUITA
   PER OGNUNO DEGLI 8 PUNTI. */
void Point_Reset(void)
{
  unsigned Indice,Livello;

  for(Indice=0;Indice<Nodi;Indice++,Coda++)          /* inizializza le code */
  {
    for(Livello=0;Livello<4;Livello++)
    {
      (*Coda).istante[Livello]=Exp(WorkLoad[Livello]);
      (*Coda).lunghezza[Livello]=floor((double)((Lunghezza/2+Lunghezza*((long)rand())/(RAND_MAX+1))));
    }
    (*Coda).last_token=0;
  }
  Coda-=Nodi;
}

/* INIZIALIZZA LE VARIABILI CHE RICHIEDONO DI ESSERE RESETTATE SOLO PRIMA
   DI OGNI CAMPAGNA DI SIMULAZIONI. */
void Screen_Reset(void)
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

/* SIMULA IL RELATIVO PROTOCOLLO TOKEN BUS, E OLTRE ALLE VARIBILI GLOBALI
   (COI DATI DELLA RETE) HA BISOGNO CHE LE SIANO PASSATE LE INFORMAZIONI
   RELATIVE ALLA ATTUALE SIMULAZIONE DA COMPIERE, IN MODO DA POTERE
   VISUALIZZARE CORRETTAMENTE I RISULTATI DELLE SIMULAZIONI.
   "Priority" INDICA INFATTI IL LIVELLO DI PRIORITA' DI CUI VALUTARE LE
   PRESTAZIONI, "Punto" INDICA DI QUALE PUNTO DA INTERPOLARE SI STIA
   EFFETTUANDO LA SIMULAZIONE, "Curva" INDICA L'OCCUPAZIONE DEI LIVELLI
   A PRIORITA' SUPERIORE (SIMULO UNA OCCUPAZIONE DEL 25%, 50%, 75% DELLA
   BANDA MA SOLO NEL CASO IN CUI "Priority" NON SIA LA MASSIMA). */
void TokenBus(unsigned Punto, unsigned Curva)
{                                                  																				 /* con carico [frames/sec]. */
  float Start;
  float sum_ritardi=0;
  float TRT,THT;
  unsigned Indice,Livello;
  unsigned long num_ritardi=0;
  unsigned colonna;
  unsigned long bit_trasmessi=0;

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

	    if(Time-(*Coda).istante[Priority]<1) colonna=0;
	    else colonna=floor((double)((4*log10((double)((Time-(*Coda).istante[Priority]))))));
	    if(colonna>=16) colonna=15;
	    Matrice.intervallo_ritardi[Punto][Curva][colonna]++; /*ritardi*/
	    (*Coda).msg_spediti[Punto]++;                       /*Fairness*/
	  }
		   /* aumenta tempo globale e TRT del tempo di trasmissione */
	  Time+=((float)(*Coda).lunghezza[Livello])/(1000*Data_Rate)+
		 Percorso/200;
	  TRT +=((float)(*Coda).lunghezza[Livello])/(1000*Data_Rate)+
		 Percorso/200;

						 /* riempie daccapo la coda */
	  (*Coda).lunghezza[Livello]=floor((double)((Lunghezza/2+Lunghezza*((long)rand())/(RAND_MAX+1))));
	  (*Coda).istante[Livello]+=Exp(WorkLoad[Livello]);
	}
      }
    }
    Coda-=Nodi;
  }

  if (num_ritardi!=0) Access_Delay=sum_ritardi/(float)num_ritardi;
    else Access_Delay=0;                                 /* AD=[frames/sec] */
  ThroughPut=((float)bit_trasmessi)/(1000*Time);                 /*TP=[Mbps]*/
}

/* SIMULA IL PROTOCOLLO TOKEN RING UTILIZZANDO LE STESSE VARIABILI DEL
   PRECEDENTE CASO TOKEN BUS, MA E' ALQUANTO PIU' LABORIOSA E LENTA,
   IN QUANTO AD OGNI PASSAGGIO DI TOKEN BISOGNA DETERMINARE QUALE E' IL
   MESSAGGIO A PRIORITA' PIU' ELEVATA TRA QUELLI PRESENTI IN TUTTE LE
   STAZIONI. */
void TokenRing(unsigned Punto, unsigned Curva)
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

	    if(Time-(*Coda).istante[Priority]<1) colonna=0;
	    else colonna=floor((double)((4*log10((double)((Time-(*Coda).istante[Priority]))))));
	    if(colonna>=16) colonna=15;
	    Matrice.intervallo_ritardi[Punto][Curva][colonna]++; /*ritardi*/
	    (*Coda).msg_spediti[Punto]++;                       /*Fairness*/
	  }
		      /* aumenta il tempo globale del tempo di trasmissione */
	  Time+=((float)(*Coda).lunghezza[Livello])/(1000*Data_Rate);
						 /* riempie daccapo la coda */
	  (*Coda).lunghezza[Livello]=floor((double)((Lunghezza/2+Lunghezza*((long)rand())/(RAND_MAX+1))));
	  (*Coda).istante[Livello]+=Exp(WorkLoad[Livello]);
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

/* SIMULA IL PROTOCOLLO FDDI IN MANIERA MOLTO SIMILE AL TOKEN BUS. */
void FDDI_Protocol(unsigned Punto, unsigned Curva)
{																			 /* con carico [frames/sec]. */
  float sum_ritardi=0;
  float TRT;
  unsigned Indice,Livello;
  unsigned long num_ritardi=0;
  unsigned colonna;
  unsigned long bit_trasmessi=0;

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

	    if(Time-(*Coda).istante[Priority]<1) colonna=0;
	    else colonna=floor((double)((4*log10((double)((Time-(*Coda).istante[Priority]))))));
	    if(colonna>=16) colonna=15;
	    Matrice.intervallo_ritardi[Punto][Curva][colonna]++; /*ritardi*/
	    (*Coda).msg_spediti[Punto]++;                       /*Fairness*/
	  }
		   /* aumenta tempo globale e TRT del tempo di trasmissione */
	  Time+=((float)(*Coda).lunghezza[Livello])/(1000*Data_Rate);
	  TRT+=((float)(*Coda).lunghezza[Livello])/(1000*Data_Rate);

						 /* riempie daccapo la coda */
	  (*Coda).lunghezza[Livello]=floor((double)((Lunghezza/2+Lunghezza*((long)rand())/(RAND_MAX+1))));
	  (*Coda).istante[Livello]+=Exp(WorkLoad[Livello]);
	}
      }
    }
    Coda-=Nodi;
  }

  if (num_ritardi!=0) Access_Delay=sum_ritardi/(float)num_ritardi;
    else Access_Delay=0;                                 /* AD=[frames/sec] */
  ThroughPut=((float)bit_trasmessi)/(1000*Time);                 /*TP=[Mbps]*/
}

/* E' LA FUNZIONE CHE IN BASE ALLE SCELTE INIZIALI DA MENU PROVVEDE A
   SELEZIONARE IL PRESCELTO PROTOCOLLO DA SIMULARE.
   I PARAMETRI DA PASSARE SONO GLI STESSI DELLE TRE PROCEDURE TOKEN BUS,
   TOKEN RING E FDDI, COSI' COME DESCRITTI ALL'INIZIO DEL TOKEN BUS;
   E' ALTRESI' PRESENTE UN ULTERIORE PARAMETRO "PROTOCOL" CHE PROVVEDE
   APPUNTO A SELEZIONARE IL PROTOCOLLO PRESCELTO DALL'UTENTE. */
void Protocollo(unsigned Punto, unsigned Curva)
{
  Point_Reset();                    /* setta istante,lunghezza e last_token */

  switch(Protocol)
  {
    case TOKEN_BUS: TokenBus(Punto,Curva); break;
    case TOKEN_RING: TokenRing(Punto,Curva); break;
    case FDDI: FDDI_Protocol(Punto,Curva); break;
  }
}

/* QUESTA FUNZIONE E' IL VERO CERVELLO DELLA SIMULAZIONE, IN QUANTO
   EFFETTUA LA CAMPAGNA DI SIMULAZIONI CHIAMANDO LA FUNZIONE
   Protocollo E MEMORIZZANDO TUTTI I RISULTATI NELLA STRUTTURA Matrice.*/
void Simulatore(void)
{
  unsigned Punto,Curva,Setta_WL;
  time_t t;

  Coda=(struct nodo *) calloc(Nodi,sizeof(struct nodo));
  if(Coda==NULL)
  {
    printf("# Insufficient memory (try with less nodes).\n");
    exit(EXIT_FAILURE);
  }

  srand((unsigned) time(&t));
  Screen_Reset();

  if(Priority==0) WL_max=2*1e6*Data_Rate/(float)(Nodi*Lunghezza);
  else WL_max=1e6*Data_Rate/(float)(Nodi*Lunghezza);
  for(Setta_WL=0;Setta_WL<4;Setta_WL++) WorkLoad[Setta_WL]=1;

  printf("# Fab Net 3.0 is simulating ");

  for(Punto=1;Punto<9;Punto++)
  {
    Matrice.workload[Punto]=WL_max*((float)Punto)/8;
    WorkLoad[Priority]=Matrice.workload[Punto];
    if(Priority==0)
    {
      Protocollo(Punto,0);
      Matrice.throughput[Punto][0]=ThroughPut;
      Matrice.access_delay[Punto][0]=Access_Delay;

      printf("...");
    }
    else for(Curva=0;Curva<3;Curva++)           /* 3 curve banda occupata */
    {
      WorkLoad[0]=WL_max*0.25*(float)(Curva+1); /* carico del 25%,50%,75% */
      Protocollo(Punto,Curva);
      Matrice.throughput[Punto][Curva]=ThroughPut;
      Matrice.access_delay[Punto][Curva]=Access_Delay;

      printf(".");
    }
  }
  printf("\n");

  free(Coda);
}

/* VISUALIZZA LA CORRETTA SINTASSI. */
void PrintSyntax(void)
{
    printf("\n              >>>  Fab Net 3.0  <<<\n");
    printf("Command line version - Written in portable ANSI C\n");
    printf("(C) 1996 by Fabrizio Fazzino, ffazzino@k200.cdc.unict.it\n");
    printf("Token Bus / Token Ring / FDDI  Computer Networks Simulator\n\n");
    printf("Syntax is the following : \n");
    printf("  fabnet PROTOCOL PRIORITY NODES PATH DATA_RATE LENGTH ");
    printf("T_SIMUL [TRT(4)..TRT(1)]\n\n");
    printf("Where:  ( the default '*' is used if parameter doesn't match )\n");
    printf("	PROTOCOL = int 0=TokenBus, 1=TokenRing, 2=FDDI ( * = 0 )\n");
    printf("	PRIORITY = int [number] of priority 4...1 ( * = 4 )\n");
    printf("	NODES = int [number] of nodes ( * = 30 )\n");
    printf("	PATH = float [Km] between two nodes ( * = 1 )\n");
    printf("	DATA_RATE = float [Mbps] data-rate ( * = 1 )\n");
    printf("	LENGTH = long [bit] mean messages length ( * = 1000 )\n");
    printf("	T_SIMUL = float [msec] virtual time to simulate ( * = 3000 )\n");
    printf("	T_PRI = 4 float [msec] tokenrotationtimes ( * = 50 40 30 15 )\n");
}

/* VISUALIZZA I RISULTATI SULLO STANDARD OUTPUT. */
void PrintResults(void)
{
    int i,j;
    int curve;

    /* Primo record con gli 11 parametri utilizzati in ingresso */
    printf("#%u,%u,%u,%g,%g,",Protocol,4-Priority,Nodi,Percorso,Data_Rate);
    printf("%u,",Lunghezza);
    printf("%g,",T_Simul);
    printf("%g,%g,%g,%g\n",T_Pri[0],T_Pri[1],T_Pri[2],T_Pri[3]);

    /* Secondo record con valori max su cui normalizzare i grafici */
    TP_max=Data_Rate;
    if(Priority==0) AD_max=Matrice.access_delay[4][0];
    else AD_max=Matrice.access_delay[4][1];
    if(AD_max<100) AD_max=100;
    printf("#%g,%g\n",TP_max,AD_max);

    /* Terzo record con ascisse WorkLoad ( float workload[9] ) */
    printf("#");
    for(i=1;i<=7;i++) printf("%g,",Matrice.workload[i]);
    printf("%g\n",Matrice.workload[8]);

    /* Uno o tre record per il ThroughPut ( float throughput[9][3] ) */
    if(Priority==0) curve=1;
    else curve=3;
    for(j=0;j<curve;j++)
    {
      printf("#");
      for(i=1;i<=7;i++) printf("%g,",Matrice.throughput[i][j]);
      printf("%g\n",Matrice.throughput[8][j]);
    }

    /* Uno o tre record per l'Access Delay ( float access_delay[9][3] ) */
    for(j=0;j<curve;j++)
    {
      printf("#");
      for(i=1;i<=7;i++) printf("%g,",Matrice.access_delay[i][j]);
      printf("%g\n",Matrice.access_delay[8][j]);
    }

/*
  float workload[9];          /* valori di WL a cui eseguire le simulazioni
  float throughput[9][3];                         /* array di TP risultanti
  float access_delay[9][3];                       /* array di AD risultanti
  unsigned long intervallo_ritardi[9][3][16];/* contatore per distribuzione
*/
}

/* PROCEDURA PRINCIPALE CHE VISUALIZZA LA SINTASSI CORRETTA OPPURE
   AVVIA LA SIMULAZIONE COI PARAMETRI RICEVUTI E STAMPA I RISULTATI. */
int main(int argc, char *argv[])
{
  unsigned protocol,priority,nodi;
  float percorso,data_rate;
  unsigned long lunghezza;
  float t_simul;
  float t_pri[4];

  if(argc!=8 && argc!=12) /* Num. di parametri sbagliato */
  {
    PrintSyntax();
    exit(EXIT_FAILURE);
  }
  else  /* Setto tutti i parametri */
  {
    protocol = (unsigned)atol(argv[1]);
    if(protocol<=2) Protocol=protocol;

    priority = (unsigned)atol(argv[2]);
    if(priority>=1 && priority<=4) Priority=4-priority;

    nodi = (unsigned)atol(argv[3]);
    if(nodi>=1) Nodi=nodi;

    percorso = (float)atof(argv[4]);
    if(percorso>0) Percorso=percorso;

    data_rate = (float)atof(argv[5]);
    if(data_rate>0) Data_Rate=data_rate;

    lunghezza = (unsigned long)atol(argv[6]);
    if(lunghezza>0) Lunghezza=lunghezza;

    t_simul = (float)atof(argv[7]);
    if(t_simul>0) T_Simul=t_simul;

    if(argc==12)
    {
      t_pri[0] = (float)atof(argv[8]);
      if(t_pri[0]>0) T_Pri[0]=t_pri[0];

      t_pri[1] = (float)atof(argv[9]);
      if(t_pri[1]>0) T_Pri[1]=t_pri[1];
      if(T_Pri[1]>T_Pri[0]) T_Pri[1]=T_Pri[0];

      t_pri[2] = (float)atof(argv[10]);
      if(t_pri[2]>0) T_Pri[2]=t_pri[2];
      if(T_Pri[2]>T_Pri[1]) T_Pri[2]=T_Pri[1];

      t_pri[3] = (float)atof(argv[11]);
      if(t_pri[3]>0) T_Pri[3]=t_pri[3];
      if(T_Pri[3]>T_Pri[2]) T_Pri[3]=T_Pri[2];
    }

    /* Avvio la simulazione */
    Simulatore();

    /* Visualizzo i risultati */
    PrintResults();
  }

  exit(EXIT_SUCCESS);
  return 0;
}
