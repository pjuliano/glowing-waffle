Create Or Replace View Kd_WWSS_NADirect As
Select
    'NADirect' As Segment,
    Case When A.Region_Code = 'USEC' Then 'East Coast'
           When A.Region_Code = 'USWC' Then 'West Coast'
           When A.Region_Code = 'USSC' Then 'South Central'
           When A.Region_Code = 'USNC' Then 'North Central'
           When A.Region_Code = 'UNASSIGNED' Then 'House' --Also includes Moti's sales, but I'm not arguing with Wayne anymore.
           Else A.Region_Code
    End As Region_Code,
    Sum(Case When A.Invoicedate = Trunc(Sysdate)
           Then A.Allamounts
           Else 0
      End) As Today_Sales,
    Sum(Case When Extract(Month From A.Invoicedate) = Extract(Month From Sysdate) And
                Extract(Year From A.Invoicedate) = Extract(Year From Sysdate)
           Then A.Allamounts
           Else 0
      End) MTD_Sales,
    E.MTD_Quota MTD_Goal,
    Sum(Case When Extract(Month From A.Invoicedate) = Extract(Month From Sysdate) And
                Extract(Year From A.Invoicedate) = Extract(Year From Sysdate)
           Then A.Allamounts
           Else 0
      End) - E.MTD_Quota MTD_Variance,
    Sum(Case When Decode(Extract(Month From Sysdate),1,'QTR1',2,'QTR1',3,'QTR1',4,'QTR2',5,'QTR2',6,'QTR2',7,'QTR3',8,'QTR3',9,'QTR3',10,'QTR4',11,'QTR4',12,'QTR4') = 
                Decode(Extract(Month From A.Invoicedate),1,'QTR1',2,'QTR1',3,'QTR1',4,'QTR2',5,'QTR2',6,'QTR2',7,'QTR3',8,'QTR3',9,'QTR3',10,'QTR4',11,'QTR4',12,'QTR4') And
                Extract(Year From A.Invoicedate) = Extract(Year From Sysdate)
           Then A.Allamounts
           Else 0
      End) QTD_Sales,
    F.QTD_Quota QTD_Goal,
    Sum(Case When Decode(Extract(Month From Sysdate),1,'QTR1',2,'QTR1',3,'QTR1',4,'QTR2',5,'QTR2',6,'QTR2',7,'QTR3',8,'QTR3',9,'QTR3',10,'QTR4',11,'QTR4',12,'QTR4') = 
                Decode(Extract(Month From A.Invoicedate),1,'QTR1',2,'QTR1',3,'QTR1',4,'QTR2',5,'QTR2',6,'QTR2',7,'QTR3',8,'QTR3',9,'QTR3',10,'QTR4',11,'QTR4',12,'QTR4') And
                Extract(Year From A.Invoicedate) = Extract(Year From Sysdate)
           Then A.Allamounts
           Else 0
      End) - F.QTD_Quota QTD_Variance,   
    Sum(Case When Extract(Year From A.InvoiceDate) = Extract(Year From Sysdate)
           Then A.Allamounts
           Else 0
      End) YTD_Sales,
    G.YTD_Quota, 
    Sum(Case When Extract(Year From A.InvoiceDate) = Extract(Year From Sysdate)
             Then A.Allamounts
             Else 0
        End) - G.YTD_Quota As YTD_Variance
From
    Kd_Sales_Data_Request A,
    Kd_Monthly_Calendar C,
    KD_NA_Month_Quota E,
    KD_NA_Qtr_Quota F, 
    KD_NA_Year_Quota G
Where
    A.Region_Code = G.Region And
    A.Region_Code = F.Region And
    A.Region_Code = E.Region And
    C.Month = Extract(Month From Sysdate) And
    A.Charge_Type = 'Parts' And
    Extract(Year From A.Invoicedate) >= Extract(Year From Sysdate) And
    A.Corporate_Form = 'DOMDIR' And
    A.Catalog_No != '3DBC-22001091' And
    ((A.Order_No Not Like 'W%' And
    A.Order_No Not Like 'X%') Or
    A.Order_No Is Null) And
    (A.Market_Code != 'PREPOST' Or A.Market_Code Is Null) And
    A.Invoice_ID != 'CR1001802096' AND --20180904 Invoice is stuck not posted and cannot be deleted.
    A.Order_No != 'C512921' --Kevin Stack's order/return that spanned years.

Group By
  'NADirect',
  A.Region_Code,
  E.MTD_Quota,
  F.QTD_Quota,
  G.YTD_Quota