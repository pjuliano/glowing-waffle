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
    D.ProductCode as Product2_Product_Code,
    A.Part_Product_Family,
    B.Detail_Product_Family,
    A.Invoiced_Qty,
    B.Detail_Quantity,
    Case When A.Invoiced_Qty != 0 Then A.AllAmounts/A.Invoiced_Qty End As Calc_Unit_Price,
    B.Detail_Unit_Price,
    A.Allamounts,
    B.Detail_Total_Price,
    B.Header_Id,
    B.Header_Owner_Id,
    B.Header_Account_Id,
    B.Header_Account_Owner_Id,
    B.Detail_Id,
    B.Detail_Product2_Id,
    C.Id As Ifs_Salesman_Code_Id,
    D.Id As Product2_Id
From
    Kd_Sales_Data_Request A Left Join Kd_Sf_Header_Detail_Join B On
        A.Invoice_Id = B.Header_Name And
        A.Item_Id = B.Detail_Line_No And
        A.Order_No = B.Header_Order_No 
                            Left Join Kd_Sf_Users C On 
        A.Salesman_Code = C.District__C
                            Left Join Kd_Sf_Product2 D On 
        A.Catalog_No = D.Productcode
    
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
    A.Allamounts != B.Detail_Total_Price Or
    B.Header_Owner_Id != C.Id Or 
    A.Catalog_No != D.Productcode Or
    B.Detail_Product_Code != D.Productcode)
Order By
    A.Invoicedate,
    A.Invoice_Id,
    A.Item_Id
