<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Direct_Super_Group_Record_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Direct_Super_Group</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Direct Super Group Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Overlay_Super_Group_Record_Type</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Overlay_Super_Group</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Overlay Super Group Record Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Update Direct Super Group Record Type</fullName>
        <actions>
            <name>Update_Direct_Super_Group_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Super_Group__c.Type__c</field>
            <operation>equals</operation>
            <value>Direct</value>
        </criteriaItems>
        <description>Updates Record Type to 'Direct Super Group', whenever Super Group record is created with Sales Credit Type Value as 'Direct'</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update Overlay Super Group Record Type</fullName>
        <actions>
            <name>Update_Overlay_Super_Group_Record_Type</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Super_Group__c.Type__c</field>
            <operation>equals</operation>
            <value>Overlay</value>
        </criteriaItems>
        <description>Updates Record Type to 'Overlay Super Group', whenever Super Group record is created with Sales Credit Type Value as 'Overlay''</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
