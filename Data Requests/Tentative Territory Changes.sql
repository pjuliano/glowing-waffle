With TotalSales As (Select Customer_No, Sum(Case When Part_Product_Code = 'REGEN' Then a.AllAmounts Else 0 End) as RegenTotal, Sum(Case When Part_Product_Code != 'REGEN' Then A.AllAmounts Else 0 End) as ImplTotal From KD_Sales_Data_Request A Where Extract(YEar From A.InvoiceDate) = 2018 and A.Charge_Type = 'Parts' And
  A.Corporate_Form = 'DOMDIR' And
  A.Catalog_No != '3DBC-22001091' And
  ((A.Order_No Not Like 'W%' And
    A.Order_No Not Like 'X%') Or
    A.Order_No Is Null) And
  (A.Market_Code != 'PREPOST' Or A.Market_Code Is Null) And
  A.Invoice_ID != 'CR1001802096' Group By Customer_No)
Select
    Cust_Ord_Customer_Api.Get_Salesman_Code(A.Customer_ID) as Current_Rep_ID,
    Person_Info_Api.Get_Name(Cust_Ord_Customer_Api.Get_Salesman_Code(A.Customer_ID)) As Current_Rep,
    Cust_Ord_Customer_Address_Api.Get_Region_Code(Customer_ID,Ifsapp.Customer_Info_Address_Api.Get_Default_Address(A.Customer_Id,'Delivery')) As Current_Region,
    A.Customer_Id,
    A.Name,
    A.Association_No,
    Substr(Customer_Info_Address_Api.Get_Zip_Code(A.Customer_Id,Ifsapp.Customer_Info_Address_Api.Get_Default_Address(A.Customer_Id,'Delivery')),1,5) As Delivery_Zip_Code,
    B.Rep_ID As New_Rep,
    Person_Info_Api.Get_Name(B.Rep_ID) As New_Rep_Name,
    Nvl(C.RegenTotal,0) As RegenTotal2018,
    Nvl(C.ImplTotal,0) As ImplTotal2018
From
    Customer_Info A Left Join TotalSales C On A.Customer_ID = C.Customer_No 
                    Left Join KD_Zip_Data_Temp B On B.Zip_Code = SubStr(Customer_Info_Address_Api.Get_Zip_Code(A.Customer_Id,Ifsapp.Customer_Info_Address_Api.Get_Default_Address(A.Customer_Id,'Delivery')),1,5)
Where
    A.Corporate_Form = 'DOMDIR' And
    Customer_Info_Address_Api.Get_Country(A.Customer_Id,Ifsapp.Customer_Info_Address_Api.Get_Default_Address(A.Customer_Id,'Delivery')) = 'UNITED STATES' 