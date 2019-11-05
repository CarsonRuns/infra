@isTest
public class CRMDB_Helper_Test {
    public static testMethod void demo(){
        Boolean parentUpdate = false;
        User admin = CEE_TestUtility.getUser('admin', true);
        List<PermissionSetAssignment> permissionSetList = new List<PermissionSetAssignment>();        
        for(PermissionSet ps : [SELECT Id,Name FROM PermissionSet WHERE Name = 'CRMDB_CMO' OR Name = 'customerDetailPermission']) {
            PermissionSetAssignment psa = new PermissionSetAssignment (PermissionSetId = ps.Id, AssigneeId = admin.Id);
            
            permissionSetList.add(psa);
        }        
        upsert permissionSetList;
        system.debug('permissionSetList'+permissionSetList);
        system.Runas(admin) {  
            Org_Constant_CS__c testCust = new Org_Constant_CS__c();
            testCust.Name = 'CRMDBPermissionSets';
            testCust.Non_Production_Value__c ='0PS1b0000004e8z,0PS1b0000004e90';
            testCust.Production_Value__c ='0PS1b0000004e8z,0PS1b0000004e90';
            insert testCust;
            
            Org_Constant_CS__c testCust1 = new Org_Constant_CS__c();
            testCust1.Name = 'CRMDB Trigger Skip';
            testCust1.Non_Production_Value__c ='No';
            testCust1.Production_Value__c ='No';
            insert testCust1;
            
            CRMDB__c crmdb = new CRMDB__c(
                Last_MSR_Date_or_N_A__c = Date.today(),
                Last_QBR__c = Date.today(),
                Customer_Sentiment__c = 'Positive',
                Account_State__c = 'Green', 
                Is_Customer_on_CAP__c = 'No',
                CAP_Title__c = 'NA',
                CAP_case_Number_Engagement_ID__c = 'CAP876445',
                CAP_Case_Opened_Date__c = Date.today(),
                CAP_case_Manager_Name__c = 'John Schroeder',
                Theater__c = 'AMER',
                Segment__c = 'US Commercial',
                GES_or_CGEM_Area__c = 'GES_South',
                Name = 'Archer-Daniels-Midlands (ADM)',
                Active_Customer__c = 'yes',
                Date_Customer_first_became_CMS_Customer__c = Date.today(),
                Service_Transition_Date__c = Date.today(),
                Offer_Level__c = 'Foundation',
                //Who_Delivers_Service__c = 'Cisco',
                Reference_Account__c = 'No',
                Direct_Indirect_Sales__c = 'N/A - Cisco Direct',
                Contract_Renewal_Date__c = Date.today(),
                Device_Count__c = 1,
                SDM_Assigned__c = 'John',
                Manager__c = 'John',
                CMO_Assigned_for_Billing_Reporting__c = 'Martha Lercher',
                //key_contacts__c = 'Martha Lercher',
                CMO_Assigned_for_MSR__c = 'Martha Lercher',
                Partner_Delivered_CSM_Assigned__c = 'Brian Chapman',
                Number_of_Scheduled_Meetings_per_Week__c = 4,
                Number_of_Scheduled_Meetings_Per_Quarter__c = 4,
                Open_CONTRACT_CRs_Complex__c = 1,
                Open_CONTRACT_CRs_Simple__c = 1,
                Projects_On_going_Count__c = 1,
                Land__c = 'Customer Active',
                Adopt__c = 935,
                Delivery_NOC_Count__c = 46,
                Type_of_Transition__c = 'None',
                Platform_Count__c = 3,
                CMO_Billing_Effort__c = 20,
                CMO_MSR_Effort__c = 22,
                Expand__c = 20,
                Renew__c = 0,
                SLA__c = 'Yes',
                DID__c = '17160708',
                Links_to_Quote_Contract_SoW__c ='https://docs.cisco.com/share/page/site/nextgen-edcs/documentlibrary#filter=path%7C%2FCisco%2520Services%2FCisco%2520Maged%2520Services%2FCustomers%2FBaxter%2520Healthcare%2FBaxter%2520Doc%2520Exchange%2FBaxter%2520Contract%2520Information%7C&page=1',
                Upsell_Opportunities__c = 'Extended voice support',
                Margin_As_sold__c = 20,
                Annual_Revenue_FY_to_date__c = 123,
                Integrated_Account_Plan_IAP_Link__c = 'True',
                Margin_Delivered__c = 46,
                Renewal_Probability__c = 2,
                Contract_Term_Months__c = 23,
                Total_Other_Cisco_products_and_services__c = 2,
                Total_Cisco_Contract_Value__c = 123,
                Annual_CMS_Contract_Value__c = 123,
                Total_CMS_Contract_Value__c = 123);
            
            Insert crmdb;
            CRMDB__c crmdbtest = new CRMDB__c(
                Last_MSR_Date_or_N_A__c = Date.today(),
                Last_QBR__c = Date.today(),
                Customer_Sentiment__c = 'Positive',
                Account_State__c = 'Green', 
                Is_Customer_on_CAP__c = 'No',
                CAP_Title__c = 'NA',
                CAP_case_Number_Engagement_ID__c = 'CAP876445',
                CAP_Case_Opened_Date__c = Date.today(),
                CAP_case_Manager_Name__c = 'John Schroeder',
                Theater__c = 'AMER',
                Segment__c = 'US Commercial',
                GES_or_CGEM_Area__c = 'GES_South',
                Name = 'Archer-Daniels-Midlands (ADM)2',
                Active_Customer__c = 'yes',
                Date_Customer_first_became_CMS_Customer__c = Date.today(),
                Service_Transition_Date__c = Date.today(),
                Offer_Level__c = 'Foundation',
                //Who_Delivers_Service__c = 'Cisco',
                Reference_Account__c = 'No',
                Direct_Indirect_Sales__c = 'N/A - Cisco Direct',
                Contract_Renewal_Date__c = Date.today(),
                Device_Count__c = 1,
                SDM_Assigned__c = 'John',
                Manager__c = 'John',
                CMO_Assigned_for_Billing_Reporting__c = 'Martha Lercher',
                //key_contacts__c = 'Martha Lercher',
                CMO_Assigned_for_MSR__c = 'Martha Lercher',
                Partner_Delivered_CSM_Assigned__c = 'Brian Chapman',
                Number_of_Scheduled_Meetings_per_Week__c = 4,
                Number_of_Scheduled_Meetings_Per_Quarter__c = 4,
                Open_CONTRACT_CRs_Complex__c = 1,
                Open_CONTRACT_CRs_Simple__c = 1,
                Projects_On_going_Count__c = 1,
                Land__c = 'Customer Active',
                Adopt__c = 935,
                Delivery_NOC_Count__c = 46,
                Type_of_Transition__c = 'None',
                Platform_Count__c = 3,
                CMO_Billing_Effort__c = 20,
                CMO_MSR_Effort__c = 22,
                Expand__c = 20,
                Renew__c = 0,
                SLA__c = 'Yes',
                DID__c = '17160708',
                Links_to_Quote_Contract_SoW__c ='https://docs.cisco.com/share/page/site/nextgen-edcs/documentlibrary#filter=path%7C%2FCisco%2520Services%2FCisco%2520Maged%2520Services%2FCustomers%2FBaxter%2520Healthcare%2FBaxter%2520Doc%2520Exchange%2FBaxter%2520Contract%2520Information%7C&page=1',
                Upsell_Opportunities__c = 'Extended voice support',
                Margin_As_sold__c = 20,
                Annual_Revenue_FY_to_date__c = 123,
                Integrated_Account_Plan_IAP_Link__c = 'True',
                Margin_Delivered__c = 46,
                Renewal_Probability__c = 2,
                Contract_Term_Months__c = 23,
                Total_Other_Cisco_products_and_services__c = 2,
                Total_Cisco_Contract_Value__c = 123,
                Annual_CMS_Contract_Value__c = 123,
                Total_CMS_Contract_Value__c = 123);
            
            Insert crmdbtest;
            
            CRMDB__c crmdbChild = new CRMDB__c(
                Master_Customer_Name__c=crmdb.id,
                Last_MSR_Date_or_N_A__c = Date.today(),
                Last_QBR__c = Date.today(),
                Customer_Sentiment__c = 'Positive',
                Account_State__c = 'Green', 
                Is_Customer_on_CAP__c = 'No',
                CAP_Title__c = 'NA',
                CAP_case_Number_Engagement_ID__c = 'CAP876445',
                CAP_Case_Opened_Date__c = Date.today(),
                CAP_case_Manager_Name__c = 'John Schroeder',
                Theater__c = 'AMER',
                Segment__c = 'US Commercial',
                GES_or_CGEM_Area__c = 'GES_South',
                Name = 'Archer-Daniels-Midlands (ADM)3',
                Active_Customer__c = 'yes',
                Date_Customer_first_became_CMS_Customer__c = Date.today(),
                Service_Transition_Date__c = Date.today(),
                Offer_Level__c = 'Foundation',
                //Who_Delivers_Service__c = 'Cisco',
                Reference_Account__c = 'No',
                Direct_Indirect_Sales__c = 'N/A - Cisco Direct',
                Contract_Renewal_Date__c = Date.today(),
                Device_Count__c = 1,
                SDM_Assigned__c = 'John',
                Manager__c = 'John',
                CMO_Assigned_for_Billing_Reporting__c = 'Martha Lercher',
                //key_contacts__c = 'Martha Lercher',
                CMO_Assigned_for_MSR__c = 'Martha Lercher',
                Partner_Delivered_CSM_Assigned__c = 'Brian Chapman',
                Number_of_Scheduled_Meetings_per_Week__c = 4,
                Number_of_Scheduled_Meetings_Per_Quarter__c = 4,
                Open_CONTRACT_CRs_Complex__c = 1,
                Open_CONTRACT_CRs_Simple__c = 1,
                Projects_On_going_Count__c = 1,
                Land__c = 'Customer Active',
                Adopt__c = 935,
                Delivery_NOC_Count__c = 46,
                Type_of_Transition__c = 'None',
                Platform_Count__c = 3,
                CMO_Billing_Effort__c = 20,
                CMO_MSR_Effort__c = 22,
                Expand__c = 20,
                Renew__c = 0,
                SLA__c = 'Yes',
                DID__c = '17160708',
                Links_to_Quote_Contract_SoW__c ='https://docs.cisco.com/share/page/site/nextgen-edcs/documentlibrary#filter=path%7C%2FCisco%2520Services%2FCisco%2520Maged%2520Services%2FCustomers%2FBaxter%2520Healthcare%2FBaxter%2520Doc%2520Exchange%2FBaxter%2520Contract%2520Information%7C&page=1',
                Upsell_Opportunities__c = 'Extended voice support',
                Margin_As_sold__c = 20,
                Annual_Revenue_FY_to_date__c = 123,
                Integrated_Account_Plan_IAP_Link__c = 'True',
                Margin_Delivered__c = 46,
                Renewal_Probability__c = 2,
                Contract_Term_Months__c = 23,
                Total_Other_Cisco_products_and_services__c = 2,
                Total_Cisco_Contract_Value__c = 123,
                Annual_CMS_Contract_Value__c = 123,
                Total_CMS_Contract_Value__c = 123,
                Total_CMS_Contract_Value_CR_S__c = 123,
                Annual_CMS_Contract_Value_CR_S__c=123);
            upsert crmdbChild;
            //adding records to list
            List<CRMDB__c> oldList = new List<CRMDB__c>();
            oldList.add(crmdbChild);  
            crmdbChild.Total_CMS_Contract_Value_CR_S__c=111;
            crmdbChild.Annual_CMS_Contract_Value_CR_S__c=111;
            update crmdbChild;
            
            CRMDB__c crmdbChild22 = new CRMDB__c(
                Master_Customer_Name__c=crmdb.id,
                Last_MSR_Date_or_N_A__c = Date.today(),
                Last_QBR__c = Date.today(),
                Customer_Sentiment__c = 'Positive',
                Account_State__c = 'Green', 
                Is_Customer_on_CAP__c = 'No',
                CAP_Title__c = 'NA',
                CAP_case_Number_Engagement_ID__c = 'CAP876445',
                CAP_Case_Opened_Date__c = Date.today(),
                CAP_case_Manager_Name__c = 'John Schroeder',
                Theater__c = 'AMER',
                Segment__c = 'US Commercial',
                GES_or_CGEM_Area__c = 'GES_South',
                Name = 'Archer-Daniels-Midlands (ADM)4',
                Active_Customer__c = 'yes',
                Date_Customer_first_became_CMS_Customer__c = Date.today(),
                Service_Transition_Date__c = Date.today(),
                Offer_Level__c = 'Foundation',
                //Who_Delivers_Service__c = 'Cisco',
                Reference_Account__c = 'No',
                Direct_Indirect_Sales__c = 'N/A - Cisco Direct',
                Contract_Renewal_Date__c = Date.today(),
                Device_Count__c = 1,
                SDM_Assigned__c = 'John',
                Manager__c = 'John',
                CMO_Assigned_for_Billing_Reporting__c = 'Martha Lercher',
                //key_contacts__c = 'Martha Lercher',
                CMO_Assigned_for_MSR__c = 'Martha Lercher',
                Partner_Delivered_CSM_Assigned__c = 'Brian Chapman',
                Number_of_Scheduled_Meetings_per_Week__c = 4,
                Number_of_Scheduled_Meetings_Per_Quarter__c = 4,
                Open_CONTRACT_CRs_Complex__c = 1,
                Open_CONTRACT_CRs_Simple__c = 1,
                Projects_On_going_Count__c = 1,
                Land__c = 'Customer Active',
                Adopt__c = 935,
                Delivery_NOC_Count__c = 46,
                Type_of_Transition__c = 'None',
                Platform_Count__c = 3,
                CMO_Billing_Effort__c = 20,
                CMO_MSR_Effort__c = 22,
                Expand__c = 20,
                Renew__c = 0,
                SLA__c = 'Yes',
                DID__c = '17160708',
                Links_to_Quote_Contract_SoW__c ='https://docs.cisco.com/share/page/site/nextgen-edcs/documentlibrary#filter=path%7C%2FCisco%2520Services%2FCisco%2520Maged%2520Services%2FCustomers%2FBaxter%2520Healthcare%2FBaxter%2520Doc%2520Exchange%2FBaxter%2520Contract%2520Information%7C&page=1',
                Upsell_Opportunities__c = 'Extended voice support',
                Margin_As_sold__c = 20,
                Annual_Revenue_FY_to_date__c = 123,
                Integrated_Account_Plan_IAP_Link__c = 'True',
                Margin_Delivered__c = 46,
                Renewal_Probability__c = 2,
                Contract_Term_Months__c = 23,
                Total_Other_Cisco_products_and_services__c = 2,
                Total_Cisco_Contract_Value__c = 123,
                Annual_CMS_Contract_Value__c = 123,
                Total_CMS_Contract_Value__c = 123,
                Total_CMS_Contract_Value_CR_S__c= 1212,
                Annual_CMS_Contract_Value_CR_S__c=1212);
            
            insert crmdbChild22;
            //adding records to list
            List<CRMDB__c> newList  = new List<CRMDB__c>();
            newList.add(crmdbChild);
            //newList.add(crmdbChild22);
            //CRMDB_Helper.processAfterUpdate(oldList,newList);
            
            CRMDB__c crmdbChild23 = new CRMDB__c(
                Master_Customer_Name__c=crmdb.id,
                Last_MSR_Date_or_N_A__c = Date.today(),
                Last_QBR__c = Date.today(),
                Customer_Sentiment__c = 'Positive',
                Account_State__c = 'Green', 
                Is_Customer_on_CAP__c = 'No',
                CAP_Title__c = 'NA',
                CAP_case_Number_Engagement_ID__c = 'CAP876445',
                CAP_Case_Opened_Date__c = Date.today(),
                CAP_case_Manager_Name__c = 'John Schroeder',
                Theater__c = 'AMER',
                Segment__c = 'US Commercial',
                GES_or_CGEM_Area__c = 'GES_South',
                Name = 'Archer-Daniels-Midlands (ADM)4',
                Active_Customer__c = 'Yes',
                Date_Customer_first_became_CMS_Customer__c = Date.today(),
                Service_Transition_Date__c = Date.today(),
                Offer_Level__c = 'Foundation',
                //Who_Delivers_Service__c = 'Cisco',
                Reference_Account__c = 'No',
                Direct_Indirect_Sales__c = 'N/A - Cisco Direct',
                Contract_Renewal_Date__c = Date.today(),
                Device_Count__c = 1,
                SDM_Assigned__c = 'John',
                Manager__c = 'John',
                CMO_Assigned_for_Billing_Reporting__c = 'Martha Lercher',
                //key_contacts__c = 'Martha Lercher',
                CMO_Assigned_for_MSR__c = 'Martha Lercher',
                Partner_Delivered_CSM_Assigned__c = 'Brian Chapman',
                Number_of_Scheduled_Meetings_per_Week__c = 4,
                Number_of_Scheduled_Meetings_Per_Quarter__c = 4,
                Open_CONTRACT_CRs_Complex__c = 1,
                Open_CONTRACT_CRs_Simple__c = 1,
                Projects_On_going_Count__c = 1,
                Land__c = 'Customer Active',
                Adopt__c = 935,
                Delivery_NOC_Count__c = 46,
                Type_of_Transition__c = 'None',
                Platform_Count__c = 3,
                CMO_Billing_Effort__c = 20,
                CMO_MSR_Effort__c = 22,
                Expand__c = 20,
                Renew__c = 0,
                SLA__c = 'Yes',
                DID__c = '17160708',
                Links_to_Quote_Contract_SoW__c ='https://docs.cisco.com/share/page/site/nextgen-edcs/documentlibrary#filter=path%7C%2FCisco%2520Services%2FCisco%2520Maged%2520Services%2FCustomers%2FBaxter%2520Healthcare%2FBaxter%2520Doc%2520Exchange%2FBaxter%2520Contract%2520Information%7C&page=1',
                Upsell_Opportunities__c = 'Extended voice support',
                Margin_As_sold__c = 20,
                Annual_Revenue_FY_to_date__c = 123,
                Integrated_Account_Plan_IAP_Link__c = 'True',
                Margin_Delivered__c = 46,
                Renewal_Probability__c = 2,
                Contract_Term_Months__c = 23,
                Total_Other_Cisco_products_and_services__c = 2,
                Total_Cisco_Contract_Value__c = 123,
                Annual_CMS_Contract_Value__c = 123,
                Total_CMS_Contract_Value__c = 123,
                Total_CMS_Contract_Value_CR_S__c= 0,
                Annual_CMS_Contract_Value_CR_S__c=0);
            
            insert crmdbChild23;
            List<CRMDB__c> newList1  = new List<CRMDB__c>();
            newList.add(crmdbChild23);
            //CRMDB_Helper.processAfterInsert(newList1);
            //CRMDB_Helper.CRMDB_ValidateChildCap(oldList,newList);
            crmdbChild22.Master_Customer_Name__c =  crmdbtest.id;
            update crmdbChild22;
            newList.add(crmdbChild22);  
            // CRMDB_Helper.processAfterUpdate(oldList,newList);
            CRMDB__c crmdb1 = new CRMDB__c(
                Last_MSR_Date_or_N_A__c = Date.today(),
                Last_QBR__c = Date.today(),
                Customer_Sentiment__c = 'Positive',
                Account_State__c = 'Green', 
                Is_Customer_on_CAP__c = 'No',
                CAP_Title__c = 'NA',
                CAP_case_Number_Engagement_ID__c = 'CAP876445',
                CAP_Case_Opened_Date__c = Date.today(),
                CAP_case_Manager_Name__c = 'John Schroeder',
                Theater__c = 'AMER',
                Segment__c = 'US Commercial',
                GES_or_CGEM_Area__c = 'GES_South',
                Name = 'Archer-Daniels-Midlands (ADM) 1',
                Active_Customer__c = 'yes',
                Date_Customer_first_became_CMS_Customer__c = Date.today(),
                Service_Transition_Date__c = Date.today(),
                Offer_Level__c = 'Foundation',
                //Who_Delivers_Service__c = 'Cisco',
                Reference_Account__c = 'No',
                Direct_Indirect_Sales__c = 'N/A - Cisco Direct',
                Contract_Renewal_Date__c = Date.today(),
                Device_Count__c = 1,
                SDM_Assigned__c = 'John',
                Manager__c = 'John',
                CMO_Assigned_for_Billing_Reporting__c = 'Martha Lercher',
                //key_contacts__c = 'Martha Lercher',
                CMO_Assigned_for_MSR__c = 'Martha Lercher',
                Partner_Delivered_CSM_Assigned__c = 'Brian Chapman',
                Number_of_Scheduled_Meetings_per_Week__c = 4,
                Number_of_Scheduled_Meetings_Per_Quarter__c = 4,
                Open_CONTRACT_CRs_Complex__c = 1,
                Open_CONTRACT_CRs_Simple__c = 1,
                Projects_On_going_Count__c = 1,
                Land__c = 'Customer Active',
                Adopt__c = 935,
                Delivery_NOC_Count__c = 46,
                Type_of_Transition__c = 'None',
                Platform_Count__c = 3,
                CMO_Billing_Effort__c = 20,
                CMO_MSR_Effort__c = 22,
                Expand__c = 20,
                Renew__c = 0,
                SLA__c = 'Yes',
                DID__c = '17160708',
                Links_to_Quote_Contract_SoW__c ='https://docs.cisco.com/share/page/site/nextgen-edcs/documentlibrary#filter=path%7C%2FCisco%2520Services%2FCisco%2520Maged%2520Services%2FCustomers%2FBaxter%2520Healthcare%2FBaxter%2520Doc%2520Exchange%2FBaxter%2520Contract%2520Information%7C&page=1',
                Upsell_Opportunities__c = 'Extended voice support',
                Margin_As_sold__c = 20,
                Annual_Revenue_FY_to_date__c = 123,
                Integrated_Account_Plan_IAP_Link__c = 'True',
                Margin_Delivered__c = 46,
                Renewal_Probability__c = 2,
                Contract_Term_Months__c = 23,
                Total_Other_Cisco_products_and_services__c = 2,
                Total_Cisco_Contract_Value__c = 123,
                Annual_CMS_Contract_Value__c = 123,
                Total_CMS_Contract_Value__c = 123);
            
            CRMDB__c crmdb1Child = new CRMDB__c(
                Master_Customer_Name__c=crmdb1.id,
                Last_MSR_Date_or_N_A__c = Date.today(),
                Last_QBR__c = Date.today(),
                Customer_Sentiment__c = 'Positive',
                Account_State__c = 'Green', 
                Is_Customer_on_CAP__c = 'No',
                CAP_Title__c = 'NA',
                CAP_case_Number_Engagement_ID__c = 'CAP876445',
                CAP_Case_Opened_Date__c = Date.today(),
                CAP_case_Manager_Name__c = 'John Schroeder',
                Theater__c = 'AMER',
                Segment__c = 'US Commercial',
                GES_or_CGEM_Area__c = 'GES_South',
                Name = 'Archer-Daniels-Midlands (ADM)',
                Active_Customer__c = 'yes',
                Date_Customer_first_became_CMS_Customer__c = Date.today(),
                Service_Transition_Date__c = Date.today(),
                Offer_Level__c = 'Foundation',
                //Who_Delivers_Service__c = 'Cisco',
                Reference_Account__c = 'No',
                Direct_Indirect_Sales__c = 'N/A - Cisco Direct',
                Contract_Renewal_Date__c = Date.today(),
                Device_Count__c = 1,
                SDM_Assigned__c = 'John',
                Manager__c = 'John',
                CMO_Assigned_for_Billing_Reporting__c = 'Martha Lercher',
                //key_contacts__c = 'Martha Lercher',
                CMO_Assigned_for_MSR__c = 'Martha Lercher',
                Partner_Delivered_CSM_Assigned__c = 'Brian Chapman',
                Number_of_Scheduled_Meetings_per_Week__c = 4,
                Number_of_Scheduled_Meetings_Per_Quarter__c = 4,
                Open_CONTRACT_CRs_Complex__c = 1,
                Open_CONTRACT_CRs_Simple__c = 1,
                Projects_On_going_Count__c = 1,
                Land__c = 'Customer Active',
                Adopt__c = 935,
                Delivery_NOC_Count__c = 46,
                Type_of_Transition__c = 'None',
                Platform_Count__c = 3,
                CMO_Billing_Effort__c = 20,
                CMO_MSR_Effort__c = 22,
                Expand__c = 20,
                Renew__c = 0,
                SLA__c = 'Yes',
                DID__c = '17160708',
                Links_to_Quote_Contract_SoW__c ='https://docs.cisco.com/share/page/site/nextgen-edcs/documentlibrary#filter=path%7C%2FCisco%2520Services%2FCisco%2520Maged%2520Services%2FCustomers%2FBaxter%2520Healthcare%2FBaxter%2520Doc%2520Exchange%2FBaxter%2520Contract%2520Information%7C&page=1',
                Upsell_Opportunities__c = 'Extended voice support',
                Margin_As_sold__c = 20,
                Annual_Revenue_FY_to_date__c = 123,
                Integrated_Account_Plan_IAP_Link__c = 'True',
                Margin_Delivered__c = 46,
                Renewal_Probability__c = 2,
                Contract_Term_Months__c = 23,
                Total_Other_Cisco_products_and_services__c = 2,
                Total_Cisco_Contract_Value__c = 123,
                Annual_CMS_Contract_Value__c = 123,
                Total_CMS_Contract_Value__c = 123);
            List<ID> ListID= new List<ID>();            
            
            //  Insert crmdbChild;
            
            Insert crmdb1;
            List<CRMDB__c> CRMDBlistP= new List<CRMDB__C>();
            CRMDBlistP.add(crmdb1);
            List<CRMDB__c> CRMDBlistC= new List<CRMDB__C>();
            CRMDBlistC.add(crmdbChild);
            CRMDBlistC.add(crmdbChild22);
            
            system.debug('CRMDB Record created' + crmdb);
            Map <ID,CRMDB__c> recordListOldMap = new Map <ID,CRMDB__c>();
            recordListOldMap.put(crmdb.Id,crmdb);
            
            Qualification__c Q= new Qualification__c(Name='Test', Contract_Duration__c='1',
                                                     Total_Committed_Contract_Value_TCCV_000__c =123,
                                                     CMS_Pursuit_Type__c='Change Request', Qualification_Forecast_Status__c='Booked',
                                                     recordTypeId='012800000003c7X',Focus_Pursuit__c = 'Yes',Solution_Delivery__c= date.today(),
                                                     Engaged_Team_s__c='CMS', Architecture__c= 'Cloud', Customer_Vision__c = 'Test',
                                                     Theater__c='Americas-Canada ',Contract_Year_1_Revenue__c=1, CRMDB__c= crmdb.id);
            
            try {
                Insert Q;
                system.debug('Qualification created');
            } catch(DmlException e) {
                System.debug('The following exception has occurred: ' + e.getMessage());
            }
            
            Qualification__c Q1= [SELECT ID,CRMDB__c from Qualification__c Where Id=:Q.Id  ];     
            Q1.CRMDB__c = crmdb1.id ; 
            Update Q1;
            
            Map <ID,Qualification__c> recordListOldMapQ = new Map <ID,Qualification__c>();
            Map<Id,CRMDB__c> recMap = new  Map<Id,CRMDB__c>();
            recordListOldMapQ.put(Q1.Id,Q1);
            
            
            Test.StartTest(); 
            try{system.debug('Parent >>' +crmdb);
                CRMDB_Helper a = new CRMDB_Helper();
                list <CRMDB__c> recordNew = new List<CRMDB__c>();
                list<CRMDB__c> C1=new List<CRMDB__c>();
                C1.add(crmdbChild22);
                system.debug('Child C1 >>' +C1);
                Insert C1;
                list<CRMDB__c>C2=new List<CRMDB__c>();
                C2.add(crmdbChild);
                
                system.debug('parentUpdate>>>>>>>>>>> >>' +parentUpdate);
                Insert C2;
                recMap.put(crmdbChild.Id,crmdbChild);
                
                crmdbChild22.Master_Customer_Name__c =  crmdb.id;
                update crmdbChild22;
                c1.add(crmdbChild22);  
                //CRMDB_Helper.CRMDB_ValidateChildCap(c1,c2);
                CRMDB_Helper.parentUpdate = false;
                list <Qualification__c> recordNewQ = new List<Qualification__c>();
                recordNew.add(crmdb);
                recordNewQ.add(Q);
                //QualificationTriggerHandler QQ= new QualificationTriggerHandler();
                //QualificationTriggerHandler.ChangeRequestFieldUpdate(recordNewQ,recordListOldMapQ);
                
               }catch(exception e){}
            Test.StopTest(); 
            system.debug('parentUpdate>>>>>>>>>>> >>' +parentUpdate);
            
            
        }
    }
    
