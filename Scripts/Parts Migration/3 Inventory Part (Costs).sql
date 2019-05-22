DECLARE
    A_   VARCHAR2(32000) := ''; --p0
    B_   VARCHAR2(32000) := 'AAAUNvAAIAAM2p9AAW'; --p1
    C_   VARCHAR2(32000) := '20181206124105'; --p2
    D_   VARCHAR2(32000) := 'ESTIMATED_MATERIAL_COST'
                             || Chr(31)
                             || '10'
                             || Chr(30); --p3
    E_   VARCHAR2(32000) := 'DO'; --p4
BEGIN
For Parts In (  Select 
                    A.ObjVersion, 
                    A.ObjID, 
                    B.Estimated_Material_Cost 
                From 
                    Inventory_Part_Config A, 
                    KD_Data_Migration B 
                Where 
                    A.Part_No = B.Part_No)
    Loop
        A_ := '';
        B_ := Parts.ObjID;
        C_ := Parts.OBJVersion;
        D_ :=    'ESTIMATED_MATERIAL_COST'
                 || Chr(31)
                 || Parts.Estimated_Material_Cost
                 || Chr(30); --p3
        E_ := 'DO';
        Ifsapp.Inventory_Part_Config_Api.Modify__(A_,B_,C_,D_,E_);
    End Loop;
END;