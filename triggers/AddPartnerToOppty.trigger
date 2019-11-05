trigger AddPartnerToOppty on Quote__c (after insert, after update, after delete) {

    Opportunity[] opptysToUpdate = new Opportunity[]{};

    /*
    for(Quote__c q : System.Trigger.new) {
        if(Trigger.isInsert || q.PartnerAcctId__c != System.Trigger.oldMap.get(q.Id).PartnerAcctId__c){
            if(q.PartnerAcctId__c != null)
                partnerAcct = String.valueOf(q.PartnerAcctId__c).subString(0,15);
            
            Opportunity o = new Opportunity(Id=q.Opportunity_Name__c, Quote_Partner_Account_Id__c=partnerAcct);    
            opptysToUpdate.add(o);
        }
    }
    */
    Set<Id> opptyIds = new Set<Id>();
    
    if(Trigger.isDelete){
    for(Quote__c q : Trigger.old)
    opptyIds.add(q.Opportunity_Name__c);    
    }
    else if(Trigger.isInsert || Trigger.isUpdate){
    for(Quote__c q : Trigger.new) {
        if((Trigger.isInsert && q.PartnerAcctId__c != null) || (Trigger.isUpdate && q.PartnerAcctId__c != Trigger.oldMap.get(q.Id).PartnerAcctId__c)){
        
        opptyIds.add(q.Opportunity_Name__c);
        
        }
      } 
    }
    if(opptyIds.size()>0){
      for(Opportunity op : [Select Id,Quote_Partner_Account_Id__c,(Select Id,PartnerAcctId__c from Partner_Quotes__r where PartnerAcctId__c!='' Order by CreatedDate ASC) from Opportunity where Id IN:opptyIds])
      { 
        String partnerAcct = '';
        if(op.Partner_Quotes__r.size()>0){
         for(Quote__c q : op.Partner_Quotes__r)
         {
          if(partnerAcct != '' && !partnerAcct.Contains(String.valueOf(q.PartnerAcctId__c).subString(0,15)))
          partnerAcct += ',' + String.valueOf(q.PartnerAcctId__c).subString(0,15) ;
          else if(partnerAcct == '')
          partnerAcct += String.valueOf(q.PartnerAcctId__c).subString(0,15); 
                
         }
        }
        Opportunity o = new Opportunity(Id=op.Id, Quote_Partner_Account_Id__c=partnerAcct);
        System.debug(o);
        opptysToUpdate.add(o);
      }
    }
    system.debug(opptysToUpdate);
    if(opptysToUpdate.size() > 0)
        update opptysToUpdate;    

}