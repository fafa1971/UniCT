;-----------------------------------------------------------------------;
; 		     	  the Fab Monitor				;
;	     (C) 1996 by Fabio Bruno & Fabrizio Fazzino			;
;									;
;	File: EDITOR.ASM						;
;-----------------------------------------------------------------------;

CURSORE_VERO_X           DB      0
CURSORE_VERO_Y           DB      0

CURSORE_FANTASMA_X        DB      0
CURSORE_FANTASMA_Y        DB      0

;-----------------------------------------------------------------------;
; MOSTRA_CURSORE_FANTASMA usa CURSOR_X e CURSOR_Y, tramite MOV_TO_...,  ;
; come coordinate per il cursore fantasma.                              ;
;-----------------------------------------------------------------------;
MOSTRA_CURSORE_FANTASMA PROC
	PUSH    AX BX CX DX
	CALL    SALVA_CURSORE_VERO      ; Salva posizione del cursore reale

	CALL    SPOSTA_CURSORE_FINESTRA_HEX     ; Pone cursore finestra hex
	MOV     CX,4                            ; Ripete 4 volte
	MOV     DL,ATTRIB_DATI_EVIDENZIATI      ; Attributo video inverso
	CALL    SCRIVE_ATTRIB_N_VOLTE           ; Scrive numero hex in inverso

	CALL    SPOSTA_CURSORE_FINESTRA_ASCII   ; Pone cursore finestra ASCII
	MOV     CX,1                            ; Scrive solo 1 volta
	CALL    SCRIVE_ATTRIB_N_VOLTE   ; Scrive carattere ASCII in inverso

	CALL    RIPRISTINA_CURSORE_VERO         ; Ripristina posiz.curs.vero
	POP     DX CX BX AX
	RET
MOSTRA_CURSORE_FANTASMA ENDP

;-----------------------------------------------------------------------;
; CANCELLA_CURSORE_FANTASMA cancella il cursore fantasma; funziona in   ;
; modo contrario a MOSTRA_CURSORE_FANTASMA                              ;
;-----------------------------------------------------------------------;
CANCELLA_CURSORE_FANTASMA       PROC
	PUSH    CX DX
	CALL    SALVA_CURSORE_VERO              ; Memorizza dove era cursore

	CALL    SPOSTA_CURSORE_FINESTRA_HEX     ; Pone cursore finestra hex
	MOV     CX,4                            ; Ripete 4 volte
	MOV     DL,ATTRIB_DATI_NORMALI          ; Attributo video normale
	CALL    SCRIVE_ATTRIB_N_VOLTE           ; Colora numero hex normale

	CALL    SPOSTA_CURSORE_FINESTRA_ASCII   ; Pone cursore finestra ASCII
	MOV     CX,1                            ; Scrive solo 1 volta
	CALL    SCRIVE_ATTRIB_N_VOLTE           ; Colora ASCII normale

	CALL    RIPRISTINA_CURSORE_VERO         ; Rimette cursore dove era
	POP     DX CX
	RET
CANCELLA_CURSORE_FANTASMA       ENDP

;-----------------------------------------------------------------------;
; Queste quattro procedure spostano i cursori fantasma.                 ;
;-----------------------------------------------------------------------;
;-----------------------------------------------------------------------;
; CURSORE_FANTASMA_SU                                                   ;
;-----------------------------------------------------------------------;
CURSORE_FANTASMA_SU     PROC
	PUSH    CX
	CALL    CANCELLA_CURSORE_FANTASMA       ; Rimuove da vecchia posizione
	DEC     CURSORE_FANTASMA_Y      ; Sposta cursore in alto di una riga
	JNS     NON_ERA_IN_ALTO         ; Salta se non era a inizio finestra
	MOV     CURSORE_FANTASMA_Y,0    ; Se era all'inizio lo lascia lç
NON_ERA_IN_ALTO:
	CALL    MOSTRA_CURSORE_FANTASMA ; Scrive curs.fantasma in nuova posiz.
	POP     CX
	RET
CURSORE_FANTASMA_SU      ENDP

;-----------------------------------------------------------------------;
; CURSORE_FANTASMA_GIU                                                  ;
;-----------------------------------------------------------------------;
CURSORE_FANTASMA_GIU    PROC
	PUSH    CX
	CALL    CANCELLA_CURSORE_FANTASMA       ; Rimuove da vecchia posizione
	INC     CURSORE_FANTASMA_Y      ; Sposta cursore in basso di una riga
	CMP     CURSORE_FANTASMA_Y,16   ; Vede se era a fine finestra
	JB      NON_ERA_IN_BASSO        ; No, allora salta alla fine
	MOV     CURSORE_FANTASMA_Y,15   ; Se era alla fine lo lascia lç
