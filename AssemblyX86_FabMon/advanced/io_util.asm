;-----------------------------------------------------------------------;
; 		     	  the Fab Monitor				;
;	     (C) 1996 by Fabio Bruno & Fabrizio Fazzino			;
;									;
;	File: IO_UTIL.ASM						;
;-----------------------------------------------------------------------;

BS      EQU     8       ; Carattere di Backspace
CR      EQU     13      ; Carattere Carriage Return
ESCAPE  EQU     27      ; Carattere Escape

SCHERMO_SEG      DW      0B800h ; Segmento del buffer di schermo
SCHERMO_PTR      DW      0      ; Offset del cursore nella memoria video
SCHERMO_X        DB      0      ; Coordinata X del cursore
SCHERMO_Y        DB      0      ; Coordinata Y del cursore

INPUT_TASTIERA  LABEL   BYTE
NUM_CHAR_MAX    DB      0               ; Lunghezza del buffer di input
NUM_CHAR_LETTI  DB      0               ; Numero di caratteri letti
CHARS           DB      80 DUP (0)      ; Buffer per input da tastiera

;-----------------------------------------------------------------------;
; UtilitÖ per l'output sullo schermo.                                   ;
;-----------------------------------------------------------------------;

;-----------------------------------------------------------------------;
; SCRIVE_CHAR invia un carattere allo schermo scrivendo direttamente    ;
; nella memoria video; in questo modo un carattere come il backspace    ;
; ä trattato come un qualsiasi altro carattere e visualizzato.          ;
;                                                                       ;
; Ingresso:  DL  =  Byte da stampare sullo schermo                      ;
;-----------------------------------------------------------------------;
SCRIVE_CHAR     PROC
	PUSH    AX BX CX DX ES

	ASSUME  DS:@CODE
	MOV     AX,CS
	MOV     DS,AX
	
	MOV     AX,SCHERMO_SEG  ; Pone segmento memoria video...
	MOV     ES,AX           ;                       ...in ES
	MOV     BX,SCHERMO_PTR  ; Punta al carattere nella memoria schermo

        MOV     ES:[BX],DL              ; Scrive char sullo schermo
	CALL    SPOSTA_CURSORE_DESTRA   ; Sposta alla pos.success.del cursore

	POP     ES DX CX BX AX
	RET
SCRIVE_CHAR     ENDP

;-----------------------------------------------------------------------;
; SCRIVE_STRINGA scrive una stringa di caratteri sullo schermo.         ;
; La stringa deve terminare con DB 0.                                   ;
;                                                                       ;
; Ingresso:  DS:DX  =  Indirizzo della stringa                          ;
;-----------------------------------------------------------------------;
SCRIVE_STRINGA  PROC
	PUSH    AX DX SI
	PUSHF                   ; Salva flag direzione
	CLD                     ; Imposta direzione per incremento (in avanti)
	MOV     SI,DX           ; Pone indirizzo in SI (per LODSB)

CICLO_STRINGA:
	LODSB                   ; Carica in AL il byte ES:[SI]
	OR      AL,AL           ; Controlla se stringa ä finita (con 0)
	JZ      FINE_SCRIVE_STRINGA    ; Sç, abbiamo finito con la stringa
	MOV     DL,AL           ; No, carica char per successiva funzione
	CALL    SCRIVE_CHAR     ; Scrive il carattere
	JMP     CICLO_STRINGA   ; Itera per ogni carattere della stringa

FINE_SCRIVE_STRINGA:
	POPF                    ; Ripristina flag di direzione
	POP     SI DX AX
	RET
SCRIVE_STRINGA  ENDP

;-----------------------------------------------------------------------;
; SCRIVE_CIFRA_HEX converte i 4 bit bassi di DL in una cifra esadecimale;
; e la scrive sullo schermo. In realtÖ serve al successivo SCRIVE_HEX.  ;
;                                                                       ;
; Ingresso:  DL  =  I 4 bit inferiori contengono numero da              ;
;                       visualizzare in esadecimale                     ;
;-----------------------------------------------------------------------;
SCRIVE_CIFRA_HEX        PROC
	PUSH    DX                      ; Salva i registri utilizzati
	CMP     DL,10                   ; Questo nibble ä <10 ?
	JAE     LETTERA_HEX             ; No, converte in lettera
	ADD     DL,"0"                  ; Sç, converte in una cifra
	JMP     SCRIVE_CIFRA            ; Scrive questo carattere
