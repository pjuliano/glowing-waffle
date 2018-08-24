Create Or Replace Function Kd_Udi_Check_Char (V_Mod43Value In Number)
    Return Varchar2 As
Begin
    Return
    Case When V_Mod43value = 0 Then '0'
         When V_Mod43value = 1 Then '1'
         When V_Mod43value = 2 Then '2'
         When V_Mod43value = 3 Then '3'
         When V_Mod43value = 4 Then '4'
         When V_Mod43value = 5 Then '5'
         When V_Mod43value = 6 Then '6'
         When V_Mod43value = 7 Then '7'
         When V_Mod43value = 8 Then '8'
         When V_Mod43value = 9 Then '9'
         When V_Mod43value = 10 Then 'A'
         When V_Mod43value = 11 Then 'B'
         When V_Mod43value = 12 Then 'C'
         When V_Mod43value = 13 Then 'D'
         When V_Mod43value = 14 Then 'E'
         When V_Mod43value = 15 Then 'F'
         When V_Mod43value = 16 Then 'G'
         When V_Mod43value = 17 Then 'H'
         When V_Mod43value = 18 Then 'I'
         When V_Mod43value = 19 Then 'J'
         When V_Mod43value = 20 Then 'K'
         When V_Mod43value = 21 Then 'L'
         When V_Mod43value = 22 Then 'M'
         When V_Mod43value = 23 Then 'N'
         When V_Mod43value = 24 Then 'O'
         When V_Mod43value = 25 Then 'P'
         When V_Mod43value = 26 Then 'Q'
         When V_Mod43value = 27 Then 'R'
         When V_Mod43value = 28 Then 'S'
         When V_Mod43value = 29 Then 'T'
         When V_Mod43value = 30 Then 'U'
         When V_Mod43value = 31 Then 'V'
         When V_Mod43value = 32 Then 'W'
         When V_Mod43value = 33 Then 'X'
         When V_Mod43value = 34 Then 'Y'
         When V_Mod43value = 35 Then 'Z'
         When V_Mod43value = 36 Then '-'
         When V_Mod43value = 37 Then '.'
         When V_Mod43value = 38 Then ' '
         When V_Mod43value = 39 Then '$'
         When V_Mod43value = 40 Then '/'
         When V_Mod43value = 41 Then '+'
         When V_Mod43value = 42 Then '%'
    End;
End;