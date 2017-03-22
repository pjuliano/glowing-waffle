Declare
   A_ Varchar2(32000) := Null; --p0
   B_ Varchar2(32000) := 'AAAUNvAAIAAM2mAAA1'; --p1
   C_ Varchar2(32000) := '20140110132103'; --p2
   D_ Varchar2(32000) := 'ESTIMATED_MATERIAL_COST'||Chr(31)||'0'||Chr(30); --p3
   E_ Varchar2(32000) := 'DO'; --p4
Begin
   For Cur In (Select
                 A.Part_No,
                 A.Objid,
                 A.ObjVersion
               From
                 Inventory_Part_Config A
               Where
                 A.Estimated_Material_Cost != 0 And
                 A.Contract = '100' And
                 A.Part_No In (''))
   Loop
     A_ := Null;
     B_ := Cur.Objid;
     C_ := Cur.ObjVersion;
     D_ := 'ESTIMATED_MATERIAL_COST'||Chr(31)||'0'||Chr(30);
     E_ := 'DO'; 
     Ifsapp.Inventory_Part_Config_Api.Modify__( A_ , B_ , C_ , D_ , E_ );
     Commit;
     ----------------------------------
     ---Dbms_Output Section---
     ----------------------------------
     Dbms_Output.Put_Line('a_=' || A_);
     Dbms_Output.Put_Line('b_=' || B_);
     Dbms_Output.Put_Line('c_=' || C_);
     Dbms_Output.Put_Line('d_=' || D_);
     Dbms_Output.Put_Line('e_=' || E_);
     ----------------------------------
   End Loop;
End;