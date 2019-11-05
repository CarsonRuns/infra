/***************************************************************************************************
Name    : NGCC_PS_CreateResponseDetails_Flow
Author  : Gaurav Singh
Purpose : This class is used in Custome Engagement Tool, it is responsible to create Response Details
Date	: 15-Jan-2019

Modification History: 

*****************************************************************************************************/

public class NGCC_PS_CreateResponseDetails_Flow {
    @InvocableMethod
    public static void createResponseDetails(List<Id> responseIds){
        Id responseId = responseIds[0];        
        CC_Response__c response 			= [select id, Lead__c, Lead__r.Id, Lead__r.Name, Lead__r.CustomCountry__c from CC_Response__c where id = :responseId limit 1]; 
        CC_PreSales_Flow_Call_Script__c cs 	= CC_PreSales_Flow_Call_Script__c.getOrgDefaults();
        CC_Call_Script__c callScript 		= [select id,Theater__c from CC_Call_Script__c where Name = :cs.Call_Script_Name__c limit 1];
        
        if(flsGet(CC_Response__c.Call_Script__c)){
        	response.Call_Script__c = callScript.Id;
        }
        
        List<NGCC_Mapping_Object__c> mObj = [Select Language__c from NGCC_Mapping_Object__c where Name = : response.Lead__r.CustomCountry__c];
        if( !mObj.isEmpty() ){
            response.Language__c = mObj[0].Language__c;
        }else{
            if( flsGet(CC_Response__c.Language__c) ){
                response.Language__c = 'English: en_US';
            }
        }
        update response;
        
        createCallScript( response );
    }
    
