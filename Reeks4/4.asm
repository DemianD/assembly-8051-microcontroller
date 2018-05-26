; Schrijf een programma dat op P1.7 een blokgolf genereert met een frequentie van 7KHz en op
; P1.6 een blokgolf met een frequentie van 500Hz.

; 7KHz      = 7000 Hz  
; 7000 Hz   = 1/7000 seconden = 0,000142857
; Omschakelen om de 0,000071429 seconden

; 500Hz     = 1/500 seconden = 0,002
; Omschakelen om de 0,001 seconden

; 7KHz
; #klokpulsen = ((24,5*10^6)/8)*0,000071429 = 218,75

; 500Hz
; #klokpulsen = ((24,5*10^6)/8)*0,001 = 3062,5

; Ik zal gebruik maken van 2 timers, met mode 0 ( Mode 0: 13-bit counter/timer)
; Timer 0 voor 7KHz
; Timer 1 voor 500Hz

; Een 13-bit timer zal overlopen bij 2^13 = 8192
; 218,75                (Fout van 0,25 bij 219 ticks)           < Beste keuze
; 218,75 / 4 = 54,69    (Fout van 0,31 bij 55 ticks)
; 218,75 / 12 = 18,23   (Fout van 0,23 bij 18 ticks)         
; 218,75 / 48 = 4,58    (Fout van 0,42 bij 5 ticks)
; Startwaarde: 8192 - 219 = 7973 => #1F25h

; 3062,5                (Fout van 0,5 bij 3063 ticks)           < Beste keuze
; 3062,5 / 4 = 765,63   (Fout van 0,37 bij 766 ticks)      
; 3062,5 / 12 = 255,21  (Fout van 0,21 bij 255 ticks)      
; 3062,5 / 48 = 63,80   (Fout van 0,2 bij 64 ticks)        
; Startwaarde: 8192 - 3063 = 5129 => #1409h

$include(8051f120.inc)

cseg at 0000H
    jmp main

cseg at 000BH
    jmp ISR_TIMER0

cseg at 001BH
    jmp ISR_TIMER1

main:
    clr EA
    mov WDTCN, #0DEh
    mov WDTCN, #0ADh
    setb EA

    ; Interrupts voor Timer 0 en Timer 1
    setb ET0
    setb ET1

    mov SFRPAGE, #0Fh
    mov XBR2, #40h
    mov P1MDOUT, #0FFh ; Uitvoer pinnen 6 en 7 aanzetten, rest zijn dont-cares

    mov SFRPAGE, #00H

    ; TMOD
    ; Beide timers op Mode 0
    mov TMOD, #0000000b

    ; CKCON, instellen dat gewoon getelt moet worden met de systeemklok.
    ; Niet delen
    mov CKCON, #00011000b

    ; Timers stoppen
    clr TR0
    clr TR1

    ; Overflow vlaggen clearen
    clr TF0 
    clr TF1 

    ; Startwaarden T0
    mov TH0, #1Fh
    mov TL0, #25h

    ; Startwaarden T1
    mov TH1, #14h
    mov TL1, #09h

    clr P1.6
    clr P1.7

    ; Starten
    setb TR0
    setb TR1

    ; Oneindige lus
    jmp $

ISR_TIMER0:
    clr TR0
    clr TF0 

    cpl P1.6

    ; Startwaarden T0
    mov TH0, #1Fh
    mov TL0, #25h

    setb TR0

    reti

ISR_TIMER1:
    clr TR1
    clr TF1

    cpl P1.7

    ; Startwaarden T1
    mov TH1, #14h
    mov TL1, #09h

    setb TR1

    reti
