@isTest(SeeAllData = true)
public class NGCC_CreateBulkResponseController_Test {

    public static testMethod void NGCC_BulkResponseController_PositiveTest() {
        User uSDR = NGCC_CallScript_Data_Test.testSDRUser('sdr7@cisco.com.reg');
                          
        System.runAs(uSDR) {
             List<Lead> lstLead= NGCC_CallScript_Data_Test.testMultipleLead();        
             insert lstLead;
            
            Test.setCurrentPageReference(New PageReference('Page.NGCC_BulkCreateResponse'));
            ApexPages.StandardSetcontroller stdSetCtlLead = New ApexPages.StandardSetController(lstLead);        
            stdSetCtlLead.setSelected(lstLead);
            
            NGCC_CreateBulkResponseController ngccBulkRes = new NGCC_CreateBulkResponseController(stdSetCtlLead );
            Test.startTest();
                System.assert(ngccBulkRes.getHasSelected());
                ngccBulkRes.saveLeads();
                ngccBulkRes.CancelRecords();
                System.assert(!ngccBulkRes.getHasMessages());
            Test.stopTest(); 
        
        }       
    }
    
    public static testMethod void NGCC_BulkResponseController_NegativeTest() {
         
        List<Lead> lstLead= new List<Lead>();
        
        Test.setCurrentPageReference(Page.NGCC_BulkCreateResponse);
       
        ApexPages.StandardSetController stdSetCtlLead  = new ApexPages.StandardSetController(lstLead);
        NGCC_CreateBulkResponseController ngccBulkRes = new NGCC_CreateBulkResponseController(stdSetCtlLead );
        ngccBulkRes.controller.setSelected(lstLead);
        
        Test.startTest();
            System.assert(!ngccBulkRes.getHasSelected());
            ngccBulkRes.saveLeads();
            System.assert(ngccBulkRes.getHasMessages());
            ApexPages.Message msg = ApexPages.getMessages().get(0);
            System.assertEquals(msg.getSummary(),'Please select at least one Lead for creating CC Response');
        Test.stopTest();
        
    }
        
        

}