Declare
   A_ Varchar2(32000) := ''; --p0
   B_ Varchar2(32000) := 'AAAUe8AAIAAAEkrAAA'; --p1
   C_ Varchar2(32000) := '20170116132340'; --p2
   D_ Varchar2(32000) := 'VALID_TO_DATE'||Chr(31)||'2018-01-31-00.00.00'||Chr(30); --p3
   E_ Varchar2(32000) := 'DO'; --p4
Begin
  For Cursor In (Select
                   Objid,
                   Objversion
                 From 
                   Sales_Price_List
                 Where
                   Valid_To_Date Is Not Null)
  Loop
    A_ := '';
    B_ := Cursor.Objid;
    C_ := Cursor.Objversion;
    D_ := 'VALID_TO_DATE'||Chr(31)||'2018-01-31-00.00.00'||Chr(30);
    E_ := 'DO';
    Ifsapp.Sales_Price_List_Api.Modify__( A_ , B_ , C_ , D_ , E_ );
  End Loop;
End;