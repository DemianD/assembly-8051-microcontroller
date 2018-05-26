; Sluit het uiterst linkse display aan op poort 0 en implementeer vervolgens een teller die begint te
; tellen vanaf 0 en bij het indrukken van de drukknop aangesloten op P3.7 de tellerwaarde
; incrementeert. Van zodra de waarde 9 bereikt wordt, herbegint het tellen vanaf 0.

; Dit is dus nog zonder timer

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

    mov P0MDOUT, #0FFH ; Alles van poort 0 is uitschrijfbaar
    mov P3MDOUT, #80h  ; P3.7 dient als invoer. Dit moet eigenlijk niet, doordat alles standaard invoer is.

    mov 20h, #0111111b ; Bitpatroon voor 0
    mov 21h, #0000110b ; Bitpatroon voor 1
    mov 22h, #1011011b ; Bitpatroon voor 2
    mov 23h, #1001111b ; Bitpatroon voor 3
    mov 24H, #1100110b ; bitpatroon voor 4
	mov 25H, #1101101b ; bitpatroon voor 5
	mov 26H, #1111101b ; bitpatroon voor 6
	mov 27H, #0000111b ; bitpatroon voor 7	
    mov 28H, #1111111b ; bitpatroon voor 8
	mov 29H, #1101111b ; bitpatroon voor 9

    ; Een telregister bijhouden
    mov R2, #0h

    jmp uitschrijven

start:
    ; Wachten tot op de knop wordt gedrukt
    ; jump if bit not set veroorzaakt hier dus een oneindige lus
    jnb P3.7, $

    inc R2

    cjne R2, #10d, uitschrijven

    mov R2, #0h


uitschrijven:
    ; Basisadres
    mov A, #20h

    ; Op het basisadres tellen we het cijfer (dit kan 0, 1, 2, 3, 4, ... 9 zijn)
    add A, R2

    ; Wat mag niet:
    ; Als je dit doet, dan ga je niet het bitpatroon wegschrijven,
    ; maar ga je vb 20, 21, 22, 23, ... wegschrijven.
    ; Wij willen de inhoud dat zich op het adres 20, 21, 23, wegschrijven
    ; mov P0, A

    ; Dit doen we via pointers
    ; 20hexadecimaal in R0 steken
    mov R0, A

    ; Via indirecte adressering de inhoud van het adres dat zich in regster 0 bevindt naar P0 schrijven
    mov P0, @R0 

    jmp start
