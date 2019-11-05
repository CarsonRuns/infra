/*
Author          : Shivi Srivastava
Release         : March 29, 2019 Release
Created         : March 26, 2019
Functionality   : multiEditAccountController Test Class


Modification History:
Itrack#        Date        Author              Change 
4/Jun/2019	Kavya 			Removed Seealldata true
*/
@isTest
public class multiEditAccountController_Test {
    static testMethod void multiAccountTest(){
        Utilities.setIsTestMethod(true);
        Utilities.setValidationSkip(true);        
        
        Profile p = [SELECT Id FROM Profile WHERE Name = 'Cisco_ADMIN' Limit 1];
        User usr = lxTestDataFactory.createSingleUser(p.Id);
        insert usr;
        lxTestDataFactory.createCustomSettings();
        Account a = lxTestDataFactory.createChannelAccount(usr.Id);
        a.Country__c ='test';
        a.City__c = 'test';
        insert a;
        AccountTeamMember acntTM = new AccountTeamMember();
        acntTM.TeamMemberRole = 'Cisco_Admin';
        acntTM.AccountId = a.Id;
        acntTM.UserId = usr.Id;
        insert acntTM;
        
        AccountTeamMember atm = [Select Id,TeamMemberRole,User.Username FROM AccountTeamMember limit 1];
        system.debug('accnt team member'+atm);
        User usr1 = [select id from User where isActive=true and id=:atm.user.id limit 1];
        usr.Additional_User_Permissions__c = 'SE User';
        update usr;
        //userIdLst.add(usr.Id);
        String records= '[{'+
            '                    \"accId\": \"'+a.id+'\",'+
            '                    \"accOwner\": \"eudatamanager\",'+
            '                    \"atmId\": \"'+atm.id+'\",'+
            '                    \"atvOptyVal\": 0,' +
            '                \"cActiveOpty\": 1,'+
            '                \"city\": \"CANADA\",'+
            '                \"cOpty\": 12,'+
            '                \"country\": \"CANADA\",'+
            '                \"hasManager\": \"00530000000k1asAAA\",'+
            '                \"memberId\": \"'+usr1.id+'\",'+
            '                \"name\": \"SUNTORY K.K.\",'+
            '               \"optyVal\": 11,'+
            '               \"redirectURL\": \"https://ciscosales--qtr.cs52.my.salesforce.com/0018000000oAFXIAA4",'+
            '               \"role\": \"Systems Engineer (Assigned Account)\",'+
            '               \"teamId\": \"moando\",'+
            '                \"totalContact\": 1'+
            '                }]';
        
        String lstUserIds = '[{'+
            '                    \"id\": \"'+usr1.id+'\"'+
            '                }]';
        
        Test.startTest();
        Boolean save= multiEditAccountController.saveAssignments(records,lstUserIds,true);   
        Boolean save1= multiEditAccountController.saveAssignments(records,lstUserIds,false);   
        Boolean remove= multiEditAccountController.removeAssignments(records,lstUserIds);
        Boolean deleteRec= multiEditAccountController.deleteAssignments(records,lstUserIds);
        Boolean checkSE1=multiEditAccountController.checkSEUserPermission();
        system.runAs(usr){
            Boolean checkSE=multiEditAccountController.checkSEUserPermission();
        }
        Test.stopTest();
    }
}