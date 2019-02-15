DECLARE
   a_ VARCHAR2(32000) := NULL; --p0
   b_ VARCHAR2(32000) := NULL; --p1
   c_ VARCHAR2(32000) := NULL; --p2
   d_ VARCHAR2(32000) := 'CUSTOMER_NO'||chr(31)||'11408'||chr(30)||'COMMISSION_RECEIVER'||chr(31)||'INSIDE6'||chr(30); --p3
   e_ VARCHAR2(32000) := 'DO'; --p4
Begin
  For Cur In (Select 
  G.Customer_Id,
  Q.Is_Rep_Id,
  'Commission receiver does not exist.'
From
  Ifsapp.Customer_Info G Left Join Ifsapp.Cust_Def_Com_Receiver H 
    On G.Customer_Id = H.Customer_No
                         Left Join IFSapp.KD_Inside_Rep_Assignments Q on Cust_Ord_Customer_Api.Get_Salesman_Code(G.Customer_ID) = Q.Rep_ID
Where 
  H.Commission_Receiver Is Null And
  G.Corporate_Form = 'DOMDIR' And
  G.Customer_Id Not In ('CATEMP','TEMPLATE','5593','A29830') And
  Cust_Ord_Customer_Api.Get_Salesman_Code(G.Customer_Id) != '999')
Loop
    A_ := Null;
    B_ := Null;
    C_ := Null;
    D_ := 'CUSTOMER_NO'||chr(31)||Cur.Customer_ID||chr(30)||'COMMISSION_RECEIVER'||chr(31)||Cur.IS_Rep_ID||chr(30);
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
