; Schrijf een programma dat het LED op P1.6 doet knipperen. Doe dit m.b.v. vertragingslussen.

$include (c8051f120.inc)

cseg at 0000H
    jmp main

cseg at 0050H

main:
    clr EA

    mov WDTCN, #0DEH
    mov WDTCN, #0ADH

    setb EA

    mov SFRPAGE, #0FH
    mov XBR2, #40h

    ; P1.6 als uitvoer
    mov P1MDOUT, #01000000b

start:
    mov R2,#255d

loop:
    djnz R2, loop

    cpl P1.6

    jmp start

; Of alternatief:
; Niet getest

start:
    mov R2, #255d

loop:
    djnz R2, $ ; Gewoon naar het huidige adres

    cpl P1.6

    jmp start