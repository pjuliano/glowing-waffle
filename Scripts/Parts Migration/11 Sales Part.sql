DECLARE
    A_   VARCHAR2(32000) := NULL; --p0
    B_   VARCHAR2(32000) := NULL; --p1
    C_   VARCHAR2(32000) := NULL; --p2
    D_   VARCHAR2(32000) := 'CATALOG_NO'
                             || Chr(31)
                             || 'PT-TEST-4'
                             || Chr(30)
                             || 'CATALOG_DESC'
                             || Chr(31)
                             || 'Test Paltop Part 1'
                             || Chr(30)
                             || 'CONTRACT'
                             || Chr(31)
                             || '100'
                             || Chr(30)
                             || 'PART_NO'
                             || Chr(31)
                             || 'PT-TEST-4'
                             || Chr(30)
                             || 'SOURCING_OPTION'
                             || Chr(31)
                             || 'Inventory Order'
                             || Chr(30)
                             || 'UNIT_MEAS'
                             || Chr(31)
                             || 'EA'
                             || Chr(30)
                             || 'CONV_FACTOR'
                             || Chr(31)
                             || '1'
                             || Chr(30)
                             || 'PRICE_UNIT_MEAS'
                             || Chr(31)
                             || 'EA'
                             || Chr(30)
                             || 'PRICE_CONV_FACTOR'
                             || Chr(31)
                             || '1'
                             || Chr(30)
                             || 'SALES_UNIT_MEAS'
                             || Chr(31)
                             || 'EA'
                             || Chr(30)
                             || 'INVERTED_CONV_FACTOR'
                             || Chr(31)
                             || '1'
                             || Chr(30)
                             || 'SALES_PRICE_GROUP_ID'
                             || Chr(31)
                             || 'TARGET'
                             || Chr(30)
                             || 'CATALOG_GROUP'
                             || Chr(31)
                             || 'INSTR'
                             || Chr(30)
                             || 'LIST_PRICE'
                             || Chr(31)
                             || '250'
                             || Chr(30)
                             || 'PRIMARY_CATALOG_DB'
                             || Chr(31)
                             || 'FALSE'
                             || Chr(30)
                             || 'ACTIVEIND_DB'
                             || Chr(31)
                             || 'Y'
                             || Chr(30)
                             || 'TAXABLE_DB'
                             || Chr(31)
                             || 'Use sales tax'
                             || Chr(30)
                             || 'QUICK_REGISTERED_PART_DB'
                             || Chr(31)
                             || 'FALSE'
                             || Chr(30)
                             || 'EXPORT_TO_EXTERNAL_APP_DB'
                             || Chr(31)
                             || 'FALSE'
                             || Chr(30)
                             || 'CLOSE_TOLERANCE'
                             || Chr(31)
                             || '0'
                             || Chr(30)
                             || 'CREATE_SM_OBJECT_OPTION_DB'
                             || Chr(31)
                             || 'DONOTCREATESMOBJECT'
                             || Chr(30)
                             || 'USE_SITE_SPECIFIC_DB'
                             || Chr(31)
                             || 'FALSE'
                             || Chr(30)
                             || 'WEIGHT_NET'
                             || Chr(31)
                             || ''
                             || Chr(30)
                             || 'WEIGHT_GROSS'
                             || Chr(31)
                             || ''
                             || Chr(30)
                             || 'VOLUME'
                             || Chr(31)
                             || ''
                             || Chr(30)
                             || 'COST'
                             || Chr(31)
                             || '0'
                             || Chr(30)
                             || 'CATALOG_TYPE_DB'
                             || Chr(31)
                             || 'INV'
                             || Chr(30)
                             || 'COMPANY'
                             || Chr(31)
                             || '100'
                             || Chr(30)
                             || 'FREE_SAMPLE_DB'
                             || Chr(31)
                             || 'N'
                             || Chr(30)
                             || 'PART_DESCRIPTION'
                             || Chr(31)
                             || 'Test Paltop Part 1'
                             || Chr(30)
                             || 'CREATE_PURCHASE_PART'
                             || Chr(31)
                             || 'FALSE'
                             || Chr(30); --p3
    E_   VARCHAR2(32000) := 'DO'; --p4
BEGIN
    Ifsapp.Sales_Part_Api.New__(A_,B_,C_,D_,E_);
END;