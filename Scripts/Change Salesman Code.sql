Declare
   A_ Varchar2(32000) := Null; --p0
   B_ Varchar2(32000) := 'AAAUCRAAIAAMd1nAAG'; --p1
   C_ Varchar2(32000) := '20170207124247'; --p2
   D_ Varchar2(32000) := 'SALESMAN_CODE'||Chr(31)||'215'||Chr(30); --p3
   E_ Varchar2(32000) := 'DO'; --p4
Begin
  For Cur In (Select
                *
              From
                Cust_Ord_Customer_Ent A
              Where
                A.Salesman_Code = '305' And
                Customer_Info_Address_Api.Get_State(A.Customer_Id, Customer_Info_Address_Api.Get_Default_Address(A.Customer_Id,'Delivery')) = 'CO')
  Loop
    A_ := Null;
    B_ := Cur.Objid;
    C_ := Cur.Objversion;
    D_ := 'SALESMAN_CODE'||Chr(31)||'325'||Chr(30);
    E_ := 'DO';
    Ifsapp.Cust_Ord_Customer_Api.Modify__( A_ , B_ , C_ , D_ , E_ );
    Commit;
  End Loop;
End;
