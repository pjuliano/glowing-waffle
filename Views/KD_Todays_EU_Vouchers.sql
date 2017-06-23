Create or Replace View KD_TODAYS_EU_VOUCHERS As
Select
  A.Company,
  A.Voucher_Date,
  A.Accounting_Year,
  A.Accounting_Period,
  A.Userid,
  A.Entered_By_User_Group,
  A.Account,
  A.Account_Desc,
  A.Debet_Amount As Debit_Amount,
  A.Credit_Amount,
  A.Amount,
  A.Text
From
  Gen_Led_Voucher_Row_Union_Qry A
Where
  A.Company != '100' And
  Extract(Month From A.Voucher_Date) = Extract(Month From Sysdate) And
  Extract(Year From A.Voucher_Date) = Extract(Year From Sysdate)
Order By
  A.Voucher_Date,
  A.Company;