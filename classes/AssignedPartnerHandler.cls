public without sharing class AssignedPartnerHandler
    implements ITrigger 
    {

    public static Boolean stopExcutingWorkflowFieldUpdate = true;
    map<Id,string> mpUserList = new map<Id,string>();
    public AssignedPartnerHandler()
    {       
    }
    public void bulkBefore()    
    {   
        System.debug(System.LoggingLevel.INFO,'@@@@ Limits.getQueries(): '+Limits.getQueries()+' Limits.getLimitQueries(): '+Limits.getLimitQueries()+' AssignedPartnerHandler.bulkBefore()');
    }
 
    public void bulkAfter()
    {
        System.debug(System.LoggingLevel.INFO,'@@@@ Limits.getQueries(): '+Limits.getQueries()+' Limits.getLimitQueries(): '+Limits.getLimitQueries()+' AssignedPartnerHandler.bulkAfter()');
        if( !Trigger.isDelete ){
            set<Id> accountIds = new set<Id>();
            for(SObject AP: Trigger.New){
                Assigned_Partner__c newAP = (Assigned_Partner__c) AP;
                if( Trigger.isInsert && newAP.Assignment_Activated__c){
                    accountIds.add(newAP.Assigned_Partner__c);
                }
                
                if( Trigger.isUpdate){
                    Assigned_partner__c oldAP = (Assigned_Partner__c) Trigger.oldMap.get(newAP.Id);
                    if(newAP.Assignment_Activated__c && !oldAP.Assignment_Activated__c){
                        accountIds.add(newAP.Assigned_Partner__c);
                    }
                }
            }
            System.debug(System.LoggingLevel.WARN,'************************AssignedPartnerHandler.bulkAfter()*****************************************');
            System.debug('BEFORE:' + Limits.getLimitQueries());
            if(accountIds.size() > 0)
            mpUserList = prmUtils.getSCPUserList(accountIds);
            System.debug('AFTER:' + Limits.getLimitQueries());
            System.debug(System.LoggingLevel.WARN,'************************AssignedPartnerHandler.bulkAfter()*****************************************');
        }
    }
    public void beforeInsert(SObject so)
    {    
        Assigned_Partner__c udpatedAssPartner = (Assigned_Partner__c) so;   
        if(udpatedAssPartner.Partner_Status__c != null && udpatedAssPartner.SCP_Partner_Status__c == null){
            udpatedAssPartner.SCP_Partner_Status__c = udpatedAssPartner.Partner_Status__c;
        }
        if(udpatedAssPartner.SCP_Partner_Status__c != null && udpatedAssPartner.Partner_Status__c == null ){
            udpatedAssPartner.Partner_Status__c = udpatedAssPartner.SCP_Partner_Status__c;
        }
        if(udpatedAssPartner.SCP_Partner_Status__c != udpatedAssPartner.Partner_Status__c){
            udpatedAssPartner.Partner_Status__c = udpatedAssPartner.SCP_Partner_Status__c;
        }           
    }
    public void beforeUpdate(SObject oldSo, SObject so)
    {    
        Assigned_Partner__c oldAssPartner = (Assigned_Partner__c) oldSo;
        Assigned_Partner__c udpatedAssPartner = (Assigned_Partner__c) so;   
        if(udpatedAssPartner.Partner_Status__c != oldAssPartner.Partner_Status__c && udpatedAssPartner.Partner_Status__c != oldAssPartner.SCP_Partner_Status__c){
                udpatedAssPartner.SCP_Partner_Status__c = udpatedAssPartner.Partner_Status__c;
        }
        if(udpatedAssPartner.SCP_Partner_Status__c != oldAssPartner.SCP_Partner_Status__c && udpatedAssPartner.SCP_Partner_Status__c != oldAssPartner.Partner_Status__c){
            udpatedAssPartner.Partner_Status__c = udpatedAssPartner.SCP_Partner_Status__c;  
        }
        
        //Ensure PSR1 field is populated when TP is editted by partner user
        if(Partner360Utils.PARTNER_STATUS_ACTIVELY_WORKING.equals(udpatedAssPartner.Partner_Status__c) && 
           (prmFilterUtility.checkPatnerUser() == 1 || UserInfo.getProfileId() == '00en0000000Hg4k') &&
           (udpatedAssPartner.Assigned_Partner_Sales_Rep__c == null && 
            udpatedAssPartner.Assigned_Partner_Sales_Rep_2__c == null && 
            udpatedAssPartner.Assigned_Partner_Sales_Rep_3__c == null
           ))
        {
            udpatedAssPartner.Assigned_Partner_Sales_Rep__c =UserInfo.getUserId();
        }
    }
    public void beforeDelete(SObject so)
    {
    }
    public void afterInsert(SObject so)
    {
    }
    public void afterUpdate(SObject oldSo, SObject so)
    {       
        Assigned_Partner__c oldAssPartner = (Assigned_Partner__c) oldSo;
        Assigned_Partner__c udpatedAssPartner = (Assigned_Partner__c) so;   
        list<Id> lsvtContactIds = new list<Id>();
        string userList = '';
        //System.debug(stopExcutingWorkflowFieldUpdate);
        //System.debug('oldAssPartner.Partner_Status__c | ' + oldAssPartner.Partner_Status__c);
        //System.debug('udpatedAssPartner.Partner_Status__c | ' + udpatedAssPartner.Partner_Status__c);
        //System.debug('oldAssPartner.Assignment_Activated__c | ' + oldAssPartner.Assignment_Activated__c);
        //System.debug('udpatedAssPartner.Assignment_Activated__c | ' + udpatedAssPartner.Assignment_Activated__c);
        if(stopExcutingWorkflowFieldUpdate && !oldAssPartner.Assignment_Activated__c  && udpatedAssPartner.Assignment_Activated__c  && udpatedAssPartner.Partner_Status__c == 'Partner Assigned'){            
           userList = mpUserList.get(udpatedAssPartner.Assigned_Partner__c);
            if(userList != ''){
                if(!Test.isRunningTest()){
                    boolean callStackLimitExceeded = (Limits.getFutureCalls() >= Limits.getLimitFutureCalls());
                    System.debug(System.LoggingLevel.INFO,'@@@@ Limits.getFutureCalls() : '+Limits.getFutureCalls()+' Limits.getLimitFutureCalls() : '+Limits.getLimitFutureCalls());
                    System.debug(System.LoggingLevel.INFO, '@@@@ callStackLimitExceeded : '+callStackLimitExceeded);
                    if(!callStackLimitExceeded) {
                        SCP_Notifications_RestCall.callWSAPI('SCP-TTL-PPT', '', 'SCP-PPT-ASMT', 'N', 'SCP user', 'Prospects Module', 'SCP', udpatedAssPartner.Id, udpatedAssPartner.Customer_Account_Name__c, udpatedAssPartner.LastModifiedByName__c, userList);
                    }
                    stopExcutingWorkflowFieldUpdate = false;
                }
            }
        }
    }
    public void afterDelete(SObject so)
    {
    } 
    public void andFinally()
    {
        System.debug(System.LoggingLevel.INFO,'@@@@ Limits.getQueries(): '+Limits.getQueries()+' Limits.getLimitQueries(): '+Limits.getLimitQueries()+' AssignedPartnerHandler.andFinally()');
    }
}