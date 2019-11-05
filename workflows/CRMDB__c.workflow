<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Set_Financials_Total_value_to_0</fullName>
        <field>Annual_CMS_Contract_Value__c</field>
        <formula>0</formula>
        <name>Set Financials Total value to 0</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_financials_Annual_field_to_0</fullName>
        <field>Total_CMS_Contract_Value__c</field>
        <formula>0</formula>
        <name>Set financials Annual field to 0</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Setting null value on CRMDB Global</fullName>
        <actions>
            <name>Set_Financials_Total_value_to_0</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_financials_Annual_field_to_0</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>CRMDB__c.Annual_Child_CMS_CR__c</field>
            <operation>greaterThan</operation>
            <value>USD 0</value>
        </criteriaItems>
        <criteriaItems>
            <field>CRMDB__c.Total_Child_CMS_CR__c</field>
            <operation>greaterThan</operation>
            <value>USD 0</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
