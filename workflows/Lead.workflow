<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_to_3rdPartner_Data_Sharing</fullName>
        <description>Email to Contact to confirm Partner Data Sharing</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>donotreply-dgcontactcenter@cisco.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>NGCC_Marketing_Contact_Center_Repository/NGCC_3rd_Party_Email_Notification</template>
    </alerts>
    <alerts>
        <fullName>NGCC_Email_to_Contact_to_Partner_LATAM</fullName>
        <description>NGCC Email to Contact to Partner LATAM</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>NGCC_Marketing_Contact_Center_Repository/NGCC_Email_to_Contact_to_Partner_LATAM</template>
    </alerts>
    <alerts>
        <fullName>NGCC_Lead_PreSales_Email_to_Customer_Flow</fullName>
        <description>NGCC Lead PreSales Email to Customer Flow</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>NGCC_Marketing_Contact_Center_Repository/NGCC_Lead_PreSales_Email_to_Customer_template_Flow</template>
    </alerts>
    <alerts>
        <fullName>NGCC_Notify_CCM_for_Approval</fullName>
        <description>NGCC Notify CCM for Approval</description>
        <protected>false</protected>
        <recipients>
            <field>Cisco_Contact_Center_Manager1__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Cisco_Contact_Center_Manager2__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>donotreply-dgcontactcenter@cisco.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>NGCC_Marketing_Contact_Center_Repository/NGCC_Approval_Email</template>
    </alerts>
    <alerts>
        <fullName>NGCC_Notify_LDR_for_Approval</fullName>
        <description>NGCC Notify LDR for Approval</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>donotreply-dgcontactcenter@cisco.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>NGCC_Marketing_Contact_Center_Repository/NGCC_Approval_Email</template>
    </alerts>
    <alerts>
        <fullName>NGCC_Notify_Lead_Admin_to_validate_Lead_Partner_and_AM_Assignment</fullName>
        <description>NGCC Notify Lead Admin to validate Lead Partner and AM Assignment</description>
        <protected>false</protected>
        <recipients>
            <field>Lead_Admin_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>donotreply-dgcontactcenter@cisco.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>NGCC_Marketing_Contact_Center_Repository/NGCC_Notify_Lead_Admin_to_validate_Lead_Partner_and_AM_AssignmentEmail</template>
    </alerts>
    <alerts>
        <fullName>NGCC_Notify_Lead_Owner_with_Rejection_Reason</fullName>
        <description>NGCC Notify Lead Owner with Rejection Reason</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>donotreply-dgcontactcenter@cisco.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>NGCC_Marketing_Contact_Center_Repository/NGCC_Notify_Lead_Owner_about_Rejection</template>
    </alerts>
    <alerts>
        <fullName>NGCC_Notify_Lead_Owner_with_Rejection_Reason_APJ</fullName>
        <description>NGCC Notify Lead Owner with Rejection Reason APJ</description>
        <protected>false</protected>
        <recipients>
            <field>SDR_Lead_Owner_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>donotreply-dgcontactcenter@cisco.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>NGCC_Marketing_Contact_Center_Repository/NGCC_Notify_Lead_Owner_about_Rejection</template>
    </alerts>
    <alerts>
        <fullName>NGCC_Send_Live_Chat_Transcript_to_Customer</fullName>
        <description>NGCC Send Live Chat Transcript to Customer</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>donotreply-dgcontactcenter@cisco.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>NGCC_Marketing_Contact_Center_Repository/NGCC_Live_Chat_Transcript_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>NeweLeadsAlertnotificationtemplate</fullName>
        <description>New eLeads Alert notification template</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>donotreply-sfdc@cisco.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>SAMPLES/LeadsNewassignmentnotificationSAMPLE</template>
    </alerts>
    <alerts>
        <fullName>NotificationofNewPartnerLead</fullName>
        <description>Notification of New Partner Lead</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>unfiled$public/LeademailtoPartnertemplate</template>
    </alerts>
    <alerts>
        <fullName>Send_an_email_to_Lead_Admin_Alias</fullName>
        <ccEmails>immediate_timeframe_convergys@external.cisco.com</ccEmails>
        <description>Send an email to Lead Admin Alias</description>
        <protected>false</protected>
        <recipients>
            <field>Lead_Admin_Alias_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>donotreply-dgcontactcenter@cisco.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>NGCC_Marketing_Contact_Center_Repository/NGCC_Immediate_Timeframe_Template</template>
    </alerts>
    <alerts>
        <fullName>Sending_email_notification_to_Route_to_AM_email_id</fullName>
        <description>Sending email notification to Route to AM email id</description>
        <protected>false</protected>
        <recipients>
            <field>AM_Email_Id__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>donotreply-dgcontactcenter@cisco.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>NGCC_Marketing_Contact_Center_Repository/NGCC_HandRaiser_Appt_Lead_PLBM_Partner</template>
    </alerts>
    <alerts>
        <fullName>Sourcefire_Rejected_Leads_Rule_3_4_Rule_3_7</fullName>
        <ccEmails>gbarai@cisco.com</ccEmails>
        <description>Sourcefire Rejected Leads (Rule 3.4 &amp; Rule 3.7)</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Leads/Energywise_Lead_Creation_Notification</template>
    </alerts>
    <fieldUpdates>
        <fullName>Address_Line1_Update</fullName>
        <description>Update Address Line1 with End Customer Account's Address Line1</description>
        <field>Address_Line_1__c</field>
        <formula>End_Customer_Account__r.AddressLine1__c</formula>
        <name>Address Line1 Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Address_Line2_Update</fullName>
        <description>Update Address Line2 with End Customer Account's Address Line2</description>
        <field>Address_Line_2__c</field>
        <formula>End_Customer_Account__r.AddressLine2__c</formula>
        <name>Address Line2 Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_Lead_Acceptance_Date_Now</fullName>
        <description>Sets Lead Acceptance Date</description>
        <field>Latest_Lead_Acceptance_Date__c</field>
        <formula>Now()</formula>
        <name>Assign Lead Acceptance Date_Now()</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Assign_Lead_Assignment_Date</fullName>
        <description>Assigns todays date to Lead Assignment Date</description>
        <field>Lead_Assignment_Date__c</field>
        <formula>Now()</formula>
        <name>Assign Lead Assignment Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Cisco_Recommended_PSR_Null</fullName>
        <description>Empty the field Cisco Recommended PSR</description>
        <field>Cisco_Rec_PSR__c</field>
        <name>Cisco Recommended PSR_Null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>City_Update</fullName>
        <description>Update City field with End Customer Account's City field</description>
        <field>CustomCity__c</field>
        <formula>End_Customer_Account__r.City__c</formula>
        <name>City Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Clear_Dedupe_Field</fullName>
        <field>DedupeRecord__c</field>
        <name>Clear Dedupe Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Copy_Description</fullName>
        <description>Copies description to description copy field</description>
        <field>Description__c</field>
        <formula>Description</formula>
        <name>Copy Description</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Deal_Create_Date_Time_Now</fullName>
        <field>Deal_Create_Date_Time__c</field>
        <formula>Now()</formula>
        <name>Deal Create Date/Time_Now()</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Dedupe_Field_Set</fullName>
        <field>DedupeRecord__c</field>
        <literalValue>Dedupe</literalValue>
        <name>Dedupe Field Set</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Initial_Partner_Assigned_BEC_ID_Update</fullName>
        <description>Set Initial Partner Assigned BEC ID (PGTMV) to the first Channel Partner's BEC ID.</description>
        <field>Initial_Partner_Assigned_BEC_ID_PGTMV__c</field>
        <formula>Channel_Partner__r.BEC_ID__c</formula>
        <name>Initial Partner Assigned BEC ID Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>LeadType</fullName>
        <field>Lead_Type__c</field>
        <formula>$RecordType.Name</formula>
        <name>Lead Type</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Address12</fullName>
        <description>Copies Address 1 and Address 2 to Street</description>
        <field>Street</field>
        <formula>TRIM(LEFT(Address_Line_1__c &amp; ' ' &amp; Address_Line_2__c,255))</formula>
        <name>Lead_Address12</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_City</fullName>
        <description>Copies CustomCity to City</description>
        <field>City</field>
        <formula>TRIM(LEFT(CustomCity__c,40))</formula>
        <name>Lead_City</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Closed_Date_Now</fullName>
        <description>Sets Lead Closed Date to Now() when the record type of lead is changed to closed or if deal id is assigned to the lead or if lead is converted.</description>
        <field>Lead_Closed_Date__c</field>
        <formula>NOW()</formula>
        <name>Lead Closed Date Now()</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Country</fullName>
        <description>Copies CutomCountry to Country</description>
        <field>Country</field>
        <formula>TRIM(LEFT(TEXT(CustomCountry__c),40))</formula>
        <name>Lead_Country</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Qualified_Date_Set_for_DRT_process</fullName>
        <field>Lead_Qualified_Date__c</field>
        <formula>NOW()</formula>
        <name>Lead Qualified Date Set for DRT process</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Qualifier</fullName>
        <field>Lead_Qualifier__c</field>
        <formula>LastModifiedById</formula>
        <name>Lead Qualifier</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Qualifier_Call_Center</fullName>
        <field>Lead_Qualifier_Call_Center__c</field>
        <formula>TEXT(LastModifiedBy.Marketing_Call_Center__c)</formula>
        <name>Lead Qualifier Call Center</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Qualifier_Name</fullName>
        <field>Lead_Qualifier_Name__c</field>
        <formula>LastModifiedBy.FirstName+' '+ LastModifiedBy.LastName</formula>
        <name>Lead Qualifier Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Quality_Comments</fullName>
        <description>Empty the field Lead_Quality_Comments</description>
        <field>Lead_Quality_Comments__c</field>
        <name>Lead Quality Comments</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Quality_Rating</fullName>
        <description>Empty the field Lead_Quality_Rating</description>
        <field>Lead_Quality_Rating__c</field>
        <name>Lead_Quality_Rating</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Record_Type_Closed</fullName>
        <description>Change the record type to Close on conversion</description>
        <field>RecordTypeId</field>
        <lookupValue>Closed</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Lead Record Type_Closed</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Source_eLeads</fullName>
        <description>Lead Source</description>
        <field>LeadSource</field>
        <literalValue>eLeads</literalValue>
        <name>Lead Source-eLeads</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_State</fullName>
        <description>Copies CustomState to State</description>
        <field>State</field>
        <formula>TRIM(LEFT(CustomState__c, 20))</formula>
        <name>Lead_State</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Status_2Accepted_Mine_Channel</fullName>
        <description>Updating Field Lead Status when Channel Partner is selected on the Lead Record</description>
        <field>Status</field>
        <literalValue>2 Accepted-Mine/Channel</literalValue>
        <name>Lead Status_2 Accepted-Mine/Channel</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Status_2_Accepted_Mine_Channel</fullName>
        <description>2 Accepted-Mine/Channel</description>
        <field>Status</field>
        <literalValue>2 Accepted-Mine/Channel</literalValue>
        <name>Lead Status_2 Accepted-Mine/Channel</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Status_3_11_Rejected_Duplicate</fullName>
        <description>Lead Status Field to be updated to 3.11 Rejected–Duplicate</description>
        <field>Status</field>
        <literalValue>3.11 Rejected-Duplicate</literalValue>
        <name>Lead Status -3.11 Rejected–Duplicate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Status_3_12_Rejected_No_Valid_Proje</fullName>
        <description>Lead Status Field to be updated to 3.12 Rejected-No Valid Project</description>
        <field>Status</field>
        <literalValue>3.12 Rejected-No Valid Project</literalValue>
        <name>Lead Status-3.12 Rejected-No Valid Proje</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Status_3_2_Rejected_Already_oppty</fullName>
        <description>Lead Status Field to be updated to 3.2 Rejected-Already oppty</description>
        <field>Status</field>
        <literalValue>3.2 Rejected-Already oppty</literalValue>
        <name>Lead Status -3.2 Rejected-Already oppty</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Status_3_2_Rejected_Lost_to_Compet</fullName>
        <description>Lead Status Field to be updated to 3.2 Rejected-Lost to Competition</description>
        <field>Status</field>
        <literalValue>3.6 Rejected-Lost to Competition</literalValue>
        <name>Lead Status -3.2 Rejected-Lost to Compet</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Status_3_5_Rejected_Project_Cancele</fullName>
        <description>Lead Status Field to be updated to 3.5 Rejected-Project Canceled</description>
        <field>Status</field>
        <literalValue>3.5 Rejected-Project Canceled</literalValue>
        <name>Lead Status-3.5 Rejected-Project Cancele</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Status_3_9_Rejected_No_Customer_Res</fullName>
        <description>Lead Status Field to be updated to 3.9 Rejected-No Customer Response</description>
        <field>Status</field>
        <literalValue>3.9 Rejected-No Customer Response</literalValue>
        <name>Lead Status-3.9 Rejected-No Customer Res</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Status_Active</fullName>
        <description>Activate the Lead Status from Inactive</description>
        <field>Status</field>
        <literalValue>New Prospect</literalValue>
        <name>Lead Status Active</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Status_Update_to3_1Rejected_Invald</fullName>
        <description>Lead Status Field to be updated to 3.1 Rejected-Invalid Contact</description>
        <field>Status</field>
        <literalValue>3.1 Rejected-Invalid Contact</literalValue>
        <name>Lead Status Update to3.1Rejected-Invald</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Status_Update_to_Rejected_NotTer</fullName>
        <description>Lead Status Update to3.7 Rejected-NotTerritory</description>
        <field>OwnerId</field>
        <lookupValue>Security_Free_Trials</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Lead Status Update to Rejected-NotTer</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_TAC_Assign_TAC_Lead_Queue_Owner</fullName>
        <field>OwnerId</field>
        <lookupValue>TAC_Leads</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Lead TAC Assign TAC Lead Queue Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_TAC_Company_Update</fullName>
        <field>Account_Name_English__c</field>
        <formula>Company</formula>
        <name>Lead TAC Company Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_TAC_English_Address_Line_1</fullName>
        <field>Address_Line_1__c</field>
        <formula>Address_Line_1_English__c</formula>
        <name>Lead TAC English Address Line 1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_TAC_English_Address_Line_2</fullName>
        <field>Address_Line_2__c</field>
        <formula>Address_Line_2_English__c</formula>
        <name>Lead TAC English Address Line 2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_TAC_English_City</fullName>
        <field>CustomCity__c</field>
        <formula>City_English__c</formula>
        <name>Lead TAC English City</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_TAC_English_State_Province</fullName>
        <field>CustomState__c</field>
        <formula>State_Province_English__c</formula>
        <name>Lead TAC English State Province</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_TAC_English_Zip</fullName>
        <field>CustomZip__c</field>
        <formula>Zip_Postal_Code_English__c</formula>
        <name>Lead TAC English Zip</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_TAC_Remove_Duplicate_Id</fullName>
        <field>System_Duplicate_ID__c</field>
        <name>Lead TAC Remove Duplicate Id</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_TAC_Update_Products_of_Interest</fullName>
        <field>ProductsOfInterest__c</field>
        <formula>"Tech: " &amp;  Technology__c &amp; " - " &amp; "SubTech: " &amp;  Sub_Technology__c</formula>
        <name>Lead TAC Update Products of Interest</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Update_Duplicate_Prevention</fullName>
        <field>Duplicate_Prevention__c</field>
        <formula>TEXT(LeadSource) + "-" + Source_System_ID__c</formula>
        <name>Lead Update Duplicate Prevention</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lead_Zip</fullName>
        <description>Copies CustomZip to Zip/Postal</description>
        <field>PostalCode</field>
        <formula>TRIM(LEFT(CustomZip__c,20))</formula>
        <name>Lead_Zip</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NGCC_APJ_Approval_LDR_Owner_Australia</fullName>
        <field>OwnerId</field>
        <lookupValue>NGCC_CC_LDR_SellByTel_Australia</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>NGCC APJ Approval LDR Owner (Australia)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NGCC_APJ_Approval_LDR_Owner_Australia1</fullName>
        <field>OwnerId</field>
        <lookupValue>NGCC_CC_LDR_SellByTel_Australia</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>NGCC APJ Approval LDR Owner (Australia)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NGCC_APJ_Approval_LDR_Owner_GC</fullName>
        <field>OwnerId</field>
        <lookupValue>NGCC_CC_LDR_Convergys_China</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>NGCC APJ Approval LDR Owner (GC)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NGCC_APJ_Approval_LDR_Owner_India</fullName>
        <field>OwnerId</field>
        <lookupValue>NGCC_CC_LDR_Convergys_India</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>NGCC APJ Approval LDR Owner (India)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NGCC_APJ_Approval_LDR_Owner_Japan</fullName>
        <field>OwnerId</field>
        <lookupValue>NGCC_CC_LDR_Inhouse_Japan</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>NGCC APJ Approval LDR Owner (Japan)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NGCC_APJ_Approval_LDR_Owner_Korea</fullName>
        <field>OwnerId</field>
        <lookupValue>NGCC_CC_LDR_SellByTel_Korea</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>NGCC APJ Approval LDR Owner (Korea)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NGCC_APJ_Approval_LDR_Owner_Kuala_Lump</fullName>
        <field>OwnerId</field>
        <lookupValue>NGCC_CC_LDR_SellByTel_Kuala_Lumpur</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>NGCC APJ Approval LDR Owner (Kuala Lump)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NGCC_APJ_Approval_LDR_Owner_Manila_Asia</fullName>
        <field>OwnerId</field>
        <lookupValue>NGCC_CC_LDR_Convergys_Manila_Asia</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>NGCC APJ Approval LDR Owner(Manila-Asia)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NGCC_Approval_Submission</fullName>
        <description>This field update will ensure that any lead submitted for approval will have a status of Approval Pending</description>
        <field>Status</field>
        <literalValue>Approval Pending</literalValue>
        <name>NGCC Approval Submission</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NGCC_Approval_Submission_Approved</fullName>
        <field>Status</field>
        <literalValue>Approved</literalValue>
        <name>NGCC Approval Submission-Approved</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NGCC_Approval_Submission_Mktg_Qualified</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Qualified_Prospect</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>NGCC Approval Submission-Mktg Qualified</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NGCC_Approval_Submission_Recalled</fullName>
        <field>Status</field>
        <literalValue>Marketing Qualified</literalValue>
        <name>NGCC Approval Submission-Recalled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NGCC_Approval_Submission_Rejected</fullName>
        <field>Status</field>
        <literalValue>Rejected</literalValue>
        <name>NGCC Approval Submission-Rejected</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NGCC_DedupeRecord</fullName>
        <description>Update the DedupeRecord to deduped so inactive leads are not considered in duplication process.</description>
        <field>DedupeRecord__c</field>
        <literalValue>Dedupe</literalValue>
        <name>NGCC_DedupeRecord</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NGCC_Default_Lead_Category_to_Appointmen</fullName>
        <field>Lead_Category__c</field>
        <literalValue>BANT</literalValue>
        <name>NGCC Default Lead Category to Appointmen</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NGCC_EloquaCommonCampaignId</fullName>
        <field>Eloqua_CC_Id__c</field>
        <formula>TRIM("cc000589")</formula>
        <name>NGCC_EloquaCommonCampaignId</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NGCC_EloquaCommonCampaign_Blank</fullName>
        <field>Eloqua_CC_Id__c</field>
        <name>NGCC_EloquaCommonCampaign_Blank</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NGCC_First_Approval_Received</fullName>
        <field>First_Approval_Received__c</field>
        <literalValue>1</literalValue>
        <name>NGCC First Approval Received</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NGCC_First_Approval_Received1</fullName>
        <field>First_Approval_Received__c</field>
        <literalValue>1</literalValue>
        <name>NGCC First Approval Received</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NGCC_Lead_Approver_Role_EMEAR</fullName>
        <field>Lead_Approval_Role__c</field>
        <formula>$UserRole.Name</formula>
        <name>NGCC Lead Approver Role EMEAR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NGCC_Lead_Deduper_Processing</fullName>
        <field>DeduperProcessing__c</field>
        <literalValue>0</literalValue>
        <name>NGCC Lead Deduper Processing</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NGCC_Lead_Sent_to_Sales_Date_Update</fullName>
        <field>Lead_Qualified_Date__c</field>
        <formula>Now()</formula>
        <name>NGCC Lead Sent to Sales Date Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NGCC_Lead_Source_Event_Name_FU</fullName>
        <field>Source_System__c</field>
        <formula>"NGCC"</formula>
        <name>NGCC Lead Source Event Name FU</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NGCC_Lead_Source_Event_Number_FU</fullName>
        <field>Source_Event_Number__c</field>
        <formula>CASESAFEID(Id)</formula>
        <name>NGCC Lead Source Event Number FU</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NGCC_Lead_Source_To_Ngcc</fullName>
        <description>When lead is created in SFDC update the Lead Source to NGCC</description>
        <field>LeadSource</field>
        <literalValue>NGCC</literalValue>
        <name>NGCC Lead Source To Ngcc</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NGCC_MQL_Process_Duplicate_Update</fullName>
        <field>MQL_Validation__c</field>
        <formula>IF((ISBLANK(MODS_Contact__c) &amp;&amp; ISBLANK(Lead_Contact__c)),
		Id,
			IF(NOT(ISBLANK(MODS_Contact__c)) &amp;&amp; NOT(ISBLANK(Lead_Contact__c)),	
				TEXT(MODS_Contact__c) + ProgramEvent__c,
				IF(NOT(ISBLANK(MODS_Contact__c)),
					TEXT(MODS_Contact__c) +  ProgramEvent__c,
					Lead_Contact__c + ProgramEvent__c)
			)+IF((TEXT(Status) ='Approved' || TEXT(Status) ='Send to Sales' || TEXT(Status) ='Marketing Qualified'),'MQL',TEXT(Status)))</formula>
        <name>NGCC MQL Process-Duplicate-Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NGCC_MQL_Unqualified_Updated</fullName>
        <field>Status</field>
        <literalValue>Marketing Unqualified</literalValue>
        <name>NGCC MQL-Unqualified Updated</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NGCC_Marketing_Qualified_Lead_Score</fullName>
        <field>LeadScore__c</field>
        <formula>IF(OR(
	ISPICKVAL(QATimeFrame__c,'0 - 4 Months'),
        ISPICKVAL(QATimeFrame__c,'0-4 MONTHS'),
        ISPICKVAL(QATimeFrame__c,'0 - 4 MONTHS'),
	ISPICKVAL(QATimeFrame__c,'NOW - 3 MONTHS'),
	ISPICKVAL(QATimeFrame__c,'Now - 3 Months') 
	),'A',
	
	(IF (OR(
		ISPICKVAL(QATimeFrame__c,'5 - 12 Months' ),
		ISPICKVAL(QATimeFrame__c,'5 - 12 MONTHS'),
		ISPICKVAL(QATimeFrame__c,'4 - 6 Months'),
		ISPICKVAL(QATimeFrame__c,'5-12 MONTHS'),
		ISPICKVAL(QATimeFrame__c,'7 - 12 Months') 
		),'B',
		(IF (OR(
			ISPICKVAL(QATimeFrame__c,'12+ MONTHS' ),
			ISPICKVAL(QATimeFrame__c,'Over 12 Months'),
			ISPICKVAL(QATimeFrame__c,'No Plans To Purchase'),
			ISPICKVAL(QATimeFrame__c,'Unknown'),
			ISPICKVAL(QATimeFrame__c,'No Response'),
			ISPICKVAL(QATimeFrame__c,'12+ Months'),
			ISPICKVAL(QATimeFrame__c,'NO PLAN TO PURCHASE'),
			ISPICKVAL(QATimeFrame__c,'UNKNOWN')
			),'C','-')
		)
	
	)
	)
)</formula>
        <name>NGCC Marketing Qualified -Lead Score</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NGCC_Marketing_Qualified_Process_MQL_Dat</fullName>
        <field>MQL_Created_Date__c</field>
        <formula>NOW()</formula>
        <name>NGCC Marketing Qualified Process-MQL Dat</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NGCC_Marketing_Qualified_Process_Update</fullName>
        <field>Status</field>
        <literalValue>Marketing Qualified</literalValue>
        <name>NGCC Marketing Qualified Process-Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NGCC_Orignating_Marketing_Pipeline</fullName>
        <field>Originating_Marketing_Pipeline__c</field>
        <formula>IF(AND(NOT(ISNULL(ProductAmount__c)),NOT(ISNULL(ServicesAmount__c))),
	ProductAmount__c+ServicesAmount__c,
		IF(ISNULL(ServicesAmount__c),ProductAmount__c,ServicesAmount__c))</formula>
        <name>NGCC Orignating Marketing Pipeline</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NGCC_Populate_SDR_Assignment_Date</fullName>
        <field>SDR_Assignment_Date__c</field>
        <formula>TODAY()</formula>
        <name>NGCC Populate SDR Assignment Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NGCC_RecordType_Change</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Prospect</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>NGCC RecordType Change</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NGCC_Requalification_Status</fullName>
        <field>Call_Status__c</field>
        <literalValue>Requalification Required</literalValue>
        <name>NGCC Requalification Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NGCC_SDR_Assignement_DateTime_Update</fullName>
        <field>SDR_Assignment_DateTime__c</field>
        <formula>NOW()</formula>
        <name>NGCC SDR Assignement Date &amp; Time Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NGCC_SDR_Assignement_Date_Time_Update</fullName>
        <field>SDR_Assignment_DateTime__c</field>
        <formula>NOW()</formula>
        <name>NGCC SDR Assignement Date &amp; Time Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NGCC_SDR_Assignement_Update</fullName>
        <field>SDR_Assignment_Date__c</field>
        <formula>Today()</formula>
        <name>NGCC SDR Assignement Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NGCC_SDR_Lead_Owner_Email</fullName>
        <field>SDR_Lead_Owner_Email__c</field>
        <formula>Owner:User.Email</formula>
        <name>NGCC SDR Lead Owner Email</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NGCC_SDR_Owner_Id</fullName>
        <field>SDR_Lead_Owner_New__c</field>
        <formula>Owner:User.Id</formula>
        <name>NGCC SDR Owner Id</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NGCC_SDR_Owner_Name</fullName>
        <field>SDR_Lead_Owner_Name__c</field>
        <formula>Owner:User.FirstName &amp;" "&amp; Owner:User.LastName</formula>
        <name>NGCC SDR Owner Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NGCC_Update_Call_Center_Vendor</fullName>
        <description>Update the call center vendor field</description>
        <field>Call_Center_Vendor__c</field>
        <formula>TEXT(Owner:User.Marketing_Call_Center__c)</formula>
        <name>NGCC Update Call Center Vendor</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NGCC_Update_SDR_Assignment_Date</fullName>
        <description>This will update the SDR Assignment Date on Lead</description>
        <field>SDR_Assignment_Date__c</field>
        <formula>TODAY()</formula>
        <name>NGCC Update SDR Assignment Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>P360_Estimated_Product_Amount</fullName>
        <description>Update the Estimated Product Amount by removing the decimal.</description>
        <field>ProductAmount__c</field>
        <formula>IF( ROUND(ProductAmount__c,0) &gt; ProductAmount__c,ROUND(ProductAmount__c,0)-1, ROUND(ProductAmount__c,0))</formula>
        <name>P360 Estimated Product Amount</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>P360_Estimated_Service_Amount</fullName>
        <description>Update Estimated Service Amount by removing the decimal.</description>
        <field>ServicesAmount__c</field>
        <formula>IF( ROUND(ServicesAmount__c,0) &gt; ServicesAmount__c,ROUND(ServicesAmount__c,0)-1, ROUND(ServicesAmount__c,0))</formula>
        <name>P360 Estimated Service Amount</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>P360_Originating_Marketing_Total_value</fullName>
        <description>This is to copy over Originating Marketing Pipeline to Total value if Total Value is blank on creation. To Align FY14 marketing SQL metrics</description>
        <field>TotalValue__c</field>
        <formula>If(
NOT(
OR(
ISBLANK(Originating_Marketing_Pipeline__c),
ISNULL(Originating_Marketing_Pipeline__c)
)
),Originating_Marketing_Pipeline__c/1000,0)</formula>
        <name>P360 Originating Marketing - Total value</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>P360_PSR1_Name_Update</fullName>
        <field>PSR_SYS1__c</field>
        <formula>PSR_1__r.FirstName &amp; " " &amp; PSR_1__r.LastName</formula>
        <name>P360 PSR1 Name Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>P360_PSR2_Name_Update</fullName>
        <field>PSR_SYS2__c</field>
        <formula>PSR_2__r.FirstName &amp; " " &amp; PSR_2__r.LastName</formula>
        <name>P360 PSR2 Name Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>P360_PSR3_Name_Update</fullName>
        <field>PSR_SYS3__c</field>
        <formula>PSR_3__r.FirstName &amp; " " &amp; PSR_3__r.LastName</formula>
        <name>P360 PSR3 Name Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>P360_SQL_FLAG_Checked</fullName>
        <description>SQL FLAG field will be checked when a Lead ever has one of the below status values to preserve the SQL status and values:
