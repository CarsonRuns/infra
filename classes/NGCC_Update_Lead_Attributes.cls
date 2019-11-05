/* 
* NGCC_Update_Lead_Attributes is called by the NGCC_UpdateLeadAttributes trigger after an insert or update.
* @description: When called from the trigger, the UpdateLeadAttributes method determines if the call status
*     has a 'call completed' status. If so, the method gets all of the CC_Response_Detail__c records 
*     corresponding the CC_Response__c id that have a MODS_Question_Answer_Code__c found in the fieldMapping variable. 
*     The method then maps the Customer_Response__c to a Lead attribute field by adding it to a lead object and finally 
*     updates the Lead record.
*     Modification History - Try Catch block added at line 176 to handle the System.NullPointerException: Attempt to de-reference a null object
* @author: Daniel Pisciottano
* @created date: March 28, 2014
* 
* @updated: March 31, 2014 - Daniel Pisciottano - removed the update within the for loop and changed the fieldMapping variable to utilize the 
*    NGCC_QA_and_Lead_Mapping__c custom setting
* @updated: April 8, 2014 - Ramzil Cleopas 
*                          1. Added logic to check the logic works only if the response details records are marked as completed
*                          2. Added Code to update the Lead fields as Inactive/Invalid based on the response
*                          3. Mark the rented flag as false based on the response
*                          4. Update the Response disposition and Call Status Values on Lead Outcome and Call Status
* 
* Author  : Ghattamaneni Chaithanya
* Purpose : Adding Dispostion Sub Type field
*           Added to save the Selected Disposition Sub Type value Line No#240
*           Based on Selected Disposition and Disposition Sub Type fields changing Lead Contact Status Line No#241-246
* date    : July 17,2018
*
* Author  : Ghattamaneni Chaithanya
* Purpose : Added Contact Reason and Persona fields to page US291144
* 		    Line no: 245-248
* date    : June 13,2019
*                
*/

public class NGCC_Update_Lead_Attributes {
    
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
    
    static Map<Id,CC_Response__c> mapLeadResponse = new Map<Id,CC_Response__c>();
    static Map<String, NGCC_QA_and_Lead_Mapping__c> fieldMapping = new Map<String, NGCC_QA_and_Lead_Mapping__c>();
    static Map<Id,Lead> mapLeadUpdate = new Map<Id,Lead>();
    
    /* Method that processes the list of CC_Response__c objects sent from NGCC_UpdateLeadAttributes trigger */    
    public static void UpdateLeadAttributes(List<CC_Response__c> responses){
        // Initalize Lead list, id lists, and field mapping from the NGCC_QA_and_Lead_Mapping__c custom setting
        List<Lead> leadList = new List<Lead>();
        List<List<String>> idLists = new List<List<String>>();
        // Get list of response details that correspond to the response ids and appropriate MODS codes
        fieldMapping = NGCC_QA_and_Lead_Mapping__c.getAll();
        
        Set<String> responseIds = new Set<String>();
        
        //Map<Id,Id> mapLeadContact = new Map<Id,Id>();
        
        // Iterate over the responses and build out it lists
        for(CC_Response__c response : responses){
            if(!response.Call_Script_Executed__c || (response.Call_Script_Executed__c && response.No_of_Question__c != 0)){
                mapLeadResponse.put(response.Lead__c,response);      
            }                  
            // Verify a completed call status on the CC_Response__c object
            if(response.Call_Script_Completed__c && response.No_of_Question__c > 0){
                idLists.add(new List<String>{response.Id, response.Lead__c});
                responseIds.add(response.Id);
            }
        }
        
        if(!idLists.isEmpty()){
            UpdateLeadAttributesAgainstMODS(idLists,responseIds);
        }else
        {
            UpdateLeadDisposition(mapLeadUpdate,fieldMapping);
        }
        
    }
    
