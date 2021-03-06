Create Or Replace View KD_ASP_6M As
Select
    A.Region_Code,
    A.Salesman_Code,
    Person_Info_Api.Get_Name(A.Salesman_Code) As Salesman_Name,
    NVL(A."CM_IMPLANTS_ASP",0) "CM_IMPLANTS_ASP",
    NVL(B."1PM_IMPLANTS_ASP",0) "1PM_IMPLANTS_ASP",
    NVL(C."2PM_IMPLANTS_ASP",0) "2PM_IMPLANTS_ASP",
    NVL(D."3PM_IMPLANTS_ASP",0) "3PM_IMPLANTS_ASP",
    NVL(E."4PM_IMPLANTS_ASP",0) "4PM_IMPLANTS_ASP",
    NVL(F."5PM_IMPLANTS_ASP",0) "5PM_IMPLANTS_ASP",
    NVL(A."CM_IMPLANT_BODIES_ASP",0) "CM_IMPLANT_BODIES_ASP",
    NVL(B."1PM_IMPLANT_BODIES_ASP",0) "1PM_IMPLANT_BODIES_ASP",
    NVL(C."2PM_IMPLANT_BODIES_ASP",0) "2PM_IMPLANT_BODIES_ASP",
    NVL(D."3PM_IMPLANT_BODIES_ASP",0) "3PM_IMPLANT_BODIES_ASP",
    NVL(E."4PM_IMPLANT_BODIES_ASP",0) "4PM_IMPLANT_BODIES_ASP",
    NVL(F."5PM_IMPLANT_BODIES_ASP",0) "5PM_IMPLANT_BODIES_ASP",
    NVL(A."CM_PRIMA_ASP",0) "CM_PRIMA_ASP",
    NVL(B."1PM_PRIMA_ASP",0) "1PM_PRIMA_ASP",
    NVL(C."2PM_PRIMA_ASP",0) "2PM_PRIMA_ASP",
    NVL(D."3PM_PRIMA_ASP",0) "3PM_PRIMA_ASP",
    NVL(E."4PM_PRIMA_ASP",0) "4PM_PRIMA_ASP",
    NVL(F."5PM_PRIMA_ASP",0) "5PM_PRIMA_ASP",
    NVL(A."CM_PRMA+_ASP",0) "CM_PRMA+_ASP",
    NVL(B."1PM_PRMA+_ASP",0) "1PM_PRMA+_ASP",
    NVL(C."2PM_PRMA+_ASP",0) "2PM_PRMA+_ASP",
    NVL(D."3PM_PRMA+_ASP",0) "3PM_PRMA+_ASP",
    NVL(E."4PM_PRMA+_ASP",0) "4PM_PRMA+_ASP",
    NVL(F."5PM_PRMA+_ASP",0) "5PM_PRMA+_ASP",
    NVL(A."CM_GNSIS_ASP",0) "CM_GNSIS_ASP",
    NVL(B."1PM_GNSIS_ASP",0) "1PM_GNSIS_ASP",
    NVL(C."2PM_GNSIS_ASP",0) "2PM_GNSIS_ASP",
    NVL(D."3PM_GNSIS_ASP",0) "3PM_GNSIS_ASP",
    NVL(E."4PM_GNSIS_ASP",0) "4PM_GNSIS_ASP",
    NVL(F."5PM_GNSIS_ASP",0) "5PM_GNSIS_ASP",
    NVL(A."CM_TLMAX_ASP",0) "CM_TLMAX_ASP",
    NVL(B."1PM_TLMAX_ASP",0) "1PM_TLMAX_ASP",
    NVL(C."2PM_TLMAX_ASP",0) "2PM_TLMAX_ASP",
    NVL(D."3PM_TLMAX_ASP",0) "3PM_TLMAX_ASP",
    NVL(E."4PM_TLMAX_ASP",0) "4PM_TLMAX_ASP",
    NVL(F."5PM_TLMAX_ASP",0) "5PM_TLMAX_ASP",
    NVL(A."CM_PCOMM_ASP",0) "CM_PCOMM_ASP",
    NVL(B."1PM_PCOMM_ASP",0) "1PM_PCOMM_ASP",
    NVL(C."2PM_PCOMM_ASP",0) "2PM_PCOMM_ASP",
    NVL(D."3PM_PCOMM_ASP",0) "3PM_PCOMM_ASP",
    NVL(E."4PM_PCOMM_ASP",0) "4PM_PCOMM_ASP",
    NVL(F."5PM_PCOMM_ASP",0) "5PM_PCOMM_ASP",
    NVL(A."CM_COMM_ASP",0) "CM_COMM_ASP",
    NVL(B."1PM_COMM_ASP",0) "1PM_COMM_ASP",
    NVL(C."2PM_COMM_ASP",0) "2PM_COMM_ASP",
    NVL(D."3PM_COMM_ASP",0) "3PM_COMM_ASP",
    NVL(E."4PM_COMM_ASP",0) "4PM_COMM_ASP",
    NVL(F."5PM_COMM_ASP",0) "5PM_COMM_ASP",
    NVL(A."CM_BIO_ASP",0) "CM_BIO_ASP",
    NVL(B."1PM_BIO_ASP",0) "1PM_BIO_ASP",
    NVL(C."2PM_BIO_ASP",0) "2PM_BIO_ASP",
    NVL(D."3PM_BIO_ASP",0) "3PM_BIO_ASP",
    NVL(E."4PM_BIO_ASP",0) "4PM_BIO_ASP",
    NVL(F."5PM_BIO_ASP",0) "5PM_BIO_ASP",
    NVL(A."CM_BVINE_ASP",0) "CM_BVINE_ASP",
    NVL(B."1PM_BVINE_ASP",0) "1PM_BVINE_ASP",
    NVL(C."2PM_BVINE_ASP",0) "2PM_BVINE_ASP",
    NVL(D."3PM_BVINE_ASP",0) "3PM_BVINE_ASP",
    NVL(E."4PM_BVINE_ASP",0) "4PM_BVINE_ASP",
    NVL(F."5PM_BVINE_ASP",0) "5PM_BVINE_ASP",
    NVL(A."CM_CONNX_ASP",0) "CM_CONNX_ASP",
    NVL(B."1PM_CONNX_ASP",0) "1PM_CONNX_ASP",
    NVL(C."2PM_CONNX_ASP",0) "2PM_CONNX_ASP",
    NVL(D."3PM_CONNX_ASP",0) "3PM_CONNX_ASP",
    NVL(E."4PM_CONNX_ASP",0) "4PM_CONNX_ASP",
    NVL(F."5PM_CONNX_ASP",0) "5PM_CONNX_ASP",
    NVL(A."CM_CYTOP_ASP",0) "CM_CYTOP_ASP",
    NVL(B."1PM_CYTOP_ASP",0) "1PM_CYTOP_ASP",
    NVL(C."2PM_CYTOP_ASP",0) "2PM_CYTOP_ASP",
    NVL(D."3PM_CYTOP_ASP",0) "3PM_CYTOP_ASP",
    NVL(E."4PM_CYTOP_ASP",0) "4PM_CYTOP_ASP",
    NVL(F."5PM_CYTOP_ASP",0) "5PM_CYTOP_ASP",
    NVL(A."CM_DYNAB_ASP",0) "CM_DYNAB_ASP",
    NVL(B."1PM_DYNAB_ASP",0) "1PM_DYNAB_ASP",
    NVL(C."2PM_DYNAB_ASP",0) "2PM_DYNAB_ASP",
    NVL(D."3PM_DYNAB_ASP",0) "3PM_DYNAB_ASP",
    NVL(E."4PM_DYNAB_ASP",0) "4PM_DYNAB_ASP",
    NVL(F."5PM_DYNAB_ASP",0) "5PM_DYNAB_ASP",
    NVL(A."CM_DYNAG_ASP",0) "CM_DYNAG_ASP",
    NVL(B."1PM_DYNAG_ASP",0) "1PM_DYNAG_ASP",
    NVL(C."2PM_DYNAG_ASP",0) "2PM_DYNAG_ASP",
    NVL(D."3PM_DYNAG_ASP",0) "3PM_DYNAG_ASP",
    NVL(E."4PM_DYNAG_ASP",0) "4PM_DYNAG_ASP",
    NVL(F."5PM_DYNAG_ASP",0) "5PM_DYNAG_ASP",
    NVL(A."CM_DYNAM_ASP",0) "CM_DYNAM_ASP",
    NVL(B."1PM_DYNAM_ASP",0) "1PM_DYNAM_ASP",
    NVL(C."2PM_DYNAM_ASP",0) "2PM_DYNAM_ASP",
    NVL(D."3PM_DYNAM_ASP",0) "3PM_DYNAM_ASP",
    NVL(E."4PM_DYNAM_ASP",0) "4PM_DYNAM_ASP",
    NVL(F."5PM_DYNAM_ASP",0) "5PM_DYNAM_ASP",
    NVL(A."CM_SYNTH_ASP",0) "CM_SYNTH_ASP",
    NVL(B."1PM_SYNTH_ASP",0) "1PM_SYNTH_ASP",
    NVL(C."2PM_SYNTH_ASP",0) "2PM_SYNTH_ASP",
    NVL(D."3PM_SYNTH_ASP",0) "3PM_SYNTH_ASP",
    NVL(E."4PM_SYNTH_ASP",0) "4PM_SYNTH_ASP",
    NVL(F."5PM_SYNTH_ASP",0) "5PM_SYNTH_ASP",
    NVL(A."CM_MTF_ASP",0) "CM_MTF_ASP",
    NVL(B."1PM_MTF_ASP",0) "1PM_MTF_ASP",
    NVL(C."2PM_MTF_ASP",0) "2PM_MTF_ASP",
    NVL(D."3PM_MTF_ASP",0) "3PM_MTF_ASP",
    NVL(E."4PM_MTF_ASP",0) "4PM_MTF_ASP",
    NVL(F."5PM_MTF_ASP",0) "5PM_MTF_ASP"

