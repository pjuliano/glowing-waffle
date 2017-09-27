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