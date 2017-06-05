Select
  A.Customer_Id,
  D.Name,
  B.Amount_Due,
  C.Credit_Limit
From
  Identity_Invoice_Info A Left Join Identity_Pay_Info_Cu_Qry B
    On A.Customer_Id = B.Identity 
                          Left Join Customer_Credit_Info_Cust C
    On A.Customer_Id = C.Identity
                          Left Join Customer_Info D
    On A.Customer_Id = D.Customer_Id
Where
  A.Pay_Term_Id = 'CC' And
  B.Amount_Due < 5 And
  C.Credit_Limit < 5000