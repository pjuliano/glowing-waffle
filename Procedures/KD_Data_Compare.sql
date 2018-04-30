Create Or Replace Procedure KD_Compare_Data As
Begin
  Execute Immediate 
    'Delete From Kd_Sales_Data_Compare_Table A Where Refresh_Date = Sysdate';
  Execute Immediate
    'Insert Into KD_Sales_Data_Compare_Table
      Select
        Extract(Year From Invoicedate) As Year,
        Corporate_Form,
        Sum(Allamounts) As Total,
        Count(1) As Record_Count,
        SysDate Refresh_Date
      From
        Kd_Sales_Data_Request
      Group By
        Extract(Year From Invoicedate),
        Corporate_Form,
        Sysdate
      Order By
        Extract(Year From Invoicedate),
        Corporate_Form';
  Execute Immediate
    'Delete From Kd_Sales_Data_Compare_View A Where Refresh_Date = Sysdate';
  Execute Immediate
    'Insert Into KD_Sales_Data_Compare_View
      Select
        Extract(Year From Invoicedate) As Year,
        Corporate_Form,
        Sum(Allamounts) As Total,
        Count(1) As Record_Count,
        SysDate Refresh_Date
      From
        Kd_Sales_Data
      Group By
        Extract(Year From Invoicedate),
        Corporate_Form,
        Sysdate
      Order By
        Extract(Year From Invoicedate),
        Corporate_Form';
End;
  