Declare
   a_ VARCHAR2(32000) := NULL; --p0
   b_ VARCHAR2(32000) := 'AAAUN9AAIAAMfZ4AAJ'; --p1
   c_ VARCHAR2(32000) := 'CF$_TILOBE_DB'||chr(31)||'TILOBE'||chr(30); --p2
   d_ VARCHAR2(32000) := ''; --p3
   e_ VARCHAR2(32000) := 'DO'; --p4
Begin
  For Parts In (Select
                  Part_No,
                  Objid,
                  ObjVersion,
                  Part_Status
                From
                  Inventory_Part
                Where
                  Contract = '100' And
                  Accounting_Group = 'FG' And
                  Part_Product_Family In ('PRIMA','PRMA+','GNSIS','TLMAX') And
                  Part_Status In ('A','O'))
  Loop
    A_ := Null;
    B_ := Parts.Objid;
    C_ := 'CF$_TILOBE_DB'||Chr(31)||'TILOBE'||Chr(30);
    D_ := '';
    E_ := 'DO';
    Ifsapp.Inventory_Part_Cfp.Cf_Modify__(A_ , B_ , C_ , D_ , E_ );
  End Loop;
End;