Create Or Replace View KD_WWSS_REWORK As
With QuotaNA As
( Select
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
    A.Region),
Quotaglobal As
( Select
    A.F1,
    Sum(A.Jan) As "1",
    Sum(A.Feb) As "2",
    Sum(A.Mar) As "3",
    Sum(A.Apr) As "4",
    Sum(A.May) As "5",
    Sum(A.Jun) As "6",
    Sum(A.Jul) As "7",
    Sum(A.Aug) As "8",
    Sum(A.Sep) As "9",
    Sum(A.Oct) As "10",
    Sum(A.Nov) As "11",
    Sum(A.Dec) As "12",
    Sum(A.Q1) As Q1,
    Sum(A.Q2) As Q2,
    Sum(A.Q3) As Q3,
    Sum(A.Q4) As Q4,
    Sum(A.Total) As Total
  From
    Srfcstnew A
  Group By
    A.F1)
Select
  Decode(A.Corporate_Form,'ASIA', 'GlobalDist.','BENELUX','EuroSub','CAN','GlobalDist.','DOMDIR','NADirect','DOMDIS','GlobalDist.','EUR','GlobalDist.','FRA','EuroSub','Freight','Freight','GER','EuroSub','ITL','EuroSub','LA','GlobalDist.','SWE','EuroSub',A.Corporate_Form) As Segment,
  Case
    When
      A.Corporate_Form = 'Freight'
    Then
      'Freight'
    Else
      A.Region_Code
  End As Region,
  Sum(Case
        When
          A.Invoicedate = Trunc(Sysdate)
        Then
          A.Allamounts
        Else
          0
      End) As Today,
  Sum(Case
        When
          Extract(Month From A.Invoicedate) = Extract(Month From Sysdate) And
          Extract(Year From A.Invoicedate) = Extract(Year From Sysdate)
        Then
          A.AllAmounts
        Else
          0
      End) As Month_Actual,
  Case
    When
      Corporate_Form = 'DOMDIR'
    Then
      Decode(Extract(Month From Sysdate),1,B."1",2,B."2",3,B."3",4,B."4",5,B."5",6,B."6",7,B."7",8,B."8",9,B."9",10,B."10",11,B."11",12,B."12")
    Else
      Decode(Extract(Month From Sysdate),1,C."1",2,C."2",3,C."3",4,C."4",5,C."5",6,C."6",7,C."7",8,C."8",9,C."9",10,C."10",11,C."11",12,C."12")
  End As Month_Quota,
  Round((Sum(Case
                When
                  Extract(Month From A.Invoicedate) = Extract(Month From Sysdate) And
                  Extract(Year From A.Invoicedate) = Extract(Year From Sysdate)
                Then
                  A.AllAmounts
                Else
                  0
              End) / 
              Case
                When
                  Corporate_Form = 'DOMDIR'
                Then
                  Decode(Extract(Month From Sysdate),1,B."1",2,B."2",3,B."3",4,B."4",5,B."5",6,B."6",7,B."7",8,B."8",9,B."9",10,B."10",11,B."11",12,B."12")
                Else
                  Decode(Extract(Month From Sysdate),1,C."1",2,C."2",3,C."3",4,C."4",5,C."5",6,C."6",7,C."7",8,C."8",9,C."9",10,C."10",11,C."11",12,C."12")
              End) * 100, 2) As Month_Pct_To_Plan,
  Sum(Case
        When
          Decode(Extract(Month From Sysdate),1,'QTR1',2,'QTR1',3,'QTR1',4,'QTR2',5,'QTR2',6,'QTR2',7,'QTR3',8,'QTR3',9,'QTR3',10,'QTR4',11,'QTR4',12,'QTR4') = 
          Decode(Extract(Month From A.Invoicedate),1,'QTR1',2,'QTR1',3,'QTR1',4,'QTR2',5,'QTR2',6,'QTR2',7,'QTR3',8,'QTR3',9,'QTR3',10,'QTR4',11,'QTR4',12,'QTR4') And
          Extract(Year From Sysdate) = Extract(Year From A.InvoiceDate)
        Then
          A.Allamounts
        Else
          0
      End) As Qtr_Actual,
  Case
    When
      Corporate_Form = 'DOMDIR'
    Then
      Decode(Extract(Month From Sysdate),1,B.Q1,2,B.Q1,3,B.Q1,4,B.Q2,5,B.Q2,6,B.Q2,7,B.Q3,8,B.Q3,9,B.Q3,10,B.Q4,11,B.Q4,12,B.Q4)
    Else
      Decode(Extract(Month From Sysdate),1,C.Q1,2,C.Q1,3,C.Q1,4,C.Q2,5,C.Q2,6,C.Q2,7,C.Q3,8,C.Q3,9,C.Q3,10,C.Q4,11,C.Q4,12,C.Q4)
  End As Qtr_Quota,
  Round((Sum(Case
                When
                  Decode(Extract(Month From Sysdate),1,'QTR1',2,'QTR1',3,'QTR1',4,'QTR2',5,'QTR2',6,'QTR2',7,'QTR3',8,'QTR3',9,'QTR3',10,'QTR4',11,'QTR4',12,'QTR4') = 
                  Decode(Extract(Month From A.Invoicedate),1,'QTR1',2,'QTR1',3,'QTR1',4,'QTR2',5,'QTR2',6,'QTR2',7,'QTR3',8,'QTR3',9,'QTR3',10,'QTR4',11,'QTR4',12,'QTR4') And
                  Extract(Year From Sysdate) = Extract(Year From A.InvoiceDate)
                Then
                  A.Allamounts
                Else
                  0
              End) /     
              Case
                When
                  Corporate_Form = 'DOMDIR'
                Then
                  Decode(Extract(Month From Sysdate),1,B.Q1,2,B.Q1,3,B.Q1,4,B.Q2,5,B.Q2,6,B.Q2,7,B.Q3,8,B.Q3,9,B.Q3,10,B.Q4,11,B.Q4,12,B.Q4)
                Else
                  Decode(Extract(Month From Sysdate),1,C.Q1,2,C.Q1,3,C.Q1,4,C.Q2,5,C.Q2,6,C.Q2,7,C.Q3,8,C.Q3,9,C.Q3,10,C.Q4,11,C.Q4,12,C.Q4)
              End) * 100,2) As QTR_PCT_To_Plan,  
  Sum(Case
        When
          Extract(Year From A.InvoiceDate) = Extract(Year From Sysdate)
        Then
          A.AllAmounts
        Else
          0
      End) As Ytd_Actual,
  Case
    When 
      A.Corporate_Form = 'DOMDIR'
    Then 
      B.Total
    Else 
      C.Total
  End As Year_Quota,
  Round((Sum(Case
              When 
                Extract(Year From A.Invoicedate) = Extract(Year From Sysdate)
              Then 
                A.Allamounts
              Else 
                0
              End) /
              Case
                When 
                  A.Corporate_Form = 'DOMDIR'
                Then 
                  B.Total
                Else 
                  C.Total
              End) * 100,2) As Year_Pct_To_Plan,
  Sum(Case
        When
          Extract(Month From Sysdate) In (1,2,3)
        Then
          Case
            When
              Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) - 1 And
              Extract(Month From A.Invoicedate) In (10,11,12)
            Then
              A.AllAmounts
            Else
              0
          End
        When
          Extract(Month From Sysdate) In (4,5,6)
        Then
          Case
            When
              Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) And
              Extract(Month From A.Invoicedate) In (1,2,3)
            Then
              A.AllAmounts
            Else
              0
          End
        When
          Extract(Month From Sysdate) In (7,8,9)
        Then
          Case
            When
              Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) And
              Extract(Month From A.InvoiceDate) In (4,5,6)
            Then
              A.Allamounts
            Else
              0
          End
        When
          Extract(Month From Sysdate) In (10,11,12)
        Then
          Case
            When
              Extract(Month From A.Invoicedate) = Extract(Year From Sysdate) And
              Extract(Month From A.InvoiceDate) In (7,8,9)
            Then
              A.Allamounts
            Else
              0
          End
        Else
          0
      End) As Last_Qtr,
  Round(Sum(Case
              When
                Decode(Extract(Month From Sysdate),1,'QTR1',2,'QTR1',3,'QTR1',4,'QTR2',5,'QTR2',6,'QTR2',7,'QTR3',8,'QTR3',9,'QTR3',10,'QTR4',11,'QTR4',12,'QTR4') = 
                Decode(Extract(Month From A.Invoicedate),1,'QTR1',2,'QTR1',3,'QTR1',4,'QTR2',5,'QTR2',6,'QTR2',7,'QTR3',8,'QTR3',9,'QTR3',10,'QTR4',11,'QTR4',12,'QTR4') And
                Extract(Year From Sysdate) = Extract(Year From A.InvoiceDate)
              Then
                A.Allamounts
              Else
                0
            End) / 
        Sum(Case
              When
                Extract(Month From Sysdate) In (1,2,3)
              Then
                Case
                  When
                    Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) - 1 And
                    Extract(Month From A.Invoicedate) In (10,11,12)
                  Then
                    A.AllAmounts
                  Else
                    0
                End
              When
                Extract(Month From Sysdate) In (4,5,6)
              Then
                Case
                  When
                    Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) And
                    Extract(Month From A.Invoicedate) In (1,2,3)
                  Then
                    A.AllAmounts
                  Else
                    0
                End
              When
                Extract(Month From Sysdate) In (7,8,9)
              Then
                Case
                  When
                    Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) And
                    Extract(Month From A.InvoiceDate) In (4,5,6)
                  Then
                    A.Allamounts
                  Else
                    0
                End
              When
                Extract(Month From Sysdate) In (10,11,12)
              Then
                Case
                  When
                    Extract(Month From A.Invoicedate) = Extract(Year From Sysdate) And
                    Extract(Month From A.InvoiceDate) In (7,8,9)
                  Then
                    A.Allamounts
                  Else
                    0
                End
              Else
                0
            End) * 100,2) As Vs_Last_Qtr,
  Sum(Case
        When
          Extract(Month From Sysdate) In (1,2,3)
        Then
          Case
            When
              Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) - 1 And
              Extract(Month From A.Invoicedate) In (1,2,3) And
              A.InvoiceDate <= To_Date(To_Char(Extract(Month From Sysdate)) || '/' || To_Char(Extract(Day From Sysdate)) || '/' || To_Char(Extract(Year From Sysdate) -1),'MM/DD/YYYY')
            Then
              A.AllAmounts
            Else
              0
          End
        When
          Extract(Month From Sysdate) In (4,5,6)
        Then
          Case
            When
              Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) - 1 And
              Extract(Month From A.Invoicedate) In (4,5,6) And
              A.InvoiceDate <= To_Date(To_Char(Extract(Month From Sysdate)) || '/' || To_Char(Extract(Day From Sysdate)) || '/' || To_Char(Extract(Year From Sysdate) -1),'MM/DD/YYYY')
            Then
              A.AllAmounts
            Else
              0
          End
        When
          Extract(Month From Sysdate) In (7,8,9)
        Then
          Case
            When
              Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) - 1 And
              Extract(Month From A.Invoicedate) In (7,8,9) And
              A.InvoiceDate <= To_Date(To_Char(Extract(Month From Sysdate)) || '/' || To_Char(Extract(Day From Sysdate)) || '/' || To_Char(Extract(Year From Sysdate) -1),'MM/DD/YYYY')
            Then
              A.AllAmounts
            Else
              0
          End
        When
          Extract(Month From Sysdate) In (10,11,12)
        Then
          Case
            When
              Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) - 1 And
              Extract(Month From A.Invoicedate) In (10,11,12) And
              A.InvoiceDate <= To_Date(To_Char(Extract(Month From Sysdate)) || '/' || To_Char(Extract(Day From Sysdate)) || '/' || To_Char(Extract(Year From Sysdate) -1),'MM/DD/YYYY')
            Then
              A.Allamounts
            Else
              0
          End
        Else
          0
      End) As This_Qtd_Last_Year,
  Round(Sum(Case
              When
                Decode(Extract(Month From Sysdate),1,'QTR1',2,'QTR1',3,'QTR1',4,'QTR2',5,'QTR2',6,'QTR2',7,'QTR3',8,'QTR3',9,'QTR3',10,'QTR4',11,'QTR4',12,'QTR4') = 
                Decode(Extract(Month From A.Invoicedate),1,'QTR1',2,'QTR1',3,'QTR1',4,'QTR2',5,'QTR2',6,'QTR2',7,'QTR3',8,'QTR3',9,'QTR3',10,'QTR4',11,'QTR4',12,'QTR4') And
                Extract(Year From Sysdate) = Extract(Year From A.InvoiceDate)
              Then
                A.Allamounts
              Else
                0
            End) / 
        Sum(Case
              When
                Extract(Month From Sysdate) In (1,2,3)
              Then
                Case
                  When
                    Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) - 1 And
                    Extract(Month From A.Invoicedate) In (1,2,3) And
                    A.InvoiceDate <= To_Date(To_Char(Extract(Month From Sysdate)) || '/' || To_Char(Extract(Day From Sysdate)) || '/' || To_Char(Extract(Year From Sysdate) -1),'MM/DD/YYYY')
                  Then
                    A.AllAmounts
                  Else
                    0
                End
              When
                Extract(Month From Sysdate) In (4,5,6)
              Then
                Case
                  When
                    Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) - 1 And
                    Extract(Month From A.Invoicedate) In (4,5,6) And
                    A.InvoiceDate <= To_Date(To_Char(Extract(Month From Sysdate)) || '/' || To_Char(Extract(Day From Sysdate)) || '/' || To_Char(Extract(Year From Sysdate) -1),'MM/DD/YYYY')
                  Then
                    A.AllAmounts
                  Else
                    0
                End
              When
                Extract(Month From Sysdate) In (7,8,9)
              Then
                Case
                  When
                    Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) - 1 And
                    Extract(Month From A.Invoicedate) In (7,8,9) And
                    A.InvoiceDate <= To_Date(To_Char(Extract(Month From Sysdate)) || '/' || To_Char(Extract(Day From Sysdate)) || '/' || To_Char(Extract(Year From Sysdate) -1),'MM/DD/YYYY')
                  Then
                    A.AllAmounts
                  Else
                    0
                End
              When
                Extract(Month From Sysdate) In (10,11,12)
              Then
                Case
                  When
                    Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) - 1 And
                    Extract(Month From A.Invoicedate) In (10,11,12) And
                    A.InvoiceDate <= To_Date(To_Char(Extract(Month From Sysdate)) || '/' || To_Char(Extract(Day From Sysdate)) || '/' || To_Char(Extract(Year From Sysdate) -1),'MM/DD/YYYY')
                  Then
                    A.Allamounts
                  Else
                    0
                End
              Else
                0
            End) * 100,2) As Vs_This_Qtd_Last_Year,
  Sum(Case
        When
          Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) - 1 And
          A.Invoicedate <= To_Date(To_Char(Extract(Month From Sysdate)) || '/' || To_Char(Extract(Day From Sysdate)) || '/' || To_Char(Extract(Year From Sysdate) -1),'MM/DD/YYYY')
        Then
          A.AllAmounts
        Else
          0
      End) As Ytd_Last_Year,
  Round(Sum(Case
              When
                Extract(Year From A.InvoiceDate) = Extract(Year From Sysdate)
              Then
                A.AllAmounts
              Else
                0
            End) /
        Sum(Case
              When
                Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) - 1 And
                A.Invoicedate <= To_Date(To_Char(Extract(Month From Sysdate)) || '/' || To_Char(Extract(Day From Sysdate)) || '/' || To_Char(Extract(Year From Sysdate) -1),'MM/DD/YYYY')
              Then
                A.AllAmounts
              Else
                0
            End) * 100,2) As Vs_YTD_Last_Year
