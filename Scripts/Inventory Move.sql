Declare
   A_ Varchar2(32000) := Null; --p0
   B_ Float := Null; --p1
   C_ Varchar2(32000) := '210'; --p2
   D_ Varchar2(32000) := '15205K'; --p3
   E_ Varchar2(32000) := '*'; --p4
   F_ Varchar2(32000) := '1010M'; --p5
   G_ Varchar2(32000) := '29492'; --p6
   H_ Varchar2(32000) := '*'; --p7
   I_ Varchar2(32000) := '3'; --p8
   J_ Varchar2(32000) := '*'; --p9
   K_ Float := 0; --p10
   L_ Date := Null; --p11
   M_ Varchar2(32000) := '100'; --p12
   N_ Varchar2(32000) := 'CAFGROOM'; --p13
   O_ Varchar2(32000) := 'Move to inventory'; --p14
   P_ Float := 1; --p15
   Q_ Varchar2(32000) := ''; --p16
   R_ Varchar2(32000) := 'N'; --p17
   S_ Float := Null; --p18
Begin
  For Inv In (Select * From Kd_Inv_Move A Where A.Comments Not In ('FAILED','MOVED'))
  Loop
    Update Kd_Inv_Move A Set A.Comments = 'FAILED' Where Inv.Part_No = A.Part_No And Inv.Lot_Batch_No = A.Lot_Batch_No And Inv.From_Location_No = A.From_Location_No;
    Commit;
    A_ := Null;
    B_ := Null;
    C_ := Inv.From_Site;
    D_ := Inv.Part_No;
    E_ := Inv.Config_Id;
    F_ := Inv.From_Location_No;
    G_ := Inv.Lot_Batch_No;
    H_ := Inv.Config_Id;
    I_ := Inv.Rev_No;
    J_ := Inv.Serial_No;
    K_ := 0;
    L_ := To_Date(Inv.Expiration_Date,'MM/DD/YYYY');
    M_ := Inv.To_Site;
    N_ := Inv.To_Location;
    O_ := 'Move to inventory';
    P_ := Inv.On_Hand_Qty;
    Q_ := '';
    R_ := 'N';
    S_ := Null;
    Ifsapp.Inventory_Part_In_Stock_Api.Move_Part( A_ , B_ , C_ , D_ , E_ , F_ , G_ , H_ , I_ , J_ , K_ , L_ , M_ , N_ , O_ , P_ , 0, Q_ , Null, Null, Null, Null, Null, R_ , Null, S_ );
    Update KD_Inv_Move A Set A.Comments = 'MOVED' Where Inv.Part_No = A.Part_No And Inv.Lot_Batch_No = A.Lot_Batch_No And Inv.From_Location_No = A.From_Location_No;
    Commit;
  End Loop;
End;
