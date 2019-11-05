//** Class to process errors occured during user onboarding**/
//** Author:     Mukesh JSC Team
//** Date:       02/15/2013
// ************************ Change History Start ************************
// 04/28/2016 Added the null check for P360_ReassignLeadsandTPsonDeactivedUser() in finish() method.
// 05/13/2016 Fixed the error tracking for batch flow with specific list for Tx_log__c using usertoUpdateError.
// 05/26/2016 Fixed the user default locale issue Line# 230, 249
// ************************ Change History End ************************

global class P360_PartnerPortalUserOnboardingRedesign implements Database.Batchable<sObject>, Database.Stateful  {  

// SCAVA Helper Method to validate Update Access at field level
     public static Boolean flsUpdate(SObjectField field)
    {
        return field.getDescribe().isUpdateable() ? true : false;
    }
    
// SCAVA Helper Method to validate Create Access at field level
     public static Boolean flsGet(SObjectField field)
    {
        return field.getDescribe().isCreateable() ? true : false;
    }

    global List<Tx_Log__c> txLogs=new List<Tx_Log__c>();                            //Store list of Errors to be Stored in Tx Logs
    global boolean runFromTest = false;                                             //Variable for Run Test
    global Set<String> SetOfContact=new Set<String>();                              //Set of Contact Created for Run Test
    global final String   USERNAME_TAG = '@cisco.com.sales';                        //String to be appended to Username
    global final String instanceName = Partner360Utils.getSandboxName();            // instance name ie. INT, TEST etc 
    global final Map<String, String> mapAllLocales = new Map<String, String>();
    static final Map<String, String> mapAllLocales = new Map<String, String>();
    global static boolean inFutureContext = false;    
    global Set<Id> SetOfInactiveUser=new Set<Id>();
    
    global Database.QueryLocator start(Database.BatchableContext BC){
        String query = '';
        if(runFromTest == false){
            query = Label.P360_Contact_Scheduler_Query_String;                      //Normal Batch Query
        }
        else
        {
            query = Label.P360_Contact_Scheduler_Query_String + ' AND ID IN : SetOfContact';  // For Test Run
        }         
        system.debug(query);
        return Database.getQueryLocator(query);  
    } 

    global void execute(Database.BatchableContext BC, List<sObject> scope){     
        try
        {   
            List<User> newUserInsert=new List<User>();                                      //List of Users to be Inserted
            List<User> lstUserToUpdate=new List<User>();                                    //List of Users to be Updated
            List<User> usrExecRoleUpdate=new List<User>();                                  //List of Users for which Role need to be Updated            
            Map<Id, Contact > mapIdContact= new Map<Id, Contact>();                        // Map key = contactId, Map value = Contact sObject            
            Set<Id> newUserExecRoleUpdate= new Set<Id>();                                   //Set of Newly Created User whose Role need to be updated to Executive
            Set<Id> setAccountToProcess=new Set<Id>();                                      //Set of Account which are enabled from PPE during the transaction
            Set<Id> setAccountforNewUsr=new Set<Id>();                                     //Set of Account for which initiatly the Executive Role was not Created
            Database.DMLOptions dmo = new Database.DMLOptions();                
            dmo.EmailHeader.triggerUserEmail = false;
            
            for(Contact c : (List<Contact>) scope)
            {
                mapIdContact.put(c.Id, c);                                                  //Collect Scoped Contact
                setAccountToProcess.add(c.AccountId);                               
            }
            
            Map<String,Id> usrRoleId=getUserRole(setAccountToProcess);                      //Fetcg User Role for Collected Contacts Accounts       
            for(User objExistingUser : [Select u.Id,u.UserName,u.FirstName,u.LastName,u.Email,u.UserRoleId,
                                u.ProfileId,u.ContactId,u.AccountId,u.IsActive,u.Theatre__c
                                from User u 
                                where ContactId IN :mapIdContact.KeySet()])
            {
                if(objExistingUser != Null)
                {
                    //SCAVA FIX
                    if(flsUpdate(User.Email))
                    {
                    objExistingUser.Email = mapIdContact.get(objExistingUser.ContactId).Email + instanceName;
                    }
                    if(flsUpdate(User.UserName))
                    {
                    objExistingUser.UserName = getUserName(mapIdContact.get(objExistingUser.ContactId));
                    }
                    if(flsUpdate(User.languagelocalekey))
                    {
                    objExistingUser.languagelocalekey = mapIdContact.get(objExistingUser.ContactId).Pref_Language__c;
                    }
                    if(flsUpdate(User.FirstName))
                    {
                    objExistingUser.FirstName = mapIdContact.get(objExistingUser.ContactId).FirstName;
                    }
                    if(flsUpdate(User.LastName))
                    {
                    objExistingUser.LastName = mapIdContact.get(objExistingUser.ContactId).LastName;
                    }
                    if(flsUpdate(User.Theatre__c))
                    {
                    objExistingUser.Theatre__c = mapIdContact.get(objExistingUser.ContactId).UserTheatre1__c;
                    }
                    if(flsUpdate(User.City))
                    {
                    objExistingUser.City = mapIdContact.get(objExistingUser.ContactId).MailingCity;
                    }
                    if(flsUpdate(User.Country))
                    {
                    objExistingUser.Country = mapIdContact.get(objExistingUser.ContactId).MailingCountry;
                    }
                    if(flsUpdate(User.State))
                    {
                    objExistingUser.State = mapIdContact.get(objExistingUser.ContactId).MailingState;
                    }
                    if(flsUpdate(User.Street))
                    {
                    objExistingUser.Street = mapIdContact.get(objExistingUser.ContactId).MailingStreet;
                    }
                    if(flsUpdate(User.PostalCode))
                    {
                    objExistingUser.PostalCode = mapIdContact.get(objExistingUser.ContactId).MailingPostalCode;
                    }
                    objExistingUser.setOptions(dmo);                    
                    
                    Boolean newStatus;
                    if(mapIdContact.get(objExistingUser.ContactId).ContactStatus__c == 'Active')
                        {newStatus = True;}
                    else
                        {newStatus = False;}
                                       
                    if(newStatus == False || mapIdContact.get(objExistingUser.ContactId).PA_Role__c=='Normal' || 
                        mapIdContact.get(objExistingUser.ContactId).PA_Role__c==Null || 
                        mapIdContact.get(objExistingUser.ContactId).Account.Partner_Assignment_Eligible__c != 1)
                    {
                        //SCAVA FIX
                        if(flsUpdate(User.IsActive))
                        {
                        objExistingUser.IsActive = False;
                        }
                        SetOfInactiveUser.add(objExistingUser.Id);
                        System.debug('If objExistingUser.IsActive'+  objExistingUser.IsActive); 
                    }                         
                    else
                    {
                        //SCAVA FIX
                        if(flsUpdate(User.UserRoleId))
                        {
                        objExistingUser.UserRoleId = usrRoleId.get(mapIdContact.get(objExistingUser.ContactId).PA_Role__c + mapIdContact.get(objExistingUser.ContactId).AccountId);    
                        }
                        //SCAVA FIX
                        if(flsUpdate(User.IsActive))
                        {
                        objExistingUser.IsActive = True;
                        }
                    }
                    
                    lstUserToUpdate.add(objExistingUser);
                    mapIdContact.remove(objExistingUser.ContactId);                             //removes the updating user from list of processing records
                    
                    System.debug('Print User'+lstUserToUpdate);
                }
            }
        
            if(!lstUserToUpdate.isEmpty()){
                inFutureContext = true;
                Database.SaveResult[] updateResult = Database.update(lstUserToUpdate,false);    //Commiting the updates to the database
                List<Tx_Log__c> usertoUpdateError = P360_ErrorHandlingCls.getErrorStatus(lstUserToUpdate,updateResult);    //Sending Update Result for processing and track any error which has occured
                if(!usertoUpdateError.isEmpty()){
                    txLogs.addAll(usertoUpdateError);              
                    //Sending Insert Result for processing and track any error which has occured
                }
            }           
    
            //Process all Contacts whose crossponding users doesnt exist
            if(!mapIdContact.isEmpty())
            {
            system.debug('<<Entering');
                for(Contact objCon: mapIdContact.Values())
                {
                   system.debug('<<Entering into for loop');
                    if(objCon.PA_Role__c != 'Normal' && objCon.PA_Role__c != Null){
                        system.debug('Users to Create for'+objCon);
                        User usrnew=new User();//Initiating new record of User for each Contact
                            //SCAVA FIX
                            if(flsGet(User.firstname))
                            {
                            usrnew.firstname = objCon.FirstName;
                            }
                            if(flsGet(User.lastname))
                            {
                            usrnew.lastname = objCon.LastName;
                            }
                            
                            //fix for contact name
                            if(objCon.Lastname.length() > 3)
                            {
                                //SCAVA FIX
                                if(flsGet(User.alias))
                                {
                                usrnew.alias = objCon.FirstName.substring(0,2)+objCon.Lastname.substring(0,3);
                                }
                            }
                            else
                            {
                                usrnew.alias = objCon.FirstName.substring(0,2)+objCon.Lastname;
                            }
                            //SCAVA FIX
                            if(flsGet(User.CommunityNickname))
                            {
                            usrnew.CommunityNickname = objCon.FirstName + Partner360Utils.generateRandomNumericString(6); 
                            }
                            if(flsGet(User.languagelocalekey))
                            {
                            usrnew.languagelocalekey = objCon.Pref_Language__c;
                            }
                            if(flsGet(User.localesidkey))
                            {
                            usrnew.localesidkey = getUserLocaleInfo(objCon.MailingCountry, objCon.PreferredLanguage__c);
                            }
                            if(flsGet(User.timezonesidkey))
                            {
                            usrnew.timezonesidkey ='America/Los_Angeles';
                            }
                            if(flsGet(User.username))
                            {
                            usrnew.username=getUserName(objCon);
                            }
                            if(flsGet(User.email))
                            {
                            usrnew.email=objCon.email + instanceName;
                            }
                            if(flsGet(User.EmailEncodingKey))
                            {
                            usrnew.EmailEncodingKey='UTF-8';
                            }
                            //Checking if the Role already exist if not adding in a separate set for later update of Role if contact is App Admin
                        if(usrRoleId.containsKey(objCon.PA_Role__c + objCon.AccountId))
                        {
                            // SCAVA Fix
                            if(flsGet(User.UserRoleId))
                            {
                            usrnew.UserRoleId= usrRoleId.get(objCon.PA_Role__c +objCon.AccountId);
                            }
                        }else if(objCon.PA_Role__c=='Executive')
                        {
                            newUserExecRoleUpdate.add(objCon.Id); //Set of Contact Id for which Executive Role doesnt exist,by default user will be created with User Role
                            setAccountforNewUsr.add(objCon.AccountId);
                        }
                            // SCAVA Fix
                            if(flsGet(User.profileid))
                            {
                            usrnew.profileid = getP360PortalProfile();
                            }
                            if(flsGet(User.contactId))
                            {
                            usrnew.contactId = objCon.Id;
                            }
                            if(flsGet(User.City))
                            {
                            usrnew.City = objCon.MailingCity;
                            }
                            if(flsGet(User.Country))
                            {
                            usrnew.Country = objCon.MailingCountry;
                            }
                            if(flsGet(User.State))
                            {
                            usrnew.State = objCon.MailingState;
                            }
                            if(flsGet(User.Street))
                            {
                            usrnew.Street = objCon.MailingStreet;
                            }
                            if(flsGet(User.PostalCode))
                            {
                            usrnew.PostalCode = objCon.MailingPostalCode;
                            }
                           // usrnew.jsclean_ext__js_lead_import__c = true;
                            if(flsGet(User.Theatre__c))
                            {
                            usrnew.Theatre__c = objCon.UserTheatre1__c;
                            }
                            usrnew.setOptions(dmo);
                            newUserInsert.add(usrnew);   
                    }
                }
                system.debug('newUserInsert>>>'+newUserInsert);
                if(!newUserInsert.isEmpty()){  
                system.debug('<<Entering');                 
                    Database.SaveResult[] insertResult = Database.insert(newUserInsert,false);      //Inserting new records to the database
                    List<Tx_Log__c> insertError = P360_ErrorHandlingCls.getErrorStatus(newUserInsert,insertResult);
                    if(!insertError.isEmpty()){
                        txLogs.addAll(insertError);                                                 //Sending Insert Result for processing and track any error which has occured
                    }
                }
               
                Map<String,Id> usrRoleUpdateId=getUserRole(setAccountforNewUsr);
                
                if(!newUserExecRoleUpdate.isEmpty())
                {    
                    for(User uObj:[Select Id,UserRoleId,Username,ContactId,AccountId from User where ContactId IN : newUserExecRoleUpdate])
                    {
                        If(newUserExecRoleUpdate.contains(uObj.ContactId))
                        {
                            //SCAVA FIX
                            if(flsUpdate(User.UserRoleId))
                            {
                            uObj.UserRoleId=usrRoleUpdateId.get('Executive' + uObj.AccountId);
                            }
                            usrExecRoleUpdate.add(uObj);
                        }
                    }
                    
                    if(!usrExecRoleUpdate.isEmpty()){
                        inFutureContext = true;
                        Database.SaveResult[] usrUpdateResult = Database.update(usrExecRoleUpdate,false);
                        List<Tx_Log__c> updateRoleError = P360_ErrorHandlingCls.getErrorStatus(usrExecRoleUpdate,usrUpdateResult);                    
                        if(!updateRoleError.isEmpty()){
                            txLogs.addAll(updateRoleError);
                        }
                    }
                }
            }
    
        }
        Catch(Exception e)
        {
            Tx_Log__c tlObj = new Tx_Log__c();
            // SCAVA Fix
            if(flsGet(Tx_Log__c.exception__c))
            {
            tlObj.exception__c = true;
            }
            if(flsGet(Tx_Log__c.message__c))
            {
            tlObj.message__c = e.getMessage();
            }
            if(flsGet(Tx_Log__c.originated__c))
            {
            tlObj.originated__c = 'P360_PartnerPortalUserOnboarding_v2';
            }
            if(flsGet(Tx_Log__c.type__c))
            {
            tlObj.type__c = 'P360_PartnerUserOnboarding';
            }
            Database.SaveResult logInsertResult = Database.insert(tlObj,false);
            system.debug('logInsertResult'+logInsertResult);
        }
    }
    
   global void finish(Database.BatchableContext BC){
        system.debug('txLogs'+txLogs);
        inFutureContext = false;
        if(!SetOfInactiveUser.isEmpty()){            
            P360_ReassignLeadsandTPsonDeactivedUser.ReassignLeadsandTPsDirect(SetOfInactiveUser);
        }       
        insert txLogs;
    }
   
    //Gettings roles of accounts
    public static Map<String,Id> getUserRole(Set<Id> setAccId)
    {
        Map<String,Id> usrRoleId=new Map<String,Id>();
        for(UserRole lstRole : [Select PortalType,PortalRole, PortalAccountId ,Id From UserRole where PortalAccountId = :setAccId And PortalType='Partner'])
            {
                usrRoleId.put(lstRole.PortalRole+lstRole.PortalAccountId,lstRole.Id);
            }
        return usrRoleId;
    }


    public static String getUserLocaleInfo(String contactCountry, String language)
    {
        // if nothing matches, this will be returned as the default locale
        String default_locale = 'en_US';
        
        if(mapAllLocales.isEmpty())
            getAllLocales();
      
        //loop and check using all country values
        for(String s: mapAllLocales.keySet())
        {       
            if(contactCountry !=null && s.toLowerCase().equals(contactCountry.toLowerCase()))
            {
                return mapAllLocales.get(s);
            }
        }         
      
      //loop and check using all language values  
        for(String s: mapAllLocales.keySet())
        {  
            if(language != null && s.toLowerCase().equals(language.toLowerCase()))
                return mapAllLocales.get(s);       
        }
        
    return default_locale;    
    }
   
    // creates a map of all locales available in the User locale drowpdown
    public static Map<String, String> getAllLocales()
    {
        if (mapAllLocales.isEmpty())
        {
            Schema.DescribeFieldResult fieldResult = User.LocaleSidKey.getDescribe();
            List<Schema.PicklistEntry> listLocales = fieldResult.getPicklistValues(); 
            for(Schema.PicklistEntry f: listLocales)
            {               
                mapAllLocales.put(f.getLabel(), f.getValue());
            }
        }
    
    return mapAllLocales;
    }

    public static String getP360PortalProfile()
    {
        return Utilities.getConstant_CS('P360_Portal_Profile');     
    }
    
    public String getUserName(Contact c)
    {
        String userName;
        if(c.CCO_ID__c != null)
        {
            String ccoId = c.CCO_ID__c;
            String[] ccoIdArray = c.CCO_ID__c.split(',');       
            if(ccoIdArray.size() > 0)
                ccoId = ccoIdArray[0];
            
            userName = ccoId + USERNAME_TAG;      
        } 
        else
        {
            userName = c.email;      
            userName = userName  +  USERNAME_TAG;  
         }  
        
        userName = userName + instanceName;
    return userName;
    }
}