From
  Kd_Sales_Data_Request A Left Join Quotana B
    On A.Region_Code = B.Region
                          Left Join Quotaglobal C
    On A.Corporate_Form = C.F1
Where
  A.Corporate_Form Not In ('ITL','FRA','BENELUX','GER','SWE','KEY','DOMDIRPR','DOMDIRLE') And
  A.Region_Code != 'ITL' And
  Extract(Year From A.Invoicedate) >= Extract(Year From Sysdate) - 1 And
  A.Source = 'IFS'
Group By
  Decode(A.Corporate_Form,'ASIA', 'GlobalDist.','BENELUX','EuroSub','CAN','GlobalDist.','DOMDIR','NADirect','DOMDIS','GlobalDist.','EUR','GlobalDist.','FRA','EuroSub','Freight','Freight','GER','EuroSub','ITL','EuroSub','LA','GlobalDist.','SWE','EuroSub',A.Corporate_Form),
  Case
    When
      A.Corporate_Form = 'Freight'
    Then
      'Freight'
    Else
      A.Region_Code
  End,
  Case
    When
      Corporate_Form = 'DOMDIR'
    Then
      Decode(Extract(Month From Sysdate),1,B."1",2,B."2",3,B."3",4,B."4",5,B."5",6,B."6",7,B."7",8,B."8",9,B."9",10,B."10",11,B."11",12,B."12")
    Else
      Decode(Extract(Month From Sysdate),1,C."1",2,C."2",3,C."3",4,C."4",5,C."5",6,C."6",7,C."7",8,C."8",9,C."9",10,C."10",11,C."11",12,C."12")
  End,
  Case
    When
      Corporate_Form = 'DOMDIR'
    Then
      Decode(Extract(Month From Sysdate),1,B.Q1,2,B.Q1,3,B.Q1,4,B.Q2,5,B.Q2,6,B.Q2,7,B.Q3,8,B.Q3,9,B.Q3,10,B.Q4,11,B.Q4,12,B.Q4)
    Else
      Decode(Extract(Month From Sysdate),1,C.Q1,2,C.Q1,3,C.Q1,4,C.Q2,5,C.Q2,6,C.Q2,7,C.Q3,8,C.Q3,9,C.Q3,10,C.Q4,11,C.Q4,12,C.Q4)
  End,
  Case
    When 
      A.Corporate_Form = 'DOMDIR'
    Then 
      B.Total
    Else 
      C.Total
  End
