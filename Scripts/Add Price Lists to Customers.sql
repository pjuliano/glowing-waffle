DECLARE
   a_ VARCHAR2(32000) := NULL; --p0
   b_ VARCHAR2(32000) := NULL; --p1
   c_ VARCHAR2(32000) := NULL; --p2
   d_ VARCHAR2(32000) := 'SALES_PRICE_GROUP_ID'||chr(31)||'PROS'||chr(30)||'CURRENCY_CODE'||chr(31)||'USD'||chr(30)||'PRICE_LIST_NO'||chr(31)||'CLRCHCPROS'||chr(30)||'CUSTOMER_ID'||chr(31)||'A26898'||chr(30); --p3
   e_ VARCHAR2(32000) := 'DO'; --p4
BEGIN

  For Cur In (Select * From Customer_Info A Where A.Association_No = 'N1003')
  Loop
    A_ := Null;
    B_ := Null;
    C_ := Null;
    D_ := 'SALES_PRICE_GROUP_ID'||Chr(31)||'PROS'||Chr(30)||'CURRENCY_CODE'||Chr(31)||'USD'||Chr(30)||'PRICE_LIST_NO'||Chr(31)||'CLRCHCPROS'||Chr(30)||'CUSTOMER_ID'||Chr(31)||Cur.Customer_Id||Chr(30);
    e_:= 'DO';
    Ifsapp.Customer_Pricelist_Api.New__( A_ , B_ , C_ , D_ , E_ );
  End loop;
   ----------------------------------
   ---Dbms_Output Section---
   ----------------------------------
   Dbms_Output.Put_Line('a_=' || a_);
   Dbms_Output.Put_Line('b_=' || b_);
   Dbms_Output.Put_Line('c_=' || c_);
   Dbms_Output.Put_Line('d_=' || d_);
   Dbms_Output.Put_Line('e_=' || e_);
   ----------------------------------

END;
