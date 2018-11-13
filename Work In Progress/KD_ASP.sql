Create Or Replace View KD_ASP As 
With CY_ASP As (
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
                                         End)),2) "CY_BIO_ASP",
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
                                         End)),2) "CY_IMPLANTS_ASP",
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
                                         End)),2) "CY_IMPLANT_BODIES_ASP",
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
                                         End)),2) "CY_PRIMA_ASP",
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
                                        End)),2) "CY_PRMA+_ASP",
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
                                        End)),2) "CY_GNSIS_ASP",
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
                                        End)),2) "CY_TLMAX_ASP",
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
                                        End)),2) "CY_PCOMM_ASP",
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
                                        End)),2) "CY_COMM_ASP",
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
                                        End)),2) "CY_BVINE_ASP",
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
                                        End)),2) "CY_CONNX_ASP",
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
                                        End)),2) "CY_CYTOP_ASP",
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
                                        End)),2) "CY_DYNAB_ASP",
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
                                        End)),2) "CY_DYNAG_ASP",
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
                                        End)),2) "CY_DYNAM_ASP",
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
                                        End)),2) "CY_SYNTH_ASP",
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
                                        End)),2) "CY_MTF_ASP"
From
    KD_Sales_Data_Request A
Where
    Extract(Year From A.InvoiceDate) = Extract(Year From Sysdate) And
    A.Charge_Type = 'Parts' And
    A.Corporate_Form = 'DOMDIR' And
    A.Catalog_No != '3DBC-22001091' And
  ((A.Order_No Not Like 'W%' And
    A.Order_No Not Like 'X%') Or
    A.Order_No Is Null) And
   (A.Market_Code != 'PREPOST' Or A.Market_Code Is Null) And
    A.Invoice_ID != 'CR1001802096' --20180904 Invoice is stuck not posted and cannot be deleted.
Group By 
    Rollup(A.Region_Code,A.Salesman_Code)
Order By 
    A.Salesman_Code),
    
PY_ASP AS (
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
                                         End)),2) "PY_BIO_ASP",
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
                                         End)),2) "PY_IMPLANTS_ASP",
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
                                         End)),2) "PY_IMPLANT_BODIES_ASP",
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
                                         End)),2) "PY_PRIMA_ASP",
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
                                        End)),2) "PY_PRMA+_ASP",
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
                                        End)),2) "PY_GNSIS_ASP",
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
                                        End)),2) "PY_TLMAX_ASP",
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
                                        End)),2) "PY_PCOMM_ASP",
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
                                        End)),2) "PY_COMM_ASP",
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
                                        End)),2) "PY_BVINE_ASP",
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
                                        End)),2) "PY_CONNX_ASP",
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
                                        End)),2) "PY_CYTOP_ASP",
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
                                        End)),2) "PY_DYNAB_ASP",
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
                                        End)),2) "PY_DYNAG_ASP",
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
                                        End)),2) "PY_DYNAM_ASP",
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
                                        End)),2) "PY_SYNTH_ASP",
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
                                        End)),2) "PY_MTF_ASP"
From
    KD_Sales_Data_Request A
Where
    Extract(Year From A.InvoiceDate) = Extract(Year From Sysdate)-1 And
    A.Charge_Type = 'Parts' And
    A.Corporate_Form = 'DOMDIR' And
    A.Catalog_No != '3DBC-22001091' And
  ((A.Order_No Not Like 'W%' And
    A.Order_No Not Like 'X%') Or
    A.Order_No Is Null) And
   (A.Market_Code != 'PREPOST' Or A.Market_Code Is Null) And
    A.Invoice_ID != 'CR1001802096' --20180904 Invoice is stuck not posted and cannot be deleted.
Group By
    Rollup(A.Region_Code,A.Salesman_Code)
Order By 
    A.Salesman_Code)

