; Schrijf een programma dat bij het indrukken van de drukknop, aangesloten op P3.7, het looplicht
; in tegengestelde zin doet lopen.

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

    mov P1MDOUT, #0FFH ; Alles van Pin 1 is uitvoer
    mov P3MDOUT, #0H   ; Alles van Pin 3 is invoer, dit moet niet expliciet want standaard is het invoer

    ; Alle ledjes uitzetten
    mov P1, #0FFH

    ; Minstens 1 ledje aan
    mov A, #10000000b


start:
    mov P1, A

    ; Wanneer de drukknop is ingedrukt (waarde 0), dan gaan we de Carry gaan toggelen
    jnb P3.7, toggle

    jb C, links ; Als de carry aanstaat, dan gaan we naar links roteren

    ; Als de carry niet aanstaat, dan gaan we naar rechts roteren
    ; Hier hebben we eigenlijk geen jump voor nodig.
    ; We zouden even goed een rr A kunnen schrijven, en dan komt hij vanzelf bij iteraties terecht
    jnb C, rechts

iteraties:
    mov R3, #255d

loop: 
    mov R4, #255d
    djnz R4, $
    djnz R3, loop

    jmp start

links:
    rl A

    jmp iteraties

rechts:
    rr A

    jmp iteraties

toggle:
    cpl C

    jmp start