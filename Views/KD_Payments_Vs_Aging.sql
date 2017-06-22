Create Or Replace View KD_Payments_VS_Aging As
Select
  A.Identity As Customer_No,
  A.Name,
  Cust_Ord_Customer_Api.Get_Salesman_Code(A.Identity) As Salesman_Code,
  Person_Info_Api.Get_Name(Cust_Ord_Customer_Api.Get_Salesman_Code(A.Identity)) As Salesman_Name,
  D.Region,
  Customer_Info_Address_Api.Get_State(A.Identity,Customer_Info_Address_Api.Get_Default_Address(A.Identity,'Pay')) As Pay_State,
  C."Current",
  C."0-30",
  C."31-60",
  C."61-90",
  C."91-120",
  C."121-150",
  C."151+",
  A.Jan,
  A.Feb,
  A.Mar,
  A.Apr,
  A.May,
  A.Jun,
  A.Jul,
  A.Aug,
  A.Sep,
  A.Oct,
  A.Nov,
  A.Dec
From
  Kd_Customer_Payments A Left Join Customer_Info B
    On A.Identity = B.Customer_Id
                         Left Join Kd_Customer_Aging_Buckets C
    On A.Identity = C.Identity
                         Left Join Srrepquota D
    On Cust_Ord_Customer_Api.Get_Salesman_Code(A.Identity) = D.Repnumber
Where
  B.Corporate_Form Not In ('BENELUX','FRA','GER','ITL','SWE');