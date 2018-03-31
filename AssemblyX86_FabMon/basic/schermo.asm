;-----------------------------------------------------------------------;
; 		     	  the Fab Monitor				;
;	     (C) 1996 by Fabio Bruno & Fabrizio Fazzino			;
;									;
;	File: SCHERMO.ASM						;
;-----------------------------------------------------------------------;

CR      EQU     13      ; Carriage Return
LF      EQU     10      ; Line Feed

;-----------------------------------------------------------------------;
; Caratteri grafici per cornice del blocco.                             ;
;-----------------------------------------------------------------------;
VERTICAL_BAR    EQU     0BAh
HORIZONTAL_BAR  EQU     0CDh
UPPER_LEFT      EQU     0C9h
UPPER_RIGHT     EQU     0BBh
LOWER_LEFT      EQU     0C8h
LOWER_RIGHT     EQU     0BCh
TOP_T_BAR       EQU     0CBh
BOTTOM_T_BAR    EQU     0CAh

PATTERN_LINEA_SUPERIORE LABEL   BYTE
	DB      ' ',7
	DB      UPPER_LEFT,1
	DB      HORIZONTAL_BAR,49
	DB      TOP_T_BAR,1
	DB      HORIZONTAL_BAR,18
	DB      UPPER_RIGHT,1
	DB      0
PATTERN_LINEA_INFERIORE LABEL   BYTE
	DB      ' ',7
	DB      LOWER_LEFT,1
	DB      HORIZONTAL_BAR,49
	DB      BOTTOM_T_BAR,1
	DB      HORIZONTAL_BAR,18
	DB      LOWER_RIGHT,1
	DB      0

COLORI_BORDO_CORNICE    LABEL   BYTE
        DB      ATTRIB_SFONDO,7
        DB      ATTRIB_CORNICE,70
        DB      ATTRIB_SFONDO,3
        DB      0

COLORI_INTERNO_CORNICE  LABEL   BYTE
        DB      ATTRIB_SFONDO,7
        DB      ATTRIB_CORNICE,1
        DB      ATTRIB_DATI_NORMALI,49
        DB      ATTRIB_CORNICE,1
        DB      ATTRIB_DATI_NORMALI,18
        DB      ATTRIB_CORNICE,1
        DB      ATTRIB_SFONDO,7
        DB      0

;-----------------------------------------------------------------------;
; CANCELLA_BLOCCO azzera il contenuto del buffer di 256 byte.           ;
;-----------------------------------------------------------------------;
CANCELLA_BLOCCO PROC
	PUSH    AX CX DI

	LEA     DI,BLOCCO       ; Carica l'indirizzo del blocco
	MOV     CX,256          ; Ripete per 256 volte
	CLD                     ; Setta direzione in avanti
	MOV     AL,0            ; Memorizza il dato AL=0
REP     STOSB                   ; Ripete CX volte

	POP     DI CX AX
	RET
CANCELLA_BLOCCO ENDP

;-----------------------------------------------------------------------;
; LEGGE_BLOCCO legge un blocco di 256 byte scrivendolo in BLOCCO.       ;
;-----------------------------------------------------------------------;
LEGGE_BLOCCO    PROC
	PUSH    AX CX DS SI ES DI
	CALL    CANCELLA_BLOCCO         ; Cancella tutto il blocco

	MOV     DS,CS:INDIRIZZO         ; Base per la lettura in memoria
	MOV     SI,0000h                ; Spiazzamento sempre nullo

	PUSH    CS
	POP     ES
	LEA     DI,BLOCCO       ; Punta al blocco in memoria (destinazione)

	MOV     CX,256          ; Num. di byte da leggere
	CLD                     ; Pone DirFlag=0 (cosç LODSB aumenta SI)

CICLO_LEGGI_MEMORIA:
	LODSB           ; Legge mem.(DS:SI), la scrive in AL e aumenta SI
	STOSB           ; Scrive AL su BLOCCO (ES:DI) e aumenta DI
	LOOP    CICLO_LEGGI_MEMORIA     ; Ripete 256 volte
       
	POP     DI ES SI DS CX AX
	RET
