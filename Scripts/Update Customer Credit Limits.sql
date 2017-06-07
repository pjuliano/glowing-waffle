Declare
   A_ Varchar2(32000) := Null; --p0
   B_ Varchar2(32000) := 'AAAUBDAAIAAABBcAAg'; --p1
   C_ Varchar2(32000) := '20170208095357'; --p2
   D_ Varchar2(32000) := 'CREDIT_LIMIT'||Chr(31)||'10000'||Chr(30); --p3
   E_ Varchar2(32000) := 'DO'; --p4
Begin
  For CL_Update In (Select
                      A.Customer_Id,
                      A.New_Credit_Limit,
                      A.Status,
                      B.ObjID,
                      B.Objversion
                    From
                      Kd_Credit_Limit_Update A,
                      Customer_Credit_Info B
                    Where
                      A.Customer_Id = B.Identity And
                      A.Status = 'NEW')
  Loop 
    A_ := Null;
    B_ := Cl_Update.Objid;
    C_ := Cl_Update.Objversion;
    D_ := 'CREDIT_LIMIT'||Chr(31)|| Cl_Update.New_Credit_Limit ||Chr(30);
    E_ := 'DO';
    Update Kd_Credit_Limit_Update A Set A.Status = 'FAILED' Where CL_Update.Customer_ID = A.Customer_ID;
    Commit;
    Ifsapp.Customer_Credit_Info_Api.Modify__( A_ , B_ , C_ , D_ , E_ );
    Commit;
    Update Kd_Credit_Limit_Update A Set A.Status = 'SUCCESS' Where CL_Update.Customer_ID = A.Customer_ID;
  End Loop;
End;