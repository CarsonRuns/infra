<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>Case_Comment_Email_CIC_Cisco</fullName>
        <description>Case Comment Email CIC Cisco</description>
        <protected>false</protected>
        <recipients>
            <type>creator</type>
        </recipients>
        <senderAddress>donotreply-ciscosales@cisco.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Cases/Case_Comment_HtmlEmail_Template_CIC</template>
    </alerts>
    <fieldUpdates>
        <fullName>TSN_Mobility_of_Case_Comment_Update</fullName>
        <description>To Update # of case comment on insert of new comment to a case</description>
        <field>Number_of_Case_Comment__c</field>
        <formula>IF(ISBLANK(Parent.Number_of_Case_Comment__c) || ISNULL(Parent.Number_of_Case_Comment__c), 1,Parent.Number_of_Case_Comment__c+1)</formula>
        <name>TSN Mobility: # of Case Comment Update</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>TSN_Update_Case_Status_Comment_Addition</fullName>
        <field>Status</field>
        <literalValue>Updated</literalValue>
        <name>TSN_Update_Case_Status_Comment_Addition</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Literal</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Update_Case_Last_Modified_Date_Comment</fullName>
        <field>Status_Change_Date_Time__c</field>
        <formula>NOW()</formula>
        <name>Update_Case_Last_Modified_Date_Comment</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
        <targetObject>ParentId</targetObject>
    </fieldUpdates>
    <rules>
        <fullName>Case Comment Email CIC Cisco</fullName>
        <actions>
            <name>Case_Comment_Email_CIC_Cisco</name>
            <type>Alert</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>CIC Security &amp; Trust Customer Engagement Request</value>
        </criteriaItems>
        <triggerType>onCreateOrTriggeringUpdate</triggerType>
    </rules>
    <rules>
        <fullName>TSN_Update_Case_Status_Comment_Addition</fullName>
        <actions>
            <name>TSN_Update_Case_Status_Comment_Addition</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>This work flow will update Case Status if a Case Comment is added to TSN Case by AM/SE users</description>
        <formula>AND(Parent.RecordTypeId == '01280000000G78n' , $Profile.Name &lt;&gt; "Cisco_Sales_Cases" , !(ISPICKVAL(Parent.Status ,'Closed')),!(BEGINS(Parent.OwnerId , '00G')))</formula>
        <triggerType>onCreateOnly</triggerType>
    </rules>
    <rules>
        <fullName>Update_Comments_Added_DT_Count</fullName>
        <actions>
            <name>TSN_Mobility_of_Case_Comment_Update</name>
            <type>FieldUpdate</type>
        </actions>
        <actions>
            <name>Update_Case_Last_Modified_Date_Comment</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <criteriaItems>
            <field>Case.RecordTypeId</field>
            <operation>equals</operation>
            <value>Partner Advisor Case,PDI Case,GVE Case</value>
        </criteriaItems>
        <description>This work flow will update Last Modified Date and Count on Case if a Case Comment is added</description>
        <triggerType>onCreateOnly</triggerType>
    </rules>
</Workflow>
