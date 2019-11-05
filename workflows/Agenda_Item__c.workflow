<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>CEE_Agenda_Item_Account_Population</fullName>
        <field>Account_Name__c</field>
        <formula>Customer_Engagements_Events__r.Primary_Account__r.Name</formula>
        <name>CEE Agenda Item Account Population</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CEE_Agenda_Item_Briefing_Status_Pop</fullName>
        <field>Briefing_Status__c</field>
        <formula>TEXT(Customer_Engagements_Events__r.Request_Status__c)</formula>
        <name>CEE Agenda Item Briefing Status Pop</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CEE_Agenda_Item_Briefing_Type_Population</fullName>
        <field>Briefing_Type__c</field>
        <formula>TEXT(Customer_Engagements_Events__r.Event_Type__c)</formula>
        <name>CEE Agenda Item Briefing Type Population</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CEE_Agenda_Item_Topic_Name_Populate</fullName>
        <field>Topic_Name__c</field>
        <formula>Topic__r.Name</formula>
        <name>CEE Agenda Item Topic Name Populate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>CEE Agenda Item Briefing Population</fullName>
        <actions>
            <name>CEE_Agenda_Item_Account_Population</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CEE_Agenda_Item_Briefing_Status_Pop</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CEE_Agenda_Item_Briefing_Type_Population</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CEE_Agenda_Item_Topic_Name_Populate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>True</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
