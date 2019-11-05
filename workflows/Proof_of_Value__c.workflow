<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>GVE_POV_Notification</fullName>
        <ccEmails>tsn-request@cisco.com</ccEmails>
        <description>GVE POV Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>dghaney@cisco.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>marirand@cisco.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PoV_Templates/PoV_Approval_Notification_to_GVE</template>
    </alerts>
    <alerts>
        <fullName>Notification_after_order_save_without_BOM</fullName>
        <ccEmails>pov-approval-mailer@cisco.com</ccEmails>
        <description>Notification after order save without BOM</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderAddress>donotreply-ciscosales@cisco.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>PoV_Templates/No_BOM_Notification_to_POV_Owner</template>
    </alerts>
    <alerts>
        <fullName>POV_Order_Created</fullName>
        <ccEmails>pov-approval-mailer@cisco.com</ccEmails>
        <description>POV Order Created</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderAddress>donotreply-sfdc@cisco.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>PoV_Templates/POV_Order_Created</template>
    </alerts>
    <alerts>
        <fullName>PoV_Approval_Notification_for_Lead_SE_and_SE_Manager_Approved</fullName>
        <ccEmails>Content-security-cse@cisco.com</ccEmails>
        <description>PoV Approval Notification for Lead SE and SE Manager Approved</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/PoV_Approval_Notification_to_Lead_SE_and_Security_SE_Manager</template>
    </alerts>
    <alerts>
        <fullName>PoV_Approval_Notification_to_Threat_Grid_Provision</fullName>
        <ccEmails>provision@threatgrid.com</ccEmails>
        <description>PoV Approval Notification to Threat Grid Provision</description>
        <protected>false</protected>
        <recipients>
            <recipient>dghaney@cisco.com</recipient>
            <type>user</type>
        </recipients>
        <recipients>
            <recipient>marirand@cisco.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PoV_Templates/PoV_Approval_Notification_to_Threat_Grid_Provision</template>
    </alerts>
    <alerts>
        <fullName>PoV_Lead_SE_Approval_Notification_to_Owner</fullName>
        <description>PoV Lead SE Approval Notification to Owner</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CEE_Email_Templates/PoV_Lead_SE_Approval_Notification_to_Owner</template>
    </alerts>
    <alerts>
        <fullName>PoV_Rejection_Notification_Lead_SE</fullName>
        <description>PoV Rejection Notification_Lead SE</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>CEE_Email_Templates/PoV_Rejection_Notification_By_Lead_SE</template>
    </alerts>
    <alerts>
        <fullName>PoV_Rejection_Notification_SE</fullName>
        <description>PoV Rejection Notification_SE</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PoV_Templates/PoV_Rejection_Notification</template>
    </alerts>
    <alerts>
        <fullName>PoV_SE_MGR_Approval_Notification_to_Owner</fullName>
        <ccEmails>pov-approval-mailer@cisco.com</ccEmails>
        <description>PoV SE MGR Approval Notification to Owner</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PoV_Templates/PoV_SE_MGR_Approval_Notification_to_Owner</template>
    </alerts>
    <alerts>
        <fullName>PoV_SE_Reminder_Email1</fullName>
        <description>PoV SE Reminder Email1</description>
        <protected>false</protected>
        <recipients>
            <field>Security_SE_MGR__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PoV_Templates/New_Reminder_PoV_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>PoV_SE_Reminder_Email10</fullName>
        <description>PoV SE Reminder Email10</description>
        <protected>false</protected>
        <recipients>
            <field>Security_SE_MGR__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PoV_Templates/New_Reminder_PoV_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>PoV_SE_Reminder_Email2</fullName>
        <description>PoV SE Reminder Email2</description>
        <protected>false</protected>
        <recipients>
            <field>Security_SE_MGR__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PoV_Templates/New_Reminder_PoV_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>PoV_SE_Reminder_Email3</fullName>
        <description>PoV SE Reminder Email3</description>
        <protected>false</protected>
        <recipients>
            <field>Security_SE_MGR__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PoV_Templates/New_Reminder_PoV_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>PoV_SE_Reminder_Email4</fullName>
        <description>PoV SE Reminder Email4</description>
        <protected>false</protected>
        <recipients>
            <field>Security_SE_MGR__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PoV_Templates/New_Reminder_PoV_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>PoV_SE_Reminder_Email5</fullName>
        <description>PoV SE Reminder Email5</description>
        <protected>false</protected>
        <recipients>
            <field>Security_SE_MGR__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PoV_Templates/New_Reminder_PoV_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>PoV_SE_Reminder_Email6</fullName>
        <description>PoV SE Reminder Email6</description>
        <protected>false</protected>
        <recipients>
            <field>Security_SE_MGR__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PoV_Templates/New_Reminder_PoV_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>PoV_SE_Reminder_Email7</fullName>
        <description>PoV SE Reminder Email7</description>
        <protected>false</protected>
        <recipients>
            <field>Security_SE_MGR__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PoV_Templates/New_Reminder_PoV_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>PoV_SE_Reminder_Email8</fullName>
        <description>PoV SE Reminder Email8</description>
        <protected>false</protected>
        <recipients>
            <field>Security_SE_MGR__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PoV_Templates/New_Reminder_PoV_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>PoV_SE_Reminder_Email9</fullName>
        <description>PoV SE Reminder Email9</description>
        <protected>false</protected>
        <recipients>
            <field>Security_SE_MGR__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PoV_Templates/New_Reminder_PoV_Email_Template</template>
    </alerts>
    <fieldUpdates>
        <fullName>Eval_Status_Field</fullName>
        <field>POV_Status__c</field>
        <literalValue>POV Approved</literalValue>
        <name>Eval Status Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Final_Approval_Date</fullName>
        <field>Final_Approval_Date__c</field>
        <formula>TODAY()</formula>
        <name>Final Approval Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_SE_Approved</fullName>
        <description>Lead SE Approved</description>
        <field>Security_Lead_SE_Status__c</field>
        <formula>"Approved"</formula>
        <name>Lead SE Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_SE_MGR_Approved</fullName>
        <field>Security_SE_MGR_Status__c</field>
        <formula>'Approved'</formula>
        <name>Lead SE MGR Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_SE_Rejected</fullName>
        <description>Lead SE Rejected</description>
        <field>Security_Lead_SE_Status__c</field>
        <formula>"Rejected"</formula>
        <name>Lead SE Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>OD_Approved</fullName>
        <field>Security_OD_Status__c</field>
        <formula>'Approved'</formula>
        <name>OD Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>OD_Rejected</fullName>
        <field>Security_OD_Status__c</field>
        <formula>'Rejected'</formula>
        <name>OD Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>POV_Approval_Status</fullName>
        <field>POV_Approval_Status__c</field>
        <literalValue>sAM Submitted</literalValue>
        <name>POV Approval Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>POV_Approval_Status_Lead_SE</fullName>
        <field>POV_Approval_Status__c</field>
        <literalValue>Lead SE Approved</literalValue>
        <name>POV Approval Status Lead SE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>POV_Approval_Status_Lead_SE_Rejects</fullName>
        <field>POV_Approval_Status__c</field>
        <literalValue>Lead SE Rejected</literalValue>
        <name>POV Approval Status Lead SE Rejects</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>POV_Approval_Status_OD_Rejects</fullName>
        <field>POV_Approval_Status__c</field>
        <literalValue>OD Rejected</literalValue>
        <name>POV Approval Status OD Rejects</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>POV_Approval_Status_SE_MGR_Approves</fullName>
        <field>POV_Approval_Status__c</field>
        <literalValue>SE Manager Approved</literalValue>
        <name>POV Approval Status SE MGR Approves</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>POV_Approval_Status_SE_MGR_Rejects</fullName>
        <field>POV_Approval_Status__c</field>
        <literalValue>SE Manager Rejected</literalValue>
        <name>POV Approval Status SE MGR Rejects</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>POV_Approval_Status_changed</fullName>
        <field>POV_Approval_Status__c</field>
        <literalValue>SAM Work in Progress</literalValue>
        <name>POV Approval Status changed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>POV_Approval_Status_on_OD_Approves</fullName>
        <field>POV_Approval_Status__c</field>
        <literalValue>OD Approved</literalValue>
        <name>POV Approval Status OD Approves</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>POV_Reported_Decision_Date_Update</fullName>
        <description>POV Reported Decision Date set based on POV Outcome value</description>
        <field>POV_Reported_Decision_Date__c</field>
        <formula>TODAY()</formula>
        <name>POV Reported Decision Date Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>POV_Status_Lead_SE_Approves</fullName>
        <field>POV_Status__c</field>
        <literalValue>Approval In Progress</literalValue>
        <name>POV Status Lead SE Approves</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>POV_Status_Lead_SE_Rejects</fullName>
        <field>POV_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>POV Status Lead SE Rejects</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>POV_Status_OD_Approves</fullName>
        <field>POV_Status__c</field>
        <literalValue>POV Approved</literalValue>
        <name>POV Status OD Approves</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>POV_Status_SE_MGR_Rejects</fullName>
        <field>POV_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>POV Status SE MGR Rejects</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>POV_Status_SE_Manager_Approves</fullName>
        <field>POV_Status__c</field>
        <literalValue>POV Approved</literalValue>
        <name>POV Status SE Manager Approves</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>POV_Status_before_Submission</fullName>
        <field>POV_Status__c</field>
        <literalValue>Approval In Progress</literalValue>
        <name>POV Status before Submission</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>POV_Status_changed</fullName>
        <field>POV_Status__c</field>
        <literalValue>In Progress</literalValue>
        <name>POV Status changed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>POV_Status_on_OD_Rejects</fullName>
        <field>POV_Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>POV Status OD Rejects</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PoV_Approval_Status_Update</fullName>
        <field>POV_Approval_Status__c</field>
        <literalValue>SAM Work in Progress</literalValue>
        <name>PoV Approval Status Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PoV_Status_Update</fullName>
        <field>POV_Status__c</field>
        <literalValue>In Progress</literalValue>
        <name>PoV Status Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RM_Rejected</fullName>
        <field>Security_RM_Status__c</field>
        <formula>'Rejected'</formula>
        <name>RM Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Record_Type_Update</fullName>
        <field>RecordTypeId</field>
        <lookupValue>POV_Submit</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Record Type Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reset_Lead_SE_Status</fullName>
        <field>Security_Lead_SE_Status__c</field>
        <name>Reset Lead SE Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reset_OD_Status</fullName>
        <field>Security_OD_Status__c</field>
        <name>Reset OD Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reset_RM_Status</fullName>
        <field>Security_RM_Status__c</field>
        <name>Reset RM Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Reset_SE_Status</fullName>
        <field>Security_SE_MGR_Status__c</field>
        <name>Reset SE Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SE_MGR_Rejected</fullName>
        <field>Security_SE_MGR_Status__c</field>
        <formula>'Rejected'</formula>
        <name>SE MGR Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SE_Manager_Approved</fullName>
        <field>Security_RM_Status__c</field>
        <formula>'Approved'</formula>
        <name>SE Manager Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Owner_Email</fullName>
        <field>Owner_Email__c</field>
        <formula>CreatedBy.Email</formula>
        <name>Update Owner Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>eSTAR_order_status_changes_to_Returned</fullName>
        <field>BOM_Returned_Date__c</field>
        <formula>TODAY()</formula>
        <name>eSTAR order status changes to Returned</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>GVE Notification</fullName>
        <actions>
            <name>GVE_POV_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Notify GVE</description>
        <formula>TEXT(POV_Approval_Status__c) = 'SE Manager Approved'
