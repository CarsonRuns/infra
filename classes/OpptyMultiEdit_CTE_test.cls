/************************************************************************************************************************************
Name    : OpptyMultiEdit_CTE_test 
Purpose : Test class for OpptyMultiEdit_CTE class

Modification History:  updated by Naresh

*************************************************************************************************************************************/ 

@isTest
public class OpptyMultiEdit_CTE_test {
    public static testMethod void test_OpptyMultiEdit_CTE_N()
    {
        Utilities.setIsTestMethod(true);
        Utilities.setValidationSkip(true);
        Utilities.setSkipFuture(true);
        
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Cisco_ADMIN' Limit 1];
        User usr = lxTestDataFactory.createSingleUser(p.Id);
        system.runAs(usr){
            lxTestDataFactory.createCustomSettings();
            PageReference newpage  = new PageReference('/apex/OpptyMultiEdit?robots=true');
            Test.setCurrentPageReference( newpage );
            Opportunity testOpty = lxTestDataFactory.createSingleOppty();
            testOpty.Opportunity_Status__c ='Lost';
            testOpty.Contractual_Pricing_Letter_Opportunity__c = 'No';
            insert testOpty;
            List<opportunity> opptyList = new List<Opportunity>();
            opptyList.add(testOpty);
            ApexPages.StandardSetController ssc = new ApexPages.StandardSetController( opptyList );
            ssc.setSelected(opptyList);                                                      
            String proflie= UserInfo.getProfileId();
            String profileId = proflie.substring(0,proflie.length()-3);                                                      
            ProfileID__c objectnew = new ProfileID__c(SetupOwnerId=UserInfo.getOrganizationId(), Cisco_US_Commercial__c=profileId);
            OpptyMultiEdit_CTE.wrapOpportunity wpOpp = new OpptyMultiEdit_CTE.wrapOpportunity(testOpty);
            OpptyMultiEdit_CTE.seOpportunity seoppty = new OpptyMultiEdit_CTE.seOpportunity();
            seoppty.seOpp =testOpty;
            seoppty.selected = true;
            
            seoppty.headerSelected = true;
            List<OpptyMultiEdit_CTE.seOpportunity> seWrapperList = new List<OpptyMultiEdit_CTE.seOpportunity>();
            seWrapperList.add(seoppty);
            System.debug('>>> '+seWrapperList);
            OpptyMultiEdit_CTE.seTech setech = new OpptyMultiEdit_CTE.seTech();
            setech.techBE = 'test';
            setech.techMixPercent = 12;
            OpptyMultiEdit_CTE.seService seservice = new OpptyMultiEdit_CTE.seService();
            seservice.serviceBE = 'test';
            seservice.serviceMixPercent = 12;
            seOppty.selected = true;
            seOppty.headerSelected = true;
            seOppty.seOpp = testOpty;
            Account a = lxTestDataFactory.createChannelAccount(usr.Id);
            insert a;
            Pricebook2 pb21 = lxTestDataFactory.createPriceBook2();
            insert pb21;
            Opportunity opty2 = lxTestDataFactory.createSingleOpportunity(a.id, pb21.id, usr.Id);
            insert opty2;
            seoppty.selected = true;
            Resource_Request_Assignment__c resreq= new Resource_Request_Assignment__c(Opportunity_Name__c=opty2.Id,
                                                                                Resource_Name__c=usr.Name,Resource_Status__c='Decline-Pending');
            
           
            OpptyMultiEdit_CTE ct = new OpptyMultiEdit_CTE( ssc ); 
           
            ct.getGoToUrl();
            ct.setGoToUrl('/test');
            ct.setSaveNew();
            ct.getErrorMsg();  
            ct.getOpptyList();
            ct.getOpptyCount();    
            ct.getStage1();        
            ct.getStage2();
            ct.getStage3();
            ct.getStage4();
            ct.getStage5();
            ct.getTeamRolePicklist();
            ct.getWrapOpptunityList();
            ct.getSEWrapperList();
            ct.showSE();
            ct.showSpecialist();
            ct.seWrapperList=seWrapperList;
            ct.checkBoxAction();
            ct.seassignMyself();
            ct.seAssignSomeoneElse();
            ct.closePopup();
            ct.saveNClose();
            ct.saveNew();
            ct.getsearchBy();
            ct.passUserId();
            ct.seUserSave();
            ct.prevListviewId = 'test';
            ct.listViewId = 'test';
            ct.searchKey='shi';
            ct.search();

            if(opty2!=null){
                ct.getCompetitorsPicklist();
                ct.setCompetitorsPicklist(opty2);
                ct.ExtensionSave();
                ct.processSelected();
            }
            
        }
        
    }  
    public static testMethod void test_OpptyMultiEdit_CTE_N1(){
        Utilities.setIsTestMethod(true);
        Utilities.setValidationSkip(true);
        Utilities.setSkipFuture(true);
        
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Cisco_ADMIN' Limit 1];
        User usr = lxTestDataFactory.createSingleUser(p.Id);
        system.runAs(usr){
            User user1 = new User(firstName='Test1',LastName ='PA Contact', USERNAME='testpa2@cisco.com.sales.test',email='testpa232@cisco.com.test',ALIAS='testp',COMMUNITYNICKNAME='testp',ISACTIVE=True,
                             TIMEZONESIDKEY='America/Los_Angeles',LnP_T_C_Acepted_Date__c=Date.Today()+5,LnP_TC_Reset_Date__c=Date.Today()-5,LnP_TC_Accepted__c=true,PROFILEID =p.Id ,LANGUAGELOCALEKEY ='en_US',THEATRE__C='APJC-APAC',
                             LOCALESIDKEY ='en_US',EMAILENCODINGKEY='UTF-8',Additional_User_Permissions__c='SE User',
                            Notification_Entity__c='Case; Opportunity',Notification_Platform__c='Email; WebEx Teams',Notification_Preference__c='Daily Digest'
                            );
            insert user1;
            user1.Reporting_Manager_Level_1_cec__c=usr.Username.substringBefore('@');
            update user1;
            lxTestDataFactory.createCustomSettings();
            PageReference newpage  = new PageReference('/apex/OpptyMultiEdit?robots=true');
            Test.setCurrentPageReference( newpage );
            Opportunity testOpty = lxTestDataFactory.createSingleOppty();
            testOpty.Opportunity_Status__c ='Lost';
            testOpty.Contractual_Pricing_Letter_Opportunity__c = 'No';
            insert testOpty;
            List<opportunity> opptyList = new List<Opportunity>();
            opptyList.add(testOpty);
        ApexPages.StandardSetController ssc = new ApexPages.StandardSetController( opptyList );
        OpptyMultiEdit_CTE ct = new OpptyMultiEdit_CTE( ssc ); 
        ct.searchKey='';
        ct.search();
        ct.checkSEMOrSED(user1.username.substringBefore('@'));
        }
    }
    
}