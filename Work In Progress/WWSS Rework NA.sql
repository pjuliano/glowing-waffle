Create Or Replace View Kd_WWSS_NADirect As
With Quota_Na As (
  Select
    A.Region,
    Sum(A.Jan) As "1",
    Sum(A.Feb) As "2",
    Sum(A.Mar) As "3",
    Sum(A.Apr) As "4",
    Sum(A.May) As "5",
    Sum(A.June) As "6",
    Sum(A.July) As "7",
    Sum(A.Aug) As "8",
    Sum(A.Sept) As "9",
    Sum(A.Oct) As "10",
    Sum(A.Nov) As "11",
    Sum(A.Dec) As "12",
    Sum(A.Qtr1) As Q1,
    Sum(A.Qtr2) As Q2,
    Sum(A.Qtr3) As Q3,
    Sum(A.Qtr4) As Q4,
    Sum(A.Year) As Total
  From
    Srrepquota A
  Group By
    A.Region  )

Select
  'NADirect' As Segment,
  A.Region_Code,
  Sum(Case When A.Invoicedate = Trunc(Sysdate)
           Then A.Allamounts
           Else 0
      End) As Today_Sales,
  Sum(Case When Extract(Month From A.Invoicedate) = Extract(Month From Sysdate) And
                Extract(Year From A.Invoicedate) = Extract(Year From Sysdate)
           Then A.Allamounts
           Else 0
      End) As Month_Sales,
  Round(Decode(Extract(Month From Sysdate),1,B."1",2,B."2",3,B."3",4,B."4",5,B."5",6,B."6",7,B."7",8,B."8",9,B."9",10,B."10",11,B."11",12,B."12"),2) As Month_Quota,
  Round((Sum(Case When Extract(Month From A.Invoicedate) = Extract(Month From Sysdate) And
                       Extract(Year From A.Invoicedate) = Extract(Year From Sysdate)
                  Then A.Allamounts
                  Else 0
             End) / NullIf(Decode(Extract(Month From Sysdate),1,B."1",2,B."2",3,B."3",4,B."4",5,B."5",6,B."6",7,B."7",8,B."8",9,B."9",10,B."10",11,B."11",12,B."12"),0)) * 100,2) As Month_Pct_Plan,
  Round((Decode(Extract(Month From Sysdate),1,B."1",2,B."2",3,B."3",4,B."4",5,B."5",6,B."6",7,B."7",8,B."8",9,B."9",10,B."10",11,B."11",12,B."12") -
         Sum(Case When Extract(Month From A.Invoicedate) = Extract(Month From Sysdate) And
                       Extract(Year From A.Invoicedate) = Extract(Year From Sysdate)
                  Then A.Allamounts
                  Else 0
             End)) / NullIf((C.Total_Sales_Days - C.Elapsed_Work_Days),0),2) As Month_Daily_Required,
  Sum(Case When Decode(Extract(Month From Sysdate),1,'QTR1',2,'QTR1',3,'QTR1',4,'QTR2',5,'QTR2',6,'QTR2',7,'QTR3',8,'QTR3',9,'QTR3',10,'QTR4',11,'QTR4',12,'QTR4') = 
                Decode(Extract(Month From A.Invoicedate),1,'QTR1',2,'QTR1',3,'QTR1',4,'QTR2',5,'QTR2',6,'QTR2',7,'QTR3',8,'QTR3',9,'QTR3',10,'QTR4',11,'QTR4',12,'QTR4') And
                Extract(Year From A.Invoicedate) = Extract(Year From Sysdate)
           Then A.Allamounts
           Else 0
      End) As Qtr_Sales,
  Round(Decode(Extract(Month From Sysdate),1,B.Q1,2,B.Q1,3,B.Q1,4,B.Q2,5,B.Q2,6,B.Q2,7,B.Q3,8,B.Q3,9,B.Q3,10,B.Q4,11,B.Q4,12,B.Q4),2) As Qtr_Quota,
  Round((Sum(Case When Decode(Extract(Month From Sysdate),1,'QTR1',2,'QTR1',3,'QTR1',4,'QTR2',5,'QTR2',6,'QTR2',7,'QTR3',8,'QTR3',9,'QTR3',10,'QTR4',11,'QTR4',12,'QTR4') = 
                       Decode(Extract(Month From A.Invoicedate),1,'QTR1',2,'QTR1',3,'QTR1',4,'QTR2',5,'QTR2',6,'QTR2',7,'QTR3',8,'QTR3',9,'QTR3',10,'QTR4',11,'QTR4',12,'QTR4') And
                       Extract(Year From A.Invoicedate) = Extract(Year From Sysdate)
                  Then A.Allamounts
                  Else 0
             End) / NullIf(Decode(Extract(Month From Sysdate),1,B.Q1,2,B.Q1,3,B.Q1,4,B.Q2,5,B.Q2,6,B.Q2,7,B.Q3,8,B.Q3,9,B.Q3,10,B.Q4,11,B.Q4,12,B.Q4),0)) * 100,2) As Qtr_Pct_Plan,
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
              End)) / NullIF((D.Total_Sales_Days - D.Elapsed_Work_Days),0),2) As Qtr_Daily_Required,
  Round(((Sum(Case When Decode(Extract(Month From Sysdate),1,'QTR1',2,'QTR1',3,'QTR1',4,'QTR2',5,'QTR2',6,'QTR2',7,'QTR3',8,'QTR3',9,'QTR3',10,'QTR4',11,'QTR4',12,'QTR4') = 
                        Decode(Extract(Month From A.Invoicedate),1,'QTR1',2,'QTR1',3,'QTR1',4,'QTR2',5,'QTR2',6,'QTR2',7,'QTR3',8,'QTR3',9,'QTR3',10,'QTR4',11,'QTR4',12,'QTR4') And
                        Extract(Year From A.Invoicedate) = Extract(Year From Sysdate)
                   Then A.Allamounts
                   Else 0
              End) / NullIf(D.Elapsed_Work_Days,0)) * D.Total_Sales_Days) / NullIf(Decode(Extract(Month From Sysdate),1,B.Q1,2,B.Q1,3,B.Q1,4,B.Q2,5,B.Q2,6,B.Q2,7,B.Q3,8,B.Q3,9,B.Q3,10,B.Q4,11,B.Q4,12,B.Q4),0) * 100,2) As Qtr_Run_Rate_Pct,
  Round(((Sum(Case When Decode(Extract(Month From Sysdate),1,'QTR1',2,'QTR1',3,'QTR1',4,'QTR2',5,'QTR2',6,'QTR2',7,'QTR3',8,'QTR3',9,'QTR3',10,'QTR4',11,'QTR4',12,'QTR4') = 
                        Decode(Extract(Month From A.Invoicedate),1,'QTR1',2,'QTR1',3,'QTR1',4,'QTR2',5,'QTR2',6,'QTR2',7,'QTR3',8,'QTR3',9,'QTR3',10,'QTR4',11,'QTR4',12,'QTR4') And
                        Extract(Year From A.Invoicedate) = Extract(Year From Sysdate)
                   Then A.Allamounts
                   Else 0
              End) / NullIf(D.Elapsed_Work_Days,0)) * D.Total_Sales_Days),2) As Qtr_Run_Rate_Sales,
  Sum(Case When Extract(Year From A.InvoiceDate) = Extract(Year From Sysdate)
           Then A.Allamounts
           Else 0
      End) As Year_Sales,
  Round(B.Total,2) As Year_Quota,
  Round((Sum(Case When Extract(Year From A.Invoicedate) = Extract(Year From Sysdate)
                  Then A.Allamounts
                  Else 0
             End) / NullIf(B.Total,0)) * 100,2) As Year_Pct_Plan,
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
  Round((Sum(Case When Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) And
                       Decode(Extract(Month From Sysdate),1,'QTR1',2,'QTR1',3,'QTR1',4,'QTR2',5,'QTR2',6,'QTR2',7,'QTR3',8,'QTR3',9,'QTR3',10,'QTR4',11,'QTR4',12,'QTR4') =
                       Decode(Extract(Month From A.InvoiceDate),1,'QTR1',2,'QTR1',3,'QTR1',4,'QTR2',5,'QTR2',6,'QTR2',7,'QTR3',8,'QTR3',9,'QTR3',10,'QTR4',11,'QTR4',12,'QTR4')
                  Then A.Allamounts
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
  Quota_Na B Full Outer Join Kd_Sales_Data_Request A
    On B.Region = A.Region_Code,
  Kd_Monthly_Calendar C,
  KD_Quarterly_Calendar D
Where
  C.Month = Extract(Month From Sysdate) And
  D.Quarter = Decode(Extract(Month From Sysdate),1,'QTR1',2,'QTR1',3,'QTR1',4,'QTR2',5,'QTR2',6,'QTR2',7,'QTR3',8,'QTR3',9,'QTR3',10,'QTR4',11,'QTR4',12,'QTR4') And
  A.Charge_Type = 'Parts' And
  Extract(Year From A.Invoicedate) >= Extract(Year From Sysdate) -1 And
  A.Corporate_Form = 'DOMDIR'
Group By
  'NADirect',
  A.Region_Code,
  Decode(Extract(Month From Sysdate),1,B."1",2,B."2",3,B."3",4,B."4",5,B."5",6,B."6",7,B."7",8,B."8",9,B."9",10,B."10",11,B."11",12,B."12"),
  C.Total_Sales_Days - C.Elapsed_Work_Days,
  Decode(Extract(Month From Sysdate),1,B.Q1,2,B.Q1,3,B.Q1,4,B.Q2,5,B.Q2,6,B.Q2,7,B.Q3,8,B.Q3,9,B.Q3,10,B.Q4,11,B.Q4,12,B.Q4),
  D.Total_Sales_Days - D.Elapsed_Work_Days,
  D.Elapsed_Work_Days,
  D.Total_Sales_Days,
  B.Total