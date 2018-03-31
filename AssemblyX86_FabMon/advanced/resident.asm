;-----------------------------------------------------------------------;
; 		     	  the Fab Monitor				;
;	     (C) 1996 by Fabio Bruno & Fabrizio Fazzino			;
;									;
;	File: RESIDENT.ASM  (solo versione ADVANCED)			;
;-----------------------------------------------------------------------;

	S EQU 32        ; Spazio
	O EQU 196       ; Tratto orizzontale della cornice
        V EQU 179       ; Tratto verticale della cornice
        ASX EQU 218     ; Angolo in alto a sinistra
        ADX EQU 191     ; Angolo in alto a destra
        BSX EQU 192     ; Angolo in basso a sinistra
        BDX EQU 217     ; Angolo in basso a destra

FALSE EQU 0          ; = 00000000b
TRUE  EQU 0FFh       ; = 11111111b = -1

MODOVIDEO       DB      ?     ; Modo video del programma interrotto

SEG_INIZ        DW      ?     ; Segmento in cui si trova il nostro programma
AMBIENTE        DW      ?     ; Indirizzo d'ambiente del nostro programma

ATTIVA          DB      FALSE ; Messo a true da int 09h, a false da INIZIALIZZA
ATTIVATO        DB      FALSE ; Messo a true da INIZIALIZZA, a false da RIPRISTINA

NASCOSTO        DB      FALSE ; Invertito da int 09h

Int13           DB      0     ; InDiscoFlag, se > 1 accesso al disco in corso

OldStackSize    DW      ?     ; Dimensione dello stack del progr. interrotto

IndosPtrOfs     DW      ?     ; Indirizzo dell'offset di InDos flag
IndosPtrSeg     DW      ?     ; Indirizzo del segment di InDos flag

OldInt1B        LABEL WORD    ; Gestore del Ctrl-C
OldInt1B_addr   DD      ?

OldInt23        LABEL WORD    ; Gestore del Ctrl-Break
OldInt23_addr   DD      ?

OldInt24        LABEL WORD    ; Gestore errori critici
OldInt24_addr   DD      ?

OldPsp          DW      ?     ; Indirizzo del PSP
OldDtaOfs       DW      ?     ; Indirizzo del DTA, Offset...
OldDtaSeg       DW      ?     ; ...e Segment

OldSP           DW      ?     ; Stack Pointer del progr. interrotto
OldSS           DW      ?     ; Stack Segment del progr. interrotto

Cursx           DB      ?     ; Colonna del cursore
Cursy           DB      ?     ; Riga del cursore
CursHigh        DB      ?     ; Linea di scansione iniziale del cursore
CursLow         DB      ?     ; Linea di scansione finale del cursore
ScreenFileName  DB      'c:\screen.sav',0 ; File su cui salvo lo schermo

OldInt8         LABEL WORD    ; Interrupt del clock
OldInt8_addr    DD      ?

OldInt9         LABEL WORD    ; Interrupt della tastiera
OldInt9_addr    DD      ?

OldInt13        LABEL WORD    ; Interrupt del disco
OldInt13_addr   DD      ?

OldInt28        LABEL WORD    ; DOS idle interrupt
OldInt28_addr   DD      ?


        TITOLO DB ASX,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O ; 20 char
               DB  O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O
	       DB  O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O
               DB  O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,ADX

               DB V,'  ',ASX,O,O,O,O,O,O,O,O,O,ADX      ; 14 char
               DB '     (C)1996 by Fabio Bruno'         ; 27 char
               DB ' & Fabrizio Fazzino     '            ; 24 char
               DB ASX,O,O,O,O,O,O,O,O,O,O,ADX,'  ',V    ; 15 char

               DB V,'  ',V,' the Fab ',V                ; 14 char
               DB '                ',ASX,' Alt-F1: '    ; 26 char
               DB ' Monitor                 '           ; 25 char
               DB V,'  /  /19  ',V,'  ',V               ; 15 char                

	       DB V,'  ',V,' Monitor ',V                ; 14 char
               DB '                ',195,' Alt-F2: '    ; 26 char
               DB ' Mostra/nasconde         '           ; 25 char
               DB V,'   :  :   ',V,'  ',V               ; 15 char

               DB V,'  ',BSX,O,O,O,O,O,O,O,O,O,BDX      ; 14 char
               DB '                ',BSX,' Alt-F3: '    ; 26 char
               DB ' Disinstalla             '           ; 25 char
               DB BSX,O,O,O,O,O,O,O,O,O,O,BDX,'  ',V    ; 15 char

               DB BSX,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O ; 20 char
               DB  O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O
               DB  O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O
	       DB  O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,BDX,'$'


