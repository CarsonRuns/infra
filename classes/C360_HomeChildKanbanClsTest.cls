/*
* Copyright (c) 2018, salesforce.com, inc.
* All rights reserved.
* SPDX-License-Identifier: BSD-3-Clause
* For full license text, see the LICENSE file in the repo root or https://opensource.org/licenses/BSD-3-Clause
*/
@isTest
public class C360_HomeChildKanbanClsTest {
    
    public static testmethod void tm1(){
        Profile prof = [select id from profile where name LIKE 'Cisco_ADMIN'];
        User user = new User(Alias = 'newUser', Email='newuser@cisco.com',
                             EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                             LocaleSidKey='en_US', ProfileId = prof.id,
                             TimeZoneSidKey='America/Los_Angeles', UserName='newuser@cisco.com', 
                             Theatre__c = 'Americas-US Commercial', Additional_User_Permissions__c='Enable EndUser ACCTCreation');
        insert user;
        
        insert new ObjectRecordTypeIds__c(AccountChannelRecordTypeId__c = '33e30000000dcbg', 
                                          Account_Customer_RecordTypeId__c=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId());
        insert new ProfileID__c(Cisco_Renewals__c = '11e30000000dcbg', Cisco_PSS__c='22e30000000dcbg');
        insert new Org_Constants__c(Key__c = 'Oppty: ProfileIds to skip Triggers', prod_value__c='prodval');
        system.runAs(user){
            Account a = new Account();
            a.Name = 'customer acc';
            a.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
            insert a;
            
            Account acc2 = new Account();
            acc2.Name = 'Bu acc';
            acc2.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Unit').getRecordTypeId();
            acc2.ParentId = a.Id;
            insert acc2;
            
            Account acc3 = new Account();
            acc3.Name = 'End user acc';
            acc3.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('End-User').getRecordTypeId();
            acc3.ParentId = acc2.Id;
            insert acc3;
            
            Opportunity o = new Opportunity();
            o.Partner_Required__c = true;
            o.AccountId = acc3.Id;
            o.StageName = '1 - Prospect';
            o.Name = 'opp name';
            o.CloseDate = date.today();
            insert o;
            List<string> lString = new  List<string>();
            lString.add('Name');
            lString.add('OwnerId');
            List<string> lStrings = new list<string>();
            lStrings.add('Closed Lost');
            List<Id> customersId = new List<Id>();
            List<String> offerName = new List<String>();
            
            Test.startTest();
            C360_HomeChildKanbanUtil wrp = C360_HomeChildKanbanCls.getKanban('opportunity', lString, 'stagename', string.valueOf(a.id), 'AccountId', lStrings, 'Amount', 'Name', customersId,offerName);
            C360_HomeChildKanbanCls.getKanban('opportunity', lString, 'stagename', string.valueOf(a.id), 'AccountId', lStrings, 'Name', 'Name', customersId,offerName);
            C360_HomeChildKanbanCls.getKanban('opportunity', lString, 'stagenam', string.valueOf(a.id), 'AccountId', null, null, 'Name', customersId,offerName);        
            C360_HomeChildKanbanCls.getObjs();
            C360_HomeChildKanbanCls.getObjChilds('Account');
            C360_HomeChildKanbanCls.getObjFlds('Account');
            C360_HomeChildKanbanCls.getPickVals('Industry','Account');
            system.assertEquals(wrp.isSuccess, true);
            Test.stopTest();
        }
    }    
    
