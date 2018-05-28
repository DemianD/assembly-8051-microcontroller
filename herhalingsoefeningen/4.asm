; Herneem oefening 1 maar maak nu verplicht gebruik van timer 2 i.p.v. timer 0 of timer 1.
; Raadpleeg de datasheet om de werking van timer 2 te doorgronden.   

; Genereer een geluidssignaal van 1KHz.

; 1 Khz = 1000 Hz
; 1/1000 = 0,001 seconden.

; Een omschakeling van 0,0005 seconden

; Hoeveel klokpulsen?
; (24,5 * 10^6 / 8) * 0,0005 = 1531,25

; Gekozen voor een auto-reload timer van Timer 2 (16-bits)
; 2^16 = 65536 < Bij 65536 klokpulsen zal een 16-bit timer overlopen.

; We moeten niet te delen

; Startwaarden: 65536 - 1531 = 64005
; 64005 = #FA05h

cseg at 0000H
    jmp main

cseg at 002B
    jmp ISR_TIMER2

cseg at 0080H

main:   
    clr EA
    mov WDTCN, #0DEh
    mov WDTCN, #0ADh
    setb EA
    setb ET2

    mov SFRPAGE, #0Fh
    mov XBR2, #40h
    mov P1MDOUT, #80h

    mov SFRPAGE, #00h

    ; Alles op 0
    ; mov TMR2CN, #00000 

    ; SYSCLOCK 
    mov TMR2CF, #01000b

    ; Startwaardes
    mov TMR2L, #05h
    mov TMR2H, #0FAh

    ; Auto reload value
    mov RCAP2L, #05h
    mov RCAP2H, #0FAh

    setb TR2

    jmp $

ISR_TIMER2:
    ; Overflow flag not cleared by hardware
    clr TF2

    cpl P1.7

    reti
