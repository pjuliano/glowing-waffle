Create or Replace View KD_NA_Commission_Detail As
Select
  A.Customer_No,
  A.Customer_Name,
  A.Invoicedate,
  A.Invoice_Id,
  A.Item_Id As Line,
  Extract(Month From A.Invoicedate) As Month,
  Extract(Year From A.Invoicedate) As Year,
  A.Invoiceqtr As Qtr,
  A.Salesman_Code,
  B.Name As Salesman_Name,
  A.Commission_Receiver,
  A.Region_Code,
  A.Delivstate,
  A.Delivcountry,
  A.Delivzip,
  A.Catalog_No,
  A.Catalog_Desc,
  A.Part_Product_Family,
  A.Part_Product_Code,
  A.Second_Commodity,
  A.Invoiced_Qty,
  A.Sale_Unit_Price,
  A.Allamounts,
  A.Invoiced_Qty * A.Cost As Cost,
  A.Truelocalamt As Local_Amount,
  A.Association_No,
  A.District_Code,
  A.Cust_Grp,
  A.Market_Code,
  A.Site,
  Case
    When
      A.Corporate_Form = 'DOMDIR'
    Then
      'NADIRECT'
    Else
      Null
  End As Segment,
  A.Rma_No,
  A.Order_No,
  C.Order_Id As Order_Type,
  A.Source,
  Case
    When
      A.Part_Product_Code = 'REGEN'
    Then
      'BIOMATERIALS'
    When
      A.Part_Product_Code Not In ('REGEN','LIT')
    Then
      'IMPLANTS'
    Else
      'OTHER'
  End As Product_Type,
  A.Customer_Name As Association_Name
From
  Kd_Sales_Data_Request A Left Join Customer_Order C
    On A.Order_No = C.Order_No And
       A.Customer_No = C.Customer_No,
  Person_Info B
Where
    a.charge_type = 'Parts' AND
    a.corporate_form = 'DOMDIR' AND
    ((a.order_no NOT LIKE 'W%' AND
    a.order_no NOT LIKE 'X%') OR a.order_no IS NULL) AND
    a.catalog_no != '3DBC-22001091' AND
    a.customer_no NOT IN ('A86088','A35173') AND
    a.salesman_code = b.person_id AND
    (a.market_code != 'PREPOST' OR a.market_code IS NULL) AND
    a.invoice_id != 'CR1001802096' AND --20180904 Invoice is stuck not posted and cannot be deleted.
    (a.order_no != 'C512921' OR a.order_No Is Null) AND --Kevin Stack's order/return that spanned years.
    a.Salesman_code != '318'