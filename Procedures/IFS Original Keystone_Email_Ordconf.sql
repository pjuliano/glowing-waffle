create or replace procedure KEYSTONE_EMAIL_ORDCONF (order_no_ IN VARCHAR2)
 is

   fnd_user_            VARCHAR2(30)         := Fnd_Session_API.Get_Fnd_User;
   field_separator_     CONSTANT VARCHAR2(1) := Client_SYS.field_separator_;
   job_id_              NUMBER;
   report_attr_         VARCHAR2(2000);
   parameter_attr_      VARCHAR2(2000);
   schedule_id_         NUMBER;
   start_date_          DATE              := SYSDATE;
   schedule_name_       VARCHAR2(200);
   report_id_           VARCHAR2(30)      := 'CUSTOMER_ORDER_CONF_REP';
   message_attr_        VARCHAR2(2000);
   pdf_archiving_       VARCHAR2(5)       := 'TRUE';
   archiving_attr_      VARCHAR2(2000);
   next_execution_date_ DATE;
   seq_no_              NUMBER;
   customer_email_      VARCHAR2(2000);
   salesrep_email_      VARCHAR2(2000);
   customer_name_       VARCHAR2(2000);
   salesrep_name_       VARCHAR2(2000);
   customer_no_         customer_order_tab.customer_no%TYPE;
   default_phone_       customer_info_comm_method_tab.value%TYPE;
   stat_group_          CUST_ORD_CUSTOMER_TAB.Cust_Grp%TYPE;
   ship_state_          CUSTOMER_INFO_ADDRESS_TAB.state%TYPE;
   creation_date_       CUSTOMER_INFO_TAB.creation_date%TYPE;


BEGIN

--IF (:old.order_conf = 'N') and (:new.order_conf = 'Y') THEN
--IF :new.cust_ref = '1' THEN
--Trace_SYS.Message('order_no' ||:new.order_no);
--Trace_SYS.Message('order_no old' ||:old.order_no);

  -- General_SYS.Init_Method(lu_name_, 'PURCHASE_ORDER_API', 'Email');
   Client_SYS.Clear_Attr(report_attr_);
   Client_SYS.Add_To_Attr('REPORT_ID', report_id_,  report_attr_);
   Client_SYS.Add_To_Attr('LU_NAME', 'CustomerOrder',  report_attr_);

   Client_SYS.Clear_Attr(parameter_attr_);
   Client_SYS.Add_To_Attr('ORDER_NO', order_no_, parameter_attr_);
--   Client_SYS.Add_To_Attr('PUR_ORDER_PRINT_OPTION',Pur_Order_Print_Option_API.Decode('ORDER'), parameter_attr_);

   -- Find the next execution date from the execution plan (if this is not done, the schedule will execute immediately)
   next_execution_date_ := Batch_SYS.Get_Next_Exec_Time__('ASAP', start_date_);
   schedule_name_ := Report_Definition_API.Get_Translated_Report_Title(report_id_);
   -- Create the new scheduled report.
   Batch_SYS.New_Batch_Schedule(schedule_id_,
                                next_execution_date_,
                                start_date_,
                                NULL,
                                schedule_name_,
                                'Archive_API.Create_And_Print_Report__',
                                'TRUE',
                                'ASAP',
                                NULL,
                                NULL,
                                report_id_);

   -- Add the id of the created scheduled task to report attribute string.
   Client_SYS.Set_Item_Value('SCHEDULE_ID', schedule_id_, report_attr_);
   Client_SYS.Set_Item_Value('LAYOUT_NAME', Report_Layout_Definition_API.Get_Default_Layout(report_id_), report_attr_);
   -- Add the language code for this session to the report attribute string if no language has been choosen
   Client_SYS.Set_Item_Value('LANG_CODE', Fnd_Session_API.Get_Language, report_attr_);
   Client_SYS.Set_Item_Value('NOTES', 'TRIGGER', report_attr_);

   -- Creating the message attr
   Client_SYS.Clear_Attr(message_attr_);
   Client_SYS.Add_To_Attr('MESSAGE_TYPE', 'NONE', message_attr_);
   -- This is used to send the message only
   --Client_SYS.Add_To_Attr('MESSAGE_TYPE', 'EMAIL', message_attr_);
   --Client_SYS.Add_To_Attr('SEND_EMAIL_TO', email_, message_attr_);

   --- Creating the pdf archiving attr
   Client_SYS.Clear_Attr(archiving_attr_);
   Client_SYS.Add_To_Attr('PDF_ARCHIVING', pdf_archiving_, archiving_attr_);
   -- Not sure add these two as well
  -- Client_SYS.Add_To_Attr('SEND_PDF', 'TRUE', archiving_attr_);
  -- Client_SYS.Add_To_Attr('SEND_PDF_TO', email_, archiving_attr_);
  --JASON - Here we'll define the different event parameters
  --1 - Customer Email
  --2 - Salesrep Email
  --3 - Customer Contact
  --4 - Salesrep Name
  --5 - Coordinator
  customer_no_ := customer_order_api.get_customer_no(order_no_);
  customer_email_ := Customer_Info_Comm_Method_API.Get_Default_E_Mail(customer_no_, sysdate);
  salesrep_email_ := Person_Info_Comm_Method_API.Get_Default_E_Mail(customer_order_api.get_salesman_code(order_no_), sysdate);
  customer_name_  := Customer_Info_Address_API.Get_Primary_Contact(customer_no_, customer_order_api.get_bill_addr_no(order_no_) );
  salesrep_name_  := Person_Info_Api.Get_Name(customer_order_api.get_salesman_code(order_no_));
