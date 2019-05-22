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
                             || 'Test Paltop Part 1'
                             || Chr(30)
                             || 'CONTRACT'
                             || Chr(31)
                             || '100'
                             || Chr(30)
                             || 'TYPE_CODE'
                             || Chr(31)
                             || 'Purchased'
                             || Chr(30)
                             || 'PLANNER_BUYER'
                             || Chr(31)
                             || 'JMPICARIELLO'
                             || Chr(30)
                             || 'UNIT_MEAS'
                             || Chr(31)
                             || 'EA'
                             || Chr(30)
                             || 'CATCH_UNIT_MEAS'
                             || Chr(31)
                             || ''
                             || Chr(30)
                             || 'PRIME_COMMODITY'
                             || Chr(31)
                             || 'PABBL'
                             || Chr(30)
                             || 'SECOND_COMMODITY'
                             || Chr(31)
                             || 'PACC'
                             || Chr(30)
                             || 'ASSET_CLASS'
                             || Chr(31)
                             || 'S'
                             || Chr(30)
                             || 'PART_STATUS'
                             || Chr(31)
                             || 'A'
                             || Chr(30)
                             || 'ACCOUNTING_GROUP'
                             || Chr(31)
                             || 'FG'
                             || Chr(30)
                             || 'PART_PRODUCT_CODE'
                             || Chr(31)
                             || 'IMPL'
                             || Chr(30)
                             || 'PART_PRODUCT_FAMILY'
                             || Chr(31)
                             || 'PRIMA'
                             || Chr(30)
                             || 'DIM_QUALITY'
                             || Chr(31)
                             || 'N/A'
                             || Chr(30)
                             || 'LEAD_TIME_CODE'
                             || Chr(31)
                             || 'Purchased'
                             || Chr(30)
                             || 'PURCH_LEADTIME'
                             || Chr(31)
                             || '10'
                             || Chr(30)
                             || 'MANUF_LEADTIME'
                             || Chr(31)
                             || '0'
                             || Chr(30)
                             || 'EXPECTED_LEADTIME'
                             || Chr(31)
                             || '10'
                             || Chr(30)
                             || 'MIN_DURAB_DAYS_CO_DELIV'
                             || Chr(31)
                             || '0'
                             || Chr(30)
                             || 'MIN_DURAB_DAYS_PLANNING'
                             || Chr(31)
                             || '0'
                             || Chr(30)
                             || 'CUSTOMS_STAT_NO'
                             || Chr(31)
                             || '3006100100'
                             || Chr(30)
                             || 'INTRASTAT_CONV_FACTOR'
                             || Chr(31)
                             || '1'
                             || Chr(30)
                             || 'SUPPLY_CODE'
                             || Chr(31)
                             || 'Inventory Order'
                             || Chr(30)
                             || 'DOP_CONNECTION'
                             || Chr(31)
                             || 'Manual DOP'
                             || Chr(30)
                             || 'DOP_NETTING'
                             || Chr(31)
                             || 'Netting'
                             || Chr(30)
                             || 'QTY_CALC_ROUNDING'
                             || Chr(31)
                             || '0'
                             || Chr(30)
                             || 'ZERO_COST_FLAG'
                             || Chr(31)
                             || 'Zero Cost Forbidden'
                             || Chr(30)
                             || 'PART_COST_GROUP_ID'
                             || Chr(31)
                             || 'FG'
                             || Chr(30)
                             || 'CYCLE_PERIOD'
                             || Chr(31)
                             || '240'
                             || Chr(30)
                             || 'CYCLE_CODE_DB'
                             || Chr(31)
                             || 'N'
                             || Chr(30)
                             || 'STOCK_MANAGEMENT_DB'
                             || Chr(31)
                             || 'SYSTEM MANAGED INVENTORY'
                             || Chr(30)
                             || 'PALLET_HANDLED_DB'
                             || Chr(31)
                             || 'FALSE'
                             || Chr(30)
                             || 'DESCRIPTION_COPY'
                             || Chr(31)
                             || 'Test Paltop Part 1'
                             || Chr(30); --p3
    E_   VARCHAR2(32000) := 'DO'; --p4
