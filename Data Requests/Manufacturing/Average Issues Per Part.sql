Select
  A.Part_No,
  A.Description,
  A.Accounting_Group,
  B.Planning_Method,
  A.Part_Product_Family,
  A.Part_Product_Code,
  Round(Sum(C.MTD_Issues) / 12,2) As Avg_Issues_12M
From
  Inventory_Part A Left Join Inventory_Part_Planning B
    On A.Contract = B.Contract And
       A.Part_No = B.Part_No
                   Left Join Inventory_Part_Period_Hist C
    On A.Contract = C.Contract And
       A.Part_No = C.Part_No
Where
  A.Part_Status = 'A' And
  C.Stat_Year_No || '-' || C.Stat_Period_No In ('2016-06','2016-07','2016-08','2016-09','2016-10','2016-11','2016-12','2017-01','2017-02','2017-03','2017-04','2017-05') And
  A.Contract = '100'
Group By
  A.Part_No,
  A.Description,
  A.Accounting_Group,
  B.Planning_Method,
  A.Part_Product_Family,
  A.Part_Product_Code