;-----------------------------------------------------------------------;
; 		     	  the Fab Monitor				;
;	     (C) 1996 by Fabio Bruno & Fabrizio Fazzino			;
;									;
;	File: FABMON.ASM (file principale versione BASIC)		;
;-----------------------------------------------------------------------;

	S EQU 32        ; Spazio
	O EQU 196       ; Tratto orizzontale della cornice
	V EQU 179       ; Tratto verticale della cornice
	ASX EQU 218     ; Angolo in alto a sinistra
	ADX EQU 191     ; Angolo in alto a destra
	BSX EQU 192     ; Angolo in basso a sinistra
	BDX EQU 217     ; Angolo in basso a destra

.MODEL SMALL

ROM_BIOS_DATA   SEGMENT AT 40H        ; Uso l'area dati del BIOS (da 0040:0000)
		ORG 1AH               ; Offset del buffer di tastiera
		TESTA  DW ?           ; Testa del buffer di tastiera
		CODA   DW ?           ; Coda del buffer di tastiera
		BUFFER DW 16 DUP (?)  ; Buffer di 16 caratteri
		BUFFER_END LABEL WORD ; Etichetta di fine buffer
ROM_BIOS_DATA   ENDS

.CODE
		ORG 100H

START:          JMP INT_INSTALLA

	OldInt_08 LABEL WORD  
	OldInt_08_addr  DD ?

	OldInt_09 LABEL WORD
	OldInt_09_addr  DD ?

	TITOLO DB ASX,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O ; 20 char
	       DB  O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O
	       DB  O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O
	       DB  O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,ADX

	       DB V,'  ',ASX,O,O,O,O,O,O,O,O,O,ADX      ; 14 char
	       DB '     (C)1996 by Fabio Bruno'         ; 27 char
	       DB ' & Fabrizio Fazzino     '            ; 24 char
	       DB ASX,O,O,O,O,O,O,O,O,O,O,ADX,'  ',V    ; 15 char

	       DB V,'  ',V,' the Fab ',V                ; 14 char
	       DB '                 ',ASX,' Alt-F1:'    ; 26 char
	       DB ' Monitor                 '           ; 25 char
	       DB V,'  /  /19  ',V,'  ',V               ; 15 char                

	       DB V,'  ',V,' Monitor ',V                ; 14 char
	       DB '                 ',195,' Alt-F2:'    ; 26 char
	       DB ' Mostra/nasconde         '           ; 25 char
	       DB V,'   :  :   ',V,'  ',V               ; 15 char

	       DB V,'  ',BSX,O,O,O,O,O,O,O,O,O,BDX      ; 14 char
	       DB '                 ',BSX,' Alt-F3:'    ; 26 char
	       DB ' Disinstalla             '           ; 25 char
	       DB BSX,O,O,O,O,O,O,O,O,O,O,BDX,'  ',V    ; 15 char

	       DB BSX,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O ; 20 char
	       DB  O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O
	       DB  O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O
	       DB  O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,O,BDX,'$'

	SEG_INIZ        DW      ?
	AMBIENTE        DW      ?
	
	GIA_CARICATO    DB      0   
	NASCOSTO        DB      0

	Cursx           DB      ?
	Cursy           DB      ?
	CursHigh        DB      ?
	CursLow         DB      ?

INCLUDE MAIN.ASM

NUOVO_INT_08    PROC
		PUSH    DS

		PUSH    AX
		ASSUME  DS:@CODE
		MOV     AX,CS
		MOV     DS,AX
		POP     AX

		PUSHF
		CALL    OldInt_08_addr  ; Chiamo vecchia routine del clock
				
		CMP     GIA_CARICATO,1  ; Se il prog. ä attivo...
		JE      FINE            ;       ...salto alla fine

		CMP     NASCOSTO,1      ; Se il riquadro ä nascosto...
		JE      FINE            ;       ...salto alla fine
		
		CALL    QUADRO          ; Disegno il riquadro
		CALL    CLOCK           ; Aggiorno l'orologio

	FINE:
		POP     DS
		IRET    
NUOVO_INT_08    ENDP

