@isTest 
private class NGCC_Q_A_Bank_Test {

    static testmethod void testNGCC_Q_A_Bank() {
        //Getting the Record Type from the Master QA Object
        List<RecordType> rtypes = [Select Name, Id From RecordType 
                  where sObjectType='CC_Master_Question_Answer_Bank__c' and isActive=true];
     
         //Create a map between the Record Type Name and Id for easy retrieval
         Map<String,String> qaRecordTypes = new Map<String,String>{};
         for(RecordType rt: rtypes)
         {
            qaRecordTypes.put(rt.Name,rt.Id);
         }
         
        List<sObject> ls = Test.loadData(CC_Master_Question_Answer_Bank__c.sObjectType, 'NGCC_Q_A_Bank');
        System.assertequals(ls.size(), 24);
        
        set<Id> newId= new Set<Id>();
        for(sObject newls : ls)
        {
            newId.add(newls.Id);         
        }
        // Creating Answer Options
        List<CC_Master_Question_Answer_Bank__c> lstAnsMaster= new List<CC_Master_Question_Answer_Bank__c>();
        for(integer j=0;j<5;j++)
        {
            CC_Master_Question_Answer_Bank__c newAnswers= new CC_Master_Question_Answer_Bank__c();
            newAnswers.RecordTypeId = qaRecordTypes.get('Answer');
            newAnswers.Answer_Text__c = 'Option '+ j;
            lstAnsMaster.add(newAnswers);
        }
        
        insert lstAnsMaster;
        
        // Ensuring all the new created Record are of Question Record Type
        List<CC_Master_Question_Answer_Bank__c> lstQAMaster= new List<CC_Master_Question_Answer_Bank__c>();
        integer k=0;
        for(CC_Master_Question_Answer_Bank__c qaMasterObj: [Select Id,Name,RecordTypeId from CC_Master_Question_Answer_Bank__c where Id IN: newId])
        {
            qaMasterObj.RecordTypeId = qaRecordTypes.get('Question');
            string answerOptionId;
            if(k==1)
            {
                
                integer l= 0;
                for(CC_Master_Question_Answer_Bank__c ansObj :lstAnsMaster)
                {
                    if(answerOptionId=='')
                    {
                         answerOptionId = l+':'+ansObj.Id+',';
                    }else
                    {
                        answerOptionId = answerOptionId + l+':'+ansObj.Id+',';
                    }
                    l++;
                }
            }
            qaMasterObj.Answer_Options_Id__c = answerOptionId;
            lstQAMaster.add(qaMasterObj);
            k++;
        }
         
        update lstQAMaster;
        system.debug('aaaaaaaaaaaaa'+lstQAMaster);
        // validating if the english translation were inserted
        integer i=[Select Count() from CC_Question_Answer_Translations__c where CC_Master_Question_Answer_Bank__c IN: newId];
        System.assert(ls.size() == i);
        
        
        
        // Creating new Translation for a question in German
        CC_Question_Answer_Translations__c qaTransObj = new CC_Question_Answer_Translations__c();        
        qaTransObj.Language__c = 'German';
        qaTransObj.Language_Code__c='de';
        qaTransObj.CC_Master_Question_Answer_Bank__c = lstQAMaster[0].Id;
        qaTransObj.Translated_Value__c = 'Testing Call Script QA';   
        system.debug('bbbbbbbb'+qaTransObj);     
        insert qaTransObj;
        
        // Testing the Integrated UI
        Test.setCurrentPageReference(Page.NGCC_Q_A_Translation);        
        ApexPages.StandardController sc = new ApexPages.StandardController(qaTransObj);
        NGCC_Q_A_Translation_Anwers_CTE testCTE = new NGCC_Q_A_Translation_Anwers_CTE(sc);
        testCTE.getAnswerTrans();
        
        System.assertequals(testCTE.bAvailableOption, false);
        System.assertequals(testCTE.bNewTranslation, false);

       /************Testing when Options available***********************************************/
       // Creating new Translation for a question in German
        CC_Question_Answer_Translations__c qaTransObj1 = new CC_Question_Answer_Translations__c();        
        qaTransObj1.Language__c = 'German';
        qaTransObj1.Language_Code__c='de';
        qaTransObj1.CC_Master_Question_Answer_Bank__c = lstQAMaster[1].Id;
        qaTransObj1.Translated_Value__c = 'Testing Call Script QA';   
        system.debug('bbbbbbbb'+qaTransObj);     
        insert qaTransObj1;
        
        // Testing the Integrated UI
        Test.setCurrentPageReference(Page.NGCC_Q_A_Translation);        
        ApexPages.StandardController sc1 = new ApexPages.StandardController(qaTransObj1);
        NGCC_Q_A_Translation_Anwers_CTE testCTE1 = new NGCC_Q_A_Translation_Anwers_CTE(sc1);
        testCTE1.getAnswerTrans();
        
        System.assertequals(testCTE1.bAvailableOption, true);
        System.assertequals(testCTE1.bNewTranslation, true);        
        testCTE1.cmdAddTranslation();
        testCTE1.cmdUpdate();
       
    }
}