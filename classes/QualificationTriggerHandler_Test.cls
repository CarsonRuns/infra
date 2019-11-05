@isTest
public class QualificationTriggerHandler_Test {
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
            
            CRMDB__c crmdbChild = new CRMDB__c(
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
            insert  crmdbChild;
             CRMDB__c crmdbChild1 = new CRMDB__c(
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
            insert  crmdbChild1;
            Qualification__c Q= new Qualification__c(Name='Test', Contract_Duration__c='1',
                                                     Total_Committed_Contract_Value_TCCV_000__c =123,
                                                     CMS_Pursuit_Type__c='Change Request', Qualification_Forecast_Status__c='Booked',
                                                     recordTypeId='012800000003c7X',Focus_Pursuit__c = 'Yes',Solution_Delivery__c= date.today(),
                                                     Engaged_Team_s__c='CMS', Architecture__c= 'Cloud', Customer_Vision__c = 'Test',
                                                     Theater__c='Americas-Canada ',Contract_Year_1_Revenue__c=1, CRMDB__c= crmdb.id);
            
            Insert Q;
            
            system.debug('Qualification created'+Q.CRMDB__C);
            //system.debug('Qualification created'+Q1.CRMDB__C);
            Map <ID,Qualification__c> recordListOldMapQ = new Map <ID,Qualification__c>();
            Q.CRMDB__c = crmdbChild1.ID;
                update Q;
            recordListOldMapQ.put(Q.Id,Q);
            system.debug('recordListOldMapQ'+recordListOldMapQ);
            list <Qualification__c> recordNewQ = new List<Qualification__c>();
            recordNewQ.add(Q);
            system.debug('recordNewQ'+recordNewQ);
            List<ID> oldCrmdbIDs = new List<ID>();
            List<ID> newCrmdbIDs = new List<ID>();
            oldCrmdbIDs.add(crmdbChild.Id);
            newCrmdbIDs.add(crmdbChild.Id);  
            List<CRMDB__c> oldCrmdLst = new List<CRMDB__c>();
            List<CRMDB__c> newCrmdLst = new List<CRMDB__c>();
            oldCrmdLst.add(crmdbChild);
            newCrmdLst.add(crmdbChild); 
            Test.StartTest(); 
            try{
                QualificationTriggerHandler QQ= new QualificationTriggerHandler();
                QualificationTriggerHandler.ChangeRequestFieldUpdate(recordNewQ,recordListOldMapQ);
                Q.CRMDB__c = crmdbChild.ID;
                update Q;
                recordListOldMapQ.put(Q.ID,Q);
                QualificationTriggerHandler.ChangeRequestFieldUpdate(recordNewQ,recordListOldMapQ);
                
            }catch(exception e){
                system.debug('error'+e.getStackTraceString());
                system.debug('error1'+e.getLineNumber());
                system.debug('error2'+e.getMessage());
            }
            Test.StopTest();  
        }
        
    }
    
    
}