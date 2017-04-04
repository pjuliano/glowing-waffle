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
  A.Charge_Type = 'Parts' And
  A.Corporate_Form = 'DOMDIR' And
  ((A.Order_No Not Like 'W%' And
  A.Order_No Not Like 'X%') Or A.Order_No Is Null) And
  A.Customer_No Not In ('A86088','A35173') And
  A.Salesman_Code = B.Person_Id And
  (A.Market_Code != 'PREPOST' Or A.Market_Code Is Null)