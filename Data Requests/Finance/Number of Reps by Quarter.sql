Select
  *
From (
  Select
    A.Invoiceqtryr,
    Customer_Order_Api.Get_Salesman_Code(A.Order_No) As Order_Salesman
  From
    Kd_Sales_Data_Request A
  Where
    A.Corporate_Form = 'DOMDIR' And
    Extract(Year From A.Invoicedate) >= 2012 And
    Customer_Order_Api.Get_Salesman_Code(A.Order_No) Is Not Null)
Pivot
  (Count(Distinct Order_Salesman) For Invoiceqtryr In ( 'QTR1/2012',
                                                        'QTR2/2012',
                                                        'QTR3/2012',
                                                        'QTR4/2012',
                                                        'QTR1/2013',
                                                        'QTR2/2013',
                                                        'QTR3/2013',
                                                        'QTR4/2013',
                                                        'QTR1/2014',
                                                        'QTR2/2014',
                                                        'QTR3/2014',
                                                        'QTR4/2014',
                                                        'QTR1/2015',
                                                        'QTR2/2015',
                                                        'QTR3/2015',
                                                        'QTR4/2015',
                                                        'QTR1/2016',
                                                        'QTR2/2016',
                                                        'QTR3/2016',
                                                        'QTR4/2016',
                                                        'QTR1/2017',
                                                        'QTR2/2017',
                                                        'QTR3/2017',
                                                        'QTR4/2017'))