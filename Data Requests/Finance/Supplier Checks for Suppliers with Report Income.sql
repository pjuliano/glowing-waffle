Select
  Identity_Invoice_Info_Api.Get_Vat_No(A.Company,A.Identity,A.Party_Type) As Tax_Id,
  A.*,
  Supplier_Info_Address_Api.Get_Address1(A.Identity,A.Address_Id) As Address1,
  Supplier_Info_Address_Api.Get_Address2(A.Identity,A.Address_Id) As Address2,
  Supplier_Info_Address_Api.Get_City(A.Identity,A.Address_Id) As City,
  Supplier_Info_Address_Api.Get_State(A.Identity,A.Address_Id) As State,
  Supplier_Info_Address_Api.Get_Zip_Code(A.Identity,A.Address_Id) As Zip_Code
From
  Check_Ledger_Item A
Where
  A.Payment_Doc_Type = 'Supplier Check' And
  A.Objstate In ('Cashed','Created','Printed') And
  Extract(Year From A.Voucher_Date) = Extract(Year From Sysdate) - 1 And
  Identity_Invoice_Info_Api.Get_Report_And_Withhold_DB(A.Company,A.Identity,A.Party_Type_Db) = 'REPORT_INCOME'