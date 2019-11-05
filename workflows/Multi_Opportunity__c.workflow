<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Deal_value</fullName>
        <field>Deal_Value_Summary_000s__c</field>
        <formula>Opportunity__r.Expected_Total_Value_000_s__c</formula>
        <name>Update Deal value</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Update Deal value</fullName>
        <actions>
            <name>Update_Deal_value</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Multi_Opportunity__c.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>This work flow rule will fire when user change opportunity in Multi opportunity junction object.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
