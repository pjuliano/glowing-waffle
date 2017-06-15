Create Or Replace View KD_Customer_Aging_By_Due_Date As
Select
  *
From
  (
  Select
    A.Identity As Customer_No,
    B.Name As Customer_Name,
    Identity_Invoice_Info_Api.Get_Group_Id(A.Company, Identity, Customer_Info_Api.Get_Party_Type(A.Identity)) as Group_ID,
    D.Rep_Name,
    D.Region,
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
    Ledger_Item_Cu_Qry A,
    Customer_Info B,
    Cust_Ord_Customer_Ent C,
    Srrepquota D
  Where
    A.Identity = B.Customer_Id And
    B.Customer_Id = C.Customer_Id And
    C.Salesman_Code = D.RepNumber And
    A.Fully_Paid = 'FALSE'
  )
Pivot
  (Sum(Open_Amount) For Due_Month In (1 "JAN",2 "FEB",3 "MAR",4 "APR",5 "MAY",6 "JUN",7 "JUL",8 "AUG",9 "SEP",10 "OCT",11 "NOV",12 "DEC",0 "OTHER"))