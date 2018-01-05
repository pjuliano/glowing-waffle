Create or Replace View KD_VoucherDate_Vs_InvoiceDate As
Select
  Cust_Ord_Customer_Api.Get_Salesman_Code(A.Identity) As Rep_Id,
  Person_Info_Api.Get_Name(Cust_Ord_Customer_Api.Get_Salesman_Code(A.Identity)) As Rep_Name,
  A.Identity As Customer_No,
  A.Name As Customer_Name,
  B.Ledger_Item_Series_Id,
  B.Ledger_Item_Id,
  C.Invoice_Date,
  A.Voucher_Date,
  A.Voucher_Date - C.Invoice_Date As Days,
  C.Pay_Term_Description
From
  Check_Ledger_Item A Left Join Ledger_Transaction B
    On A.Payment_Id = B.Payment_Id And
       A.Company = B.Company And
       A.Party_Type_Db = B.Party_Type_Db
                      Left Join Customer_Order_Inv_Head_Uiv C
    On B.Ledger_Item_Series_Id = C.Series_Id And
       B.Ledger_Item_Id = C.Invoice_NO
Where
  A.Company = '100' And
  A.Ledger_Item_Series_Id = 'CUCHECK' And 
  B.Ledger_Item_Series_Id In ('CD','CI','II','CR') And
  (A.Party_Type_Db = 'CUSTOMER' Or A.Objstate != 'Cancelled');