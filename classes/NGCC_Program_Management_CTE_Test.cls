@isTest(SeeAllData = True)
public class NGCC_Program_Management_CTE_Test {
    
    // Campaign Related List Functionality
    
    public static testMethod void NGCC_Prog_Mgmt_Camp_Pve_Test() {
        List < Lead > lstLead = new List < Lead > ();
        String mktgLeadRecType;
        ObjectRecordTypeIds__c orgConstant = ObjectRecordTypeIds__c.getInstance();    // initiate custom setting contain object record type
        mktgLeadRecType = orgConstant.Marketing_Lead_RecordType__c;                   // assign marketing lead recordtype to variable
        
        User uSMgr = NGCC_CallScript_Data_Test.testSMUser();
        User uSDR = NGCC_CallScript_Data_Test.testSDRUser('sdr1@cisco.com.reg');
        
        System.runAs(uSMgr) {
            Campaign c= new Campaign(Name='Campaign1',Program_Event_Name__c='ProgramEvent',Program_Event_Code__c='000001',Program_Originating_Country__c='UNITED STATES');
            insert c;
            for (integer i = 0; i < 5; i++) {
                lstLead.add(new Lead(FirstName = 'TestUser' + i, LastName = 'Lead', Company = 'ABC' + i,RecordTypeId=mktgLeadRecType,Campaign_Name__c=c.id));
            }
            insert lstLead;
            
            Test.startTest();
            Test.setCurrentPageReference(New PageReference('Page.NGCC_ProgramEventAssignSDR'));                
            ApexPages.StandardController stdCtlCamp = New ApexPages.StandardController(c);    
            NGCC_Program_Event_Assign_SDR_CTE  setContCamp = new NGCC_Program_Event_Assign_SDR_CTE(stdCtlCamp );
            setContCamp.getValidateUser();
            setContCamp.refreshData();
            setContCamp.getLeads();
            setContCamp.txtOwnersName = uSDR.Id;
            setContCamp.leadList = setContCamp.getLeads();
            setContCamp.leadList[0].Selected = true;
            
            setContCamp.getSelected();
            setContCamp.filterListView = 'Unassigned';
            setContCamp.refreshData();
            setContCamp.txtOwnersName='000000000000000';
            setContCamp.getSelected();
            
            
            System.runAs(uSDR) {
                Test.setCurrentPageReference(New PageReference('Page.NGCC_ProgramEventAssignSDR'));                
                ApexPages.StandardController stdCtlCampSDR = New ApexPages.StandardController(c);    
                NGCC_Program_Event_Assign_SDR_CTE setContCampSDR = new NGCC_Program_Event_Assign_SDR_CTE(stdCtlCampSDR);
                setContCampSDR.getValidateUser();
                
                Test.setCurrentPageReference(New PageReference('Page.NGCC_Items_to_Approve'));      
                NGCC_Items_To_Approve_CTL controller = new NGCC_Items_To_Approve_CTL();
                controller.getValidateUser();
                controller.getApprovalRecord();
                controller.getRejectedRecord();                     
            }  
            Test.stopTest();
        }
    }
    
    public static testMethod void NGCC_Prog_Mgmt_Camp_Nve_Test() {
        Campaign c= new Campaign(Name='Campaign1',Program_Event_Name__c='ProgramEvent',Program_Event_Code__c='000001');
        insert c;
        Test.setCurrentPageReference(New PageReference('Page.NGCC_ProgramEventAssignSDR'));                
        ApexPages.StandardController stdCtlCampSDR = New ApexPages.StandardController(c);    
        NGCC_Program_Event_Assign_SDR_CTE setContCampSDR = new NGCC_Program_Event_Assign_SDR_CTE(stdCtlCampSDR);
        setContCampSDR.getValidateUser();    
    }
    public static testMethod void NGCC_Program_Event_Unassigned_Test() {
        Campaign c= new Campaign(Name='Campaign1',Program_Event_Name__c='ProgramEvent',Program_Event_Code__c='000001');
        insert c;
        Test.setCurrentPageReference(New PageReference('Page.NGCC_ProgramEventAssignSDR'));                
        ApexPages.StandardController stdCtlCampSDR = New ApexPages.StandardController(c);    
        NGCC_Program_Event_Assign_SDR_CTE setContCampSDR = new NGCC_Program_Event_Assign_SDR_CTE(stdCtlCampSDR);
        setContCampSDR.filterListView = 'Unassigned';
        setContCampSDR.query = true;
        setContCampSDR.getValidateUser();    
    }

    
}