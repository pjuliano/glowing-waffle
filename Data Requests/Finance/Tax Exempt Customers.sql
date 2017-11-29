Select
  A.Customer_Id,
  Customer_Info_Api.Get_Name(A.Customer_ID) as Customer_Name,
  A.Address_Id,
  C.Address1,
  C.Address2,
  C.City,
  C.State,
  C.Zip_Code,
  C.Jurisdiction_Code,
  B.Tax_Exemption_Cert_No
From
  Customer_Delivery_Tax_Info A Left Join Customer_Del_Tax_Exempt B
    On A.Customer_Id = B.Customer_Id And
       A.Address_Id = B.Address_Id
                               Left Join Customer_Info_Address C
    On A.Customer_Id = C.Customer_Id And
       A.Address_Id = C.Address_Id
Where
  A.Liability_Type = 'EXEMPT' And
  Cust_Ord_Customer_Address_Api.Get_District_Code(A.Customer_Id,A.Address_Id) = 'DOMDIR' And
  C.Country_Db = 'US'
Order By
  A.Customer_Id,
  A.Address_Id