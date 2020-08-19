Create or Replace View KD_Boomi_Products As
Select 
  A.Contract,
  A.Catalog_No,
  A.Catalog_Desc,
  A.Catalog_Group,
  A.Sales_Price_Group_Id,
  A.Sales_Unit_Meas,
  A.Activeind,
  Decode(A.Activeind_Db,'Y','true','N','false') as Activeind_Db,
  A.Customs_Stat_No,
  A.Date_Entered,
  A.List_Price,
  A.Price_Conv_Factor,
  A.Price_Unit_Meas,
  B.Second_Commodity,
  B.Part_Product_Family,
  B.Part_Product_Code,
  B.Type_Designation,
  C.Inventory_Value
From 
  Sales_Part A Left Join Inventory_Part B On 
    A.Part_No = B.Part_No And 
      A.Contract=B.Contract And 
      B.Accounting_Group In ('FG','LIT','DEMO')
               Left Join Inventory_Part_Unit_Cost_Sum C On
      A.Contract = C.Contract And
      A.Part_No = C.Part_No
Where
  A.Contract = '100'

UNION ALL

SELECT
                contract,
                charge_type,
                charge_type_desc,
                'Financing',
                'Financing',
                sales_unit_meas,
                'Active part',
                'true',
                NULL,
                NULL,
                0,
                1,
                sales_unit_meas,
                'Financing',
                'Financing',
                'Financing',
                'Financing',
                0            
FROM
                sales_charge_type
WHERE
                contract = '100'
                    AND charge_type IN ('FIN12','FIN18','FIN24')
ORDER BY 
                2