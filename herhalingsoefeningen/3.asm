; Sluit de toetsenbordmodule aan op poort 0. Schrijf een programma dat een alarminstallatie
; voorstelt. Bij het indrukken van de knop aangesloten op /INT0 wordt het alarm aangezet. Bij het
; drukken op de knop aangesloten op /INT1, stopt het alarm

cseg at 0000H
    jmp main

cseg at 0003H
    jmp ISR_ET0

cseg at 0013H
    jmp ISR_ET1

cseg at 000BH
    jmp ISR_TIMER0

cseg at 001BH
    jmp ISR_TIMER1

cseg at 0080H

main:
    clr EA  
    mov WDTCN, #0DEh
    mov WDTCN, #0ADh
    setb EA
    
    setb ET0    ; Interrupt timer 0 overflow
    setb ET1    ; Interrupt timer 1 overflow
    setb EX0    ; External Interrupt 0

    mov SFRPAGE, #0Fh
    mov XBR2, #40h
    mov XBR1, #10100b   ; P0.0 => INT0  ; P0.1 => INT1

    mov P1MDOUT, #80h   ; 7-de bit uitvoer
    mov P0MDOUT, #10h   ; 4-de bit als uitvoer

    mov SFRPAGE, #00h

    clr P1.7
    clr P0.4

    ; Timer Modes instellen
    mov TMOD, #00100001b

    ; Delen door 12 = de standaard
    ; mov CKCON, #00b

    ; Startwaarden Timer 0
    mov TL0, #06h
    mov TH0, #C6h

    ; Starten bij 3Khz
    mov TL1, #D5h
    mov TH1, #D5h

    ; Oneindige lus
    jmp $

ISR_TIMER0:
    ; Overflow flag is cleared by hardware
    ; Timer stoppen, opnieuw initialiseren, en starten.
    clr TR0
    mov TL0, #06h
    mov TH0, #C6h
    setb TR0

    ; Als de Carry aan staat, hoge pieptoon
    cpl C
    jc hoog

    mov TL1, #D5h
    mov TH1, #D5h
    reti

hoog:
    mov TL1, #ABh
    mov TH1, #ABh

    reti

ISR_TIMER1:
    ; Overflow flag is cleared by hardware

    cpl P1.7

    reti

ISR_ET0:
    ; TODO: Wachten tot losgelaten wordt? Met een dubbele lus?

    clr EX0     ; External Interrupt 0 uitzetten
    setb EX1    ; External Interrupt 1 aanzetten

    ; Beide timers starten.
    setb TR0
    setb TR1

    reti

ISR_ET1:
    ; TODO: Wachten tot losgelaten wordt? Met een dubbele lus?

    clr EX1    ; External Interrupt 1 uitzetten
    setb EX0     ; External Interrupt 0 aanzetten

    ; Beide timers stoppen.
    clr TR0
    clr TR1

    ; Hier zou ik ook nog eventueel alle timers eens kunnen resetten (hun waardes)

    reti