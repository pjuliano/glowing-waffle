Declare
   A_ Varchar2(32000) := ''; --p0
   B_ Varchar2(32000) := 'AAAUe8AAIAAAEkrAAV'; --p1
   C_ Varchar2(32000) := '20090731171918'; --p2
   D_ Varchar2(32000) := 'VALID_TO_DATE'||Chr(31)||'2018-01-01-00.00.00'||Chr(30); --p3
   E_ Varchar2(32000) := 'DO'; --p4
Begin
   For Cur In (Select 
                 A.Objid,
                 A.Objversion
               From 
                 Sales_Price_List A)
   Loop
     A_ := '';
     B_ := Cur.Objid;
     C_ := Cur.Objversion;
     D_ := 'VALID_TO_DATE'||Chr(31)||'2018-01-01-00.00.00'||Chr(30);
     E_ := 'DO';
     Ifsapp.Sales_Price_List_Api.Modify__( A_ , B_ , C_ , D_ , E_ );
   End Loop;
   ----------------------------------
   ---Dbms_Output Section---
   ----------------------------------
   Dbms_Output.Put_Line('a_=' || A_);
   Dbms_Output.Put_Line('b_=' || B_);
   Dbms_Output.Put_Line('c_=' || C_);
   Dbms_Output.Put_Line('d_=' || D_);
   Dbms_Output.Put_Line('e_=' || E_);
   ----------------------------------
End;