DECLARE
    A_   VARCHAR2(32000) := NULL; --p0
    B_   VARCHAR2(32000) := NULL; --p1
    C_   VARCHAR2(32000) := NULL; --p2
    D_   VARCHAR2(32000) := 'PART_NO'
                             || Chr(31)
                             || 'PT-TEST-4'
                             || Chr(30)
                             || 'CONTRACT'
                             || Chr(31)
                             || '100'
                             || Chr(30)
                             || 'VENDOR_NO'
                             || Chr(31)
                             || 'PRECIS'
                             || Chr(30)
                             || 'BUY_UNIT_MEAS'
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
                             || 'STD_MULTIPLE_QTY'
                             || Chr(31)
                             || '1'
                             || Chr(30)
                             || 'STANDARD_PACK_SIZE'
                             || Chr(31)
                             || '1'
                             || Chr(30)
                             || 'STATUS_CODE'
                             || Chr(31)
                             || '2'
                             || Chr(30)
                             || 'MINIMUM_QTY'
                             || Chr(31)
                             || '0'
                             || Chr(30)
                             || 'VENDOR_MANUF_LEADTIME'
                             || Chr(31)
                             || '0'
                             || Chr(30)
                             || 'PURCHASE_PAYMENT_TYPE'
                             || Chr(31)
                             || 'Normal'
                             || Chr(30)
                             || 'QTY_CALC_ROUNDING'
                             || Chr(31)
                             || '16'
                             || Chr(30)
                             || 'PART_OWNERSHIP'
                             || Chr(31)
                             || 'Company Owned'
                             || Chr(30)
                             || 'COUNTRY_OF_ORIGIN'
                             || Chr(31)
                             || ''
                             || Chr(30)
                             || 'LIST_PRICE'
                             || Chr(31)
                             || '2'
                             || Chr(30)
                             || 'CURRENCY_CODE'
                             || Chr(31)
                             || 'USD'
                             || Chr(30)
                             || 'DISCOUNT'
                             || Chr(31)
                             || '0'
                             || Chr(30)
                             || 'ADDITIONAL_COST_AMOUNT'
                             || Chr(31)
                             || '0'
                             || Chr(30)
                             || 'PRIMARY_VENDOR_DB'
                             || Chr(31)
                             || 'Y'
                             || Chr(30)
                             || 'ORDERS_PRICE_OPTION_DB'
                             || Chr(31)
                             || 'DONOTSENDPRICE'
                             || Chr(30)
                             || 'SUPPLY_CONFIGURATION_DB'
                             || Chr(31)
                             || 'CONFIGATSUPPLIER'
                             || Chr(30)
                             || 'QUICK_REGISTERED_PART_DB'
                             || Chr(31)
                             || 'FALSE'
                             || Chr(30)
                             || 'DIST_ORDER_RECEIPT_TYPE_DB'
                             || Chr(31)
                             || 'NO AUTOMATIC RECPT'
                             || Chr(30)
                             || 'RECEIVE_CASE'
                             || Chr(31)
                             || 'Receive into Arrival'
                             || Chr(30)
                             || 'SAMPLE_PERCENT'
                             || Chr(31)
                             || '0'
                             || Chr(30)
                             || 'SAMPLE_QTY'
                             || Chr(31)
                             || '0'
                             || Chr(30)
                             || 'INTERNAL_CONTROL_TIME'
                             || Chr(31)
                             || '0'
                             || Chr(30)
                             || 'EXTERNAL_SERVICE_ALLOWED_DB'
                             || Chr(31)
                             || 'FALSE'
                             || Chr(30)
                             || 'MULTISITE_PLANNED_PART_DB'
                             || Chr(31)
                             || 'NOT_MULTISITE_PLAN'
                             || Chr(30); --p3
    E_   VARCHAR2(32000) := 'DO'; --p4