QUADRO  PROC
        PUSH    AX BX CX DX ES SI
                                             
        MOV     AH,3            ; Funzione BIOS per leggere posiz.cursore
        XOR     BH,BH           ; Pagina 0
        INT     10h             ; Legge pos.cursore in (DH,DL)
        CMP     DH,6            ; Vede se sono dentro il riquadro
        JG      DISEGNA_QUADRO  ; Se sono fuori passo avanti
        MOV     AH,2            ; Funzione BIOS per posizionare cursore
        MOV     DH,6            ; Nuova riga
	INT     10h             ; Posiziona il cursore oltre il riquadro
DISEGNA_QUADRO:                
        MOV     AX,0B800h       ; Pone il segmento degli attributi...
        MOV     ES,AX           ;               ...in ES
        MOV     SI,0000h        ; Inizio dell'area da scandire
        MOV     CX,480          ; Numero di caratteri da colorare 6*80
        MOV     BX,0000h        ; Punta all'inizio della stringa
ATTRIB_LOOP:                    
        MOV     AL,TITOLO[BX]
        MOV     BYTE PTR ES:[SI],AL
        INC     BX
        INC     SI
        MOV     BYTE PTR ES:[SI],78d   ; Colora con attributo 78
	INC     SI
        LOOP    ATTRIB_LOOP
        
        POP     SI ES DX CX BX AX
        RET
QUADRO  ENDP


WRITE_CLOCK     PROC
        ; Stampa il carattere AL nella posizione (BH,BL) della pagina 0
        PUSH    AX BX CX DX ES SI
        MOV     DL,AL           ; Conservo il carattere AL da stampare

	MOV     AL,BH           ; Numero di riga
        MOV     CH,80d          ; Caratteri per riga
        MUL     CH              ; AX=riga*80
        ADD     AL,BL           ; Sommo ad AX il numero di colonna
        ADC     AH,0000h        ; Aggiungo ad AX l'eventuale riporto
        SHL     AX,1            ; Moltiplico per 2

        MOV     SI,AX           ; Spiazzamento nella memoria video
        MOV     AX,0B800h       ; Base della memoria video...
        MOV     ES,AX           ;               ...da porre in ES

        MOV     AL,DL           ; Ripristino il carattere AL da stampare
        MOV     BYTE PTR ES:[SI],AL

        POP     SI ES DX CX BX AX

        RET
WRITE_CLOCK     ENDP