LEGGE_BLOCCO    ENDP

;-----------------------------------------------------------------------;
; SCRIVE_BLOCCO riscrive il blocco modificato in memoria.               ;
;-----------------------------------------------------------------------;
SCRIVE_BLOCCO   PROC
	PUSH    AX CX DS SI ES DI

	LEA     SI,BLOCCO       ; Punta al blocco in memoria (origine)

	MOV     ES,INDIRIZZO    ; Base per la scrittura in memoria
	MOV     DI,0000h        ; Spiazzamento sempre nullo

	MOV     CX,256          ; Num. di byte da scrivere
	CLD                     ; Pone DirFlag=0 (cosç LODSB aumenta SI)

CICLO_SCRIVI_MEMORIA:
	LODSB           ; Legge mem.(DS:SI), la scrive in AL e aumenta SI
	STOSB           ; Scrive AL su BLOCCO (ES:DI) e aumenta DI
	LOOP    CICLO_SCRIVI_MEMORIA    ; Ripete 256 volte
	
	CALL    SCRIVE_PROMPT_NORMALE   ; Riscrive il prompt
	
	POP     DI ES SI DS CX AX
	RET
SCRIVE_BLOCCO   ENDP

;-----------------------------------------------------------------------;
; BLOCCO_PRECEDENTE legge il blocco precedente.                         ;
;-----------------------------------------------------------------------;
BLOCCO_PRECEDENTE      PROC
	PUSH    AX DX

	MOV     AX,INDIRIZZO            ; Rileva indirizzo base corrente
	OR      AX,AX                   ; Se ä giÖ a 0...
	JZ      FINE_BLOCCO_PRECEDENTE  ;               ...non decrementa
	SUB     AX,10h                  ; Sottrae 100h (256 byte)
	MOV     INDIRIZZO,AX            ; Salva nuovo indirizzo

        CALL    MOSTRA_BLOCCO           ; Visualizza nuovo blocco
	CALL    SCRIVE_PROMPT_NORMALE           ; Riscrive prompt normale

FINE_BLOCCO_PRECEDENTE:
	POP     DX AX
	RET
BLOCCO_PRECEDENTE      ENDP

;-----------------------------------------------------------------------;
; BLOCCO_SUCCESSIVO legge il blocco successivo.                         ;
;-----------------------------------------------------------------------;
BLOCCO_SUCCESSIVO     PROC
	PUSH    AX DX
	
	MOV     AX,INDIRIZZO            ; Rileva indirizzo base corrente
	ADD     AX,10h                  ; Aggiunge 100h (256 byte)
	MOV     INDIRIZZO,AX            ; Salva nuovo indirizzo

        CALL    MOSTRA_BLOCCO           ; Visualizza nuovo blocco
	CALL    SCRIVE_PROMPT_NORMALE           ; Riscrive prompt normale
	
	POP     DX AX
	RET
BLOCCO_SUCCESSIVO     ENDP

;-----------------------------------------------------------------------;
; LEGGE_BASE_MEM                                                        ;
;-----------------------------------------------------------------------;
LEGGE_BASE_MEM  PROC
	PUSH    BX DX

        LEA     DX,PROMPT_BASE          ; Stringa di richiesta numero blocco
        CALL    SCRIVE_RIGA_PROMPT      ; Scrive la richiesta
	CALL    LEGGE_WORD              ; Legge la nuova base in BX
        JC      FINE_LEGGE_BASE         ; Se c'ä errore ignora nuova base
        MOV     INDIRIZZO,BX            ; Pone nuova base in INDIRIZZO
        CALL    MOSTRA_BLOCCO           ; Visualizza il nuovo blocco

FINE_LEGGE_BASE:
        CLC                             ; Cancella eventuale carry
        CALL    SCRIVE_PROMPT_NORMALE   ; Visualizza il prompt
	POP     DX BX
	RET
LEGGE_BASE_MEM  ENDP

