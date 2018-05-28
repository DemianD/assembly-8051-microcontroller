; 22H.7     = Bit adressable (p127, 12.2.4)
; P2.3      = Bit adressable (p229)                 ALL PAGES
; P7.1      = Bit adressable (p236)                 SFRPAGE F
; F0        = B-register = Bit adressable (p145)    
    
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
    mov P0MDOUT, #01b

start:
    ; NAND van P2.3 en 22H.7
    mov C, P2.3
    anl C, 22H.7
    cpl C

    ; F1 is een vlaggetje die we gebruiken.
    ; Echter kunnen we enkel op C bitbewerkingen doen.
    mov F1, C

    ; OR van P7.1, F0
    mov C, P7.1
    orl C, F0

    ; AND van C en F1
    anl C, F1

    mov P0.0, C

    jmp start
