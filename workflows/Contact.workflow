<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Email_Alert_to_Partner_User_on_Contact_Update_before_or_after_user_creation</fullName>
        <description>Email Alert to Partner User on Contact Update before or after user creation</description>
        <protected>false</protected>
        <recipients>
            <field>Email</field>
            <type>email</type>
        </recipients>
        <senderAddress>donotreply-sfdc@cisco.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>P360_Email_Templates/Sales_Collaboration_Platform_New_User</template>
    </alerts>
    <fieldUpdates>
        <fullName>Account_Change_Time_Update</fullName>
        <field>Account_Owner_Email_Update_Time__c</field>
        <formula>NOW()</formula>
        <name>Account Change Time Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Additional_Mobile_Number</fullName>
        <field>SFDC_Mobile_Number__c</field>
        <formula>PRIORVALUE(MobilePhone)</formula>
        <name>Additional Mobile Number</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Additional_Phone_Number</fullName>
        <field>SFDC_Phone_Number__c</field>
        <formula>PRIORVALUE(Phone)</formula>
        <name>Additional Phone Number</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Additional_Primary_Email_Update</fullName>
        <field>SFDC_Primary_Email__c</field>
        <formula>PRIORVALUE(Email)</formula>
        <name>Additional Primary Email Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Additional_Secondary_Email_Update</fullName>
        <field>SFDC_Secondary_Email__c</field>
        <formula>PRIORVALUE(EmailAddress2__c)</formula>
        <name>Additional Secondary Email Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CX_Title_Field_update</fullName>
        <description>Update Title field for Internal Contact.</description>
        <field>Title</field>
        <formula>TEXT(CX_Team_Role__c)</formula>
        <name>CX - Title Field update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CheckEmailOptOut</fullName>
        <description>For QW 1924, to set the standard field “Email Opt Out” depending upon “Contact Permission Email”</description>
        <field>HasOptedOutOfEmail</field>
        <literalValue>1</literalValue>
        <name>Check Email Opt Out</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Contact_Delete_Date_Now</fullName>
        <description>Set Contact Delete Date to Now</description>
        <field>Contact_Delete_Date__c</field>
        <formula>Now()</formula>
        <name>Contact Delete Date (Now)</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Contact_P360_PPE_Updates</fullName>
        <description>Update Partner_Program_Enrollment_Updated_Date__c whenever there are change to user relevant fields</description>
        <field>Partner_Program_Enrollment_Updated_Date__c</field>
        <formula>TODAY()</formula>
        <name>Contact &gt; P360 PPE Updates</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Contact_P360_Role_Update</fullName>
        <description>This will update Contact Role based on user Partner Led Role</description>
        <field>PA_Role__c</field>
        <formula>IF(CONTAINS(Partner_Admin_Roles__c , "PARTNER_LED_APP_ADMIN"),"Executive",
IF(CONTAINS(Partner_Admin_Roles__c , "PARTNER_LED_APP_USER") ,"Worker","Normal"))</formula>
        <name>Contact &gt; P360 Role Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Contact_Partner_Admin_RoleUpdated_Date</fullName>
        <description>The Date Time on which the partner admin role field is updated is stored here.</description>
        <field>Partner_Admin_Role_Update_Date__c</field>
        <formula>NOW()</formula>
        <name>Contact &gt; Partner Admin RoleUpdated Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Contact_Title_Local_Update</fullName>
        <description>This updates the Title Local field with the value of the Title field.</description>
        <field>Title_English__c</field>
        <formula>Title</formula>
        <name>Contact Title Local Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>DeploymentNoContacts</fullName>
        <description>This rules is to updates all contacts deployment no. field with the data that is stored on the user record.</description>
        <field>Deployment_No__c</field>
        <formula>$User.Deployment_No__c</formula>
        <name>Deployment No. Contacts</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Nurture_Date_today</fullName>
        <description>Nurture Date today()</description>
        <field>Nurture_Date__c</field>
        <formula>TODAY()</formula>
        <name>Nurture Date today()</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Other_City</fullName>
        <field>OtherCity</field>
        <formula>PRIORVALUE(MailingCity)</formula>
        <name>Other City</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Other_Country</fullName>
        <field>OtherCountry</field>
        <formula>PRIORVALUE(MailingCountry)</formula>
        <name>Other Country</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Other_State_Province</fullName>
        <field>OtherState</field>
        <formula>PRIORVALUE(MailingState)</formula>
        <name>Other State/Province</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Other_Street</fullName>
        <field>OtherStreet</field>
        <formula>PRIORVALUE(MailingStreet)</formula>
        <name>Other Street</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Other_Zip_Postal_Code</fullName>
        <field>OtherPostalCode</field>
        <formula>PRIORVALUE(MailingPostalCode)</formula>
        <name>Other Zip/Postal Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Partner_Contact_Name_Local_Update</fullName>
        <description>This updates the Partner Contact Name Local field with the first name and the last name.</description>
        <field>Partner_Contact_Name_Local__c</field>
        <formula>IF(ISPICKVAL(Account.Country__c, 'Japan'), LastName + " " + FirstName, FirstName + " " + LastName)</formula>
        <name>Partner Contact Name Local Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Partner_Contact_Name_Local_Update_Japan</fullName>
        <description>Updates the partner contact name local field</description>
        <field>Partner_Contact_Name_Local__c</field>
        <formula>LastName + " " + FirstName</formula>
        <name>Partner Contact Name Local Update Japan</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>UncheckEmailOptOut</fullName>
        <description>For QW 1924, to set the standard field “Email Opt Out” depending upon “Contact Permission Email”</description>
        <field>HasOptedOutOfEmail</field>
        <literalValue>0</literalValue>
        <name>Uncheck Email Opt Out</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Contact_DuplicatePrevention</fullName>
        <field>DuplicatePrevention__c</field>
        <formula>IF(AccountId = '0013000000Gdbbx' ||
   AccountId = '0018000000skzY3' ||
   AccountId = '0018000000UQ0Tw' ||
   AccountId = '0018000000V7axy',
     AccountId + '-' + LastName + '-' + Email+ '-' + Phone + '-' + TEXT( NOW()), 
     AccountId + '-' + LastName + '-' + Email
)</formula>
        <name>Update Contact DuplicatePrevention</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <outboundMessages>
        <fullName>Contact_Notification</fullName>
        <apiVersion>40.0</apiVersion>
        <endpointUrl>https://wsgx-secure.cisco.com/quotecollab/oppty/ContactNotification</endpointUrl>
        <fields>AccountId</fields>
        <fields>Account_ID__c</fields>
        <fields>Birthdate</fields>
        <fields>ContactPermissionCall__c</fields>
        <fields>ContactPermissionEmail__c</fields>
        <fields>ContactPermissionFax__c</fields>
        <fields>ContactPermissionMail__c</fields>
        <fields>ContactStatus__c</fields>
        <fields>Description</fields>
        <fields>Email</fields>
        <fields>EmailAddress2__c</fields>
        <fields>EmailAddress3__c</fields>
        <fields>Fax</fields>
        <fields>FirstName</fields>
        <fields>Gender__c</fields>
        <fields>HomePhone</fields>
        <fields>Id</fields>
        <fields>JobFunction__c</fields>
        <fields>JobLevel__c</fields>
        <fields>LastName</fields>
        <fields>LeadType__c</fields>
        <fields>MailingCity</fields>
        <fields>MailingCountry</fields>
        <fields>MailingPostalCode</fields>
        <fields>MailingState</fields>
        <fields>MailingStreet</fields>
        <fields>MobilePhone</fields>
        <fields>Nurture_Date__c</fields>
        <fields>Nurture_Program_Name__c</fields>
        <fields>OtherCity</fields>
        <fields>OtherCountry</fields>
        <fields>OtherPhone</fields>
        <fields>OtherPostalCode</fields>
        <fields>OtherState</fields>
        <fields>OtherStreet</fields>
        <fields>OwnerId</fields>
        <fields>Phone</fields>
        <fields>PreferredLanguage__c</fields>
        <fields>RecordTypeId</fields>
        <fields>Salutation</fields>
        <fields>SystemModstamp</fields>
        <fields>Time_Zone__c</fields>
        <fields>Title</fields>
        <includeSessionId>false</includeSessionId>
        <integrationUser>cr_ai_change_events@cisco.com</integrationUser>
        <name>Contact Notification</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>Account Change</fullName>
        <actions>
            <name>Account_Change_Time_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(AccountId)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CX - Populate Title field</fullName>
        <actions>
            <name>CX_Title_Field_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.RecordTypeId</field>
            <operation>equals</operation>
            <value>Internal Contact</value>
        </criteriaItems>
        <description>Populate Title field with Team member LOV item</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>Check Email Opt Out</fullName>
        <actions>
            <name>CheckEmailOptOut</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 AND 2 AND 3 AND 4 AND 5</booleanFilter>
        <criteriaItems>
            <field>Contact.ContactPermissionEmail__c</field>
            <operation>notEqual</operation>
            <value>Y</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.ContactPermissionEmail__c</field>
            <operation>notEqual</operation>
            <value>Yes</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.ContactPermissionEmail__c</field>
            <operation>notEqual</operation>
            <value>1</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.ContactPermissionEmail__c</field>
            <operation>notEqual</operation>
            <value>I</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.ContactPermissionEmail__c</field>
            <operation>notEqual</operation>
            <value>O</value>
        </criteriaItems>
        <description>For QW 1924, to set the standard field “Email Opt Out” depending upon “Contact Permission Email”</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Contact Delete Date %28Now%29</fullName>
        <actions>
            <name>Contact_Delete_Date_Now</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>ISCHANGED(   OldAccountIdBeforeDeletion__c  ) &amp;&amp;   BEGINS(Account.Name, 'Contact Delete Dummy Account')</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Contact Outbound Notification</fullName>
        <actions>
            <name>Contact_Notification</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.ContactStatus__c</field>
            <operation>equals</operation>
            <value>Active</value>
        </criteriaItems>
        <description>The data will flow from sfdc to Tibco through Layer 7</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>ContactDuplicatePrevention</fullName>
        <actions>
            <name>Update_Contact_DuplicatePrevention</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Stamps DuplicatePrevention field on the Contact with AccountId - LastName - Email.</description>
        <formula>( $User.Username    != 'informatica_integration_user@cisco.com'     &amp;&amp; $User.Username != 'ye_publish@cisco.com'    &amp;&amp; $User.Username != 'dataload_suppress_user@cisco.com' )    &amp;&amp;   (ISNEW() ||  ( ISCHANGED(AccountId) ||    ISCHANGED(LastName) ||    ISCHANGED(Email) ||    DuplicatePrevention__c == '') )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Deployment No%2E Contacts</fullName>
        <actions>
            <name>DeploymentNoContacts</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>User.Deployment_No__c</field>
            <operation>notEqual</operation>
            <value>999</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.CreatedById</field>
            <operation>notEqual</operation>
            <value>Data Migration</value>
        </criteriaItems>
        <description>This rule is to update the Deployment No. field on the contact record with the data on the user record.</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Nurture Date Today%28%29</fullName>
        <actions>
            <name>Nurture_Date_today</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Nurture Date Today()</description>
        <formula>ISCHANGED(Nurture_Program_Name__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>P360 Email alert for Partner before%2Fafter user create</fullName>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>Contact.Partner_Admin_Roles__c</field>
            <operation>equals</operation>
            <value>PARTNER_LED_APP_ADMIN</value>
        </criteriaItems>
        <criteriaItems>
            <field>Contact.Partner_Admin_Roles__c</field>
            <operation>equals</operation>
            <value>PARTNER_LED_APP_USER</value>
        </criteriaItems>
        <description>This is a Time Dependent work flow to check contatcs(partner admin role) and send an email to Partner after 24hrs(In the meanwhile users can be created with batch class)</description>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
        <workflowTimeTriggers>
            <actions>
                <name>Email_Alert_to_Partner_User_on_Contact_Update_before_or_after_user_creation</name>
                <type>Alert</type>
            </actions>
            <offsetFromField>Contact.Partner_Admin_Role_Update_Date__c</offsetFromField>
            <timeLength>24</timeLength>
            <workflowTimeTriggerUnit>Hours</workflowTimeTriggerUnit>
        </workflowTimeTriggers>
    </rules>
    <rules>
        <fullName>P360 Partner Program Enrollment Updated Date</fullName>
        <actions>
            <name>Contact_P360_PPE_Updates</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Contact_P360_Role_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This will update Partner Program Enrollment Updated Date based on change in contact details.
This is part of P360 Partner On boarding Daily Jobs implementation</description>
        <formula>AND( RecordTypeId = $Setup.ObjectRecordTypeIds__c.Contact_PDB_RecordTypeId__c,  ( ISNEW() &amp;&amp;  NOT(ISBLANK(Partner_Admin_Roles__c) )  ) ||  ISCHANGED( Partner_Admin_Roles__c ) ||  ISCHANGED( CCO_ID__c ) ||  ISCHANGED( Email ) ||  ISCHANGED( ContactStatus__c ) ||  ISCHANGED( PreferredLanguage__c)||  ISCHANGED( FirstName ) ||  ISCHANGED( LastName) ||  ISCHANGED( MailingCity) ||  ISCHANGED( MailingCountry) ||  ISCHANGED( MailingState ) ||  ISCHANGED( MailingStreet) ||  ISCHANGED( MailingPostalCode))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>P360_Partner_Admin_Roles_Updated</fullName>
        <actions>
            <name>Contact_Partner_Admin_RoleUpdated_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This workflow will record the date on which the partner admin role field was updated in the record.</description>
        <formula>( ISNEW() &amp;&amp;   NOT(ISBLANK(Partner_Admin_Roles__c) )  )  || ISCHANGED( Partner_Admin_Roles__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SystemContactConversion</fullName>
        <actions>
            <name>Additional_Mobile_Number</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Additional_Phone_Number</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Additional_Primary_Email_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Additional_Secondary_Email_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Other_City</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Other_Country</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Other_State_Province</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Other_Street</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Other_Zip_Postal_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>AND(ISCHANGED( RecordTypeId ),  $RecordType.DeveloperName == 'PDB_Partner_Contact')</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Uncheck Email Opt Out</fullName>
        <actions>
            <name>UncheckEmailOptOut</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Contact.ContactPermissionEmail__c</field>
            <operation>equals</operation>
            <value>1,Yes,O,Y,I</value>
        </criteriaItems>
        <description>For QW 1924, to set the standard field “Email Opt Out” depending upon “Contact Permission Email”</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
