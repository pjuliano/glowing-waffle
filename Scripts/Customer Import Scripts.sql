DECLARE
   a_ VARCHAR2(32000) := 'TEMPLATE'; --p0
   b_ VARCHAR2(32000) := '40000'; --p1
   c_ VARCHAR2(32000) := '100'; --p2
   d_ VARCHAR2(32000) := 'Saggitariutt Jefferspin'; --p3
   e_ VARCHAR2(32000) := 'ZZZZ'; --p4
BEGIN
    --Copy customer from template
    For Cust In (Select * From KD_Customer_Import)
       Loop
            A_ := 'TEMPLATE';
            B_ := Cust.CustomerID;
            C_ := '100';
            D_ := Cust.Name;
            E_ := Cust.Association_No;
            IFSAPP.Customer_Info_API.Copy_Existing_Customer( a_ , b_ , c_ , d_ , e_ );
        End Loop;
END;

DECLARE
   a_ VARCHAR2(32000) := NULL; --p0
   b_ VARCHAR2(32000) := 'AAAUBHAARAAA/vpAAC'; --p1
   c_ VARCHAR2(32000) := '1'; --p2
   d_ VARCHAR2(32000) := 'ADDRESS1'||chr(31)||'302 Church Street'||chr(30)||'ZIP_CODE'||chr(31)||'07747'||chr(30)||'COUNTY'||chr(31)||''||chr(30)||'STATE'||chr(31)||'NJ'||chr(30)||'CITY'||chr(31)||'Aberdeen Township'||chr(30); --p3
   e_ VARCHAR2(32000) := 'DO'; --p4
BEGIN
    --Modify Address
    For Cust In (Select A.*, B.OBjversion, B.ObjID From KD_Customer_Import A, Customer_Info_Address B Where A.CustomerID = B.Customer_ID And A.Address1 Is Not Null)
        Loop
            A_ := Null;
            B_ := Cust.ObjID;
            C_ := Cust.ObjVersion;
            D_ := 'ADDRESS1'||chr(31)||Cust.Address1||chr(30)||'ADDRESS2'||chr(31)||Cust.Address2||chr(30)||'ZIP_CODE'||chr(31)||Cust.Zip_Code||chr(30)||'COUNTY'||chr(31)||''||chr(30)||'STATE'||chr(31)||Cust.State||chr(30)||'CITY'||chr(31)||Cust.City||chr(30);
            E_ := 'DO';
            IFSAPP.CUSTOMER_INFO_ADDRESS_API.MODIFY__( a_ , b_ , c_ , d_ , e_ );
        End Loop;
END;

DECLARE
   a_ VARCHAR2(32000) := NULL; --p0
   b_ VARCHAR2(32000) := 'AAAUBHAARAAA/vpAAC'; --p1
   c_ VARCHAR2(32000) := '2'; --p2
   d_ VARCHAR2(32000) := 'PRIMARY_CONTACT'||chr(31)||'Abe Froman'||chr(30); --p3
   e_ VARCHAR2(32000) := 'DO'; --p4
BEGIN
    --Add Primary Contact
    For Cust In (Select A.*, B.ObjID, B.ObjVersion From KD_Customer_Import A, Customer_Info_Address B Where A.CustomerID = B.Customer_ID And A.Address1 = B.Address1)
    Loop
        A_ := Null;
        B_ := Cust.ObjID;
        C_ := Cust.ObjVersion;
        D_ := 'PRIMARY_CONTACT'||chr(31)||Cust.Primary_Contact||chr(30); 
        E_ := 'DO';
        IFSAPP.CUSTOMER_INFO_ADDRESS_API.MODIFY__( a_ , b_ , c_ , d_ , e_ );
    End Loop;
END;

