<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Emailer_Set_Category_Type_for_Tasks</fullName>
        <description>Sets Category Type to Emailer Function, if the subject starts with Email Messenger</description>
        <field>Category_Type__c</field>
        <literalValue>Emailer Function</literalValue>
        <name>Emailer Set Category Type for Tasks</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Jabber_To_Populate_Call_Object_FU</fullName>
        <field>ReportingCallObject__c</field>
        <formula>IF(CallObject = 'Jabber Call',
	IF(NOT(ISBLANK(WhatId)),
		CASE(LEFT(WhatId,3),
			'001','Account',
			'006','Opportunity',
			'Case'),
				IF(NOT(ISBLANK(WhoId)),
					CASE(LEFT(WhoId,3), 
						'003','Contact', 
						'Lead'),'UnAssociated')),
	'')</formula>
        <name>Jabber To Populate Call Object FU</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Category_Type_to_Email</fullName>
        <description>Set Category Type to Email</description>
        <field>Category_Type__c</field>
        <literalValue>Email</literalValue>
        <name>Set Category Type to Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Emailer Set Category Type for Tasks</fullName>
        <actions>
            <name>Emailer_Set_Category_Type_for_Tasks</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.Category_Type__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Task.Subject</field>
            <operation>startsWith</operation>
            <value>Email Messenger</value>
        </criteriaItems>
        <description>Sets Category Type to Emailer Function, if the subject starts with Email Messenger</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Jabber To populate Reporting Object</fullName>
        <actions>
            <name>Jabber_To_Populate_Call_Object_FU</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Jabber Dec 2013 Release: Use to update Reporting Call Object Field</description>
        <formula>OR(ISNEW(),ISCHANGED(WhatId), ISCHANGED(WhoId))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set Category Type to Email</fullName>
        <actions>
            <name>Set_Category_Type_to_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Task.Category_Type__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Task.Subject</field>
            <operation>startsWith</operation>
            <value>Email:</value>
        </criteriaItems>
        <description>Set Category Type to Email</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
