Create Or Replace View KD_AR_Credit_Statements As
Select 
  A.Identity As Customer_No,
  B.Name,
  C.Address1,
  C.Address2,
  C.City,
  C.State,
  C.Zip_Code,
  C.Country,
  Sum(A.Open_Amount) As Open_Amount
From 
  Ledger_Item_Cu_Qry A, 
  Customer_Info B,
  Customer_Info_Address C,
  Customer_Info_Address_Type D
Where
  A.Identity = B.Customer_Id And
  B.Customer_Id = C.Customer_Id And
  C.Customer_Id = D.Customer_Id And
  C.Address_ID = D.Address_ID And
  D.Def_Address = 'TRUE' And
  D.Address_Type_Code = 'Document' And
  C.Country In ('UNITED STATES', 'CANADA')
Group By
  A.Identity,
  B.Name,
  C.Address1,
  C.Address2,
  C.City,
  C.State,
  C.Zip_Code,
  C.Country
Having
  Sum(A.Open_Amount) < 0