&amp;&amp;
( TEXT(POV_Solution_Advanced_Threat__c) = 'AMP on Endpoint/ThreatGrid'
  ||
 TEXT(POV_Solution_Advanced_Threat__c) = 'AMP Private Cloud'
  ||
 TEXT(POV_Solution_Advanced_Threat__c) = 'AMP for Endpoint'
)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Notification after order save</fullName>
        <actions>
            <name>POV_Order_Created</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Proof_of_Value__c.eSTAR_Order_Status__c</field>
            <operation>equals</operation>
            <value>ORDER CREATED</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Notification after order save without BOM</fullName>
        <actions>
            <name>Notification_after_order_save_without_BOM</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Proof_of_Value__c.BOMStatus__c</field>
            <operation>equals</operation>
            <value>0</value>
        </criteriaItems>
        <criteriaItems>
            <field>Proof_of_Value__c.POV_Approval_Status__c</field>
            <operation>equals</operation>
            <value>OD Approved</value>
        </criteriaItems>
        <criteriaItems>
            <field>Proof_of_Value__c.eSTAR_Order_Status__c</field>
            <operation>notEqual</operation>
            <value>ORDER CREATED</value>
        </criteriaItems>
        <description>If there is no BOM on the PoV , once OD approves, send an approval email to PoV owner and cc PoV mailer alias.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>POV Reminder for approval by OD</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Proof_of_Value__c.POV_Approval_Status__c</field>
            <operation>equals</operation>
            <value>RM Approved</value>
        </criteriaItems>
        <description>POV Reminder for approval by OD</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <timeLength>10</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <timeLength>4</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <timeLength>5</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <timeLength>8</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <timeLength>6</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <timeLength>7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <timeLength>9</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <timeLength>3</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <timeLength>2</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>POV Reminder for approval by RM</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Proof_of_Value__c.POV_Approval_Status__c</field>
            <operation>equals</operation>
            <value>SE Manager Approved</value>
        </criteriaItems>
        <description>POV Reminder for approval by RM</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <timeLength>5</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <timeLength>10</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <timeLength>6</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <timeLength>8</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <timeLength>3</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <timeLength>2</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <timeLength>7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <timeLength>4</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <timeLength>9</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>POV Reminder for approval by SE MGR</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Proof_of_Value__c.POV_Approval_Status__c</field>
            <operation>equals</operation>
            <value>SAM Submitted</value>
        </criteriaItems>
        <description>POV Reminder for approval by SE MGR</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>PoV_SE_Reminder_Email1</name>
                <type>Alert</type>
            </actions>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>PoV_SE_Reminder_Email9</name>
                <type>Alert</type>
            </actions>
            <timeLength>9</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>PoV_SE_Reminder_Email3</name>
                <type>Alert</type>
            </actions>
            <timeLength>3</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>PoV_SE_Reminder_Email10</name>
                <type>Alert</type>
            </actions>
            <timeLength>10</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>PoV_SE_Reminder_Email6</name>
                <type>Alert</type>
            </actions>
            <timeLength>6</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>PoV_SE_Reminder_Email4</name>
                <type>Alert</type>
            </actions>
            <timeLength>4</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>PoV_SE_Reminder_Email7</name>
                <type>Alert</type>
            </actions>
            <timeLength>7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>PoV_SE_Reminder_Email8</name>
                <type>Alert</type>
            </actions>
            <timeLength>8</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>PoV_SE_Reminder_Email2</name>
                <type>Alert</type>
            </actions>
            <timeLength>2</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>PoV_SE_Reminder_Email5</name>
                <type>Alert</type>
            </actions>
            <timeLength>5</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>POV Reported Decision Date Update</fullName>
        <actions>
            <name>POV_Reported_Decision_Date_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Set POV Reported Decision Date based on POV outcome changes to: Tech Win, Tech Loss, No Decision or Cancelled</description>
        <formula>TEXT(POV_Outcome__c) = "Tech Win" ||  TEXT(POV_Outcome__c) = "Tech Loss" ||  TEXT(POV_Outcome__c) = "Tech No Decision" ||  TEXT(POV_Outcome__c) = "Cancelled"</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>POV Thread Grid Provision Notification</fullName>
        <actions>
            <name>PoV_Approval_Notification_to_Threat_Grid_Provision</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Notify Thread Grid Provision Notification</description>
        <formula>TEXT(POV_Approval_Status__c) = 'SE Manager Approved'
