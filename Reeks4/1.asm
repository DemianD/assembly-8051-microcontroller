; Pas oefening 3 reeks 3 aan zodat er nu gebruikgemaakt wordt van een interrupt.

;  Voor meer info over de locatie van de interruptvectoren verwijzen we naar de datasheet. 
; (meer specifiek, tabel 12.4 op bladzijde 147)
; Sluit het laatste display aan op poort 3 en implementeer een seconden – en minutenteller. De
; seconden worden afgebeeld op de twee uiterst linkse displays, de minuten op de twee uiterst
; rechtse displays. Gebruik hierbij een timer!

; Uit de datasheet: 
; The CPU generates an LCALL to a predetermined address to begin execution of an interrupt service routine (ISR)
; Each ISR must end with an RETI instruction

; Interrupts must first be globally enabled by setting the EA bit
; Then, Each interrupt source can be individually enabled or disabled 

; Some interrupt-pending flags are automatically cleared by the hardware
; Most are not cleared by the hardware and must be cleared by software before returning from the ISR

$include (c8051f120.inc)

cseg at 0000H
    jmp main

cseg at 000BH
    jmp ISR_T0

; Opgepast hier ! Normaal zetten we 0050H
; Maar bovenstaande staat al op 000BH, dus we moeten lager
cset at 0050H

main:
    clr EA
    mov WDTCN, #0DEh
    mov WDTCN, #0ADh
    setb EA
    setb ET0 ; Enable Timer 0 overflow Interrupt. Tijdens de oplossing plaatsen we dat altijd hier

    mov SFRPAGE, #0Fh
    mov XBR2, #40h

    mov P0MDOUT, #0FFH ; Alles van poort 0 is uitschrijfbaar
    mov P1MDOUT, #0FFH ; Alles van poort 1 is uitschrijfbaar
    mov P2MDOUT, #0FFH ; Alles van poort 2 is uitschrijfbaar
    mov P3MDOUT, #0FFH ; Alles van poort 2 is uitschrijfbaar

    ; Dit best hier plaatsen na de P1MDOUTS. Waarom? Omdat P4 enzo enkel beschikbaar is in #0Fh
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

    ; Vier telregisters bijhouden
    mov R2, #0h ; Voor de meest linkse
    mov R3, #0h ; 
    mov R4, #0h ; 
    mov R5, #0h ; Voor de meest rechts

    clr TR0
    ; clr TF0 Deze is niet meer nodig als we interrupts gebruiken (denk ik)

    mov TMOD, #0001b
    mov CKCON, #0010b
    
    ; Startwaarden instellen
    mov TH0, #6H 
    mov TL0, #0C6H


    setb TR0 ; Start (run) the timer

    ; Initieel even uitschrijven
    jmp $

ISR_T0:
    ; Resetten van huidige waardes
    clr TR0
    mov TH0, #6H 
    mov TL0, #0C6H
    setb TR0

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

reti 

; Wat ik niet zeker weet:
; - De setb ET0 