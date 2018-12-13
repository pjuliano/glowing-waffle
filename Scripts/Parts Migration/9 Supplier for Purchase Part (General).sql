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
    Ifsapp.Purchase_Part_Supplier_Api.New__(A_,B_,C_,D_,E_);
END;