;-----------------------------------------------------------------------;
; CANCELLA_SCHERMO cancella l'intero schermo.                           ;
;-----------------------------------------------------------------------;
CANCELLA_SCHERMO        PROC
	PUSH    AX BX CX DX
	
	XOR     AL,AL           ; Cancella intera finestra
	XOR     CX,CX           ; Angolo superiore sinistro ä a (0,0)
	MOV     DH,24           ; Riga inferiore dello schermo ä la 24
	MOV     DL,79           ; Limite destro ä la colonna 79
        MOV     BH,ATTRIB_SFONDO        ; Attributo per lo sfondo
	MOV     AH,6            ; Funzione BIOS di scorrimento in alto
	INT     10h             ; INT del BIOS cancella la finestra

	POP     DX CX BX AX
	RET
CANCELLA_SCHERMO        ENDP

;-----------------------------------------------------------------------;
; SCRIVE_TITOLO scrive la riga con il titolo.                           ;
;-----------------------------------------------------------------------;
SCRIVE_TITOLO   PROC
	PUSH    AX BX CX DX

	XOR     DL,DL                   ; Inizio riga (DL=0)
	MOV     DH,NUM_RIGA_TITOLO      ; Vede a quale riga scrivere
	CALL    SPOSTA_CURSORE_XY       ; Sposta il cursore a inizio riga
	PUSH    DX                      ; Salva l'inizio della linea
	LEA     DX,RIGA_TITOLO          ; Punta alla stringa con titolo
	CALL    SCRIVE_STRINGA          ; Scrive la stringa sullo schermo

	POP     DX                      ; Ricalcola inizio riga titolo
	CALL    SPOSTA_CURSORE_XY       ; Pone nuovamente il cursore
	MOV     DL,ATTRIB_TITOLO        ; Carica l'attributo inverso
	MOV     CX,80                   ; Riga di 80 char
	CALL    SCRIVE_ATTRIB_N_VOLTE   ; Scrive l'attributo 80 volte

	POP     DX CX BX AX
	RET
SCRIVE_TITOLO   ENDP

;-----------------------------------------------------------------------;
; SCRIVE_RIGA_FUNZIONI scrive la riga con i tasti funzione in inverso,  ;
; con i numeri in normale.                                              ;
;-----------------------------------------------------------------------;
SCRIVE_RIGA_FUNZIONI    PROC
	PUSH    AX BX CX DX

	XOR     DL,DL                   ; Inizio riga (DL=0)
	MOV     DH,NUM_RIGA_FUNZIONI    ; Vede a quale riga scrivere
	CALL    SPOSTA_CURSORE_XY       ; Sposta il cursore a inizio riga
	PUSH    DX                      ; Salva l'inizio della linea
	LEA     DX,RIGA_FUNZIONI        ; Punta alla stringa con funzioni
	CALL    SCRIVE_STRINGA          ; Scrive la stringa sullo schermo

	POP     DX                      ; Ricalcola inizio riga funzioni
	CALL    SPOSTA_CURSORE_XY       ; Pone nuovamente il cursore
	MOV     AX,5                    ; Ripete il ciclo per 5 tasti
CICLO_FUNZIONI:
	MOV     DL,ATTRIB_FUNZ_NUMERI   ; Carica l'attributo
	MOV     CX,4                    ; Ripete attributo 2 volte
	CALL    SCRIVE_ATTRIB_N_VOLTE   ; Scrive l'attributo

	MOV     DL,ATTRIB_FUNZ_LETTERE  ; Carica l'attributo
	MOV     CX,12                   ; Numero di ripetizioni dell'attributo
	CALL    SCRIVE_ATTRIB_N_VOLTE   ; Scrive l'attributo

	DEC     AX                      ; Diminuisce il contatore del ciclo
	JNZ     CICLO_FUNZIONI          ; Ripete il ciclo 5 volte

	POP     DX CX BX AX
	RET
SCRIVE_RIGA_FUNZIONI    ENDP

