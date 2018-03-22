With Customers As (
Select
  *
From (
  Select
    A.Salesman_Code,
    Person_Info_Api.Get_Name(A.Salesman_Code) As Salesman_Name,
    A.Region_Code,
    A.Customer_No,
    A.Customer_Name,
    A.Part_Product_Family || '-' || Extract(Year From A.InvoiceDate) As "Family-Year",
    A.AllAmounts
  From
    KD_Sales_Data_Request A
  Where
    (A.Invoicedate Between To_Date('01/01/2017','MM/DD/YYYY') And To_Date('03/31/2017','MM/DD/YYYY') Or
    A.Invoicedate Between To_Date('01/01/2018','MM/DD/YYYY') And To_Date('03/31/2018','MM/DD/YYYY') Or
    A.InvoiceDate Between To_Date('01/01/2018','MM/DD/YYYY') And To_Date('03/31/2018','MM/DD/YYYY')) And
    A.Part_Product_Code = 'IMPL' And
    A.Corporate_Form = 'DOMDIR')
Pivot (
  Sum(Allamounts)
  For "Family-Year" In ('EXHEX-2016' As "EXHEX-2016",
                        'EXHEX-2017' As "EXHEX-2017",
                        'EXHEX-2018' As "EXHEX-2018",
                        'OCT-2016' As "OCT-2016",
                        'OCT-2017' As "OCT-2017",
                        'OCT-2018' As "OCT-2018",
                        'ZMAX-2016' As "ZMAX-2016",
                        'ZMAX-2017' As "ZMAX-2017",
                        'ZMAX-2018' As "ZMAX-2018",
                        'EXORL-2016' As "EXORL-2016",
                        'EXORL-2017' As "EXORL-2017",
                        'EXORL-2018' As "EXORL-2018",
                        'TRINX-2016' As "TRINX-2016",
                        'TRINX-2017' As "TRINX-2017",
                        'TRINX-2018' As "TRINX-2018",
                        'PRIMA-2016' As "PRIMA-2016",
                        'PRIMA-2017' As "PRIMA-2017",
                        'PRIMA-2018' As "PRIMA-2018",
                        'PRMA+-2016' As "PRMA+-2016",
                        'PRMA+-2017' As "PRMA+-2017",
                        'PRMA+-2018' As "PRMA+-2018",
                        'GNSIS-2016' As "GNSIS-2016",
                        'GNSIS-2017' As "GNSIS-2017",
                        'GNSIS-2018' As "GNSIS-2018",
                        'OTMED-2016' As "OTMED-2016",
                        'OTMED-2017' As "OTMED-2017",
                        'OTMED-2018' As "OTMED-2018")))

Select
  Salesman_Code,
  Salesman_Name,
  Region_Code,
  Customer_No,
  Customer_Name,
  "EXHEX-2016",
  "EXHEX-2017",
  Case When ("EXHEX-2016" <= 1000 Or "EXHEX-2016" Is Null) And "EXHEX-2017" >= 5000
       Then 'NEW CUSTOMER'
  End As "NEW-EXHEX-2017",
  "EXHEX-2018",
  Case When ("EXHEX-2017" <= 1000 Or "EXHEX-2017" Is Null) And "EXHEX-2018" >= 5000
       Then 'NEW CUSTOMER'
  End As "NEW-EXHEX-2018",
  "OCT-2016",
  "OCT-2017",
  Case When ("OCT-2016" <= 1000 Or "OCT-2016" Is Null) And "OCT-2017" >= 5000
       Then 'NEW CUSTOMER'
  End As "NEW-OCT-2017", 
  "OCT-2018",
  Case When ("OCT-2017" <= 1000 Or "OCT-2017" Is Null) And "OCT-2018" >= 5000
       Then 'NEW CUSTOMER'
  End As "NEW-OCT-2018",
  "ZMAX-2016",
  "ZMAX-2017",
  Case When ("ZMAX-2016" <= 1000 Or "ZMAX-2016" Is Null) And "ZMAX-2017" >= 5000
       Then 'NEW CUSTOMER'
  End As "NEW-ZMAX-2017",
  "ZMAX-2018",
  Case When ("ZMAX-2017" <= 1000 Or "ZMAX-2017" Is Null) And "ZMAX-2018" >= 5000
       Then 'NEW CUSTOMER'
  End As "NEW-ZMAX-2018",
  "EXORL-2016",
  "EXORL-2017",
  Case When ("EXORL-2016" <= 1000 Or "EXORL-2016" Is Null) And "EXORL-2017" >= 5000
       Then 'NEW CUSTOMER'
  End As "NEW-EXORL-2017",  
  "EXORL-2018",
  Case When ("EXORL-2017" <= 1000 Or "EXORL-2017" Is Null) And "EXORL-2018" >= 5000
       Then 'NEW CUSTOMER'
  End As "NEW-EXORL-2018",
  "TRINX-2016",
  "TRINX-2017",
  Case When ("TRINX-2016" <= 1000 Or "TRINX-2016" Is Null) And "TRINX-2017" >= 5000
       Then 'NEW CUSTOMER'
  End As "NEW-TRINX-2017",
  "TRINX-2018",
  Case When ("TRINX-2017" <= 1000 Or "TRINX-2017" Is Null) And "TRINX-2018" >= 5000
       Then 'NEW CUSTOMER'
  End As "NEW-TRINX-2018",
  "PRIMA-2016",
  "PRIMA-2017",
  Case When ("PRIMA-2016" <= 1000 Or "PRIMA-2016" Is Null) And "PRIMA-2017" >= 5000
       Then 'NEW CUSTOMER'
  End As "NEW-PRIMA-2017",
  "PRIMA-2018",
  Case When ("PRIMA-2017" <= 1000 Or "PRIMA-2017" Is Null) And "PRIMA-2018" >= 5000
       Then 'NEW CUSTOMER'
  End As "NEW-PRIMA-2018",
  "PRMA+-2016",
  "PRMA+-2017",
  Case When ("PRMA+-2016" <= 1000 Or "PRMA+-2016" Is Null) And "PRMA+-2017" >= 5000
       Then 'NEW CUSTOMER'
  End As "NEW-PRMA+-2017",
  "PRMA+-2018",
  Case When ("PRMA+-2017" <= 1000 Or "PRMA+-2017" Is Null) And "PRMA+-2018" >= 5000
       Then 'NEW CUSTOMER'
  End As "NEW-PRMA+-2018",
  "GNSIS-2016",
  "GNSIS-2017",
  Case When ("GNSIS-2016" <= 1000 Or "GNSIS-2016" Is Null) And "GNSIS-2017" >= 5000
       Then 'NEW CUSTOMER'
  End As "NEW-GNSIS-2017",
  "GNSIS-2018",
  Case When ("GNSIS-2017" <= 1000 Or "GNSIS-2017" Is Null) And "GNSIS-2018" >= 5000
       Then 'NEW CUSTOMER'
  End As "NEW-GNSIS-2018",
  "OTMED-2016",
  "OTMED-2017",
  Case When ("OTMED-2016" <= 1000 Or "OTMED-2016" Is Null) And "OTMED-2017" >= 5000
       Then 'NEW CUSTOMER'
  End As "NEW-OTMED-2017",
  "OTMED-2018",
  Case When ("OTMED-2017" <= 1000 Or "OTMED-2017" Is Null) And "OTMED-2018" >= 5000
       Then 'NEW CUSTOMER'
  End As "NEW-OTMED-2018"
