global class CSContact {
    /**
     * Returns an XML string of Contacts that match the search criteria
     * param optyID - the SFDC opportunity ID
     * param firstName - The first name of the contact
     * param lastName - The last name of the contact
     * param emailAddr - The email address of the contact
     */
    WebService static String searchByOpty(String optyID, String firstName, String lastName, String emailAddr, String alias, String orderBy, String ascDesc) {
        Opportunity o = new Opportunity();
        String contactStr = '';
        String fName;
        String lName;
        String oAlias;
        String accountId;

        try {
            o = [Select AccountId from Opportunity where Id = :optyId];
            accountId = String.valueOf(o.AccountId);
        }
        catch (QueryException qe) {
            return oSearchXML(optyID,'FAILURE','Unable to find Account ID for input Opportunity ID: '+qe.getMessage(),'');
        }
        //Build query string
        String q = 'Select c.Title, c.Phone, c.Owner.Alias, c.MailingState, c.MailingCity, c.LastName, c.FirstName, c.Email From Contact c where ContactStatus__c=\'Active\' and AccountId = :accountId';

        if(firstName != null && firstName != '') {
            fName = firstName.replace('*', '%');
            q += ' and c.FirstName like :fName';
        }
        if(lastName != null && lastName != '') {
            lName = lastName.replace('*', '%');
            q += ' and c.LastName like :lName';
        }
        if(emailAddr != null && emailAddr != '') {
            q += ' and c.Email = :emailAddr';
        }
        if(alias != null && alias != '') {
            oAlias = alias.replace('*', '%');
            q += ' and c.Owner.Alias like :oAlias';
        }
        if(orderBy != null && orderBy != '') {
            q += ' order by '+orderBy;
            if (ascDesc != null && ascDesc != '') {
                q += ' '+ascDesc;
            }
        }
   
        //Limit the results to 100 records
           q += ' limit 100';
           
        /* Fetch object details and cast */
        List<Contact> cList;
        try {
            cList = Database.query(q);
            for (Contact c : cList) {
                contactStr += '<Contact><Title>'+cdata(c.Title)+'</Title><Phone>'+cdata(c.Phone)+'</Phone><OwnerAlias>'+cdata(c.Owner.Alias)+'</OwnerAlias><State>'+cdata(c.MailingState)+'</State><City>'+cdata(c.MailingCity)+'</City><LastName>'+cdata(c.LastName)+'</LastName><FirstName>'+cdata(c.FirstName)+'</FirstName><Email>'+cdata(c.Email)+'</Email></Contact>';
            }
        }
        catch (QueryException qe) {
            //no contacts
        }                
        return oSearchXML(optyID,'SUCCESS','',contactStr);
    }
    /**
     * Returns an XML string of Contacts that match the search criteria
     * param optyID - the SFDC opportunity ID
     * param firstName - The first name of the contact
     * param lastName - The last name of the contact
     * param emailAddr - The email address of the contact
     */
    public static String cdata(String input) {
        if (input == null || input == '') {
            return '';
        }
        else {
            return '<![CDATA['+input+']]>';
        }
    }
    /**
     * Returns an XML string of for the Contact search
     * param optyID - the SFDC opportunity ID
     * param status - if the operation was a success or failure
     * param errMsg - if the operation failed, the error message associated with the failure
     * param contactResult - The partially formatted string of Contacts to return
     */
    public static String oSearchXML(String optyID,String status,String errMsg,String contactResult) {
        String errXML = '<SearchResult><SFDCID>'+optyID+'</SFDCID><Status>'+status+'</Status><ErrorMsg>'+errMsg+'</ErrorMsg><ContactList>'+contactResult+'</ContactList></SearchResult>';
        return errXML;
    }
    /**
     * Returns an XML string for the Contact create
     * param cecId - The user's CEC ID
     * param optyID - the SFDC opportunity ID
     * param status - if the operation was a success or failure
     * param errMsg - if the operation failed, the error message associated with the failure
     * param contactID - The SFDC Contact ID for the newly created Contact
     */
    public static String oCreateXML(String cecID,String optyID,String status,String errMsg,String contactID) {
        String errXML = '<CreateResult><OptyID>'+optyID+'</OptyID><CECID>'+cecID+'</CECID><ContactID>'+contactID+'</ContactID><Status>'+status+'</Status><ErrorMsg>'+errMsg+'</ErrorMsg></CreateResult>';
        return errXML;
    }
    /**
     * Returns an XML string that contains the SFDC ID of the new Contact
     * param optyID - the SFDC opportunity ID
     * param cecId - The user's CEC ID
     * param firstName - The first name of the contact
     * param lastName - The last name of the contact
     * param emailAddr - The email address of the contact
     */
    WebService static String create(String optyID, String cecID, String firstName, String lastName, String emailAddr) {
        Opportunity o = new Opportunity();
        User u = new User();
        try {
            String queryOwnerId = cecId+'@cisco.com%';
            u = [Select Id from User where UserName like :queryOwnerId and isActive=true];
        }
        catch (QueryException qe) {
            return oCreateXML(cecID,optyID,'FAILURE','Unable to find CEC ID in SFDC: '+qe.getMessage(),'');
        }
        try {
            o = [Select AccountId from Opportunity where Id = :optyID];
        }
        catch (QueryException qe) {
            return oCreateXML(cecID,optyID,'FAILURE','Unable to find Account ID for input Opportunity ID: '+qe.getMessage(),'');
        }

        try {
            Contact c = new Contact();
            c.AccountId = o.AccountId;
            c.OwnerId = u.Id;
            c.FirstName = firstName;
            c.LastName = lastName;
            c.Email = emailAddr;
            Insert c;

            return oCreateXML(cecID,optyID,'SUCCESS','',c.Id);
        }
        catch (Exception e) {
            return oCreateXML(cecID,optyID,'FAILURE','Unable to create new Contact: '+e.getMessage(),'');
        }
    }
    /**
     * Returns an XML string that contains the SFDC ID of the new Partner Contact
     * param optyID - the SFDC opportunity ID
     * param cecID - The user's CEC ID
     * param acctID - The SFDC ID of the Partner Account
     * param name - The name of the contact
     * param addr - The address of the contact
     * param ccoId - The Partner Contact's CCO ID
     * param city - The Account city
     * param country - The Account country
     * param emailAddr - The email address of the contact
     * param pdbCNID - The PDB ID of the Partner Contact
     * param phone - The phone number for the contact
     * param title - The contact's title
     */
    WebService static String createPtnrCt(String optyID, String cecID, String acctID, String name, String addr, String ccoID, String city, String country, String emailAddr, String pdbCNID, String phone, String title, String quoteID) {
        Partner_Contact__c c = new Partner_Contact__c();
        try {
            //Check to see if the Partner Contact exists for the PDB CN ID (unique identifier)
            c = [Select Id, pdb_cn_id__c from Partner_Contact__c where pdb_cn_id__c = :pdbCNID];
        }
        catch (QueryException qe) {
            //If the Partner Contact does not exist, create it
            try {
                c.Name = name;
                c.Address__c = addr;
                c.CCO_Id__c = ccoID;
                c.City__c = city;
                c.Country__c = country;
                c.Email__c = emailAddr;
                c.pdb_cn_id__c = pdbCNID;
                c.phone__c = phone;
                c.title__c = title;
                c.Partner_Name__c = acctID;
                Insert c;
            }
            catch (Exception e) {
                return oCreateXML(cecID,optyID,'FAILURE','Unable to create new PartnerContact: '+e.getMessage(),'');
            }
        }
        Partner_Contact_Oppty_Mapping__c m = new Partner_Contact_Oppty_Mapping__c();
        try {
            //Check to see if there is a mapping between the Partner Contact and Opportunity & Quote Both
            m = [Select Id, opportunity__c from Partner_Contact_Oppty_Mapping__c where partner_contact__c = :c.Id and opportunity__c = :optyID and Quote_ID__c =: quoteID];
        }
        catch (QueryException qe) {
            //If no mapping, create one to associate the Partner Contact to the Opportunity
            //This allows an N:N relationship between Partner Contact and Opportunity
            try {
                m.opportunity__c = optyID;
                m.Partner_Contact__c = c.Id;
                m.Quote_ID__c = quoteID;
                Insert m;
            }
            catch (Exception e) {
                return oCreateXML(cecID,optyID,'FAILURE','Unable to create new PartnerContactMapping: '+e.getMessage(),'');
            }
        }
        return oCreateXML(cecID,optyID,'SUCCESS','',c.Id);
    }
}