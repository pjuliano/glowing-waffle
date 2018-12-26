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
    For Parts In (  Select
                        *
                    From
                        KD_Data_Migration A,
                        Part_Catalog B
                    Where
                        A.Part_No = B.Part_No)
    Loop
        A_ := Null;
        B_ := Null;
        C_ := Null;
        D_ :=       'PART_NO'
                 || Chr(31)
                 || Parts.Part_No
                 || Chr(30)
                 || 'DESCRIPTION'
                 || Chr(31)
                 || Parts.Description
                 || Chr(30)
                 || 'UNIT_CODE'
                 || Chr(31)
                 || Parts.Unit_Code
                 || Chr(30)
                 || 'STD_NAME_ID'
                 || Chr(31)
                 || Parts.Std_Name_ID
                 || Chr(30)
                 || 'WEIGHT_NET'
                 || Chr(31)
                 || Parts.Weight_Net
                 || Chr(30)
                 || 'UOM_FOR_WEIGHT_NET'
                 || Chr(31)
                 || Parts.UOM_For_Weight_Net
                 || Chr(30)
                 || 'VOLUME_NET'
                 || Chr(31)
                 || Parts.Volume_Net
                 || Chr(30)
                 || 'UOM_FOR_VOLUME_NET'
                 || Chr(31)
                 || Parts.UOM_For_Volume_Net
                 || Chr(30)
                 || 'FREIGHT_FACTOR'
                 || Chr(31)
                 || Parts.Freight_Factor
                 || Chr(30)
                 || 'POSITION_PART_DB'
                 || Chr(31)
                 || Parts.Position_Part_DB
                 || Chr(30)
                 || 'CONDITION_CODE_USAGE_DB'
                 || Chr(31)
                 || Parts.Condition_Code_Usage_DB
                 || Chr(30)
                 || 'CONFIGURABLE_DB'
                 || Chr(31)
                 || Parts.Configurable_DB
                 || Chr(30)
                 || 'CATCH_UNIT_ENABLED_DB'
                 || Chr(31)
                 || Upper(Parts.Catch_Unit_Enabled_DB)
                 || Chr(30)
                 || 'MULTILEVEL_TRACKING_DB'
                 || Chr(31)
                 || Parts.Multilevel_Tracking_DB
                 || Chr(30)
                 || 'ALLOW_AS_NOT_CONSUMED_DB'
                 || Chr(31)
                 || Upper(Parts.Allow_As_Not_Consumed_DB)
                 || Chr(30)
                 || 'RECEIPT_ISSUE_SERIAL_TRACK_DB'
                 || Chr(31)
                 || Upper(Parts.Receipt_Issue_Serial_Track_DB)
                 || Chr(30)
                 || 'SERIAL_TRACKING_CODE_DB'
                 || Chr(31)
                 || Parts.Serial_Tracking_Code_DB
                 || Chr(30)
                 || 'ENG_SERIAL_TRACKING_CODE_DB'
                 || Chr(31)
                 || Parts.Eng_Serial_Tracking_Code_DB
                 || Chr(30)
                 || 'STOP_ARRIVAL_ISSUED_SERIAL_DB'
                 || Chr(31)
                 || Upper(Parts.Stop_Arrival_Issued_Serial_DB)
                 || Chr(30)
                 || 'STOP_NEW_SERIAL_IN_RMA_DB'
                 || Chr(31)
                 || Upper(Parts.Stop_New_Serial_In_RMA_DB)
                 || Chr(30)
                 || 'SERIAL_RULE'
                 || Chr(31)
                 || Parts.Serial_Rule
                 || Chr(30)
                 || 'LOT_TRACKING_CODE'
                 || Chr(31)
                 || Parts.Lot_Tracking_Code
                 || Chr(30)
                 || 'LOT_QUANTITY_RULE'
                 || Chr(31)
                 || Parts.Lot_Quantity_Rule
                 || Chr(30)
                 || 'SUB_LOT_RULE'
                 || Chr(31)
                 || Parts.Sub_Lot_Rule
                 || Chr(30)
                 || 'COMPONENT_LOT_RULE'
                 || Chr(31)
                 || Parts.Component_Lot_Rule
                 || Chr(30);
        E_ := 'DO';
        Ifsapp.Part_Catalog_Api.New__(A_,B_,C_,D_,E_);
    End Loop;
END;