LETTERA_HEX:
	ADD     DL,"A"-10       ; Converte in lettera esadecimale
SCRIVE_CIFRA:
	CALL    SCRIVE_CHAR     ; Visualizza la lettera sullo schermo
	POP     DX              ; Ripristina vecchio valore di AX
	RET
SCRIVE_CIFRA_HEX        ENDP

;-----------------------------------------------------------------------;
; SCRIVE_HEX converte il byte nel registro DL in esadecimale e          ;
; scrive le due cifre esadecimali alla posizione corrente del cursore.  ;
;                                                                       ;
; Ingresso:  DL  =  Byte da convertire in esadecimale.                  ;
;-----------------------------------------------------------------------;
SCRIVE_HEX      PROC            ; Punto di inserimento
	PUSH    CX DX           ; Salva registri usati in questa procedura

	MOV     DH,DL           ; Fa una copia del byte da visualizzare
	MOV     CX,4            ; Prepara shift a dx di 4 posizioni
	SHR     DL,CL           ; Pone in DL solo il suo nibble pió alto
	CALL    SCRIVE_CIFRA_HEX        ; Visualizza prima cifra esadecimale

	MOV     DL,DH           ; Ripreleva il byte da visualizzare
	AND     DL,0Fh          ; Cancella il nibble alto
	CALL    SCRIVE_CIFRA_HEX        ; Visualizza seconda cifra esadecimale

	POP     DX CX
	RET
SCRIVE_HEX      ENDP

;-----------------------------------------------------------------------;
; SCRIVE_WORD_HEX scrive DX come 4 cifre esadecimali.                   ;
;                                                                       ;
; Ingresso:  DX  =  Word da convertire in esadecimale.                  ;
;-----------------------------------------------------------------------;
SCRIVE_WORD_HEX PROC
	PUSH    DX

	XCHG    DH,DL                   ; Metto la parte alta in DL
	CALL    SCRIVE_HEX              ; Scrive parte alta dell'indirizzo
	MOV     DL,DH                   ; Rimetto in DL la parte bassa
	CALL    SCRIVE_HEX              ; Scrive la parte bassa dell'indir.

	POP     DX
	RET
SCRIVE_WORD_HEX ENDP

;-----------------------------------------------------------------------;
; SCRIVE_DECIMALE serve per scrivere un numero a 16 bit senza segno     ;
; in notazione decimale.                                                ;
;                                                                       ;
; Ingresso:  DX  =  numero senza segno a 16 bit.                        ;
;-----------------------------------------------------------------------;
SCRIVE_DECIMALE PROC
	PUSH    AX BX CX DX SI

	MOV     AX,DX           ; Pone in AX il numero da convertire
	MOV     SI,10           ; Preparo divisione per 10 usando SI
	XOR     CX,CX           ; Azzero il contatore
NON_ZERO:
	XOR     DX,DX           ; Imposta la parola superiore del num a 0
	DIV     SI              ; Calcola quoziente AX e resto DX di DX:AX/10
	PUSH    DX              ; Conserva resto (cifra dec.) nello stack
	INC     CX              ; Aggiunge un'altra cifra
	OR      AX,AX           ; Controlla se il quoziente AX ä 0
	JNE     NON_ZERO        ; No, nuova iterazione

CICLO_SCRITTURA_CIFRA:
	POP     DX              ; Preleva le cifre in ordine inverso
	CALL    SCRIVE_CIFRA_HEX        ; Scrive una cifra decimale (0..9)
	LOOP    CICLO_SCRITTURA_CIFRA   ; Itera per tutte le cifre

FINE_SCRIVI_DECIMALE:
	POP     SI DX CX BX AX
	RET
SCRIVE_DECIMALE ENDP

;-----------------------------------------------------------------------;
; SCRIVE_CHAR_N_VOLTE scrive pió di una copia di un carattere           ;
;                                                                       ;
; Ingresso:  DL  =  Codice carattere                                    ;
;            CX  =  Numero di copie del carattere                       ;
;-----------------------------------------------------------------------;
SCRIVE_CHAR_N_VOLTE     PROC
	PUSH    CX
N_VOLTE:
	CALL    SCRIVE_CHAR     ; Scrive il carattere in DL
	LOOP    N_VOLTE         ; Ripete CX volte

	POP     CX
	RET
SCRIVE_CHAR_N_VOLTE      ENDP