CLOCK   PROC
        PUSH    AX BX CX DX ES SI

        ;**** ANNO, MESE E GIORNO ****

        MOV     AH,04h          ; Funzione che scrive la data in (CX,DX)
	INT     1Ah             ; INT del clock

        ; ANNO
        MOV     AL,CL           ; Sposta seconde cifre dell'anno (CL) in AL
        SHR     AL,4            ; Sposta a destra di un nibble (isola 3^ cifra)
        ADD     AL,30h          ; Converte in ASCII
        MOV     BX,024Ah        ; Posizione cursore
        CALL    WRITE_CLOCK     ; Scrive la terza cifra dell'anno

        MOV     AL,CL           ; Rimette seconde cifre dell'anno (CL) in AL
        AND     AL,0Fh          ; Azzera la parte sinistra (isola 4^ cifra)
        ADD     AL,30h          ; Converte in ASCII
        MOV     BX,024Bh        ; Posizione cursore
	CALL    WRITE_CLOCK     ; Scrive la quarta cifra dell'anno

        ; MESE
        MOV     AL,DH           ; Sposta 2 cifre del mese (DH) in AL
        SHR     AL,4            ; Sposta a destra di un nibble (isola 1^ cifra)
        ADD     AL,30h          ; Converte in ASCII
        MOV     BX,0245h        ; Posizione cursore
        CALL    WRITE_CLOCK     ; Scrive la prima cifra del mese

        MOV     AL,DH           ; Rimette il mese (DH) in AL
        AND     AL,0Fh          ; Azzera la parte sinistra (isola 2^ cifra)
        ADD     AL,30h          ; Converte in ASCII
        MOV     BX,0246h        ; Posizione cursore
	CALL    WRITE_CLOCK     ; Scrive la seconda cifra del mese

        ; GIORNO
        MOV     AL,DL           ; Sposta 2 cifre del giorno (DL) in AL
        SHR     AL,4            ; Sposta a destra di un nibble (isola 1^ cifra)
        ADD     AL,30h          ; Converte in ASCII
        MOV     BX,0242h        ; Posizione cursore
        CALL    WRITE_CLOCK     ; Scrive la prima cifra del giorno

        MOV     AL,DL           ; Rimette il giorno (DL) in AL
        AND     AL,0Fh          ; Azzera la parte sinistra (isola quarta cifra)
        ADD     AL,30h          ; Converte in ASCII
        MOV     BX,0243h        ; Posizione cursore
	CALL    WRITE_CLOCK     ; Scrive la seconda cifra del giorno

        ;**** ORE, MINUTI E SECONDI ****

        MOV     AH,02h          ; Funzione che scrive l'orario in (CX,DH)
        INT     1Ah             ; INT del clock

        ; ORE
        MOV     AL,CH           ; Sposta 2 cifre delle ore (CH) in AL
        SHR     AL,4            ; Sposta a destra di un nibble (isola 1^ cifra)
        ADD     AL,30h          ; Converte in ASCII
        MOV     BX,0343h        ; Posizione cursore
        CALL    WRITE_CLOCK     ; Scrive la prima cifra delle ore

        MOV     AL,CH           ; Rimette le ore (CH) in AL
        AND     AL,0Fh          ; Azzera la parte sinistra (isola 2^ cifra)
        ADD     AL,30h          ; Converte in ASCII
        MOV     BX,0344h        ; Posizione cursore
        CALL    WRITE_CLOCK     ; Scrive la seconda cifra delle ore

        ; MINUTI
        MOV     AL,CL           ; Sposta 2 cifre dei minuti (CL) in AL
        SHR     AL,4            ; Sposta a destra di un nibble (isola 3^ cifra)
        ADD     AL,30h          ; Converte in ASCII
        MOV     BX,0346h        ; Posizione cursore
        CALL    WRITE_CLOCK     ; Scrive la prima cifra dei minuti

        MOV     AL,CL           ; Rimette i minuti (CL) in AL
        AND     AL,0Fh          ; Azzera la parte sinistra (isola 4^ cifra)
        ADD     AL,30h          ; Converte in ASCII
        MOV     BX,0347h        ; Posizione cursore
        CALL    WRITE_CLOCK     ; Scrive la seconda cifra dei minuti

        ; SECONDI
        MOV     AL,DH           ; Sposta 2 cifre dei secondi (DH) in AL
        SHR     AL,4            ; Sposta a destra di un nibble (isola 1^ cifra)
        ADD     AL,30h          ; Converte in ASCII
        MOV     BX,0349h        ; Posizione cursore
        CALL    WRITE_CLOCK     ; Scrive la prima cifra dei secondi

        MOV     AL,DH           ; Rimette i secondi (DH) in AL
        AND     AL,0Fh          ; Azzera la parte sinistra (isola 2^ cifra)
        ADD     AL,30h          ; Converte in ASCII
        MOV     BX,034Ah        ; Posizione cursore
        CALL    WRITE_CLOCK     ; Scrive la seconda cifra dei secondi

        POP     SI ES DX CX BX AX

        RET
CLOCK   ENDP


;------------------------------------------------------------------------------
; Gestione delle Interruzioni : 8h, 9h, 13h, 28h 
;------------------------------------------------------------------------------

NewInt8 PROC
                                                          
        PUSHF                   ; Sar… estratto dallo stack dall'iret del
                                ;  vecchio gestore di interrupt
        CALL    CS:OldInt8_addr ; Chiamata al vecchio gestore di interrupt
                   
        CLI

        CMP     CS:ATTIVATO,TRUE  ; Se il monitor Š gi… attivato....
	JE      VAI_IRET_8        ; ..salta alla fine
                   
        CMP     CS:NASCOSTO,TRUE  ; Se questa variabile Š settata...                   
        JE      QUI               ; ..non visualizzare la mascherina

        STI                     ; Abilita le interruzioni
        CALL    QUADRO          ; Visualizza la mascherina
        CALL    CLOCK           ; Visualizza l'orologio
        CLI                     ; Disabilita le interruzioni
