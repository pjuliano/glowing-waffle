Begin
For Parts In (Select 
                A.Delivering_Contract,
                A.Contract,
                A.Part_No,
                A.Configuration_Id,
                A.Lot_Batch_No,
                A.Serial_No,
                A.Waiv_Dev_Rej_No,
                A.Expiration_Date,
                A.Quantity,
                A.Catch_Quantity,
                A.Eng_Chg_Level
              From
                Inventory_Part_In_Transit_All A)
Loop
  Inventory_Part_In_Transit_Api.Remove_From_Order_Transit(Parts.Delivering_Contract, --Delivering_Contract_ Varchar2,
                                                          Parts.Contract, --Contract_ Varchar2,
                                                          Parts.Part_No, --Part_No_ Varchar2,
                                                          Parts.Configuration_Id, --Configuration_Id_ Varchar2,
                                                          Parts.Lot_Batch_No, --Lot_Batch_No_ Varchar2,
                                                          Parts.Serial_No, --Serial_No_ Varchar2,
                                                          Parts.Eng_Chg_Level, --Eng_Chg_Level_ Varchar2,
                                                          Parts.Waiv_Dev_Rej_No, --Waiv_Dev_Rej_No_ Varchar2,
                                                          Parts.Expiration_Date, --Expiration_Date_ Date,
                                                          Parts.Quantity, --Qty_To_Remove_ Number,
                                                          Parts.Quantity, --Catch_Qty_To_Remove_ Number,
                                                          True /**Remove_Unit_Cost_ Pl/Sql Boolean**/);
End Loop;
End;