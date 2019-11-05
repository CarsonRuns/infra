/********************************************************************************************************************************
Name    : NGCC_Items_To_Approve_CTL 
Author  : Mukesh Srivastava
Purpose : This is the controller class for showing notificaition on the side bar to marketing user. It has two part:
            1) To show count of Leads waiting for approval but only to Site Managers or CCMs
            2) To show count of Leads rejected either by Sales after been sent to sales or Marketing user during Approval process
Created Date: 1/14/2014
Modification History: 

***********************************************************************************************************************************/
public class NGCC_Items_To_Approve_CTL {

    // Queue Id where the user is been a member
    Id actId;
    Set<Id> setGroupId = new Set<Id>();
    public String strItemToApprove {get;set;}
    public String strRejected {get;set;}
    
    // @ Constructor
    public NGCC_Items_To_Approve_CTL() {
        Org_Constant_CS__c csIA = Org_Constant_CS__c.getInstance('NGCC_Items_to_Approve');
        strItemToApprove = csIA.Production_Value__c;
        
        Org_Constant_CS__c csRej = Org_Constant_CS__c.getInstance('NGCC_Items_to_Approve_Rejected');
        strRejected = csRej.Production_Value__c;
    }
    /* @method: Get the count of leads waiting for approval by to the logged in user or his/her queue
    //@ return: Count of leads waiting for approval */
    public integer getApprovalRecord() {
        // Count of lead waiting for approval
        integer appCount = 0;

        // Get the Queue detail which is associated to user
        LIST < GroupMember > actList = [SELECT GroupId from GroupMember where UserOrGroupId IN(SELECT Id from Group where RelatedId = : UserInfo.getUserRoleId())];

        for(GroupMember gm: actList){
            setGroupId.add(gm.GroupId);
        }
        
        
        // Get the count of record waiting for approval based on Queue and Logged in user
        appCount = [Select Count() from ProcessInstanceWorkItem WHERE ProcessInstance.Status = 'Pending'
            AND(ActorId IN : setGroupId OR ActorId = : UserInfo.getUserId()) LIMIT 101
        ];

        // Returns the count of lead waiting for approval
        return appCount;
    }

    /* @method: Get the count of leads Rejected by Sales and Marketing manager (during approval process)
    //@ return: Count of leads Rejected by Marketing user or Sales */
    public integer getRejectedRecord() {
        // Count of Rejected lead for the logged in User
        integer rejCount = 0;

        // Getting the count of lead rejected by Sales and Marketing manager (during approval process)
        rejCount = [Select Count() from Lead WHERE Status Like 'Rejected%'
            AND OwnerId = : UserInfo.getUserId() LIMIT 101
        ];

        // Returns the count of Lead rejected
        return rejCount;
    }

    /* @method: Validate the logged user and hide the Approval notification if the logged in user in SDR
    //@ return: false if the logged user in SDR else true */
    public boolean getValidateUser() {
        try {
            // Validating the logged in User profile name
            UserRole usrRole = [Select name from UserRole where Id = : UserInfo.getUserRoleId() LIMIT 1];

            // if the logged in SDR then hide else show the approval notification
            if (usrRole.Name.contains('SDR')) {
                return false;
            } else {
                return true;
            }
        }
        // if any user without any roles access it then show both
        catch (Exception e) {
            return true;
        }
    }
}