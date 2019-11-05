<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Closed_Checkbox_Update</fullName>
        <description>Updates Closed Checkbox to true whenever status is changed to RSM-Closed</description>
        <field>Closed__c</field>
        <literalValue>1</literalValue>
        <name>Closed Checkbox Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Closed_Date_Update</fullName>
        <description>Updates Closed Date whenever status is changed to RSM-Closed</description>
        <field>ClosedDate__c</field>
        <formula>Now()</formula>
        <name>Closed Date Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Open_Checkbox_update</fullName>
        <description>Update the open checkbox to true when a new record is created for Account Plan</description>
        <field>Open__c</field>
        <literalValue>1</literalValue>
        <name>Open Checkbox update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opened_Checkbox_Update</fullName>
        <description>Updates Open Checkbox to False whenever status is changed from RSM-Closed to something else</description>
        <field>Open__c</field>
        <literalValue>0</literalValue>
        <name>Opened Checkbox Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opened_Date_Update</fullName>
        <description>Updates Opened Date to Now when a new record is created for Account Plan</description>
        <field>CreatedDate__c</field>
        <formula>Now()</formula>
        <name>Opened Date Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Close_Field</fullName>
        <description>Updates Closed checkbox to false whenever status is changed from RSM-Closed to something else</description>
        <field>Closed__c</field>
        <literalValue>0</literalValue>
        <name>Update Close Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Closed_Date</fullName>
        <description>Updates Closed Date to Null if value in Status field is changed from RSM-Closed to something else</description>
        <field>ClosedDate__c</field>
        <name>Update Closed Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>AP Close and Close Date Update</fullName>
        <actions>
            <name>Closed_Checkbox_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Closed_Date_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Opened_Checkbox_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account_Plan__c.Status__c</field>
            <operation>equals</operation>
            <value>RSM - Closed</value>
        </criteriaItems>
        <description>This rule updates the Close and Closed Date field whenever a Status is changed to RSM Closed for Account Plan</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>AP Open and Open Date Update</fullName>
        <actions>
            <name>Open_Checkbox_update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Opened_Date_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account_Plan__c.Status__c</field>
            <operation>equals</operation>
            <value>AM - In Revision,New,RSM - Reviewing,RSM - Accepted</value>
        </criteriaItems>
        <description>This rule will update Open check box and Opened Date for Account Plan whenever a new Account Plan is created</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Account Plan Status Change from RSM Closed</fullName>
        <actions>
            <name>Open_Checkbox_update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Close_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Closed_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account_Plan__c.Status__c</field>
            <operation>notEqual</operation>
            <value>RSM - Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Account_Plan__c.Closed__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>The rule will change the values in open, close checkbox and Closed date when Account Plan Status would be changed from RSM Closed to any other status LOV</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
