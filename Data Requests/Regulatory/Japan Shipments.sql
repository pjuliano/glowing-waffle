Select 
    *
From 
    Inventory_Transaction_Hist2
Where
    Part_No In ('S2432-40-1K',
                'S2432-55-1K',
                'S2432-70-1K',
                'S2501-40-1K',
                'S2501-55-1K',
                'S2501-70-1K',
                '42001K',
                '42002K',
                'S2435K',
                'S2504K',
                'S2439K',
                'S2506K',
                '42021K',
                '42022K',
                '42023K',
                '42024K',
                '42025K',
                '42026K',
                'S2400K',
                '42004K',
                'S2401K',
                '42005K',
                'S2407-00K',
                'S2407-01K',
                '42011K',
                '42012K',
                'S2405-00K',
                'S2405-01K',
                '42007K',
                '42008K',
                '42017K',
                '42018K',
                '42019K',
                '42020K',
                'S2417-0K',
                'S2417-2K') And
    Date_Created >= To_Date('06/01/2015','MM/DD/YYYY') And
    --Transaction_Code = 'OESHIP' And
    Customer_Order_Address_Api.Get_Country_Code(Order_No) = 'JP'
Order By
    Part_No,
    Lot_Batch_No,
    Date_Applied