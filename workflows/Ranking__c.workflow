<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Unique_Ranking_Attribute</fullName>
        <field>Unique_Attribute_Ranking__c</field>
        <formula>Text(Theatre__c) &amp; TEXT(Attribute_Name__c) &amp; TEXT(Attribute_Value__c)</formula>
        <name>Unique Ranking Attribute</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Unique_Ranking_Values</fullName>
        <actions>
            <name>Unique_Ranking_Attribute</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>text(Attribute_Name__c) != null</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
