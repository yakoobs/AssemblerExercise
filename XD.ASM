org 100h

start:
  CALL intro
  CALL wprowadzPierwszaLiczbe
  CALL wprowadzDrugaLiczbe
  CALL wybierzDzialanie
  CALL koniec


  ;INFORMACJE POCZATKOWE
  intro:
    MOV DX, introInf
    CALL wypiszDX
  RET

  ;ZAPYTANIE O PIERWSZY ARGUMENT
  wprowadzPierwszaLiczbe:
    MOV DX, arg1st
    CALL wypiszDX
    CALL wczytajLiczbe
  RET

  ;ZAPYTANIE O DRUGI ARGUMENT
  wprowadzDrugaLiczbe:
    MOV DX, arg2nd
    CALL wypiszDX
  RET

  ;WYBOR DZIALANIA (DZIELENIE CZY MNOZENIE)
  wybierzDzialanie:
    MOV DX, opInf
    CALL wypiszDX
  RET

  ;ZAKONCZ PROGRAM
  koniec:
		MOV DX, progEnd
		CALL wypiszDX

		MOV AX, 4C00H
		INT 21H

  ;POMOCNICZA METODA DO WYPISYWANIA ZE ZNAKIEM NOWEJ LINIIs
  wypiszDX:
    MOV AH, 9
    INT 21H

    MOV DX, ent1
    INT 21H
  RET

  ;POMOCNICZA METODA DO WYPISYWANIA ZAWARTOSCI REJESTROW:
  wypiszRejestry:
    MOV AH, 9
    MOV DX, ent1
    INT 21H

    ;wypisanie AX
    MOV DX, labelAX
    INT 21H
    MOV DX, AX
    INT 21H

    MOV DX, ent1
    INT 21H
  RET

  wczytajLiczbe:
    XOR AL, AL	;Wyczysc rejestr AL poniewaz prowadzi tu rowniez instrukcja
        ;obslugujaca wyjatek wprowadzenia blednej liczby (error->clrstack)
        ;ktora zawiera warosci w AL
    MOV AH, 9	;Funkcja DOSowa wypisujaca z DX lancuch znak�w
        ;musimy powtorzyc deklaracje AH=9 poniewaz mozemy tu skoczyc
        ;z etykiety error gdzie w AH jest 1

    MOV DX, ent1	;Enter
    INT 21H		;Przerwanie DOS

    MOV DX, getnumb	;Do rejestru DX kopiuj lancuch getnumb
    INT 21H		;Przerwanie DOS

    MOV DX, ent1	;Enter
    INT 21H		;Przerwanie DOS

    MOV CX, 0	;Wartosc 0 do rejestru CX, bedzie on wskazywac na
      ;ilosc pobranych cyfr przez program

    pushloop: ;W petli pobieramy znaki i wrzucamy na stos
      MOV AH, 1	;Funkcja oczekjaca na znak ze standardowego wejscia
      INT 21H

      CMP AL, 13	;Jesli jest to enter konczymy wpisywanie znakow
      JE  poploop	;Przeskocz do etykiety zrzucania cyfr ze stosu
      CMP AL, 48	;Sprawdzamy czy wprowadzony znak jest cyfra badajac
      JL  error	;przedzial wartosci dla cyfr w tablicy ASCII
                ;jesli jest mniejszy to nie jest cyfra
      CMP AL, 57;Porownaj czy wprowadzony znak jest wartoscia odpowiadajaca cyfrze
      JG  error	;Jesli wiekszy to wprowadzony znak nie
                ;jest cyfra i przejdz do etykiety error

      INC CL 		;Poprawnie pobralismy cyfre wiec zwiekszam licznik cyfr
      MOV [count],CL	;MOV [miennej wartosc rejestru CX (ilosc liczb na stosie)
      SUB AL, 48	;Uzyskujemy cyfre ze znaku ASCII

      XOR AH, AH	;Zerujemy g�rna czesc rejestru AX czyli AH po to aby uzyskac
                ;w calym rejestrze wartosc naszej cyfry bo obecnie w AH mamy
                ;wartosc funkcji wywolujacej pobranie znaku tak wiec
                ;dla pobranej 2 mielibysmy np 100000002 w AX
                ;ale uzywajac XOR mamy same zera w AH oraz 00000002 w AL
      PUSH AX		;Wrzucamy na stos rejestr AX
      JMP pushloop	;Kolejny krok petli

      poploop:
    		CMP CL,0	;Porownaj czy stos czysty
    		JE  choose	;Jesli tak to koniec programu
    		POP BX		;Zdejmij wartosc z BX (pojedyncza cyfra z wejscia)
    		MOV CH, CL
    	_mul:
    		CMP CH, 1	;Mnozymy (n-1) razy gdzie n to ilosc liczb na stosie
    		JE  dalej	;Jesli spelniony warunek przejdz do dodania wyniku
    		MOV AX, 10	;Przenies do AX wartosc 10
    		MUL BX		;Pomnoz BX razy wartosc AX i wynik do AX
    		xor dx,dx	;Zerowanie rejestru DX
    		MOV BX, AX	;Przenies do BX aktualny wynik mnozenia liczby
    		DEC CH		;Zmniejsz licznik mnozen o 1
    		JMP _mul	;Przejdz do kolejnego kroku mnozenia
    	dalej:
    		ADD [temp] , BX ;Dodaj do zmiennej aktualna wartosc liczby
    		MOV [count], CL  ;3 2 1 przeno� do count aktualn� ilosc liczb na stosie
    		DEC CL		;osiaga wartosc 0 dla 1 na stosie Zmniejsz wartosc licznika stosu o 1

		    JMP poploop	;Przejdz do poczatku etykiety
  RET

  choose:
    XOR CX, CX        ;Wyczysc rejestr CX
    MOV AL, [numbers] ;Przenies do AL ilosc liczb do pobrania
    CMP AL, 2	  ;Jesli rowne 2 to przejdz do pierwszej
    JE  first	  ;Przejdz do etykiety first
    MOV AX, [temp]	  ;Przenies do AX wartosc zliczby wprowadzonej przez uzytkownika
    MOV [num2], AX	  ;Przenies do zmiennej [num2] wartosc rejestru AX
    JMP wybierzDzialanie	  ;Przejdz do etykiety wyboru operacji
  first:
    MOV AX, [temp]	  ;Przenies do AX wartosc zmiennej temp czyli liczby uzytkownika
    MOV [num1], AX	  ;Przenies do zmiennej num1
    XOR AX, AX	  ;Wyczysc rejestr
    MOV [temp], AX    ;Wyczysc zmienna tymczasowa
    MOV AL, [numbers] ;Przenies do AL informacje o ilosci liczb do pobrania
    DEC AL		  ;Zmniejsz o 1 liczbe zmiennych
    MOV [numbers], AL ;Przenies z rejestru AL zmniejszona liczbe do zmiennej numbers
    JMP wprowadzDrugaLiczbe         ;Przejdz do wprowadzania kolejnej liczby

  error:

   MOV AH, 9	;Funkcja wywolujaca lancuch znak�w
   MOV DX, ent1	;Enter
   INT 21H

   MOV DX, wrong	;Wrzuc do DX informacje o blednym parametrze
   INT 21H

   MOV DX, ent1	;Enter
   INT 21H

   MOV DX, askuser	;Do DX kopiuj lancuch z pytaniem czy uzytkownik
       ;chce powtorzyc wpisywanie liczb
   INT 21H

   MOV DX, ent1	;Enter
   INT 21H

   XOR AL,AL	;Wyczysc AL

   MOV AH, 1	;Funkcja pobierajaca znak z wejscia
       ;Jesli bedzie to y to wracamy do poczatku
       ;wprowadzania danej liczby jesli n to konczymy program
   INT 21H

   CMP AL, 116	;116 odpowiada w ascii literze t
   JE  clrstack	;Przejdz do wyczyszczenia stosu ->
       ;pobieraj cyfry jeszcze raz na "czysty" stos
   CMP AL, 84	;84  odpowiada w ascii literze T
   JE  clrstack	;Przejdz do wyczyszczenia stosu ->
       ;pobieraj cyfry na "czysty" stos

   JMP koniec	;Jesli uzytkownik poda n lub inny symbol to przejdz do
       ;etykiety zakonczenia programu



   clrstack:			;Jesli uzytkownik chce jeszcze raz wprowadzac iczby
       ;warto (???) wyczyscic stos ze wczesniej wprowadzonych wartosci

   POP BX		;Zdejmij ze stosu do BX
   XOR BX,BX	;Zeruj BX

   CMP CX,0	;Porownaj czy wartosc rejestru CX wynosi 0
   JE  wczytajLiczbe	;Jesli tak to przejdz do ponownego wprowadzania	cyfr
   DEC CX		;Zmniejsz o 1 rejestr CX

   JMP clrstack	;Przejdz do kolejnego kroku (tylko gdy JE input nie jest spelnione)

  getnumb   db  "Podaj liczbe:$"
  askuser	  db  "Czy chcesz powt�rzyc wpisywanie liczby? t - tak, n - nie.$"
  wrong     db  "Podales niepoprawny argument.$"
  arg1st    db  "Wprowadz pierwszy argument:$"
  arg2nd    db  "Wprowadz drugi argument$"
  introInf  db  "Program dzielacy i mnozacy $"
  opInf     db  "Wpisz znak dzialania (* lub \) $"
  progEnd   db  "Koniec. $"
  ent1      db  10,13,36
  count     db  0
  labelAX   db "AX $"
  temp      dw  0
  num1      dw  0
  num2      dw  0
  numbers db 2
