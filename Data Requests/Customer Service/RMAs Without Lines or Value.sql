Select
    RM.Rma_No,
    RM.Date_Requested,
    RM.Cust_Ref,
    RL.Part_No,
    Count(RL.RMA_No) As Planned_Lines,
    Sum(Rl.Qty_To_Return * Rl.Base_Sale_Unit_Price) As Total_Pending$
From
    Return_Material RM Left Join Return_Material_Line RL
        On RM.RMA_No = RL.Rma_No And
           RL.State = 'Planned'
Where
    RM.State = 'Planned' And
    RM.Date_Requested < To_Date('01/01/2018','MM/DD/YYYY')
Group By
    RM.RMA_No,
    RM.Date_Requested,
    RM.Cust_Ref,
    RL.Part_No
Having
    Count(RL.RMA_No) = 0  Or (Count(RL.RMA_No) = 1 And RL.Part_No = 'UNK' And Sum(Rl.Qty_To_Return * Rl.Base_Sale_Unit_Price) = 0)
    --(Sum(Rl.Qty_To_Return * Rl.Base_Sale_Unit_Price) Is Null Or Sum(Rl.Qty_To_Return * Rl.Base_Sale_Unit_Price) = 0)
Order By
    RM.Date_Requested Asc