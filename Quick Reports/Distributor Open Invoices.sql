Select 
  A.Identity As Customer_No,
  A.Identity_Name As Customer_Name,
  A.Ledger_Item_Series_Id || A.Ledger_Item_Id As Invoice_No,
  A.Order_Reference,
  A.Ledger_Date,
  A.Due_Date,
  A.Inv_Amount,
  A.Open_Amount
From 
  Ifsapp.Ledger_Item_Cu_Det_Qry A, 
  Ifsapp.Customer_Info B 
Where 
  A.Identity = B.Customer_Id And 
  B.Corporate_Form In ('ASIA','LA','EUR','CAN') And 
  A.Open_Dom_Amount != 0 And
  A.Identity Like '%&CustomerNo%'