--(+) 110202 RUJAUS C_G987812-1 (START)
  default_phone_ := customer_info_comm_method_api.get_default_phone(customer_no_, SYSDATE);
  stat_group_ := CUST_ORD_CUSTOMER_API.Get_Cust_Grp(customer_no_);
  ship_state_ := CUSTOMER_ORDER_ADDRESS_API.Get_State(order_no_);
  creation_date_ := CUSTOMER_INFO_API.Get_creation_date(customer_no_);
--(+) 110202 RUJAUS C_G987812-1 (FINISH)

   Client_SYS.Add_To_Attr('PDF_EVENT_PARAM_1', customer_email_, archiving_attr_);
   Client_SYS.Add_To_Attr('PDF_EVENT_PARAM_2', salesrep_email_, archiving_attr_);
   Client_SYS.Add_To_Attr('PDF_EVENT_PARAM_3', customer_name_, archiving_attr_);
   Client_SYS.Add_To_Attr('PDF_EVENT_PARAM_4', salesrep_name_, archiving_attr_);
   Client_SYS.Add_To_Attr('PDF_EVENT_PARAM_5', 'TRIGGER', archiving_attr_);
   client_SYS.Add_To_Attr('REPLY_TO_USER', Person_Info_API.Get_User_Id(customer_order_api.get_authorize_code(order_no_)), archiving_attr_);
--(+) 110202 RUJAUS C_G987812-1 (START)   
   Client_SYS.Add_To_Attr('DEFAULT_PHONE', default_phone_, archiving_attr_);
   Client_SYS.Add_To_Attr('STAT_GROUP',    stat_group_,    archiving_attr_);
   Client_SYS.Add_To_Attr('SHIP_STATE',    ship_state_,    archiving_attr_);
   Client_SYS.Add_To_Attr('CREATION_DATE', creation_date_, archiving_attr_);
--(+) 110202 RUJAUS C_G987812-1 (FINISH)

   -- Add the parameters
   Batch_SYS.New_Batch_Schedule_Param(seq_no_, schedule_id_, 'REPORT_ATTR', report_attr_);
   Batch_SYS.New_Batch_Schedule_Param(seq_no_, schedule_id_, 'PARAMETER_ATTR', parameter_attr_);
   Batch_SYS.New_Batch_Schedule_Param(seq_no_, schedule_id_, 'MESSAGE_ATTR', message_attr_);
   Batch_SYS.New_Batch_Schedule_Param(seq_no_, schedule_id_, 'ARCHIVING_ATTR', archiving_attr_);
   Batch_SYS.New_Batch_Schedule_Param(seq_no_, schedule_id_, 'DISTRIBUTION_LIST', fnd_user_|| field_separator_);
   
--END IF;
   
END;