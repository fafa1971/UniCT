/**********************************************************/
/*                  LOGICAL  DATA  BASE                   */
/*           di Fabio Bruno & Fabrizio Fazzino            */
/**********************************************************/
code=3000
nowarnings

DOMAINS
record=reference string*

DATABASE
record(record)
attributi(record)
nome(string)
presente

PREDICATES
principale
ripeti
info
rimuovipresente
messaggio
messaggio1
messaggio2
tasto

comunico(integer)
errore(integer)
cerca(record)
immesso(record)
accetta(record)
crea(record)
comunica(record)
comando(char)
modifica(string)

chiedi(record,record)
trova(string,record)
appartiene(string,record)
immetto(record,record)
scrivi(record,record)
formato(string,string)
risposta(string,string)
istanzia(string,string)
scelta(string,string,string)

/* predicati della ricerca relazionale */
esegui(record)
menu
scelta_relaz(char,record)
cerca_relaz(record)
limite_min(string)
limite_max(string)

GOAL
makewindow(1,32,64,"Fab & Fab Logical Data Base",0,0,25,80),
makewindow(2,31,63,"Principale",1,19,23,42),
makewindow(3,30,64,"Ricerca Relazionale",0,0,25,80),
makewindow(4,78,64,"Record Trovati",4,10,20,60),
principale.

CLAUSES
principale:-
	shiftwindow(1),shiftwindow(2),
	ripeti,beep,clearwindow,
	cursor(1,3),write("L O G I C A L   D A T A   B A S E"),
	cursor(2,3),info,
	cursor(4,7),write("N = Nuovo Archivio"),
	cursor(5,7),write("A = Apri File Esistente"),
	cursor(6,7),write("S = Salva File Attuale"),
	cursor(8,7),write("I = Inserisci Record"),
	cursor(9,7),write("R = Ricerca Record"),
	cursor(10,7),write("M = Modifica Record"),
	cursor(11,7),write("C = Cancella Record"),
	cursor(13,7),write("V = Visualizza Archivio"),
	cursor(14,7),write("E = Elimina Archivio"),
	cursor(15,7),write("Z = Ricerca sul dB Relazionale"),
	cursor(17,7),write("Q = Quit"),
	cursor(18,3),write("Digita la lettera corrispondente"),
	cursor(19,3),write("all'opzione prescelta..."),
	readchar(Input),clearwindow,comando(Input),ripeti.

ripeti.
ripeti:-ripeti.

/********** NUOVO ARCHIVIO ************/
comando('n'):-          /* se Š gi… presente un archivio in memoria */
	presente,
	messaggio1,nl,
	!,fail.

comando('n'):-
	not(presente),beep,
	ripeti,
	write("Nome del dB = "),
	readln(Nome),
	isname(Nome),   /* se Nome ha pi— di 8 caratteri */
	formato(Nome,NomeF),
	concat(NomeF,".db",Nome1),
	nl,write("STRUTTURA del RECORD :\n"),
	!,
	crea(L),
	attributi(_),
	asserta(nome(Nome1)),
	asserta(presente),
	!,fail.

/********** APRI FILE ESISTENTE *************/
comando('a'):-
	not(presente),disk(Cdir),beep,
	write("[drive:\\percorso] attuali= ",Cdir),nl,
	write("[drive:\\percorso] scelti = "),
	readln(Cd),
	scelta(Cd,Cdir,Cdn),%Cdn e' la nuova dir
	makewindow(4,32,7,"",9,1,10,50),
	trap(dir(Cdn,"*.db",File,1,1,1),E,errore(E)),%intercettazione errore
	removewindow(4,1),
	consult(File),
	asserta(presente),clearwindow,!,fail.

/* se chiami carica con un db in memoria */
comando('a'):-
	presente,messaggio1,nl,!,fail.

/*********** SALVA FILE ATTUALE *************/
/* posso salvare solo se e' vero presente */
comando('s'):-presente,beep,
	nome(Nome),
	write("Salvo il Db: ",Nome),
	rimuovipresente,
	save(Nome),
	asserta(presente),
	nl,!,fail.

/* se non e' presente alcun
   db,il salvataggio e' proibito */
comando('s'):-
	not(presente),
	messaggio,
	!,fail.

/************* INSERISCI RECORD ***************/
comando('i'):-
	presente,beep,
	immesso(R),
	asserta(presente),
	nl,!,fail.

comando('i'):-
	not(presente),messaggio,!,fail.

