Select
    Cust_Ord_Customer_Api.Get_Salesman_Code(A.Customer_Id) As Salesman_Code,
    Person_Info_Api.get_Name(Cust_Ord_Customer_Api.Get_Salesman_Code(A.Customer_Id)) As Salesman_Name,
    A.Customer_Id,
    Customer_Info_Api.Get_Name(A.Customer_Id) As Customer_Name,
    B.Order_No,
    A.Charge_Type,
    A.Charge_Amount,
    B.Catalog_No,
    B.Allamounts,
    A.Charge_Amount - B.AllAmounts As Charge_Delta
    --Sum(Case When Extract(Year From B.Invoicedate) = 2017 Then B.Allamounts Else 0 End) As "2017_Sales",
    --Sum(Case When Extract(Year From B.InvoiceDate) = 2018 Then B.AllAmounts Else 0 End) As "2018_Sales"
From
    Customer_Charge_Ent A,
    KD_Sales_Data_Request B
Where
    A.Customer_Id = B.Customer_No And
    B.Charge_Type = 'Freight' And
    Extract(Year From B.Invoicedate) > 2016 And
    --B.Corporate_Form = 'DOMDIR' And
    A.Charge_Type != B.Catalog_No
--Group By
--    Cust_Ord_Customer_Api.Get_Salesman_Code(A.Customer_Id),
--    Person_Info_Api.get_Name(Cust_Ord_Customer_Api.Get_Salesman_Code(A.Customer_Id)),
--    A.Customer_Id,
--    Customer_Info_Api.Get_Name(A.Customer_Id),
--    B.Order_No,
--    A.Charge_Type,
--    A.Charge_Cost,
--    B.Catalog_No,
--    B.AllAmounts