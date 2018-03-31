// Stampa il testo sullo schermo (fttext.c) //
char *Riga[20];

void Titolo(char *stringa);
void Pagina0(void);
void Pagina1(void);
void Pagina2(void);
void Pagina3(void);
void Pagina4(void);
void Pagina5(void);
void Pagina6(void);
void Pagina7(void);
void Pagina8(void);
void Pagina9(void);
void Pagina10(void);
void Pagina11(void);
void Profilo(void);
void Sound(void);
void Sabine(void);
void Stampa(void);

void Titolo(char *stringa)
{
int inizio;
settextstyle(TRIPLEX_FONT,HORIZ_DIR,4);
inizio=(640-textwidth(stringa))/2;
setfillstyle(SOLID_FILL,RED);
bar(inizio-20,5,640-inizio+20,55);
setcolor(YELLOW);
setlinestyle(SOLID_LINE,SOLID_FILL,3);
rectangle(inizio-20,5,640-inizio+20,55);
outtextxy(inizio,10,stringa);
}

void Pagina0(void)  /* Introduzione */
{
Riga[0]="  Il programma didattico 'Fisica Tecnica' rappresenta con";
Riga[1]="testi e brevi animazioni gli aspetti principali della";
Riga[2]="Termodinamica, della Trasmissione del Calore, dell'Acustica,";
Riga[3]="dell'Illuminotecnica e delle loro principali applicazioni.";
Riga[4]="  Dopo aver selezionato una delle opzioni Š sufficiente";
Riga[5]="premere qualunque tasto per proseguire nella lettura delle";
Riga[6]="successive schermate di testo o nella visione delle";
Riga[7]="descrizioni animate di cicli e impianti di condizionamento.";
Riga[8]="  Il calcolatore per proseguire Š sempre in attesa della";
Riga[9]="pressione di un tasto, e da ogni punto del programma si";
Riga[10]="pu• ritornare al menu principale semplicemente";
Riga[11]="premendo un certo numero di tasti qualsiasi.";
Riga[12]="  Lo scopo delle semplici animazioni Š quello di spiegare";
Riga[13]="una alla volta le varie fasi che compongono il processo,";
Riga[14]="evidenziando di volta in volta in colore rosso componente";
Riga[15]="e trasformazione direttamente interessati.";
}

void Pagina1(void)        /* Termodinamica */
{
Riga[0]="  La Termodinamica Š la scienza che studia il trasferimento";
Riga[1]="dell'energia, le sue trasformazioni da una forma all'altra e";
Riga[2]="i risultati di queste trasformazioni.";
Riga[3]="  La Termodinamica si fonda su due principi fondamentali :";
Riga[4]="il primo Š il principio della conservazione dell'energia,";
Riga[5]="e fissa l'equivalenza fra le varie forme dell'energia, in";
Riga[6]="particolare tra calore e lavoro; esso fornisce dunque delle";
Riga[7]="informazioni QUANTITATIVE sugli scambi energetici.";
Riga[8]="  Il Secondo Principio stabilisce invece QUALITATIVAMENTE";
Riga[9]="un bilancio tra le varie forme di energia, sancendo la";
Riga[10]="degradazione dell'energia e la non equivalenza operativa";
Riga[11]="delle varie forme di energia al fine di ottenere lavoro";
Riga[12]="meccanico. Un aspetto della legge naturale espressa dal";
Riga[13]="Secondo Principio Š la presenza di irreversibilit… in";
Riga[14]="tutti i processi naturali, che causano la tendenza a";
Riga[15]="procedere verso uno stato di disordine crescente.";
}

void Pagina2(void)       /* Cicli Termodinamici */
{
Riga[0]="  Come applicazione della termodinamica verranno analizzati";
Riga[1]="i cicli termodinamici, la cui esecuzione in un opportuno";
Riga[2]="impianto motore costituisce il metodo pi— comune per";
Riga[3]="realizzare la trasformazione di energia termica in energia";
Riga[4]="meccanica (ciclo diretto) o viceversa (ciclo inverso).";
Riga[5]="  Verranno presi come riferimento i cicli a vapore, in cui";
Riga[6]="il fluido motore Š sottoposto durante il ciclo a processi";
Riga[7]="con cambiamento di fase.";
Riga[8]="  Come esempi di cicli a vapore realizzabili nella pratica";
Riga[9]="saranno presi il ciclo diretto di Rankine a surriscaldamento";
Riga[10]="e il ciclo inverso frigorifero a compressione di vapore.";
Riga[11]="  Per rappresentare le trasformazioni sono stati scelti dei";
Riga[12]="diagrammi in cui appare su un asse l'entalpia, che con le";
Riga[13]="sue variazioni, valutabili dalle proiezioni sull'asse entalpico,";
Riga[14]="rappresenta il calore scambiato (per trasformazioni isobare)";
Riga[15]="o il lavoro scambiato (per trasformazioni adiabatiche).";
}

