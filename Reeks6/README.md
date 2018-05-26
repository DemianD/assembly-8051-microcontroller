#  Gebruik van de onboard temperatuursensor

Het omzetten van een spanning naar een getal, of beter een digitale waarde, gebeurt door een analoog naar digitaal omzetter, afgekort ADC.

Onze microcontroller beschikt over een `12-bit SAR ADC (ADC0)` en over een `8-bit SAR ADC (ADC2)`.

* ADC: Analog to Digital converter
* SAR: Successive Approximation Register (via opeenvolgende benaderingen)


Open de datasheet en lees aandachtig de sectie die handelt over de werking van de verschillende
analoog-naar-digitaal omzetters (pagina 49 en verder). Geef eerst antwoord op onderstaande
vragen:

## Welke analoog-naar-digitaal omzetter moet je gebruiken wanneer je de onboard temperatuursensor wil gebruiken?

Eight of the AMUX channels are available for external measurements while the ninth channel is internally connected
to an on-chip temperature sensor.

## Geef een overzicht van alle registers (naam volstaat) die je hiervoor moet instellen.

- The Channel Selection register AMX0SL: the Temperature Sensor is selected by bits AMX0AD3-0 in register AMX0SL
- The Configuration register AMX0CF

## Op welke manier(en) kun je een omzetting starten?

4 manieren:

1. Writing a ‘1’ to the AD0BUSY bit of ADC0CN; 
2. A Timer 3 overflow (i.e. timed continuous conversions);
3. A rising edge detected on the external ADC convert start signal, CNVSTR0;
4. A Timer 2 overflow (i.e. timed continuous conversions).

### Eerste manier:

- The AD0BUSY bit is set to logic 1 during conversion and restored to logic 0 when conversion is complete.
- The falling edge of AD0BUSY triggers an interrupt (when enabled) and sets the AD0INT interrupt flag (ADC0CN.5)
- Converted data is available in the ADC0 data word MSB and LSB registers, ADC0H, ADC0L

When initiating conversions by writing a ‘1’ to AD0BUSY, the AD0INT bit should be polled to determine when a
conversion has completed (ADC0 interrupts may also be used). The recommended polling procedure is shown below.:

- Step 1. Write a ‘0’ to AD0INT;
- Step 2. Write a ‘1’ to AD0BUSY;
- Step 3. Poll AD0INT for ‘1’;
- Step 4. Process ADC0 data.

## Welke registers (naam volstaat) heb je nodig voor het instellen van de referentiespanning?
## Wat is de waarde, uitgedrukt in Volts, van de referentiespanning?
## Wat is de digitale waarde die met een spanning van 0.842 V overeenstemt? Je mag hierbij veronderstellen dat er wordt gebruikgemaakt van een 12-bit SAR ADC.


Schrijf nu een volledig ASM-programma dat gewoon één conversie start. Bekijk met de debugger de
inhoud van de ADC-registers en ga na met welke temperatuur deze waarde overeenstemt.
Bedenk tot slot een werkwijze om de digitale waarde in de registers van de ADC om te zetten naar
een temperatuur die je kunt afdrukken op drie 7-segmentdisplays (voor de tientallen, eenheden en
tienden).