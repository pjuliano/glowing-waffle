Create Or Replace View Kd_Customer_Aging_Buckets As
Select
  *
From
( Select
    Identity,
    Customer_Info_Api.Get_Name(Identity) As Name,
    Identity_Invoice_Info_Api.Get_Group_Id(Company, Identity, Customer_Info_Api.Get_Party_Type(Identity)) As Group_Id,
    Case 
      When Trunc(Sysdate) - Decode(Due_Date,Null,Ledger_Date,Due_Date) <= 0 
      Then '0'
      When Trunc(Sysdate) - Decode(Due_Date,Null,Ledger_Date,Due_Date) Between 0 And 30
      Then '1'
      When Trunc(Sysdate) - Decode(Due_Date,Null,Ledger_Date,Due_Date) Between 31 And 60
      Then '2'
      When Trunc(Sysdate) - Decode(Due_Date,Null,Ledger_Date,Due_Date) Between 61 And 90
      Then '3'
      When Trunc(Sysdate) - Decode(Due_Date,Null,Ledger_Date,Due_Date) Between 91 And 120
      Then '4'
      When Trunc(Sysdate) - Decode(Due_Date,Null,Ledger_Date,Due_Date) Between 121 And 150
      Then '5'
      When Trunc(Sysdate) - Decode(Due_Date,Null,Ledger_Date,Due_Date) >= 151
      Then '6'
    End As Bucket,
  Open_Dom_Amount As Bucket_Value
  From
    Kd_Ar_Aging_Stmt_V2_New 
  Where
    Company = '100')
Pivot
( Sum(Bucket_Value) For Bucket In (0 As "Current",1 As "0-30",2 As "31-60",3 As "61-90",4 As "91-120",5 As "121-150",6 As "151+"));

Create or Replace View KD_Customer_Payments As
Select
  *
From 
( Select
    Identity,
    Name,
    Extract(Month From Payment_Date) As Month,
    Inv_Amount
  From
    Pay_Doc_Followup_Qry
  Where
    Party_Type = 'Customer' And
  ((Extract(Year From Payment_Date) = Extract(Year From Sysdate)) Or
   (Extract(Month From Payment_Date) > Extract(Month From Sysdate) And 
    Extract(Year From Payment_Date) = Extract(Year From Sysdate) - 1)) And
    Objstate != 'Cancelled')
Pivot
( Sum(Inv_Amount) For Month In (1 As Jan,2 As Feb,3 As Mar,4 As Apr,5 As May,6 As Jun,7 As Jul,8 As Aug,9 As Sep,10 As Oct,11 As Nov,12 As Dec));

Create or Replace View KD_Aging_Vs_Payments As  
Select
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
Where
  Decode(A."0-30",Null,0,A."0-30") + Decode(A."31-60",Null,0,A."31-60") + Decode(A."61-90",Null,0,A."61-90") + Decode(A."91-120",Null,0,A."91-120") + Decode(A."121-150",Null,0,A."121-150") + Decode(A."151+",Null,0,A."151+") != 0
Order By
  A.Identity;