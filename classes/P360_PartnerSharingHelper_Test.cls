@isTest
public class P360_PartnerSharingHelper_Test {
    // SCAVA Helper Method to validate Create Access at field level
     public static Boolean flsGet(SObjectField field)
    {
        return field.getDescribe().isCreateable() ? true : false;
    }
public static testMethod void testPartnerAssignmentToLead()
{
    
    
    List < sObject > objRecTypeData = Test.loadData(ObjectRecordTypeIds__c.sObjectType,'ObjectRecordTypeIds');
    lead l = GenericStaticTestData.gettesteLeadRecord();
    Id PSRUserId = GenericStaticTestData.gettestPSRUserRecord().id;
        
    test.starttest();
    if(l.channel_partner__c != null)
    {
        l.channel_partner__c = null;
        update l;         
        l.channel_partner__c = GenericStaticTestData.gettestChannelAccountRecord1().id;
        l.PSR_1__c = PSRUserId;
        l.PSR_2__c = PSRUserId;
        l.PSR_3__c = PSRUserId;
        update l;
    }
    else
    {    
        l.channel_partner__c = GenericStaticTestData.gettestChannelAccountRecord1().id;
        l.PSR_1__c = PSRUserId;
        l.PSR_2__c = PSRUserId;
        l.PSR_3__c = PSRUserId;
        update l;
        l.channel_partner__c = null;
        update l;  
    }       
    test.stoptest();    
}

public static testMethod void testTargetProspectActivation()
{
    List < sObject > objRecTypeData = Test.loadData(ObjectRecordTypeIds__c.sObjectType,'ObjectRecordTypeIds');
    Assigned_Partner__c TP = GenericStaticTestData.gettestTargetProspectRecord();
    Id PSRUserId = GenericStaticTestData.gettestPSRUserRecord().id;
    
    test.starttest();
    
    TP.ASSIGNMENT_ACTIVATED__C = true;
    TP.Assigned_Partner_Sales_Rep__c = PSRUserId;
    TP.Assigned_Partner_Sales_Rep_2__c = PSRUserId;
    TP.Assigned_Partner_Sales_Rep_3__c = PSRUserId;
    update TP;
  
    test.stoptest();
}


public static testMethod void testPartnerGeneratedTargetProspect()
{
  List < sObject > objRecTypeData = Test.loadData(ObjectRecordTypeIds__c.sObjectType,'ObjectRecordTypeIds');
    Id PSRUserId = GenericStaticTestData.gettestPSRUserRecord().id;
    Assigned_Partner__c TP = GenericStaticTestData.gettestTargetProspectRecord();
    Account a = GenericStaticTestData.gettestChannelAccountRecord1();
    a.Primary_Cisco_Contact__c = GenericStaticTestData.gettestAMUserRecord().id;
    update a;

    test.starttest();
    
    List<Assigned_Partner__c> TPs = New list<Assigned_Partner__c>();
    TPs.add(TP);
    List<Assigned_Partner__c> PGTPs = TPs.deepclone();
    PGTPs[0].Target_Architecture__c = 'Video-TelePresence & Conferencing';
    
    
    AccountShare ash = new AccountShare();
    ash.AccountId = GenericStaticTestData.gettestEndUserAccountRecordRed().id;
    ash.UserOrGroupId = GenericStaticTestData.gettestPAUserRecord().id;   
    ash.AccountAccessLevel  = 'Read';
    ash.OpportunityAccessLevel = 'None';
    insert ash;
    
    system.runas(GenericStaticTestData.gettestPAUserRecord())
    {
          insert(PGTPs);       
    }
    
    PGTPs[0].ASSIGNMENT_ACTIVATED__C = False;
    update PGTPs[0];
    
    test.stoptest();
}   

public static testMethod void testPartnerGeneratedLead()
{   
List < sObject > objRecTypeData = Test.loadData(ObjectRecordTypeIds__c.sObjectType,'ObjectRecordTypeIds');
    Id PSRUserId = GenericStaticTestData.gettestPSRUserRecord().id;
    lead l = GenericStaticTestData.gettesteLeadRecord();    
    Account a = GenericStaticTestData.gettestChannelAccountRecord1();
    a.Primary_Cisco_Contact__c = GenericStaticTestData.gettestAMUserRecord().id;   
    update a;
        Account a33 = new Account(name='Test End-User Account',CRName__c ='Test End-User Account',RECORDTYPEID='0123000000004aUAAQ',Country__c='UNITED STATES');
    insert a33;
    if(l.channel_partner__c == null)
    {    
        l.channel_partner__c = GenericStaticTestData.gettestChannelAccountRecord1().id;
    }
        l.PSR_1__c = PSRUserId;
        l.PSR_2__c = PSRUserId;
        l.PSR_3__c = PSRUserId; 
        l.Partner_Lead_Status__c = 'Partner Assigned'; 
    test.starttest();
    List<Lead> Leads = New list<Lead>();
    Leads.add(l);
    List<Lead> PGLeads = Leads.deepclone();        
       
    //system.runas(GenericStaticTestData.gettestPAUserRecord())
    system.runas(new User(Id=UserInfo.getUserId()))
    {
          insert(PGLeads);
    }
    test.stoptest();
     Lead l1 = new Lead();
     //SCAVA FIX
    if(flsGet(Lead.firstName))
    {
     l1.firstName='Test Manual';
    }
    if(flsGet(Lead.LastName))
    {
     l1.LastName ='Lead';
    }
    if(flsGet(Lead.RECORDTYPEID))
    {
     l1.RECORDTYPEID='0123000000004aSAAQ';
    }
    if(flsGet(Lead.company))
    {
     l1.company='Test End-User Account';
    }
    if(flsGet(Lead.email))
    {
     l1.email='test@test.com.test';
    }
    if(flsGet(Lead.LeadSource))
    {
     l1.LeadSource='eLeads';
    }
    if(flsGet(Lead.End_Customer_Account__c))
    {
     l1.End_Customer_Account__c = a33.id;
    }
    if(flsGet(Lead.channel_partner__c))
    {
     l1.channel_partner__c = GenericStaticTestData.gettestChannelAccountRecord1().id;
    }
     insert l1;
     List<AccountShare> AccountShareToInsert = new List<AccountShare>();
     AccountShare ash = new AccountShare();
     //SCAVA FIX
    if(flsGet(AccountShare.AccountId))
    {
        ash.AccountId = a.id;
    }
    if(flsGet(AccountShare.UserOrGroupId))
    {
        ash.UserOrGroupId = userinfo.getUserId();   
    }
    if(flsGet(AccountShare.AccountAccessLevel))
    {
        ash.AccountAccessLevel  = 'Read';
    }
    if(flsGet(AccountShare.OpportunityAccessLevel))
    {
        ash.OpportunityAccessLevel = 'None';
    }
     insert ash;
        Map<Id,Lead> lMap = new Map<Id,Lead>();
        lMap.put(l.id,l);
     P360_PartnerSharingHelper psh= new P360_PartnerSharingHelper(lMap);
     psh.PossibleAccountShareToDelete = new List<AccountShare>{ash};
     psh.accountShareDelete();
     psh.sendPartnerGeneratedLeadNotifications();
}

}