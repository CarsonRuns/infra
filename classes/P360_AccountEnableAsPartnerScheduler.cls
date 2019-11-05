/*
// majanard - added "Leads & Prospects" partner program name to the query - Partner_Program_Leads_Prospect_Name
*/

global class  P360_AccountEnableAsPartnerScheduler implements Schedulable {
    global void execute(SchedulableContext SC) {
        // execute the Partner Portal user onboarding batch process.
        // query to get all channel accounts, whose parent partner companies are enrolled in a partner 360 program
        String query = 'select Id from account where isPartner = false and account.ParentId in ( SELECT Partner_Company__c FROM Partner_Program_Enrollment__c where name in (\'' +Utilities.getConstant_CS('Partner_Led_Program_Name')+'\',\''+ Utilities.getConstant_CS('Partner_Program_Leads_Prospect_Name')+ '\') and Program_Enrollment_Status__c = \'Active\')';
        P360_AccountEnableAsPartner p = new P360_AccountEnableAsPartner(query);
        Database.executeBatch(p,50);        
    }



/*

P360_AccountEnableAsPartnerScheduler p = new P360_AccountEnableAsPartnerScheduler();
 String sch = '0 0 4 * * ?';
        system.schedule('P360 - Enable Account as Partner', sch, p);

*/

// Test class here

public static testMethod void testScheduler()
     {
        Test.startTest();
        P360_AccountEnableAsPartnerScheduler p = new P360_AccountEnableAsPartnerScheduler();
        String sch = '0 0 0/1 * * ?';
       // system.schedule('P360 - Enable Account as Partner', sch, p);
        test.stopTest();

     }

}