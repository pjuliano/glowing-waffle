Declare
   A_ Varchar2(32000) := Null; --p0
   B_ Varchar2(32000) := Null; --p1
   C_ Varchar2(32000) := Null; --p2
   D_ Varchar2(32000) := Null; --p3
   E_ Varchar2(32000) := 'DO'; --p4
Begin
  For Cur In (Select
                A.Customer_ID, A.Objid, A.Objversion
              From
                Identity_Pay_Info A
              Where
                Cust_Ord_Customer_Api.Get_Salesman_Code(A.Customer_Id) In ('103','215','223','201','204','134','121','101','111','131','102','221','202','115','116','112','104','133') And
                A.Company = '100')
  Loop
    A_ := Null;
    B_ := Cur.Objid;
    C_ := Cur.Objversion;
    D_ := 'AR_CONTACT'||Chr(31)||'CHANSON'||Chr(30)||'SEND_REMINDER_TO_PAYER'||Chr(31)||'FALSE'||Chr(30)||'SEND_INTEREST_INV_TO_PAYER'||Chr(31)||'FALSE'||Chr(30)||'SEND_STATEMENT_OF_ACC_TO_PAYER'||Chr(31)||'FALSE'||Chr(30);
    E_ := 'DO';
    Identity_Pay_Info_Api.Modify__( A_ , B_ , C_ , D_ , E_ );
  End Loop;
End;
