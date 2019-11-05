@isTest
private class RenewalsCustomerBuControllerTest {
    
    static testMethod void customerBuControllerMethodTest(){
        
        
        	/*string rtId='01234000000Boc4AAC';// renewals opportunity record typeId
            Opportunity oppty = new Opportunity(name='Test',accountId ='0018000000Lc2vgAAB', StageName='2 - Qualified', CloseDate=System.today() + 50, Expected_Product__c=10.0,
                                                error_description__c='error', DealID__c='1', Opportunity_Status__c='Active', recordtypeId=rtId, Opportunity_Owner_AM__c =userinfo.getUserId(),
                                                Primary_Partner__c = '00180000010yatFAAQ', Competitors__c = 'A10 Networks', Is_Product_Quote_Integrated__c = 'Yes', Is_Service_Quote_Integrated__c = 'No' ); 
            insert oppty; */ 
        	/*Opportunity o = new Opportunity(name='Test',StageName='2 - Qualified',CloseDate=System.today() - 50,Expected_Product__c=10.0,error_description__c='error',DealID__c='1',Opportunity_Status__c='Active',recordtypeId=utilities.getOpptyParentRecordTypeId()); 
        	insert o;*/
        
        RenewalsCustomerBuController RenewalsCustomerBuControllerOb=new RenewalsCustomerBuController();
        
        ObjectRecordTypeIds__c ObjectRecordTypeIdsOb=new ObjectRecordTypeIds__c();
        ObjectRecordTypeIdsOb.Account_BU_RecordType_18__c='01234000000YNIaAAO';
        ObjectRecordTypeIdsOb.Account_Customer_RecordType_18__c='01234000000YNIbAAO';
        insert ObjectRecordTypeIdsOb;
        RenewalsCustomerBuController.getCustomerDetail('0063400001DQhPoAAL');
        RenewalsCustomerBuController.getCustomerBuDetails('0063400001DQhPoAAL');
        RenewalsCustomerBuController.getbn('0063400001DQhPoAAL');
    }
}