DECLARE
   a_ VARCHAR2(32000) := NULL; --p0
   b_ VARCHAR2(32000) := 'AAAUB5AAIAAABHbAEI'; --p1
   c_ VARCHAR2(32000) := '20160208132234'; --p2
   d_ VARCHAR2(32000) := 'DO'; --p3
Begin
  For Cur In (Select 
                * 
              From 
                Cust_Def_Com_Receiver A
              Where 
                A.Customer_No IN ('D44059',
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
    B_ := Cur.Objid;
    C_ := Cur.Objversion;
    D_ := 'DO';
    Ifsapp.Cust_Def_Com_Receiver_Api.Remove__( A_ , B_ , C_ , D_ );
  End Loop;
END;