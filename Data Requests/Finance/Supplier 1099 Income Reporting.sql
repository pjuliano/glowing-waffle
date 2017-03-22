Select
  A.*
From
  Supplier_Info A,
  Identity_Invoice_Info B
Where
  A.Supplier_Id = B.Identity And
  B.Report_And_Withhold_DB = 'REPORT_INCOME'