Select
    A.Region_Code,
    A.Salesman_Code,
    Person_Info_Api.Get_Name(A.Salesman_Code) Salesman_Name,
    Nvl(A."CY_IMPLANTS_ASP",0) "CY_IMPLANTS_ASP",
    NVL(B."PY_IMPLANTS_ASP",0) "PY_IMPLANTS_ASP",
    Nvl(A."CY_IMPLANTS_ASP" - B."PY_IMPLANTS_ASP",0) "IMPLANTS_ASP_DELTA",
    Nvl(A."CY_IMPLANT_BODIES_ASP",0) "CY_IMPLANT_BODIES_ASP",
    Nvl(B."PY_IMPLANT_BODIES_ASP",0) "PY_IMPLANT_BODIES_ASP",
    Nvl(A."CY_IMPLANT_BODIES_ASP" - B."PY_IMPLANT_BODIES_ASP",0) "IMPLANT_BODIES_ASP",
    Nvl(A."CY_PRIMA_ASP",0) "CY_PRIMA_ASP",
    Nvl(B."PY_PRIMA_ASP",0) "PY_PRIMA_ASP",
    Nvl(A."CY_PRIMA_ASP" - B."PY_PRIMA_ASP",0) "PRIMA_ASP_DELTA",
    Nvl(A."CY_PRMA+_ASP",0) "CY_PRMA+_ASP",
    Nvl(B."PY_PRMA+_ASP",0) "PY_PRMA+_ASP",
    Nvl(A."CY_PRMA+_ASP" - B."PY_PRMA+_ASP",0) "PRMA+_ASP_DELTA",
    Nvl(A."CY_GNSIS_ASP",0) "CY_GNSIS_ASP",
    Nvl(B."PY_GNSIS_ASP",0) "PY_GNSIS_ASP",
    Nvl(A."CY_GNSIS_ASP" - B."PY_GNSIS_ASP",0) "GNSIS_ASP_DELTA",
    Nvl(A."CY_TLMAX_ASP",0) "CY_TLMAX_ASP",
    Nvl(B."PY_TLMAX_ASP",0) "PY_TLMAX_ASP",
    Nvl(A."CY_TLMAX_ASP" - B."PY_TLMAX_ASP",0) "TLMAX_ASP_DELTA",
    Nvl(A."CY_PCOMM_ASP",0) "CY_PCOMM_ASP",
    Nvl(B."PY_PCOMM_ASP",0) "PY_PCOMM_ASP",
    Nvl(A."CY_PCOMM_ASP" - B."PY_PCOMM_ASP",0) "PCOMM_ASP_DELTA",
    Nvl(A."CY_COMM_ASP",0) "CY_COMM_ASP",
    Nvl(B."PY_COMM_ASP",0) "PY_COMM_ASP",
    Nvl(A."CY_COMM_ASP" - B."PY_COMM_ASP",0) "COMM_ASP_DELTA",
    Nvl(A."CY_BIO_ASP",0) "CY_BIO_ASP",
    Nvl(B."PY_BIO_ASP",0) "PY_BIO_ASP",
    Nvl(A."CY_BIO_ASP" - B."PY_BIO_ASP",0) "BIO_ASP_DELTA",
    Nvl(A."CY_BVINE_ASP",0) "CY_BVINE_ASP",
    Nvl(B."PY_BVINE_ASP",0) "PY_BVINE_ASP",
    Nvl(A."CY_BVINE_ASP" - B."PY_BVINE_ASP",0) "BVINE_ASP_DELTA",
    Nvl(A."CY_CONNX_ASP",0) "CY_CONNX_ASP",
    Nvl(B."PY_CONNX_ASP",0) "PY_CONNX_ASP",
    Nvl(A."CY_CONNX_ASP" - B."PY_CONNX_ASP",0) "CONNX_ASP_DELTA",
    Nvl(A."CY_CYTOP_ASP",0) "CY_CYTOP_ASP",
    Nvl(B."PY_CYTOP_ASP",0) "PY_CYTOP_ASP",
    Nvl(A."CY_CYTOP_ASP" - B."PY_CYTOP_ASP",0) "CYTOP_ASP_DELTA",
    Nvl(A."CY_DYNAB_ASP",0) "CY_DYNAB_ASP",
    Nvl(B."PY_DYNAB_ASP",0) "PY_DYNAB_ASP",
    Nvl(A."CY_DYNAB_ASP" - B."PY_DYNAB_ASP",0) "DYNAB_ASP_DELTA",
    Nvl(A."CY_DYNAG_ASP",0) "CY_DYNAG_ASP",
    Nvl(B."PY_DYNAG_ASP",0) "PY_DYNAG_ASP",
    Nvl(A."CY_DYNAG_ASP" - B."PY_DYNAG_ASP",0) "DYNAG_ASP_DELTA",
    Nvl(A."CY_DYNAM_ASP",0) "CY_DYNAM_ASP",
    Nvl(B."PY_DYNAM_ASP",0) "PY_DYNAM_ASP",
    Nvl(A."CY_DYNAM_ASP" - B."PY_DYNAM_ASP",0) "DYNAM_ASP_DELTA",
    Nvl(A."CY_SYNTH_ASP",0) "CY_SYNTH_ASP",
    Nvl(B."PY_SYNTH_ASP",0) "PY_SYNTH_ASP",
    Nvl(A."CY_SYNTH_ASP" - B."PY_SYNTH_ASP",0) "SYNTH_ASP_DELTA",
    Nvl(A."CY_MTF_ASP",0) "CY_MTF_ASP",
    Nvl(B."PY_MTF_ASP",0) "PY_MTF_ASP",
    NVL(A."CY_MTF_ASP" - B."PY_MTF_ASP",0) "MTF_ASP_DELTA"
From
    CY_ASP A,
    PY_ASP B
Where
    (A.Salesman_Code = B.Salesman_Code And A.Region_Code = B.Region_Code) Or 
    (A.Salesman_Code Is Null And B.Salesman_Code Is Null And A.Region_Code = B.Region_Code) Or
    (A.Salesman_Code Is Null and B.Salesman_Code IS Null And A.Region_Code Is Null and B.Region_Code IS Null)
Order By
    Decode(A.Region_Code,'USEC',1,'USCE',2,'USWC',3,'SECA',4,'UNASSIGNED',5),
    A.Salesman_Code