Create Or Replace View KD_Cost_Values As 
Select 
  A.Contract,
  A.Part_No,
  A.Inventory_Value Localvalue,
  A.Inventory_Value Inventoryvalueus 
From 
  Inventory_Part_Unit_Cost_Sum A,
  Inventory_Part B
Where 
  A.Contract=B.Contract And
  A.Part_No=B.Part_No And
  B.Accounting_Group In ('FG','DEMO') And
  A.Contract='100' And
  B.Part_Status='A'

Union All

Select 
  A.Contract,
  A.Part_No,
  Inventory_Value Localvalue,
  (A.Inventory_Value*1.4) Inventoryvalueus 
From 
  Inventory_Part_Unit_Cost_Sum A,
  Inventory_Part B
Where 
  A.Contract=B.Contract And
  A.Part_No=B.Part_No And
  A.Contract='210' And
  B.Part_Status='A' And 
  Not Exists (Select 
                * 
              From 
                Inventory_Part C
              Where 
                C.Part_No=B.Part_No And
                C.Contract='100')

Union All

Select 
  A.Contract, 
  A.Catalog_No, 
  A.Cost, 
  A.Cost 
From 
  Sales_Part A 
Where 
  Catalog_Type_Db = 'NON' And 
  A.Contract = '100'