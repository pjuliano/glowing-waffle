Create or Replace View KD_Aging_Vs_Payments As  
Select
  D.Name As Rep_Name,
  E.Region,
  Customer_Info_Address_Api.Get_State(A.Identity,Customer_Info_Address_Api.Get_Default_Address(A.Identity,'Pay')) As Pay_State,
  A.Identity As Customer_ID,
  A.Name,
  A.Group_Id,
  A."Current", 
  A."0-30",
  A."31-60",
  A."61-90",
  A."91-120",
  A."121-150",
  A."151+",
  Decode(A."0-30",Null,0,A."0-30") + Decode(A."31-60",Null,0,A."31-60") + Decode(A."61-90",Null,0,A."61-90") + Decode(A."91-120",Null,0,A."91-120") + Decode(A."121-150",Null,0,A."121-150") + Decode(A."151+",Null,0,A."151+") As TOTAL_Past_Due,
  B.Jan,
  B.Feb,
  B.Mar,
  B.Apr,
  B.May,
  B.Jun,
  B.Jul,
  B.Aug,
  B.Sep,
  B.Oct,
  B.Nov,
  B.Dec
From
  Kd_Customer_Aging_Buckets A Left Join Kd_Customer_Payments B
    On A.Identity = B.Identity
                              Left Join Cust_Ord_Customer_Ent C
    On A.Identity = C.Customer_Id,
  Person_Info D Left Join Srrepquota E
    On D.Person_Id = E.Repnumber
Where
  C.Salesman_Code = D.Person_Id
Order By
  A.Identity;