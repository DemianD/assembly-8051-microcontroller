; Sluit vervolgens twee bijkomende displays aan op poorten 1 en 2. Implementeer nu een teller die
; begint bij 0 en eindigt bij 999. Opnieuw gebruik je de drukknop aangesloten op P3.7

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
    mov P1MDOUT, #0FFH ; Alles van poort 1 is uitschrijfbaar
    mov P2MDOUT, #0FFH ; Alles van poort 2 is uitschrijfbaar

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

    ; Drie telregisters bijhouden
    mov R2, #0h ; Voor de meest linkse
    mov R3, #0h ; 
    mov R4, #0h ; Voor de meest rechts

    jmp uitschrijven

start:
    ; Wachten tot op de knop wordt gedrukt
    ; jump if bit not set veroorzaakt hier dus een oneindige lus
    jnb P3.7, $

    inc R4

    cjne R4, #10d, uitschrijven
    mov R4, #0d; We komen hier als R4 gelijk was aan 10
    inc R3

    cjne R3, #10d, uitschrijven
    mov R3, #0d; We komen hier als R3 gelijk was aan 10
    inc R2

    cjne R2, #10d, uitschrijven
    mov R2, #0d; We komen hier als R2 gelijk was aan 10

    ; Als we hier ooit komen, betekent het dat we nu het getal 000 hebben (alles is terug gereset)

uitschrijven:
    ; Voor meest rechtse cijfer
    mov A, #20h
    add A, R4
    mov R0, A
    mov P2, @R0 

    ; Voor middelste cijfer
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