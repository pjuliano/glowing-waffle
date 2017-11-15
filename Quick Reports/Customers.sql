Select
  A.Customer_Id,
  A.Name,
  A.Creation_Date,
  Customer_Info_Address_Api.Get_Primary_Contact(A.Customer_Id,Customer_Info_Address_Api.Get_Default_Address(A.Customer_Id,'Delivery')) As Primary_Contact,
  Customer_Info_Address_Api.Get_Secondary_Contact(A.Customer_Id,Customer_Info_Address_Api.Get_Default_Address(A.Customer_Id,'Delivery')) As Secondary_Contact,
  Customer_Info_Address_Api.Get_Address1(A.Customer_Id,Customer_Info_Address_Api.Get_Default_Address(A.Customer_Id,'Delivery')) As Delivaddress1,
  Customer_Info_Address_Api.Get_Address2(A.Customer_Id,Customer_Info_Address_Api.Get_Default_Address(A.Customer_Id,'Delivery')) As Delivaddress2,
  Customer_Info_Address_Api.Get_City(A.Customer_Id,Customer_Info_Address_Api.Get_Default_Address(A.Customer_Id,'Delivery')) As Delivcity,
  Customer_Info_Address_Api.Get_State(A.Customer_Id,Customer_Info_Address_Api.Get_Default_Address(A.Customer_Id,'Delivery')) As Delivstate,
  Customer_Info_Address_Api.Get_Zip_Code(A.Customer_Id,Customer_Info_Address_Api.Get_Default_Address(A.Customer_Id,'Delivery')) As Delivzip,
  Customer_Info_Address_Api.Get_Default_Address(A.Customer_Id,'Delivery') As Delivaddressid,
  Cust_Ord_Customer_Api.Get_Cust_Grp(A.Customer_Id) As Cust_Grp,
  Cust_Ord_Customer_Api.Get_Salesman_Code(A.Customer_Id) As Salesman_Code,
  A.Association_No,
  Customer_Info_Comm_Method_Api.Get_Default_Phone(A.Customer_Id) As Phone,
  Customer_Info_Comm_Method_Api.Get_Default_Fax(A.Customer_ID) as Fax
From
  Customer_Info A
Where
  Upper(A.Name) = Upper('&Name') Or
  A.Customer_Id = '&Customer_No' Or
  Customer_Info_Address_Api.Get_Zip_Code(A.Customer_Id,Customer_Info_Address_Api.Get_Default_Address(A.Customer_Id,'Delivery')) = '&Zip' Or
  Cust_Ord_Customer_Api.Get_Salesman_Code(A.Customer_Id) = '&Salesman_Code' Or
  Upper(Customer_Info_Address_Api.Get_City(A.Customer_Id,Customer_Info_Address_Api.Get_Default_Address(A.Customer_Id,'Delivery'))) = Upper('&Delivery_City') Or
  Upper(Customer_Info_Address_Api.Get_Primary_Contact(A.Customer_Id,Customer_Info_Address_Api.Get_Default_Address(A.Customer_Id,'Delivery'))) = Upper('&Primary_Contact') Or
  Customer_Info_Address_Api.Get_Secondary_Contact(A.Customer_Id,Customer_Info_Address_Api.Get_Default_Address(A.Customer_Id,'Delivery'))= Upper('&Secondary_Contact') Or
  Upper(A.Association_No) = Upper('$Association_No') Or
  A.Creation_Date >= To_Date('&Created_On_Or_After','MM/DD/YYYY')
Order By
  A.Customer_ID