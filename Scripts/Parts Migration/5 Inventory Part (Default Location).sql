DECLARE
    A_   VARCHAR2(32000) := NULL; --p0
    B_   VARCHAR2(32000) := NULL; --p1
    C_   VARCHAR2(32000) := NULL; --p2
    D_   VARCHAR2(32000) := 'CONTRACT'
                             || Chr(31)
                             || '100'
                             || Chr(30)
                             || 'PART_NO'
                             || Chr(31)
                             || 'PT-TEST-1'
                             || Chr(30)
                             || 'LOCATION_NO'
                             || Chr(31)
                             || 'CAFGROOM'
                             || Chr(30)
                             || 'LOCATION_TYPE'
                             || Chr(31)
                             || 'Picking'
                             || Chr(30); --p3
    E_   VARCHAR2(32000) := 'DO'; --p4
BEGIN
    For Parts In (Select * From KD_Data_Migration)
    Loop
        A_ := NULL;
        B_ := NULL;
        C_ := NULL;
        D_ :=   'CONTRACT'
                 || Chr(31)
                 || Parts.Contract
                 || Chr(30)
                 || 'PART_NO'
                 || Chr(31)
                 || Parts.Part_No
                 || Chr(30)
                 || 'LOCATION_NO'
                 || Chr(31)
                 || Parts.Location_No
                 || Chr(30)
                 || 'LOCATION_TYPE'
                 || Chr(31)
                 || Parts.Location_Type
                 || Chr(30); --p3
        E_ := 'DO';
        Ifsapp.Inventory_Part_Def_Loc_Api.New__(A_,B_,C_,D_,E_);
    End Loop;
END;