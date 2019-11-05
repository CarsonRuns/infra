/*
This trigger is used to create account shareing records for partners in communities.
Delete the Account sharing when record is deleted and updated the distributor & partner names
Population the Distributor & Partner Name lookups insert the records

*/
trigger SCP_Communities_Channel_PartnerAccountSharing on Disti_to_Partner_Mapping__c (after update,after insert, after delete, before insert) {    
    map<Id,set<Id>> mpDistiPartners = new map<Id,set<Id>>();    
    map<Id,set<Id>> mpDistiPartnerShareDelete = new map<Id,set<id>>();
    map<Id,Id> distiParentChiledMap = new map<Id,Id>();
    map<Id,Id> distiParentChiledMapDeletePartner = new map<Id,Id>();
    map<Id,Id> distiParentChiledMapDelete = new map<Id,Id>();
    map<Id,set<Id>> mpDistiChangesAccountShareDelete = new map<Id,set<Id>>();
    map<Id,Id> mpdistiParentChiledRecordDelete = new map<Id,Id>();
    map<Id,set<Id>> mpDistiPartnersDeleteRecords = new map<Id,set<Id>>();
    if(trigger.isAfter && (trigger.isUpdate || trigger.isInsert)){
    for(Disti_to_Partner_Mapping__c DP : trigger.new){
        if((Trigger.isInsert && DP.Distributor__c != null && DP.Partner__c != null ) || 
            (Trigger.isUpdate && DP.Distributor__c != null && Trigger.OldMap.get(DP.Id).Partner__c != DP.Partner__c) ||
                Trigger.isUpdate && DP.Distributor__c != Trigger.OldMap.get(DP.Id).Distributor__c && DP.Distributor__c != null){
                distiParentChiledMap.put(DP.Distributor__c,DP.DistiPartnetId__c);
                if(!mpDistiPartners.containsKey(DP.DistiPartnetId__c)){
                    set<Id> lstPartnerIds = new set<Id>();
                    lstPartnerIds.add(DP.Partner__c);
                    mpDistiPartners.put(DP.DistiPartnetId__c,lstPartnerIds);
                }
                else{
                     Set<Id> lstPartnerIds = mpDistiPartners.get(DP.DistiPartnetId__c); 
                     lstPartnerIds.add(DP.Partner__c);
                     mpDistiPartners.put(DP.DistiPartnetId__c,lstPartnerIds);
                }                                     
           }
           if(trigger.isUpdate && Trigger.OldMap.get(DP.Id).Partner__c != DP.Partner__c){
                distiParentChiledMapDeletePartner.put(DP.Distributor__c,DP.DistiPartnetId__c);                
                if(!mpDistiPartnerShareDelete.containsKey(DP.DistiPartnetId__c)){
                    set<Id> lstPartnerIds = new set<Id>();
                    lstPartnerIds.add(Trigger.OldMap.get(DP.Id).Partner__c);
                    mpDistiPartnerShareDelete.put(DP.DistiPartnetId__c,lstPartnerIds);
                }
                else{
                     Set<Id> lstPartnerIds = mpDistiPartnerShareDelete.get(DP.DistiPartnetId__c); 
                     lstPartnerIds.add(Trigger.OldMap.get(DP.Id).Partner__c);
                     mpDistiPartnerShareDelete.put(DP.DistiPartnetId__c,lstPartnerIds);
                }                
            }           
            if(Trigger.isUpdate && Trigger.OldMap.get(DP.Id).Distributor__c != DP.Distributor__c){
                distiParentChiledMapDelete.put(Trigger.OldMap.get(DP.Id).Distributor__c,Trigger.OldMap.get(DP.Id).DistiPartnetId__c);
                if(!mpDistiChangesAccountShareDelete.containsKey(Trigger.OldMap.get(DP.Id).DistiPartnetId__c)){
                    set<Id> lstPartnerIds = new set<Id>();
                    lstPartnerIds.add(DP.Partner__c);
                    mpDistiChangesAccountShareDelete.put(Trigger.OldMap.get(DP.Id).DistiPartnetId__c,lstPartnerIds);
                }
                else{
                     Set<Id> lstPartnerIds = mpDistiPartnerShareDelete.get(Trigger.OldMap.get(DP.Id).DistiPartnetId__c); 
                     lstPartnerIds.add(DP.Partner__c);
                     mpDistiChangesAccountShareDelete.put(Trigger.OldMap.get(DP.Id).DistiPartnetId__c,lstPartnerIds);
                }                   
            }           
        }
    }    
    if(trigger.isDelete){
        for(Disti_to_Partner_Mapping__c DP : trigger.old){
            mpdistiParentChiledRecordDelete.put(DP.Distributor__c,DP.DistiPartnetId__c);
            if(!mpDistiPartnersDeleteRecords.containsKey(DP.DistiPartnetId__c)){
                set<Id> lstPartnerIds = new set<Id>();
                lstPartnerIds.add(DP.Partner__c);
                mpDistiPartnersDeleteRecords.put(DP.DistiPartnetId__c,lstPartnerIds);
            }
            else{
                 Set<Id> lstPartnerIds = mpDistiPartnerShareDelete.get(DP.DistiPartnetId__c); 
                 lstPartnerIds.add(DP.Partner__c);
                 mpDistiChangesAccountShareDelete.put(DP.DistiPartnetId__c,lstPartnerIds);
            }                   
        }
    }   
    // This code is for populating partner Name & Distributor name look up fields based on Account BE GEO ID
    if(trigger.isBefore && trigger.isInsert) {
        SCP_Communities_AccountSharingHelper objNew = new SCP_Communities_AccountSharingHelper();
        objNew.mapDistiPartnerAccountlookup(trigger.new); 
    }       
    // this code is used to delete the sharing record for Distibutor is updated
    if(!mpDistiChangesAccountShareDelete.isEmpty()){
       SCP_Communities_AccountSharingHelper objNew = new SCP_Communities_AccountSharingHelper();
       objNew.deleteAccountShareRecords(mpDistiChangesAccountShareDelete,distiParentChiledMapDelete);
    }
    // this code is used for Insert Account share to the distibutor accounts.
    if(!mpDistiPartners.isEmpty()){
        SCP_Communities_AccountSharingHelper objNew = new SCP_Communities_AccountSharingHelper();
        objNew.insertAccountShareRecords(mpDistiPartners,distiParentChiledMap);
    }
    // this code is used to delete account share when partner Changed
    if(!mpDistiPartnerShareDelete.isEmpty()){
        SCP_Communities_AccountSharingHelper objNew = new SCP_Communities_AccountSharingHelper();
        objNew.deleteAccountShareRecords(mpDistiPartnerShareDelete,distiParentChiledMapDeletePartner);
    }
    // this code is for delete the account share when user delete the juction object data
    if(!mpDistiPartnersDeleteRecords.isEmpty()){
        SCP_Communities_AccountSharingHelper objNew = new SCP_Communities_AccountSharingHelper();
        objNew.deleteAccountShareRecords(mpDistiPartnersDeleteRecords,mpdistiParentChiledRecordDelete);
    }
}