<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>PEPE_APJ_ARCH_SS_host_detail_section_updates_changes_notifies_the_ARCH_ADMIN_TEA</fullName>
        <ccEmails>apj-pepe-archadmin@cisco.com</ccEmails>
        <description>PEPE: APJ ARCH_SS host detail section updates/changes notifies the ARCH ADMIN TEAM</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>PEPE_Email_Template_Notifications/PEPE_APJ_ARCH_SS_Host_Section_changes_notifies_ARCH_ADMIN_TEAM</template>
    </alerts>
    <alerts>
        <fullName>PEPE_ARCH_SS_host_detail_section_updates_changes_notifies_the_ARCH_ADMIN_TEAM</fullName>
        <description>PEPE: ARCH_SS host detail section updates/changes notifies the ARCH ADMIN TEAM</description>
        <protected>false</protected>
        <recipients>
            <recipient>PEPE_ARCH_EMEAR_ADMIN</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PEPE_Email_Template_Notifications/PEPE_ARCH_SS_Host_Section_changes_notifies_ARCH_ADMIN_TEAM</template>
    </alerts>
    <alerts>
        <fullName>PEPE_Email_Notification_to_APJ_SME_when_booked_Session_Slot_has_been_approved_by</fullName>
        <ccEmails>apj-pepe-piwadmin@cisco.com</ccEmails>
        <description>PEPE_Email Notification to APJ SME when booked Session Slot has been approved by PIW Admin</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>PEPE_Email_Template_Notifications/PEPE_APJ_PIW_Admin_sends_Session_Slot_booked_approval_notification_to_SMEs</template>
    </alerts>
    <alerts>
        <fullName>PEPE_Email_Notification_to_SME_when_booked_Session_Slot_has_been_approved_by_PIW</fullName>
        <ccEmails>pepe-piw-admin@cisco.com</ccEmails>
        <description>PEPE_Email Notification to SME when booked Session Slot has been approved by PIW Admin</description>
        <protected>false</protected>
        <recipients>
            <field>SME_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PEPE_Email_Template_Notifications/PEPE_PIW_Admin_sends_Session_Slot_booked_approval_notification_to_SMEs</template>
    </alerts>
    <alerts>
        <fullName>PEPE_Email_Notification_to_SME_when_booked_Session_Slot_has_been_rejected_by_PIW</fullName>
        <description>PEPE_Email Notification to SME when booked Session Slot has been rejected by PIW Admin</description>
        <protected>false</protected>
        <recipients>
            <field>SME_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PEPE_Email_Template_Notifications/PEPE_PIW_Admin_sends_Session_Slot_booked_decline_notification_to_SMEs</template>
    </alerts>
    <alerts>
        <fullName>PEPE_Email_Notification_to_all_APJ_SMEs_when_New_Session_slot_created_for_publis</fullName>
        <ccEmails>apj-pepe-piwadmin@cisco.com</ccEmails>
        <description>PEPE_Email Notification to all APJ SMEs when New Session slot created for published Training Event</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>PEPE_Email_Template_Notifications/PEPE_APJ_PIW_Session_slot_Event_Approve</template>
    </alerts>
    <alerts>
        <fullName>PEPE_Email_Notification_to_all_EMEAR_Admins_when_Session_Slot_has_been_submitted</fullName>
        <description>PEPE: Email Notification to all EMEAR Admins when Session Slot has been submitted for approval by PIW SME</description>
        <protected>false</protected>
        <recipients>
            <recipient>PEPE_SME_PIW_EMEAR_Admin_Group</recipient>
            <type>group</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PEPE_Email_Template_Notifications/PEPE_SMEs_sends_Session_Slot_booking_submission_notification_to_PIW_Admin</template>
    </alerts>
    <alerts>
        <fullName>PEPE_Email_Notification_to_all_EMEAR_SMEs_when_New_Session_slot_created_for_publ</fullName>
        <ccEmails>pepe-piw-admin@cisco.com</ccEmails>
        <description>PEPE_Email Notification to all EMEAR SMEs when New Session slot created for published Training Event</description>
        <protected>false</protected>
        <recipients>
            <field>SME_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PEPE_Email_Template_Notifications/PEPE_Notification_sent_to_PIW_EMEAR_SMEs_when_slots_are_setup_published</template>
    </alerts>
    <alerts>
        <fullName>PEPE_PIW_Session_slot_is_modified_edited_for_review_on_Published_Event_1</fullName>
        <ccEmails>PEPE-PIW-ADMIN@cisco.com</ccEmails>
        <description>PEPE_PIW Session slot is modified_or_edited for review on Published Event</description>
        <protected>false</protected>
        <recipients>
            <field>SME_Email__c</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>PEPE_Email_Template_Notifications/PEPE_PIW_Session_slot_is_modified_edited_for_review_on_Published_Event</template>
    </alerts>
    <fieldUpdates>
        <fullName>DefaultTheater</fullName>
        <field>Theater_Region__c</field>
        <literalValue>All Theaters</literalValue>
        <name>Default Theater</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PEPE_PIW_Update_modified_emaild</fullName>
        <description>This email field will have modifier email id</description>
        <field>SME_Email__c</field>
        <formula>LastModifiedBy.Email</formula>
        <name>PEPE: PIW Update modified emaild</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PEPE_RecType_to_PIW</fullName>
        <description>This will change record type to PIW.</description>
        <field>RecordTypeId</field>
        <lookupValue>PIW</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>PEPE: RecType to PIW</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PEPE_RecType_to_PIW_Approved_Reject</fullName>
        <description>This field update will change the record type to PIW approved Rejected.</description>
        <field>RecordTypeId</field>
        <lookupValue>PIW_Approved_Rejected</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>PEPE: RecType to PIW Approved Reject</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PEPE_SS_TE_Name_autopoulated_backend</fullName>
        <description>This field update acts as formula field but used for searchable and is a external field.</description>
        <field>Training_Event_Name__c</field>
        <formula>Training_Event__r.Name</formula>
        <name>PEPE: SS TE Name autopoulated backend</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PEPE_Status_changed_to_Approved</fullName>
        <description>This will update the status to Approved.</description>
        <field>Status__c</field>
        <literalValue>Approved</literalValue>
        <name>PEPE: Status changed to Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PEPE_Status_changed_to_Rejected</fullName>
        <description>This will update the status to Rejected.</description>
        <field>Status__c</field>
        <literalValue>Rejected</literalValue>
        <name>PEPE: Status changed to Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PEPE_Status_changed_to_Submitted</fullName>
        <description>This will update the status to Submitted.</description>
        <field>Status__c</field>
        <literalValue>Submitted</literalValue>
        <name>PEPE: Status changed to Submitted</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PublishToCal</fullName>
        <description>Sep 2018 changes, updating value of publish to calendar</description>
        <field>Publish_to_Calendar__c</field>
        <literalValue>Yes</literalValue>
        <name>PublishToCal</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PublishToCalendarNo</fullName>
        <field>Publish_to_Calendar__c</field>
        <literalValue>No</literalValue>
        <name>PublishToCalendarNo</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PublishToCalenderYes</fullName>
        <field>Publish_to_Calendar__c</field>
        <literalValue>Yes</literalValue>
        <name>PublishToCalenderYes</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>PEPE%3A APJ ARC_SS host details changes updates notifies ARCH ADMIN TEAM</fullName>
        <actions>
            <name>PEPE_APJ_ARCH_SS_host_detail_section_updates_changes_notifies_the_ARCH_ADMIN_TEA</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>When a session slot is updated by host and is sent and email notification to admin team(APJC).</description>
        <formula>ISPICKVAL( Training_Event__r.Platform__c, 'Architectures') &amp;&amp;  ISPICKVAL(Theater_Super_Regions_Geography__c,'APJC' ) &amp;&amp; ( ISPICKVAL( Training_Event__r.Type_of_Architecture_Event__c, 'Multiple Sessions Live' ) || ISPICKVAL( Training_Event__r.Type_of_Architecture_Event__c, 'Multiple Sessions Remote' ) ) &amp;&amp;  (  ISCHANGED(Language__c ) ||  ISCHANGED(Do_you_want__c ) ||  ISCHANGED(Room_Name_ARCH__c )||  ISCHANGED( Theater_Region__c )||   ISCHANGED( Theater_Super_Regions_Geography__c )|| ISCHANGED( Country_ARCH__c )|| ISCHANGED( ZIP_Code_ARCH__c )|| ISCHANGED( Address_1_ARCH__c ) || ISCHANGED( Address_2_ARCH__c ) || ISCHANGED(  Address_3__c ) || ISCHANGED(  Location__c  )  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PEPE%3A ARC_SS host details changes updates notifies ARCH ADMIN TEAM</fullName>
        <actions>
            <name>PEPE_ARCH_SS_host_detail_section_updates_changes_notifies_the_ARCH_ADMIN_TEAM</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>When a session slot is updated by host and is sent and email notification to admin team.</description>
        <formula>ISPICKVAL( Training_Event__r.Platform__c, 'Architectures') &amp;&amp;  ISPICKVAL(Theater_Super_Regions_Geography__c,'EMEAR' ) &amp;&amp; ( ISPICKVAL( Training_Event__r.Type_of_Architecture_Event__c, 'Multiple Sessions Live' ) || ISPICKVAL( Training_Event__r.Type_of_Architecture_Event__c, 'Multiple Sessions Remote' ) ) &amp;&amp;  (  ISCHANGED(Language__c ) ||  ISCHANGED(Do_you_want__c ) ||  ISCHANGED(Room_Name_ARCH__c )||  ISCHANGED( Theater_Region__c )||   ISCHANGED( Theater_Super_Regions_Geography__c )|| ISCHANGED( Country_ARCH__c )|| ISCHANGED( ZIP_Code_ARCH__c )|| ISCHANGED( Address_1_ARCH__c ) || ISCHANGED( Address_2_ARCH__c ) || ISCHANGED(  Address_3__c ) || ISCHANGED(  Location__c  )  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PEPE%3A PIW REc Type change when status Created</fullName>
        <actions>
            <name>PEPE_RecType_to_PIW</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This will change the status field to Created.</description>
        <formula>ISCHANGED( Status__c ) &amp;&amp;  ISPICKVAL( Status__c ,"Created")</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PEPE%3A Session Slots Updates backend Training Event Name</fullName>
        <actions>
            <name>PEPE_SS_TE_Name_autopoulated_backend</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This WF is used for updating the backend column Training Event Name</description>
        <formula>ISNEW() ||  NOT(ISNEW())</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PEPE_EmailNotification to APJ PIW SMEs when New Session Slot Created for PIW Published Event</fullName>
        <actions>
            <name>PEPE_Email_Notification_to_all_APJ_SMEs_when_New_Session_slot_created_for_publis</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>This process will send Email Notification to PIW SMEs when a new Session slot has been created for a Published APJ PIW TE. SME EMAIL 01</description>
        <formula>ISPICKVAL(Training_Event__r.Status__c,  'Published')  &amp;&amp; ( RecordType.Name ='PIW' || RecordType.Name = 'PIW Approved Rejected'  ) &amp;&amp; TEXT( Status__c ) == 'Created' &amp;&amp; TEXT( Training_Event__r.PIW_Send_Notification__c ) == 'Yes' &amp;&amp;  ISPICKVAL(Theater_Super_Regions_Geography__c,'APJC')</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PEPE_EmailNotification to PIW SMEs when New Session Slot Created for PIW Published Event</fullName>
        <actions>
            <name>PEPE_Email_Notification_to_all_EMEAR_SMEs_when_New_Session_slot_created_for_publ</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>This process will send Email Notification to PIW SMEs when a new Session slot has been created for a Published PIW TE. SME EMAIL 01</description>
        <formula>ISPICKVAL(Training_Event__r.Status__c,  'Published')  &amp;&amp; ( RecordType.Name ='PIW' || RecordType.Name = 'PIW Approved Rejected'  ) &amp;&amp; TEXT( Status__c ) == 'Created' &amp;&amp; TEXT( Training_Event__r.PIW_Send_Notification__c ) == 'Yes' &amp;&amp;  ISPICKVAL(Theater_Super_Regions_Geography__c,'EMEAR')</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>PEPE_PIW Session slot is modified_or_edited for review on Published Event SME EMAIL 03</fullName>
        <actions>
            <name>PEPE_PIW_Session_slot_is_modified_edited_for_review_on_Published_Event_1</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>PIW Session slot is modified/edited for review on Published Event</description>
        <formula>TEXT( Training_Event__r.PIW_Send_Notification__c ) == 'Yes'  &amp;&amp; ISPICKVAL(Theater_Super_Regions_Geography__c,'EMEAR') &amp;&amp; (RecordType.Name == 'PIW' ||  RecordType.Name == 'PIW Approved Rejected') &amp;&amp; TEXT( Training_Event__r.Status__c ) == 'Published' &amp;&amp;  ( TEXT(Status__c)== 'Approved' || TEXT(Status__c) == 'Delivered'  ) &amp;&amp; TEXT(PRIORVALUE(Status__c))== TEXT(Status__c) &amp;&amp; PRIORVALUE( LastModifiedById ) &lt;&gt; LastModifiedById</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PIW_Publish_to_Calendar_Flag</fullName>
        <actions>
            <name>PublishToCal</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4</booleanFilter>
        <criteriaItems>
            <field>PEPE_Training_Event__c.Platform__c</field>
            <operation>equals</operation>
            <value>PIW</value>
        </criteriaItems>
        <criteriaItems>
            <field>PEPE_Training_Event__c.Status__c</field>
            <operation>equals</operation>
            <value>Published</value>
        </criteriaItems>
        <criteriaItems>
            <field>PEPE_Training_Event__c.CVENT_Flag__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <criteriaItems>
            <field>PEPE_Session_Slots__c.Status__c</field>
            <operation>equals</operation>
            <value>Approved</value>
        </criteriaItems>
        <description>Sep 2018 changes</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PublishToCalendarWhenNo</fullName>
        <actions>
            <name>PublishToCalendarNo</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>IF(  ISPICKVAL(Training_Event__r.Status__c, 'Published') &amp;&amp; ISPICKVAL(Status__c,'Approved') &amp;&amp; ISPICKVAL( Training_Event__r.Platform__c ,'PIW') &amp;&amp; ISPICKVAL(  Training_Event__r.Publish_to_Calendar__c ,'No'), true, false)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>PublishToCalendarWhenYes</fullName>
        <actions>
            <name>PublishToCalenderYes</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( ISPICKVAL(Training_Event__r.Status__c, 'Published') &amp;&amp; ISPICKVAL(Status__c,'Approved') &amp;&amp; ISPICKVAL( Training_Event__r.Platform__c ,'PIW') &amp;&amp; ISPICKVAL(  Training_Event__r.Publish_to_Calendar__c ,'Yes'))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