;-----------------------------------------------------------------------;
; SCRIVE_ATTRIB_N_VOLTE imposta l'attributo per N caratteri, iniziando  ;
; dalla posizione corrente del cursore.                                 ;
;                                                                       ;
; Ingresso:  CX  =  Numero di caratteri di cui impostare l'attributo    ;
;            DL  =  Nuovo attributo per i caratteri                     ;
;-----------------------------------------------------------------------;
SCRIVE_ATTRIB_N_VOLTE PROC
	PUSH    AX BX CX DX DI ES

	MOV     AX,SCHERMO_SEG  ; Pone segmento memoria video...
	MOV     ES,AX           ;                       ...in ES
	MOV     DI,SCHERMO_PTR  ; Fa puntare DI al carattere
	INC     DI              ; Punta all'attributo di tale carattere
	MOV     AL,DL           ; Mette in AL l'attributo da scrivere
CICLO_ATTRIB:
	STOSB                   ; Scrive l'attributo AL in ES:[DI]
	INC     DI              ; Si sposta all'attributo successivo
	INC     SCHERMO_X       ; Memorizza cursore alla colonna successiva
	LOOP    CICLO_ATTRIB    ; Scrive l'attributo CX volte

	DEC     DI              ; Punta all'ultimo carattere scritto
	MOV     SCHERMO_PTR,DI  ; Salva posiz.ultimo char nel punt.schermo

	POP     ES DI DX CX BX AX
	RET
SCRIVE_ATTRIB_N_VOLTE ENDP

;-----------------------------------------------------------------------;
; SCRIVE_PATTERN traccia una linea sullo schermo sulla base dei dati    ;
; seguenti :                                                            ;
;       DB   { char, volte } , 0                                        ;
; (dove {char,volte} significa che tale coppia puï essere ripetuta).    ;
;                                                                       ;
; Ingresso:  DS:DX  =  Indirizzo del modello da tracciare               ;
;-----------------------------------------------------------------------;
SCRIVE_PATTERN  PROC
	PUSH    AX BX CX DX SI
	PUSHF           ; Salva il flag di direzione
	CLD             ; Imposta il flag direzione per l'incremento
	MOV     SI,DX   ; Pone l'indirizzo del pattern in SI (per LODSB)

CICLO_PATTERN:
	LODSB           ; Carica in AL il char che era a DS:SI
	OR      AL,AL   ; Controlla se i dati sono finiti (con lo zero)
	JZ      FINE_PATTERN    ; Sç, finisce
	MOV     DL,AL   ; No, conserva in DL il char da scrivere
	LODSB           ; Carica in AL il numero di copie da fare
	MOV     CL,AL   ; Copio tale numero di copie (byte) in CX
	XOR     CH,CH   ; Ovviamente imposto a 0 il byte alto della word CX
	CALL    SCRIVE_CHAR_N_VOLTE     ; Scrive CX volte il char DL
	JMP     CICLO_PATTERN   ; Ripete il ciclo per ogni char del pattern

FINE_PATTERN:
	POPF            ; Ripristina il flag direzione
	POP     SI DX CX BX AX
	RET
SCRIVE_PATTERN  ENDP

;-----------------------------------------------------------------------;
; SCRIVE_PATTERN_COLORI colora una linea sullo schermo sulla base dei   ;
; dati seguenti :                                                       ;
;       DB   { char, volte } , 0                                        ;
; (dove {char,volte} significa che tale coppia puï essere ripetuta).    ;
;                                                                       ;
; Ingresso:  DS:DX  =  Indirizzo del modello da tracciare               ;
;-----------------------------------------------------------------------;
SCRIVE_PATTERN_COLORI   PROC
	PUSH    AX BX CX DX SI
	PUSHF           ; Salva il flag di direzione
	CLD             ; Imposta il flag direzione per l'incremento
	MOV     SI,DX   ; Pone l'indirizzo del pattern in SI (per LODSB)

CICLO_PATTERN_COLORI:
	LODSB           ; Carica in AL il char che era a DS:SI
	OR      AL,AL   ; Controlla se i dati sono finiti (con lo zero)
        JZ      FINE_PATTERN_COLORI     ; Sç, finisce
	MOV     DL,AL   ; No, conserva in DL il char da scrivere
	LODSB           ; Carica in AL il numero di copie da fare
	MOV     CL,AL   ; Copio tale numero di copie (byte) in CX
	XOR     CH,CH   ; Ovviamente imposto a 0 il byte alto della word CX
        CALL    SCRIVE_ATTRIB_N_VOLTE   ; Scrive CX volte il char DL
        JMP     CICLO_PATTERN_COLORI    ; Ripete ciclo per ogni char

