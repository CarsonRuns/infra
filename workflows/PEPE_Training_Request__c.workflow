<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>APJ_Arch_Event_Approve_Notification</fullName>
        <ccEmails>apj-pepe-archadmin@cisco.com</ccEmails>
        <description>APJ Arch Event Approve Notification</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>PEPE_Email_Template_Notifications/PEPE_APJ_ARCH_Email_alert_at_Event_Approved</template>
    </alerts>
    <alerts>
        <fullName>APJ_PIW_Event_Approve_Notification</fullName>
        <ccEmails>apj-pepe-piwadmin@cisco.com</ccEmails>
        <description>APJ PIW Event Approve Notification</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>PEPE_Email_Template_Notifications/PEPE_notification_on_Training_request_when_the_TR_status_Approved_to_TE_Owner</template>
    </alerts>
    <alerts>
        <fullName>BLP_Payment_Status_Notification</fullName>
        <ccEmails>partner_plus_enablement@cisco.com</ccEmails>
        <description>BLP_Payment_Status_Notification</description>
        <protected>false</protected>
        <recipients>
            <field>PLP_Email_Field_01__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>donotreply-ciscosales@cisco.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>PEPE_Email_Template_Notifications/LP_Template</template>
    </alerts>
    <alerts>
        <fullName>PDP_Email_Notification_to_Mailer_PP</fullName>
        <description>PDP: Email Notification to Mailer PP</description>
        <protected>false</protected>
        <recipients>
            <field>PDP_Mailer_PP__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PDP/PDP_PLED_notification_when_Regional_Lead_requests_Training_Request</template>
    </alerts>
    <alerts>
        <fullName>PDP_Email_Notification_to_all_RLs_for_ARC_records</fullName>
        <description>PDP: Email Notification to all RLs for ARC records</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PDP/PDP_Email_Notification_2_RLs_for_Awaiting_Requestors_Response</template>
    </alerts>
    <alerts>
        <fullName>PDP_PPL_Email_Notification_to_TE_Owner_On_Requested</fullName>
        <description>PDP_PPL_Email_Notification_to_TE_Owner_On_Requested</description>
        <protected>false</protected>
        <recipients>
            <field>TE_Owner_email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PEPE_Email_Template_Notifications/PDP_PPL_Email_Notification_to_TE_Owner_On_Requested</template>
    </alerts>
    <alerts>
        <fullName>PDP_PPL_Email_Notification_to_TR_Owner_On_LPBC_ARC</fullName>
        <description>PDP_PPL_Email_Notification_to_TR_Owner_On_LPBC_ARC</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PEPE_Email_Template_Notifications/PDP_PPL_Email_Notification_to_TR_Owner_For_LPBA_ARC</template>
    </alerts>
    <alerts>
        <fullName>PEPE_ARCH_EMAIL_ALERT_for_cancellation</fullName>
        <description>PEPE: ARCH EMAIL ALERT for cancellation</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PEPE_Email_Template_Notifications/PEPE_ARCH_for_cancellation_of_the_requestor_rejection</template>
    </alerts>
    <alerts>
        <fullName>PEPE_ARCH_is_used_for_reviewing_the_TR_requested_status</fullName>
        <description>PEPE: ARCH is used for reviewing the TR requested status</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PEPE_Email_Template_Notifications/PEPE_ARCH_Admin_to_host_TR_reviewed_for_the_approval_or_rejected</template>
    </alerts>
    <alerts>
        <fullName>PEPE_ARCH_is_used_for_reviewing_the_TR_requested_status_APJ</fullName>
        <description>PEPE: ARCH is used for reviewing the TR requested status APJ</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PEPE_Email_Template_Notifications/PEPE_APJ_ARCH_Admin_to_host_TR_reviewed_for_the_approval_or_rejected</template>
    </alerts>
    <alerts>
        <fullName>PEPE_Arch_send_email_alert_to_admin_host_and_learning_partner_if_applicable_when</fullName>
        <description>PEPE: Arch send email alert to admin, host and learning partner if applicable when room and propose date changes</description>
        <protected>false</protected>
        <recipients>
            <field>PLP_Email_Field_01__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>PLP_Email_Field_02__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>PLP_Email_Field_03__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>TE_Owner_email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>donotreply-sfdc@cisco.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>PEPE_Email_Template_Notifications/PEPE_Arch_email_alert_to_Hosts_Admins_L_for_Room_and_propose_dates_changes</template>
    </alerts>
    <alerts>
        <fullName>PEPE_Email_Notification_to_LP1_when_status_changed_to_Learning_Partner_being_con</fullName>
        <description>PEPE: Email Notification to LP1 when status changed to Learning Partner being contacted</description>
        <protected>false</protected>
        <recipients>
            <field>PLP_Email_Field_01__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>donotreply-ciscosales@cisco.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>PEPE_Email_Template_Notifications/PEPE_Email_Notification_to_LPs_when_status_is_Learning_Partner_being_contacted</template>
    </alerts>
    <alerts>
        <fullName>PEPE_Email_Notification_to_LP2_when_status_changed_to_Learning_Partner_being_con</fullName>
        <description>PEPE: Email Notification to LP2 when status changed to Learning Partner being contacted</description>
        <protected>false</protected>
        <recipients>
            <field>PLP_Email_Field_02__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>donotreply-ciscosales@cisco.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>PEPE_Email_Template_Notifications/PEPE_Email_Notification_to_LPs_when_status_is_Learning_Partner_being_contacted</template>
    </alerts>
    <alerts>
        <fullName>PEPE_Email_Notification_to_LP3_when_status_changed_to_Learning_Partner_being_con</fullName>
        <description>PEPE: Email Notification to LP3 when status changed to Learning Partner being contacted</description>
        <protected>false</protected>
        <recipients>
            <field>PLP_Email_Field_03__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>donotreply-ciscosales@cisco.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>PEPE_Email_Template_Notifications/PEPE_Email_Notification_to_LPs_when_status_is_Learning_Partner_being_contacted</template>
    </alerts>
    <alerts>
        <fullName>PEPE_PP_notification_on_Training_request_when_the_TR_status_changed_to_Event_app</fullName>
        <description>PEPE PP notification on Training request when the TR status changed to “Event approved"</description>
        <protected>false</protected>
        <recipients>
            <field>PDP_Mailer_PP__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>donotreply-sfdc@cisco.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>PEPE_Email_Template_Notifications/PEPE_Sample_notification_on_Training_request_when_the_TR_status_changed_to_Even</template>
    </alerts>
    <alerts>
        <fullName>PEPE_PVT_EMEAR_Admin_notifies_hosts_on_TR_Approved</fullName>
        <description>PEPE: PVT EMEAR Admin notifies hosts on TR Approved</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>donotreply-sfdc@cisco.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>PEPE_Email_Template_Notifications/PEPE_PVT_EMEAR_Admin_notifies_hosts_on_TR_Approved</template>
    </alerts>
    <alerts>
        <fullName>PEPE_PVT_TR_rejected_by_admin_sends_notification_to_host</fullName>
        <description>PEPE: PVT TR rejected by admin sends notification to host</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>donotreply-sfdc@cisco.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>PEPE_Email_Template_Notifications/PEPE_PVT_EMEAR_Admin_notifies_hosts_on_TR_Rejection</template>
    </alerts>
    <alerts>
        <fullName>PEPE_notification_on_Training_request_when_the_TR_status_Approved_to_TE_Owner</fullName>
        <description>PEPE notification on Training request when the TR status Approved to TE Owner</description>
        <protected>false</protected>
        <recipients>
            <field>PDP_Mailer_PP__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PEPE_Email_Template_Notifications/PEPE_notification_on_Training_request_when_the_TR_status_Approved_to_TE_Owner</template>
    </alerts>
    <fieldUpdates>
        <fullName>CventCode</fullName>
        <field>CI_CVENT_Code__c</field>
        <name>CventCode</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CventCodeToBeCleared</fullName>
        <field>CI_CVENT_Code__c</field>
        <name>CventCodeToBeCleared</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CventNameToBeCleared</fullName>
        <field>CI_CVENT_Session_Name__c</field>
        <name>CventNameToBeCleared</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CventSesIdToBeCleared</fullName>
        <field>CI_CVENT_Session_Id__c</field>
        <name>CventSesIdToBeCleared</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>End_Date_Calculation</fullName>
        <field>Actual_End_Date__c</field>
        <formula>if( TE_Training_Duration_Unit__c  ='Days',Actual_Start_Date__c+  TE_Training_Duration_Value__c -1,null)</formula>
        <name>End Date Calculation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>End_time</fullName>
        <description>Default time</description>
        <field>Actual_End_Time__c</field>
        <literalValue>17:00</literalValue>
        <name>End time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PDP_Added_into_cart_to_Requested</fullName>
        <field>Status__c</field>
        <literalValue>Requested</literalValue>
        <name>PDP: Added into cart to Requested</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PDP_Field_Update_to_APJC</fullName>
        <description>Geography field to APJC when master is APJC</description>
        <field>Geography__c</field>
        <literalValue>APJC</literalValue>
        <name>PDP: Field Update to APJC</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PDP_Field_Update_to_Agenda</fullName>
        <description>Formula field update to agenda</description>
        <field>Agenda__c</field>
        <formula>Training_Offering_Id__r.Agenda__c</formula>
        <name>PDP: Field Update to Agenda</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PDP_Field_Update_to_Americas</fullName>
        <description>Geography field to Americas when master is Americas</description>
        <field>Geography__c</field>
        <literalValue>Americas</literalValue>
        <name>PDP: Field Update to Americas</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PDP_Field_Update_to_EMEAR</fullName>
        <description>Geography field to APJC when master is EMEAR</description>
        <field>Geography__c</field>
        <literalValue>EMEAR</literalValue>
        <name>PDP: Field Update to EMEAR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PDP_Field_Update_to_Objectives</fullName>
        <description>Formula Field update on Objectives</description>
        <field>Objectives__c</field>
        <formula>Training_Offering_Id__r.Objectives__c</formula>
        <name>PDP: Field Update to Objectives</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PDP_PPL_FieldUpdate_Change_PRI_NO</fullName>
        <field>RecordTypeId</field>
        <lookupValue>PPL_PRIMARY_REQUEST_NO</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>PDP_PPL_FieldUpdate_Change_PRI_NO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PDP_PPL_Field_Update_to_EMEAR</fullName>
        <description>Geography field to APJC when master is EMEAR</description>
        <field>Geography__c</field>
        <literalValue>EMEAR</literalValue>
        <name>PDP_PPL_Field_Update_to_EMEAR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PDP_PPL_Primary_Request_Status_NO</fullName>
        <field>Primary_request__c</field>
        <literalValue>No</literalValue>
        <name>PDP_PPL_Primary_Request_Status_NO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PDP_PPL_Primary_Request_Status_YES</fullName>
        <field>Primary_request__c</field>
        <literalValue>Yes</literalValue>
        <name>PDP_PPL_Primary_Request_Status_YES</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PDP_PPL_RecType_ALL_STATUS_PRI_YES</fullName>
        <description>It will update the record type to Confirmed LPCIP MoreInfo</description>
        <field>RecordTypeId</field>
        <lookupValue>REC_PPL_ALL_STATUS_PRIMARY_YES</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>PDP_PPL_RecType_ALL_STATUS_PRI_YES</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PDP_PPL_RecType_changeToEA_LC_Delivered</fullName>
        <description>It will update the record type to Event Approved or Deliered or Logistic Confirm</description>
        <field>RecordTypeId</field>
        <lookupValue>PPL_PRIMARY_REQUEST_YES_EA_LC_DELIVERED</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>PDP_PPL_RecType_changeToEA_LC_Delivered</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PDP_RecType_change_to_Approved_Expired</fullName>
        <description>It will update the record type to Approved Expired.</description>
        <field>RecordTypeId</field>
        <lookupValue>Edit_EventApproved_Expired</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>PDP: RecType change to Approved Expired</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PDP_RecType_change_to_Delivered_Closed</fullName>
        <description>It will update the record type to Delivered Closed</description>
        <field>RecordTypeId</field>
        <lookupValue>Edit_Delivered_Closed</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>PDP: RecType change to Delivered Closed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PDP_RecType_to_LPBC_ARC_MoreInfo</fullName>
        <description>It will update the record type to Confirmed LPCIP MoreInfo</description>
        <field>RecordTypeId</field>
        <lookupValue>Edit_LPBC_ARC_MoreInfo</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>PDP: RecType to LPBC ARC MoreInfo</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PDP_RecType_to_Logistics_Confirmed</fullName>
        <description>It will update the record type to Logistics Confirmed.</description>
        <field>RecordTypeId</field>
        <lookupValue>Edit_Logistics_Confirmed</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>PDP: RecType to Logistics Confirmed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PDP_Rec_Typ_to_Cal_Based</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Calendar_Based_Host_CancellationRejectedDieliveredClosed</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>PDP: Rec Typ to Cal Based</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PDP_Rec_Typ_to_Edit_LPBC_ARC_Moreinfo</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Edit_LPBC_ARC_MoreInfo</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>PDP: Rec Typ to "Edit LPBC ARC Moreinfo"</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PDP_Requested_to_Event_Approved</fullName>
        <field>Status__c</field>
        <literalValue>Event Approved</literalValue>
        <name>PDP: Requested to Event Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PDP_Requested_to_LPBC</fullName>
        <field>Status__c</field>
        <literalValue>Learning Partner being contacted</literalValue>
        <name>PDP: Requested to LPBC</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PDP_Requested_to_Request_Rejected</fullName>
        <field>Status__c</field>
        <literalValue>Request Rejected</literalValue>
        <name>PDP: Requested to Request Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PDP_TR_NO_Requested_to_Request_Rejected</fullName>
        <field>Status__c</field>
        <literalValue>Request Rejected</literalValue>
        <name>PDP:TR NO Requested to Request Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PDP_Training_Duration_Unit_to_Days</fullName>
        <description>Updates the Training Duration Unit to Days</description>
        <field>Training_Duration_Unit__c</field>
        <literalValue>Days</literalValue>
        <name>PDP: Training Duration Unit to Days</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PDP_Training_Duration_Unit_to_Hours</fullName>
        <description>Updates the Training Duration Unit to Hours</description>
        <field>Training_Duration_Unit__c</field>
        <literalValue>Hours</literalValue>
        <name>PDP: Training Duration Unit to Hours</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PDP_Training_Duration_Unit_to_Minutes</fullName>
        <description>Updates the Training Duration Unit to Minutes</description>
        <field>Training_Duration_Unit__c</field>
        <literalValue>Minutes</literalValue>
        <name>PDP: Training Duration Unit to Minutes</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PDP_Training_Duration_Value_to_Value</fullName>
        <description>This updates the child Duration value with master Training Duration Value</description>
        <field>Training_Duration_Value__c</field>
        <formula>Training_Offering_Id__r.Training_Duration_Value__c</formula>
        <name>PDP: Training Duration Value to Value</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PDP_field_Update_to_Request</fullName>
        <description>Dec2016 Release</description>
        <field>PDP_Mailer_PP__c</field>
        <formula>IF( ISPICKVAL(Theatre_Region__c,"North"), 'emear_pepe_pp_north@cisco.com', 
IF( ISPICKVAL(Theatre_Region__c,"France"), 'emear_pepe_pp_france@cisco.com',
IF( ISPICKVAL(Theatre_Region__c,"South"), 'emear_pepe_pp_south@cisco.com',
IF( ISPICKVAL(Theatre_Region__c,"Central"), 'emear_pepe_pp_central@cisco.com',
IF( ISPICKVAL(Theatre_Region__c,"Africa"), 'emear_pepe_pp_africa@cisco.com',
IF( ISPICKVAL(Theatre_Region__c,"Middle East"), 'emear_pepe_pp_middle_east@cisco.com',
IF( ISPICKVAL(Theatre_Region__c,"Germany"), 'emear_pepe_pp_germany@cisco.com',
IF( ISPICKVAL(Theatre_Region__c,"All Theaters"), 'Emear_pepe_all_theaters@cisco.com',
IF( ISPICKVAL(Theatre_Region__c,"UK&amp;I"), 'emear_pepe_pp_uki@cisco.com',null
)
)
)
))))))</formula>
        <name>PDP_field_Update_to_Request</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PEPE_Arch_LIVE_RT_to_Delivered</fullName>
        <description>This record type to delivered.</description>
        <field>RecordTypeId</field>
        <lookupValue>Architecture_LIVE_Delivered_03</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>PEPE: Arch LIVE RT to Delivered</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PEPE_Arch_LIVE_Requested_RT_to_LPBC</fullName>
        <description>This field update is used when LIVE training request is Learning Partner Being Contacted.</description>
        <field>RecordTypeId</field>
        <lookupValue>Architecture_LIVE_LPBC_02</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>PEPE: Arch LIVE Requested RT to LPBC</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PEPE_Arch_REMOTE_Requested_RT_to_LPBC</fullName>
        <description>This recordtype changes when LPBC is selected</description>
        <field>RecordTypeId</field>
        <lookupValue>Architecture_REMOTE_LPBC_02</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>PEPE: Arch REMOTE Requested RT to LPBC</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PEPE_Arch_REMOTE_to_Delivered</fullName>
        <description>This recordtype used for REMOTE based request to change when delivered</description>
        <field>RecordTypeId</field>
        <lookupValue>Architecture_REMOTE_Delivered_03</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>PEPE: Arch REMOTE to Delivered</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PEPE_Calendar_changd_to_Requestd_layout</fullName>
        <description>This Field update will change the recordtype field to Requested Calendar Layout having approval history</description>
        <field>RecordTypeId</field>
        <lookupValue>Calendar_Based_Host_Requested</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>PEPE: Calendar changd to Requestd layout</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PEPE_PDP_Requested_to_IBC</fullName>
        <description>Update the status to IBC when the arch live event status is requested and gets approved</description>
        <field>Status__c</field>
        <literalValue>Instructor being contacted</literalValue>
        <name>PEPE: PDP: Requested to IBC</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PEPE_PDP_Requested_to_LPBC</fullName>
        <description>Updates the status to LPBC</description>
        <field>Status__c</field>
        <literalValue>Learning Partner being contacted</literalValue>
        <name>PEPE: PDP: Requested to LPBC</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PEPE_PLP_Email_Field_01_Update</fullName>
        <description>This field update is to update the PLP EMail Field 01 based on the TE PLP 031value</description>
        <field>PLP_Email_Field_01__c</field>
        <formula>IF( 
ISPICKVAL(Training_Offering_Id__r.Potential_Learning_Partner_01__c, 'Firefly'), 'pepe_fire_fly@external.cisco.com', 
IF(ISPICKVAL(Training_Offering_Id__r.Potential_Learning_Partner_01__c, 'Fast Lane'), 'pepe_fast_lane@external.cisco.com', 
IF(ISPICKVAL(Training_Offering_Id__r.Potential_Learning_Partner_01__c, '5i'), 'pepe_5i@external.cisco.com', 
IF(ISPICKVAL(Training_Offering_Id__r.Potential_Learning_Partner_01__c, 'Innovise'), 'pepe_innovise@external.cisco.com', 
'pepe-it@cisco.com'
))))</formula>
        <name>PEPE: PLP Email Field 01 Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PEPE_PLP_Email_Field_02_Update</fullName>
        <description>This is to update the PLP Email Field 02 based on the TE PLP 02 value</description>
        <field>PLP_Email_Field_02__c</field>
        <formula>IF( 
ISPICKVAL(Training_Offering_Id__r.Potential_Learning_Partner_02__c, 'Firefly'),'pepe_fire_fly@external.cisco.com', 
IF(ISPICKVAL(Training_Offering_Id__r.Potential_Learning_Partner_02__c, 'Fast Lane'),'pepe_fast_lane@external.cisco.com', 
IF(ISPICKVAL(Training_Offering_Id__r.Potential_Learning_Partner_02__c, '5i'),'pepe_5i@external.cisco.com', 
IF(ISPICKVAL(Training_Offering_Id__r.Potential_Learning_Partner_02__c, 'Innovise'),'pepe_innovise@external.cisco.com', 
'pepe-it@cisco.com'
))))</formula>
        <name>PEPE: PLP Email Field 02 Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PEPE_PLP_Email_Field_03_Update</fullName>
        <description>This field update is to update the PLP EMail Field 03 based on the TE PLP 03 value</description>
        <field>PLP_Email_Field_03__c</field>
        <formula>IF( 
ISPICKVAL(Training_Offering_Id__r.Potential_Learning_Partner_03__c, 'Firefly'), 'pepe_fire_fly@external.cisco.com', 
IF(ISPICKVAL(Training_Offering_Id__r.Potential_Learning_Partner_03__c, 'Fast Lane'), 'pepe_fast_lane@external.cisco.com', 
IF(ISPICKVAL(Training_Offering_Id__r.Potential_Learning_Partner_03__c, '5i'), 'pepe_5i@external.cisco.com', 
IF(ISPICKVAL(Training_Offering_Id__r.Potential_Learning_Partner_03__c, 'Innovise'), 'pepe_innovise@external.cisco.com', 
'pepe-it@cisco.com'
))))</formula>
        <name>PEPE: PLP Email Field 03 Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PEPE_PPL_Added_into_cart_to_Requested</fullName>
        <field>Status__c</field>
        <literalValue>Requested</literalValue>
        <name>PEPE: PPL Added into cart to Requested</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PEPE_PPL_TR_NO_Added_into_to_Requested</fullName>
        <field>Status__c</field>
        <literalValue>Requested</literalValue>
        <name>PEPE: PPL TR NO Added into to Requested</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PEPE_Requested_to_EventApproved</fullName>
        <description>PEPE: Requested to EventApproved status change when remote event is selected and then got approved</description>
        <field>Status__c</field>
        <literalValue>Event Approved</literalValue>
        <name>PEPE: Requested to EventApproved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PEPE_Set_CVENT_Created_Status</fullName>
        <description>This Field updated will set CVENT created status as “Not Started” whenever TR edited</description>
        <field>CI_Created_Status__c</field>
        <literalValue>Not Started</literalValue>
        <name>PEPE: Set CVENT Created Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PEP_Arch_Update_TE_Owner_email</fullName>
        <description>This field update used to populate TE owner's email into TE Owner email field on TR object</description>
        <field>TE_Owner_email__c</field>
        <formula>Training_Offering_Id__r.Owner:User.Email</formula>
        <name>PEP: Arch Update TE Owner email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PPL_Primary_Request_NO_Approved</fullName>
        <field>Status__c</field>
        <literalValue>Approved</literalValue>
        <name>PPL Primary Request NO Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PPL_Rec_Type_Change_PRI_NO_APPROVED</fullName>
        <field>RecordTypeId</field>
        <lookupValue>PPL_Approved_PRIMARY_NO</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>PPL_Rec_Type_Change_PRI_NO_APPROVED</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PPL_Request_Rejected_PRIMARY_NO</fullName>
        <field>RecordTypeId</field>
        <lookupValue>PPL_Request_Rejected_PRIMARY_NO</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>PPL_Request_Rejected_PRIMARY_NO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Proposed_date_to_Actual_Start_date</fullName>
        <field>Actual_Start_Date__c</field>
        <formula>if( ISBLANK(Actual_Start_Date__c) ,Proposed_Start_Date_1__c,Actual_Start_Date__c )</formula>
        <name>Proposed date to Actual Start date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Start_Time</fullName>
        <description>Default time</description>
        <field>Actual_Start_Time__c</field>
        <literalValue>09:00</literalValue>
        <name>Start Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Template_Name</fullName>
        <field>CI_Template_Name__c</field>
        <name>Template Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_the_BLP_Field</fullName>
        <description>The field update on BLP Flag to yes when Delivery team has cisco learning partner</description>
        <field>BLP_Flag__c</field>
        <literalValue>Yes</literalValue>
        <name>Update the BLP Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_the_BLP_Field_to_NO</fullName>
        <description>Update the BLP Field to NO</description>
        <field>BLP_Flag__c</field>
        <literalValue>No</literalValue>
        <name>Update the BLP Field to NO</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <rules>
        <fullName>BLP Payment Status</fullName>
        <actions>
            <name>BLP_Payment_Status_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Send notification to BLPs</description>
        <formula>if(NOT(ISPICKVAL(Training_Offering_Id__r.Potential_Learning_Partner_01__c,''))&amp;&amp;  $User.Id !='00580000007m0VU' &amp;&amp;  ISPICKVAL(Training_Offering_Id__r.Status__c,'Published')  &amp;&amp;  ISPICKVAL( Training_Offering_Id__r.Delivery_Team_new__c ,'Cisco Learning Partner( SKIP BLP WF)')  &amp;&amp;  ISPICKVAL(Status__c,'Event Approved'),True,False)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CventCode_Clear</fullName>
        <actions>
            <name>CventCodeToBeCleared</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CventNameToBeCleared</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CventSesIdToBeCleared</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>PEPE_Training_Request__c.Status__c</field>
            <operation>equals</operation>
            <value>Added into cart,Requested,Instructor being contacted,Event Approved</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>IsClone Record</fullName>
        <actions>
            <name>CventCode</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Template_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>It will update Cvent code if it is cloned record</description>
        <formula>ISCLONE()</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PDP%3A Email Notification to all RLs when TR is Awaiting Requestors Response</fullName>
        <actions>
            <name>PDP_Email_Notification_to_all_RLs_for_ARC_records</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>PEPE_Training_Request__c.Status__c</field>
            <operation>equals</operation>
            <value>Awaiting Requestor's confirmation</value>
        </criteriaItems>
        <criteriaItems>
            <field>PEPE_Training_Request__c.Geography__c</field>
            <operation>equals</operation>
            <value>EMEAR</value>
        </criteriaItems>
        <criteriaItems>
            <field>PEPE_Training_Request__c.PEPE_Record_Type__c</field>
            <operation>equals</operation>
            <value>Catalogue</value>
        </criteriaItems>
        <criteriaItems>
            <field>PEPE_Training_Request__c.Platform__c</field>
            <operation>equals</operation>
            <value>Partner Plus</value>
        </criteriaItems>
        <description>Sends Email Notification to all RLs when TR is Awaiting Requestors Response</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PDP%3A Rec Type Change When Confirmed LPCIP MoreInfo</fullName>
        <actions>
            <name>PDP_RecType_to_LPBC_ARC_MoreInfo</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>PEPE_Training_Request__c.Status__c</field>
            <operation>equals</operation>
            <value>Awaiting Requestor's confirmation,Learning Partner being contacted,More info Needed</value>
        </criteriaItems>
        <criteriaItems>
            <field>PEPE_Training_Request__c.PEPE_Record_Type__c</field>
            <operation>equals</operation>
            <value>Catalogue</value>
        </criteriaItems>
        <criteriaItems>
            <field>PEPE_Training_Request__c.Platform__c</field>
            <operation>equals</operation>
            <value>Partner Plus</value>
        </criteriaItems>
        <description>It will update the record type when status is changed to Confirmed or Learning Partner Confirmation In Progress.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PDP%3A Rec Type Change When Status Approved Or Expired</fullName>
        <actions>
            <name>PDP_RecType_change_to_Approved_Expired</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>It will update the record type when status is Approved Or Expired.</description>
        <formula>(ISPICKVAL( Status__c , 'Event Approved') || ISPICKVAL( Status__c , 'Expired')) &amp;&amp;  ISPICKVAL(Training_Offering_Id__r.Platform__c, 'Partner Plus')</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PDP%3A Rec Type Change When Status Delivered Or Closed</fullName>
        <actions>
            <name>PDP_RecType_change_to_Delivered_Closed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>It will update the record type when status is Delivered  Or Closed.</description>
        <formula>(ISPICKVAL( Status__c, 'Delivered') || ISPICKVAL( Status__c, 'Closed') )&amp;&amp; ISPICKVAL(Training_Offering_Id__r.PEPE_Record_Type__c, 'Catalogue') &amp;&amp; ISPICKVAL(Training_Offering_Id__r.Platform__c, 'Partner Plus')</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PDP%3A Rec Type Change When Status Logistics Confirmed</fullName>
        <actions>
            <name>PDP_RecType_to_Logistics_Confirmed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>PEPE_Training_Request__c.Status__c</field>
            <operation>equals</operation>
            <value>Logistics Confirmed</value>
        </criteriaItems>
        <criteriaItems>
            <field>PEPE_Training_Request__c.PEPE_Record_Type__c</field>
            <operation>equals</operation>
            <value>Catalogue</value>
        </criteriaItems>
        <criteriaItems>
            <field>PEPE_Training_Request__c.Platform__c</field>
            <operation>equals</operation>
            <value>Partner Plus</value>
        </criteriaItems>
        <description>It will update the record type when status is Logistics Confirmed.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PDP%3A Update the Agenda with master Agenda</fullName>
        <actions>
            <name>PDP_Field_Update_to_Agenda</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow is taking up the formula field evaluation on Objectives from master to child.</description>
        <formula>Training_Offering_Id__r.Agenda__c &lt;&gt; '' &amp;&amp;  ISPICKVAL(Status__c, "Added into cart")</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>PDP%3A Update the Geo APJC in Child Record</fullName>
        <actions>
            <name>PDP_Field_Update_to_APJC</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Updates the child record with parent Geography value.</description>
        <formula>ISPICKVAL(Training_Offering_Id__r.Geography__c, 'APJC')</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PDP%3A Update the Geo Americas in Child Record</fullName>
        <actions>
            <name>PDP_Field_Update_to_Americas</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Updates the child record with parent Geography value.</description>
        <formula>ISPICKVAL(Training_Offering_Id__r.Geography__c, 'Americas')</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PDP%3A Update the Geo EMEAR in Child Record</fullName>
        <actions>
            <name>PDP_Field_Update_to_EMEAR</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Updates the child record with parent Geography value.</description>
        <formula>ISPICKVAL(Training_Offering_Id__r.Geography__c, 'EMEAR')</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PDP%3A Update the Objectives with master Objectives</fullName>
        <actions>
            <name>PDP_Field_Update_to_Objectives</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow is taking up the formula field evaluation on Objectives from master to child.</description>
        <formula>Training_Offering_Id__r.Objectives__c &lt;&gt; '' &amp;&amp;  ISPICKVAL(Status__c, "Added into cart")</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>PDP%3A Update the Training Duration Value in Days</fullName>
        <actions>
            <name>PDP_Training_Duration_Unit_to_Days</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PDP_Training_Duration_Value_to_Value</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Updates the child record with parent Training Duration Unit and Value when status is Added into cart</description>
        <formula>ISPICKVAL(Training_Offering_Id__r.Training_Duration_Unit__c, 'Days') &amp;&amp; NOT ( ISNULL(Training_Offering_Id__r.Training_Duration_Value__c))  &amp;&amp;  ISPICKVAL( Status__c, "Added into cart")</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PDP%3A Update the Training Duration Value in Hours</fullName>
        <actions>
            <name>PDP_Training_Duration_Unit_to_Hours</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PDP_Training_Duration_Value_to_Value</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Updates the child record with parent Training Duration Unit and Value when status is Added into cart</description>
        <formula>ISPICKVAL(Training_Offering_Id__r.Training_Duration_Unit__c, 'Hours') &amp;&amp; NOT ( ISBLANK(Training_Offering_Id__r.Training_Duration_Value__c))  &amp;&amp;  ISPICKVAL( Status__c, "Added into cart")</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PDP%3A Update the Training Duration Value in Minutes</fullName>
        <actions>
            <name>PDP_Training_Duration_Unit_to_Minutes</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PDP_Training_Duration_Value_to_Value</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Updates the child record with parent Training Duration Unit and Value when status is Added into cart</description>
        <formula>ISPICKVAL(Training_Offering_Id__r.Training_Duration_Unit__c, 'Minutes') &amp;&amp; NOT ( ISBLANK(Training_Offering_Id__r.Training_Duration_Value__c)) &amp;&amp; ISPICKVAL( Status__c, "Added into cart")</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PDP_Email_TO_Theater_Admins</fullName>
        <actions>
            <name>PDP_Email_Notification_to_Mailer_PP</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>PDP_field_Update_to_Request</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This is for Dec 2016 release for notification to theater wise Admin members</description>
        <formula>TEXT( Training_Offering_Id__r.Platform__c ) = 'Partner Plus' &amp;&amp; TEXT(Geography__c) = 'EMEAR' ||TEXT(Geography__c) = 'APJ' &amp;&amp; TEXT(Status__c) = 'Requested' &amp;&amp; ( ISPICKVAL(PRIORVALUE(Status__c) ,"Added into cart"))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PDP_PPL_Email_Notification_to_TE_Owner</fullName>
        <actions>
            <name>PDP_PPL_Email_Notification_to_TE_Owner_On_Requested</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>PEPE_Training_Request__c.Status__c</field>
            <operation>equals</operation>
            <value>Requested</value>
        </criteriaItems>
        <criteriaItems>
            <field>PEPE_Training_Request__c.Geography__c</field>
            <operation>equals</operation>
            <value>EMEAR,APJ</value>
        </criteriaItems>
        <criteriaItems>
            <field>PEPE_Training_Request__c.Platform__c</field>
            <operation>equals</operation>
            <value>Partner Plus Lounge</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>PDP_PPL_Email_Notification_to_TR_Owner</fullName>
        <actions>
            <name>PDP_PPL_Email_Notification_to_TR_Owner_On_LPBC_ARC</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>PEPE_Training_Request__c.Status__c</field>
            <operation>equals</operation>
            <value>Awaiting Requestor's confirmation,Learning Partner being contacted,Request Rejected</value>
        </criteriaItems>
        <criteriaItems>
            <field>PEPE_Training_Request__c.Geography__c</field>
            <operation>equals</operation>
            <value>EMEAR</value>
        </criteriaItems>
        <criteriaItems>
            <field>PEPE_Training_Request__c.Platform__c</field>
            <operation>equals</operation>
            <value>Partner Plus Lounge</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PDP_PPL_Primary_Request_NO</fullName>
        <actions>
            <name>PDP_PPL_FieldUpdate_Change_PRI_NO</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PDP_PPL_Primary_Request_Status_NO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(TEXT(Country__c) != TEXT(Training_Offering_Id__r.Country__c), Platform__c = 'Partner Plus Lounge',TEXT(Status__c)='Added into cart')</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PDP_PPL_Primary_Request_YES</fullName>
        <actions>
            <name>PDP_PPL_Primary_Request_Status_YES</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>TEXT(Country__c) == TEXT(Training_Offering_Id__r.Country__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PDP_PPL_Rec_Type_Change_EA_LC_Delivered_PRI_YES</fullName>
        <actions>
            <name>PDP_PPL_RecType_changeToEA_LC_Delivered</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 AND 2) AND 3</booleanFilter>
        <criteriaItems>
            <field>PEPE_Training_Request__c.Platform__c</field>
            <operation>equals</operation>
            <value>Partner Plus Lounge</value>
        </criteriaItems>
        <criteriaItems>
            <field>PEPE_Training_Request__c.Status__c</field>
            <operation>equals</operation>
            <value>Event Approved,Logistics Confirmed,Delivered</value>
        </criteriaItems>
        <criteriaItems>
            <field>PEPE_Training_Request__c.Primary_request__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <description>Record Type Changes when Training Request is in Event Approved or Delivered or Logistic confirmed status</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PDP_PPL_Rec_Type_Change_PRI_NO_APPROVED</fullName>
        <actions>
            <name>PPL_Rec_Type_Change_PRI_NO_APPROVED</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>PEPE_Training_Request__c.Platform__c</field>
            <operation>equals</operation>
            <value>Partner Plus Lounge</value>
        </criteriaItems>
        <criteriaItems>
            <field>PEPE_Training_Request__c.Status__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <criteriaItems>
            <field>PEPE_Training_Request__c.Primary_request__c</field>
            <operation>equals</operation>
            <value>No</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PDP_PPL_Rec_Type_Change_PRI_YES</fullName>
        <actions>
            <name>PDP_PPL_RecType_ALL_STATUS_PRI_YES</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 AND 2) AND 3</booleanFilter>
        <criteriaItems>
            <field>PEPE_Training_Request__c.Status__c</field>
            <operation>equals</operation>
            <value>Requestor Cancellation,Request Rejected,Event Cancelled,Learning Partner being contacted,Expired,Awaiting Requestor's confirmation,More info Needed,Event Approved,Delivered</value>
        </criteriaItems>
        <criteriaItems>
            <field>PEPE_Training_Request__c.Platform__c</field>
            <operation>equals</operation>
            <value>Partner Plus Lounge</value>
        </criteriaItems>
        <criteriaItems>
            <field>PEPE_Training_Request__c.Primary_request__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <description>It will update the record type when status is changed to Confirmed or Learning Partner Confirmation In Progress.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PDP_PPL_Update_the_Geo_EMEAR_in_Child_Record</fullName>
        <actions>
            <name>PDP_PPL_Field_Update_to_EMEAR</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Updates the child record with parent Geography value.</description>
        <formula>ISPICKVAL(Training_Offering_Id__r.Geography__c, 'EMEAR')</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PEPE APJ ARCH Email alert at Event Approved</fullName>
        <actions>
            <name>APJ_Arch_Event_Approve_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>notification on Training request when the TR status changed to “Event approved”</description>
        <formula>TEXT( Training_Offering_Id__r.Platform__c ) = 'Architectures' &amp;&amp; TEXT(Geography__c) = 'APJC' &amp;&amp; ISPICKVAL(PRIORVALUE(Status__c), "Awaiting Requestor's confirmation") &amp;&amp; TEXT(Status__c) = 'Event Approved'</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PEPE Arch change on room and propose start date send email alert</fullName>
        <actions>
            <name>PEPE_Arch_send_email_alert_to_admin_host_and_learning_partner_if_applicable_when</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Send email to admin, host, learning partner (if applicable) when the Room Name, Room Name 2, Proposed start date, Proposed start date2 is changed</description>
        <formula>$Profile.Id != $Setup.ProfileID__c.Cisco_ADMIN__c &amp;&amp;  TEXT(Training_Offering_Id__r.Platform__c) == "Architectures" &amp;&amp; OR( ISCHANGED( Room_Name__c ),  ISCHANGED(  Room_Name_2__c ),  ISCHANGED(  Proposed_Start_Date_1__c ),  ISCHANGED(  Proposed_Start_Date_2__c ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PEPE PP Email alert at Event Approved</fullName>
        <actions>
            <name>PEPE_notification_on_Training_request_when_the_TR_status_Approved_to_TE_Owner</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>notification on Training request when the TR status changed to “Event approved”</description>
        <formula>(TEXT( Training_Offering_Id__r.Platform__c ) = 'Partner Plus' &amp;&amp; TEXT(Geography__c) = 'EMEAR' || TEXT(Geography__c) = 'APJC' ) &amp;&amp; (ISPICKVAL(PRIORVALUE(Status__c), "Awaiting Requestor's confirmation") &amp;&amp; TEXT(Status__c) = 'Event Approved')</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PEPE%3A ARCH APJ Default Start%2FEnd Time</fullName>
        <actions>
            <name>End_time</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Start_Time</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5</booleanFilter>
        <criteriaItems>
            <field>PEPE_Training_Request__c.Geography__c</field>
            <operation>equals</operation>
            <value>EMEAR,APJC</value>
        </criteriaItems>
        <criteriaItems>
            <field>PEPE_Training_Request__c.Platform__c</field>
            <operation>equals</operation>
            <value>Architectures</value>
        </criteriaItems>
        <criteriaItems>
            <field>PEPE_Training_Request__c.Status__c</field>
            <operation>equals</operation>
            <value>Instructor being contacted,Requested</value>
        </criteriaItems>
        <criteriaItems>
            <field>PEPE_Training_Request__c.Actual_Start_Time__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>PEPE_Training_Request__c.Actual_End_Time__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>2018 Release</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PEPE%3A ARCH APJ ProposeDate_copy</fullName>
        <actions>
            <name>End_Date_Calculation</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Proposed_date_to_Actual_Start_date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3</booleanFilter>
        <criteriaItems>
            <field>PEPE_Training_Request__c.Geography__c</field>
            <operation>equals</operation>
            <value>EMEAR,APJC</value>
        </criteriaItems>
        <criteriaItems>
            <field>PEPE_Training_Request__c.Platform__c</field>
            <operation>equals</operation>
            <value>Architectures</value>
        </criteriaItems>
        <criteriaItems>
            <field>PEPE_Training_Request__c.Status__c</field>
            <operation>equals</operation>
            <value>Instructor being contacted,Requested</value>
        </criteriaItems>
        <description>2018 Release</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PEPE%3A Arc and PP Set CVENT created status as Not Started whenever TR edited</fullName>
        <actions>
            <name>PEPE_Set_CVENT_Created_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 AND 2 AND 3 ) AND (4 OR 5)</booleanFilter>
        <criteriaItems>
            <field>PEPE_Training_Request__c.CI_CVENT_Flag__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <criteriaItems>
            <field>PEPE_Training_Request__c.CI_Template_Name__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>PEPE_Training_Request__c.CI_Created_Status__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>PEPE_Training_Request__c.Platform__c</field>
            <operation>equals</operation>
            <value>Partner Plus</value>
        </criteriaItems>
        <criteriaItems>
            <field>PEPE_Training_Request__c.Platform__c</field>
            <operation>equals</operation>
            <value>Architectures</value>
        </criteriaItems>
        <description>This Rule will set CVENT created status as Not Started whenever TR edited for Architecture and PP platform</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PEPE%3A Arch LIVE to EventApproved%2FDelivered layout</fullName>
        <actions>
            <name>PEPE_Arch_LIVE_RT_to_Delivered</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This layout is seen when Delivered is seen on ARCH LIVE request record status</description>
        <formula>ISPICKVAL(Training_Offering_Id__r.Platform__c ,'Architectures') &amp;&amp; ISPICKVAL(Training_Offering_Id__r.PEPE_Record_Type__c,'Architecture') &amp;&amp; ( ISPICKVAL(Training_Offering_Id__r.Type_of_Architecture_Event__c, 'Standard Live') || ISPICKVAL(Training_Offering_Id__r.Type_of_Architecture_Event__c, 'Multiple Sessions Live')  )&amp;&amp;  ISPICKVAL(Status__c, 'Event Approved')</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PEPE%3A Arch LIVE to LPBC layout</fullName>
        <actions>
            <name>PEPE_Arch_LIVE_Requested_RT_to_LPBC</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This layout is seen when LPBC is seen on RCH LIVE request record</description>
        <formula>ISPICKVAL(Training_Offering_Id__r.Platform__c ,'Architectures') &amp;&amp; ISPICKVAL(Training_Offering_Id__r.PEPE_Record_Type__c,'Architecture') &amp;&amp; ( ISPICKVAL(Training_Offering_Id__r.Type_of_Architecture_Event__c, 'Standard Live') || ISPICKVAL(Training_Offering_Id__r.Type_of_Architecture_Event__c, 'Multiple Sessions Live') )&amp;&amp;  ISPICKVAL(Status__c, 'Learning Partner being contacted')</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PEPE%3A Arch REMOTE to EventAprroved%2FDelivered layout</fullName>
        <actions>
            <name>PEPE_Arch_REMOTE_to_Delivered</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This layout is seen when Delivered is seen on ARCH REMOTE request record status</description>
        <formula>ISPICKVAL(Training_Offering_Id__r.Platform__c ,'Architectures') &amp;&amp; ISPICKVAL(Training_Offering_Id__r.PEPE_Record_Type__c,'Architecture') &amp;&amp;  ( ISPICKVAL(Training_Offering_Id__r.Type_of_Architecture_Event__c, 'Standard Remote') || ISPICKVAL(Training_Offering_Id__r.Type_of_Architecture_Event__c, 'Multiple Sessions Remote') )&amp;&amp; ISPICKVAL(Status__c, 'Event Approved')</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PEPE%3A Arch REMOTE to LPBC layout</fullName>
        <actions>
            <name>PEPE_Arch_REMOTE_Requested_RT_to_LPBC</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This layout is seen when LPBC is seen on ARCH REMOTE request record</description>
        <formula>ISPICKVAL(Training_Offering_Id__r.Platform__c ,'Architectures') &amp;&amp; ISPICKVAL(Training_Offering_Id__r.PEPE_Record_Type__c,'Architecture') &amp;&amp; ISPICKVAL(Status__c, 'Learning Partner being contacted') &amp;&amp;  ( ISPICKVAL(  Training_Offering_Id__r.Type_of_Architecture_Event__c  , 'Standard Remote') || ISPICKVAL( Training_Offering_Id__r.Type_of_Architecture_Event__c, 'Multiple Sessions Remote') )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PEPE%3A Email Notification to LPs when TR is Learning Partner being contacted</fullName>
        <actions>
            <name>PEPE_Email_Notification_to_LP1_when_status_changed_to_Learning_Partner_being_con</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>PEPE_Email_Notification_to_LP2_when_status_changed_to_Learning_Partner_being_con</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>PEPE_Email_Notification_to_LP3_when_status_changed_to_Learning_Partner_being_con</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Sends Email Notification to LPs when TR is 'Learning Partner being contacted'</description>
        <formula>TEXT(Training_Offering_Id__r.Platform__c) = 'Partner Plus' || 
( 
TEXT(Training_Offering_Id__r.Platform__c) = 'Architectures' &amp;&amp;
IF(INCLUDES(Training_Offering_Id__r.Delivery_Team__c, 'Cisco Learning Partner'), TRUE, FALSE) 
)
&amp;&amp; 
(TEXT(Status__c) = 'Learning Partner being contacted' || 
TEXT(Status__c) = 'Instructor being contacted') 
&amp;&amp; 
TEXT(Geography__c) = 'EMEAR' 
&amp;&amp; 
( 
 (PLP_Email_Field_01__c!='')
||
 (PLP_Email_Field_02__c!='')
||
 (PLP_Email_Field_03__c!='')
)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>PEPE_Arch Update TE Owner email</fullName>
        <actions>
            <name>PEP_Arch_Update_TE_Owner_email</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This rule is used to update TE Owner email while creating new TR</description>
        <formula>1=1</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>PPL_Request_Rejected_PRIMARY_NO</fullName>
        <actions>
            <name>PPL_Request_Rejected_PRIMARY_NO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 AND 3) AND 2</booleanFilter>
        <criteriaItems>
            <field>PEPE_Training_Request__c.Status__c</field>
            <operation>equals</operation>
            <value>Request Rejected</value>
        </criteriaItems>
        <criteriaItems>
            <field>PEPE_Training_Request__c.Primary_request__c</field>
            <operation>equals</operation>
            <value>No</value>
        </criteriaItems>
        <criteriaItems>
            <field>PEPE_Training_Request__c.Platform__c</field>
            <operation>equals</operation>
            <value>Partner Plus Lounge</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update the BLP Flag based on Delivery team</fullName>
        <actions>
            <name>Update_the_BLP_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If TE.Delivery Team contains 'Cisco Learning Partner'default set BLP flag = "Yes" else "No"</description>
        <formula>AND(ISPICKVAL(Training_Offering_Id__r.Delivery_Team_new__c,'Cisco Learning Partner'),OR(ISPICKVAL(Training_Offering_Id__r.Platform__c,'Architectures'),ISPICKVAL(Training_Offering_Id__r.Platform__c,'Partner Plus'),ISPICKVAL(Status__c, 'Added into cart')))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update the BLP Flag based on Delivery team to NO</fullName>
        <actions>
            <name>Update_the_BLP_Field_to_NO</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If TE.Delivery Team contains 'Cisco Learning Partner'default set BLP flag = "Yes" else "No"</description>
        <formula>NOT(IF(ISPICKVAL(Training_Offering_Id__r.Delivery_Team_new__c, 'Cisco Learning Partner'), TRUE, FALSE))&amp;&amp; ISPICKVAL(  Training_Offering_Id__r.Platform__c, 'Architectures' )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