NON_ERA_IN_BASSO:
	CALL    MOSTRA_CURSORE_FANTASMA ; Scrive curs.fantasma in nuova posiz.
	POP     CX
	RET
CURSORE_FANTASMA_GIU    ENDP

;-----------------------------------------------------------------------;
; CURSORE_FANTASMA_SINISTRA                                             ;
;-----------------------------------------------------------------------;
CURSORE_FANTASMA_SINISTRA       PROC
	CALL    CANCELLA_CURSORE_FANTASMA       ; Rimuove da vecchia posizione
	DEC     CURSORE_FANTASMA_X      ; Sposta cursore a sx di una colonna
	JNS     NON_ERA_A_SINISTRA      ; Salta se non era sul lato sinistro
	MOV     CURSORE_FANTASMA_X,0    ; Se era a sinistra lo lascia lç
NON_ERA_A_SINISTRA:
	CALL    MOSTRA_CURSORE_FANTASMA ; Scrive il cursore fantasma
	RET
CURSORE_FANTASMA_SINISTRA       ENDP

;-----------------------------------------------------------------------;
; CURSORE_FANTASMA_DESTRA                                               ;
;-----------------------------------------------------------------------;
CURSORE_FANTASMA_DESTRA PROC
	CALL    CANCELLA_CURSORE_FANTASMA       ; Rimuove da vecchia posizione
	INC     CURSORE_FANTASMA_X      ; Sposta cursore a dx di una colonna
	CMP     CURSORE_FANTASMA_X,16   ; Vede se era giÖ sul lato destro
	JB      NON_ERA_A_DESTRA        ; No, allora salta alla fine
	MOV     CURSORE_FANTASMA_X,15   ; Se era a destra lo lascia lç
NON_ERA_A_DESTRA:
	CALL    MOSTRA_CURSORE_FANTASMA ; Scrive il cursore fantasma
	RET
CURSORE_FANTASMA_DESTRA ENDP

;-----------------------------------------------------------------------;
; SPOSTA_CURSORE_FINESTRA_HEX sposta il cursore reale nella posizione   ;
; del cursore fantasma nella finestra esadecimale.                      ;
;-----------------------------------------------------------------------;
SPOSTA_CURSORE_FINESTRA_HEX     PROC
	PUSH    AX BX CX DX

	MOV     DH,NUM_LINEE_BIANCHE_SUPERIORI  ; Num.righe vuote +
	ADD     DH,2                    ; + riga hex + barra orizzontale +
	ADD     DH,CURSORE_FANTASMA_Y   ; + riga del cursore fantasma = DH

	MOV     DL,8                    ; Rientro a sinistra
	MOV     CL,3                    ; Ogni colonna usa 3 caratteri
	MOV     AL,CURSORE_FANTASMA_X   ; = colonna del cursore fantasma
	MUL     CL                      ; Moltiplico CURS_FAN_X per 3
	ADD     DL,AL                   ; Aggiungo rientro per avere colonna

	CALL    SPOSTA_CURSORE_XY       ; Sposto il cursore a (DH,DL)

	POP     DX CX BX AX
	RET
SPOSTA_CURSORE_FINESTRA_HEX     ENDP

;-----------------------------------------------------------------------;
; SPOSTA_CURSORE_FINESTRA_ASCII sposta il cursore reale all'inizio del  ;
; cursore fantasma nella finestra ASCII.                                ;
;-----------------------------------------------------------------------;
SPOSTA_CURSORE_FINESTRA_ASCII   PROC
	PUSH    AX BX CX DX

	MOV     DH,NUM_LINEE_BIANCHE_SUPERIORI  ; Num.righe vuote +
	ADD     DH,2                    ; + riga hex + barra orizzontale +
	ADD     DH,CURSORE_FANTASMA_Y   ; + riga del cursore fantasma = DH

	MOV     DL,59                   ; Rientro a sinistra
	ADD     DL,CURSORE_FANTASMA_X   ; Pió CURS_FAN_X per ottenere colonna

	CALL    SPOSTA_CURSORE_XY       ; Sposto il cursore a (DH,DL)

	POP     DX CX BX AX
	RET
