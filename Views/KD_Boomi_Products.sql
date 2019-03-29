Create or Replace View KD_Boomi_Products As
Select 
  A.Contract,
  A.Catalog_No,
  A.Catalog_Desc,
  A.Catalog_Group,
  A.Sales_Price_Group_Id,
  A.Sales_Unit_Meas,
  A.Activeind,
  Decode(A.Activeind_Db,'Y','true','N','false') as Activeind_Db,
  A.Customs_Stat_No,
  A.Date_Entered,
  A.List_Price,
  A.Price_Conv_Factor,
  A.Price_Unit_Meas,
  B.Second_Commodity,
  B.Part_Product_Family,
  B.Part_Product_Code,
  B.Type_Designation,
  C.Inventory_Value
From 
  Sales_Part A Left Join Inventory_Part B On 
    A.Part_No = B.Part_No And 
      A.Contract=B.Contract And 
      A.Contract='100' And
      B.Accounting_Group In ('FG','LIT','DEMO')
               Left Join Inventory_Part_Unit_Cost_Sum C On
      A.Contract = C.Contract And
      A.Part_No = C.Part_No
Order By
  A.Catalog_No