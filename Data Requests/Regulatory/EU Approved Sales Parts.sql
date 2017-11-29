Select
  A.Catalog_No,
  Sales_Part_Api.Get_Catalog_Desc(A.Contract,A.Catalog_No) As Catalog_Desc
From
  Sales_Part_Characteristic A
Where
  A.Contract = '100' And
  Sales_Part_Api.Get_Activeind(A.Contract,A.Catalog_No) = 'Active part' And
  A.Characteristic_Code In ('BE','BG','CZ','DK','DE','EE','IE','EL','ES','FR','HR','IT','CY','LV','LT','LU','HU','MT','NL','AT','PL','PT','RO','SI','SK','FI','SE','UK') 
Group By
  A.Catalog_No,
  Sales_Part_Api.Get_Catalog_Desc(A.Contract,A.Catalog_No)