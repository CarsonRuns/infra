<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Send_Daily_Digest</fullName>
        <description>Send Daily Digest</description>
        <protected>false</protected>
        <recipients>
            <field>Receipient__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>sfdc-automated-email-donotreply@cisco.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Notification/Daily_Digest_Template</template>
    </alerts>
    <rules>
        <fullName>Daily Digest Notification</fullName>
        <actions>
            <name>Send_Daily_Digest</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>Email_Preference__c</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