DECLARE
   a_ VARCHAR2(32000) := NULL; --p0
   b_ VARCHAR2(32000) := 'AAAbDwAARAAAHLQAAS'; --p1
   c_ VARCHAR2(32000) := '1'; --p2
   d_ VARCHAR2(32000) := 'PARTY_TYPE_DB'||chr(31)||'CUSTOMER'||chr(30)||'IDENTITY'||chr(31)||'40000'||chr(30)||'VALUE'||chr(31)||'e1adler@aol.com'||chr(30)||'ADDRESS_ID'||chr(31)||'99'||chr(30); --p3
   e_ VARCHAR2(32000) := 'DO'; --p4
BEGIN
    --Set email
    For Cust In (Select A.*, B.ObjID, B.ObjVersion From KD_Customer_Import A, COMM_METHOD B Where A.CustomerID = B.Identity And Method_ID_DB = 'E_MAIL' And A.Email Is Not Null)
    Loop
        A_ := Null;
        B_ := Cust.ObjID;
        C_ := Cust.ObjVersion;
        D_ := 'PARTY_TYPE_DB'||chr(31)||'CUSTOMER'||chr(30)||'IDENTITY'||chr(31)||Cust.CustomerID||chr(30)||'VALUE'||chr(31)||Cust.Email||chr(30)||'ADDRESS_ID'||chr(31)||'99'||chr(30);
        E_ := 'DO';
        IFSAPP.COMM_METHOD_API.MODIFY__( a_ , b_ , c_ , d_ , e_ );
    End Loop;
END;

DECLARE
   a_ VARCHAR2(32000) := NULL; --p0
   b_ VARCHAR2(32000) := 'AAAbDwAARAAAHLQAAS'; --p1
   c_ VARCHAR2(32000) := '1'; --p2
   d_ VARCHAR2(32000) := 'PARTY_TYPE_DB'||chr(31)||'CUSTOMER'||chr(30)||'IDENTITY'||chr(31)||'40000'||chr(30)||'VALUE'||chr(31)||'e1adler@aol.com'||chr(30)||'ADDRESS_ID'||chr(31)||'99'||chr(30); --p3
   e_ VARCHAR2(32000) := 'DO'; --p4
BEGIN
    --Set phone
    For Cust In (Select A.*, B.ObjID, B.ObjVersion From KD_Customer_Import A, COMM_METHOD B Where A.CustomerID = B.Identity And Method_ID_DB = 'PHONE' And A.Phone Is Not Null)
    Loop
        A_ := Null;
        B_ := Cust.ObjID;
        C_ := Cust.ObjVersion;
        D_ := 'PARTY_TYPE_DB'||chr(31)||'CUSTOMER'||chr(30)||'IDENTITY'||chr(31)||Cust.CustomerID||chr(30)||'VALUE'||chr(31)||Cust.Phone||chr(30)||'ADDRESS_ID'||chr(31)||'99'||chr(30);
        E_ := 'DO';
        IFSAPP.COMM_METHOD_API.MODIFY__( a_ , b_ , c_ , d_ , e_ );
    End Loop;
END;

DECLARE
   a_ VARCHAR2(32000) := ''; --p0
   b_ VARCHAR2(32000) := 'AAAUCQAARAAAbTOAAk'; --p1
   c_ VARCHAR2(32000) := '20190204143903'; --p2
   d_ VARCHAR2(32000) := 'REGION_CODE'||chr(31)||'USEC'||chr(30); --p3
   e_ VARCHAR2(32000) := 'DO'; --p4
BEGIN  
    --Add region code
    For Cust In (Select A.*, B.ObjID, B.ObjVersion From KD_Customer_Import A, Cust_Ord_Customer_Address_Ent B Where A.CustomerID = B.Customer_ID)
    Loop
        A_ := '';
        B_ := Cust.ObjID;
        C_ := Cust.ObjVersion;
        D_ := 'REGION_CODE'||chr(31)||Cust.Region||chr(30);
        E_ := 'DO';
        IFSAPP.CUST_ORD_CUSTOMER_ADDRESS_API.MODIFY__( a_ , b_ , c_ , d_ , e_ );
    End Loop;
END;

