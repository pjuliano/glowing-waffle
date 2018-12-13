DECLARE
    A_   VARCHAR2(32000) := NULL; --p0
    B_   VARCHAR2(32000) := NULL; --p1
    C_   VARCHAR2(32000) := NULL; --p2
    D_   VARCHAR2(32000) := 'PART_NO'
                             || Chr(31)
                             || 'PT-TEST-8'
                             || Chr(30)
                             || 'DESCRIPTION'
                             || Chr(31)
                             || 'Test Paltop Part 2'
                             || Chr(30)
                             || 'UNIT_CODE'
                             || Chr(31)
                             || 'EA'
                             || Chr(30)
                             || 'STD_NAME_ID'
                             || Chr(31)
                             || '0'
                             || Chr(30)
                             || 'WEIGHT_NET'
                             || Chr(31)
                             || '11.1'
                             || Chr(30)
                             || 'UOM_FOR_WEIGHT_NET'
                             || Chr(31)
                             || 'g'
                             || Chr(30)
                             || 'VOLUME_NET'
                             || Chr(31)
                             || '82.5'
                             || Chr(30)
                             || 'UOM_FOR_VOLUME_NET'
                             || Chr(31)
                             || 'cm3'
                             || Chr(30)
                             || 'FREIGHT_FACTOR'
                             || Chr(31)
                             || '1'
                             || Chr(30)
                             || 'POSITION_PART_DB'
                             || Chr(31)
                             || 'NOT POSITION PART'
                             || Chr(30)
                             || 'CONDITION_CODE_USAGE_DB'
                             || Chr(31)
                             || 'NOT_ALLOW_COND_CODE'
                             || Chr(30)
                             || 'CONFIGURABLE_DB'
                             || Chr(31)
                             || 'NOT CONFIGURED'
                             || Chr(30)
                             || 'CATCH_UNIT_ENABLED_DB'
                             || Chr(31)
                             || 'FALSE'
                             || Chr(30)
                             || 'MULTILEVEL_TRACKING_DB'
                             || Chr(31)
                             || 'TRACKING_ON'
                             || Chr(30)
                             || 'ALLOW_AS_NOT_CONSUMED_DB'
                             || Chr(31)
                             || 'FALSE'
                             || Chr(30)
                             || 'RECEIPT_ISSUE_SERIAL_TRACK_DB'
                             || Chr(31)
                             || 'FALSE'
                             || Chr(30)
                             || 'SERIAL_TRACKING_CODE_DB'
                             || Chr(31)
                             || 'NOT SERIAL TRACKING'
                             || Chr(30)
                             || 'ENG_SERIAL_TRACKING_CODE_DB'
                             || Chr(31)
                             || 'NOT SERIAL TRACKING'
                             || Chr(30)
                             || 'STOP_ARRIVAL_ISSUED_SERIAL_DB'
                             || Chr(31)
                             || 'TRUE'
                             || Chr(30)
                             || 'STOP_NEW_SERIAL_IN_RMA_DB'
                             || Chr(31)
                             || 'TRUE'
                             || Chr(30)
                             || 'SERIAL_RULE'
                             || Chr(31)
                             || 'Manual'
                             || Chr(30)
                             || 'LOT_TRACKING_CODE'
                             || Chr(31)
                             || 'Lot Tracking'
                             || Chr(30)
                             || 'LOT_QUANTITY_RULE'
                             || Chr(31)
                             || 'One Lot Per Production Order'
                             || Chr(30)
                             || 'SUB_LOT_RULE'
                             || Chr(31)
                             || 'No Sub Lots Allowed'
                             || Chr(30)
                             || 'COMPONENT_LOT_RULE'
                             || Chr(31)
                             || 'Many Lots Allowed'
                             || Chr(30); --p3
    E_   VARCHAR2(32000) := 'DO'; --p4
BEGIN
    Ifsapp.Part_Catalog_Api.New__(A_,B_,C_,D_,E_);
END;