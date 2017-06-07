Select
  A.Price_List_No,
  A.Catalog_No,
  Sales_Part_Api.Get_Catalog_Desc(A.Base_Price_Site,A.Catalog_No) As Catalog_Desc,
  Inventory_Part_Api.Get_Part_Product_Family(A.Base_Price_Site,A.Catalog_No) As Part_Product_Family,
  Inventory_Part_Api.Get_Part_Product_Code(A.Base_Price_Site,A.Catalog_No) As Part_Product_Code,
  A.
  A.Base_Price,
  A.Percentage_Offset,
  A.Amount_Offset,
  A.Rounding,
  A.Sales_Price
From
  Sales_Price_List_Part_Tab A
Where
  A.Price_List_No In ('GD NATIONA','GD SI','GD PROS')