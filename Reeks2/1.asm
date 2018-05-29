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
    jmp wacht_0
_1:
    ;toon een 1
    jmp wacht_0
_2:
    ;toon een 2
    jmp wacht_0
_3:
    ;toon een 3
    jmp wacht_0
_4:
    ;toon een 4
    jmp wacht_1
_5:
    ;toon een 6
    jmp wacht_1
_6:
    ;toon een 6
    jmp wacht_1
_7:
    ;toon een 7
    jmp wacht_1
_8:
    ;toon een 8
    jmp wacht_2
_9:
    ;toon een 9
    jmp wacht_2
_A:
    ;toon een A
    jmp wacht_2
_B:
    ;toon een B
    jmp wacht_2
_C:
    ;toon een C
    jmp wacht_3
_D:
    ;toon een D
    jmp wacht_3
_E:
    ;toon een E
    jmp wacht_3
_F:
    ;toon een F
    jmp wacht_3

wacht_0:
    mov R3, #255d
loop_0:
    mov R4, #255d
    djnz R4, $
    djnz R3, loop_0

    jnb P0.0, wacht_0
    jmp start

wacht_1:
    mov R3, #255d
loop_1:
    mov R4, #255d
    djnz R4, $
    djnz R3, loop_1

    jnb P0.1, wacht_1
    jmp start

wacht_2:
    mov R3, #255d
loop_2:
    mov R4, #255d
    djnz R4, $
    djnz R3, loop_2

    jnb P0.2, wacht_2
    jmp start

wacht_3:
    mov R3, #255d
loop_3:
    mov R4, #255d
    djnz R4, $
    djnz R3, loop_3

    jnb P0.3, wacht_3
    jmp start