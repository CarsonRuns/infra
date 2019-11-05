/*********************************************************************************************
Name    : NGCC_UpdateLeadContactInfo 
Author  : Bapu Rao Srigadde
Purpose : To update the contact information on Lead
Created Date: 06/12/2014
Modification History: 
Modified date: Added mobile field -Bapu
*********************************************************************************************/

global class NGCC_UpdateLeadContactInfo implements Database.Batchable<Sobject> 
{

 // SCAVA Helper Method
     public static Boolean flsGet(SObjectField field)
    {
        return field.getDescribe().isCreateable() ? true : false;
    }
    
    // SCAVA Helper Method to validate Update Access at field level
     public static Boolean flsUpdateGet(SObjectField field)
    {
        return field.getDescribe().isUpdateable() ? true : false;
    }

global Database.QueryLocator start(Database.BatchableContext BC) 
    {
    Profile objProfile = [select id, name from Profile where name =:'Cisco_NGCC'];
    set<Id> userId = new set<Id>();
    list<User> lstUser = [Select id, name,ProfileId from User Where ProfileId =: objProfile.Id ];
    
    for(User objUser : lstUser){
            userId.add(objUser.Id);
    }
    string strRecordTypeId = 
    Schema.Sobjecttype.Lead.getRecordTypeInfosByName().get('Prospect').getRecordTypeId();
 String StrQuery='Select id,name,Title,Phone,MobilePhone,Call_Permission__c,Contact_Department__c,Email, Preferred_Language__c,Company,Lead_Contact__c,Address_Line_1__c,'
     +'CustomCity__c,CustomState__c,CustomCountry__c,CustomZip__c, FirstName, LastName '
     +'from lead where Lead_Contact__c != null and RecordTypeId =:strRecordTypeId and LastModifiedById IN:userId and LastModifiedDate = TODAY AND HOUR_IN_DAY(LastModifiedDate) > 1';
    
    //Added condition to ensure that the batch job running in test will only process less than 200 records.  Current test classes for the NGCC are setup for seealldata=true
    //This is a temp fix.  Final fix is update the NGCC test classes as seealldata=false
    if( Test.isRunningTest() ){
        StrQuery += ' limit 180'; 
    }
        
   return Database.getQueryLocator(StrQuery);
    }
      
    global list<Contact> contactDetails(list<Lead> lstExactLead){
     list<Contact> lstContact = new list<Contact>();
     list<Contact> lstContact1 = new list<Contact>();
     Set<String> contactID = new Set<String>();
     map<id,lead> mapLead = new map<id,lead>();
     for(Lead objLead : lstExactLead){
      contactID.add(objLead.Lead_Contact__c);
      mapLead.put(objLead.Lead_Contact__c,objLead);
     }
     lstContact = [Select id,name,FirstName, LastName,Title,Phone, MobilePhone ,ContactPermissionCall__c,Email, Department,PreferredLanguage__c from Contact where id IN :contactID];
          //MailingAddress,OtherAddress
          system.debug('before==='+lstContact);
      for(Contact objContact : lstContact){
          Lead objLead = mapLead.get(objContact.Id);
          //SCAVA
          if(flsGet(Contact.FirstName)||flsUpdateGet(Contact.FirstName)){ 
          objContact.FirstName = objLead.FirstName;
          }
          if(flsGet(Contact.LastName)||flsUpdateGet(Contact.LastName)){ 
          objContact.LastName = objLead.LastName;  
          }
          if(flsGet(Contact.Email)||flsUpdateGet(Contact.Email)){ 
          objContact.Email = objLead.Email;
          }
          if(flsGet(Contact.Title)||flsUpdateGet(Contact.Title)){ 
          objContact.Title = objLead.Title;
          }
          if(flsGet(Contact.Department)||flsUpdateGet(Contact.Department)){ 
          objContact.Department = objLead.Contact_Department__c;
          }
          if(flsGet(Contact.Phone)||flsUpdateGet(Contact.Phone)){ 
          objContact.Phone = objLead.Phone;
          }
          if(flsGet(Contact.MobilePhone)||flsUpdateGet(Contact.MobilePhone)){ 
          objContact.MobilePhone = objLead.MobilePhone; 
          }
          if(flsGet(Contact.ContactPermissionCall__c)||flsUpdateGet(Contact.ContactPermissionCall__c)){ 
          objContact.ContactPermissionCall__c = objLead.Call_Permission__c;
          }
          if(flsGet(Contact.Email)||flsUpdateGet(Contact.Email)){ 
          objContact.Email = objLead.Email;
          }
          if(flsGet(Contact.PreferredLanguage__c)||flsUpdateGet(Contact.PreferredLanguage__c)){ 
          objContact.PreferredLanguage__c = objLead.Preferred_Language__c;
          }
          if(flsGet(Contact.MailingCity)||flsUpdateGet(Contact.MailingCity)){ 
          objContact.MailingCity = objLead.CustomCity__c;
          }
          if(flsGet(Contact.MailingCountry)||flsUpdateGet(Contact.MailingCountry)){ 
          objContact.MailingCountry = objLead.CustomCountry__c;
          }
          if(flsGet(Contact.MailingStreet)||flsUpdateGet(Contact.MailingStreet)){ 
          objContact.MailingStreet = objLead.Address_Line_1__c;
          }
          if(flsGet(Contact.MailingState)||flsUpdateGet(Contact.MailingState)){ 
          objContact.MailingState = objLead.CustomState__c;
          }
          if(flsGet(Contact.MailingPostalcode)||flsUpdateGet(Contact.MailingPostalcode)){ 
          objContact.MailingPostalcode = objLead.CustomZip__c;
          }//SCAVA
          lstContact1.add(objContact);
          
      }
     return lstContact1;
    }
    
    global void execute(Database.BatchableContext BC, list<sObject> scope)
    {
     try
  {
   list<Contact> leadContacts = new list<Contact>();
   list<Lead> lstLead = new list<Lead>();

   lstLead = (list<Lead>)scope;
      system.debug('**********************'+lstLead);
   leadContacts = contactDetails(lstLead);
   system.debug('leadContacts==='+leadContacts);
   update leadContacts;
   system.debug('leadContacts==='+leadContacts);
  }
  catch(Exception exc)
  {
   System.debug('***Exception in execute***'+ exc); 
  }
 }
      
    global void finish(Database.BatchableContext BC)
    {
     try
     {
         
     }
     catch(Exception exc)
     {
      System.debug('***Exception in finish'+exc); 
   }
 }
}