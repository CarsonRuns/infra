<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>JiffleAttendeeUpdateCEE</fullName>
        <field>Jiffle_Reporting_Tracker__c</field>
        <formula>Customer_Engagements_Events__r.Jiffle_Reporting_Tracker__c +1</formula>
        <name>JiffleAttendeeUpdateCEE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>Customer_Engagements_Events__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>JiffleNowAttendeeReconciled</fullName>
        <field>Reconciled__c</field>
        <formula>IF(
	CONTAINS(Attendee_Email__c, "@cisco.com"),
	"Yes",
	IF(
		(ISPICKVAL(Meeting_Attended__c,"Yes") || ISPICKVAL(Meeting_Attended__c,"No") ||  Attendee_Status__c = "Cancelled" || Attendee_Status__c = "Deleted"),
		"Yes",
		"No"
	)
)</formula>
        <name>JiffleNowAttendeeReconciled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>JiffleNowAttendeeUniqueKey</fullName>
        <field>UniqueCombination__c</field>
        <formula>Customer_Engagements_Events__r.Jiffle_Event__r.Id+ Customer_Engagements_Events__r.Primary_Account__c + Customer_Engagements_Events__r.Opportunity__c + Jiffle_Session_Meeting__c</formula>
        <name>JiffleNow Attendee UniqueKey</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>JiffleNowAttendeeUniqueKey</fullName>
        <actions>
            <name>JiffleNowAttendeeReconciled</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>JiffleNowAttendeeUniqueKey</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2 OR 3</booleanFilter>
        <criteriaItems>
            <field>Jiffle_Attendee_Invitee__c.UniqueCombination__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Jiffle_Attendee_Invitee__c.Meeting_Attended__c</field>
            <operation>equals</operation>
            <value>Yes,No</value>
        </criteriaItems>
        <criteriaItems>
            <field>Jiffle_Attendee_Invitee__c.Attendee_Status__c</field>
            <operation>equals</operation>
            <value>Declined,Cancelled</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
