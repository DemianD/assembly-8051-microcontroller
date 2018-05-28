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
    mov P0MDOUT, #01b

start:
    ; 22H.7 AND P2.3

    ; Stel 22H.7 is:
    ; 1000 0000
    
    ; Dit willen we op de 3de bit krijgen.
    ; rl = 0000 0001
    ; rl = 0000 0010
    ; rl = 0000 0100
    ; rl = 0000 1000

    mov A, 22H
    rl A
    rl A
    rl A
    rl A

    ; Stel A:
    ; A     : 0000 1000
    ; P2.3  : 1100 0011

    anl A, P2       ; A = 0000 0000
    cpl A           ; A = 1111 1111

    push Acc

    ; F0 (PSW.5) OR P7.1

    mov A, P7   
    rl A
    rl A
    rl A
    rl A

    orl A, PSW 
    pop B   

    ; B = 3de byte
    ; A = 5de byte
    rr A
    rr A

    ; 3de byte met 3de byte vergelijken
    anl A, B

    mov C, Acc.3

    jmp start

