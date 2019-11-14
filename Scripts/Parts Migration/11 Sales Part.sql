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
    For Parts In (Select * From KD_Data_Migration Where done IS NULL)
    Loop
        A_ := Null;
        B_ := Null;
        C_ := Null;
        D_ :=   'CATALOG_NO'
                 || Chr(31)
                 || parts.catalog_no
                 || Chr(30)
                 || 'CATALOG_DESC'
                 || Chr(31)
                 || parts.catalog_desc
                 || Chr(30)
                 || 'CONTRACT'
                 || Chr(31)
                 || parts.contract
                 || Chr(30)
                 || 'PART_NO'
                 || Chr(31)
                 || parts.part_no
                 || Chr(30)
                 || 'SOURCING_OPTION'
                 || Chr(31)
                 || parts.sourcing_option
                 || Chr(30)
                 || 'UNIT_MEAS'
                 || Chr(31)
                 || parts.unit_meas
                 || Chr(30)
                 || 'CONV_FACTOR'
                 || Chr(31)
                 || parts.conv_factor
                 || Chr(30)
                 || 'PRICE_UNIT_MEAS'
                 || Chr(31)
                 || parts.price_unit_meas
                 || Chr(30)
                 || 'PRICE_CONV_FACTOR'
                 || Chr(31)
                 || parts.price_conv_factor
                 || Chr(30)
                 || 'SALES_UNIT_MEAS'
                 || Chr(31)
                 || parts.sales_unit_meas
                 || Chr(30)
                 || 'INVERTED_CONV_FACTOR'
                 || Chr(31)
                 || parts.inverted_conv_factor
                 || Chr(30)
                 || 'SALES_PRICE_GROUP_ID'
                 || Chr(31)
                 || parts.sales_price_group_id
                 || Chr(30)
                 || 'CATALOG_GROUP'
                 || Chr(31)
                 || parts.catalog_group
                 || Chr(30)
                 || 'LIST_PRICE'
                 || Chr(31)
                 || parts.list_price
                 || Chr(30)
                 || 'PRIMARY_CATALOG_DB'
                 || Chr(31)
                 || parts.primary_catalog_db
                 || Chr(30)
                 || 'ACTIVEIND_DB'
                 || Chr(31)
                 || parts.activeind_db
                 || Chr(30)
                 || 'TAXABLE_DB'
                 || Chr(31)
                 || parts.taxable_db
                 || Chr(30)
                 || 'QUICK_REGISTERED_PART_DB'
                 || Chr(31)
                 || parts.quick_registered_part_db
                 || Chr(30)
                 || 'EXPORT_TO_EXTERNAL_APP_DB'
                 || Chr(31)
                 || parts.export_to_external_app_db
                 || Chr(30)
                 || 'CLOSE_TOLERANCE'
                 || Chr(31)
                 || parts.close_tolerance
                 || Chr(30)
                 || 'CREATE_SM_OBJECT_OPTION_DB'
                 || Chr(31)
                 || parts.create_sm_object_option_db
                 || Chr(30)
                 || 'USE_SITE_SPECIFIC_DB'
                 || Chr(31)
                 || parts.use_site_specific_db
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
                 || parts.cost
                 || Chr(30)
                 || 'CATALOG_TYPE_DB'
                 || Chr(31)
                 || parts.catalog_type_db
                 || Chr(30)
                 || 'COMPANY'
                 || Chr(31)
                 || parts.company
                 || Chr(30)
                 || 'FREE_SAMPLE_DB'
                 || Chr(31)
                 || parts.free_sample_db
                 || Chr(30)
                 || 'PART_DESCRIPTION'
                 || Chr(31)
                 || parts.part_description
                 || Chr(30)
                 || 'CREATE_PURCHASE_PART'
                 || Chr(31)
                 || 'FALSE'
                 || Chr(30); --p3
        E_ := 'DO';
        UPDATE kd_data_migration SET done = 'notok' WHERE catalog_no = parts.catalog_no;
        COMMIT;
        Ifsapp.Sales_Part_Api.New__(A_,B_,C_,D_,E_);
        COMMIT;
        UPDATE kd_data_migration SET done = 'ok' WHERE catalog_no = parts.catalog_no;
        COMMIT;
    End Loop;
END;