From
    Kd_Asp_Cm_Tab A,
    Kd_Asp_1pm_Tab B,
    Kd_Asp_2pm_Tab C,
    Kd_Asp_3pm_Tab D,
    Kd_Asp_4pm_Tab E,
    Kd_Asp_5pm_Tab F
Where
    (A.Salesman_Code = B.Salesman_Code And B.Salesman_Code = C.Salesman_Code And C.Salesman_Code = D.Salesman_Code And D.Salesman_Code = E.Salesman_Code And E.Salesman_Code = F.Salesman_Code And A.Region_Code = B.Region_Code And B.Region_Code = C.Region_Code And C.Region_Code = D.Region_Code And D.Region_Code = E.Region_Code And E.Region_Code = F.Region_Code) Or
    (A.Salesman_Code Is Null And B.Salesman_Code Is Null And C.Salesman_Code Is Null And D.Salesman_Code Is Null And E.Salesman_Code Is Null And F.Salesman_Code Is Null And A.Region_Code = B.Region_Code And B.Region_Code = C.Region_Code And C.Region_Code = D.Region_Code And D.Region_Code = E.Region_Code And E.Region_Code = F.Region_Code) Or
    (A.Salesman_Code Is Null And B.Salesman_Code Is Null And C.Salesman_Code Is Null And D.Salesman_Code Is Null And E.Salesman_Code Is Null And F.Salesman_Code Is Null And A.Region_Code Is Null And B.Region_Code Is Null And C.Region_Code Is Null And D.Region_Code Is Null And E.Region_Code Is Null And F.Region_Code Is Null)
Order By
    Decode(A.Region_Code,'USEC',1,'USCE',2,'USWC',3,'SECA',4,'UNASSIGNED',5),
    A.Salesman_Code