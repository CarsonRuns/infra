<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_Notification_for_the_AM_Partner</fullName>
        <description>Email Notification for Lead Admin Alias</description>
        <protected>false</protected>
        <recipients>
            <field>AM_Email_Id__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Lead_Admin_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Partner_Contact_Email_Id__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>donotreply-dgcontactcenter@cisco.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>NGCC_Marketing_Contact_Center_Repository/NGCC_EmailTemplateForAM_Partner</template>
    </alerts>
    <fieldUpdates>
        <fullName>Update_Key_Code</fullName>
        <field>Key_Code__c</field>
        <formula>Lead__r.ProgramEvent__c</formula>
        <name>Update Key Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>NGCC Key Code Update</fullName>
        <actions>
            <name>Update_Key_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Will update key code with Lead Program Event Code</description>
        <formula>OR( Lead__r.ProgramEvent__c  &lt;&gt; null, Lead__r.ProgramEvent__c  &lt;&gt; '')</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
