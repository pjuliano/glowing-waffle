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
  For Inv In (Select
                A.Contract,
                A.Part_No,
                A.Configuration_Id As Config_Id,
                'CLEANROOMCA' As Move_From,
                A.Lot_Batch_No,
                A.Configuration_Id,
                A.Eng_Chg_Level as Rev_No,
                A.Serial_No,
                '0',
                To_Date(A.Expiration_Date,'MM/DD/YYYY') As Expiration_Date,
                A.Contract As Contract1,
                'CLEANROOMCH' As Move_To,
                'Move to inventory',
                A.Qty_Onhand - A.Qty_Reserved As Qty_Available,
                '',
                'N'
              From
                Inventory_Part_In_Stock A
              Where
                Location_No = 'CLEANROOMCH')
  Loop
    A_ := Null;
    B_ := Null;
    C_ := Inv.Contract;
    D_ := Inv.Part_No;
    E_ := Inv.CONFIG_ID;
    F_ := Inv.Move_From;
    G_ := Inv.Lot_Batch_No;
    H_ := Inv.Configuration_Id;
    I_ := Inv.Rev_No;
    J_ := Inv.Serial_No;
    K_ := 0;
    L_ := Inv.Expiration_Date;
    M_ := Inv.Contract;
    N_ := Inv.Move_To;
    O_ := 'Move to inventory';
    P_ := Inv.Qty_Available;
    Q_ := '';
    R_ := 'N';
    S_ := Null;
    Ifsapp.Inventory_Part_In_Stock_Api.Move_Part( A_ , B_ , C_ , D_ , E_ , F_ , G_ , H_ , I_ , J_ , K_ , L_ , M_ , N_ , O_ , P_ , 0, Q_ , Null, Null, Null, Null, Null, R_ , Null, S_ );
  End Loop;
End;
