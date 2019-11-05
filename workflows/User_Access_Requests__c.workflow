<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_to_Recipient_with_request_status</fullName>
        <description>Email to Recipient with request status</description>
        <protected>false</protected>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>donotreply-ciscosales@cisco.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>SFDC_User_Access_Email_Templates/User_Access_2nd_Level_Decision_Email</template>
    </alerts>
    <alerts>
        <fullName>SFDC_User_Access_Granted_Email_Notification</fullName>
        <description>SFDC User Access Granted Email Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>donotreply-ciscosales@cisco.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>SFDC_User_Access_Email_Templates/User_Access_Granted_Email</template>
    </alerts>
    <alerts>
        <fullName>User_Access_GSTS_Alert</fullName>
        <ccEmails>sfdc-st@cisco.com</ccEmails>
        <description>User Access GSTS Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>alfowler@cisco.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>sfdc-automated-email-donotreply@cisco.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>UAR/User_Access_GSTS_Alert_Director_Not_Found</template>
    </alerts>
    <alerts>
        <fullName>User_Access_GSTS_Alert_Duplicate_User2</fullName>
        <ccEmails>sfdc-st@cisco.com</ccEmails>
        <description>User Access GSTS Alert - Duplicate User2</description>
        <protected>false</protected>
        <recipients>
            <recipient>alfowler@cisco.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>sfdc-automated-email-donotreply@cisco.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>UAR/User_Access_GSTS_Alert_Duplicate_User</template>
    </alerts>
    <fieldUpdates>
        <fullName>Approved_Decision_Field_Update</fullName>
        <field>Level_2_Approver_Decision__c</field>
        <literalValue>Approved</literalValue>
        <name>2nd Level Approved Decision Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Level_2_Approval_Status_Update</fullName>
        <description>Setting Level 2 Approval status to Pending</description>
        <field>Level_2_Approver_Decision__c</field>
        <literalValue>Pending</literalValue>
        <name>Level 2 Approval Status Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reject_Decision_Field_Update</fullName>
        <field>Level_2_Approver_Decision__c</field>
        <literalValue>Rejected</literalValue>
        <name>2nd Level Reject Decision Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Request_Status_Level_2_Pending</fullName>
        <field>Request_Status__c</field>
        <literalValue>Level 2 Approval Pending</literalValue>
        <name>Request Status Level 2 Pending</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Request_Status_Update</fullName>
        <field>Request_Status__c</field>
        <literalValue>Provisioning in Progress</literalValue>
        <name>Request Status Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Request_Status_Update_for_L2_Approved</fullName>
        <description>Request Status changes to "Provisioning in Progress" when L2 approval is approved.</description>
        <field>Request_Status__c</field>
        <literalValue>Provisioning in Progress</literalValue>
        <name>Request Status Update for L2 Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>User_Access_Level_1_Approval_Pending</fullName>
        <description>Updates Level 1 Approver Decision to Pending when Level 1 Approval is required</description>
        <field>Level_1_Approver_Decision__c</field>
        <literalValue>Pending</literalValue>
        <name>User Access Level 1 Approval Pending</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>User_Access_Level_2_Approval</fullName>
        <field>Level_2_Approval_Required__c</field>
        <literalValue>1</literalValue>
        <name>User Access Level 2 Approval</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>User_Access_Request_Granted</fullName>
        <field>User_Created__c</field>
        <literalValue>1</literalValue>
        <name>User Access Request Granted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>User_Access_Request_Level_2_Decision</fullName>
        <field>Level_2_Approver_Decision__c</field>
        <literalValue>Pending</literalValue>
        <name>User Access Request Level 2 Decision</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>User_Access_Request_Status</fullName>
        <description>This workflow updates the User Access Request Status field based on approval required</description>
        <field>Request_Status__c</field>
        <literalValue>Level 1 Approval Pending</literalValue>
        <name>User Access Request Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>User_Access_Request_Status_Approval_2</fullName>
        <field>Request_Status__c</field>
        <literalValue>Level 2 Approval Pending</literalValue>
        <name>User Access Request Status Approval 2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>User_Access_Request_Status_Provisioning</fullName>
        <description>Set Request Status to Provisioning in Progress so user is created</description>
        <field>Request_Status__c</field>
        <literalValue>Provisioning in Progress</literalValue>
        <name>User Access Request Status Provisioning</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>UAR Alert GSTS for Duplicate User</fullName>
        <actions>
            <name>User_Access_GSTS_Alert_Duplicate_User2</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User_Access_Requests__c.Request_Status__c</field>
            <operation>equals</operation>
            <value>Duplicate Request</value>
        </criteriaItems>
        <criteriaItems>
            <field>User_Access_Requests__c.GSTS_Comments__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>UAR Alert GSTS when Duplicate User</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>UAR Alert GSTS when Director Not Found</fullName>
        <actions>
            <name>User_Access_GSTS_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User_Access_Requests__c.Director_Name__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>User_Access_Requests__c.Recipient_Title__c</field>
            <operation>notContain</operation>
            <value>DIRECTOR</value>
        </criteriaItems>
        <criteriaItems>
            <field>User_Access_Requests__c.Recipient_Title__c</field>
            <operation>notContain</operation>
            <value>VP</value>
        </criteriaItems>
        <description>UAR Alert GSTS when Director Not Found</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>User Access Granted Email notificaiton</fullName>
        <actions>
            <name>SFDC_User_Access_Granted_Email_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User_Access_Requests__c.Request_Status__c</field>
            <operation>equals</operation>
            <value>Access Granted</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>User Access Level 2 Approval</fullName>
        <actions>
            <name>User_Access_Level_2_Approval</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User_Access_Requests__c.Access_Type__c</field>
            <operation>equals</operation>
            <value>Read/Write</value>
        </criteriaItems>
        <criteriaItems>
            <field>User_Access_Requests__c.Access_Level__c</field>
            <operation>equals</operation>
            <value>Worldwide</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>User Access Request Level 1 Approval pending</fullName>
        <actions>
            <name>User_Access_Level_1_Approval_Pending</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User_Access_Requests__c.Level_1_Approval_Required__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>User_Access_Requests__c.Level_1_Approver_Decision__c</field>
            <operation>notEqual</operation>
            <value>Approved</value>
        </criteriaItems>
        <description>Sets Level 1 Approval Decision to Pending when Level 1 Approval is Required</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>User Access Request Status Approval 1</fullName>
        <actions>
            <name>User_Access_Request_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User_Access_Requests__c.Level_1_Approval_Required__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>User_Access_Requests__c.Level_1_Approver_Decision__c</field>
            <operation>equals</operation>
            <value>Pending,N/A</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>User Access Request Status Approval 2</fullName>
        <actions>
            <name>User_Access_Request_Status_Approval_2</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User_Access_Requests__c.Level_2_Approval_Required__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>User_Access_Requests__c.Level_1_Approver_Decision__c</field>
            <operation>equals</operation>
            <value>Approved,N/A</value>
        </criteriaItems>
        <criteriaItems>
            <field>User_Access_Requests__c.Level_2_Approver_Decision__c</field>
            <operation>notEqual</operation>
            <value>Approved,Rejected</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>User Access Request Status Provisioning</fullName>
        <actions>
            <name>User_Access_Request_Status_Provisioning</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User_Access_Requests__c.Level_1_Approver_Decision__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <criteriaItems>
            <field>User_Access_Requests__c.Level_2_Approval_Required__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>User_Access_Requests__c.User_Created__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Set request status to Provisioning in Progress when user access should be provisioned.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>User Access Request from Director</fullName>
        <actions>
            <name>Request_Status_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR (2 AND 3 AND 4)</booleanFilter>
        <criteriaItems>
            <field>User_Access_Requests__c.Recipient_IsDirector__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>User_Access_Requests__c.Level_1_Approval_Required__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>User_Access_Requests__c.Level_2_Approval_Required__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>User_Access_Requests__c.Recipient_IsDirector__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
