@isTest(seeAllData=true)

// This is the test class for TSN_Update_Account_Entitlement Trigger on Partner Specialization Object

private Class TSN_Update_Account_Entitlement_Test{
       private static testMethod void test(){
           
           Test.startTest();
           Account partnerAccount = [select Id, Name 
                                    from Account 
                                    where recordTypeId = '01280000000G6ts' limit 1];

           Partner_Specialization__c psObject=new Partner_Specialization__c(); 
           psObject.Name='Partner Plus FY13';
           psObject.Status__c='Active';
           psObject.Partner_Company__c=partnerAccount.id;

          
           insert psObject;
           
           //Added as part of the code update for INC000030091635.
           Partner_Specialization__c psUpdate = [Select ID, Status__c from Partner_Specialization__c where Partner_Company__c=:partnerAccount.id and Name=:'Partner Plus FY13'];
           psUpdate.Status__c = 'Inactive';
           update psUpdate;
           
           Test.stopTest();
     }
}