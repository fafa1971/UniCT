;-----------------------------------------------------------------------;
; 		     	  the Fab Monitor				;
;	     (C) 1996 by Fabio Bruno & Fabrizio Fazzino			;
;									;
;       File: MAIN.ASM                                                  ;
;-----------------------------------------------------------------------;

ATTRIB_TITOLO           EQU     94      ; Viola + giallo
ATTRIB_FUNZ_NUMERI      EQU     32      ; Verde + nero
ATTRIB_FUNZ_LETTERE     EQU     31      ; Blu + bianchissimo
ATTRIB_SFONDO           EQU     78      ; Rosso + giallo
ATTRIB_ERRORE           EQU     79      ; Rosso + bianchissimo
ATTRIB_CORNICE          EQU     62      ; Ciano + giallo
ATTRIB_DATI_NORMALI     EQU     23      ; Rosso + giallo
ATTRIB_DATI_EVIDENZIATI EQU     113     ; Ciano + nero

INDIRIZZO       DW      0       ; Indirizzo d'inizio visualizzaz.memoria

OFFSET_BLOCCO   DW      0       ; Offset visualizzazione blocco

NUM_LINEE_BIANCHE_SUPERIORI     DB      4       ; Num.righe vuote in alto
NUM_RIGA_TITOLO                 DB      0       ; Riga del titolo
NUM_RIGA_INTESTAZIONE           DB      2       ; Riga intestazione
RIGA_TITOLO                     DB      32 DUP(' '),'the Fab Monitor',0
INTESTAZIONE_MEMORIA            DB      '  Indirizzo di inizio : ',0
INTESTAZIONE_INDIRIZZO          DB      ':0000h',0

NUM_RIGA_PROMPT         DB      23
PROMPT_NORMALE          DB      '  Inserire char alfanumerico (es.R)'
			DB      ' o byte esadecimale (es.2C) : ',0
PROMPT_BASE             DB      '  Inserire base dell''indirizzo (4 hex) : ',0

NUM_RIGA_FUNZIONI       DB      1
RIGA_FUNZIONI           DB      'Pag',24,'Ind.Preced. '
			DB      'Pag',25,'Ind.Success.'
			DB      'Iniz',' Setta Base '
			DB      'Ins.','Salva modif.'
			DB      'Fine','Torna al DOS'
			DB      0

BLOCCO                  DB      256 DUP (?)     ; Buffer di 256 byte

INCLUDE IO_UTIL.ASM
INCLUDE SCHERMO.ASM
INCLUDE EDITOR.ASM

;-----------------------------------------------------------------------;
; MAIN                                                                  ;
;-----------------------------------------------------------------------;
MAIN    PROC
	PUSH    DS
	PUSH    AX
	
	ASSUME  DS:@CODE
	MOV     AX,CS
	MOV     DS,AX
	
	POP     AX        

	CALL    CANCELLA_SCHERMO        ; Cancella tutto lo schermo
	CALL    SCRIVE_TITOLO           ; Scrive titolo (primo rigo)
	CALL    SCRIVE_RIGA_FUNZIONI    ; Scrive tasti funz.(secondo rigo)
        CALL    MOSTRA_BLOCCO           ; Mostra dati sullo schermo
	CALL    SCRIVE_PROMPT_NORMALE   ; Scrive prompt in fondo allo schermo

	CALL    SMISTA          ; Legge tasto e seleziona opportuna funzione
	; Ritorna da SMISTA solo se viene premuto F10 per uscire al DOS

	POP     DS
	RET
MAIN    ENDP

