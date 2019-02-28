DECLARE
   a_ VARCHAR2(32000) := NULL; --p0
   b_ VARCHAR2(32000) := NULL; --p1
   c_ VARCHAR2(32000) := NULL; --p2
   d_ VARCHAR2(32000) := 'CUSTOMER_NO'||chr(31)||'11408'||chr(30)||'COMMISSION_RECEIVER'||chr(31)||'INSIDE6'||chr(30); --p3
   e_ VARCHAR2(32000) := 'DO'; --p4
Begin
  For Cur In (Select Customer_ID From Customer_Info Where Customer_ID In ('D44059',
'A35515',
'A46437',
'19203-02',
'15606',
'A26924',
'15836',
'6958',
'A76355',
'7756',
'4393',
'A23551',
'17941',
'A48357',
'15499',
'17085',
'12868',
'5494',
'A35987',
'13567',
'A35979',
'8563',
'A27982'))
Loop
    A_ := Null;
    B_ := Null;
    C_ := Null;
    D_ := 'CUSTOMER_NO'||chr(31)||Cur.Customer_ID||chr(30)||'COMMISSION_RECEIVER'||chr(31)||'INSIDE9'||chr(30);
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