DECLARE
   a_ VARCHAR2(32000) := ''; --p0
   b_ VARCHAR2(32000) := 'AAAUCRAAIAAOl1EAAD'; --p1
   c_ VARCHAR2(32000) := '20190204143902'; --p2
   d_ VARCHAR2(32000) := 'CUST_GRP'||chr(31)||'IMPL'||chr(30)||'SALESMAN_CODE'||chr(31)||'101'||chr(30); --p3
   e_ VARCHAR2(32000) := 'DO'; --p4
BEGIN
    --Customer Group and Salesman Code
    For Cust In (Select A.*, B.Objversion, B.ObjID From KD_Customer_Import A, Cust_Ord_Customer_Ent B Where A.CustomerID = B.Customer_ID) 
    Loop
        A_ := '';
        B_ := Cust.ObjID;
        C_ := Cust.ObjVersion;
        D_ := 'CUST_GRP'||chr(31)||'IMPL'||chr(30)||'SALESMAN_CODE'||chr(31)||Cust.Salesman_Code||chr(30); 
        E_ := 'DO';
        IFSAPP.CUST_ORD_CUSTOMER_API.MODIFY__( a_ , b_ , c_ , d_ , e_ );
    End Loop;
END;

DECLARE
   a_ VARCHAR2(32000) := NULL; --p0
   b_ VARCHAR2(32000) := NULL; --p1
   c_ VARCHAR2(32000) := NULL; --p2
   d_ VARCHAR2(32000) := 'CUSTOMER_NO'||chr(31)||'40000'||chr(30)||'COMMISSION_RECEIVER'||chr(31)||'INSIDE1'||chr(30); --p3
   e_ VARCHAR2(32000) := 'DO'; --p4
BEGIN
    --Add Commission Receiver
    For Cust In (Select * From KD_Customer_Import Where Commission_Receiver Is Not Null)
    Loop
        A_ := Null;
        B_ := Null;
        C_ := Null;
        D_ := 'CUSTOMER_NO'||chr(31)||Cust.CustomerID||chr(30)||'COMMISSION_RECEIVER'||chr(31)||Cust.Commission_Receiver||chr(30);
        E_ := 'DO';
        IFSAPP.CUST_DEF_COM_RECEIVER_API.NEW__( a_ , b_ , c_ , d_ , e_ );
    End Loop;
END;

DECLARE
   a_ VARCHAR2(32000) := ''; --p0
   b_ VARCHAR2(32000) := 'AAAUMCAARAACH1VAAB'; --p1
   c_ VARCHAR2(32000) := '1'; --p2
   d_ VARCHAR2(32000) := 'PAY_TERM_ID'||chr(31)||'30'||chr(30); --p3
   e_ VARCHAR2(32000) := 'DO'; --p4
BEGIN
    For Cust In (Select A.*, B.ObjID, B.ObjVersion From KD_Customer_Import A, Identity_Invoice_INfo B Where A.CustomerID = B.Identity)
    Loop
        A_ := Null;
        B_ := Cust.ObjID;
        C_ := Cust.ObjVersion;
        D_ := 'PAY_TERM_ID'||chr(31)||Cust.Terms||chr(30);
        E_ := 'DO';
        IFSAPP.IDENTITY_INVOICE_INFO_API.MODIFY__( a_ , b_ , c_ , d_ , e_ );
    End Loop;    
END;

DECLARE
   a_ VARCHAR2(32000) := NULL; --p0
   b_ VARCHAR2(32000) := 'AAAbDwAAIAAM7KKABO'; --p1
   c_ VARCHAR2(32000) := '1'; --p2
   d_ VARCHAR2(32000) := 'DO'; --p3
BEGIN
    --Remove KD Customer Service email entry
    For Cust In (Select * From Comm_Method Where Value = 'customersupport@keystonedental.com' And Identity Like '40___')
    Loop
        A_ := Null;
        B_ := Cust.Objid;
        C_ := Cust.ObjVersion;
        D_ := 'DO';
        IFSAPP.COMM_METHOD_API.REMOVE__( a_ , b_ , c_ , d_ );
    End Loop;
END;
