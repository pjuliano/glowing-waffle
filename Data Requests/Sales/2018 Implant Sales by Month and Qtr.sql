Select
    Salesman_Code,
    Person_Info_Api.Get_Name(Salesman_Code) As Salesman_Name,
    A.Part_Product_Family,
    Sum(Case When Extract(Month From A.InvoiceDate) = 1 Then A.Invoiced_Qty Else 0 End) as M1,
    Sum(Case When Extract(Month From A.InvoiceDate) = 2 Then A.Invoiced_Qty Else 0 End) as M2,
    Sum(Case When Extract(Month From A.InvoiceDate) = 3 Then A.Invoiced_Qty Else 0 End) as M3,
    Sum(Case When Extract(Month From A.InvoiceDate) = 4 Then A.Invoiced_Qty Else 0 End) as M4,
    Sum(Case When Extract(Month From A.InvoiceDate) = 5 Then A.Invoiced_Qty Else 0 End) as M5,
    Sum(Case When Extract(Month From A.InvoiceDate) = 6 Then A.Invoiced_Qty Else 0 End) as M6,
    Sum(Case When Extract(Month From A.InvoiceDate) = 7 Then A.Invoiced_Qty Else 0 End) as M7,
    Sum(Case When Extract(Month From A.InvoiceDate) = 8 Then A.Invoiced_Qty Else 0 End) as M8,
    Sum(Case When Extract(Month From A.InvoiceDate) = 9 Then A.Invoiced_Qty Else 0 End) as M9,
    Sum(Case When Extract(Month From A.InvoiceDate) = 10 Then A.Invoiced_Qty Else 0 End) as M10,
    Sum(Case When Extract(Month From A.InvoiceDate) = 11 Then A.Invoiced_Qty Else 0 End) as M11,
    Sum(Case When Extract(Month From A.InvoiceDate) = 12 Then A.Invoiced_Qty Else 0 End) as M12,
    Sum(Case When A.InvoiceQtr = 'QTR1' Then A.Invoiced_Qty Else 0 End) as Q1,
    Sum(Case When A.InvoiceQtr = 'QTR2' Then A.Invoiced_Qty Else 0 End) as Q2,
    Sum(Case When A.InvoiceQtr = 'QTR3' Then A.Invoiced_Qty Else 0 End) as Q3,
    Sum(Case When A.InvoiceQtr = 'QTR4' Then A.Invoiced_Qty Else 0 End) as Q4,
    Sum(A.Invoiced_Qty) as Year
From
    KD_Sales_Data_Request A
Where
  Extract(Year From A.Invoicedate) = Extract(Year From Sysdate)-1 And
  A.Charge_Type = 'Parts' And
  A.Corporate_Form = 'DOMDIR' And
  A.Catalog_No != '3DBC-22001091' And
  ((A.Order_No Not Like 'W%' And
    A.Order_No Not Like 'X%') Or
    A.Order_No Is Null) And
  (A.Market_Code != 'PREPOST' Or A.Market_Code Is Null) And
  A.PArt_Product_Code = 'IMPL' And
  A.Invoice_ID != 'CR1001802096' --20180904 Invoice is stuck not posted and cannot be deleted.
Group By
    Salesman_Code,
    Person_Info_Api.Get_Name(Salesman_Code),
    A.Part_Product_Family