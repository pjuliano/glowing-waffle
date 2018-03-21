Select
  A.Supplier_Id,
  A.Name,
  Supplier_Info_Address_Api.Get_Address1(A.Supplier_Id, Supplier_Info_Address_Api.Get_Default_Address(A.Supplier_Id,'Pay')) As Address1,
  Supplier_Info_Address_Api.Get_Address2(A.Supplier_Id, Supplier_Info_Address_Api.Get_Default_Address(A.Supplier_Id,'Pay')) As Address2,
  Supplier_Info_Address_Api.Get_City(A.Supplier_Id, Supplier_Info_Address_Api.Get_Default_Address(A.Supplier_Id,'Pay')) As City,
  Supplier_Info_Address_Api.Get_State(A.Supplier_Id, Supplier_Info_Address_Api.Get_Default_Address(A.Supplier_Id,'Pay')) As State,
  Supplier_Info_Address_Api.Get_Zip_Code(A.Supplier_Id, Supplier_Info_Address_Api.Get_Default_Address(A.Supplier_Id,'Pay')) As Zip_Code,
  Supplier_Info_Address_Api.Get_Country(A.Supplier_Id, Supplier_Info_Address_Api.Get_Default_Address(A.Supplier_Id,'Pay')) As Country
From
  Supplier_Info A