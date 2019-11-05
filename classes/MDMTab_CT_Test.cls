@isTest
private class MDMTab_CT_Test {
    
    static void setUpOrgConstantsData() {
        Org_Constant_CS__c org = new Org_Constant_CS__c();
        org.Name = 'MDM Redirect';
        org.Production_Value__c = 'http://wwwin-tools.cisco.com/DealMgmt/DealRoute.do?application=SFDC&';
        org.Non_Production_Value__c = 'http://wwwin-tools-stage.cisco.com/DealMgmt/DealRoute.do?application=SFDC&';
        insert org;
    }

    @isTest static void MDMControllerTestWithoutOppty() {

        setUpOrgConstantsData();
        Pagereference pageRef = Page.MDMTab;
        Test.setCurrentPage(pageRef);
        
        Test.startTest();
        
        MDMTab_CT con = new MDMTab_CT();       
        System.assert(con.mdmImgUrl != null);
        System.assert(con.urlToOpen != null);
        
        Test.stopTest();
    }    
}