; Schrijf een programma dat wanneer de gebruiker op de drukknop op P3.7 drukt, het LED op P1.6
; eenmaal doet knipperen. Wanneer er een tweede maal gedrukt wordt, knippert het LED 2 maal.
; Enz.

$include (c8051f120.inc)

cseg at 0000H
    jmp main

cset at 0050H

main:
    clr EA

    mov WDTCN, #0DEH
    mov WDTCN, #0ADH

    setb EA

    mov SFRPAGE, #0FH
    mov XBR2, #40h


    mov P1MDOUT, #01000000b
    mov P3MDOUT, #0h 

    ; Een telregister bijhouden
    mov R2, #0h

    ; Registers die dienen voor de loop
    mov R3, #255d
    mov R4, #255d

start:
    ; Wachten tot knop wordt ingedrukt (Volgens mij moeten deze comments omgekeerd zijn)
    jb P3.7, $

    ; Wachten tot knop wordt losgelaten (Volgens mij moeten deze comments omgekeerd zijn)
    jnb P3.7, $

    ; We komen hier als er wel iemand op de schakelaar heeft geklikt.
    ; We verhogen de waarde van het aantal keren dat we moeten flikkeren met 1
    inc R2 ; Een keer aan
    inc R2 ; Een keer uit

    ; We nemen een kopie van deze waarde
    mov A, R2

loop1: 
    mov R3, #255d

loop2:
    mov R4, #255d
	
    djnz R4, $      ; Wachten tot de binnenste loop op 0 staat
	djnz R3, loop2  ; Daarna gaan we terug naar loop 2, dit doen we 255 keer

    ; Als we hier komen is de vertragingslus gepasseerd.
    ; Nu toggelen we het lichtje
    cpl P1.6

    djnz A, loop1

    ; A zal nu op 0 staan. Dit betekent dat we terug kunnen naar start omdat we X keer geflikkerd hebben.
    jmp start

; Verwacht:
; - Bij opstarten zal hij meteen vastzitten bij regel 39
; - Als we daarna klikken, en blijven inhouden zal het flikkeren wel gebeuren en zullen we belanden bij lijn 36