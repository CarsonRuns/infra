/*****************************************************************************************************************************
Name    : NGCC_CallScript_Preview_Mgmt_CTE 
Author  : Mukesh Srivastava
Purpose : This is the controller class for Call Script Preview. This controller class handles Q&A generation, 
            translation,validation, routing and overall call script requirement
Created Date: 4/30/2014
Modification History: 

******************************************************************************************************************************/

public class NGCC_CallScript_Preview_Mgmt_CTE {

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

    Public CC_Response__c response { get; set;}
    String strCallScript;
    String strCallScriptTheater;
    
    List<CC_Response_Detail__c > newResDetail = new List<CC_Response_Detail__c >();  
        
    public NGCC_CallScript_Preview_Mgmt_CTE(ApexPages.StandardController controller) {        
        strCallScript= ApexPages.currentPage().getParameters().get('CallScript');
        strCallScriptTheater = ApexPages.currentPage().getParameters().get('Theater');       
        response = new CC_Response__c();
    }
    
   
     /* @method: Update the call script status so that we can make sure Categories are populated which is required for call script invocation */
    public boolean updateStats(){
        Boolean updateStatus;
        
        CC_Call_Script__c ccCS=[Select Status__c, Question_Categories__c,Preview_Count__c from  CC_Call_Script__c where Id =: strCallScript Limit 1]; 
        // SCAVA Fix
        if(flsGet(CC_Call_Script__c.Status__c)||flsUpdateGet(CC_Call_Script__c.Status__c)){
        ccCS.Status__c = 'Previewed';
        }
        if(ccCS.Preview_Count__c == Null)
        {
            if(flsGet(CC_Call_Script__c.Preview_Count__c)||flsUpdateGet(CC_Call_Script__c.Preview_Count__c)){
            ccCS.Preview_Count__c = 0;
            }
        }else{
            ccCS.Preview_Count__c += 1;
        }         
        try
        {
            Database.SaveResult updateCallScript = Database.Update(ccCS,false);
            updateStatus = true;
        }catch(exception e)
        {            
            updateStatus = false;
        }        
        return updateStatus;
    }   
    