NUOVO_INT_09    PROC
		PUSH    AX BX DX DS
		
		ASSUME  DS:@CODE
		MOV     AX,CS
		MOV     DS,AX

		PUSHF
		CALL    OldInt_09_addr  ; Chiamo la vecchia routine (tastiera)
		
		CMP     GIA_CARICATO,1  ; Se il prog. ä attivo...
		JE      EXIT            ;       ...salto alla fine

		ASSUME  DS:ROM_BIOS_DATA
		MOV     BX,ROM_BIOS_DATA
		MOV     DS,BX
		
		MOV     BX,CODA          ; Punto a coda buffer di tastiera
		CMP     BX,TESTA         ; Controllo se il buffer ä vuoto
		JE      EXIT             ; Ed in questo caso esce
		SUB     BX,2             ; Punta al char appena letto
		CMP     BX,OFFSET BUFFER ; Oltre la parte bassa del buffer?
		JAE     NON_ESCE         ; No
		MOV BX,OFFSET BUFFER_END ; Sç, si sposta nella parte alta
		SUB     BX,2             ; Punta al char appena letto
	NON_ESCE:
		MOV     DX,[BX]         ; Pongo il carattere in DX
		CMP     DX,6800h        ; E' Alt-F1 ?
		JE      F1              ; Sç, salta a F1
		CMP     DX,6900h        ; E' Alt-F2 ?
		JE      F2              ; Sç, salta a F2
		CMP     DX,6A00h        ; E' Alt-F3 ?
		JE      F3              ; Sç, salta a F3
		JMP     EXIT            ; Se nessuno di questi, esci
	F1:        
		MOV     CODA,BX         ; Rimuovi Alt-F1
		
		ASSUME  DS:@CODE
		MOV     AX,CS
		MOV     DS,AX

		MOV     GIA_CARICATO,1  ; Avverte che il monitor ä attivo

		POP     DS DX BX AX
		
		CALL    SALVA_SCHERMO           ; Salva lo schermo
		CALL    MAIN                    ; Esegue il monitor
		CALL    RIPRISTINA_SCHERMO      ; Ripristina lo schermo
		
		PUSH    DS
		PUSH    AX
		ASSUME  DS:@CODE
		MOV     AX,CS
		MOV     DS,AX
		POP     AX

		MOV     GIA_CARICATO,0  ; Azzera la variabile
		POP     DS
		IRET              
	EXIT:
		POP     DS DX BX AX
		IRET  
       
	F2:
		ASSUME  DS:ROM_BIOS_DATA
		MOV     AX,ROM_BIOS_DATA
		MOV     DS,AX
		
		MOV     CODA,BX         ; Rimuovi Alt-F2
		
		ASSUME  DS:@CODE
		MOV     AX,CS
		MOV     DS,AX

		MOV     AH,NASCOSTO     ; Esegue NOT(NASCOSTO)
		MOV     AL,1
		SUB     AL,AH
		MOV     NASCOSTO,AL 

		JMP     EXIT
	F3:
		ASSUME  DS:ROM_BIOS_DATA
		MOV     AX,ROM_BIOS_DATA
		MOV     DS,AX
		
		MOV     CODA,BX         ; Rimuovi Alt-F3
		
		POP     DS DX BX AX
		JMP     DISINSTALLA     ; Disinstalla il programma
NUOVO_INT_09    ENDP

SALVA_SCHERMO   PROC
		PUSH    AX BX CX DX DS SI ES DI
                         
		MOV     AH,3
		XOR     BH,BH
		INT     10h         ; Legge pos. e dim. cursore
		   
		MOV     Cursx,DL    ; Memorizza pos. e dim. cursore
		MOV     Cursy,DH
		MOV     CursHigh,CH
		MOV     CursLow,CL

		XOR     CX,CX           ; CL=0 col.inizio, CH=0 riga inizio
		MOV     DX,184Fh        ; DL=79 col.finale, DH=24 riga finale
		MOV     SI,OFFSET CS:SCREENSAVE ; Buffer di memorizzazione
	
		MOV     AX,0B800h   ; Segmento inizio VGA colore
		MOV     ES,AX
	
	Clr2:                   ; Inizio ciclo per salvare lo schermo
		MOV     BL,CL       ; Colonna iniziale
		MOV     BH,0        
	
		MOV     AL,160      ; Num.di char+attrib di una riga intera
		MUL     CH          ; Moltiplico per la riga di partenza
		MOV     DI,AX       ; Sposto offset di partenza
		ADD     DI,BX       ; Sommo BX caratteri
                ADD     DI,BX       ; Sommo BX attributi
	C2:                     ; Inizio ciclo per salvare una riga
                PUSH    DX
                MOV     DX,ES:[DI]
                MOV     CS:[SI],DX
                POP     DX      
                CMP     BL,DL   ; Verifico se sono a fine riga
                JE      N2      ; Se sç salto avanti
                INC     DI      ; Incremento dest. di char+attrib
                INC     DI
                INC     SI      ; Incremento sorg. di char+attrib
                INC     SI
                INC     BL      ; Incremento il numero di colonna
                JMP     C2      ; Ripeto il ciclo per la prossima colonna
	N2:                     
                INC     DI      ; Incremento dest. di char+attrib
                INC     DI
                INC     SI      ; Incremento sorg. di char+attrib
                INC     SI      
                MOV     BL,CL   ; Ripristino BL
                INC     CH      ; Incrementa la riga
                CMP     CH,DH   ; Se sono all'ultima riga finisce
                JLE     C2      ; Altrimenti ripete il ciclo
		
                POP     DI ES SI DS DX CX BX AX
		RET
