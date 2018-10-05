Create Or Replace View KD_SVQ_Margins As
Select
    A.Salesman_Code,
   (Round(
         (Sum(Case When A.Invoiceqtr = 'QTR' || To_Char(Sysdate,'Q') 
                   Then A.Allamounts
                   Else 0
              End)-
          Sum(Case When A.Invoiceqtr = 'QTR' || To_Char(Sysdate,'Q')
                   Then A.Cost * A.Invoiced_Qty
                   Else 0
              End))/
          Nullif(Sum(Case When A.Invoiceqtr = 'QTR' || To_Char(Sysdate,'Q') 
                   Then A.Allamounts
                   Else 0
             End),0),5))*100 As Qtd_Margin,
    (Round((Sum(A.AllAmounts)-Sum(A.Cost * A.Invoiced_Qty))/Nullif(Sum(A.AllAmounts),0),5)) * 100 As YTD_Margin
From
    Kd_Sales_Data_Request A
Where
    Extract(Year From Invoicedate) = Extract(Year From Sysdate) And
    A.Charge_Type = 'Parts' And
    A.Corporate_Form = 'DOMDIR' And
    A.Catalog_No != '3DBC-22001091' And
  ((A.Order_No Not Like 'W%' And
    A.Order_No Not Like 'X%') Or
    A.Order_No Is Null) And
   (A.Market_Code != 'PREPOST' Or A.Market_Code Is Null) And
   A.Invoice_ID != 'CR1001802096' --20180904 Invoice is stuck not posted and cannot be deleted.
Group By
    A.Salesman_Code