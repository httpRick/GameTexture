# GameTexture

GameTexture co to jest?
===========
zasób umożliwający nakładać wszystkie textury z gry Grand Theft Auto San Andreas oraz textury z SAMP 0.3 C.

Autorzy
========================================================================

- Rick <Main Developer>
- Forkerer <Support> [Original use code: https://github.com/forkerer/MTA-IMGLoader]

Licencja
========================================================================

Kod dystrybuowany jest licencji: GPLv3.

Polskie tłumaczenie licencji GPLv3: http://gnu.org.pl/text/licencja-gnu.html

Zawartość repozytorium
========================================================================

W repozytorium znajduje się:
* Kod LUA serwera
* Plik IMG zawierający 2048 textur
* Plik fx tworzacy shader na textury


DOKUMENTACJA
========================================================================

Przykład nakładania tekstury na obiekt:

index - indeks tekstury może być nazwa tekstury lub numer
red, green, blue - kolory RGB textury
brightness - natężenie światła białego

local exampleObject = Object(980, 0.0, 0.0, 0.0)
setElementData(exampleObject, "GameTexture", { {index = 1, red = 0, green = 0, blue = 0 }, {index = 2, red = 0, green = 0, blue = 0 } } )
