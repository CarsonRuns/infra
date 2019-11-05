/* 
* This class will hold all the commonly shared methods of the Partner 360 project.
*/
global class Partner360Utils { 

// partner status value for assigned partner    
public static final String PARTNER_STATUS_CLOSED = 'Closed';
public static final String PARTNER_STATUS_ASSIGNED_NEW = 'Assigned (New)';
public static final String PARTNER_STATUS_ACTIVELY_WORKING = 'Actively Working';
public static final String PARTNER_STATUS_REJECTED = 'Rejected';
public static final String PARTNER_STATUS_PARTNER_ASSIGNED= 'Partner Assigned';
public static final String PARTNER_STATUS_ASSIGNED_To_PSR= 'Assigned to PSR';
public static final String PARTNER_STATUS_EXPIRED= 'Expired';

// Partner Portal User Roles
public static final String PARTNER_PORTAL_USER_ROLE_ADMIN = 'Partner Executive';
public static final String PARTNER_PORTAL_USER_ROLE_PSR = 'Partner User';

// SFDC Role labels
public static final String SFDC_LABEL_PARTNER_ADMIN = 'Partner Admin';
public static final String SFDC_LABEL_PSR = 'Partner Sales Rep';

public static final String PARTNER_USER = 'PowerPartner';
    
public static final String PARTNER_STATUS_CLOSED_REASON_PEP_EXPIRED = 'Partner Program Enrollment expired.';    
public static final String PARTNER_ASSIGNMENT_DEACTIVATED_BY_TXM = 'Partner Assignment deactivated by TxM.';    
public static final String PARTNER_ASSIGNMENT_REJECT_ASSIGNMENT = 'Invalid Target Prospect assignment: Target Prospect previously rejected by Partner.';

public static final String LEAD_STATUS_ACCEPTED = '2 Accepted-Mine/Channel'; // Accepted picklist value
public static final String LEAD_PARTNER_STATUS_ASSIGNED = 'Partner Assigned'; //Partner Assigned Status picklist value
public static final String LEAD_PARTNER_STATUS_ACTIVELY_WORKING = 'Actively Working';
public static final String LEAD_PARTNER_STATUS_ASSIGNED_TO_PSR = 'Assigned To PSR';

// this static varible is created for sending only one email to Partner Admin
// for both Target Prospects and Lead Object
public static boolean isMailSkip=true;


// Skip variables to skip perticular trigger executions (e.g. twice execution on workflow field updates) // addded by Swapnil Kandekar
public static boolean skip_P360_AssignedPartnerSharing = false;
public static boolean skip_P360_AssignLeadSharing = false;
public static boolean skip_P360_Partner_Resharing_On_OwnerChange = false;
public static boolean skip_P360_Target_Prospect_BeforeUpdateInsert = false;
public static boolean skip_P360_TargetProspect_AfterUpdateInsert = false;


//Static variable to hold manual accountshares for account ownerchannge
Public Static List<AccountShare> AccountSharesToKeep ;

public static map<Id, List<UserRole>> mapAccountUserRoles = new map<Id, List<UserRole>>();

//private static final String adminRole = Utilities.getConstant_CS('Partner_Admin_Role');
//private static final String psrRole = Utilities.getConstant_CS('Partner_Sales_Rep_Role'); 

// Returns the Partner Admin role for Contact 
public static String getPartnerAdminRole()
{
    return Utilities.getConstant_CS('Partner_Admin_Role');    
}

// Returns the Partner Sales Rep role for Contact
public static String getPartnerSalesRepRole()
{  
    return Utilities.getConstant_CS('Partner_Sales_Rep_Role');       
}

    // Returns the role Id based on the whether the contact has the PA or the PSR role.
   // PA role is given precedence over here.
   public static Id getPortalUserRole(Contact c)
   {             
     List<UserRole> listRoles = new List<UserRole>();
     
     // check if the user roles are present in map for the specified account id
     if(mapAccountUserRoles.size() > 0)
     {
        // if the account is present in the map, get the roles from the map
        if(mapAccountUserRoles.containsKey(c.AccountId))
        {
            List<UserRole> listuserRoles = mapAccountUserRoles.get(c.AccountId);
            Boolean isAdmin = isPartnerAdmin(c.Partner_Admin_Roles__c);
            Boolean isPSR = isPSR(c.Partner_Admin_Roles__c);
            
            for(UserRole ur: listuserRoles)
            {
                if(isAdmin)
                {
                    if(ur.Name.contains('Exec'))
                        return ur.Id;
                }
                else if(isPSR)
                {
                    if(ur.Name.contains('User'))
                        return ur.Id;
                }
            }
            
         }
         
      }
       
        
      // if the roles map is empty or the accountid is not present, then add that accountid to the map   
      if(isPartnerAdmin(c.Partner_Admin_Roles__c))
         {
            listRoles = [Select Name, Id from UserRole where PortalAccountId = :c.AccountId and Name like '%Exec%' ];           
         } 
      else if(isPSR(c.Partner_Admin_Roles__c))
         {
            listRoles = [Select Name, Id from UserRole where PortalAccountId = :c.AccountId and Name like '%User%' ];        
         }
         
       if (listRoles.size() > 0)
       {
               mapAccountUserRoles.put(c.AccountId, listRoles);
               return listRoles[0].id;
       }
     
            
     return null;   
   }
  
    // is contact Role same as that of PSR
    public static boolean isPSR(String contactRole)
   {
      if (contactRole != null){
        if(contactRole.contains(getPartnerSalesRepRole()))
         return true;
      }
     
      return false;
   }
   
   // is contact Role same as that of PA
   public static boolean isPartnerAdmin(String contactRole)
   {
     if (contactRole != null){
        if(contactRole.contains(getPartnerAdminRole()))
         return true;
     }
     
     return false;      
   }
   
   /*
    * This method will remove the sharing of the assigned partner record, indicated by user id.
    */
    public static List<Assigned_Partner__Share> removeAssignPartnerSharingForUser(String userId)
    {
        String sharingReason = Schema.Assigned_Partner__Share.RowCause.Sharing_With_Partner__c;
        List<Assigned_Partner__Share> listToDelete = [Select a.id 
                                                        from Assigned_Partner__Share a 
                                                        where a.UserOrGroupId = :userId and a.RowCause=:sharingReason] ;
        return listToDelete;
    }
    
    /*
    * This method will remove the sharing of the end user account/customer account with the specified user
    */
    public static List<AccountShare> removeEndUserAcctSharingForUser(String userId)
    {
        // get all the manually shared records for the customer account
           List<AccountShare> listAccountShare = [Select a.Id 
                                                        from AccountShare a  
                                                        where a.UserOrGroupId = :userId
                                                        and a.RowCause = 'Manual' and a.AccountAccessLevel = 'Read'];
           return listAccountShare;
    }
    
     //Function to remove LeadSharing records
    public static List<LeadShare> removeRecSharing(String userId)
    {
        
        List<LeadShare> leadShareDelList = [Select Id 
                                                From LeadShare 
                                                Where UserOrGroupId = :userId
                                                AND RowCause = 'Manual']; 
        return leadShareDelList;
    }
    
   // function to generate a random numeric string of numbers of the specified length
   public static String generateRandomNumericString(Integer numOfCharachters)
   {
     return String.valueOf(Crypto.getRandomInteger()).substring(1,numOfCharachters);
   }
   
   public static Boolean isProduction()
   {
      String host = System.URL.getSalesforceBaseUrl().getHost();
      
      // split the host eg.cs1-api.salesforce.com
      String[] hostArray = host.split('\\.');
      if(!hostArray.isEmpty())
      {
        // the first item is the domain
        String sfdcInstance = hostArray[0];
        if(sfdcInstance.toLowerCase().contains('na')) 
        {
            return true;
        }  
        else
            return false;
      }
      return false;
   }
   
   public static String getSandboxName()
   {
      User u = [Select id, UserName from User where isActive=true and isPortalEnabled=false limit 1];
      
      String[] iArray =  u.Username.split('\\.');
      String instanceName = '.' + iArray[iArray.size()-1]; 
      
      // the value returned in production should be blank
      if (instanceName.contains('.com'))
        return '';
      else
        return instanceName;
      
   }
   
    public static List<Schema.PicklistEntry> getTargetArchitectureValues()
    {
        Schema.DescribeFieldResult fieldResult = Assigned_Partner__c.Target_Architecture__c.getDescribe();
        List<Schema.PicklistEntry> listTargetArchitecture = fieldResult.getPicklistValues();
        
        return listTargetArchitecture;              
    }
    
    public static String getTargetArchitectureForTestClass()
    {
        List<Schema.PicklistEntry> listArch = getTargetArchitectureValues();
        
        if(!listArch.isEmpty())
        {
            Schema.PicklistEntry f = listArch[0];
            return f.getValue();
        } else {
            return 'Any/All Technologies';
        }
            
    }
    
    /*
    * This method checks if the partner - customer combination is active in any other target prospect or lead record
    */
    public static boolean endUserAccountAssigned(Id partnerAccountId, Id customerAccountId, Id currentRecordId)
    {
        // check if the partner-customer combination is active in  target prospect.
        List<Assigned_Partner__c> listTargetProspects = [SELECT Id
                                                             FROM Assigned_Partner__c 
                                                             where Partner_Status__c != :Partner360Utils.PARTNER_STATUS_REJECTED 
                                                             and Assigned_Partner__c = :partnerAccountId 
                                                             and Customer_Account__c = :customerAccountId
                                                             and id != :currentRecordId];
                                                             
       if(!listTargetProspects.isEmpty())
            return true;
       else
        {
           List<Lead> listLeads = [select Id 
                                    from lead 
                                    where Channel_Partner__c = :partnerAccountId
                                    and End_Customer_Account__c = :customerAccountId
                                    and id != :currentRecordId
                                    and status = '2 Accepted-Mine/Channel'
                                    and Partner_Lead_Status__c in ('Partner Assigned','Assigned To PSR','Actively Working')];   
            
          if(!listLeads.isEmpty())
          {
            return true;
          }
        }
        
        return false;     
        
    }
    
    
   
    
  /*SHOULD BE REMOVED AS NOT USED ANYWHERE???  
    COMMENTED AS NOT BEING USED 
      
    // wrapper method to send the mail out to PAs when a target account is assigned to them.
    public static void sendTargetAssignmentMailToPA(Map<id, Id> mapMailRecords)
    {
        sendEmailwithTemplate2(mapMailRecords, '00XS0000000Dtbe');          
    }  
    
    public static void sendLeadAssignmentMailToPA(Map<id, Id> mapMailRecords)
    {
        sendEmailwithTemplate2(mapMailRecords, '00XS0000000Dtbj');
    }
    
    // Method to send out mails.
    // mapMailrecords - Map<Contact Id, LeadId or Assigned Partner Id>
    // templateId - email template Id
    private static void sendEmailwithTemplate2(Map<id, Id> mapMailRecords, String templateId)
    {
          
            Messaging.SingleEmailMessage[] mailArray = new List<Messaging.SingleEmailMessage>();
            Messaging.SingleEmailMessage mail;          
             
            for(Id contactId: mapMailRecords.keySet())
            {
                // get the what id; maybe lead or assigned partner record
                Id whatId = mapMailRecords.get(contactId);
                
                //New instance of a single email message
                mail = new Messaging.SingleEmailMessage();
                
                // The email template ID used for the email
                mail.setTemplateId(templateId);
                
                // Who you are sending the email to
                mail.setTargetObjectId(contactId);
                
                // Related to object used by the template
                mail.setWhatId(whatId); 
                
                mail.setBccSender(false);
                mail.setUseSignature(false);
                //mail.setReplyTo('recruiting@acme.com');
                mail.setSenderDisplayName('Cisco Partner Portal');
                mail.setSaveAsActivity(false); 
                   
                mailArray.add(mail);                
                
            }
            
            if(mailArray.size() > 0)
            {
                Messaging.sendEmail(mailArray);
            }
                
    }
    
  private static void sendEmailwithTemplate(List<Id> recipients, Id targetObjectId, String templateId)
    {
          Messaging.SingleEmailMessage[] mailArray = new List<Messaging.SingleEmailMessage>();
          Messaging.SingleEmailMessage mail;
          
          for(Id recipientId: recipients)
          {
                  //New instance of a single email message
                 mail = new Messaging.SingleEmailMessage();
                 
                  // Who you are sending the email to
                  mail.setTargetObjectId(recipientId);
                  
                  // The email template ID used for the email
                  mail.setTemplateId(templateId);
                  
                   mail.setWhatId(targetObjectId);    
                   mail.setBccSender(false);
                   mail.setUseSignature(false);
                   //mail.setReplyTo('recruiting@acme.com');
                   //mail.setSenderDisplayName('HR Recruiting');
                   mail.setSaveAsActivity(false); 
                   
                   mailArray.add(mail);                
                 
          }    
           
        if(mailArray.size() > 0)
        {
            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail });
        }   
         
                
    }
    
  */


}