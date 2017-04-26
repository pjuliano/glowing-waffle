Create Or Replace View KD_Customers_With_Credits As
Select 
  A.Identity,
  A.Name,
  Nvl(A."0-30",0) + Nvl(A."121-150",0) + Nvl(A."151+",0) + Nvl(A."31-60",0) + Nvl(A."61-90",0) + Nvl(A."91-120",0) As Balance,
  Customer_Info_Address_Api.Get_Address1(A.Identity,Ifsapp.Customer_Info_Address_Api.Get_Default_Address(A.Identity,'Pay')) As Address1,
  Customer_Info_Address_Api.Get_Address2(A.Identity,Ifsapp.Customer_Info_Address_Api.Get_Default_Address(A.Identity,'Pay')) As Address2,
  Customer_Info_Address_Api.Get_City(A.Identity,Ifsapp.Customer_Info_Address_Api.Get_Default_Address(A.Identity,'Pay')) As City,
  Customer_Info_Address_Api.Get_State(A.Identity,Ifsapp.Customer_Info_Address_Api.Get_Default_Address(A.Identity,'Pay')) As State,
  Customer_Info_Address_Api.Get_Zip_Code(A.Identity,Ifsapp.Customer_Info_Address_Api.Get_Default_Address(A.Identity,'Pay')) As Zip,
  B.Last_Order_Date
From 
  Kd_Customer_Aging_Buckets A Left Join Kd_Last_Order_Date B
    On A.Identity = B.Customer_No
Where
  Nvl(A."Current",0) + Nvl(A."0-30",0) + Nvl(A."121-150",0) + Nvl(A."151+",0) + Nvl(A."31-60",0) + Nvl(A."61-90",0) + Nvl(A."91-120",0) < 0
