# Computerhardware

Elk programma moet eindigen in een oneindige lus:
```
jmp $
```

## Compiler vs Cross Compiler vs Assembler vs Cross Assembler

**Compiler:** Source code als input en maakt een executable file voor je eigen besturingssysteem.

**Cross Compiler:** Source code als input en maakt een executable file voor een ander besturingssysteem.

**Assembler:** Tussenstap voor de Compiler

**Cross Assembler:** Tussenstap voor de Compiler voor een ander besturingssysteem.

## C-code naar Assembly

Er zijn twee dialecten:
- Intel
- Berkley

```bash
gcc -s -masm=Intel file.c
```

## Statisch vs Dynamisch linken

- Bij statisch linken ga je alle libraries mee compileren in je executable. Dan krijg je dus een zeer groot bestand.
- Bij dynamisch linken worden de libraries op het systeem gebruikt. Bestand is veel kleiner.

## Watchdog timer

De watchdog-timer is een timer die automatisch gestart wordt. Deze zal na X-tijd overlopen en een `reset` uitvoeren van het programma. Dit is niet gewenst in de labo's, en daarom gaan we deze uitschakelen.

## Uitvoer pin:

- 1 wegschrijven -> spanning op de lijn zetten: het licht zal branden
- 0 wegschrijven -> spanning van de lijn weghalen: het licht zal doven

## Invoer pin:

Een input pin is altijd 1 tenzij je er door een externe impuls een 0 van maakt, vb. een drukknop.

## Hoeveel bits is er nodig om 64kB te adresseren?

```
64kB = 64*1024 bytes.
= 2^6*2^10
```

## Pointers

Er zijn maar 2 Registers die kunnen dienen als pointers:

- R0
- R1

## Hexadecimaal naar binair:

- 1: 1
- 2: 2
- 3: 3
- 4: 4
- 5: 5
- 6: 6
- 7: 7
- 8: 8
- 9: 9
- A: 10
- B: 11
- C: 12
- D: 13
- E: 14
- F: 15

**ABCDh naar binair:**

- A:  10        ->  8421        -> 1010
- B:  11        ->  8421        -> 1011
- C:  12        ->  8421        -> 1100
- D:  13        ->  8421        -> 1101

Resultaat: `1010 1011 1100 1101`