void Pagina3(void)    /* Condizionamento dell'Aria */
{
Riga[0]="  Il Condizionamento dell'Aria Š l'insieme dei processi che";
Riga[1]="permettono il controllo di alcuni parametri negli ambienti";
Riga[2]="chiusi (temperatura, umidit…, velocit… e purezza dell'aria).";
Riga[3]="  Per l'uomo i valori usuali di benessere riguardo a";
Riga[4]="temperatura ed umidit… relativa sono i seguenti :";
Riga[5]="";
Riga[6]="   INVERNO  ³ t = 21øC          ESTATE  ³ t = 26øC";
Riga[7]="             ³ í = 50 %                   ³ í = 50 %";
Riga[8]="";
Riga[9]="  Verr… considerata la tipologia di impianto 'a tutta aria',";
Riga[10]="in cui l'azione dei carichi termici ambientali viene";
Riga[11]="contrastata con l'immissione nell'ambiente di una portata";
Riga[12]="di aria di immissione nelle opportune condizioni termo-";
Riga[13]="igrometriche (I) , ed estrazione di una uguale portata";
Riga[14]="di aria nelle condizioni ambienti (A).";
Riga[15]="";
}

void Pagina4(void)       /* Condizioni di Immissione */
{
Riga[0]="  Per conoscere le opportune condizioni termoigrometriche";
Riga[1]="che dovr… soddisfare la portata di immissione (I) per";
Riga[2]="mantenere le condizioni dell'ambiente al valore desiderato";
Riga[3]="(A), si potr… tracciare sul diagramma psicrometrico h-x";
Riga[4]="la RETTA DI ESERCIZIO, passante per A e con pendenza";
Riga[5]="funzione dei carichi termici dell'ambiente e della portata";
Riga[6]="totale di vapor d'acqua immesso.";
Riga[7]="  Per stabilire poi in quale punto della retta di esercizio";
Riga[8]="debba essere scelto lo stato effettivo di introduzione (I)";
Riga[9]="si potr… fare riferimento alle seguenti considerazioni :";
Riga[10]="1) La portata di aria di immissione non pu• essere minore";
Riga[11]="della portata minima di aria esterna di rinnovo necessaria";
Riga[12]="per assicurare la purezza dell'aria nel locale.";
Riga[13]="2) La temperatura dell'aria introdotta non deve discostarsi";
Riga[14]="molto dalla temperatura ambiente per non creare situazioni";
Riga[15]="poco confortevoli vicino ai dispositivi di immissione.";
}

void Pagina5(void)        /* Trasmissione del Calore */
{
Riga[0]="  I meccanismi per la trasmissione del calore sono :";
Riga[1]="CONDUZIONE : dovuta a una distribuzione non uniforme";
Riga[2]="  di temperatura tra mezzi a contatto fisico.";
Riga[3]="IRRAGGIAMENTO : dovuto a onde elettromagnetiche ;";
Riga[4]="  non richiede la presenza di un mezzo interposto";
Riga[5]="  ( come ad esempio per l'irraggiamento solare ).";
Riga[6]="CONVEZIONE : avviene con trasporto di materia ed Š";
Riga[7]="  determinato da agenti esterni ( convezione forzata )";
Riga[8]="  o da differenze di densit… dovute ad un gradiente";
Riga[9]="  di temperatura ( convezione naturale ).";
Riga[10]="";
Riga[11]="  La trasmissione del calore si fonda sui principi della";
Riga[12]="termodinamica, sulla legge di conservazione della massa";
Riga[13]="e sulle 3 leggi particolari di Fourier, Planck e Newton";
Riga[14]="per i meccanismi sopra accennati.";
Riga[15]="";
}

