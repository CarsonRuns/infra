public  without sharing class  P360_Custom_Lead_Conversion_CTE
{
    
    //Error messages
    Public Boolean ErrorOnLead{get;set;}
    Public String ErrorHead{get;set;}
    Public String ErrorContent{get;set;} 
    
    
    
    Public Boolean SendEmailToRecordOwner {get;set;}
    Public List<SelectOption> StatusOptions {get;set;}
    Public Boolean DoNotCreateOpportunity {get;set;}
    
    //Objects
    Public Lead Lead {get;set;} 
    Public Account AccountForOwnerField {get;set;}
    Public Contact Contact {get;set;}
    Public Opportunity Opportunity {get;set;} 
    Public String SBCAccountId {get;set;}
    
    public string callfunc{get;set;}


    
    //Constructor
    public P360_Custom_Lead_Conversion_CTE(ApexPages.StandardController controller) {
        String LeadId = ApexPages.currentPage().getParameters().get('Id');
        system.debug('current page360_Custom_Lead_Conversion: url'+ApexPages.currentPage().getUrl());
        
        //Get Account Id if page is been redireted to lead conversion from SBC after creating the account there.
        SBCAccountId = ApexPages.currentPage().getParameters().get('accountid');
        
        Lead = [select Id,Name,lastName,OwnerId,recordtype.name,Channel_Partner__c,Deal_ID__c,isConverted,
                Channel_Partner__r.Name,Company,Status,Email,End_Customer_Account__c,Program_Event_Name__c,Program_Name__c,ProgramEvent__c,Program_Event_Description__c from lead where Id = :LeadId];
        
        this.AccountForOwnerField = new Account();
        this.Contact = new Contact();
        this.Opportunity = new Opportunity(name = Lead.company + '-'  );
        
        //Autopopulate the account lookup with account created from SBC if any.
        if(SBCAccountId != null && SBCAccountId !='')
        {
            Lead.End_Customer_Account__c = SBCAccountId;
        }
        
        //if lead is not assigned to any End-User account then populate the account lookup with account having same name as lead company.
        else if(Lead.End_Customer_Account__c == null && Lead.company != null && Lead.company != '')
        {
            ObjectRecordTypeIds__c o = ObjectRecordTypeIds__c.getInstance();       
            String Account_End_User_RecordTypeId = o.Account_End_User_RecordTypeId__c;
            List<Account> ExistingAccounts = new list<Account>([Select id from account where name=:Lead.Company and 
                                                                RecordTypeId =:Account_End_User_RecordTypeId
                                                                order by LastModifiedDate DESC limit 1]);
            if(ExistingAccounts.size() >0)
                Lead.End_Customer_Account__c = ExistingAccounts[0].Id;      
        }
        
        /* If Lead Ownerid is user and Partner_Status__c is null then populate the lead ownerid as record owner lookup on conversion page,
else put logged in user as record owner lookup on conversion page.*/
        
        String OwnerId = Lead.OwnerId;
        if(OwnerId.startsWith('005'))
            AccountForOwnerField.OwnerId = Lead.OwnerId;
        else
            AccountForOwnerField.OwnerId =  UserInfo.getUserId();
        
        /*Converted status values differ with record type according to their processes.
        so those mapping are stored in custom settings.*/
        
        StatusOptions = new List<SelectOption>();
        for(String s : LeadConvertedStatusValues__c.getInstance(Lead.recordtype.name).StatusValues__c.split(';'))
        {
            StatusOptions.add(new SelectOption(s,s));
        }        
        ErrorOnLead = false;
        ValidateLeadRecord();                     
    }
    
    /*Lead Conversion is not allowed when
    1. Deal Id present on lead,this happens when partner converts lead to deal in CCW or other systems.
    2. If lead is assigned to partner. This case partner supposed to convert the lead, internal users are not allowed to do so.
    3. For Some set of profiles, user should have additional user permission to convert the lead.
    */
    
    Public void ValidateLeadRecord()
    {
        system.debug('Deal id is'+Lead.Deal_ID__c);
        if(Lead.Deal_ID__c!= null || Lead.isConverted)
        {
            system.debug('lead conversion'+Lead.isConverted +'lead deal'+Lead.Deal_ID__c);
            ErrorOnLead = true;
            ErrorHead = 'Converted Lead.';
            ErrorContent = 'Lead is already converted. ';    
        }
        
        else if(Lead.Channel_Partner__c!= null)
        {
            ErrorOnLead = true;
            ErrorHead = 'Lead is assigned to partner. ';
            ErrorContent = 'Lead is assigned and visible to Partner - '+ Lead.Channel_Partner__r.Name+ ' and only the Partner can convert the lead.';
        }
        else
        {
            String ProfileIds = Utilities.getOrgConstant('ProfileIDTest');
            String UserProfileId = UserInfo.getProfileId().substring(0,15);
            System.debug(ProfileIds);
            System.debug(UserProfileId);
            if(ProfileIds.contains(UserProfileId) && !Utilities.checkAdditionalUserPermission('Enable Lead Conversion'))
            {
                ErrorOnLead = true;
                ErrorHead = 'Insufficient Privileges.';
                ErrorContent = 'You do not have the level of access necessary to Convert Lead. ';
            }
        }
    }
    
    
    // Redirect to account create from Create Account button, Account create s-control will redirect to SBC.
    Public pagereference LaunchSBC()
    {
        String redirectURL = '/001/e?RecordType=0123000000004aU&ent=Account';
        pageReference ref = new pagereference(redirectURL +'&leadId=' +Lead.Id);
        return ref ;
    }
    
    public pageReference Convert(){
        //Check again if lead is converted to Deal in the meantime, if yes throw error.
        Lead l = [Select Deal_Id__c,isConverted from lead where id =:Lead.Id];
        if((l.Deal_Id__c != null && l.Deal_Id__c != '') || Lead.isConverted)
        {
            system.debug('Deal id'+l.Deal_Id__c+'lead conversion'+Lead.isConverted);
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Lead is already converted.')); 
            return null;
        }
        else
        {
            /*
            Check if there is already a contact on selected account with same last name,email id,
            if yes then assign lead conversion to the same contact. 
            */
            List<Contact> ExistingContacts = new List<Contact>([Select DuplicatePrevention__c,accountId,Program_Event_Name__c,Program_Event_Description__c,Program_Event_Code__c,Program_Name__c from Contact where
                                                                accountid =:Lead.End_Customer_Account__c and
                                                                email =:Lead.Email and LastName =:Lead.LastName]);
            System.Debug('ExistingContacts');
            System.Debug(ExistingContacts);
            if(ExistingContacts.size()>0)
            {
                Contact = ExistingContacts[0];          
            }
            /*
            Convert lead and redirect user to opportunity involved in lead conversion in edit mode.
            if opportunity is not created redirect to account in involved in lead conversion.
            */
            String returnId = convertLeadToAcctOpptyContact(Lead.Id,Lead.End_Customer_Account__c,Contact.Id,Opportunity.name,
                                                            AccountForOwnerField.OwnerId,DoNotCreateOpportunity,
                                                            SendEmailToRecordOwner,null,Lead.status);
            system.debug('returnId is'+returnId);
            if(returnId == null)
                return null;
            else if(DoNotCreateOpportunity == True){
                pageReference ref = new pagereference('/' + returnId);
                return ref ;
            }
            else{
                /*****
                    Modified by Pradeep Adla: opportunity edit form is not opening in Lightnigng Console due to URL mismatch. 
                    So we are using diffrent URL for different UI
                *****/
                //To find the user in which UI
                String uiTheme = UserInfo.getUiTheme();
                //If the user in either "Lightning" or "Lightning Console" 
                if( uiTheme == 'Theme4d' || uiTheme == 'Theme4u' ) {
                      pagereference ref = new pagereference('/lightning/r/Opportunity/'+returnId+'/edit');
                    return ref;
                }
                //If the user in "Classic" 
                else{
                    pageReference  ref = new pagereference('/' + returnId + '/e?retURL=' + returnId); 
                    return ref;
                }
            }
        }
    }
    
    //Convert Lead with DataBase Method Lead Convert.
    public String convertLeadToAcctOpptyContact(Id LeadId,Id AccountId,Id ContactId,String OpportunityName,Id OwnerId,
                                                Boolean DoNotCreateOpportunity,Boolean EmailNotification,
                                                Boolean OverwriteSource,String ConvertedStatus)
    {
        
        Database.LeadConvert lc = new database.LeadConvert();
        lc.setLeadId(LeadId);
        if(AccountId!=Null)
        {
            lc.setAccountId(AccountId);
        }
        if(ContactId!=Null)
        {
            lc.setContactId(ContactId);
        }
        if(OwnerId!=Null)
        {
            lc.setOwnerId(OwnerId);
        }
        if(DoNotCreateOpportunity!=Null)
        {
            lc.setDoNotCreateOpportunity(DoNotCreateOpportunity);
            if(DoNotCreateOpportunity==false)
            {
                lc.setOpportunityName(OpportunityName);
            }
        }
        if(OverwriteSource!=Null)
        {
            lc.setOverwriteLeadSource(OverwriteSource);
        }
        if(EmailNotification!=Null)
        {
            lc.setSendNotificationEmail(EmailNotification);
        }
        lc.setConvertedStatus(ConvertedStatus);
        Savepoint sp = Database.setSavepoint();
        try
        {        
            Lead.Lead_Closed_Date__c = System.now();
            Lead.Opportunity_Owner_AM__c = OwnerId;
            Update Lead;
            Database.LeadConvertResult lcr  = Database.convertLead(lc);    
            System.debug('Contact ID*** '+lcr.getContactId());
            if(lcr.isSuccess()){
               Contact cnt =[Select accountId,Program_Event_Name__c,Program_Event_Description__c,Program_Event_Code__c,Program_Name__c from Contact where
                                                                Id=:lcr.getContactId()];
                cnt.Program_Event_Name__c=Lead.Program_Event_Name__c;
                cnt.Program_Name__c =Lead.Program_Name__c;
                cnt.Program_Event_Code__c =Lead.ProgramEvent__c;
                cnt.Program_Event_Description__c =Lead.Program_Event_Description__c;
              Update cnt;
            }
            
            if(DoNotCreateOpportunity == True)
                return lcr.getAccountId(); 
            else
                return lcr.getOpportunityId();     
        }
        catch (Exception e)
        {
            Database.rollback(sp);
            ApexPages.addMessages(e);        
            return null;
        }
    }   
}