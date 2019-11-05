/**
 * Name : AttachmentTrigger_Test
 * Author :  Unit Test Generator
 * Description : Test class used for testing the AttachmentTrigger
 * Date : 9/16/14 2:31 PM 
 * Version : <intial Draft> 
 */
@isTest(seealldata=true)
private class AttachmentTrigger_Test { 
     static testMethod  void testAttachmentTrigger(){
         Blob b = Blob.valueOf('Test Data');
         Assigned_partner__c  ASTest = GenericStaticTestData.gettestTargetProspectRecord();
         Attachment attachment = new Attachment();
         attachment.ParentId = ASTest.Id;
         attachment.Name = 'Test Attachment for Parent';
         attachment.Body = b;         
         insert(attachment);
         blob b1 = blob.valueof('Test demo');
         attachment.body = b1;
         update attachment;             
        //delete attachmentTest;
    }
}