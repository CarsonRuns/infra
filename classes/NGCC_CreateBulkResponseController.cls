/************************************************************************************************************************************
Name    : NGCC_CreateBulkResponseController
Author  : Ramzil Roxann
Purpose : Allow user to create responses for leads which are not valid for NGCC project through List view
Created Date: 2/25/2014
Modification History:  
                     Awnish added logic to populated source event number on the responses # PBI000000051342
*************************************************************************************************************************************/

public with sharing class NGCC_CreateBulkResponseController {

     // SCAVA Helper Method
     public static Boolean flsGet(SObjectField field)
    {
        return field.getDescribe().isCreateable() ? true : false;
    }
    
    // SCAVA Helper Method to validate Update Access at field level
     public static Boolean flsUpdateGet(SObjectField field)
    {
        return field.getDescribe().isUpdateable() ? true : false;
    }
    
    public Apexpages.StandardSetController controller {get;set;}
    public CC_Response__c response { get; set;}
    public string responsetype { get; set;}
    
    Set<Id> setleadId = new Set<Id>();
    List<Lead> lstleads = new List<Lead>();
    List<CC_Response__c> lstresponse = new List<CC_Response__c>();
    
    public NGCC_CreateBulkResponseController(ApexPages.StandardSetController stdcontroller) {
        this.controller = stdController; 
        response = new CC_Response__c();
        for(Lead l: (List<Lead>) controller.getSelected()){
            setleadId.add(l.id);                  
        }
        
        if(setleadId != null && !setleadId.isEmpty()){
            lstleads = [Select Id,Name,Route_to_AM__r.Email,Partner_Contact_Email__r.Email,Campaign_Name__c,
                        CustomCountry__c, source_event_number__c FROM Lead Where Id=:setleadId]; 
        }        
    }
    
    //@method: To create bulk response taking input from UI 
    public PageReference saveLeads() { 
        
        if(lstleads != null && !lstleads.isEmpty()){
            for(Lead leadobj : lstleads){  
                CC_Response__c respobj = new CC_Response__c();
                NGCC_QA_and_Lead_Mapping__c myCSStatus = NGCC_QA_and_Lead_Mapping__c.getValues(response.Status__c); 
                //SCAVA 
                if(flsGet(CC_Response__c.Lead__c)||flsUpdateGet(CC_Response__c.Lead__c)){
                respobj.Lead__c = leadobj.Id;
                }
                if(flsGet(CC_Response__c.Name)||flsUpdateGet(CC_Response__c.Name)){
                respobj.Name = leadobj.Name + System.now();
                }
                if(flsGet(CC_Response__c.AM_Email_Id__c)||flsUpdateGet(CC_Response__c.AM_Email_Id__c)){
                respobj.AM_Email_Id__c = leadobj.Route_to_AM__r.Email;
                }
                if(flsGet(CC_Response__c.Partner_Contact_Email_Id__c)||flsUpdateGet(CC_Response__c.Partner_Contact_Email_Id__c)){
                respobj.Partner_Contact_Email_Id__c = leadobj.Partner_Contact_Email__r.Email;
                }
                if(flsGet(CC_Response__c.Campaign__c)||flsUpdateGet(CC_Response__c.Campaign__c)){
                respobj.Campaign__c = leadobj.Campaign_Name__c;
                }
                if(flsGet(CC_Response__c.source_event_number__c)||flsUpdateGet(CC_Response__c.source_event_number__c)){
                respobj.source_event_number__c = leadobj.source_event_number__c; // Added by Awnish for Source Event Number Fix # PBI000000051342
                }
                if(flsGet(CC_Response__c.Status__c)||flsUpdateGet(CC_Response__c.Status__c)){
                respobj.Status__c = response.Status__c;
                }
                if(flsGet(CC_Response__c.Response_Type__c)||flsUpdateGet(CC_Response__c.Response_Type__c)){
                respobj.Response_Type__c = response.Response_Type__c;
                }
                if(flsGet(CC_Response__c.Notes__c)||flsUpdateGet(CC_Response__c.Notes__c)){
                respobj.Notes__c = response.Notes__c;
                }
                if(flsGet(CC_Response__c.Response_Date_Time__c)||flsUpdateGet(CC_Response__c.Response_Date_Time__c)){
                respobj.Response_Date_Time__c=System.now(); 
                }
                if(flsGet(CC_Response__c.Call_Status__c)||flsUpdateGet(CC_Response__c.Call_Status__c)){
                respobj.Call_Status__c = myCSStatus.Call_Status__c; 
                }//SCAVA
                lstresponse.add(respobj);
            }
        }
        
        if(lstresponse!= null && !lstresponse.isEmpty()){
            Database.insert(lstresponse,false);
        }
        
        return new PageReference('/00Q');        
    }
    
    /*@method: verify if any of the record is selected or not
      @returns true or false
    */
    public Boolean getHasSelected() {
        Boolean retval;
        if (controller.getSelected() == null || controller.getSelected().size() == 0) {
            ApexPages.Message errMsg = new ApexPages.Message(ApexPages.Severity.ERROR, 'Please select at least one Lead for creating CC Response');
            ApexPages.addMessage(errMsg);
            retval = false;
        } else {
            retval = true;
        }
        return retval;
    }
    
    /*@method: verify if any error occured
      @returns true or false
    */
    public Boolean getHasMessages() {
        Boolean retval;
        if (ApexPages.getMessages().size() == 0) {
            retval = false;
        } else {
            retval = true;
        }
        return retval;
    }
    
    /*@method: Provide back functionality to go back to List view
      @return pagereference back to list view
    */
    public PageReference CancelRecords(){
        return new PageReference('/00Q');
    }
}