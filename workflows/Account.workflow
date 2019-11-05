<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>AccountNameEngToCR_Name</fullName>
        <description>Copy Account Name English to CR Name</description>
        <field>CRName__c</field>
        <formula>AccountNameEnglish__c</formula>
        <name>AccountNameEngToCR_Name</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AccountReadOnlyMessageUpdate</fullName>
        <field>Read_Only_Warning__c</field>
        <formula>"DO NOT change the Account Name or it will be out-of-sync with PDB."</formula>
        <name>Account Read Only Message Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_BillingAddress12</fullName>
        <description>Copies Address1 and Address 2 to Billing Street</description>
        <field>BillingStreet</field>
        <formula>TRIM(LEFT(AddressLine1__c &amp; ' ' &amp; AddressLine2__c,255))</formula>
        <name>Account_Billing Address12</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_BillingCity</fullName>
        <description>Copies City to Billing City</description>
        <field>BillingCity</field>
        <formula>TRIM(LEFT(City__c,40))</formula>
        <name>Account_Billing City</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_BillingCountry</fullName>
        <description>Copies Country to Billing Country</description>
        <field>BillingCountry</field>
        <formula>TRIM(LEFT(TEXT(Country__c),40))</formula>
        <name>Account_Billing Country</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_BillingState</fullName>
        <description>Copies State to Billing State/Province</description>
        <field>BillingState</field>
        <formula>TRIM(LEFT(State__c,20))</formula>
        <name>Account_Billing State</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_BillingZip</fullName>
        <description>Copies Zip to Billing Postal Code</description>
        <field>BillingPostalCode</field>
        <formula>TRIM(LEFT(ZipPostalCode__c, 20))</formula>
        <name>Account_Billing Zip</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_PGTMV_ID_Update</fullName>
        <description>Updates PGTMV field when workflow fires.</description>
        <field>PGTMV_ID__c</field>
        <formula>IF( $RecordType.Name == 'Channel', BEC_ID__c , BE_GEO_ID__c)</formula>
        <name>Account PGTMV ID Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Account_Site_Update</fullName>
        <field>Site</field>
        <formula>LEFT(IF( LEN(AddressLine1_English__c) &gt; 0, LEFT( AddressLine1_English__c , 15),IF( LEN(AddressLine1__c) &gt; 0, LEFT( AddressLine1__c, 15), LEFT( CRAddressLine1__c, 15) ))
&amp; "," 
&amp; IF( LEN( City_English__c ) &gt; 0, LEFT( City_English__c , 10), IF( LEN(City__c) &gt; 0, LEFT( City__c, 10), LEFT( CRCity__c,10)  ))
&amp; "," 
&amp; IF( LEN( State_Province_English__c ) &gt; 0, LEFT( State_Province_English__c , 10), IF( LEN(State__c) &gt; 0, LEFT( State__c, 10), LEFT( CRState__c, 10) ))
&amp; "," 
&amp; IF( LEN( TEXT(Country_English__c) ) &gt; 0, LEFT( TEXT(Country_English__c) , 10), IF( LEN(TEXT(Country__c)) &gt; 0, LEFT( TEXT(Country__c), 10), LEFT( CRCountry__c, 10) )),80)</formula>
        <name>Account_Site_Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Address1EngToCR_Address1</fullName>
        <description>Copy Address 1 English to CR Address Line 1</description>
        <field>CRAddressLine1__c</field>
        <formula>AddressLine1_English__c</formula>
        <name>Address1EngToCR_Address1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Address2EngToCR_Address2</fullName>
        <description>Copy Address 2 English to CR Address Line 2</description>
        <field>CRAddressLine2__c</field>
        <formula>AddressLine2_English__c</formula>
        <name>Address2EngToCR_Address2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AddressEnglishFlag</fullName>
        <field>AddressEnglishFlag__c</field>
        <literalValue>1</literalValue>
        <name>AddressEnglishFlag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>AddressFlag</fullName>
        <field>AddressFlag__c</field>
        <literalValue>1</literalValue>
        <name>AddressFlag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Address_Line_1_Update_to_CRLine1</fullName>
        <field>AddressLine1__c</field>
        <formula>CRAddressLine1__c</formula>
        <name>Address Line 1 Update to CRLine1</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Address_Line_2_Update_to_CRLine2</fullName>
        <field>AddressLine2__c</field>
        <formula>CRAddressLine2__c</formula>
        <name>Address Line 2 Update to CRLine2</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CI_Last_Updated_Date_Now</fullName>
        <description>Update CI Last updated date when fields related to ci is changed.</description>
        <field>CI_Last_Updated_Date__c</field>
        <formula>Now()</formula>
        <name>CI Last Updated Date _Now()</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CRAddressFlag</fullName>
        <field>CRAdressFlag__c</field>
        <literalValue>1</literalValue>
        <name>CRAddressFlag</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CityEngToCR_City</fullName>
        <description>Copy City English to CR City</description>
        <field>CRCity__c</field>
        <formula>City_English__c</formula>
        <name>CityEngToCR_City</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>City_Update_to_CRCity_Value</fullName>
        <field>City__c</field>
        <formula>CRCity__c</formula>
        <name>City Update to CRCity Value</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>CountryEngToCR_Country</fullName>
        <description>Copy CountryEnglish to CR Country</description>
        <field>CRCountry__c</field>
        <formula>TEXT(Country_English__c)</formula>
        <name>CountyEngToCR_Country</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Flag_Run_Rate_Accounts</fullName>
        <description>Flag Run Rate Accounts</description>
        <field>Run_Rate_Account__c</field>
        <literalValue>Yes</literalValue>
        <name>Flag Run Rate Accounts</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Partner_Program_Enrollment_Updated_Date</fullName>
        <description>This will update Partner Program Enrollment Updated Date to Today().
