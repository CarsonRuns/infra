/************************************************************************************************************************************
Name    : CustomerGURenewalRollupToAccountTest
Author  : C360 Dev team
Purpose : Contains logic to execute test methods of CustomerGURenewalRollupToAccount,CustomerGURenewalRollupScheduleBatchApex
Date    : 25/02/2019

*************************************************************************************************************************************/
@isTest
public class CustomerGURenewalRollupToAccountTest{
    static testMethod void testmethodRollup(){
        Profile prof = [select id from profile where name LIKE '%Cisco_ADMIN%' limit 1];
        User user = new User(Alias = 'newUser', Email='newuser@cisco.com',
                             EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                             LocaleSidKey='en_US', ProfileId = prof.id,
                             TimeZoneSidKey='America/Los_Angeles', UserName='newuser@cisco.com', 
                             Theatre__c = 'Americas-US Commercial', Additional_User_Permissions__c='Enable EndUser ACCTCreation');
        insert user;
        
        insert new ProfileID__c(Cisco_Renewals__c = '11e30000000dcbg', Cisco_PSS__c='22e30000000dcbg');
        insert new Org_Constants__c(Key__c = 'Oppty: ProfileIds to skip Triggers', prod_value__c='prodval');
        insert new Org_Constant_CS__c(Name='PilotProfileId',Non_Production_Value__c='00e30000000dV6c',Production_Value__c='00e30000000dV6c');
        
        system.runAs(user){     
            
            Id customerRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
            Id buRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Unit').getRecordTypeId();
            Id endUserRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('End-User').getRecordTypeId();
            Id channerRecId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Channel').getRecordTypeId();
            
            insert new ObjectRecordTypeIds__c(AccountChannelRecordTypeId__c = channerRecId,Account_Customer_RecordType_18__c=customerRecId,Account_BU_RecordType_18__c=buRecId,Account_End_User_RT_18__c=endUserRecId);
            
            Account customer = new Account(Name='CUSTOMER-AMP',RecordTypeId=customerRecId,Total_Upcoming_Renewals__c = 0,Forecasted_Attrition__c=0);
            insert customer;
            
            Account bu1 = new Account(Name='BU - AMP AU',ParentId=customer.Id,RecordTypeId=buRecId,Total_Upcoming_Renewals__c = 0,Forecasted_Attrition__c=0);
            Account bu2 = new Account(Name='BU - AMP US',ParentId=customer.Id,RecordTypeId=buRecId,Total_Upcoming_Renewals__c = 0,Forecasted_Attrition__c=0);
            List<Account> buList = new List<Account>();
            buList.add(bu1);
            buList.add(bu2);
            insert buList;
            
            Account endUser1 = new Account(Name='PACIFIC INDUSTRIES',ParentId=bu1.Id,RecordTypeId=endUserRecId);
            insert endUser1;
            
            Id oppRecId = Schema.SObjectType.Opportunity.getRecordTypeInfosByName().get('Renewals Opportunity').getRecordTypeId();
            List<Opportunity> oppList = new List<Opportunity>();
            Opportunity opp1 = new Opportunity(Name='AMP Capital',recordTypeId=oppRecId,AccountId=endUser1.Id,StageName='1 - Prospect',CloseDate=System.today(),Partner_Required__c = true,Forecasted_Attrition_000s__c=50);
            Opportunity opp2 = new Opportunity(Name='AMP Capital Meraki Retail Wifi',recordTypeId=oppRecId,AccountId=endUser1.Id,StageName='1 - Prospect',CloseDate=System.today(),Partner_Required__c = true,Forecasted_Attrition_000s__c=50);
            oppList.add(opp1);
            oppList.add(opp2);
            insert oppList ;
            
            Profile prof1 = [select id from profile where name LIKE '%Cisco_Sales%' limit 1];
            User salesUser = new User(Alias = 'salesUse', Email='salesUser@cisco.com',
                                      EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                                      LocaleSidKey='en_US', ProfileId = prof1.id,
                                      TimeZoneSidKey='America/Los_Angeles', UserName='salesUser@cisco.com', 
                                      Theatre__c = 'Americas-US Commercial');
            insert salesUser;
            List<OpportunityTeamMember> oppTeamList = new List<OpportunityTeamMember>();
            OpportunityTeamMember member1 = new OpportunityTeamMember(OpportunityId=opp1.Id,userId=salesUser.Id,TeamMemberRole='Account Manager',opportunityAccessLevel='Edit');
            OpportunityTeamMember member3 = new OpportunityTeamMember(OpportunityId=opp2.Id,userId=salesUser.Id,TeamMemberRole='Account Manager',opportunityAccessLevel='Edit');
            oppTeamList.add(member1);
            oppTeamList.add(member3);
            insert oppTeamList;
            
            insert new  Apex_Batch_Job__c (Name ='OppRollupToAccount',query__c='Select Id,Name,Customer_Rollup_Renewals__c,Forecasted_Attrition_Rollup__c,ParentId,Roll_up_of_Total_Prior_ATR__c,Roll_up_of_Total_Expected_ATR__c from Account where (Customer_Rollup_Renewals__c > 0 OR Forecasted_Attrition_Rollup__c > 0',query1__c ='OR Roll_up_of_Total_Prior_ATR__c>0 OR Roll_up_of_Total_Expected_ATR__c > 0 )  and Id =\''+enduser1.id+'\'');
            
            String query = 'Select Id,Name,Customer_Rollup_Renewals__c,Forecasted_Attrition_Rollup__c,ParentId,Roll_up_of_Total_Prior_ATR__c,Roll_up_of_Total_Expected_ATR__c from Account where (Customer_Rollup_Renewals__c > 0 OR Forecasted_Attrition_Rollup__c > 0  OR Roll_up_of_Total_Prior_ATR__c>0 OR Roll_up_of_Total_Expected_ATR__c > 0 )  and Id =\''+enduser1.id+'\'';
            CustomerGURenewalRollupToAccount obj = new CustomerGURenewalRollupToAccount(query);
            String sch = '0 0 8 13 2 ?';
            CustomerGURenewalRollupScheduleBatchApex gl= new CustomerGURenewalRollupScheduleBatchApex();
            gl.query='Select Id,Name,Customer_Rollup_Renewals__c,Forecasted_Attrition_Rollup__c,ParentId,Roll_up_of_Total_Prior_ATR__c,Roll_up_of_Total_Expected_ATR__c from Account where (Customer_Rollup_Renewals__c > 0 OR Forecasted_Attrition_Rollup__c > 0 OR Roll_up_of_Total_Prior_ATR__c>0 OR Roll_up_of_Total_Expected_ATR__c > 0 )  and Id =\''+enduser1.id+'\'';
            String jobIds = System.schedule('testBasicScheduledApex',sch,gl);
            ID JobId = Database.executeBatch(obj,200);  
            
        }
    }   
}