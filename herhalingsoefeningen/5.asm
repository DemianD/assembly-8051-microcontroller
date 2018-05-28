; Idem voor oefening 2 waarbij nu gebruik gemaakt wordt van timers 2 en 3.

; Maak gebruik van twee timers om een  alarmsignaal af te spelen. Om de 250 ms wordt er
; overgeschakeld van een hoge toon (3 KHz) naar een lagere toon (1.5 KHz) of omgekeerd.  Indien
; mogelijk maak je gebruik van een 8‐bit timer met autoreload.

; 250ms
; #klokpulsen = (24,5*10^6/8)*0,250 = 765625

; 3KHz = 3000Hz
; 1/3000 = 0,00033333...
; Omschakeling om de 0,000166667 seconden.
; #klokpulsen = (24,5*10^6/8)*0,000166667 = 510,42

; 1.5KHz = 1500Hz
; 1/1500 = 0,000666667
; Omschakeling om de 0,000333333 seconden.
; #klokpulsen = (24,5*10^6/8)*0,000333333 = 1020,83

; Timer 2 en 3 gebruiken. Deze kunnen beide in auto-reload mode.
; Deze zijn beide 16-bits: 2^16 = 65536

; Timer 2 voor 250ms:
; 765625/12 = 63802,08
; Startwaarde: 65536-63802 = 1734d = 6C6h 

; Timer 3
; We hoeven niet te delen:
; Startwaarde 3KHz: 65536-510 = 65026d = #FE02
; Startwaarde 1.5KHz: 65536-1021 = 64515d = #FC03

cseg at 0000H
    jmp main

cseg at 002BH
    jmp ISR_TIMER2

cseg at 0073H
    jmp ISR_TIMER3

cseg at 0080H

main:
    clr EA
    mov WDTCN, #0DEh
    mov WDTCN, #0ADh
    setb EA

    setb ET2        ; Interupts Timer 2
    mov EIE2, #01b  ; Interupts Timer 3

    mov SFRPAGE, #0Fh
    mov XBR2, #40h
    mov P1MDOUT, #80h


    ; TIMER 3
    mov SFRPAGE, #01h

    ; SYSCLCK door niets gedeeld
    mov TMR3CF, #01000b 

    ; Startwaarden
    mov TMR3H, #0FEh
    mov TMR3L, #02h

    ; Auto reload waarden
    mov RCAP3H, #01h
    mov RCAP3L, #0FEh

    ; Timer 3 starten
    setb TR3


    ; TIMER 2
    mov SFRPAGE, #00h

    ; Delen door 12
    ; mov TMR2CF, #00 ; Standaard wordt al gedeeld door 12

    ; Startwaarden
    mov TMR2H, #06h
    mov TMR2L, #0C6h 

    ; Auto reload waarden
    mov RCAP2H, #06h
    mov RCAP2L, #0C6h 

    ; Timer 2 starten
    setb TR2

    clr P1.7
    clr C

    jmp $

ISR_TIMER2:
    ; Overflow flag not cleared by hardware
    clr TF2

    mov SFRPAGE, #01h

    ; Als de Carry aan staat, hoge pieptoon
    cpl C
    jc hoog

    mov RCAP3H, #0FEh
    mov RCAP3L, #03h

    mov SFRPAGE, #00h
    reti
    
hoog:
    mov RCAP3H, #0FEh
    mov RCAP3L, #02h

    mov SFRPAGE, #00h
    reti

ISR_TIMER3
    ; Overflow flag not cleared by hardware
    mov SFRPAGE, #01h
    clr TF3

    cpl P1.7
    mov SFRPAGE, #00h
    reti
