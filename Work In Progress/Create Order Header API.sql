DECLARE
   a_ VARCHAR2(32000) := NULL; --p0
   b_ VARCHAR2(32000) := NULL; --p1
   C_ Varchar2(32000) := Null; --p2
   d_ VARCHAR2(32000) := 'ORDER_NO'||chr(31)||''||chr(30)||'CUSTOMER_NO'||chr(31)||'29524'||chr(30)||'WANTED_DELIVERY_DATE'||chr(31)||''||chr(30)||'ORDER_ID'||chr(31)||Cust_Ord_Customer_Api.Get_Order_Id('29524')||chr(30)||'AUTHORIZE_CODE'||chr(31)||'JDRZYZGA'||chr(30)||'CONTRACT'||chr(31)||'100'||chr(30)||'CURRENCY_CODE'||chr(31)||Cust_Ord_Customer_Api.Get_Currency_Code('29524')||chr(30)||'ADDITIONAL_DISCOUNT'||chr(31)||'0'||chr(30)||'PRIORITY'||chr(31)||Cust_Ord_Customer_Api.Get_Priority('29524')||chr(30)||'CUST_REF'||chr(31)||Cust_Ord_Customer_Api.Get_Cust_Ref('29524')||chr(30)||'SHIP_ADDR_NO'||chr(31)||Customer_Info_Address_Api.Get_Default_Address('29524','Delivery')||chr(30)||'BILL_ADDR_NO'||chr(31)||Customer_Info_Address_Api.Get_Default_Address('29524','Pay')||chr(30)||'SHIP_VIA_CODE'||chr(31)||Cust_Ord_Customer_Address_Api.Get_Ship_Via_Code('29524',Customer_Info_Address_Api.Get_Default_Address('29524','Delivery'))||chr(30)||'DELIVERY_TERMS'||chr(31)||Cust_Ord_Customer_Address_Api.Get_Delivery_Terms('29524',Customer_Info_Address_Api.Get_Default_Address('29524','Delivery'))||chr(30)||'DEL_TERMS_LOCATION'||chr(31)||Cust_Ord_Customer_Address_Api.Get_Del_Terms_Location('29524',Customer_Info_Address_Api.Get_Default_Address('29524','Delivery'))||chr(30)||'ROUTE_ID'||chr(31)||Cust_Ord_Customer_Address_Api.Get_Route_ID('29524',Customer_Info_Address_Api.Get_Default_Address('29524','Delivery'))||chr(30)||'FORWARD_AGENT_ID'||chr(31)||Cust_Ord_Customer_Api.Get_Forward_Agent_Id('29524')||chr(30)||'CUST_CALENDAR_ID'||chr(31)||Cust_Ord_Customer_Address_Api.Get_Cust_Calendar_Id('29524',Customer_Info_Address_Api.Get_Default_Address('29524','Delivery'))||chr(30)||'EXT_TRANSPORT_CALENDAR_ID'||chr(31)||''||chr(30)||'SHIPMENT_CREATION'||chr(31)||Cust_Ord_Customer_Address_Api.Get_Shipment_Creation('29524',Customer_Info_Address_Api.Get_Default_Address('29524','Delivery'))||chr(30)||'BACKORDER_OPTION'||chr(31)||Cust_Ord_Customer_Api.Get_Backorder_Option('29524')||chr(30)||'FREIGHT_MAP_ID'||chr(31)||Customer_Address_Leadtime_Api.Get_Freight_Map_Id('29524',Customer_Info_Address_Api.Get_Default_Address('29524','Delivery'),Cust_Ord_Customer_Address_Api.Get_Ship_Via_Code('29524',Customer_Info_Address_Api.Get_Default_Address('29524','Delivery')),'100')||chr(30)||'ZONE_ID'||chr(31)||Customer_Address_Leadtime_Api.Get_Zone_Id('29524',Customer_Info_Address_Api.Get_Default_Address('29524','Delivery'),Cust_Ord_Customer_Address_Api.Get_Ship_Via_Code('29524',Customer_Info_Address_Api.Get_Default_Address('29524','Delivery')),'100')||chr(30)||'FREIGHT_PRICE_LIST_NO'||chr(31)||''||chr(30)||'APPLY_FIX_DELIV_FREIGHT_DB'||chr(31)||'FALSE'||chr(30)||'INTRASTAT_EXEMPT_DB'||chr(31)||Cust_Ord_Customer_Address_Api.Get_Intrastat_Exempt_Db('29524',Customer_Info_Address_Api.Get_Default_Address('29524','Delivery'))||chr(30)||'CONFIRM_DELIVERIES_DB'||chr(31)||Cust_Ord_Customer_Api.Get_Confirm_Deliveries_Db('29524')||chr(30)||'CHECK_SALES_GRP_DELIV_CONF_DB'||chr(31)||Upper(Cust_Ord_Customer_Api.Get_Check_Sales_Grp_Deliv_Conf('29524'))||chr(30)||'DELIVERY_LEADTIME'||chr(31)||Customer_Address_Leadtime_Api.Get_Delivery_Leadtime('29524',Customer_Info_Address_Api.Get_Default_Address('29524','Delivery'),Cust_Ord_Customer_Address_Api.Get_Ship_Via_Code('29524',Customer_Info_Address_Api.Get_Default_Address('29524','Delivery')),'100')||chr(30)||'PICK_INVENTORY_TYPE_DB'||chr(31)||'ORDINV'||chr(30)||'USE_PRE_SHIP_DEL_NOTE_DB'||chr(31)||'FALSE'||chr(30)||'SALESMAN_CODE'||chr(31)||Cust_Ord_Customer_Api.Get_Salesman_Code('29524')||chr(30)||'AGREEMENT_ID'||chr(31)||''||chr(30)||'LANGUAGE_CODE'||chr(31)||Cust_Ord_Customer_Api.Get_Language_Code('29524')||chr(30)||'VAT_NO'||chr(31)||Cust_Ord_Customer_Address_Api.Get_Vat('29524',Customer_Info_Address_Api.Get_Default_Address('29524','Delivery'),'100')||chr(30)||'VAT_DB'||chr(31)||CUST_ORD_CUSTOMER_ADDRESS_API.Get_Vat_DB('29524',Customer_Info_Address_Api.Get_Default_Address('29524','Delivery'),'100','US')||chr(30)||'TAX_LIABILITY'||chr(31)||Customer_Delivery_Tax_Info_Api.Get_Liability_Db('29524',Customer_Info_Address_Api.Get_Default_Address('29524','Delivery'),'100','US',Sysdate)||chr(30)||'PAY_TERM_ID'||chr(31)||Identity_Invoice_Info_Api.Get_Pay_Term_Id('100','29524',Customer_Info_Api.Get_Party_Type('29524'))||chr(30)||'PROPOSED_PREPAYMENT_AMOUNT'||chr(31)||'0'||chr(30)||'JINSUI_INVOICE_DB'||chr(31)||'FALSE'||chr(30)||'REGION_CODE'||chr(31)||CUST_ORD_CUSTOMER_ADDRESS_API.Get_Region_Code('29524',Customer_Info_Address_Api.Get_Default_Address('29524','Delivery'))||chr(30)||'DISTRICT_CODE'||chr(31)||CUST_ORD_CUSTOMER_ADDRESS_API.Get_District_Code('29524',Customer_Info_Address_Api.Get_Default_Address('29524','Delivery'))||chr(30)||'MARKET_CODE'||chr(31)||''||chr(30)||'CLASSIFICATION_STANDARD'||chr(31)||''||chr(30)||'SUPPLY_COUNTRY'||chr(31)||'UNITED STATES'||chr(30)||'CUSTOMER_NO_PAY_ADDR_NO'||chr(31)||''||chr(30)||'SM_CONNECTION_DB'||chr(31)||'NOT CONNECTED'||chr(30)||'SCHEDULING_CONNECTION_DB'||chr(31)||'NOT SCHEDULE'||chr(30)||'PRINT_CONTROL_CODE'||chr(31)||''||chr(30)||'ORDER_CONF_FLAG_DB'||chr(31)||'N'||chr(30)||'PACK_LIST_FLAG_DB'||chr(31)||'Y'||chr(30)||'PICK_LIST_FLAG_DB'||chr(31)||'Y'||chr(30)||'ORDER_CONF_DB'||chr(31)||'N'||chr(30)||'SUMMARIZED_SOURCE_LINES_DB'||chr(31)||'Y'||chr(30)||'SUMMARIZED_FREIGHT_CHARGES_DB'||chr(31)||'Y'||chr(30)||'PRINT_DELIVERED_LINES_DB'||chr(31)||'FALSE'||chr(30); --p3
   e_ VARCHAR2(32000) := 'DO'; --p4
BEGIN

    
IFSAPP.CUSTOMER_ORDER_API.NEW__( a_ , b_ , c_ , d_ , e_ );

   ----------------------------------
   ---Dbms_Output Section---
   ----------------------------------
   Dbms_Output.Put_Line('a_=' || a_);
   Dbms_Output.Put_Line('b_=' || b_);
   Dbms_Output.Put_Line('c_=' || c_);
   Dbms_Output.Put_Line('d_=' || d_);
   Dbms_Output.Put_Line('e_=' || e_);
   ----------------------------------

End;