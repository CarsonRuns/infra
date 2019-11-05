@isTest
public class CS_Lead_Accept_Button_Controller_Test {
    
    public static testMethod void acceptButtonMethod(){
        Id ManualRecordTypeId =  [SELECT Id FROM RecordType   WHERE DeveloperName = 'Manual' AND sObjectType = 'Lead'].Id;
        Id eLeadsRecordTypeId =  [SELECT Id FROM RecordType   WHERE DeveloperName = 'eLeads' AND sObjectType = 'Lead'].Id;
        Id partnerRecordTypeId =  [SELECT Id FROM RecordType   WHERE DeveloperName = 'PartnerGeneratedLead' AND sObjectType = 'Lead'].Id;
        
        String ManualRecTypeId = String.valueOf(ManualRecordTypeId);
        String eLeadsRecTypeId = String.valueOf(eLeadsRecordTypeId);
        String partnerRecTypeId = String.valueOf(partnerRecordTypeId);
        
        ObjectRecordTypeIds__c objRec = new ObjectRecordTypeIds__c();
        objRec.Manual_Lead_RecordTypeId__c = ManualRecTypeId.substring(0,ManualRecTypeId.length()-3);
        objRec.eLeadsRecordTypeId__c = eLeadsRecTypeId.substring(0,eLeadsRecTypeId.length()-3);
        objRec.Partner_Generated_Lead_RecordTypeId__c= partnerRecTypeId.substring(0,partnerRecTypeId.length()-3);
        insert objRec;
        
        User ledOwner = [Select id,name from user where profile.name='Cisco_ADMIN' and  IsActive = True AND  Additional_User_Permissions__c != 'Enable_ePSS' limit 1];
        ledOwner.Position_1__c = 'test12345\n\rjdnkjsankjd';
        ledOwner.Deployment_No__c  = 'SKIP';
        update ledOwner;
        
        List<Org_Constants__c> orgConstantsList = new List<Org_Constants__c>();
        Org_Constants__c oc = new Org_Constants__c();
        oc.Key__c = 'Lead:Status';
        oc.prod_value__c ='2 Accepted-Mine/Channel';
        orgConstantsList.add(oc);
        Org_Constants__c oc1 = new Org_Constants__c();
        oc1.Key__c = 'Lead:Warning Error';
        oc1.prod_value__c ='No records selected';
        orgConstantsList.add(oc1);
        Org_Constants__c oc2 = new Org_Constants__c();
        oc2.Key__c = 'Lead:Accepted Page Message';
        oc2.prod_value__c ='Lead Accepted';
        orgConstantsList.add(oc2);
        test.startTest();
        System.runAs(ledOwner){
            List<Lead> leadList = new List<Lead>();
            Lead l1 = new Lead(firstName='Test Manual',LastName ='Lead', RECORDTYPEID= ManualRecTypeId,company='Test End-User Account',email='test@test.com.test', LeadSource='eLeads');
            leadList.add(l1);
            insert leadList;
            
            
          //  Lead l = GenericStaticTestData.testManualLeadRecord();
           // leadList.add(l);
            
            // insert leadList;
            
            Test.setCurrentPage(Page.CS_Lead_Accept_Button);
            ApexPages.StandardSetController  stdCon = new ApexPages.StandardSetController(leadList);
            stdCon.setSelected(leadList); 
            stdCon.getSelected();
            System.debug('Recs ::: '+stdCon.getSelected());
            CS_Lead_Accept_Button_Controller leadCon = new CS_Lead_Accept_Button_Controller(stdCon); 

            leadCon.getSelectedLeads();
            leadCon.updateLeadStatus();
            leadCon.cancelUpdateStatus();
            //leadCon.cancelUpdateStatus();
        }
        Test.stopTest();
        
    } 
}