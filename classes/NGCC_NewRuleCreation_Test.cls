@isTest
public class NGCC_NewRuleCreation_Test {

    static testMethod void SingleItePositivemTest(){
        CC_Master_Question_Answer_Bank__c ccMaster = new CC_Master_Question_Answer_Bank__c(name='M');
        insert ccMaster;
        //list<NGCC_Rule_Assignment__c> rules = new list<NGCC_Rule_Assignment__c>();
        //rules.add(new NGCC_Rule_Assignment__c(MODS_Leads__c='Lead Attribute',Countries__c='UK;US',Lead_Attribute__c='lastName',Priority__c='1',Rank__c='1',Theater__c='APJXC',Value__c='m1,m', Active__c= true));
        
        //insert rules;
        
        list<NGCC_Rule_Assignment__c> rules2 = new list<NGCC_Rule_Assignment__c>();
        rules2.add(new NGCC_Rule_Assignment__c(MODS_Leads__c='Lead Attribute',Countries__c='UK;US',Lead_Attribute__c='lastName',Priority__c='1',Rank__c='1',Theater__c='APJ',Value__c='m1,m', Active__c= true));
        rules2.add(new NGCC_Rule_Assignment__c(MODS_Leads__c=null,Countries__c=null,Lead_Attribute__c='',Priority__c='',Rank__c='',Theater__c='',Value__c='', Active__c= true));
        rules2.add(new NGCC_Rule_Assignment__c(MODS_Leads__c='Lead Attribute',Countries__c='',Lead_Attribute__c='lastName',Priority__c='',Rank__c='',Theater__c='APJ',Value__c='', Active__c= true, All_Countries__c=false));
        
        insert rules2;
        
       // rules[0].Priority__c='2';
        //update rules;
        
        ApexPages.StandardController sc = new ApexPages.StandardController(rules2[0]);
        NGCC_NewRuleCreation testController =  new NGCC_NewRuleCreation(sc );
        PageReference pageRef = Page.NGCC_LeadRuleassignment; 
        pageRef.getParameters().put('id', String.valueOf(rules2[0].id));
        Test.setCurrentPage(pageRef);

        testController .saveRec();
        testController .reRenderThePage();
        testController.saveandNew();
        
        
        ApexPages.StandardController sc1= new ApexPages.StandardController(rules2[1]);
        NGCC_NewRuleCreation testController1 =  new NGCC_NewRuleCreation(sc1);
        PageReference pageRef1 = Page.NGCC_LeadRuleassignment; 
        pageRef1.getParameters().put('id', String.valueOf(rules2[1].id));
        Test.setCurrentPage(pageRef1);

        testController1 .saveRec();
        testController1 .reRenderThePage();
        testController1 .saveandNew();
     
    } 
    static testMethod void SingleItemNegativeTest(){
        CC_Master_Question_Answer_Bank__c ccMaster = new CC_Master_Question_Answer_Bank__c(name='M');
        insert ccMaster;
        
        
        NGCC_Rule_Assignment__c rule = new NGCC_Rule_Assignment__c(MODS_Leads__c=null,Countries__c=null,Lead_Attribute__c='',Priority__c='',Rank__c='',Theater__c='APJ',Value__c='', Active__c= true);
        
        insert rule;
        ApexPages.StandardController sc = new ApexPages.StandardController(rule);
        NGCC_NewRuleCreation testController =  new NGCC_NewRuleCreation(sc );
        PageReference pageRef = Page.NGCC_LeadRuleassignment; 
        pageRef.getParameters().put('id', String.valueOf(rule.id));
        Test.setCurrentPage(pageRef);
        //Test.startTest();
        testController .saveRec();
        testController .reRenderThePage();
        testController.saveandNew();
        //Test.stopTest();
    }
    //Zak: added new SelectionSort method. 
    @isTest(SeeAllData=true)
    static void SortLeadAttributeAsecTest(){
        NGCC_Lead_Attribute_Mapping__c obj = new NGCC_Lead_Attribute_Mapping__c();
        list<selectoption> custompicklist = new list<selectoption>();
                list<selectoption> custompicklist1 = new list<selectoption>();
        Map<String,NGCC_Lead_Attribute_Mapping__c> x1 = NGCC_Lead_Attribute_Mapping__c.getall();
        List<NGCC_Lead_Attribute_Mapping__c> unsortedValues= x1.values();
        
        /*Map<String,NGCC_Lead_Attribute_Mapping__c> x2 = NGCC_Lead_Attribute_Mapping__c.getall();
        List<NGCC_Lead_Attribute_Mapping__c> testValues= x2.values();*/
        
        //insert unsortedValues;
        ApexPages.StandardController sc = new ApexPages.StandardController(obj);
        NGCC_NewRuleCreation testController =  new NGCC_NewRuleCreation(sc);
        
        Test.startTest();
        List<NGCC_Lead_Attribute_Mapping__c> sortedList = testController.SortLeadAttributeAsec(unsortedValues);
        for(NGCC_Lead_Attribute_Mapping__c str:sortedList ){
        custompicklist.add(new selectoption(str.Name,str.Value__c));
        
        for(NGCC_Lead_Attribute_Mapping__c strs:unsortedValues){
        custompicklist1.add(new selectoption(strs.Name,strs.Value__c));        
        }
        }
        System.assertNotEquals(custompicklist,custompicklist1,'List is sorted');
        Test.stopTest();
        }
}