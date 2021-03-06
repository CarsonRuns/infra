<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>NGCCAcitve</fullName>
        <field>active__c</field>
        <literalValue>0</literalValue>
        <name>NGCCAcitve</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NGCC_Active_Rule</fullName>
        <field>active__c</field>
        <literalValue>1</literalValue>
        <name>NGCC Active Rule</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>NGCCAssignementRuleActive</fullName>
        <actions>
            <name>NGCC_Active_Rule</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CC_Assignment_Rule__c.Child_Record_Count__c</field>
            <operation>greaterThan</operation>
            <value>0</value>
        </criteriaItems>
        <description>NGCC Assignment Rule :- Active workflow based on child record count</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>NGCCAssignementRuleInactive</fullName>
        <actions>
            <name>NGCCAcitve</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>CC_Assignment_Rule__c.Child_Record_Count__c</field>
            <operation>lessOrEqual</operation>
            <value>0</value>
        </criteriaItems>
        <description>NGCC Assignment Rule:- Inactive workflow based on child record count</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
