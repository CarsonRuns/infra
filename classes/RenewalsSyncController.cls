public class RenewalsSyncController {
    
    /*
@ Created /Modified : Apr 26,2019
* @description : Method to get Expecetd Term & oppty line flag  
* @param : Oppty Id 
* @return : list
*/ 
    @auraEnabled
    public static resultWrapper getExpectedTermApex(Id opptyId){
        resultWrapper optylinemap = new resultWrapper();
        Renewals_Portfolio__c renewals = Renewals_Portfolio__c.getOrgDefaults();
        Optylinemap.defaultSyncMessage = renewals.default_sync_message__c;
        optylinemap.defaultTermMessage = renewals.default_term_message__c;
        optylinemap.defaultLineMessage = renewals.default_line_message__c;
        optylinemap.defaultSuccessMessage = renewals.default_success_Message__c;
        list<OpportunityLineItem> olilist = new list<OpportunityLineItem>();
        try{
            optylinemap.optylineitemExpectedTerm = [select Expected_Contract_Term__c  from opportunity  where Id = :opptyId].Expected_Contract_Term__c;
        }catch(Exception e){
            system.debug('Error fetching term for lines '+e);
        }
        
        try{
            olilist = [select id, Term_in_Months__c  from OpportunityLineItem  where opportunityId = :opptyId];
        }catch(Exception e){
            system.debug('Error fetching Lines for opty '+e);
        }
        
        if(!olilist.isEmpty()){ 
            optylinemap.optylineflag= true;
        }
        else{
            optylinemap.optylineflag=false;
        }
        return optylinemap;
    }
    /*
@ Created /Modified : Apr 26,2019
* @description : Method to sync Expecetd Term to opportunity line items
* @param : Oppty Id 
* @return : string
*/ 
    @auraEnabled    
    public static String saveExpectedTermApex(Id opptyId){
        list<OpportunityLineItem> updateList = new list<OpportunityLineItem>();
        list<OpportunityLineItem> olilist = new list<OpportunityLineItem>();
        Decimal expectedTerm = NULL;
        String RetVal ;
        try{
            expectedTerm = [select Expected_Contract_Term__c  from opportunity  where Id = :opptyId].Expected_Contract_Term__c;
        }catch(Exception e){
            RetVal ='Error fetching values';
            system.debug('Error: fetching term->'+e);
        }
        
        try{
            olilist = [select id, Term_in_Months__c  from OpportunityLineItem  where opportunityId = :opptyId];
        }catch(Exception e){
            RetVal ='Error: fetching values';
            system.debug('Error fetching lines->'+e);
        }
        
        if(!olilist.isEmpty()){
            for(OpportunityLineItem each : olilist) 
            {
                OpportunityLineItem opl = new OpportunityLineItem(Id = each.Id);
                opl.Term_in_Months__c = expectedTerm;
                updateList.add(opl);
            }
            if(!updateList.isEmpty()){
                try{
                    update updateList;
                    RetVal = 'Success';
                }catch(exception e){
                    RetVal ='Error: Updating List';
                    system.debug('Error Updating List->'+e);
                }
            }
            else{
                RetVal = 'Error: Empty list';
            } 
        }
        else {
             RetVal = 'Error: empty lines';
        }
        
        return RetVal;
    }
    public class resultWrapper{
        @AuraEnabled public boolean optylineflag { get; set; }
        @AuraEnabled public decimal optylineitemExpectedTerm { get; set;}
        @AuraEnabled public string defaultSyncMessage { get; set; }
        @AuraEnabled public string defaultTermMessage { get; set; }
        @AuraEnabled public string defaultLineMessage { get; set; }
        @AuraEnabled public string defaultSuccessMessage { get; set; }
    }
}