Create View KD_WWSS_Families As
Select
  A.Corporate_Form,
  A.Part_Product_Family,
  Sum(Case When A.Invoicedate = Trunc(Sysdate) 
           Then A.Allamounts
           Else 0
      End) As Today_Sales,
  Sum(Case When Extract(Month From Invoicedate) = Extract(Month From Sysdate) And
                Extract(Year From Invoicedate) = Extract(Year From Sysdate)
           Then A.Allamounts
           Else 0
      End) As Month_Sales,
  Round(Decode(Extract(Month From Sysdate),1,B.Jan,2,B.Feb,3,B.Mar,4,B.Apr,5,B.May,6,B.Jun,7,B.Jul,8,B.Aug,9,B.Sep,10,B.Oct,11,B.Nov,12,B.Dec),2) As Month_Quota,
  Round(Sum(Case When Extract(Month From Invoicedate) = Extract(Month From Sysdate) And
                      Extract(Year From Invoicedate) = Extract(Year From Sysdate)
                 Then A.Allamounts
                 Else 0
            End) / NullIf(Decode(Extract(Month From Sysdate),1,B.Jan,2,B.Feb,3,B.Mar,4,B.Apr,5,B.May,6,B.Jun,7,B.Jul,8,B.Aug,9,B.Sep,10,B.Oct,11,B.Nov,12,B.Dec),0),4) * 100 As Month_Pct_Plan,
  Round(Sum(Case When Extract(Month From Invoicedate) = Extract(Month From Sysdate) And
                      Extract(Year From Invoicedate) = Extract(Year From Sysdate)
                 Then A.Allamounts
                 Else 0
            End) / NullIf(C.Elapsed_Work_Days,0),2) As Month_Daily_Avg,
  Round((Decode(Extract(Month From Sysdate),1,B.Jan,2,B.Feb,3,B.Mar,4,B.Apr,5,B.May,6,B.Jun,7,B.Jul,8,B.Aug,9,B.Sep,10,B.Oct,11,B.Nov,12,B.Dec) - 
         Sum(Case When Extract(Month From Invoicedate) = Extract(Month From Sysdate) And
                       Extract(Year From Invoicedate) = Extract(Year From Sysdate)
                  Then A.Allamounts
                  Else 0
             End)) / NullIf((C.Total_Sales_Days - C.Elapsed_Work_Days),0),2) As Month_Daily_Required,
  Sum(Case When Decode(Extract(Month From Sysdate),1,'QTR1',2,'QTR1',3,'QTR1',4,'QTR2',5,'QTR2',6,'QTR2',7,'QTR3',8,'QTR3',9,'QTR3',10,'QTR4',11,'QTR4',12,'QTR4') = 
                Decode(Extract(Month From A.Invoicedate),1,'QTR1',2,'QTR1',3,'QTR1',4,'QTR2',5,'QTR2',6,'QTR2',7,'QTR3',8,'QTR3',9,'QTR3',10,'QTR4',11,'QTR4',12,'QTR4') And
                Extract(Year From A.InvoiceDate) = Extract(Year From Sysdate)
           Then A.Allamounts
           Else 0
      End) As Qtr_Sales,
  Round(Decode(Extract(Month From Sysdate),1,B.Q1,2,B.Q1,3,B.Q1,4,B.Q2,5,B.Q2,6,B.Q2,7,B.Q3,8,B.Q3,9,B.Q3,10,B.Q4,11,B.Q4,12,B.Q4),2) As Qtr_Quota,
  Round((Sum(Case When Decode(Extract(Month From Sysdate),1,'QTR1',2,'QTR1',3,'QTR1',4,'QTR2',5,'QTR2',6,'QTR2',7,'QTR3',8,'QTR3',9,'QTR3',10,'QTR4',11,'QTR4',12,'QTR4') = 
                       Decode(Extract(Month From A.Invoicedate),1,'QTR1',2,'QTR1',3,'QTR1',4,'QTR2',5,'QTR2',6,'QTR2',7,'QTR3',8,'QTR3',9,'QTR3',10,'QTR4',11,'QTR4',12,'QTR4') And
                       Extract(Year From A.Invoicedate) = Extract(Year From Sysdate)
                  Then A.Allamounts
                 Else 0
        End) / Nullif(Decode(Extract(Month From Sysdate),1,B.Q1,2,B.Q1,3,B.Q1,4,B.Q2,5,B.Q2,6,B.Q2,7,B.Q3,8,B.Q3,9,B.Q3,10,B.Q4,11,B.Q4,12,B.Q4),0)) * 100,2) As Qtr_Pct_Plan,
  Round(Sum(Case When Decode(Extract(Month From Sysdate),1,'QTR1',2,'QTR1',3,'QTR1',4,'QTR2',5,'QTR2',6,'QTR2',7,'QTR3',8,'QTR3',9,'QTR3',10,'QTR4',11,'QTR4',12,'QTR4') = 
                      Decode(Extract(Month From A.Invoicedate),1,'QTR1',2,'QTR1',3,'QTR1',4,'QTR2',5,'QTR2',6,'QTR2',7,'QTR3',8,'QTR3',9,'QTR3',10,'QTR4',11,'QTR4',12,'QTR4') And
                      Extract(Year From A.Invoicedate) = Extract(Year From Sysdate)
                 Then A.Allamounts
                 Else 0
            End) / Nullif(D.Elapsed_Work_Days,0),2)  As Qtr_Daily_Avg,
  Round(Decode(Extract(Month From Sysdate),1,B.Q1,2,B.Q1,3,B.Q1,4,B.Q2,5,B.Q2,6,B.Q2,7,B.Q3,8,B.Q3,9,B.Q3,10,B.Q4,11,B.Q4,12,B.Q4) - 
        Sum(Case When Decode(Extract(Month From Sysdate),1,'QTR1',2,'QTR1',3,'QTR1',4,'QTR2',5,'QTR2',6,'QTR2',7,'QTR3',8,'QTR3',9,'QTR3',10,'QTR4',11,'QTR4',12,'QTR4') = 
                      Decode(Extract(Month From A.Invoicedate),1,'QTR1',2,'QTR1',3,'QTR1',4,'QTR2',5,'QTR2',6,'QTR2',7,'QTR3',8,'QTR3',9,'QTR3',10,'QTR4',11,'QTR4',12,'QTR4') And
                      Extract(Year From A.Invoicedate) = Extract(Year From Sysdate)
                 Then A.Allamounts
                 Else 0
            End),2) As Qtr_To_Go,
  Round((Decode(Extract(Month From Sysdate),1,B.Q1,2,B.Q1,3,B.Q1,4,B.Q2,5,B.Q2,6,B.Q2,7,B.Q3,8,B.Q3,9,B.Q3,10,B.Q4,11,B.Q4,12,B.Q4) - 
        Sum(Case When Decode(Extract(Month From Sysdate),1,'QTR1',2,'QTR1',3,'QTR1',4,'QTR2',5,'QTR2',6,'QTR2',7,'QTR3',8,'QTR3',9,'QTR3',10,'QTR4',11,'QTR4',12,'QTR4') = 
                      Decode(Extract(Month From A.Invoicedate),1,'QTR1',2,'QTR1',3,'QTR1',4,'QTR2',5,'QTR2',6,'QTR2',7,'QTR3',8,'QTR3',9,'QTR3',10,'QTR4',11,'QTR4',12,'QTR4') And
                      Extract(Year From A.Invoicedate) = Extract(Year From Sysdate)
                 Then A.Allamounts
                 Else 0
            End)) / Nullif((D.Total_Sales_Days - D.Elapsed_Work_Days),0),2) As Qtr_Daily_Required,
  Round(((Sum(Case When Decode(Extract(Month From Sysdate),1,'QTR1',2,'QTR1',3,'QTR1',4,'QTR2',5,'QTR2',6,'QTR2',7,'QTR3',8,'QTR3',9,'QTR3',10,'QTR4',11,'QTR4',12,'QTR4') = 
                      Decode(Extract(Month From A.Invoicedate),1,'QTR1',2,'QTR1',3,'QTR1',4,'QTR2',5,'QTR2',6,'QTR2',7,'QTR3',8,'QTR3',9,'QTR3',10,'QTR4',11,'QTR4',12,'QTR4') And
                      Extract(Year From A.Invoicedate) = Extract(Year From Sysdate)
                 Then A.Allamounts
                 Else 0
            End) / Nullif(D.Elapsed_Work_Days,0)) * D.Total_Sales_Days) / Nullif(Decode(Extract(Month From Sysdate),1,B.Q1,2,B.Q1,3,B.Q1,4,B.Q2,5,B.Q2,6,B.Q2,7,B.Q3,8,B.Q3,9,B.Q3,10,B.Q4,11,B.Q4,12,B.Q4),0) * 100,2)  As Qtr_Run_Rate,
  Sum(Case When Extract(Year From A.Invoicedate) = Extract(Year From Sysdate)
           Then A.Allamounts
           Else 0
      End) As Year_Sales,
  Round(B.Total,2) As Year_Quota,
  Round((Sum(Case When Extract(Year From A.Invoicedate) = Extract(Year From Sysdate)
                  Then A.Allamounts
                  Else 0
             End) / Nullif(B.Total,0)) * 100,2) As Year_Pct_Plan,
  Round(Sum(Case When Extract(Month From A.Invoicedate) In (10,11,12) And
                      Extract(Month From Sysdate) In (1,2,3) And
                      Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) -1
                 Then A.Allamounts
                 When Extract(Month From A.Invoicedate) In (1,2,3) And
                      Extract(Month From Sysdate) In (4,5,6) And
                      Extract(Year From A.Invoicedate) = Extract(Year From Sysdate)
                 Then A.Allamounts
                 When Extract(Month From A.Invoicedate) In (4,5,6) And
                      Extract(Month From Sysdate) In (7,8,9) And
                      Extract(Year From A.Invoicedate) = Extract(Year From Sysdate)
                 Then A.Allamounts
                 When Extract(Month From A.Invoicedate) In (7,8,9) And
                      Extract(Month From Sysdate) In (10,11,12) And
                      Extract(Year From A.Invoicedate) = Extract(Year From Sysdate)
                 Then A.Allamounts
            End),2) As Prior_Qtr_Sales,
  Round((Sum(Case When Extract(Year From A.Invoicedate) = Extract(Year From Sysdate)
                  Then A.Allamounts
                  Else 0
             End) / NullIf( 
         Sum(Case When Extract(Month From A.Invoicedate) In (10,11,12) And
                       Extract(Month From Sysdate) In (1,2,3) And
                       Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) -1
                  Then A.Allamounts
                  When Extract(Month From A.Invoicedate) In (1,2,3) And
                       Extract(Month From Sysdate) In (4,5,6) And
                       Extract(Year From A.Invoicedate) = Extract(Year From Sysdate)
                  Then A.Allamounts
                  When Extract(Month From A.Invoicedate) In (4,5,6) And
                       Extract(Month From Sysdate) In (7,8,9) And
                       Extract(Year From A.Invoicedate) = Extract(Year From Sysdate)
                  Then A.Allamounts
                  When Extract(Month From A.Invoicedate) In (7,8,9) And
                       Extract(Month From Sysdate) In (10,11,12) And
                       Extract(Year From A.Invoicedate) = Extract(Year From Sysdate)
                  Then A.Allamounts
             End),0)) * 100,2) As Prior_Qtr_Pct,
  Sum(Case When Decode(Extract(Month From Sysdate),1,'QTR1',2,'QTR1',3,'QTR1',4,'QTR2',5,'QTR2',6,'QTR2',7,'QTR3',8,'QTR3',9,'QTR3',10,'QTR4',11,'QTR4',12,'QTR4') = 
                Decode(Extract(Month From A.Invoicedate),1,'QTR1',2,'QTR1',3,'QTR1',4,'QTR2',5,'QTR2',6,'QTR2',7,'QTR3',8,'QTR3',9,'QTR3',10,'QTR4',11,'QTR4',12,'QTR4') And
                A.InvoiceDate <= To_Date(Extract(Month From Sysdate) || '/' || Extract(Day From Sysdate) || '/' || (Extract(Year From Sysdate) -1),'MM/DD/YYYY')
           Then A.Allamounts
           Else 0
      End) As Prior_Year_Qtd_Sales,
  Round((Sum(Case When Decode(Extract(Month From Sysdate),1,'QTR1',2,'QTR1',3,'QTR1',4,'QTR2',5,'QTR2',6,'QTR2',7,'QTR3',8,'QTR3',9,'QTR3',10,'QTR4',11,'QTR4',12,'QTR4') = 
                       Decode(Extract(Month From A.Invoicedate),1,'QTR1',2,'QTR1',3,'QTR1',4,'QTR2',5,'QTR2',6,'QTR2',7,'QTR3',8,'QTR3',9,'QTR3',10,'QTR4',11,'QTR4',12,'QTR4') And
                       Extract(Year From A.Invoicedate) = Extract(Year From Sysdate)
                  Then A.Allamounts
                  Else 0
             End) /NullIf( 
           Sum(Case When Decode(Extract(Month From Sysdate),1,'QTR1',2,'QTR1',3,'QTR1',4,'QTR2',5,'QTR2',6,'QTR2',7,'QTR3',8,'QTR3',9,'QTR3',10,'QTR4',11,'QTR4',12,'QTR4') = 
                         Decode(Extract(Month From A.Invoicedate),1,'QTR1',2,'QTR1',3,'QTR1',4,'QTR2',5,'QTR2',6,'QTR2',7,'QTR3',8,'QTR3',9,'QTR3',10,'QTR4',11,'QTR4',12,'QTR4') And
                         A.InvoiceDate <= To_Date(Extract(Month From Sysdate) || '/' || Extract(Day From Sysdate) || '/' || (Extract(Year From Sysdate) -1),'MM/DD/YYYY')
                    Then A.Allamounts
                    Else 0
               End),0)) * 100,2) As Prior_Year_Qtd_Pct,
  Round(Sum(Case When A.Invoicedate <= To_Date(Extract(Month From Sysdate) || '/' || Extract(Day From Sysdate) || '/' || (Extract(Year From Sysdate) -1) ,'MM/DD/YYYY')
                 Then A.Allamounts
                 Else 0
            End),2) As Prior_Ytd_Sales,
  Round((Sum(Case When Extract(Year From A.InvoiceDate) = Extract(Year From Sysdate)
                Then A.Allamounts
                Else 0
           End) / NullIf(
       Sum(Case When A.Invoicedate <= To_Date(Extract(Month From Sysdate) || '/' || Extract(Day From Sysdate) || '/' || (Extract(Year From Sysdate) -1) ,'MM/DD/YYYY')
                 Then A.Allamounts
                 Else 0
            End),0)) * 100,2) As Prior_YTD_Pct