;-----------------------------------------------------------------------;
; SCRIVE_INTESTAZIONE scrive l'header con il numero del blocco.         ;
;-----------------------------------------------------------------------;
SCRIVE_INTESTAZIONE     PROC
	PUSH    DX

	XOR     DL,DL                           ; Prima colonna DL=0
	MOV     DH,NUM_RIGA_INTESTAZIONE        ; Riga dell'intestazione
	CALL    SPOSTA_CURSORE_XY       ; Sposta curs. su riga intestazione
	
        LEA     DX,INTESTAZIONE_MEMORIA ; Punta a 'Indirizzo di inizio:'
	CALL    SCRIVE_STRINGA          ; Scrive la stringa
	MOV     DX,INDIRIZZO            ; Carica l'indirizzo base
	CALL    SCRIVE_WORD_HEX         ; Scrive indirizzo base
	LEA     DX,INTESTAZIONE_INDIRIZZO       ; Punta a '0h'
	CALL    SCRIVE_STRINGA          ; Scrive la stringa
	CALL    CANCELLA_FINE_RIGA      ; Pulisco caratteri residui

	POP     DX
	RET
SCRIVE_INTESTAZIONE     ENDP

;-----------------------------------------------------------------------;
; SCRIVE_HEX_SUPERIORI scrive i numeri da 0 a F nella riga superiore    ;
; della visualizzazione del blocco.                                     ;
;-----------------------------------------------------------------------;
SCRIVE_HEX_SUPERIORI    PROC
	PUSH    CX DX

	; Scrivo gli hex sopra la finestra hex
	MOV     DL,' '                  ; Carattere 'spazio'
	MOV     CX,9                    ; Ripete 9 volte
	CALL    SCRIVE_CHAR_N_VOLTE     ; Scrive 9 spazi ad inizio riga

	XOR     DH,DH                   ; Inizia da DH=0
CICLO_NUMERI_HEX:
	MOV     DL,DH                   ; Copia in DL il numero da scrivere
	CALL    SCRIVE_HEX              ; Scrive numero hex
	MOV     DL,' '                  ; Carattere 'spazio'
	CALL    SCRIVE_CHAR             ; Scrive uno spazio
	INC     DH                      ; Aumenta numero hex da scrivere
	CMP     DH,10h                  ; Vede se ha finito (solo 00..0Fh)
	JB      CICLO_NUMERI_HEX        ; Se non ha finito cicla

	; Scrivo gli hex sopra la finestra ASCII
	MOV     DL,' '                  ; Carattere 'spazio'
	MOV     CX,2                    ; Ripete 2 volte
	CALL    SCRIVE_CHAR_N_VOLTE     ; Scrive 2 spazi in finestra ASCII
	XOR     DL,DL                   ; Inizio da DL=0
CICLO_CIFRE_HEX:
	CALL    SCRIVE_CIFRA_HEX        ; Scrive il carattere hex
	INC     DL                      ; Aumenta numero da scrivere
	CMP     DL,10h                  ; Vede se ha finito (10h ä escluso)
	JB      CICLO_CIFRE_HEX         ; Se non ha finito cicla

	CALL    A_CAPO                  ; Pone a capo il cursore

	POP     DX CX
	RET
SCRIVE_HEX_SUPERIORI    ENDP

;-----------------------------------------------------------------------;
; COLORA_SCHERMO colora ogni parte dello schermo del monitor in maniera ;
; differente.                                                           ;
;-----------------------------------------------------------------------;
COLORA_SCHERMO  PROC
        PUSH    CX DX

        XOR     DL,DL                   ; Prima colonna da colorare (DL=0)
        MOV     DH,2                    ; Prima riga da colorare
        CALL    SPOSTA_CURSORE_XY       ; Sposta il cursore all'inizio

        MOV     CX,3                    ; Num.righe superiori (sotto intest.)
