<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>SAC_Support_Requester_APJC</fullName>
        <ccEmails>sfdc_sac_apjc@cisco.com</ccEmails>
        <description>SAC Support Requester APJC</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>sac-support@cisco.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Sales_Support_Request/SAC_Email_To_Requester</template>
    </alerts>
    <alerts>
        <fullName>SAC_Support_Requester_Americas</fullName>
        <ccEmails>sfdc_sac_americas@cisco.com</ccEmails>
        <description>SAC Support Requester Americas</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>sac-support@cisco.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Sales_Support_Request/SAC_Email_To_Requester</template>
    </alerts>
    <alerts>
        <fullName>SAC_Support_Requester_EMEAR</fullName>
        <ccEmails>sfdc_sac_emear@cisco.com</ccEmails>
        <description>SAC Support Requester EMEAR</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>sac-support@cisco.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Sales_Support_Request/SAC_Email_To_Requester</template>
    </alerts>
    <alerts>
        <fullName>SAC_TV_Support_Request_Provider</fullName>
        <ccEmails>sactv-support@cisco.com</ccEmails>
        <description>SAC TV Support Request Provider</description>
        <protected>false</protected>
        <senderAddress>sactv-support@cisco.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Sales_Support_Request/SAC_Email_Support_Provider_SACTV_SACWebEx_HTML</template>
    </alerts>
    <alerts>
        <fullName>SAC_WebEx_Support_Request_Provider</fullName>
        <ccEmails>sac-webex@cisco.com</ccEmails>
        <description>SAC WebEx Support Request Provider</description>
        <protected>false</protected>
        <senderAddress>sac-webex@cisco.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Sales_Support_Request/SAC_Email_Support_Provider_SACTV_SACWebEx_HTML</template>
    </alerts>
    <rules>
        <fullName>SAC Requester Email Notification_APJC</fullName>
        <actions>
            <name>SAC_Support_Requester_APJC</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>SAC Requester Email Notification for APJC</description>
        <formula>NOT( ISBLANK(Support_Request_Type__c)) &amp;&amp; 
CONTAINS(Theater__c, 'APJC') &amp;&amp; 
LEN(Services_Recently_Selected__c )&gt;0</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SAC Requester Email Notification_Americas</fullName>
        <actions>
            <name>SAC_Support_Requester_Americas</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>SAC Requester Email Notification for Americas</description>
        <formula>NOT( ISBLANK(Support_Request_Type__c)) &amp;&amp;
CONTAINS(Theater__c, 'Americas')  &amp;&amp;
LEN(Services_Recently_Selected__c )&gt;0</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SAC Requester Email Notification_EMEAR</fullName>
        <actions>
            <name>SAC_Support_Requester_EMEAR</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>SAC Requester Email Notification for EMEAR</description>
        <formula>NOT( ISBLANK(Support_Request_Type__c)) &amp;&amp;
CONTAINS(Theater__c, 'EMEAR')  &amp;&amp;
LEN(Services_Recently_Selected__c )&gt;0</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SAC_Email to SAC TV Support Team</fullName>
        <actions>
            <name>SAC_TV_Support_Request_Provider</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Email alert to SAC TV Support Team containing all services selected by requestor.</description>
        <formula>AND( ISPICKVAL(Request_Type__c, "SAC TV") ,NOT(ISNULL(Support_Request_Type__c )),(LEN(Services_Recently_Selected__c )&gt;0), ($Organization.Id = '00DV0000008rndp'))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SAC_Email to SAC WebEx Support Team</fullName>
        <actions>
            <name>SAC_WebEx_Support_Request_Provider</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Email alert to SAC WebEx Support Team containing all services selected by requestor.</description>
        <formula>AND( ISPICKVAL(Request_Type__c, "SAC WebEx") ,NOT(ISBLANK(Support_Request_Type__c )),(LEN(Services_Recently_Selected__c )&gt;0))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
