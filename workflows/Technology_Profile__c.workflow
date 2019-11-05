<?xml version="1.0" encoding="utf-8"?><Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>Collaboration_TP_Last_Modified_Date</fullName>
        <description>Collaboration  TP Last Modified Date</description>
        <field>Collaboration_Last_Modified_Date__c</field>
        <formula>NOW()</formula>
        <name>Collaboration TP Last Modified Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Data_Center_TP_Last_Modified_Date</fullName>
        <description>TP Last Modified Date</description>
        <field>Data_Center_Last_Modified_Date__c</field>
        <formula>NOW()</formula>
        <name>Data Center TP Last Modified Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>EN_TP_Last_Modified_Date</fullName>
        <description>EN TP Last Modified Date</description>
        <field>EN_Last_Modified_Date__c</field>
        <formula>NOW()</formula>
        <name>EN TP Last Modified Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Emerging_TP_Last_Modified_Date</fullName>
        <description>Emerging TP Last Modified Date</description>
        <field>Emerging_Last_Modified_Date__c</field>
        <formula>NOW()</formula>
        <name>Emerging TP Last Modified Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>Security_TP_Last_Modified_Date</fullName>
        <description>Security TP Last Modified Date</description>
        <field>Security_Last_Modified_Date__c</field>
        <formula>NOW()</formula>
        <name>Security TP Last Modified Date</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>Collaboration TP Last Modified Date</fullName>
        <actions>
            <name>Collaboration_TP_Last_Modified_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>WR-0454---Last Date Collaboration TP was modified</description>
        <formula>ISCHANGED (COLLAB_Contact_Center_ACD__c) ||  ISCHANGED (COLLAB_Contact_Center_IVR__c) ||  ISCHANGED (COLLAB_Contact_Center_Recording__c) ||  ISCHANGED (COLLAB_Core_Primary_Call_Control__c) ||  ISCHANGED (COLLAB_Core_Secondary_Call_Control__c) ||  ISCHANGED (COLLAB_Core_Primary_Voice_Mail__c) ||  ISCHANGED (COLLAB_Mobility_UC_Client_Deployed__c) ||  ISCHANGED (COLLAB_Video_Corp_Video_Distribution__c) ||  ISCHANGED (COLLAB_Video_PRI_Desktop_Video_Vendor__c) ||  ISCHANGED (COLLAB_Video_PRI_Video_Endpoint_Vendor__c) ||  ISCHANGED (COLLAB_Video_PRI_Video_Infra_Vendor__c) ||  ISCHANGED (COLLAB_Video_Secondary_Video_Vendor__c) ||  ISCHANGED (COLLAB_Web_Collab_Audio_Only_Bridge__c) ||  ISCHANGED (COLLAB_Web_Collab_IM_Presence__c) ||  ISCHANGED (COLLAB_Web_Collab_Web_Conf_AudioBridge__c) ||  ISCHANGED (COLLAB_Web_Collab_Primary_Vendor__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Data Center TP Last Modified Date</fullName>
        <actions>
            <name>Data_Center_TP_Last_Modified_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>WR-0454---Last Date Data Center TP was modified</description>
        <formula>ISCHANGED (DC_Environment_App_Acceleration__c) ||  ISCHANGED (DC_Environment_App_Load_Balancing__c) ||  ISCHANGED (DC_Environment_Automation__c) ||  ISCHANGED (DC_Servers_Blade__c) ||  ISCHANGED (DC_Servers_Rack__c) ||  ISCHANGED (DC_Servers_Secondary_Blade__c) ||  ISCHANGED (DC_Servers_Secondary_Rack__c) ||  ISCHANGED (DC_Storage_FC__c) ||  ISCHANGED (DC_Storage_FC_Switching__c) ||  ISCHANGED (DC_Storage_NAS__c) ||  ISCHANGED (DC_Storage_Secondary_FC__c) ||  ISCHANGED (DC_Storage_Secondary_NAS__c) ||  ISCHANGED (DC_Switching_Blade_Server__c) ||  ISCHANGED (DC_Switching_Core__c) || ISCHANGED (DC_Switching_ToR__c) ||  ISCHANGED (DC_Environment_Hybrid_Cloud_Mgmt__c) ||  ISCHANGED (DC_Switching_Hypervisor_VSwitch__c)||  ISCHANGED (DC_Environment_Hyperconverged__c)||  ISCHANGED (DC_Switching_SDN__c)||  ISCHANGED (DC_Servers_NIC_HBA__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>EN TP Last Modified Date</fullName>
        <actions>
            <name>EN_TP_Last_Modified_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>WR-0454---Last Date EN TP was modified</description>
        <formula>ISCHANGED (EN_Routing_Aggregation_Routers__c) ||  ISCHANGED (EN_Routing_Branch_Routers__c) ||  ISCHANGED (EN_Routing_WAN_Optimization__c) ||  ISCHANGED (EN_Switching_LAN_Access__c) ||  ISCHANGED (EN_Switching_LAN_CORE__c) ||  ISCHANGED (EN_Switching_LAN_Distribution__c) ||  ISCHANGED (EN_Switching_Secondary_LAN_Access__c) ||  ISCHANGED (EN_Switching_Secondary_LAN_Core__c) ||  ISCHANGED (EN_Switching_Secondary_LAN_Distribution__c) ||  ISCHANGED (EN_Wireless_AP__c) ||  ISCHANGED (EN_Wireless_Controller__c) ||  ISCHANGED (EN_Wireless_MSE__c) ||  ISCHANGED (EN_Wireless_Management__c) ||  ISCHANGED (EN_Wireless_Secondary_AP__c) ||  ISCHANGED (EN_Wireless_Secondary_Controller__c) ||  ISCHANGED (EN_Switching_Management__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Emerging TP Last Modified Date</fullName>
        <actions>
            <name>Emerging_TP_Last_Modified_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>WR-0454---Last Date Emerging TP was modified</description>
        <formula>ISCHANGED (EM_Digital_Media__c) ||  ISCHANGED (EM_Connected_Energy_Network__c) ||  ISCHANGED (EM_Home_Networking__c) ||  ISCHANGED (EM_Media_Experience__c) ||  ISCHANGED (EM_Physical_Security__c)</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
    <rules>
        <fullName>Security TP Last Modified Date</fullName>
        <actions>
            <name>Security_TP_Last_Modified_Date</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>Last Date TP was modified</description>
        <formula>ISCHANGED (SEC_Web_Security__c) ||
ISCHANGED (SEC_Email_Security__c ) ||
ISCHANGED (SEC_Firewall__c ) ||
ISCHANGED (SEC_Secure_DC_Firewall__c ) ||
ISCHANGED (SEC_IPS_IDS__c ) ||
ISCHANGED (SEC_NAC_ISE__c ) ||
ISCHANGED (SEC_IPSec_VPN__c ) ||
ISCHANGED (SEC_SSL_VPN__c ) ||
ISCHANGED (SEC_UTM__c ) ||
ISCHANGED (SEC_Adv_Malware_Protection_for_Network__c ) ||
ISCHANGED (SEC_Endpoint_Protection__c ) ||
ISCHANGED (SEC_Breach_Detection__c ) ||
ISCHANGED (SEC_Breach_Detection__c )</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
