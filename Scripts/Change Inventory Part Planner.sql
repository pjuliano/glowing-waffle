DECLARE
   a_ VARCHAR2(32000) := ''; --p0
   b_ VARCHAR2(32000) := 'AAAUN9AAIAAMe8OAAH'; --p1
   c_ VARCHAR2(32000) := '20161121105417'; --p2
   d_ VARCHAR2(32000) := 'PLANNER_BUYER'||chr(31)||'LGRAY'||chr(30); --p3
   e_ VARCHAR2(32000) := 'DO'; --p4
Begin
  For Cur In (Select
                A.Objid,
                A.ObjVersion
              From 
                Inventory_Part A
              Where
                A.Part_No In (Select
                                A.Part_No
                              From
                                Purchase_Part_Supplier A
                              Where
                                A.Contract = '100' And
                                A.Vendor_No In ('BOBINC')) And
                A.Contract = '100')
  Loop
    A_ := '';
    B_ := Cur.Objid;
    C_ := Cur.Objversion;
    D_ := 'PLANNER_BUYER'||Chr(31)||'LGRAY'||Chr(30);
    E_ := 'DO';
    Ifsapp.Inventory_Part_Api.Modify__( A_ , B_ , C_ , D_ , E_ );
  End Loop;
End;