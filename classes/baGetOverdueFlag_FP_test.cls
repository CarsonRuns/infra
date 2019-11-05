@istest
public class baGetOverdueFlag_FP_test {
    public static testMethod void test()
    {
        system.debug('baOverDueflag is :  start time normal ba territory :'+system.now());
        long d1=system.currentTimeMillis();
        string baOverDueflag = baGetOverdueFlag_FP.getOverdueflag('600025', Date.newInstance(2010,05,30));
        long d2=system.currentTimeMillis();
        system.debug('baOverDueflag is :  end time normal ba territory :'+system.now());
        system.debug('baOverDueflag is :  '+baOverDueflag+'   Difference : '+(d2-d1) );
        system.debug('baOverDueflag is :  start time oneclick ba territory :'+system.now());
        d1=system.currentTimeMillis();
        //string baOverDueflag2 = getOverdueflag('saperrea@cisco.com.dev', Date.newInstance(2010,05,30));
        string baOverDueflag2 = baGetOverdueFlag_FP.getOverdueflag('saperrea@cisco.com.dev', Date.newInstance(2010,07,04));
        d2=system.currentTimeMillis();
        system.debug('baOverDueflag is :  end time oneclick ba territory :'+system.now());
        system.debug('baOverDueflag2 is :  '+baOverDueflag2+'     Diff   :  '+(d2-d1));
    }  
    public static testMethod void test_HomePageMsg_CT()
    {
        Test.startTest();
        try{       
            HomePageMsg_CT controller = new HomePageMsg_CT();    
            controller.getOverDueOpptys();
            controller.getOverDueOpptysLt30Days();
            controller.getWaitingLeads();
            controller.getAcceptedLeads();
            controller.getItems();
            controller.getOptyWithEndDatedTerritory();
            string temp = controller.WaitingLeadsID;
            string temp1 = controller.AcceptedLeadsID;
            string temp2 = controller.OverDueOpptysID;
            string temp3 = controller.OverDueOpptysLt30DaysID;
            controller.ObjectIds('WaitingLeads');
            Opportunity o = new Opportunity(name='o1',StageName=controller.Stage1,CloseDate= System.today(), Automate_Movement_to_Stage_3__c = controller.Yes, Forecast_Status__c = controller.NotForecastable );
            Unconverted_Opportunities__c uo = new Unconverted_Opportunities__c(Notification_Type__c = 'UNCONVERTED_COUNT',CEC_User_Name__c = UserInfo.getUserName().split('@')[0],Number_of_Unconverted_Opportunities__c = 1);
            
        }
        catch(exception e){}
        Test.stopTest();        
    }    
    //TEST METHOD//
    public static testMethod void test_OpptyMessages_CTE(){
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Cisco_Admin' Limit 1];
        User admUser = new User(Additional_User_Permissions__c = 'Enable EndUser ACCTCreation', Alias = 'newUser', Email = 'batchJobOppty@cisco.com',
                                EmailEncodingKey = 'UTF-8', LastName = 'Testing', LanguageLocaleKey = 'en_US',
                                LocaleSidKey = 'en_US', ProfileId = p.Id, TimeZoneSidKey = 'America/Los_Angeles', UserName = 'batchJobOppty@cisco.com.testing', Theatre__c = 'Americas-US Commercial');
        insert admUser; 
        System.runAs(admUser){
            ProfileID__c profileIds = new ProfileID__c();
            profileIds.Cisco_Renewals__c = '00e34000001CQnp';
            profileIds.Cisco_PSS__c = '00e30000000rrZw';
            insert profileIds;
            Org_Constants__c  orgC = new Org_Constants__c();
            orgC.Key__c = 'Oppty: ProfileIds to skip Triggers';
            orgC.prod_value__c = 'For testing';
            orgC.Type__c = 'URL';
            insert orgC; 
            ObjectRecordTypeIds__c objR = new ObjectRecordTypeIds__c();
            objR.Opportunity_Parent_Mobile_RecordTypeId__c = '01234000000GGKw';
            insert objR;
            
            List<Territory2Type> terriType  = [SELECT id, DeveloperName from Territory2Type where  DeveloperName = 'DR' LIMIT 1];
            //insert territory model
            
            List<Territory2Model>   terrModel = [Select Id from Territory2Model where State = 'Active' limit 1];
            
            Territory2 terrData = new Territory2(
                DeveloperName = 'TestTerritory', 
                Territory2ModelId=terrModel[0].Id, Name='Parent Territory', Territory2TypeId=terriType[0].Id,AccountAccessLevel = 'All',
                OpportunityAccessLevel = 'Edit');
            insert terrData;
            List<Territory2> terr1 = new List<Territory2>();
            terr1.add(terrData);
            
            Test.setCurrentPageReference(new PageReference('OpptyMessages'));
            //Test.startTest();
            Opportunity o = new Opportunity(name='Test',StageName='2 - Qualified',Expected_Product__c=10.0,error_description__c='error',DealID__c='1',Opportunity_Status__c='Active',territory2id=terr1[0].id,CloseDate=system.today()+4);
            //insert o;
            ApexPages.StandardController sc = new ApexPages.StandardController(o);  
            OpptyMessages_CTE controller = new OpptyMessages_CTE(sc);
            controller.checkTerritory();
            List<UserTerritory2Association> utList = new List<UserTerritory2Association>();
            UserTerritory2association ut = new UserTerritory2Association(Territory2Id=o.territory2id,UserId=UserInfo.getUserId());
            utList.add(ut);
            controller.checkTerritory();
            controller.getOverdueMsg();
            controller.getIsMessages();
            controller.isOverdue=false;
            controller.isError=false;
            controller.getIsMessages();
            //Test.stopTest();
        }
    }
}