void Pagina6(void)       /* Meccanismi Combinati */
{
Riga[0]="  I meccanismi di trasmissione del calore non avvengono";
Riga[1]="mai isolati, anzi in generale sono presenti tutti e tre";
Riga[2]="contemporaneamente.";
Riga[3]="  Ad esempio il profilo di temperatura della parete esterna";
Riga[4]="di una abitazione potrebbe essere il seguente :";
Riga[5]="";
Riga[6]="                               All' interno della parete";
Riga[7]="                               l'andamento della temperatura";
Riga[8]="                               Š lineare in quanto Š dovuto";
Riga[9]="                               prevalentemente alla";
Riga[10]="                               conduzione.";
Riga[11]="";
Riga[12]="  Invece l'andamento della temperatura all'esterno della";
Riga[13]="parete non Š lineare in quanto la conducibilit… termica";
Riga[14]="dell'aria Š d'ordine di grandezza inferiore a quella dei";
Riga[15]="solidi ed allora prevale la convezione.";
}

void Pagina7(void)  /* Acustica Fisiologica */
{
Riga[0]="  Il suono ha origine dalle vibrazioni elastiche dei corpi,";
Riga[1]="viene trasmesso al timpano dell'orecchio umano mediante";
Riga[2]="un mezzo materiale ( solitamente aria )  e la vibrazione";
Riga[3]="della membrana viene qui tradotta in sensazioni uditive.";
Riga[4]="";
Riga[5]="  L' uomo percepisce tutti i suoni con una frequenza";
Riga[6]="compresa tra i 20 e i 20.000 Hz ;  a parit… di intensit…";
Riga[7]="acustica i suoni producono nell'uomo una sensazione uditiva";
Riga[8]="differente a seconda della loro frequenza, come Š visibile";
Riga[9]="dagli audiogrammi di Fletcher e Munson, da cui ad esempio";
Riga[10]="si evince che il picco di sensazione sonora si ha per";
Riga[11]="suoni a frequenze di 3000-4000 Hz circa.";
Riga[12]="";
Riga[13]="";
Riga[14]="";
Riga[15]="";
}

void Pagina8(void)  /* Ascolto di Suoni Puri */
{
Riga[0]="  Il computer Š in grado attraverso il proprio altoparlante";
Riga[1]="interno di emettere suoni a qualunque frequenza.";
Riga[2]="  E' possibile sperimentarlo adesso inserendo il valore di";
Riga[3]="frequenza a cui si desidera ascoltare un breve suono.";
Riga[4]="  Si ricorda a tal proposito che le frequenze udibili vanno";
Riga[5]="da 20 a 20.000 Hz .";
Riga[6]="";
Riga[7]="  Per proseguire il programma senza ascoltare alcun suono";
Riga[8]="Š sufficiente inserire alla richiesta del calcolatore il";
Riga[9]="valore 1 anzich‚ la frequenza desiderata.";
Riga[10]="";
Riga[11]="";
Riga[12]="";
Riga[13]="";
Riga[14]="";
Riga[15]="";
}

void Pagina9(void)     /* Acustica delle Sale */
{
Riga[0]="  L' Acustica delle Sale Š una delle principali applicazioni";
Riga[1]="dell'Acustica, e permette una progettazione adeguata delle";
Riga[2]="sale a seconda della loro destinazione specifica.";
Riga[3]="  In particolare si dovr… cercare di ottimizzare il TEMPO";
Riga[4]="DI RIVERBERAZIONE che serve a valutare la coda sonora,";
Riga[5]="cio‚ la permanenza nell'ambiente di un suono anche";
Riga[6]="dopo la cessazione dell'emissione.";
Riga[7]="  Il tempo di riverberazione pu• essere calcolato con la";
Riga[8]="famosa RELAZIONE DI SABINE , ricavata sperimentalmente:";
Riga[9]="";
Riga[10]="";
Riga[11]="";
Riga[12]="";
Riga[13]="";
Riga[14]="";
Riga[15]="";
}