Order By
  Decode(A.Corporate_Form,'ASIA', 'GlobalDist.','BENELUX','EuroSub','CAN','GlobalDist.','DOMDIR','NADirect','DOMDIS','GlobalDist.','EUR','GlobalDist.','FRA','EuroSub','Freight','Freight','GER','EuroSub','ITL','EuroSub','LA','GlobalDist.','SWE','EuroSub',A.Corporate_Form) Desc;
Create Or Replace View KD_WWSS_MK As 
With 
Calendar_Month As
( Select
    *
  From
    Kd_Monthly_Calendar A
  Where
    Extract(Month From Sysdate) = A.Month),
Calendar_Qtr As
( Select
    Sum(A.Total_Sales_Days) As Total_Sales_Days,
    Sum(A.Elapsed_Work_Days) As Elapsed_Work_Days
  From
    KD_Monthly_Calendar A
  Where
    A.Month <= Case
                  When
                    Extract(Month From Sysdate) In (1,2,3)
                  Then
                    3
                  When
                    Extract(Month From Sysdate) In (4,5,6)
                  Then
                    6
                  When
                    Extract(Month From Sysdate) In (7,8,9)
                  Then
                    9
                  When
                    Extract(Month From Sysdate) In (10,11,12)
                  Then
                    12
                End And
    A.Month >= Case
                  When
                    Extract(Month From Sysdate) In (1,2,3)
                  Then
                    1
                  When
                    Extract(Month From Sysdate) In (4,5,6)
                  Then
                    4
                  When
                    Extract(Month From Sysdate) In (7,8,9)
                  Then
                    7
                  When
                    Extract(Month From Sysdate) In (10,11,12)
                  Then
                    10
                End)
