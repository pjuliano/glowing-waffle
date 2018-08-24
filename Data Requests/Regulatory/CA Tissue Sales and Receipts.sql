Select
    Part_No,
    Sales_Part_Api.Get_Catalog_Desc(Contract,Part_No) As Catalog_Desc,
    Sum(Case When Transaction_Code = 'ARRIVAL' Then Quantity Else 0 End) As QTY_Received,
    Sum(Case When Transaction_Code = 'OESHIP' Then Quantity Else 0 End) As QTY_Shipped
From
    Inventory_Transaction_Hist2
Where
    Part_No In ('401172',
                '401173',
                '401174',
                '401175',
                '401176',
                '401177',
                '401178',
                '401193',
                '401194',
                '10.110.1050',
                '10.110.1060',
                '10.110.1070',
                '10.120.1050',
                '10.120.1060',
                '10.120.1070',
                '10.210.1050',
                '10.210.1060',
                '10.210.1070',
                '10.220.1030',
                '10.220.1040',
                '10.220.1050',
                '10.310.1050',
                '10.310.1060',
                '10.310.1070',
                '10.310.1080',
                '10.610.1025',
                '10.610.1050',
                '10.610.1060',
                '10.610.1070',
                '10.620.1025',
                '10.620.1050',
                '10.620.1060',
                '10.620.1070',
                '10.630.1025',
                '10.630.1050',
                '10.630.1075') And
    Date_Applied Between To_Date('06/01/2017','MM/DD/YYYY') And To_Date('05/31/2018','MM/DD/YYYY')
Group By
    Part_No,
    Sales_Part_Api.Get_Catalog_Desc(Contract,Part_No)