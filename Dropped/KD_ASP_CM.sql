Create or Replace View KD_ASP_CM As
Select
    A.Region_Code,
    A.Salesman_Code,
    Round(Sum(Case When Part_Product_Code = 'REGEN' Then
                   A.AllAmounts
                   Else 0
              End) /
              Decode(Sum(Case When Part_Product_Code ='REGEN' Then
                              A.Invoiced_qty
                              Else 0
                         End),0,Null,Sum(Case When Part_Product_Code ='REGEN' Then
                                              A.Invoiced_qty
                                              Else 0
                                         End)),2) "CM_BIO_ASP",
    Round(Sum(Case When Part_Product_Code Not In ('LIT','REGEN') Then
                   A.AllAmounts
                   Else 0
              End) /
              Decode(Sum(Case When Part_Product_Code Not In ('LIT','REGEN') Then
                              A.Invoiced_qty
                              Else 0
                         End),0,Null,Sum(Case When Part_Product_Code Not In ('LIT','REGEN') Then
                                              A.Invoiced_qty
                                              Else 0
                                         End)),2) "CM_IMPLANTS_ASP",
    Round(Sum(Case When Part_Product_Code = 'IMPL' Then
                   A.AllAmounts
                   Else 0
              End) /
              Decode(Sum(Case When Part_Product_Code = 'IMPL' Then
                              A.Invoiced_qty
                              Else 0
                         End),0,Null,Sum(Case When Part_Product_Code = 'IMPL' Then
                                              A.Invoiced_qty
                                              Else 0
                                         End)),2) "CM_IMPLANT_BODIES_ASP",
    Round(Sum(Case When Part_Product_Family = 'PRIMA' Then
                   A.AllAmounts
                   Else 0
              End) /
              Decode(Sum(Case When Part_Product_Family = 'PRIMA' Then
                              A.Invoiced_qty
                              Else 0
                         End),0,Null,Sum(Case When Part_Product_Family = 'PRIMA' Then           
                                              A.Invoiced_qty
                                              Else 0
                                         End)),2) "CM_PRIMA_ASP",
    Round(Sum(Case When Part_Product_Family = 'PRMA+' Then
                   A.AllAmounts
                   Else 0
              End) /
              Decode(Sum(Case When Part_Product_Family = 'PRMA+' Then
                            A.Invoiced_qty
                            Else 0
                       End),0,Null,Sum(Case When Part_Product_Family = 'PRMA+' Then
                                             A.Invoiced_qty
                                             Else 0
                                        End)),2) "CM_PRMA+_ASP",
    Round(Sum(Case When Part_Product_Family = 'GNSIS' Then
                   A.AllAmounts
                   Else 0
              End) /
              Decode(Sum(Case When Part_Product_Family = 'GNSIS' Then
                            A.Invoiced_qty
                            Else 0
                       End),0,Null,Sum(Case When Part_Product_Family = 'GNSIS' Then
                                             A.Invoiced_qty
                                             Else 0
                                        End)),2) "CM_GNSIS_ASP",
    Round(Sum(Case When Part_Product_Family = 'TLMAX' Then
                   A.AllAmounts
                   Else 0
              End) /
              Decode(Sum(Case When Part_Product_Family = 'TLMAX' Then
                            A.Invoiced_qty
                            Else 0
                       End),0,Null,Sum(Case When Part_Product_Family = 'TLMAX' Then
                                             A.Invoiced_qty
                                             Else 0
                                        End)),2) "CM_TLMAX_ASP",
    Round(Sum(Case When Part_Product_Family = 'PCOMM' Then
                   A.AllAmounts
                   Else 0
              End) /
              Decode(Sum(Case When Part_Product_Family = 'PCOMM' Then
                            A.Invoiced_qty
                            Else 0
                       End),0,Null,Sum(Case When Part_Product_Family = 'PCOMM' Then
                                             A.Invoiced_qty
                                             Else 0
                                        End)),2) "CM_PCOMM_ASP",
    Round(Sum(Case When Part_Product_Family = 'COMM' Then
                   A.AllAmounts
                   Else 0
              End) /
              Decode(Sum(Case When Part_Product_Family = 'COMM' Then
                            A.Invoiced_qty
                            Else 0
                       End),0,Null,Sum(Case When Part_Product_Family = 'COMM' Then
                                             A.Invoiced_qty
                                             Else 0
                                        End)),2) "CM_COMM_ASP",
    Round(Sum(Case When Part_Product_Family = 'BVINE' Then
                   A.AllAmounts
                   Else 0
              End) /
              Decode(Sum(Case When Part_Product_Family = 'BVINE' Then
                            A.Invoiced_qty
                            Else 0
                       End),0,Null,Sum(Case When Part_Product_Family = 'BVINE' Then
                                             A.Invoiced_qty
                                             Else 0
                                        End)),2) "CM_BVINE_ASP",
    Round(Sum(Case When Part_Product_Family = 'CONNX' Then
                   A.AllAmounts
                   Else 0
              End) /
              Decode(Sum(Case When Part_Product_Family = 'CONNX' Then
                            A.Invoiced_qty
                            Else 0
                       End),0,Null,Sum(Case When Part_Product_Family = 'CONNX' Then
                                             A.Invoiced_qty
                                             Else 0
                                        End)),2) "CM_CONNX_ASP",
    Round(Sum(Case When Part_Product_Family = 'CYTOP' Then
                   A.AllAmounts
                   Else 0
              End) /
              Decode(Sum(Case When Part_Product_Family = 'CYTOP' Then
                            A.Invoiced_qty
                            Else 0
                       End),0,Null,Sum(Case When Part_Product_Family = 'CYTOP' Then
                                             A.Invoiced_qty
                                             Else 0
                                        End)),2) "CM_CYTOP_ASP",
    Round(Sum(Case When Part_Product_Family = 'DYNAB' Then
                   A.AllAmounts
                   Else 0
              End) /
              Decode(Sum(Case When Part_Product_Family = 'DYNAB' Then
                            A.Invoiced_qty
                            Else 0
                       End),0,Null,Sum(Case When Part_Product_Family = 'DYNAB' Then
                                             A.Invoiced_qty
                                             Else 0
                                        End)),2) "CM_DYNAB_ASP",
    Round(Sum(Case When Part_Product_Family = 'DYNAG' Then
                   A.AllAmounts
                   Else 0
              End) /
              Decode(Sum(Case When Part_Product_Family = 'DYNAG' Then
                            A.Invoiced_qty
                            Else 0
                       End),0,Null,Sum(Case When Part_Product_Family = 'DYNAG' Then
                                             A.Invoiced_qty
                                             Else 0
                                        End)),2) "CM_DYNAG_ASP",
    Round(Sum(Case When Part_Product_Family = 'DYNAM' Then
                   A.AllAmounts
                   Else 0
              End) /
              Decode(Sum(Case When Part_Product_Family = 'DYNAM' Then
                            A.Invoiced_qty
                            Else 0
                       End),0,Null,Sum(Case When Part_Product_Family = 'DYNAM' Then
                                             A.Invoiced_qty
                                             Else 0
                                        End)),2) "CM_DYNAM_ASP",
    Round(Sum(Case When Part_Product_Family = 'SYNTH' Then
                   A.AllAmounts
                   Else 0
              End) /
              Decode(Sum(Case When Part_Product_Family = 'SYNTH' Then
                            A.Invoiced_qty
                            Else 0
                       End),0,Null,Sum(Case When Part_Product_Family = 'SYNTH' Then
                                             A.Invoiced_qty
                                             Else 0
                                        End)),2) "CM_SYNTH_ASP",
    Round(Sum(Case When Part_Product_Family = 'MTF' Then
                   A.AllAmounts
                   Else 0
              End) /
              Decode(Sum(Case When Part_Product_Family = 'MTF' Then
                            A.Invoiced_qty
                            Else 0
                       End),0,Null,Sum(Case When Part_Product_Family = 'MTF' Then
                                             A.Invoiced_qty
                                             Else 0
                                        End)),2) "CM_MTF_ASP",
    Sysdate as RefreshDate
From
    KD_Sales_Data_Request A
Where
    A.InvoiceMthYr = To_Char(Sysdate,'MM') || '/' || Extract(Year From Sysdate) And
    A.Charge_Type = 'Parts' And
    A.Corporate_Form = 'DOMDIR' And
    A.Catalog_No != '3DBC-22001091' And
  ((A.Order_No Not Like 'W%' And
    A.Order_No Not Like 'X%') Or
    A.Order_No Is Null) And
   (A.Market_Code != 'PREPOST' Or A.Market_Code Is Null) And
    A.Invoice_ID != 'CR1001802096' AND --20180904 Invoice is stuck not posted and cannot be deleted.
(A.Order_No != 'C512921' Or A.Order_No Is Null) --Kevin Stack's order/return that spanned years.
Group By 
    Rollup(A.Region_Code,A.Salesman_Code)