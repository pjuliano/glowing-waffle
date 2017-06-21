Create Or Replace View Kd_Customer_Aging_By_Due_Date As
With Current_Payments As (
  Select
    Identity,
    Name,
    Extract(Month From Payment_Date) As Month,
    Sum(Inv_Amount) As Amount
  From
    Pay_Doc_Followup_Qry
  Where
    Party_Type = 'Customer' And
    Extract(Year From Payment_Date) = Extract(Year From Sysdate) And
    Extract(Month From Payment_Date) = Extract(Month From Sysdate) And
    Objstate != 'Cancelled'
  Group By
    Identity,
    Name,
    Extract(Month From Payment_Date))
Select
  *
From
  (
  Select
    A.Identity As Customer_No,
    B.Name As Customer_Name,
    Identity_Invoice_Info_Api.Get_Group_Id(A.Company, A.Identity, Customer_Info_Api.Get_Party_Type(A.Identity)) as Group_ID,
    D.Rep_Name,
    D.Region,
    E.Amount As Current_Mo_Payments,
    Customer_Info_Address_Api.Get_State(A.Identity,Customer_Info_Address_Api.Get_Default_Address(A.Identity,'Delivery')) As State,
    Case When Extract(Month From A.Due_Date) > Extract(Month From Sysdate) And
              Extract(Year From A.Due_Date) = Extract(Year From Sysdate)-1
         Then Extract(Month From A.Due_Date)
         When Extract(Month From A.Due_Date) <= Extract(Month From Sysdate) And
              Extract(Year From A.Due_Date) = Extract(Year From Sysdate)
         Then Extract(Month From A.Due_Date)
         Else 0
    End As Due_Month,
    A.Open_Amount
  From
    Ledger_Item_Cu_Qry A Left Join Current_Payments E
      On A.Identity = E.Identity,
    Customer_Info B,
    Cust_Ord_Customer_Ent C Left Join Srrepquota D
      On C.Salesman_Code = D.RepNumber
  Where
    A.Identity = B.Customer_Id And
    B.Customer_Id = C.Customer_Id And
    A.Fully_Paid = 'FALSE' And
    A.Due_Date <= Last_Day(Sysdate) And
    A.Company = '100'
  )
Pivot
  (Sum(Open_Amount) For Due_Month In (1 "JAN",2 "FEB",3 "MAR",4 "APR",5 "MAY",6 "JUN",7 "JUL",8 "AUG",9 "SEP",10 "OCT",11 "NOV",12 "DEC",0 "OTHER"))