     /* @method: Allowing user to launch the call script after creating response and response detail and passing requried information via URL Parameter */
    public pageReference launchCallScript(){
        if(updateStats())
            // SCAVA Fix
        {
            if(flsGet(CC_Response__c.Call_Script__c)||flsUpdateGet(CC_Response__c.Call_Script__c)){
            response.Call_Script__c = strCallScript;
            }
            if(flsGet(CC_Response__c.Name)||flsUpdateGet(CC_Response__c.Name)){
            response.Name = 'Preview Call Script';                
            }
            Database.SaveResult insertResponse = Database.Insert(response,true);        
            CC_Response__c newResponse = [SELECT Id,Name,Language__c,Call_Script__c from CC_Response__c where Id =: response.Id];
            
            createCallScript(newResponse );
            List<string> langcode = newResponse.language__c.split(': ');
            string redirectURL = '/apex/NGCC_CallScript_Preview?preview=yes&ResponseId='+newResponse.Id+'&lang='+langcode[1]+'&retURL='+strCallScript;          
            
            PageReference previewPage = new PageReference(redirectURL );        
            previewPage.setRedirect(true);        
            return previewPage;
        }else
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Please correct Call Script Q&A\'s as there are some missing Question Type or Question Category'));
            return null;
        }
    }
    
    /* @method: Creating the new response detail with almost cloning Call Script Q&A */
    public void createCallScript(CC_Response__c response){
        
        List<CC_Call_Script_Q_A__c> responseDetails = [select Name,help_text__c, Question_Category__c,Conditionaly_Required_If__c,Conditionally_Required_Criteria__c,
                                                       Sequence__c,Required__c,Question_Type__c, Answer_Options__c,Required_on_Lead_Description__c,
                                                       Question_Text__c, Call_Script__c,CC_Master_Question_Bank__c,Local_to_SFDC__c ,
                                                       Minimum_If_Number_Validation__c,Maximum_If_Number_Validation__c,Question_Required__c,Validation_Both_Conditional_or_Required__c  
                                                       from CC_Call_Script_Q_A__c WHERE Call_Script__c = :response.Call_Script__c];
        
        for (CC_Call_Script_Q_A__c r: responseDetails){
            CC_Response_Detail__c newDetail = new CC_Response_Detail__c();
            // SCAVA Fix
            if(flsGet(CC_Response_Detail__c.Name)||flsUpdateGet(CC_Response_Detail__c.Name)){
            newDetail.Name = r.Name;
            }
            if(flsGet(CC_Response_Detail__c.Question_Category__c)||flsUpdateGet(CC_Response_Detail__c.Question_Category__c)){
            newDetail.Question_Category__c = r.Question_Category__c;
            }
            if(flsGet(CC_Response_Detail__c.Conditionaly_Required_If__c)||flsUpdateGet(CC_Response_Detail__c.Conditionaly_Required_If__c)){
            newDetail.Conditionaly_Required_If__c = r.Conditionaly_Required_If__c;
            }
            if(flsGet(CC_Response_Detail__c.Conditionally_Required_Criteria__c)||flsUpdateGet(CC_Response_Detail__c.Conditionally_Required_Criteria__c)){
            newDetail.Conditionally_Required_Criteria__c = r.Conditionally_Required_Criteria__c;
            }
            if(flsGet(CC_Response_Detail__c.Sequence__c)||flsUpdateGet(CC_Response_Detail__c.Sequence__c)){
            newDetail.Sequence__c = r.Sequence__c;
            }
            if(flsGet(CC_Response_Detail__c.Required__c)||flsUpdateGet(CC_Response_Detail__c.Required__c)){
            newDetail.Required__c = r.Required__c;
            }
            if(flsGet(CC_Response_Detail__c.Question_Type__c)||flsUpdateGet(CC_Response_Detail__c.Question_Type__c)){
            newDetail.Question_Type__c = r.Question_Type__c;
            }
            if(flsGet(CC_Response_Detail__c.Answer_Options_Id__c)||flsUpdateGet(CC_Response_Detail__c.Answer_Options_Id__c)){
            newDetail.Answer_Options_Id__c = r.Answer_Options__c;
            }
            if(flsGet(CC_Response_Detail__c.Question_Text__c)||flsUpdateGet(CC_Response_Detail__c.Question_Text__c)){
            newDetail.Question_Text__c = r.Question_Text__c;
            }
            if(flsGet(CC_Response_Detail__c.Call_Script__c)||flsUpdateGet(CC_Response_Detail__c.Call_Script__c)){
            newDetail.Call_Script__c = r.Call_Script__c;
            }
            newDetail.Response_Id__c  = response.Id;
            // SCAVA Fix
            if(flsGet(CC_Response_Detail__c.CC_Master_Question_Answer_Bank__c)||flsUpdateGet(CC_Response_Detail__c.CC_Master_Question_Answer_Bank__c)){
            newDetail.CC_Master_Question_Answer_Bank__c = r.CC_Master_Question_Bank__c;
            }
            if(flsGet(CC_Response_Detail__c.Local_to_SFDC__c)||flsUpdateGet(CC_Response_Detail__c.Local_to_SFDC__c)){
            newDetail.Local_to_SFDC__c = true;
            }
            if(flsGet(CC_Response_Detail__c.Question_Required__c)||flsUpdateGet(CC_Response_Detail__c.Question_Required__c)){
            newDetail.Question_Required__c = r.Question_Required__c;
            }
            if(flsGet(CC_Response_Detail__c.Minimum_If_Number_Validation__c)||flsUpdateGet(CC_Response_Detail__c.Name)){
            newDetail.Maximum_If_Number_Validation__c= r.Maximum_If_Number_Validation__c;
            }
            if(flsGet(CC_Response_Detail__c.Name)||flsUpdateGet(CC_Response_Detail__c.Minimum_If_Number_Validation__c)){
            newDetail.Minimum_If_Number_Validation__c= r.Minimum_If_Number_Validation__c;
            }
            if(flsGet(CC_Response_Detail__c.Validation_Both_Conditional_or_Required__c)||flsUpdateGet(CC_Response_Detail__c.Validation_Both_Conditional_or_Required__c)){
            newDetail.Validation_Both_Conditional_or_Required__c= r.Validation_Both_Conditional_or_Required__c;
            }
            if(flsGet(CC_Response_Detail__c.Required_on_Lead_Description__c)||flsUpdateGet(CC_Response_Detail__c.Required_on_Lead_Description__c)){
            newDetail.Required_on_Lead_Description__c= r.Required_on_Lead_Description__c;
            }
            if(flsGet(CC_Response_Detail__c.Customer_Response__c)||flsUpdateGet(CC_Response_Detail__c.Customer_Response__c)){
            newDetail.Customer_Response__c = '';
            }
            if(flsGet(CC_Response_Detail__c.Customer_Response_Detail__c)||flsUpdateGet(CC_Response_Detail__c.Customer_Response_Detail__c)){
            newDetail.Customer_Response_Detail__c= '';
            }
            if(flsGet(CC_Response_Detail__c.Customer_Response_Detail_Local__c)||flsUpdateGet(CC_Response_Detail__c.Customer_Response_Detail_Local__c)){
            newDetail.Customer_Response_Detail_Local__c = '';
            }
            if(flsGet(CC_Response_Detail__c.Help_Text__c)||flsUpdateGet(CC_Response_Detail__c.Help_Text__c)){
            newDetail.Help_Text__c = r.Help_Text__c;
            }
            
            newResDetail.add(newDetail);
        }
        Database.SaveResult[] insertResponseDetail = Database.Insert(newResDetail,false);
    } 
    
    public List<NGCC_Lead_Attribute_Wrapper> lstLeadAttribute {get;set;}
    public List<NGCC_Lead_Qualification_Wrapper> lstLeadQualification {get;set;}
    
    public class NGCC_Lead_Attribute_Wrapper{
        public String modsCode{get;set;}
        public Boolean available{get;set;}
        public String purpose{get;set;}

        public NGCC_Lead_Attribute_Wrapper(String purpose, String modsCode, Boolean available) {
            this.purpose = purpose;
            this.modsCode = modsCode ;
            this.available = available ;            
        }
    }
    
    public class NGCC_Lead_Qualification_Wrapper{
        public String modsCode{get;set;}
        public Boolean available{get;set;}
        public String purpose{get;set;}

        public NGCC_Lead_Qualification_Wrapper(String purpose, String modsCode, Boolean available) {
            this.purpose = purpose;
            this.modsCode = modsCode ;
            this.available = available ;            
        }
    }
    
    public void validateCallScript(){
        lstLeadAttribute = new List < NGCC_Lead_Attribute_Wrapper >();
        lstLeadQualification = new List < NGCC_Lead_Qualification_Wrapper >();
        
        Set<String> strAddedQA = new Set<String>(); // added as csMapping collection is read only in nature
        Map<String, NGCC_QA_and_Lead_Mapping__c> allFieldMapping = NGCC_QA_and_Lead_Mapping__c.getAll();
        Map<String, NGCC_QA_and_Lead_Mapping__c> fieldMapping = new Map<String, NGCC_QA_and_Lead_Mapping__c>();
        Set<String> strQuestionCode = new Set<String>();
        Map<String,String> mapQuesText = new Map<String,String>();
        
        for(NGCC_QA_and_Lead_Mapping__c qaLM: allFieldMapping.values()){
            if(qaLM.Theater__c != NULL){            
                if(qaLM.Theater__c.contains(strCallScriptTheater)){
                    fieldMapping.put(qaLM.Name,qaLM);
                    strQuestionCode.add(qaLM.Name);
                }
            }
        }
        
        for(CC_Master_Question_Answer_Bank__c ccMQAB:[Select Id,Question_Text__c,MODS_Question_Answer_Code__c from CC_Master_Question_Answer_Bank__c 
                                                    WHERE MODS_Question_Answer_Code__c IN : strQuestionCode]){
            mapQuesText.put(ccMQAB.MODS_Question_Answer_Code__c,ccMQAB.Question_Text__c);
        }
        
        for(CC_Call_Script_Q_A__c callScriptQA: [Select Id,CC_Master_Question_Bank__r.MODS_Question_Answer_Code__c from CC_Call_Script_Q_A__c
                                                    WHERE Call_Script__c = :strCallScript])
        {
            if(fieldMapping.containsKey(callScriptQA.CC_Master_Question_Bank__r.MODS_Question_Answer_Code__c))
            {
                if(fieldMapping.get(callScriptQA.CC_Master_Question_Bank__r.MODS_Question_Answer_Code__c).purpose__c.contains('Attribute'))
                {
                    lstLeadAttribute.add(new NGCC_Lead_Attribute_Wrapper(
                                    mapQuesText.get(callScriptQA.CC_Master_Question_Bank__r.MODS_Question_Answer_Code__c),
                                    callScriptQA.CC_Master_Question_Bank__r.MODS_Question_Answer_Code__c,
                                    true));                
                    strAddedQA.add(callScriptQA.CC_Master_Question_Bank__r.MODS_Question_Answer_Code__c);
                }else if(fieldMapping.get(callScriptQA.CC_Master_Question_Bank__r.MODS_Question_Answer_Code__c).purpose__c.contains('Qualification'))
                {
                    lstLeadQualification.add(new NGCC_Lead_Qualification_Wrapper (
                                    mapQuesText.get(callScriptQA.CC_Master_Question_Bank__r.MODS_Question_Answer_Code__c),
                                    callScriptQA.CC_Master_Question_Bank__r.MODS_Question_Answer_Code__c,
                                    true));                
                    strAddedQA.add(callScriptQA.CC_Master_Question_Bank__r.MODS_Question_Answer_Code__c);
                
                }
            }
                        
        }
        
        for(NGCC_QA_and_Lead_Mapping__c missingQA: fieldMapping.values())
        {
            if(missingQA.purpose__c.contains('Attribute') && !strAddedQA.contains(missingQA.Name))
            {
                lstLeadAttribute.add(new NGCC_Lead_Attribute_Wrapper(mapQuesText.get(missingQA.Name),
                                missingQA.Name,
                                false));
            }else if(missingQA.purpose__c.contains('Qualification')&& !strAddedQA.contains(missingQA.Name))
            {
                lstLeadQualification.add(new NGCC_Lead_Qualification_Wrapper(mapQuesText.get(missingQA.Name),
                                missingQA.Name,
                                false));
            }
        }
                                                            
           
    }
    
}