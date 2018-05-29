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

start:
    ; Standaard staat de invoer op 1. Als deze op 1 staat, dan moeten we niets doen (wachten)
    jb P3.7, $  

    ; De gebruiker heeft de knop ingedrukt.
    cpl P1.6    

    ; Nu gaan we wachten tot de gebruiker terug loslaat
    jnb P3.7, $  

    jmp start