COLORA_RIGHE_SUPERIORI:
        PUSH    CX                      ; Salva contatore
        MOV     DL,ATTRIB_SFONDO        ; Carica l'attributo
        MOV     CX,80                   ; Ripete per tutta la riga
        CALL    SCRIVE_ATTRIB_N_VOLTE   ; Colora tutta la riga come sfondo
        CALL    A_CAPO                  ; Va a capo
        POP     CX                      ; Ripristina contatore
        LOOP    COLORA_RIGHE_SUPERIORI  ; Ripete per tutte le righe superiori

        LEA     DX,COLORI_BORDO_CORNICE ; Punta cornice superiore
        CALL    SCRIVE_PATTERN_COLORI   ; Colora cornice superiore
        CALL    A_CAPO                  ; Va a capo

        MOV     CX,16                   ; Num. di righe interne al riquadro
COLORA_RIQUADRO:
        LEA     DX,COLORI_INTERNO_CORNICE       ; Punta interno riquadro dati
        CALL    SCRIVE_PATTERN_COLORI   ; Colora una riga interna al riquadro
        CALL    A_CAPO                  ; Va a capo
        LOOP    COLORA_RIQUADRO         ; Colora le 16 righe di dati

        LEA     DX,COLORI_BORDO_CORNICE ; Punta cornice superiore
        CALL    SCRIVE_PATTERN_COLORI   ; Colora cornice superiore
        CALL    A_CAPO                  ; Va a capo

        MOV     CX,3                    ; Num.righe inferiori
COLORA_RIGHE_INFERIORI:
        PUSH    CX                      ; Salva contatore
        MOV     DL,ATTRIB_SFONDO        ; Carica l'attributo
        MOV     CX,80                   ; Ripete per tutta la riga
        CALL    SCRIVE_ATTRIB_N_VOLTE   ; Colora tutta la riga come sfondo
        CALL    A_CAPO                  ; Va a capo
        POP     CX                      ; Ripristina contatore
        LOOP    COLORA_RIGHE_INFERIORI  ; Ripete per tutte le righe inferiori

        POP     DX CX
        RET
COLORA_SCHERMO  ENDP

;-----------------------------------------------------------------------;
; MOSTRA_BLOCCO visualizza un blocco di 256 byte                        ;
; (utilizza le procedure ausiliarie che seguono).                       ;
;-----------------------------------------------------------------------;
MOSTRA_BLOCCO   PROC
	PUSH    DX

	CALL    SCRIVE_INTESTAZIONE             ; Scrive intestazione
	CALL    LEGGE_BLOCCO                    ; Legge il blocco

	XOR     DL,DL                           ; Prima colonna DL=0
	MOV     DH,NUM_LINEE_BIANCHE_SUPERIORI  ; Prima riga riquadro
	CALL    SPOSTA_CURSORE_XY               ; Sposta il cursore
	CALL    SCRIVE_HEX_SUPERIORI            ; Scrive 00...0F in cima
	LEA     DX,PATTERN_LINEA_SUPERIORE      ; Punta alla cornice superiore
	CALL    SCRIVE_PATTERN                  ; Stampa la cornice superiore
	CALL    A_CAPO                          ; Va a capo

	XOR     DX,DX                           ; Inizio del blocco
	MOV     OFFSET_BLOCCO,DX                ; Imposta offset blocco a 0
        CALL    MOSTRA_BLOCCO_DATI              ; Mostra 256 byte        

	LEA     DX,PATTERN_LINEA_INFERIORE      ; Punta alla cornice inferiore
	CALL    SCRIVE_PATTERN                  ; Stampa la cornice inferiore

        CALL    COLORA_SCHERMO                  ; Colora tutto il riquadro
	CALL    MOSTRA_CURSORE_FANTASMA         ; Scrive il cursore fantasma

	POP     DX
	RET
MOSTRA_BLOCCO   ENDP

;-----------------------------------------------------------------------;
; MOSTRA_BLOCCO_DATI visualizza un blocco (256 byte)                    ;
; (ä una procedura ausiliaria usata da MOSTRA_BLOCCO).                  ;
;-----------------------------------------------------------------------;
MOSTRA_BLOCCO_DATI      PROC
	PUSH    CX DX

	XOR     DX,DX
	MOV     CX,16                   ; Ripete 16 volte
