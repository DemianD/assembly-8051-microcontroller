; Sluit de toetsenbordmodule aan op poort 0. Schrijf een programma dat bij 10 keer indrukken van
; de toets linksboven het LED op P1.6 doet oplichten. 

; Gebruik maken van interrupts
; We maken gebruik van de externe interrupt lijn 1

; Datasheet pagina 147 : External Interrupt 1 (/INT1)
; Om deze interrupt te enabelen, zetten we EX1 op 1
; Wanneer deze interrupt optreedt, zal de code op locatie 0x0013 optreden


$include(8051f120.inc)

cseg at 0000H
    jmp main

cseg at 0013H
    jmp ISR_INT1

; Opgelet, dit moet je dan ook verhogen. (iets hoger dan 13 + 1 instructie)
cseg at 0050H

main: 
    clr EA
    mov WDTCN, #0DEh
    mov WDTCN, #0ADh
    setb EA
    setb EX1 ; External interrupt 1 enable
    
    ; crossbar aanzetten
    mov SFRPAGE, #0Fh
    mov XBR2, #40h

    ; crossbar configureren zodat INT 1 beschikbaar wordt.
    ; Zie figuur pagina 217
    ; Zoek daar naar /INT1. Aan de rechterkant zie je welk bit van de crossbar je moet aanzetten.
    ; Wanneer we dit configureren, brengen we extra functionaliteit via P0.0 naar buiten. (omdat we geen andere instellen)
    mov XBR1, #10000b

    ; Poorten configureren.
    ; Wij willen hebben als we linksboven klikken. Zie Reeks 2 voor toetsenbord.
    ; Dit houdt dan in dat P0.4 als output moet zijn, en P0.0 als invoer.
    mov P0MDOUT, #010000b ; P0.4 als een uitvoerpin,

    mov P1MDOUT, #0FFh    ; P1.6 als uitvoer, rest zijn dont-cares. 

    ; Hier clearen we de waarde van P0.4
    ; Waarom niet P0.0? Wel P0.4 is de uitvoerpin die we kunnen bewerken.
    clr P0.4

    ; Lichtje uitzetten
    clr P1.6

    mov R2, #00h

    ; Oneindige lus
    jmp $

ISR_INT1:
    ; Code op lijn 62 is niet goed, doordat het toestenbord niet ontwikkeld is voor interrupts. 
    ; We moeten er meer tijd tussen steken.
    ; jnb P0.0, $ 

    ; wat meer tijd 
    mov R3, #255d
lus:
    mov R4, #255d
    djnz R4, $
    djnz R3, lus

    ; Jump if bit is not set
    jnb P0.0, ISR_INT1
    
    ; Bij 10 tellen pas het lichtje doen branden.
    inc R2
    cjne R2, #10d, einde
    cpl P1.6
    mov R2, #00d

einde: 
    reti
