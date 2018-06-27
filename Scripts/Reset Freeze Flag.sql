Declare
  A_ Varchar2(3200) := Null; --Contract
  B_ Varchar2(3200) := Null; --Part No
  C_ Varchar2(3200) := Null; --Configuration ID
  D_ Varchar2(3200) := Null; --Location No
  E_ Varchar2(3200) := Null; --Lot/Batch
  F_ Varchar2(3200) := Null; --Serial No
  G_ Varchar2(3200) := Null; --Engineering Change Level
  H_ Varchar2(3200) := Null; --Waiv Dev Rej No
  I_ Number := Null; --Activity Sequence
Begin
  For
    Cursor In ( Select
                  A.Contract,
                  A.Part_No,
                  A.Configuration_Id,
                  A.Location_No,
                  A.Lot_Batch_No,
                  A.Serial_No,
                  A.Eng_Chg_Level,
                  A.Waiv_Dev_Rej_No,
                  A.Activity_Seq
                From
                  Inventory_Part_In_Stock A)
                --Where
                  --A.Location_No = 'ITINVRETURN' )
  Loop
    A_ := Cursor.Contract;
    B_ := Cursor.Part_No;
    C_ := Cursor.Configuration_Id;
    D_ := Cursor.Location_No;
    E_ := Cursor.Lot_Batch_No;
    F_ := Cursor.Serial_No;
    G_ := Cursor.Eng_Chg_Level;
    H_ := Cursor.Waiv_Dev_Rej_No;
    I_ := Cursor.Activity_Seq;
    Inventory_Part_In_Stock_Api.Reset_Freeze_Flag(A_,B_,C_,D_,E_,F_,G_,H_,I_);
  End Loop;
End;