QUI:       
        PUSH    AX              ; Salvo AX
        MOV     AX,1            ; Pongo AX=1 per Check
        CALL    Check           ; Controlla se Š possibile l'attivazione
	POP     AX              ; Ripristino AX
        JC      VAI_IRET_8      ; Se impossibile l'attivazione salta a IRET
        CALL    PRINCIPALE      ; Se no lancia il programma
VAI_IRET_8:       
        IRET
NewInt8 ENDP

NewInt9 PROC 
        CLI                       ; Disabilita le interruzioni
        PUSH    AX BX DX DS ES
                
        PUSHF
        CALL    CS:OldInt9_addr   ; Chiama il vecchio gestore di int.

        CLI
        
        CMP     CS:ATTIVATO,TRUE  ; Se il monitor Š gi… attivato...
        JE      EXIT              ; ..salta alla fine

        ASSUME  DS:ROM_BIOS_DATA  ; Setto DS al segmento dati del BIOS..
        MOV     BX,ROM_BIOS_DATA  ; ..che mi sono definito
        MOV     DS,BX
                
        MOV     BX,CODA           ; Punta alla coda del buffer di tastiera
        CMP     BX,TESTA          ; Controllo se il buffer Š vuoto
        JE      EXIT              ; Ed in questo caso esce
	SUB     BX,2              ; Punta al car. appena letto
        CMP     BX,OFFSET BUFFER  ; Oltre la parte bassa del buffer?
        JAE     NON_ESCE          ; No
        MOV     BX,OFFSET BUFFER_END ; Si, si sposta nella parte alta
        SUB     BX,2              ; Punta al car. appena letto
NON_ESCE:
        MOV     DX,[BX]         ; Pongo il carattere in DX
        CMP     DX,6800h        ; E' Alt-F1 ?
        JE      F1              ; Si, salta a F1
        CMP     DX,6900h        ; E' Alt-F2 ?
        JE      F2              ; Si, salta a F2
        CMP     DX,6A00h        ; E' Alt-F3 ?
        JE      F3              ; Si, salta a F3
	JMP     EXIT            ; Se nessuno di questi esci
F1:        
        MOV     CODA,BX         ; Rimuovi Alt-F1
        MOV     CS:ATTIVA,TRUE  ; Metti a true il flag di attivazione
        JMP     EXIT            ; Salta alla fine
        
; Punto d'uscita, Š in mezzo alla procedura per permettere salti near
EXIT:                           
        CLC                     ; Azzera Carry flag
        POP     ES DS DX BX AX
        STI                     ; Riabilita le interruzioni
        IRET                    ; Ritorna dall'iterrupt
        
F2:                             ; Mostra/Nasconde la mascherina
        MOV     CODA,BX         ; Rimuovi Alt-F2
        NOT     CS:NASCOSTO     ; Inverte la var. NASCOSTO          
        JMP     EXIT            ; Salta alla fine

F3:                             ; Se si pu• disinstalla il programma
        MOV     CODA,BX         ; Rimuovi Alt-F3
                
        ; Verifico che nessuno punti alle mie routines
                
        MOV     BX,CS:SEG_INIZ
        MOV     ES,BX           ; ES=Segmento del programma
        MOV     AL,08h          ; AL=Interrupt da controllare
	CALL    Check_inst      ; Setta Carry se qualcuno punta alla mia routine
        JC      EXIT            ; Se non posso disinstallarlo, esco
                
        MOV     AL,09h          ; Altro interrupt da controllare
        CALL    Check_inst
        JC      EXIT
                
        MOV     AL,13h          ; Altro interrupt da controllare
        CALL    Check_inst
        JC      EXIT
                
        MOV     AL,28h          ; Altro interrupt da controllare
        CALL    Check_inst
	JC      EXIT
                
        POP     ES DS DX BX AX
        JMP     DISINSTALLA     ; Salta a disinstalla
NewInt9 ENDP

NewInt13        PROC
        INC     BYTE PTR CS:int13 ; Incrementa il nostro InDiscoFlag
                   
        PUSHF 
        CALL    CS:OldInt13_addr  ; Chiama il vecchio gestore
                   
        PUSHF                     ; Salvo i flag
	DEC     BYTE PTR CS:int13 ; Decrementa InDiscoFlag
        POPF                      ; Ripristino i flag

        RETF 2                    ; Estrae IP e CS e non F
