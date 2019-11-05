/***************************************************************************************************
Name    : NGCC_Flow_CallScript_Controller
Author  : Ghattamaneni Chaithanya
Purpose : This class is controller for NGCC_Flow_CallScript Component, it is responsible for get the values from Callscript
Date	: 07-Apr-2019

Modification History: 

*****************************************************************************************************/

public class NGCC_Flow_CallScript_Controller {
    @AuraEnabled
    public static Map<String, String> getCallScriptQA(string QuestionCode,string Lang,string CallScriptName,string Info){
        Map<String, String> options = new Map<String, String>();
        Set<string> setAnsId = new Set<string>();
        List<CC_Call_Script__c> callScript = [select id,Theater__c from CC_Call_Script__c where Name = :CallScriptName limit 1];          
        List<CC_Call_Script_Q_A__c> CCQ = [select id, Name,CC_Master_Question_Bank__c,Question_Type__c,CC_Master_Question_Bank__r.name,Call_Script__c,Answer_Options__c 
                                           from CC_Call_Script_Q_A__c where Call_Script__c =:callScript[0].id and Name=:QuestionCode limit 1];
        
        List<CC_Question_Answer_Translations__c> CCQAT = new  List<CC_Question_Answer_Translations__c>();
        CCQAT =  [select id, Translated_Value__c,CC_Master_Question_Answer_Bank__c,Language_Code__c,Language__c 
                  from CC_Question_Answer_Translations__c where CC_Master_Question_Answer_Bank__c=:CCQ[0].CC_Master_Question_Bank__c and Language_Code__c=:Lang limit 1];
        if(CCQAT.isEmpty()){
            CCQAT =  [select id, Translated_Value__c,CC_Master_Question_Answer_Bank__c,Language_Code__c,Language__c 
                      from CC_Question_Answer_Translations__c where CC_Master_Question_Answer_Bank__c=:CCQ[0].CC_Master_Question_Bank__c and Language_Code__c='en_US' limit 1];
        }
        options.put(QuestionCode,CCQAT[0].Translated_Value__c);
        if(CCQ[0].Question_Type__c == 'Picklist' || CCQ[0].Question_Type__c=='Radio'){
            List <String> strNewValue;
            if(CCQ[0].Answer_Options__c != null){
                strNewValue = new List <String>(CCQ[0].Answer_Options__c.split(','));
            }
            for (String optionName: strNewValue) {
                setAnsId.add(optionName.subString(optionName.indexOf(':')+1,optionName.length()));
            }
            if(Info != 'PS_Lead_TimeFrame' &&  Info != 'PS_Lead_ProjectBudget'){
                    for(CC_Question_Answer_Translations__c qat : [Select Id, Answer_Text__c,Translated_Value__c,CC_Master_Question_Answer_Bank__r.Name,CC_Master_Question_Answer_Bank__c from CC_Question_Answer_Translations__c 
                                                              where CC_Master_Question_Answer_Bank__c IN: setAnsId AND Language_Code__c =: CCQAT[0].Language_Code__c order by Answer_Text__c]){
                         options.put(qat.CC_Master_Question_Answer_Bank__r.Name,qat.Translated_Value__c);
                         setAnsId.remove(qat.CC_Master_Question_Answer_Bank__c);
                   }
            }            
            if(!setAnsId.isEmpty()){
                for(CC_Question_Answer_Translations__c qat : [Select Id, Answer_Text__c,Translated_Value__c,CC_Master_Question_Answer_Bank__r.Name,CC_Master_Question_Answer_Bank__c from CC_Question_Answer_Translations__c 
                                                              where CC_Master_Question_Answer_Bank__c IN: setAnsId AND Language_Code__c ='en_US' order by Answer_Text__c]){
                     options.put(qat.CC_Master_Question_Answer_Bank__r.Name,qat.Translated_Value__c);
                     setAnsId.remove(qat.CC_Master_Question_Answer_Bank__c);
                }
            }
        }
        return options;
    }
}