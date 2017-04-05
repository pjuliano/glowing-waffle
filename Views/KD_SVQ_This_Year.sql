Create Or Replace View KD_SVQ_This_Year As
Select
  A.Salesman_Code,
  Sum(A.Allamounts) As This_Year,
  B.Year As Year_Quota,
  B.Region
From
  Kd_Sales_Data_Request A Left Join Srrepquota B
    On A.Salesman_Code = B.Repnumber
Where
  A.Charge_Type = 'Parts' And
  A.Corporate_Form = 'DOMDIR' And
((A.Order_No Not Like 'W%' And
  A.Order_No Not Like 'X%') Or
  A.Order_No Is Null) And
  Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) And
  (A.Market_Code != 'PREPOST' Or A.Market_Code Is Null)
Group By
  A.Salesman_Code,
  B.Year,
  B.Region;