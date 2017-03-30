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
  Case When Decode(Extract(Month From Sysdate),1,B.Jan,2,B.Feb,3,B.Mar,4,B.Apr,5,B.May,6,B.Jun,7,B.Jul,8,B.Aug,9,B.Sep,10,B.Oct,11,B.Nov,12,B.Dec) != 0
       Then Round(Sum(Case When Extract(Month From Invoicedate) = Extract(Month From Sysdate) And
                                Extract(Year From Invoicedate) = Extract(Year From Sysdate)
                                Then A.Allamounts
                                Else 0
                      End) / Decode(Extract(Month From Sysdate),1,B.Jan,2,B.Feb,3,B.Mar,4,B.Apr,5,B.May,6,B.Jun,7,B.Jul,8,B.Aug,9,B.Sep,10,B.Oct,11,B.Nov,12,B.Dec),4) * 100
       Else Null
  End As Month_Pct_Plan,
  Round(Sum(Case When Extract(Month From Invoicedate) = Extract(Month From Sysdate) And
                      Extract(Year From Invoicedate) = Extract(Year From Sysdate)
                 Then A.Allamounts
                 Else 0
            End) / C.Elapsed_Work_Days,2) As Month_Daily_Avg,
  Round((Decode(Extract(Month From Sysdate),1,B.Jan,2,B.Feb,3,B.Mar,4,B.Apr,5,B.May,6,B.Jun,7,B.Jul,8,B.Aug,9,B.Sep,10,B.Oct,11,B.Nov,12,B.Dec) - 
         Sum(Case When Extract(Month From Invoicedate) = Extract(Month From Sysdate) And
                       Extract(Year From Invoicedate) = Extract(Year From Sysdate)
                  Then A.Allamounts
                  Else 0
             End)) / (C.Total_Sales_Days - C.Elapsed_Work_Days),2) As Month_Daily_Required,
  Sum(Case When Decode(Extract(Month From Sysdate),1,'QTR1',2,'QTR1',3,'QTR1',4,'QTR2',5,'QTR2',6,'QTR2',7,'QTR3',8,'QTR3',9,'QTR3',10,'QTR4',11,'QTR4',12,'QTR4') = 
                Decode(Extract(Month From A.Invoicedate),1,'QTR1',2,'QTR1',3,'QTR1',4,'QTR2',5,'QTR2',6,'QTR2',7,'QTR3',8,'QTR3',9,'QTR3',10,'QTR4',11,'QTR4',12,'QTR4') And
                Extract(Year From A.InvoiceDate) = Extract(Year From Sysdate)
           Then A.Allamounts
           Else 0
      End) As Qtr_Sales,
  Round(Decode(Extract(Month From Sysdate),1,B.Q1,2,B.Q1,3,B.Q1,4,B.Q2,5,B.Q2,6,B.Q2,7,B.Q3,8,B.Q3,9,B.Q3,10,B.Q4,11,B.Q4,12,B.Q4),2) As Qtr_Quota
From
  Srfcstbyfam B Full OUter Join Kd_Sales_Data_Request A
    On B.F1 = A.Corporate_Form And
       B.Family = A.Part_Product_Family,
  KD_Monthly_Calendar C
Where
  A.Charge_Type = 'Parts' And
  A.Part_Product_Code != 'LIT' And
  A.Corporate_Form In ('DOMDIR','DOMDIS','CAN','EUR','ASIA','LA') And
  Extract(Month From Sysdate) = C.Month
Group By
  A.Corporate_Form,
  A.Part_Product_Family,
  Decode(Extract(Month From Sysdate),1,B.Jan,2,B.Feb,3,B.Mar,4,B.Apr,5,B.May,6,B.Jun,7,B.Jul,8,B.Aug,9,B.Sep,10,B.Oct,11,B.Nov,12,B.Dec),
  C.Elapsed_Work_Days,
  C.Total_Sales_Days - C.Elapsed_Work_Days,
  Decode(Extract(Month From Sysdate),1,B.Q1,2,B.Q1,3,B.Q1,4,B.Q2,5,B.Q2,6,B.Q2,7,B.Q3,8,B.Q3,9,B.Q3,10,B.Q4,11,B.Q4,12,B.Q4)
Order By
  A.Corporate_Form,
  A.Part_Product_Family