void Pagina10(void)      /* Percezione della luce */
{
Riga[0]="  La luce Š una forma di energia raggiante che si";
Riga[1]="trasmette per onde elettromagnetiche e si propaga in";
Riga[2]="un mezzo trasparente.";
Riga[3]="  La retina dell'occhio umano Š capace di percepire le";
Riga[4]="radiazioni monocromatiche la cui lunghezza d'onda sia";
Riga[5]="compresa tra 0,38 e 0,78 micron, con una differente";
Riga[6]="visibilit… relativa a seconda che si tratti di visione";
Riga[7]="diurna o notturna.";
Riga[8]="  La retina Š composta dai bastoncelli, che percepiscono";
Riga[9]="l'intensit… della luce, e dai coni, che ne percepiscono";
Riga[10]="il colore.";
Riga[11]="  Qualunque effetto cromatico pu• essere ottenuto";
Riga[12]="miscelando opportunamente 3 radiazioni monocromatiche";
Riga[13]="fondamentali, come si pu• vedere dal Triangolo dei Colori.";
Riga[14]="";
Riga[15]="";
}

void Pagina11(void)       /* Illuminamento Ottimale */
{
Riga[0]="  Per l'illuminamento ottimale, oltre che perseguire il";
Riga[1]="valore di illuminamento adatto per ogni specifica";
Riga[2]="applicazione, bisogna anche cercare di ottimizzare";
Riga[3]="i coefficienti di uniformit… e di utilizzazione del";
Riga[4]="flusso ( cercando il giusto compromesso tra essi perch‚";
Riga[5]="sono antitetici ) , ed evitare fenomeni di abbagliamento.";
Riga[6]="";
Riga[7]="  Come sorgenti luminose artificiali si adoperano le";
Riga[8]="sorgenti a incandescenza ( come le comuni lampadine e";
Riga[9]="le lampade alogene ) , le sorgenti a luminescenza";
Riga[10]="( ad esempio al neon )  e le sorgenti fluorescenti.";
Riga[11]="";
Riga[12]="";
Riga[13]="";
Riga[14]="";
Riga[15]="";
}

void Profilo(void)
{
  int profilo_temperatura[]={ 10,300, 70,300, 90,295, 100,280,
                              200,260, 210,245, 230,240, 290,240 };
  setcolor(YELLOW);
  setlinestyle(SOLID_LINE,SOLID_FILL,1);
  line(100,195,100,350);
  line(200,195,200,350);
  setcolor(RED);
  drawpoly(8,profilo_temperatura);
  setcolor(CYAN);
  settextstyle(DEFAULT_FONT,HORIZ_DIR,1);
  outtextxy(30,330,"esterno     parete     interno");
}

void Sound(void)
{
int freq=0;
char input[10];

setcolor(CYAN);
setfillstyle(SOLID_FILL,BLACK);
settextstyle(TRIPLEX_FONT,HORIZ_DIR,2);
START: while(1!=freq)
  {
    outtextxy(0,343," Frequenza del suono (20ö20.000 Hz oppure 1) :");
    gotoxy(67,23);
    freq=atoi(gets(input));
    bar(520,349,640,369);
    if(0==freq|20>freq|20000<freq) goto START;
    sound(freq); delay(600); nosound();
    goto START;
  }
}

void Sabine(void)
{
  setcolor(YELLOW);
  settextstyle(TRIPLEX_FONT,HORIZ_DIR,3);
  outtextxy(20,350,"T  =  0.16     V");
  outtextxy(20,380,"           ä a S  + ä A");
  setcolor(CYAN);
  outtextxy(360,310,"V = volume della sala ;");
  outtextxy(360,340,"ä aS = assorbimento");
  outtextxy(360,360,"     superfici ;");
  outtextxy(360,390,"ä A = assorbimento");
  outtextxy(360,410,"    arredo e persone.");
  setcolor(YELLOW);
  setlinestyle(SOLID_LINE,SOLID_FILL,1);
  line(150,377,305,377);
  settextstyle(DEFAULT_FONT,HORIZ_DIR,1);
  outtextxy(191,400,"i");
  outtextxy(217,400,"i");
  outtextxy(306,400,"i");
  setcolor(RED);
  setlinestyle(SOLID_LINE,SOLID_FILL,3);
  rectangle(0,325,330,430);
}

void Stampa(void)
{
  int riga;
  setcolor(WHITE);
  settextstyle(TRIPLEX_FONT,HORIZ_DIR,2);
  for(riga=0; riga<16; riga++) outtextxy(5,riga*25+60,Riga[riga]);
  sound(3000); delay(30); nosound();
}
