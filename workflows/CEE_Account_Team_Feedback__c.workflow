<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Update_Record_Type_Id_for_FSAT_CPOC</fullName>
        <description>update record type id for FSAT CPOC Records</description>
        <field>RecordTypeId</field>
        <lookupValue>CPOC_CEE_Accounts_Team_Feedback</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Record Type Id for FSAT CPOC</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Record_Type_Id_for_FSAT_CXC</fullName>
        <description>This will update the record type for FSAT feedback</description>
        <field>RecordTypeId</field>
        <lookupValue>CXC_CEE_Account_Team_Feedback</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Update Record Type Id for FSAT CXC</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>FSAT_CPOC_Update_Recordtype_Account Team Feedback</fullName>
        <actions>
            <name>Update_Record_Type_Id_for_FSAT_CPOC</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CEE_Account_Team_Feedback__c.FSAT_Survey_Project_Type__c</field>
            <operation>equals</operation>
            <value>CPOC</value>
        </criteriaItems>
        <description>This will update the record type id for FSAT CPOC Feedback records</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>FSAT_CXC_Update_Recordtype_Account Team Feedback</fullName>
        <actions>
            <name>Update_Record_Type_Id_for_FSAT_CXC</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CEE_Account_Team_Feedback__c.FSAT_Survey_Project_Type__c</field>
            <operation>equals</operation>
            <value>OBX</value>
        </criteriaItems>
        <description>This will update the record type for FSAT feedback object</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