    public static void createCallScript( CC_Response__c response ) {
        List<CC_Response_Detail__c> newResDetail 				= new List <CC_Response_Detail__c>();
        Map<String, NGCC_QA_and_Lead_Mapping__c> fieldMapping 	= NGCC_QA_and_Lead_Mapping__c.getAll();
        
        if(response.Call_Script__c != Null){
            Lead leadPrepopulation = getLeadPrePopulation( response.Lead__r.Id, fieldMapping );
            
            Map<String,NGCC_Response_Detail_To_Call_Script_Q_A__c> mapResDetailToCSQA = NGCC_Response_Detail_To_Call_Script_Q_A__c.getAll();
            string query = 'SELECT Id';
            for (NGCC_Response_Detail_To_Call_Script_Q_A__c csQ: mapResDetailToCSQA.values()) {
                query += ',' + csQ.Call_Script_Q_A_Field__c;
            }
            
            query 	+= 	',Validation_Both_Conditional_or_Required__c, CC_Master_Question_Bank__r.MODS_Question_Answer_Code__c '
                	+	' from CC_Call_Script_Q_A__c where Call_Script__c = \'' + response.Call_Script__c + '\'';
            List<CC_Call_Script_Q_A__c> responseDetails = database.query(query);
            
            for (CC_Call_Script_Q_A__c r: responseDetails) {
                CC_Response_Detail__c newDetail = new CC_Response_Detail__c();
                
                for (String strResDetail: mapResDetailToCSQA.keyset()) {
                    newDetail.put(strResDetail, r.get(mapResDetailToCSQA.get(strResDetail).Call_Script_Q_A_Field__c));
                }
                newDetail.Response_Id__c = response.Id;
                newDetail.Validation_Both_Conditional_or_Required__c = r.Validation_Both_Conditional_or_Required__c;
                
                if( fieldMapping.keySet().contains( r.CC_Master_Question_Bank__r.MODS_Question_Answer_Code__c ) ){
                    system.debug('----------- r.CC_Master_Question_Bank__r.MODS_Question_Answer_Code__c '+r.CC_Master_Question_Bank__r.MODS_Question_Answer_Code__c);
                    String leadAttribute = fieldMapping.get(r.CC_Master_Question_Bank__r.MODS_Question_Answer_Code__c).FieldName__c;
                    system.debug('leadAttribute=='+leadAttribute);
                    if(fieldMapping.get(r.CC_Master_Question_Bank__r.MODS_Question_Answer_Code__c).Field_Type__c ==  'Boolean'){
                        if( (Boolean)leadPrepopulation.get(leadAttribute) == true ){
                            newDetail.Customer_Response_Detail__c = fieldMapping.get(r.CC_Master_Question_Bank__r.MODS_Question_Answer_Code__c).True_Value__c;
                        }else{
                            newDetail.Customer_Response_Detail__c = 'false';
                        }
                    }else if(fieldMapping.get(r.CC_Master_Question_Bank__r.MODS_Question_Answer_Code__c).Field_Type__c ==  'Numeric'){
                        if( (Double)leadPrepopulation.get(leadAttribute) != NULL ){
                            newDetail.Customer_Response_Detail__c = String.valueOf( (Double)leadPrepopulation.get(leadAttribute) );
                        }else{
                            newDetail.Customer_Response_Detail__c = NULL;
                        }
                    }else if(fieldMapping.get(r.CC_Master_Question_Bank__r.MODS_Question_Answer_Code__c).Field_Type__c ==  'DateTime'){
                        if( (DateTime)leadPrepopulation.get(leadAttribute) != NULL ){
                            newDetail.Customer_Response_Detail__c = String.valueOf( (DateTime)leadPrepopulation.get(leadAttribute) );
                        }else{
                            newDetail.Customer_Response_Detail__c = NULL;
                        }
                    }else if(fieldMapping.get(r.CC_Master_Question_Bank__r.MODS_Question_Answer_Code__c).Field_Type__c ==  'Date'){
                        if( (Date)leadPrepopulation.get(leadAttribute) != NULL ){
                            newDetail.Customer_Response_Detail__c = String.valueOf( (Date)leadPrepopulation.get(leadAttribute) );
                        }else{
                            newDetail.Customer_Response_Detail__c = NULL;
                        }
                    }else if(fieldMapping.get(r.CC_Master_Question_Bank__r.MODS_Question_Answer_Code__c).Field_Type__c != NULL && fieldMapping.get(r.CC_Master_Question_Bank__r.MODS_Question_Answer_Code__c).Field_Type__c.CONTAINS('CharLimit')){
                                 if( (String)leadPrepopulation.get(leadAttribute) != NULL ){
                                     newDetail.Customer_Response_Detail__c = (String)leadPrepopulation.get(leadAttribute);
                                 }else{
                                     newDetail.Customer_Response_Detail__c = NULL;
                                 }
                     }else{
                         if( (String)leadPrepopulation.get(leadAttribute) != NULL ){
                             newDetail.Customer_Response_Detail__c = (String)leadPrepopulation.get(leadAttribute);
                         }else{
                             newDetail.Customer_Response_Detail__c = NULL;
                         }      
                     }
                }
                
                newResDetail.add(newDetail);
            }
            database.insert(newResDetail,false);
        }
    }
    
    public static Lead getLeadPrePopulation( Id leadId, Map<String,NGCC_QA_and_Lead_Mapping__c> mapLeadDetailQA ) {
        string query = 'SELECT Id,Email';
        for (NGCC_QA_and_Lead_Mapping__c lDetail: mapLeadDetailQA.values()) {
            if (lDetail.Purpose__c != null && lDetail.Purpose__c.contains('Lead')) {
                if (!query.contains(lDetail.FieldName__c) &&  !lDetail.FieldName__c.contains('Phone')) {
                    query = query + ',' + lDetail.FieldName__c;
                }
            }
        }
        query = query + ',Phone,MobilePhone,Route_to_AM__r.Email,ProgramEvent__c,Partner_Contact_Email__r.Email,';
        query = query + 'First_Call_Attempt__c,No_of_Attempts__c, Campaign_Name__r.Call_Script__c,Campaign_Name__r.Maximum_No_Attempts__c';
        query = query + ' FROM Lead WHERE Id = \'' + leadId + '\' LIMIT 1';
        return Database.query(query);
    }
    
    public static Boolean flsGet(SObjectField field){
        return field.getDescribe().isCreateable() ? true : false;
    }
}