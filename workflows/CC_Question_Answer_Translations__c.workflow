<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>NGCC_Q_A_Translation_Code</fullName>
        <field>Language_Code__c</field>
        <formula>CASE(TEXT(Language__c),
"Danish","da",
"Dutch","nl_NL",
"English","en_US",
"Finnish","fi",
"French","fr",
"German","de",
"Italian","it",
"Japanese","ja",
"Korean","ko",
"Portuguese (Brazil)","pt_BR",
"Russian","ru",
"Spanish","es",
"Swedish","sv",
"Thai","th",
"Arabic","ar",
"Czech","cs",
"Greek","el",
"Hungarian","hu",
"Polish","pl",
"Turkish","tr",
"Chinese Simplified","zh_CN",
"Vietnamese","vi",
"Others")</formula>
        <name>NGCC Q&amp;A Translation Code</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>NGCC_Q_A_Translation_ExternalId_Update</fullName>
        <field>MasterQuestionBankId__c</field>
        <formula>CASESAFEID(CC_Master_Question_Answer_Bank__c)&amp;CASE(TEXT(Language__c), 
"Danish","da", 
"Dutch","nl_NL", 
"English","en_US", 
"Finnish","fi", 
"French","fr", 
"German","de", 
"Italian","it", 
"Japanese","ja", 
"Korean","ko", 
"Portuguese (Brazil)","pt_BR", 
"Russian","ru", 
"Spanish","es", 
"Swedish","sv", 
"Thai","th", 
"Arabic","ar", 
"Czech","cs", 
"Greek","el", 
"Hungarian","hu", 
"Polish","pl", 
"Turkish","tr", 
"Chinese Simplified","zh_CN", 
"Vietnamese","vi", 
"Others")</formula>
        <name>NGCC_Q&amp;A_Translation_ExternalId_Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>NGCC_Q%26A_Translation_ExternalId %26 Code</fullName>
        <actions>
            <name>NGCC_Q_A_Translation_Code</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>NGCC_Q_A_Translation_ExternalId_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <booleanFilter>1 OR 2</booleanFilter>
        <criteriaItems>
            <field>CC_Question_Answer_Translations__c.Translated_Value__c</field>
            <operation>notEqual</operation>
        </criteriaItems>
        <criteriaItems>
            <field>CC_Question_Answer_Translations__c.MasterQuestionBankId__c</field>
            <operation>equals</operation>
        </criteriaItems>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
