<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>EmailsATworkspaceownerifATExpectedproductvalueis5Million</fullName>
        <description>Emails AT workspace owner if AT Expected product value is &gt; $5 Million.</description>
        <protected>false</protected>
        <recipients>
            <field>PSS__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity_Notifications/AT_Expected_Product_5Million_Notification</template>
    </alerts>
    <alerts>
        <fullName>Multitech_Workspace_DCR_Approval_Notification</fullName>
        <description>Multitech Workspace DCR Approval Notification</description>
        <protected>false</protected>
        <recipients>
            <field>DCR__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity_Notifications/Workspace_DCR_Approval_Notification_Template</template>
    </alerts>
    <alerts>
        <fullName>Multitech_Workspace_DCR_Reject_Notification</fullName>
        <description>Multitech Workspace DCR Reject Notification</description>
        <protected>false</protected>
        <recipients>
            <field>DCR__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity_Notifications/Workspace_DCR_Reject_Notification_Template</template>
    </alerts>
    <alerts>
        <fullName>Multitech_Workspace_DCR_Submission</fullName>
        <description>Multitech Workspace DCR Submission</description>
        <protected>false</protected>
        <recipients>
            <recipient>bpreuss@cisco.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity_Notifications/Workspace_Submission_Notification_to_DCR</template>
    </alerts>
    <fieldUpdates>
        <fullName>DCR_Status_Update_to_Submit</fullName>
        <description>Once the DCR has entered their name on the workspace, status should  automatically show “Submitted” .</description>
        <field>DCR_Workspace_Approval_Status__c</field>
        <literalValue>Submitted</literalValue>
        <name>DCR Status Update to Submit</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FY_Copy_EBD_Fiscal_Year_PSS</fullName>
        <description>Copies Fiscal Year of PSS Expected Book Date</description>
        <field>FY_Copy_PSS__c</field>
        <formula>YEAR( FY_Start_Date_PSS__c ) + 1</formula>
        <name>FY Copy EBD Fiscal Year PSS</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FY_Set_EBD_Fiscal_Week_PSS</fullName>
        <description>Set Fiscal Week of PSS Expected Book Date</description>
        <field>Fiscal_Week_PSS__c</field>
        <formula>FLOOR((AT_Expected_Book_Date__c - FY_Start_Date_PSS__c) / 7 ) + 1</formula>
        <name>FY Set EBD Fiscal Week PSS</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MultiTech</fullName>
        <description>MultiTech</description>
        <field>Is_Multi_Tech__c</field>
        <literalValue>1</literalValue>
        <name>MultiTech</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>OWForecast_Status_Commit</fullName>
        <description>OWForecast Status Commit</description>
        <field>AT_Forecast_Status__c</field>
        <literalValue>Commit</literalValue>
        <name>OWForecast Status Commit</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>OWForecast_Status_Not_Forecastable</fullName>
        <description>OWForecast Status Not Forecastable</description>
        <field>AT_Forecast_Status__c</field>
        <literalValue>Not Forecastable</literalValue>
        <name>OWForecast Status Not Forecastable</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>OW_Forecast_Status_Upside</fullName>
        <description>Forecast Status Upside</description>
        <field>AT_Forecast_Status__c</field>
        <literalValue>Upside</literalValue>
        <name>OW Forecast Status Upside</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>OWorkspace_Status_Active</fullName>
        <description>OWorkspace Status Active</description>
        <field>PSS_Workspace_Status__c</field>
        <literalValue>Active</literalValue>
        <name>OWorkspace Status Active</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>OWorkspace_Status_Booked</fullName>
        <description>OWorkspace Status Booked</description>
        <field>PSS_Workspace_Status__c</field>
        <literalValue>Booked</literalValue>
        <name>OWorkspace Status Booked</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>OWorkspace_Status_Cancelled</fullName>
        <description>OWorkspace Status Cancelled</description>
        <field>PSS_Workspace_Status__c</field>
        <literalValue>Cancelled</literalValue>
        <name>OWorkspace Status Cancelled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>OWorkspace_Status_Lost</fullName>
        <description>OWorkspace Status Lost</description>
        <field>PSS_Workspace_Status__c</field>
        <literalValue>Lost</literalValue>
        <name>OWorkspace Status Lost</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PSS_Owner_Change</fullName>
        <field>AT_Team__c</field>
        <name>PSS Owner Change</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Workspace_Name</fullName>
        <description>Set workspace</description>
        <field>Name</field>
        <formula>Opportunity__r.Name</formula>
        <name>Workspace Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Workspace_Won_Lost_Date</fullName>
        <description>Workspace Won/Lost Date</description>
        <field>Workspace_Won_Lost_Date__c</field>
        <formula>TODAY()</formula>
        <name>Workspace Won/Lost Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Workspace_Won_Lost_Date_to_null</fullName>
        <description>Set Workspace Won/Lost Date to null</description>
        <field>Workspace_Won_Lost_Date__c</field>
        <name>Workspace Won/Lost Date to null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>AT Expected Product %3E 5Million Notification</fullName>
        <actions>
            <name>EmailsATworkspaceownerifATExpectedproductvalueis5Million</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AT_Workspace__c.AT_Expected_Product__c</field>
            <operation>greaterThan</operation>
            <value>"USD 5,000"</value>
        </criteriaItems>
        <description>Emails Opportunity workspace owner if Opportunity Workspace Expected product value is &gt; $5 Million.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>FY EBD Changed PSS</fullName>
        <actions>
            <name>FY_Copy_EBD_Fiscal_Year_PSS</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>FY_Set_EBD_Fiscal_Week_PSS</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Workflow copies Opportunity Workspace Expected Book Date's Fiscal Year Start Date, and sets Fiscal Week</description>
        <formula>$User.Username = 'praschan@cisco.com' ||
