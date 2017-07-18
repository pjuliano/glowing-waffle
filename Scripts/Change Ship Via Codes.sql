DECLARE
   a_ VARCHAR2(32000) := NULL; --p0
   b_ VARCHAR2(32000) := 'AAAUCQAAIAAMsb9AAA'; --p1
   c_ VARCHAR2(32000) := '20170714090751'; --p2
   d_ VARCHAR2(32000) := 'SHIP_VIA_CODE'||chr(31)||'BW2'||chr(30); --p3
   e_ VARCHAR2(32000) := 'DO'; --p4
Begin
  For Addresses In (Select
                      A.Objid,
                      A.ObjVersion
                    From
                      Cust_Ord_Customer_Address A
                    Where
                      Cust_Ord_Customer_Api.Get_Salesman_Code(A.Customer_No) = '101')
  Loop
    A_ := Null;
    B_ := Addresses.Objid;
    C_ := Addresses.Objversion;
    D_ := 'SHIP_VIA_CODE'||Chr(31)||'BW2'||Chr(30);
    E_ := 'DO';
    Ifsapp.Cust_Ord_Customer_Address_Api.Modify__( A_ , B_ , C_ , D_ , E_ );
  End Loop;
End;

