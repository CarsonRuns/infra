<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>External_Fund_Qualification_Creation_notification</fullName>
        <description>External Fund Qualification Creation notification</description>
        <protected>false</protected>
        <recipients>
            <recipient>external-funds@cisco.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Qualification_Notifications/External_Fund_Qualification_Created</template>
    </alerts>
    <alerts>
        <fullName>LCD_AlertTo_ce_CMSO_deals_APJC</fullName>
        <description>LCD_AlertTo_ce_CMSO_deals_APJC</description>
        <protected>false</protected>
        <recipients>
            <recipient>cmso_apjc@cisco.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Qualification_Notifications/NBM_CMSO_Email_template</template>
    </alerts>
    <alerts>
        <fullName>LCD_AlertTo_ce_CMSO_deals_Americas</fullName>
        <description>LCD_AlertTo_ce_CMSO_deals_Americas</description>
        <protected>false</protected>
        <recipients>
            <recipient>cmso_americas@cisco.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Qualification_Notifications/NBM_CMSO_Email_template</template>
    </alerts>
    <alerts>
        <fullName>LCD_AlertTo_ce_CMSO_deals_emear</fullName>
        <description>LCD_AlertTo_ce_CMSO_deals_emear</description>
        <protected>false</protected>
        <recipients>
            <recipient>cmso_emear@cisco.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Qualification_Notifications/NBM_CMSO_Email_template</template>
    </alerts>
    <alerts>
        <fullName>LCD_AlertTo_ce_bridge_deals_emear</fullName>
        <description>LCD_AlertTo_ce_bridge_deals_emear</description>
        <protected>false</protected>
        <recipients>
            <recipient>cms_war_room@cisco.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Qualification_Notifications/New_LCD_Qualification_Registration</template>
    </alerts>
    <alerts>
        <fullName>LCD_AlertTo_co_review_apjc</fullName>
        <description>LCD_AlertTo_co-review_apjc</description>
        <protected>false</protected>
        <recipients>
            <recipient>nbm-review_gsp@cisco.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Qualification_Notifications/New_LCD_Qualification_Registration</template>
    </alerts>
    <alerts>
        <fullName>LCD_AlertTo_co_review_canada</fullName>
        <description>LCD_AlertTo_co-review_canada</description>
        <protected>false</protected>
        <recipients>
            <recipient>co-review_canada@cisco.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Qualification_Notifications/New_LCD_Qualification_Registration</template>
    </alerts>
    <alerts>
        <fullName>LCD_AlertTo_co_review_emear</fullName>
        <description>LCD_AlertTo_co-review_emear</description>
        <protected>false</protected>
        <recipients>
            <recipient>co-review_emear@cisco.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Qualification_Notifications/New_LCD_Qualification_Registration</template>
    </alerts>
    <alerts>
        <fullName>LCD_AlertTo_nbm_review_CMS</fullName>
        <description>LCD_AlertTo_nbm-review_CMS</description>
        <protected>false</protected>
        <recipients>
            <recipient>cms_war_room@cisco.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Qualification_Notifications/New_LCD_Qualification_Registration</template>
    </alerts>
    <alerts>
        <fullName>LCD_AlertTo_nbm_review_GES</fullName>
        <description>LCD_AlertTo_nbm-review_GES</description>
        <protected>false</protected>
        <recipients>
            <recipient>ges-set-sfdc@cisco.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Qualification_Notifications/New_LCD_Qualification_Registration</template>
    </alerts>
    <alerts>
        <fullName>LCD_AlertTo_nbm_review_GSP</fullName>
        <description>LCD_AlertTo_nbm-review_GSP</description>
        <protected>false</protected>
        <recipients>
            <recipient>nbm-review_gsp@cisco.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Qualification_Notifications/New_LCD_Qualification_Registration</template>
    </alerts>
    <alerts>
        <fullName>LCD_AlertTo_nbm_review_apjc</fullName>
        <description>LCD_AlertTo_nbm-review_apjc</description>
        <protected>false</protected>
        <recipients>
            <recipient>nbm-review_apjc@cisco.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Qualification_Notifications/New_LCD_Qualification_Registration</template>
    </alerts>
    <alerts>
        <fullName>LCD_AlertTo_nbm_review_emear</fullName>
        <description>LCD_AlertTo_nbm-review_emear</description>
        <protected>false</protected>
        <recipients>
            <recipient>nbm-review_emear@cisco.com</recipient>
            <type>user</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Qualification_Notifications/New_LCD_Qualification_Registration</template>
    </alerts>
    <alerts>
        <fullName>LCD_Request_Status_Change_Alert_For_3_Agreement_Closing</fullName>
        <description>LCD Request Status Change Alert For 3-Agreement/Closing</description>
        <protected>false</protected>
        <recipients>
            <field>NBM_Theater_Lead__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Requester_Name__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Qualification_Notifications/NBM_Approve_Template</template>
    </alerts>
    <alerts>
        <fullName>Qualification_Status_Type_Change_Alert</fullName>
        <description>Qualification Status/Type Change Alert</description>
        <protected>false</protected>
        <recipients>
            <field>NBM_Theater_Lead__c</field>
            <type>email</type>
        </recipients>
        <recipients>
            <field>Opportunity_Lead__c</field>
            <type>userLookup</type>
        </recipients>
        <recipients>
            <field>Requester_Name__c</field>
            <type>userLookup</type>
        </recipients>
        <senderType>CurrentUser</senderType>
        <template>Qualification_Notifications/LCD_Qualification_Status_Type_Change</template>
    </alerts>
    <fieldUpdates>
        <fullName>NBM_Status_Field_Update</fullName>
        <field>Status__c</field>
        <name>NBM Status Field Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SAC_GSPO_BMC_Owner</fullName>
        <field>OwnerId</field>
        <lookupValue>GSPO_BMC</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>SAC GSPO BMC Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SAC_GSPO_CA_Technologies_Owner</fullName>
        <field>OwnerId</field>
        <lookupValue>GSPO_CATechnologies</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>SAC GSPO CA Technologies Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SAC_GSPO_Citrix_Owner</fullName>
        <field>OwnerId</field>
        <lookupValue>GSPO_Citrix</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>SAC GSPO Citrix Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SAC_GSPO_Dell_Owner</fullName>
        <field>OwnerId</field>
        <lookupValue>GSPO_Dell</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>SAC GSPO Dell Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SAC_GSPO_EMC_Owner</fullName>
        <field>OwnerId</field>
        <lookupValue>GSPO_EMC</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>SAC GSPO EMC Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SAC_GSPO_HDS_Owner</fullName>
        <field>OwnerId</field>
        <lookupValue>GSPO_HDS</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>SAC GSPO HDS Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SAC_GSPO_Intel_Owner</fullName>
        <field>OwnerId</field>
        <lookupValue>GSPO_Intel</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>SAC GSPO Intel Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SAC_GSPO_MTP_Google_Apple_RIM_Owner</fullName>
        <field>OwnerId</field>
        <lookupValue>GSPO_MTPGoogleAppleRIM</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>SAC GSPO MTP - Google/Apple/RIM  Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SAC_GSPO_Microsoft_Owner</fullName>
        <field>OwnerId</field>
        <lookupValue>GSPO_Microsoft</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>SAC GSPO Microsoft Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SAC_GSPO_NetApp_Owner</fullName>
        <field>OwnerId</field>
        <lookupValue>GSPO_NetApp</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>SAC GSPO NetApp Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SAC_GSPO_Oracle_Owner</fullName>
        <field>OwnerId</field>
        <lookupValue>GSPO_Oracle</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>SAC GSPO Oracle Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SAC_GSPO_Other_Owner</fullName>
        <field>OwnerId</field>
        <lookupValue>GSPO_Other</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>SAC GSPO Other Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SAC_GSPO_RedHat_Owner</fullName>
        <field>OwnerId</field>
        <lookupValue>GSPO_RedHat</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>SAC GSPO RedHat Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SAC_GSPO_SAP_Owner</fullName>
        <field>OwnerId</field>
        <lookupValue>GSPO_SAP</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>SAC GSPO SAP Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SAC_GSPO_VCE_Owner</fullName>
        <field>OwnerId</field>
        <lookupValue>GSPO_VCE</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>SAC GSPO VCE Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SAC_GSPO_VMWare_Owner</fullName>
        <field>OwnerId</field>
        <lookupValue>GSPO_VMWare</lookupValue>
        <lookupValueType>Queue</lookupValueType>
        <name>SAC GSPO VMWare Owner</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>LookupValue</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_CRMDB_Integrated_Field</fullName>
        <description>Update CRMDB Integrated Flag to False when a qualification is cloned</description>
        <field>Integrated_with_CRMDB__c</field>
        <literalValue>0</literalValue>
        <name>Update CRMDB Integrated Field</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>External Fund Qualification Notification</fullName>
        <actions>
            <name>External_Fund_Qualification_Creation_notification</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Qualification__c.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Qualification__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>GIF-External Funds</value>
        </criteriaItems>
        <description>External Fund Qualification creation email to external-funds@cisco.com.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>LCD Request Status Change Alert For 3-Agreement%2FClosing</fullName>
        <actions>
            <name>LCD_Request_Status_Change_Alert_For_3_Agreement_Closing</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Qualification__c.Status__c</field>
            <operation>equals</operation>
            <value>3-Agreement/Closing</value>
        </criteriaItems>
        <criteriaItems>
            <field>Qualification__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>LCD Opportunity</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>LCD_AlertTo_nbm-review_CMS</fullName>
        <actions>
            <name>LCD_AlertTo_nbm_review_CMS</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Qualification__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>LCD Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Qualification__c.Engaged_Team_s__c</field>
            <operation>includes</operation>
            <value>CMS</value>
        </criteriaItems>
        <description>Email Alert when a new NBM qualification is created</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>LCD_AlertTo_nbm-review_GET</fullName>
        <actions>
            <name>LCD_AlertTo_nbm_review_GES</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Qualification__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>LCD Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Qualification__c.Engaged_Team_s__c</field>
            <operation>includes</operation>
            <value>GES SET</value>
        </criteriaItems>
        <description>Email Alert when a new NBM qualification is created</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>LCD_AlertTo_nbm-review_GSP</fullName>
        <actions>
            <name>LCD_AlertTo_nbm_review_GSP</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Qualification__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>LCD Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Qualification__c.Engaged_Team_s__c</field>
            <operation>includes</operation>
            <value>GSP LCD</value>
        </criteriaItems>
        <description>Email Alert when a new NBM qualification is created</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>LCD_AlertTo_nbm-review_apjc</fullName>
        <actions>
            <name>LCD_AlertTo_nbm_review_apjc</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Qualification__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>LCD Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Qualification__c.Engaged_Team_s__c</field>
            <operation>includes</operation>
            <value>APJ SET</value>
        </criteriaItems>
        <description>LCD_AlertTo_nbm-review_apjc</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>LCD_AlertTo_nbm-review_emear</fullName>
        <actions>
            <name>LCD_AlertTo_nbm_review_emear</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <criteriaItems>
            <field>Qualification__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>LCD Opportunity</value>
        </criteriaItems>
        <criteriaItems>
            <field>Qualification__c.Engaged_Team_s__c</field>
            <operation>includes</operation>
            <value>EMEAR LCD</value>
        </criteriaItems>
        <description>LCD_AlertTo_nbm-review_emear</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>NBM Status Update for GSPO</fullName>
        <actions>
            <name>NBM_Status_Field_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Qualification__c.RecordTypeId</field>
            <operation>equals</operation>
            <value>GSPO Qualification</value>
        </criteriaItems>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Qualification Status%2FType Change</fullName>
        <actions>
            <name>Qualification_Status_Type_Change_Alert</name>
            <type>Alert</type>
        </actions>
        <active>false</active>
        <description>Email is sent whenever the NBM status is changed</description>
        <formula>(ISCHANGED( Status__c )  ||  ISCHANGED(Engaged_Team_s__c)  )
