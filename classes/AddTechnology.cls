/**
* @author       Sudic
* @version      Intial version (1.0)
* @since        2015-05-01 (YYYY-MM-DD)
* @description  OpportunityLineItem object extension controller class
**/
public with sharing class AddTechnology {
    public string finalJson{get;set;}
    public string setValue{get;set;}
    public string Profiles{get;set;}
    public string QIProfiles{get;set;}
    public string opptyRecordTypeId{get;set;} // Added by surya: To store opportunity recordtypeId
    public AddTechnology(ApexPages.StandardController controller){     
        // Added by surya: To get opportunity recordtypeId
        OpportunityLineItem opptyLineItem = (OpportunityLineItem)controller.getRecord();
        Opportunity oppty =[Select id,recordTypeId from opportunity where id =:opptyLineItem.OpportunityId];
        this.opptyRecordTypeId = oppty.recordTypeId;
        
        Profiles = Utilities.getConstant_CS('Exclude From PUI and Competitor Popup');
        QIProfiles = Utilities.getConstant_CS('QI2TechnologyProfiles');     
    }    
    @RemoteAction
    public static void SaveOppLineItems(list<OpportunityLineItem> lstInsert, list<OpportunityLineItem> lstUpdate, string oppId) { 
        system.debug('Oppty Line Item**************');
        system.debug('Before Upsert Oppty Line Item**************');
       
        if(lstInsert.size() > 0){
            insert lstInsert;
        }
        if(lstUpdate.size() > 0){
            update lstUpdate;
        }
    }
}