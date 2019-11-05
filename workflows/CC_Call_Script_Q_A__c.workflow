<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>NGCC_Call_Script_Status_Update</fullName>
        <field>Status__c</field>
        <literalValue>Draft</literalValue>
        <name>NGCC Call Script Status Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>Call_Script__c</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NGCC_Call_Script_Validation_Required_FU</fullName>
        <field>Validation_Both_Conditional_or_Required__c</field>
        <literalValue>1</literalValue>
        <name>NGCC Call Script Validation Required FU</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>NGCC Call Script Q%2FA Change To Call Script Status</fullName>
        <actions>
            <name>NGCC_Call_Script_Status_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(ISCHANGED( LastModifiedDate ), ISPICKVAL(Call_Script__r.Status__c, 'Previewed'))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>NGCC Call Script Validation Required Updates</fullName>
        <actions>
            <name>NGCC_Call_Script_Validation_Required_FU</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2 OR (3 AND 4)</booleanFilter>
        <criteriaItems>
            <field>CC_Call_Script_Q_A__c.Required__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>CC_Call_Script_Q_A__c.Conditionaly_Required_If__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>CC_Call_Script_Q_A__c.Maximum_If_Number_Validation__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>CC_Call_Script_Q_A__c.Minimum_If_Number_Validation__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