&amp;&amp; 
(RecordTypeId = $Setup.ObjectRecordTypeIds__c.LCD_Qualification_Record_Type_Id__c &amp;&amp;
NOT( ISNEW())
)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SAC GSPO BMC Owner</fullName>
        <actions>
            <name>SAC_GSPO_BMC_Owner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Workflow to update the owner field value with the BMC queue when the partner value is chosen as BMC</description>
        <formula>RecordTypeId = '01280000000G7GD' &amp;&amp; ISPICKVAL(Partner__c, 'BMC')</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SAC GSPO CA Technologies Owner</fullName>
        <actions>
            <name>SAC_GSPO_CA_Technologies_Owner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Workflow to update the owner field value with the CA Technologies queue when the partner value is chosen as CA Technologies</description>
        <formula>RecordTypeId = '01280000000G7GD' &amp;&amp; ISPICKVAL(Partner__c, 'CA Technologies')</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SAC GSPO Citrix Owner</fullName>
        <actions>
            <name>SAC_GSPO_Citrix_Owner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Workflow to update the owner field value with the Citrix queue when the partner value is chosen as Citrix</description>
        <formula>RecordTypeId = '01280000000G7GD' &amp;&amp; ISPICKVAL(Partner__c, 'Citrix')</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SAC GSPO Dell Owner</fullName>
        <actions>
            <name>SAC_GSPO_Dell_Owner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Workflow to update the owner field value with the GSPO_Dell queue when the partner value is chosen as Dell</description>
        <formula>RecordTypeId = '01280000000G7GD' &amp;&amp; ISPICKVAL(Partner__c, 'Dell')</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SAC GSPO EMC Owner</fullName>
        <actions>
            <name>SAC_GSPO_EMC_Owner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Workflow to update the owner field value with the GSPO_EMC queue when the partner value is chosen as ECM.</description>
        <formula>RecordTypeId = '01280000000G7GD' &amp;&amp; ISPICKVAL(Partner__c, 'EMC')</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SAC GSPO HDS Owner</fullName>
        <actions>
            <name>SAC_GSPO_HDS_Owner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Workflow to update the owner field value with the GSPO_HDS queue when the partner value is chosen as HDS</description>
        <formula>RecordTypeId = '01280000000G7GD' &amp;&amp; ISPICKVAL(Partner__c, 'HDS')</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SAC GSPO Intel Owner</fullName>
        <actions>
            <name>SAC_GSPO_Intel_Owner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Workflow to update the owner field value with the GSPO_Intel queue when the partner value is chosen as Intel</description>
        <formula>RecordTypeId = '01280000000G7GD' &amp;&amp;   ISPICKVAL(Partner__c, 'Intel')</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SAC GSPO MTP - Google%2FApple%2FRIM  Owner</fullName>
        <actions>
            <name>SAC_GSPO_MTP_Google_Apple_RIM_Owner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Workflow to update the owner field value with the GSPO_MTP - Google/Apple/RIM  queue when the partner value is chosen as MTP - Google/Apple/RIM</description>
        <formula>RecordTypeId = '01280000000G7GD' &amp;&amp; ISPICKVAL(Partner__c, 'MTP - Google/Apple/RIM')</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SAC GSPO Microsoft Owner</fullName>
        <actions>
            <name>SAC_GSPO_Microsoft_Owner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Workflow to update the owner field value with the GSPO_Microsoft queue when the partner value is chosen as Microsoft</description>
        <formula>RecordTypeId = '01280000000G7GD' &amp;&amp; ISPICKVAL(Partner__c, 'Microsoft')</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SAC GSPO NetApp Owner</fullName>
        <actions>
            <name>SAC_GSPO_NetApp_Owner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Workflow to update the owner field value with the GSPO_NetApp queue when the partner value is chosen as NetApp</description>
        <formula>RecordTypeId = '01280000000G7GD' &amp;&amp; ISPICKVAL(Partner__c, 'NetApp')</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SAC GSPO Oracle Owner</fullName>
        <actions>
            <name>SAC_GSPO_Oracle_Owner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Workflow to update the owner field value with the GSPO_Oracle queue when the partner value is chosen as Oracle</description>
        <formula>RecordTypeId = '01280000000G7GD' &amp;&amp; ISPICKVAL(Partner__c, 'Oracle')</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SAC GSPO Other Owner</fullName>
        <actions>
            <name>SAC_GSPO_Other_Owner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Workflow to update the owner field value with the GSPO_Other queue when the partner value is chosen as Other</description>
        <formula>RecordTypeId = '01280000000G7GD' &amp;&amp; ISPICKVAL(Partner__c, 'Other')</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SAC GSPO RedHat Owner</fullName>
        <actions>
            <name>SAC_GSPO_RedHat_Owner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Workflow to update the owner field value with the GSPO_RedHat queue when the partner value is chosen as RedHat</description>
        <formula>RecordTypeId = '01280000000G7GD' &amp;&amp; ISPICKVAL(Partner__c, 'RedHat')</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SAC GSPO SAP Owner</fullName>
        <actions>
            <name>SAC_GSPO_SAP_Owner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Workflow to update the owner field value with the GSPO_SAP queue when the partner value is chosen as SAP</description>
        <formula>RecordTypeId = '01280000000G7GD' &amp;&amp; ISPICKVAL(Partner__c, 'SAP')</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SAC GSPO VCE Owner</fullName>
        <actions>
            <name>SAC_GSPO_VCE_Owner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>RecordTypeId = '01280000000G7GD' &amp;&amp; ISPICKVAL(Partner__c, 'VCE')</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>SAC GSPO VMWare Owner</fullName>
        <actions>
            <name>SAC_GSPO_VMWare_Owner</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Workflow to update the owner field value with the GSPO_VMWare queue when the partner value is chosen as VMWare</description>
        <formula>RecordTypeId = '01280000000G7GD' &amp;&amp; ISPICKVAL(Partner__c, 'VMWare')</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Update CRMDB Integrated Flag</fullName>
        <actions>
            <name>Update_CRMDB_Integrated_Field</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Qualification__c.Integrated_with_CRMDB__c</field>
            <operation>equals</operation>
            <value>True</value>
        </criteriaItems>
        <description>Updated CRMDB Integrated Flag to False when qualification is cloned.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
