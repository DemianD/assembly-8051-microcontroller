; Schrijf nu een volledig ASM-programma dat gewoon één conversie start. Bekijk met de debugger de
; inhoud van de ADC-registers en ga na met welke temperatuur deze waarde overeenstemt.
; Bedenk tot slot een werkwijze om de digitale waarde in de registers van de ADC om te zetten naar
; een temperatuur die je kunt afdrukken op drie 7-segmentdisplays (voor de tientallen, eenheden en
; tienden).

; AMUX input pairs can be programmed to operate in either differential or single-ended mode.
; The AMUX defaults to all single-ended inputs upon reset

; Differentiaal is beter. Waarom?
; Als er ruis optreedt zullen beide signalen verstoord raken op ongeveer dezelfde plaats. 
; Aangezien het verschil genomen wordt tussen de twee zal de fout weggewerkt worden.

; AMX0SL: om de channel te selecteren.
; AMX0CF: configuratie register

; When the ADC0 input configuration is changed a minimum tracking time is required 
; before an accurate conversion can be performed. ~ 200ms


$include(8051f120.inc)

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

    mov P0MDOUT, #0FFh       
    mov P1MDOUT, #0FFh
    mov P2MDOUT, #0FFh

    mov P1, #00H
    mov P2, #00H
    mov P3, #00H

    mov SFRPAGE, #00h

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


    ; The voltage reference used by ADC0 is selected as described in VOLTAGE REFERENCE ...
    ; The Reference Control Register, REF0CN enables/disables the internal reference generator
    ; and selects the reference inputs for ADC0 and ADC2.

    mov REF0CN, #0111b
    ; -  TEMPE: Temperature Sensor Enable Bit
    ; -  BIASE: ADC/DAC Bias Generator Enable Bit. (Must be ‘1’ if using ADC or DAC)
    ; -  REFBE: Internal Reference Buffer Enable Bit

    ; VREF Turn-on Time 1: 2 ms (zie pagina 108)
    ; Vandaard deze lus om minstens 2ms te wachten
    mov R2, #255d;

loop:
    mov R3, #255d
    djnz R3, $
    djnz R2, loop

    mov AMX0CF, #00H ; alles single-ended inputs
    mov AMX0SL, #09H ; channel 9

    ; The ADC0 subsystem (ADC0, trackand-hold and PGA0) is enabled only 
    ; when the AD0EN bit in the ADC0 Control register (ADC0CN) is set to logic 1.
    ; The ADC0 subsystem is in low power shutdown when this bit is logic 0.

    ; AD0EN: ADC0 Enable Bit
    ; 0: ADC0 Disabled. ADC0 is in low-power shutdown.
    ; 1: ADC0 Enabled. ADC0 is active and ready for data conversions.
    setb AD0EN

start:
    ; Starting a Conversion:

    ; Step 1. Write a ‘0’ to AD0INT;
    ; Step 2. Write a ‘1’ to AD0BUSY;
    ; Step 3. Poll AD0INT for ‘1’;
    ; Step 4. Process ADC0 data.

    clr AD0INT      ; Step 1
    setb AD0BUSY    ; Step 2
    jnb AD0INT, $   ; Step 3

    ; Step 4. Process ADC0 data.

	; Vref = 2,43       ; Pagina 108

    ; Vtemp = digitale waarde / 4096 * Vref  ; Geen idee hoe ze hieraan komen
    ; temp = (Vtemp - O,776) / 0.00286       ; Formule van Pagina 50 omgevormt
    ; vb. (1450 / 4096 * 2,43) - 0,776) / 0,00286 = 29,45

    ; Interpoleren
    
    ; Vtemp           = digitale waarde / 4096 * Vref
    ; temp            = (Vtemp) - 0,776) / 0,00286
    ; Digitale waarde = (temp * 0,00286 + 0,776) / Vref * 4096 

    ; Vb. 15 graden naar digitaal: 1380,34 ~ 564H
    ; Vb. 564H digitale waarde naar temp: 14,93

    ; Wat zal er gebeuren als de digitale waarde stijgt met 1H ? Dus 565
    ; Vb. 565H digitale waarde naar temp: 15,13

    ; Plaats dit eens in een interval:
    ; [14,93..., 15,13[	-> 564	(een verschil van ongeveer 0,2 (15,13-14,93))

    ; Na conversie vinden we de minst significante 8 bits in het register ADC0L
    ; 15 is onze basistemperatuur.
    ; ADC0L is een digitale waarde.

    ; Laten we stellen dat ADC0 = 566 (nog zonder rekening te houden met low bytes of high bytes)
    ; Dan zouden we verwachten dat de temperatuur 15,33 is (14,93 + (ADC0 - 564) *0,2)

    ; We kunnen geen komma getallen gebruiken:
    ; (15,00 + (ADCL - 564) * 0,2)

    ; 564 is groter dan een 8 bit getal.
    ; 564: 0000 0101 0110 0100
    ;  64: 0000 0000 0110 0100
    ; We nemen de minst 8 significate bits
    ; Ook van 566 nemen we de minst significante bits. Dit doen we door ADC0L te gebruiken.
    ; (15,00 + (ADC0L - 64) * 0,2)

    ; *0,2 is hetzelfde als delen door 5
    ; (15,00 + (ADC0L - 64) / 5)

    mov A, ADC0L            ; 66H               (minst significaten bits nemen)
    subb A, #64H            ; 66H - 64H = 2H
    mov B, #5d              

    ; div A B (A = deeltal, B = deler => na instructie uitgevoerd is, A => quotient, B = rest)
    div AB                  ; A = 0, B = 2

    ; Euclidische deling;
    ; Onze rest = 2. We doen dit eens maal 10.
    ; Dan delen we dit terug door 5. (20/5 => 4) 
    ; Maar maal 10 / 5 is hetzelfde als maal 2, dat op te lossen valt met een bit shifting naar links
    push Acc
    mov A, B                ; A = 2H
    rl A                    ; A = 4H

    mov R6, A               ; R6 = 4H
    pop Acc                 ; A = 0

    add A, #15d             ; A = Fh

    ; Nu hebben we een getal met 2 cijfers, die twee willen we gaan opsplitsen
    mov B, #10d             ; B = Ah
    div AB                  ; A = 1 ; B = 5

    mov R5, B   ;   R5 = eenheden
    mov R4, A   ;   R4 = tientallen

uitschrijven:
	mov A, #20H
	add A, R4	
	mov R0,    	
	mov P0, @R0	

	mov A, #20H
	add A, R5
	mov R0, A	
	mov P1, @R0

	mov A, #20H
	add A, R6
	mov R0, A	
	mov P2, @R0

	jmp start