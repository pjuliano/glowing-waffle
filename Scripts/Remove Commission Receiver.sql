DECLARE
   a_ VARCHAR2(32000) := NULL; --p0
   b_ VARCHAR2(32000) := 'AAAUB5AAIAAABHbAEI'; --p1
   c_ VARCHAR2(32000) := '20160208132234'; --p2
   d_ VARCHAR2(32000) := 'DO'; --p3
Begin
  For Cur In (Select 
                * 
              From 
                Cust_Def_Com_Receiver A,
                (Select Customer, Substr(Substr(Issue,31),1,Length(Substr(Issue,31))-1) From KD_Customer_Check Where Issue Like 'Commission receiver should be%') B
              Where 
                A.Customer_No = B.Customer)
  Loop
    A_ := Null;
    B_ := Cur.Objid;
    C_ := Cur.Objversion;
    D_ := 'DO';
    Ifsapp.Cust_Def_Com_Receiver_Api.Remove__( A_ , B_ , C_ , D_ );
  End Loop;
END;