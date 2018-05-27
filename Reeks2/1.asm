; Toetsenbord

; Sluit de toetsenbordmodule aan op poort 0 en schrijf een programma dat zorgt voor het scannen
; van het toetsenbord. Wanneer een toets ingedrukt wordt, wordt de bijhorende binaire waarde
; op de LED‐bar, aangesloten op poort 1, getoond. Onderstaande figuur geeft aan hoe het
; toetsenbord is opgebouwd:

$include (c8051f120.inc)

cseg at 0000H
    jmp main

cseg at 0050H

main:
    clr EA
    mov WDTCN, #0DEh
    mov WDTCN, #0ADh
    setb EA

    mov SFRPAGE, #0Fh
    mov XBR2, #40h

    mov P1MDOUT, #0FFh
    mov P0MDOUT, #11110000b ; 4567 zijn uitvoer pinnen, 0123 zijn invoer pinnen

start:
    ; Afscannen
    ; Letterlijk 1 voor 1 gaan afscannen.

    ; We starten met alle uitvoerpinnen aan te zetten
    mov P0, #0F0h ; 

    ; 0 en 0 => Ingedrukt
    clr P0.4
    jnb P0.0, _0
    jnb P0.1, _4
    jnb P0.2, _8
    jnb P0.3, _C
    setb P0.4

    clr P0.5
    jnb P0.0, _1
    jnb P0.1, _5
    jnb P0.2, _9
    jnb P0.3, _D
    setb P0.5

    clr P0.6
    jnb P0.0, _2
    jnb P0.1, _6
    jnb P0.2, _A
    jnb P0.3, _E
    setb P0.5

    clr P0.7
    jnb P0.0, _3
    jnb P0.1, _7
    jnb P0.2, _B
    jnb P0.3, _F
    setb P0.5

    jmp start


_0:
    ;toon een 0
    jmp start
_1:
    ;toon een 1
    jmp start
_2:
    ;toon een 3
    jmp start
_4:
    ;toon een 4
    jmp start
_5:
    ;toon een 6
    jmp start
_6:
    ;toon een 6
    jmp start
_7:
    ;toon een 7
    jmp start
_8:
    jmp start
    ;toon een 8
_9:
    ;toon een 9
    jmp start
_A:
    ;toon een A
    jmp start
_B:
    ;toon een B
    jmp start
_C:
    ;toon een C
    jmp start
_D:
    ;toon een D
    jmp start
_E:
    ;toon een E
    jmp start
_F:
    ;toon een F
    jmp start

