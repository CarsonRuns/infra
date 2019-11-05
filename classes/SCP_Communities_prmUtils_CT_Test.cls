@isTest
public with sharing class SCP_Communities_prmUtils_CT_Test {
    public static testmethod void testLanguageLocaleKey(){
        PageReference pageRef = Page.SCP_Communities_leadInitDeal;
        Test.setCurrentPage(pageRef);
        
        UtilUnitTest.loadAllStaticData();
        ApexPages.StandardController ctr = new ApexPages.StandardController(new Lead());
        SCP_Communities_prmUtils_CT initDealCt = new SCP_Communities_prmUtils_CT(ctr);
        String userLanguageKey = initDealCt.LanguageLocaleKey;
    }
}