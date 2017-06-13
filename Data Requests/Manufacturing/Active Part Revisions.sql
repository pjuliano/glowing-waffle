Select
  A.Part_No,
  Inventory_Part_Api.Get_Description(A.Contract,A.Part_No) As Part_Desc,
  A.Eng_Revision,
  A.Eng_Chg_Level
From
  Part_Revision A
Where
  A.Eff_Phase_Out_Date Is Null And
  Inventory_Part_Api.Get_Part_Status(A.Contract,A.Part_No) = 'A' And
  A.Contract = '100'