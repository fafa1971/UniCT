;-----------------------------------------------------------------------;
; 		     	  the Fab Monitor				;
;	     (C) 1996 by Fabio Bruno & Fabrizio Fazzino			;
;									;
;	File: INSTALL.ASM  (solo versione ADVANCED)			;
;-----------------------------------------------------------------------;

;-----------------------------------------------------------------------;
; Questa procedura INSTALL_CHECK serve ad evitare che il programma venga;
; installato pi— di una volta in memoria. Se tento di lanciare il prog. ;
; per la seconda volta, avr• due copie del programma in memoria, quello ;
; residente e quello che sta girando, per• questa procedura lanciata per;
; prima si accorge della presenza della prima copia e termina il codice ;
; con la funzione AH=4Ch di INT 21h.                                    ;
; La ricerca avviene confrontando i primi 16 byte di tutti i possibili  ;
; segmenti in memoria, a partire da 0000h fino a CS che Š il primo      ;
; segmento libero in cui Š stato piazzato il programma, con i primi     ;
; 16 byte del codice, se si ha l'uguaglianza Š molto probabile che una  ;
; copia sia gi… in memoria. La prima word Š invertita (NOT'ed) per      ;
; evitare che il programma trovi se stesso, e per evitare che ci siano  ;
; pi— "immagini" del programma in memoria che, pur non avendo realmente ;
; memoria allocata loro, non siano stati fisicamente rimosse da un altro;
; programma sovrapposto e quindi ingannino la procedura.                ;
;                                                                       ;
;  Ingresso:  CS = Code Segment corrente                                ;
;  Uscita: Carry Flag = 1 = Non trovato                                 ;
;      	   Carry Flag = 0 = Trovato                                     ;
;          ES = Seg. in cui il progr. Š installato o CS se non trovato  ;
;-----------------------------------------------------------------------;
INSTALL_CHECK   PROC
	PUSH    BX AX SI DI CX

	NOT     WORD PTR CS:START       ; Inverto la prima word
	MOV     BX,0000h                ; Inizio la ricerca da zero
	MOV     AX,CS                   ; Conservo CS in AX

Loop1:
	INC     BX                      ; Vado al prossimo segmento
	MOV     ES,BX                   ; ES Š il seg. che sto analizzando
	CMP     AX,BX                   ; Confronto CS ed ES
	JE      NO_COPIA                ; Non appena CS=ES posso dire che
					;  non ho una copia gi… in memoria
	MOV     SI,OFFSET START         ; Punto SI all'inizio del codice
	MOV     DI,SI                   ; Faccio lo stesso con DI
	MOV     CX,16                   ; Confronta 16 bytes
	REPE    CMPSB                   ; Ripete, finchŠ uguale, il confr. tra
                                        ;  i byte a DS:DI e ES:SI (inc DI ed SI)
        JNE     Loop1                   ; Se diversi devo confrontare il succ. seg.
        CLC                             ; Se uguali metto a zero Carry flag
USCITA:        
        POP     CX DI SI AX BX
        RET
        
NO_COPIA:
        STC                             ; Non presente in mem.,setto Carry flag
        JMP     SHORT USCITA
        
INSTALL_CHECK   ENDP

;-----------------------------------------------------------------------;
; INSTALLA Š la procedura che installa il programma residente           ;
; sostituendo i gestori di interruzione 8h,9h,13h e 28h con i nuovi     ;
; definiti in RESIDENT.ASM						;
;-----------------------------------------------------------------------;
INSTALLA        PROC
	CALL    INSTALL_CHECK           ; Verifico se gi… installato
	JC      PUOI_INSTALLARE         ; Salto all'installazione
	PRINTMAC Gia_in_memoria         ; Se no scrivo messaggio...
	MOV     AH,4Ch
        INT     21h                     ; ...ed esco dal programma
PUOI_INSTALLARE:            
        CLC                             ; Azzero Carry Flag
	CLI                             ; Disabilito le interruzioni

        MOV     SEG_INIZ,ES             ; Memorizzo il segmento del programma
        MOV     BX,ES:[002Ch]           ; Indirizzo d'ambiente
        MOV     AMBIENTE,BX             ; Memorizzo l'indirizzo dell'ambiente
                   
        MOV     ES,BX                   ; Indirizzo d'ambiente
        MOV     AH,49h                  ; Funzione per liberare memoria
        INT     21h                     ; Libero la memoria assegnata al
					;  blocco ambiente del programma

        MOV     AX,3508h                ; BIOS timer
        INT     21h                     ; Leggo ind. del vett. d'int. originale
        MOV     OldInt8,BX              ; Lo memorizzo, offset...
        MOV     OldInt8[2],ES           ; ..e segment 
        MOV     AX,2508h                ; Scrivo il nuovo ind. nel vett. d'int.
        LEA     DX,NewInt8              ; Offset. DS punta al codice
        INT     21h                     ; Nuovo gestore
                                      
        MOV     AX,3509h                ; BIOS kbd
        INT     21h
        MOV     OldInt9,BX
	MOV     OldInt9[2],ES
        MOV     AX,2509h
        LEA     DX,NewInt9
        INT     21h                     ; Nuovo gestore

        MOV     AX,3513h                ; BIOS I/O
        INT     21h
        MOV     OldInt13,BX
        MOV     OldInt13[2],ES
        MOV     AX,2513h
        LEA     DX,NewInt13
        INT     21h                     ; Nuovo gestore

	MOV     AX,3528h                ; DOS Idle Int.
        INT     21h
        MOV     OldInt28,BX
        MOV     OldInt28[2],ES
        MOV     AX,2528h
        LEA     DX,NewInt28
        INT     21h                     ; Nuovo gestore

        MOV     AH,34h                  ; Funzione per leggere ind. di INDOS f.
        INT     21h                     ; Restituisce in ES:BX INDOS flag
        MOV     IndosPtrOfs,BX          ; Memorizzo offset...
        MOV     IndosPtrSeg,ES          ; ..e segment dell'indirizzo

	STI                             ; Riabilito le interruzioni

        MOV     DX,(FINERESIDENTE-START+100h+15) SHR 4; Nøpar. da lasciare res.
        MOV     AH,31h                  ; Funzione per rendere residente il prg.
        INT     21h                     ; TSR !!!
INSTALLA        ENDP
