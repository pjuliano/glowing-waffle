DECLARE
   a_ VARCHAR2(32000) := NULL; --p0
   b_ VARCHAR2(32000) := NULL; --p1
   c_ VARCHAR2(32000) := NULL; --p2
   d_ VARCHAR2(32000) := 'ORDER_NO'||chr(31)||''||chr(30)||'CUSTOMER_NO'||chr(31)||'29524'||chr(30)||'WANTED_DELIVERY_DATE'||chr(31)||'2020-01-11-00.00.00'||chr(30)||'ORDER_ID'||chr(31)||'NO'||chr(30)||'AUTHORIZE_CODE'||chr(31)||'JDRZYZGA'||chr(30)||'CONTRACT'||chr(31)||'100'||chr(30)||'CURRENCY_CODE'||chr(31)||'USD'||chr(30)||'ADDITIONAL_DISCOUNT'||chr(31)||'0'||chr(30)||'PRIORITY'||chr(31)||''||chr(30)||'CUST_REF'||chr(31)||''||chr(30)||'SHIP_ADDR_NO'||chr(31)||'99'||chr(30)||'BILL_ADDR_NO'||chr(31)||'99'||chr(30)||'SHIP_VIA_CODE'||chr(31)||'BW2'||chr(30)||'DELIVERY_TERMS'||chr(31)||'F01'||chr(30)||'DEL_TERMS_LOCATION'||chr(31)||''||chr(30)||'ROUTE_ID'||chr(31)||''||chr(30)||'FORWARD_AGENT_ID'||chr(31)||''||chr(30)||'CUST_CALENDAR_ID'||chr(31)||''||chr(30)||'EXT_TRANSPORT_CALENDAR_ID'||chr(31)||''||chr(30)||'SHIPMENT_CREATION'||chr(31)||'No Automatic Creation'||chr(30)||'BACKORDER_OPTION'||chr(31)||'Allow Incomplete Lines and Packages'||chr(30)||'FREIGHT_MAP_ID'||chr(31)||''||chr(30)||'ZONE_ID'||chr(31)||''||chr(30)||'FREIGHT_PRICE_LIST_NO'||chr(31)||''||chr(30)||'APPLY_FIX_DELIV_FREIGHT_DB'||chr(31)||'FALSE'||chr(30)||'INTRASTAT_EXEMPT_DB'||chr(31)||'INCLUDE'||chr(30)||'CONFIRM_DELIVERIES_DB'||chr(31)||'FALSE'||chr(30)||'CHECK_SALES_GRP_DELIV_CONF_DB'||chr(31)||'FALSE'||chr(30)||'DELIVERY_LEADTIME'||chr(31)||'2'||chr(30)||'PICK_INVENTORY_TYPE_DB'||chr(31)||'ORDINV'||chr(30)||'USE_PRE_SHIP_DEL_NOTE_DB'||chr(31)||'FALSE'||chr(30)||'SALESMAN_CODE'||chr(31)||'101'||chr(30)||'AGREEMENT_ID'||chr(31)||''||chr(30)||'LANGUAGE_CODE'||chr(31)||'en'||chr(30)||'VAT_NO'||chr(31)||''||chr(30)||'VAT_DB'||chr(31)||'Y'||chr(30)||'TAX_LIABILITY'||chr(31)||'TAX'||chr(30)||'PAY_TERM_ID'||chr(31)||'CC'||chr(30)||'PROPOSED_PREPAYMENT_AMOUNT'||chr(31)||'0'||chr(30)||'JINSUI_INVOICE_DB'||chr(31)||'FALSE'||chr(30)||'REGION_CODE'||chr(31)||'USEC'||chr(30)||'DISTRICT_CODE'||chr(31)||'DOMDIR'||chr(30)||'MARKET_CODE'||chr(31)||''||chr(30)||'CLASSIFICATION_STANDARD'||chr(31)||''||chr(30)||'SUPPLY_COUNTRY'||chr(31)||'UNITED STATES'||chr(30)||'CUSTOMER_NO_PAY_ADDR_NO'||chr(31)||''||chr(30)||'SM_CONNECTION_DB'||chr(31)||'NOT CONNECTED'||chr(30)||'SCHEDULING_CONNECTION_DB'||chr(31)||'NOT SCHEDULE'||chr(30)||'PRINT_CONTROL_CODE'||chr(31)||''||chr(30)||'ORDER_CONF_FLAG_DB'||chr(31)||'N'||chr(30)||'PACK_LIST_FLAG_DB'||chr(31)||'Y'||chr(30)||'PICK_LIST_FLAG_DB'||chr(31)||'Y'||chr(30)||'ORDER_CONF_DB'||chr(31)||'N'||chr(30)||'SUMMARIZED_SOURCE_LINES_DB'||chr(31)||'Y'||chr(30)||'SUMMARIZED_FREIGHT_CHARGES_DB'||chr(31)||'Y'||chr(30)||'PRINT_DELIVERED_LINES_DB'||chr(31)||'FALSE'||chr(30); --p3
