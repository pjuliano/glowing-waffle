Select
    A.Invoice_Id,
    B.Header_Name,
    A.Salesman_Code,
    B.Header_Salesman,
    A.Region_Code,
    B.Header_Region,
    A.Customer_No,
    B.Header_Customer_No,
    A.Order_No,
    B.Header_Order_No,
    A.Currency,
    B.Header_Currency,
    A.Invoicedate,
    B.Header_Closedate,
    A.Item_Id,
    B.Detail_Line_No,
    A.Catalog_No,
    B.Detail_Product_Code,
    A.Part_Product_Family,
    B.Detail_Product_Family,
    A.Invoiced_Qty,
    B.Detail_Quantity,
    Case When A.Invoiced_Qty != 0 Then A.AllAmounts/A.Invoiced_Qty End As Calc_Unit_Price,
    B.Detail_Unit_Price,
    A.AllAmounts,
    B.Detail_Total_Price
From
    Kd_Sales_Data_Request A Left Join Kd_Sf_Header_Detail_Join B On
        A.Invoice_Id = B.Header_Name And
        A.Item_Id = B.Detail_Line_No And
        A.Order_No = B.Header_Order_No
Where
    A.Invoiceqtryr = 'QTR1/2018' And
    A.Charge_Type = 'Parts' And
    A.Corporate_Form = 'DOMDIR' And
   (A.Invoice_Id != B.Header_Name Or
    A.Salesman_Code != B.Header_Salesman Or
    A.Region_Code != B.Header_Region Or
    A.Customer_No != B.Header_Customer_No Or
    A.Order_No != B.Header_Order_No Or
    A.Currency != B.Header_Currency Or
    A.InvoiceDate != B.Header_Closedate Or
    A.Catalog_No != B.Detail_Product_Code Or 
    Upper(A.Part_Product_Family) != Upper(B.Detail_Product_Family) Or
    A.Invoiced_Qty != B.Detail_Quantity Or
    Case When A.Invoiced_Qty != 0 Then A.Allamounts/A.Invoiced_Qty End != B.Detail_Unit_Price Or
    A.AllAmounts != B.Detail_Total_Price)
Order By
    A.Invoicedate,
    A.Invoice_Id,
    A.Item_ID