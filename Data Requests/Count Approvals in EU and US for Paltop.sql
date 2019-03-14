Select 
    Catalog_No,
    Sum(Case When Characteristic_Code = 'US' Then 1 Else 0 End),
    Sum(Case When Characteristic_Code != 'US' Then 1 Else 0 End)
From 
    Sales_Part_Characteristic 
Where 
    Contract = '100' and 
    (
        Characteristic_Code = 'US' Or 
        INDISCRETE_CHARACTERISTIC_Api.Get_Description(Characteristic_Code) Like '%EU%'
    )
Group By
    Catalog_No