. Actively Working
. Closed through disti
. Closed through stock
. Deal created</description>
        <field>SQL_FLAG__c</field>
        <literalValue>1</literalValue>
        <name>P360 SQL FLAG Checked</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>P360_Total_Value_Update</fullName>
        <description>Update Total Value field with the sum of Estimated Product Value and Estimated Service Value. Ignore the Decimal points in both fields (Don't even Round-Off)</description>
        <field>TotalValue__c</field>
        <formula>(IF(ProductAmount__c &gt;0,IF( ROUND(ProductAmount__c,0) &gt; ProductAmount__c,ROUND(ProductAmount__c,0)-1, ROUND(ProductAmount__c,0)) ,0)+ 
IF(ServicesAmount__c &gt;0, IF( ROUND(ServicesAmount__c,0) &gt; ServicesAmount__c,ROUND(ServicesAmount__c,0)-1, ROUND(ServicesAmount__c,0)),0))/1000</formula>
        <name>P360 Total Value Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>P360_Update_Company_Name_Eng_Field</fullName>
        <field>Account_Name_English__c</field>
        <formula>End_Customer_Account__r.AccountNameEnglish__c</formula>
        <name>P360 Update Company Name (Eng) Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>P360_Update_Company_Name_Field</fullName>
        <field>Company</field>
        <formula>End_Customer_Account__r.Name</formula>
        <name>P360 Update Company Name Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PSRAssigned_to_False</fullName>
        <description>if there is no psr on lead set isPSRAssigned__c to false</description>
        <field>isPSRAssigned__c</field>
        <literalValue>0</literalValue>
        <name>PSRAssigned to False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PSR_1_Null</fullName>
        <description>Empty the field PSR 1.</description>
        <field>PSR_1__c</field>
        <name>PSR 1_Null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PSR_2_Null</fullName>
        <description>Empty the field PSR2</description>
        <field>PSR_2__c</field>
        <name>PSR 2_Null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PSR_3_Null</fullName>
        <field>PSR_3__c</field>
        <name>PSR 3_Null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PSR_Assigned_Date_Now</fullName>
        <description>This Date field gets populated when PSR is assigned to a Lead</description>
        <field>PSR_Assigned_Date__c</field>
        <formula>NOW()</formula>
        <name>PSR Assigned Date_Now()</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PSR_Assigned_Date_Null</fullName>
        <description>Nullify PSR assigned date when Channel Partner is changed/deleted</description>
        <field>PSR_Assigned_Date__c</field>
        <name>PSR Assigned Date_Null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Partner_Accepted_Date_Time_Now</fullName>
        <description>P360- Partner Accepted Date/Time field update based on Partner Lead Status Lov's</description>
        <field>P360_Partner_Accepted_Date_Time__c</field>
        <formula>NOW()</formula>
        <name>Partner Accepted Date/Time_Now()</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Partner_Accepted_Date_Time_Null</fullName>
        <description>Empty P360- Partner Accepted Date/Time when Channel Partner is Changed</description>
        <field>P360_Partner_Accepted_Date_Time__c</field>
        <name>Partner Accepted Date/Time_Null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Partner_Actively_Working_Date</fullName>
        <description>Date/Time when partner status was changed to Actively Working</description>
        <field>Partner_Actively_Working_Date__c</field>
        <formula>NOW()</formula>
        <name>Partner Actively Working Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Partner_Actively_Working_to_NULL</fullName>
        <description>Set Partner Actively Working to NULL</description>
        <field>Partner_Actively_Working_Date__c</field>
        <name>Partner Actively Working to NULL</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Partner_Assignment_Date_Time_Now</fullName>
        <description>Updates Partner Assigned Date on lead record when Channel Partner is added.</description>
        <field>Partner_Assigned_Date__c</field>
        <formula>NOW()</formula>
        <name>Partner Assignment Date/Time_Now()</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Partner_Assignment_Date_Time_Null</fullName>
        <field>Partner_Assigned_Date__c</field>
        <name>Partner Assignment Date/Time_Null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Partner_Lead_Status_Assigned_To_PSR</fullName>
        <description>"Partner Lead Status" lov to be set to "Assigned to PSR" when PSR is assigned</description>
        <field>Partner_Lead_Status__c</field>
        <literalValue>Assigned To PSR</literalValue>
        <name>Partner Lead Status_Assigned To PSR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Partner_Lead_Status_Deal_Created</fullName>
        <field>Partner_Lead_Status__c</field>
        <literalValue>Deal Created</literalValue>
        <name>Partner Lead Status_Deal Created</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Partner_Lead_Status_Null</fullName>
        <field>Partner_Lead_Status__c</field>
        <name>Partner Lead Status_Null</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Partner_Lead_Status_Partner_Assigned</fullName>
        <description>This rule will update Partner Lead Status to "Assigned Partner" if Partner Company is not null</description>
        <field>Partner_Lead_Status__c</field>
        <literalValue>Partner Assigned</literalValue>
        <name>Partner Lead Status_Partner Assigned</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SQL_Flag</fullName>
        <description>Empty the field SQL_Flag</description>
        <field>SQL_FLAG__c</field>
        <literalValue>0</literalValue>
        <name>SQL Flag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Status_to_Inactive</fullName>
        <description>Sets the Lead status to Inactive</description>
        <field>Status</field>
        <literalValue>Inactive</literalValue>
        <name>Set Status to Inactive</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>State_Province_Update</fullName>
        <description>Update State/Province Field with End Customer Account's State/Province Field</description>
        <field>CustomState__c</field>
        <formula>End_Customer_Account__r.State__c</formula>
        <name>State/Province Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Lead_Owner_to_Queue</fullName>
        <description>Updates lead owner to the call back queue for Eloqua web form leads</description>
        <field>OwnerId</field>
        <lookupValue>NGCC_N3_Atlanta_Callback</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>Update Lead Owner to Queue</name>
        <notifyAssignee>true</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Lead_Status_to_Waiting</fullName>
        <field>Status</field>
        <literalValue>1 Waiting</literalValue>
        <name>Update Lead Status to Waiting</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Viewed_By_PSR_FALSE</fullName>
        <field>Viewed_By_PSR__c</field>
        <literalValue>0</literalValue>
        <name>Viewed By PSR_FALSE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Zip_PostalCode_Update</fullName>
        <description>Update Zip/Postal Code Field with End Customer Account's Zip/Postal Code Field</description>
        <field>CustomZip__c</field>
        <formula>End_Customer_Account__r.ZipPostalCode__c</formula>
        <name>Zip/PostalCode Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>isPSRAssigned_FALSE</fullName>
        <description>when channel partner is removed on reassignment of the lead it update PsrAssigned checkbox.</description>
        <field>isPSRAssigned__c</field>
        <literalValue>0</literalValue>
        <name>isPSRAssigned_FALSE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>isPSRAssigned_TRUE</fullName>
        <field>isPSRAssigned__c</field>
        <literalValue>1</literalValue>
        <name>isPSRAssigned_TRUE</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>leadProspectClosedDate_update</fullName>
        <description>Lead Prospect Close Date value for field update</description>
        <field>Lead_Prospect_Close_Date__c</field>
        <formula>DATETIMEVALUE(today())</formula>
        <name>leadProspectClosedDate update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Copy Description</fullName>
        <actions>
            <name>Copy_Description</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Description</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>Copies data from description field to description copy field.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Initial Partner Assigned BEC ID %28PGTMV%29 Update</fullName>
        <actions>
            <name>Initial_Partner_Assigned_BEC_ID_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow will set the PGTMV Site ID of first Channel Partner on the Lead.</description>
        <formula>DATEVALUE( CreatedDate) &gt;= DATE(2016,06,13) &amp;&amp;
ISBLANK(Initial_Partner_Assigned_BEC_ID_PGTMV__c) &amp;&amp; NOT(ISBLANK(Channel_Partner__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Latest Lead Acceptance Date Now%28%29</fullName>
        <actions>
            <name>Assign_Lead_Acceptance_Date_Now</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Set Latest Lead Acceptance Date Now()</description>
        <formula>ISPICKVAL(Status, '2 Accepted-Mine/Channel')</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Lead Assignment Date</fullName>
        <actions>
            <name>Assign_Lead_Assignment_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>On change of owner, sets the current date to Lead Assignment Date</description>
        <formula>ISCHANGED(OwnerId) || ISNEW()</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Lead Closed Date Now%28%29</fullName>
        <actions>
            <name>Lead_Closed_Date_Now</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Sets Lead Closed Date to Now() when the record type of lead is changed to closed or if deal id is assigned to the lead or if lead is converted.</description>
        <formula>(ISCHANGED( RecordTypeId ) &amp;&amp; RecordTypeId = $Setup.ObjectRecordTypeIds__c.Closed_Lead_RecordTypeId__c ) 
|| 
(ISCHANGED( Deal_ID__c )) 
|| 
(ISBLANK( Lead_Closed_Date__c ) &amp;&amp; ISCHANGED( IsConverted ) &amp;&amp; IsConverted )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Lead Duplicate Prevention</fullName>
        <actions>
            <name>Lead_Update_Duplicate_Prevention</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.LeadSource</field>
            <operation>equals</operation>
            <value>TAC Generated Lead,Zift_AQL,Zift_MQL,Zift_Partner</value>
        </criteriaItems>
        <description>Populate the Duplicate Prevention field (for stopping replicate create calls) for a given set of Lead Sources</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Lead Source-eLeads</fullName>
        <actions>
            <name>Lead_Source_eLeads</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>The rule updates the Lead:Lead Source Field with eLeads</description>
        <formula>ISPICKVAL(LeadSource,'') &amp;&amp;
RecordTypeId == $Setup.ObjectRecordTypeIds__c.eLeadsRecordTypeId__c</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Lead Status Rejection Rule -3%2E1 Rejected-Invalid Contact</fullName>
        <actions>
            <name>Lead_Status_Update_to3_1Rejected_Invald</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Partner_Lead_Status__c</field>
            <operation>equals</operation>
            <value>Rejected-Invalid Contact</value>
        </criteriaItems>
        <description>P360- Lead Status Rejection Workflow rule based on Partner Lead Status Field-
Partner Lead Status (Rejected - Invalid Contact) = Lead Status(3.1 Rejected-Invalid Contact
)</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Lead Status Rejection Rule -3%2E11 Rejected%E2%80%93Duplicate</fullName>
        <actions>
            <name>Lead_Status_3_11_Rejected_Duplicate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Partner_Lead_Status__c</field>
            <operation>equals</operation>
            <value>Rejected-Duplicate</value>
        </criteriaItems>
        <description>P360- Lead Status Rejection Workflow rule based on Partner Lead Status Field-
Partner Lead Status (Rejected–Duplicate) = Lead Status(3.11 Rejected–Duplicate)</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Lead Status Rejection Rule -3%2E12 Rejected-No Valid Project</fullName>
        <actions>
            <name>Lead_Status_3_12_Rejected_No_Valid_Proje</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Partner_Lead_Status__c</field>
            <operation>equals</operation>
            <value>Rejected-No Valid Project</value>
        </criteriaItems>
        <description>P360- Lead Status Rejection Workflow rule based on Partner Lead Status Field-
Partner Lead Status (Rejected-No Valid Project) = Lead Status(3.12 Rejected-No Valid Project)</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Lead Status Rejection Rule -3%2E5 Rejected-Project Canceled</fullName>
        <actions>
            <name>Lead_Status_3_5_Rejected_Project_Cancele</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Partner_Lead_Status__c</field>
            <operation>equals</operation>
            <value>Rejected-Project Canceled</value>
        </criteriaItems>
        <description>P360- Lead Status Rejection Workflow rule based on Partner Lead Status Field-
Partner Lead Status (Rejected-Project Canceled) = Lead Status(3.5 Rejected-Project Canceled)</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Lead Status Rejection Rule -3%2E9 Rejected-No Customer Response</fullName>
        <actions>
            <name>Lead_Status_3_9_Rejected_No_Customer_Res</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Partner_Lead_Status__c</field>
            <operation>equals</operation>
            <value>Rejected-No Customer Response</value>
        </criteriaItems>
        <description>P360- Lead Status Rejection Workflow rule based on Partner Lead Status Field-
Partner Lead Status (Rejected-No Customer Response) = Lead Status(3.9 Rejected-No Customer Response)</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Lead Status Rejection Rule- 3%2E6 Rejected-Lost to Competition</fullName>
        <actions>
            <name>Lead_Status_3_2_Rejected_Lost_to_Compet</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Partner_Lead_Status__c</field>
            <operation>equals</operation>
            <value>Rejected-Lost to Competition</value>
        </criteriaItems>
        <description>P360- Lead Status Rejection Workflow rule based on Partner Lead Status Field-
Partner Lead Status (Rejected -Lost to Competition) = Lead Status(3.1 Rejected-Lost to Competition)</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Lead Status Rejection Rule-3%2E2 Rejected-Already oppty</fullName>
        <actions>
            <name>Lead_Status_3_2_Rejected_Already_oppty</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Partner_Lead_Status__c</field>
            <operation>equals</operation>
            <value>Rejected-Already Deal</value>
        </criteriaItems>
        <description>P360- Lead Status Rejection Workflow rule based on Partner Lead Status Field-Partner Lead Status (Rejected-Already Deal) = Lead Status(3.2 Rejected-Already oppty)</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Lead Status to be Accepted</fullName>
        <actions>
            <name>Assign_Lead_Acceptance_Date_Now</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Lead_Status_2Accepted_Mine_Channel</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Partner_Assignment_Date_Time_Now</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Partner_Lead_Status_Partner_Assigned</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>To Update the Lead Status to '2 Accepted-Mine/Channel'  when Channel Partner field is not Blank
NGCC: Updated to Exclude Marketing Record</description>
        <formula>IF( NOT(CONTAINS(RecordType.Name,'Prospect')) ,(  NOT(ISBLANK(Channel_Partner__c))  &amp;&amp;  NOT(ISPICKVAL( Partner_Lead_Status__c, "Actively Working"))  &amp;&amp;  NOT(ISPICKVAL( Partner_Lead_Status__c, "Deal Created"))  &amp;&amp;  ISBLANK(PRIORVALUE(Channel_Partner__c))  &amp;&amp;  ISCHANGED(Channel_Partner__c)  )  ||  (  ISNEW()  &amp;&amp;  NOT(ISBLANK(Channel_Partner__c))  &amp;&amp;  ISPICKVAL(Partner_Lead_Status__c,"")  ),FALSE)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Lead Status to be Accepted on upload</fullName>
        <actions>
            <name>Lead_Status_2_Accepted_Mine_Channel</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Lead Status to be Accepted on upload</description>
        <formula>ISPICKVAL(Status, '1 Waiting')
&amp;&amp;
RecordType.Id = $Setup.ObjectRecordTypeIds__c.Manual_Lead_RecordTypeId__c
&amp;&amp;
NOT(ISBLANK(Channel_Partner__c ))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Lead TAC Duplicate ID Clear</fullName>
        <actions>
            <name>Lead_TAC_Remove_Duplicate_Id</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Clear out duplicate Id values when a Lead is manually changed from Rejected to regular status.</description>
        <formula>AND( ISPICKVAL(LeadSource,'TAC Generated Lead'),  ISPICKVAL(PRIORVALUE(Status),'3.11 Rejected-Duplicate'), NOT(ISPICKVAL(Status,'3.11 Rejected-Duplicate')) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Lead TAC English Fields</fullName>
        <actions>
            <name>Lead_TAC_Company_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Lead_TAC_English_Address_Line_1</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Lead_TAC_English_Address_Line_2</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Lead_TAC_English_City</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Lead_TAC_English_State_Province</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Lead_TAC_English_Zip</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.LeadSource</field>
            <operation>equals</operation>
            <value>TAC Generated Lead</value>
        </criteriaItems>
        <description>Replicate the TAC English fields to the main fields on Create.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Lead TAC Products of Interest</fullName>
        <actions>
            <name>Lead_TAC_Update_Products_of_Interest</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.LeadSource</field>
            <operation>equals</operation>
            <value>TAC Generated Lead</value>
        </criteriaItems>
        <description>Products of Interests field for TAC Generated Leads will follow the format "Tech: " &amp; Technology &amp; "Subtech: " Sub-technology.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Lead TAC Unallocated Reassignment</fullName>
        <actions>
            <name>Lead_TAC_Assign_TAC_Lead_Queue_Owner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.OwnerId</field>
            <operation>equals</operation>
            <value>Other - Unallocated Leads</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.LeadSource</field>
            <operation>equals</operation>
            <value>TAC Generated Lead</value>
        </criteriaItems>
        <description>Reassign TAC leads that LRE assigns to unallocated queue to the TAC Leads queue.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Lead Type</fullName>
        <actions>
            <name>LeadType</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>The rule updates the Lead:Lead Type Field with the record type of Lead.</description>
        <formula>OR(AND(ISCHANGED( RecordTypeId ),NOT(CONTAINS(Lead_Type__c,'Eloqua'))), Lead_Type__c = '')</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Lead_Address_Change</fullName>
        <actions>
            <name>Lead_Address12</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Lead_City</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Lead_Country</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Lead_State</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Lead_Zip</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Copies custom address fields to standard</description>
        <formula>(ISCHANGED( Address_Line_1__c) || ISCHANGED(Address_Line_2__c)) || 
((Address_Line_1__c &amp; ' ' &amp; Address_Line_2__c) != Street) ||
(ISCHANGED( CustomCity__c )) || (CustomCity__c != City ) ||
(ISCHANGED(CustomState__c )) || (CustomState__c != State) ||
(ISCHANGED (CustomZip__c)) || (CustomZip__c != PostalCode) ||
(ISCHANGED(CustomCountry__c)) || (Country = '')</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Lead_Channel_Partner_Change2</fullName>
        <actions>
            <name>Lead_Quality_Comments</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Lead_Quality_Rating</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Partner_Actively_Working_to_NULL</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SQL_Flag</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Reset fields when partner is changed.</description>
        <formula>ISCHANGED(Channel_Partner__c)  &amp;&amp;  NOT(ISBLANK(Channel_Partner__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>NGCC Dedupe Clearing</fullName>
        <actions>
            <name>Clear_Dedupe_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>notEqual</operation>
            <value>Pre-Prospect,New Prospect,1 Waiting</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>NGCC Lead Deduper Processing</fullName>
        <actions>
            <name>NGCC_Lead_Deduper_Processing</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.DeduperProcessing__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>NGCC Lead Qualification Date Update for DRT process</fullName>
        <actions>
            <name>Lead_Qualified_Date_Set_for_DRT_process</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 AND 2 AND 3)</booleanFilter>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>equals</operation>
            <value>Marketing Qualified</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>Prospect</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Lead_Qualified_Date__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>NGCC Lead Qualifier Update</fullName>
        <actions>
            <name>Lead_Qualifier</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Lead_Qualifier_Call_Center</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Lead_Qualifier_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>equals</operation>
            <value>Marketing Qualified</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>Prospect,Qualified Prospect</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>NGCC Lead Sent to Sales Date Update</fullName>
        <actions>
            <name>NGCC_Lead_Sent_to_Sales_Date_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 AND (2 OR 3))</booleanFilter>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>equals</operation>
            <value>Send to Sales</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>Prospect</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>Qualified Prospect</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>NGCC Lead Sent to Sales Date Update Qualified Prospects</fullName>
        <actions>
            <name>NGCC_Lead_Sent_to_Sales_Date_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>eLeads,Manual,Partner Generated Lead,Closed</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>NGCC Lead Source Event Number</fullName>
        <actions>
            <name>NGCC_Lead_Source_Event_Number_FU</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Source_Event_Number__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>Prospect</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>NGCC Lead Source System</fullName>
        <actions>
            <name>NGCC_Lead_Source_Event_Name_FU</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Source_System__c</field>
            <operation>notEqual</operation>
            <value>noHold</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>Prospect</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>NGCC Lead Status Active</fullName>
        <actions>
            <name>Lead_Status_Active</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Call_Status__c</field>
            <operation>equals</operation>
            <value>Open</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Contact_Status__c</field>
            <operation>notEqual</operation>
            <value>Inactive</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Phone_Status__c</field>
            <operation>notEqual</operation>
            <value>Invalid</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>equals</operation>
            <value>Inactive</value>
        </criteriaItems>
        <description>Ability to set Lead status to Active when Phone status or Contact status is set to Active.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>NGCC Lead Status Inactive</fullName>
        <actions>
            <name>NGCC_DedupeRecord</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Set_Status_to_Inactive</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Ability to set Lead status to Inactive when Phone status or Contact status is set to Inactive.</description>
        <formula>AND(
	OR(
	TEXT(Phone_Status__c)="Invalid",
	TEXT(Contact_Status__c )="Inactive"
	),
	TEXT(Call_Status__c) = "Open",
	$Profile.Name&lt;&gt;"Cisco_Integration_Echo_Suppression"
)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>NGCC Lead Status to Waiting for eLeads</fullName>
        <actions>
            <name>Update_Lead_Status_to_Waiting</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Changing default Lead status to Waiting for eLeads</description>
        <formula>ISCHANGED( RecordTypeId ) &amp;&amp; Lead_Record_Type_Name__c ='eLeads' &amp;&amp; PRIORVALUE( Lead_Record_Type_Name__c ) = 'Prospect' &amp;&amp; ISPICKVAL( Status , 'Marketing Qualified')</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>NGCC Marketing Mandatory Processing</fullName>
        <actions>
            <name>NGCC_Default_Lead_Category_to_Appointmen</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Sprint 3 - US5608
			Populating Lead Attributes for Reporting</description>
        <formula>AND(ISBLANK(TEXT(Lead_Category__c)),CONTAINS(RecordType.Name,'Prospect'))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>NGCC Marketing Qualified Process</fullName>
        <actions>
            <name>NGCC_Marketing_Qualified_Lead_Score</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>NGCC_Marketing_Qualified_Process_MQL_Dat</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>NGCC_Marketing_Qualified_Process_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>NGCC_Orignating_Marketing_Pipeline</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>((1 AND 2 AND 3 AND 4 AND 5 AND 6 AND 7 AND 13 AND 14 AND 15 AND 16) AND ((8 AND 9 AND 10 AND 11) OR 12))</booleanFilter>
        <criteriaItems>
            <field>Lead.Project_Flag__c</field>
            <operation>equals</operation>
            <value>Yes</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.QABudget__c</field>
            <operation>notEqual</operation>
            <value>No budget available,Did not respond,NO BUDGET</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.QATimeFrame__c</field>
            <operation>equals</operation>
            <value>Now - 3 Months,4 - 6 Months,7 - 12 Months,0 - 4 Months,5 - 12 Months,0-4 MONTHS,5-12 MONTHS</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>Prospect</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Call_Status__c</field>
            <operation>equals</operation>
            <value>Call Completed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>equals</operation>
            <value>New Prospect,Marketing Qualified,Inactive,Cancel,Marketing Unqualified</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Lead_Qualification_Error__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Lead_Category__c</field>
            <operation>equals</operation>
            <value>APPOINTMENT</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Appointment_Type__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Appointment_Date_Time__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Appointment_Status__c</field>
            <operation>equals</operation>
            <value>Accepted,Confirmed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Lead_Category__c</field>
            <operation>notEqual</operation>
            <value>APPOINTMENT</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Outcome__c</field>
            <operation>equals</operation>
            <value>Qualified Lead</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Lead_Cancel_Reason__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.QABudget__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Is_Call_Script_Executed__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>NGCC Marketing Qualified Process-Duplicate Check</fullName>
        <actions>
            <name>NGCC_MQL_Process_Duplicate_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>Prospect</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>equals</operation>
            <value>Approved,Marketing Qualified,Send to Sales</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>NGCC Marketing Qualified Process-Unqualified</fullName>
        <actions>
            <name>NGCC_MQL_Unqualified_Updated</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>NGCC_Marketing_Qualified_Lead_Score</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>NGCC_Orignating_Marketing_Pipeline</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>((1 OR 2 OR 3 OR 7 OR 8 OR 9) AND 4 AND 5 AND 6)</booleanFilter>
        <criteriaItems>
            <field>Lead.Project_Flag__c</field>
            <operation>notEqual</operation>
            <value>Yes</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.QABudget__c</field>
            <operation>equals</operation>
            <value>No budget available,Did not respond,NO BUDGET</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.QATimeFrame__c</field>
            <operation>notEqual</operation>
            <value>Now - 3 Months,4 - 6 Months,7 - 12 Months,0 - 4 Months,5 - 12 Months,0-4 MONTHS,5-12 MONTHS</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>Prospect</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Call_Status__c</field>
            <operation>equals</operation>
            <value>Call Completed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>equals</operation>
            <value>New Prospect,Marketing Qualified,Inactive,Marketing Unqualified</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Outcome__c</field>
            <operation>equals</operation>
            <value>Max Attempts Reached,Cust Prefers a different buying method,Customer Dropped Off,Customer Service,Lead Escalation,Transfer out,WebEx eCommerce Purchase (Interim)</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.QABudget__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.QATimeFrame__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>NGCC Notify LDR for %3E 200 GC</fullName>
        <actions>
            <name>NGCC_Notify_LDR_for_Approval</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>NGCC_APJ_Approval_LDR_Owner_GC</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.RecordTypeId</field>
            <operation>equals</operation>
            <value>Prospect</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>equals</operation>
            <value>Approval Pending</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Theater__c</field>
            <operation>equals</operation>
            <value>Greater China</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Originating_Marketing_Pipeline__c</field>
            <operation>greaterThan</operation>
            <value>200000</value>
        </criteriaItems>
        <description>Notify LDR for Greater China as we cant send notification via approval just for type of record</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>NGCC SDR Assignment Date</fullName>
        <actions>
            <name>NGCC_Populate_SDR_Assignment_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>NGCC_SDR_Assignement_DateTime_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Populating SDR Assignment Date Lead Attributes for Reporting</description>
        <formula>AND(  	BEGINS(OwnerId,'005'), 	$Profile.Name&lt;&gt;"Cisco_Integration_Echo_Suppression" , 	OR(  		RecordTypeId = $Setup.ObjectRecordTypeIds__c.Marketing_Lead_RecordType__c,  		RecordTypeId = $Setup.ObjectRecordTypeIds__c.Marketing_Qualified_Lead__c  	)  )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>NGCC SDR Assignment Reporting Lead Attributes</fullName>
        <actions>
            <name>NGCC_Lead_Source_To_Ngcc</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>NGCC_SDR_Assignement_Date_Time_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>NGCC_SDR_Assignement_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>NGCC_SDR_Lead_Owner_Email</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>NGCC_SDR_Owner_Id</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>NGCC_SDR_Owner_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>NGCC_Update_Call_Center_Vendor</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>NGCC_Update_SDR_Assignment_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Sprint 3 - US5608
Populating Lead Attributes for Reporting</description>
        <formula>AND(  	OR(  		AND( 			ISCHANGED(OwnerId), 			BEGINS(OwnerId,'005'), 			OR($Profile.Name='Cisco_NGCC',NOT(ISBLANK(TEXT(Owner:User.Marketing_Call_Center__c)))) 		),  		AND( 			ISCHANGED(OwnerId), 			$Profile.Name&lt;&gt;'Cisco_Integration_Echo_Suppression',			  			OR( 				CONTAINS(Owner:User.UserRole.DeveloperName,'SDR'), 				CONTAINS(Owner:User.UserRole.Name,'NGCC-CC Site Manager'), 				NOT(ISBLANK(TEXT(Owner:User.Marketing_Call_Center__c))) 			)  		),  		AND(  			ISNEW(),  			OR(CONTAINS(Owner:User.UserRole.DeveloperName,'SDR'), CONTAINS(Owner:User.UserRole.DeveloperName,'NGCC-CC Site Manager'),  			NOT(ISBLANK(TEXT(Owner:User.Marketing_Call_Center__c))) )  		)  	),  	OR( 		RecordTypeId = $Setup.ObjectRecordTypeIds__c.Marketing_Lead_RecordType__c,  		RecordTypeId = $Setup.ObjectRecordTypeIds__c.Marketing_Qualified_Lead__c  	) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>NGCC Send Live Chat Transcript to Customer</fullName>
        <actions>
            <name>NGCC_Send_Live_Chat_Transcript_to_Customer</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Sending Live Chat Transcript to Customer</description>
        <formula>AND( NOT(ISNEW()),AND( OR( ISCHANGED( Send_Chat_Flag__c ),ISCHANGED( Live_Chat_Transcript_Body__c )),Send_Chat_Flag__c ,LEN(Live_Chat_Transcript_Body__c) &lt;&gt; 0))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>NGCC Send email to Lead Admin Alias</fullName>
        <actions>
            <name>Send_an_email_to_Lead_Admin_Alias</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND (3 OR 4) AND 5</booleanFilter>
        <criteriaItems>
            <field>Lead.Outcome__c</field>
            <operation>equals</operation>
            <value>Immediate Timeframe</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>equals</operation>
            <value>Send to Sales</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.CustomCountry__c</field>
            <operation>equals</operation>
            <value>CANADA</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.CustomCountry__c</field>
            <operation>equals</operation>
            <value>UNITED STATES</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Originating_Marketing_Pipeline__c</field>
            <operation>greaterOrEqual</operation>
            <value>35000</value>
        </criteriaItems>
        <description>Send an email to Lead Admin Alias email when lead outcome is immediate Timeframe and Lead Status is send to sales.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>NGCC-N3 Atlanta Callback</fullName>
        <actions>
            <name>Update_Lead_Owner_to_Queue</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead.Country</field>
            <operation>equals</operation>
            <value>UNITED STATES,CANADA</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Eloqua_Asset_Id__c</field>
            <operation>equals</operation>
            <value>5623</value>
        </criteriaItems>
        <description>Assigning Leads from Eloqua callback forms to NGCC-N3 Atlanta CallBack Queue.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>NGCC_Inbound_Rule</fullName>
        <actions>
            <name>NGCC_EloquaCommonCampaignId</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(  	ISPICKVAL(Medium_Type__c, "Inbound Call"), 	CONTAINS(Campaign_Name__r.Campaign_source__c, "Eloqua"), 	$Profile.Name &lt;&gt;"Cisco_Integration_Echo_Suppression", 	NOT( 		ISBLANK( 			TEXT(Owner:User.Marketing_Call_Center__c) 		) 	), 	OR( 		RecordTypeId = $Setup.ObjectRecordTypeIds__c.Marketing_Lead_RecordType__c, 		RecordTypeId = $Setup.ObjectRecordTypeIds__c.Marketing_Qualified_Lead__c 	) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>NGCC_Inbound_Rule_Blank</fullName>
        <actions>
            <name>NGCC_EloquaCommonCampaign_Blank</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( 	ISCHANGED(Medium_Type__c), 	ISPICKVAL(PRIORVALUE(Medium_Type__c), "Inbound Call"), 	OR( 		ISPICKVAL(Medium_Type__c, "Outbound Call"), 		ISPICKVAL(Medium_Type__c, "Inbound Chat"), 		ISPICKVAL(Medium_Type__c, "Web Inquiry") 	), 	CONTAINS(Campaign_Name__r.Campaign_source__c, "Eloqua"),  	$Profile.Name &lt;&gt;"Cisco_Integration_Echo_Suppression", 	NOT( 		ISBLANK( 			TEXT(Owner:User.Marketing_Call_Center__c) 		) 	), 	OR( 		RecordTypeId = $Setup.ObjectRecordTypeIds__c.Marketing_Lead_RecordType__c, 		RecordTypeId = $Setup.ObjectRecordTypeIds__c.Marketing_Qualified_Lead__c 	) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>NGCC_Update ldProspectCloseDate wrt Call Status</fullName>
        <actions>
            <name>leadProspectClosedDate_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update lead Prospect Close Date with system date wrt Call Status values</description>
        <formula>NOT(OR(ISPICKVAL(Call_Status__c,'Call Back Later'), ISPICKVAL(Call_Status__c, 'Open')))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>No PSR on Lead</fullName>
        <actions>
            <name>PSRAssigned_to_False</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PSR_Assigned_Date_Null</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Nullify PSR fields if there is no PSR on leads</description>
        <formula>PSR_1__c = ''
&amp;&amp;
PSR_2__c = ''
&amp;&amp;
PSR_3__c = ''</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Notify Partner of Lead</fullName>
        <actions>
            <name>NotificationofNewPartnerLead</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>PleaseForwardLeadSheet</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Partner_Notified__c</field>
            <operation>equals</operation>
            <value>TODAY</value>
        </criteriaItems>
        <description>Used to send Lead Sheet to Record Owner, which will then be forwarded to Partner.</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>P360 Close Lead On Deal Creation</fullName>
        <actions>
            <name>Deal_Create_Date_Time_Now</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Lead_Record_Type_Closed</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Lead.Partner_Lead_Status__c</field>
            <operation>equals</operation>
            <value>Deal Created</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Partner_Lead_Status__c</field>
            <operation>contains</operation>
            <value>Closed-Order Through</value>
        </criteriaItems>
        <description>Change the lead record type upon conversion</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>P360 Lead Channel Partner Changed</fullName>
        <actions>
            <name>Cisco_Recommended_PSR_Null</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PSR_1_Null</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PSR_2_Null</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PSR_3_Null</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PSR_Assigned_Date_Null</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Partner_Accepted_Date_Time_Null</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Partner_Assignment_Date_Time_Now</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Partner_Lead_Status_Partner_Assigned</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Viewed_By_PSR_FALSE</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>isPSRAssigned_FALSE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This is for P360 2A development.
workflow rule to update Partner Lead Status field on the basis of actions performed.</description>
        <formula>ISCHANGED(Channel_Partner__c)  &amp;&amp; 
NOT(ISBLANK(Channel_Partner__c)) 
&amp;&amp;  PRIORVALUE(Partner_Lead_Status__c) != null</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>P360 Lead Channel Partner Removal</fullName>
        <actions>
            <name>Cisco_Recommended_PSR_Null</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PSR_1_Null</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PSR_2_Null</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PSR_3_Null</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>PSR_Assigned_Date_Null</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Partner_Accepted_Date_Time_Null</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Partner_Assignment_Date_Time_Null</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Partner_Lead_Status_Null</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Viewed_By_PSR_FALSE</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>isPSRAssigned_FALSE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When channel partner is removed from Lead record</description>
        <formula>IF((ISCHANGED(Channel_Partner__c) &amp;&amp; ISBLANK(Channel_Partner__c)), TRUE, FALSE)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>P360 Originating Marketing Pipeline to Total Value</fullName>
        <actions>
            <name>P360_Originating_Marketing_Total_value</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.TotalValue__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.ProductAmount__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.ServicesAmount__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>This is to copy over Originating Marketing Pipeline to Total value if Total Value is blank on creation to Align FY14 marketing SQL metrics</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>P360 PSR Assignment to Lead</fullName>
        <actions>
            <name>PSR_Assigned_Date_Now</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Partner_Accepted_Date_Time_Now</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Partner_Lead_Status_Assigned_To_PSR</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>isPSRAssigned_TRUE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If any Partner Sales Rep(PSR 1, PSR 2 or PSR 3) is selected, then the corresponding Partner Lead Status field value is changed to ASSIGN TO PSR value.</description>
        <formula>(OR(NOT(ISBLANK(PSR_1__c)), NOT(ISBLANK(PSR_2__c)), NOT(ISBLANK(PSR_3__c)))) 
&amp;&amp;  
(ISCHANGED(PSR_1__c) || ISCHANGED(PSR_2__c) || ISCHANGED(PSR_3__c) || ISNEW())  
&amp;&amp;
(NOT(isPSRAssigned__c))
&amp;&amp; NOT( ISPICKVAL(Partner_Lead_Status__c , 'Actively Working') )
&amp;&amp; NOT( ISPICKVAL(Partner_Lead_Status__c , 'Deal Created') )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>P360 PSR Assignment to Lead - Reporting</fullName>
        <actions>
            <name>PSR_Assigned_Date_Now</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Partner_Accepted_Date_Time_Now</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>isPSRAssigned_TRUE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If any Partner Sales Rep(PSR 1, PSR 2 or PSR 3) is selected, then the corresponding reporting fields need to be updated</description>
        <formula>(OR(    NOT(ISBLANK(PSR_1__c)),     NOT(ISBLANK(PSR_2__c)),     NOT(ISBLANK(PSR_3__c))))  &amp;&amp;  (ISCHANGED(PSR_1__c) || ISCHANGED(PSR_2__c) || ISCHANGED(PSR_3__c) || ISNEW())  &amp;&amp;  (NOT(isPSRAssigned__c))  &amp;&amp; NOT( ISPICKVAL(Partner_Lead_Status__c , 'Actively Working') )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>P360 PSR Assignment to Lead - Status</fullName>
        <actions>
            <name>Partner_Lead_Status_Assigned_To_PSR</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If any Partner Sales Rep(PSR 1, PSR 2 or PSR 3) is selected when the current Partner Lead Status is Partner Assigned, then the corresponding Partner Lead Status field value is changed to ASSIGN TO PSR value.</description>
        <formula>(OR (NOT(ISBLANK(PSR_1__c)), NOT(ISBLANK(PSR_2__c)), NOT(ISBLANK(PSR_3__c))))   
&amp;&amp;   
(ISCHANGED(PSR_1__c) || ISCHANGED(PSR_2__c) || ISCHANGED(PSR_3__c) || ISNEW())   
&amp;&amp;   
(NOT(isPSRAssigned__c))   
&amp;&amp;  
( ISPICKVAL(Partner_Lead_Status__c , 'Partner Assigned') )  
&amp;&amp; 
NOT(OR( ISPICKVAL(Partner_Lead_Status__c,'Rejected-Invalid Contact'), ISPICKVAL(Partner_Lead_Status__c,'Rejected-Already Deal'), ISPICKVAL(Partner_Lead_Status__c,'Rejected-Project Canceled'), ISPICKVAL(Partner_Lead_Status__c,'Rejected-Lost to Competition'), ISPICKVAL(Partner_Lead_Status__c,'Rejected-Not My Territory/Account'), ISPICKVAL(Partner_Lead_Status__c,'Rejected-No Customer Response'), ISPICKVAL(Partner_Lead_Status__c,'Rejected-Duplicate'), ISPICKVAL(Partner_Lead_Status__c,'Rejected-No Valid Project'),ISPICKVAL(Partner_Lead_Status__c,'Deal Created') ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>P360 Partner%2FPSR Assigned Date For Partner Uploaded Leads</fullName>
        <actions>
            <name>PSR_Assigned_Date_Now</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Partner_Assignment_Date_Time_Now</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>isPSRAssigned_TRUE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This will update partner assigned date when lead is uploaded by partner.</description>
        <formula>$User.ProfileId =$Setup.ProfileID__c.Partner360_Portal_Profile__c</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>P360 SQL FLAG Update</fullName>
        <actions>
            <name>P360_SQL_FLAG_Checked</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Lead.Partner_Lead_Status__c</field>
            <operation>equals</operation>
            <value>Actively Working,Deal Created,Closed-Order Through Stock,Closed-Order Through Disti</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.SQL_FLAG__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>This workflow will set The "SQL FLAG" when a Lead ever has one of the below status values to preserve the SQL status &amp; values and will remain "Checked" in future

. Actively Working
. Closed through disti
. Closed through stock
. Deal created</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>P360 Total Value Update With Product  And Service Amount</fullName>
        <actions>
            <name>P360_Total_Value_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow will update  "Total Value"  field with the sum of  Estimated Product Value and Estimated Service Value, whenever these are entered</description>
        <formula>ISCHANGED(ProductAmount__c) || ISCHANGED(ServicesAmount__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>P360 Update Address Fields on Lead For APJC Users</fullName>
        <actions>
            <name>Address_Line1_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Address_Line2_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>City_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>State_Province_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Zip_PostalCode_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This Workflow rule is Created for the requirement- When the End Customer Account Name is Selected, Populate the Company Address Local Fields onto the corresponding Lead fields only for Chinese and Korean Accounts</description>
        <formula>NOT(ISBLANK(End_Customer_Account__c)) &amp;&amp;  (ISCHANGED(End_Customer_Account__c)  || ISNEW()) &amp;&amp;  (UPPER( End_Customer_Account__r.CRCountry__c)  =  $Label.Country_China  ||  CONTAINS( UPPER(End_Customer_Account__r.CRCountry__c) ,  $Label.Country_Korea) || UPPER(End_Customer_Account__r.CRCountry__c)  =  $Label.Country_Japan)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>P360 Update Company Name Fields on Lead</fullName>
        <actions>
            <name>P360_Update_Company_Name_Eng_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>P360_Update_Company_Name_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This Workflow rule is Created for the requirement- When the End Customer Account Name is Selected, Populate the Company Name and Company Name English fields with the Name of End Customer Account</description>
        <formula>(ISCHANGED(End_Customer_Account__c) || ISNEW()) &amp;&amp; NOT(ISBLANK(End_Customer_Account__c))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>P360 Update PSR ID%2FName Fields with Name</fullName>
        <actions>
            <name>P360_PSR1_Name_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>P360_PSR2_Name_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>P360_PSR3_Name_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 OR 2 OR 3) OR (4 AND 5 AND 6)</booleanFilter>
        <criteriaItems>
            <field>Lead.PSR_1__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.PSR_2__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.PSR_3__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.PSR_1__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.PSR_2__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.PSR_3__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>This Workflow rule is created for CCIX</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>P360-Partner Acceptance Date</fullName>
        <actions>
            <name>Partner_Accepted_Date_Time_Now</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2 OR 3</booleanFilter>
        <criteriaItems>
            <field>Lead.Partner_Lead_Status__c</field>
            <operation>equals</operation>
            <value>Assigned To PSR</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Partner_Lead_Status__c</field>
            <operation>equals</operation>
            <value>Actively Working</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Partner_Lead_Status__c</field>
            <operation>equals</operation>
            <value>Deal Created</value>
        </criteriaItems>
        <description>Rule to update the Field P360-Partner Acceptance Date/Time based on the Partner Lead Status</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>PSR Not Assigned</fullName>
        <actions>
            <name>isPSRAssigned_FALSE</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>If psr is not assigned set is psr assigned to false</description>
        <formula>ISBLANK(PSR_1__c)
&amp;&amp;
ISBLANK(PSR_2__c)
&amp;&amp;
ISBLANK(PSR_3__c)
&amp;&amp;
isPSRAssigned__c</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Partner Actively Working Date</fullName>
        <actions>
            <name>Partner_Actively_Working_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Date/Time when partner status was changed to Actively Working</description>
        <formula>ISPICKVAL(Partner_Lead_Status__c, 'Actively Working')
&amp;&amp;
 ISBLANK(Partner_Actively_Working_Date__c)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Product %2B Service %3D Total Value</fullName>
        <actions>
            <name>P360_Total_Value_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR  2</booleanFilter>
        <criteriaItems>
            <field>Lead.ProductAmount__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.ServicesAmount__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>When product or service amount is provided, total value = product + service</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Sourcefire Rejected Leads</fullName>
        <actions>
            <name>Sourcefire_Rejected_Leads_Rule_3_4_Rule_3_7</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Lead_Status_Update_to_Rejected_NotTer</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>3 AND (1 OR 2)</booleanFilter>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>equals</operation>
            <value>3.4 Rejected-Enterprise/Named,3.7 Rejected-Not My Territory/Account</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>equals</operation>
            <value>3.7 Rejected-Not My Territory/Account</value>
        </criteriaItems>
        <criteriaItems>
            <field>Lead.SourceFire_Lead_source__c</field>
            <operation>equals</operation>
            <value>SourceFire</value>
        </criteriaItems>
        <description>Lead Status Rejection Rule -3.7 Rejected-Not My Territory/Account</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update product and services amount</fullName>
        <actions>
            <name>P360_Estimated_Product_Amount</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>P360_Estimated_Service_Amount</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Round product an services amount when entered during creation or update</description>
        <formula>OR(     ISNEW(),      ISCHANGED( ProductAmount__c ),       ISCHANGED( ServicesAmount__c )    )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>zzNGCC Lead Pre Prospect Creation</fullName>
        <actions>
            <name>Dedupe_Field_Set</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Lead.Status</field>
            <operation>equals</operation>
            <value>Pre-Prospect</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <tasks>
        <fullName>PLOCLeadAcceptanceReminder2day</fullName>
        <assignedToType>owner</assignedToType>
        <description>Email generated to lead owner:
It has been 2 days since we have assigned this lead to you. Please review this lead as soon as possible and please accept or reject the lead.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Completed</status>
        <subject>PLOC: Lead Acceptance Reminder- 2 day</subject>
    </tasks>
    <tasks>
        <fullName>PleaseForwardLeadSheet</fullName>
        <assignedToType>owner</assignedToType>
        <description>Please forward email notification to the appropriate partner.  Email was just sent to you.</description>
        <dueDateOffset>0</dueDateOffset>
        <notifyAssignee>true</notifyAssignee>
        <priority>High</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Please Forward Lead Sheet</subject>
    </tasks>
</Workflow>
