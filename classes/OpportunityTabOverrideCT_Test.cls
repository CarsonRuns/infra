@isTest
public class OpportunityTabOverrideCT_Test{
    static testMethod void initTests(){
        test.startTest();
        Boolean act;
        PageReference pageRef = Page.pdrDown;
        Test.setcurrentpage(pageRef);
        Apexpages.currentpage().getparameters().put('isdtp','mn');  
        ApexPages.currentPage().getParameters().put('manageDeal','true');
        ApexPages.currentPage().getParameters().put('biddingDeal','true');
        OpportunityTabOverride_CT pCt = new OpportunityTabOverride_CT();
        pCt.init();
        act= pCt.addSessionId;     
        pCt.checkUserProfile();
        test.stopTest();
    } 
}