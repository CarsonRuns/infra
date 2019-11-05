<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Specialist_Email</fullName>
        <description>This workflow updates Technology Specialist Email field.</description>
        <field>technology_Specialist_Email__c</field>
        <formula>Technology_Specialist__r.Email</formula>
        <name>Specialist Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Add technology Specialist email</fullName>
        <actions>
            <name>Specialist_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Workspace_Technology__c.Technology_Specialist__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>It is used to update the email of technology specialist on the service one side.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
