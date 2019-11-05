/***************************************************************************************************
Name    : NGCC_Flow_CallScript_Q_Translation
Author  : Ghattamaneni Chaithanya
Purpose : This class is controller for NGCC_Flow_PS_Project_Details Component, it is responsible for get the trnaslated values from Callscript
Date	: 08-Apr-2019

Modification History: 

*****************************************************************************************************/

public class NGCC_Flow_CallScript_Q_Translation {
    @AuraEnabled
    public static Map<String, String> getCallScriptQA(List<string> QuestionCodes,string Lang,string CallScriptName){
        Map<String, String> options = new Map<String, String>();
        Set<Id> setQIds = new Set<Id>();
        
        List<CC_Call_Script__c> callScript = [select id,Theater__c from CC_Call_Script__c where Name = :CallScriptName limit 1];          

        for(CC_Call_Script_Q_A__c QA : [select id, Name,CC_Master_Question_Bank__c,Question_Type__c,CC_Master_Question_Bank__r.name,Call_Script__c,Answer_Options__c from CC_Call_Script_Q_A__c 
                     					where Call_Script__c =:callScript[0].id and Name IN:QuestionCodes]){
            setQIds.add(QA.CC_Master_Question_Bank__c);
        }        
        for(CC_Question_Answer_Translations__c QATran : [select id, Translated_Value__c,CC_Master_Question_Answer_Bank__r.Name,CC_Master_Question_Answer_Bank__r.Answer_Options_Id__c,Language_Code__c,Language__c from CC_Question_Answer_Translations__c 
                    									 where CC_Master_Question_Answer_Bank__c IN:setQIds and Language_Code__c=:Lang]){
            options.put(QATran.CC_Master_Question_Answer_Bank__r.Name,QATran.Translated_Value__c);
            setQIds.remove(QATran.CC_Master_Question_Answer_Bank__c);
        }
        if(!setQIds.isEmpty()){
            for(CC_Question_Answer_Translations__c QATran : [select id, Translated_Value__c,CC_Master_Question_Answer_Bank__r.Name,CC_Master_Question_Answer_Bank__r.Answer_Options_Id__c,Language_Code__c,Language__c from CC_Question_Answer_Translations__c 
                    									 	 where CC_Master_Question_Answer_Bank__c IN:setQIds and Language_Code__c='en_US']){
                options.put(QATran.CC_Master_Question_Answer_Bank__r.Name,QATran.Translated_Value__c);
                setQIds.remove(QATran.CC_Master_Question_Answer_Bank__c);
        	}
        }
        return options;        
    }
}