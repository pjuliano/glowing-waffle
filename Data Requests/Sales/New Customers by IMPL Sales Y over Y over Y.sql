With Customers As (
Select
  *
From (
  Select
    A.Customer_No,
    A.Customer_Name,
    A.Part_Product_Family || '-' || Extract(Year From A.InvoiceDate) As "Family-Year",
    A.AllAmounts
  From
    KD_Sales_Data_Request A
  Where
    (A.Invoicedate Between To_Date('01/01/2016','MM/DD/YYYY') And To_Date('12/04/2016','MM/DD/YYYY') Or
    A.Invoicedate Between To_Date('01/01/2017','MM/DD/YYYY') And To_Date('12/04/2017','MM/DD/YYYY') Or
    A.InvoiceDate Between To_Date('01/01/2015','MM/DD/YYYY') And To_Date('12/04/2015','MM/DD/YYYY')) And
    A.Part_Product_Code = 'IMPL' And
    A.Corporate_Form = 'DOMDIR')
Pivot (
  Sum(Allamounts)
  For "Family-Year" In ('EXHEX-2015' As "EXHEX-2015",
                        'EXHEX-2016' As "EXHEX-2016",
                        'EXHEX-2017' As "EXHEX-2017",
                        'OCT-2015' As "OCT-2015",
                        'OCT-2016' As "OCT-2016",
                        'OCT-2017' As "OCT-2017",
                        'ZMAX-2015' As "ZMAX-2015",
                        'ZMAX-2016' As "ZMAX-2016",
                        'ZMAX-2017' As "ZMAX-2017",
                        'EXORL-2015' As "EXORL-2015",
                        'EXORL-2016' As "EXORL-2016",
                        'EXORL-2017' As "EXORL-2017",
                        'TRINX-2015' As "TRINX-2015",
                        'TRINX-2016' As "TRINX-2016",
                        'TRINX-2017' As "TRINX-2017",
                        'PRIMA-2015' As "PRIMA-2015",
                        'PRIMA-2016' As "PRIMA-2016",
                        'PRIMA-2017' As "PRIMA-2017",
                        'GNSIS-2015' As "GNSIS-2015",
                        'GNSIS-2016' As "GNSIS-2016",
                        'GNSIS-2017' As "GNSIS-2017",
                        'OTMED-2015' As "OTMED-2015",
                        'OTMED-2016' As "OTMED-2016",
                        'OTMED-2017' As "OTMED-2017")))

Select
  Customer_No,
  Customer_Name,
  "EXHEX-2015",
  "EXHEX-2016",
  Case When ("EXHEX-2015" <= 1000 Or "EXHEX-2015" Is Null) And "EXHEX-2016" >= 5000
       Then 'NEW CUSTOMER'
  End As "NEW-EXHEX-2016",
  "EXHEX-2017",
  Case When ("EXHEX-2016" <= 1000 Or "EXHEX-2016" Is Null) And "EXHEX-2017" >= 5000
       Then 'NEW CUSTOMER'
  End As "NEW-EXHEX-2017",
  "OCT-2015",
  "OCT-2016",
  Case When ("OCT-2015" <= 1000 Or "OCT-2015" Is Null) And "OCT-2016" >= 5000
       Then 'NEW CUSTOMER'
  End As "NEW-OCT-2016", 
  "OCT-2017",
  Case When ("OCT-2016" <= 1000 Or "OCT-2016" Is Null) And "OCT-2017" >= 5000
       Then 'NEW CUSTOMER'
  End As "NEW-OCT-2017",
  "ZMAX-2015",
  "ZMAX-2016",
  Case When ("ZMAX-2015" <= 1000 Or "ZMAX-2015" Is Null) And "ZMAX-2016" >= 5000
       Then 'NEW CUSTOMER'
  End As "NEW-ZMAX-2016",
  "ZMAX-2017",
  Case When ("ZMAX-2016" <= 1000 Or "ZMAX-2016" Is Null) And "ZMAX-2017" >= 5000
       Then 'NEW CUSTOMER'
  End As "NEW-ZMAX-2017",
  "EXORL-2015",
  "EXORL-2016",
  Case When ("EXORL-2015" <= 1000 Or "EXORL-2015" Is Null) And "EXORL-2016" >= 5000
       Then 'NEW CUSTOMER'
  End As "NEW-EXORL-2016",  
  "EXORL-2017",
  Case When ("EXORL-2016" <= 1000 Or "EXORL-2016" Is Null) And "EXORL-2017" >= 5000
       Then 'NEW CUSTOMER'
  End As "NEW-EXORL-2017",
  "TRINX-2015",
  "TRINX-2016",
  Case When ("TRINX-2015" <= 1000 Or "TRINX-2015" Is Null) And "TRINX-2016" >= 5000
       Then 'NEW CUSTOMER'
  End As "NEW-TRINX-2016",
  "TRINX-2017",
  Case When ("TRINX-2016" <= 1000 Or "TRINX-2016" Is Null) And "TRINX-2017" >= 5000
       Then 'NEW CUSTOMER'
  End As "NEW-TRINX-2017",
  "PRIMA-2015",
  "PRIMA-2016",
  Case When ("PRIMA-2015" <= 1000 Or "PRIMA-2015" Is Null) And "PRIMA-2016" >= 5000
       Then 'NEW CUSTOMER'
  End As "NEW-PRIMA-2016",
  "PRIMA-2017",
  Case When ("PRIMA-2016" <= 1000 Or "PRIMA-2016" Is Null) And "PRIMA-2017" >= 5000
       Then 'NEW CUSTOMER'
  End As "NEW-PRIMA-2017",
  "GNSIS-2015",
  "GNSIS-2016",
  Case When ("GNSIS-2015" <= 1000 Or "GNSIS-2015" Is Null) And "GNSIS-2016" >= 5000
       Then 'NEW CUSTOMER'
  End As "NEW-GNSIS-2016",
  "GNSIS-2017",
  Case When ("GNSIS-2016" <= 1000 Or "GNSIS-2016" Is Null) And "GNSIS-2017" >= 5000
       Then 'NEW CUSTOMER'
  End As "NEW-GNSIS-2017",
  "OTMED-2015",
  "OTMED-2016",
  Case When ("OTMED-2015" <= 1000 Or "OTMED-2015" Is Null) And "OTMED-2016" >= 5000
       Then 'NEW CUSTOMER'
  End As "NEW-OTMED-2016",
  "OTMED-2017",
  Case When ("OTMED-2016" <= 1000 Or "OTMED-2016" Is Null) And "OTMED-2017" >= 5000
       Then 'NEW CUSTOMER'
  End As "NEW-OTMED-2017"
From
  Customers