SPOSTA_CURSORE_FINESTRA_ASCII   ENDP

;-----------------------------------------------------------------------;
; SALVA_CURSORE_VERO salva la posizione del cursore reale nelle due     ;
; variabili CURSORE_VERO_X e CURSORE_VERO_Y.                            ;
;-----------------------------------------------------------------------;
SALVA_CURSORE_VERO      PROC
	PUSH    AX BX CX DX

	MOV     AH,3                    ; Funzione per leggere posiz. cursore
	XOR     BH,BH                   ; Pagina BH=0
	INT     10h                     ; INT del BIOS legge in (DH,DL)
	MOV     CURSORE_VERO_Y,DL       ; Salva riga cursore
	MOV     CURSORE_VERO_X,DH       ; Salva colonna cursore

	POP     DX CX BX AX
	RET
SALVA_CURSORE_VERO      ENDP

;-----------------------------------------------------------------------;
; RIPRISTINA_CURSORE_VERO riporta il cursore reale alla vecchia         ;
; posizione, salvata in CURSORE_VERO_X e CURSORE_VERO_Y.                ;
;-----------------------------------------------------------------------;
RIPRISTINA_CURSORE_VERO PROC
	PUSH    DX
	MOV     DL,CURSORE_VERO_Y       ; Legge riga cursore
	MOV     DH,CURSORE_VERO_X       ; Legge colonna cursore
	CALL    SPOSTA_CURSORE_XY       ; Posiziona cursore a (DH,DL)
	POP     DX
	RET
RIPRISTINA_CURSORE_VERO ENDP

;-----------------------------------------------------------------------;
; SCRIVE_BUFFER scrive un byte su BLOCCO, alla locazione di memoria     ;
; puntata dal cursore fantasma.                                         ;
;                                                                       ;
; Ingresso:  DL  =  Byte da scrivere su BLOCCO                          ;
;                                                                       ;
; L'offset ä calcolato da :                                             ;
;  OFFSET = OFFSET_BLOCCO+(16*CURSORE_FANTASMA_Y)+CURSORE_FANTASMA_X    ;
;-----------------------------------------------------------------------;
SCRIVE_BUFFER   PROC
	PUSH    AX BX CX DX

	MOV     BX,OFFSET_BLOCCO        ; Carico l'offset nel blocco
	MOV     AL,CURSORE_FANTASMA_Y   ; Carico la riga del curs.fantasma
	XOR     AH,AH                   ; Azzero parte alta di AX
	MOV     CL,4                    ; Preparo moltiplicazione per 16
	SHL     AX,CL                   ; Moltiplico CUR_FAN_Y per 16
	ADD     BX,AX                   ; BX = OFFSET_BLOCCO + (16 * Y)
	MOV     AL,CURSORE_FANTASMA_X   ; Metto in AL la colonna del cursore
	XOR     AH,AH                   ; Azzero la parte alta di AX
	ADD     BX,AX                   ; Questo ä l'indirizzo finale
	MOV     BLOCCO[BX],DL          ; Memorizza il byte

	POP     DX CX BX AX
	RET
SCRIVE_BUFFER   ENDP

;-----------------------------------------------------------------------;
; EDITA_BYTE modifica un byte in memoria e sullo schermo.               ;
;                                                                       ;
; Ingresso:  DL  =  Byte da scrivere su BLOCCO e modificare su schermo  ;
;-----------------------------------------------------------------------;
EDITA_BYTE      PROC
	PUSH    DX
	CALL    SALVA_CURSORE_VERO              ; Salva posiz.cursore

	CALL    SPOSTA_CURSORE_FINESTRA_HEX     ; Va su numero hex in fin.hex
	CALL    SPOSTA_CURSORE_DESTRA           ; Muove cursore.pos.seguente
	CALL    SCRIVE_HEX                      ; Scrive il nuovo numero

	CALL    SPOSTA_CURSORE_FINESTRA_ASCII   ; Va su char in finestra ASCII
	CALL    SCRIVE_CHAR                     ; Scrive il nuovo carattere

	CALL    RIPRISTINA_CURSORE_VERO         ; Ripristina posiz.cursore

	CALL    MOSTRA_CURSORE_FANTASMA         ; Riscrive cursore fantasma
	CALL    SCRIVE_BUFFER                   ; Salva nuovo byte in BLOCCO
	CALL    SCRIVE_PROMPT_NORMALE           ; Scrive il prompt
	POP     DX
	RET
EDITA_BYTE      ENDP