NewInt13        ENDP


NewInt28        PROC
        PUSHF 
        CALL    CS:OldInt28_addr  ; Chiamo il vecchio gestore

        CLI 

	PUSH    AX                ; Salvo AX
        MOV     AX,0    ; Per segnalare che sto chiamando la proc. da int28h
                        ; (in questo caso non ho probl.di InDos F.)
        CALL    Check             ; Controlla se Š possibile l'attivazione
        POP     AX                ; Ripristino AX
        JC      VAI_IRET_28       ; Se impossibile l'attivazione salta a IRET
                   
        CALL    PRINCIPALE        ; Se no lancia il programma
VAI_IRET_28:    
        IRET                      ; Ritorno dall'interrupt
NewInt28        ENDP

;------------------------------------------------------------------------------
; Check: Mette il carry a 1 se impossibile attivare il monitor.
;------------------------------------------------------------------------------
Check   PROC 
        CMP     CS:ATTIVATO,TRUE ; E' gi… attivato ?
        JE      IMPOSSIBILE       
                   
        CMP     CS:ATTIVA,TRUE   ; Posso attivarlo (Alt-F1) ?
        JNE     IMPOSSIBILE

        CMP     BYTE PTR CS:Int13,0 ; Non ci sono interruzioni disco in corso?
        JNE     IMPOSSIBILE

        CMP     AX,0             ; Per vedere se arrivo da int 28h
	JE      TUTTO_OK         ; In questo caso non importa InDos flag
        PUSH    ES
        PUSH    BX
        MOV     BX,CS:IndosPtrOfs   ; BX=Offset di InDos flag
        MOV     ES,CS:IndosPtrSeg   ; ES=Segment di InDos flag
        CMP     BYTE PTR ES:[BX],0  ; InDos flag vale 0 ?
        POP     BX
        POP     ES
        JNE     IMPOSSIBILE

TUTTO_OK:                           ; Posso attivarlo
        CLC                         ; Azzero Carry flag
        RET                         ; Ritorno dalla procedura

IMPOSSIBILE:                        ; Non posso attivarlo
        STC                         ; Setto Carry flag
        RET                         ; Ritorno dalla prcedura
Check   ENDP

;------------------------------------------------------------------------------
; PRINCIPALE: salva lo stack e i registri, 
; chiama INIZIALIZZA,Main e RIPRISTINA
;------------------------------------------------------------------------------
PRINCIPALE      PROC 
        MOV     CS:ATTIVATO,TRUE  ; Il programma Š gi… attivo
        MOV     CS:ATTIVA,FALSE ; Per la prossima volta

        MOV     CS:OldSP,SP     ; Salva Stack Pointer
        MOV     CS:OldSS,SS     ; Salva Stack Segment
                                                    
        PUSH    CS
        POP     SS              ; Lo stack Š alla fine del prg nel nostro seg
        MOV     SP,(OFFSET MIO_STACK) + SIZEOFSTACK

        PUSH    AX BX CX DX SI DI BP DS ES ; Salvo tutti i registri

        ; Copia dello stack corrente
        MOV     DS,CS:OldSS     ; DS=Vecchio Stack Segment
        MOV     SI,CS:OldSP     ; Si=Vecchio Stack Pointer
	XOR     CX,CX           ; Azzero CX
        CLD                     ; Azzero Direction flag (cos SI sar… inc.)
                
SALVA_STACK:        
        CMP     SI,0FFFEh       ; Limite max dello stack, fine del segmento
        JE      STACK_SALVATO   
        LODSW                   ; Carica la word in DS:SI
        PUSH    AX              ; Push sul nostro stack
        INC     CX
        CMP     CX,1024         ; Ho caricato 1024 word ?
        JE      STACK_SALVATO   ; Si, salta a STACK_SALVATO
        JMP     SALVA_STACK     ; No, salta a SALVA_STACK

