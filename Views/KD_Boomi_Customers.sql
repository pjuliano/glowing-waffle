Create Or Replace View KD_Boomi_Customers As
Select
  A.Customer_ID,
  A.Customer_Name,
  A.Address_Id,
  A.Address_Type_Code_Db,
  A.Address1,
  Decode(A.Address2,Null,' ',A.Address2) As Address2,
  A.City,
  A.State,
  A.Zip_Code,
  A.Country,
  A.Phone,
  Decode(A.Fax,Null,' ',A.Fax) As Fax,
  Decode(A.Email,Null,' ',A.Email) As Email,
  A.Deliv_Address_Id,
  A.Deliv_Address_Type_Code,
  A.Deliv_Address1,
  A.Deliv_Address2,
  A.Deliv_City,
  A.Deliv_State,
  A.Deliv_Zip_Code,
  A.Deliv_Country,
  A.Currency_Code,
  A.Salesman_Code,
  A.Corporate_Form,
  Decode(A.Association_No,Null,' ',A.Association_No) As Association_No,
  A.Primary_Contact,
  A.Pay_Term_Id,
  A.Cust_Grp,
  A.Inactive,
  Decode(A.Market_Code,Null,' ',A.Market_Code) As Market_Code,
  A.Order_Id,
  A.Commission_Receiver,
  A.Valid_To,
  A.Region,
  Decode(A.Cysales,Null,0,A.Cysales) As Cysales,
  Decode(A.Cyimpl,Null,0,A.Cyimpl) As Cyimpl,
  Decode(A.Cybio,Null,0,A.Cybio) As Cybio,
  B.First_Order_Date,
  C.Last_Order_Date,
  Decode(D.Price_Lists,Null,' ',D.Price_Lists) As Price_Lists
From
  Kd_Customers A Left Join Kd_First_Order_Date B
    On A.Customer_Id = B.Customer_No 
                 Left Join Kd_Last_Order_Date C
    On A.Customer_Id = C.Customer_No
                 Left Join Kd_Customer_Pricelists D
    On A.Customer_ID = D.Customer_Id
Where
  (  
  A.Corporate_Form Not In ('FRA','ITL','SWE','IT','BENELUX','GER','KEY','CAN','SPA','LA','DOMDIS','EUR') And
  A.Salesman_Code Not In ('908','504','318') And
  A.Customer_ID != 'CATEMP'     ) Or
  (
  A.Customer_ID Like 'N%' And
  A.Salesman_Code = '999'       )