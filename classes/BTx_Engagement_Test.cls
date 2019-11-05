// ******* Change History ********
//  majanard - 03052015: Removed the reference for Vertical__c from BTx_Engagement_Revenue__c query.
// ******* Change History ********

@isTest(seeAllData=true)
private Class BTx_Engagement_Test
{
    static testMethod void BTx_Revenue_TestMethod()    
    {  
        Test.startTest(); 
        BTx_Engagement_Revenue__c btx = [SELECT ID, Engagement__c, Solution__c, Is_this_a_Primary_Solution__c, Comments__c FROM BTx_Engagement_Revenue__c limit 1];  
        btx.Solution__c = 'Other (provide description below)';
        btx.Comments__c = 'executing test method';
        btx.Is_this_a_Primary_Solution__c = false;
        btx.Engagement_Total_DC_Mix__c = 100;
        update btx;
        
        btx.Solution__c = 'Digital Store Entertainment';
       update btx;
        
        
        
        ApexPages.StandardController controller = new ApexPages.StandardController(btx);
        Apexpages.currentPage().getParameters().put('CF00N80000004vwCK_lkid',btx.Engagement__c);
        PageReference pageRef = new BTx_Revenue(controller).pageredir();
        Apexpages.currentPage().getParameters().put('CF00N80000004vwCK_lkid',null);
         Apexpages.currentPage().getParameters().put('retURL','/'+btx.ID);
        PageReference pageRef1 = new BTx_Revenue(controller).pageredir();
        Apexpages.currentPage().getParameters().put('note','true');
        Apexpages.currentPage().getParameters().put('sn','0');
        Apexpages.currentPage().getParameters().put('retURL','/'+btx.Engagement__c);
        PageReference pageRef2 = new BTx_Revenue(controller).pageredir();
        Test.stopTest();    
    }
}