/**************************************************************************************************
Name          : CIContactLookup_Ctrl
Author        : DSE CI Team
Purpose       : Used to identify the existing contact based on the query string parameter and redirect; If no contact found, redirect to new manual contact page.
Created Date  : 11/18/2016
Test Class    : CIContactLookup_Test
Modification History: 
    1.0 - DSE CI Release
    2.0 - DE12150 DSE Backlog - Null check for CI contact without email
**************************************************************************************************/

public class CIContactLookup_Ctrl{
    
    //Constructor Method
    public CIContactLookup_Ctrl (ApexPages.StandardController stdCT) {}
    
    //Invoked from DSE CI tile to identify the existing contact or redirect the user to new Contact creation with field data pre-populated.
    public PageReference lookupContact(){
        List<Contact> contactList = new List<Contact>();
        List<MSL_MODS_Contact__c> modsContactList = new List<MSL_MODS_Contact__c>();
        List <Account> accountNames = new List<Account>();
        
        PageReference contactLoopupURL = null;
        //Capture all the query string parameters from the URL
        String contact_name = ApexPages.currentPage().getParameters().get('contact_name');
        String email = ApexPages.currentPage().getParameters().get('email');
        String job_title = ApexPages.currentPage().getParameters().get('job_title');
        String person_party_id = ApexPages.currentPage().getParameters().get('person_party_id');
        String cr_party_id = ApexPages.currentPage().getParameters().get('cr_party_id');
        String decision_maker_type = ApexPages.currentPage().getParameters().get('decision_maker_type');        
        String firstName = '';
        String lastName = '';
        
        //Split the contact_name in to FirstName and LastName
        if(contact_name != null){
            firstName = contact_name.substringBefore(' ');
            lastName = contact_name.substringAfter(' ');
        }
        
        //Set decision maker to blank if not sent
        if (decision_maker_type == null || decision_maker_type == '' || decision_maker_type == 'undefined')
        {
            decision_maker_type = '';
        }
       
        if(person_party_id != null && person_party_id != '' && person_party_id != 'undefined'){
        modsContactList = [Select ID, MODS_Contact_ID__c from MSL_MODS_Contact__c  where MODS_Contact_ID__c =: Integer.valueOf(person_party_id)];
        }
        //DE12150 - Added null check for email to redirect user to new contact creation.
        if(email != ''){
            if(modsContactList.size() > 0){
                contactList = [Select ID from Contact where MODS_Contact_ID__c =: modsContactList[0].id AND Email =: email order by lastmodifieddate desc];   
            }   else {
                 contactList = [Select ID from Contact where Email =: email ];  
            }
        }
        
        if(contactList.size() > 0)
        {
            contactLoopupURL =  New PageReference( '/'+contactList[0].Id);
            contactLoopupURL.setRedirect(true);
           
        } 
        else {
            if (cr_party_id != 'None' && cr_party_id != null && cr_party_id != '' && cr_party_id != 'undefined'){
                accountNames = [select name from account where CSCSiteID__c =:cr_party_id];
                if (accountNames.size() > 0)
                contactLoopupURL =  New PageReference('/003/e?retURL=%2Fhome%2Fhome.jsp&RecordType=0123000000004aT&name_lastcon2='+lastName+'&name_firstcon2='+firstName+'&con5='+job_title+'&con15='+email+'&con4='+accountNames[0].name+'&00N30000000ggk5='+decision_maker_type);
                else
                contactLoopupURL =  New PageReference('/003/e?retURL=%2Fhome%2Fhome.jsp&RecordType=0123000000004aT&name_lastcon2='+lastName+'&name_firstcon2='+firstName+'&con5='+job_title+'&con15='+email+'&00N30000000ggk5='+decision_maker_type);

            } else 
            {
                contactLoopupURL =  New PageReference('/003/e?retURL=%2Fhome%2Fhome.jsp&RecordType=0123000000004aT&name_lastcon2='+lastName+'&name_firstcon2='+firstName+'&con5='+job_title+'&con15='+email+'&00N30000000ggk5='+decision_maker_type);
            }
        }
        return contactLoopupURL;
    }
}