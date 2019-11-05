<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>CEE_Agenda_Room_Account_Population</fullName>
        <field>Account_Name__c</field>
        <formula>Customer_Engagements_Events__r.Primary_Account__r.Name</formula>
        <name>CEE Agenda Room Account Population</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CEE_Agenda_Room_Briefing_Status_Populate</fullName>
        <field>Briefing_Status__c</field>
        <formula>TEXT(Customer_Engagements_Events__r.Request_Status__c)</formula>
        <name>CEE Agenda Room Briefing Status Populate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CEE_Agenda_Room_Briefing_Type_Population</fullName>
        <field>Briefing_Type__c</field>
        <formula>TEXT(Customer_Engagements_Events__r.Event_Type__c)</formula>
        <name>CEE Agenda Room Briefing Type Population</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CEE_Agenda_Room_Name_Populate</fullName>
        <field>Room_Name__c</field>
        <formula>Room__r.Display_Name__c</formula>
        <name>CEE Agenda Room Name Populate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>CEE Agenda Room Populate Briefing</fullName>
        <actions>
            <name>CEE_Agenda_Room_Account_Population</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CEE_Agenda_Room_Briefing_Status_Populate</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CEE_Agenda_Room_Briefing_Type_Population</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CEE_Agenda_Room_Name_Populate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>True</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
