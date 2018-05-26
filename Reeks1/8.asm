; NIET GETEST: 

; Schrijf een programma dat de LED op P1.6 doet knipperen met een frequentie van 0.5Hz (1s aan
; en 1s uit). Gebruik hiervoor een timer!

; Wat weten we:
; 0.5Hz = 2 seconden. 

; Zie ook even cursus pagina 54

; Aantal klokpulsen:
; = (24.5*10^6)/8 * het aantalseconden
; = (24.5*10^6)/8 * 1
; = 3062500

; Een 16 bit timer kan maar 2^16 pulsen tellen. (65536)
; Echter kunnen we via CKCON de snelheid waarmee getelt wordt beïnvloeden door bijvoorbeeld te delen door 48

; Indien we 3062500 delen door 48, dan bekomen we afgerond 63802 klokpulsen
; Dit kunnen we nog net realiseren met een 16bit timer.

; We weten wanneer we aan 1 seconde zitten als de timer overloopt.
; De timer zal maar pas overlopen bij 65536.

; Oplossing, we trekken 63802 van 65536 af, en dat is onze startwaarde:
; 65536 - 63802 = 1734

; 1734 decimaal = 6C6 Hexadecimaal

; Ik zal gebruik maken van timer 0

$include (c8051f120.inc)

cseg at 0000H
    jmp main

cset at 0050H

main:
    clr EA
    mov WDTCN, #0DEH
    mov WDTCN, #0ADH
    setb EA

    mov SFRPAGE, #0FH
    mov XBR2, #40h

    mov P1MDOUT, #01000000b

    ; Eerste stap: Timer 0 instellen als een timer 
    ; Dit doen we via het register TMOD

    ; GATE0: hebben we niet nodig, dus dat laten we op 0.
    ; C/T0: 0 betekent op timer, dus dit zetten we op 0
    ; T0M1 en T0M0: We hebben een 16 bit timer nodig, dus we zetten M1 op 0 en M0 op 1

    ; Resultaat: 0000 0001

    ; Opgelet: dit zou #00H moeten zijn in plaats van #0H. 
    ; VERGEET ZEKER NIET UW SFRPAGE AAN TE PASSEN
    mov SFRPAGE, #00H
    mov TMOD, #01H

    ; We willen de systeemklok delen door 48.
    ; Dit doen we door SCA1 op 1 te plaatsen, en SCA0 op 0 te plaatsen
    mov CKCON, #02H
    
    ; Timer Control Registers;
    ; Deze zijn bit addressable (pagina 289)

    clr TR0 ; TCON.4 = Als deze waarde op 1 komt, zal het tellen beginnen. 
    clr TF0 ; TCON.5 = Als deze bit geset wordt, betekent het dat de timer overgelopen is.

    ; Starwaarden instellen
    ; Dit doen we in TH0 en TL0 (Timer High, en Timer Low)

    ; 6C6 bestaat uit 2 bytes: 
    ; = 0000 0110  1100 0110
    ; = 6H         C6H
    ; Of je leidt het gewoon af uit 6C6 (gewoon rechtste 2 getalletjes, en linkse twee)
    mov TH0, #6H 
    mov TL0, #0C6H

    setb TR0 ; De timer starten

start:
    ; We gaan een oneindige lus creeëren zolang de timer overflow flag niet is ingestelt
    jnb TF0, $

    ; Komen we hier, dan is de Timer Overflow flag gezet
    cpl P1.6

    ; Timer stoppen
    clr TR0

    ; Overflow clearen
    clr TF0

    ; Standaardwaarden terug zetten
    mov TH0, #6H 
    mov TL0, #0C6H

    ; Timer terug starten
    setb TR0
    
    ; Terug alles herhalen
    jmp start
