<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>BLP_LPLBC_STATUS</fullName>
        <description>BLP_LPLBC_STATUS</description>
        <protected>false</protected>
        <recipients>
            <field>PLP_Email_Alias__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>donotreply-ciscosales@cisco.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>PEPE_Email_Template_Notifications/PEPE_Email_Notification_to_LPs_when_status_is_Learning_Partner_being_contacted</template>
    </alerts>
    <alerts>
        <fullName>PEPE_Email_Notification_to_LP_when_Quote_Rejected</fullName>
        <description>PEPE: Email Notification to LP when Quote Rejected</description>
        <protected>false</protected>
        <recipients>
            <field>PLP_Email_Alias__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PEPE_Email_Template_Notifications/PEPE_Email_Notification_to_LPs_when_status_Quote_Rejected</template>
    </alerts>
    <alerts>
        <fullName>PEPE_Email_Notification_to_LPs_when_status_changed_at_any_instance</fullName>
        <description>PEPE: Email Notification to LPs when status changed at any instance</description>
        <protected>false</protected>
        <recipients>
            <field>PLP_Email_Alias__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>donotreply-ciscosales@cisco.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>PEPE_Email_Template_Notifications/PEPE_Email_Notification_to_LPs_when_status_changes</template>
    </alerts>
    <rules>
        <fullName>PEPE%3A BLP_LPBC_SEND_EMAIL</fullName>
        <actions>
            <name>BLP_LPLBC_STATUS</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>PEPE_Learning_Partner__c.Status__c</field>
            <operation>equals</operation>
            <value>LP being contacted</value>
        </criteriaItems>
        <description>Send email to BLP when LP records are created.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>PEPE%3A Email Notification to LPs when LP Status changes</fullName>
        <actions>
            <name>PEPE_Email_Notification_to_LPs_when_status_changed_at_any_instance</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Sends Email Notification to LPs when LP status is changed other than 'Confirmed by LP' and 'Quote Rejected'</description>
        <formula>AND( ISCHANGED( Status__c ),   NOT(ISPICKVAL(Status__c, 'Confirmed by LP')|| ISPICKVAL(Status__c, 'Quote Rejected')),   TEXT(Training_Request_Id__r.Geography__c) = 'EMEAR')</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PEPE%3A Email Notification to LPs when LP Status is Quote Rejected</fullName>
        <actions>
            <name>PEPE_Email_Notification_to_LP_when_Quote_Rejected</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Sends Email Notification to LPs when LP status is Quote Rejected</description>
        <formula>AND( ISCHANGED( Status__c ), ISPICKVAL(Status__c, 'Quote Rejected'),   TEXT(Training_Request_Id__r.Geography__c) = 'EMEAR')</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