BLOCCO_DATI:
	CALL    MOSTRA_RIGA_DATI        ; Mostra 1 riga di dati
	CALL    A_CAPO                  ; Va a capo
	ADD     DX,16                   ; Si sposta di 16 byte in blocco
        LOOP    BLOCCO_DATI             ; Ripete per visualizzare 16 righe

	POP     DX CX
	RET
MOSTRA_BLOCCO_DATI      ENDP

;-----------------------------------------------------------------------;
; MOSTRA_RIGA_DATI visualizza una riga di dati (16 byte) prima in hex   ;
; e poi in ASCII.                                                       ;
;                                                                       ;
; Ingresso:  DS:DX  =  Distanza in BLOCCO in byte                       ;
;-----------------------------------------------------------------------;
MOSTRA_RIGA_DATI        PROC
	PUSH    AX BX CX DX

	MOV     BX,DX           ; Pone in BX l'offset dentro BLOCCO

	MOV     DL,' '          ; Carattere 'spazio'
	MOV     CX,3            ; Ripete 3 volte
	CALL    SCRIVE_CHAR_N_VOLTE     ; Scrive 3 spazi prima della linea

	; Scrive la distanza in esadecimale (allinea prima e seconda pag.)
	CMP     BX,100h         ; Vede se la prima cifra ä 1
	JB      SCRIVE_UNO      ; No, allora DL ä giÖ uno spazio
	MOV     DL,'1'          ; Sç, allora inserisci 1 in DL
SCRIVE_UNO:
	CALL    SCRIVE_CHAR     ; Scrive DL (primo byte)
	MOV     DL,BL   ; Copia il byte basso in DL per l'output esadecimale
	CALL    SCRIVE_HEX      ; Scrive DL (secondo byte)

	; Scrive separatore
	MOV     DL,' '          ; Carattere 'spazio'
	CALL    SCRIVE_CHAR     ; Scrive lo spazio
	MOV     DL,VERTICAL_BAR ; Lato sinistro del riquadro
	CALL    SCRIVE_CHAR     ; Visualizza lato sinistro riquadro
	MOV     DL,' '          ; Carattere 'spazio'
	CALL    SCRIVE_CHAR     ; Scrive un altro spazio

	; Scrive i dati nella finestra hex
	MOV     CX,16           ; Ripete 16 volte
	PUSH    BX              ; Conserva BX
CICLO_HEX:
	MOV     DL,BLOCCO[BX]   ; Preleva 1 byte
	CALL    SCRIVE_HEX      ; Visualizza il byte in esadecimale
	MOV     DL,' '          ; Carattere 'spazio'
	CALL    SCRIVE_CHAR     ; Scrive uno spazio tra i numeri
	INC     BX              ; Aumenta l'offset dentro BLOCCO
	LOOP    CICLO_HEX       ; Ripete per i 16 byte

	; Scrive separatore
	MOV     DL,VERTICAL_BAR ; Separatore centrale tra i 2 riquadri
	CALL    SCRIVE_CHAR     ; Scrive il separatore
	MOV     DL,' '          ; Aggiunge altro spazio prima dei caratteri
	CALL    SCRIVE_CHAR     ; Stampa lo spazio

	; Scrive i dati nella finestra ASCII
	MOV     CX,16           ; Ripete 16 volte
	POP     BX              ; Ripristina la distanza dentro BLOCCO
CICLO_ASCII:
	MOV     DL,BLOCCO[BX]   ; Preleva 1 byte
	CALL    SCRIVE_CHAR     ; Visualizza il byte come ASCII
	INC     BX              ; Aumenta l'offset dentro BLOCCO
	LOOP    CICLO_ASCII     ; Ripete per i 16 byte

	; Scrive separatore
	MOV     DL,' '          ; Carattere 'spazio'
	CALL    SCRIVE_CHAR     ; Scrive lo spazio a fine riga
	MOV     DL,VERTICAL_BAR ; Lato destro del riquadro
	CALL    SCRIVE_CHAR     ; Traccia il lato destro del riquadro

	POP     DX CX BX AX
	RET
