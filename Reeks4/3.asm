; Sluit de toetsenbordmodule aan op poort 0. Sluit bovendien de 7-segmentdisplaymodule aan op
; poorten 1 t.e.m. 4. Schrijf vervolgens een programma dat je reactiesnelheid berekent. Hierbij zal
; de tijd tussen het indrukken van de toets linksboven en het indrukken van de toets er net onder,
; uitgedrukt in milliseconden, op de 7-segementen displays getoond worden.
; Probeer de timer te laten werken in autoreload mode.

$include(8051f120.inc)

cseg at 0000H
    jmp main

cseg at 000BH
    jmp ISR_TIMER

cseg at 0003H
    jmp ISR_INT0

cseg at 0013H
    jmp ISR_INT1

cseg at 0050H

main:
    clr EA
    mov WDTCN, #0DEh
    mov WDTCN, #0ADh
    setb EA

    setb EX0 ; Interrupts van INT0 aanzetten
    setb ET0 ; Interrupts voor de timer aanzetten

    mov SFRPAGE, #0Fh
    mov XBR2, #40h

    ; P0.0 = interrupt lijn 0
    ; P0.1 = interrupt lijn 1
    mov XBR1, #10100b

    ; Interrupts enabelen voor deze interrupt lijnen
    mov P0MDOUT, #10h        ; Bij P0 dient enkel poort 4 aan te staan als uitvoer voor het toestenbord.
    mov P1MDOUT, #0FFh
    mov P2MDOUT, #0FFh
    mov P3MDOUT, #0FFh
    mov P4MDOUT, #0FFh

    clr P0.4

    mov 20h, #0111111b ; Bitpatroon voor 0
    mov 21h, #0000110b ; Bitpatroon voor 1
    mov 22h, #1011011b ; Bitpatroon voor 2
    mov 23h, #1001111b ; Bitpatroon voor 3
    mov 24H, #1100110b ; bitpatroon voor 4
    mov 25H, #1101101b ; bitpatroon voor 5
    mov 26H, #1111101b ; bitpatroon voor 6
    mov 27H, #0000111b ; bitpatroon voor 7  
    mov 28H, #1111111b ; bitpatroon voor 8
    mov 29H, #1101111b ; bitpatroon voor 9

    ; Timer configureren
    ; Timer O/1: 8-bit counter/timer with auto-reload
    ; 24.1.3. Mode 2: 8-bit Counter/Timer with Auto-Reload (page 287)
    mov TMOD, #10b

    ; Hoeveel pulsen moeten we tellen voor 1 milliseconde?
    ; 24.5 * 10^6 / 8 * 10^-3
    ; 3062,5 voor 1 milliseconde

    ; Onze 8-bit timer zal overlopen bij 2^8 = 256. 
    ; Echter is ons getal (3062,5) te groot voor in 8 bit.
    ; We kunnen dit delen door 12.
    ; 3062,5 / 12 = 255,2083
    mov CKCON, #00b

    ; Waarom niet voor delen door 48 gekozen?
    ; 3062,5 / 48 = 63,80
    ; Om af te ronden hebben we 0,2 nodig. Dan hebben we een fout van 0,2 op 64 ticks
    ; Terwijl bij 3062,5 hebben we 0,5 nodig om af te ronden. Dan hebben we een fout van 0,5 op 3063 ticks (wat beter is)

    ; Onze timer zal overlopen bij 256
    ; Echter hebben we maar 255 ticks nodig voor 1 miliseconde
    ; Wat we doen is de startwaarde op 1 zetten.
    ; TL0 holds the count and TH0 holds the reload value.
    ; When the counter in TL0 overflows from 0xFF to 0x00, the timer overflow flag TF0 is set and the counter in TL0 is reloaded from TH0. 
    mov TL0, #-255d ; Dit neemt automatisch het inverse, dus 1
    mov TH0, #-255d ; Dit neemt automatisch het inverse, dus 1

    clr TRO ; timer disabelen
    clr TF0 ; Overflow flag

    ; Vier telregisters bijhouden
    mov R2, #0h ; Voor de meest linkse
    mov R3, #0h ; 
    mov R4, #0h ; 
    mov R5, #0h ; Voor de meest rechts

    mov SFRPAGE, #0Fh

    mov P1, #00H
    mov P2, #00H
    mov P3, #00H
    mov P4, #00H

    jmp $

ISR_INT0:
    setb TR0
    clr EX0     ; Interrupts ontvangen van EX0 stopzetten
    setb EX1    ; Interrupts ontvangen van EX1
    RETI

ISR_INT1:
    clr TR0     ; timer stoppen
    setb EX0    ; Interrupts ontvangen van EX0
    clr EX1     ; Interrupts ontvangen van EX1 stopzetten
    RETI

timer:  
    ; Not sure of dit nodig is.
    ; clr TF0

    ; Telregisters verhogen.
    inc R5
    cjne R5, #10d, uitschrijven
    mov R5, #0d; We komen hier als R5 gelijk was aan 10

    inc R4
    cjne R4, #10d, uitschrijven
    mov R4, #0d; We komen hier als R4 gelijk was aan 10

    inc R3
    cjne R3, #10d, uitschrijven
    mov R3, #0d; We komen hier als R3 gelijk was aan 10

    inc R2
    cjne R2, #10d, uitschrijven
    mov R2, #0d; We komen hier als R2 gelijk was aan 10

    mov R5, #00d
    mov R4, #00d
    mov R3, #00d
    mov R2, #00d

uitschrijven:
    ; Voor meest rechtse cijfer
    mov A, #20h
    add A, R5
    mov R0, A
    mov P3, @R0 
    
    ; Voor middelste rechtse cijfer
    mov A, #20h
    add A, R4
    mov R0, A
    mov P2, @R0 

    ; Voor middelste linkse cijfer
    mov A, #20h
    add A, R3
    mov R0, A
    mov P1, @R0 

    ; Voor linkse cijfer
    mov A, #20h
    add A, R2
    mov R0, A
    mov P0, @R0 

    RETI
