Create or Replace View KD_TODAYS_US_VOUCHERS As
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
  A.Company = '100' And
  A.Voucher_Date = Trunc(Sysdate);