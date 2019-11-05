<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_Alert_for_Deal_ID</fullName>
        <ccEmails>praschan@cisco.com</ccEmails>
        <description>Email Alert for Deal ID</description>
        <protected>false</protected>
        <recipients>
            <recipient>sales-dealid-stack-alert@cisco.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>sfdc-automated-email-donotreply@cisco.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Deal_ID_Email_Template/Deal_ID_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Oppty_Workspace_Batch_Exception</fullName>
        <ccEmails>sfdc-integration-apex-exceptions@external.cisco.com</ccEmails>
        <description>Oppty Workspace Batch Exception</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>P360_Email_Templates/Oppty_Workspace_Sharing_Exception_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>P360_User_Onboarding_Exception_Notification</fullName>
        <description>P360 User Onboarding Exception Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>sfdc_apex_user@cisco.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>donotreply-sfdc@cisco.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>P360_Email_Templates/P360_User_Onboarding_Exception_Notification</template>
    </alerts>
    <rules>
        <fullName>Deal ID Email</fullName>
        <actions>
            <name>Email_Alert_for_Deal_ID</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2 OR 3</booleanFilter>
        <criteriaItems>
            <field>Tx_Log__c.Name</field>
            <operation>contains</operation>
            <value>Deal ID Percent Threshold</value>
        </criteriaItems>
        <criteriaItems>
            <field>Tx_Log__c.Name</field>
            <operation>contains</operation>
            <value>Denominator Zero</value>
        </criteriaItems>
        <criteriaItems>
            <field>Tx_Log__c.Name</field>
            <operation>contains</operation>
            <value>Deal ID out of bounds</value>
        </criteriaItems>
        <description>This rule will set off email notifications for both Deal Id Thresholds and Math Exception Errors</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>P360 User Onboarding Exception Notification</fullName>
        <actions>
            <name>P360_User_Onboarding_Exception_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Tx_Log__c.exception__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Tx_Log__c.type__c</field>
            <operation>equals</operation>
            <value>P360_Contact_Job,P360_Account_Job</value>
        </criteriaItems>
        <description>This is used to send email notification when any exception occurred in P360 User Onboarding Jobs.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>zzOppty Workspace Batch Job</fullName>
        <actions>
            <name>Oppty_Workspace_Batch_Exception</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Tx_Log__c.originated__c</field>
            <operation>equals</operation>
            <value>Oppty_OpptyWorkspace_BatchUpdate</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
