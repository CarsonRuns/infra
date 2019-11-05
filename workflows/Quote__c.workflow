<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>UpdateOppty_CCW_BOM_IntegrateQuoteStatus</fullName>
        <description>Update CCW BOM Integrate Quote Status field in Opportunity with Status of Integrated Quote's CCW Deal Status</description>
        <field>CCW_BOM_Integrated_Quote_Status__c</field>
        <formula>CCW_Deal_Status_MQ__c</formula>
        <name>UpdateOppty CCW BOM IntegrateQuoteStatus</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Opportunity_Name__c</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>Update Opportunity CCW BOM Integrate Quote Status</fullName>
        <actions>
            <name>UpdateOppty_CCW_BOM_IntegrateQuoteStatus</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update CCW BOM Integrate Quote Status field in Opportunity</description>
        <formula>DM_Quote_ID__c ==  Opportunity_Name__r.CCW_BOM_Integrated_Quote_Id__c</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
