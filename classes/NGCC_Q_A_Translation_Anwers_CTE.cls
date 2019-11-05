/******************************************************************************************************************************************************
Name    : NGCC_Q_A_Translation_Anwers_CTE 
Author  : Mukesh Srivastava
Purpose : Controller to show all the available translated options for a particular question in the specified lanugage
Created Date: 4/18/2014
Modification History:                       
*********************************************************************************************************************************************************/

public class NGCC_Q_A_Translation_Anwers_CTE {
    
    Private CC_Question_Answer_Translations__c qaTrans;
    Public List<CC_Question_Answer_Translations__c> qansTrans {get;set;}
    Public List<CC_Master_Question_Answer_Bank__c> newQansTrans {get;set;}
    Public boolean bNewTranslation {get;set;}
    Public boolean bAvailableOption {get;set;}
    Set<Id> setAnsId = new Set<Id>();
    
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
    
    /* Controller to get record of the particular question */
    Public NGCC_Q_A_Translation_Anwers_CTE(ApexPages.StandardController controller) {
        this.qaTrans =  [select id, CC_Master_Question_Answer_Bank__r.Answer_Options_Id__c,Language_Code__c,Language__c from CC_Question_Answer_Translations__c where id = :controller.getId() limit 1];
        getAnswerTrans();
    }   
        
    /* @ method: Getting the translation for the answer options associated to the Question
    //@ Sets the whether the options are available and whether we need translation for the option in the given language
    //@ Sets page error if the no options available for the particular question basically either its the answer detail or Text questions */
    Public void getAnswerTrans(){
        try
        {
            List < String > strNewValue = new List < String > (this.qaTrans.CC_Master_Question_Answer_Bank__r.Answer_Options_Id__c.split(','));
            
            bAvailableOption = true;
            
            for (String optionName: strNewValue) {
                setAnsId.add(Id.valueOf(optionName.subString(optionName.indexOf(':')+1,optionName.length())));
            }
            qansTrans= [Select Id, Answer_Text__c,Translated_Value__c from CC_Question_Answer_Translations__c 
                        where CC_Master_Question_Answer_Bank__c IN: setAnsId AND Language_Code__c =: qaTrans.Language_Code__c];
            if(qansTrans.isEmpty())
            {
                bNewTranslation = true;
            }
            else
            {
                bNewTranslation = false;
            }
            
        }catch(Exception e)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'No other options available for this Question/Answer Bank Translation.'));
            bAvailableOption = false;
            bNewTranslation = false;
        }
    }
    
    /* @ method: To update the translation if the user has modified any of the translation or created new translation
    //@ return: null to refresh the page */
    public pageReference cmdUpdate(){
        try
        {
            Database.SaveResult[] updateQAAnswerTrans = Database.Update(qansTrans,false); 
        }catch(Exception e)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Unable to Update the Translaton.'));
        }
        return null;
    }    
    
    /* @ method: If the translation are not available for the options user can add translation in the particular language
    //@ Create all options translations to be translatable */
    public void cmdAddTranslation(){
        List<CC_Question_Answer_Translations__c > newLstQansTrans= new List<CC_Question_Answer_Translations__c>();
        try{
            for(CC_Master_Question_Answer_Bank__c  newQansObj : [Select Answer_Text__c,Id from CC_Master_Question_Answer_Bank__c where Id IN: setAnsId])
            {
                CC_Question_Answer_Translations__c newQansTrans = new CC_Question_Answer_Translations__c();
                /*newQansTrans.CC_Master_Question_Answer_Bank__c = newQansObj.Id;
                newQansTrans.Language_Code__c = qaTrans.Language_Code__c;
                newQansTrans.Language__c = qaTrans.Language__c;*/
                newQansTrans.CC_Master_Question_Answer_Bank__c = newQansObj.Id;
                //SCAVA
                if(flsGet(CC_Question_Answer_Translations__c.Language_Code__c)){
                newQansTrans.Language_Code__c = qaTrans.Language_Code__c;
                }
                if(flsGet(CC_Question_Answer_Translations__c.Language__c)){
                newQansTrans.Language__c = qaTrans.Language__c;
                }
                //SCAVA
                newLstQansTrans.add(newQansTrans);
            }
            Database.SaveResult[] insertNewQAAnswerTrans = Database.Insert(newLstQansTrans,false);  
        }catch(Exception e)
        {
            ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Unable to add the Translaton.'));
        }    
    }
}