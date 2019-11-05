<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>P360_Lead_Creation_By_Partner_Notification_To_TxM_TBM</fullName>
        <description>P360 Lead Creation By Partner - Notification To TxM/TBM</description>
        <protected>false</protected>
        <recipients>
            <field>Recipient__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>donotreply-sfdc@cisco.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>P360_Email_Templates/P360_Lead_By_Partner_Notification</template>
    </alerts>
    <alerts>
        <fullName>P360_TP_Creation_By_Partner_Notification_To_TxM_TBM</fullName>
        <description>P360 TP Creation By Partner - Notification To TxM/TBM</description>
        <protected>false</protected>
        <recipients>
            <field>Recipient__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>donotreply-sfdc@cisco.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>P360_Email_Templates/P360_TP_Creation_By_Partner_Notification</template>
    </alerts>
    <fieldUpdates>
        <fullName>Status_Email_Sent</fullName>
        <field>Status__c</field>
        <literalValue>Email Sent</literalValue>
        <name>Status_Email Sent</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>P360 Lead Creation By Partner - Notification To TxM%2FTBM</fullName>
        <actions>
            <name>P360_Lead_Creation_By_Partner_Notification_To_TxM_TBM</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Status_Email_Sent</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>P360_Mail_Queue__c.Notification_Type__c</field>
            <operation>equals</operation>
            <value>New Partner Generated Lead</value>
        </criteriaItems>
        <criteriaItems>
            <field>P360_Mail_Queue__c.Email_Notification__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>P360 TP Creation By Partner - Notification To TxM%2FTBM</fullName>
        <actions>
            <name>P360_TP_Creation_By_Partner_Notification_To_TxM_TBM</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Status_Email_Sent</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>P360_Mail_Queue__c.Notification_Type__c</field>
            <operation>equals</operation>
            <value>New Partner Generated Target Prospect</value>
        </criteriaItems>
        <criteriaItems>
            <field>P360_Mail_Queue__c.Email_Notification__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