/*********** RICERCA RECORD ***********/
comando('r'):- presente,beep,
	write("Ricerca di record filtrati."),nl,nl,
	write("Alla richiesta dei vari campi"),nl,
	write("inserire solo quelli da filtrare,"),nl,
	write("e alla richiesta dei rimanenti"),nl,
	write("premere il tasto RETURN."),nl,nl,
	cerca(R),!,asserta(presente),
	record(R),comunica(R),nl,tasto,nl,fail.
	       
comando('r'):- not(presente),messaggio2,!,fail.

/********** MODIFICA RECORD **********/
comando('m'):- presente,beep,write("Modifica di un record."),
	nl,write("Inserisci il campo chiave : "),nl,
	attributi([T|C]),write(T," = "),
	readln(Input),modifica(Input),
	asserta(presente),nl,!,fail.
	       
comando('m'):- not(presente),messaggio2,!,fail.

/********** CANCELLA RECORD ***********/
comando('c'):- presente,beep,write("Eliminazione di un record."),
	nl,write("Inserisci il campo chiave : "),nl,
	attributi([T|C]),write(T," = "), 
	readln(Input),trova(Input,Lista),
	write("Confermi l'eliminazione (s/n) ?"),readchar(Char),
	Char = 's',retract(record(Lista)),nl,!,fail;
	nl,!,fail.

comando('c'):- not(presente),messaggio2,!,fail.

/************ VISUALIZZA ARCHIVIO ***************/
comando('v'):- presente,!,
	record(R),comunica(R),nl,
	tasto,fail.

/************ ELIMINA ARCHIVIO *************/
comando('e'):-
	presente,beep,nome(Nome),
	write("Elimino l'archivio ",Nome),nl,
	write("dalla memoria ?  (s/n) "),
	cursor(Riga,Col),
	ripeti,
	readln(Risposta),
	cursor(Riga,Col),
	risposta(Risposta,"elimina"),
	nl,!,fail.

comando('e'):-  not(presente),
	messaggio,
	nl,!,fail.

/********** RICERCA SUL DATA BASE RELAZIONALE *********/
comando('z') :-
	not(presente),
	ripeti,beep,
	retractall(_),
	disk("C:\\PROLOG\\FABER"),
	consult("rec1.db"),
	consult("rec2.db"),
	shiftwindow(3),clearwindow,menu,
	esegui([Nome,Indirizzo,Qualifica,AnzMin,AnzMax,
	Ditta,Merce,NumDipMin,NumDipMax]),
	ripeti.

comando('z') :-
	presente,messaggio1,nl,!,fail.

/*************** QUIT ****************/
comando('q'):-
	presente,beep,
	nome(Nome),
	write("Presente in Memoria il dB: ",Nome),nl,
	write("Confermi l'uscita (s/n) ? "),
	cursor(Riga,Col),
	ripeti,
	readln(Risposta),
	cursor(Riga,Col),
	risposta(Risposta,"quit"),
	nl,nl,!.

comando('q'):-
	not(presente),beep,
	clearwindow,
	removewindow,
	exit.

comando(_):- !,fail.

/******** INFORMAZIONI SULL'ARCHIVIO IN MEMORIA ********/
info:-  presente,
	nome(Nome),
	write("Archivio in Memoria: ",Nome),
	!,true.

info:-  not(presente),
	write("Nessun archivio in memoria."),
	!,true.

/**************** RISPOSTE ******************/
risposta("s","quit"):- clearwindow,removewindow,exit.
risposta("n","quit").

risposta("s","elimina"):- retractall(_),!.
risposta("n","elimina").

/*********** DIRECTORY SCELTA ************/
scelta("",Cdir,Cdir):-!.    /* return conferma la directory */
scelta(Cd,_,Cd).            /* la nuova directory Š Cd */

/********** PREDICATI DI RIMOZIONE ********/
rimuovipresente :- retract(presente),fail.
rimuovipresente.

/************ MESSAGGI e TASTO ****************/
messaggio :- write("Nessun dB Presente in Memoria!"),
	beep,nl,nl,tasto.

messaggio1 :- nome(Nome),
	write("E' presente in memoria il file ",Nome," ."),nl,
	write("Prima di aprirne un altro devi"),nl,
	write("eliminarlo con l'opzione 'E'."),
	beep,nl,nl,tasto.

messaggio2 :- write("Prima devi aprire un archivio\n","con il tasto 'A'."),
	beep,nl,nl,tasto.
	
tasto:- write("[TASTO]"),beep,
	readchar(_),
	cursor(X,Y),
	Y1=0,
	cursor(X,Y1),
	write("        "),
	nl.

