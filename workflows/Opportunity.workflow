<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>AT_Opportunity_Owner_Notification</fullName>
        <description>AT_Opportunity_Owner_Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity_Notifications/AT_Opportunity_Owner_Notification</template>
    </alerts>
    <alerts>
        <fullName>Account_SE_Notification</fullName>
        <description>Account SE Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>Systems Engineer (Assigned Account)</recipient>
            <type>accountTeam</type>
        </recipients>
        <senderAddress>donotreply-sfdc@cisco.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Opportunity_Notifications/Account_SE_Notification</template>
    </alerts>
    <alerts>
        <fullName>Cisco_Refresh</fullName>
        <ccEmails>tn-prog-apjc@cisco.com</ccEmails>
        <description>zzCisco Refresh</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>donotreply-ciscosales@cisco.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Opportunity_Notifications/Cisco_Refresh_Request</template>
    </alerts>
    <alerts>
        <fullName>Competitor_Information</fullName>
        <description>Competitor_Information</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderAddress>competitive_analysis@cisco.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Opportunity_Notifications/Competitor_Information</template>
    </alerts>
    <alerts>
        <fullName>Deals_at_Risk</fullName>
        <ccEmails>deals-at-risk-poor-quality@cisco.com</ccEmails>
        <description>Deals at Risk</description>
        <protected>false</protected>
        <senderType>CurrentUser</senderType>
        <template>Opportunity_Notifications/Deals_at_Risk</template>
    </alerts>
    <alerts>
        <fullName>Meraki_SFDC_Opportunity_Notification</fullName>
        <description>Meraki_SFDC_Opportunity_Notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>meraki_sfdc_opportunity@cisco.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>donotreply-sfdc@cisco.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Opportunity_Notifications/Meraki_Opportunity_Notification</template>
    </alerts>
    <alerts>
        <fullName>Multinational_Account_Notification</fullName>
        <description>Multinational Account Notification</description>
        <protected>false</protected>
        <recipients>
            <type>owner</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Opportunity_Notifications/Multinational_Account_Notification</template>
    </alerts>
    <fieldUpdates>
        <fullName>APJC_APAC</fullName>
        <description>APJC-APAC</description>
        <field>Theater__c</field>
        <literalValue>APJC-APAC</literalValue>
        <name>APJC-APAC</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>APJC_Greater_China</fullName>
        <description>APJC-Greater China</description>
        <field>Theater__c</field>
        <literalValue>APJC-Greater China</literalValue>
        <name>APJC-Greater China</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>APJC_Japan</fullName>
        <description>APJC-Japan</description>
        <field>Theater__c</field>
        <literalValue>APJC-Japan</literalValue>
        <name>APJC-Japan</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Alekhya_Test</fullName>
        <field>StageName</field>
        <literalValue>5 - Closed Won</literalValue>
        <name>Alekhya_Test</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Americas_Canada</fullName>
        <description>Update Theater to Americas-Canada</description>
        <field>Theater__c</field>
        <literalValue>Americas-Canada</literalValue>
        <name>Americas-Canada</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Americas_Global_Enterprise_Segment</fullName>
        <description>Americas-US Enterprise renamed to Americas-Global Enterprise Segment</description>
        <field>Theater__c</field>
        <literalValue>Americas-Global Enterprise Segment</literalValue>
        <name>Americas-Global Enterprise Segment</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Americas_LATAM</fullName>
        <description>Update Theater to Americas-LATAM</description>
        <field>Theater__c</field>
        <literalValue>Americas-LATAM</literalValue>
        <name>Americas-LATAM</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Americas_US_Commercial</fullName>
        <description>Americas-US Commercial</description>
        <field>Theater__c</field>
        <literalValue>Americas-US Commercial</literalValue>
        <name>Americas-US Commercial</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Americas_US_Public_Sector</fullName>
        <description>Americas-US Public Sector</description>
        <field>Theater__c</field>
        <literalValue>Americas-US Public Sector</literalValue>
        <name>Americas-US Public Sector</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CSMTG_Tagging</fullName>
        <description>Based on technologies field tag the opportunity</description>
        <field>Visible_to_Biz_Group_Name_s__c</field>
        <formula>Visible_to_Biz_Group_Name_s__c  &amp; ' CSMTG '</formula>
        <name>zzCSMTG Tagging</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Clear_CCW_BOM_Integrate_Quote_Status</fullName>
        <description>Clear CCW BOM Integrate Quote Status</description>
        <field>CCW_BOM_Integrated_Quote_Status__c</field>
        <name>Clear CCW BOM Integrate Quote Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Clear_CCW_Integrated_Date</fullName>
        <description>Clear CCW_Integrated Date</description>
        <field>CCW_BOM_Integrated_Date__c</field>
        <name>Clear CCW_Integrated Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Clear_CCW_QuoteId_Field</fullName>
        <description>Clear CCW_QuoteId Field</description>
        <field>CCW_BOM_Integrated_Quote_Id__c</field>
        <name>Clear CCW_QuoteId Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Deal_ID_Obtainted_Timestamp</fullName>
        <description>Deal ID Obtainted Timestamp</description>
        <field>Deal_ID_Obtainted_Timestamp__c</field>
        <formula>NOW()</formula>
        <name>Deal ID Obtainted Timestamp</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EBD_Week_In_Year</fullName>
        <field>Fiscal_Week_String__c</field>
        <formula>text(round(FLOOR((CloseDate - FY_Start_Date__c ) / 7 ) + 1,0))</formula>
        <name>EBD Week In Year</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EMEAR</fullName>
        <description>EMEAR</description>
        <field>Theater__c</field>
        <literalValue>EMEAR</literalValue>
        <name>EMEAR</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ENGG_Tagging</fullName>
        <description>ENG Tagging</description>
        <field>Visible_to_Biz_Group_Name_s__c</field>
        <formula>Visible_to_Biz_Group_Name_s__c  &amp; ' ENG '</formula>
        <name>zzENG Tagging</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FY_Copy_EBD_Fiscal_Year</fullName>
        <description>Copies Fiscal Year of Expected Book Date</description>
        <field>FY_Copy__c</field>
        <formula>YEAR( FY_Start_Date__c ) + 1</formula>
        <name>FY Copy EBD Fiscal Year</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>FY_Set_EBD_Fiscal_Week</fullName>
        <description>Set Fiscal Week of Expected Book Date</description>
        <field>Fiscal_Week__c</field>
        <formula>FLOOR((CloseDate - FY_Start_Date__c ) / 7 ) + 1</formula>
        <name>FY Set EBD Fiscal Week</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Forecast_Position_to_None</fullName>
        <description>set forecast position to null when owner of the opportunity is changed</description>
        <field>Position__c</field>
        <name>Forecast Position to None</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Forecast_Status_Commit</fullName>
        <description>Forecast Status Commit</description>
        <field>Forecast_Status__c</field>
        <literalValue>Commit</literalValue>
        <name>Forecast Status Commit</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Forecast_Status_Not_Forecastable</fullName>
        <description>Forecast Status Not Forecastable</description>
        <field>Forecast_Status__c</field>
        <literalValue>Not Forecastable</literalValue>
        <name>Forecast Status Not Forecastable</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Forecast_Status_Update</fullName>
        <description>Update Forecast Status to Upside</description>
        <field>Forecast_Status__c</field>
        <literalValue>Upside</literalValue>
        <name>Forecast Status Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Forecast_Status_Upside</fullName>
        <description>Forecast Status Upside</description>
        <field>Forecast_Status__c</field>
        <literalValue>Upside</literalValue>
        <name>Forecast Status Upside</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Global_Enterprise</fullName>
        <description>Global Enterprise</description>
        <field>Theater__c</field>
        <literalValue>Global Enterprise</literalValue>
        <name>Global Enterprise</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Global_Service_Provider</fullName>
        <description>update Theater to Global Service Provider</description>
        <field>Theater__c</field>
        <literalValue>Global Service Provider</literalValue>
        <name>Global Service Provider</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Lost_Cancelled_Date_Time_NULL</fullName>
        <description>Sets Lost/Cancelled Date/Time to NULL</description>
        <field>Lost_Cancelled_Date_Time__c</field>
        <name>Lost/Cancelled Date/Time NULL</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>MS_Deal_Category</fullName>
        <description>Update Deal Category to Managed Service
