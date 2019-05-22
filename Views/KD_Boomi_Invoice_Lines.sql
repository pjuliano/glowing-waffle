Create Or Replace View KD_Boomi_Invoice_Lines As 
Select
  Site,
  Invoice_Id,
  Case When Source = 'SI' Then Item_Id || '-' || Authorize_Code Else Item_ID End As Item_ID,
  Invoicedate,
  Decode(Invoiced_Qty,0,1,Invoiced_Qty) As Invoiced_Qty,
  Sale_Unit_Price,
  Discount,
  Net_Curr_Amount,
  Gross_Curr_Amount,
  Catalog_Desc,
  Customer_Name,
  Order_No,
  Customer_No,
  Cust_Grp,
  Case When Invoiced_Qty = 0 Then 'Manual Credit'
       When Sales_Part_Api.Check_Exist(Site, Catalog_No) = 0 Or Inventory_Part_Api.Get_Accounting_Group(Site,Catalog_No) Not In ('FG','LIT','DEMO') Or catalog_No In ('PRCADJ','PRIPROKIT','UPGRFEE','PROCFEE') Then 'UNKNOWN'
       Else Catalog_No End As Catalog_No,
  Authorize_Code,
  Salesman_Code,
  District_Code,
  Region_Code,
  Createdate,
  Part_Product_Code,
  Part_Product_Family,
  Second_Commodity,
  Invoicemonth,
  Invoiceqtr,
  Invoiceqtryr,
  Invoicemthyr,
  Group_Id,
  Type_Designation,
  Customer_No_Pay,
  Corporate_Form,
  Allamounts,
  Localamount,
  Charge_Type,
  Source,
  Currency
From
  Kd_Sales_Data_Request A
Where
  A.Catalog_No != '3DBC-22001091' And
  ((A.Order_No Not Like 'W%' And
    A.Order_No Not Like 'X%') Or
    A.Order_No Is Null) And
  (A.Market_Code != 'PREPOST' Or A.Market_Code Is Null) And
    A.Invoice_ID != 'CR1001802096' AND --20180904 Invoice is stuck not posted and cannot be deleted.
    (A.Order_No != 'C512921' Or A.Order_No Is Null) And --Kevin Stack's order/return that spanned years.
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