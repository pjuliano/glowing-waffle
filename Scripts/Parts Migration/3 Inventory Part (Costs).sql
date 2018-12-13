--Add Inventory Part Costs
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
    Ifsapp.Inventory_Part_Config_Api.Modify__(A_,B_,C_,D_,E_);
END;