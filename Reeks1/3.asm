; Schrijf een programma dat bij het indrukken van de schakelaar, aangesloten op P3.7, het LED op P1.6 aan‐ of uitschakelt.

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

    mov P1MDOUT, #01000000b

    ; Dit is strikt gezien niet noodzakelijk, want standaard is alles invoer
    mov P3MDOUT, #0h 

    clr P1.6
    clr P3.7

start:
    ; Eerste keer is dit false; P3.7 is leeg als niemand erop klikt
    ; jb = jump if bit set. Hij zal dus niet jumpen en verder gaan met de volgende instructie
    jb P3.7, $  

    ; We gaan nu het lichtje aanzetten (want initieel stond het op 0)
    cpl P1.6    

    ; jnb = jump if bit is not set. 
    ; Maar niemand hoe de schakelaar ingedrukt, dus dit komt in een oneindige lus.
    ; Wanneer we op de schakelaar klikken, gaat hij terug naar start
	jnb P3.7,$  
	jmp start

; Verwacht:
; Bij opstarten zal het ledje branden
; Wanneer je de eerste keer klikt, en je blijft klikken gebeurt er niets tot je loslaat.
 