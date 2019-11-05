global class AccountSearch {

    WebService static String sitelookup(String cscid,String ownerid) {
        //return sitelookupWDummy(cscid, ownerid, false);
        //SCAVA FIX
        if(cscid!=null && cscid!='')
        cscid = String.escapeSingleQuotes(cscid);
        
        if(ownerid!=null && ownerid!='')
        ownerid = String.escapeSingleQuotes(ownerid);
        
        return sitelookupWDummy(cscid, ownerid, false);        
    }
        
    WebService static String sitelookupWDummy(String cscid,String ownerid, Boolean allowDummyOwner) {
            
        String oid = ownerid + '@cisco.com%';  
        String idout = '';
        String dummyString = 'and Owner.Dummy_User__c = false ';
        // Creating new 'dummyStringVelocity' to handle Vlocity Users check
        String dummyStringVelocity = 'and Owner.Dummy_User__c = true and Owner.Name like \'%Velocity%\'';
        
        /* Check for mandatory fields */
        if(cscid == '' || cscid == null || ownerid =='' || ownerid == null) {
            throw new CustomException('CSCSiteId/OwnerId can not be null');
        }

        /* Is dummy owner OK? */
        if (allowDummyOwner) {
            dummyString = '';
        }
        
        /* Fetch accounts based on CSC Site ID */
      //String q = 'select Id From Account WHERE CSCSiteID__c =\''+cscid+'\' and RecordType.name = \'End-User\' '+ dummyString+'limit 2';
      //SCAVA FIX  
        String q = 'select Id From Account WHERE CSCSiteID__c =\''+String.escapeSingleQuotes(cscid)+'\' and RecordType.name = \'End-User\' '+ dummyString+'limit 2';
        
        Account[] acct = (List<Account>)Database.query(q);
        //Account[] acct = [select Id From Account WHERE CSCSiteID__c = :cscid and Owner.Dummy_User__c = false and RecordType.name = 'End-User' limit 2];
         system.debug('acct>>'+acct);
         // Checking whether the user is 'VELOCITY' user or not
         
        if (acct.size()== 0) {
           //String q1 = 'select Id From Account WHERE CSCSiteID__c =\''+cscid+'\' and RecordType.name = \'End-User\' '+ dummyStringVelocity +'limit 2';
           //SCAVA FIX
            String q1 = 'select Id From Account WHERE CSCSiteID__c =\''+String.escapeSingleQuotes(cscid)+'\' and RecordType.name = \'End-User\' '+ dummyStringVelocity +'limit 2';
            acct = (List<Account>)Database.query(q1);
        }
         
        if (acct.size()== 1) {
            idout = '<CSCSearchResult><Type>Site</Type><CSCID>'+cscid+'</CSCID><SFDCID>'+acct[0].Id+'</SFDCID><ErrorMsg></ErrorMsg></CSCSearchResult>'; 
        }
        else if (acct.size() > 1) {
            //String q2 = 'select Id From Account WHERE CSCSiteID__c =\''+cscid+'\' and Owner.Username like \''+oid+'\' and RecordType.name = \'End-User\' '+ dummyString+'order by LastmodifiedDate desc Limit 1';
            //SCAVA FIX
            String q2 = 'select Id From Account WHERE CSCSiteID__c =\''+String.escapeSingleQuotes(cscid)+'\' and Owner.Username like \''+String.escapeSingleQuotes(oid)+'\' and RecordType.name = \'End-User\' '+ dummyString+'order by LastmodifiedDate desc Limit 1';
            Account[] getname = (List<Account>)Database.query(q2);
            //Account[] getname = [select Id from Account where CSCSiteID__c = :cscid and Owner.Username like :oid and Owner.Dummy_User__c = false and RecordType.name = 'End-User' order by LastmodifiedDate desc Limit 1];
                    
            if (getname.size()== 1) {
                idout = '<CSCSearchResult><Type>Site</Type><CSCID>'+cscid+'</CSCID><SFDCID>'+getname[0].Id+'</SFDCID><ErrorMsg></ErrorMsg></CSCSearchResult>';
            }
            else {
              //String q3 = 'select Id From Account WHERE CSCSiteID__c =\''+cscid+'\' and RecordType.name = \'End-User\' '+ dummyString+'order by LastmodifiedDate desc Limit 1';
              //SCAVA FIX
                String q3 = 'select Id From Account WHERE CSCSiteID__c =\''+String.escapeSingleQuotes(cscid)+'\' and RecordType.name = \'End-User\' '+ dummyString+'order by LastmodifiedDate desc Limit 1';
                Account[] noowner = (List<Account>)Database.query(q3);
                //Account[] noowner= [select Id from Account where CSCSiteID__c = :cscid  and Owner.Dummy_User__c = false and RecordType.name = 'End-User' order by LastModifiedDate desc limit 1];
                idout = '<CSCSearchResult><Type>Site</Type><CSCID>'+cscid+'</CSCID><SFDCID>'+noowner[0].Id+'</SFDCID><ErrorMsg></ErrorMsg></CSCSearchResult>'; 
            }
        }
        else if(acct.size()<1) {
            String errmsg = 'Given CSCSiteId does not exist in SFDC OR Owner must be a dummy user.';
            idout = '<CSCSearchResult><Type>Site</Type><CSCID>'+cscid+'</CSCID><SFDCID></SFDCID><ErrorMsg>'+errmsg+'</ErrorMsg></CSCSearchResult>';
        }
        return idout;
    }
  
    WebService static String CompanyLookup(String inputXML, String ownerid) {
      //return CompanyLookupCreate(inputXML,ownerid,false,'');
      //SCAVA FIX
        if(inputXML!=null && inputXML!='')
        inputXML = String.escapeSingleQuotes(inputXML);
        
        if(ownerid!=null && ownerid!='')
        ownerid = String.escapeSingleQuotes(ownerid);        
        
        return CompanyLookupCreate(inputXML,ownerid,false,'');
    }
     
    WebService static String CompanyLookupCreate(String inputXML, String ownerid, Boolean allowDummyOwner, String altOwnerid) {
    
      //XmlStreamReader reader = new XmlStreamReader(inputXML);
      //SCAVA FIX
        XmlStreamReader reader = new XmlStreamReader(string.escapeSingleQuotes(inputXML));
        reader.setCoalescing(true);

        String key='';
        String val='';
        String addrLine1='';
        String addrLine1_eng='';
        String addrLine2='';
        String addrLine2_eng='';
        String companyID='';
        String siteID='';
        String city='';
        String city_eng='';
        String state='';
        String state_eng='';
        String country='';
        String country_eng='';
        String name='';
        String token='';
        String postalCode='';
        String postalCode_eng='';
        String xyz = '';
        String aid = '';
        String compid = '';
        Boolean cscidfound = true;
        List<String> ctidList = new List<String>(); //cm-12222008 - used to keep track of the CTIDs
        String dummyString = 'and Owner.Dummy_User__c = false ';
        String dummyString2 = 'and Dummy_User__c = false ';
        // Creating new 'dummyStringVelocity' to handle Vlocity Users check
        String dummyStringVelocity = 'and Owner.Dummy_User__c = true and Owner.Name like \'%Velocity%\'';
        
        /* Is dummy owner OK? */
        if (allowDummyOwner) {
            dummyString = '';
            dummyString2 = '';
            if (altOwnerid != '') {
                altOwnerid +='@cisco.com%';
            }
        }
 
        /* Parse the input XML */
        while (reader.hasNext()) {
            if (reader.getEventType() == XmlTag.END_ELEMENT) {
            //Do nothing
            }
            else if (reader.getEventType() == XmlTag.START_ELEMENT) {
                val = '';
                key = reader.getLocalName();
            }
            else if (reader.getEventType() == XmlTag.CHARACTERS) {
                val = reader.getText();
        
        
/*cm-12222008 - Can't do this here anymore since we need to add country to the search and it DNE until the end
               if (key == 'CSCID' && val != '' && cscidfound){ 
                    compid = val;
                    Account[] acct =  [select Id,CSCID__c from Account where CSCID__c = :compid limit 1];
                        if (acct.size() > 0)
                             {cscidfound = false;}
               }
*/

                /* cm start - 12222008
                 * Keep track of the CTIDs passed to the service
                 * Once out of the process & country is available we will do the search
                 */
                if (key == 'CSCID' && val != ''){ 
                    ctidList.add(val);
                }
                /*cm end*/

                else if (key == 'Name' && val != '') {
                    name = val;
                }
                else if (key == 'AddressLine1__c' && val != '') {
                    addrLine1 = val;
                }
                else if (key == 'AddressLine1_English__c' && val != '') {
                    addrLine1_eng = val;
                }
                else if (key == 'AddressLine2__c'&& val != '' ) {
                    addrLine2 = val;
                }
                else if (key == 'AddressLine2_English__c'&& val != '' ) {
                    addrLine2_eng = val;
                }
                else if (key == 'CSCID__c' && val != '' ) {
                    companyID = val;
                }
                else if (key == 'CSCSiteID__c' && val != '' ) {
                    siteID = val;
                }
                else if (key == 'City__c' && val != '') {
                    city = val;
                }
                else if (key == 'City_English__c' && val != '') {
                    city_eng = val;
                }
                else if (key == 'State__c' && val != '' ) {
                    state = val;
                }
                else if (key == 'State_Province_English__c' && val != '' ) {
                    state_eng = val;
                }
                else if (key == 'Country__c' && val != '') {
                    country = val;
                }
                else if (key == 'Country_English__c' && val != '') {
                    country_eng = val;
                }
                else if (key == 'TOKENID__c' ) {
                    token = val;
                }
                else if (key == 'ZipPostalCode__c' && val != '' ) {
                    postalCode = val;
                }
                else if (key == 'Zip_Postal_Code_English__c' && val != '' ) {
                    postalCode_eng = val;
                }
            }
            reader.next();
        }

        /* Perform the required field checks */
        if (addrLine1 == '' || city == '' || country == '' ||  ownerid == '') {
            throw new CustomException('one of the required fields from (Address1,city,Country,Ownerid) is having a null value  :  ');
        }
        
        /* Check to see if the CTID + Country exist in SFDC */      
        String firstCSCID = '';     
        Account[] acctx = new Account[]{};
        if(ctidList.size() > 0){
           firstCSCID = ctidList.get(0);
           acctx =  [select Id,CSCID__c from Account where CSCID__c =:firstCSCID and CRCountry__c = :country_eng limit 2];
           if(acctx.size() == 0){
           firstCSCID = '';
           acctx =  [select Id,CSCID__c from Account where CSCID__c in :ctidList and CRCountry__c = :country_eng limit 2];
          }
        }
        /*else{
            String NoCSCIDInXML = 'No CSCID is sent in the XML';
         return '<AccountResult><SFDCID></SFDCID><Status>FAILURE</Status><ErrorMsg>'+NoCSCIDInXML+'</ErrorMsg></AccountResult>';
        }*/
        
        /* Define local variables */ 
        String oid = ownerid + '@cisco.com%';
        string idout ='';
        User[] users;
        User[] usr ;
        Org_Constants__c[] oc1;
                    
        /*
         * If there are potential matches, perform more identification steps
         */                    
        if (acctx.size() > 0) {
            String idList = '';
            if(firstCSCID == ''){
            for (String id : ctidList) {
                idList = idList + ',\'' + id + '\'';
            }
            idList = idList.substring(1);
            }
            else{
            idList = '\'' + firstCSCID + '\'';
            }
          //String q1 = 'select Id,CSCID__c from Account where CSCID__c in ('+idList+') and CRCountry__c = \''+country_eng+'\' and RecordType.name = \'End-User\' '+dummyString+'limit 2';
          //SCAVA FIX 
            String q1 = 'select Id,CSCID__c from Account where CSCID__c in ('+idList+') and CRCountry__c = \''+string.escapeSingleQuotes(country_eng)+'\' and RecordType.name = \'End-User\' '+dummyString+'limit 2';
        
        Account[] acct = (List<Account>)Database.query(q1);
         
         // Checking whether the user is 'VELOCITY' user or not
         
        if (acct.size()== 0) 
        {
            //String q2 = 'select Id,CSCID__c from Account where CSCID__c in ('+idList+') and CRCountry__c = \''+country_eng+'\' and RecordType.name = \'End-User\' '+dummyStringVelocity+'limit 2';
            //SCAVA FIX    
            String q2 = 'select Id,CSCID__c from Account where CSCID__c in ('+idList+') and CRCountry__c = \''+string.escapeSingleQuotes(country_eng)+'\' and RecordType.name = \'End-User\' '+dummyStringVelocity+'limit 2';
            acct = (List<Account>)Database.query(q2);
            system.debug('acct>>'+acct);
        }                       
            //Account[] acct =  [select Id,CSCID__c from Account where CSCID__c in :ctidList and Owner.Dummy_User__c = false and RecordType.name = 'End-User' and CRCountry__c = :country_eng limit 2]; //cm-12222008 - add country to the search
            
            //If only one Account found, return it   
            if (acct.size()== 1) {
                idout = '<CSCSearchResult><Type>Company</Type><CSCID>'+acct[0].CSCID__c+'</CSCID><SFDCID>'+acct[0].Id+'</SFDCID><ErrorMsg></ErrorMsg></CSCSearchResult>'; 
            }
            //If mutliple matches, restrict by owner ID
            else if (acct.size() > 1) {
              //String q2 = 'select Id,CSCID__c from Account where CSCID__c in ('+idList+') and CRCountry__c = \''+country_eng+'\' and Owner.Username like \''+oid+'\' and RecordType.name = \'End-User\' '+dummyString+' order by LastmodifiedDate desc Limit 1';
              //SCAVA FIX  
                String q2 = 'select Id,CSCID__c from Account where CSCID__c in ('+idList+') and CRCountry__c = \''+string.escapeSingleQuotes(country_eng)+'\' and Owner.Username like \''+String.escapeSingleQuotes(oid)+'\' and RecordType.name = \'End-User\' '+dummyString+' order by LastmodifiedDate desc Limit 1';
                Account[] getname = (List<Account>)Database.query(q2);
                //Account[] getname = [select Id,CSCID__c from Account where CSCID__c in :ctidList  and Owner.Username like :oid and Owner.Dummy_User__c = false and RecordType.name = 'End-User' and CRCountry__c = :country_eng order by LastmodifiedDate desc Limit 1]; //cm-12222008 - add country to the search
                    
                //If only one Account found, return it   
                if (getname.size()== 1) {
                    idout = '<CSCSearchResult><Type>Company</Type><CSCID>'+getname[0].CSCID__c+'</CSCID><SFDCID>'+getname[0].Id+'</SFDCID><ErrorMsg></ErrorMsg></CSCSearchResult>';
                }
                /* If multiple matches or no matches
                 * remove the owner ID criteria and take the last modified one
                 */
                else {
                  //String q3 = 'select Id,CSCID__c from Account where CSCID__c in ('+idList+') and CRCountry__c = \''+country_eng+'\' and RecordType.name = \'End-User\' '+dummyString+' order by LastmodifiedDate desc Limit 1';
                   //SCAVA FIX
                    String q3 = 'select Id,CSCID__c from Account where CSCID__c in ('+idList+') and CRCountry__c = \''+string.escapeSingleQuotes(country_eng)+'\' and RecordType.name = \'End-User\' '+dummyString+' order by LastmodifiedDate desc Limit 1';
                    Account[] noowner = (List<Account>)Database.query(q3);
                    //Account[] noowner= [select Id,CSCID__c from Account where CSCID__c in :ctidList and Owner.Dummy_User__c = false and RecordType.name = 'End-User' and CRCountry__c = :country_eng order by LastModifiedDate desc limit 1]; //cm-12222008 - add country to the search
                    idout = '<CSCSearchResult><Type>Company</Type><CSCID>'+noowner[0].CSCID__c+'</CSCID><SFDCID>'+noowner[0].Id+'</SFDCID><ErrorMsg></ErrorMsg></CSCSearchResult>'; 
                }
            }
            /* If no matches, first see if the Create Flag is true
             * If not, return error message
             */
            else if (allowDummyOwner && altOwnerid == '') {
                String errmsg = 'An owner is required to create an Account.';
                idout = '<AccountResult><SFDCID></SFDCID><Status>FAILURE</Status><ErrorMsg>'+errmsg+'</ErrorMsg></AccountResult>';
            }
            /* If no matches
             * check the profile to determine if the user can create an Account
             */ 
            else if(acct.size() < 1) {         
                if (allowDummyOwner && altOwnerid !='') {
                    oid = altOwnerid;
                }
                //RecordType rt = [select Id from RecordType where Name = 'End-User'];
                ObjectRecordTypeIds__c objRecordTypeSetting = ObjectRecordTypeIds__c.getOrgDefaults();
                String endUserAccRT = objRecordTypeSetting.Account_End_User_RecordTypeId__c ;

                usr = [ select profileId from User where username like :oid];
                                
                if (usr.size()>0)
                {
                  string prof_id = '%'+ usr[0].profileid + '%';
                  oc1 = [Select Id from Org_Constants__c where Key__c = 'ProfileID_PDR'  and  prod_value__c  like :prof_id];
                }
                if (oc1.size() >= 1 ) 
                {
                 //String q = 'select Id from User where username like \''+oid+'\' and Additional_User_Permissions__c includes (\'Enable PDR ACCTCreation\') '+dummyString2+' limit 1';
                  //SCAVA FIX  
                    String q = 'select Id from User where username like \''+String.escapeSingleQuotes(oid)+'\' and Additional_User_Permissions__c includes (\'Enable PDR ACCTCreation\') '+dummyString2+' limit 1';
                    users = (List<User>)Database.query(q);
                    //users = [select Id from User where username like :oid  and Dummy_user__c = false and Additional_User_Permissions__c includes ('Enable PDR ACCTCreation') limit 1];
                }
                else
                {
                 Org_Constants__c[] oc = [Select prod_value__c from Org_Constants__c where Key__c = 'ProfileID:End-User Accunt in QC'];
                 String[] checkValues = oc[0].prod_value__c.Split(','); 
                 String chkV = '';
                 for (String id : checkValues) {
                     chkV = chkV + ',\'' + id + '\'';
                 }
                 chkV = chkV.substring(1);
               //String q = 'select Id from User where username like \''+oid+'\' and ProfileId in ('+chkV+') '+dummyString2+' limit 1';
               //SCAVA FIX  
                 String q = 'select Id from User where username like \''+String.escapeSingleQuotes(oid)+'\' and ProfileId in ('+chkV+') '+dummyString2+' limit 1';
                 users = (List<User>)Database.query(q);
                 //users = [select Id from User where username like :oid  and Dummy_user__c = false and ProfileId in :checkValues limit 1];
                }

                // Account creation
                if(users.size() == 1 && siteID != '') {
                 /*  Account ac = new Account(Name = name,AccountNameEnglish__c = name,CRName__c = name,AddressLine1__c = addrLine1,AddressLine1_English__c = addrLine1_eng,CRAddressLine1__c = addrLine1_eng,AddressLine2__c = addrLine2,AddressLine2_English__c = addrLine2_eng,CRAddressLine2__c = addrLine2_eng,CSCID__c = companyID,CSCSiteID__c = siteID,City__c = city,City_English__c = city_eng,CRCity__c = city_eng,State__c = state,CRState__c  = state_eng,State_Province_English__c = state_eng,Country__c = country,Country_English__c = country_eng,CRCountry__c = country_eng,ZipPostalCode__c = postalCode,Zip_Postal_Code_English__c = postalCode_eng,CRZipPostalCode__c = postalCode_eng,Recordtypeid=rt.Id,ownerId = users[0].Id);
                    Insert ac;
                    aid = String.valueOf(ac.Id);
                    idout = '<AccountResult><SFDCID>'+aid+'</SFDCID><Status>SUCCESS: Account Created</Status><ErrorMsg></ErrorMsg></AccountResult>';*/
                    //SCAVA FIX
                    Account ac = new Account(Name = String.escapeSingleQuotes(name),AccountNameEnglish__c = String.escapeSingleQuotes(name),CRName__c = String.escapeSingleQuotes(name),AddressLine1__c = String.escapeSingleQuotes(addrLine1),AddressLine1_English__c = String.escapeSingleQuotes(addrLine1_eng),CRAddressLine1__c = String.escapeSingleQuotes(addrLine1_eng),AddressLine2__c = String.escapeSingleQuotes(addrLine2),AddressLine2_English__c = String.escapeSingleQuotes(addrLine2_eng),CRAddressLine2__c = String.escapeSingleQuotes(addrLine2_eng),CSCID__c = String.escapeSingleQuotes(companyID),CSCSiteID__c = String.escapeSingleQuotes(siteID),City__c = String.escapeSingleQuotes(city),City_English__c = String.escapeSingleQuotes(city_eng),CRCity__c = String.escapeSingleQuotes(city_eng),State__c = String.escapeSingleQuotes(state),CRState__c  = String.escapeSingleQuotes(state_eng),State_Province_English__c = String.escapeSingleQuotes(state_eng),Country__c = String.escapeSingleQuotes(country),Country_English__c = String.escapeSingleQuotes(country_eng),CRCountry__c = String.escapeSingleQuotes(country_eng),ZipPostalCode__c = String.escapeSingleQuotes(postalCode),Zip_Postal_Code_English__c = String.escapeSingleQuotes(postalCode_eng),CRZipPostalCode__c = String.escapeSingleQuotes(postalCode_eng),Recordtypeid=endUserAccRT,ownerId = users[0].Id);
                        Insert ac;                    
                    aid = String.valueOf(ac.Id);
                    idout = '<AccountResult><SFDCID>'+aid+'</SFDCID><Status>SUCCESS: Account Created</Status><ErrorMsg></ErrorMsg></AccountResult>';
                }
                else if(users.size() == 1 && siteID == '') {
                    /*Account ac = new Account(Name = name,AccountNameEnglish__c = name,AddressLine1__c = addrLine1,AddressLine1_English__c = addrLine1_eng,AddressLine2__c = addrLine2,AddressLine2_English__c = addrLine2_eng,CSCID__c = companyID,CSCSiteID__c = siteID,City__c = city,City_English__c = city_eng,State__c = state,State_Province_English__c = state_eng,Country__c = country,Country_English__c = country_eng,ZipPostalCode__c = postalCode,Zip_Postal_Code_English__c = postalCode_eng,Recordtypeid=rt.Id,ownerId = users[0].Id);
                    Insert ac;
                    aid = String.valueOf(ac.Id);
                    idout = '<AccountResult><SFDCID>'+aid+'</SFDCID><Status>SUCCESS: Account Created</Status><ErrorMsg></ErrorMsg></AccountResult>';*/
                   //SCAVA FIX  
                    Account ac = new Account(Name = String.escapeSingleQuotes(name),AccountNameEnglish__c = String.escapeSingleQuotes(name),AddressLine1__c = String.escapeSingleQuotes(addrLine1),AddressLine1_English__c = String.escapeSingleQuotes(addrLine1_eng),AddressLine2__c = String.escapeSingleQuotes(addrLine2),AddressLine2_English__c = String.escapeSingleQuotes(addrLine2_eng),CSCID__c = String.escapeSingleQuotes(companyID),CSCSiteID__c = String.escapeSingleQuotes(siteID),City__c = String.escapeSingleQuotes(city),City_English__c = String.escapeSingleQuotes(city_eng),State__c = String.escapeSingleQuotes(state),State_Province_English__c = String.escapeSingleQuotes(state_eng),Country__c = String.escapeSingleQuotes(country),Country_English__c = String.escapeSingleQuotes(country_eng),ZipPostalCode__c = String.escapeSingleQuotes(postalCode),Zip_Postal_Code_English__c = String.escapeSingleQuotes(postalCode_eng),Recordtypeid=endUserAccRT,ownerId = users[0].Id);
                    Insert ac;
                    aid = String.valueOf(ac.Id);
                    idout = '<AccountResult><SFDCID>'+aid+'</SFDCID><Status>SUCCESS: Account Created</Status><ErrorMsg></ErrorMsg></AccountResult>';
                }
                else if(users.size()== 0) {
                    String errmsg = 'Given User does not exist in SFDC OR  is not on a correct profile OR  must be a dummy user.';
                    idout = '<AccountResult><SFDCID></SFDCID><Status>FAILURE</Status><ErrorMsg>'+errmsg+'</ErrorMsg></AccountResult>';
                }
            }    
        }
        /* If no potential matches
         * Determine if the user has the ability to create Accounts
         * based on his/her profile
         */
        else {
            if (allowDummyOwner && altOwnerid !='') {
                oid = altOwnerid;
            }
            //RecordType rt = [select Id from RecordType where Name = 'End-User'];
            ObjectRecordTypeIds__c objRecordTypeSetting = ObjectRecordTypeIds__c.getOrgDefaults();
            String endUserAccRT = objRecordTypeSetting.Account_End_User_RecordTypeId__c ;
            usr = [ select profileId from User where username like :oid  ];
                    
            if (usr.size()>0)
            {
              string prof_id = '%'+ usr[0].profileid + '%';
              oc1 = [Select Id from Org_Constants__c where Key__c = 'ProfileID_PDR'  and  prod_value__c  like :prof_id];
            }
            if (oc1 != null && oc1.size() >= 1 ) 
            {
            //String q = 'select Id from User where username like \''+oid+'\' and Additional_User_Permissions__c includes (\'Enable PDR ACCTCreation\') '+dummyString2+' limit 1';
            //SCAVA FIX
             String q = 'select Id from User where username like \''+String.escapeSingleQuotes(oid)+'\' and Additional_User_Permissions__c includes (\'Enable PDR ACCTCreation\') '+dummyString2+' limit 1';
             users = (List<User>)Database.query(q);
             //users = [select Id from User where username like :oid  and Dummy_user__c = false and Additional_User_Permissions__c includes ('Enable PDR ACCTCreation') limit 1];
            }
            else
            {
             Org_Constants__c[] oc = [Select prod_value__c from Org_Constants__c where Key__c = 'ProfileID:End-User Accunt in QC' ];
             String[] checkValues = oc[0].prod_value__c.Split(','); 
             String chkV = '';
             for (String id : checkValues) {
                 chkV = chkV + ',\'' + id + '\'';
             }
             chkV = chkV.substring(1);
             //String q = 'select Id from User where username like \''+oid+'\' and ProfileId in ('+chkV+') '+dummyString2+' limit 1';
             //SCAVA FIX
             String q = 'select Id from User where username like \''+String.escapeSingleQuotes(oid)+'\' and ProfileId in ('+chkV+') '+dummyString2+' limit 1';
             users = (List<User>)Database.query(q);
             //users = [select Id from User where username like :oid  and Dummy_user__c = false and ProfileId in :checkValues limit 1];
            }
            // Account creation
            if(users.size() == 1 && siteID != ''){
                    /*Account ac = new Account(Name = name,AccountNameEnglish__c = name,CRName__c = name,AddressLine1__c = addrLine1,AddressLine1_English__c = addrLine1_eng,CRAddressLine1__c = addrLine1_eng,AddressLine2__c = addrLine2,AddressLine2_English__c = addrLine2_eng,CRAddressLine2__c = addrLine2_eng,CSCID__c = companyID,CSCSiteID__c = siteID,City__c = city,City_English__c = city_eng,CRCity__c = city_eng,State__c = state,CRState__c  = state_eng,State_Province_English__c = state_eng,Country__c = country,Country_English__c = country_eng,CRCountry__c = country_eng,ZipPostalCode__c = postalCode,Zip_Postal_Code_English__c = postalCode_eng,CRZipPostalCode__c = postalCode_eng,Recordtypeid=rt.Id,ownerId = users[0].Id);
                    Insert ac;
                    aid = String.valueOf(ac.Id);
                    idout = '<AccountResult><SFDCID>'+aid+'</SFDCID><Status>SUCCESS: Account Created</Status><ErrorMsg></ErrorMsg></AccountResult>';*/
                    //SCAVA FIX
                Account ac = new Account(Name = String.escapeSingleQuotes(name),AccountNameEnglish__c = String.escapeSingleQuotes(name),CRName__c = String.escapeSingleQuotes(name),AddressLine1__c = String.escapeSingleQuotes(addrLine1),AddressLine1_English__c = String.escapeSingleQuotes(addrLine1_eng),CRAddressLine1__c = String.escapeSingleQuotes(addrLine1_eng),AddressLine2__c = String.escapeSingleQuotes(addrLine2),AddressLine2_English__c = addrLine2_eng,CRAddressLine2__c = addrLine2_eng,CSCID__c = companyID,CSCSiteID__c = siteID,City__c = city,City_English__c = city_eng,CRCity__c = String.escapeSingleQuotes(city_eng),State__c = String.escapeSingleQuotes(state),CRState__c  = String.escapeSingleQuotes(state_eng),State_Province_English__c = String.escapeSingleQuotes(state_eng),Country__c = String.escapeSingleQuotes(country),Country_English__c = String.escapeSingleQuotes(country_eng),CRCountry__c = String.escapeSingleQuotes(country_eng),ZipPostalCode__c = String.escapeSingleQuotes(postalCode),Zip_Postal_Code_English__c = String.escapeSingleQuotes(postalCode_eng),CRZipPostalCode__c = String.escapeSingleQuotes(postalCode_eng),Recordtypeid=endUserAccRT,ownerId = users[0].Id);
                Insert ac;
                aid = String.valueOf(ac.Id);
                idout = '<AccountResult><SFDCID>'+aid+'</SFDCID><Status>SUCCESS: Account Created</Status><ErrorMsg></ErrorMsg></AccountResult>';
            }
            else if(users.size() == 1 && siteID == '') {
                    /*Account ac = new Account(Name = name,AccountNameEnglish__c = name,AddressLine1__c = addrLine1,AddressLine1_English__c = addrLine1_eng,AddressLine2__c = addrLine2,AddressLine2_English__c = addrLine2_eng,CSCID__c = companyID,CSCSiteID__c = siteID,City__c = city,City_English__c = city_eng,State__c = state,State_Province_English__c = state_eng,Country__c = country,Country_English__c = country_eng,ZipPostalCode__c = postalCode,Zip_Postal_Code_English__c = postalCode_eng,Recordtypeid=rt.Id,ownerId = users[0].Id);
                    Insert ac;
                    aid = String.valueOf(ac.Id);
                    idout = '<AccountResult><SFDCID>'+aid+'</SFDCID><Status>SUCCESS: Account Created</Status><ErrorMsg></ErrorMsg></AccountResult>';*/
               //SCAVA FIX
                Account ac = new Account(Name = String.escapeSingleQuotes(name),AccountNameEnglish__c = String.escapeSingleQuotes(name),AddressLine1__c = String.escapeSingleQuotes(addrLine1),AddressLine1_English__c = String.escapeSingleQuotes(addrLine1_eng),AddressLine2__c =String.escapeSingleQuotes(addrLine2),AddressLine2_English__c = String.escapeSingleQuotes(addrLine2_eng),CSCID__c = String.escapeSingleQuotes(companyID),CSCSiteID__c = String.escapeSingleQuotes(siteID),City__c = String.escapeSingleQuotes(city),City_English__c = String.escapeSingleQuotes(city_eng),State__c = String.escapeSingleQuotes(state),State_Province_English__c = String.escapeSingleQuotes(state_eng),Country__c = String.escapeSingleQuotes(country),Country_English__c = String.escapeSingleQuotes(country_eng),ZipPostalCode__c = String.escapeSingleQuotes(postalCode),Zip_Postal_Code_English__c = String.escapeSingleQuotes(postalCode_eng),Recordtypeid=endUserAccRT,ownerId = users[0].Id);
                    Insert ac;
                aid = String.valueOf(ac.Id);
                idout = '<AccountResult><SFDCID>'+aid+'</SFDCID><Status>SUCCESS: Account Created</Status><ErrorMsg></ErrorMsg></AccountResult>';
            }
            else if(users.size()== 0) {
                String errmsg = 'Given User does not exist in SFDC OR  is not on a correct profile OR  must be a dummy user.';
                idout = '<AccountResult><SFDCID></SFDCID><Status>FAILURE</Status><ErrorMsg>'+errmsg+'</ErrorMsg></AccountResult>';
            }
        }
        return idout;
    }
 }