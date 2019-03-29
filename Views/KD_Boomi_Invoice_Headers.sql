Create OR replace View KD_Boomi_Invoice_Headers As
Select
  A.Salesman_Code,
  A.Customer_No,
  A.Customer_Name,
  Case When A.Invoice_Id Like 'CR%'
       Then ''
       Else A.Order_No
  End As Order_No,
  Case When A.Invoice_ID LIke 'CR%' Then A.InvoiceDate Else B.Date_Entered End As Date_Entered,
  A.Invoice_Id,
  Sum(A.AllAmounts) As Total,
  A.Invoicedate,
  Case When A.Source = 'SI' Then ' ' Else A.Authorize_Code End As Authorize_Code,
  A.Region_Code,
  A.Createdate,
  A.Corporate_Form,
  Max(A.Market_Code) As Market_Code,
  A.Pay_Term_Description,
  A.Kdreference,
  A.CustomerRef,
  Case When Instr(A.Invoice_Id,'CR') = 0
       Then B.Customer_Po_No
       Else ''
  End As Customer_Po_No,
  A.Deliverydate,
  A.Ship_Via,
  A.Currency,
  A.Invoiceadd1,
  A.Invoiceadd2,
  A.Invoicecity,
  A.Invoicestate,
  A.Invoicezip,
  A.Delivadd1,
  A.Delivadd2,
  A.Delivcity,
  A.Delivstate,
  A.Delivzip,
  Max(A.Item_ID) As Total_Lines

From
  Kd_Sales_Data_Request A Left Join Customer_Order B On
    A.Site = B.Contract And
    A.Customer_No = B.Customer_No And
    A.Order_No = B.Order_No 
    
Where
  A.Catalog_No != '3DBC-22001091' And
  ((A.Order_No Not Like 'W%' And
    A.Order_No Not Like 'X%') Or
    A.Order_No Is Null) And
  (A.Market_Code != 'PREPOST' Or A.Market_Code Is Null) And
    A.Invoice_ID != 'CR1001802096' AND --20180904 Invoice is stuck not posted and cannot be deleted.
    A.Order_No != 'C512921' And --Kevin Stack's order/return that spanned years.
    Site = '100' And
  A.Charge_Type = 'Parts' And  
  A.Corporate_Form In ('DOMDIR','ASIA') And
  ((
  A.Salesman_Code Not In ('505','506','507','508','318') And
  A.Customer_No != 'B3730' And
  A.Invoice_Id != '0' )
  Or
  (A.Customer_No In ('B2911',
        '32517',
        'B2864',
        'B6706',
        'B3169',
        'B2140',
        'B2189',
        'B6499',
        'B6646',
        'B6532',
        'B6782',
        'B3730',
        'B2848',
        'B6684',
        '1639')
        )) And
    A.Currency in ('USD','CAD')
Group By
  A.Salesman_Code,
  A.Customer_No,
  A.Customer_Name,
  Case When A.Invoice_Id Like 'CR%'
       Then ''
       Else A.Order_No
  End,
  A.Invoice_Id,
  A.Invoicedate,
  Case When A.Source = 'SI' Then ' ' Else A.Authorize_Code End,
  A.Region_Code,
  A.Createdate,
  A.Corporate_Form,
  A.Pay_Term_Description,
  A.Kdreference,
  A.CustomerRef,
  Case When Instr(A.Invoice_Id,'CR') = 0
       Then B.Customer_Po_No
       Else ''
  End,
  Case When A.Invoice_ID LIke 'CR%' Then A.InvoiceDate Else B.Date_Entered End,
  A.Deliverydate,
  A.Ship_Via,
  A.Currency,
  A.Invoiceadd1,
  A.Invoiceadd2,
  A.Invoicecity,
  A.Invoicestate,
  A.Invoicezip,
  A.Delivadd1,
  A.Delivadd2,
  A.Delivcity,
  A.Delivstate,
  A.Delivzip