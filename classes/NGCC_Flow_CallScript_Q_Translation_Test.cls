@isTest(SeeAllData = true)
public class NGCC_Flow_CallScript_Q_Translation_Test {
@isTest
    public static void getCallScriptQATest(){
        List<string> QuestionCodes = new List<string>();
        string QuestionCode = 'LEAD_CATEGORY_SFDC';
        QuestionCodes.add(QuestionCode);
        string Lang = 'English';
        string CallScriptName = 'AMER LG';
        Map<String, String> QAMap = NGCC_Flow_CallScript_Q_Translation.getCallScriptQA(QuestionCodes,Lang,CallScriptName);
        system.assertEquals(true, QAMap.size()>0);
    }
     @isTest
    public static void getCallScriptQATest2(){
        List<string> QuestionCodes = new List<string>();
        string QuestionCode = 'ROUTE_TO_AM_SFDC';
        QuestionCodes.add(QuestionCode);
        string Lang = 'Spanish';
        string CallScriptName = 'AMER LG';
        Map<String, String> QAMap = NGCC_Flow_CallScript_Q_Translation.getCallScriptQA(QuestionCodes,Lang,CallScriptName);
        system.assertEquals(true, QAMap.size()>0);
    }    
}