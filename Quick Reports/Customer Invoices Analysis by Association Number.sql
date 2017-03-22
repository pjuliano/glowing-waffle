Select
  Customer_Info_Api.Get_Association_No(A.Identity) As Assn_No,
  A.*
From
  Outgoing_Invoice_Qry A
Where
  Customer_Info_Api.Get_Association_No(A.Identity) Is Not Null And
  A.Invoice_Date Between To_Date('&DateFrom','MM/DD/YYYY') And To_Date('&DateTo','MM/DD/YYYY') And
  A.Company = '100'
Order By
  Customer_Info_Api.Get_Association_No(A.Identity),
  A.Invoice_Date Desc,
  A.Invoice_No Desc