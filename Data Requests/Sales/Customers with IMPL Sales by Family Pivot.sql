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
    (A.Invoicedate Between To_Date('01/01/2016','MM/DD/YYYY') And To_Date('08/31/2016','MM/DD/YYYY') Or
    A.Invoicedate Between To_Date('01/01/2017','MM/DD/YYYY') And To_Date('08/31/2017','MM/DD/YYYY') Or
    A.InvoiceDate Between To_Date('01/01/2015','MM/DD/YYYY') And To_Date('08/31/2015','MM/DD/YYYY')) And
    A.Part_Product_Code = 'IMPL' And
    A.Corporate_Form = 'DOMDIR')
Pivot (
  Sum(Allamounts)
  For "Family-Year" In ('EXHEX-2015',
                        'EXHEX-2016',
                        'EXHEX-2017',
                        'OCT-2015',
                        'OCT-2016',
                        'OCT-2017',
                        'ZMAX-2015',
                        'ZMAX-2016',
                        'ZMAX-2017',
                        'EXORL-2015',
                        'EXORL-2016',
                        'EXORL-2017',
                        'TRINX-2015',
                        'TRINX-2016',
                        'TRINX-2017',
                        'PRIMA-2015',
                        'PRIMA-2016',
                        'PRIMA-2017',
                        'GNSIS-2015',
                        'GNSIS-2016',
                        'GNSIS-2017',
                        'OTMED-2015',
                        'OTMED-2016',
                        'OTMED-2017'))