    /* Process all the Response Detail against the MODS mapping to Lead Attribute */
    public static void UpdateLeadAttributesAgainstMODS(List<List<String>> resLead,Set<String> resId){   
        
        List<CC_Response_Detail__c> details = [
            SELECT Response_Id__c, CC_Master_Question_Answer_Bank__r.MODS_Question_Answer_Code__c, Customer_Response__c ,Customer_Response_Detail__c
            FROM CC_Response_Detail__c 
            WHERE Response_Id__c IN :resId
            AND CC_Master_Question_Answer_Bank__r.MODS_Question_Answer_Code__c IN :fieldMapping.keySet()
        ];
        
        // Iterate over the list of ids and create a new lead with current lead id of the iteration
        for(List<String> idList : resLead){
            Lead firstlead = new Lead();
            //if(flsGet(lead.Id)||flsUpdateGet(lead.Id)){
            firstlead.Id = idList[1];
            //}
            
            // Iterate over all of the response detail records 
            for(CC_Response_Detail__c detail : details){
                // Only append customer responses if the current response id corresponds to the lead being updated
                if(detail.Response_Id__c == idList[0]){
                    // Retrieve the lead attribute field name relative to what the current response detail 
                    // matches to based on MODS code
                    //if(detail.Customer_Response_Detail__c != NULL){
                    boolean bAnswer;
                    String leadAttribute = fieldMapping.get(detail.CC_Master_Question_Answer_Bank__r.MODS_Question_Answer_Code__c).FieldName__c;
                    
                    if(fieldMapping.get(detail.CC_Master_Question_Answer_Bank__r.MODS_Question_Answer_Code__c).Field_Type__c ==  'Boolean'){
                        if(fieldMapping.get(detail.CC_Master_Question_Answer_Bank__r.MODS_Question_Answer_Code__c).True_Value__c == detail.Customer_Response_Detail__c)
                        {
                            bAnswer = True;
                        }else{
                            bAnswer = false;
                        }
                        firstlead.put(leadAttribute,bAnswer);
                    }else if(fieldMapping.get(detail.CC_Master_Question_Answer_Bank__r.MODS_Question_Answer_Code__c).Field_Type__c ==  'Numeric'){
                        if(detail.Customer_Response_Detail__c != NULL){
                            firstlead.put(leadAttribute,double.ValueOf(detail.Customer_Response_Detail__c));
                        }else{
                            firstlead.put(leadAttribute,NULL);
                        }
                    }else if(fieldMapping.get(detail.CC_Master_Question_Answer_Bank__r.MODS_Question_Answer_Code__c).Field_Type__c ==  'DateTime'){
                        if(detail.Customer_Response_Detail__c != NULL){
                            string strDT= detail.Customer_Response_Detail__c;
                            DateTime dT = DateTime.parse(strDT);
                            
                            firstlead.put(leadAttribute,dT);
                        }else{
                            firstlead.put(leadAttribute,NULL);
                        }
                    }else if(fieldMapping.get(detail.CC_Master_Question_Answer_Bank__r.MODS_Question_Answer_Code__c).Field_Type__c ==  'Date'){
                        if(detail.Customer_Response_Detail__c != NULL){
                            string strDate= detail.Customer_Response_Detail__c.substring(0,detail.Customer_Response_Detail__c.indexOf(' '));
                            firstlead.put(leadAttribute,Date.parse(strDate));
                        }else{
                            firstlead.put(leadAttribute,NULL);
                        }
                    }else if(fieldMapping.get(detail.CC_Master_Question_Answer_Bank__r.MODS_Question_Answer_Code__c).Field_Type__c != NULL &&
                             fieldMapping.get(detail.CC_Master_Question_Answer_Bank__r.MODS_Question_Answer_Code__c).Field_Type__c.CONTAINS('CharLimit')){
                                 if(detail.Customer_Response_Detail__c != NULL){
                                     string strNewValue = '';
                                     string strLimit = fieldMapping.get(detail.CC_Master_Question_Answer_Bank__r.MODS_Question_Answer_Code__c).Field_Type__c;
                                     Integer intLimit = Integer.valueOf(strLimit.substring(strLimit.indexOf('-')+1));
                                     
                                     if(detail.Customer_Response_Detail__c.length() > intLimit ){
                                         strNewValue = detail.Customer_Response_Detail__c.substring(0,intLimit);
                                     } else {
                                         strNewValue = detail.Customer_Response_Detail__c;
                                     }
                                     firstlead.put(leadAttribute,strNewValue);
                                 }else{
                                     firstlead.put(leadAttribute, NULL);
                                 }
                             }else{
                                 firstlead.put(leadAttribute,detail.Customer_Response_Detail__c);
                             }
                    //}
                }
            }
            mapLeadUpdate.put(firstlead.Id,firstlead);
        }
        system.debug('mapLeadUpdate==='+mapLeadUpdate);
        UpdateLeadDisposition(mapLeadUpdate,fieldMapping);
        
    }
    