MOSTRA_RIGA_DATI        ENDP

;-----------------------------------------------------------------------;
; SPOSTA_CURSORE_XY sposta il cursore.                                  ;
;                                                                       ;
; Ingresso:  DH  =  Riga (Y)                                            ;
;            DL  =  Colonna (X)                                         ;
;-----------------------------------------------------------------------;
SPOSTA_CURSORE_XY       PROC
	PUSH    AX BX

	MOV     BH,0            ; Visualizza pagina 0
	MOV     AH,2            ; Funzione per settare posiz.cursore
	INT     10h             ; INT del BIOS setta il cursore a (DH,DL)

	MOV     AL,DH           ; Prende il numero di riga
	MOV     BL,80           ; Moltiplica per 80 caratteri per linea
	MUL     BL              ; AX = riga * 80
	ADD     AL,DL           ; Aggiunge la colonna
	ADC     AH,0            ; AX = riga * 80 + colonna
	SHL     AX,1            ; Moltiplica AX per 2
	MOV     SCHERMO_PTR,AX  ; Salva l'offset del cursore
	MOV     SCHERMO_X,DL    ; Salva colonna del cursore
	MOV     SCHERMO_Y,DH    ; Salva riga del cursore

	POP     BX AX
	RET
SPOSTA_CURSORE_XY       ENDP

