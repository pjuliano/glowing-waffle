Create or Replace View Kd_National_Account_Summary As
Select
  A.Association_No,
  B.Name,
  Sum(Decode(Extract(Month From A.Invoicedate),1,A.Allamounts,0)) As Jan,
  Sum(Decode(Extract(Month From A.Invoicedate),2,A.Allamounts,0)) As Feb,
  Sum(Decode(Extract(Month From A.Invoicedate),3,A.Allamounts,0)) As Mar,
  Sum(Case When Extract(Month From A.Invoicedate) In (1,2,3) Then A.Allamounts Else 0 End) As Q1,
  Sum(Decode(Extract(Month From A.Invoicedate),4,A.Allamounts,0)) As Apr,
  Sum(Decode(Extract(Month From A.Invoicedate),5,A.Allamounts,0)) As May,
  Sum(Decode(Extract(Month From A.Invoicedate),6,A.Allamounts,0)) As Jun,
  Sum(Case When Extract(Month From A.Invoicedate) In (4,5,6) Then A.Allamounts Else 0 End) As Q2,
  Sum(Decode(Extract(Month From A.Invoicedate),7,A.Allamounts,0)) As Jul,
  Sum(Decode(Extract(Month From A.Invoicedate),8,A.Allamounts,0)) As Aug,
  Sum(Decode(Extract(Month From A.Invoicedate),9,A.Allamounts,0)) As Sep,
  Sum(Case When Extract(Month From A.Invoicedate) In (7,8,9) Then A.Allamounts Else 0 End) As Q3,
  Sum(Decode(Extract(Month From A.Invoicedate),10,A.Allamounts,0)) As Oct,
  Sum(Decode(Extract(Month From A.Invoicedate),11,A.Allamounts,0)) As Nov,
  Sum(Decode(Extract(Month From A.Invoicedate),12,A.Allamounts,0)) As Dec, 
  Sum(Case When Extract(Month From A.Invoicedate) In (10,11,12) Then A.Allamounts Else 0 End) As Q4,
  Sum(A.AllAmounts) As Total
From
  Kd_Sales_Data_Request A Left Join Customer_Info B
    On A.Association_No = B.Customer_ID
Where
  A.Association_No Like 'N%' And
  A.Association_No Not In ('UNIV','NIHI001','N1001','N1012','N9153') And
  A.Association_No Not Like '%SI%' And
  A.Charge_Type = 'Parts' And
  A.Corporate_Form = 'DOMDIR' And
  Extract(Year From A.InvoiceDate) = Extract(Year From Sysdate)
Group By
  A.Association_No,
  B.Name