    /* Process the Disposition value and update some additional attribute required as per mapping object */
    public static  void UpdateLeadDisposition(Map<Id,Lead> mapLead, Map<String, NGCC_QA_and_Lead_Mapping__c> fieldDispositionMapping){       
        try{
            for(Id res : mapLeadResponse.KeySet()){
                Lead lead;
                String status = mapLeadResponse.get(res).Status__c;
                System.debug(status);
                if(mapLead.containsKey(res)){
                    lead = mapLead.get(res);
                } else {
                    lead = new Lead();
                    lead.Id = res;
                }
                lead ltd = [select id,status,No_of_Attempts__c,First_Call_Attempt__c from lead where id =: lead.Id ];
                if (ltd.No_of_Attempts__c == Null) {
                    lead.put('No_of_Attempts__c',0);
                    lead.put('First_Call_Attempt__c',System.now());
                }
                if (ltd.No_of_Attempts__c == 0){
                    lead.put('First_Call_Attempt__c',System.now());
                }
                lead.put('No_of_Attempts__c',ltd.No_of_Attempts__c + 1);
                NGCC_QA_and_Lead_Mapping__c myCSStatus = NGCC_QA_and_Lead_Mapping__c.getValues(status);
                if(myCSStatus != Null){
                    if (myCSStatus.Lead_Status__c != Null && myCSStatus.Lead_Status__c != '') {
                        lead.put('Status',myCSStatus.Lead_Status__c);
                    }
                }
                if(fieldDispositionMapping.get(status).Purpose__c == 'Call Disposition - Additional'){
                    String leadFieldName = fieldDispositionMapping.get(status).FieldName__c;
                    String leadFieldValue = fieldDispositionMapping.get(status).FieldValue__c;
                    
                    if(leadFieldName != null){
                        if(leadFieldValue == 'TRUE' || leadFieldValue == 'FALSE'){
                            lead.put(leadFieldName ,Boolean.valueOf(leadFieldValue));
                        } else {
                            lead.put(leadFieldName ,leadFieldValue);
                        }
                    }
                    
                    if(fieldDispositionMapping.get(status).Update_Lead_Status__c == True){
                        lead.put('Status',fieldDispositionMapping.get(status).Lead_Status__c);   
                    }
                }
                
                if(fieldDispositionMapping.get(status).Purpose__c == 'Call Disposition - Call Back'){
                    lead.put('Call_Back_Date_Time__c',mapLeadResponse.get(res).Call_Back_Time__c);
                }
                // Update the Outcome and Call Status on Lead
                if(mapLeadResponse.get(res).Lead_Description__c != NULL){
                    lead.put('Description',mapLeadResponse.get(res).Lead_Description__c);
                }
                
                /*Update the Call script executed process*/
                if(mapLeadResponse.get(res).Call_Script_Executed__c){
                    lead.put('Is_Call_Script_Executed__c',true);
                }
                
                lead.put('Outcome__c',status);
                // Added by gchaitha to save the Disposition Sub Type value
                lead.put('Disposition_Sub_Type__c',mapLeadResponse.get(res).Disposition_Sub_Type__c);
                if(status =='Invalid Info' && (mapLeadResponse.get(res).Disposition_Sub_Type__c == 'Duplicate Prospect' || mapLeadResponse.get(res).Disposition_Sub_Type__c == 'No longer with Company' || mapLeadResponse.get(res).Disposition_Sub_Type__c == 'Not Fit Wrong Contact')){
                    lead.put('Contact_Status__c','Inactive');
                }else if(status =='Invalid Info' && (mapLeadResponse.get(res).Disposition_Sub_Type__c == 'Phone')){
                    lead.put('Phone_Status__c','Invalid');                             
                }else if(status =='Invalid Info' && (mapLeadResponse.get(res).Disposition_Sub_Type__c == 'Email')){
                    lead.put('Email_Status__c','InValid');                             
                }else{
                    lead.put('Contact_Status__c','Active');
                }
                lead.put('Call_Status__c',mapLeadResponse.get(res).Call_Status__c);
                lead.put('Lead_Qualification_Error__c','');     
                lead.put('Medium_Type__c',mapLeadResponse.get(res).Response_Type__c);  
                lead.put('Latest_Agent_Notes__c',mapLeadResponse.get(res).Notes__c);
                
                // added by gchaitha US291144
                lead.put('Contact_Reason__c',mapLeadResponse.get(res).Contact_Reason__c);
                lead.put('Persona__c',mapLeadResponse.get(res).Persona__c);
                //end
                mapLead.put(lead.Id,lead);    
            }
            
            // Update the list of lead objects with field updates
            if(mapLead.values().size()>0){                
                List<Lead> lUpdate = mapLead.values();
                system.debug('Status=='+lUpdate[0].Status);
                Database.SaveResult[] updateResponse = Database.Update(lUpdate, false);
                system.debug('updateResponse=='+updateResponse);
                List<Lead> lNewUpdate = new List<Lead>();
                List<Tx_Log__c> errObj=new List<Tx_Log__c>();               
                integer i=0;                
                for(Database.SaveResult sr : updateResponse){ 
                    if (sr.isSuccess()==false) {              
                        Lead l = lUpdate[i];
                        for(Database.Error err : sr.getErrors()) {
                            if(flsGet(lead.Lead_Qualification_Error__c)||flsUpdateGet(lead.Lead_Qualification_Error__c)){
                                l.Lead_Qualification_Error__c = err.getMessage();
                            }
                            Tx_Log__c newErrorRecord = new Tx_Log__c();
                            if(flsGet(Tx_Log__c.name)||flsUpdateGet(Tx_Log__c.name)){
                                newErrorRecord.name = 'User: '+ UserInfo.getUserId();
                            }
                            if(flsGet(Tx_Log__c.originated__c)||flsUpdateGet(Tx_Log__c.originated__c)){
                                newErrorRecord.originated__c = 'NGCC_Call_Script';
                            }
                            if(flsGet(Tx_Log__c.type__c)||flsUpdateGet(Tx_Log__c.type__c)){
                                newErrorRecord.type__c = 'Lead: '+ l.Id;
                            }
                            if(flsGet(Tx_Log__c.exception__c)||flsUpdateGet(Tx_Log__c.exception__c)){
                                newErrorRecord.exception__c = true;
                            }
                            if(flsGet(Tx_Log__c.message__c)||flsUpdateGet(Tx_Log__c.message__c)){
                                newErrorRecord.message__c = err.getMessage()+ ' ' +err.getStatusCode();
                            }
                            errObj.add(newErrorRecord);
                        }
                        lNewUpdate.add(l);
                    }
                    i++;
                }
                if(!lNewUpdate.isEmpty()){
                    insert errObj;                               
                    Database.SaveResult[] updateResponseAfterError = Database.Update(lNewUpdate, false);
                }
            }           
            //End Here                                                                                                          
        }catch(Exception e){
            system.debug('exception=='+e);
            system.debug('exception=='+e.getLineNumber());
        }
    }
}