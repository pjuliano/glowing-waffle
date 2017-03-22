DECLARE
   a_ VARCHAR2(32000) := ''; --p0
   b_ VARCHAR2(32000) := 'AAAUNvAAIAAM2pYABu'; --p1
   c_ VARCHAR2(32000) := '20160129142806'; --p2
   d_ VARCHAR2(32000) := 'ESTIMATED_MATERIAL_COST'||chr(31)||'10.57'||chr(30); --p3
   e_ VARCHAR2(32000) := 'DO'; --p4
Begin
  For Costs In (Select 
                  A.Part_No,
                  A.Cost, 
                  B.Objid, 
                  B.Objversion
                From
                  Kd_Est_Mat_Cost_Upload A Left Join Inventory_Part_Config B
                    On A.Part_No = B.Part_No And
                       B.Contract = '100')
  Loop
    Update Kd_Est_Mat_Cost_Upload A Set A.Comments = 'Failed' Where A.Part_No = Costs.Part_No;
    Commit;
    A_ := '';
    B_ := Costs.Objid;
    C_ := Costs.Objversion;
    D_ := 'ESTIMATED_MATERIAL_COST'||Chr(31)||Costs.Cost||Chr(30);
    E_ := 'DO';
    Ifsapp.Inventory_Part_Config_Api.Modify__( A_ , B_ , C_ , D_ , E_ );
    Commit;
    Update Kd_Est_Mat_Cost_Upload A Set A.Comments = 'Success' Where A.Part_No = Costs.Part_No;
    Commit;
  End Loop;
  ----------------------------------
  ---Dbms_Output Section---
  ----------------------------------
  Dbms_Output.Put_Line('a_=' || a_);
  Dbms_Output.Put_Line('b_=' || b_);
  Dbms_Output.Put_Line('c_=' || c_);
  Dbms_Output.Put_Line('d_=' || d_);
  Dbms_Output.Put_Line('e_=' || e_);
  ----------------------------------
END;
