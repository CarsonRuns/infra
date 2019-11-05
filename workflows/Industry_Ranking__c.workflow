<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Industry_Ranking_Duplicate_Prevention</fullName>
        <description>Industry Ranking Duplicate Prevention</description>
        <field>Duplicate_Prevention__c</field>
        <formula>TEXT(Source__c) &amp;  '_' &amp; Year__c &amp; '_' &amp; Account__c</formula>
        <name>Industry Ranking Duplicate Prevention</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Industry Ranking Duplicate Prevention</fullName>
        <actions>
            <name>Industry_Ranking_Duplicate_Prevention</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Industry_Ranking__c.Source__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Industry_Ranking__c.Year__c</field>
            <operation>notEqual</operation>
            <value></value>
        </criteriaItems>
        <description>Industry Ranking Duplicate Prevention</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
