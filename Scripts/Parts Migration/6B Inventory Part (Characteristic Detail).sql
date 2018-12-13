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
    Ifsapp.Inventory_Part_Char_Api.New__(A_,B_,C_,D_,E_);
END;