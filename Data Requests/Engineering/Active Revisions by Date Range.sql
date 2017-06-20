With Last_Sale_Date As (
  Select
    A.Part_No,
    A.Eng_Chg_Level,
    Max(A.Date_Created) As Last_Sale_Date
  From
    Inventory_Transaction_Hist A
  Where
    A.Contract = '100' And
    A.Transaction_Code = 'OESHIP'
  Group By
    A.Part_No,
    A.Eng_Chg_Level),
     Onhand_Qty As (
  Select
    A.Part_No,
    A.Eng_Chg_Level,
    Sum(Inventory_Part_In_Stock_Api.Get_Qty_Onhand(A.Contract,A.Part_No,A.Configuration_ID,A.location_No,A.Lot_Batch_No,A.Serial_No,A.Eng_Chg_Level,A.Waiv_Dev_rej_No,A.Activity_Seq)) As Onhand_Qty
  From 
    Inventory_Transaction_Hist A
  Where
    Inventory_Part_In_Stock_Api.Get_Qty_Onhand(A.Contract,A.Part_No,A.Configuration_Id,A.Location_No,A.Lot_Batch_No,A.Serial_No,A.Eng_Chg_Level,A.Waiv_Dev_Rej_No,A.Activity_Seq) Is Not Null
  Group By
    A.Part_No,
    A.Eng_Chg_Level)
  
Select
  A.Part_No,
  A.Description,
  A.Part_Product_Code,
  A.Part_Product_Family,
  B.Eff_Phase_In_Date,
  B.Eff_Phase_Out_Date,
  B.Eng_Chg_Level,
  B.Eng_Revision,
  B.Eng_Revision_Desc,
  C.Last_Sale_Date,
  D.Onhand_Qty
From
  Inventory_Part A,
  Part_Revision B Left Join Last_Sale_Date C   
    On B.Part_No = C.Part_No And B.Eng_Chg_Level = C.Eng_Chg_Level
                  Left Join Onhand_Qty D
    On B.Part_No = D.Part_No And
       B.Eng_Chg_Level = D.Eng_Chg_level
Where
  A.Contract = B.Contract And
  A.Part_No = B.Part_No And 
  A.Contract = '100' And
  --A.Accounting_Group = 'FG' And
  A.Part_Status != 'OBS' And
  B.Eff_Phase_In_Date Between To_Date('05/01/2016','MM/DD/YYYY') And To_Date('05/31/2017','MM/DD/YYYY')