/**
 * Class OpportunityHandler
 *
 * Trigger Handler for the Opportunity SObject. This class implements the ITrigger
 * interface to help ensure the trigger code is bulkified and all in one place.
 ***** Change History *****
 * 9/28 - BeforeInsert & BeforeUpdate - set the Solution ID lookup value based on Picklist Value.
 */
public without sharing class OpportunityHandler
    implements ITrigger
{
    private String parentMobileRecTypeId; 
    private String parentRecTypeId; 
    private String runningUserTheater;
    private Boolean isRunningUserPss = false;
    // Constructor
    public OpportunityHandler()
    {
        this.parentMobileRecTypeId = ObjectRecordTypeIds__c.getInstance().Opportunity_Parent_Mobile_RecordTypeId__c;
        this.parentRecTypeId = ObjectRecordTypeIds__c.getInstance().Opportunity_Parent_RecordTypeId__c;
        User runningUser = [Select Theatre__c,Additional_User_Permissions__c From User where id =:UserInfo.getUserId()];
        if( runningUser != null ){
            if( runningUser.Theatre__c != null  ){
                this.runningUserTheater = runningUser.Theatre__c;
            }
            
            if( runningUser.Additional_User_Permissions__c != null && runningUser.Additional_User_Permissions__c.contains('Enable_ePSS')){
                this.isRunningUserPss = true;
            }
        }
    }
 
    public void bulkBefore()
    {
        if(!Trigger.isDelete){
            //SolutionID - Opportunity Insert/Update fix
            Set<string> lstStr = new set<string>();     
            Map<id,string> sMap = new Map<id,string>();
            Map<string,id> slMap = new Map<string,id>();
            List<Opportunity> lstOpt = trigger.new;       
            List<Solution_ID__c> sltonIds = new List<Solution_ID__c>();
            if(Trigger.isInsert){
                for(Opportunity opt :lstOpt ){
                        if(opt.Solution_Identifier__c != null && opt.Solution_Identifier__c != ''){
                            lstStr.add(opt.Solution_Identifier__c);
                            sMap.put(opt.id,opt.Solution_Identifier__c);
                        }
                    }
                }
                if(trigger.isUpdate){               
                    for(Opportunity opt :lstOpt ){
                        Opportunity oldOpt = (Opportunity)trigger.oldMap.get(opt.id);
                        if( (oldOpt.Solution_Identifier__c != opt.Solution_Identifier__c)){
                            lstStr.add(opt.Solution_Identifier__c);
                            sMap.put(opt.id,opt.Solution_Identifier__c);
                        }
                    }
                }
                
                if(!lstStr.isEmpty()){
                    sltonIds = [select id,Solution_ID__c from Solution_ID__c where Solution_ID__c in: lstStr];      
                 }
                 
                for(Solution_ID__c sid : sltonIds){
                    slMap.put(sid.Solution_ID__c,sid.id);
                 }
                
                for(Opportunity opts :lstOpt ){
                    if(sMap.containsKey(opts.id)){
                        opts.Solution_ID_Description__c = slMap.get(sMap.get(opts.id));             
                    }           
                }
            }
        }
 
    public void bulkAfter()
    {

    }
 
    public void beforeUpdate(SObject oldSo, SObject so)
    {

    }
 
    public void beforeDelete(SObject so)
    {
    }
 
    public void beforeInsert(SObject so)
    {
        //US7424: Check if oppty being created is using mobile record type
        //if so replace with parent record type
        Opportunity newOppty = (Opportunity) so;
        System.debug('**************Opportunity BeforeInsert START*************************');
        System.debug('newOppty: ' + newOppty);
        System.debug('newOppty.RecordTypeId: ' + newOppty.RecordTypeId);
        System.debug('this.parentMobileRecTypeId: ' + this.parentMobileRecTypeId);
        System.debug('newOppty.RecordTypeId == this.parentMobileRecTypeId: ' + (newOppty.RecordTypeId == this.parentMobileRecTypeId));
        if(newOppty.RecordTypeId == this.parentMobileRecTypeId){
            newOppty.RecordTypeId = this.parentRecTypeId;
            //Set flag to true
            newOppty.Created_Via_Salesforce1__c = true;
        }
        
        //US7244: Set theater field if is null
        if(newOppty.Theater__c == null && this.runningUserTheater != null){
            newOppty.Theater__c = this.runningUserTheater;
        }
        
        //US7244: Set Opportunity Owner AM field if not pss
        if(!isRunningUserPss && newOppty.Opportunity_Owner_AM__c == null ){
            newOppty.Opportunity_Owner_AM__c = UserInfo.getUserId();
        }
        
        
        
        System.debug('newOppty: ' + newOppty);
        System.debug('**************Opportunity BeforeInsert END*************************');
    }
 
    public void afterInsert(SObject so)
    {
    }
 
    public void afterUpdate(SObject oldSo, SObject so)
    {
               
    }
 
    public void afterDelete(SObject so)
    {
    }
 
    public void andFinally()
    {

    }
}