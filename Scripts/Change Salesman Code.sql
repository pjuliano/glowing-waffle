Declare
   A_ Varchar2(32000) := Null; --p0
   B_ Varchar2(32000) := 'AAAUCRAAIAAMd1nAAG'; --p1
   C_ Varchar2(32000) := '20170207124247'; --p2
   D_ Varchar2(32000) := 'SALESMAN_CODE'||Chr(31)||'215'||Chr(30); --p3
   E_ Varchar2(32000) := 'DO'; --p4
Begin
  For Cur In (Select
                A.Objid,
                A.Objversion
              From
                Cust_Ord_Customer_Ent A
              Where
                Customer_ID In (
'17247',
'32974',
'22896',
'4191',
'19644',
'6702',
'18973'          
                ))
  Loop
    A_ := Null;
    B_ := Cur.Objid;
    C_ := Cur.Objversion;
    D_ := 'SALESMAN_CODE'||Chr(31)||'121'||Chr(30);
    E_ := 'DO';
    Ifsapp.Cust_Ord_Customer_Api.Modify__( A_ , B_ , C_ , D_ , E_ );
    Commit;
  End Loop;
End;