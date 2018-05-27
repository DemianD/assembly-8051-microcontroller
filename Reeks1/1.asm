; Schrijf een programma dat het LED op P1.6 aanzet.

; Notes:
; - Indien een waarde als #FFH, na de hashtag begint met een letter, dan schrijf je eerst een 0 ervoor
; - Regel 51 heb ik zelf geschreven met bit-addressable

; Deze regel krijg je gegeven
$include (c8051f120.inc)

; Het cseg directive geeft aan waar de assembleerder de overeenstemmende machinecode in het programmageheugen moet wegschrijven.
; De code onder cseg zal hier weggeschreven worden vanaf adres 0000H
; cseg staat voor Code Segment
cseg at 0000H
    jmp main

; De code hieronder wordt weggeschreven vanaf adres 0050H
cseg at 0050H

main:
    ; EA staat voor Enable All interrupts.
    ; Wanneer de waarde op 0 staat, betekent dit dat geen enkele interrupt de code kan onderbreken.
    clr EA     

    ; Watchdogtimer uitschakelen
    ; Waarom? Een watchdogtimer is een timer die bij overlopen een reset zal uitvoeren.
    ; Als je goed kijkt, dan wordt de waarde DEAD ernaar toe geschreven.
    ; WDTCN: WatchDog Timer CoNtrol register
    mov WDTCN, #0DEH 
    mov WDTCN, #0ADH

    ; De Enable interrupts terug aanzetten.
    setb EA

    ; Crossbar aanzetten
    ; Zie datasheet pagina 226. Daar staat dat bit 6, de bit is om de crossbar te enabelen.
    ; Ook vind je daar de SFRPage terecht.
    mov SFRPAGE, #0FH
    mov XBR2, #40H 


    ; P1.6 moet uitschrijfbaar zijn. 
    ; Ieder GPIO-poort beschikt over 2 registers: PxMDOUT en Px 

    ; GPIO-poort configureren als output pin doe je met het PxMDOUT
    ; 1. Zit ik in de juiste SFR-page? (Aflezen op pagina 229)
    ; 2. Pin 6 moet uitvoerbaar zijn: 0100 0000
    mov P1MDOUT, #01000000b

    ; Led aanzetten
    ; Opgelet, poort 1 bit-addressable, maar P1MDOUT niet
    ; P1 is ook aanwezig op alle SFR-pages. (Pagina 228)
    setb P1.6

    ; Ik heb geen idee of dit mag.
    ; jmp $

start: 
    ; Een programma moet altijd eindigen met een oneindige lus.
    jmp start

END