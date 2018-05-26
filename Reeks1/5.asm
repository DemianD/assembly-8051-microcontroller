; Sluit de LED‐bar aan op digitale I/O‐poort 1 en schrijf een programma dat alle LED’s doet
; knipperen

$include (c8051f120.inc)

cseg at 0000H
    jmp main

cset at 0050H

main:
    clr EA

    mov WDTCN, #0DEh
    mov WDTCN, #0ADh

    setb EA

    mov SFRPAGE, #0FH
    mov XBR2, #40h

    mov P1MDOUT, #0FFH

    ; Alle Led's doet knipperen.
    ; Moet dit willekeurig zijn? Dat weet ik niet zeker.
    ; Er zal sowieso een vertragingslus nodig zijn, ik gok op een dubbele.

start:
    ; Dit kan niet:
    ; cpl P1

    ; Wat wel kan is eerst de waarde naar de Accumulator plaatsen, en dan een volledig complement nemen
    mov A, P1
    cpl A

    mov P1, A

    ; Een dubbele vertragingslus
loop1:
    mov R3, #255d

loop2:
    mov R4, #255d

    djnz R4, $
    djnz R3, loop2

    jmp start

; Verwacht:
; - De ledjes springen meteen aan