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
    MOV DX, firstArg
    CALL wypiszDX
  RET

  ;ZAPYTANIE O DRUGI ARGUMENT
  wprowadzDrugaLiczbe:
    MOV DX, secondArg
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


  firstArg  db  "Wprowadz pierwszy argument:$"
  secondArg db  "Wprowadz drugi argument$"
  introInf  db  "Program dzielacy i mnozacy $"
  opInf     db  "Wpisz znak dzialania (* lub \) $"
  progEnd   db  "Koniec. $"
  ent1      db  10,13,36
