Create Or Replace View KD_US_Sales_Detail_Grouped As
Select
  A.Customer_No,
  A.Customer_Name,
  Extract(Month From A.Invoicedate) As Month,
  Extract(Year From A.Invoicedate) As Year,
  A.Invoiceqtr,
  A.Salesman_Code,
  E.Name,
  A.Commission_Receiver,
  A.Region_Code,
  A.Delivstate,
  A.Delivcountry,
  A.Delivzip,
  A.Part_Product_Family,
  A.Part_Product_Code,
  A.Second_Commodity,
  A.Invoiced_Qty,
  Sum(A.Sale_Unit_Price) As Sale_Unit_Price,
  Sum(A.Allamounts) As Allamounts,
  Sum(C.Inventoryvalueus * A.Invoiced_Qty) As Cost_Value,
  Sum(A.Truelocalamt) As Truelocalamt,
  A.Association_No,
  A.District_Code,
  A.Cust_Grp,
  A.Market_Code,
  A.Site,
  Case When A.Corporate_Form In ('DOMDIR')
       Then 'NADIRECT'
       When A.Corporate_Form In ('GER','BENELUX','FRA','ITL','SWE')
       Then 'EUROPE'
       When A.Corporate_Form In ('ASIA','AT','EUR','SPA','CAN','DOMDIS')
       Then 'GLOBALDIST'
  End As Segment,
  A.Corporate_Form,
  A.Source,
  A.Type_Designation,
  Case When A.Part_Product_Family In ('DYNAC','DYNAG','DYNAM','DYNAB','CONNX','CYTOP','BVINE','SYNTH','MFT')
       Then 'BIOMATERIALS'
       When A.Part_Product_Family In ('COMM','GNSIS','PRIMA','RENOV','RESTO','STAGE','SUST','TEFGE','XP1','TRINX','EXHEX','EXORL','OCT','ZMAX','LODI','OTMED')
       Then 'IMPLANTS'
       Else 'OTHER'
  End As Product_Type,
  Sum(B.List_Price) As List_Price
From
  Kd_Sales_Data_Request A Left Join Sales_Part B
    On A.Site = B.Contract And
       A.Catalog_No = B.Catalog_No
                          Left Join Kd_Cost_Values C
    On A.Catalog_No = C.Part_No
                          Left Join Kd_Unique_Sales_Parts D
    On A.Catalog_No = D.Catalog_No
                          Left Join Person_Info E
    On A.Salesman_Code = E.Person_Id
                          Left Join Customer_Order F
    On A.Order_No = F.Order_No And
       A.Customer_No = F.Customer_No
Where
  A.Charge_Type = 'Parts'
Group By
  A.Customer_No,
  A.Customer_Name,
  Extract(Month From A.Invoicedate),
  Extract(Year From A.Invoicedate),
  A.Invoiceqtr,
  A.Salesman_Code,
  E.Name,
  A.Commission_Receiver,
  A.Region_Code,
  A.Delivstate,
  A.Delivcountry,
  A.Delivzip,
  A.Part_Product_Family,
  A.Part_Product_Code,
  A.Second_Commodity,
  A.Invoiced_Qty,
    A.Association_No,
  A.District_Code,
  A.Cust_Grp,
  A.Market_Code,
  A.Site,
  Case When A.Corporate_Form In ('DOMDIR')
       Then 'NADIRECT'
       When A.Corporate_Form In ('GER','BENELUX','FRA','ITL','SWE')
       Then 'EUROPE'
       When A.Corporate_Form In ('ASIA','AT','EUR','SPA','CAN','DOMDIS')
       Then 'GLOBALDIST'
  End,
  A.Corporate_Form,
  A.Source,
  A.Type_Designation,
  Case When A.Part_Product_Family In ('DYNAC','DYNAG','DYNAM','DYNAB','CONNX','CYTOP','BVINE','SYNTH','MFT')
       Then 'BIOMATERIALS'
       When A.Part_Product_Family In ('COMM','GNSIS','PRIMA','RENOV','RESTO','STAGE','SUST','TEFGE','XP1','TRINX','EXHEX','EXORL','OCT','ZMAX','LODI','OTMED')
       Then 'IMPLANTS'
       Else 'OTHER'
  End