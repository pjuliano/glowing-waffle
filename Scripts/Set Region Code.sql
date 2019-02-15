
    
DECLARE
   a_ VARCHAR2(32000) := ''; --p0
   b_ VARCHAR2(32000) := 'AAAUCQAAIAAMr88AAg'; --p1
   c_ VARCHAR2(32000) := '20161101155114'; --p2
   d_ VARCHAR2(32000) := 'REGION_CODE'||chr(31)||'USNC'||chr(30); --p3
   e_ VARCHAR2(32000) := 'DO'; --p4
BEGIN
For Cur In (SELECT
                Customer_ID,
                Objid,
                Objversion,
                Region
            FROM
                Cust_Ord_Customer_Address_Ent,
                Srrepquota
            WHERE
                Cust_Ord_Customer_Api.Get_Salesman_Code(Customer_ID) = Repnumber And
                Region_Code != Region)
Loop
    A_:= '';
    B_:= Cur.Objid;
    C_:= Cur.Objversion;
    D_:= 'REGION_CODE'||chr(31)||Cur.Region||chr(30);
    E_:= 'DO';
    IFSAPP.CUST_ORD_CUSTOMER_ADDRESS_API.MODIFY__( a_ , b_ , c_ , d_ , e_ );
End loop;
END;
