<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Opportunity_Owner_get_notification_when_SE_Assigned_themselves</fullName>
        <description>Opportunity Owner get notification when SE Assigned themselves</description>
        <protected>false</protected>
        <recipients>
            <field>Requester_Email_ID__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>RAE/SEAssignmentNotificationtoOpportunityOwner</template>
    </alerts>
    <alerts>
        <fullName>Send_an_email_for_request_of_Resource</fullName>
        <description>Send an email for request of Resource</description>
        <protected>false</protected>
        <recipients>
            <field>SEM_Email_ID__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Resource_Name__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>RAE/Request_Assignment_Name_Requested</template>
    </alerts>
    <fieldUpdates>
        <fullName>Activating_assignment_status</fullName>
        <description>Sets the Assignment status to active</description>
        <field>Assignment_Status__c</field>
        <literalValue>Active</literalValue>
        <name>Activating assignment status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RAE_Requestor_EmailID_Update</fullName>
        <field>Requester_Email_ID__c</field>
        <formula>CreatedBy.Email</formula>
        <name>RAE Requestor EmailID Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SE_Reset_SLA_Expired_Flag</fullName>
        <field>SLA_Expired__c</field>
        <literalValue>0</literalValue>
        <name>SE Reset SLA Expired Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_SLA_Expired_2</fullName>
        <description>Updates SLA_Expired__c = true when rule criteria is met</description>
        <field>SLA_Expired__c</field>
        <literalValue>1</literalValue>
        <name>Update_SLA_Expired_2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Assignment Status Activation</fullName>
        <actions>
            <name>Opportunity_Owner_get_notification_when_SE_Assigned_themselves</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Activating_assignment_status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow rule sets the assignment status as active once the resource status changes from requested to assigned.</description>
        <formula>(
    ISPICKVAL(Resource_Status__c, "Assigned") || 
    ISPICKVAL(Resource_Status__c, "Direct Assignment")
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>RAE_Requestor_EmailID_Update</fullName>
        <actions>
            <name>RAE_Requestor_EmailID_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Resource_Request_Assignment__c.CreatedById</field>
            <operation>notEqual</operation>
            <value>PDR Collab</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>SE Reset SLA Expired Flag</fullName>
        <actions>
            <name>SE_Reset_SLA_Expired_Flag</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(
NOT( ISNEW()),
OR(
ISCHANGED( Resource_Name__c),
ISCHANGED( Team_Name__c ),
ISCHANGED( Specialization__c )
),
ISPICKVAL(Resource_Status__c, "Requested")


)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SE_SLA_Rule</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Resource_Request_Assignment__c.SLA_Expired__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Resource_Request_Assignment__c.Resource_Status__c</field>
            <operation>equals</operation>
            <value>Requested</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.Username</field>
            <operation>notEqual</operation>
            <value>praschan@cisco.com</value>
        </criteriaItems>
        <description>Workflow Rule to be triggered if SLA meets</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Send_an_email_for_request_of_Resource</name>
                <type>Alert</type>
            </actions>
            <actions>
                <name>Update_SLA_Expired_2</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Resource_Request_Assignment__c.SLA_Start_Date__c</offsetFromField>
            <timeLength>48</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
</Workflow>
