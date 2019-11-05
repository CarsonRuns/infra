<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Business_Entity_Update</fullName>
        <description>Business Entity Update</description>
        <field>Business_Entity__c</field>
        <formula>IF(Product2.ProductCode == 'Technology',
TEXT(Product2.Business_Entity__c),

IF (TEXT(Product2.Service_Type__c) == 'TS' ||
UPPER(Product2.Service_Category__c) == 'TECHNICAL SUPPORT SERVICES' ||
UPPER(Product2.Service_Category__c) == 'WORLDWIDE TRAINING',
'TS-S',
IF (UPPER(Product2.Allocated_Service_Group__c) == 'AS SUBSCRIPTION',
'AS-S',
IF (UPPER(Product2.Allocated_Service_Group__c) == 'AS TRANSACTIONAL' ||
UPPER(Product2.Allocated_Service_Group__c) == 'AS TRANSACTION' ||
UPPER(Product2.Allocated_Service_Group__c) == 'AS FIXED',
'AS-T',
TEXT( PricebookEntry.Product2.Business_Entity__c)
)))

)</formula>
        <name>Business Entity Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>OpportunityProductServiceTypeUpdate</fullName>
        <description>Sets the value of Service Type to either 'AS', 'TS' for 'Service' records</description>
        <field>Service_Type__c</field>
        <formula>IF(TEXT(Product2.Service_Type__c) == 'TS' || 
        UPPER(Product2.Service_Category__c) == 'TECHNICAL SUPPORT SERVICES' ||
        UPPER(Product2.Service_Category__c) == 'WORLDWIDE TRAINING', 
        'TS',
   IF(TEXT(Product2.Service_Type__c) == 'AS' || 
           UPPER(Product2.Allocated_Service_Group__c) == 'AS SUBSCRIPTION' ||
           UPPER(Product2.Allocated_Service_Group__c) == 'AS TRANSACTIONAL',
           'AS',
   IF(Product2.ProductCode == 'Service',
           TEXT(Product2.Service_Type__c),
    ''))
   )</formula>
        <name>Opportunity Product Service Type Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Product_CCW_Quote_Id_Update</fullName>
        <field>CCW_BOM_Integrated_Quote_Id__c</field>
        <formula>QuoteId__c</formula>
        <name>zzOpportunityProductCCWQuoteIdUpdate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>OpportunityId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Opportunity_Product_Integration_TimeStam</fullName>
        <field>CCW_BOM_Integrated_Date__c</field>
        <formula>NOW()</formula>
        <name>zzOpportunityProductIntegration TimeStam</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>OpportunityId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Product_Code_update</fullName>
        <description>Updates Product Code to Technology/Service</description>
        <field>Product_Code__c</field>
        <formula>Product2.ProductCode</formula>
        <name>Product Code update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Product_Family_Update</fullName>
        <description>Product Family Update</description>
        <field>Product_Family__c</field>
        <formula>IF 
(
    (Product_Family_Ref__c != '' || 
       ISBLANK (Product_Family_Ref__c)), 
         Product_Family_Ref__r.Product_Family_Description__c,  
         Product_Family__c
)</formula>
        <name>Product Family Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Opportunity Product BE%2FProduct Code Update</fullName>
        <actions>
            <name>Business_Entity_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Product_Code_update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Updates BE/ProductCode</description>
        <formula>Product2.ProductCode != ''</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Opportunity Product Service Type Update</fullName>
        <actions>
            <name>OpportunityProductServiceTypeUpdate</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>OpportunityLineItem.ProductCode</field>
            <operation>equals</operation>
            <value>Service</value>
        </criteriaItems>
        <description>Sets the value of Service Type to either 'AS', 'TS' for 'Service' records</description>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Product Family Update</fullName>
        <actions>
            <name>Product_Family_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Product Family Update</description>
        <formula>Product_Family_Ref__c != ''</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>zzOpportunity Product Integration TimeStamp</fullName>
        <actions>
            <name>Opportunity_Product_CCW_Quote_Id_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Opportunity_Product_Integration_TimeStam</name>
            <type>FieldUpdate</type>
        </actions>
        <active>false</active>
        <formula>NOT(ISBLANK(QuoteId__c))</formula>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
</Workflow>
