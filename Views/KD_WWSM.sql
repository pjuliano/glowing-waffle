Create Or Replace View KD_WWSM As
Select
    SD.Corporate_Form,
    Case When SD.Part_Product_Code = 'REGEN' Then 'REGEN' Else 'IMPL' End As Product_Code,
    SD.Part_Product_Family,
    Sum(Case When SD.InvoiceDate = Trunc(Sysdate) 
             Then SD.AllAmounts Else 0 End) As Today,
    Sum(Case When SD.InvoiceDate = Trunc(Sysdate) 
             Then SD.Cost * SD.Invoiced_Qty Else 0 End) As Today_Cost,
    Sum(Case When SD.InvoiceDate = Trunc(Sysdate) 
             Then SD.AllAmounts Else 0 End) -
    Sum(Case When SD.InvoiceDate = Trunc(Sysdate) 
             Then SD.Cost * SD.Invoiced_Qty Else 0 End) As Today_Margin$,
    (   (   Sum(Case When SD.InvoiceDate = Trunc(Sysdate) 
                     Then SD.Cost * SD.Invoiced_Qty Else 0 End) - 
            Sum(Case When SD.InvoiceDate = Trunc(Sysdate) 
                     Then SD.Cost * SD.Invoiced_Qty Else 0 End)    ) /
        Nullif(Sum(Case When SD.InvoiceDate = Trunc(Sysdate) 
                        Then SD.AllAmounts Else 0 End),0)    ) * 100 As  "TODAY_MARGIN%",
    Sum(Case When Extract(Month From SD.InvoiceDate) = Extract(Month From Sysdate) And
                  Extract(Year From SD.InvoiceDate) = Extract(Year From Sysdate)
             Then SD.AllAmounts Else 0 End) As Month_Actual,
    Sum(Case When Extract(Month From SD.InvoiceDate) = Extract(Month From Sysdate) And
                  Extract(Year From SD.InvoiceDate) = Extract(Year From Sysdate)
             Then SD.Cost * SD.Invoiced_Qty Else 0 End) As Month_Cost,
    Sum(Case When Extract(Month From SD.InvoiceDate) = Extract(Month From Sysdate) And
                  Extract(Year From SD.InvoiceDate) = Extract(Year From Sysdate)
             Then SD.AllAmounts Else 0 End) - 
    Sum(Case When Extract(Month From SD.InvoiceDate) = Extract(Month From Sysdate) And
              Extract(Year From SD.InvoiceDate) = Extract(Year From Sysdate)
         Then SD.Cost * SD.Invoiced_Qty Else 0 End) As Month_Margin$,
    (   (   Sum(Case When Extract(Month From SD.InvoiceDate) = Extract(Month From Sysdate) And
                          Extract(Year From SD.InvoiceDate) = Extract(Year From Sysdate)
                     Then SD.AllAmounts Else 0 End) - 
            Sum(Case When Extract(Month From SD.InvoiceDate) = Extract(Month From Sysdate) And
                      Extract(Year From SD.InvoiceDate) = Extract(Year From Sysdate)
                 Then SD.Cost * SD.Invoiced_Qty Else 0 End) ) / 
        Nullif(Sum(Case When Extract(Month From SD.InvoiceDate) = Extract(Month From Sysdate) And
                             Extract(Year From SD.InvoiceDate) = Extract(Year From Sysdate)
                        Then SD.AllAmounts Else 0 End),0)   ) * 100 As "MONTH_MARGIN%",
    Sum(Case When To_Char(SD.InvoiceDate,'Q') = To_Char(Sysdate,'Q') AND
                  Extract(Year From SD.InvoiceDate) = Extract(Year From Sysdate) 
             Then SD.AllAmounts Else 0 End) As Quarter_Actual,
    Sum(Case When To_Char(SD.InvoiceDate,'Q') = To_Char(Sysdate,'Q') And
                  Extract(Year From SD.InvoiceDate) = Extract(Year From Sysdate)
             Then SD.Cost * SD.Invoiced_Qty Else 0 End) As Quarter_Cost,
    Sum(Case When To_Char(SD.InvoiceDate,'Q') = To_Char(Sysdate,'Q') And
                  Extract(Year From SD.InvoiceDate) = Extract(Year From Sysdate) 
             Then SD.AllAmounts Else 0 End) - 
    Sum(Case When To_Char(SD.InvoiceDate,'Q') = To_Char(Sysdate,'Q') And
                  Extract(Year From SD.InvoiceDate) = Extract(Year From Sysdate)
             Then SD.Cost * SD.Invoiced_Qty Else 0 End) As Quarter_Margin$,
    (   (   Sum(Case When To_Char(SD.InvoiceDate,'Q') = To_Char(Sysdate,'Q') And
                          Extract(Year From SD.InvoiceDate) = Extract(Year From Sysdate) 
                     Then SD.AllAmounts Else 0 End) - 
            Sum(Case When To_Char(SD.InvoiceDate,'Q') = To_Char(Sysdate,'Q') And
                          Extract(Year From SD.InvoiceDate) = Extract(Year From Sysdate)
                     Then SD.Cost * SD.Invoiced_Qty Else 0 End) ) /
        Nullif(Sum(Case When To_Char(SD.InvoiceDate,'Q') = To_Char(Sysdate,'Q') And
                             Extract(Year From SD.InvoiceDate) = Extract(Year From Sysdate) 
                        Then SD.AllAmounts Else 0 End),0)   ) * 100 As "QUARTER_MARGIN%",
    Sum(Case When Extract(Year From SD.InvoiceDate) = Extract(Year From Sysdate) 
             Then SD.AllAmounts Else 0 End) As Year_Actual,
    Sum(Case When Extract(Year From SD.InvoiceDate) = Extract(Year From Sysdate)
             Then SD.Cost * SD.Invoiced_Qty Else 0 End) As Year_Cost,
    Sum(Case When Extract(Year From SD.InvoiceDate) = Extract(Year From Sysdate) 
             Then SD.AllAmounts Else 0 End) -
    Sum(Case When Extract(Year From SD.InvoiceDate) = Extract(Year From Sysdate) 
             Then SD.Cost * SD.Invoiced_Qty Else 0 End) As Year_Margin$,
    (   (   Sum(Case When Extract(Year From SD.InvoiceDate) = Extract(Year From Sysdate) 
                     Then SD.Cost * SD.Invoiced_Qty Else 0 End) - 
            Sum(Case When Extract(Year From SD.InvoiceDate) = Extract(Year From Sysdate) 
                     Then SD.Cost * SD.Invoiced_Qty Else 0 End)    ) /
        Nullif(Sum(Case When Extract(Year From SD.InvoiceDate) = Extract(Year From Sysdate)
                        Then SD.AllAmounts Else 0 End),0)    ) * 100 As  "YEAR_MARGIN%"    
From
    KD_Sales_Data_Request SD
Where
    SD.InvoiceDate >= Add_Months(Trunc(SYSDATE),-24) And
    SD.Part_Product_Family IS Not Null And
    SD.Part_Product_Family Not In (' ','Freight')
Group By
    SD.Corporate_Form,
    Case When SD.Part_Product_Code = 'REGEN' Then 'REGEN' Else 'IMPL' End,
    SD.Part_Product_Family
Having
    Sum(SD.AllAmounts) != 0 
Order By
    SD.Corporate_Form,
    Case When SD.Part_Product_Code = 'REGEN' Then 'REGEN' Else 'IMPL' End,
    SD.Part_Product_Family