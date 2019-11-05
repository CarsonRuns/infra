<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Attendee_Status_to_Attended</fullName>
        <field>Attendee_Status__c</field>
        <literalValue>Attended Meeting</literalValue>
        <name>Attendee Status to Attended</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Attendee_Status_to_Not_Attended</fullName>
        <field>Attendee_Status__c</field>
        <literalValue>Didnt Attend Meeting</literalValue>
        <name>Attendee Status to Not Attended</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Attendee_Status_to_Not_Confirmed</fullName>
        <field>Attendee_Status__c</field>
        <literalValue>Not Confirmed</literalValue>
        <name>Attendee Status to Not Confirmed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>Meeting Attended From Reconciliation</fullName>
        <actions>
            <name>Attendee_Status_to_Attended</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CEE_Jiffle_Attendee__c.Meeting_Attended__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Meeting Not Attended From Reconciliation</fullName>
        <actions>
            <name>Attendee_Status_to_Not_Attended</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CEE_Jiffle_Attendee__c.Meeting_Attended__c</field>
            <operation>equals</operation>
            <value>No</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Meeting Not Confirmed From Reconciliation</fullName>
        <actions>
            <name>Attendee_Status_to_Not_Confirmed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CEE_Jiffle_Attendee__c.Meeting_Attended__c</field>
            <operation>equals</operation>
            <value>Dont Know</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