BEGIN
    For Parts In (Select * From KD_Data_Migration)
    Loop
        A_ := NULL;
        B_ := NULL;
        C_ := NULL;
        D_ :=       'PART_NO'
                 || Chr(31)
                 || Parts.Part_No
                 || Chr(30)
                 || 'DESCRIPTION'
                 || Chr(31)
                 || Parts.Description
                 || Chr(30)
                 || 'CONTRACT'
                 || Chr(31)
                 || Parts.Contract
                 || Chr(30)
                 || 'TYPE_CODE'
                 || Chr(31)
                 || Parts.Type_Code
                 || Chr(30)
                 || 'PLANNER_BUYER'
                 || Chr(31)
                 || Parts.Planner_Buyer
                 || Chr(30)
                 || 'UNIT_MEAS'
                 || Chr(31)
                 || Parts.Unit_Meas
                 || Chr(30)
                 || 'CATCH_UNIT_MEAS'
                 || Chr(31)
                 || Parts.Catch_Unit_Meas
                 || Chr(30)
                 || 'PRIME_COMMODITY'
                 || Chr(31)
                 || PArts.Prime_Commodity
                 || Chr(30)
                 || 'SECOND_COMMODITY'
                 || Chr(31)
                 || Parts.Second_Commodity
                 || Chr(30)
                 || 'ASSET_CLASS'
                 || Chr(31)
                 || Parts.Asset_Class
                 || Chr(30)
                 || 'PART_STATUS'
                 || Chr(31)
                 || Parts.Part_Status
                 || Chr(30)
                 || 'ACCOUNTING_GROUP'
                 || Chr(31)
                 || PArts.Accounting_Group
                 || Chr(30)
                 || 'PART_PRODUCT_CODE'
                 || Chr(31)
                 || Parts.Part_Product_Code
                 || Chr(30)
                 || 'PART_PRODUCT_FAMILY'
                 || Chr(31)
                 || Parts.Part_Product_Family
                 || Chr(30)
                 || 'DIM_QUALITY'
                 || Chr(31)
                 || Parts.Dim_Quality
                 || Chr(30)
                 || 'LEAD_TIME_CODE'
                 || Chr(31)
                 || Parts.Lead_Time_Code
                 || Chr(30)
                 || 'PURCH_LEADTIME'
                 || Chr(31)
                 || Parts.Purch_Leadtime
                 || Chr(30)
                 || 'MANUF_LEADTIME'
                 || Chr(31)
                 || Parts.Manuf_Leadtime
                 || Chr(30)
                 || 'EXPECTED_LEADTIME'
                 || Chr(31)
                 || Parts.Expected_Leadtime
                 || Chr(30)
                 || 'MIN_DURAB_DAYS_CO_DELIV'
                 || Chr(31)
                 || Parts.MIN_DURAB_DAYS_PLANNING
                 || Chr(30)
                 || 'MIN_DURAB_DAYS_PLANNING'
                 || Chr(31)
                 || Parts.Min_Durab_Days_Planning
                 || Chr(30)
                 || 'CUSTOMS_STAT_NO'
                 || Chr(31)
                 || Parts.Customs_Stat_No
                 || Chr(30)
                 || 'INTRASTAT_CONV_FACTOR'
                 || Chr(31)
                 || Parts.Intrastat_Conv_Factor
                 || Chr(30)
                 || 'SUPPLY_CODE'
                 || Chr(31)
                 || Parts.Supply_Code
                 || Chr(30)
                 || 'DOP_CONNECTION'
                 || Chr(31)
                 || Parts.Dop_Connection
                 || Chr(30)
                 || 'DOP_NETTING'
                 || Chr(31)
                 || Parts.Dop_Netting
                 || Chr(30)
                 || 'QTY_CALC_ROUNDING'
                 || Chr(31)
                 || Parts.Qty_Calc_Rounding
                 || Chr(30)
                 || 'ZERO_COST_FLAG'
                 || Chr(31)
                 || Parts.Zero_Cost_Flag
                 || Chr(30)
                 || 'PART_COST_GROUP_ID'
                 || Chr(31)
                 || Parts.Part_Cost_Group_ID
                 || Chr(30)
                 || 'CYCLE_PERIOD'
                 || Chr(31)
                 || Parts.Cycle_Period
                 || Chr(30)
                 || 'CYCLE_CODE_DB'
                 || Chr(31)
                 || Parts.Cycle_Code_DB
                 || Chr(30)
                 || 'STOCK_MANAGEMENT_DB'
                 || Chr(31)
                 || Parts.Stock_Management_DB
                 || Chr(30)
                 || 'PALLET_HANDLED_DB'
                 || Chr(31)
                 || Upper(Parts.Pallet_Handled_DB)
                 || Chr(30)
                 || 'DESCRIPTION_COPY'
                 || Chr(31)
                 || Parts.Description_Copy
                 || Chr(30); --p3
        E_ := 'DO';
        Ifsapp.Inventory_Part_Api.New__(A_,B_,C_,D_,E_);
    End Loop;
END;