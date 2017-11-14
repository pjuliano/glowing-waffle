Create Or Replace View KD_Total_Invoice_Taxes As
Select
  Series_Id || Invoice_No As Invoice_Id,
  Item_ID,
  Sum(Tax_Amount) * -1 As Total_Tax
From
  Tax_Ledger_Item_Qry
Group By
  Series_Id || Invoice_No,
  Item_Id