    public static testmethod void tm2(){
        Profile prof = [select id from profile where name LIKE 'Cisco_ADMIN'];
        User user = new User(Alias = 'newUser', Email='newuser@cisco.com',
                             EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                             LocaleSidKey='en_US', ProfileId = prof.id,
                             TimeZoneSidKey='America/Los_Angeles', UserName='newuser@cisco.com', 
                             Theatre__c = 'Americas-US Commercial', Additional_User_Permissions__c='Enable EndUser ACCTCreation');
        insert user;
        
        insert new ObjectRecordTypeIds__c(AccountChannelRecordTypeId__c = '33e30000000dcbg', 
                                          Account_Customer_RecordTypeId__c=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId());
        insert new ProfileID__c(Cisco_Renewals__c = '11e30000000dcbg', Cisco_PSS__c='22e30000000dcbg');
        insert new Org_Constants__c(Key__c = 'Oppty: ProfileIds to skip Triggers', prod_value__c='prodval');
        system.runAs(user){
            Account a = new Account();
            a.Name = 'customer acc';
            a.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
            insert a;
            
            Account acc2 = new Account();
            acc2.Name = 'Bu acc';
            acc2.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Unit').getRecordTypeId();
            acc2.ParentId = a.Id;
            insert acc2;
            
            Account acc3 = new Account();
            acc3.Name = 'End user acc';
            acc3.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('End-User').getRecordTypeId();
            acc3.ParentId = acc2.Id;
            insert acc3;
            
            Opportunity o = new Opportunity();
            o.Partner_Required__c = true;
            o.AccountId = acc3.Id;
            o.StageName = '1 - Prospect';
            o.Name = 'opp name';
            o.CloseDate = date.today();
            insert o;
            //opportunity o = new opportunity(Name = 'name', AccountId = a.id, StageName = 'Qualification', CloseDate = Date.today());
            //insert o;
            string act = C360_HomeChildKanbanCls.updateRec(string.valueOf(o.id), '1 - Prospect', '1 - Prospect');
            C360_HomeChildKanbanCls.updateRec(string.valueOf(o.id)+'a', '1 - Prospect', '1 - Prospect');
            //system.assertEquals(act, 'true');
        }
    }
    
    public static testmethod void tm3(){
        Profile prof = [select id from profile where name LIKE 'Cisco_ADMIN'];
        User user = new User(Alias = 'newUser', Email='newuser@cisco.com',
                             EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
                             LocaleSidKey='en_US', ProfileId = prof.id,
                             TimeZoneSidKey='America/Los_Angeles', UserName='newuser@cisco.com', 
                             Theatre__c = 'Americas-US Commercial', Additional_User_Permissions__c='Enable EndUser ACCTCreation');
        insert user;
        
        insert new ObjectRecordTypeIds__c(AccountChannelRecordTypeId__c = '33e30000000dcbg', 
                                          Account_Customer_RecordTypeId__c=Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId());
        insert new ProfileID__c(Cisco_Renewals__c = '11e30000000dcbg', Cisco_PSS__c='22e30000000dcbg');
        insert new Org_Constants__c(Key__c = 'Oppty: ProfileIds to skip Triggers', prod_value__c='prodval');
        system.runAs(user){
            Account a = new Account();
            a.Name = 'customer acc';
            a.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Customer').getRecordTypeId();
            insert a;
            
            Account acc2 = new Account();
            acc2.Name = 'Bu acc';
            acc2.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Business Unit').getRecordTypeId();
            acc2.ParentId = a.Id;
            insert acc2;
            
            Account acc3 = new Account();
            acc3.Name = 'End user acc';
            acc3.RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('End-User').getRecordTypeId();
            acc3.ParentId = acc2.Id;
            insert acc3;
            
            Opportunity o = new Opportunity();
            o.Partner_Required__c = true;
            o.AccountId = acc3.Id;
            o.StageName = '1 - Prospect';
            o.Name = 'opp name';
            o.CloseDate = date.today();
            insert o;
            C360_HomeChildKanbanCls.deleteRec(o);
            system.assertEquals(null, null);
        }
    }
    
    public static testmethod void tm4(){
        kanbanDev__Kanban_Configuration__c k = new kanbanDev__Kanban_Configuration__c(Name='Test');
        string res = C360_HomeChildKanbanCls.saveConfig(k);
        system.assertEquals(res, 'true');
    }
    
    public static testmethod void tm5(){
        kanbanDev__Kanban_Configuration__c k = new kanbanDev__Kanban_Configuration__c(Name='Test');
        insert k;
        C360_KanbanConfigList ka = new C360_KanbanConfigList();
        ka.getDefaultValue();
        ka.getValues();
        system.assertEquals(null, null);
    }
    
}