If the partner associated with the opportunity has ‘Managed Services Partner’ set to Yes and other conditions satisfy deal category will be set Managed Service.</description>
        <field>Managed_Services__c</field>
        <literalValue>Managed Service</literalValue>
        <name>MS Deal Category</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Merged_Stage_update</fullName>
        <description>Merged Stage update</description>
        <field>StageName</field>
        <literalValue>5 - Closed Cancelled</literalValue>
        <name>Merged Stage update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Metrics_Fields_Modified_Date</fullName>
        <description>Set Metrics Field Modified Date to Today</description>
        <field>Usage_Metric_Data_Last_Modified_Date__c</field>
        <formula>Today()</formula>
        <name>Metrics Fields Modified Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NonStdDiscountApproval_Default</fullName>
        <field>Discount_Approval__c</field>
        <literalValue>None</literalValue>
        <name>NonStdDiscountApproval_Default</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NonStdProdEnhancements_Default</fullName>
        <field>Product_Enhancements__c</field>
        <literalValue>Not Required</literalValue>
        <name>NonStdProdEnhancements_Default</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NonStdTC_Default</fullName>
        <field>Non_Standard_Terms_and_Conditions__c</field>
        <literalValue>None</literalValue>
        <name>NonStdTC_Default</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Reference_Prompt</fullName>
        <field>Reference_Prompt__c</field>
        <formula>"qualified"</formula>
        <name>zzOpportunity Reference Prompt</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Set_Duplicate_Prevention</fullName>
        <description>Set Duplicate_Prevention__c field to unique value</description>
        <field>Duplicate_Prevention__c</field>
        <formula>Data_Source_Name__c + "-" + Source_Opp_ID__c</formula>
        <name>Opportunity Set Duplicate Prevention</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Status_Active</fullName>
        <description>Opportunity Status Active</description>
        <field>Opportunity_Status__c</field>
        <literalValue>Active</literalValue>
        <name>Opportunity Status Active</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Status_Booked</fullName>
        <description>Opportunity Status Booked</description>
        <field>Opportunity_Status__c</field>
        <literalValue>Booked</literalValue>
        <name>Opportunity Status Booked</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Status_Cancelled</fullName>
        <description>Opportunity Status Cancelled</description>
        <field>Opportunity_Status__c</field>
        <literalValue>Cancelled</literalValue>
        <name>Opportunity Status Cancelled</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Status_Lost</fullName>
        <description>Opportunity Status Lost</description>
        <field>Opportunity_Status__c</field>
        <literalValue>Lost</literalValue>
        <name>Opportunity Status Lost</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Value_Range_Field_Update</fullName>
        <field>Dollar_Amount_Greater_than_5M__c</field>
        <literalValue>Less than 5 Million</literalValue>
        <name>zzOpportunity Value Range Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Oppty_Lost_Cancelled_Date_Time_NOW</fullName>
        <description>Sets Opportunity Lost/Cancelled Date/Time to Now</description>
        <field>Lost_Cancelled_Date_Time__c</field>
        <formula>NOW()</formula>
        <name>Oppty Lost/Cancelled Date/Time NOW</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RemoveRequestSEName</fullName>
        <description>This workflow validation will Set the SE Status to Declined if declined by SEM</description>
        <field>Request_SE_Name__c</field>
        <name>Remove Request SE Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RolePrimaryUpdate</fullName>
        <field>Primary_Partner_Role__c</field>
        <name>zzRolePrimaryUpdate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RoleUpdate2</fullName>
        <field>Role_2__c</field>
        <name>zzRoleUpdate2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RoleUpdate3</fullName>
        <field>Role_3__c</field>
        <name>zzRoleUpdate3</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RoleUpdate4</fullName>
        <field>Role_4__c</field>
        <name>zzRoleUpdate4</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>RoleUpdate5</fullName>
        <field>Role_5__c</field>
        <name>zzRoleUpdate5</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SE_Assigned_To_True</fullName>
        <field>SE_Assigned__c</field>
        <literalValue>1</literalValue>
        <name>SE Assigned To True</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SE_Assigned_to_false</fullName>
        <field>SE_Assigned__c</field>
        <literalValue>0</literalValue>
        <name>SE Assigned to false</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SE_Engaged_to_false</fullName>
        <field>SE_Engagement_Type__c</field>
        <name>SE Engaged to false</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Null</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SE_Status_field_update</fullName>
        <field>SE_Status__c</field>
        <literalValue>Technical Close</literalValue>
        <name>SE Status field update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Service_Source_New</fullName>
        <description>Service Source_New</description>
        <field>Service_Source__c</field>
        <literalValue>New</literalValue>
        <name>Service Source_New</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Service_Source_Renewal</fullName>
        <description>Service Source_Renewal</description>
        <field>Service_Source__c</field>
        <literalValue>Renewal</literalValue>
        <name>Service Source_Renewal</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_CCW_BOM_Integration_Date</fullName>
        <description>et CCW BOM Integration timestamp to Now()</description>
        <field>CCW_BOM_Integrated_Date__c</field>
        <formula>NOW()</formula>
        <name>Set CCW BOM Integration Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Set_SE_Status</fullName>
        <description>Set SE Status field to 'No SE Assigned'</description>
        <field>SE_Status__c</field>
        <literalValue>No SE Assigned</literalValue>
        <name>Set SE Status</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_CCW_BOM_Integration_Date</fullName>
        <description>Update CCW BOM Integration Date</description>
        <field>CCW_BOM_Integrated_Date__c</field>
        <formula>NOW()</formula>
        <name>Update CCW BOM Integration Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Customer_Win_Recommendation</fullName>
        <field>Customer_Win_Recommendation__c</field>
        <literalValue>1</literalValue>
        <name>Update Customer Win Recommendation</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Expected_Product_on_Opportunity</fullName>
        <field>Expected_Product__c</field>
        <formula>Exp_TCV_Product_Rollup_000s__c</formula>
        <name>Update Expected Product on Opportunity</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Opportinty_Owner_Text_Field</fullName>
        <description>Update Opportinty Owner Text Field used for SE Oppty List View</description>
        <field>Opportunity_Owner_Text__c</field>
        <formula>LEFT(Owner.Username,Find("@", Owner.Username)-1)</formula>
        <name>Update Opportinty Owner Text Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Prior_ATR_Product</fullName>
        <field>ATR_000s_Product__c</field>
        <formula>Prior_ATR_Product_Rollup_000s__c</formula>
        <name>Update Prior ATR Product</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Prior_ATR_Service</fullName>
        <field>ATR_000s_Service__c</field>
        <formula>Prior_ATR_Service_Rollup_000s__c</formula>
        <name>Update Prior ATR Service</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Prior_TCV_Product</fullName>
        <field>Prior_TCV_000s_Product__c</field>
        <formula>Prior_TCV_Product_Rollup_000s__c</formula>
        <name>Update Prior TCV Product</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Prior_TCV_Service</fullName>
        <field>Prior_TCV_000s_Service__c</field>
        <formula>Prior_TCV_Service_Rollup_000s__c</formula>
        <name>Update Prior TCV Service</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Updating_Expected_Service</fullName>
        <field>Expected_Service__c</field>
        <formula>Exp_TCV_Service_Rollup_000s__c</formula>
        <name>Updating Expected Service</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>zzSolution_Identifier_Update</fullName>
        <description>Update Solution_Identifier__c value when ever the Solution_ID_Description__c lookup is changed</description>
        <field>Solution_Identifier__c</field>
        <formula>Solution_ID_Description__r.Solution_ID__c</formula>
        <name>zzSolution Identifier Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <outboundMessages>
        <fullName>OpportunityFieldUpdate</fullName>
        <apiVersion>33.0</apiVersion>
        <description>This outbound message will send the updated values to service source</description>
        <endpointUrl>https://renew.prod.ssi-cloud.com/crm-sfdc/ciscoinc/Opportunity/sync/soap?auth=aW50ZWdyYXRpb25fdXNlckBjaXNjb2luYy5jb218cGFzc3dvcmRvbmU=</endpointUrl>
        <fields>CloseDate</fields>
        <fields>CurrencyIsoCode</fields>
        <fields>DO_NOT_USE_SS_CONVE_PRODUCT_USD__c</fields>
        <fields>DO_NOT_USE_SS_CONVE_SERVICE_USD__c</fields>
        <fields>DealID__c</fields>
        <fields>End_Date__c</fields>
        <fields>Expected_Product__c</fields>
        <fields>Expected_Service__c</fields>
        <fields>Forecast_Status__c</fields>
        <fields>Id</fields>
        <fields>Opportunity_Status__c</fields>
        <fields>Source_Opp_ID__c</fields>
        <fields>Start_Date__c</fields>
        <fields>Tag_as_Multiyear__c</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>mule_opty_gateway_integration_user@cisco.com</integrationUser>
        <name>OpportunityFieldUpdate</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>OpptyOutboundGSTS</fullName>
        <apiVersion>8.0</apiVersion>
        <endpointUrl>https://wsgx-test-secure.cisco.com:443</endpointUrl>
        <fields>CreatedById</fields>
        <fields>Discount_Approval__c</fields>
        <fields>HasOpportunityLineItem</fields>
        <fields>Id</fields>
        <fields>LastModifiedById</fields>
        <fields>LastModifiedDate</fields>
        <fields>Parent_ID__c</fields>
        <fields>Solution_Identifier__c</fields>
        <fields>SystemModstamp</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>integration_user1@cisco.com</integrationUser>
        <name>Oppty Outbound GSTS</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>OpptyOutboundParentNonGSTS</fullName>
        <apiVersion>40.0</apiVersion>
        <endpointUrl>https://wsgx-test-secure.cisco.com:443</endpointUrl>
        <fields>AccountId</fields>
        <fields>DealID__c</fields>
        <fields>Deal_Expiration_Date__c</fields>
        <fields>Discount_Approval__c</fields>
        <fields>End_Date__c</fields>
        <fields>Expected_Product__c</fields>
        <fields>Expected_Service__c</fields>
        <fields>Forecast_Status__c</fields>
        <fields>HasOpportunityLineItem</fields>
        <fields>Id</fields>
        <fields>LastModifiedById</fields>
        <fields>LastModifiedDate</fields>
        <fields>Name</fields>
        <fields>Non_Standard_Terms_and_Conditions__c</fields>
        <fields>Non_standard_Terms_and_Conditions_Prod__c</fields>
        <fields>Non_standard_Terms_and_Conditions_Srvc__c</fields>
        <fields>Opportunity_Status__c</fields>
        <fields>OwnerId</fields>
        <fields>Parent_ID__c</fields>
        <fields>Position__c</fields>
        <fields>Product_Enhancements__c</fields>
        <fields>Solution_Identifier__c</fields>
        <fields>Start_Date__c</fields>
        <fields>SystemModstamp</fields>
        <fields>Territory2Id</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>integration_user1@cisco.com</integrationUser>
        <name>Oppty Outbound Parent Non GSTS</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>OpptyOutboundPhase</fullName>
        <apiVersion>8.0</apiVersion>
        <description>Outbound:</description>
        <endpointUrl>https://wsgx-test-secure.cisco.com:443</endpointUrl>
        <fields>CreatedById</fields>
        <fields>HasOpportunityLineItem</fields>
        <fields>Id</fields>
        <fields>LastModifiedById</fields>
        <fields>LastModifiedDate</fields>
        <fields>Parent_ID__c</fields>
        <fields>Solution_Identifier__c</fields>
        <fields>SystemModstamp</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>integration_user1@cisco.com</integrationUser>
        <name>Oppty Outbound Phase</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>PWNotificationOpptyOwnerChange</fullName>
        <apiVersion>8.0</apiVersion>
        <description>This Workflow rule will notify Partner Workspace (PDR/ICW) that the opportunity owner has been changed in SFDC.</description>
        <endpointUrl>https://wsgx-test-secure.cisco.com:443</endpointUrl>
        <fields>CreatedDate</fields>
        <fields>Id</fields>
        <fields>LastModifiedDate</fields>
        <fields>OwnerId</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>cisco_integration_user3@cisco.com</integrationUser>
        <name>PW Notification Oppty Owner Change</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <outboundMessages>
        <fullName>PWNotificationOpptyPositionChange</fullName>
        <apiVersion>8.0</apiVersion>
        <description>This Workflow rule will notify Partner Workspace (PDR/ICW) that the opportunity forecasting position has been changed in SFDC.</description>
        <endpointUrl>https://wsgx-test-secure.cisco.com:443</endpointUrl>
        <fields>CreatedDate</fields>
        <fields>Id</fields>
        <fields>LastModifiedDate</fields>
        <fields>Position__c</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>cisco_integration_user3@cisco.com</integrationUser>
        <name>PW Notification Oppty Position Change</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>APJC-APAC</fullName>
        <actions>
            <name>APJC_APAC</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Territory_Level_01__c</field>
            <operation>notEqual</operation>
            <value>Global Service Provider</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Theater__c</field>
            <operation>notEqual</operation>
            <value>APJC-APAC</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Territory_Level_02__c</field>
            <operation>equals</operation>
            <value>ANZ AREA,ASEAN_AREA,INDIA_AREA,ROK_AREA</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Partner Parent Opportunity,Parent Opportunity,Bookings,Renewals Opportunity</value>
        </criteriaItems>
        <description>Update Theater</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>APJC-Greater China</fullName>
        <actions>
            <name>APJC_Greater_China</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 4 AND (3 OR 5)</booleanFilter>
        <criteriaItems>
            <field>Opportunity.Territory_Level_01__c</field>
            <operation>notEqual</operation>
            <value>Global Service Provider</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Theater__c</field>
            <operation>notEqual</operation>
            <value>APJC-Greater China</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Territory_Level_02__c</field>
            <operation>equals</operation>
            <value>GREATER_CHINA</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Partner Parent Opportunity,Parent Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Territory_Level_01__c</field>
            <operation>equals</operation>
            <value>GREATER_CHINA</value>
        </criteriaItems>
        <description>Update Theater</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>APJC-Japan</fullName>
        <actions>
            <name>APJC_Japan</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Territory_Level_01__c</field>
            <operation>notEqual</operation>
            <value>Global Service Provider</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Theater__c</field>
            <operation>notEqual</operation>
            <value>APJC-Japan</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Territory_Level_02__c</field>
            <operation>equals</operation>
            <value>JAPAN__</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Partner Parent Opportunity,Parent Opportunity,Bookings,Renewals Opportunity</value>
        </criteriaItems>
        <description>Update Theater</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>AT Opportunity Owner_Notification</fullName>
        <actions>
            <name>AT_Opportunity_Owner_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Notify AM when PSS creates an opportunity</description>
        <formula>$Profile.Id ='00e30000000rrZw'|| INCLUDES( $User.Additional_User_Permissions__c,'Enable_ePSS')</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Account SE Notification</fullName>
        <active>true</active>
        <description>Account SE Notification</description>
        <formula>NOT(ISBLANK(Id) )&amp;&amp; ($RecordType.DeveloperName=='ParentOpportunity' || $RecordType.DeveloperName=='PartnerParentOpportunity' || $RecordType.DeveloperName=='PartnerPhaseOpportunity' || $RecordType.DeveloperName=='PhaseOpportunity' || ($RecordType.DeveloperName=='Renewals_Opportunity' &amp;&amp;  $Profile.Id != $Setup.ProfileID__c.Cisco_ADMIN__c ))</formula>
        <triggerType>onCreateOnly</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Account_SE_Notification</name>
                <type>Alert</type>
            </actions>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Days</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Americas-Canada</fullName>
        <actions>
            <name>Americas_Canada</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Theater__c</field>
            <operation>notEqual</operation>
            <value>Americas-Canada</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Territory_Level_02__c</field>
            <operation>equals</operation>
            <value>CANADA</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Partner Parent Opportunity,Parent Opportunity,Bookings,Renewals Opportunity</value>
        </criteriaItems>
        <description>Update Theater</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Americas-LATAM</fullName>
        <actions>
            <name>Americas_LATAM</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Territory_Level_01__c</field>
            <operation>notEqual</operation>
            <value>Global Service Provider</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Theater__c</field>
            <operation>notEqual</operation>
            <value>Americas-LATAM</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Territory_Level_02__c</field>
            <operation>equals</operation>
            <value>LATIN AMERICA</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Partner Parent Opportunity,Parent Opportunity,Bookings,Renewals Opportunity</value>
        </criteriaItems>
        <description>Update Theater</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Americas-US Commercial</fullName>
        <actions>
            <name>Americas_US_Commercial</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Territory_Level_01__c</field>
            <operation>notEqual</operation>
            <value>Global Service Provider</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Theater__c</field>
            <operation>notEqual</operation>
            <value>Americas-US Commercial</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Territory_Level_02__c</field>
            <operation>equals</operation>
            <value>US COMMERCIAL</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Partner Parent Opportunity,Parent Opportunity,Bookings,Renewals Opportunity</value>
        </criteriaItems>
        <description>Update Theater</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Americas-US Enterprise</fullName>
        <actions>
            <name>Americas_Global_Enterprise_Segment</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Territory_Level_01__c</field>
            <operation>notEqual</operation>
            <value>Global Service Provider</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Theater__c</field>
            <operation>notEqual</operation>
            <value>Americas-Global Enterprise Segment</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Territory_Level_02__c</field>
            <operation>equals</operation>
            <value>US ENTERPRISE</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Partner Parent Opportunity,Parent Opportunity,Bookings,Renewals Opportunity</value>
        </criteriaItems>
        <description>Update Theater</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Americas-US Public Sector</fullName>
        <actions>
            <name>Americas_US_Public_Sector</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Territory_Level_01__c</field>
            <operation>notEqual</operation>
            <value>Global Service Provider</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Theater__c</field>
            <operation>notEqual</operation>
            <value>Americas-US Public Sector</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Territory_Level_02__c</field>
            <operation>equals</operation>
            <value>US PS Market Segment</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Partner Parent Opportunity,Parent Opportunity,Bookings,Renewals Opportunity</value>
        </criteriaItems>
        <description>Update Theater</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Competitor_Information</fullName>
        <active>true</active>
        <description>Used to email links to battle cards. (Uses Competitor Information custom setting)</description>
        <formula>( CloseDate &gt;  TODAY()  &amp;&amp; TEXT(Opportunity_Status__c) ==  'Active'  &amp;&amp; TEXT(Forecast_Status__c) !=  'Commit'  &amp;&amp; TEXT(StageName) != '5 - Closing'  &amp;&amp; TEXT(Account.Run_Rate_Account__c) != 'Yes' &amp;&amp; (Expected_Product__c   &gt;= 10 || Expected_Service__c &gt;= 10) )  &amp;&amp; ( INCLUDES( Competitors__c ,'Aerohive Networks')  || INCLUDES( Competitors__c ,'Arris (Brocade/Ruckus)')  || INCLUDES( Competitors__c ,'Juniper Networks')  || INCLUDES( Competitors__c ,'Riverbed')  || INCLUDES( Competitors__c ,'Silver Peak')  )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Competitor_Information</name>
                <type>Alert</type>
            </actions>
            <timeLength>1</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>Create Task Reminder</fullName>
        <active>false</active>
        <description>Create Task Reminder</description>
        <formula>ISCHANGED(StageName) &amp;&amp; TEXT(StageName) = '5 - Closing' &amp;&amp; CONTAINS (Owner.Reporting_Up_Manager_Chain__c, 'mdoumano')</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Customer Win Recommendation</fullName>
        <actions>
            <name>Update_Customer_Win_Recommendation</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Customer_Win_Recommendation__c</field>
            <operation>notEqual</operation>
            <value>True</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>2 - Qualification</value>
        </criteriaItems>
        <description>Work flow to update Customer Win Recommendation</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Deal ID Obtainted Timestamp</fullName>
        <actions>
            <name>Deal_ID_Obtainted_Timestamp</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Deal ID Obtainted Timestamp</description>
        <formula>$User.Username != 'dataload_suppress_user@cisco.com' &amp;&amp; RecordTypeId = $Setup.ObjectRecordTypeIds__c.Opportunity_Parent_RecordTypeId__c &amp;&amp; !ISBLANK(Timestamp_DealID_Status_SetTo_Processing__c ) &amp;&amp; CONTAINS(Deal_Id_Status__c, 'Obtained')</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>EMEAR</fullName>
        <actions>
            <name>EMEAR</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Territory_Level_01__c</field>
            <operation>notEqual</operation>
            <value>Global Service Provider</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Theater__c</field>
            <operation>notEqual</operation>
            <value>EMEAR</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Territory_Level_01__c</field>
            <operation>equals</operation>
            <value>EMEAR-REGION</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Partner Parent Opportunity,Parent Opportunity</value>
        </criteriaItems>
        <description>Update Theater</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>FY EBD Changed</fullName>
        <actions>
            <name>EBD_Week_In_Year</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>FY_Copy_EBD_Fiscal_Year</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>FY_Set_EBD_Fiscal_Week</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Workflow copies Expected Book Date's Fiscal Year Start Date, and sets Fiscal Week
