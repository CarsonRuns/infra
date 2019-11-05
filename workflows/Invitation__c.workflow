<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Set_restricted_partners_Info</fullName>
        <field>Restricted_Partners_Info__c</field>
        <formula>IF(CONTAINS(Opportunity__r.Restricted_Partners_Info__c, 
'-'+Partner_SFDC_Id__c+'-'), Opportunity__r.Restricted_Partners_Info__c, Opportunity__r.Restricted_Partners_Info__c+'-'+ Partner_SFDC_Id__c+'-')</formula>
        <name>Set restricted partners Info</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Opportunity__c</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>Set restricted partners on opportunity</fullName>
        <actions>
            <name>Set_restricted_partners_Info</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Invitation__c.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
