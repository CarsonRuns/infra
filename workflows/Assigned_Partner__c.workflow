<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Clear_Assign_Directly_to_Recommended_PSR</fullName>
        <description>Clear the Assign Directly To Recommended PSR checkbox</description>
        <field>Assign_Recommended_PSR__c</field>
        <literalValue>0</literalValue>
        <name>Clear Assign Directly to Recommended PSR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Clear_PSR1_Before_Activation</fullName>
        <description>Clear PSR1 field when TP is not activated and TxM is trying to assign PSR at the time of TP creation</description>
        <field>Assigned_Partner_Sales_Rep__c</field>
        <name>Clear PSR1 Before Activation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Clear_PSR2_Before_Activation</fullName>
        <description>Clear PSR2 field when TP is not activated and TxM is trying to assign a PSR at the time of TP creation</description>
        <field>Assigned_Partner_Sales_Rep_2__c</field>
        <name>Clear PSR2 Before Activation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Clear_PSR3_Before_Activation</fullName>
        <description>Clear PSR3 field when TP is not activated and TxM is trying to assign a PSR at the time of TP creation</description>
        <field>Assigned_Partner_Sales_Rep_3__c</field>
        <name>Clear PSR3 Before Activation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Clear_isPSRAssigned</fullName>
        <description>Set isPSRAssigned = false</description>
        <field>isPSRAssigned__c</field>
        <literalValue>0</literalValue>
        <name>Clear isPSRAssigned</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Duplicate_Prevention_Field</fullName>
        <description>FY14 Q2 P360 Release: Recreated due to change in duplicate criteria</description>
        <field>Duplicate_Prevention__c</field>
        <formula>Assigned_Partner__c &amp;"-"&amp; Customer_Account__c &amp;"-"&amp; Marketing_Play_Name__c &amp;"-"&amp; TEXT(Target_Architecture__c)</formula>
        <name>Duplicate_Prevention_Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Email_update_for_TBM_TAM</fullName>
        <field>TBM_TAM_Email__c</field>
        <formula>TBM_TAM__r.Email</formula>
        <name>Email update for TBM/TAM</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>P360_AP_PSR1_name_update</fullName>
        <field>Assigned_PSR_SYS1__c</field>
        <formula>Assigned_Partner_Sales_Rep__r.FirstName &amp; " " &amp; Assigned_Partner_Sales_Rep__r.LastName</formula>
        <name>P360 AP PSR1 name update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>P360_AP_PSR2_name_update</fullName>
        <field>Assigned_PSR_SYS2__c</field>
        <formula>Assigned_Partner_Sales_Rep_2__r.FirstName &amp; " " &amp;  Assigned_Partner_Sales_Rep_2__r.LastName</formula>
        <name>P360 AP PSR2 name update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>P360_AP_PSR3_name_update</fullName>
        <field>Assigned_PSR_SYS3__c</field>
        <formula>Assigned_Partner_Sales_Rep_3__r.FirstName &amp; " " &amp;  Assigned_Partner_Sales_Rep_3__r.LastName</formula>
        <name>P360 AP PSR3 name update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>P360_Marketing_Field_Name_Update</fullName>
        <field>Marketing_Play_Name__c</field>
        <formula>"Customer Intelligence"</formula>
        <name>P360 Marketing Field Name Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>P360_Target_Prospect_Partner_Activated</fullName>
        <description>Set the checkbox when a partner is assigned and a target prospect is activated.</description>
        <field>Partner_Assigned__c</field>
        <literalValue>1</literalValue>
        <name>P360_Target_Prospect_Partner Activated</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>P360_Target_Prospect_Partner_InActivated</fullName>
        <description>Set the checkbox when a partner is assigned and a target prospect is Inactivated.</description>
        <field>Assignment_Activated__c</field>
        <literalValue>0</literalValue>
        <name>P360_Target_Prospect_Partner InActivated</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>P360_partner_status_assigned_to_PSR</fullName>
        <description>This workflow field rule update Partner Status to Assigned to PSR.</description>
        <field>Partner_Status__c</field>
        <literalValue>Assigned to PSR</literalValue>
        <name>P360 partner status &gt; assigned to PSR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PSR_Accepted_Date_Time_NOW</fullName>
        <description>Date/Time PSR Accepted TP</description>
        <field>PSR_Accepted_Date_Time__c</field>
        <formula>NOW()</formula>
        <name>PSR Accepted Date/Time NOW</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PSR_Assigned_Date_Time_NOW</fullName>
        <description>Set PSR Assigned Date/Time to NOW</description>
        <field>PSR_Assigned_Date_Time__c</field>
        <formula>NOW()</formula>
        <name>PSR Assigned Date/Time NOW</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Partner_Accepted_Date</fullName>
        <field>Partner_Accepted_Date__c</field>
        <formula>Now()</formula>
        <name>Partner Accepted Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Partner_Added_Date_Time_NOW</fullName>
        <description>Set Partner Added Date Time to Now</description>
        <field>Partner_Added_Date_Time__c</field>
        <formula>NOW()</formula>
        <name>Partner Added Date/Time NOW()</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Partner_Status_Closed</fullName>
        <description>Update Partner Status to "Closed"</description>
        <field>Partner_Status__c</field>
        <literalValue>Closed</literalValue>
        <name>Partner Status_Closed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Partner_Status_Update</fullName>
        <description>Set the Partner Status to "Assigned New"</description>
        <field>Partner_Status__c</field>
        <literalValue>Assigned (New)</literalValue>
        <name>Partner Status Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Prospect_Partner_Activated_Date_Time_NOW</fullName>
        <description>Target Prospect Activation Date/Time to NOW</description>
        <field>Partner_Assigned_Date__c</field>
        <formula>Now()</formula>
        <name>Prospect/Partner Activated Date/Time NOW</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reject_Closed_Reason_Expired</fullName>
        <description>Update Reject/Closed Reason to "Expired"</description>
        <field>Rejected_Reason__c</field>
        <literalValue>Expired</literalValue>
        <name>Reject/Closed Reason_Expired</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_isPSRAssigned</fullName>
        <field>isPSRAssigned__c</field>
        <literalValue>1</literalValue>
        <name>Update isPSRAssigned</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Duplicate_Prevention_Rule</fullName>
        <actions>
            <name>Duplicate_Prevention_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This rule trigger when user create or edit record in Assignd Partner object.</description>
        <formula>!ISBLANK( Assigned_Partner__c) &amp;&amp; !ISBLANK( Customer_Account__c ) &amp;&amp; !ISBLANK( Marketing_Play_Name__c ) &amp;&amp; !ISPICKVAL(Target_Architecture__c,'')</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>P360 Assigned Partner update P360 fields</fullName>
        <actions>
            <name>P360_AP_PSR1_name_update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>P360_AP_PSR2_name_update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>P360_AP_PSR3_name_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 AND 2 AND 3) OR (4 OR 5 OR 6)</booleanFilter>
        <criteriaItems>
            <field>Assigned_Partner__c.Assigned_Partner_Sales_Rep__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Assigned_Partner__c.Assigned_Partner_Sales_Rep_2__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Assigned_Partner__c.Assigned_Partner_Sales_Rep_3__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Assigned_Partner__c.Assigned_Partner_Sales_Rep__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Assigned_Partner__c.Assigned_Partner_Sales_Rep_2__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Assigned_Partner__c.Assigned_Partner_Sales_Rep_3__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Workflow rule Created for CCIX</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>P360 Clear PSR Before TP Activation</fullName>
        <actions>
            <name>Clear_PSR1_Before_Activation</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Clear_PSR2_Before_Activation</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Clear_PSR3_Before_Activation</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Clear_isPSRAssigned</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Partner_Status_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND (2 OR 3 OR 4)</booleanFilter>
        <criteriaItems>
            <field>Assigned_Partner__c.Assignment_Activated__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>Assigned_Partner__c.Assigned_Partner_Sales_Rep__c</field>
            <operation>notEqual</operation>
            <value>NULL</value>
        </criteriaItems>
        <criteriaItems>
            <field>Assigned_Partner__c.Assigned_Partner_Sales_Rep_2__c</field>
            <operation>notEqual</operation>
            <value>NULL</value>
        </criteriaItems>
        <criteriaItems>
            <field>Assigned_Partner__c.Assigned_Partner_Sales_Rep_3__c</field>
            <operation>notEqual</operation>
            <value>NULL</value>
        </criteriaItems>
        <description>Clear all PSR fields when a TP is uploaded and user tries to assign a PSR before TP activation</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>P360 Marketing Field Name Update</fullName>
        <actions>
            <name>P360_Marketing_Field_Name_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Assigned_Partner__c.Marketing_Play_Name__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Marketing field name should be "Customer Intelligence", if the field value is blank</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>P360 PSR Assignment Rule%2E</fullName>
        <actions>
            <name>P360_partner_status_assigned_to_PSR</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PSR_Assigned_Date_Time_NOW</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_isPSRAssigned</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If any Partner Sales Rep(PSR 1, PSR 2 or PSR 3) is selected, then the corresponding Partner  Status field value is changed to ASSIGN TO PSR value.</description>
        <formula>(OR( NOT( ISBLANK( Assigned_Partner_Sales_Rep__c ) ) , NOT( ISBLANK( Assigned_Partner_Sales_Rep_2__c ) ) , NOT( ISBLANK( Assigned_Partner_Sales_Rep_3__c ) ) ))    &amp;&amp; (ISCHANGED( Assigned_Partner_Sales_Rep__c )  ||  ISCHANGED( Assigned_Partner_Sales_Rep_2__c )  ||  ISCHANGED( Assigned_Partner_Sales_Rep_3__c ) || ISNEW())  &amp;&amp; (!isPSRAssigned__c)  &amp;&amp; NOT(  OR(ISPICKVAL(Partner_Status__c , 'Actively Working') , 	ISPICKVAL(Partner_Status__c , 'Closed') , 	ISPICKVAL(Partner_Status__c , 'Rejected'))) &amp;&amp;  Assignment_Activated__c</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>P360-Partner Accepted Date</fullName>
        <actions>
            <name>Partner_Accepted_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Assigned_Partner__c.Partner_Status__c</field>
            <operation>equals</operation>
            <value>Actively Working</value>
        </criteriaItems>
        <criteriaItems>
            <field>Assigned_Partner__c.Partner_Status__c</field>
            <operation>equals</operation>
            <value>Assigned to PSR</value>
        </criteriaItems>
        <description>Workflow rule created to update the Partner Accepted date based on partner status field</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>P360-Prospect%2FPartner Activated Date%2FTime</fullName>
        <actions>
            <name>P360_Target_Prospect_Partner_Activated</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Prospect_Partner_Activated_Date_Time_NOW</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Assigned_Partner__c.Assignment_Activated__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>P360- Rule to Update Prospect/Partner Activated date field based on Prospect/Partner Activated on target prospect</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>P360_TP_Timer_Expire_Execution</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Assigned_Partner__c.Expiration_Date_Link__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Assigned_Partner__c.Assignment_Activated__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>On Expiration Date.
