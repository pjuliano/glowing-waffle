With IFS_Data As (
Select
  A.Invoice_Id IFS_INVOICE_ID,
  Sum(A.AllAmounts) IFS_TOTAL
From
  Kd_Sales_Data_Request A
Where
  Site = '100' And
  A.Charge_Type = 'Parts' And
  A.Salesman_Code Not In ('505','506','507','508') And
  A.Customer_No != 'B3730' And
  A.Corporate_Form != 'Freight' And
  A.Corporate_Form In ('DOMDIR','ASIA','DOMDIS') And
  A.Invoice_Id != '0' And
  A.InvoiceDate < To_Date('01/01/2018','MM/DD/YYYY')
Group By
  A.Invoice_Id)

Select
  A.Ifs_Invoice_Id,
  Round(A.Ifs_Total,2) Ifs_Total,
  B.Column3,
  Round(B.Column4,2) Column4,
  B.Column1
From
  Ifs_Data A Left Join Kd_Util B
    On A.IFS_Invoice_Id = B.Column3
Where
  B.Column3 Is Null Or
  Round(B.Column4,2) != Round(IFS_Total,2)
