Create Or Replace View KD_QTR_QUOTA_CONTEST AS
Select
  A.Salesman_Code,
  Person_Info_Api.Get_Name(A.Salesman_Code) As Salesman_Name,
  B.Qtr4 As Qtr4_Quota,
  Sum(A.Allamounts) As Total_Sales,
  Round(Sum(A.AllAmounts)/B.Qtr4,4) * 100 As PCT_To_Quota
From
  Kd_Sales_Data_Request A Left Join Srrepquota B On
    A.Salesman_Code = B.Repnumber
Where
  A.Charge_Type = 'Parts' And
  A.Invoicedate Between To_Date('10/01/2017','MM/DD/YYYY') And To_Date('12/31/2017','MM/DD/YYYY') And
  A.Corporate_Form = 'DOMDIR'
Group By
  A.Salesman_Code,
  Person_Info_Api.Get_Name(A.Salesman_Code),
  B.Qtr4
Order By
  Round(Sum(A.AllAmounts)/B.Qtr4,4) * 100 Desc