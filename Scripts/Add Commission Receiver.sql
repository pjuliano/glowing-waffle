DECLARE
   a_ VARCHAR2(32000) := NULL; --p0
   b_ VARCHAR2(32000) := NULL; --p1
   c_ VARCHAR2(32000) := NULL; --p2
   d_ VARCHAR2(32000) := 'CUSTOMER_NO'||chr(31)||'11408'||chr(30)||'COMMISSION_RECEIVER'||chr(31)||'INSIDE6'||chr(30); --p3
   e_ VARCHAR2(32000) := 'DO'; --p4
Begin
  For Cur In (Select Customer As Customer_No, Substr(Substr(Issue,31),1,Length(Substr(Issue,31))-1) As NEWIS From KD_Customer_Check Where Issue Like 'Commission receiver should be%')
  Loop
    A_ := Null;
    B_ := Null;
    C_ := Null;
    D_ := 'CUSTOMER_NO'||chr(31)||Cur.Customer_No||chr(30)||'COMMISSION_RECEIVER'||chr(31)||Cur.NEWIS||chr(30);
    IFSAPP.CUST_DEF_COM_RECEIVER_API.NEW__( a_ , b_ , c_ , d_ , e_ );

   ----------------------------------
   ---Dbms_Output Section---
   ----------------------------------
   Dbms_Output.Put_Line('a_=' || a_);
   Dbms_Output.Put_Line('b_=' || b_);
   Dbms_Output.Put_Line('c_=' || c_);
   Dbms_Output.Put_Line('d_=' || d_);
   Dbms_Output.Put_Line('e_=' || e_);
   ----------------------------------
  End Loop;
End;
