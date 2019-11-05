/*********************************************************************************************************************************
Name    : NGCC_Campaign_Management_Cls
Author  : Ramzil
Purpose : This class is to handle all Campaign related activity for NGCC project
            Assigning Theater and Default Call Script
            Closing Lead when Campaign is Cancelled and Closed
            
Created Date:  1/25/2014 
Modification History:   @Mukesh Modified to make readable code
                        @Mukesh added Maximum attempt and priority update to all lead
						Nirup, update to default call script only if the field is null (2/16/16)
                     
**********************************************************************************************************************************/
public class NGCC_Campaign_Management_Cls{
    
	//@ method: To process All before activity on Campaign Object
    public static void NGCC_Campaign_Management_Before(List<Campaign> newLstCampaign){
        
        List<Campaign> lstCampCallScriptAssignment = new List<Campaign>();
        Map<String,NGCC_Mapping_Object__c> mapMPObj=new Map<String,NGCC_Mapping_Object__c>();        
        for(NGCC_Mapping_Object__c mObj: [Select Name,Id,Theater__c from NGCC_Mapping_Object__c]){
            mapMPObj.put(mObj.Name,mObj);
        }  
        for(Campaign camp: newLstCampaign){
            //system.debug('Check2');
            //system.debug('CALL -->' +camp.Call_Script__c);
            //system.debug('Program -->' +camp.Program_Originating_Country__c);
            if(camp.Program_Originating_Country__c != null && camp.Call_Script__c == null){
                //system.debug('Check3-->'+mapMPObj);
                if(mapMPObj.containsKey(camp.Program_Originating_Country__c)){
                    //system.debug('Check4-->' +mapMpObj);
                  camp.Theatre__c = mapMPObj.get(camp.Program_Originating_Country__c).Theater__c;
                  lstCampCallScriptAssignment.add(Camp);
                }
            }
        }
        NGCC_Campaign_CallScript_Assignment(lstCampCallScriptAssignment);
    }   
    //@ method: To process assign Theater and Default Call Script
    public static void NGCC_Campaign_CallScript_Assignment(List<Campaign> newLstCampaign){  
        set<string> theaterSet = new set<string>();
        for(Campaign cm : newLstCampaign){
            if(cm.Theatre__c != null){
                theaterSet.add(cm.Theatre__c);
            }
        }
        
        Map<String, Id> mapTheaterCallScript = new Map<String,Id>(); // If campaign source is not a "Global Eloqua"
        Map<String, Id> mapTheaterCallScript_Eloqua = new Map<String,Id>();// If campaign source is  a " Global Eloqua"
        for(CC_Call_Script__c csObj: [Select Id, Theater__c,Default_Call_Script__c,Source__c FROM CC_Call_Script__c Where Default_Call_Script__c=true AND Theater__c In :theaterSet])
        {
            if(csObj.Source__c == 'Global Eloqua'){
                mapTheaterCallScript_Eloqua.put(csObj.Theater__c,csObj.Id);
            }else{
                mapTheaterCallScript.put(csObj.Theater__c,csObj.Id); // If source is empty in call script , considering call script not related Global Eloqua            
            }
            
        }
        
        for(Campaign camp: newLstCampaign){
            
            if(camp.Campaign_source__c == 'Global Eloqua'){
                if(mapTheaterCallScript_Eloqua.containsKey(camp.Theatre__c)){
                    camp.Call_Script__c = mapTheaterCallScript_Eloqua.get(camp.Theatre__c);
                } 
            }else{
                if(mapTheaterCallScript.containsKey(camp.Theatre__c)){
                    camp.Call_Script__c = mapTheaterCallScript.get(camp.Theatre__c);
                } 
            }
            
                  
        }       
    }
    static map<Id,Campaign> mapCIdCamp= new map<Id,Campaign>();
    static Set<Id> setCampId = new Set<Id>();
    
    //@ method: To process All after activity on Campaign Object
    public static void NGCC_Campaign_Management_After(List<Campaign> newLstCampaign,Map<Id,Campaign> mapIdCampaign){ 
    
        for(Campaign camp: newLstCampaign){
            if(camp.Status != mapIdCampaign.get(camp.Id).Status){
                if(camp.Status == 'Cancelled' || camp.Status == 'Completed'){
                    setCampId.add(camp.Id);
                }
            }
            
            if(camp.Status != 'Cancelled' || camp.Status != 'Completed'){
                    if(camp.Priority__c != mapIdCampaign.get(camp.Id).Priority__c){
                        mapCIdCamp.put(camp.Id,camp);
                    }
            }
        }
        
        NGCC_Campaign_Lead_Update(setCampId);
    }
    // @ method: To process Close all Leads when campaign is completed or cancelled   
    public static void NGCC_Campaign_Lead_Update(Set<Id> setCanClsdCampaign){
        List<Lead> lstLeadToProcess = [Select Id, Call_Status__c,Outcome__c,ProgramEvent__c,Campaign_Name__c FROM Lead 
                                        Where Campaign_Name__c IN : setCanClsdCampaign OR  Campaign_Name__c IN :mapCIdCamp.keySet()]; 
        for(Lead ldObj: lstLeadToProcess){
            if(setCampId.contains(ldObj.Campaign_Name__c )){
                ldObj.Call_Status__c = 'PE Cancelled/Completed';
                ldObj.Status = 'Inactive';
            }
        }        
        if(!lstLeadToProcess.isEmpty()){
            Database.SaveResult[] updateLeadStatus = Database.update(lstLeadToProcess ,false);
            system.debug('*************'+lstLeadToProcess.size());
        }
    }  
}