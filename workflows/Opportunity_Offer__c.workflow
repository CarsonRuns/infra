<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>QI_Opportunity_Offer_Integrated_Date</fullName>
        <field>Integrated_with_CCW__c</field>
        <formula>NOW()</formula>
        <name>QI-Opportunity Offer Integrated Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>QI-Opportunity Offer Integration Update</fullName>
        <actions>
            <name>QI_Opportunity_Offer_Integrated_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>NOT(ISBLANK(QuoteId__c))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
