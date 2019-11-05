public class DuplicateLine {
    
    public Static Set<Id> opptyAlreadyAdded = new Set<Id>(); 
   
    public static void processIds(Set<Id> OpptyIds){
        DuplicateLine__c[] dlisToAdd = new DuplicateLine__c[]{};        

        for (Id oId : OpptyIds) {
            if (!opptyAlreadyAdded.contains(oId)){
               DuplicateLine__c dliTmp = new DuplicateLine__c(OpptyEx__c=oId, Status__c='ToUpdate');
               dlisToAdd.add(dliTmp);
               opptyAlreadyAdded.add(oId);
            }              
        } 
        if (dlisToAdd.size() > 0){upsert dlisToAdd OpptyEx__c;}        
    }    

}