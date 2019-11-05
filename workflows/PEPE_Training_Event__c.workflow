<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>PDP_Email_Notification_to_all_RLs_for_published_records</fullName>
        <description>PDP: Email Notification to all RLs for published records</description>
        <protected>false</protected>
        <recipients>
            <recipient>PDP_PP_Regional_Leads_EMEAR</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PDP/PDP_Email_Notification_to_RLs_for_Published_offering</template>
    </alerts>
    <alerts>
        <fullName>PDP_PLED_ARC_Submits_to_PLED_Admin_APJ</fullName>
        <ccEmails>apj-pepe-archadmi@cisco.com</ccEmails>
        <description>PDP: PLED ARC Submits to PLED Admin APJ</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>PEPE_Email_Template_Notifications/PEPE_ARCH_APJ_Admin_notification_on_TE_Submit</template>
    </alerts>
    <alerts>
        <fullName>PDP_PLED_PIW_Submits_to_PLED_Admin_APJ</fullName>
        <ccEmails>apj-pepe-piwadmin@cisco.com</ccEmails>
        <description>PDP: PLED PIW Submits to PLED Admin APJ</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>PEPE_Email_Template_Notifications/PEPE_PIW_APJ_Admin_notification_on_TE_Submit</template>
    </alerts>
    <alerts>
        <fullName>PDP_PPL_Email_Notification_to_all_RLs_for_published_records</fullName>
        <description>PDP_PPL_Email_Notification_to_all_RLs_for_published_records</description>
        <protected>false</protected>
        <recipients>
            <field>First_Requestor_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Second_Requestor_Email__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Third_Requestor_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PEPE_Email_Template_Notifications/PDP_PPL_Email_Notification_to_RLs_for_Published_offering</template>
    </alerts>
    <alerts>
        <fullName>PEPE_APJ_ARCH_EMEAR_Admins_to_ARCH_ADMINS_on_TE_Published</fullName>
        <ccEmails>apj-pepe-archadmin@cisco.com</ccEmails>
        <description>PEPE: APJ ARCH EMEAR Admins to ARCH ADMINS on TE Published</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>PEPE_Email_Template_Notifications/PEPE_ARCH_APJ_Admin_notifies_on_TE_published</template>
    </alerts>
    <alerts>
        <fullName>PEPE_ARCH_EMEAR_Admins_to_ARCH_ADMINS_on_TE_Published</fullName>
        <ccEmails>emear-pepe-archadmin@cisco.com</ccEmails>
        <description>PEPE: ARCH EMEAR Admins to ARCH ADMINS on TE Published</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>PEPE_Email_Template_Notifications/PEPE_ARCH_EMEAR_Admin_notifies_country_hosts_on_TE_published</template>
    </alerts>
    <alerts>
        <fullName>PEPE_Email_Notification_to_all_APJC_SMEs_for_published_TE_recs_for_booking_Sessi</fullName>
        <description>PEPE: Email Notification to all APJC SMEs for published TE recs for booking SessionSlots</description>
        <protected>false</protected>
        <recipients>
            <recipient>PEPE_Leads_Hosts_SMEs_APJC</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PEPE_Email_Template_Notifications/PEPE_Notification_sent_to_PIW_EMEAR_SMEs_when_slots_are_setup_published</template>
    </alerts>
    <alerts>
        <fullName>PEPE_Email_Notification_to_all_EMEAR_SMEs_for_published_TE_records_for_booking_S</fullName>
        <description>PEPE: Email Notification to all EMEAR SMEs for published TE records for booking Session Slots</description>
        <protected>false</protected>
        <recipients>
            <recipient>PEPE_SME_PIW_EMEAR_for_SMEs</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PEPE_Email_Template_Notifications/PEPE_Notification_sent_to_PIW_EMEAR_SMEs_when_slots_are_setup_published</template>
    </alerts>
    <alerts>
        <fullName>PEPE_PIW_APJ_on_TE_Published</fullName>
        <ccEmails>apj-pepe-piwadmin@cisco.com</ccEmails>
        <description>PEPE: PIW APJ  on TE Published</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>PEPE_Email_Template_Notifications/PEPE_PIW_APJ_Admin_notifies_on_TE_published</template>
    </alerts>
    <alerts>
        <fullName>PEPE_PIW_EMEAR_Admins_to_ARCH_ADMINS_on_TE_Published</fullName>
        <ccEmails>apj-pepe-piwadmin@cisco.com</ccEmails>
        <description>PEPE: PIW EMEAR Admins to ARCH ADMINS on TE Published</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>PEPE_Email_Template_Notifications/PEPE_ARCH_EMEAR_Admin_notifies_country_hosts_on_TE_published</template>
    </alerts>
    <alerts>
        <fullName>PEPE_PVT_APJC_Admins_to_Hosts_on_TE_published</fullName>
        <description>PEPE: PVT APJC Admins to Hosts on TE published</description>
        <protected>false</protected>
        <recipients>
            <recipient>PEPE_Leads_Hosts_SMEs_APJC</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PEPE_Email_Template_Notifications/PEPE_PVT_EMEAR_Admin_notifies_country_hosts_on_TE_published</template>
    </alerts>
    <alerts>
        <fullName>PEPE_PVT_ARCH_EMAIL_ALERT_for_cancellation</fullName>
        <description>PEPE: PVT/ARCH EMAIL ALERT for cancellation</description>
        <protected>false</protected>
        <recipients>
            <recipient>PEPE_CAL_PVT_Admins_EMEAR</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PEPE_Email_Template_Notifications/PEPE_ARCH_for_cancellation_of_the_requestor_rejection</template>
    </alerts>
    <alerts>
        <fullName>PEPE_PVT_EMEAR_Admins_to_PVT_ARCH_Hosts_on_TE_published</fullName>
        <ccEmails>emear-pepe-pvtadmin@cisco.com</ccEmails>
        <description>PEPE: PVT EMEAR Admins to PVT Hosts on TE published</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PEPE_Email_Template_Notifications/PEPE_PVT_EMEAR_Admin_notifies_country_hosts_on_TE_published</template>
    </alerts>
    <fieldUpdates>
        <fullName>CventCode</fullName>
        <description>Update cvent code when its cloned</description>
        <field>CVENT_Code__c</field>
        <name>CventCode</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CventCodeToBeCleared</fullName>
        <field>CVENT_Code__c</field>
        <name>CventCodeToBeCleared</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PDP_PPL_RecType_to_Logistics_Withdrawn</fullName>
        <field>RecordTypeId</field>
        <lookupValue>PPL_Read_Only</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>PDP_PPL_RecType_to_Logistics_Withdrawn</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PDP_PPL_RecordType_Change_When_Published</fullName>
        <description>It will update the record type when status is changed from Submitted to Published.</description>
        <field>RecordTypeId</field>
        <lookupValue>PPL_Only_Status_and_GnD</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>PDP:PPL RecordType Change When Published</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PDP_PPL_Record_Type_When_Submitted</fullName>
        <description>It will update the record type when status is changed from Created to Submitted.</description>
        <field>RecordTypeId</field>
        <lookupValue>PPL_Editable</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>PDP_PPL_Record_Type_When_Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PDP_PPL_Status_to_published</fullName>
        <field>Status__c</field>
        <literalValue>Published</literalValue>
        <name>PDP: PPL Status to published</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PDP_PPL_Status_to_submitted</fullName>
        <field>Status__c</field>
        <literalValue>Submitted</literalValue>
        <name>PDP: PPL Status to submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PDP_PPL_Submitted_to_Deleted</fullName>
        <field>Status__c</field>
        <literalValue>Deleted</literalValue>
        <name>PDP:PPL Submitted to Deleted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PDP_RecType_to_Logistics_Withdrawn</fullName>
        <description>It will update the record type to Withdrawn.</description>
        <field>RecordTypeId</field>
        <lookupValue>All_Read_Only</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>PDP: RecType to Logistics Withdrawn</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PDP_Record_Type_Change_When_Published</fullName>
        <description>It will update the record type when status is changed from Submitted to Published.</description>
        <field>RecordTypeId</field>
        <lookupValue>Only_Status_and_GnD</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>PDP: Record Type Change When Published</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PDP_Record_Type_When_Submitted</fullName>
        <description>It will update the record type when status is changed from Created to Submitted.</description>
        <field>RecordTypeId</field>
        <lookupValue>All_Editable</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>PDP: Record Type When Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PDP_Status_to_published</fullName>
        <field>Status__c</field>
        <literalValue>Published</literalValue>
        <name>PDP: Status to published</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PDP_Status_to_submitted</fullName>
        <field>Status__c</field>
        <literalValue>Submitted</literalValue>
        <name>PDP: Status to submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PDP_Submitted_to_Deleted</fullName>
        <field>Status__c</field>
        <literalValue>Deleted</literalValue>
        <name>PDP: Submitted to Deleted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PEPE_Arch_Published_recordtype_change</fullName>
        <description>This is used for rec type change on published status</description>
        <field>RecordTypeId</field>
        <lookupValue>Architechture_Published</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>PEPE: Arch Published recordtype change</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PEPE_Arch_Submitted_recordtype_change</fullName>
        <description>this is to change the recordtype when status is submitted.</description>
        <field>RecordTypeId</field>
        <lookupValue>Architechture_Submitted_02</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>PEPE: Arch Submitted recordtype change</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PEPE_CAL_RecType_Change_When_Published</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Calendar_Published_RT</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>PEPE:CAL_RecType Change When Published</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PEPE_Company_value_to_CISCO_for_PVT</fullName>
        <description>Company field is equal to Cisco for PVT TEs</description>
        <field>Company__c</field>
        <formula>"Cisco"</formula>
        <name>PEPE: Company value to CISCO for PVT</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PEPE_PVT_Submitted_change_RecordType</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Calendar_Submitted_RT</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>PEPE: PVT Submitted change RecordType</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PEPE_RecordType_unchanged</fullName>
        <field>RecordTypeId</field>
        <lookupValue>PIW</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>PEPE:RecordType unchanged</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PEPE_Record_Type_Change_When_Approved</fullName>
        <field>RecordTypeId</field>
        <lookupValue>PIW_Published</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>PEPE: Record Type Change When Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PEPE_Record_Type_Change_When_Published</fullName>
        <description>It will update the record type when status is changed from Submitted to Published.</description>
        <field>RecordTypeId</field>
        <lookupValue>PIW_Published</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>PEPE:Record Type Change When Published</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PEPE_Set_CVENT_Created_Status_on_TE</fullName>
        <description>This Field updated will set CVENT created status as “Not Started” whenever TE edited for PVT and PIW</description>
        <field>CI_Created_Status__c</field>
        <literalValue>Not Started</literalValue>
        <name>PEPE: Set CVENT Created Status on TE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PEPE_Title_value_to_Learning_Partner</fullName>
        <description>For PVT TE events, Title field values are set to "Learning Partner"</description>
        <field>Title__c</field>
        <formula>"Program Specialist"</formula>
        <name>PEPE: Title value to Learning Partner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Template_Name</fullName>
        <field>CI_Template_Name__c</field>
        <name>Template Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Arch APJ TE is published send email if send admin is YES</fullName>
        <actions>
            <name>PEPE_APJ_ARCH_EMEAR_Admins_to_ARCH_ADMINS_on_TE_Published</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Arch TE is published send email if send to admin is YES</description>
        <formula>AND ((TEXT( Platform__c) == 'Architectures' ),  (TEXT( Status__c) =='Published') ,(TEXT( Geography__c)== 'APJC' ), (TEXT( Send_Notification__c)== 'Yes' ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Arch TE is published send email if send admin is YES</fullName>
        <actions>
            <name>PEPE_ARCH_EMEAR_Admins_to_ARCH_ADMINS_on_TE_Published</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Arch TE is published send email if send to admin is YES</description>
        <formula>AND ((TEXT( Platform__c) == 'Architectures' ),  (TEXT( Status__c) =='Published') , (TEXT( Geography__c)== 'EMEAR' ) , (TEXT( Send_Notification__c)== 'Yes' ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CventCode_Clear</fullName>
        <actions>
            <name>CventCodeToBeCleared</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>PEPE_Training_Event__c.Status__c</field>
            <operation>equals</operation>
            <value>Created</value>
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
        <formula>ISCLONE()</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PDP%3A Email Notification to all RLs for published records</fullName>
        <actions>
            <name>PDP_Email_Notification_to_all_RLs_for_published_records</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>PEPE_Training_Event__c.Status__c</field>
            <operation>equals</operation>
            <value>Published</value>
        </criteriaItems>
        <criteriaItems>
            <field>PEPE_Training_Event__c.Regional_Lead_Notification__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <criteriaItems>
            <field>PEPE_Training_Event__c.PEPE_Record_Type__c</field>
            <operation>equals</operation>
            <value>Catalogue</value>
        </criteriaItems>
        <criteriaItems>
            <field>PEPE_Training_Event__c.Platform__c</field>
            <operation>equals</operation>
            <value>Partner Plus</value>
        </criteriaItems>
        <description>PLED allows email notification to send to all regional leads for published records. Or else, it won't notify regional leads on published records.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PDP%3A Rec Type Change When Status Withdrawal  or Deleted</fullName>
        <actions>
            <name>PDP_RecType_to_Logistics_Withdrawn</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>PEPE_Training_Event__c.Status__c</field>
            <operation>equals</operation>
            <value>Deleted,Withdrawn</value>
        </criteriaItems>
        <criteriaItems>
            <field>PEPE_Training_Event__c.Platform__c</field>
            <operation>equals</operation>
            <value>Partner Plus,Architectures</value>
        </criteriaItems>
        <criteriaItems>
            <field>PEPE_Training_Event__c.PEPE_Record_Type__c</field>
            <operation>equals</operation>
            <value>Catalogue</value>
        </criteriaItems>
        <description>It will update the record type when status is Withdrawn or Deleted.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PDP_PPL_Email_Notification_to_all_RLs_for_published_records</fullName>
        <actions>
            <name>PDP_PPL_Email_Notification_to_all_RLs_for_published_records</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>PEPE_Training_Event__c.Status__c</field>
            <operation>equals</operation>
            <value>Published</value>
        </criteriaItems>
        <criteriaItems>
            <field>PEPE_Training_Event__c.Regional_Lead_Notification__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <criteriaItems>
            <field>PEPE_Training_Event__c.Platform__c</field>
            <operation>equals</operation>
            <value>Partner Plus Lounge</value>
        </criteriaItems>
        <description>PLED allows email notification to send to all regional leads for published records. Or else, it won't notify regional leads on published records.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PDP_PPL_Rec_Type_Change_When_Status_Withdrawan_or_Deleted</fullName>
        <actions>
            <name>PDP_PPL_RecType_to_Logistics_Withdrawn</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>PEPE_Training_Event__c.Status__c</field>
            <operation>equals</operation>
            <value>Deleted,Withdrawn</value>
        </criteriaItems>
        <criteriaItems>
            <field>PEPE_Training_Event__c.Platform__c</field>
            <operation>equals</operation>
            <value>Partner Plus Lounge</value>
        </criteriaItems>
        <description>It will update the record type when status is Withdrawn or Deleted.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PDP_PPL_Rec_Type_Change_When_Submitted</fullName>
        <actions>
            <name>PDP_PPL_Record_Type_When_Submitted</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>PEPE_Training_Event__c.Status__c</field>
            <operation>equals</operation>
            <value>Submitted</value>
        </criteriaItems>
        <criteriaItems>
            <field>PEPE_Training_Event__c.Platform__c</field>
            <operation>equals</operation>
            <value>Partner Plus Lounge</value>
        </criteriaItems>
        <description>It will update the calendar based record type when status is Submitted</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PEPE%3A Calendar Rec Type Change When Submitted</fullName>
        <actions>
            <name>PEPE_PVT_Submitted_change_RecordType</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>PEPE_Training_Event__c.Status__c</field>
            <operation>equals</operation>
            <value>Submitted</value>
        </criteriaItems>
        <criteriaItems>
            <field>PEPE_Training_Event__c.PEPE_Record_Type__c</field>
            <operation>equals</operation>
            <value>Calendar</value>
        </criteriaItems>
        <description>It will update the calendar based record type when status is Submitted</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PEPE%3A Catalogue Rec Type Change When Submitted</fullName>
        <actions>
            <name>PDP_Record_Type_When_Submitted</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>PEPE_Training_Event__c.Status__c</field>
            <operation>equals</operation>
            <value>Submitted</value>
        </criteriaItems>
        <criteriaItems>
            <field>PEPE_Training_Event__c.PEPE_Record_Type__c</field>
            <operation>equals</operation>
            <value>Catalogue</value>
        </criteriaItems>
        <criteriaItems>
            <field>PEPE_Training_Event__c.Platform__c</field>
            <operation>equals</operation>
            <value>Partner Plus</value>
        </criteriaItems>
        <description>It will update the calendar based record type when status is Submitted</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PEPE%3A Company and Title field values are default for PVT</fullName>
        <actions>
            <name>PEPE_Company_value_to_CISCO_for_PVT</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PEPE_Title_value_to_Learning_Partner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>PEPE_Training_Event__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>PVT,Calendar_Submitted_RT,Calendar Published RT</value>
        </criteriaItems>
        <description>Theses are hidden from the layout. But the values are determined for PVT in default and backend.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PEPE%3A Notification to PVT Country Hosts when PVT TE Published</fullName>
        <actions>
            <name>PEPE_PVT_EMEAR_Admins_to_PVT_ARCH_Hosts_on_TE_published</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>PEPE_Training_Event__c.Status__c</field>
            <operation>equals</operation>
            <value>Published</value>
        </criteriaItems>
        <criteriaItems>
            <field>PEPE_Training_Event__c.PEPE_Record_Type__c</field>
            <operation>equals</operation>
            <value>Calendar</value>
        </criteriaItems>
        <criteriaItems>
            <field>PEPE_Training_Event__c.Platform__c</field>
            <operation>equals</operation>
            <value>PVT</value>
        </criteriaItems>
        <criteriaItems>
            <field>PEPE_Training_Event__c.Send_Notification__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <description>This is used for sending email alert to both pvt based country hosts when TE of PVT calendar based is published</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PEPE%3A PVT and PIW Set CVENT created status as Not Started whenever TE edited</fullName>
        <actions>
            <name>PEPE_Set_CVENT_Created_Status_on_TE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 AND 2 AND 3) AND (4 OR 5)</booleanFilter>
        <criteriaItems>
            <field>PEPE_Training_Event__c.CVENT_Flag__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <criteriaItems>
            <field>PEPE_Training_Event__c.CI_Template_Name__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>PEPE_Training_Event__c.CI_Created_Status__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>PEPE_Training_Event__c.Platform__c</field>
            <operation>equals</operation>
            <value>PVT</value>
        </criteriaItems>
        <criteriaItems>
            <field>PEPE_Training_Event__c.Platform__c</field>
            <operation>equals</operation>
            <value>PIW</value>
        </criteriaItems>
        <description>This Rule will set CVENT created status as Not Started whenever TE edited for PVT and PIW platform</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PIW TE is published send email if send admin is YES</fullName>
        <actions>
            <name>PEPE_PIW_APJ_on_TE_Published</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>PIW TE is published send email if send to admin is YES</description>
        <formula>AND ((TEXT( Platform__c) == 'PIW' ),  (TEXT( Status__c) =='Published') , TEXT( Geography__c)== 'APJC', (TEXT(  PIW_Send_Notification__c )== 'Yes' ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
