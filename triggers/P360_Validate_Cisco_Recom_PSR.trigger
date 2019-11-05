/*
    Purpose: To Validate the Cisco Recommended PSR for associated to Assigned Partner
*/
trigger P360_Validate_Cisco_Recom_PSR on Assigned_Partner__c (after update,after insert) {
   
   if(trigger.isupdate){
        Map<Id,Id> mapTPUser=new Map<Id,Id>();
        Map<Id,Id> mapUserAccount=new Map<Id,Id>();
        Set<id> setUserId=new Set<Id>();

        for(Assigned_Partner__c ap: Trigger.New){
            if(ap.Assignment_Activated__c==True){
            setUserId.add(ap.Cisco_Recomended_Partner_Sales_Rep__c);
            }
        }
   
        if(!setUserId.IsEmpty()){
            for(User u:[Select AccountId,ContactId,Id from User where Id IN :setUserId])
            {
                mapUserAccount.put(u.Id,u.AccountId);
            }
            
            
            for(Assigned_Partner__c apupdate: Trigger.New){
                if(mapUserAccount.ContainsKey(apupdate.Cisco_Recomended_Partner_Sales_Rep__c )){
                    system.debug('Cisco Recommended'+apupdate.Assigned_Partner__c);
                    if(mapUserAccount.get(apupdate.Cisco_Recomended_Partner_Sales_Rep__c) != apupdate.Assigned_Partner__c)
                    {
                        apupdate.addError(System.Label.P360_Validate_Cisco_Rec_PSR);
                    }
                }
            }
        }
    }
}