BEGIN
    For Parts In (Select * From KD_Data_Migration)
    Loop
        A_ := Null;
        B_ := Null;
        C_ := Null;
        D_ := 'PART_NO'
             || Chr(31)
             || Parts.Part_No
             || Chr(30)
             || 'CONTRACT'
             || Chr(31)
             || Parts.Contract
             || Chr(30)
             || 'VENDOR_NO'
             || Chr(31)
             || Parts.Vendor_No
             || Chr(30)
             || 'BUY_UNIT_MEAS'
             || Chr(31)
             || Parts.Buy_Unit_Meas
             || Chr(30)
             || 'CONV_FACTOR'
             || Chr(31)
             || Parts.Conv_Factor
             || Chr(30)
             || 'PRICE_UNIT_MEAS'
             || Chr(31)
             || Parts.Price_Unit_Meas
             || Chr(30)
             || 'PRICE_CONV_FACTOR'
             || Chr(31)
             || Parts.Price_Conv_Factor
             || Chr(30)
             || 'STD_MULTIPLE_QTY'
             || Chr(31)
             || Parts.Std_Multiple_Qty
             || Chr(30)
             || 'STANDARD_PACK_SIZE'
             || Chr(31)
             || Parts.Standard_Pack_Size
             || Chr(30)
             || 'STATUS_CODE'
             || Chr(31)
             || PArts.Status_Code
             || Chr(30)
             || 'MINIMUM_QTY'
             || Chr(31)
             || PArts.Minimum_Qty
             || Chr(30)
             || 'VENDOR_MANUF_LEADTIME'
             || Chr(31)
             || Parts.Vendor_Manuf_Leadtime
             || Chr(30)
             || 'PURCHASE_PAYMENT_TYPE'
             || Chr(31)
             || Parts.Purchase_Payment_Type
             || Chr(30)
             || 'QTY_CALC_ROUNDING'
             || Chr(31)
             || PArts.Qty_Calc_Rounding
             || Chr(30)
             || 'PART_OWNERSHIP'
             || Chr(31)
             || Parts.Part_Ownership
             || Chr(30)
             || 'COUNTRY_OF_ORIGIN'
             || Chr(31)
             || Parts.Country_Of_Origin
             || Chr(30)
             || 'LIST_PRICE'
             || Chr(31)
             || Parts.List_Price
             || Chr(30)
             || 'CURRENCY_CODE'
             || Chr(31)
             || Parts.Currency_Code
             || Chr(30)
             || 'DISCOUNT'
             || Chr(31)
             || Parts.Discount
             || Chr(30)
             || 'ADDITIONAL_COST_AMOUNT'
             || Chr(31)
             || Parts.Additional_Cost_Amount
             || Chr(30)
             || 'PRIMARY_VENDOR_DB'
             || Chr(31)
             || Parts.Primary_Vendor_DB
             || Chr(30)
             || 'ORDERS_PRICE_OPTION_DB'
             || Chr(31)
             || Parts.Orders_Price_Option_DB
             || Chr(30)
             || 'SUPPLY_CONFIGURATION_DB'
             || Chr(31)
             || Parts.Supply_Configuration_DB
             || Chr(30)
             || 'QUICK_REGISTERED_PART_DB'
             || Chr(31)
             || Upper(Parts.Quick_Registered_Part_DB)
             || Chr(30)
             || 'DIST_ORDER_RECEIPT_TYPE_DB'
             || Chr(31)
             || Parts.Dist_Order_Receipt_Type_DB
             || Chr(30)
             || 'RECEIVE_CASE'
             || Chr(31)
             || Parts.Receive_Case
             || Chr(30)
             || 'SAMPLE_PERCENT'
             || Chr(31)
             || Parts.Sample_Percent
             || Chr(30)
             || 'SAMPLE_QTY'
             || Chr(31)
             || PArts.Sample_Qty
             || Chr(30)
             || 'INTERNAL_CONTROL_TIME'
             || Chr(31)
             || Parts.Internal_Control_Time
             || Chr(30)
             || 'EXTERNAL_SERVICE_ALLOWED_DB'
             || Chr(31)
             || Upper(Parts.External_Service_Allowed_DB)
             || Chr(30)
             || 'MULTISITE_PLANNED_PART_DB'
             || Chr(31)
             || Parts.Multisite_Planned_Part_DB
             || Chr(30);
        E_ := 'DO';
        Ifsapp.Purchase_Part_Supplier_Api.New__(A_,B_,C_,D_,E_);
    End Loop;
END;