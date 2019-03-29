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
                Customer_ID In ('8743',
                                '6717',
                                '2839',
                                '17006',
                                '30085',
                                '24481',
                                'A17755',
                                '17073',
                                'D44048',
                                '19877',
                                '20391',
                                '22304',
                                'A22737',
                                '33063',
                                '15621',
                                '15857',
                                '33810',
                                '24931'))
  Loop
    A_ := Null;
    B_ := Cur.Objid;
    C_ := Cur.Objversion;
    D_ := 'SALESMAN_CODE'||Chr(31)||'315'||Chr(30);
    E_ := 'DO';
    Ifsapp.Cust_Ord_Customer_Api.Modify__( A_ , B_ , C_ , D_ , E_ );
    Commit;
  End Loop;
End;