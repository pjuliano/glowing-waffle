Select
  A.Catalog_No,
  A.Catalog_Desc,
  Sum(A.Invoiced_Qty) As US_Units,
  Sum(Case
        When A.Delivstate = 'NY'
        Then A.Invoiced_Qty
        Else 0
      End) As NY_Units
From
  KD_Sales_Data_Request A
Where
  Extract(Year From A.Invoicedate) = 2016 And
  A.Delivcountry = 'UNITED STATES' And
  A.Catalog_No In ( '10.110.1050',
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
                    '10.401.1520',
                    '10.401.2030',
                    '10.401.3040',
                    '10.405.1520',
                    '10.405.2030',
                    '10.405.3040',
                    '10.501.1020',
                    '10.501.1030',
                    '10.501.2040',
                    '10.505.1020',
                    '10.505.1030',
                    '10.505.2040',
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
                    '10.630.1075',
                    'BT-0401G50',
                    'BT-0401GS50',
                    'BT-0802G05',
                    'BT-1001PU01DE',
                    'BT-1002PU50DE',
                    'BT-1301G501',
                    'BT-1301G550',
                    'BT-1301GS550',
                    'BT-1302G250',
                    'BT-9901G01',
                    'CS0418',
                    'CS0518',
                    'CS051819',
                    'CS0618PERIO',
                    'CS0618PREM',
                    'CS0618RC',
                    'GBR2530',
                    'NB-1-0210-025',
                    'NB-1-0210-050',
                    'NB-1-0210-100',
                    'NB-1-0210-200',
                    'NB-1-1020-025',
                    'NB-1-1020-050',
                    'NB-1-1020-100',
                    'NB-1-1020-200',
                    'NB-L1-0210-025',
                    'NB-L1-0210-050',
                    'NB-L1-1020-025',
                    'NB-L1-1020-050',
                    'NB-S1-0210-025',
                    'NB-S1-0210-050',
                    'NB-S1-0210-100',
                    'NB-S1-0210-200',
                    'NB-S1-1020-025',
                    'NB-S1-1020-050',
                    'NB-S1-1020-100',
                    'NB-S1-1020-200',
                    'RTM1520',
                    'RTM2030',
                    'RTM3040',
                    'TI150ANL-2',
                    'TI150AS-2',
                    'TI150BL-2',
                    'TI150PL-2',
                    'TI150PS-2',
                    'TI150PST-2',
                    'TI250ANL-2',
                    'TI250AS-2',
                    'TI250BL-2',
                    'TI250PL-2',
                    'TI250PLT-2',
                    'TI250PS-2',
                    'TI250PST-2',
                    'TI250XL-2',
                    'TXT1224',
                    'TXT2530')
Group By
  A.Catalog_No,
  A.Catalog_Desc