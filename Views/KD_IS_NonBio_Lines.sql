Create Or Replace View KD_IS_NONBIO_LINES As
Select
  A.Authorize_Code As Offender,
  A.Order_No, 
  B.Line_No || '-' || B.Rel_No As Line,
  B.Part_No,
  B.Catalog_Desc
From 
  Customer_Order A Left Join Customer_Order_Line B
    On A.Order_No = B.Order_No
Where
  A.Authorize_Code In ('MANTAR','LWITHROW','JNEVES','JNORRIS','TAUCOIN','MGRAVES','LENTERKIN') And
  Inventory_Part_Api.Get_Part_Product_Code(B.Company, B.Part_No) != 'REGEN' And
  Inventory_Part_Api.Get_Part_Product_Code(B.Company, B.Part_No) != 'LIT' And
  B.Objstate = 'Invoiced' And
  Trunc(B.Date_Entered) = Trunc(Sysdate)
Order By
  A.Authorize_Code,
  A.Order_No