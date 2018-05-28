; Maak gebruik van twee timers om een  alarmsignaal af te spelen. Om de 250 ms wordt er
; overgeschakeld van een hoge toon (3 KHz) naar een lagere toon (1.5 KHz) of omgekeerd.  Indien
; mogelijk maak je gebruik van een 8‐bit timer met autoreload.

; 2 timers nodig:
; 1 voor om de 250ms over te schakelen, en 1 voor de toon te genereren.
; Deze oefening zal nog gebruik maken van Timer 0 en Timer 1

; 250ms
; #klokpulsen = (24,5*10^6/8)*0,250 = 765625
; 
; Dit is te groot voor zowel een 8-bit timer (max 256) als een 16-bit (max 65536) timer, dus delen.
; 765625/4  = 191406,25 (te groot)
; 765625/12 = 63802,08          < Beste 
; 765625/48 = 15950,52

; Dus we delen door 12 en gebruiken een 16-bit timer.
; Startwaarde: 65536-63802 = 1734d   = 6C6h

; 3KHz = 3000Hz
; 1/3000 = 0,00033333...
; Omschakeling om de 0,000166667 seconden.
; #klokpulsen = (24,5*10^6/8)*0,000166667 = 510,42

; Hier kunnen we ook gebruik maken van een 16-bit timer, maar een auto-reload timer is misschien beter.
; Maximum aantal bits: 256
; Doordat we Timer 0 al delen door 12, kunnen we enkel kiezen om niet te delen of ook te delen door 12.
; Wij zullen ook moeten delen door 12.

; 510,42 / 12 = 42,54       
; Startwaarde: 256 - 43 = 213d = D5h

; 1.5KHz = 1500Hz
; 1/1500 = 0,000666667
; Omschakeling om de 0,000333333 seconden.
; #klokpulsen = (24,5*10^6/8)*0,000333333 = 1020,83

; Dit gebruikt dezelfde timer als hierboven, dus ook delen door 12.
; 1020,83 / 12 = 85,07  
; Startwaarde: 256 - 85 = 171d = ABh

cseg at 0000H
    jmp main

cseg at 000BH
    jmp ISR_TIMER0

cseg at 001BH
    jmp ISR_TIMER1

cseg at 0080H

main:
    clr EA  
    mov WDTCN, #0DEh
    mov WDTCN, #0ADh
    setb EA
    
    setb ET0
    setb ET1

    mov SFRPAGE, #0Fh
    mov XBR2, #40h
    mov P1MDOUT, #80h   ; 7-de bit

    mov SFRPAGE, #00h

    clr P1.7
    clr C

    ; Timer Modes instellen
    mov TMOD, #00100001b

    ; Delen door 12 = de standaard
    ; mov CKCON, #00b

    mov TL0, #06h
    mov TH0, #C6h

    ; Starten bij 3Khz
    mov TL1, #D5h
    mov TH1, #D5h

    ; Timers starten
    setb TR0
    setb TR1

    ; Oneindige lus
    jmp $

ISR_TIMER0:
    ; Overflow flag is cleared by hardware
    ; Timer stoppen, opnieuw initialiseren, en starten.
    clr TR0
    mov TL0, #06h
    mov TH0, #C6h
    setb TR0

    ; Als de Carry aan staat, hoge pieptoon
    cpl C
    jc hoog

    mov TL1, #D5h
    mov TH1, #D5h
    reti

hoog:
    mov TL1, #ABh
    mov TH1, #ABh

    reti

ISR_TIMER1:
    ; Overflow flag is cleared by hardware

    cpl P1.7

    reti
