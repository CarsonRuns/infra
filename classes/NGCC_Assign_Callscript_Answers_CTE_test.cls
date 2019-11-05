@isTest(SeeallData=true)
Public Class NGCC_Assign_Callscript_Answers_CTE_test{

    private static final String test_question_id = 'a2nS0000000S5re';

    private static testMethod void testdoSearch(){
        //CC_Call_Script_Q_A__c question = [Select id from CC_Call_Script_Q_A__c where id = :test_question_id limit 1];
        CC_Call_Script__c cs = new CC_Call_Script__c(name='testing');
        insert cs;
        CC_Call_Script_Q_A__c question = new CC_Call_Script_Q_A__c(name ='test', Call_Script__c=cs.Id, Answer_Options__c='01:000000x,02:00000y');
        insert question;
        
        ApexPages.StandardController stdcte = new ApexPages.StandardController(question);   
        NGCC_Assign_Callscript_Answers_CTE cte = new NGCC_Assign_Callscript_Answers_CTE(stdcte);
        cte.filtertext='test';
        cte.doSearch();
    }
    
    private static testMethod void testgetIsRendered(){
        CC_Call_Script__c cs = new CC_Call_Script__c(name='testing');
        insert cs;
        CC_Call_Script_Q_A__c question = new CC_Call_Script_Q_A__c(name ='test', Call_Script__c=cs.Id);
        insert question;
        
        ApexPages.StandardController stdcte = new ApexPages.StandardController(question);   
        NGCC_Assign_Callscript_Answers_CTE cte = new NGCC_Assign_Callscript_Answers_CTE(stdcte);
        cte.getIsRendered();
    }
    
    private static testMethod void testgetIsLocal(){
        CC_Call_Script__c cs = new CC_Call_Script__c(name='testing');
        insert cs;
        CC_Call_Script_Q_A__c question = new CC_Call_Script_Q_A__c(name ='test', Call_Script__c=cs.Id);
        insert question;
        
        ApexPages.StandardController stdcte = new ApexPages.StandardController(question);   
        NGCC_Assign_Callscript_Answers_CTE cte = new NGCC_Assign_Callscript_Answers_CTE(stdcte);
        cte.getIsLocal();
    }
    
    private static testMethod void testgetIsDummyOwner(){
        CC_Call_Script__c cs = new CC_Call_Script__c(name='testing');
        insert cs;
        CC_Call_Script_Q_A__c question = new CC_Call_Script_Q_A__c(name ='test', Call_Script__c=cs.Id);
        insert question;
        
        ApexPages.StandardController stdcte = new ApexPages.StandardController(question);   
        NGCC_Assign_Callscript_Answers_CTE cte = new NGCC_Assign_Callscript_Answers_CTE(stdcte);
        cte.getIsDummyOwner();
    }
    
    private static testMethod void testupdate_selection(){
        CC_Call_Script__c cs = new CC_Call_Script__c(name='testing');
        insert cs;
        CC_Call_Script_Q_A__c question = new CC_Call_Script_Q_A__c(name ='test', Call_Script__c=cs.Id);
        insert question;
        
        ApexPages.StandardController stdcte = new ApexPages.StandardController(question);   
        NGCC_Assign_Callscript_Answers_CTE cte = new NGCC_Assign_Callscript_Answers_CTE(stdcte);
        cte.update_selection();
    }
    
    private static testMethod void testadd_option(){
        CC_Call_Script__c cs = new CC_Call_Script__c(name='testing');
        insert cs;
        CC_Call_Script_Q_A__c question = new CC_Call_Script_Q_A__c(name ='test', Call_Script__c=cs.Id);
        insert question;
        
        ApexPages.StandardController stdcte = new ApexPages.StandardController(question);   
        NGCC_Assign_Callscript_Answers_CTE cte = new NGCC_Assign_Callscript_Answers_CTE(stdcte);
        cte.add_option();
    }

    private static testMethod void answerWrapperTest(){
        CC_Master_Question_Answer_Bank__c test = new CC_Master_Question_Answer_Bank__c(name='testing');
        insert test; 
        NGCC_Assign_Callscript_Answers_CTE.AnswerWrapper aw1 = new NGCC_Assign_Callscript_Answers_CTE.AnswerWrapper(test, false, 1);
        NGCC_Assign_Callscript_Answers_CTE.AnswerWrapper aw2 = new NGCC_Assign_Callscript_Answers_CTE.AnswerWrapper(test, false, 2);
                
        aw1.compareTo(aw2);
        aw1.compareTo(aw1);
        aw2.compareTo(aw1);
        aw1.compareTo('test');
    }
}