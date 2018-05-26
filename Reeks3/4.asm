; Implementeer een 24u klok.

; We weten dat 1 minuut 60 seconden is.
; Aantal klokpulsen:
; = (24.5*10^6)/8 * 60
; = 183750000

; Dit is redelijk veel, we kunnen de kloksnelheid waarmee getelt wordt nog eens delen door 48:
; = 3828125
; Dit getal past niet in een 16bit timer :( 
; Of we houden toch 2 extra tel-registers bij, voor de seconden