From
  Customers
Where
  Case When ("EXHEX-2016" <= 1000 Or "EXHEX-2016" Is Null) And "EXHEX-2017" >= 5000
       Then 'NEW CUSTOMER'
  End = 'NEW CUSTOMER' Or
  Case When ("EXHEX-2017" <= 1000 Or "EXHEX-2017" Is Null) And "EXHEX-2018" >= 5000
       Then 'NEW CUSTOMER'
  End = 'NEW CUSTOMER' Or
  Case When ("OCT-2016" <= 1000 Or "OCT-2016" Is Null) And "OCT-2017" >= 5000
       Then 'NEW CUSTOMER'
  End = 'NEW CUSTOMER' Or
  Case When ("OCT-2017" <= 1000 Or "OCT-2017" Is Null) And "OCT-2018" >= 5000
       Then 'NEW CUSTOMER'
  End = 'NEW CUSTOMER' Or
  Case When ("ZMAX-2016" <= 1000 Or "ZMAX-2016" Is Null) And "ZMAX-2017" >= 5000
       Then 'NEW CUSTOMER'
  End = 'NEW CUSTOMER' Or
  Case When ("ZMAX-2017" <= 1000 Or "ZMAX-2017" Is Null) And "ZMAX-2018" >= 5000
       Then 'NEW CUSTOMER'
  End = 'NEW CUSTOMER' Or
  Case When ("EXORL-2016" <= 1000 Or "EXORL-2016" Is Null) And "EXORL-2017" >= 5000
       Then 'NEW CUSTOMER'
  End = 'NEW CUSTOMER' Or
  Case When ("EXORL-2017" <= 1000 Or "EXORL-2017" Is Null) And "EXORL-2018" >= 5000
       Then 'NEW CUSTOMER'
  End = 'NEW CUSTOMER' Or
  Case When ("TRINX-2016" <= 1000 Or "TRINX-2016" Is Null) And "TRINX-2017" >= 5000
       Then 'NEW CUSTOMER'
  End = 'NEW CUSTOMER' Or
  Case When ("TRINX-2017" <= 1000 Or "TRINX-2017" Is Null) And "TRINX-2018" >= 5000
       Then 'NEW CUSTOMER'
  End = 'NEW CUSTOMER' Or
  Case When ("PRIMA-2016" <= 1000 Or "PRIMA-2016" Is Null) And "PRIMA-2017" >= 5000
       Then 'NEW CUSTOMER'
  End = 'NEW CUSTOMER' Or
  Case When ("PRIMA-2017" <= 1000 Or "PRIMA-2017" Is Null) And "PRIMA-2018" >= 5000
       Then 'NEW CUSTOMER'
  End = 'NEW CUSTOMER' Or
  Case When ("PRMA+-2017" <= 1000 Or "PRMA+-2017" Is Null) And "PRMA+-2018" >= 5000
       Then 'NEW CUSTOMER'
  End = 'NEW CUSTOMER' Or
  Case When ("GNSIS-2016" <= 1000 Or "GNSIS-2016" Is Null) And "GNSIS-2017" >= 5000
       Then 'NEW CUSTOMER'
  End = 'NEW CUSTOMER' Or
  Case When ("GNSIS-2017" <= 1000 Or "GNSIS-2017" Is Null) And "GNSIS-2018" >= 5000
       Then 'NEW CUSTOMER'
  End = 'NEW CUSTOMER' Or
  Case When ("OTMED-2016" <= 1000 Or "OTMED-2016" Is Null) And "OTMED-2017" >= 5000
       Then 'NEW CUSTOMER'
  End = 'NEW CUSTOMER' Or
  Case When ("OTMED-2017" <= 1000 Or "OTMED-2017" Is Null) And "OTMED-2018" >= 5000
       Then 'NEW CUSTOMER'
  End = 'NEW CUSTOMER'