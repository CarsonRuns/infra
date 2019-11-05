trigger P360_TP_Geocode_AfterUpsert on Assigned_Partner__c (after update, after insert) {
    set<id> triggerIds = trigger.newMap.keyset();

    List<Assigned_Partner__c> tps = [SELECT id, Customer_Account__c FROM Assigned_Partner__c where id in :triggerIds];
    List<id> accts = new List<id>();
    for(Assigned_Partner__c tp: tps){
        if(trigger.isUpdate){
            Assigned_Partner__c  oldtp = trigger.oldMap.get(tp.id);
            Assigned_Partner__c  newtp = trigger.newMap.get(tp.id);
            if(oldtp.Customer_Account__c != newtp.Customer_Account__c){
                accts.add(newtp.Customer_Account__c);
            }
        }
        else{
            if(tp.Customer_Account__c != null){
                accts.add(tp.Customer_Account__c);
            }
        }
    }
    List<Account> accounts = [SELECT id, Needs_Geolocation_Update__c, Geolocation__Latitude__s, Geolocation__Longitude__s from account where id in :accts];
    for(Account acct: accounts){
        if(acct.Geolocation__Latitude__s == null){
            acct.Needs_Geolocation_Update__c = true;
        }
    }
    
    update(accounts);
}