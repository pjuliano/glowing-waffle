Create Or Replace View KD_CQ_COMMISSION As
Select
  A.Salesman_Code,
  Sum(Case When Extract(Month From A.Invoicedate) In (1,4,7,10) And
                A.Part_Product_Code Not In ('LIT','REGEN')
           Then A.Allamounts
           Else 0
      End) As Qm1_Impl,
  Round(Sum(Case When Extract(Month From A.Invoicedate) In (1,4,7,10) And
                      A.Part_Product_Code Not In ('LIT','REGEN')
                 Then A.Allamounts
                 Else 0
            End) * 0.08,2) As Qm1_Imp_Com_Base,
  Round(Sum(Case When Extract(Month From A.Invoicedate) In (1,4,7,10) And
                      A.Part_Product_Code Not In ('LIT','REGEN') 
                 Then A.Allamounts
                 Else 0
            End) * 0.09,2) - 
  Round(Sum(Case When Extract(Month From A.Invoicedate) In (1,4,7,10) And
                      A.Part_Product_Code Not In ('LIT','REGEN')
                 Then A.Allamounts
                 Else 0
            End) * 0.08,2) As "QM1_IMP_COM+",
  Sum(Case When Extract(Month From A.Invoicedate) In (1,4,7,10) And
                A.Part_Product_Code = 'REGEN'
           Then A.Allamounts
           Else 0
      End) As Qm1_Bio,
  Round(Sum(Case When Extract(Month From A.Invoicedate) In (1,4,7,10) And
                      A.Part_Product_Code = 'REGEN'
                 Then A.Allamounts
                 Else 0
            End) * 0.06,2) As Qm1_BIO_Com_Base,
  Round(Sum(Case When Extract(Month From A.Invoicedate) In (1,4,7,10) And
                      A.Part_Product_Code = 'REGEN' 
                 Then A.Allamounts
                 Else 0
            End) * 0.07,2) - 
  Round(Sum(Case When Extract(Month From A.Invoicedate) In (1,4,7,10) And
                      A.Part_Product_Code = 'REGEN'
                 Then A.Allamounts
                 Else 0
            End) * 0.06,2) As "QM1_BIO_COM+",
  Sum(Case When Extract(Month From A.Invoicedate) In (2,5,8,11) And
                A.Part_Product_Code Not In ('LIT','REGEN')
           Then A.Allamounts
           Else 0
      End) As Qm2_Impl,
  Round(Sum(Case When Extract(Month From A.Invoicedate) In (2,5,8,11) And
                      A.Part_Product_Code Not In ('LIT','REGEN')
                 Then A.Allamounts
                 Else 0
            End) * 0.08,2) As Qm2_Imp_Com_Base,
  Round(Sum(Case When Extract(Month From A.Invoicedate) In (2,5,8,11) And
                      A.Part_Product_Code Not In ('LIT','REGEN') 
                 Then A.Allamounts
                 Else 0
            End) * 0.09,2) - 
  Round(Sum(Case When Extract(Month From A.Invoicedate) In (2,5,8,11) And
                      A.Part_Product_Code Not In ('LIT','REGEN')
                 Then A.Allamounts
                 Else 0
            End) * 0.08,2) As "QM2_IMP_COM+",
  Sum(Case When Extract(Month From A.Invoicedate) In (2,5,8,11) And
                A.Part_Product_Code = 'REGEN'
           Then A.Allamounts
           Else 0
      End) As QM2_Bio,
  Round(Sum(Case When Extract(Month From A.Invoicedate) In (2,5,8,11) And
                      A.Part_Product_Code = 'REGEN'
                 Then A.Allamounts
                 Else 0
            End) * 0.06,2) As Qm2_BIO_Com_Base,
  Round(Sum(Case When Extract(Month From A.Invoicedate) In (2,5,8,11) And
                      A.Part_Product_Code = 'REGEN' 
                 Then A.Allamounts
                 Else 0
            End) * 0.07,2) - 
  Round(Sum(Case When Extract(Month From A.Invoicedate) In (2,5,8,11) And
                      A.Part_Product_Code = 'REGEN'
                 Then A.Allamounts
                 Else 0
            End) * 0.06,2) As "QM2_BIO_COM+",
  Sum(Case When Extract(Month From A.Invoicedate) In (3,6,9,12) And
                A.Part_Product_Code Not In ('LIT','REGEN')
           Then A.Allamounts
           Else 0
      End) As Qm3_Impl,
  Round(Sum(Case When Extract(Month From A.Invoicedate) In (3,6,9,12) And
                      A.Part_Product_Code Not In ('LIT','REGEN')
                 Then A.Allamounts
                 Else 0
            End) * 0.08,2) As Qm3_Imp_Com_Base,
  Round(Sum(Case When Extract(Month From A.Invoicedate) In (3,6,9,12) And
                      A.Part_Product_Code Not In ('LIT','REGEN') 
                 Then A.Allamounts
                 Else 0
            End) * 0.09,2) - 
  Round(Sum(Case When Extract(Month From A.Invoicedate) In (3,6,9,12) And
                      A.Part_Product_Code Not In ('LIT','REGEN')
                 Then A.Allamounts
                 Else 0
            End) * 0.08,2) As "QM3_IMP_COM+",
  Sum(Case When Extract(Month From A.Invoicedate) In (3,6,9,12) And
                A.Part_Product_Code = 'REGEN'
           Then A.Allamounts
           Else 0
      End) As Qm3_Bio,
  Round(Sum(Case When Extract(Month From A.Invoicedate) In (3,6,9,12) And
                      A.Part_Product_Code = 'REGEN'
                 Then A.Allamounts
                 Else 0
            End) * 0.06,2) As Qm3_BIO_Com_Base,
  Round(Sum(Case When Extract(Month From A.Invoicedate) In (3,6,9,12) And
                      A.Part_Product_Code = 'REGEN' 
                 Then A.Allamounts
                 Else 0
            End) * 0.07,2) - 
  Round(Sum(Case When Extract(Month From A.Invoicedate) In (3,6,9,12) And
                      A.Part_Product_Code = 'REGEN'
                 Then A.Allamounts
                 Else 0
            End) * 0.06,2) As "QM3_BIO_COM+"
From
  Kd_Sales_Data_Request A Left Join Srrepquota B
    On A.Salesman_Code = B.Repnumber
Where
  Case When Extract(Month From A.Invoicedate) In (1,2,3) 
       Then 'QTR1'
       When Extract(Month From A.Invoicedate) In (4,5,6)
       Then 'QTR2'
       When Extract(Month From A.Invoicedate) In (7,8,9)
       Then 'QTR3'
       When Extract(Month From A.Invoicedate) In (10,11,12)
       Then 'QTR4'
  End = A.InvoiceQtr And
  Extract(Year From A.Invoicedate) = Extract(Year From Sysdate) And
  A.Charge_Type = 'Parts' And
  A.Corporate_Form = 'DOMDIR' And
((A.Order_No Not Like 'W%' And
  A.Order_No Not Like 'X%') Or
  A.Order_No Is Null) And
 (A.Market_Code != 'PREPOST' or A.Market_Code Is Null)
Group By
  A.Salesman_Code
Order By
  A.Salesman_Code Asc