Declare
   A_ Varchar2(32000) := ''; --p0
   B_ Varchar2(32000) := 'AAAUCRAAIAANMj/AAA'; --p1
   C_ Varchar2(32000) := '20170123160931'; --p2
   D_ Varchar2(32000) := 'CUST_GRP'||Chr(31)||'RESTO'||Chr(30); --p3
   E_ Varchar2(32000) := 'DO'; --p4
Begin
  For Cur In (With Accounts As (
              Select
                A.Customer_No,
                Sum(A.Allamounts)
              From
                Kd_Sales_Data_Request A
              Where
                A.Cust_Grp = 'RESTO' And
                A.Charge_Type = 'Parts' And
                A.Corporate_Form = 'DOMDIR' And
                A.Part_Product_Code = 'REGEN'
              Group By
                A.Customer_No
              Having
                Sum(A.Allamounts) > 0)
                
              Select 
                A.Customer_No,
                A.Objid,
                A.Objversion
              From 
                Cust_Ord_Customer A,
                Customer_Info B,
                Accounts C
              Where 
                A.Customer_No = B.Customer_Id And
                A.Cust_Grp = 'RESTO' And
                B.Corporate_Form = 'DOMDIR' And
                A.Customer_No = C.Customer_No)
  Loop
    A_ := '';
    B_ := Cur.Objid;
    C_ := Cur.Objversion;
    D_ := 'CUST_GRP'||Chr(31)||'IMPL'||Chr(30);
    E_ := 'DO';
    Ifsapp.Cust_Ord_Customer_Api.Modify__( A_ , B_ , C_ , D_ , E_ );
  End Loop;
End;