STACK_SALVATO:
        PUSH    CS
        POP     DS              ; Setto DS al segmento del codice
        MOV     OldStackSize,CX ; Salvo la dimensine dello stack

        PUSH    AX
        PUSH    BX              ; Sporcato da f.15 di int 10h
                   
        MOV     AH,15           ; Funzione 15 del BIOS
        INT     10h             ; Restituisce modo video corrente in AL
        MOV     CS:MODOVIDEO,AL ; Conservo modo video interrotto
        
        POP     BX              ; Ripristino BX
	POP     AX

        CALL    INIZIALIZZA     ; Setta DTA, PSP e salva schermo

        STI
        CALL    Main            ; Nostro programma
        CLI

        CALL    RIPRISTINA      ; Ripristina le interruzioni, in uscita DS=CS

        MOV     CX,OldStackSize ; Dimensione dello stack del pr. interrotto

        OR      CX,CX           ; Se CX=0 viene settato Zero flag...
	JZ      RIPRISTINA_REG  ; ..in tal caso non ho stack da ripristinare

        MOV     ES,OldSS        ; Segmento dello stack
        MOV     DI,OldSP        ; Offset dello stack
        ADD     DI,CX           ; Due volte perchŠ DI punta al byte
        ADD     DI,CX           ; Mi posiziono sul fondo dello stack
        SUB     DI,2            ; Punto la prima locazione
        STD                     ; Setto Direction flag (DI verr… decr.)

RIPRISTINA_STACK:         
        POP     AX              ; Estraggo una word
        STOSW                   ; Immagazzino la word in ES:DI (DI decr. di 2)
        LOOP    RIPRISTINA_STACK  ; Ciclo fino a che CX=0

RIPRISTINA_REG:        
        POP     ES DS BP DI SI DX CX BX AX

        MOV     SP,CS:OldSP     ; Ripristino SP
        MOV     SS,CS:OldSS     ; Ripristino SS
        MOV     CS:ATTIVATO,FALSE ; Pongo a false la var. di attivazione

        RET                   
PRINCIPALE      ENDP

; ------------------------------------------------------------------------------
; INIZIALIZZA e RIPRISTINA (agganciano int 1B,23,24)
; ------------------------------------------------------------------------------

INIZIALIZZA     PROC ; In ingresso DS=CS, vedi CheckReg (si Š sotto CLI)

        MOV     AX,351Bh        ; Gestore di Ctrl-C
        INT     21h             ; Ne leggo l'indirizzo
        MOV     OldInt1B,BX     ; Memorizzo Offset..
        MOV     OldInt1B[2],ES  ; ..e Segment
        MOV     AX,251Bh        ; Setta il nuovo indirizzo del gestore
        MOV     DX,OFFSET NewInt1B  ; Nostro gestore
        INT     21h 

        MOV     AX,3523h        ; Gestore di Ctrl-Break
	INT     21h             ; Ne leggo l'indirizzo
        MOV     OldInt23,BX     ; Memorizzo Offset..
        MOV     OldInt23[2],ES  ; ..e Segment
        MOV     AX,2523h        ; Setta il nuovo indirizzo del gestore
        MOV     DX,OFFSET NewInt23  ; Nostro gestore
        INT     21h 

        MOV     AX,3524h        ; Gestore errori critici
        INT     21h             ; Ne leggo l'indirizzo
        MOV     OldInt24,BX     ; Memorizzo Offset..
        MOV     OldInt24[2],ES  ; ..e Segment
        MOV     AX,2524h        ; Setta il nuovo indirizzo del gestore
        MOV     DX,OFFSET NewInt24  ; Nostro gestore
	INT     21h

        MOV     AH,2Fh          ; Legge l'indirizzo del DTA
        INT     21h
        MOV     OldDtaOfs,BX    ; Memorizza Offset..
        MOV     OldDtaSeg,ES    ; ..e Segment

        MOV     DX,80h          ; 100h/2d=128d
        MOV     AH,1Ah
        INT     21h             ; Setta ind. del DTA al centro del mio PSP

        MOV     AH,51h          ; Legge l'indirizzo del PSP
        INT     21h
	MOV     OldPsp,BX       ; Salva PSP

        MOV     AH,50h          ; Setta l'indirizzo del PSP
        MOV     BX,DS           ; Debutto del nostro PSP
        INT     21h             

        CMP     CS:MODOVIDEO,3
        JNE     QUA1            ; Se non 80x25 a colori salta avanti
        
        ; Salva schermo
	MOV     AH,3            ; Servizio del BIOS
        XOR     BH,BH           ; Pagina 0
        INT     10h             ; Acquisisce posizione e aspetto del cursore
	MOV     Cursx,DL        ; Colonna
        MOV     Cursy,DH        ; Riga
        MOV     CursHigh,CH
        MOV     CursLow,CL      ; Spessore
        
        MOV     AH,3Ch          ; F. DOS per creazione file
        MOV     CX,0022h        ; Attributi: Nascosto + Archivio
        MOV     DX,OFFSET ScreenFileName ; Nome del file da creare
        INT     21h             ; Crea il file (c:\screen.sav)
        MOV     BX,AX           ; Gestore del file (serve a f. 40h)

        MOV     AH,40h          ; F. DOS per scrivere su file
        MOV     CX,80*25*2      ; Numero byte da leggere
	MOV     DX,0B800h       ; Indirizzo dal quale leggere
        MOV     DS,DX           ; Segmento (B800h)
        XOR     DX,DX           ; Offset (0000h)
        INT     21h             ; Scrive lo schermo su file

        MOV     AH,3Eh
        INT     21h             ; Chiude il file

        CMP     CS:MODOVIDEO,3
        JE      QUA2            ; Se 80x25 a colori salta avanti