This is part of P360 Partner On boarding Daily Jobs implementation.</description>
        <field>Partner_Program_Enrollment_Updated_Date__c</field>
        <formula>Today()</formula>
        <name>Partner Program Enrollment Updated Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Remove_Flag_Run_Rate_Accounts</fullName>
        <description>Remove Flag Run Rate Accounts</description>
        <field>Run_Rate_Account__c</field>
        <literalValue>No</literalValue>
        <name>Remove Flag Run Rate Accounts</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>SFDC_Account_ID</fullName>
        <description>Copies Account ID to SFDC Account ID</description>
        <field>OMF_Account_ID__c</field>
        <formula>CASESAFEID(Id)</formula>
        <name>SFDC Account ID</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>StateEngToCR_State</fullName>
        <description>Copy State English to CR State</description>
        <field>CRState__c</field>
        <formula>State_Province_English__c</formula>
        <name>StateEngToCR_State</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>State_Update_to_CRStateC_Value</fullName>
        <field>State__c</field>
        <formula>CRState__c</formula>
        <name>State Update to CRState Value</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>ZipEngToCR_Zip</fullName>
        <description>Copy ZipEnglish to CR Zip</description>
        <field>CRZipPostalCode__c</field>
        <formula>Zip_Postal_Code_English__c</formula>
        <name>ZipEngToCR_Zip</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Zip_Code_Update_to_CR_Value</fullName>
        <field>ZipPostalCode__c</field>
        <formula>CRZipPostalCode__c</formula>
        <name>Zip Code Update to CR Value</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>account_owner_update_time</fullName>
        <field>Account_Owner_Update_Time__c</field>
        <formula>NOW()</formula>
        <name>Account Owner Update Time</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <outboundMessages>
        <fullName>CR_Account_Integration</fullName>
        <apiVersion>38.0</apiVersion>
        <description>Used for CR Account Integration</description>
        <endpointUrl>https://wsgx-secure.cisco.com/quotecollab/oppty/AccountIntegration</endpointUrl>
        <fields>CRAddressLine1__c</fields>
        <fields>CRAddressLine2__c</fields>
        <fields>CRAddressLine3__c</fields>
        <fields>CRCity__c</fields>
        <fields>CRCountry__c</fields>
        <fields>CRName__c</fields>
        <fields>CRState__c</fields>
        <fields>CRZipPostalCode__c</fields>
        <fields>End_Customer_Account_Integrated_with_CR__c</fields>
        <fields>Id</fields>
        <fields>OMF_Account_ID__c</fields>
        <includeSessionId>true</includeSessionId>
        <integrationUser>cr_ai_change_events@cisco.com</integrationUser>
        <name>CR Account Integration</name>
        <protected>false</protected>
        <useDeadLetterQueue>false</useDeadLetterQueue>
    </outboundMessages>
    <rules>
        <fullName>Account Owner Id Update</fullName>
        <actions>
            <name>account_owner_update_time</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>(ISCHANGED( OwnerId )) &amp;&amp; (RecordType.Id != $Setup.ObjectRecordTypeIds__c.Account_Customer_RecordTypeId__c &amp;&amp; RecordType.Id != $Setup.ObjectRecordTypeIds__c.Account_Business_Unit_RecordTypeId__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Account PGTMV ID Update</fullName>
        <actions>
            <name>Account_PGTMV_ID_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Updates the PGTMV ID field on the Account for Partner Contacts.  BEC for Channel accounts and BE GEO for Partner Company accounts.  Used in the Upsert process.</description>
        <formula>AND(OR( $RecordType.Name == 'Channel', $RecordType.Name == 'Partner Company'), OR(PGTMV_ID__c == '', AND( $RecordType.Name == 'Channel', ISCHANGED(BEC_ID__c)), AND( $RecordType.Name == 'Partner Company', ISCHANGED(BE_GEO_ID__c))))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Account Read Only Message Update</fullName>
        <actions>
            <name>AccountReadOnlyMessageUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Account.Read_Only_Warning__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>equals</operation>
            <value>Channel</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Account_Billing Address12</fullName>
        <actions>
            <name>Account_BillingAddress12</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Copies Address1 and Address 2 to Billing Street</description>
        <formula>((ISCHANGED( AddressLine1__c ) || ISCHANGED( AddressLine2__c )) || ((AddressLine1__c &amp; ' ' &amp; AddressLine2__c) !=  BillingStreet ))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Account_Billing City</fullName>
        <actions>
            <name>Account_BillingCity</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Copies City to Billing City</description>
        <formula>((ISCHANGED(City__c )) || (City__c != BillingCity))</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Account_Billing Country</fullName>
        <actions>
            <name>Account_BillingCountry</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Copies Country to Billing Country</description>
        <formula>(ISCHANGED(Country__c)) || (BillingCountry = '')</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Account_Billing State</fullName>
        <actions>
            <name>Account_BillingState</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Copies State to Billing State/Province</description>
        <formula>(ISCHANGED(State__c )) || (State__c != BillingState)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Account_Billing Zip</fullName>
        <actions>
            <name>Account_BillingZip</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Copies Zip to Billing Postal Code</description>
        <formula>(ISCHANGED(ZipPostalCode__c)) || (ZipPostalCode__c != BillingPostalCode)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Account_Site_Update</fullName>
        <actions>
            <name>Account_Site_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This rule will update the Account site field whenever there is change in English as well as non English address.</description>
        <formula>NOT (ISNULL(Id))  /*ISCHANGED( AddressLine1__c ) || ISCHANGED( City__c )|| ISCHANGED( State__c )|| ISCHANGED( Country__c )|| ISCHANGED( AddressLine1_English__c )|| ISCHANGED( City_English__c )|| ISCHANGED( State_Province_English__c )|| ISCHANGED( Country_English__c )|| ISCHANGED( CRAddressLine1__c) || ISCHANGED( CRCity__c) || ISCHANGED( CRState__c) || ISCHANGED( CRCountry__c) */</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>AddressEnglishFlag</fullName>
        <actions>
            <name>AddressEnglishFlag</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2 OR 3 OR 4 OR 5 OR 6 OR 7</booleanFilter>
        <criteriaItems>
            <field>Account.AddressLine1_English__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.AddressLine2_English__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.AccountNameEnglish__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.City_English__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Country_English__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.State_Province_English__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Zip_Postal_Code_English__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>AddressFlag</fullName>
        <actions>
            <name>AddressFlag</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 OR 2 OR 3 OR 4 OR 5 OR 6 OR 7) AND 8</booleanFilter>
        <criteriaItems>
            <field>Account.Name</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.AddressLine1__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.AddressLine2__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.City__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.Country__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.State__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.ZipPostalCode__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Business Unit,Customer</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CR Account outbound%3A Integration</fullName>
        <actions>
            <name>CR_Account_Integration</name>
            <type>OutboundMessage</type>
        </actions>
        <active>true</active>
        <description>Used for CR Outbound Account Integration</description>
        <formula>(End_Customer_Account_Integrated_with_CR__c = 'No') &amp;&amp;  (RecordType.Id != $Setup.ObjectRecordTypeIds__c.Account_Customer_RecordTypeId__c  	&amp;&amp; RecordType.Id != $Setup.ObjectRecordTypeIds__c.Account_Business_Unit_RecordTypeId__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>CRAddressFlag</fullName>
        <actions>
            <name>CRAddressFlag</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>(1 OR 2 OR 3 OR 4 OR 5 OR 6 OR 7) AND 8</booleanFilter>
        <criteriaItems>
            <field>Account.CRAddressLine1__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.CRAddressLine2__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.CRCity__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.CRCountry__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.CRName__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.CRState__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.CRZipPostalCode__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>Account.RecordTypeId</field>
            <operation>notEqual</operation>
            <value>Business Unit,Customer</value>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Channel Account Address Update</fullName>
        <actions>
            <name>Address_Line_1_Update_to_CRLine1</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Address_Line_2_Update_to_CRLine2</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>City_Update_to_CRCity_Value</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>State_Update_to_CRStateC_Value</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Zip_Code_Update_to_CR_Value</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>For Channel Accounts if the Standard Address fields are blank, the CR field values will be copied over from PGTMV.  Users can then modify the standard Address as seen fit.</description>
        <formula>AND($RecordType.Name == 'Channel', AddressLine1__c == '', AddressLine2__c == '', City__c == '', State__c == '', ZipPostalCode__c == '' )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Flag Run Rate Accounts</fullName>
        <actions>
            <name>Flag_Run_Rate_Accounts</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>RecordType.Id = $Setup.ObjectRecordTypeIds__c.Account_End_User_RecordTypeId__c &amp;&amp; ( Contains (Lower(Name), 'run rate') || Contains (Lower(Name), 'runrate') || Contains (Lower(Name), 'run-rate') || Contains (Lower(AccountNameEnglish__c) , 'run rate') || Contains (Lower(AccountNameEnglish__c) , 'runrate')|| Contains (Lower(AccountNameEnglish__c) , 'run-rate') )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>P360 CI Last Uploaded Date</fullName>
        <actions>
            <name>CI_Last_Updated_Date_Now</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Created as part of P360 Sep '12 Release.
This will update the CI Last Uploaded Date whenever the key CI data changes.</description>
        <formula>( ISCHANGED(Allocated_Partner_1__c) || ISCHANGED(Allocated_Partner_2__c) || ISCHANGED(Allocated_Partner_3__c) || ISCHANGED(Allocated_Partner_4__c) ||  ISCHANGED(Unallocated_Account__c) || ISCHANGED(Release_to_Unallocated_Pool__c ) ||  ISCHANGED(Current_FY_Bookings_000__c) || ISCHANGED(Current_FY_RAD_Strategy__c) || ISCHANGED(Current_FY_Wallet_Share_YTD__c) || ISCHANGED(Current_FY_Wallet_Total_000__c) ||  ISCHANGED(Previous_FY_Bookings_000__c) || ISCHANGED(Previous_FY_RAD_Strategy__c) || ISCHANGED(Previous_FY_Wallet_Share__c) || ISCHANGED(Previous_FY_Wallet_Total_000__c) ||  ISCHANGED(Previous_4_FY_Bookings_000__c) || ISCHANGED(Previous_4_FY_RAD_Strategy__c) || ISCHANGED(Previous_4_FY_Wallet_Share__c) || ISCHANGED(Previous_4_FY_Wallet_Total_000__c) ||  ISCHANGED(P2B_Data_Center_UCS__c) || ISCHANGED(P2B_Routing__c) || ISCHANGED(P2B_Security__c) || ISCHANGED(P2B_Switching__c) || ISCHANGED(P2B_Unified_Communications__c) || ISCHANGED(P2B_Video__c) || ISCHANGED(P2B_Wireless__c) ||  ISCHANGED(Sales_Alert_01_Description__c) || ISCHANGED(Sales_Alert_02_Description__c) || ISCHANGED(Sales_Alert_03_Description__c) || ISCHANGED(Sales_Alert_04_Description__c) || ISCHANGED(Sales_Alert_05_Description__c) || ISCHANGED(Sales_Alert_06_Description__c) ) &amp;&amp; (RecordType.Id != $Setup.ObjectRecordTypeIds__c.Account_Customer_RecordTypeId__c &amp;&amp; RecordType.Id != $Setup.ObjectRecordTypeIds__c.Account_Business_Unit_RecordTypeId__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>P360 Partner Program Enrollment Updated Date</fullName>
        <actions>
            <name>Partner_Program_Enrollment_Updated_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This will update Partner Program Enrollment Updated Date based on change in Partners enrollment in Partner Program Enrollment.
This is part of P360 Partner On boarding Daily Jobs implementation.</description>
        <formula>OR(  	 AND( 			$RecordType.Id = $Setup.ObjectRecordTypeIds__c.AccountPartnerCompanyRecordTypeId__c,  			ISCHANGED( Partner_360_Program_Count__c )  		),  	 AND( 			ISNEW(), 			$RecordType.Id = $Setup.ObjectRecordTypeIds__c.AccountChannelRecordTypeId__c, 			Partner_Assignment_Eligible__c = 1		  		) 	)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>PDR Collab Account Creation</fullName>
        <actions>
            <name>AccountNameEngToCR_Name</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Address1EngToCR_Address1</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Address2EngToCR_Address2</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CityEngToCR_City</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>CountryEngToCR_Country</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>StateEngToCR_State</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>ZipEngToCR_Zip</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Copy Address English to CR address</description>
        <formula>$User.Id = '00580000001UWjm' &amp;&amp;  ISBLANK( CRName__c )  &amp;&amp;  NOT(ISBLANK( AccountNameEnglish__c ))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Remove Flag Run Rate Accounts</fullName>
        <actions>
            <name>Remove_Flag_Run_Rate_Accounts</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>RecordType.Id = $Setup.ObjectRecordTypeIds__c.Account_End_User_RecordTypeId__c &amp;&amp; ( !Contains (Lower(Name), 'run rate') &amp;&amp; !Contains (Lower(Name), 'runrate') &amp;&amp; !Contains (Lower(Name), 'run-rate') &amp;&amp; !Contains (Lower(AccountNameEnglish__c) , 'run rate') &amp;&amp; !Contains (Lower(AccountNameEnglish__c) , 'runrate')&amp;&amp; !Contains (Lower(AccountNameEnglish__c) , 'run-rate') )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>SFDC Account ID</fullName>
        <actions>
            <name>SFDC_Account_ID</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Copies Account ID to SFDC Account ID</description>
        <formula>(ISBLANK( TRIM(OMF_Account_ID__c )) || Id != OMF_Account_ID__c) &amp;&amp; (RecordType.Id != $Setup.ObjectRecordTypeIds__c.Account_Customer_RecordTypeId__c &amp;&amp; RecordType.Id != $Setup.ObjectRecordTypeIds__c.Account_Business_Unit_RecordTypeId__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
