Declare
   A_ Varchar2(32000) := Null; --p0
   B_ Varchar2(32000) := 'AAAciEAAIAAM9mGABW'; --p1
   C_ Varchar2(32000) := '3'; --p2
   D_ Varchar2(32000) := 'LIABILITY_TYPE'||Chr(31)||'EXEMPT'||Chr(30); --p3
   E_ Varchar2(32000) := 'DO'; --p4
Begin
  For Cur In (
Select
  *
From
  Customer_Delivery_Tax_Info
Where
  Customer_ID In (
'10946',
'11222',
'5841',
'A47923',
'A77021',
'11005',
'10011',
'11257',
'6556',
'A66181',
'11314',
'A91110',
'A27331',
'6704',
'A65759',
'A53648',
'A86425',
'A86550',
'A87610',
'A87785',
'A88353',
'A88713',
'7224',
'A55880',
'13039',
'D46058',
'6118'))
  Loop 
    Update Kd_Tax_Exempt_Ifs_7 A Set A.Tax_Regime = 'FAIL' Where A.Customer_Id = Cur.Customer_Id;
    Commit;
    A_ := Null;
    B_ := Cur.Objid;
    C_ := Cur.Objversion;
    D_ := 'LIABILITY_TYPE'||Chr(31)||'EXEMPT'||Chr(30);
    E_ := 'DO';
    Ifsapp.Customer_Delivery_Tax_Info_Api.Modify__( A_ , B_ , C_ , D_ , E_ );
    Update Kd_Tax_Exempt_Ifs_7 A Set A.Tax_Regime = 'SUCCESS' Where A.Customer_Id = Cur.Customer_Id;
    Commit;
  End Loop;
End;