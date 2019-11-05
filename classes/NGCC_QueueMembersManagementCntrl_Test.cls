/*********************************************************************************************************
Name    : NGCC_QueueMembersManagementCntrl_Test
Author  : Ghattamaneni Chaithanya
Purpose : This is the test Class for the class NGCC_QueueMembersManagementController
Created Date: 08 March 2019

Modification History: 

*********************************************************************************************************/
@isTest
public class NGCC_QueueMembersManagementCntrl_Test {
 @isTest
    public static void QueueMemberAssignmentControllertest(){
        User u = new User(
            ProfileId = [SELECT Id FROM Profile WHERE Name Like '%Cisco_NGCC%' limit 1].Id,
            LastName = 'last',
            Email = 'test@Cisco.com',
            Username = 'test@test.com' + System.currentTimeMillis(),
            CompanyName = 'TEST',
            Title = 'title',
            Alias = 'alias',
            TimeZoneSidKey = 'America/Los_Angeles',
            EmailEncodingKey = 'UTF-8',
            LanguageLocaleKey = 'en_US',
            LocaleSidKey = 'en_US',
            Theatre__c = 'APJC-APAC'
        );
        insert u;
        
        Group g1 = new Group(Name='test_Callback', type='Queue');
        insert g1;
        
        QueuesObject q1 = new QueueSObject(QueueID = g1.id, SobjectType = 'Lead');
        insert q1;
        
        GroupMember GM = new GroupMember(GroupId = g1.id,UserOrGroupId = u.Id);
        insert GM;
        
        PageReference pageRef = Page.NGCC_QueueMembersManagementPage;
        pageRef.getParameters().put('selectedGroupId', String.valueOf(g1.Id));
        Test.setCurrentPage(pageRef);
        
        NGCC_QueueMembersManagementController cntrl = new NGCC_QueueMembersManagementController();
        cntrl.getQueueType();
        cntrl.selectedQueueType = 'Callback';
        cntrl.getgroupOptions();
        cntrl.refresh();
        cntrl.getselectedGroup();
        cntrl.getgroupUsers();
        cntrl.memberToAdd = GM;
        cntrl.addUserToGroup();
        cntrl.userIdToRemove = u.id;
        cntrl.removeUserFromGroup();
    }
    @isTest
    public static void QueueMemberAssignmentControllertest_SelectGroupMessage(){
        PageReference pageRef = Page.NGCC_QueueMembersManagementPage;
        Test.setCurrentPage(pageRef);
        
        NGCC_QueueMembersManagementController cntrl = new NGCC_QueueMembersManagementController();
        cntrl.addUserToGroup();
        cntrl.removeUserFromGroup();
    }
     @isTest
    public static void QueueMemberAssignmentControllertest_SelectUserMessage(){
        Group g1 = new Group(Name='test_Callback', type='Queue');
        insert g1;
        
        QueuesObject q1 = new QueueSObject(QueueID = g1.id, SobjectType = 'Lead');
        insert q1;
        
        PageReference pageRef = Page.NGCC_QueueMembersManagementPage;
        pageRef.getParameters().put('selectedGroupId', String.valueOf(g1.Id));
        Test.setCurrentPage(pageRef);
        
        NGCC_QueueMembersManagementController cntrl = new NGCC_QueueMembersManagementController();
        cntrl.getQueueType();
        cntrl.selectedQueueType = 'Callback';
        cntrl.addUserToGroup();
        cntrl.removeUserFromGroup();
    }
}