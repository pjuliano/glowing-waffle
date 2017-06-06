Create Or Replace View Kd_Commission_Report_V2 As
Select
  C.Region,
  A.Salesman_Code,
  B.Name,
  A.Customer_No,
  A.Customer_Name,
  A.Order_No,
  Customer_Order_Api.Get_Order_Id(A.Order_No) As Order_Id,
  Case When A.Invoicedate = Trunc(sysdate) 
       Then 'TODAY'
       Else 'HISTORY'
  End As Today_Or_Hist,
  E.Last_Activity_Date,
  Sum(A.Allamounts) As Total,
  Sum(Case When A.Part_Product_Code Not In ('LIT','REGEN')
           Then A.Allamounts
           Else 0
      End) As Implant_Sales,
  Sum(Case When A.Part_Product_Code Not In ('LIT','REGEN')
           Then (A.Allamounts * 0.09) --* Decode(D.Jr_Rep_Pct,Null,1,1-D.Jr_Rep_Pct)
           Else 0
      End) As Implant_Commission,
  Sum(Case When A.Part_Product_Code In ('REGEN')
           Then A.Allamounts
           Else 0
      End) As Bio_Sales,
  Sum(Case When A.Part_Product_Code In ('REGEN')
           Then (A.Allamounts * 0.07) --* Decode(D.Jr_Rep_Pct,Null,1,1-D.Jr_Rep_Pct)
           Else 0
      End) As Bio_Commission,
  Sum(Case When A.Part_Product_Code Not In ('LIT','REGEN')
           Then (A.Allamounts * 0.09) --* Decode(D.Jr_Rep_Pct,Null,1,1-D.Jr_Rep_Pct)
           Else 0
      End) +
  Sum(Case When A.Part_Product_Code In ('REGEN')
           Then (A.Allamounts * 0.07) * Decode(D.Jr_Rep_Pct,Null,1,1-D.Jr_Rep_Pct)
           Else 0
      End) As Total_Commission
From
  Kd_Sales_Data_Request A Left Join Kd_Jr_Rep_Assignments D
    On A.Salesman_Code = D.Rep_Assignment
                          Left Join KD_Last_Order_Activity_Date E
    On A.Order_No = E.Order_No,
  Person_Info B,
  Srrepquota C
Where
  A.Salesman_Code = B.Person_Id And
  A.Salesman_Code = C.Repnumber And
  A.Customer_No Not In ('A86088','A35173') And
  A.Charge_Type = 'Parts' And
  A.Corporate_Form = 'DOMDIR' And
  ((A.Order_No Not Like 'W%' And A.Order_No Not Like 'X%') Or A.Order_No Is Null) And
  Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) And
  (A.Market_Code != 'PREPOST' Or A.Market_Code Is Null)
Group By
  C.Region,
  A.Salesman_Code,
  B.Name,
  A.Customer_No,
  A.Customer_Name,
  A.Order_No,
  Customer_Order_Api.Get_Order_Id(A.Order_No),
  Case When A.Invoicedate = Trunc(Sysdate) 
       Then 'TODAY'
       Else 'HISTORY'
  End,
  E.Last_Activity_Date
Order By
  C.Region,
  B.Name,
  A.Customer_Name,
  A.Order_No;