; Schrijf een eerste subroutine voor het bepalen van het product van twee getallen. De twee
; getallen worden voor het aanroepen van de subroutine op de stapel geplaatst. Bij deze oefening
; mag je gebruikmaken van de MUL-instructie. De uitvoer van de subroutine bevindt zich in de
; accu(LSB) en in het B-register(MSB).

; Mul AB
; De instructie mul zal de inhoud van de accumualtor vermenigvuldigen met de inhoud van het B-register.
; Het resultaat, dat uit 2 bytes bestaat wordt terug in A (minst beduidende bytes) 
; en B (meeste beduidende bytes) geschreven. 

; R1 en R2 gebruiken als operanden

cseg at 0000H
    jmp main

cseg at 0050H

main:
    clr EA
    mov WDTCN, #DEh
    mov WDTCN, #ADh
    setb EA

    mov R1, #4d
    mov R2, #2d

    ; R1*R2 moet 8d opleveren (=8H)

    push 01H; push R1
    push 02H; push R2

    ; Stack overzicht
    ; 02H       < SP
    ; 01H       
    ; 07H

    call verm

    ; Stack overzicht 
    ; 02H        < SP
    ; 01H        
    ; 07H

    ; Terug zetten op het begin adres = resetten
    mov SP, #07h

    ; Stack overzicht 
    ; 02H        
    ; 01H        
    ; 07H       < SP

    jmp $

verm:
    ; Stack overzicht
    ; PC         < SP
    ;
    ; 02H       
    ; 01H       
    ; 07H

    push 00h ; push R0
    ; Stack overzicht
    ; 00H        < SP
    ; PC         
    ;
    ; 02H       
    ; 01H       
    ; 07H

    mov R0, SP
    ; Stack overzicht
    ; 00H        < SP < R0
    ; PC         
    ;
    ; 02H       
    ; 01H       
    ; 07H

    dec R0
    dec R0
    dec R0

    ; Stack overzicht
    ; 00H        < SP 
    ; PC         
    ;            
    ; 02H        < R0
    ; 01H       
    ; 07H

    mov A, @R0  
    dec R0

    ; Stack overzicht
    ; 00H        < SP 
    ; PC         
    ;            
    ; 02H        
    ; 01H        < R0
    ; 07H

    mov B, @R0  

    mul AB

    ; 00H        < SP 
    ; PC         
    ;            
    ; 02H        
    ; 01H        < R0
    ; 07H

    pop 00H     ; De oorsprongkelijke waarde terug in R0 steken

    ; PC         < SP 
    ;            
    ; 02H        
    ; 01H        
    ; 07H

    ret