FINE_PATTERN_COLORI:
	POPF            ; Ripristina il flag direzione
	POP     SI DX CX BX AX
	RET
SCRIVE_PATTERN_COLORI   ENDP

;-----------------------------------------------------------------------;
; UtilitÖ per l'input da tastiera.                                      ;
;-----------------------------------------------------------------------;

;-----------------------------------------------------------------------;
; LEGGE_TASTO legge un carattere dalla tastiera.                        ;
;                                                                       ;
; Uscita:  AL  =  Codice carattere (ad eccezione di AH=1)               ;
;          AH  =   0 se legge carattere ASCII                           ;
;                  1 se legge un carattere speciale                     ;
;-----------------------------------------------------------------------;
LEGGE_TASTO     PROC
	XOR     AH,AH           ; Funzione AH=0 del BIOS
	INT     16h             ; BIOS legge char+scancode della tastiera
	OR      AL,AL           ; Se ASCII=0 ä un codice esteso
	JZ      CODICE_ESTESO   ; Se ä un codice esteso salta pió avanti
NON_ESTESO:
	XOR     AH,AH           ; Azzera scancode AH=0 (ritorna AL=ASCII)
LETTURA_FINITA:
	RET

CODICE_ESTESO:
	MOV     AL,AH           ; Mette scancode in AL
	MOV     AH,1            ; AH=1 segnala codice esteso
	JMP     LETTURA_FINITA  ; Ritorna AH=1 e AL=carattere speciale
LEGGE_TASTO     ENDP

;-----------------------------------------------------------------------;
; CONVERTE_CHAR_MAIUSCOLO converte in maiuscolo il char in AL.          ;
;-----------------------------------------------------------------------;
CONVERTE_CHAR_MAIUSCOLO   PROC
	CMP     AL,'a'          ; Confronta il char col pió piccolo minuscolo
	JB      NON_MINUSCOLO   ; Se ä ancora pió piccolo non ä minuscolo
	CMP     AL,'z'          ; Confronta il char col pió grande minuscolo
	JA      NON_MINUSCOLO   ; Se ä ancora pió grande non ä minuscolo
	ADD     AL,'A'-'a'      ; E'minuscolo, converti in maiuscolo                                                                            
NON_MINUSCOLO:
	RET
CONVERTE_CHAR_MAIUSCOLO   ENDP

;-----------------------------------------------------------------------;
; CONVERTE_STRINGA_MAIUSCOLO converte i caratteri della stringa, usando ;
; il formato del DOS per le stringhe, in tutte lettere maiuscole.       ;
;                                                                       ;
;       DS:DX   Indirizzo del buffer di stringa                         ;
;-----------------------------------------------------------------------;
CONVERTE_STRINGA_MAIUSCOLO PROC
	PUSH    AX BX CX

	MOV     BX,DX           ; Pone in BX lo spiazzamento della stringa
	INC     BX              ; Punta al contatore di caratteri letti
	MOV     CL,[BX]         ; Conteggio char nel secondo byte del buffer
	XOR     CH,CH           ; Azzera byte superiore del contatore
CICLO_MAIUSCOLO:
	INC     BX              ; Punta al carattere successivo nel buffer
	MOV     AL,[BX]         ; Legge il carattere e lo pone in AL
	CALL    CONVERTE_CHAR_MAIUSCOLO ; Converte il singolo char maiuscolo
	MOV     [BX],AL         ; Riconserva carattere convertito nel buffer
	LOOP    CICLO_MAIUSCOLO ; Itera CX volte per ogni char della stringa

	POP     CX BX AX
	RET
CONVERTE_STRINGA_MAIUSCOLO ENDP

;-----------------------------------------------------------------------;
; BEEP emette un breve suono senza usare l'INT del DOS.                 ;
;-----------------------------------------------------------------------;
BEEP    PROC
	PUSH    AX CX DX
	
	CLI                             ; Disabilito gli interrupt
        MOV     DX,500                  ; Lunghezza suono (in cicli)
	IN      AL,61h                  ; Legge porta timer (chip i8253)
	AND     AL,11111110b            ; Scollega altoparlante dal timer
