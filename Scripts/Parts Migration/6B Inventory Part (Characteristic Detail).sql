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
                             || 'CHARACTERISTIC_CODE'
                             || Chr(31)
                             || 'STER'
                             || Chr(30)
                             || 'ATTR_VALUE_ALPHA'
                             || Chr(31)
                             || 'ST'
                             || Chr(30)
                             || 'UNIT_MEAS'
                             || Chr(31)
                             || ''
                             || Chr(30); --p3
    E_   VARCHAR2(32000) := 'DO'; --p4
BEGIN
    For Parts In (Select
                    *
                  From
                    KD_Data_Migration A)
    Loop
        A_ := Null;
        B_ := Null;
        C_ := Null;
        D_ :=   'CONTRACT'
                 || Chr(31)
                 || '100'
                 || Chr(30)
                 || 'PART_NO'
                 || Chr(31)
                 || Parts.Part_No
                 || Chr(30)
                 || 'CHARACTERISTIC_CODE'
                 || Chr(31)
                 || Parts.Characteristic_Code
                 || Chr(30)
                 || 'ATTR_VALUE_ALPHA'
                 || Chr(31)
                 || PArts.Attr_Value_Alpha
                 || Chr(30)
                 || 'UNIT_MEAS'
                 || Chr(31)
                 || ''
                 || Chr(30); --p3
        E_ := 'DO';
        Ifsapp.Inventory_Part_Char_Api.New__(A_,B_,C_,D_,E_);
    End Loop;
END;