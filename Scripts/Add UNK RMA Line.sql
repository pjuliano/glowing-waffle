DECLARE
    A_   VARCHAR2(32000) := NULL; --p0
    B_   VARCHAR2(32000) := NULL; --p1
    C_   VARCHAR2(32000) := NULL; --p2
    D_   VARCHAR2(32000) := 'RMA_NO'
                             || Chr(31)
                             || '1562'
                             || Chr(30)
                             || 'CATALOG_NO'
                             || Chr(31)
                             || 'UNK'
                             || Chr(30)
                             || 'CATALOG_DESC'
                             || Chr(31)
                             || 'Unknown/Unidentified Return Item'
                             || Chr(30)
                             || 'CONFIGURATION_ID'
                             || Chr(31)
                             || '*'
                             || Chr(30)
                             || 'CONDITION_CODE'
                             || Chr(31)
                             || ''
                             || Chr(30)
                             || 'QTY_TO_RETURN'
                             || Chr(31)
                             || '1'
                             || Chr(30)
                             || 'RETURN_REASON_CODE'
                             || Chr(31)
                             || 'ABC'
                             || Chr(30)
                             || 'INSPECTION_INFO'
                             || Chr(31)
                             || 'N/A'
                             || Chr(30)
                             || 'BASE_SALE_UNIT_PRICE'
                             || Chr(31)
                             || '0'
                             || Chr(30)
                             || 'SALE_UNIT_PRICE'
                             || Chr(31)
                             || '0'
                             || Chr(30)
                             || 'PRICE_CONV_FACTOR'
                             || Chr(31)
                             || '1'
                             || Chr(30)
                             || 'VAT_DB'
                             || Chr(31)
                             || 'Y'
                             || Chr(30)
                             || 'TAX_LIABILITY'
                             || Chr(31)
                             || 'TAX'
                             || Chr(30)
                             || 'DELIVERY_TYPE'
                             || Chr(31)
                             || ''
                             || Chr(30)
                             || 'REBATE_BUILDER_DB'
                             || Chr(31)
                             || 'TRUE'
                             || Chr(30)
                             || 'PART_NO'
                             || Chr(31)
                             || 'UNK'
                             || Chr(30)
                             || 'CONTRACT'
                             || Chr(31)
                             || '100'
                             || Chr(30)
                             || 'CURRENCY_RATE'
                             || Chr(31)
                             || '1'
                             || Chr(30)
                             || 'CONV_FACTOR'
                             || Chr(31)
                             || '1'
                             || Chr(30)
                             || 'INVERTED_CONV_FACTOR'
                             || Chr(31)
                             || '1'
                             || Chr(30)
                             || 'COMPANY'
                             || Chr(31)
                             || '100'
                             || Chr(30)
                             || 'QTY_EDITED_FLAG'
                             || Chr(31)
                             || 'EDITED'
                             || Chr(30); --p3
    E_   VARCHAR2(32000) := 'DO'; --p4
BEGIN
    For RMAS In (Select Price_List_No As RMA_No, Status From KD_Price_List_Upload Where STatus Is Null)
    Loop
        A_ := Null;
        B_ := Null;
        C_ := Null;
        D_ :=   'RMA_NO'
                 || Chr(31)
                 || RMAS.RMA_No
                 || Chr(30)
                 || 'CATALOG_NO'
                 || Chr(31)
                 || 'UNK'
                 || Chr(30)
                 || 'CATALOG_DESC'
                 || Chr(31)
                 || 'Unknown/Unidentified Return Item'
                 || Chr(30)
                 || 'CONFIGURATION_ID'
                 || Chr(31)
                 || '*'
                 || Chr(30)
                 || 'CONDITION_CODE'
                 || Chr(31)
                 || ''
                 || Chr(30)
                 || 'QTY_TO_RETURN'
                 || Chr(31)
                 || '1'
                 || Chr(30)
                 || 'RETURN_REASON_CODE'
                 || Chr(31)
                 || 'ABC'
                 || Chr(30)
                 || 'INSPECTION_INFO'
                 || Chr(31)
                 || 'N/A'
                 || Chr(30)
                 || 'BASE_SALE_UNIT_PRICE'
                 || Chr(31)
                 || '0'
                 || Chr(30)
                 || 'SALE_UNIT_PRICE'
                 || Chr(31)
                 || '0'
                 || Chr(30)
                 || 'PRICE_CONV_FACTOR'
                 || Chr(31)
                 || '1'
                 || Chr(30)
                 || 'VAT_DB'
                 || Chr(31)
                 || 'Y'
                 || Chr(30)
                 || 'TAX_LIABILITY'
                 || Chr(31)
                 || 'TAX'
                 || Chr(30)
                 || 'DELIVERY_TYPE'
                 || Chr(31)
                 || ''
                 || Chr(30)
                 || 'REBATE_BUILDER_DB'
                 || Chr(31)
                 || 'TRUE'
                 || Chr(30)
                 || 'PART_NO'
                 || Chr(31)
                 || 'UNK'
                 || Chr(30)
                 || 'CONTRACT'
                 || Chr(31)
                 || '100'
                 || Chr(30)
                 || 'CURRENCY_RATE'
                 || Chr(31)
                 || '1'
                 || Chr(30)
                 || 'CONV_FACTOR'
                 || Chr(31)
                 || '1'
                 || Chr(30)
                 || 'INVERTED_CONV_FACTOR'
                 || Chr(31)
                 || '1'
                 || Chr(30)
                 || 'COMPANY'
                 || Chr(31)
                 || '100'
                 || Chr(30)
                 || 'QTY_EDITED_FLAG'
                 || Chr(31)
                 || 'EDITED'
                 || Chr(30); --p3
        E_ := 'DO';
        Update KD_Price_List_Upload Set Status = 'FAILED' Where RMAs.RMA_No = Price_List_No;
        Commit;
        Ifsapp.Return_Material_Line_Api.New__(A_,B_,C_,D_,E_);
        Update KD_Price_List_Upload Set Status = 'SUCCESS' Where RMAs.RMA_No = Price_List_No;
        Commit;
        End Loop;
END;