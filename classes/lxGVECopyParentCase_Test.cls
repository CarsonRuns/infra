/*
Author          : Manikant Kella
Release         : May 03rd, 2019
Created         : Manikant Kella
Functionality   : Test Class for lxGVECopyParentCase apex controller
				  


Modification History:
*------------------------------------------------------------------------------------
Itrack#        Date        Author                             Change  
*------------------------------------------------------------------------------------
US261709    Apr 03,2019   Manikant Kella(mkella)     Test Class for lxGVECopyParentCase apex controller
*------------------------------------------------------------------------------------
*/


@istest(SeeAllData=false)
private class lxGVECopyParentCase_Test {
    @TestSetup static void setupData() {
        // fetch End Customer Contact Record type id
        Id recTypeId = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('End Customer Contact').getRecordTypeId();
        //ObjectRecordTypeIds__c.getInstance().Contact_Manual_Partner_RecordTypeId__c
 		ObjectRecordTypeIds__c objRecordType = new ObjectRecordTypeIds__c();
        objRecordType.Contact_Manual_Partner_RecordTypeId__c = recTypeId;
  		insert objRecordType;
 }
    private static testMethod void test(){
        
        Utilities.setIsTestMethod(true);
        Utilities.setValidationSkip(true);
        Id tsnRecTypeId = Schema.SObjectType.Case.getRecordTypeInfosByName().get('GVE Case').getRecordTypeId();
        //Case c1=new Case(RecordtypeId =Utilities.getCaseTSNRecordTypeId());
        Case c1=new Case(RecordtypeId =tsnRecTypeId);
        c1.Web_CCO_ID__c='testuser';
        c1.Origin ='Web';
        c1.suppliedemail='testuser@gmail.com';
        c1.Architecture__c='Test';   
        c1.Assigned_SLA__c = '1 hr';
        c1.Status = 'Closed';
        insert c1;
        
        //Case c2=new Case(RecordtypeId =Utilities.getCaseTSNRecordTypeId());
        Case c2=new Case(RecordtypeId =tsnRecTypeId);
        c2.Web_CCO_ID__c='testuser';
        c2.Origin ='Web';
        c2.suppliedemail='testuser@gmail.com';
        c2.Architecture__c='Test';   
        c2.Assigned_SLA__c = '1 hr';
		insert c2;
        Test.startTest();
		String tryBlockResult = lxGVECopyParentCase.createChildCaseRecord(c1.id);
        String catchBlockResult = lxGVECopyParentCase.createChildCaseRecord(c2.id);
        Test.stopTest();
    }

}