PROX_CICLO:
	OR      AL,00000010b            ; Attiva altoparlante
	OUT     61h,AL                  ; Invia il comando alla porta
	MOV     CX,3000                 ; Periodo (ritardo 1^ metÖ ciclo)
PRIMA_META:
	LOOP    PRIMA_META              ; Genera ritardo mentre altop.attivo
	AND     AL,11111101b            ; Disattivo altoparlante
	OUT     61h,AL                  ; Invia il comando
	MOV     CX,3000                 ; Periodo (ritardo 2^ metÖ ciclo)
SECONDA_META:
	LOOP    SECONDA_META            ; Ritardo mentre altop.non attivo
	DEC     DX                      ; Decrementa il numero di cicli
	JNZ     PROX_CICLO              ; Se zero termina
	STI                             ; Riabilito gli interrupt

	POP     DX CX AX
	RET
BEEP    ENDP

;-----------------------------------------------------------------------;
; LEGGE_STRINGA svolge una funzione molto simile alla funzione AH=0Ah   ;
; dell'INT 21h del DOS, perï riporta se viene premuto un tasto funzione ;
; o un tasto speciale. ESC cancella l'input e permette di ricominciare. ;
;                                                                       ;
; Ingresso:  DS:DX  =  Indirizzo del buffer di tastiera.                ;
;                      Primo byte: num max char da leggere pió return.  ;                         
; Uscita:              Secondo byte: riporta il numero di byte          ;
;                                   effettivamente letti, oppure :      ;
;                                    0  =  Nessun char letto            ;
;                                   -1  =  Letto char speciale (-1=0FFh);
;-----------------------------------------------------------------------;
LEGGE_STRINGA   PROC
	PUSH    AX BX SI

	MOV     SI,DX           ; Usa SI come registro indice per il buffer
RICOMINCIA:
	CALL    AGGIORNA_CURSORE_VERO   ; Posiziona il cursore
	MOV     BX,2            ; Pone BX=offset inizio del buffer
	CALL    LEGGE_TASTO     ; Legge un carattere dalla tastiera
	OR      AH,AH           ; E' carattere ASCII esteso?
	JNZ     ESTESO          ; Sç, legge carattere esteso
STRINGA_NON_ESTESA:             ; Carattere esteso ä errore se buffer ä pieno
	CMP     AL,CR           ; Carattere di ritorno carrello (CR)?
	JE      FINE_INPUT      ; Sç, riceve return, input finito
	CMP     AL,BS           ; Carattere BackSpace?
	JNE     NON_BACKSPACE   ; No, non ä premuto backspace
	CALL    BACKSPACE       ; Sç, cancella carattere
	CMP     BL,2            ; Vede se il buffer ä vuoto (primo char)
	JE      RICOMINCIA      ; Sç, puï ancora leggere ASCII esteso
	JMP     LEGGI_PROSSIMO_CHAR     ; No, continua lettura char normali

NON_BACKSPACE:
	CMP     AL,ESCAPE       ; Carattere di cancellazione buffer (Esc)?
	JE      SVUOTA_BUFFER   ; Sç, premuto Esc, allora cancella buffer
	CMP     BL,[SI]         ; Confronta num.char.attuali e num.max.char
	JA      BUFFER_PIENO    ; Se attuali>max il buffer ä pieno
	MOV     [SI+BX],AL      ; Altrimenti salva carattere nel buffer
	INC     BX              ; Punta prossimo carattere libero nel buffer
	PUSH    DX              ; Conserva DX
	MOV     DL,AL           ; Pone il carattere in DL
	CALL    SCRIVE_CHAR     ; Stampa il carattere DL sullo schermo
	POP     DX              ; Ripristina DX
LEGGI_PROSSIMO_CHAR:
	CALL    AGGIORNA_CURSORE_VERO   ; Aggiorna la posizione del cursore
	CALL    LEGGE_TASTO             ; Legge altro char dalla tastiera
	OR      AH,AH                   ; Vede se ä char normale AH=0 o esteso
	JZ      STRINGA_NON_ESTESA      ; Se char ä normale torna su
SEGNALA_ERRORE:                 ; Char ASCIIZ non valido se buffer non ä vuoto
	CALL    BEEP            ; Emette segnale acustico di errore
	
	JMP     SHORT LEGGI_PROSSIMO_CHAR       ; Legge carattere successivo

