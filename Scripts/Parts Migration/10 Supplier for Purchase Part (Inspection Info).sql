DECLARE
    A_   VARCHAR2(32000) := NULL; --p0
    B_   VARCHAR2(32000) := 'AAAUalAAIAAMtKtAAe'; --p1
    C_   VARCHAR2(32000) := '20181207145054'; --p2
    D_   VARCHAR2(32000) := 'RECEIVE_CASE'
                             || Chr(31)
                             || 'Receive into Inventory'
                             || Chr(30)
                             || 'INSPECTION_CODE'
                             || Chr(31)
                             || ''
                             || Chr(30)
                             || 'SAMPLE_PERCENT'
                             || Chr(31)
                             || '0'
                             || Chr(30)
                             || 'SAMPLE_QTY'
                             || Chr(31)
                             || '0'
                             || Chr(30); --p3
    E_   VARCHAR2(32000) := 'DO'; --p4
BEGIN
    Ifsapp.Purchase_Part_Supplier_Api.Modify__(A_,B_,C_,D_,E_);
END;