/*********************************************************************************************************************************
Name    : EloquaProspectProfiler_CTE
Author  : Mukesh Srivastava
Purpose : The purpose of the class to handle Eloqua Profiler Access on Both lead and Contact           
Created Date:  10/14/2014
Modification History: 
 1.History
 Date:- Mar-14-2018
 Author: Kapil Gundi
 Purpose:- 
 1. US177469 Added additional Lead Status for SFDC, NGCC line 95-99 & line 104-105. 
 2. Changed CreateDate from 6 Months to 18 Months line 78.                  
*****************************************************************************************************************************************/

public with sharing class EloquaProspectProfiler_CTE {

    Lead currentLead;
    public String value {get;set;}
    public boolean isLead {get; set;}

    public EloquaProspectProfiler_CTE(ApexPages.StandardController controller) {
       String id = controller.getRecord().Id;
       isLead = false; 
       if (id.startsWith('00Q') == true && Test.isRunningTest() == false){
        isLead = true;
        Lead lead = (Lead) controller.getRecord();     
        currentLead = [SELECT Email,Status,Latest_Lead_Acceptance_Date__c, CreatedDate, Partner_Owned_Contact_Flag__c from Lead where Id =: lead.Id];
       }
       value = ''; 
       
    }
        
     public boolean validLicense {get;set;}
     public boolean activeLead {get; set;} 
     
     public void validateLicense(){
        validLicense = false;
        activeLead = false;
         
  //String id='00580000007JMPMAA4';
       // List<User> ulist=[Select Additional_User_Permissions__c, GCS_Enabled__c from User where Id=: id Limit 1]; 
        List<User> ulist=[Select Additional_User_Permissions__c, GCS_Enabled__c from User where Id=: UserInfo.getUserId() Limit 1];
         System.debug('!!!userId: '+UserInfo.getUserId());
         System.debug('ulist'+ulist);
         if(ulist[0].Additional_User_Permissions__c !=null && ulist[0].Additional_User_Permissions__c.Contains('MCP Prospect Profiler')){
             validLicense = true;
              System.debug('!!!validLicense: '+validLicense);
         }
         if(isLead){        
            activeLead = isActiveLead(this.currentLead) && validLicense;
         }

         if (ulist[0].GCS_Enabled__c){
           value = Org_Constant_CS__c.getInstance('Eloqua_Profiler_GCS').Production_Value__c;
           System.debug('!!!value: '+value);
         } else {
            value = Org_Constant_CS__c.getInstance('Eloqua_Profiler_Global').Production_Value__c;
            
              // System.debug('!!!in Global');
              System.debug('!!!value: '+value);
         }

    }
    
    public Boolean isActiveLead(Lead l){
        Boolean isActive = false;
        
        if ( dateRangeCheck(l) && leadRecordTypeCheck(l) && l.Email != NULL &&
            (sfdcActiveLead(l) || ngccActiveLead(l))
            ){
            isActive = true;    
        }
            
        return isActive;
    }
    
    public Boolean dateRangeCheck(Lead l){
        Boolean value = l.CreatedDate > (System.Now() - 547) && l.CreatedDate.addMinutes(30) < System.Now();
        return value;
    }
    
    public Boolean leadRecordTypeCheck (Lead l){
        Boolean value = (
            l.RecordTypeId == Schema.Sobjecttype.Lead.getRecordTypeInfosByName().get('Prospect').getRecordTypeId() ||
            l.RecordTypeId == Schema.Sobjecttype.Lead.getRecordTypeInfosByName().get('Qualified Prospect').getRecordTypeId() ||
            l.RecordTypeId == Schema.Sobjecttype.Lead.getRecordTypeInfosByName().get('eLeads').getRecordTypeId() ||
            l.RecordTypeId == Schema.Sobjecttype.Lead.getRecordTypeInfosByName().get('Closed').getRecordTypeId() ||
            l.RecordTypeId == Schema.Sobjecttype.Lead.getRecordTypeInfosByName().get('Manual').getRecordTypeId()
            );
        return value;
    }
    
    public Boolean sfdcActiveLead(Lead l){
        Boolean value = 
              (l.Status == '2 Accepted-Mine/Channel' && l.Partner_Owned_Contact_Flag__c == false) ||
              ((l.Status == '1 Waiting' ||
              l.Status == '3.4 Rejected-Enterprise/Named' || l.Status == '3.7 Rejected-Not My Territory/Account' || l.Status == '3.1 Rejected-Invalid Contact' || l.Status == '3.2 Rejected-Already oppty' || 
              l.Status == '3.5 Rejected-Project Canceled' || l.Status == '3.6 Rejected-Lost to Competition' || l.Status == '3.8 Rejected-No Cisco Response(Admin Onl' || l.Status == '3.9 Rejected-No Customer Response' ||
              l.Status == '3.11 Rejected-Duplicate' || l.Status == '3.12 Rejected-No Valid Project') && l.Partner_Owned_Contact_Flag__c == false); 
        return value;
    }
    
    public Boolean ngccActiveLead(Lead l){
        Boolean value = (( l.Status =='New Prospect' ||  l.Status == 'Approval Pending' || l.Status == 'Approved' || l.Status == 'Picked for Routing' || l.Status == 'Marketing Qualified' || l.Status == 'Rejected' ||
                        l.Status == 'Send to Sales' || l.Status == 'Inactive' || l.Status == 'Rejected by Sales' || l.Status == 'Cancel' || l.Status == 'Marketing Unqualified')
                        && l.Partner_Owned_Contact_Flag__c == false);
        return value;
    }
    
    
}