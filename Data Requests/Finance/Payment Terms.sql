Select
  A.Customer_No,
  A.Customer_Name,
  A.Invoicedate,
  A.Invoice_Id,
  Extract(Month From A.Invoicedate) As Month,
  Extract(Year From A.Invoicedate) As Year,
  A.Invoiceqtr,
  A.Salesman_Code,
  Person_Info_Api.Get_Name(A.Salesman_Code) As Salesman_Name,
  Sum(A.Allamounts) As Sales_Price_Fc,
  Decode(A.Corporate_Form,'DOMDIR','NADIRECT') As Segment,
  A.Order_No,
  Case When A.Part_Product_Family In ('DYNAC','DYNAG','DYNAB','DYNAM','CONNX','CYTOP','BVINE','SYNTH','MTF')
       Then 'BIOMATERIALS'
       When A.Part_Product_Family In ('COMM','GNSIS','PRIMA','RENOV','STAGE','SUST','TEFGE','XP1','TRINX','EXHEX','EXORL','OCT','ZMAX','LODI','OTMED')
       Then 'IMPLANTS'
       When A.Part_Product_Family In ('EG','CUSAB','OTHER','EDU','MOTOR','ODYSS','LEGACY','DEVELOP')
       Then 'OTHER'
  End As Product_Type,
  Customer_Order_Api.Get_Pay_Term_Id(A.Order_No) As Order_Terms,
  Identity_Invoice_Info_Api.Get_Pay_Term_Id(A.Site,A.Customer_No,'CUSTOMER') As Customer_Terms
From
  Kd_Sales_Data_Nightly A
Where
  A.Invoicedate >= To_Date('01/01/2015','MM/DD/YYYY') And
  A.Corporate_Form = 'DOMDIR' And
  A.Charge_Type = 'Parts'
Group By
  A.Customer_No,
  A.Customer_Name,
  A.Invoicedate,
  A.Invoice_Id,
  Extract(Month From A.Invoicedate),
  Extract(Year From A.Invoicedate),
  A.Invoiceqtr,
  A.Salesman_Code,
  Person_Info_Api.Get_Name(A.Salesman_Code),
  Decode(A.Corporate_Form,'DOMDIR','NADIRECT'),
  A.Order_No,
  Case When A.Part_Product_Family In ('DYNAC','DYNAG','DYNAB','DYNAM','CONNX','CYTOP','BVINE','SYNTH','MTF')
       Then 'BIOMATERIALS'
       When A.Part_Product_Family In ('COMM','GNSIS','PRIMA','RENOV','STAGE','SUST','TEFGE','XP1','TRINX','EXHEX','EXORL','OCT','ZMAX','LODI','OTMED')
       Then 'IMPLANTS'
       When A.Part_Product_Family In ('EG','CUSAB','OTHER','EDU','MOTOR','ODYSS','LEGACY','DEVELOP')
       Then 'OTHER'
  End,
  Customer_Order_Api.Get_Pay_Term_Id(A.Order_No),
  Identity_Invoice_Info_Api.Get_Pay_Term_Id(A.Site,A.Customer_No,'CUSTOMER')