<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Emailer_Set_Category_Type_for_Event</fullName>
        <description>Sets Category Type to Emailer Function, if the subject starts with Email Messenger</description>
        <field>Category_Type__c</field>
        <literalValue>Emailer Function</literalValue>
        <name>Emailer Set Category Type for Event</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Emailer Set Category Type for Event</fullName>
        <actions>
            <name>Emailer_Set_Category_Type_for_Event</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Event.Category_Type__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Event.Subject</field>
            <operation>startsWith</operation>
            <value>Email Messenger</value>
        </criteriaItems>
        <description>Sets Category Type to Emailer Function, if the subject starts with Email Messenger</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
