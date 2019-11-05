@isTest(SeeAllData=true)

private Class TSN_Add_CaseOwner_As_OptyTeam_Test{
     
     private static testMethod void test(){
        User currentUser = [Select id from user where profileid=:Utilities.getTSNProfileId() and IsActive = True limit 1];
        Group gp1=new Group(name='Group1');
        insert gp1;
       
        System.runAs(currentUser){
            GroupMember gm1=new GroupMember(groupId=gp1.id,userorgroupId=currentUser.id);
            insert gm1;
        }
         
        Case testTSNCase = new Case(RecordTypeId=Utilities.getCaseTSNRecordTypeId(),Contact_Type__c = 'Cisco',Cisco_Contact__c='abc@cisco.com', Architecture__c='Collaboration');
        insert testTSNCase; // TSN Case
 
         // Cisco_US_Commercial User
         
        Profile p1 = [SELECT Id FROM profile WHERE name='Cisco_ADMIN'];
        User opptyOwner= new User(alias = 'newUser1',email='newuser1@cisco.com',emailencodingkey='UTF-8', lastname='Testing',languagelocalekey='en_US',Additional_User_Permissions__c='SE User',localesidkey='en_US', profileid = p1.Id,timezonesidkey='America/Los_Angeles',Theatre__c='Americas-US Commercial', username='newuser1@cisco.com', BA_Territories__c = 'test,sec_1');
        insert opptyOwner;
         
       // User opptyOwner = [Select id from user where profileid = '00e30000000qn3M' and IsActive = True AND Additional_User_Permissions__c != 'Enable_ePSS' limit 1];
         
        // New Opportunity
        Opportunity oppty = new Opportunity(OwnerId=opptyOwner.Id,Opportunity_Owner_AM__c=opptyOwner.Id,name='abc',StageName='2 - Qualification',CloseDate= system.today());
        insert oppty;
        Test.StartTest();
        TSN_Add_CaseOwner_As_OptyTeam TSN_Add_CaseOwner_As_OptyTeam_Object=new TSN_Add_CaseOwner_As_OptyTeam();
        testTSNCase.opportunity__c=oppty.id;
        testTSNCase.ownerId=currentUser.id;
        testTSNCase.team__C='Group1';
        update testTSNCase;
        Id[] c=new List<Id>();
        
        c.add(testTSNCase.id);
        TSN_Add_CaseOwner_As_OptyTeam.TSN_Add_Opty_team(c);
        update testTSNCase; 
        Test.StopTest();
    }
    
    
    private static testMethod void test_insert(){
        User currentUser = [Select id from user where profileid=:Utilities.getTSNProfileId() and IsActive = True and Additional_User_Permissions__c != 'Enable_ePSS' limit 1];
        Group gp1=new Group(name='Group1');
        insert gp1;

        System.runAs(currentUser){
            GroupMember gm1=new GroupMember(groupId=gp1.id,userorgroupId=currentUser.id);
            insert gm1;
        }
        Case testTSNCase = new Case(RecordTypeId=Utilities.getCaseTSNRecordTypeId(),Contact_Type__c = 'Cisco',Cisco_Contact__c='abc@cisco.com', Architecture__c='Collaboration');
 
         // Cisco_US_Commercial User
        Profile p1 = [SELECT Id FROM profile WHERE name='Cisco_ADMIN'];
        User opptyOwner= new User(alias = 'newUser1',email='newuser1@cisco.com',emailencodingkey='UTF-8', lastname='Testing',languagelocalekey='en_US',Additional_User_Permissions__c='SE User',localesidkey='en_US', profileid = p1.Id,timezonesidkey='America/Los_Angeles',Theatre__c='Americas-US Commercial', username='newuser1@cisco.com', BA_Territories__c = 'test,sec_1');
        insert opptyOwner;
        // User opptyOwner = [Select id from user and IsActive = True AND Additional_User_Permissions__c != 'Enable_ePSS' limit 1];
         
         // New Opportunity
         Opportunity oppty = new Opportunity(OwnerId=opptyOwner.Id,Opportunity_Owner_AM__c=opptyOwner.Id,name='abc',StageName='2 - Qualification',CloseDate= system.today());
         insert oppty;
         Test.StartTest();
         TSN_Add_CaseOwner_As_OptyTeam TSN_Add_CaseOwner_As_OptyTeam_Object=new TSN_Add_CaseOwner_As_OptyTeam();
         testTSNCase.opportunity__c=oppty.id;
         testTSNCase.ownerId=currentUser.id;
         testTSNCase.team__C='Group1';
         insert testTSNCase;
         Map<ID, ID> owner_opty_map=new Map<ID, ID>();
        
         owner_opty_map.put(testTSNCase.ownerID, testTSNCase.opportunity__c);
         TSN_Add_CaseOwner_As_OptyTeam.TSN_Add_Opty_team_insert(owner_opty_map);
         Test.StopTest();
    }
}