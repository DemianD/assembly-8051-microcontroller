; getal in A vermenigvuldigen met 62 en als high byte register B gebruiken
$include (c8051f120.inc)

cseg at 0000H 
    jmp main

cseg at 0050H
main:
    clr EA
    mov WDTCN, #0DEh
    mov WDTCN, #0ADh
    setb EA

    mov A, #12d            ; A = 1000 1100
    mov R1, #06d           ; A =      0110

    push Acc
loop: 
    clr C

    rlc A                  ; A = 0001 1000 (24) ; C = 1
    push Acc               

    ; Stapel overzicht
    ; 0001 1000
    ; 12d
    ; 07h           

    mov A, B               ; A = 0000 0000      ; C = 1
    rlc A                  ; A = 0000 0001      ; C = 0
    mov B, A               ; B = 0000 0001
    pop Acc                ; A = 0001 1000

    djnz R1, loop          ; R1 = 5

    pop 00h

    subb A, R0
    subb A, R0

    jmp $
