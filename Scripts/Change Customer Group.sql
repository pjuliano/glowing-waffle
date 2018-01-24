Declare
   A_ Varchar2(32000) := ''; --p0
   B_ Varchar2(32000) := 'AAAUCRAAIAANMj/AAA'; --p1
   C_ Varchar2(32000) := '20170123160931'; --p2
   D_ Varchar2(32000) := 'CUST_GRP'||Chr(31)||'RESTO'||Chr(30); --p3
   E_ Varchar2(32000) := 'DO'; --p4
Begin
  For Cur In (Select 
                A.Customer_No,
                A.Objid,
                A.Objversion
              From 
                Cust_Ord_Customer A,
                Customer_Info B
              Where 
                A.Customer_No = B.Customer_Id And
                A.Cust_Grp = 'GD' And
                B.Corporate_Form = 'DOMDIR')
  Loop
    A_ := '';
    B_ := Cur.Objid;
    C_ := Cur.Objversion;
    D_ := 'CUST_GRP'||Chr(31)||'RESTO'||Chr(30);
    E_ := 'DO';
    Ifsapp.Cust_Ord_Customer_Api.Modify__( A_ , B_ , C_ , D_ , E_ );
  End Loop;
End;
