With CY_ASP As (
Select
    A.Salesman_Code,
    Person_Info_Api.Get_Name(A.Salesman_Code) Salesman_Name,
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
                                        End)),2) "CY_SYNTH_ASP"
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
    A.Salesman_Code,
    Person_Info_Api.Get_Name(A.Salesman_Code)
Order By 
    A.Salesman_Code),
    
PY_ASP AS (
Select
    A.Salesman_Code,
    Person_Info_Api.Get_Name(A.Salesman_Code) Salesman_Name,
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
                                        End)),2) "PY_SYNTH_ASP"
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
    A.Salesman_Code,
    Person_Info_Api.Get_Name(A.Salesman_Code)
Order By 
    A.Salesman_Code)

Select
    C.Region,
    A.Salesman_Code,
    A.Salesman_Name,
    A."CY_PRIMA_ASP",
    B."PY_PRIMA_ASP",
    A."CY_PRIMA_ASP" - B."PY_PRIMA_ASP" "PRIMA_ASP_DELTA",
    A."CY_PRMA+_ASP",
    B."PY_PRMA+_ASP",
    A."CY_PRMA+_ASP" - B."PY_PRMA+_ASP" "PRMA+_ASP_DELTA",
    A."CY_GNSIS_ASP",
    B."PY_GNSIS_ASP",
    A."CY_GNSIS_ASP" - B."PY_GNSIS_ASP" "GNSIS_ASP_DELTA",
    A."CY_TLMAX_ASP",
    B."PY_TLMAX_ASP",
    A."CY_TLMAX_ASP" - B."PY_TLMAX_ASP" "TLMAX_ASP_DELTA",
    A."CY_PCOMM_ASP",
    B."PY_PCOMM_ASP",
    A."CY_PCOMM_ASP" - B."PY_PCOMM_ASP" "PCOMM_ASP_DELTA",
    A."CY_COMM_ASP",
    B."PY_COMM_ASP",
    A."CY_COMM_ASP" - B."PY_PCOMM_ASP" "COMM_ASP_DELTA",
    A."CY_BVINE_ASP",
    B."PY_BVINE_ASP",
    A."CY_BVINE_ASP" - B."PY_BVINE_ASP" "BVINE_ASP_DELTA",
    A."CY_CONNX_ASP",
    B."PY_CONNX_ASP",
    A."CY_CONNX_ASP" - B."PY_CONNX_ASP" "CONNX_ASP_DELTA",
    A."CY_CYTOP_ASP",
    B."PY_CYTOP_ASP",
    A."CY_CYTOP_ASP" - B."PY_CYTOP_ASP" "CYTOP_ASP_DELTA",
    A."CY_DYNAB_ASP",
    B."PY_DYNAB_ASP",
    A."CY_DYNAB_ASP" - B."PY_DYNAB_ASP" "DYNAB_ASP_DELTA",
    A."CY_DYNAG_ASP",
    B."PY_DYNAG_ASP",
    A."CY_DYNAG_ASP" - B."PY_DYNAG_ASP" "DYNAG_ASP_DELTA",
    A."CY_DYNAM_ASP",
    B."PY_DYNAM_ASP",
    A."CY_DYNAM_ASP" - B."PY_DYNAM_ASP" "DYNAM_ASP_DELTA",
    A."CY_SYNTH_ASP",
    B."PY_SYNTH_ASP",
    A."CY_SYNTH_ASP" - B."PY_SYNTH_ASP" "SYNTH_ASP_DELTA"
From
    CY_ASP A Left Join Srrepquota C
        On A.Salesman_Code = C.Repnumber,
    PY_ASP B
Where
    A.Salesman_Code = B.Salesman_Code
Order By
    C.Region,
    A.Salesman_Code