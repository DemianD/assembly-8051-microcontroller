; C-Programma

;    void geefLaatste(int *tab, int n, int *l){
;       *l = tab[n-1];
;    }
;
;    int main(){
;       int t[] = {1,2,3}; //30H
;       int laatste; //40H
;       geefLaatste(t,3,&laatste);
;       while(1);
;       return 0;
;    }

cseg at 0000H
    jmp main

cseg at 0050H

main:
    clr EA
    mov WDTCN, #0DEH
    mov WDTCN, #0ADH
    setb EA

    mov 30H, #1d
    mov 31H, #2d
    mov 32H, #3d

    ; Begin van de array meegeven.
    mov R0, #30H
    push 00H

        ; Stack overzicht
        ; 30H       < SP     
        ; 07H

    ; Aantal elementen in de array
    mov R0, #3d
    push 00H

        ; Stack overzicht
        ;  3d       < SP
        ; 30H           
        ; 07H

    ; Adres meegeven naar waar het resultaat moet geschreven worden
    mov R0, #40h
    push 00H

        ; Stack overzicht
        ; 40h       < SP
        ;  3d       
        ; 30H           
        ; 07H

    call geef_laatste

    ; Resetten
    mov SP, #007h

    jmp $

geef_laatste:
        push 00H
        mov R0, SP
        ; Stack overzicht
        ; 40h       < SP < R0
        ; PC        
        ;
        ; 40h
        ;  3d       
        ; 30H           
        ; 07H    

        dec R0
        dec R0
        dec R0

        ; Stack overzicht
        ; 40h       < SP 
        ; PC        
        ;           
        ; 40h       < R0
        ;  3d       
        ; 30H           
        ; 07H    

        push 01H        ; R1
        mov R1, @R0     ; R1 bevat nu de waarde #40h

        ; Stack overzicht
        ; 01H       < SP
        ; 40h       
        ; PC        
        ;           
        ; 40h       < R0
        ;  3d       
        ; 30H           
        ; 07H    

        dec R0
        push 02H        ; R2

        ; Stack overzicht
        ; 02H       < SP
        ; 01H       
        ; 40h       
        ; PC        
        ;           
        ; 40h       
        ;  3d       < R0
        ; 30H           
        ; 07H    

        mov R2, @R0     ; R2 bevat nu de waarde 3d

        dec R0

        ; Stack overzicht
        ; 02H       < SP
        ; 01H       
        ; 40h       
        ; PC        
        ;           
        ; 40h       
        ;  3d       
        ; 30H       < R0    
        ; 07H    

        ; R0 wijst nu naar het eerste adres van de array.
        mov A, @R0      ; A bevat nu de waarde 30h

        dec R2          ; R2 bevat nu de waarde 2
        add A, R2       ; A bevat nu 32h

        mov R0, A       ; R0 bevat nu de waarde 32h
        mov A, @R0      ; A bevat nu de waarde die zich op adres 32h bevindt

        mov @R1, A      ; Op het adres van 40H, schrijven we de waarde van de A

        ; Stack overzicht
        ; 02H       < SP
        ; 01H       
        ; 00H       
        ; PC        
        ;           
        ; 40h       
        ;  3d       
        ; 30H       < R0    
        ; 07H    

        pop, 02H        
        pop, 01H        
        pop, 00H      

        ; Stack overzicht
        ; PC        < SP 
        ;           
        ; 40h       
        ;  3d       
        ; 30H       < R0    
        ; 07H    

        ret  