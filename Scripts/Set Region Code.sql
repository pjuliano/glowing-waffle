
    
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
                Objversion
            FROM
                Cust_Ord_Customer_Address_Ent
            WHERE
                Customer_ID In ('N1036',
'N1037',
'N1038',
'N1043',
'N1044',
'N1045',
'N1042',
'N1041',
'N1047',
'N1039',
'N1040',
'N1048',
'N1049',
'N1050',
'N1051',
'N1058',
'N1056',
'N1054',
'N1059',
'N1057',
'N1061',
'N1060',
'N1053',
'N1055'
                
                ))
Loop
    A_:= '';
    B_:= Cur.Objid;
    C_:= Cur.Objversion;
    D_:= 'REGION_CODE'||chr(31)||'USNA'||chr(30);
    E_:= 'DO';
    IFSAPP.CUST_ORD_CUSTOMER_ADDRESS_API.MODIFY__( a_ , b_ , c_ , d_ , e_ );
    Commit;
End loop;
END;
