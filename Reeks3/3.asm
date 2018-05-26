; Sluit het laatste display aan op poort 3 en implementeer een seconden – en minutenteller. De
; seconden worden afgebeeld op de twee uiterst linkse displays, de minuten op de twee uiterst
; rechtse displays. Gebruik hierbij een timer!

; Ik ga Timer 0 gebruiken
; Zie ook Reeks 1, oef 8 waar ik de berekening uitleg.
; Doordat we per seconde moeten tellen, is de berekening dus hetzelfde.

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
    mov P1MDOUT, #0FFH ; Alles van poort 1 is uitschrijfbaar
    mov P2MDOUT, #0FFH ; Alles van poort 2 is uitschrijfbaar
    mov P3MDOUT, #0FFH ; Alles van poort 2 is uitschrijfbaar

    ; Dit best hier plaatsen na de P1MDOUTS
    mov SFRPAGE, #00H

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

    ; Drie telregisters bijhouden
    mov R2, #0h ; Voor de meest linkse
    mov R3, #0h ; 
    mov R4, #0h ; 
    mov R5, #0h ; Voor de meest rechts

    ; Instellen dat timer 0 als een 16-bit timer werkt
    mov TMOD, #01b

    ; Snelheid waarmee geteld wordt vertragen door te delen door 48
    mov CKCON, #10b

    ; Resetten van huidige waardes
    clr TF0

    ; Timer stoppen
    clr TR0

    ; Startwaarden instellen
    mov TH0, #6H 
    mov TL0, #0C6H

    ; Timer starten
    setb TR0
    
    ; Initieel even uitschrijven
    jmp uitschrijven

start:

    ; Oneindige lus tot de timer overgelopen is
    jnb TF0, $

    ; Timer is overgelopen. We stoppen eerst de timer (dit moet normaal niet)
    ; clr TR0

    ; Resetten van huidige waardes
    clr TF0
    mov TH0, #6H 
    mov TL0, #0C6H

    ; Telregisters verhogen.
    inc R4
    cjne R4, #10d, uitschrijven
    mov R4, #0d; We komen hier als R4 gelijk was aan 10

    inc R3
    cjne R3, #10d, uitschrijven
    mov R3, #0d; We komen hier als R3 gelijk was aan 10

    inc R2
    cjne R2, #10d, uitschrijven
    mov R2, #0d; We komen hier als R2 gelijk was aan 10


uitschrijven:
    ; Voor meest rechtse cijfer
    mov A, #20h
    add A, R5
    mov R0, A
    mov P3, @R0 
    
    ; Voor middelste rechtse cijfer
    mov A, #20h
    add A, R4
    mov R0, A
    mov P2, @R0 

    ; Voor middelste linkse cijfer
    mov A, #20h
    add A, R3
    mov R0, A
    mov P1, @R0 

    ; Voor linkse cijfer
    mov A, #20h
    add A, R2
    mov R0, A
    mov P0, @R0 

    jmp start


; Wat ik nu niet precies weet:
; - Moet je de timer stopzetten vooraleer je weer startwaarde kan invullen? In andere oplossingen zie ik van niet