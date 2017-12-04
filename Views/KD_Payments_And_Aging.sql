Create Or Replace View KD_Payments_And_Aging As
Select
  Decode(A.Identity,Null,B.Identity,A.Identity) As Identity,
  Decode(A.Name,Null,B.Name,A.Name) As Name, 
  C.Group_Id,
  Cust_Ord_Customer_Api.Get_Salesman_Code(Decode(A.Identity,Null,B.Identity,A.Identity)) As Salesman_Code,
  A."Current",
  A."0-30",
  A."31-60",
  A."61-90",
  A."91-120",
  A."121-150",
  A."151+",
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
  Kd_Customer_Aging_Buckets A Full Outer Join Kd_Customer_Payments B 
    On A.Identity = B.Identity
                              Left Join Identity_Invoice_Info C
    On (A.Identity = C.Customer_Id Or B.Identity = C.Customer_ID)