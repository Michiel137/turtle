# Turtle Robot

Een rijdende robot gemaakt met 3D prints, goedkope onderdelen en geprogrammeerd in MicroPython.

Alle bestanden, inclusief deze beschrijving zijn op GitHub te vinden: https://github.com/Michiel137/turtle

## Start

De robot bevat alle bestanden die je nodig hebt, maar hij moet nog wel geconfigureerd worden om hem via WiFi te kunnen programmeren.

1. Sluit de robot met een USB kabel aan op de computer
1. Installeer de ontwikkelomgiving voor MicroPython: [Thonny](https://thonny.org/).
1. Open Thonny. Kies "Standard" voor "Initial Settings"
1. Klik rechtsonderin de statusbalk om de interpreter te configureren
1. Kies "MicroPython (Raspberry Pi Pico)" voor de interpreter
1. Kies "Board in FS mode @ COM..." voor de poort
1. Onderin de shell zie je nu een Python prompt. Je kan hier Python commando's uitvoeren
1. Open in Thonny het bestand boot.py van de robot: Bestand -> Open -> Raspberry Pi Pico -> boot.py
1. Haal van de laatste regel in het bestand de "#" weg en vervang \<SSID\> en \<PASSWORD\> met de WiFi netwerknaam en het WiFi wachtwoord
1. Sla het bestand op: Bestand -> Opslaan
1. Herstart de robot door op het Stop icoon te klikken (of Uitvoeren -> Stoppen/Opnieuw starten backend)
1. De robot maakt nu verbinding met het WiFi netwerk
1. In het shell scherm wordt het adres van de robot geprint achter "WebREPL server started on". Kopieer dit adres
1. Klik rechtsonderin de statusbalk om de interpreter te configureren: Selecteer "Configureren interpreter"
1. Vul bij "Port or WebREPL" het adres van de robot in, maar vervang "http://" door "ws://"
1. Vul voor het wachtwoord "geheim" in
1. OK
1. Thonny maakt nu verbinding via WiFi. De USB kabel is niet meer nodig
1. Op de robot staan een aantal scripts die je uit kan proberen: Bestand -> Open -> Raspberry Pi Pico
    - blink.py - klipper met de leds
    - noise.py - maak geluid
    - collision.py - rij rond en probeer botsingen te voorkomen
    - square.py - teken een vierkant
1. Nadat je het script geopend hebt kan je het met F5 uitvoeren (of Uitvoeren -> Voer huidige script uit)
1. Sommige scripts hebben geen einde. Je kan het script stoppen met Ctrl-C (of Uitvoeren -> Onderbreek uitvoering)
1. Probeer de scripts uit en pas ze aan!
1. Als je een idee hebt en een nieuw script wil maken, maak dan een nieuw bestand: Bestand -> Nieuw
    - Bestanden hoeven niet op de robot te staan om ze uit te voeren: Bestand -> Opslaan -> Deze computer
    - Het is een goed idee om voor een nieuw script te beginnen met een kopie van een bestaand script
    - als je een fout in het script hebt gemaakt wordt dat in het shell scherm getoond als je het script uitvoerd

## Problemen Oplossen

1. Zijn de batterijen leeg?
1. Als de verbinding van Thonny met de robot niet meer lijkt te werken, verbind dan opnieuw door rechtonderin de statusbalk te klikken en "MicroPython (Raspberry Pi Pico) ws://<ip>:8266" te kiezen
