Declare
   A_ Varchar2(32000) := Null; --p0
   B_ Varchar2(32000) := 'AAAUMEAAIAAMwlBAAA'; --p1
   C_ Varchar2(32000) := '4'; --p2
   D_ Varchar2(32000) := 'AR_CONTACT'||Chr(31)||'EDELSAPIO'||Chr(30)||'SEND_REMINDER_TO_PAYER'||Chr(31)||'FALSE'||Chr(30)||'SEND_INTEREST_INV_TO_PAYER'||Chr(31)||'FALSE'||Chr(30)||'SEND_STATEMENT_OF_ACC_TO_PAYER'||Chr(31)||'FALSE'||Chr(30); --p3
   E_ Varchar2(32000) := 'DO'; --p4
Begin
  For Cur In (Select
                A.Objid, A.Objversion
              From
                Identity_Pay_Info A
              Where
                Cust_Ord_Customer_Api.Get_Salesman_Code(A.Identity) In ('123','225','126','124','24','226','305','308','301','308','304','125','325','217','303,','311','303','311','314','136','324'))
  Loop
    A_ := Null;
    B_ := Cur.Objid;
    C_ := Cur.Objversion;
    D_ := 'AR_CONTACT'||Chr(31)||'EDELSAPIO'||Chr(30)||'SEND_REMINDER_TO_PAYER'||Chr(31)||'FALSE'||Chr(30)||'SEND_INTEREST_INV_TO_PAYER'||Chr(31)||'FALSE'||Chr(30)||'SEND_STATEMENT_OF_ACC_TO_PAYER'||Chr(31)||'FALSE'||Chr(30);
    E_ := 'DO';
    Identity_Pay_Info_Api.Modify__( A_ , B_ , C_ , D_ , E_ );
  End Loop;
End;