&amp;&amp;
( TEXT(POV_Solution_Advanced_Threat__c) = 'AMP on Endpoint/ThreatGrid' 
  ||
  TEXT(POV_Solution_Advanced_Threat__c) = 'Threat Grid SaaS'
)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>POV eSTAR order status changes to Returned</fullName>
        <actions>
            <name>eSTAR_order_status_changes_to_Returned</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Proof_of_Value__c.eSTAR_Order_Status__c</field>
            <operation>equals</operation>
            <value>Returned</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>PoV Status Updates</fullName>
        <actions>
            <name>PoV_Approval_Status_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PoV_Status_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Proof_of_Value__c.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Provision Notification</fullName>
        <actions>
            <name>PoV_Approval_Notification_for_Lead_SE_and_SE_Manager_Approved</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <formula>(TEXT(POV_Approval_Status__c) = 'SE Manager Approved' 
|| 
TEXT(POV_Approval_Status__c) = 'Lead SE Approved') 
&amp;&amp; 
( TEXT(POV_Solution_Email_Security__c) = 'Advanced Phishing - On prem sensor' 
|| 
TEXT(POV_Solution_Email_Security__c) = 'Advanced Phishing - Cloud sensor' 
|| 
TEXT(POV_Solution_Email_Security__c) = 'Domain Protection' 
)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Owner Email</fullName>
        <actions>
            <name>Update_Owner_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Proof_of_Value__c.CreatedById</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
