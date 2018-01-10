Create Or Replace View KD_Customers As 
Select
  A.Customer_Id,
  A.Name As Customer_Name,
  Customer_Info_Address_Api.Get_Default_Address(A.Customer_Id,'Pay') As Address_Id,
  'PAY' As Address_Type_Code_DB,
  Customer_Info_Address_Api.Get_Address1(A.Customer_Id,Customer_Info_Address_Api.Get_Default_Address(A.Customer_Id,'Pay')) As Address1,
  Null As Address2,
  Customer_Info_Address_Api.Get_City(A.Customer_Id,Customer_Info_Address_Api.Get_Default_Address(A.Customer_Id,'Pay')) As City,
  Customer_Info_Address_Api.Get_State(A.Customer_Id,Customer_Info_Address_Api.Get_Default_Address(A.Customer_Id,'Pay')) As State,
  Customer_Info_Address_Api.Get_Zip_Code(A.Customer_Id,Customer_Info_Address_Api.Get_Default_Address(A.Customer_Id,'Pay')) As Zip_Code,
  Customer_Info_Address_Api.Get_Country(A.Customer_Id,Customer_Info_Address_Api.Get_Default_Address(A.Customer_Id,'Pay')) As Country,
  Customer_Info_Comm_Method_Api.Get_Default_Phone(A.Customer_Id) As Phone,
  Customer_Info_Comm_Method_Api.Get_Default_Fax(A.Customer_Id) As Fax,
  Customer_Info_Comm_Method_Api.Get_Default_E_Mail(A.Customer_Id) As Email,
  Customer_Info_Address_Api.Get_Default_Address(A.Customer_Id,'Delivery') As Deliv_Address_Id,
  'DELIVERY' As Deliv_Address_Type_Code,
  Customer_Info_Address_Api.Get_Address1(A.Customer_Id,Customer_Info_Address_Api.Get_Default_Address(A.Customer_Id,'Delivery')) As Deliv_Address1,
  Customer_Info_Address_Api.Get_Address2(A.Customer_Id,Customer_Info_Address_Api.Get_Default_Address(A.Customer_Id,'Delivery')) As Deliv_Address2,
  Customer_Info_Address_Api.Get_City(A.Customer_Id,Customer_Info_Address_Api.Get_Default_Address(A.Customer_Id,'Delivery')) As Deliv_City,
  Customer_Info_Address_Api.Get_State(A.Customer_Id,Customer_Info_Address_Api.Get_Default_Address(A.Customer_Id,'Delivery')) As Deliv_State,
  Customer_Info_Address_Api.Get_Zip_Code(A.Customer_Id,Customer_Info_Address_Api.Get_Default_Address(A.Customer_Id,'Delivery')) As Deliv_Zip_Code,
  Customer_Info_Address_Api.Get_Country(A.Customer_Id,Customer_Info_Address_Api.Get_Default_Address(A.Customer_Id,'Delivery')) As Deliv_Country,
  Cust_Ord_Customer_Api.Get_Currency_Code(A.Customer_Id) As Currency_Code,
  Cust_Ord_Customer_Api.Get_Salesman_Code(A.Customer_Id) As Salesman_Code,
  A.Corporate_Form,
  A.Association_No,
  Customer_Info_Address_Api.Get_Primary_Contact(A.Customer_Id,Customer_Info_Address_Api.Get_Default_Address(A.Customer_Id,'Delivery')) As Primary_Contact,
  Identity_Invoice_Info_Api.Get_Pay_Term_Id('100',A.Customer_Id,A.Party_Type) As Pay_Term_Id,
  Cust_Ord_Customer_Api.Get_Cust_Grp(A.Customer_Id) As Cust_Grp,
  Case When Cust_Ord_Customer_Api.Get_Date_Del(A.Customer_Id) Is Null
       Then 'FALSE'
       Else 'TRUE'
  End As Inactive,
  Cust_Ord_Customer_Api.Get_Market_Code(A.Customer_Id) As Market_Code,
  Cust_Ord_Customer_Api.Get_Order_Id(A.Customer_Id) As Order_Id,
  B.Commission_Receiver,
  A.Creation_Date,
  Customer_Info_Address_Api.Get_Valid_To(A.Customer_Id,Customer_Info_Address_Api.Get_Default_Address(A.Customer_Id,'Delivery')) As Valid_To,
  Cust_Ord_Customer_Address_Api.Get_Region_Code(A.Customer_Id,Customer_Info_Address_Api.Get_Default_Address(A.Customer_Id,'Delivery')) As Region,
  Nvl(C.Cysales,0) As Cysales,
  Nvl(C.Cyimpl,0) As Cyimpl,
  Nvl(C.Cybio,0) As CYBio
From
  Customer_Info A Left Join Cust_Def_Com_Receiver B On
    A.Customer_Id = B.Customer_No
                  Left Join Kd_Cy_Sales C On
    A.Customer_ID = C.Customer_No