SVUOTA_BUFFER:  ; Esc svuota buffer e cancella tutti char visualizzati
	PUSH    CX              ; Conserva CX
	MOV     CL,[SI]         ; Pone CX=numero massimo di char nel buffer
	XOR     CH,CH           ; Azzera parte alta del contatore
CICLO_SVUOTA:   
	CALL    BACKSPACE       ; Cancella un singolo carattere dal buffer
	LOOP    CICLO_SVUOTA    ; Ripete per tutti i caratteri del buffer
	POP     CX              ; Ripristina CX
	JMP     RICOMINCIA      ; Se buffer vuoto puï leggere ASCII estesi

BUFFER_PIENO:   ; Se buffer pieno non ä possibile leggere altro char...
	JMP     SHORT SEGNALA_ERRORE  ; allora emette segnale acustico

ESTESO:         ; Se char esteso, lo mette nel buffer e riporta -1 char letti
	MOV     [SI+2],AL       ; Introduce questo carattere nel buffer
	MOV     BL,0FFh         ; Segnala letto char speciale (BL=-1)
	JMP     FINE_LEGGE_STRINGA      ; Salta alla fine

FINE_INPUT:     ;Input terminato, salva conteggio dei char letti
	SUB     BL,2            ; Conteggio dei caratteri letti
FINE_LEGGE_STRINGA:
	MOV     [SI+1],BL       ; Pone numero char letti nel secondo byte
																	
	POP     SI BX AX
	RET
LEGGE_STRINGA   ENDP

;-----------------------------------------------------------------------;
; BACKSPACE cancella un carattere dal buffer e dallo schermo            ;
; (solo se il buffer non ä vuoto, altrimenti non fa niente).            ;
;                                                                       ;
; Ingresso:  DS:[SI+BX]  =  Ultimo carattere nel buffer.                ;
; Uscita:    BX  = Viene aggiornato per puntare correttamente.          ;
;-----------------------------------------------------------------------;
BACKSPACE       PROC
	PUSH    AX DX

	CMP     BX,2            ; Confronta num.char con posiz.primo char
	JE      END_BS          ; Se buffer vuoto non fa niente

	DEC     BX                      ; Rimuove un carattere dal buffer
	CALL    LEGGE_POSIZIONE_CURSORE ; Legge posizione corrente del cursore
	DEC     DL                      ; Si sposta di una colonna a sinistra
	CALL    SPOSTA_CURSORE_XY       ; Sposta il cursore nella nuova posiz.
	PUSH    DX                      ; Salva la nuova posizione
	MOV     DL,20h                  ; Prende il carattere 'spazio'
	CALL    SCRIVE_CHAR             ; Scrive spazio sullo schermo
	POP     DX                      ; Ripristina la posizione
	CALL    SPOSTA_CURSORE_XY       ; Torna sull'ultimo spazio

END_BS: POP     DX AX
	RET
BACKSPACE       ENDP

;-----------------------------------------------------------------------;
; LEGGE_DECIMALE converte la stringa di cifre decimali fornite nel      ;
; buffer di READ_STRING in una word.                                    ;
;                                                                       ;
; Uscita:  AX  =  Stringa decimale convertita in word                   ;
;          CF  =  Impostato se errore, altrimenti azzerato              ;
;-----------------------------------------------------------------------;
LEGGE_DECIMALE  PROC
	PUSH    BX CX DX

	MOV     NUM_CHAR_MAX,6          ; Numero massimo ä di 5 cifre (65535)
	LEA     DX,INPUT_TASTIERA       ; Fa puntare ad INPUT_TASTIERA
	CALL    LEGGE_STRINGA           ; Legge una stringa
	MOV     CL,NUM_CHAR_LETTI       ; Rileva num.char.letti (secondo byte)
	XOR     CH,CH           ; Imposta byte superiore del contatore a 0
	CMP     CL,0    ; Riporta errore se non viene letto alcun carattere
	JLE     CIFRA_DECIMALE_ERRATA   ; Nessun char letto, segnala errore
	XOR     AX,AX                   ; Inizia con numero impostato a 0
	XOR     BX,BX                   ; Comincia dall'inizio della stringa
