@isTest
public class APICalloutControllerTest {
    
    //public static user  u {get;set;}
    @testSetup
    static void testData(){
         User u = CEE_TestUtility.getUser('admin', true);
        String orgId = UserInfo.getOrganizationId();
        
        List < sObject > objRecTypeData = Test.loadData(ObjectRecordTypeIds__c.sObjectType,'GlobalTestObjectRecordTypeIds');
        List < sObject > osCSData = Test.loadData(Org_Constants__c.sObjectType,'OrgConstants');
        Org_Constant_CS__c ocs = new Org_Constant_CS__c();
        ocs.name = 'Exclude From PUI and Competitor Popup';
        ocs.Non_Production_Value__c = 'Cisco_ADMIN';
        ocs.Production_Value__c = 'Cisco_ADMIN';
        insert ocs;
        
        
         Id RecordtypeIdValue;
         System.runas(u){
            List<C360TACCasesAPI__c> apiSettings = C360_TestDataFactory.prepareTACNPSSettings();
            insert apiSettings;
 
             Account a = new Account();
            //Insert Customer Account Record
            Account CustomerAcc = new Account();
            Id CustrRcrdId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
            CustomerAcc.RecordTypeId = CustrRcrdId;
            CustomerAcc.Name = 'CustomerTestAccount';
            CustomerAcc.AccountNumber='1234';
            CustomerAcc.Assigned_CSE__c=u.id;
            insert CustomerAcc;
            system.debug('CustomerAcc>>>'+CustomerAcc); 
            Account BusinessAcc = new Account();
            Id BusinessRcrdId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Unit').getRecordTypeId();
            Integer i;
            for(i=0;i<=5;i++){
                BusinessAcc.RecordTypeId = BusinessRcrdId;
                BusinessAcc.Name = 'BusinessTestAccount'+i;
                BusinessAcc.ParentId = CustomerAcc.Id;
                BusinessAcc.AccountNumber ='10800'+i;
                
            }
            insert BusinessAcc;
            system.debug('BusinessAcc>>>'+BusinessAcc);
         }
    }
    static testMethod void testMethodTAC() 
    {
        // Create Test User
        User u = CEE_TestUtility.getUser('admin1', true);
       
        System.runas(u){
            List<Id> testId = new List<Id>();
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new TestMockHttpGenerator());
            String res = APICalloutController.doTACAPI(testId,true);
            List<Object> objTACList =  (List<Object>) JSON.deserializeUntyped(res);
            system.debug('===objTACList'+objTACList);
            String buName ='';
            for(Object obj:objTACList){
                Map<String,Object> accWrap = (Map<String,Object>)obj;
                system.debug('===accWrap'+accWrap.get('customerName'));
                buName = String.valueOf(accWrap.get('customerName'));
                break;

            }
            Test.stopTest();
        }
    }
    static testMethod void testMethodNPS() 
    {
        //Creating Account Records for Customer and BU
        // Create Test User
         User u = CEE_TestUtility.getUser('admin2', true);
        
        
        //Id RecordtypeIdValue;
        System.runas(u){
            List<Id> testId = new List<Id>();           
            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new TestMockHttpGenerator());
            String res = APICalloutController.doNPSAPI(testId,true);
            system.debug('===res'+res); 
            List<Object> objNPSList =  (List<Object>) JSON.deserializeUntyped(res);
            system.debug('===objNPSList'+objNPSList); 
            String buName ='';
            for(Object obj:objNPSList){
                Map<String,Object> accWrap = (Map<String,Object>)obj;
                system.debug('===accWrap'+accWrap.get('customerName'));
                buName = String.valueOf(accWrap.get('customerName'));
                break;
            }
            System.assertEquals(buName, 'BusinessTestAccount1');
            Test.stopTest();
        }
    }
    
}