; Schrijf een programma dat een looplicht verwezenlijkt. Sluit hiervoor de LED‐bar aan op poort 1

$include (c8051f120.inc)

cset at 0000H
    jmp main

cseg at 0050H

main:
    clr EA
    mov WDTCN, #0DEH
    mov WDTCN, #0ADH
    setb EA

    mov SFRPAGE, #0FH
    mov XBR2, #40h

    ; Alle pinnen voor P1 zijn uitvoer pinnen
    mov P1MDOUT, #0FFH

    ; Alle ledjes uitzetten
    mov P1, #0FFH

    ; Het meest links ledje aanzetten
    setb P1.7

start:

    ; Ik heb ervoor gekozen om een looplicht van links naar rechts te lopen. 
    ; Dus zo ---------------->

    mov A, P1

    rr A ; naar rechts roteren.

    mov P1, A

iteraties:
    mov R3, #255d

loop: 
    mov R4, #255d
    djnz R4, $
    djnz R3, loop

    jmp start

; Bij het opstarten, zal meteen het tweede ledje actief zijn.