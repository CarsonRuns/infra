<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>PEPE_Prefix_to_Event_Day_Name</fullName>
        <description>This field update adds a prefix to the event day name</description>
        <field>Name</field>
        <formula>Training_Event__r.Name  + " - " + Name</formula>
        <name>PEPE: Prefix to Event Day Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PEPE_Update_Training_Event_Id</fullName>
        <description>This field gets updated with the main event value</description>
        <field>Training_Event_Id__c</field>
        <formula>Training_Event__r.Name</formula>
        <name>PEPE: Update Training Event Id</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>PEPE%3A External TE Id update on the event day to be searchable</fullName>
        <actions>
            <name>PEPE_Update_Training_Event_Id</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>PEPE_Event_Day__c.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>This will add training event name prefix to event day</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