CONVERTI_CIFRA:
	MOV     DX,10                   ; Prepara moltiplicazione per 10
	MUL     DX                      ; Moltiplica AX per 10
	JC      CIFRA_DECIMALE_ERRATA   ; Ho CF=1 se risult.supera una parola
	MOV     DL,CHARS[BX]            ; Rileva cifra successiva
	SUB     DL,'0'                  ; La converte in un semibyte (4 bit)
	JS      CIFRA_DECIMALE_ERRATA   ; Cifra errata se < 0 (segno neg.)
	CMP     DL,9                    ; Confronta con 9
	JA      CIFRA_DECIMALE_ERRATA   ; Se ä >9 ä cifra decimale errata
	ADD     AX,DX                   ; Corretta, va aggiunta al numero
	INC     BX                      ; Punta al carattere successivo
	LOOP    CONVERTI_CIFRA          ; Preleva cifra successiva
	JMP     FINE_DECIMALE           ; Salta alla fine
CIFRA_DECIMALE_ERRATA:
	STC                             ; Imposta riporto per segnalare errore
FINE_DECIMALE:
	POP     DX CX BX
	RET
LEGGE_DECIMALE  ENDP

;-----------------------------------------------------------------------;
; LEGGE_BYTE legge un singolo char ASCII oppure un hex a 2 cifre        ;
; (serve per la fase di editing, inserico 2 hex oppure un char ASCII).  ;
;                                                                       ;
; Uscita:  AL  =  Codice carattere (se AH diverso da 0)                 ;
;          AH  =  0 se legge char ASCII                                 ;
;                 1 se legge char speciale                              ;
;                -1 se non legge nessun carattere.                      ;
;-----------------------------------------------------------------------;
LEGGE_BYTE      PROC
	PUSH    DX

	MOV     NUM_CHAR_MAX,3                  ; Max 2 char + 1 per invio
	LEA     DX,INPUT_TASTIERA               ; Punta alla destinazione
	CALL    LEGGE_STRINGA                   ; Legge stringa
	CMP     NUM_CHAR_LETTI,1                ; Se ho letto 1 char...
	JE      INPUT_ASCII                     ;       ...deve essere ASCII
	JB      NESSUN_CARATTERE                ; Se non ho letto nessun char
	CMP     BYTE PTR NUM_CHAR_LETTI,0FFh    ; Se num.char letti ä FF...
	JE      TASTO_SPECIALE                  ;       ...ä tasto speciale
INPUT_2_HEX:
	CALL    CONVERTE_STRINGA_MAIUSCOLO      ; Converte i 2 char maiuscolo
	LEA     DX,CHARS                        ; Punta ai caratteri
	CALL    CONVERTE_HEX_TO_BYTE            ; Li converte in un byte
	JC      NESSUN_CARATTERE                ; In caso di errore
	XOR     AH,AH                           ; Ritorna AH=0
	JMP     LETTURA_ESEGUITA                ; Salta alla fine

NESSUN_CARATTERE:
	XOR     AH,AH                           ; Azzera AH
	NOT     AH                              ; Negandolo ho AH=0FFh=-1
	JMP     LETTURA_ESEGUITA                ; Salta alla fine
INPUT_ASCII:
	MOV     AL,CHARS                        ; Punta ai caratteri
	XOR     AH,AH                           ; Ritorna AH=0
	JMP     LETTURA_ESEGUITA                ; Salta alla fine
TASTO_SPECIALE:
	MOV     AL,CHARS[0]                     ; Restituisce AL=char letto
	MOV     AH,1                            ; AH=1 indica char speciale
LETTURA_ESEGUITA:
	POP     DX
	RET
LEGGE_BYTE      ENDP

;-----------------------------------------------------------------------;
; LEGGE_WORD chiede di inserire una stringa di 4 char hex, la converte  ;
; e la pone in BX (ä usata per chiedere la base per la lettura in mem.).;
;                                                                       ;
; Uscita:  BX  =  Word letta                                            ;
;          CF  =  Carry settato in caso di errore, altrimenti azzerato. ;
;-----------------------------------------------------------------------;
LEGGE_WORD      PROC
	PUSH    DX

        CLC                                     ; Pulisco il Carry Flag
	MOV     NUM_CHAR_MAX,5                  ; Max 4 char + 1 per invio
	LEA     DX,INPUT_TASTIERA               ; Punta alla destinazione
	CALL    LEGGE_STRINGA                   ; Legge stringa

        CMP     NUM_CHAR_LETTI,4                ; Se char non sono 4...
        JNE     ERRORE_LEGGE_WORD               ;       ...ignora tutto

	LEA     DX,INPUT_TASTIERA               ; Punta al buffer
	CALL    CONVERTE_STRINGA_MAIUSCOLO      ; Converte 4 char maiuscolo

	LEA     DX,CHARS                        ; Punta alla stringa
	CALL    CONVERTE_HEX_TO_BYTE            ; Converto char 1 e 2
        JC      ERRORE_LEGGE_WORD               ; Errore di conversione
	MOV     BH,AL                           ; Conservo primo byte

	INC     DX                              ; Mi sposto alla seconda...
	INC     DX                              ; ...coppia di caratteri
	CALL    CONVERTE_HEX_TO_BYTE            ; Converto char 3 e 4
        JC      ERRORE_LEGGE_WORD               ; Errore di conversione
	MOV     BL,AL                           ; Conservo secondo byte
        JMP     FINE_LEGGE_WORD                 ; Salta alla fine (no errore)

