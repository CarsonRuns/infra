<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>SAC_Support_Request_Detail</fullName>
        <description>SAC Support Request Provider</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>sac-support@cisco.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Sales_Support_Request/SAC_Email_Support_Provider</template>
    </alerts>
    <alerts>
        <fullName>SAC_Support_Request_Provider_Application_Dependency_Mapping</fullName>
        <description>SAC Support Request Provider - Application Dependency Mapping</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>sac-support@cisco.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Sales_Support_Request/SAC_Email_Support_Provider</template>
    </alerts>
    <alerts>
        <fullName>SAC_Support_Request_Provider_Cloud</fullName>
        <description>SAC Support Request Provider - Cloud</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>sac-support@cisco.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Sales_Support_Request/SAC_Email_Support_Provider</template>
    </alerts>
    <alerts>
        <fullName>SAC_Support_Request_Provider_General_Migration</fullName>
        <description>SAC Support Request Provider - General Migration</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>sac-support@cisco.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Sales_Support_Request/SAC_Email_Support_Provider</template>
    </alerts>
    <alerts>
        <fullName>SAC_Support_Request_Provider_NetApp_FlexPod</fullName>
        <description>SAC Support Request Provider - NetApp FlexPod</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>sac-support@cisco.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Sales_Support_Request/SAC_Email_Support_Provider</template>
    </alerts>
    <fieldUpdates>
        <fullName>SAC_Update_SRD_Accept_Date</fullName>
        <field>Accepted_Date__c</field>
        <formula>NOW()</formula>
        <name>SAC_Update_SRD_Accept_Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SAC_Update_SRD_Status</fullName>
        <field>Status__c</field>
        <literalValue>In Process</literalValue>
        <name>SAC_Update_SRD_Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>SAC Email to Application Dependency Mapping Queue</fullName>
        <actions>
            <name>SAC_Support_Request_Provider_Application_Dependency_Mapping</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Used to send Email Notification to the Support Provider Queue Application Dependency Mapping</description>
        <formula>ISPICKVAL( Request_Type__c , 'UCS') &amp;&amp;
Support_Request_Type__c = 'Application Dependency Mapping'</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SAC Email to Cloud Queue</fullName>
        <actions>
            <name>SAC_Support_Request_Provider_Cloud</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Used to send email notification to the support provider queue Cloud</description>
        <formula>ISPICKVAL( Request_Type__c , 'UCS') &amp;&amp;
Support_Request_Type__c = 'Cloud'</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SAC Email to General Migration Queue</fullName>
        <actions>
            <name>SAC_Support_Request_Provider_General_Migration</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Used to send email notification to the support provider queue General Migration</description>
        <formula>ISPICKVAL( Request_Type__c , 'UCS') &amp;&amp;
Support_Request_Type__c = 'General Migration'</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SAC Email to Intel Meet Comp</fullName>
        <actions>
            <name>SAC_Support_Request_Detail</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Used to send email notification to the support provider queue Intel Meet Comp</description>
        <formula>ISPICKVAL( Request_Type__c , 'UCS') &amp;&amp;
Support_Request_Type__c = 'Intel Competitive Discounts (MEET-COMP)'</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SAC Email to Microsoft</fullName>
        <actions>
            <name>SAC_Support_Request_Detail</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Used to send email notification to the support provider queue Microsoft</description>
        <formula>ISPICKVAL( Request_Type__c , 'UCS') &amp;&amp;
Support_Request_Type__c = 'Microsoft'</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SAC Email to NetApp FlexPod Queue</fullName>
        <actions>
            <name>SAC_Support_Request_Provider_NetApp_FlexPod</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Used to send email notification to the support provider queue NetApp FlexPod</description>
        <formula>ISPICKVAL( Request_Type__c , 'UCS')&amp;&amp;
Support_Request_Type__c = 'NetApp FlexPod'</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SAC Email to Oracle</fullName>
        <actions>
            <name>SAC_Support_Request_Detail</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Used to send email notification to the support provider queue Oracle</description>
        <formula>ISPICKVAL( Request_Type__c , 'UCS')&amp;&amp;
