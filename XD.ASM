org 100h

start:
  call intro
  call wprowadzPierwszaliczbe
  call wprowadzDrugaliczbe
  call wybierzDzialanie
  call koniec


  ;INFORMACJE POCZATKOWE
  intro:
    MOV DX, introInf
    call wypiszDX
  ret

  ;ZAPYTANIE O PIERWSZY ARGUMENT
  wprowadzPierwszaliczbe:
    MOV DX, firstArg
    call wypiszDX
  ret

  ;ZAPYTANIE O DRUGI ARGUMENT
  wprowadzDrugaliczbe:
    MOV DX, secondArg
    call wypiszDX
  ret

  ;WYBOR DZIALANIA (DZIELENIE CZY MNOZENIE)
  wybierzDzialanie:
    MOV DX, opInf
    call wypiszDX
  ret

  ;ZAKONCZ PROGRAM
  koniec:
		MOV DX, progEnd
		call wypiszDX

		MOV AX, 4C00H
		INT 21H

  wypiszDX:
    MOV AH, 9
    INT 21H

    MOV DX, ent1
    INT 21H

    ret


  firstArg  db  "Wprowadz pierwszy argument:$"
  secondArg db  "Wprowadz drugi argument$"
  introInf  db  "Program dzielacy i mnozacy $"
  opInf     db  "Wpisz znak dzialania (* lub \) $"
  progEnd   db  "Koniec. $"
  ent1      db  10,13,36
