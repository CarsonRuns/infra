<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Case_Last_Modified_Date_Email_Change</fullName>
        <field>Status_Change_Date_Time__c</field>
        <formula>NOW()</formula>
        <name>Case_Last_Modified_Date_Email_Change</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_First_Outbound_Email_Set</fullName>
        <description>Update the Case Field - First_Outbound_Email_Sent__c with first email sent Date/Time</description>
        <field>First_Outbound_Email_Sent__c</field>
        <formula>NOW()</formula>
        <name>Update First Outbound Email Set</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>Email_Message_on_Case</fullName>
        <actions>
            <name>Update_First_Outbound_Email_Set</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This Workflow will fire when first Outbound Email is sent.</description>
        <formula>ISNULL(Parent.First_Outbound_Email_Sent__c) &amp;&amp; (Incoming = False) &amp;&amp;   NOT( ISBLANK(  Parent.Owner:User.Id   ) )</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update_Case_Last_Modified_Date_Email_Change</fullName>
        <actions>
            <name>Case_Last_Modified_Date_Email_Change</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Created as a QW-7772 - To add a workflow rule that will update the "Last Modified Date" field when a PDI Engineer sends an outbound email to a partner or Cisco SE. This workflow will update Last Modified Date on Case if an Email Message is recieved/sent</description>
        <formula>OR( Incoming = True, Incoming = False )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