ERRORE_LEGGE_WORD:
        CALL    BEEP            ; Emette segnale acustico (cancella carry!)
        STC                     ; Setta carry flag per segnalare errore

FINE_LEGGE_WORD:
	POP     DX
	RET
LEGGE_WORD      ENDP

;-----------------------------------------------------------------------;
; CONVERTE_HEX_TO_BYTE converte i due caratteri a DS:DX da esadecimale  ;
; a un byte.                                                            ;
;                                                                       ;
; Ingresso:  DS:DX  =  Indirizzo dei due char del numero esadecimale    ;
; Uscita:  AL  =  Byte                                                  ;
;          CF  =  Impostato in caso di errore, altrimenti azzerato      ;
;-----------------------------------------------------------------------;
CONVERTE_HEX_TO_BYTE     PROC
	PUSH    BX CX

	MOV     BX,DX                   ; Pongo indirizzo in BX
	MOV     AL,[BX]                 ; Prelevo la prima cifra
	CALL    CONVERTE_CIFRA_HEX      ; La converto in un nibble
	JC      HEX_ERRATO      ; Se riporto ä impostato, cifra hex ä errata
	MOV     CX,4                    ; Preparo moltiplicazione
	SHL     AL,CL                   ; Moltiplico per 16
	MOV     AH,AL                   ; Ne conservo una copia

	INC     BX                      ; Mi sposto sulla seconda cifra
	MOV     AL,[BX]                 ; Prelevo la seconda cifra
	CALL    CONVERTE_CIFRA_HEX      ; La converto in un nibble
	JC      HEX_ERRATO      ; Se riporto ä impostato, cifra hex ä errata

	OR      AL,AH                   ; Unisco i due semibyte
	CLC                             ; Azzero riporto per assenza errore
	JMP     FINE_HEX
HEX_ERRATO:
	STC                             ; Imposto riporto per presenza errore
FINE_HEX:
	POP     CX BX
	RET
CONVERTE_HEX_TO_BYTE     ENDP

;-----------------------------------------------------------------------;
; CONVERTE_CIFRA_HEX converte un char hex (ASCII 8 bit) in un nibble (4);
;                                                                       ;
; Ingresso:  AL  =  Carattere da convertire                             ;
; Uscita:  AL  =  Nibble                                                ;
;          DF  =  Impostato in caso di errore, altrimenti azzerato.     ;
;-----------------------------------------------------------------------;
CONVERTE_CIFRA_HEX       PROC
	CMP     AL,'0'          ; Confronto con 0
	JB      CIFRA_ERRATA    ; Se ä inferiore ä cifra errata
	CMP     AL,'9'          ; Confronto con 9 
	JA      PROVA_HEX       ; Se ä superiore potrebbe essere cifra hex
	SUB     AL,'0'          ; OK ä decimale, converto in nibble
	CLC                     ; Azzero il riporto, nessun errore
	RET
PROVA_HEX:
	CMP     AL,'A'          ; Confronto con A
	JB      CIFRA_ERRATA    ; Se ä inferiore non ä hex
	CMP     AL,'F'          ; Confronto con F
	JA      CIFRA_ERRATA    ; Se ä superiore non ä hex
	SUB     AL,'A'-10       ; OK ä esadecimale, converto in nibble
	CLC                     ; Azzero il riporto, nessun errore
	RET
CIFRA_ERRATA:
	STC                     ; Imposto il riporto, errore
	RET
CONVERTE_CIFRA_HEX       ENDP
