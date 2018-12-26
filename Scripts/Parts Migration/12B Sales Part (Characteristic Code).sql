DECLARE
    A_   VARCHAR2(32000) := NULL; --p0
    B_   VARCHAR2(32000) := NULL; --p1
    C_   VARCHAR2(32000) := NULL; --p2
    D_   VARCHAR2(32000) := 'CATALOG_NO'
                             || Chr(31)
                             || 'PT-TEST-4'
                             || Chr(30)
                             || 'CONTRACT'
                             || Chr(31)
                             || '100'
                             || Chr(30)
                             || 'CHARACTERISTIC_CODE'
                             || Chr(31)
                             || 'US'
                             || Chr(30)
                             || 'ATTR_VALUE_ALPHA'
                             || Chr(31)
                             || 'ABC123'
                             || Chr(30); --p3
    E_   VARCHAR2(32000) := 'DO'; --p4
BEGIN
    For Parts In (Select * From KD_Data_Migration)
    Loop
        A_ := Null;
        B_ := Null;
        C_ := Null;
        D_ := 'CATALOG_NO'
             || Chr(31)
             || Parts.Part_No
             || Chr(30)
             || 'CONTRACT'
             || Chr(31)
             || Parts.Contract
             || Chr(30)
             || 'CHARACTERISTIC_CODE'
             || Chr(31)
             || PArts.Characteristic_Code2
             || Chr(30)
             || 'ATTR_VALUE_ALPHA'
             || Chr(31)
             || Parts.Attr_Value_Alpha2
             || Chr(30); --p3
        E_ := 'DO';
        Ifsapp.Sales_Part_Characteristic_Api.New__(A_,B_,C_,D_,E_);
    End Loop;
END;