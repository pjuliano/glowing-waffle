Create Or Replace View KD_Payments_And_Aging As
Select
  Decode(A.Identity,Null,B.Identity,A.Identity) As Identity,
  Decode(A.Name,Null,B.Name,A.Name) As Name, 
  Cust_Ord_Customer_Api.Get_Salesman_Code(Decode(A.Identity,Null,B.Identity,A.Identity)) As Salesman_Code,
  Decode(A.AR_Contact,Null,B.AR_Contact,A.AR_Contact) As AR_Contact,
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
  Kd_Customer_Aging_Buckets_Test A Full Outer Join Kd_Customer_Payments_Test B 
    On A.Identity = B.Identity
Where
  ((Nvl(B.Jan,0) + Nvl(B.Feb,0) + Nvl(B.Mar,0) + Nvl(B.Apr,0) + Nvl(B.May,0) + Nvl(B.Jun,0) + Nvl(B.Jul,0) + Nvl(B.Aug,0) + Nvl(B.Sep,0) + Nvl(B.Oct,0) + Nvl(B.Nov,0) + Nvl(B.Dec,0) != 0) Or
  (Nvl(A."Current",0) + Nvl(A."0-30",0) + Nvl(A."31-60",0) + Nvl(A."61-90",0) + Nvl(A."91-120",0) + Nvl(A."121-150",0) + Nvl(A."151+",0) != 0))