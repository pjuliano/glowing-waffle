Create Or Replace View KD_QtrSales_B2958 As 
Select 
  *
From (
  Select
    A.Invoiceqtr,
    A.Part_Product_Family,
    A.AllAmounts
  From
    KD_Sales_Data_Request A
  Where
    A.Charge_Type = 'Parts' And
    A.Customer_No = 'B2958' And
    A.Invoicedate >= To_Date('01/01/' || Extract(Year From Sysdate),'MM/DD/YYYY'))
Pivot (
  Sum(Allamounts) As Sales For Invoiceqtr In ('QTR1','QTR2','QTR3','QTR4'))