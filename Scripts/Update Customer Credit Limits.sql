Declare
   A_ Varchar2(32000) := Null; --p0
   B_ Varchar2(32000) := 'AAAUBDAAIAAABBcAAg'; --p1
   C_ Varchar2(32000) := '20170208095357'; --p2
   D_ Varchar2(32000) := 'CREDIT_LIMIT'||Chr(31)||'10000'||Chr(30); --p3
   E_ Varchar2(32000) := 'DO'; --p4
Begin
  For CL_Update In (Select
                      *
                    From
                      Kd_Credit_Limit_Update A)
                      
  Ifsapp.Customer_Credit_Info_Api.Modify__( A_ , B_ , C_ , D_ , E_ );
End;