;-----------------------------------------------------------------------;
; SPOSTA_CURSORE_DESTRA sposta il cursore a destra di una posizione o   ;
; alla riga successiva se il cursore si trova a fine riga.              ;
;-----------------------------------------------------------------------;
SPOSTA_CURSORE_DESTRA   PROC
	INC     SCHERMO_PTR     ; Si sposta al carattere successivo
	INC     SCHERMO_PTR     ; (deve superare anche l'attributo)
	INC     SCHERMO_X       ; Aumenta il numero di colonna
	CMP     SCHERMO_X,79    ; Si assicura che la colonna sia <= 79
	JBE     OK              ; Se colonna <=79 finisce
	CALL    A_CAPO          ; Altrimenti va alla linea successiva
OK:
	RET
SPOSTA_CURSORE_DESTRA   ENDP

;-----------------------------------------------------------------------;
; AGGIORNA_CURSORE_VERO sposta il cursore vero nella posizione corrente ;
; del cursore virtuale. Deve essere chiamato appena prima della         ;
; richiesta di input all'utente.                                        ;
;-----------------------------------------------------------------------;
AGGIORNA_CURSORE_VERO   PROC
	PUSH    DX
	MOV     DL,SCHERMO_X            ; Colonna attuale del cursore virtuale
	MOV     DH,SCHERMO_Y            ; Riga attuale del cursore virtuale
	CALL    SPOSTA_CURSORE_XY       ; Sposta curs.reale in questa posiz.
	POP     DX
	RET
AGGIORNA_CURSORE_VERO   ENDP

;-----------------------------------------------------------------------;
; AGGIORNA_CURSORE_VIRTUALE aggiorna la posizione del cursore virtuale  ;
; in accordo con la posizione del cursore reale.                        ;
;-----------------------------------------------------------------------;
AGGIORNA_CURSORE_VIRTUALE       PROC
	PUSH    AX BX CX DX

	MOV     AH,3            ; Funzione BIOS per chiedere posiz.cursore
	XOR     BH,BH           ; Pagina BH=0
	INT     10h             ; BIOS salva posizione del cursore in (DH,DL)
	CALL    SPOSTA_CURSORE_XY       ; Sposta curs.virt.in questa posizione

	POP     DX CX BX AX
	RET
AGGIORNA_CURSORE_VIRTUALE       ENDP

;-----------------------------------------------------------------------;
; LEGGE_POSIZIONE_CURSORE non utilizza le convenzioni standard per      ;
; ritornare le informazioni nel registro AX in modo che possa essere    ;
; usata facilmente con SPOSTA_CURSORE_XY                                ;
;                                                                       ;
; Uscita:  DH  =  Riga (Y) del cursore                                  ;
;          DL  =  Colonna (X) del cursore                               ;
;-----------------------------------------------------------------------;
LEGGE_POSIZIONE_CURSORE PROC
	PUSH    AX BX CX

	MOV     AH,3            ; Funzione BIOS per chiedere posiz.cursore
	XOR     BH,BH           ; Pagina BH=0
	INT     10h             ; INT del BIOS

	POP     CX BX AX
	RET
LEGGE_POSIZIONE_CURSORE ENDP

;-----------------------------------------------------------------------;
; CANCELLA_FINE_RIGA cancella la riga dalla posizione corrente del      ;
; cursore alla fine della riga stessa.                                  ;
;-----------------------------------------------------------------------;
CANCELLA_FINE_RIGA      PROC
	PUSH    AX BX CX DX

	MOV     DL,SCHERMO_X    ; Legge colonna cursore virtuale
	MOV     DH,SCHERMO_Y    ; Legge riga cursore virtuale
	MOV     AH,6            ; Funzione per scorrere finestra su
	XOR     AL,AL           ; Cancella tutta la finestra
	MOV     CH,DH           ; Inizio e fine sulla stessa riga
	MOV     CL,DL           ; Inizia dalla colonna del cursore
	MOV     DL,79           ; Termina alla fine della riga
        MOV     BH,ATTRIB_SFONDO        ; Usa gli attributi normali
	INT     10h             ; INT del BIOS cancella fine riga

	POP     DX CX BX AX
	RET
CANCELLA_FINE_RIGA      ENDP

;-----------------------------------------------------------------------;
; A_CAPO sposta a capo il cursore.                                      ;
;-----------------------------------------------------------------------;
A_CAPO          PROC
	PUSH    AX BX CX DX
	
	MOV     AH,3            ; Servizio per leggere posizione cursore
	XOR     BH,BH           ; Pagina 0
	INT     10h             ; INT del BIOS ( [riga,colonna]=[DH,DL] )
	
	INC     DH              ; Incrementa riga
	XOR     DL,DL           ; Azzera colonna

	MOV     AH,2            ; Servizio per settare posizione cursore
	XOR     BH,BH           ; Pagina 0
	INT     10h             ; INT del BIOS
	
	CALL    AGGIORNA_CURSORE_VIRTUALE       ; Aggiorna cursore
      
	POP     DX CX BX AX        
	RET
A_CAPO          ENDP

;-----------------------------------------------------------------------;
; SCRIVE_RIGA_PROMPT scrive la riga di messaggio sullo schermo e        ;
; cancella la parte restante della riga.                                ;
;                                                                       ;
; Ingresso:  DS:DX  =  Indirizzo della riga di messaggio                ;
;-----------------------------------------------------------------------;
SCRIVE_RIGA_PROMPT      PROC
	PUSH    DX                      ; Conserva indirizzo riga da scrivere

	XOR     DL,DL                   ; Prima colonna (DL=0)
	MOV     DH,NUM_RIGA_PROMPT      ; Riga su cui scrivere prompt
	CALL    SPOSTA_CURSORE_XY       ; Sposta il cursore

	POP     DX                      ; Ripristina indirizzo riga
	CALL    SCRIVE_STRINGA          ; Scrive la riga del prompt
	CALL    CANCELLA_FINE_RIGA      ; Cancella caratteri residui
	RET
SCRIVE_RIGA_PROMPT      ENDP

;-----------------------------------------------------------------------;
; SCRIVE_PROMPT_NORMALE scrive la riga del prompt normale (inserimento).;
;-----------------------------------------------------------------------;
SCRIVE_PROMPT_NORMALE   PROC
	PUSH    DX

	LEA     DX,PROMPT_NORMALE       ; Punta alla riga del prompt normale
	CALL    SCRIVE_RIGA_PROMPT      ; Scrive la riga del prompt

	POP     DX
	RET
SCRIVE_PROMPT_NORMALE   ENDP
