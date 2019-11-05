@isTest(SeeallData=true)
Public Class NGCC_Assign_Master_Answers_CTE_test{

    private static final String test_question_id = 'a2oS00000000MsN';

    private static testMethod void testdoSearch(){
        CC_Master_Question_Answer_Bank__c question = new CC_Master_Question_Answer_Bank__c(name='test',Answer_Options_Id__c='01:000000x,02:00000y');
        insert question;
        //CC_Master_Question_Answer_Bank__c question = [Select id from CC_Master_Question_Answer_Bank__c where id = :test_question_id limit 1];
        ApexPages.StandardController stdcte = new ApexPages.StandardController(question);   
        NGCC_Assign_Master_Answers_CTE cte = new NGCC_Assign_Master_Answers_CTE(stdcte);
        cte.filtertext='test';
        cte.doSearch();
    }
    
    private static testMethod void testgetIsRendered(){
        CC_Master_Question_Answer_Bank__c question = new CC_Master_Question_Answer_Bank__c(name='test');
        insert question;
        ApexPages.StandardController stdcte = new ApexPages.StandardController(question);   
        NGCC_Assign_Master_Answers_CTE cte = new NGCC_Assign_Master_Answers_CTE(stdcte);
        cte.getIsRendered();
    }
    
    private static testMethod void testgetIsLocal(){
        CC_Master_Question_Answer_Bank__c question = new CC_Master_Question_Answer_Bank__c(name='test');
        insert question;
        ApexPages.StandardController stdcte = new ApexPages.StandardController(question);   
        NGCC_Assign_Master_Answers_CTE cte = new NGCC_Assign_Master_Answers_CTE(stdcte);
        cte.getIsLocal();
    }
    
    private static testMethod void testgetIsDummyOwner(){
        CC_Master_Question_Answer_Bank__c question = new CC_Master_Question_Answer_Bank__c(name='test');
        insert question;
        ApexPages.StandardController stdcte = new ApexPages.StandardController(question);   
        NGCC_Assign_Master_Answers_CTE cte = new NGCC_Assign_Master_Answers_CTE(stdcte);
        cte.getIsDummyOwner();
    }
    
    private static testMethod void testupdate_selection(){
        CC_Master_Question_Answer_Bank__c question = new CC_Master_Question_Answer_Bank__c(name='test');
        insert question;
        ApexPages.StandardController stdcte = new ApexPages.StandardController(question);   
        NGCC_Assign_Master_Answers_CTE cte = new NGCC_Assign_Master_Answers_CTE(stdcte);
        cte.update_selection();
    }
    
    private static testMethod void testadd_option(){
        CC_Master_Question_Answer_Bank__c question = new CC_Master_Question_Answer_Bank__c(name='test');
        insert question;
        ApexPages.StandardController stdcte = new ApexPages.StandardController(question);   
        NGCC_Assign_Master_Answers_CTE cte = new NGCC_Assign_Master_Answers_CTE(stdcte);
        cte.add_option();
    }
    
    private static testMethod void answerWrapperTest(){
        CC_Master_Question_Answer_Bank__c test = new CC_Master_Question_Answer_Bank__c(name='testing');
        insert test; 
        NGCC_Assign_Master_Answers_CTE.AnswerWrapper aw1 = new NGCC_Assign_Master_Answers_CTE.AnswerWrapper(test, false, 1);
        NGCC_Assign_Master_Answers_CTE.AnswerWrapper aw2 = new NGCC_Assign_Master_Answers_CTE.AnswerWrapper(test, false, 2);
                
        aw1.compareTo(aw2);
        aw1.compareTo(aw1);
        aw2.compareTo(aw1);
        aw1.compareTo('test');
    }
}