@isTest
public class OpportunityTabOverride_CT_Test{
    static testMethod void initTests(){
        test.startTest();
        OpportunityTabOverride_CT pCt = new OpportunityTabOverride_CT();
        pCt.manageDeal = 'true';
        pCt.biddingDeal = 'true';
        pCt.init(); 
        pCt.checkUserProfile();

        test.stopTest();
    } 

}