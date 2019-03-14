Create Or Replace View KD_WWSS_Freight As
Select
  'Freight' As Segment,
  'Freight' As Region_Code,
  Sum(Case When A.Invoicedate = Trunc(Sysdate)
           Then A.Allamounts
           Else 0
      End) As Today_Sales,
  Sum(Case When Extract(Month From A.Invoicedate) = Extract(Month From Sysdate) And
                Extract(Year From A.Invoicedate) = Extract(Year From Sysdate)
           Then A.Allamounts
           Else 0
      End) As Month_Sales,
  E.MTD_Quota MTD_Goal,
  Sum(Case When Extract(Month From A.Invoicedate) = Extract(Month From Sysdate) And
                Extract(Year From A.Invoicedate) = Extract(Year From Sysdate)
           Then A.Allamounts
           Else 0
      End) -
  E.MTD_Quota MTD_Variance,
  Sum(Case When Decode(Extract(Month From Sysdate),1,'QTR1',2,'QTR1',3,'QTR1',4,'QTR2',5,'QTR2',6,'QTR2',7,'QTR3',8,'QTR3',9,'QTR3',10,'QTR4',11,'QTR4',12,'QTR4') = 
                Decode(Extract(Month From A.Invoicedate),1,'QTR1',2,'QTR1',3,'QTR1',4,'QTR2',5,'QTR2',6,'QTR2',7,'QTR3',8,'QTR3',9,'QTR3',10,'QTR4',11,'QTR4',12,'QTR4') And
                Extract(Year From A.Invoicedate) = Extract(Year From Sysdate)
           Then A.Allamounts
           Else 0
      End) As Qtr_Sales,
  F.QTD_Quota QTD_Goal,
  Sum(Case When Decode(Extract(Month From Sysdate),1,'QTR1',2,'QTR1',3,'QTR1',4,'QTR2',5,'QTR2',6,'QTR2',7,'QTR3',8,'QTR3',9,'QTR3',10,'QTR4',11,'QTR4',12,'QTR4') = 
                Decode(Extract(Month From A.Invoicedate),1,'QTR1',2,'QTR1',3,'QTR1',4,'QTR2',5,'QTR2',6,'QTR2',7,'QTR3',8,'QTR3',9,'QTR3',10,'QTR4',11,'QTR4',12,'QTR4') And
                Extract(Year From A.Invoicedate) = Extract(Year From Sysdate)
           Then A.Allamounts
           Else 0
      End) -
  F.QTD_Quota QTD_Variance,
  Sum(Case When Extract(Year From A.InvoiceDate) = Extract(Year From Sysdate)
           Then A.Allamounts
           Else 0
      End) As YTD,
  G.YTD_Quota YTD_Goal,
  Sum(Case When Extract(Year From A.InvoiceDate) = Extract(Year From Sysdate)
           Then A.Allamounts
           Else 0
      End) -
  G.YTD_Quota YTD_Variance
From
  Kd_Sales_Data_Request A,
  Kd_Nadis_Month_Quota E,
  KD_Nadis_Qtr_Quota F,
  KD_Nadis_Year_Quota G
Where
  G.Region = 'Freight' And
  G.Region = E.Region And
  E.Region = F.Region And
  Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) And
  A.Corporate_Form = 'Freight' And
  Region_Code IN ('USDI','USSC','USEC','USNC','USWC','UNASSIGNED','CANA')
Group By
  'Freight',
  'Freight',
  E.MTD_Quota,
  F.QTD_Quota,
  G.YTD_Quota