Select
  *
From (
  Select
    A.Catalog_No,
    A.DelivCountry,
    A.Invoiced_Qty
  From
    KD_Sales_Data_Nightly A
  Where
    A.Delivcountry In ('UNITED STATES','PUERTO RICO','AUSTRIA') And
    A.Catalog_No In ('45806K','45807K','45808K','001-0945-00','001-0946-00','001-0947-00','700131','700132','700133') And
    A.Invoicedate Between To_Date('01/01/2013','MM/DD/YYYY') And To_Date('01/31/2017','MM/DD/YYYY'))
Pivot
  (Sum(Invoiced_Qty) For DelivCountry In ('UNITED STATES','AUSTRIA','PUERTO RICO'))
