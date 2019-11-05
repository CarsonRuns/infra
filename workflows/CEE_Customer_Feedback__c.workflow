<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_record_type_id</fullName>
        <description>This will update the record type for feedback</description>
        <field>RecordTypeId</field>
        <lookupValue>OBX_Customer_Feedback</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update record type id</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_record_type_id_for_CPOC</fullName>
        <description>update record type id for CPOC Reords</description>
        <field>RecordTypeId</field>
        <lookupValue>CPOC_Customer_Feedback</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update record type id for CPOC</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>CEE_OBX_Update_recordtype_CustomerFeedback</fullName>
        <actions>
            <name>Update_record_type_id</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CEE_Customer_Feedback__c.Survey_Project_Type__c</field>
            <operation>equals</operation>
            <value>OBX</value>
        </criteriaItems>
        <description>This will update the record type for feedback object</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>CPOC_Update_recordtype_CustomerFeedback</fullName>
        <actions>
            <name>Update_record_type_id_for_CPOC</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CEE_Customer_Feedback__c.Survey_Project_Type__c</field>
            <operation>equals</operation>
            <value>CPOC</value>
        </criteriaItems>
        <description>This will update the record type id for CPOC Feedback records</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
