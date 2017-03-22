Declare
   A_ Varchar2(32000) := ''; --p0
   B_ Varchar2(32000) := 'AAAUe3AAIAAAEkDAAA'; --p1
   C_ Varchar2(32000) := '20161114161151'; --p2
   D_ Varchar2(32000) := 'TAXABLE_DB'||Chr(31)||'Use sales tax'||Chr(30); --p3
   E_ Varchar2(32000) := 'DO'; --p4
Begin
  For Cur In (Select 
                A.Objid, 
                A.Objversion
              From
                Sales_Part A
              Where
                A.Catalog_Group In ('IMPL') And
                Activeind_Db = 'Y' And 
                A.Taxable_Db = 'No sales tax')
  Loop
    A_ := '';
    B_ := Cur.Objid;
    C_ := Cur.Objversion;
    D_ := 'TAXABLE_DB'||Chr(31)||'Use sales tax'||Chr(30);
    E_ := 'DO';
    Ifsapp.Sales_Part_Api.Modify__( A_ , B_ , C_ , D_ , E_ );
  End Loop;
End;

