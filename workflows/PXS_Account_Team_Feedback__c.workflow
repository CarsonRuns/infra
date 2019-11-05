<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <alerts>
        <fullName>PXS_Feedback_Email_Alert</fullName>
        <description>PXS Feedback Email Alert</description>
        <protected>false</protected>
        <recipients>
            <recipient>pe-survey-responses@cisco.com</recipient>
            <type>user</type>
        </recipients>
        <senderAddress>donotreply-ciscosales@cisco.com</senderAddress>
        <senderType>OrgWideEmailAddress</senderType>
        <template>Cases/PXS_Survey_Response_Notification_Email_Template</template>
    </alerts>
</Workflow>
