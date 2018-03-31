;-----------------------------------------------------------------------;
; 		     	  the Fab Monitor				;
;	     (C) 1996 by Fabio Bruno & Fabrizio Fazzino			;
;									;
;	File: FABMON.ASM  (file principale versione ADVANCED)		;
;-----------------------------------------------------------------------;

PRINTMAC        MACRO SYMBOL          ; Macro per scrivere una stringa
                MOV AH,09h
                MOV DX,OFFSET SYMBOL
                INT 21h
ENDM

.MODEL SMALL           ; Dati e codice stanno in un unico segmento di 64K


ROM_BIOS_DATA   SEGMENT AT 40H        ; Uso l'area dati del BIOS (da 0040:0000)
                ORG 1AH               ; Offset del buffer di tastiera
                TESTA  DW ?           ; Testa del buffer di tastiera
                CODA   DW ?           ; Coda del buffer di tastiera
                BUFFER DW 16 DUP (?)  ; Buffer di 16 caratteri
                BUFFER_END LABEL WORD ; Etichetta di fine buffer
ROM_BIOS_DATA   ENDS

.CODE
                ORG 100h  ; L'eseguibile Š .COM lascio liberi 256 byte per PSP

.8086 

START:          JMP INSTALLAZIONE

Gia_in_memoria  db 13,10,"Il programma Š gia residente in memoria!",'$'

                INCLUDE RESIDENT.ASM 
                INCLUDE MAIN.ASM 
FINERESIDENTE:
                INCLUDE INSTALL.ASM  

INSTALLAZIONE:      
                JMP INSTALLA 

                END START
