/************************************************************************************************************************************
Name    : NGCC_QueueMembersManagementController
Author  : Ghattamaneni Chaithanya
Purpose : This is the main controller class for Queue members managemnt tool.
Created Date: 08 March 2019

Modification History: 
    1. 	Author  : Ghattamaneni Chaithanya
    	Purpose : Scava Fixes
    	Date	: 25 Apr 2019
    2.	Author  : Ghattamaneni Chaithanya
    	Purpose : Extended the functionality to Chat Queues as well
    	Date	: 24 May 2019
*************************************************************************************************************************************/
public class NGCC_QueueMembersManagementController {
    public ID selectedGroupId { get; set; }
    public GroupMember memberToAdd { get; set; }
    public ID userIdToRemove { get; set; }
    public string selectedQueueType { get; set; }
    
    public NGCC_QueueMembersManagementController() {
        selectedGroupId = ApexPages.currentPage().getParameters().get('selectedGroupId');
        memberToAdd = new GroupMember(); 
    }
    public List<SelectOption> getQueueType() {
        List<SelectOption> options = new List<SelectOption>();
        options.add( new SelectOption( '', '- Select -' ) );
        options.add( new SelectOption( 'Callback', 'Callback Queue' ) );
        options.add( new SelectOption( 'Chat', 'Chat Queue' ) );
        return options;
    }
    
    public List<SelectOption> getgroupOptions() {
        List<SelectOption> options = new List<SelectOption>();
        string QType = '%'+selectedQueueType+'%';
        options.add( new SelectOption( '', '- Select -' ) );
        for ( Group grp : [SELECT id, name FROM	group WHERE type = 'Queue' and  name like :QType ORDER BY name] ) {
            options.add( new SelectOption( grp.id, grp.name ) );
        }
        return options;
    }
    
    public PageReference refreshgroup() {
        selectedGroupId = null;
        return null;
    }
    
    public PageReference refresh() {
        return null;
    }
    
    public PageReference addUserToGroup() {       
        if ( String.isBlank( selectedGroupId ) ) {
            ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.ERROR, 'Please choose a queue' ) );
            return null;
        }
        if ( memberToAdd == null || String.isBlank( memberToAdd.userOrGroupId ) ) {
            ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.ERROR, 'Please choose a user' ) );
            return null;
        }
        
        GroupMember gm = new GroupMember();
        if(flsGet(GroupMember.groupId)){
            gm.groupId = selectedGroupId;
        }
        if(flsGet(GroupMember.userOrGroupId)){
            gm.userOrGroupId = memberToAdd.userOrGroupId;
        }
        insert gm;        
        User user = getUserById( memberToAdd.userOrGroupId );
        ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.CONFIRM, user.name + ' added to queue!' ) );
        memberToAdd = new GroupMember();
        return null;
    }
    
    public User getUserById( ID userId ) {
        return [ SELECT id, name FROM user WHERE id = :userId ];
    }
    
    public List<User> getgroupUsers() {
        return new List<User>([SELECT id, firstName, lastName, username, email, isActive FROM user   WHERE
                               id IN ( SELECT userOrGroupId FROM groupmember WHERE groupId = :selectedGroupId ) AND isActive = true ORDER BY firstName ]);
    }
    
    public PageReference removeUserFromGroup() {        
        if ( String.isBlank( selectedGroupId ) ) {
            ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.ERROR, 'Please choose a queue' ) );
            return null;
        }
        if ( String.isBlank( userIdToRemove ) ) {
            ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.ERROR, 'Please choose a user' ) );
            return null;
        }
        List<GroupMember> members = new List<GroupMember>([SELECT id FROM groupmember WHERE groupId = :selectedGroupId AND userOrGroupId = :userIdToRemove]);
        if ( !members.isEmpty() ) {
            if(GroupMember.sObjectType.getDescribe().isDeletable()&& GroupMember.sObjectType.getDescribe().isAccessible()){
                delete members;
            }
        }
        User user = getUserById( userIdToRemove );
        ApexPages.addMessage( new ApexPages.Message( ApexPages.Severity.CONFIRM, user.name + ' removed from queue!' ) );
        userIdToRemove = null;
        return null;
    }  
    public Group getselectedGroup(){
        return [SELECT id,name FROM	group WHERE	id = :selectedGroupId ];
    }
    // SCAVA Helper Method
    public static Boolean flsGet(SObjectField field)
    {
        return field.getDescribe().isCreateable() ? true : false;
    }    
}