@isTest(seealldata=true)
private class SCP_Communities_viewSetting_CT_Test {
 static testMethod void myUnitTest(){           
     PageReference pageRef = Page.SCP_Communities_viewSetting;             
     string strId = [select id from SCP_Communities_listviews__c where name='My Newly Assigned Leads' and objectType__c = 'Lead'].Id;    
     Test.setCurrentPage(pageRef);
     User_Preference__c usPref = new User_Preference__c(View_Id__c=strId,User__c=userinfo.getUserId(),Selected_column_order__c='Lead Source',Columns_Sort_Order__c = 'Date Added~~desc;Lead Source~~asc');
     insert usPref;
     ApexPages.currentPage().getParameters().put('view', strId ); 
     SCP_Communities_viewSetting_CT  clsObject = new SCP_Communities_viewSetting_CT();  
     clsObject.SavePreference();  
     clsObject.saveForAllViews =true;
     clsObject.SavePreference(); 
 }

}