1. Deactivate the Target Prospect
2. Partner Status to "Closed"
3. Rejection/Closed Reason to "Expired"</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>P360_Target_Prospect_Partner_InActivated</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Partner_Status_Closed</name>
                <type>FieldUpdate</type>
            </actions>
            <actions>
                <name>Reject_Closed_Reason_Expired</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Assigned_Partner__c.Expiration_Date__c</offsetFromField>
            <timeLength>24</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>PSR Accepted Date%2FTime NOW</fullName>
        <actions>
            <name>PSR_Accepted_Date_Time_NOW</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Sets PSR Accepted Date/Time to Now when TP status changes to Actively working from Partner Assigned or PSR Assigned</description>
        <formula>ISCHANGED( Partner_Status__c )
&amp;&amp;
ISPICKVAL(Partner_Status__c, 'Actively Working')
&amp;&amp;
(PRIORVALUE(Partner_Status__c) = 'Partner Assigned'
||
PRIORVALUE(Partner_Status__c) = 'Assigned to PSR')</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Partner Added Date%2FTime NOW%28%29</fullName>
        <actions>
            <name>Partner_Added_Date_Time_NOW</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Date/Time when a Partner gets assigned to target prospect</description>
        <formula>NOT(ISBLANK(Assigned_Partner__c))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Recommended PSR changed</fullName>
        <actions>
            <name>Clear_Assign_Directly_to_Recommended_PSR</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If Cisco Recommended PSR changed, then clear the Assign Directly To Recommended PSR checkbox</description>
        <formula>IF( ISCHANGED( Cisco_Recomended_Partner_Sales_Rep__c ) &amp;&amp;  NOT( Assignment_Activated__c )  , TRUE, FALSE)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
