/**
 * Name : SCP_Communities_PSREdit_Test
 * Author : Unit Test Generator
 * Description : Test class used for testing the SCP_Communities_PSREdit
 * Date : 9/16/14 2:31 PM 
 * Version : <intial Draft> 
 */
@isTest(seeAllData=true)
private class SCP_Communities_PSREdit_Test { 
    /*
     *@name testGetComponentControllerMap() 
     *@return void 
     *@description This method for getComponentControllerMap () In CLASS SCP_Communities_PSREdit.cls
     */
     static testMethod void  testGetComponentControllerMap() { 
        Assigned_partner__c  ASTest = GenericStaticTestData.gettestTargetProspectRecord();              
        Test.startTest();   
        PageReference pageRef = Page.SCP_Communities_psrFilterLookup;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', ASTest.Id);
        SCP_Communities_PSREdit sCPCommunitiesPSREditTest  =  new  SCP_Communities_PSREdit();
        Map<string,SCP_Communities_ComponentControllerBase> mapTest = sCPCommunitiesPSREditTest.getComponentControllerMap();
         System.assert(true);
        Test.stopTest();
    }
    /*
     *@name testSetComponentControllerMap() 
     *@return void 
     *@description This method for setComponentControllerMap () In CLASS SCP_Communities_PSREdit.cls
     */
     static testMethod void  testSetComponentControllerMap() { 
        string keyTest = 'psr';
        Assigned_partner__c  ASTest = GenericStaticTestData.gettestTargetProspectRecord();  
            
        Test.startTest();
        Test.setCurrentPage(Page.SCP_Communities_psrFilterLookup);
        ApexPages.currentPage().getParameters().put('id', ASTest.Id);
        SCP_Communities_ComponentControllerBase comTest = new SCP_Communities_ComponentControllerBase();
        SCP_Communities_PSREdit sCPCommunitiesPSREditTest  =  new  SCP_Communities_PSREdit();
        sCPCommunitiesPSREditTest.setComponentControllerMap(keyTest,comTest);
         System.assert(true);
        Test.stopTest();
    }
    /*
     *@name testGetThis() 
     *@return void 
     *@description This method for getThis () In CLASS SCP_Communities_PSREdit.cls
     */
     static testMethod void  testGetThis() { 
        Assigned_partner__c  ASTest = GenericStaticTestData.gettestTargetProspectRecord();
        Test.startTest();
        Test.setCurrentPage(Page.SCP_Communities_psrFilterLookup);
        ApexPages.currentPage().getParameters().put('id', ASTest.Id);
        SCP_Communities_PSREdit sCPCommunitiesPSREditTest  =  new  SCP_Communities_PSREdit();
        SCP_Communities_PageControllerBase scp_communities_pagecontrollerbaseTest = sCPCommunitiesPSREditTest.getThis();
         System.assert(true);
        Test.stopTest();
    }
    /*
     *@name testInitlize() 
     *@return void 
     *@description This method for initlize () In CLASS SCP_Communities_PSREdit.cls
     */
     static testMethod void  testInitlize() { 
        Assigned_partner__c  ASTest = GenericStaticTestData.gettestTargetProspectRecord();
        Test.startTest();
        Test.setCurrentPage(Page.SCP_Communities_psrFilterLookup);
        ApexPages.currentPage().getParameters().put('id', ASTest.Id);
        SCP_Communities_PSREdit sCPCommunitiesPSREditTest  =  new  SCP_Communities_PSREdit();
        sCPCommunitiesPSREditTest.initlize();
         System.assert(true);
        Test.stopTest();
    }
    /*
     *@name testSavePSR() 
     *@return void 
     *@description This method for savePSR () In CLASS SCP_Communities_PSREdit.cls
     */
     static testMethod void  testSavePSR() { 
        Assigned_partner__c  ASTest = GenericStaticTestData.gettestTargetProspectRecord();
        Test.startTest();
        Test.setCurrentPage(Page.SCP_Communities_psrFilterLookup);
        ApexPages.currentPage().getParameters().put('id', ASTest.Id);
        SCP_Communities_PSREdit sCPCommunitiesPSREditTest  =  new  SCP_Communities_PSREdit();
        sCPCommunitiesPSREditTest.psr1Id = GenericStaticTestData.gettestPSRUserRecord().Id;
        PageReference pagereferenceTest = sCPCommunitiesPSREditTest.savePSR();
        System.assert(true);
        Test.stopTest();
    }
    /*
     *@name testCancel() 
     *@return void 
     *@description This method for Cancel () In CLASS SCP_Communities_PSREdit.cls
     */
     static testMethod void  testCancel() { 
        Assigned_partner__c  ASTest = GenericStaticTestData.gettestTargetProspectRecord();        
        Test.startTest();
        Test.setCurrentPage(Page.SCP_Communities_psrFilterLookup);
        ApexPages.currentPage().getParameters().put('id', ASTest.Id);
        SCP_Communities_PSREdit sCPCommunitiesPSREditTest  =  new  SCP_Communities_PSREdit();
        PageReference pagereferenceTest = sCPCommunitiesPSREditTest.Cancel();
         System.assert(true);
        Test.stopTest();
    }
    /*
     *@name testGetPsr() 
     *@return void 
     *@description This method for getPsr () In CLASS SCP_Communities_PSREdit.cls
     */
     static testMethod void  testGetPsr() { 
        Assigned_partner__c  ASTest = GenericStaticTestData.gettestTargetProspectRecord();
        Test.startTest();
        Test.setCurrentPage(Page.SCP_Communities_psrFilterLookup);
        ApexPages.currentPage().getParameters().put('id', ASTest.Id);
        SCP_Communities_PSREdit sCPCommunitiesPSREditTest  =  new  SCP_Communities_PSREdit();
        SCP_Communities_PSRBulk_CT scp_communities_psrbulk_ctTest = sCPCommunitiesPSREditTest.getPsr();        
         System.assert(true);
        Test.stopTest();
    }
    /*
     *@name testGetSearchPageUrl() 
     *@return void 
     *@description This method for getSearchPageUrl () In CLASS SCP_Communities_PSREdit.cls
     */
     static testMethod void  testGetSearchPageUrl() { 
        Assigned_partner__c  ASTest = GenericStaticTestData.gettestTargetProspectRecord();
        Test.startTest();
        Test.setCurrentPage(Page.SCP_Communities_psrFilterLookup);
        ApexPages.currentPage().getParameters().put('id', ASTest.Id);
        SCP_Communities_PSREdit sCPCommunitiesPSREditTest  =  new  SCP_Communities_PSREdit();
        String stringTest = sCPCommunitiesPSREditTest.getSearchPageUrl();
         System.assert(true);
        Test.stopTest();
    }
    static testMethod void  testGetComponentControllerLeadMap() { 
        Lead ASTest = GenericStaticTestData.gettestPartnerGereratedLeadRecord();                      
        Test.startTest();   
        PageReference pageRef = Page.SCP_Communities_psrFilterLookup;
        Test.setCurrentPage(pageRef);
        ApexPages.currentPage().getParameters().put('id', ASTest.Id);
        SCP_Communities_PSREdit sCPCommunitiesPSREditTest  =  new  SCP_Communities_PSREdit();
        Map<string,SCP_Communities_ComponentControllerBase> mapTest = sCPCommunitiesPSREditTest.getComponentControllerMap();
         System.assert(true);
        Test.stopTest();
    }
}