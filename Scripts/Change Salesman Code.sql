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
                Customer_ID In ('FR0079',
'FR0480',
'FR0485',
'FR0225',
'FR0526',
'FR0533',
'FR0491',
'FR0438',
'FR0692',
'FR0555',
'FR0661',
'FR0156',
'FR0700',
'FR0790',
'FR0186',
'FR0200',
'FR0420',
'FR0640',
'FR1279',
'FR0944',
'FR5059',
'FR5175',
'FR5016',
'FR5308',
'FR5394',
'FR5520',
'FR5630',
'FR5675',
'FR5701',
'FR5756',
'FR5746',
'FR5707',
'FR0957',
'FR5598',
'FR5277'
))
  Loop
    A_ := Null;
    B_ := Cur.Objid;
    C_ := Cur.Objversion;
    D_ := 'SALESMAN_CODE'||Chr(31)||'240-011'||Chr(30);
    E_ := 'DO';
    Ifsapp.Cust_Ord_Customer_Api.Modify__( A_ , B_ , C_ , D_ , E_ );
    Commit;
  End Loop;
End;