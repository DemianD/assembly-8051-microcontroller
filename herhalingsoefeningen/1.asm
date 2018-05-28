; Genereer een geluidssignaal van 1KHz.

; 1 Khz = 1000 Hz
; 1/1000 = 0,001 seconden.

; Een omschakeling van 0,0005 seconden

; Hoeveel klokpulsen?
; (24,5 * 10^6 / 8) * 0,0005 = 1531,25

; Gekozen voor een auto-reload timer van Timer 1 (Dus 8-bits)
; 2^8 = 256 < Bij 256 klokpulsen zal een 8-bit timer overlopen.

; Delen:
; 1531,25
; 1531,25/4 
; 1531,25/12 = 127,60           een fout van 0,40 per 128 ticks         < Beide zijn even goed < Ik kies voor deze
; 1531,25/48 = 31,90            een fout van 0,10 per 32 ticks          < Beide zijn even goed

; Startwaarden: 256 - 128 = 128
; 128 = #80h

cseg at 0000H
    jmp main

cseg at 0001B
    jmp ISR_TIMER1OVERFLOW

cseg at 0080H

main:
    clr EA
    mov WDTCN, #0DEh
    mov WDTCN, #0ADh
    setb EA

    ; Interrupts aanzetten voor Timer 1
    setb ET1

    mov SFRPAGE, #0Fh
    mov XBR2, #40h
    mov P1MDOUT, #80h       ; 7de pin

    mov SFRPAGE, #00h
    clr P1.7

    mov TMOD, #00100000b
    ; mov CKCON, #00b         ; Alles op nul laten staan. Standaard wordt gedeeld door 12.

    mov TL1, #80h             ; Startwaarde
    mov TH1, #80h             ; Auto-reload waarde

    ; Timer starten
    setb TR1

ISR_TIMER1OVERFLOW:
    cpl P1.7

    reti
