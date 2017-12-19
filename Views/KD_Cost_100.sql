Create Or Replace View KD_Cost_100 As
Select 
  A.Part_No,
  A.Inventory_Value
From 
  Inventory_Part_Unit_Cost_Sum A
Where 
  A.Contract = '100'
  
Union All

Select 
  A.Catalog_No, 
  A.Cost 
From 
  Sales_Part A 
Where 
  Catalog_Type_Db = 'NON' And 
  A.Contract = '100'