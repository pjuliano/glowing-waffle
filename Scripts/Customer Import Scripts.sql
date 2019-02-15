DECLARE
   a_ VARCHAR2(32000) := 'TEMPLATE'; --p0
   b_ VARCHAR2(32000) := '40000'; --p1
   c_ VARCHAR2(32000) := '100'; --p2
   d_ VARCHAR2(32000) := 'Saggitariutt Jefferspin'; --p3
   e_ VARCHAR2(32000) := 'ZZZZ'; --p4
BEGIN
    --Copy customer from template
    IFSAPP.Customer_Info_API.Copy_Existing_Customer( a_ , b_ , c_ , d_ , e_ );
END;

DECLARE
   a_ VARCHAR2(32000) := NULL; --p0
   b_ VARCHAR2(32000) := 'AAAUBHAARAAA/vpAAC'; --p1
   c_ VARCHAR2(32000) := '1'; --p2
   d_ VARCHAR2(32000) := 'ADDRESS1'||chr(31)||'302 Church Street'||chr(30)||'ZIP_CODE'||chr(31)||'07747'||chr(30)||'COUNTY'||chr(31)||''||chr(30)||'STATE'||chr(31)||'NJ'||chr(30)||'CITY'||chr(31)||'Aberdeen Township'||chr(30); --p3
   e_ VARCHAR2(32000) := 'DO'; --p4
BEGIN
    --Modify Address
    IFSAPP.CUSTOMER_INFO_ADDRESS_API.MODIFY__( a_ , b_ , c_ , d_ , e_ );
END;

DECLARE
   a_ VARCHAR2(32000) := NULL; --p0
   b_ VARCHAR2(32000) := 'AAAUBHAARAAA/vpAAC'; --p1
   c_ VARCHAR2(32000) := '2'; --p2
   d_ VARCHAR2(32000) := 'PRIMARY_CONTACT'||chr(31)||'Abe Froman'||chr(30); --p3
   e_ VARCHAR2(32000) := 'DO'; --p4
BEGIN
    --Add Primary Contact
    IFSAPP.CUSTOMER_INFO_ADDRESS_API.MODIFY__( a_ , b_ , c_ , d_ , e_ );
END;

DECLARE
   a_ VARCHAR2(32000) := NULL; --p0
   b_ VARCHAR2(32000) := 'AAAbDwAARAAAHLQAAS'; --p1
   c_ VARCHAR2(32000) := '1'; --p2
   d_ VARCHAR2(32000) := 'PARTY_TYPE_DB'||chr(31)||'CUSTOMER'||chr(30)||'IDENTITY'||chr(31)||'40000'||chr(30)||'VALUE'||chr(31)||'e1adler@aol.com'||chr(30)||'ADDRESS_ID'||chr(31)||'99'||chr(30); --p3
   e_ VARCHAR2(32000) := 'DO'; --p4
BEGIN
    --Set phone; Run once per method.
    IFSAPP.COMM_METHOD_API.MODIFY__( a_ , b_ , c_ , d_ , e_ );
END;

DECLARE
   a_ VARCHAR2(32000) := ''; --p0
   b_ VARCHAR2(32000) := 'AAAUCQAARAAAbTOAAk'; --p1
   c_ VARCHAR2(32000) := '20190204143903'; --p2
   d_ VARCHAR2(32000) := 'REGION_CODE'||chr(31)||'USEC'||chr(30); --p3
   e_ VARCHAR2(32000) := 'DO'; --p4
BEGIN  
    --Add region code
    IFSAPP.CUST_ORD_CUSTOMER_ADDRESS_API.MODIFY__( a_ , b_ , c_ , d_ , e_ );
END;

DECLARE
   a_ VARCHAR2(32000) := ''; --p0
   b_ VARCHAR2(32000) := 'AAAUCRAAIAAOl1EAAD'; --p1
   c_ VARCHAR2(32000) := '20190204143902'; --p2
   d_ VARCHAR2(32000) := 'CUST_GRP'||chr(31)||'IMPL'||chr(30)||'SALESMAN_CODE'||chr(31)||'101'||chr(30); --p3
   e_ VARCHAR2(32000) := 'DO'; --p4
BEGIN
    --Customer Group and Salesman Code   
    IFSAPP.CUST_ORD_CUSTOMER_API.MODIFY__( a_ , b_ , c_ , d_ , e_ );
END;

DECLARE
   a_ VARCHAR2(32000) := NULL; --p0
   b_ VARCHAR2(32000) := NULL; --p1
   c_ VARCHAR2(32000) := NULL; --p2
   d_ VARCHAR2(32000) := 'CUSTOMER_NO'||chr(31)||'40000'||chr(30)||'COMMISSION_RECEIVER'||chr(31)||'INSIDE1'||chr(30); --p3
   e_ VARCHAR2(32000) := 'DO'; --p4
BEGIN
    --Add Commission Receiver
    IFSAPP.CUST_DEF_COM_RECEIVER_API.NEW__( a_ , b_ , c_ , d_ , e_ );
END;

DECLARE
   a_ VARCHAR2(32000) := NULL; --p0
   b_ VARCHAR2(32000) := 'AAAUVuAAIAAM1rYABf'; --p1
   c_ VARCHAR2(32000) := '2'; --p2
   d_ VARCHAR2(32000) := 'COMPANY'||chr(31)||'100'||chr(30)||'IDENTITY'||chr(31)||'40000'||chr(30)||'PARTY_TYPE'||chr(31)||'Customer'||chr(30)||'PARTY_TYPE_DB'||chr(31)||'CUSTOMER'||chr(30)||'WAY_ID'||chr(31)||'CC'||chr(30)||'DEFAULT_PAYMENT_WAY'||chr(31)||'TRUE'||chr(30); --p3
   e_ VARCHAR2(32000) := 'DO'; --p4
BEGIN
    --Set payment terms
    IFSAPP.PAYMENT_WAY_PER_IDENTITY_API.NEW__( a_ , b_ , c_ , d_ , e_ );
END;