SALVA_SCHERMO   ENDP

RIPRISTINA_SCHERMO      PROC
                PUSH    AX BX CX DX DS SI ES DI
                         
                XOR     CX,CX           ; CL=0 col.inizio, CH=0 riga inizio
                MOV     DX,184Fh        ; DL=79 col.finale, DH=24 riga finale
                MOV     SI,OFFSET CS:SCREENSAVE
			
                MOV     AX,0B800h       ; Segmento per la VGA colore
                MOV     ES,AX
	Clr:        
                MOV     BL,CL           ; Colonna iniziale
                MOV     BH,0
       
                MOV     AL,160  ; Num.di char+attrib di una riga intera
                MUL     CH      ; Moltiplico per la riga di partenza
                MOV     DI,AX   ; Sposto offset di partenza
                ADD     DI,BX   ; Sommo BX caratteri
                ADD     DI,BX   ; Sommo BX attributi
	C1:                     ; Inizio ciclo per salvare una riga
                PUSH    DX
                MOV     DX,CS:[SI]
                MOV     ES:[DI],DX
                POP     DX
                CMP     BL,DL   ; Verifico se sono a fine riga
                JE      N1      ; Se sç salto avanti
                INC     DI      ; Incremento dest. di char+attrib
                INC     DI      
                INC     SI      ; Incremento sorg. di char+attrib
                INC     SI
                INC     BL      ; Incremento il numero di colonna
                JMP     C1      ; Ripeto il ciclo per la prossima colonna
	N1:                     
                INC     DI      ; Incremento dest. di char+attrib
                INC     DI      
                INC     SI      ; Incremento sorg. di char+attrib
                INC     SI
                MOV     BL,CL   ; Ripristino BL
                INC     CH      ; Incrementa la riga
                CMP     CH,DH   ; Se sono all'ultima riga finisce
                JLE     C1      ; Altrimenti ripete il ciclo
		
                MOV     AH,2    ; Ripristino pos. cursore
                XOR     BX,BX
                MOV     DH,Cursy
                MOV     DL,Cursx
                INT     10h

                MOV     AH,1    ; Ripristino dimensione cursore
                MOV     CH,CursHigh
                MOV     CL,CursLow
                INT     10h
			
                POP     DI ES SI DS DX CX BX AX
		RET
RIPRISTINA_SCHERMO      ENDP

QUADRO          PROC
		PUSH    AX BX CX DX ES SI
		
                ASSUME  DS:@CODE
                MOV     AX,CS
                MOV     DS,AX
			
		MOV     AH,3    ; Funzione BIOS per leggere posiz.cursore
		XOR     BH,BH   ; Pagina 0
		INT     10h     ; Legge pos.cursore in (DH,DL)
		CMP     DH,6    ; Vede se sono dentro il riquadro
		JG      DISEGNA_QUADRO  ; Se sono fuori passo avanti
		MOV     AH,2    ; Funzione BIOS per posizionare cursore
		MOV     DH,6    ; Nuova riga
		INT     10h     ; Posiziona il cursore oltre il riquadro
                                
	DISEGNA_QUADRO:                
                MOV     AX,0B800h       ; Pone il segmento degli attributi...
                MOV     ES,AX           ;               ...in ES
                MOV     SI,0000h        ; Inizio dell'area da scandire
                MOV     CX,480          ; Numero di char da colorare 6*80
                MOV     BX,0000h        ; Punta all'inizio della stringa
	ATTRIB_LOOP:
                MOV     AL,TITOLO[BX]
                MOV     BYTE PTR ES:[SI],AL
                INC     BX
                INC     SI
                MOV     BYTE PTR ES:[SI],78d        ; Colora con attributo 78
                INC     SI
                LOOP    ATTRIB_LOOP

                POP     SI ES DX CX BX AX
		RET
