@isTest(SeeAllData = true)
public class NGCC_Campaign_Managment_Test {
    
    public static Campaign campgDataPrep(){
        Campaign cm = new Campaign();
        cm.Name = 'tst Campaign';
        cm.Program_Originating_Country__c ='UNITED STATES';
        return cm;
    }
    
    @isTest
    public static void createCampaignTest(){
        ID mapRtyID = Schema.SObjectType.NGCC_Mapping_Object__c.getRecordTypeInfosByName().get('Country Mapping').getRecordTypeID();
        List <NGCC_Mapping_Object__c> cMap = new List <NGCC_Mapping_Object__c>();
        cMap.add(new NGCC_Mapping_Object__c( Name='UNITED STATES', Theater__c='Americas',Language__c='English: en_US',recordtypeId=mapRtyID));
        insert cMap;
        
        List <CC_Call_Script__c> callScript = new List<CC_Call_Script__c>();
        callScript.add(new CC_Call_Script__c(Name='Test_ELQ_AMER_Debug', Theater__c='Americas',Source__c='Global Eloqua',Status__c='Previewed', Default_Call_Script__c = true));
        callScript.add(new CC_Call_Script__c(Name='Test_AMER_Debug', Theater__c='Americas',Status__c='Previewed', Default_Call_Script__c = true));
        insert callScript;
        
        List<Campaign> newCmp = new List<Campaign>();
        Campaign cm = campgDataPrep();
        Campaign cm1 = campgDataPrep();
        cm1.Campaign_source__c ='Global Eloqua';
        newCmp.add(cm);
        newCmp.add(cm1);
        Test.startTest();
        insert newCmp;
        Test.stopTest();
        system.assert(cm.Call_Script__c == null || cm.Call_Script__c == '');
        system.assert(cm1.Call_Script__c == null || cm1.Call_Script__c == '');
        
    }
    
    @isTest
    public static void cancelCampaignTest(){
        Campaign cm = campgDataPrep();
        insert cm;
        
        List<Lead> nwLds = new List<Lead>();
        for (integer i=0; i<= 5; i++){
            Lead newLead = new Lead (
                LastName = 'Lead' +i,
                RecordTypeId = Schema.Sobjecttype.Lead.getRecordTypeInfosByName().get('Prospect').getRecordTypeId(),
                Company = '123',
                Status = 'New Prospect',
                CustomCountry__c = 'UNITED STATES', Campaign_Name__c =cm.Id);
            nwLds.add(newLead);
            
        }
        insert nwLds;
        cm.Status='Completed';
        Test.startTest();
        update cm;
        Test.stopTest();
        system.assert(cm.Status =='Completed');
        
        
        
    }

}