    static testMethod void testData(){
        Boolean parentUpdate = false;
        User admin = CEE_TestUtility.getUser('admin', true);
        List<PermissionSetAssignment> permissionSetList = new List<PermissionSetAssignment>();        
        for(PermissionSet ps : [SELECT Id,Name FROM PermissionSet WHERE Name = 'CRMDB_CMO' OR Name = 'customerDetailPermission']) {
            PermissionSetAssignment psa = new PermissionSetAssignment (PermissionSetId = ps.Id, AssigneeId = admin.Id);
            
            permissionSetList.add(psa);
        }        
        upsert permissionSetList;
        system.debug('permissionSetList'+permissionSetList);
        system.Runas(admin) {
            Org_Constant_CS__c testCust = new Org_Constant_CS__c();
            testCust.Name = 'CRMDBPermissionSets';
            testCust.Non_Production_Value__c ='0PS1b0000004e8z,0PS1b0000004e90';
            testCust.Production_Value__c ='0PS1b0000004e8z,0PS1b0000004e90';
            insert testCust;
            CRMDB__c crmdb = new CRMDB__c(
                Last_MSR_Date_or_N_A__c = Date.today(),
                Last_QBR__c = Date.today(),
                Customer_Sentiment__c = 'Positive',
                Account_State__c = 'Green', 
                Is_Customer_on_CAP__c = 'No',
                CAP_Title__c = 'NA',
                CAP_case_Number_Engagement_ID__c = 'CAP876445',
                CAP_Case_Opened_Date__c = Date.today(),
                CAP_case_Manager_Name__c = 'John Schroeder',
                Theater__c = 'AMER',
                Segment__c = 'US Commercial',
                GES_or_CGEM_Area__c = 'GES_South',
                Name = 'Archer-Daniels-Midlands (ADM)',
                Active_Customer__c = 'Yes',
                Date_Customer_first_became_CMS_Customer__c = Date.today(),
                Service_Transition_Date__c = Date.today(),
                Offer_Level__c = 'Foundation',
                //Who_Delivers_Service__c = 'Cisco',
                Reference_Account__c = 'No',
                Direct_Indirect_Sales__c = 'N/A - Cisco Direct',
                Contract_Renewal_Date__c = Date.today(),
                Device_Count__c = 1,
                SDM_Assigned__c = 'John',
                Manager__c = 'John',
                CMO_Assigned_for_Billing_Reporting__c = 'Martha Lercher',
                //key_contacts__c = 'Martha Lercher',
                CMO_Assigned_for_MSR__c = 'Martha Lercher',
                Partner_Delivered_CSM_Assigned__c = 'Brian Chapman',
                Number_of_Scheduled_Meetings_per_Week__c = 4,
                Number_of_Scheduled_Meetings_Per_Quarter__c = 4,
                Open_CONTRACT_CRs_Complex__c = 1,
                Open_CONTRACT_CRs_Simple__c = 1,
                Projects_On_going_Count__c = 1,
                Land__c = 'Customer Active',
                Adopt__c = 935,
                Delivery_NOC_Count__c = 46,
                Type_of_Transition__c = 'None',
                Platform_Count__c = 3,
                CMO_Billing_Effort__c = 20,
                CMO_MSR_Effort__c = 22,
                Expand__c = 20,
                Renew__c = 0,
                SLA__c = 'Yes',
                DID__c = '17160708',
                Links_to_Quote_Contract_SoW__c ='https://docs.cisco.com/share/page/site/nextgen-edcs/documentlibrary#filter=path%7C%2FCisco%2520Services%2FCisco%2520Maged%2520Services%2FCustomers%2FBaxter%2520Healthcare%2FBaxter%2520Doc%2520Exchange%2FBaxter%2520Contract%2520Information%7C&page=1',
                Upsell_Opportunities__c = 'Extended voice support',
                Margin_As_sold__c = 20,
                Annual_Revenue_FY_to_date__c = 123,
                Integrated_Account_Plan_IAP_Link__c = 'True',
                Margin_Delivered__c = 46,
                Renewal_Probability__c = 2,
                Contract_Term_Months__c = 23,
                Total_Other_Cisco_products_and_services__c = 2,
                Total_Cisco_Contract_Value__c = 123,
                Annual_CMS_Contract_Value__c = 123,
                Total_CMS_Contract_Value__c = 123);
            Insert crmdb;
            CRMDB__c crmdbChild23 = new CRMDB__c(
                Master_Customer_Name__c=crmdb.id,
                Last_MSR_Date_or_N_A__c = Date.today(),
                Last_QBR__c = Date.today(),
                Customer_Sentiment__c = 'Positive',
                Account_State__c = 'Green', 
                Is_Customer_on_CAP__c = 'No',
                CAP_Title__c = 'NA',
                CAP_case_Number_Engagement_ID__c = 'CAP876445',
                CAP_Case_Opened_Date__c = Date.today(),
                CAP_case_Manager_Name__c = 'John Schroeder',
                Theater__c = 'AMER',
                Segment__c = 'US Commercial',
                GES_or_CGEM_Area__c = 'GES_South',
                Name = 'Archer-Daniels-Midlands (ADM) 1',
                Active_Customer__c = 'No-pending activation',
                Date_Customer_first_became_CMS_Customer__c = Date.today(),
                Service_Transition_Date__c = Date.today(),
                Offer_Level__c = 'Foundation',
                //Who_Delivers_Service__c = 'Cisco',
                Reference_Account__c = 'No',
                Direct_Indirect_Sales__c = 'N/A - Cisco Direct',
                Contract_Renewal_Date__c = Date.today(),
                Device_Count__c = 1,
                SDM_Assigned__c = 'John',
                Manager__c = 'John',
                CMO_Assigned_for_Billing_Reporting__c = 'Martha Lercher',
                //key_contacts__c = 'Martha Lercher',
                CMO_Assigned_for_MSR__c = 'Martha Lercher',
                Partner_Delivered_CSM_Assigned__c = 'Brian Chapman',
                Number_of_Scheduled_Meetings_per_Week__c = 4,
                Number_of_Scheduled_Meetings_Per_Quarter__c = 4,
                Open_CONTRACT_CRs_Complex__c = 1,
                Open_CONTRACT_CRs_Simple__c = 1,
                Projects_On_going_Count__c = 1,
                Land__c = 'Customer Active',
                Adopt__c = 935,
                Delivery_NOC_Count__c = 46,
                Type_of_Transition__c = 'None',
                Platform_Count__c = 3,
                CMO_Billing_Effort__c = 20,
                CMO_MSR_Effort__c = 22,
                Expand__c = 20,
                Renew__c = 0,
                SLA__c = 'Yes',
                DID__c = '17160708',
                Links_to_Quote_Contract_SoW__c ='https://docs.cisco.com/share/page/site/nextgen-edcs/documentlibrary#filter=path%7C%2FCisco%2520Services%2FCisco%2520Maged%2520Services%2FCustomers%2FBaxter%2520Healthcare%2FBaxter%2520Doc%2520Exchange%2FBaxter%2520Contract%2520Information%7C&page=1',
                Upsell_Opportunities__c = 'Extended voice support',
                Margin_As_sold__c = 20,
                Annual_Revenue_FY_to_date__c = 123,
                Integrated_Account_Plan_IAP_Link__c = 'True',
                Margin_Delivered__c = 46,
                Renewal_Probability__c = 2,
                Contract_Term_Months__c = 23,
                Total_Other_Cisco_products_and_services__c = 2,
                Total_Cisco_Contract_Value__c = 123,
                Annual_CMS_Contract_Value__c = 123,
                Total_CMS_Contract_Value__c = 123,
                Total_CMS_Contract_Value_CR_S__c= 0,
                Annual_CMS_Contract_Value_CR_S__c=0);
            insert crmdbChild23;
            
            
            test.startTest();
            list <CRMDB__c> CRMDBList = new List<CRMDB__c>();
            CRMDBList.add(crmdb);
            Map<Id,CRMDB__c> recMap = new Map<Id,CRMDB__c>();
            recMap.put(crmdb.Id,crmdb);
            list <CRMDB__c> OldCRMDBList = new List<CRMDB__c>();
            OldCRMDBList.add(crmdbChild23);
            
            Org_Constant_CS__c test1 = new Org_Constant_CS__c();
            test1.Name = 'CRMDB Trigger Skip';
            test1.Non_Production_Value__c='No';
            test1.Production_Value__c ='No';
            insert test1;
            CRMDB_Helper.totalandAnnualContractValidation(CRMDBList,recMap);
            
            Map<Id,CRMDB__c>oldRecMap = new Map<Id,CRMDB__c>();
            //oldRecMap.put(crmdb.id,crmdb);
           List<CRMDB__c>newRecList = new List<CRMDB__c>();
            newRecList.add(crmdbChild23);
            oldRecMap.put(crmdbChild23.id,crmdbChild23);
            CRMDB_Helper.qualificationUpdate(oldRecMap,newRecList);
            crmdb.Active_Customer__c = 'No – Contract Expired (Other Active CMS Contracts)';
            update crmdb;
            
            
            
            CRMDB_Helper.qualificationUpdate(oldRecMap,newRecList);
            test.stopTest();
        }
    }
}