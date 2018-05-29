; Herschrijf de subroutine uit vraag 1 maar zonder de MUL-instructie te gebruiken en zonder
; gebruik te maken van MAC0. Zoek eerst een gepast algoritme om twee 8-bit getallen te
; vermenigvuldigen. De uitvoer moet zich opnieuw in de accumulator(LSB) en het B-register(MSB)
; bevinden.

; 16-bit getallen

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

    ; Met 16 bit vermenigvuldiging:
    ; 16*16 bit = 32bit
    ; Ofwel 4 bytes nodig voor het resultaat.
    mov 30H, #00H   ; LSB
    mov 31H, #00H   ;
    mov 32H, #00H   ;
    mov 33H, #00H   ; MSB

    ; Multiplier (2 bytes) 
    mov 34H, #251d  ; LSB
    mov 35H, #251d  ; MSB

    ; Multiplicator (2 bytes)
    mov 36H, #254d  ; LSB
    mov 37H, #254d  ; MSB

    ; Extra registers voor op te schuiven (om dan op te tellen)
    mov 38H, #00h   ; LSB
    mov 39H, #00h   ; MSB

    ;  35H 34H      (multiplier)
    ;  37H 36H      (Multiplicator)
    ;* -------

    call verm

    jmp $

; Normaal zou je hier ook nog even uw Acc, Cy, ... enzo moeten pushen en poppen op de stapel
; Zodat de subroutine hier niets van wijzigt.
verm:   
    clr C

    ; Naar rechts schuiven van Multiplicator.
    mov A, 37H
    rrc A
    mov 37h, A

    mov A, 36H
    rrc A
    mov 36h, A
    
    jnc verder 

    clr C

    ; optelllen

    mov A, 30H
    add A, 34H
    mov 30H, A

    mov A, 31H
    addc A, 35H
    mov 31H, A

    mov A, 32H
    addc A, 38H
    mov 32H, A

    mov A, 33H
    addc A, 39H
    mov 33H, A

verder:
    clr C

    mov A, 34H
    rlc A
    mov 34H, A

    mov A, 35H
    rlc A
    mov 35H, A

    mov A, 38H
    rlc A
    mov 38H, A
    
    mov A, 39H
    rlc A
    mov 39H, A

    ; Kijken of 37H en 36H (als je een OR doet, en er staan nog 1tje dan is het niet leeg)
    mov A, 36h
    orl A, 37h

    jnz verm

    ; Als je hier komt, is het berekent, en zit het resultaat in volgende adressen:
    ; 30H  LSB
    ; 31H 
    ; 32H 
    ; 33H  MSB

   ret