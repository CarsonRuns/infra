<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Presenter_Update</fullName>
        <description>When the engagement is completed sent notification to Presenters to updated the request</description>
        <protected>false</protected>
        <recipients>
            <field>Salesforce_User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CEE_Email_Templates/CEE_Presenter_Follow_up_Email</template>
    </alerts>
    <alerts>
        <fullName>Shadow_Approval_Email_Alert</fullName>
        <description>Shadow Approval Email Alert</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <field>Shadow_Approver__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Presenter_User__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>sfdc-automated-email-donotreply@cisco.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>CEE_Email_Templates/Shadow_Requestor_Approval</template>
    </alerts>
    <alerts>
        <fullName>Shadow_Rejection_Email_Alert</fullName>
        <description>Shadow Rejection Email Alert</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderAddress>sfdc-automated-email-donotreply@cisco.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>CEE_Email_Templates/Shadow_Requestor_Rejection</template>
    </alerts>
    <alerts>
        <fullName>Shadow_Request_Submission_Alert</fullName>
        <description>Shadow Request Submission Alert</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderAddress>sfdc-automated-email-donotreply@cisco.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>CEE_Email_Templates/Shadow_Request_SUBMISSION</template>
    </alerts>
    <fieldUpdates>
        <fullName>Attendee_Reports_to_CIO</fullName>
        <description>Attendee Reports to CIO? As of 9/17/2015 CIO org = gdiazjr,jkern,manville,kcwu,lperry,vgopalra. Need to change workflow if the reporting changes.</description>
        <field>Attendee_Reports_to_CIO__c</field>
        <formula>"Yes"</formula>
        <name>Attendee Reports to CIO?</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Approval_Status</fullName>
        <field>Shadow_Approval_Status__c</field>
        <literalValue>Submitted to PM</literalValue>
        <name>Update Approval Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Approval_Status_Approved</fullName>
        <field>Shadow_Approval_Status__c</field>
        <literalValue>Approved</literalValue>
        <name>Update Approval Status Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Approval_Status_Rejected</fullName>
        <field>Shadow_Approval_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>Update Approval Status Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Shadow_Approver_Email</fullName>
        <description>store the approvers name in a field in CEE Attendee Object</description>
        <field>Shadow_Approver__c</field>
        <formula>$User.Email</formula>
        <name>Update Shadow Approver Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Submitted_Date</fullName>
        <field>Shadow_Submitted_Date__c</field>
        <formula>NOW()</formula>
        <name>Update Submitted Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Attendee Reports to CIO%3F</fullName>
        <actions>
            <name>Attendee_Reports_to_CIO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Attendee Reports to CIO? As of 9/17/2015 CIO org = gdiazjr,jkern,manville,kcwu,lperry,vgopalra. Need to change workflow if the reporting changes.</description>
        <formula>!(ISBLANK( Salesforce_User__c ))
&amp;&amp;
(
CONTAINS( Salesforce_User__r.Reporting_Up_Manager_Chain__c,'gdiazjr')
||
CONTAINS( Salesforce_User__r.Reporting_Up_Manager_Chain__c,'jkern')
||

CONTAINS( Salesforce_User__r.Reporting_Up_Manager_Chain__c,'manville')
||

CONTAINS( Salesforce_User__r.Reporting_Up_Manager_Chain__c,'kcwu')
||

CONTAINS( Salesforce_User__r.Reporting_Up_Manager_Chain__c,'lperry')
||

CONTAINS( Salesforce_User__r.Reporting_Up_Manager_Chain__c,'vgopalra')
)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