BEGIN
    d_ := 
        'ORDER_NO'||chr(31)||''||chr(30)||
        'CUSTOMER_NO'||chr(31)||'2513'||chr(30)||
        'WANTED_DELIVERY_DATE'||chr(31)||TO_CHAR(SYSDATE + NVL(customer_address_leadtime_api.get_delivery_leadtime('2513',customer_info_address_api.get_default_address('2513','Delivery'),cust_ord_customer_address_api.get_ship_via_code('2513',customer_info_address_api.get_default_address('2513','Delivery')),'100'),2),'YYYY-MM-DD') || '-00.00.00'||chr(30)||
        'ORDER_ID'||chr(31)||'EO'||chr(30)||
        'AUTHORIZE_CODE'||chr(31)||'ECOM'||chr(30)||
        'CONTRACT'||chr(31)||'100'||chr(30)||
        'CURRENCY_CODE'||chr(31)||'USD'||chr(30)||
        'ADDITIONAL_DISCOUNT'||chr(31)||'0'||chr(30)||
        'PRIORITY'||chr(31)||''||chr(30)||
        'CUST_REF'||chr(31)||''||chr(30)||
        'SHIP_ADDR_NO'||chr(31)||customer_info_address_api.get_default_address('2513','Delivery')||chr(30)||
        'BILL_ADDR_NO'||chr(31)||customer_info_address_api.get_default_address('2513','Pay')||chr(30)||
        'SHIP_VIA_CODE'||chr(31)||cust_ord_customer_address_api.get_ship_via_code('2513',customer_info_address_api.get_default_address('2513','Delivery'))||chr(30)||
        'DELIVERY_TERMS'||chr(31)||cust_ord_customer_address_api.get_delivery_terms('2513',customer_info_address_api.get_default_address('2513','Delivery'))||chr(30)||
        'DEL_TERMS_LOCATION'||chr(31)||''||chr(30)||
        'ROUTE_ID'||chr(31)||''||chr(30)||
        'FORWARD_AGENT_ID'||chr(31)||''||chr(30)||
        'CUST_CALENDAR_ID'||chr(31)||''||chr(30)||
        'EXT_TRANSPORT_CALENDAR_ID'||chr(31)||''||chr(30)||
        'SHIPMENT_CREATION'||chr(31)||'No Automatic Creation'||chr(30)||
        'BACKORDER_OPTION'||chr(31)||'Allow Incomplete Lines and Packages'||chr(30)||
        'FREIGHT_MAP_ID'||chr(31)||''||chr(30)||
        'ZONE_ID'||chr(31)||''||chr(30)||
        'FREIGHT_PRICE_LIST_NO'||chr(31)||''||chr(30)||
        'APPLY_FIX_DELIV_FREIGHT_DB'||chr(31)||'FALSE'||chr(30)||
        'INTRASTAT_EXEMPT_DB'||chr(31)||'INCLUDE'||chr(30)||
        'CONFIRM_DELIVERIES_DB'||chr(31)||'FALSE'||chr(30)||
        'CHECK_SALES_GRP_DELIV_CONF_DB'||chr(31)||'FALSE'||chr(30)||
        'DELIVERY_LEADTIME'||chr(31)||customer_address_leadtime_api.get_delivery_leadtime('2513',customer_info_address_api.get_default_address('2513','Delivery'),cust_ord_customer_address_api.get_ship_via_code('2513',customer_info_address_api.get_default_address('2513','Delivery')),'100')||chr(30)||
        'PICK_INVENTORY_TYPE_DB'||chr(31)||'ORDINV'||chr(30)||
        'USE_PRE_SHIP_DEL_NOTE_DB'||chr(31)||'FALSE'||chr(30)||
        'SALESMAN_CODE'||chr(31)||cust_ord_customer_api.get_salesman_code('2513')||chr(30)||
        'AGREEMENT_ID'||chr(31)||''||chr(30)||
        'LANGUAGE_CODE'||chr(31)||'en'||chr(30)||
        'VAT_NO'||chr(31)||''||chr(30)||
        'VAT_DB'||chr(31)||'Y'||chr(30)||
        'TAX_LIABILITY'||chr(31)||'EXEMPT'||chr(30)||
        'PAY_TERM_ID'||chr(31)||'ECOM'||chr(30)||
        'PROPOSED_PREPAYMENT_AMOUNT'||chr(31)||'0'||chr(30)||
        'JINSUI_INVOICE_DB'||chr(31)||'FALSE'||chr(30)||
        'REGION_CODE'||chr(31)||cust_ord_customer_address_api.get_region_code('2513',customer_info_address_api.get_default_address('2513','Delivery'))||chr(30)||
        'DISTRICT_CODE'||chr(31)||cust_ord_customer_address_api.get_district_code('2513',customer_info_address_api.get_default_address('2513','Delivery'))||chr(30)||
        'MARKET_CODE'||chr(31)||''||chr(30)||
        'CLASSIFICATION_STANDARD'||chr(31)||''||chr(30)||
        'SUPPLY_COUNTRY'||chr(31)||'UNITED STATES'||chr(30)||
        'CUSTOMER_NO_PAY_ADDR_NO'||chr(31)||''||chr(30)||
        'SM_CONNECTION_DB'||chr(31)||'NOT CONNECTED'||chr(30)||
        'SCHEDULING_CONNECTION_DB'||chr(31)||'NOT SCHEDULE'||chr(30)||
        'PRINT_CONTROL_CODE'||chr(31)||''||chr(30)||
        'ORDER_CONF_FLAG_DB'||chr(31)||'N'||chr(30)||
        'PACK_LIST_FLAG_DB'||chr(31)||'Y'||chr(30)||
        'PICK_LIST_FLAG_DB'||chr(31)||'Y'||chr(30)||
        'ORDER_CONF_DB'||chr(31)||'N'||chr(30)||
        'SUMMARIZED_SOURCE_LINES_DB'||chr(31)||'Y'||chr(30)||
        'SUMMARIZED_FREIGHT_CHARGES_DB'||chr(31)||'Y'||chr(30)||
        'PRINT_DELIVERED_LINES_DB'||chr(31)||'FALSE'||chr(30);
    IFSAPP.CUSTOMER_ORDER_API.NEW__( a_ , b_ , c_ , d_ , 'DO' );
    ----------------------------------
    ---Dbms_Output Section---
    ----------------------------------
    --Dbms_Output.Put_Line('a_=' || a_);
    Dbms_Output.Put_Line('b_=' || b_);
    --Dbms_Output.Put_Line('c_=' || c_);
    --Dbms_Output.Put_Line('d_=' || d_);
    ----------------------------------
    
END;