dataload_suppress_user@cisco.com</description>
        <formula>($User.Username ='bdabbara@cisco.com') || (ISCHANGED(CloseDate))  ||  ( ISNULL (FY_Copy__c) &amp;&amp; NOT(ISNULL(CloseDate))  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Forecast Status Commit</fullName>
        <actions>
            <name>Forecast_Status_Commit</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>4 - Agreement,5 - Closed Won</value>
        </criteriaItems>
        <description>Forecast Status Commit</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Forecast Status Not Forecastable</fullName>
        <actions>
            <name>Forecast_Status_Not_Forecastable</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>1 - Prospect</value>
        </criteriaItems>
        <description>Forecast Status Not Forecastable</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Forecast Status Upside</fullName>
        <actions>
            <name>Forecast_Status_Upside</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>2 - Qualification,3 - Proposal</value>
        </criteriaItems>
        <description>Forecast Status Upside</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Global Service Provider</fullName>
        <actions>
            <name>Global_Service_Provider</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 OR 4) AND (2 AND 3 AND 4)</booleanFilter>
        <criteriaItems>
            <field>Opportunity.Territory_Level_01__c</field>
            <operation>equals</operation>
            <value>Global Service Provider</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Theater__c</field>
            <operation>notEqual</operation>
            <value>Global Service Provider</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.RecordTypeId</field>
            <operation>equals</operation>
            <value>Partner Parent Opportunity,Parent Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Territory_Level_02__c</field>
            <operation>contains</operation>
            <value>GSP</value>
        </criteriaItems>
        <description>Update Theater Global Service Provider</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Lost%2FCancelled Date Update NOW</fullName>
        <actions>
            <name>Oppty_Lost_Cancelled_Date_Time_NOW</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>5 - Closed Cancelled,5 - Closed Lost</value>
        </criteriaItems>
        <description>This work flow update the field Lost/Cancelled Date by today's date</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Lost%2FCancelled Date%2FTime NULL</fullName>
        <actions>
            <name>Lost_Cancelled_Date_Time_NULL</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>1 - Prospect,2 - Qualification,3 - Proposal,4 - Agreement,5 - Closed Won</value>
        </criteriaItems>
        <description>This work flow update the field Lost/Cancelled Date to null</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Meraki Opportunity Notification</fullName>
        <actions>
            <name>Meraki_SFDC_Opportunity_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Meraki Opportunity Notification</description>
        <formula>DealID__c != '' &amp;&amp;  CONTAINS(Technology_Merge_Field__c , 'Meraki')</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Merged Opportunity Stage Update</fullName>
        <actions>
            <name>Merged_Stage_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Merged Opportunity Stage Update</description>
        <formula>LEFT(RecordTypeId,15) =  LEFT($Setup.ObjectRecordTypeIds__c.Opportunity_Void_Merged_RecordTypeId__c,15) &amp;&amp;  TEXT(StageName ) != '5 - Closed Cancelled'</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Multinational Account Notification</fullName>
        <actions>
            <name>Multinational_Account_Notification</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <description>Sends Multinational Account Notification Email alert to Opportunity Owner</description>
        <formula>( (ISNEW()) || (ISPICKVAL(PRIORVALUE(Emerging_Multinational_Opportunity__c), '')))  &amp;&amp;  (NOT(ISPICKVAL(Emerging_Multinational_Opportunity__c,'')))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>NonStdTC_Default</fullName>
        <actions>
            <name>NonStdTC_Default</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Non_Standard_Terms_and_Conditions__c</field>
            <operation>notEqual</operation>
            <value>None,Service,Both,Product</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>NonStd_Discount Approval_Default</fullName>
        <actions>
            <name>NonStdDiscountApproval_Default</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Discount_Approval__c</field>
            <operation>notEqual</operation>
            <value>None,Service,Both,Product</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>NonStd_ProdEnhancements_Default</fullName>
        <actions>
            <name>NonStdProdEnhancements_Default</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Product_Enhancements__c</field>
            <operation>notEqual</operation>
            <value>Required/Unknown,Not Required</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>OUTBOUND_Oppty Outbound GSTS</fullName>
        <actions>
            <name>OpptyOutboundGSTS</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <description>Outbound:</description>
        <formula>(Phase_Linked__c = false &amp;&amp;  LEN(DealID__c ) &gt; 0) &amp;&amp;   (RecordTypeId = $Setup.ObjectRecordTypeIds__c.Opportunity_Parent_RecordTypeId__c ||   RecordTypeId = $Setup.ObjectRecordTypeIds__c.Opportunity_Partner_Parent_RecordTypeId__c ||   RecordTypeId = $Setup.ObjectRecordTypeIds__c.Opportunity_Global_RecordTypeId__c || RecordTypeId = $Setup.ObjectRecordTypeIds__c.Opportunity_Renewal_RecordTypeId__c) &amp;&amp;    ( $Profile.Name = $Setup.ProfileID__c.Cisco_GSTS__c || $Profile.Name = $Setup.ProfileID__c.Cisco_GSTS_Analyst__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>OUTBOUND_Oppty Outbound Parent Non GSTS</fullName>
        <actions>
            <name>OpptyOutboundParentNonGSTS</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <description>Outbound:</description>
        <formula>(Phase_Linked__c = false &amp;&amp;  LEN(DealID__c ) &gt; 0) &amp;&amp;   (RecordTypeId = $Setup.ObjectRecordTypeIds__c.Opportunity_Parent_RecordTypeId__c ||   RecordTypeId = $Setup.ObjectRecordTypeIds__c.Opportunity_Partner_Parent_RecordTypeId__c ||   RecordTypeId = $Setup.ObjectRecordTypeIds__c.Opportunity_Global_RecordTypeId__c || RecordTypeId = $Setup.ObjectRecordTypeIds__c.Opportunity_Renewal_RecordTypeId__c) &amp;&amp;    ( $Profile.Name != $Setup.ProfileID__c.Cisco_GSTS__c || $Profile.Name !=  $Setup.ProfileID__c.Cisco_GSTS_Analyst__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>OUTBOUND_Oppty Outbound Phase</fullName>
        <actions>
            <name>OpptyOutboundPhase</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <description>Outbound:</description>
        <formula>AND(   LEN(DealID__c ) &gt; 0,   OR(CONTAINS($RecordType.Name, "Phase"), Phase_Linked__c )  )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>OUTBOUND_PW Notification Oppty Owner Change</fullName>
        <actions>
            <name>PWNotificationOpptyOwnerChange</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <description>Outbound:This Workflow rule will notify Partner Workspace (PDR/ICW) that the opportunity owner has been changed in SFDC.</description>
        <formula>AND(ISCHANGED(OwnerId),           CONTAINS($RecordType.Name, "Partner Parent" ),           $User.Dummy_User__c = False     )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>OUTBOUND_PW Notification Oppty Position Change</fullName>
        <actions>
            <name>PWNotificationOpptyPositionChange</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <description>Outbound:This Workflow rule will notify Partner Workspace (PDR/ICW) that the opportunity forecasting position has been changed in SFDC.</description>
        <formula>AND(ISCHANGED(Position__c ), CONTAINS($RecordType.Name, "Partner Parent" ), $User.Dummy_User__c = False)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity Duplicate Prevention</fullName>
        <actions>
            <name>Opportunity_Set_Duplicate_Prevention</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Opportunity.Data_Source_Name__c</field>
            <operation>equals</operation>
            <value>SREV</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Data_Source_Name__c</field>
            <operation>equals</operation>
            <value>CISCOREADY</value>
        </criteriaItems>
        <description>Fill in a unique field in order to prevent duplicate Opportunity creation from external systems.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity Owner Text Field Update</fullName>
        <actions>
            <name>Update_Opportinty_Owner_Text_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This WF is used to update Owner Text field which is used in SE Oppty List View</description>
        <formula>OR(ISNEW() , ISCHANGED(OwnerId) )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity Status Active</fullName>
        <actions>
            <name>Opportunity_Status_Active</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>1 - Prospect,2 - Qualification,3 - Proposal,4 - Agreement</value>
        </criteriaItems>
        <description>Opportunity Status Active</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity Status Booked</fullName>
        <actions>
            <name>Opportunity_Status_Booked</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>5 - Closed Won</value>
        </criteriaItems>
        <description>Opportunity Status Booked</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity Status Cancelled</fullName>
        <actions>
            <name>Opportunity_Status_Cancelled</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>5 - Closed Cancelled</value>
        </criteriaItems>
        <description>Opportunity Status Cancelled</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity Status Lost</fullName>
        <actions>
            <name>Opportunity_Status_Lost</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.StageName</field>
            <operation>equals</operation>
            <value>5 - Closed Lost</value>
        </criteriaItems>
        <description>Opportunity Status Lost</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity-Deals at risk</fullName>
        <actions>
            <name>Deals_at_Risk</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Opportunity_Flags__c</field>
            <operation>includes</operation>
            <value>Deal at risk due to poor product quality</value>
        </criteriaItems>
        <description>Email alert for Deals at risk</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>OpportunityAutoTaskCreation</fullName>
        <actions>
            <name>Keep_CustomerWarmfor_Deal_ID</name>
            <type>Task</type>
        </actions>
        <active>true</active>
        <description>Opportunity Status Booked</description>
        <formula>AND(Text(StageName) = '5 - Closed Won', $User.Manager_s_Email_Address__c = 'mdoumano@cisco.com')</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Outbound Notification after opportunity update</fullName>
        <actions>
            <name>OpportunityFieldUpdate</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <formula>AND(  Data_Source_Name__c ='SREV',    OR(ISCHANGED( DealID__c),    (LastModifiedById &lt;&gt; $Setup.Currency_Values_For_Conversion__c.mule_opty_gateway_integration_user__c )     ),   OR(ISCHANGED( DealID__c),      ISCHANGED( CloseDate ),      ISCHANGED( Opportunity_Status__c ),      ISCHANGED( Forecast_Status__c ),      ISCHANGED( Start_Date__c ),      ISCHANGED( End_Date__c ),      ISCHANGED( Expected_Service__c ),      ISCHANGED( CurrencyIsoCode ),      ISCHANGED( Tag_as_Multiyear__c )    )   )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PDRuser_Update BOM integration date</fullName>
        <actions>
            <name>Update_CCW_BOM_Integration_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>When the opportunity is created by PDR collab user then update CCW BOM integration date with current date</description>
        <formula>LEFT(RecordTypeId, 15) == LEFT($Setup.ObjectRecordTypeIds__c.Opportunity_Partner_Parent_RecordTypeId__c, 15)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Remove Quote Integration for Lost Quote</fullName>
        <actions>
            <name>Clear_CCW_BOM_Integrate_Quote_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Clear_CCW_Integrated_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Clear_CCW_QuoteId_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Clears the CCW_BOM_Integrated_Quote_Id__c and CCW_BOM_Integrated_Date__c when the CCW_BOM_Integrated_Quote_Status__c IN "LOST", "CANCELLED"</description>
        <formula>UPPER (CCW_BOM_Integrated_Quote_Status__c) = 'LOST'   ||  UPPER (CCW_BOM_Integrated_Quote_Status__c) = 'CANCELLED'</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Renewals - Updating Expected Service from Lines Rollup</fullName>
        <actions>
            <name>Updating_Expected_Service</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(ISCHANGED(   Exp_TCV_Service_Rollup_000s__c ), RecordTypeId == $Setup.ObjectRecordTypeIds__c.Opportunity_Renewal_RecordTypeId__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Renewals - Updating Prior Product ATR from Lines Rollup</fullName>
        <actions>
            <name>Update_Prior_ATR_Product</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(ISCHANGED(Prior_ATR_Product_Rollup_000s__c), RecordTypeId == $Setup.ObjectRecordTypeIds__c.Opportunity_Renewal_RecordTypeId__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Renewals - Updating Prior Product TCV from Lines Rollup</fullName>
        <actions>
            <name>Update_Prior_TCV_Product</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(ISCHANGED(Prior_TCV_Product_Rollup_000s__c),RecordTypeId == $Setup.ObjectRecordTypeIds__c.Opportunity_Renewal_RecordTypeId__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Renewals - Updating Prior Service ATR from Lines Rollup</fullName>
        <actions>
            <name>Update_Prior_ATR_Service</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(ISCHANGED(Prior_ATR_Service_Rollup_000s__c), RecordTypeId == $Setup.ObjectRecordTypeIds__c.Opportunity_Renewal_RecordTypeId__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Renewals - Updating Prior Service TCV from Lines Rollup</fullName>
        <actions>
            <name>Update_Prior_TCV_Service</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND( ISCHANGED( Prior_TCV_Service_Rollup_000s__c ),RecordTypeId == $Setup.ObjectRecordTypeIds__c.Opportunity_Renewal_RecordTypeId__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Renewals - Updation of Expected Product from Lines Rollup</fullName>
        <actions>
            <name>Update_Expected_Product_on_Opportunity</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(ISCHANGED( Exp_TCV_Product_Rollup_000s__c ), RecordTypeId == $Setup.ObjectRecordTypeIds__c.Opportunity_Renewal_RecordTypeId__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Reset Position on Owner Change YE</fullName>
        <actions>
            <name>Forecast_Position_to_None</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>set forecast position to null when owner of the opportunity is changed</description>
        <formula>AND(PRIORVALUE(OwnerId) &lt;&gt; OwnerId, NOT(ISPICKVAL(Position__c,'')), $User.Id != '00530000000zm6i' ,$User.Id != '00580000002EwbA' , $User.Id != '00580000001UGfk', $User.Id != '00580000006FPT7' , $User.Id != '00530000000xQ0K')</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SE Assigned_New</fullName>
        <actions>
            <name>SE_Assigned_To_True</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>SE Assigned is set to True if SE Count &gt;=1</description>
        <formula>SE_Assigned__c = FALSE &amp;&amp; (SE_Count__c &gt;=1  ||  SE_Engagement_Type__c != '' )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SE Flags reset</fullName>
        <actions>
            <name>SE_Assigned_to_false</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>SE_Engaged_to_false</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.SE_Count__c</field>
            <operation>equals</operation>
            <value>0</value>
        </criteriaItems>
        <description>Resets the SE Flags to false if se count is 0</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Service Source_New</fullName>
        <actions>
            <name>Service_Source_New</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Installed_Base__c</field>
            <operation>notEqual</operation>
            <value>Software and Services Renewal</value>
        </criteriaItems>
        <description>Service Source_New</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Service Source_Renewal</fullName>
        <actions>
            <name>Service_Source_Renewal</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Opportunity.Installed_Base__c</field>
            <operation>equals</operation>
            <value>Software and Services Renewal</value>
        </criteriaItems>
        <description>Service Source_Renewal</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set CCW BOM Integration Date</fullName>
        <actions>
            <name>Set_CCW_BOM_Integration_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Set CCW BOM Integration Timestamp when Partner deal is converted to Opportunity</description>
        <formula>LEFT(RecordTypeId,15) = LEFT($Setup.ObjectRecordTypeIds__c.Opportunity_Partner_Parent_RecordTypeId__c,15)</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Set Metrics Field Modified Date to Today</fullName>
        <actions>
            <name>Metrics_Fields_Modified_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Set Metrics Field Modified Date to Today</description>
        <formula>ISCHANGED (OwnerId) || ISCHANGED (CloseDate) || ISCHANGED (Expected_Product__c) || ISCHANGED (Expected_Service__c) || ISCHANGED (StageName) || ISCHANGED (Position__c) || ISCHANGED (Description) || ISCHANGED (DD_Status__c) ||  ISCHANGED (Name) || ISCHANGED (AccountId) || ISCHANGED (Competitors__c) || ISCHANGED (Primary_Partner__c) || ISCHANGED (Partner_2__c) || ISCHANGED (Partner_3__c) ||  ISCHANGED (Start_Date__c) || ISCHANGED (End_Date__c)|| ISCHANGED (Software_Offer_Name__c) || ISCHANGED (Software_Offer_Value__c) || ISCHANGED (SE_Status__c) || ISCHANGED (Request_SE_Comments__c) || ISCHANGED (Installed_Base__c) || ISCHANGED (Industry_Solution__c) || ISCHANGED (Emerging_Multinational_Opportunity__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Set SE Status Default Value</fullName>
        <actions>
            <name>Set_SE_Status</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Workflow rule to set SE Status field on Opty to No SE Assigned if the field is set to null</description>
        <formula>ISPICKVAL( SE_Status__c , '')</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>zzCSMTG Tagging</fullName>
        <actions>
            <name>CSMTG_Tagging</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Based on technologies field tag the opportunity</description>
        <formula>NOT(ISBLANK(Technology_Merge_Field__c)) &amp;&amp; (ISBLANK(Visible_to_Biz_Group_Name_s__c) ||  NOT(CONTAINS( Visible_to_Biz_Group_Name_s__c, 'CSMTG'))) &amp;&amp; ( CONTAINS(Technology_Merge_Field__c, 'Network Management') || CONTAINS(Technology_Merge_Field__c, 'Cloud Management and Software') || CONTAINS(Technology_Merge_Field__c, 'SP ROUTING-Network Mgmt(SPMABU)') || CONTAINS( Service_Merge_Field__c, 'SPMABU') )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>zzCisco Refresh</fullName>
        <actions>
            <name>Cisco_Refresh</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Cisco Refresh</description>
        <formula>(Territory_Level_01__c ='APJ' ||  Territory_Level_01__c ='GREATER_CHINA' ) &amp;&amp;   TEXT(Installed_Base__c) =  'Cisco Refresh - Digital Ready' &amp;&amp;   TEXT(Opportunity_Status__c) = 'Active' &amp;&amp;   NOT(ISBLANK(DealID__c  )) &amp;&amp;   TEXT(Account.Run_Rate_Account__c) != 'Yes'</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>zzENGTagging</fullName>
        <actions>
            <name>ENGG_Tagging</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Based on technologies field tag the opportunity</description>
        <formula>NOT(ISBLANK(Technology_Merge_Field__c)) &amp;&amp; (ISBLANK(Visible_to_Biz_Group_Name_s__c) || NOT(CONTAINS( Visible_to_Biz_Group_Name_s__c, 'ENG'))) &amp;&amp; ( CONTAINS(Technology_Merge_Field__c, 'ENT NET-Routing-Edge') ||  CONTAINS(Technology_Merge_Field__c, 'ENT NET-Routing-Access') || CONTAINS(Technology_Merge_Field__c, 'Routing') )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>zzForecast Status Update</fullName>
        <actions>
            <name>Forecast_Status_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Workflow to update Forecast Status to Upside if Stage is not '1 - Prospect' AND Forecast Status 'Not Forecastable'</description>
        <formula>ISCHANGED(StageName ) &amp;&amp;  NOT(ISPICKVAL(StageName, '1 - Prospect')) &amp;&amp;  ISPICKVAL(Forecast_Status__c, 'Not Forecastable')</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>zzOpportunity Value Range Field Update</fullName>
        <actions>
            <name>Opportunity_Value_Range_Field_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Dollar_Amount_Greater_than_5M__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <description>Opportunity Value Range field get updated to 'Less than 5 Million' if the opportunity value range field is blank.</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>zzOppty Reference Qualified</fullName>
        <actions>
            <name>Opportunity_Reference_Prompt</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND (5 OR 6)</booleanFilter>
        <criteriaItems>
            <field>Opportunity.Opportunity_Status__c</field>
            <operation>equals</operation>
            <value>Booked</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Expected_Product__c</field>
            <operation>greaterThan</operation>
            <value>USD 100</value>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Reference_Prompt__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Opportunity.Theater__c</field>
            <operation>startsWith</operation>
            <value>Americas</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>startsWith</operation>
            <value>Cisco_US</value>
        </criteriaItems>
        <criteriaItems>
            <field>User.ProfileId</field>
            <operation>startsWith</operation>
            <value>Cisco_Canada</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>zzPartner1Role1Update</fullName>
        <actions>
            <name>RolePrimaryUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>This rule sets the Primary Partner Role field to null if the Primary Partner Role field has a value and the Primary Partner value is not selected</description>
        <formula>AND( Primary_Partner__c = '', NOT(ISPICKVAL( Primary_Partner_Role__c , '')))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>zzPartner2Role2Update</fullName>
        <actions>
            <name>RoleUpdate2</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>This rule sets the Role 2 field to null if it has a value and the Partner 2 value is not selected</description>
        <formula>AND( Partner_2__c = '', NOT(ISPICKVAL( Role_2__c , '')) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>zzPartner3Role3Update</fullName>
        <actions>
            <name>RoleUpdate3</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>This rule sets the Role3 field to null if it has a value and the Partner 3 value is not selected</description>
        <formula>AND( Partner_3__c = '', NOT(ISPICKVAL( Role_3__c , '')) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>zzPartner4Role4Update</fullName>
        <actions>
            <name>RoleUpdate4</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>This rule sets the Role 4 field to null if it has a value and the Partner 4 value is not selected</description>
        <formula>AND( Partner_4__c = '', NOT(ISPICKVAL( Role_4__c , '')) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>zzPartner5Role5Update</fullName>
        <actions>
            <name>RoleUpdate5</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>This rule sets the Role 5 field to null if it has a value and the Partner 5 value is not selected</description>
        <formula>AND( Partner_5__c = '', NOT(ISPICKVAL( Role_5__c , '')) )</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>zzSE Status Update</fullName>
        <actions>
            <name>SE_Status_field_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Opportunity.Opportunity_Status__c</field>
            <operation>notEqual</operation>
            <value>Active</value>
        </criteriaItems>
        <description>SE status field is updated to close once the opportunity stage is set to close</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>zzSolution Id update</fullName>
        <actions>
            <name>zzSolution_Identifier_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <description>Workflow will sync the Solution ID search value with the Solution_Identifier__c text value for Integration.</description>
        <formula>(ISNEW()||  ISCHANGED(Solution_ID_Description__c)) &amp;&amp; Solution_ID_Description__c != ''</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <tasks>
        <fullName>Keep_CustomerWarmfor_Deal_ID</fullName>
        <assignedToType>accountOwner</assignedToType>
        <dueDateOffset>90</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Keep Customer Warm for Deal ID ::</subject>
    </tasks>
    <tasks>
        <fullName>Reminder_Please_identify_Landed_AMs_to_Sales_Team_MN_Opportunity_not_qualified_w</fullName>
        <assignedToType>owner</assignedToType>
        <description>More Information on MN process can be found : http://wwwin.cisco.com/WWSales/cfp/gap/EMA/opportunity.shtml</description>
        <dueDateOffset>-1</dueDateOffset>
        <notifyAssignee>false</notifyAssignee>
        <priority>Normal</priority>
        <protected>false</protected>
        <status>Not Started</status>
        <subject>Reminder: Please identify Landed AMs to Sales Team, MN Opportunity not qualified without Landed Sales Team.</subject>
    </tasks>
</Workflow>
