<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>CX_Send_email_when_Master_Case_number_is_populated</fullName>
        <description>CX - Send email when Master Case number is populated</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>cisco_sales_case_management@external.cisco.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>CX_Email_templates/CX_CASE_ASSIGNED_TO_MASTER_CASE</template>
    </alerts>
    <alerts>
        <fullName>CX_Status_update_email</fullName>
        <description>CX-Status update email</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>cisco_sales_case_management@external.cisco.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>CX_Email_templates/CX_STATUS_UPDATE2</template>
    </alerts>
    <alerts>
        <fullName>Case_Assigned_to_CWR_Queue</fullName>
        <ccEmails>cwrhelp@cisco.com</ccEmails>
        <description>Case Assigned to CWR Queue</description>
        <protected>false</protected>
        <recipients>
            <recipient>CWR_Group_Users</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>donotreply-sfdc@cisco.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Cases/CWR_Queue_Email_Notification</template>
    </alerts>
    <alerts>
        <fullName>Case_Close_Email_CIC_Cisco</fullName>
        <description>Case Close Email CIC Cisco</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderAddress>donotreply-ciscosales@cisco.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Cases/Case_Close_HtmlEmail_Template_CIC</template>
    </alerts>
    <alerts>
        <fullName>Case_Close_Email_PDI_Cisco</fullName>
        <description>Case Close Email PDI Cisco</description>
        <protected>false</protected>
        <recipients>
            <field>Cisco_Contact__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>cisco_sales_case_management@external.cisco.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Cases/Case_Close_Email_Template_PDI</template>
    </alerts>
    <alerts>
        <fullName>Case_Close_Email_PDI_Partner</fullName>
        <description>Case Close Email PDI Partner</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>cisco_sales_case_management@external.cisco.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Cases/Case_Close_Email_Template_PDI</template>
    </alerts>
    <alerts>
        <fullName>Case_Creation_Email_CIC_Cisco</fullName>
        <description>Case Creation Email CIC Cisco</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderAddress>donotreply-ciscosales@cisco.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Cases/Case_Creation_HtmlEmail_Template_CIC</template>
    </alerts>
    <alerts>
        <fullName>Case_Creation_Email_PDI_Cisco</fullName>
        <description>Case Creation Email PDI Cisco</description>
        <protected>false</protected>
        <recipients>
            <field>Cisco_Contact__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>cisco_sales_case_management@external.cisco.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Cases/Case_Creation_Email_Template_PDI</template>
    </alerts>
    <alerts>
        <fullName>Case_Creation_Email_PDI_Partner</fullName>
        <description>Case Creation Email PDI Partner</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>cisco_sales_case_management@external.cisco.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Cases/Case_Creation_Email_Template_PDI_Letterhead</template>
    </alerts>
    <alerts>
        <fullName>Case_Owner_Change_notification</fullName>
        <description>Case Owner Change notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>donotreply-ciscosales@cisco.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Cases/Case_Owner_Change_Notification</template>
    </alerts>
    <alerts>
        <fullName>Case_PDI_In_NEW_for_more_than_one_hour</fullName>
        <description>Case PDI In NEW for more than one hour</description>
        <protected>false</protected>
        <recipients>
            <field>PDI_Queue_Email__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>cisco_sales_case_management@external.cisco.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>PDI_Email_Templates/Case_PDI_In_NEW_for_more_than_one_hour</template>
    </alerts>
    <alerts>
        <fullName>Case_PDI_pending_more_than_5_days</fullName>
        <description>Case PDI pending more than 5 days</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>cisco_sales_case_management@external.cisco.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>PDI_Email_Templates/Case_PDI_pending_more_than_5_days</template>
    </alerts>
    <alerts>
        <fullName>Case_Status_Resolved_Pending_Email_TSN_Cisco</fullName>
        <description>Case Status Resolved Pending Email TSN Cisco</description>
        <protected>false</protected>
        <recipients>
            <field>Cisco_Contact__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>cisco_sales_case_management@external.cisco.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Cases/TSN_Case_Resolved_Pending_Email_Template_Cisco_Custom</template>
    </alerts>
    <alerts>
        <fullName>Case_Status_Resolved_Pending_Email_TSN_Partner</fullName>
        <description>Case Status Resolved Pending Email TSN Partner</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>cisco_sales_case_management@external.cisco.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Cases/TSN_Resolved_Pending_Email_Partner_VF</template>
    </alerts>
    <alerts>
        <fullName>CloseCaseBounceEmailPDI</fullName>
        <description>CloseCaseBounceEmailPDI</description>
        <protected>false</protected>
        <recipients>
            <field>BounceBackEmailId__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>cisco_sfdc_case_admin@external.cisco.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Cases/Case_Close_Bounce_PDI_Email_Template_Custom</template>
    </alerts>
    <alerts>
        <fullName>CloseCaseBounceEmailTSNCisco</fullName>
        <description>CloseCaseBounceEmailTSNCisco</description>
        <protected>false</protected>
        <recipients>
            <field>BounceBackEmailId__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>cisco_sfdc_case_admin@external.cisco.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Cases/Case_Close_Bounce_TSN_Email_Template_VF</template>
    </alerts>
    <alerts>
        <fullName>CloseCaseBounceEmailTSNPartner</fullName>
        <description>CloseCaseBounceEmailTSNPartner</description>
        <protected>false</protected>
        <recipients>
            <field>BounceBackEmailId__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>cisco_sfdc_case_admin@external.cisco.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Cases/Case_Close_Bounce_TSN_Email_Partner_VF</template>
    </alerts>
    <alerts>
        <fullName>Close_Case_TSN_Email</fullName>
        <ccEmails>tsn-icdr@cisco.com;</ccEmails>
        <description>Close Case TSN Email</description>
        <protected>false</protected>
        <senderAddress>cisco_sales_case_management@external.cisco.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Cases/TSN_Case_Close_Email_VF</template>
    </alerts>
    <alerts>
        <fullName>Competitive_War_Room_Case_Notification</fullName>
        <ccEmails>cwrhelp@cisco.com</ccEmails>
        <description>Competitive War Room Case Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>CWR_Group_Users</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>donotreply-sfdc@cisco.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Cases/Competitive_War_Room_case</template>
    </alerts>
    <alerts>
        <fullName>GVE_CEG_Escalation_Alert</fullName>
        <ccEmails>gve-competitive@cisco.com</ccEmails>
        <description>GVE CEG Escalation Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Cases/GVE_CEG_Escalation_Alert</template>
    </alerts>
    <alerts>
        <fullName>GVE_Case_Creation_Email_Cisco</fullName>
        <description>GVE_Case Creation Email Cisco</description>
        <protected>false</protected>
        <recipients>
            <field>Cisco_Contact__c</field>
            <type>email</type>
        </recipients>
        <senderAddress>cisco_sales_case_management@external.cisco.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Cases/GVECase_Creation_Email_Template_Cisco_Latest</template>
    </alerts>
    <alerts>
        <fullName>GVE_Case_Creation_Email_Partner</fullName>
        <description>GVE_Case_Creation_Email_Partner</description>
        <protected>false</protected>
        <recipients>
            <field>ContactEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>cisco_sales_case_management@external.cisco.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Cases/GVE_Case_Creation_Email_Partner_Latest</template>
    </alerts>
    <alerts>
        <fullName>GVE_Case_Creation_Email_to_Partner_for_Web_Cases</fullName>
        <description>GVE Case Creation Email to Partner for Web Cases</description>
        <protected>false</protected>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>cisco_sales_case_management@external.cisco.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Cases/GVE_Case_Creation_Email_Partner_Latest</template>
    </alerts>
    <alerts>
        <fullName>GWR_Team_case_is_created</fullName>
        <ccEmails>cwrhelp@cisco.com</ccEmails>
        <description>GWR Team case is created</description>
        <protected>false</protected>
        <recipients>
            <recipient>CWR_Group_Users</recipient>
            <type>group</type>
        </recipients>
        <senderAddress>donotreply-ciscosales@cisco.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Cases/GWR_Team_case</template>
    </alerts>
    <alerts>
        <fullName>New_Customer_Success_Adoption_Requests</fullName>
        <description>New Customer Success Adoption Requests</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Customer_Success_Adoption_Requests/New_Customer_Success_Adoption_Requests</template>
    </alerts>
    <alerts>
        <fullName>PDI_Case_Creation_Email_for_DNA_Mentoring</fullName>
        <ccEmails>pdita-dna-alerts@cisco.com</ccEmails>
        <description>PDI - Case Creation Email for DNA_Mentoring</description>
        <protected>false</protected>
        <senderAddress>cisco_sales_case_management@external.cisco.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Cases/PDI_Create_Email_Internal_Custom</template>
    </alerts>
    <alerts>
        <fullName>PDI_Partner_Email_Notification</fullName>
        <description>PDI Partner Email Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>cisco_sales_case_management@external.cisco.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Cases/PDI_Partner_Email_Notification</template>
    </alerts>
    <alerts>
        <fullName>PDI_Web_Agent_Case_Creation_Email_for_Smart_Net_Total_Care</fullName>
        <ccEmails>pdita-sntc-alerts@cisco.com</ccEmails>
        <description>PDI -Web/Agent Case Creation Email for Smart Net Total Care</description>
        <protected>false</protected>
        <senderAddress>cisco_sales_case_management@external.cisco.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Cases/PDI_Create_Email_Internal_Custom</template>
    </alerts>
    <alerts>
        <fullName>PSTS_Case_Follow_up_Missed</fullName>
        <description>PSTS Case Follow up Missed</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>donotreply-sfdc@cisco.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Cases/PSTS_Case_Follow_up_Missed</template>
    </alerts>
    <alerts>
        <fullName>PXS_Submission_Email_Alert</fullName>
        <description>PXS Submission Email Alert</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Case_Requester__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>donotreply-ciscosales@cisco.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Cases/PXS_Case_Submission_Alert_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>PXS_Survey_Email_Alert</fullName>
        <description>PXS Survey Email Alert Process Builder - PXS Submission Email Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>BE</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Legal</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Other</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>PSS</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>SE</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <recipient>Service Sales</recipient>
            <type>caseTeam</type>
        </recipients>
        <recipients>
            <type>owner</type>
        </recipients>
        <recipients>
            <field>Case_Requester__c</field>
            <type>userLookup</type>
        </recipients>
        <senderAddress>donotreply-ciscosales@cisco.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Cases/PXS_FSAT_Survey_Email_Template</template>
    </alerts>
    <alerts>
        <fullName>Web_Agent_Case_Creation_Email_Emerging_Technologies</fullName>
        <ccEmails>pdita-en@cisco.com</ccEmails>
        <description>Web/Agent Case Creation Email PDI Emerging Technologies</description>
        <protected>false</protected>
        <senderAddress>cisco_sales_case_management@external.cisco.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Cases/PDI_Create_Email_Internal_Custom</template>
    </alerts>
    <alerts>
        <fullName>Web_Agent_Case_Creation_Email_PDI_Borderless_Networks</fullName>
        <ccEmails>pdita-en@cisco.com;</ccEmails>
        <description>Web/Agent Case Creation Email PDI Borderless Networks</description>
        <protected>false</protected>
        <senderAddress>cisco_sales_case_management@external.cisco.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Cases/PDI_Create_Email_Internal_Custom</template>
    </alerts>
    <alerts>
        <fullName>Web_Agent_Case_Creation_Email_PDI_Collaboration_East</fullName>
        <ccEmails>pdihd-uc@cisco.com;</ccEmails>
        <description>Web/Agent Case Creation Email PDI Collaboration East</description>
        <protected>false</protected>
        <senderAddress>cisco_sales_case_management@external.cisco.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Cases/PDI_Create_Email_Internal_Custom</template>
    </alerts>
    <alerts>
        <fullName>Web_Agent_Case_Creation_Email_PDI_Collaboration_West</fullName>
        <ccEmails>pdihd-uc@cisco.com;</ccEmails>
        <description>Web/Agent Case Creation Email PDI Collaboration West</description>
        <protected>false</protected>
        <senderAddress>cisco_sales_case_management@external.cisco.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Cases/PDI_Create_Email_Internal_Custom</template>
    </alerts>
    <alerts>
        <fullName>Web_Agent_Case_Creation_Email_PDI_Data_Center</fullName>
        <ccEmails>pdita-dc@cisco.com;</ccEmails>
        <description>Web/Agent Case Creation Email PDI Data Center</description>
        <protected>false</protected>
        <senderAddress>cisco_sales_case_management@external.cisco.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Cases/PDI_Create_Email_Internal_Custom</template>
    </alerts>
    <alerts>
        <fullName>Web_Case_Creation_Email_PDI</fullName>
        <description>Web Case Creation Email PDI</description>
        <protected>false</protected>
        <recipients>
            <field>SuppliedEmail</field>
            <type>email</type>
        </recipients>
        <senderAddress>cisco_sales_case_management@external.cisco.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Cases/Case_Creation_Email_Template_PDI_Letterhead</template>
    </alerts>
    <fieldUpdates>
        <fullName>CX_Field_update_CX_Status_Change_Date</fullName>
        <description>Update CX Case Status field</description>
        <field>CX_Status_Change_Date__c</field>
        <formula>TODAY()</formula>
        <name>CX Field update CX Status Change Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_PDI_Queue_Email_Update</fullName>
        <field>PDI_Queue_Email__c</field>
        <formula>CASE(
TEXT(Queue__c) ,
'PDI Borderless Networks','pdita-en@cisco.com',
'PDI Collaboration East', 'pdita-uc@cisco.com',
'PDI Collaboration West', 'pdita-uc@cisco.com',
'PDI Data Center','pdita-dc@cisco.com',
'PDI Smart Net Total Care', 'pdita-sntc-alerts@cisco.com',
'PDI DNA Mentoring', 'pdita-dna-alerts@cisco.com',
''
)</formula>
        <name>Case PDI Queue Email Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Status_Updated</fullName>
        <field>Status</field>
        <literalValue>Updated</literalValue>
        <name>Case Status - Updated</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Theater_APJC</fullName>
        <description>Set Case Theater APJC</description>
        <field>Case_Theater__c</field>
        <literalValue>APJC</literalValue>
        <name>Case Theater APJC</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Theater_Americas</fullName>
        <description>set Case Theater Americas</description>
        <field>Case_Theater__c</field>
        <literalValue>Americas</literalValue>
        <name>Case Theater Americas</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Case_Theater_EMEA</fullName>
        <description>set Case Theater EMEA</description>
        <field>Case_Theater__c</field>
        <literalValue>EMEA</literalValue>
        <name>Case Theater EMEA</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Cx_Queue_Assigned_NEW</fullName>
        <description>Cx Queue Assigned_NEW</description>
        <field>Status</field>
        <literalValue>Queue Assigned</literalValue>
        <name>Cx Queue Assigned_NEW</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Deal_Size_Estimate_Update</fullName>
        <description>Deal Size Estimate Update</description>
        <field>Subtotal_000__c</field>
        <formula>IF(ISNULL(Product_Deal_Size_Estimate__c), 0, Product_Deal_Size_Estimate__c) + IF(ISNULL(Services_Deal_Size_Estimate__c), 0, Services_Deal_Size_Estimate__c)</formula>
        <name>Deal Size Estimate Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Engage_Record_Type_Field_Update</fullName>
        <description>This workflow rule is used to updates Engage Record Type Field.</description>
        <field>RecordTypeId</field>
        <lookupValue>Engage_Services_Resources</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>Engage_Record_Type_Field_Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>IsEngageNewFieldUpdate</fullName>
        <field>isEngageNew__c</field>
        <literalValue>1</literalValue>
        <name>IsEngageNewFieldUpdate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <reevaluateOnChange>true</reevaluateOnChange>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>PH_PDI_TSN_Transfer_Case_Status_New</fullName>
        <field>Status</field>
        <literalValue>New</literalValue>
        <name>PH/PDI/TSN Transfer Case Status New</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_Status_Change_Date_Time</fullName>
        <field>Status_Change_Date_Time__c</field>
        <formula>NOW()</formula>
        <name>Set Status Change Date/Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TSN_CaseOwner</fullName>
        <field>OwnerId</field>
        <lookupValue>Front_Line</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>TSN_CaseOwner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TSN_Case_Escalated_Flag_Update</fullName>
        <field>Escalated__c</field>
        <literalValue>1</literalValue>
        <name>TSN Case Escalated Flag Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TSN_Case_Transfer_Status_Reason_Update</fullName>
        <field>Status_Reason__c</field>
        <name>TSN Case Transfer Status Reason Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TSN_Case_Transfer_Status_Update_Assign</fullName>
        <field>Status</field>
        <literalValue>Assigned</literalValue>
        <name>TSN Case Transfer Status Update Assign</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TSN_Case_Transfer_Status_Update_Unassign</fullName>
        <field>Status</field>
        <literalValue>Unassigned</literalValue>
        <name>TSN Case Transfer Status Update Unassign</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TSN_Closed_Status</fullName>
        <field>Status</field>
        <literalValue>Closed</literalValue>
        <name>TSN Closed Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TSN_SLA_Expired_False</fullName>
        <field>SLA_Expired__c</field>
        <literalValue>0</literalValue>
        <name>TSN_SLA_Expired_False</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TSN_SLA_Rule_1hr_Expired</fullName>
        <field>SLA_Expired__c</field>
        <literalValue>1</literalValue>
        <name>TSN_SLA_Rule_1hr_Expired</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TSN_SLA_Rule_24hr_Expired</fullName>
        <field>SLA_Expired__c</field>
        <literalValue>1</literalValue>
        <name>TSN_SLA_Rule_24hr_Expired</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TSN_SLA_Rule_48hr_Expired</fullName>
        <field>SLA_Expired__c</field>
        <literalValue>1</literalValue>
        <name>TSN_SLA_Rule_48hr_Expired</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TSN_SLA_Rule_4hr_Expired</fullName>
        <field>SLA_Expired__c</field>
        <literalValue>1</literalValue>
        <name>TSN_SLA_Rule_4hr_Expired</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TSN_SLA_Rule_6hr_Expired</fullName>
        <field>SLA_Expired__c</field>
        <literalValue>1</literalValue>
        <name>TSN_SLA_Rule_6hr_Expired</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TSN_UpdateTeam_PH</fullName>
        <field>Team__c</field>
        <literalValue>GVE Tier I</literalValue>
        <name>TSN UpdateTeam PH</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TSN_UpdateTeam_Triage</fullName>
        <field>Team__c</field>
        <literalValue>Front Line</literalValue>
        <name>TSN UpdateTeam Triage</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TSN_Update_Case_Owner_PH</fullName>
        <field>OwnerId</field>
        <lookupValue>GVE_Tier_I</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>TSN Update Case Owner PH</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TSN_Update_Transferred_To</fullName>
        <field>Transferred_To__c</field>
        <name>TSN Update Transferred To</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateCaseTransferredToQueueRecordPA</fullName>
        <field>RecordTypeId</field>
        <lookupValue>Partner_Advisor_Case</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>UpdateCaseTransferredToQueueRecordPA</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateCaseTransferredToQueueRecordPDI</fullName>
        <field>RecordTypeId</field>
        <lookupValue>PDI_Case</lookupValue>
        <lookupValueType>RecordType</lookupValueType>
        <name>UpdateCaseTransferredToQueueRecordPDI</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateCaseTransferredToQueueStatus</fullName>
        <field>Status</field>
        <literalValue>New</literalValue>
        <name>UpdateCaseTransferredToQueueStatus</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateCaseTransferredToQueueStatusPA</fullName>
        <field>Status</field>
        <literalValue>Open</literalValue>
        <name>UpdateCaseTransferredToQueueStatusPA</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UpdateCaseTransferredToQueue_QueuePDI</fullName>
        <field>Queue__c</field>
        <literalValue>PDI Collaboration West</literalValue>
        <name>UpdateCaseTransferredToQueue-QueuePDI</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Opportunity_Technology</fullName>
        <field>Opportunity_Technology__c</field>
        <formula>Opportunity__r.Technology_Merge_Field__c</formula>
        <name>Update_Opportunity Technology</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Owner_Change_Date_to_CreatedDate</fullName>
        <field>Owner_Change_Date__c</field>
        <formula>CreatedDate</formula>
        <name>Update Owner Change Date to CreatedDate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Owner_Change_Time</fullName>
        <field>Owner_Change_Date__c</field>
        <formula>NOW()</formula>
        <name>Update Owner Change Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>CX - Queue assigned status</fullName>
        <actions>
            <name>Cx_Queue_Assigned_NEW</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR(    
	AND(ISNEW(),        
		RecordType.DeveloperName = 'Customer_Excellence_Case',        NOT(ISPICKVAL(Case_Queue__c, 'CX - Unassigned'))     ),
	AND(NOT(ISNEW()),        
		RecordType.DeveloperName = 'Customer_Excellence_Case',        ISCHANGED(Case_Queue__c)) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CX - Send status update</fullName>
        <actions>
            <name>CX_Status_update_email</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Send an email to Case owner and case creator when Case status changes.</description>
        <formula>ISCHANGED(Status ) &amp;&amp; 
RecordType.DeveloperName = 'Customer_Excellence_Case'</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CX Populate CX Status Change Date</fullName>
        <actions>
            <name>CX_Field_update_CX_Status_Change_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Populate date of CX Status change date</description>
        <formula>AND(      RecordType.DeveloperName = 'Customer_Excellence_Case',     ISCHANGED(Status ) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CX Send email when Master case field is populated</fullName>
        <actions>
            <name>CX_Send_email_when_Master_Case_number_is_populated</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <formula>NOT( ISBLANK( CX_Master_Case_Number__c ) ) &amp;&amp; RecordType.DeveloperName = 'Customer_Excellence_Case'</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Case Assigned to CWR Queue</fullName>
        <actions>
            <name>Case_Assigned_to_CWR_Queue</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>equals</operation>
            <value>CWR Queue</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Competitive War Room Case</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case Close Email CIC Cisco</fullName>
        <actions>
            <name>Case_Close_Email_CIC_Cisco</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed,Cancelled</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>CIC Security &amp; Trust Customer Engagement Request</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Case Close Email PDI Cisco</fullName>
        <actions>
            <name>Case_Close_Email_PDI_Cisco</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>PDI Case</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Contact_Type__c</field>
            <operation>startsWith</operation>
            <value>Cisco</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Case Close Email PDI Partner</fullName>
        <actions>
            <name>Case_Close_Email_PDI_Partner</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Closed</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>PDI Case</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Contact_Type__c</field>
            <operation>equals</operation>
            <value>Partner</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Case Creation Email CIC Cisco</fullName>
        <actions>
            <name>Case_Creation_Email_CIC_Cisco</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>CIC Security &amp; Trust Customer Engagement Request</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Case Creation Email PDI Cisco</fullName>
        <actions>
            <name>Case_Creation_Email_PDI_Cisco</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.SuppliedEmail</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>PDI Case</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Contact_Type__c</field>
            <operation>startsWith</operation>
            <value>Cisco</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Case Creation Email PDI Partner</fullName>
        <actions>
            <name>Case_Creation_Email_PDI_Partner</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.SuppliedEmail</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>PDI Case</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Contact_Type__c</field>
            <operation>equals</operation>
            <value>Partner</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Case Creation Email TSN Cisco</fullName>
        <actions>
            <name>GVE_Case_Creation_Email_Cisco</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>GVE Case</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Contact_Type__c</field>
            <operation>equals</operation>
            <value>Cisco</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Do_Not_Send_Automated_Emails__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Case Creation Email TSN Cisco</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Case Creation Email TSN Partner</fullName>
        <actions>
            <name>GVE_Case_Creation_Email_Partner</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>GVE Case</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Contact_Type__c</field>
            <operation>equals</operation>
            <value>Partner</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.SuppliedEmail</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Do_Not_Send_Automated_Emails__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Case Creation Email TSN Partner</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Case Owner Change notification</fullName>
        <actions>
            <name>Case_Owner_Change_notification</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <formula>AND(ISCHANGED(OwnerId),RecordTypeId == $Setup.ObjectRecordTypeIds__c.Competitive_War_Room_Case_RT__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case PDI In NEW for more than one hour</fullName>
        <active>false</active>
        <formula>$RecordType.DeveloperName = 'PDI_Case'  &amp;&amp;  ISPICKVAL(Status , 'New') &amp;&amp;  NOT( MOD(TODAY() - DATE(1900, 1, 7), 7) = 0  ||  MOD(TODAY() - DATE(1900, 1, 7), 7) = 6 )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <timeLength>2</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <timeLength>4</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <timeLength>6</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Case_PDI_In_NEW_for_more_than_one_hour</name>
                <type>Alert</type>
            </actions>
            <timeLength>8</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <timeLength>9</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <timeLength>10</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <timeLength>3</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <timeLength>5</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <timeLength>7</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Case PDI Pending more than 5 days</fullName>
        <active>false</active>
        <formula>$RecordType.DeveloperName = 'PDI_Case' &amp;&amp;  NOT(ISPICKVAL(Status , 'Closed'))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Case_PDI_pending_more_than_5_days</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Case.LastModifiedDate</offsetFromField>
            <timeLength>5</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Case_PDI_pending_more_than_5_days</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Case.LastModifiedDate</offsetFromField>
            <timeLength>6</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Case_PDI_pending_more_than_5_days</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Case.LastModifiedDate</offsetFromField>
            <timeLength>9</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Case_PDI_pending_more_than_5_days</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Case.LastModifiedDate</offsetFromField>
            <timeLength>10</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Case_PDI_pending_more_than_5_days</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Case.LastModifiedDate</offsetFromField>
            <timeLength>13</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Case_PDI_pending_more_than_5_days</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Case.LastModifiedDate</offsetFromField>
            <timeLength>14</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Case_PDI_pending_more_than_5_days</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Case.LastModifiedDate</offsetFromField>
            <timeLength>7</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Case_PDI_pending_more_than_5_days</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Case.LastModifiedDate</offsetFromField>
            <timeLength>8</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Case_PDI_pending_more_than_5_days</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Case.LastModifiedDate</offsetFromField>
            <timeLength>11</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
        <workflowTimeTriggers>
            <actions>
                <name>Case_PDI_pending_more_than_5_days</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Case.LastModifiedDate</offsetFromField>
            <timeLength>12</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Case PDI Queue Email Update</fullName>
        <actions>
            <name>Case_PDI_Queue_Email_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>OR(ISNEW(),ISCHANGED(Queue__c)) &amp;&amp; $RecordType.DeveloperName = 'PDI_Case'</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case Status Change</fullName>
        <actions>
            <name>Set_Status_Change_Date_Time</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(Status)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Case Status Resolved Pending Email TSN Cisco</fullName>
        <actions>
            <name>Case_Status_Resolved_Pending_Email_TSN_Cisco</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5 AND 6</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>GVE Case</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Contact_Type__c</field>
            <operation>equals</operation>
            <value>Cisco</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Resolved Pending</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status_Reason__c</field>
            <operation>equals</operation>
            <value>Resolved Successfully</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Do_Not_Send_Automated_Emails__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>equals</operation>
            <value>Cisco_Sales_Cases</value>
        </criteriaItems>
        <description>Email to Cisco contact  when the case status is "Resolved Pending".</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Case Status Resolved Pending Email TSN Partner</fullName>
        <actions>
            <name>Case_Status_Resolved_Pending_Email_TSN_Partner</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>GVE Case</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Contact_Type__c</field>
            <operation>equals</operation>
            <value>Partner</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Resolved Pending</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status_Reason__c</field>
            <operation>equals</operation>
            <value>Resolved Successfully</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Do_Not_Send_Automated_Emails__c</field>
            <operation>equals</operation>
            <value>False</value>
        </criteriaItems>
        <description>Email to Partner contact when the case status is "Resolved Pending".</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Case Theater APJC</fullName>
        <actions>
            <name>Case_Theater_APJC</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Set Case Theater to APJC</description>
        <formula>ISPICKVAL(Case_Theater__c, '') &amp;&amp; ISPICKVAL(Account.Geographic_Region__c, 'APJC')</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Case Theater Americas</fullName>
        <actions>
            <name>Case_Theater_Americas</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Set Case Theater to Americas</description>
        <formula>ISPICKVAL(Case_Theater__c, '') &amp;&amp; ISPICKVAL(Account.Geographic_Region__c, 'Americas')</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Case Theater EMEA</fullName>
        <actions>
            <name>Case_Theater_EMEA</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Set Case Theater to EMEA</description>
        <formula>ISPICKVAL(Case_Theater__c, '') &amp;&amp; ISPICKVAL(Account.Geographic_Region__c, 'EMEA')</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>CloseCaseBounceEmailPDI</fullName>
        <actions>
            <name>CloseCaseBounceEmailPDI</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <formula>AND( ISCHANGED( BounceBackEmailCounter__c ) , BounceBackEmailCounter__c !=0, $RecordType.DeveloperName = 'PDI_Case' )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CloseCaseBounceEmailTSNCisco</fullName>
        <actions>
            <name>CloseCaseBounceEmailTSNCisco</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>used for close case bounce email TSN</description>
        <formula>AND( ISCHANGED( BounceBackEmailCounter__c ) , BounceBackEmailCounter__c !=0, RecordTypeId =  $Setup.ObjectRecordTypeIds__c.Case_TSN_RecordType__c , ISPICKVAL(Contact_Type__c, 'Cisco') )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CloseCaseBounceEmailTSNPartner</fullName>
        <actions>
            <name>CloseCaseBounceEmailTSNPartner</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Used for close TSN case bounce email for Contact Type 'Partner'</description>
        <formula>AND( ISCHANGED( BounceBackEmailCounter__c ) , BounceBackEmailCounter__c !=0, RecordTypeId =  $Setup.ObjectRecordTypeIds__c.Case_TSN_RecordType__c ,   ISPICKVAL(Contact_Type__c, 'Partner')   )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Deal Size Estimate Field Update</fullName>
        <actions>
            <name>Deal_Size_Estimate_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Deal Size Estimate Field Update</description>
        <formula>ISCHANGED(Product_Deal_Size_Estimate__c) ||  ISCHANGED(Services_Deal_Size_Estimate__c) || 
ISNEW()</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Engagecase_Record_Type_Update</fullName>
        <actions>
            <name>Engage_Record_Type_Field_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>IsEngageNewFieldUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow rule is used to update Engage record Type field.</description>
        <formula>CreatedById=='00580000006HZb9'</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>GVE CEG Escalation Alert</fullName>
        <actions>
            <name>GVE_CEG_Escalation_Alert</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>GVE - Send email to CEG Team when CEG Flag is selected</description>
        <formula>ISCHANGED(Escalated_to_CEG__c) &amp;&amp; TEXT(Escalated_to_CEG__c) = 'Yes'</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>GVE Case Creation Email to Partner for Web Cases</fullName>
        <actions>
            <name>GVE_Case_Creation_Email_to_Partner_for_Web_Cases</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>GVE Case</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Contact_Type__c</field>
            <operation>equals</operation>
            <value>Partner</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.SuppliedEmail</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Web_CCO_ID__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <description>GVE Case Creation Email Partner for Web Cases</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>GVE Transfer Case Owner</fullName>
        <actions>
            <name>TSN_Case_Transfer_Status_Reason_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>TSN_UpdateTeam_PH</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>TSN_Update_Case_Owner_PH</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Updates Case Owner to PH Team on Record Type Transfer</description>
        <formula>AND( !ISNEW(), ISCHANGED( RecordTypeId ), RecordTypeId  ==  $Setup.ObjectRecordTypeIds__c.Case_TSN_RecordType__c  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>GWR Team case is created</fullName>
        <actions>
            <name>GWR_Team_case_is_created</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Competitive War Room Case</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Team__c</field>
            <operation>equals</operation>
            <value>GWR</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>New CWR Case is created</fullName>
        <actions>
            <name>Competitive_War_Room_Case_Notification</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <formula>AND(RecordTypeId == $Setup.ObjectRecordTypeIds__c.Competitive_War_Room_Case_RT__c, Send_Email_Notification__c = TRUE)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>PDI - Case Creation Email for DNA_Mentoring</fullName>
        <actions>
            <name>PDI_Case_Creation_Email_for_DNA_Mentoring</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>PDI Case</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Queue__c</field>
            <operation>equals</operation>
            <value>PDI DNA Mentoring</value>
        </criteriaItems>
        <description>Email sent for upon PDI - Case Creation Email for DNA_Mentoring</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>PDI -Web%2FAgent Case Creation Email for Smart Net Total Care</fullName>
        <actions>
            <name>PDI_Web_Agent_Case_Creation_Email_for_Smart_Net_Total_Care</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND (3 OR 4)</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>PDI Case</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Queue__c</field>
            <operation>equals</operation>
            <value>PDI Smart Net Total Care</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.CCO_Search_Result_Updated__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Web_CCO_ID__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>PDI-Web/Agent Case Creation Email for Smart Net Total Care</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>PDI Partner Email Notification</fullName>
        <actions>
            <name>PDI_Partner_Email_Notification</name>
            <type>Alert</type>
        </actions>
        <actions>
            <name>Case_Status_Updated</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>PDI Owner notified when Partner sends an email to the Case</description>
        <formula>AND(ISCHANGED(Partner_Email_Date__c),  !(ISPICKVAL(Status,'Closed')), $RecordType.Name == 'PDI Case', !(BEGINS(OwnerId, '00G'))  ,
OwnerId != '00580000003FrC4' 
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PH%2FPDI%2FTSN Transfer Case Status New</fullName>
        <actions>
            <name>PH_PDI_TSN_Transfer_Case_Status_New</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>PH/PDI/TSN Transfer Case Status New</description>
        <formula>AND(!ISNEW(), ISCHANGED( RecordTypeId ), 
OR( 
RecordTypeId ==  $Setup.ObjectRecordTypeIds__c.PDI_Case__c , 
RecordTypeId ==  $Setup.ObjectRecordTypeIds__c.PH_Case__c  , 
RecordTypeId ==  $Setup.ObjectRecordTypeIds__c.Case_TSN_RecordType__c  
) 
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PSTS Case Follow up Missed</fullName>
        <active>false</active>
        <description>PSTS Case Follow up Missed</description>
        <formula>RecordTypeId =  $Setup.ObjectRecordTypeIds__c.PSTS_Case__c &amp;&amp;
TEXT(Status) != 'Closed' &amp;&amp;
Next_Action_Due_Date__c &lt; Today()</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>PSTS_Case_Follow_up_Missed</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Case.Next_Action_Due_Date__c</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>TSN Case Closure</fullName>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>GVE Case</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Resolved Pending</value>
        </criteriaItems>
        <description>This work flow is used for automatic TSN Case Closure</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>TSN_Closed_Status</name>
                <type>FieldUpdate</type>
            </actions>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>TSN Case Closure Email</fullName>
        <active>false</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>GVE Case</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Contact_Type__c</field>
            <operation>equals</operation>
            <value>Cisco</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status</field>
            <operation>equals</operation>
            <value>Resolved Pending</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Status_Reason__c</field>
            <operation>equals</operation>
            <value>Resolved Successfully</value>
        </criteriaItems>
        <description>This work flow is used for automatic TSN Case Closure Email</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Close_Case_TSN_Email</name>
                <type>Alert</type>
            </actions>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>TSN Case Escalated Flag Update</fullName>
        <actions>
            <name>TSN_Case_Escalated_Flag_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>'Escalated Flag' field will be checked whenever the case is escalated even once during its life cycle.</description>
        <formula>AND( RecordTypeId ==  $Setup.ObjectRecordTypeIds__c.Case_TSN_RecordType__c  , IsEscalated =True, Escalated__c =False )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>TSN Partner Email Notification</fullName>
        <actions>
            <name>Case_Status_Updated</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>TSN_Case_Transfer_Status_Reason_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Set Case Status as 'Updated', when requester replies to case</description>
        <formula>AND(ISCHANGED(Partner_Email_Date__c), !(ISPICKVAL(Status,'Closed')),  RecordTypeId  ==  $Setup.ObjectRecordTypeIds__c.Case_TSN_RecordType__c , !(BEGINS(OwnerId, '00G')), OwnerId != '00580000003FrC4' )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>TSN Update Case Transferred Status To Assigned</fullName>
        <actions>
            <name>TSN_Case_Transfer_Status_Reason_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>TSN_Case_Transfer_Status_Update_Assign</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>TSN_Update_Transferred_To</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update case Status to Assigned when case transferred to Engineer</description>
        <formula>AND(  ISCHANGED(OwnerId),  !BEGINS(OwnerId , '00G'),  RecordTypeId ==  $Setup.ObjectRecordTypeIds__c.Case_TSN_RecordType__c   )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>TSN Update Case Transferred Status To Unassigned</fullName>
        <actions>
            <name>TSN_Case_Transfer_Status_Reason_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>TSN_Case_Transfer_Status_Update_Unassign</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>TSN_Update_Transferred_To</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Update case status to Unassigned when case transferred to Group</description>
        <formula>ISCHANGED(OwnerId) &amp;&amp;
BEGINS(OwnerId , '00G')&amp;&amp;
RecordTypeId == $Setup.ObjectRecordTypeIds__c.Case_TSN_RecordType__c &amp;&amp;
$User.Id &lt;&gt; '005300000010pIr'</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>TSN_AM_Triage Assignment</fullName>
        <actions>
            <name>PH_PDI_TSN_Transfer_Case_Status_New</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>TSN_CaseOwner</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>TSN_UpdateTeam_Triage</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>GVE Case</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>notEqual</operation>
            <value>Cisco_Sales_Cases</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Web_CCO_ID__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.SuppliedEmail</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Assigns a TSN Case to Triage queue on the creation of Case via AM/PSS/SE users</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>TSN_SLA_Expired_False</fullName>
        <actions>
            <name>TSN_SLA_Expired_False</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>GVE Case</value>
        </criteriaItems>
        <description>Set SLA Expired to False</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>TSN_SLA_Rule_1hr</fullName>
        <active>true</active>
        <description>TSN SLA rule for Assigned SLA - 1hr</description>
        <formula>RecordTypeId == $Setup.ObjectRecordTypeIds__c.Case_TSN_RecordType__c &amp;&amp;
Case_Accepted_By_Engineer__c == False &amp;&amp;
TEXT(Assigned_SLA__c) =='1 hr' &amp;&amp;
SLA_Expired__c == False</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>TSN_SLA_Rule_1hr_Expired</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Case.CreatedDate</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>TSN_SLA_Rule_24hr</fullName>
        <active>true</active>
        <description>TSN SLA rule for Assigned SLA - 24hr</description>
        <formula>AND( RecordTypeId ==  $Setup.ObjectRecordTypeIds__c.Case_TSN_RecordType__c  ,  Case_Accepted_By_Engineer__c == False,  ISPICKVAL(Assigned_SLA__c,'24 hr'),  SLA_Expired__c == False  )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>TSN_SLA_Rule_24hr_Expired</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Case.CreatedDate</offsetFromField>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>TSN_SLA_Rule_48hr</fullName>
        <active>true</active>
        <description>TSN SLA rule for Assigned SLA - 48hr</description>
        <formula>AND( RecordTypeId ==  $Setup.ObjectRecordTypeIds__c.Case_TSN_RecordType__c  ,  Case_Accepted_By_Engineer__c == False,  ISPICKVAL(Assigned_SLA__c,'48 hr'),  SLA_Expired__c == False  )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>TSN_SLA_Rule_48hr_Expired</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Case.CreatedDate</offsetFromField>
            <timeLength>2</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>TSN_SLA_Rule_4hr</fullName>
        <active>true</active>
        <description>TSN SLA rule for Assigned SLA - 4hr</description>
        <formula>AND(  RecordTypeId ==  $Setup.ObjectRecordTypeIds__c.Case_TSN_RecordType__c  ,  Case_Accepted_By_Engineer__c == False,  ISPICKVAL(Assigned_SLA__c,'4 hr'),  SLA_Expired__c == False  )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>TSN_SLA_Rule_4hr_Expired</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Case.CreatedDate</offsetFromField>
            <timeLength>4</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>TSN_SLA_Rule_6hr</fullName>
        <active>true</active>
        <description>TSN SLA rule for Assigned SLA - 6hr as part of WR-01626.</description>
        <formula>AND(RecordTypeId == $Setup.ObjectRecordTypeIds__c.Case_TSN_RecordType__c, Case_Accepted_By_Engineer__c == False, ISPICKVAL(Assigned_SLA__c,'6 hr'), SLA_Expired__c == False)</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>TSN_SLA_Rule_6hr_Expired</name>
                <type>FieldUpdate</type>
            </actions>
            <offsetFromField>Case.CreatedDate</offsetFromField>
            <timeLength>6</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>TSN_Triage Assignment</fullName>
        <actions>
            <name>PH_PDI_TSN_Transfer_Case_Status_New</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>TSN_CaseOwner</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>TSN_UpdateTeam_Triage</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>GVE Case</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>equals</operation>
            <value>Cisco_Sales_Cases</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Team__c</field>
            <operation>equals</operation>
            <value>Front Line</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Web_CCO_ID__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.SuppliedEmail</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Assigns a TSN Case to Triage queue on the creation of Case via Triage Engineer</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update Case Transferred To Queue PA</fullName>
        <actions>
            <name>UpdateCaseTransferredToQueueRecordPA</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>UpdateCaseTransferredToQueueStatusPA</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.OwnerId</field>
            <operation>equals</operation>
            <value>Partner Advisor Queue</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Partner Advisor Case</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update Case Transferred To Queue PDI</fullName>
        <actions>
            <name>UpdateCaseTransferredToQueueRecordPDI</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>UpdateCaseTransferredToQueueStatus</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>UpdateCaseTransferredToQueue_QueuePDI</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( ISCHANGED(OwnerId), (PRIORVALUE(OwnerId) != '00580000003FrC4'), (OwnerId == '00G80000001mUl3'), ($RecordType.DeveloperName != 'PDI_Case') )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Owner Change Date On Case Update</fullName>
        <actions>
            <name>Update_Owner_Change_Time</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Owner_Change_Date__c will be populated whenever the Case owner is changed.</description>
        <formula>ISCHANGED(OwnerId)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Update Owner Change Date on Case Create</fullName>
        <actions>
            <name>Update_Owner_Change_Date_to_CreatedDate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Owner_Change_Date__c will be set to CreatedDate on Case creation.</description>
        <formula>!ISBLANK(CreatedDate)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update_Opportunity_Technology</fullName>
        <actions>
            <name>Update_Opportunity_Technology</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Technology value is directly populated from the opportunity selected.</description>
        <formula>True</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Web Case Creation Email PDI</fullName>
        <actions>
            <name>Web_Case_Creation_Email_PDI</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Case.SuppliedEmail</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>PDI Case</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Web_CCO_ID__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Web%2FAgent Case Creation Email PDI Borderless Networks</fullName>
        <actions>
            <name>Web_Agent_Case_Creation_Email_PDI_Borderless_Networks</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND (2 OR 5) AND (3 OR 4)</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>PDI Case</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Queue__c</field>
            <operation>equals</operation>
            <value>PDI Borderless Networks</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.CCO_Search_Result_Updated__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Web_CCO_ID__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Category_PDI__c</field>
            <operation>equals</operation>
            <value>Enterprise Networking,Internet of Things</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Web%2FAgent Case Creation Email PDI Collaboration East</fullName>
        <actions>
            <name>Web_Agent_Case_Creation_Email_PDI_Collaboration_East</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND (3 OR 4)</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>PDI Case</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Queue__c</field>
            <operation>equals</operation>
            <value>PDI Collaboration East</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.CCO_Search_Result_Updated__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Web_CCO_ID__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Web%2FAgent Case Creation Email PDI Collaboration West</fullName>
        <actions>
            <name>Web_Agent_Case_Creation_Email_PDI_Collaboration_West</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND (3 OR 4)</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>PDI Case</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Queue__c</field>
            <operation>equals</operation>
            <value>PDI Collaboration West</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.CCO_Search_Result_Updated__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Web_CCO_ID__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Web%2FAgent Case Creation Email PDI Data Center</fullName>
        <actions>
            <name>Web_Agent_Case_Creation_Email_PDI_Data_Center</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND (3 OR 4)</booleanFilter>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>PDI Case</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Queue__c</field>
            <operation>equals</operation>
            <value>PDI Data Center</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.CCO_Search_Result_Updated__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Web_CCO_ID__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Web_GVE_Team Assignment</fullName>
        <actions>
            <name>TSN_UpdateTeam_PH</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>GVE Case</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>notEqual</operation>
            <value>Cisco_Sales_Cases</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Web_CCO_ID__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.SuppliedEmail</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Contact_Type__c</field>
            <operation>equals</operation>
            <value>Partner</value>
        </criteriaItems>
        <description>Assigns a TSN Case to PH Team queue on Case Creation via Web</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Web_TSN_Triage Assignment</fullName>
        <actions>
            <name>TSN_UpdateTeam_Triage</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>GVE Case</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>notEqual</operation>
            <value>Cisco_Sales_Cases</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Web_CCO_ID__c</field>
            <operation>notEqual</operation>
            <value>null</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.SuppliedEmail</field>
            <operation>notEqual</operation>
            <value>null</value>
        </criteriaItems>
        <criteriaItems>
            <field>Case.Contact_Type__c</field>
            <operation>equals</operation>
            <value>Cisco</value>
        </criteriaItems>
        <description>Assigns a TSN Case with Cisco Contact Type to Triage queue on Case Creation via Web</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