QUADRO          ENDP

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

                MOV     AL,DL           ; Ripristino il char AL da stampare
                MOV     BYTE PTR ES:[SI],AL
		
                POP     SI ES DX CX BX AX
		RET
WRITE_CLOCK     ENDP

CLOCK           PROC
                PUSH    AX BX CX DX ES SI

		;**** ANNO, MESE E GIORNO ****

                MOV     AH,04h      ; Funzione che scrive la data in (CX,DX)
                INT     1Ah         ; INT del clock

		; ANNO
                MOV     AL,CL       ; Sposta seconde cifre anno (CL) in AL
                SHR     AL,4        ; Sposta dx di un nibble (isola 3^ cifra)
                ADD     AL,30h      ; Converte in ASCII
                MOV     BX,024Ah    ; Posizione cursore
                CALL    WRITE_CLOCK ; Scrive la terza cifra dell'anno

                MOV     AL,CL       ; Rimette seconde cifre anno (CL) in AL
                AND     AL,0Fh      ; Azzera la parte sx (isola 4^ cifra)
                ADD     AL,30h      ; Converte in ASCII
                MOV     BX,024Bh    ; Posizione cursore
                CALL    WRITE_CLOCK ; Scrive la quarta cifra dell'anno

		; MESE
                MOV     AL,DH       ; Sposta 2 cifre del mese (DH) in AL
                SHR     AL,4        ; Sposta dx di un nibble (isola 1^ cifra)
                ADD     AL,30h      ; Converte in ASCII
                MOV     BX,0245h    ; Posizione cursore
                CALL    WRITE_CLOCK ; Scrive la prima cifra del mese

                MOV     AL,DH       ; Rimette il mese (DH) in AL
                AND     AL,0Fh      ; Azzera la parte sinistra (isola 2^ cifra)
                ADD     AL,30h      ; Converte in ASCII
                MOV     BX,0246h    ; Posizione cursore
                CALL    WRITE_CLOCK; Scrive la seconda cifra del mese

		; GIORNO
                MOV     AL,DL       ; Sposta 2 cifre del giorno (DL) in AL
                SHR     AL,4        ; Sposta dx di un nibble (isola 1^ cifra)
                ADD     AL,30h      ; Converte in ASCII
                MOV     BX,0242h    ; Posizione cursore
                CALL    WRITE_CLOCK ; Scrive la prima cifra del giorno

                MOV     AL,DL       ; Rimette il giorno (DL) in AL
                AND     AL,0Fh      ; Azzera parte sx (isola quarta cifra)
                ADD     AL,30h      ; Converte in ASCII
                MOV     BX,0243h    ; Posizione cursore
                CALL    WRITE_CLOCK ; Scrive la seconda cifra del giorno

		;**** ORE, MINUTI E SECONDI ****

                MOV     AH,02h      ; Funzione che scrive l'orario in (CX,DH)
                INT     1Ah         ; INT del clock

		; ORE
                MOV     AL,CH       ; Sposta 2 cifre delle ore (CH) in AL
                SHR     AL,4        ; Sposta dx di un nibble (isola 1^ cifra)
                ADD     AL,30h      ; Converte in ASCII
                MOV     BX,0343h    ; Posizione cursore
                CALL    WRITE_CLOCK ; Scrive la prima cifra delle ore

                MOV     AL,CH       ; Rimette le ore (CH) in AL
                AND     AL,0Fh      ; Azzera parte sx (isola 2^ cifra)
                ADD     AL,30h      ; Converte in ASCII
                MOV     BX,0344h    ; Posizione cursore
                CALL    WRITE_CLOCK ; Scrive la seconda cifra delle ore

		; MINUTI
                MOV     AL,CL       ; Sposta 2 cifre dei minuti (CL) in AL
                SHR     AL,4        ; Sposta dx di un nibble (isola 3^ cifra)
                ADD     AL,30h      ; Converte in ASCII
                MOV     BX,0346h    ; Posizione cursore
                CALL    WRITE_CLOCK ; Scrive la prima cifra dei minuti

                MOV     AL,CL       ; Rimette i minuti (CL) in AL
                AND     AL,0Fh      ; Azzera parte sx (isola 4^ cifra)
                ADD     AL,30h      ; Converte in ASCII
                MOV     BX,0347h    ; Posizione cursore
                CALL    WRITE_CLOCK ; Scrive la seconda cifra dei minuti

		; SECONDI
                MOV     AL,DH       ; Sposta 2 cifre dei secondi (DH) in AL
                SHR     AL,4        ; Sposta dx di un nibble (isola 1^ cifra)
                ADD     AL,30h      ; Converte in ASCII
                MOV     BX,0349h    ; Posizione cursore
                CALL    WRITE_CLOCK ; Scrive la prima cifra dei secondi

                MOV     AL,DH       ; Rimette i secondi (DH) in AL
                AND     AL,0Fh      ; Azzera parte sx (isola 2^ cifra)
                ADD     AL,30h      ; Converte in ASCII
                MOV     BX,034Ah    ; Posizione cursore
                CALL    WRITE_CLOCK; Scrive la seconda cifra dei secondi

		POP SI ES DX CX BX AX
		RET
