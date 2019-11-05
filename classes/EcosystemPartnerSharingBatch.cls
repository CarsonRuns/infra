/************************************************************************************************************************************
Name    : EcosystemPartnerSharingBatch
Author  : Sreenivasulu
Purpose : Contains logic for sharing  ecosystem partner with the opportunity regardless of opportunity location.
*************************************************************************************************************************************/
global class EcosystemPartnerSharingBatch implements Database.Batchable<sObject>{
    //start Method
    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([select id ,Partner_Company__c,Program_Effective_Date__c,Program_Expiration_Date__c from Partner_Program_Enrollment__c where (Partner_Company__r.Partner_Company_Status__c ='Active (Registered)' OR Partner_Company__r.Partner_Account_Status__c='Active (Registered)') AND Program_Enrollment_Status__c = 'Active']);
    }
    //execute Method
    global void execute(Database.BatchableContext BC, List<Partner_Program_Enrollment__c > scope)
    {
        system.debug('scope'+scope);
        Set<Id> partnerIds = new Set<Id>();
        Set<Id> inactivePartnerIds = new Set<ID>();
        for(Partner_Program_Enrollment__c ac:scope) 
        {
            if(ac.Program_Effective_Date__c<=Date.Today() && ac.Program_Expiration_Date__c >=Date.Today())
            {
                partnerIds.add(ac.Partner_Company__c);
            }else{
                inactivePartnerIds.add(ac.Partner_Company__c);
            }
        }
        List<Account> channelAccList = new List<Account>([select id,name,Parentid,IsEcosystemPartner__c from account where (Parentid IN :partnerIds OR Parentid IN :inactivePartnerIds)  AND Recordtype.Name ='Channel']);
        List<Account> channelAccList1 = new  List<Account>();
        system.debug('channelAccList>>>>'+channelAccList );
        for(Account acc:channelAccList){
            if(partnerIds.contains(acc.parentid) && acc.IsEcosystemPartner__c!=true){
               acc.IsEcosystemPartner__c=true;
               channelAccList1.add(acc);
              
            }
            else if(inactivePartnerIds.contains(acc.parentid) && acc.IsEcosystemPartner__c!=false){
               acc.IsEcosystemPartner__c=false;
            }
        }
        update channelAccList1 ;
        system.debug('channelAccList1 ###'+channelAccList1 );
    }
    //Finish Method
    global void finish(Database.BatchableContext BC){
    }  
}