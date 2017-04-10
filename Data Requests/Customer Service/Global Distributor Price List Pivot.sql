Select
  *
From
   (Select
      A.Customer_No,
      B.Catalog_No As Part_No,
      Sales_Part_Api.Get_Catalog_Desc(A.Contract,B.Catalog_No) As Part_Desc,
      Inventory_Part_Api.Get_Part_Product_Family(A.Contract,B.Catalog_No) As Product_Family,
      Inventory_Part_Api.Get_Part_Product_Code(A.Contract,B.Catalog_No) As Product_Code,
      Sales_Part_Api.Get_List_Price(A.Contract,B.Catalog_No) As List_Price,
      Inventory_Part_Unit_Cost_Api.Get_Inventory_Value_By_Method(A.Contract,B.Catalog_No,'*',Null,Null) As Kd_Cost,
      Sales_Part_Api.Get_List_Price(A.Contract,B.Catalog_No) As KD_List,
      B.Deal_Price
    From
      Customer_Agreement A,
      Agreement_Sales_Part_Deal B
    Where
      A.Agreement_Id = B.Agreement_Id And
      A.Customer_No In ('B1391',
                        'B1351',
                        'B2054',
                        'B2668',
                        'B2911',
                        'B2937',
                        'B2864',
                        'B2140',
                        'B3155',
                        'B2848',
                        'B2189',
                        'B2944',
                        'B1419',
                        'B3169',
                        'B3324',
                        'I44776',
                        'B3584',
                        'B2492',
                        'B1420',
                        'A19435'))
Pivot
  (Max(Deal_Price) As Deal_Price,
   Max(100-Round((Deal_Price/Nullif(List_Price,0))*100,2)) As Discount   For Customer_No In ('B1391' As "B1391",
                                                                                             'B1351' As "B1351",
                                                                                             'B2054' As "B2054",
                                                                                             'B2668' As "B2668",
                                                                                             'B2911' As "B2911",
                                                                                             'B2937' As "B2937",
                                                                                             'B2864' As "B2864",
                                                                                             'B2140' As "B2140",
                                                                                             'B3155' As "B3155",
                                                                                             'B2848' As "B2848",
                                                                                             'B2189' As "B2189",
                                                                                             'B2944' As "B2944",
                                                                                             'B1419' As "B1419",
                                                                                             'B3169' As "B3169",
                                                                                             'B3324' As "B3324",
                                                                                             'I44776' As "I44776",
                                                                                             'B3584' As "B3584",
                                                                                             'B2492' As "B2492",
                                                                                             'B1420' As "B1420",
                                                                                             'A19435' As "A19435"))