/*********************************************************************************************************************************
Name    : DSE_Utilities 
Author  : Mukesh Srivastava
Purpose : Utility controller with all required reference data
Created Date:  1/18/2016 
Modification History: 
   #Release                     Cec       Date         Change
   1.Tac_Visibility_Release  katandon (6/17/2016) - Added 'global Boolean getTacHomeVisibility()'
     
                      
**********************************************************************************************************************************/


global class DSE_Utilities {
    
    //@Method: Provide Logged User TimeZone
    global String getTimeZoneCode() {
        TimeZone tz = UserInfo.getTimeZone();
        DSE_TimeZone_Code__c tzcodeIns = DSE_TimeZone_Code__c.getInstance(tz.toString());
        return tzcodeIns.code__c;
    }

    //@Method: Provide Logged User Locale
    global String getlocale() {
        return UserInfo.getlocale();
    }
    
    //@Method: Provide Logged User locale datetime format
    global string getlocaleformat() {
        String locale = UserInfo.getlocale();
        DSE_Locale_Date_Time_Format__c localeformatIns = DSE_Locale_Date_Time_Format__c.getInstance(locale);
        return localeformatIns.format__c;
    }
    
    //@Method: Check Home page tac tile visibility based on JobCategory
    global Boolean getTacHomeVisibility() {
        DSE_JobCategory_Tac_Home__c mc = DSE_JobCategory_Tac_Home__c.getValues('ValidJobCategory');
        User usr = new User();
        usr = [SELECT Shr_Job_Category__c FROM User WHERE Id = : UserInfo.getUserId()];
        System.debug('Shr Job Category : '+usr.Shr_job_category__c);
        if(String.isBlank(usr.Shr_job_category__c)){
            return false;
        }
        return (mc.JobCategory__c).containsIgnoreCase(usr.Shr_job_category__c);
        
    }


    
    //@ Method to find out production and sandbox URLs
    global String getPingTokenURL(){        
        Org_Constant_CS__c jnOrgCS = Org_Constant_CS__c.getValues('DSEMuleToken');        
        String strMuleURL = jnOrgCS.Production_Value__c;
        
        Organization org = [Select Id, IsSandbox FROM Organization limit 1];
        if(org.IsSandbox == TRUE){
            strMuleURL = jnOrgCS.Non_Production_Value__c;
        }
        return strMuleURL;
    }
    
    @future(callout=true)
    global static void tokenHttpcallout(){        
        
            HttpRequest req = new HttpRequest();
            DSE_Utilities dseutil = new DSE_Utilities();
            String pingUrl = dseutil.getPingTokenURL();
            req.setEndpoint(pingUrl);
            req.setMethod('POST');
            
            Http http = new Http();
            HTTPResponse res = http.send(req);
            string token = DSE_APIOAuthTokenParser.parse(res.getbody()).access_token;
            Cache.Org.put('local.DSE.muletoken', token);
        
    }

    //@Method: Get Mule Token from Org Cache
    global String getMuleToken(){
        String token = '';
        if (Cache.Org.contains('local.DSE.muletoken')) {
            token = (String)Cache.Org.get('local.DSE.muletoken');
        }
        return token;
    }
    
    //@Class: Represent JSON request for All Account and My Account
    global class DSE_Request{
        global String filter_criteria ;
        global String locale ;
        global String oe_id ;
        global Integer page_no ;
        global Integer page_size ;
        global String sort_by;
        global String sort_order;
        global String time_zone;
        global String user_id;
        global String pagination;
   
    }

   
    //@Method: Provides List of Account based on User Request on OE Page
    global DSE_RestAPIResponseHandler getAccountsDetail(DSE_Request req) {
        DSE_RestAPIResponseHandler response = new DSE_RestAPIResponseHandler();

        //Calculating query offset for pagination 
        Integer offset = (req.page_no * req.page_size) - req.page_size;

        Id endCustomerRecType = Schema.SObjectType.Account.RecordTypeInfosByName.get('End-User').RecordTypeId;
        
        // Based on the Request Parameter generating SOQL
        String queryString = 'SELECT ';
        String queryStringcount;
        for (Schema.FieldSetMember f: SObjectType.Account.FieldSets.OE_Child_Account_Related_List.getFields()) {
            queryString += f.getFieldPath() + ', ';
        }

        queryString += 'Id,Owner.Name FROM Account Where Owner.Dummy_User__c = false AND OE_ID__c=\'' + req.oe_id + '\'';
        
        queryString += ' AND RecordTypeId =\'' +endCustomerRecType +'\'';
        

        if (req.filter_criteria.indexOf('myaccounts') > 0) {
            if (req.filter_criteria.indexOf('AND') > 0) {
                req.filter_criteria = req.filter_criteria.substring(req.filter_criteria.indexOf('AND'), req.filter_criteria.length());
                req.filter_criteria = req.filter_criteria.remove('UPPER(');
                req.filter_criteria = req.filter_criteria.remove(')');
                queryString += '' + req.filter_criteria;
            }

        } else if (req.filter_criteria != '') {
            req.filter_criteria = req.filter_criteria.remove('UPPER(');
            req.filter_criteria = req.filter_criteria.remove(')');
            queryString += ' AND ' + req.filter_criteria;

        }
        queryStringcount = queryString + ' ORDER BY ' + req.sort_by + ' ' + req.sort_order;
        queryString += ' ORDER BY ' + req.sort_by + ' ' + req.sort_order + ' LIMIT ' + req.page_size + ' OFFSET ' + offset;

        system.debug(queryString);

        //Initiating the Account List which will be returned as API Response
        List < Account > lstAcc = new List < Account > ();
        List < Account > lstAccCount = new List < Account > ();

        //If OE_ID has been requested then only the API will return the data
        if (req.oe_id != '') {
            lstAcc = Database.Query(queryString);
            lstAccCount = Database.Query(queryStringcount);
        }

        //Preparing Response
        response.data = lstAcc;
        response.totalrecords = lstAccCount.size();
        response.status = '200';
        response.success = true;

        if (lstAcc.isEmpty()) {
            response.message = 'No Records Found';
        } else {
            response.message = '';
        }

        return response;
    }


}