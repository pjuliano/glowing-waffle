Select
  A.Part_No,
  Inventory_Part_Api.Get_Description(A.Contract,A.Part_No) As Part_Desc,
  A.Revision_Text,
  A.Eng_Chg_Level
From
  Part_Revision A
Where
  A.Eff_Phase_Out_Date Is Null And
  Inventory_Part_Api.Get_Part_Status(A.Contract,A.Part_No) != 'O' And
  A.Contract = '100'