/********** RICERCA,CANCELLA,EDITA **********/
cerca(Dato):-
	attributi(Record),chiedi(Dato,Record),!.
cerca([]).

chiedi([H|T],[H1|T1]):-
	write(H1," = "),readln(Aux),istanzia(H,Aux),
	chiedi(T,T1).
chiedi([],[]):-nl,!,true.  /* se sono alla fine del record */

trova(Input,Lista):-
	presente,record(Lista),appartiene(Input,Lista),
	clearwindow,attributi(Record),scrivi(Record,Lista),tasto;
	attributi([T|C]),write("Non Š presente alcun dato il con \n",
	T," = ",Input),nl,tasto.

appartiene(Input,[Input|_]).
/* appartiene(Input,[_|C]) :- appartiene(Input,C).*/

modifica(Input):-
	trova(Input,Lista),write("Riscrivi il nuovo record.\n"),
	attributi(Record),immetto(Dato,Record),!,
	write("Vuoi veramente apportare questa modifica(s/n)?\n"),
	readchar(Char),Char = 's',
	retract(record(Lista)),asserta(record(Dato));
	asserta(presente).
		
istanzia(Var,Aux):- Aux="",!.
istanzia(Var,Aux):- bound(Aux),Var=Aux.

/************** CREA ********************/
crea(L):-not(presente),      /* nessun database in memoria */
	accetta(L),          /* accetta i nomi dei campi */
	not(L=[]),
	asserta(attributi(L)),!.

crea(_):-not(presente),  /* con ESC la clausola fallisce */
	nl,nl,!.
	
/******** IMMISSIONE *********/
immesso(Dato):-attributi(Record),
	immetto(Dato,Record),
	asserta(record(Dato)),!,
	immesso(Dato1).
immesso([]).
	
immetto([H|T],[H1|T1]):-
	write(H1," = "),
	readln(H),
	not(H=""),
	immetto(T,T1).
immetto([],[]):-nl.             

/*********** FORMATO *******************/
formato(Digitato,Costruito):-str_len(Digitato,L),L>8,
	frontstr(8,Digitato,Costruito,_),!.

formato(Digitato,Digitato):-!.

/*********** OUTPUT *************/
scrivi([],[]) :- !.
scrivi([H1|T1],[H2|T2]):-
	write(H1," : ",H2),nl,
	scrivi(T1,T2).

comunica(R) :-
	!,attributi(Record),
	scrivi(Record,R).

/*********** INPUT **************/
accetta([H|T]) :-           /* accetta la lista dei campi */
	write("campo = "),
	readln(H),
	not(H=""),          /* l'input e' interrotto con RETURN */
	!,
	accetta(T).
accetta([]) :- nl.          /* arresta ricorsione */  

/****************** GESTIONE degli ERRORI *****************/
errore(E):-
       write("errore n. ",E),nl,
       comunico(E),
       write("[TASTO]"),
       readchar(_).

comunico(2009):-
       write("Indirizzario illegale"),nl,!.
comunico(_).

/********** GESTIONE DEL DATA BASE RELAZIONALE ***********/
esegui([Nome,Indirizzo,Qualifica,AnzMin,AnzMax,
	Ditta,Merce,NumDipMin,NumDipMax]) :-
	ripeti,
	shiftwindow(3),
	cursor(20,20),
	readchar(Aux),
	scelta_relaz(Aux,[Nome,Indirizzo,Qualifica,AnzMin,AnzMax,
	Ditta,Merce,NumDipMin,NumDipMax]),
	cursor(20,20),write("                                            "),
	!,Aux<>'r',Aux<>'s',
	esegui([Nome,Indirizzo,Qualifica,AnzMin,AnzMax,
	Ditta,Merce,NumDipMin,NumDipMax]).

menu :- cursor(3,30),write("Logical Data Base"),
	cursor(6,18),write("1 - Nome :"),
	cursor(7,18),write("2 - Indirizzo :"),
	cursor(8,18),write("3 - Qualifica :"),
	cursor(9,18),write("4 - Anzianit… (min/max) :"),
	cursor(10,18),write("5 - Ditta :"),
	cursor(11,18),write("6 - Merce :"),
	cursor(12,18),write("7 - Num.Dipendenti (min/max) :"),
	cursor(15,18),write("R - Ricerca i record filtrati"),
	cursor(16,18),write("S - Slega le variabili selezionate"),
	cursor(17,18),write("E - Esce").

scelta_relaz('1',[Nome,_,_,_,_,_,_,_,_]) :-
	free(Nome),write("Inserisci nome : "),readln(Aux),
	istanzia(Nome,Aux),
	cursor(6,40),write(Nome).