(ISCHANGED(AT_Expected_Book_Date__c) ||
(NOT(ISNULL(AT_Expected_Book_Date__c)) &amp;&amp;
ISNULL (FY_Copy_PSS__c) &amp;&amp;
NOT(ISNULL( AT_Expected_Product__c ))))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Multitech Workspace DCR Approval Notification</fullName>
        <actions>
            <name>Multitech_Workspace_DCR_Approval_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AT_Workspace__c.DCR_Workspace_Approval_Status__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <description>Workflow to send email notification to DCR upon approval by DCR Admin.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Multitech Workspace DCR Reject Notification</fullName>
        <actions>
            <name>Multitech_Workspace_DCR_Reject_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AT_Workspace__c.DCR_Workspace_Approval_Status__c</field>
            <operation>equals</operation>
            <value>Rejected</value>
        </criteriaItems>
        <description>Workflow to send email notification to DCR upon reject by DCR Admin.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Multitech Workspace DCR Submission</fullName>
        <actions>
            <name>Multitech_Workspace_DCR_Submission</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>DCR_Status_Update_to_Submit</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When DCR Lookup field is populated, set the Status value to "Submitted".</description>
        <formula>!ISBLANK(DCR__c) &amp;&amp;
 Is_Multi_Tech__c = TRUE</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>OWForecast Status Commit</fullName>
        <actions>
            <name>OWForecast_Status_Commit</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AT_Workspace__c.Workspace_Stage__c</field>
            <operation>equals</operation>
            <value>4 - Agreement,5 - Closed Won</value>
        </criteriaItems>
        <description>OW Forecast Status Commit</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>OWForecast Status Not Forecastable</fullName>
        <actions>
            <name>OWForecast_Status_Not_Forecastable</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AT_Workspace__c.Workspace_Stage__c</field>
            <operation>equals</operation>
            <value>1 - Prospect</value>
        </criteriaItems>
        <description>OW Forecast Status Not Forecastable</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>OWForecast Status Upside</fullName>
        <actions>
            <name>OW_Forecast_Status_Upside</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AT_Workspace__c.Workspace_Stage__c</field>
            <operation>equals</operation>
            <value>2 - Qualification,3 - Proposal</value>
        </criteriaItems>
        <description>OW Forecast Status Upside</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>OWorkspace Status Active</fullName>
        <actions>
            <name>OWorkspace_Status_Active</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AT_Workspace__c.Workspace_Stage__c</field>
            <operation>equals</operation>
            <value>1 - Prospect,2 - Qualification,3 - Proposal,4 - Agreement</value>
        </criteriaItems>
        <description>OWorkspace Status Active</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>OWorkspace Status Booked</fullName>
        <actions>
            <name>OWorkspace_Status_Booked</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AT_Workspace__c.Workspace_Stage__c</field>
            <operation>equals</operation>
            <value>5 - Closed Won</value>
        </criteriaItems>
        <description>OWorkspace Status Booked</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>OWorkspace Status Cancelled</fullName>
        <actions>
            <name>OWorkspace_Status_Cancelled</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AT_Workspace__c.Workspace_Stage__c</field>
            <operation>equals</operation>
            <value>5 - Closed Cancelled</value>
        </criteriaItems>
        <description>OWorkspace Status Cancelled</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>OWorkspace Status Lost</fullName>
        <actions>
            <name>OWorkspace_Status_Lost</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>AT_Workspace__c.Workspace_Stage__c</field>
            <operation>equals</operation>
            <value>5 - Closed Lost</value>
        </criteriaItems>
        <description>OWorkspace Status Lost</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Workspace Won%2FLost Date</fullName>
        <actions>
            <name>Workspace_Won_Lost_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Workspace Won/Lost Date</description>
        <formula>ISCHANGED( PSS_Workspace_Status__c ) &amp;&amp; (TEXT(PSS_Workspace_Status__c ) = 'Booked' ||
TEXT(PSS_Workspace_Status__c ) = 'Lost' ||
TEXT(PSS_Workspace_Status__c ) = 'Cancelled')</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Workspace Won%2FLost Date to null</fullName>
        <actions>
            <name>Workspace_Won_Lost_Date_to_null</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Workspace Won/Lost Date to null</description>
        <formula>ISCHANGED( PSS_Workspace_Status__c ) &amp;&amp; TEXT(PSS_Workspace_Status__c ) != 'Booked' &amp;&amp;
TEXT(PSS_Workspace_Status__c ) != 'Lost' &amp;&amp;
TEXT(PSS_Workspace_Status__c ) != 'Cancelled'</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>zzMultiTech</fullName>
        <actions>
            <name>MultiTech</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>AT_Workspace__c.Workspace_Technology_Line_Count__c</field>
            <operation>greaterThan</operation>
            <value>0</value>
        </criteriaItems>
        <description>Set Multitech to true</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>zzWorkspace Name</fullName>
        <actions>
            <name>Workspace_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>set workspace name</description>
        <formula>Name == 'null -- null' || Name = ''</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
