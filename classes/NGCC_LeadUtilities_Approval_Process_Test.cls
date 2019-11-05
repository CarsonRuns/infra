@isTest(SeeAllData = true)
public class NGCC_LeadUtilities_Approval_Process_Test {

    public static testMethod void NGCC_LeadUtilities_Approve_Test() {
        User uSDR = NGCC_CallScript_Data_Test.testSDRUser('sdr8@cisco.com.reg');
        User uSMR = NGCC_CallScript_Data_Test.testSMUser();                              
        System.runAs(uSDR) {
             Lead lstLead= NGCC_CallScript_Data_Test.testLead(); 
             lstLead.QATimeFrame__c = '4 - 6 Months';
             lstLead.QABudget__c = '$5000 - $14,999';
             lstLead.Project_Flag__c = 'Yes';
             lstLead.Appointment_Type__c ='BANT';
             lstLead.Call_Status__c = 'Call Completed';
             lstLead.Outcome__c = 'Qualified Lead';  // changed from Contacted to Qualified Lead by gchaitha
             lstLead.Theater__c ='Americas';
             lstLead.MODS_Contact__c = 6508892910.21;
             lstLead.Is_Call_Script_Executed__c=true;
             update lstLead;
             Lead lstUpdatedLead = [Select Id,Theater__c,Status from Lead where Id=: lstLead.Id];
             
             System.assertEquals('Americas', lstUpdatedLead.Theater__c); 
             System.assertEquals('Marketing Qualified', lstUpdatedLead.Status);
             Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
             req1.setComments('Submitting request for approval.');
             req1.setObjectId(lstUpdatedLead.id); 
             Approval.ProcessResult result = Approval.process(req1);
            
            // Verify the result
            System.assert(result.isSuccess());
            
            System.assertEquals(
                'Pending', result.getInstanceStatus(), 
                'Instance Status'+result.getInstanceStatus());           
         
        
        }
            
        System.runAs(uSMR ) {     
            Lead lstLead = [Select Id,Theater__c,Status from Lead where MODS_Contact__c = 6508892910.21];
             Test.setCurrentPageReference(New PageReference('Page.NGCC_LeadUtitlities'));
             ApexPages.StandardController stdCtlLead = New ApexPages.StandardController(lstLead );      
             
             NGCC_LeadUtitlities_CTE ngccUtilities = new NGCC_LeadUtitlities_CTE(stdCtlLead);
            
                Test.startTest();   
                    ngccUtilities.cmdSubmitForApproval();
                    ngccUtilities.approvalNeeded();                
                    ngccUtilities.cmdApprove();
                    ngccUtilities.cmdSendToSales();
                    
                    Test.setCurrentPageReference(New PageReference('Page.NGCC_Items_to_Approve'));      
                    NGCC_Items_To_Approve_CTL controller = new NGCC_Items_To_Approve_CTL();
                    controller.getValidateUser();
                    controller.getApprovalRecord();
                    controller.getRejectedRecord();
                Test.stopTest(); 
       }           
    }
    