Support_Request_Type__c = 'Oracle'</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SAC_Email to Application and Data Center Migration Queue</fullName>
        <actions>
            <name>SAC_Support_Request_Detail</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Used to send email notification to the support provider queue Application/Data Center Migration</description>
        <formula>AND(ISPICKVAL( Request_Type__c , "UCS"), (Support_Request_Type__c = "Application / Data Center Migration"),( $Organization.Id ='00DV0000008rndp' ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SAC_Email to Capacity Assurance Program Queue</fullName>
        <actions>
            <name>SAC_Support_Request_Detail</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Used to send email notification to the support provider queue Capacity and Assurance Program</description>
        <formula>AND(ISPICKVAL( Request_Type__c , "UCS"), (Support_Request_Type__c = "Capacity Assurance Program"),( $Organization.Id ='00DV0000008rndp' ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SAC_Email to Channels Support Queue</fullName>
        <actions>
            <name>SAC_Support_Request_Detail</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Used to send email notification to the support provider queue Channels Support</description>
        <formula>AND(ISPICKVAL( Request_Type__c , "UCS"), (Support_Request_Type__c = "Channels Support"),( $Organization.Id ='00DV0000008rndp' ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SAC_Email to Cisco Capital Queue</fullName>
        <actions>
            <name>SAC_Support_Request_Detail</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Used to send email notification to the support provider queue Cisco Capital</description>
        <formula>AND(ISPICKVAL( Request_Type__c , "UCS") ,(Support_Request_Type__c = "Cisco Capital"),( $Organization.Id ='00DV0000008rndp' ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SAC_Email to Demo Equipment Queue</fullName>
        <actions>
            <name>SAC_Support_Request_Detail</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Used to send email notification to the support provider queue Demo Equipment</description>
        <formula>AND(ISPICKVAL( Request_Type__c , "UCS"), (Support_Request_Type__c = "Demo Equipment"),( $Organization.Id ='00DV0000008rndp' ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SAC_Email to Other Queue</fullName>
        <actions>
            <name>SAC_Support_Request_Detail</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Used to send email notification to the support provider queue Other</description>
        <formula>AND(ISPICKVAL( Request_Type__c , "UCS") ,(Support_Request_Type__c = "Other"),( $Organization.Id ='00DV0000008rndp' ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SAC_Email to Product Information Queue</fullName>
        <actions>
            <name>SAC_Support_Request_Detail</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Used to send email notification to the support provider queue Product Information</description>
        <formula>AND(ISPICKVAL( Request_Type__c , "UCS"), (Support_Request_Type__c = "Product Information"),( $Organization.Id ='00DV0000008rndp' ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SAC_Email to RISC Server Replacement Queue</fullName>
        <actions>
            <name>SAC_Support_Request_Detail</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Used to send email notification to the support provider queue RISC Server Replacement</description>
        <formula>AND(ISPICKVAL( Request_Type__c , "UCS") ,(Support_Request_Type__c = "RISC Server Replacement"),( $Organization.Id ='00DV0000008rndp' ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SAC_Email to SAP</fullName>
        <actions>
            <name>SAC_Support_Request_Detail</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Used to send email notification to the support provider queue SAP</description>
        <formula>AND(ISPICKVAL( Request_Type__c , "UCS"), OR(( Support_Request_Type__c = 'SAP'),( Support_Request_Type__c = 'SAP HANA')), ( $Organization.Id = '00DV0000008rndp'))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SAC_Email to Services %28CA AS%29 Queue</fullName>
        <actions>
            <name>SAC_Support_Request_Detail</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Used to send email notification to the support provider queue Services (CA AS)</description>
        <formula>AND(ISPICKVAL( Request_Type__c , "UCS"), (Support_Request_Type__c = "Services (CA AS)"),( $Organization.Id ='00DV0000008rndp' ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SAC_Email to Services %28CA RMS%29 Queue</fullName>
        <actions>
            <name>SAC_Support_Request_Detail</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Used to send email notification to the support provider queue Services (CA RMS)</description>
        <formula>AND(ISPICKVAL( Request_Type__c , "UCS") ,(Support_Request_Type__c = "Services (CA RMS)"),( $Organization.Id ='00DV0000008rndp' ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SAC_Email to Services %28CA TS%29 Queue</fullName>
        <actions>
            <name>SAC_Support_Request_Detail</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Used to send email notification to the support provider queue Services (CA TS)</description>
        <formula>AND(ISPICKVAL( Request_Type__c , "UCS") ,(Support_Request_Type__c = "Services (CA TS)"),( $Organization.Id ='00DV0000008rndp' ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SAC_Email to Try and Buy Program Queue</fullName>
        <actions>
            <name>SAC_Support_Request_Detail</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Used to send email notification to the support provider queue Try and Buy Program</description>
        <formula>AND(ISPICKVAL( Request_Type__c , "UCS") ,(Support_Request_Type__c = "Try and Buy Program"),( $Organization.Id ='00DV0000008rndp' ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SAC_Email to UCS Competetive %28non-HP%29 Queue</fullName>
        <actions>
            <name>SAC_Support_Request_Detail</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Used to send email notification to the support provider queue UCS Competetive (non-HP)</description>
        <formula>AND(ISPICKVAL( Request_Type__c , "UCS") ,(Support_Request_Type__c = "UCS Competitive (non-HP)"),( $Organization.Id ='00DV0000008rndp' ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SAC_Email to UCS Ecosystem Partners Queue</fullName>
        <actions>
            <name>SAC_Support_Request_Detail</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Used to send email notification to the support provider queue Ecosystem Partners for UCS request type</description>
        <formula>AND( (Support_Request_Type__c = "Ecosystem Partners"),  ISPICKVAL(Request_Type__c, "UCS") ,( $Organization.Id ='00DV0000008rndp' ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SAC_Email to UCS HP Competitive War Room Queue</fullName>
        <actions>
            <name>SAC_Support_Request_Detail</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Used to send email notification to the support provider queue UCS HP Competitive War Room</description>
        <formula>AND(ISPICKVAL( Request_Type__c , "UCS"), (Support_Request_Type__c = "UCS HP Competitive War Room"),( $Organization.Id ='00DV0000008rndp' ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SAC_Update_SRD_Accept_Date</fullName>
        <actions>
            <name>SAC_Update_SRD_Accept_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update Sales Support Request Details Accept Date</description>
        <formula>! ISNEW() &amp;&amp; ISCHANGED( OwnerId)  &amp;&amp;  ISNULL( Accepted_Date__c ) &amp;&amp; ISCHANGED(  Status__c) &amp;&amp; ( $Organization.Id ='00DV0000008rndp')</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SAC_Update_SRD_Accept_Date_Status</fullName>
        <actions>
            <name>SAC_Update_SRD_Accept_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SAC_Update_SRD_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update Sales Support Request Details Accept Date &amp; Status</description>
        <formula>! ISNEW()  &amp;&amp; ISCHANGED( OwnerId)   &amp;&amp;  ISNULL( Accepted_Date__c )  &amp;&amp; NOT( (ISCHANGED(  Status__c))) &amp;&amp; ( $Organization.Id ='00DV0000008rndp')</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
