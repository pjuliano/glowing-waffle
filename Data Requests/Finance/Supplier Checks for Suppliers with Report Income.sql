--Include Full Address!
Select
  Identity_Invoice_Info_Api.Get_Vat_No(A.Company,A.Identity,A.Party_Type) As Tax_Id,
  A.*
From
  Check_Ledger_Item A
Where
  A.Payment_Doc_Type = 'Supplier Check' And
  A.Objstate In ('Cashed','Created','Printed') And
  Extract(Year From A.Voucher_Date) = Extract(Year From Sysdate) - 1 And
  Identity_Invoice_Info_Api.Get_Report_And_Withhold_DB(A.Company,A.Identity,A.Party_Type_Db) = 'REPORT_INCOME'