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
                a.AR_Contact = 'CHANSON' And
                A.Company = '100')
  Loop
    A_ := Null;
    B_ := Cur.Objid;
    C_ := Cur.Objversion;
    D_ := 'AR_CONTACT'||Chr(31)||'EDELSAPIO'||Chr(30)||'SEND_REMINDER_TO_PAYER'||Chr(31)||'FALSE'||Chr(30)||'SEND_INTEREST_INV_TO_PAYER'||Chr(31)||'FALSE'||Chr(30)||'SEND_STATEMENT_OF_ACC_TO_PAYER'||Chr(31)||'FALSE'||Chr(30);
    E_ := 'DO';
    Identity_Pay_Info_Api.Modify__( A_ , B_ , C_ , D_ , E_ );
  End Loop;
End;
