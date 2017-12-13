DECLARE
   a_ VARCHAR2(32000) := NULL; --p0
   b_ VARCHAR2(32000) := 'AAAUe5AAIAAJ/YtAAl'; --p1
   c_ VARCHAR2(32000) := '20110101105305'; --p2
   d_ VARCHAR2(32000) := 'DO'; --p3
Begin
  For Cursor In (Select
                   A.Objid,
                   A.ObjVersion
                 From
                   Sales_Price_List_Part A
                 Where
                   Inventory_Part_Api.Get_Accounting_Group('100',A.Catalog_No) != 'FG')
  Loop
    A_ := Null;
    B_ := Cursor.Objid;
    C_ := Cursor.Objversion;
    D_ := 'DO';
    Ifsapp.Sales_Price_List_Part_Api.Remove__( A_ , B_ , C_ , D_ );
  End Loop;
End;
