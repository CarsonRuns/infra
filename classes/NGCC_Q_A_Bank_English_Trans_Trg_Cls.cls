/*********************************************************************************************************************************
Name    : NGCC_Q_A_Bank_English_Trans_Trg_Cls
Author  : Mukesh Srivastava
Purpose : Whenever a new Answer and Questions are created by default create an English translation record in Q&A Translation object
Created Date:  3/27/2014 
Modification History: 
                      
**********************************************************************************************************************************/
public class NGCC_Q_A_Bank_English_Trans_Trg_Cls{

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
    
    /* By Default creating English translation record in Q&A Translation object 
    // If its Question then put Question Text in Translated value else Answer Text  */
    public static void NGCC_Q_A_Bank_English_Translation(map<Id,CC_Master_Question_Answer_Bank__c> mapNewQA)
    {
       List<RecordType> answerRec = [Select Id from RecordType where Name = 'Answer' Limit 1];
       
       List<CC_Question_Answer_Translations__c> ccQATranslation = new List<CC_Question_Answer_Translations__c>();
        
        for(CC_Master_Question_Answer_Bank__c ccQA: mapNewQA.values())
        {
            CC_Question_Answer_Translations__c ccQATObj = new CC_Question_Answer_Translations__c();
            ccQATObj.CC_Master_Question_Answer_Bank__c = ccQA.Id;
           
            if(flsGet(CC_Question_Answer_Translations__c.Language__c)||flsUpdateGet(CC_Question_Answer_Translations__c.Language__c)){
            ccQATObj.Language__c = 'English';
            }
             // SCAVA Fix
            if(flsGet(CC_Question_Answer_Translations__c.Language_Code__c)||flsUpdateGet(CC_Question_Answer_Translations__c.Language_Code__c)){
            ccQATObj.Language_Code__c = 'en_US';
            }
            if(ccQA.recordtypeId  != answerRec[0].Id)
            {
            if(flsGet(CC_Question_Answer_Translations__c.Translated_Value__c)||flsUpdateGet(CC_Question_Answer_Translations__c.Translated_Value__c)){
                ccQATObj.Translated_Value__c = ccQA.Question_Text__c; 
            }   
            }else
            {
                ccQATObj.Translated_Value__c = ccQA.Answer_Text__c;    
            }
            if(flsGet(CC_Question_Answer_Translations__c.MasterQuestionBankId__c)||flsUpdateGet(CC_Question_Answer_Translations__c.MasterQuestionBankId__c)){
            ccQATObj.MasterQuestionBankId__c = ccQA.Id+ccQATObj.Language_Code__c;
            }
            ccQATranslation.add(ccQATObj);
        }
        
        Database.UpsertResult[] insertTranslation = Database.upsert(ccQATranslation,Schema.CC_Question_Answer_Translations__c.MasterQuestionBankId__c,false);
    }
}