QUA1:        
        PUSH    AX

        MOV     AH,0            ; F. BIOS per settare un modo video
        MOV     AL,3            ; Setto il modo video 80x25 a colori
        INT     10h
                   
        POP     AX
                   
QUA2:
        PUSH    CS
        POP     DS              ; CS=DS

        RETN
INIZIALIZZA     ENDP 


RIPRISTINA      PROC            ; Si Š sotto CLI 
        MOV     DX,WORD PTR CS:OldInt1B
        MOV     DS,WORD PTR CS:OldInt1B[2]
        MOV     AX,251Bh
        INT     21h             ; Ripristino il gestore del Ctrl-C

        MOV     DX,WORD PTR CS:OldInt23
        MOV     DS,WORD PTR CS:OldInt23[2]
	MOV     AX,2523h
        INT     21h             ; Ripristino il gestore del Ctrl-Break

	MOV     DX,WORD PTR CS:OldInt24
        MOV     DS,WORD PTR CS:OldInt24[2]
        MOV     AX,2524h
        INT     21h             ; Ripristino il gestore degli errori critici

        MOV     DX,WORD PTR CS:OldDtaOfs ; Offset del vecchio DTA
        MOV     DS,WORD PTR CS:OldDtaSeg ; Segment      
        MOV     AH,1Ah                   ; F. DOS per settare il DTA
        INT     21h 

	PUSH    CS
        POP     DS

	MOV     BX,OldPsp       ; Offset del vecchio PSP
        MOV     AH,50h          ; F. DOS per settare il PSP
        INT     21h 

        ; Ripristina lo schermo
        CMP     CS:MODOVIDEO,3  ; 80x25 a colori
        JE      QUA3            ; Se il modo video Š questo salta avanti
        
        PUSH    AX
        
	MOV     AH,0            ; F. DOS per settare un modo video
        MOV     AL,CS:MODOVIDEO ; Ripristina quello interrotto
        INT     10h

        POP     AX
                   
QUA3:
        MOV     AH,2            ; F. BIOS per fissare posizione cursore
        XOR     BX,BX           ; Pagina 0
        MOV     DH,Cursy        ; Riga
        MOV     DL,Cursx        ; Colonna
        INT     10h             ; Ripristina posizione cursore

	MOV     AH,1            ; F. BIOS per fissare dimensione cursore
        MOV     CH,CursHigh     ; Linea scansione iniziale
        MOV     CL,CursLow      ; Linea scansione finale
	INT     10h             ; Ripristina dimensione cursore

        MOV     AH,3Dh          ; F. DOS per aprire un file
        XOR     AL,AL           ; AL=0 apertura in lettura
        MOV     DX,OFFSET ScreenFileName ; File da aprire
        INT     21h             ; Apre il file
        MOV     BX,AX           ; Gestore del file

        MOV     AH,3Fh          ; F. DOS per leggere da un file
        MOV     CX,80*25*2      ; Numero di byte da leggere
	MOV     DX,0B800h       ; Indirizzo del buffer da cui leggere
        MOV     DS,DX           ; Segment (B800h)
        XOR     DX,DX           ; Offset (0000h)
	INT     21h             ; Ripristina lo schermo

        MOV     AH,3Eh          ; F. DOS per chiudere un gestore di file
        INT     21h 

        PUSH    CS
        POP     DS              ; DS=CS
 
        MOV     AH,41h          ; F. DOS per cancellare un file
        MOV     DX,OFFSET ScreenFileName ; Nome del file da cancellare
	INT     21h             ; Cancello il file

	RETN