Select
  A.Segment,
  A.Region,
  A.Today,
  A.Month_Actual,
  A.Month_Quota,
  A.Month_Pct_To_Plan,
  Round((A.Month_Quota - A.Month_Actual) / (B.Total_Sales_Days - B.Elapsed_Work_Days),2) As Month_Daily_Req,
  A.Qtr_Actual,
  A.Qtr_Quota,
  A.Qtr_Pct_To_Plan,
  A.Qtr_Quota - A.Qtr_Actual As Qtr_Total_Req,
  Round((A.Qtr_Quota - A.Qtr_Actual) / (C.Total_Sales_Days - C.Elapsed_Work_Days),2) As Qtr_Daily_Req,
  Round((((A.Qtr_Actual / C.Elapsed_Work_Days) * C.Total_Sales_Days) / A.Qtr_Quota) * 100,2) As Qtr_Run_Rate_To_Plan,
  Round(((A.Qtr_Actual / C.Elapsed_Work_Days) * C.Total_Sales_Days),2) As Qtr_Run_Rate_Sales,
  A.Ytd_Actual,
  A.Year_Quota,
  A.Year_Pct_To_Plan,
  A.Last_Qtr,
  A.Vs_Last_Qtr,
  A.This_Qtd_Last_Year,
  A.Vs_This_Qtd_Last_Year,
  A.Ytd_Last_Year,
  A.VS_YTD_Last_YEAR
From
  Kd_Wwss_Rework A,
  Calendar_Month B,
  Calendar_QTR C