CLOCK           ENDP

DISINSTALLA     PROC
		ASSUME  DS:@CODE
		MOV     AX,CS
		MOV     DS,AX

		PUSH    DS

		CLI

		MOV     AX,2508h        ; Funzione per scrivere vett.di int
		MOV     DX,OldInt_08
		MOV     CX,OldInt_08[2]
		MOV     DS,CX
		INT     21h             ; Risistemo INT 8 del clock
		
		POP     DS
		PUSH    DS

		MOV     AX,2509h        ; Funzione per scrivere vett.di int
		MOV     DX,OldInt_09
		MOV     CX,OldInt_09[2]
		MOV     DS,CX
		INT     21h             ; Risistemo INT 9 della tastiera
		 
		POP     DS

		ASSUME  DS:@CODE
		MOV     AX,CS
		MOV     DS,AX

		MOV     BX,DS:[SEG_INIZ]        ; Libera memoria programma
		MOV     ES,BX
		MOV     AH,49h
		INT     21h
		
		MOV     BX,DS:[AMBIENTE]        ; Libera segmento ambiente
		MOV     ES,BX
		MOV     AH,49h
		INT     21h
		
		STI
		
		MOV     AH,4CH
		INT     21H             ; Termina ed esce al DOS

DISINSTALLA     ENDP

SCREENSAVE      DW      2000    DUP (?)         ; Buffer video

FINE_RESIDENTE:

INT_INSTALLA    PROC
		MOV     SEG_INIZ,ES     ; Conservo segmento del programma
		MOV     BX,ES:[002Ch]   ; (serve per disinstallazione)
		MOV     AMBIENTE,BX     ; Indirizzo del segmento ambiente
		
		MOV     AX,3508h        ; Leggo vecchio vettore di INT 8
		INT     21h
		MOV     OldInt_08,BX    ; Memorizzo il vecchio valore
		MOV     OldInt_08[2],ES
		LEA     DX,NUOVO_INT_08 ; Aggancio la mia nuova routine
		MOV     AX,2508h
		INT     21h

		MOV     AX,3509h        ; Leggo vecchio vettore di INT 9
		INT     21h
		MOV     OldInt_09,BX    ; Memorizzo il vecchio valore
		MOV     OldInt_09[2],ES
		LEA     DX,NUOVO_INT_09 ; Aggancio la mia nuova routine
		MOV     AX,2509h
		INT     21h

		; Libero la memoria assegnata al blocco ambiente
		MOV     AH,49h
		MOV     BX,CS:[AMBIENTE]
		MOV     ES,BX
		INT     21h

		; Calcolo lunghezza parte residente in paragrafi
		MOV     DX,(FINE_RESIDENTE-START+100h+15) SHR 4
		MOV     AH,31h
		INT     21h             ; Termina e rimane residente
INT_INSTALLA    ENDP

	END START
