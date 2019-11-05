<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>NGCC_Response_Detail_Customer_Response_i</fullName>
        <field>Customer_Response__c</field>
        <formula>Customer_Response_Detail__c</formula>
        <name>NGCC Response Detail Customer Response</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NGCC_Response_Detail_Date_Time</fullName>
        <field>Response_Detail_Date_Time__c</field>
        <formula>NOW()</formula>
        <name>NGCC Response Detail Date/Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NGCC_Response_Detail_Source_Event_Number</fullName>
        <field>Source_Event_Number__c</field>
        <formula>Response_Id__r.Source_Event_Number__c</formula>
        <name>NGCC Response Detail Source Event Number</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>NGCC Response Detail Customer Response if Null</fullName>
        <actions>
            <name>NGCC_Response_Detail_Customer_Response_i</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CC_Response_Detail__c.Customer_Response_Detail__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>CC_Response_Detail__c.Customer_Response__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>NGCC Response Detail Source Event Number</fullName>
        <actions>
            <name>NGCC_Response_Detail_Date_Time</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>NGCC_Response_Detail_Source_Event_Number</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CC_Response_Detail__c.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>CC_Response_Detail__c.Source_Event_Number__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
