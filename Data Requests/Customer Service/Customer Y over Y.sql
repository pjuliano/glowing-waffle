Select
    Person_Info_Api.Get_Name(SD.Salesman_Code) As Current_Salesman,
    SD.Customer_No,
    SD.Customer_Name,
    Sum(Case When Extract(Year From INvoiceDate) = Extract(Year From Sysdate)-3 Then SD.AllAmounts Else 0 End) As "2016_ALL",
    Sum(Case When Extract(Year From InvoiceDate) = Extract(Year From Sysdate)-2 Then SD.AllAmounts Else 0 End) As "2017_ALL",
    Sum(Case When Extract(Year From InvoiceDate) = Extract(Year From Sysdate)-1 Then SD.AllAmounts Else 0 End) As "2018_ALL",
    Sum(Case When Extract(Year From INvoiceDate) = Extract(Year From Sysdate)-3 And SD.Part_Product_Code = 'REGEN' Then SD.AllAmounts Else 0 End) As "2016_BIO",
    Sum(Case When Extract(Year From InvoiceDate) = Extract(Year From Sysdate)-2 And SD.Part_Product_Code = 'REGEN' Then SD.AllAmounts Else 0 End) As "2017_BIO",
    Sum(Case When Extract(Year From InvoiceDate) = Extract(Year From Sysdate)-1 And SD.Part_Product_Code = 'REGEN' Then SD.AllAmounts Else 0 End) As "2018_BIO",
    Sum(Case When Extract(Year From INvoiceDate) = Extract(Year From Sysdate)-3 And SD.Part_Product_Code != 'REGEN' Then SD.AllAmounts Else 0 End) As "2016_IMP_OTHER",
    Sum(Case When Extract(Year From InvoiceDate) = Extract(Year From Sysdate)-2 And SD.Part_Product_Code != 'REGEN' Then SD.AllAmounts Else 0 End) As "2017_IMP_OTHER",
    Sum(Case When Extract(Year From InvoiceDate) = Extract(Year From Sysdate)-1 And SD.Part_Product_Code != 'REGEN' Then SD.AllAmounts Else 0 End) As "2018_IMP_OTHER"
From
    KD_Sales_Data_Request SD
Where
    SD.Charge_Type = 'Parts' And
    SD.Corporate_Form = 'DOMDIR' And
    SD.Catalog_No != '3DBC-22001091' And
    ((SD.Order_No Not Like 'W%' And
    SD.Order_No Not Like 'X%') Or
    SD.Order_No Is Null) And
    (SD.Market_Code != 'PREPOST' Or SD.Market_Code Is Null) And
    Sd.Region_Code = 'USEC' And
    SD.Invoice_ID != 'CR1001802096' --20180904 Invoice is stuck not posted and cannot be deleted. 
Group By
    Person_Info_Api.Get_Name(SD.Salesman_Code),
    SD.Customer_No,
    SD.Customer_Name