From
  Srfcstbyfam B Full OUter Join Kd_Sales_Data_Request A
    On B.F1 = A.Corporate_Form And
       B.Family = A.Part_Product_Family,
  Kd_Monthly_Calendar C,
  KD_Quarterly_Calendar D
Where
  A.Charge_Type = 'Parts' And
  A.Part_Product_Code != 'LIT' And
  A.Corporate_Form In ('DOMDIR','DOMDIS','CAN','EUR','ASIA','LA') And
  Extract(Month From Sysdate) = C.Month And
  D.Quarter = Decode(Extract(Month From Sysdate),1,'QTR1',2,'QTR1',3,'QTR1',4,'QTR2',5,'QTR2',6,'QTR2',7,'QTR3',8,'QTR3',9,'QTR3',10,'QTR4',11,'QTR4',12,'QTR4') And
  Extract(Year From A.Invoicedate) >= Extract(Year From Sysdate) -1
Group By
  A.Corporate_Form,
  A.Part_Product_Family, 
  Decode(Extract(Month From Sysdate),1,B.Jan,2,B.Feb,3,B.Mar,4,B.Apr,5,B.May,6,B.Jun,7,B.Jul,8,B.Aug,9,B.Sep,10,B.Oct,11,B.Nov,12,B.Dec),
  C.Elapsed_Work_Days,
  C.Total_Sales_Days - C.Elapsed_Work_Days,
  Decode(Extract(Month From Sysdate),1,B.Q1,2,B.Q1,3,B.Q1,4,B.Q2,5,B.Q2,6,B.Q2,7,B.Q3,8,B.Q3,9,B.Q3,10,B.Q4,11,B.Q4,12,B.Q4),
  D.Elapsed_Work_Days,
  D.Total_Sales_Days - D.Elapsed_Work_Days,
  D.Elapsed_Work_Days,
  D.Total_Sales_Days,
  B.Total
Order By
  A.Corporate_Form,
  A.Part_Product_Family
