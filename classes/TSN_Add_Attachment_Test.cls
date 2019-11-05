@isTest

private Class TSN_Add_Attachment_Test{
     private static testMethod void test(){
         Case testCase = new Case(RecordTypeId=Utilities.getCaseTSNRecordTypeId(),Contact_Type__c = 'Cisco',Cisco_Contact__c='abc@cisco.com');
         insert testCase; // TSN Case
         Test.StartTest();
         ApexPages.StandardController controller = new ApexPages.StandardController(testCase);      
         PageReference pageRef = ApexPages.currentPage();
         pageRef.getParameters().put('id',testCase.Id);
         TSN_Add_Attachment_CTE addattach= new TSN_Add_Attachment_CTE(controller);
         String s='testing';
         Blob b=blob.valueOf(s);
         Attachment attch=new Attachment(name='test',ParentId=testCase.Id,Body=b);
         addattach.attachment=attch;
         addattach.checkAttachmentSize();
         addattach.upload();
         addattach.close();
         addattach.getResults();
         Test.StopTest();
    }
}