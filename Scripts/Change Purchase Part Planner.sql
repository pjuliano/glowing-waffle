
DECLARE
   a_ VARCHAR2(32000) := ''; --p0
   b_ VARCHAR2(32000) := 'AAAUanAAIAAMyA9AAV'; --p1
   c_ VARCHAR2(32000) := '20151109162905'; --p2
   d_ VARCHAR2(32000) := 'BUYER_CODE'||chr(31)||'LGRAY'||chr(30); --p3
   e_ VARCHAR2(32000) := 'DO'; --p4
BEGIN
  For Cur In (Select
                A.Objid,
                A.ObjVersion
              From 
                Purchase_Part A
              Where
                A.Part_No In (Select
                                A.Part_No
                              From
                                Purchase_Part_Supplier A
                              Where
                                A.Contract = '100' And
                                A.Vendor_No In ('BOBINC') And
                                A.Primary_Vendor != 'Primary supplier') And
                A.Contract = '100')
  Loop
    A_ := '';
    B_ := Cur.Objid;
    C_ := Cur.Objversion;
    D_ := 'BUYER_CODE'||Chr(31)||'RMOREAU'||Chr(30);
    E_ := 'DO'; 
    Ifsapp.Purchase_Part_Api.Modify__( A_ , B_ , C_ , D_ , E_ );
  End Loop;
End;
