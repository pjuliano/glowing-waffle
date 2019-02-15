Create Or Replace View KD_ASP_4PQ As 
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
                                         End)),2) "4PQ_BIO_ASP",
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
                                         End)),2) "4PQ_IMPLANTS_ASP",
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
                                         End)),2) "4PQ_IMPLANT_BODIES_ASP",
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
                                         End)),2) "4PQ_PRIMA_ASP",
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
                                        End)),2) "4PQ_PRMA+_ASP",
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
                                        End)),2) "4PQ_GNSIS_ASP",
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
                                        End)),2) "4PQ_TLMAX_ASP",
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
                                        End)),2) "4PQ_PCOMM_ASP",
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
                                        End)),2) "4PQ_COMM_ASP",
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
                                        End)),2) "4PQ_BVINE_ASP",
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
                                        End)),2) "4PQ_CONNX_ASP",
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
                                        End)),2) "4PQ_CYTOP_ASP",
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
                                        End)),2) "4PQ_DYNAB_ASP",
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
                                        End)),2) "4PQ_DYNAG_ASP",
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
                                        End)),2) "4PQ_DYNAM_ASP",
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
                                        End)),2) "4PQ_SYNTH_ASP",
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
                                        End)),2) "4PQ_MTF_ASP",
    Sysdate as RefreshDate
From
    KD_Sales_Data_Request A
Where
    A.InvoiceQtrYr = 'QTR' || Case When To_Char(Sysdate,'Q') = 1 Then '1' || '/' || To_Char(Extract(Year From Sysdate)-1) 
                                   When To_Char(Sysdate,'Q') = 2 Then '2' || '/' || To_Char(Extract(Year From Sysdate)-1) 
                                   When To_Char(Sysdate,'Q') = 3 Then '3' || '/' || To_Char(Extract(Year From Sysdate)-1)
                                   When To_Char(Sysdate,'Q') = 4 Then '4' || '/' || To_Char(Extract(Year From Sysdate)-1) End And
    A.Charge_Type = 'Parts' And
    A.Corporate_Form = 'DOMDIR' And
    A.Catalog_No != '3DBC-22001091' And
  ((A.Order_No Not Like 'W%' And
    A.Order_No Not Like 'X%') Or
    A.Order_No Is Null) And
   (A.Market_Code != 'PREPOST' Or A.Market_Code Is Null) And
    A.Invoice_ID != 'CR1001802096' AND --20180904 Invoice is stuck not posted and cannot be deleted.
    A.Order_No != 'C512921' --Kevin Stack's order/return that spanned years.
Group By 
    Rollup(A.Region_Code,A.Salesman_Code)