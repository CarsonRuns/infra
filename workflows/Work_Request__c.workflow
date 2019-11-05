<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>RTB_Assigned_Email_Alert</fullName>
        <ccEmails>crm-rtb-cr-mailer@cisco.com</ccEmails>
        <ccEmails>lescobed@cisco.com</ccEmails>
        <description>RTB Assigned Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>Requester_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Work_Request/Work_Request_RTB_Assigned_Notification</template>
    </alerts>
    <alerts>
        <fullName>Work_Request_Email_Notification</fullName>
        <ccEmails>gbocrm_pmo@cisco.com;sfdc-platform-services@cisco.com</ccEmails>
        <description>Work Request Email Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Additional_Stakeholder1_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Additional_Stakeholder2_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Additional_Stakeholder3_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Requester_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>donotreply-sfdc@cisco.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Work_Request/Work_Request_Notification</template>
    </alerts>
    <alerts>
        <fullName>Work_Request_Prioritized_Notification</fullName>
        <ccEmails>gbocrm_pmo@cisco.com</ccEmails>
        <description>Work Request Prioritized Notification</description>
        <protected>false</protected>
        <recipients>
            <field>Additional_Stakeholder1_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Additional_Stakeholder2_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Additional_Stakeholder3_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Requester_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>donotreply-sfdc@cisco.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Work_Request/Work_Request_Status_Prioritized</template>
    </alerts>
    <alerts>
        <fullName>Work_Request_Submission</fullName>
        <ccEmails>gbocrm_pmo@cisco.com</ccEmails>
        <description>Work Request Submission</description>
        <protected>false</protected>
        <recipients>
            <field>Additional_Stakeholder1_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Additional_Stakeholder2_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Additional_Stakeholder3_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Requester_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>donotreply-sfdc@cisco.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Work_Request/Work_Request_Submitted</template>
    </alerts>
    <alerts>
        <fullName>xRM_Assigned_Email_Alert</fullName>
        <ccEmails>xrm-new-project-request@cisco.com</ccEmails>
        <description>xRM Assigned Email Alert</description>
        <protected>false</protected>
        <recipients>
            <field>Requester_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <recipient>lescobed@cisco.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Work_Request/Work_Request_xRM_Assigned_Notification</template>
    </alerts>
    <fieldUpdates>
        <fullName>Work_Request_Status_Comments_History</fullName>
        <description>Copies Work Request Comments</description>
        <field>Work_Request_Status_Comments_History__c</field>
        <formula>Work_Request_Status_Comments__c</formula>
        <name>Work Request Status Comments History</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Work_Request_Status_History</fullName>
        <description>Copy of Work Request Status</description>
        <field>Work_Request_Status_History__c</field>
        <formula>Work_Request_Status__c</formula>
        <name>Work Request Status History</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Work Request Created</fullName>
        <actions>
            <name>Work_Request_Submission</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Work_Request__c.Work_Request_Status__c</field>
            <operation>equals</operation>
            <value>Created</value>
        </criteriaItems>
        <description>new Work Request created notification</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Work Request Notification</fullName>
        <actions>
            <name>Work_Request_Email_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Email to requester for certain work request statuses</description>
        <formula>(
ISPICKVAL(Work_Request_Status_PMO__c, 'Submitted for Monthly Review' ) ||
ISPICKVAL(Work_Request_Status_PMO__c, 'Delivered' ) ||
ISPICKVAL(Work_Request_Status_PMO__c, 'On Hold by Requester' ) ||
ISPICKVAL(Work_Request_Status_PMO__c, 'Archived' ) ||
ISPICKVAL(Work_Request_Status_PMO__c, 'Rejected-By Business Capabilities' ) ||
ISPICKVAL(Work_Request_Status_PMO__c, 'Cancelled By Requester' ) ||
ISPICKVAL(Work_Request_Status_PMO__c, 'Transferred to another team' ) ||
ISPICKVAL(Work_Request_Status_PMO__c, 'Rejected-No Global Consensus' ) ||
ISPICKVAL(Work_Request_Status_PMO__c, 'Merged with another Request' ) ||
ISPICKVAL(Work_Request_Status_PMO__c, 'Transferred to XRM-Active-Idea' ) ||
ISPICKVAL(Work_Request_Status_PMO__c, 'Transferred to XRM-Active-Architecture Evaluation &amp; Portfolio Planning' ) ||
ISPICKVAL(Work_Request_Status_PMO__c, 'Transferred to XRM-Active-Release Planning' ) ||
ISPICKVAL(Work_Request_Status_PMO__c, 'Transferred to XRM-Active-Analysis' ) ||
ISPICKVAL(Work_Request_Status_PMO__c, 'Transferred to XRM-Active-Delivery &amp; Implementation' ) ||
ISPICKVAL(Work_Request_Status_PMO__c, 'Transferred to XRM-Active-Value Capture' ) ||
ISPICKVAL(Work_Request_Status_PMO__c, 'Transferred to XRM-Completed' ) ||
ISPICKVAL(Work_Request_Status_PMO__c, 'Transferred to XRM-Merged' ) ||
ISPICKVAL(Work_Request_Status_PMO__c, 'Transferred to XRM-Paused' ) ||
ISPICKVAL(Work_Request_Status_PMO__c, 'Transferred to XRM-Removed' )
) &amp;&amp;
ISCHANGED(Work_Request_Status_PMO__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Work Request RTB Assigned Notification</fullName>
        <actions>
            <name>RTB_Assigned_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Work Request RTB Assigned Notification</description>
        <formula>TEXT(Work_Request_Status_PMO__c)='RTB-Assigned'</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Work Request Status Comments History</fullName>
        <actions>
            <name>Work_Request_Status_Comments_History</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Copies Work Request Status Comments History</description>
        <formula>Work_Request_Status_Comments_PMO__c&lt;&gt;  Work_Request_Status_Comments_History__c</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Work Request Status History</fullName>
        <actions>
            <name>Work_Request_Status_History</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Copies Work Request Status</description>
        <formula>Work_Request_Status__c &lt;&gt;  Work_Request_Status_History__c</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Work Request Status Prioritized Notification</fullName>
        <actions>
            <name>Work_Request_Prioritized_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Email to requester when work request status is changed to Prioritized-Currently in Development</description>
        <formula>ISPICKVAL(Work_Request_Status_PMO__c, 'Prioritized-Delivery Scheduled' )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Work Request xRM Assigned Notification</fullName>
        <actions>
            <name>xRM_Assigned_Email_Alert</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Work Request xRM Assigned Notification</description>
        <formula>TEXT(Work_Request_Status_PMO__c)='Transferred to XRM-Active'</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