;-----------------------------------------------------------------------;
; La TABELLA_SMISTAMENTO contiene i codici estesi legali ASCII e gli    ;
; indirizzi delle procedure che devono essere richiamate quando si      ;
; preme un tasto.                                                       ;
;                                                                       ;
; Il formato della tabella ä :                                          ;
;        DB   72                                ; Codice esteso         ;
;        DW   OFFSET CURSORE_FANTASMA_SU                                ;
;-----------------------------------------------------------------------;
TABELLA_SMISTAMENTO      LABEL   BYTE
	DB      82                              ; Insert
	DW      OFFSET SCRIVE_BLOCCO
	DB      73                              ; Pagina su
	DW      OFFSET BLOCCO_PRECEDENTE
	DB      81                              ; Pagina gió
	DW      OFFSET BLOCCO_SUCCESSIVO
	DB      71                              ; Home
	DW      OFFSET LEGGE_BASE_MEM
	DB      72                              ; Cursore su
	DW      OFFSET CURSORE_FANTASMA_SU
	DB      80                              ; Cursore gió
	DW      OFFSET CURSORE_FANTASMA_GIU
	DB      75                              ; Cursore sinistra
	DW      OFFSET CURSORE_FANTASMA_SINISTRA
	DB      77                              ; Cursore destra
	DW      OFFSET CURSORE_FANTASMA_DESTRA
	DB      0                               ; Fine tabella

;-----------------------------------------------------------------------;
; SMISTA ä la routine di smistamento principale. Durante le normali     ;
; operazioni di editing e di visualizzazione questa procedura legge i   ;
; caratteri dalla tastiera e, se il carattere ä un tasto di comando     ;
; (come ad esempio un tasto cursore), SMISTA richiama le procedure      ;
; che effettuano il lavoro effettivo. Lo smistamento ä effettuato per   ;
; tutti i tasti elencati nella tabella TAVOLA_SMISTAMENTO, dove gli     ;
; indirizzi delle procedure sono memorizzati subito dopo i nomi dei     ;
; tasti.                                                                ;
;   Se il carattere non ä un tasto speciale, dovrÖ essere introdotto    ;
; direttamente nel buffer di blocco (modalitÖ di editing).              ;
;-----------------------------------------------------------------------;
SMISTA          PROC
	PUSH    AX BX DX
CICLO_SMISTA:
	CALL    LEGGE_BYTE      ; Legge carattere in AX
	OR      AH,AH           ; AX=-1 se no char letto, 1 codice esteso
	JS      NO_CHAR_LETTI   ; Negativo=nessun carattere letto, riprova
	JNZ     CHAR_SPECIALE   ; Letto un codice esteso
	MOV     DL,AL
	CALL    EDITA_BYTE      ; Era un carattere normale, modifica byte
	JMP     CICLO_SMISTA    ; Legge un altro carattere

CHAR_SPECIALE:
	CMP     AL,79           ; Se ä premuto End = uscita
	JE      FINE_SMISTA     ; Sç, esci
				; Usa BX per consultare la tabella
	LEA     BX,TABELLA_SMISTAMENTO
SCANDISCI_TABELLA:
	CMP     BYTE PTR [BX],0 ; Fine tabella?
	JE      NON_IN_TABELLA  ; Sç, tasto non presente in tabella
	CMP     AL,[BX]         ; Corrisponde a questo elemento di tabella?
	JE      PUOI_SMISTARE   ; Sç, allora smista
	ADD     BX,3            ; No, prova il prossimo elemento
	JMP     SCANDISCI_TABELLA       ; Controlla success.elem.in tabella

PUOI_SMISTARE:
	INC     BX              ; Punta a indirizzo di procedura
	CALL    WORD PTR [BX]   ; Richiama procedura
	JMP     CICLO_SMISTA    ; Attende altro tasto

NON_IN_TABELLA: ; Non produce nulla, legge solo il carattere successivo
	JMP     CICLO_SMISTA

NO_CHAR_LETTI:
	LEA     DX,PROMPT_NORMALE
	CALL    SCRIVE_RIGA_PROMPT      ; Cancella i caratteri non validi
	JMP     CICLO_SMISTA            ; Riprova

FINE_SMISTA:
	POP     DX BX AX
	RET
SMISTA          ENDP

