@isTest(seeAllData = TRUE)
global class P360_PartnerProgramEnrollmentUpdate_Test

{
     public static testmethod void testEnableAsPartner()
     {
         string accountid = GenericStaticTestData.gettestChannelAccountRecord1().id;
         test.startTest();
         string query = 'select Id,Partner_Assignment_Eligible__c,IsPartner from account where id ='+ '\'' + accountid + '\'';
         system.debug(query );
         P360_PartnerProgramEnrollmentUpdate p = new P360_PartnerProgramEnrollmentUpdate(query);           
         Database.executeBatch(p);        
         test.stopTest();
        
     }


}