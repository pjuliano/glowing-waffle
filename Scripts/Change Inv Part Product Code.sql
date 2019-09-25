DECLARE
   a_ VARCHAR2(32000) := NULL; --p0
   b_ VARCHAR2(32000) := 'AAAUN9AAIAAMfZUAAO'; --p1
   c_ VARCHAR2(32000) := '20171221100524'; --p2
   d_ VARCHAR2(32000) := 'PART_PRODUCT_CODE'||chr(31)||'PCOMM'||chr(30); --p3
   e_ VARCHAR2(32000) := 'DO'; --p4
Begin
  For Parts In (Select
                  A.Part_No,
                  A.New_Family,
                  B.ObjID,
                  B.ObjVersion
                From
                  Kd_Inv_Part_Update A,
                  Inventory_Part B
                Where
                  A.Part_No = B.Part_No And
                  B.Contract = '100')
  Loop
    A_ := Null;
    B_ := Parts.Objid;
    C_ := Parts.Objversion;
    D_ := 'PART_PRODUCT_CODE'||chr(31)||Parts.New_Family||chr(30);
    Ifsapp.Inventory_Part_Api.Modify__( A_ , B_ , C_ , D_ , E_ );
  End Loop;
End;