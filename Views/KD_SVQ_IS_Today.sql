Create Or Replace View KD_Svq_IS_Today As
Select
  A.Commission_Receiver As Salesman_Code,
  Sum(A.AllAmounts) As Today
From
  KD_Sales_Data_Request A
Where
  A.Invoicedate = Trunc(Sysdate) And
  A.Charge_Type = 'Parts' And
  A.Corporate_Form = 'DOMDIR' And
  ((A.Order_No Not Like 'W%' And
    A.Order_No Not Like 'X%') Or
    A.Order_No Is Null) And
  (A.Market_Code != 'PREPOST' Or A.Market_Code Is Null)
Group By
  A.Commission_Receiver;