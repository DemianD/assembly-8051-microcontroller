$include (c8051f120.inc)

cseg at 0000h
jmp main

cseg at 0050h

main:
    clr EA
    mov WDTCN, #0DEh
    mov WDTCN, #0ADh
    setb EA

    ;mov SFRPAGE, #0Fh
    ;mov XBR2, #40h

    call verm
    jmp $


verm:
    mov 33H, #00H
    mov 34H, #00H

    mov 30H, #251d
    mov 31H, #254d
    
    mov 32H, #00h

    mov A, 30h

loop:
    clr C
    rrc A
    mov 30H, A

    jnc verder

    ; minst beduidende bytes bij minste beduidende bytes samentellen
    clr C
    mov A, 31h
    add A, 33h
    mov 33h, A

    ; meest beduidende bytes bij meest beduidende bytes samenstellen
    mov A, 32h
    addc A, 34h
    mov 34h, A

verder:
    clr C
    
    mov A, 31h
    rlc A
    mov 31H, A

    mov A, 32H
    rlc A
    mov 32H, A
    
    mov A, 30H

    jnz loop

    ; Hier zetten, zodat het makkelijk debugbaar is
    mov A, 33h
    mov B, 34h

ret