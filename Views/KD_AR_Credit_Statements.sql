Create Or Replace View KD_AR_Credit_Statements As
Select 
  A.Identity As Customer_No,
  B.Name,
  A.Ledger_Date,
  A.Due_Date,
  A.Ledger_Item_Series_ID || A.Ledger_Item_ID As Reference,
  A.Inv_Amount,
  A.Open_Amount,
  A.Currency,
  C.Address1,
  C.Address2,
  C.City,
  C.State,
  C.Zip_Code,
  C.Country,
  Sum(A.Open_Amount) As "Sum(Open_Amount)"
From 
  Ledger_Item_Cu_Qry A, 
  Customer_Info B,
  Customer_Info_Address C,
  Customer_Info_Address_Type D
Where
  A.Identity = B.Customer_Id And
  B.Customer_Id = C.Customer_Id And
  C.Customer_Id = D.Customer_Id And
  C.Address_Id = D.Address_ID And
  D.Def_Address = 'TRUE' And
  D.Address_Type_Code = 'Document' And
  C.Country In ('UNITED STATES', 'CANADA')
Group By
  A.Identity,
  B.Name,
  A.Ledger_Date,
  A.Due_Date,
  A.Ledger_Item_Series_ID || A.Ledger_Item_ID,
  A.Inv_Amount,
  A.Open_Amount,
  A.Currency,
  C.Address1,
  C.Address2,
  C.City,
  C.State,
  C.Zip_Code,
  C.Country
Having
  Sum(A.Open_Amount) < 0 