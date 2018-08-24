Create Or Replace Function Kd_Udi_Char_Value (V_String In Varchar2,V_Pos In Number)
    Return Number As
Begin
    Return
    Case When Nvl(Substr(Regexp_Replace(V_String,'[^a-zA-Z0-9]+',''),V_Pos,1),0) = '0' Then 0 
         When Nvl(Substr(Regexp_Replace(V_String,'[^a-zA-Z0-9]+',''),V_Pos,1),0) = '1' Then 1
         When Nvl(Substr(Regexp_Replace(V_String,'[^a-zA-Z0-9]+',''),V_Pos,1),0) = '2' Then 2
         When Nvl(Substr(Regexp_Replace(V_String,'[^a-zA-Z0-9]+',''),V_Pos,1),0) = '3' Then 3
         When Nvl(Substr(Regexp_Replace(V_String,'[^a-zA-Z0-9]+',''),V_Pos,1),0) = '4' Then 4
         When Nvl(Substr(Regexp_Replace(V_String,'[^a-zA-Z0-9]+',''),V_Pos,1),0) = '5' Then 5
         When Nvl(Substr(Regexp_Replace(V_String,'[^a-zA-Z0-9]+',''),V_Pos,1),0) = '6' Then 6
         When Nvl(Substr(Regexp_Replace(V_String,'[^a-zA-Z0-9]+',''),V_Pos,1),0) = '7' Then 7
         When Nvl(Substr(Regexp_Replace(V_String,'[^a-zA-Z0-9]+',''),V_Pos,1),0) = '8' Then 8
         When Nvl(Substr(Regexp_Replace(V_String,'[^a-zA-Z0-9]+',''),V_Pos,1),0) = '9' Then 9
         When Nvl(Substr(Regexp_Replace(V_String,'[^a-zA-Z0-9]+',''),V_Pos,1),0) = 'A' Then 10
         When Nvl(Substr(Regexp_Replace(V_String,'[^a-zA-Z0-9]+',''),V_Pos,1),0) = 'B' Then 11
         When Nvl(Substr(Regexp_Replace(V_String,'[^a-zA-Z0-9]+',''),V_Pos,1),0) = 'C' Then 12
         When Nvl(Substr(Regexp_Replace(V_String,'[^a-zA-Z0-9]+',''),V_Pos,1),0) = 'D' Then 13
         When Nvl(Substr(Regexp_Replace(V_String,'[^a-zA-Z0-9]+',''),V_Pos,1),0) = 'E' Then 14
         When Nvl(Substr(Regexp_Replace(V_String,'[^a-zA-Z0-9]+',''),V_Pos,1),0) = 'F' Then 15
         When Nvl(Substr(Regexp_Replace(V_String,'[^a-zA-Z0-9]+',''),V_Pos,1),0) = 'G' Then 16
         When Nvl(Substr(Regexp_Replace(V_String,'[^a-zA-Z0-9]+',''),V_Pos,1),0) = 'H' Then 17
         When Nvl(Substr(Regexp_Replace(V_String,'[^a-zA-Z0-9]+',''),V_Pos,1),0) = 'I' Then 18
         When Nvl(Substr(Regexp_Replace(V_String,'[^a-zA-Z0-9]+',''),V_Pos,1),0) = 'J' Then 19
         When Nvl(Substr(Regexp_Replace(V_String,'[^a-zA-Z0-9]+',''),V_Pos,1),0) = 'K' Then 20
         When Nvl(Substr(Regexp_Replace(V_String,'[^a-zA-Z0-9]+',''),V_Pos,1),0) = 'L' Then 21
         When Nvl(Substr(Regexp_Replace(V_String,'[^a-zA-Z0-9]+',''),V_Pos,1),0) = 'M' Then 22
         When Nvl(Substr(Regexp_Replace(V_String,'[^a-zA-Z0-9]+',''),V_Pos,1),0) = 'N' Then 23
         When Nvl(Substr(Regexp_Replace(V_String,'[^a-zA-Z0-9]+',''),V_Pos,1),0) = 'O' Then 24
         When Nvl(Substr(Regexp_Replace(V_String,'[^a-zA-Z0-9]+',''),V_Pos,1),0) = 'P' Then 25
         When Nvl(Substr(Regexp_Replace(V_String,'[^a-zA-Z0-9]+',''),V_Pos,1),0) = 'Q' Then 26
         When Nvl(Substr(Regexp_Replace(V_String,'[^a-zA-Z0-9]+',''),V_Pos,1),0) = 'R' Then 27
         When Nvl(Substr(Regexp_Replace(V_String,'[^a-zA-Z0-9]+',''),V_Pos,1),0) = 'S' Then 28
         When Nvl(Substr(Regexp_Replace(V_String,'[^a-zA-Z0-9]+',''),V_Pos,1),0) = 'T' Then 29
         When Nvl(Substr(Regexp_Replace(V_String,'[^a-zA-Z0-9]+',''),V_Pos,1),0) = 'U' Then 30
         When Nvl(Substr(Regexp_Replace(V_String,'[^a-zA-Z0-9]+',''),V_Pos,1),0) = 'V' Then 31
         When Nvl(Substr(Regexp_Replace(V_String,'[^a-zA-Z0-9]+',''),V_Pos,1),0) = 'W' Then 32
         When Nvl(Substr(Regexp_Replace(V_String,'[^a-zA-Z0-9]+',''),V_Pos,1),0) = 'X' Then 33
         When Nvl(Substr(Regexp_Replace(V_String,'[^a-zA-Z0-9]+',''),V_Pos,1),0) = 'Y' Then 34
         When Nvl(Substr(Regexp_Replace(V_String,'[^a-zA-Z0-9]+',''),V_Pos,1),0) = 'Z' Then 35
         When Nvl(Substr(Regexp_Replace(V_String,'[^a-zA-Z0-9]+',''),V_Pos,1),0) = '-' Then 36
         When Nvl(Substr(Regexp_Replace(V_String,'[^a-zA-Z0-9]+',''),V_Pos,1),0) = '.' Then 37
         When Nvl(Substr(Regexp_Replace(V_String,'[^a-zA-Z0-9]+',''),V_Pos,1),0) = ' ' Then 38
         When Nvl(Substr(Regexp_Replace(V_String,'[^a-zA-Z0-9]+',''),V_Pos,1),0) = '$' Then 39
         When Nvl(Substr(Regexp_Replace(V_String,'[^a-zA-Z0-9]+',''),V_Pos,1),0) = '/' Then 40
         When Nvl(Substr(Regexp_Replace(V_String,'[^a-zA-Z0-9]+',''),V_Pos,1),0) = '+' Then 41
         When Nvl(Substr(Regexp_Replace(V_String,'[^a-zA-Z0-9]+',''),V_Pos,1),0) = '%' Then 42
    End;      
End;
        