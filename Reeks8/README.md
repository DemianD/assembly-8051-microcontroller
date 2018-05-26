# Stapel

* push ADRES
* pop ADRES

## Accumulator

* `Acc` is de geheugenlocatie van de accumulator
* `A` heeft geen adres, maar is onderdeel van de CPU.

## Registers

Eerste bytes van het interne geheugen komen overeen met de registers:

* R0 -> 00H
* R1 -> 01H
* R2 -> 02H
* R3 -> 03H
* R4 -> 04H
* R5 -> 05H
* R6 -> 06H
* R7 -> 07H

## Stapel

**push:**

Schrijf nooit waarden naar de stapel, enkel directe adressen.

```
# push #20h > kan niet
# push @R1 > kan niet

# push R0 > kan niet
push 00H #

# push A > kan niet
push Acc

push B
```

**call:**

- Bij een call worden 2 bytes op de stapel geplaatst.
- Bij een ret worden 2 bytes van de stapel gehaalt.

## Stack Pointer

De Stack Pointer (SP-register) wijst altijd naar het laatste element dat op de stapel werd geplaatst. Je mag deze ook niet wijzigen. Stel dat er een interrupt optreedt, kunnen er conflicten optreden.

Om toch bewerkingen te kunnen doen met de Stack kan je gebruik maken van een hulppointer.

```asm
# Hulppointer
mov R0, SP
```

Bij het opstarten van de controller bevat het register SP de waarde 07H, wat betekent dat de eerste vrij plaats (08H) van de stack samenvalt met register R0 van registerbank 1.

Daarom is aangewezen om bij uitvoeren van het programma de stackpointer een andere waarde te geven.

**Stack resetten**

```asm
mov SP, #07h
```