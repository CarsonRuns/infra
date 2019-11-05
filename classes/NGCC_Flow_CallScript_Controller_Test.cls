@isTest(SeeAllData = true)
public class NGCC_Flow_CallScript_Controller_Test {
    @isTest
    public static void getCallScriptQATest(){
        string QuestionCode = 'LEAD_CATEGORY_SFDC';
        string Lang = 'English';
        string CallScriptName = 'AMER LG';
        string Info = '';
        Map<String, String> QAMap = NGCC_Flow_CallScript_Controller.getCallScriptQA(QuestionCode,Lang,CallScriptName,Info);
        system.assertEquals(true, QAMap.size()>0);
    }
    @isTest
    public static void getCallScriptQATest2(){
        string QuestionCode = 'ROUTE_TO_AM_SFDC';
        string Lang = 'Spanish';
        string CallScriptName = 'AMER LG';
        string Info = '';
        Map<String, String> QAMap = NGCC_Flow_CallScript_Controller.getCallScriptQA(QuestionCode,Lang,CallScriptName,Info);
        system.assertEquals(true, QAMap.size()>0);
    }    
     @isTest
    public static void getCallScriptQATest3(){
        string QuestionCode = 'LEAD_CATEGORY_SFDC';
        string Lang = 'Spanish';
        string CallScriptName = 'AMER LG';
        string Info = '';
        Map<String, String> QAMap = NGCC_Flow_CallScript_Controller.getCallScriptQA(QuestionCode,Lang,CallScriptName,Info);
        system.assertEquals(true, QAMap.size()>0);
    }    
}