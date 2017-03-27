Select
  A.Company,
  A.Voucher_Type,
  A.Voucher_No,
  A.Account,
  A.Account_Desc,
  A.Amount,
  A.Code_B As Costcenter,
  A.Voucher_Date As Effectdate,
  A.Accounting_Period As Month,
  A.Accounting_Year As Year,
  Trunc(B.Date_Reg) As Entrydate,
  B.UserId,
  A.Trans_Code As Source,
  A.Currency_Code,
  A.Text,
  A.*
From
  Gen_Led_Voucher_Row_Union_Qry A, 
  Gen_Led_Voucher2 B
Where
  A.Voucher_No = B.Voucher_No And
  Trunc(A.Voucher_Date) = Trunc(B.Voucher_Date) And
  A.Voucher_Type = B.Voucher_Type And
  A.Company = B.Company And
  (Trunc(A.Voucher_Date) >= To_Date('11/01/2016','MM/DD/YYYY') And
   Trunc(A.Voucher_Date) <= To_Date('12/31/2016','MM/DD/YYYY')) And
  A.Company = '100'