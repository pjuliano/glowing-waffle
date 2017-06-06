Select
  B.*
From
  Inventory_Transaction_Hist A,
  KD_Sales_Data_Request B
Where
  A.Location_No = 'BURLINGTON' And
  A.Transaction_Code = 'OESHIP' And
  A.Order_No = B.Order_No And
  A.Part_No = B.Catalog_No And
  A.Release_No = B.Item_Id And
  B.Invoiced_Qty > 0 And
  B.InvoiceDate Between To_Date('01/01/2016','MM/DD/YYYY') And To_Date('05/31/2017','MM/DD/YYYY')