    public static testMethod void NGCC_LeadUtilities_Reject_Test() {
        User uSDR = NGCC_CallScript_Data_Test.testSDRUser('sdr8@cisco.com.reg');
        User uSMR = NGCC_CallScript_Data_Test.testSMUser();                              
        System.runAs(uSDR) {
             Lead lstLead= NGCC_CallScript_Data_Test.testLead(); 
             lstLead.QATimeFrame__c = '4 - 6 Months';
             lstLead.QABudget__c = '$5000 - $14,999';
             lstLead.Project_Flag__c = 'Yes';
             lstLead.Appointment_Type__c ='BANT';
             lstLead.Call_Status__c = 'Call Completed'; 
             lstLead.Outcome__c = 'Qualified Lead'; // changed from Contacted to Qualified Lead by gchaitha
             lstLead.Theater__c ='Americas';
             lstLead.MODS_Contact__c = 6508892910.21;
             lstLead.Is_Call_Script_Executed__c=true;
             update lstLead;
             Lead lstUpdatedLead = [Select Id,Theater__c,Status from Lead where Id=: lstLead.Id];
             
             System.assertEquals('Americas', lstUpdatedLead.Theater__c); 
             //System.assertEquals('Marketing Qualified', lstUpdatedLead.Status);
             Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
             req1.setComments('Submitting request for approval.');
             req1.setObjectId(lstUpdatedLead.id); 
             Approval.ProcessResult result = Approval.process(req1);
        
            // Verify the result
            System.assert(result.isSuccess());
            
            System.assertEquals(
                'Pending', result.getInstanceStatus(), 
                'Instance Status'+result.getInstanceStatus());           
         
        
        }
            
        System.runAs(uSMR ) {     
            Lead lstLead = [Select Id,Theater__c,Status from Lead where MODS_Contact__c = 6508892910.21];
             Test.setCurrentPageReference(New PageReference('Page.NGCC_LeadUtitlities'));
             ApexPages.StandardController stdCtlLead = New ApexPages.StandardController(lstLead );       
             
             NGCC_LeadUtitlities_CTE ngccUtilities = new NGCC_LeadUtitlities_CTE(stdCtlLead);
                Test.startTest();   
                    ngccUtilities.approvalNeeded();                
                    ngccUtilities.cmdReject();
                    ngccUtilities.rejectReason = 'No valid';
                    ngccUtilities.processApprovalRejected();
                    ngccUtilities.cmdRequalify();
                Test.stopTest(); 
       }           
    }
    
    public static testMethod void NGCC_LeadUtilities_EMEAR_Approve_Test() {
        User uSDR = NGCC_CallScript_Data_Test.testSDRUser('sdr8@cisco.com.reg');
        User uSMR = NGCC_CallScript_Data_Test.testSMUser();                              
        System.runAs(uSDR) {
             Lead lstLead= NGCC_CallScript_Data_Test.testLead(); 
             lstLead.QATimeFrame__c = '4 - 6 Months';
             lstLead.QABudget__c = '$5000 - $14,999';
             lstLead.Project_Flag__c = 'Yes';
             lstLead.Appointment_Type__c ='BANT';
             lstLead.Call_Status__c = 'Call Completed';
             lstLead.Outcome__c = 'Qualified Lead'; // changed from Contacted to Qualified Lead by gchaitha
             lstLead.Theater__c ='EMEAR';
             lstLead.CustomCountry__c = 'UNITED KINGDOM';
             lstLead.MODS_Contact__c = 6508892910.2113;
             lstLead.Is_Call_Script_Executed__c=true;
             update lstLead;
             Lead lstUpdatedLead = [Select Id,Theater__c,Status from Lead where Id=: lstLead.Id];
             
             System.assertEquals('EMEAR', lstUpdatedLead.Theater__c); 
             //System.assertEquals('Marketing Qualified', lstUpdatedLead.Status);
             Approval.ProcessSubmitRequest req1 = new Approval.ProcessSubmitRequest();
             req1.setComments('Submitting request for approval.');
             req1.setObjectId(lstUpdatedLead.id); 
             req1.setNextApproverIds(new Id[] {UserInfo.getUserId()});
             Approval.ProcessResult result = Approval.process(req1);
            
            // Verify the result
            //System.assert(result.isSuccess());            
            //System.assertEquals('Pending', result.getInstanceStatus(),'Instance Status'+result.getInstanceStatus());           
         
        
        }
            
        System.runAs(uSMR ) {     
            Lead lstLead = [Select Id,Theater__c,Status from Lead where MODS_Contact__c = 6508892910.2113];
             Test.setCurrentPageReference(New PageReference('Page.NGCC_LeadUtitlities'));
             ApexPages.StandardController stdCtlLead = New ApexPages.StandardController(lstLead );       
             
             NGCC_LeadUtitlities_CTE ngccUtilities = new NGCC_LeadUtitlities_CTE(stdCtlLead);
                Test.startTest();   
                    ngccUtilities.cmdSubmitForApproval();
                    ngccUtilities.approvalNeeded();    
                    ngccUtilities.cmdApprove();
                    ngccUtilities.nextApproval = UserInfo.getUserId();            
                    ngccUtilities.processApprovalEMEAR();
                   // ngccUtilities.cmdSendToSales();
                Test.stopTest(); 
       }           
    }
}