RIPRISTINA      ENDP

;-----------------------------------------------------------------------;
; Procedura che controlla se qualche altro gestore di interrupt punta	;
; al nostro prima di rimuoverlo. AL Š l'interrupt da controllare ed ES  ;
; Š il segmento del nostro programma. Nel caso in cui vi sia un altro   ;
; interrupt che punti al nostro il Carry Flag verr… settato.            ;
;                                                                       ;
; Ingresso:  AL = interrupt              				;
;            ES = segmento                                              ;
; Uscita:    Carry = 1 = segmenti diversi                               ;
;            Carry = 0 = segmenti uguali                                ;
; Cambiamenti:  AX                                                      ;
;-----------------------------------------------------------------------;
CHECK_INST      PROC
	CLC
	PUSH    ES CX BX DS

	MOV     CX,ES           ; Segmento della procedura
	MOV     AH,35h          ; Legge il segmento del vettore AL
	INT     21h
	MOV     AX,ES           ; Segmento del vettore
	CMP     CX,AX           ; Sono gli stessi?

	POP     DS BX CX ES
        JE      No_Error_x               
	STC                     ; Se no allora setta il carry

No_Error_x:

	RET
CHECK_INST      ENDP

DISINSTALLA     PROC
	CLI

	PUSH    CS
	POP     DS
        PUSH    DS              ; Conservo DS=CS

        MOV     AX,2508h
        MOV     DX,OldInt8
	MOV     CX,OldInt8[2]
        MOV     DS,CX
        INT     21h             ; Ripristino interrupt del clock
                   
        POP     DS
        PUSH    DS
                   
	MOV     AX,2509h
	MOV     DX,OldInt9
        MOV     CX,OldInt9[2]
	MOV     DS,CX
        INT     21h             ; Ripristino interrupt della tastiera
                   
	POP     DS
        PUSH    DS
                   
        MOV     AX,2513h
        MOV     DX,OldInt13
        MOV     CX,OldInt13[2]
        MOV     DS,CX
	INT     21h             ; Ripristino interrupt del disco

        POP     DS
	PUSH    DS
                   
        MOV     AX,2528h
	MOV     DX,OldInt28
        MOV     CX,OldInt28[2]
        MOV     DS,CX
        INT     21h             ; Ripristino DOS idle interrupt
                   
        POP     DS
                   
	MOV     AH,49h          ; F. DOS per liberare memoria
	MOV     BX,SEG_INIZ
        MOV     ES,BX           ; Segmento del blocco da liberare
	INT     21h             ; Libero la memoria allocata al programma

        MOV     AH,49h          ; F. DOS per liberare memoria
	MOV     BX,AMBIENTE
        MOV     ES,BX           ; Segmento del blocco da liberare
        INT     21h             ; Libero l'ambiente del programma
                   
        STI                     ; Ripristino le interruzioni

        MOV     AX,4C00h        ; F. DOS per terminare il programma (Errore 0) 
	INT     21h             ; Finito !
DISINSTALLA     ENDP

;-----------------------------------------------------------------------;
; Interrupt attivati quando il programma residente Š attivo		;
;-----------------------------------------------------------------------;
NewInt1B        PROC    ; Ctrl-C routine
		IRET    ; Non fa niente
NewInt1B        ENDP 

NewInt23        PROC    ; Ctrl-Break routine
                IRET    ; Non fa niente
NewInt23        ENDP 

NewInt24        PROC    ; Gestore Errori critici
		MOV AX,DI ; Il pi— basso byte di DI = codice d'errore
		MOV AL,3  ; Chiamata Dos fallita (DOS >= 3.x)
		IRET
NewInt24        ENDP

;-----------------------------------------------------------------------;
; Copia dello stack del programma interrotto + nostro stack             ;
;-----------------------------------------------------------------------;
EVEN                            ; Allineamento pari

SIZEOFSTACK EQU (128+1024)*2    ; 128 parole per il nostro programma e...
				; ...1024 per salvare lo stack + i registri
MIO_STACK DB SIZEOFSTACK DUP (?) ; Fine del programma res. dopo lo stack