scelta_relaz('2',[_,Indirizzo,_,_,_,_,_,_,_]) :-
	free(Indirizzo),write("Inserisci indirizzo : "),readln(Aux),
	istanzia(Indirizzo,Aux),
	cursor(7,40),write(Indirizzo).

scelta_relaz('3',[_,_,Qualifica,_,_,_,_,_,_]) :-
	free(Qualifica),write("Inserisci qualifica : "),readln(Aux),
	istanzia(Qualifica,Aux),
	cursor(8,40),write(Qualifica).

scelta_relaz('4',[_,_,_,AnzMin,AnzMax,_,_,_,_]) :-
	free(AnzMin),free(AnzMax),
	write("Inserisci anzianit… min : "),readln(AuxMin),
	cursor(20,20),write("                                 "),cursor(20,20),
	write("Inserisci anzianit… max : "),readln(AuxMax),

	istanzia(AnzMin,AuxMin),
	istanzia(AnzMax,AuxMax),

	cursor(9,50),write("min=",AnzMin,"  Max=",AnzMax).

scelta_relaz('5',[_,_,_,_,_,Ditta,_,_,_]) :-
	free(Ditta),write("Inserisci ditta : "),readln(Aux),
	istanzia(Ditta,Aux),
	cursor(10,40),write(Ditta).

scelta_relaz('6',[_,_,_,_,_,_,Merce,_,_]) :-
	free(Merce),write("Inserisci merce : "),readln(Aux),
	istanzia(Merce,Aux),
	cursor(11,40),write(Merce).

scelta_relaz('7',[_,_,_,_,_,_,_,NumDipMin,NumDipMax]) :-
	free(NumDipMin),free(NumDipMax),
	write("Inserisci num.dipendenti min : "),readln(AuxMin),
	cursor(20,20),write("                                      "),
	cursor(20,20),
	write("Inserisci num.dipendenti max : "),readln(AuxMax),

	istanzia(NumDipMin,AuxMin),
	istanzia(NumDipMax,AuxMax),

	cursor(12,50),write("min=",NumDipMin,"  Max=",NumDipMax).

scelta_relaz('r',[Nome,Indirizzo,Qualifica,AnzMin,AnzMax,
	Ditta,Merce,NumDipMin,NumDipMax]) :-
	shiftwindow(4),
	cerca_relaz([Nome,Indirizzo,Qualifica,AnzMin,AnzMax,
	Ditta,Merce,NumDipMin,NumDipMax]),
	nl,nl,tasto,
	shiftwindow(3).

scelta_relaz('s',_) :- true.

scelta_relaz('e',_) :- retractall(_),principale.

cerca_relaz([Nome,Indirizzo,Qualifica,AnzMin,AnzMax,
	Ditta,Merce,NumDipMin,NumDipMax]) :-
	record([Nome,Indirizzo,Qualifica,Anzianit…,Ditta]),
	record([Ditta,Merce,NumDipendenti]),

	limite_min(AnzMin), limite_min(NumDipMin),
	limite_max(AnzMax), limite_max(NumDipMax),

	str_int(Anzianit…,AnzUguale),
	str_int(AnzMin,AnzMinore),
	str_int(AnzMax,AnzMaggiore),

	str_int(NumDipendenti,DipUguale),
	str_int(NumDipMin,DipMinore),
	str_int(NumDipMax,DipMaggiore),

	AnzUguale<=AnzMaggiore, AnzUguale>=AnzMinore,
	DipUguale<=DipMaggiore, DipUguale>=DipMinore,

	retract(record([Nome,Indirizzo,Qualifica,Anzianit…,Ditta])),
	nl,
	nl,write("Nome       : ",Nome),
	nl,write("Indirizzo  : ",Indirizzo),
	nl,write("Qualifica  : ",Qualifica),
	nl,write("Anzianit…  : ",Anzianit…),
	nl,write("Ditta      : ",Ditta),
	nl,write("Merce      : ",Merce),
	nl,write("Num.Dipend.: ",NumDipendenti),
	nl,nl,tasto,fail. /*qui x forza fail senza cut*/

cerca_relaz([Nome,Indirizzo,Qualifica,AnzMin,AnzMax,
	Ditta,Merce,NumDipMin,NumDipMax]) :-
	retractall(_),nl,nl,write("Ricerca terminata."),nl.

limite_min(Min) :- free(Min),Min="0",!.
limite_min(Min) :- true.

limite_max(Max) :- free(Max),Max="10000",!.
limite_max(Max) :- true.
