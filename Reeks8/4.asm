; Onderstaand schema toont een hardware-implementatie van een 8-bit CRC-berekening (cyclic
; redundancy check). Zoals te zien is, wordt er gebruikgemaakt van één 8-bit register en drie XORpoorten.
; Telkens als er aan de linkerzijde een bit binnenschuift, worden alle bits in het 8-bit
; register één positie naar links opgeschoven. Op discrete plaatsen wordt er een XOR-bewerking
; toegepast tussen het door te schuiven bit en het bit dat uit het register vrijkomt. 

; Schrijf een volledig ASM-programma dat alle bits van alle geheugenvakjes gelegen in het gesloten
; interval [20H, 30H] de CRC-8 berekent volgens het gegeven schema. De inhoud van ieder
; geheugenvakje wordt bit per bit in het CRC-register geschoven, te beginnen bij het
; minstsignificante bit. Er wordt dus begonnen bij het minstsignificante bit van 20H en gestopt bij
; het meestsignificante bit van adres 30H. 

; B = CRC-Register
; A = Een volgende byte die je bit per bit in het CRC-register zal plaatsen.

cseg at 0000H
    jmp main

cseg at 0050H

main:
    clr EA
    mov WDTCN, #0DEh
    mov WDTCN, #0ADh
    setb EA

    ; We starten bij adres 20. Deze bevat onze 1ste waarde
    mov R0, #20h

    ; Dit is onze CRC-register. Initieel is hij 0
    mov B, #00h

start:
    ; We laden de eerste waarde in onze accumulator.
    mov A, @R0

    ; We gaan bit per bit moeten werken. 
    mov R1, #08d

loop:
    clr C

    ; Stel dat een Byte 4 bits telde en dit was onze situatie:
    ; B = 1001
    ; A = 0011
    ; C = 0
    ; Wat we willen is dat we het meest rechtse bit van A toevoegen aan B
    ; Eerst rechtse bit van A halen:
    
    rrc A 
    ; B = 1001
    ; A = 0001
    ; C = 1  

    ; We willen dit getal achteraan inschuiven bij B.
    ; Dit kunnen we makkelijk doen door een rlc.
    ; Een rlc kan enkel maar op de A.
    push Acc
    mov A, B
    rlc A

    ; Huidige situatie:
    ; B = 0011      (= momenteel A)
    ; A = 0001      (= staat op de stapel)
    ; C = 1         (= meest linkse bit van B)

    ; Wanneer de RLC klaar is, hebben we 1 bit naar links geschoven die er zeg maar uitvalt.
    ; Wanneer dit uitgevalde bit een 1 is, dan moeten we een XOR doen.
    ; Bij een 0 moeten we echter niets doen.

    jnc verder  

    ; In ons geval is de carry gezet.
    ; Remember: ons B-register zit in A.
    xrl A, #01010001b

    ; Nu hebben we 1 bit verschoven, en zijn we klaar voor de volgende iteratie.

verder:
    mov B, A

    pop Acc

    ; Blijven werken met de volgende byte, tot we alle bits gedaan hebben.
    djnz R1, loop

    ; Alle bits zijn klaar. Een volgende iteratie starten.
    inc R0

    cjne R0, #31h, start

    ; Alle 10 getallen van het interval [20,30] zijn overlopen.
    ; We zijn klaar.

    jmp $