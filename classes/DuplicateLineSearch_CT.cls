public class DuplicateLineSearch_CT {

    public PageReference getDl() {
        try{
            error='';
            String oId = OpptyId + '%';
            DuplicateLine__c dl = [Select Id from DuplicateLine__c where OpptyEx__c like :oId];
            dlId = dl.Id;
        }
        catch(Exception e){
                    error = e.getTypeName() +' :'+e.getMessage();
        }                                
        return null;
    }

    public String error {get; set;}  
    public String OpptyId {get; set;}    
    public Id dlId {get; set;}        


}