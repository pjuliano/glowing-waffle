DECLARE
   a_ VARCHAR2(32000) := ''; --p0
   B_ Varchar2(32000) := 'AAAUBHAAIAAMilsAAH'; --p1
   c_ VARCHAR2(32000) := '2'; --p2
   d_ VARCHAR2(32000) := 'ADDRESS1'||chr(31)||'111 Broadway #804'||chr(30)||'ADDRESS2'||chr(31)||''||chr(30); --p3
   E_ Varchar2(32000) := 'DO'; --p4
Begin
    For Cur In (Select 
                    A.*,
                    B.Objid,
                    B.ObjVersion
                From 
                    Kd_Address_Update A, 
                    Customer_Info_Address B 
                Where 
                    A.Customer_Id = B.Customer_Id And 
                    To_Char(A.Address_Id) = B.Address_Id And
                    A.New_Address_1_Char_Count Is Null)
    Loop
        A_ := '';
        B_ := Cur.Objid;
        C_ := Cur.Objversion;
        D_ := 'ADDRESS1'||Chr(31)||Cur.New_Address1||Chr(30)||'ADDRESS2'||Chr(31)||Cur.New_Address2||Chr(30);
        E_ := 'DO';
        Update Kd_Address_Update A Set A.New_Address_1_Char_Count = 'FAIL' Where Customer_Id = Cur.Customer_Id And Address_Id = Cur.Address_Id;
        Commit;
        Ifsapp.Customer_Info_Address_Api.Modify__( A_ , B_ , C_ , D_ , E_ );
        Update Kd_Address_Update A Set A.New_Address_1_Char_Count = 'SUCCESS' Where Customer_Id = Cur.Customer_Id And Address_Id = Cur.Address_Id;
        Commit;
    End Loop;
End;
