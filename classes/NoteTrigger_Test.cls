/**
 * Name : NoteTrigger_Test
 * Author :  Unit Test Generator
 * Description : Test class used for testing the NoteTrigger
 * Date : 9/16/14 2:31 PM 
 * Version : <intial Draft> 
 */
@isTest(seealldata=true)
private class NoteTrigger_Test { 
     static testMethod  void testNoteTrigger(){
        Assigned_partner__c  ASTest = GenericStaticTestData.gettestTargetProspectRecord();
        Note noteTest =  new Note();
        noteTest.ParentId=ASTest.Id;
        notetest.Title='test';
        insert noteTest;
        noteTest.Title = 'demo test';
        update noteTest;
        //delete noteTest;
    }
}