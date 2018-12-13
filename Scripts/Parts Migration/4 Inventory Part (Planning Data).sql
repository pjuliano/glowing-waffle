--Add Inventory Part Planning Data
DECLARE
    A_   VARCHAR2(32000) := NULL; --p0
    B_   VARCHAR2(32000) := 'AAAUN5AAIAAMx11AAD'; --p1
    C_   VARCHAR2(32000) := '20181206124105'; --p2
    D_   VARCHAR2(32000) := 'SAFETY_STOCK'
                             || Chr(31)
                             || '10'
                             || Chr(30)
                             || 'SAFETY_STOCK_AUTO_DB'
                             || Chr(31)
                             || 'N'
                             || Chr(30)
                             || 'MAX_ORDER_QTY'
                             || Chr(31)
                             || '10'
                             || Chr(30)
                             || 'STD_ORDER_SIZE'
                             || Chr(31)
                             || '10'
                             || Chr(30); --p3
    E_   VARCHAR2(32000) := 'DO'; --p4
BEGIN
    Ifsapp.Inventory_Part_Planning_Api.Modify__(A_,B_,C_,D_,E_);
END;