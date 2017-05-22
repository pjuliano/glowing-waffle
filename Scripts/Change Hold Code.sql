Declare
   A_ Varchar2(32000) := Null; --p0
   B_ Varchar2(32000) := Null; --p1
   C_ Varchar2(32000) := Null; --p2
   D_ Varchar2(32000) := Null; --p3
   E_ Varchar2(32000) := Null; --p4
   F_ Varchar2(32000) := Null; --p5
   G_ Varchar2(32000) := Null; --p6
   H_ Varchar2(32000) := Null; --p7
   I_ Float := Null; --p8
   J_ Varchar2(32000) := Null; --p9
Begin  
  For Parts In (Select 
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
                  Inventory_Part_In_Stock A 
                Where 
                  A.Warehouse = 'CONS')
  Loop
    A_ := Parts.Contract;
    B_ := Parts.Part_No;
    C_ := Parts.Configuration_Id;
    D_ := Parts.Location_No;
    E_ := Parts.Lot_Batch_No;
    F_ := Parts.Serial_No;
    G_ := Parts.Eng_Chg_Level;
    H_ := Parts.Waiv_Dev_Rej_No;
    I_ := Parts.Activity_Seq;
    Ifsapp.Inventory_Part_In_Stock_Api.Modify_Availability_Control_Id( A_ , B_ , C_ , D_ , E_ , F_ , G_ , H_ , I_ , 'CONRES');
    Commit;
  End Loop;
End;
