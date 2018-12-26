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
    For Parts In (  Select
                        A.ObjVersion,
                        A.ObjID,
                        B.Safety_Stock,
                        B.Safety_Stock_Auto_DB,
                        B.Max_Order_Qty,
                        B.Std_Order_Size
                    From
                        Inventory_Part_Planning A,
                        KD_Data_Migration B
                    Where
                        A.Part_No = B.Part_No)
    Loop
        A_ := NULL;
        B_ := Parts.ObJID;
        C_ := PArts.ObjVersion;
        D_ :=   'SAFETY_STOCK'
                 || Chr(31)
                 || Parts.Safety_Stock
                 || Chr(30)
                 || 'SAFETY_STOCK_AUTO_DB'
                 || Chr(31)
                 || PArts.Safety_Stock_Auto_DB
                 || Chr(30)
                 || 'MAX_ORDER_QTY'
                 || Chr(31)
                 || Parts.Max_Order_Qty
                 || Chr(30)
                 || 'STD_ORDER_SIZE'
                 || Chr(31)
                 || Parts.STD_Order_Size
                 || Chr(30);
        E_ := 'DO';
        Ifsapp.Inventory_Part_Planning_Api.Modify__(A_,B_,C_,D_,E_);
    End Loop;
END;