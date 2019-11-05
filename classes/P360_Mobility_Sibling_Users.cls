@RestResource(urlMapping='/p360mobility/SiblingUsers/*')
global class P360_Mobility_Sibling_Users{

    @HttpGet
    global static ReturnClass  getSiblingUsers(){
    
        //Integer offset, Integer lim
        String o = RestContext.request.params.get('offset');
        String l = RestContext.request.params.get('limit');
        Integer offset = Integer.valueOf((o==null?'0':o));
        Integer lim = Integer.valueOf((l==null?'200':l));

        String searchString = RestContext.request.params.get('search');
        String queryCondition = (searchString ==null?' ':'AND u.Name LIKE \'' +searchString+ '%\'');
        
        system.debug('offset='+offset);
        if(lim == null || lim ==0){lim=200;}
        system.debug('lim='+lim);
        String theuserid = UserInfo.getUserId();
        
        if(Test.isRunningTest()){
            theuserid = GenericStaticTestData.gettestPSRUserRecord().id;
        }
        
        system.debug('-----> the requestor"s user id is:'+theuserid);
        
        User u = [select Id, Contact.Account.Parent.Id from User where id = :theuserid];
        String theparentacctid = u.Contact.Account.Parent.Id;
        system.debug('-----> the user"s account parent id is:'+theparentacctid );
        
        
        String soql = 'Select u.id, u.Email, u.FirstName, u.LastName, u.Title, u.Name, u.Alias, u.contact.account.Name, u.contact.Id, u.UserRole.name, u.Street, u.City, u.State, u.Country, u.PostalCode from User u where u.isactive=true and u.contact.account.parentId=\''+theparentacctid + '\' ' + queryCondition+ ' order by u.Name limit '+lim+' offset '+offset;
        system.debug('soql ='+soql );        
        List<User> siblings  = Database.query(soql);
/*
        List<User> siblings = [Select u.id, u.Email, u.FirstName, u.LastName, u.Title, u.Name, u.Alias, u.contact.account.Name, u.contact.Id, u.UserRole.name, u.Street, u.City, u.State, u.Country, u.PostalCode 
                               from User u 
                               where u.isactive=true and u.contact.account.parentId=:theparentacctid 
                               order by u.Name limit :lim offset :offset];
*/                               
        Integer totalCount = [Select count() 
                               from User u 
                               where u.isactive=true and u.contact.account.parentId=:theparentacctid];
                               
                               

        system.debug('the list of sibligs is:'+siblings);
        
        ReturnClass result = new ReturnClass('Success', 'OK', totalCount , siblings);
        return result ;
    }

/*
    @HttpPost
//    global static ReturnClass  getPSRUsers(String off, String lm, String id, String objtype){
    global static ReturnClass  getPSRUsers(){
        String off = RestContext.request.params.get('offset');
        String lm = RestContext.request.params.get('limit');
        String id = RestContext.request.params.get('id');
        String objtype = RestContext.request.params.get('type');
        String searchString = RestContext.request.params.get('search');
        
        String queryCondition = (searchString ==null?' ':'AND u.Name LIKE \'' +searchString+ '%\'');
              
        Integer offset = Integer.valueOf((off==null?'0':off));
        Integer lim = Integer.valueOf((lm==null?'200':lm));
        
        String theuserid = UserInfo.getUserId();
        system.debug('userid='+theuserid );
                
        List<User> user_list = null;
        Integer totalCount;

        system.debug('objtype='+objtype);        
        if('lead'.equals(objtype)){
            List<LeadShare>  access = [select LeadAccessLevel from leadshare where leadid=:id and UserOrGroupId = :theuserid];
            if(access.size() < 1){
//                return  new ReturnClass('Error', 'access_denied', 0, null); 
                    system.debug('access denied');       
            }
            Lead l = [Select Channel_Partner__r.Parent.id from Lead where id = :id];
            String theparentacctid = l.Channel_Partner__r.Parent.id;
            if(theparentacctid == null || ''.equals(theparentacctid )){
                  return  new ReturnClass('Success', 'No Channel Partner Assigned', 0, null);        
            }
            system.debug('theparentacctid ='+theparentacctid );        
            String soql = 'Select u.id, u.Email, u.FirstName, u.LastName, u.Title, u.Name, u.Alias, u.contact.account.Name, u.contact.Id, u.UserRole.name, u.Street, u.City, u.State, u.Country, u.PostalCode from User u where u.isactive=true and u.contact.account.parentId=\''+theparentacctid + '\' ' + queryCondition+ ' order by u.Name limit '+lim+' offset '+offset;
            system.debug('soql ='+soql );        
            user_list = Database.query(soql);
            totalCount = [Select count() 
                          from User u 
                          where u.isactive=true and u.contact.account.parentId=:theparentacctid];
            system.debug('totalCount ='+totalCount );             
        }
        else if('tp'.equals(objtype)){
            List<Assigned_Partner__Share>  access = [SELECT AccessLevel FROM Assigned_Partner__Share where UserOrGroupId = :theuserid and ParentId = :id];
            if(access.size() < 1){
//                return  new ReturnClass('Error', 'access_denied', 0, null); 
                 system.debug('access denied');
            }
            Assigned_Partner__c tp = [SELECT Assigned_Partner__r.Parent.id FROM Assigned_Partner__c where id = :id];
            String theparentacctid = tp.Assigned_Partner__r.Parent.id;
            if(theparentacctid == null || ''.equals(theparentacctid )){
                  return  new ReturnClass('Success', 'No Assigned Partner', 0, null);        
            }

            String soql = 'Select u.id, u.Email, u.FirstName, u.LastName, u.Title, u.Name, u.Alias, u.contact.account.Name, u.contact.Id, u.UserRole.name, u.Street, u.City, u.State, u.Country, u.PostalCode from User u where u.isactive=true and u.contact.account.parentId=\''+theparentacctid+'\' '+queryCondition+' order by u.Name limit '+lim+' offset '+offset;
            user_list = Database.query(soql);
            totalCount = [Select count() 
                          from User u 
                          where u.isactive=true and u.contact.account.parentId=:theparentacctid];
        }
        else{
            return  new ReturnClass('Error', 'invalid_request', 0, null);
        }
        
        ReturnClass result = new ReturnClass('Success', 'OK', user_list.size(), user_list);
        return result ;
    }
*/    
    global class ReturnClass {
    
        global String success;
        global String message;
        global Integer total;
        global List<User> records;
        
        global ReturnClass(String success, String message, Integer total, List<User> records) {
            this.success = success;
            this.message = message;
            this.total = total;
            this.records = records;
        }
    }


    @isTest(SeeAllData=true)
    public static void testGetSiblingUsers(){
    
        RestRequest req = new RestRequest();
        RestResponse res = new RestResponse();

        System.RestContext.request = new RestRequest();
        RestContext.request.requestURI = '/services/apexrest/p360mobility/PartnerUsers/';
        RestContext.request.addHeader('offset', '0');

        
//        req.requestURI = 'https://cs1.salesforce.com/services/apexrest/SiblingUsers?offset=0';
//        req.httpMethod = 'GET';
//        RestContext.request = req;
//        RestContext.response = res;
        
        ReturnClass  results = P360_Mobility_Sibling_Users.getSiblingUsers();
        
        System.debug('::::results.records is::::'+results.records);
        
        System.assertEquals('Success', results.success);        
    }
/*    
    @isTest(SeeAllData=true)
    public static void testGetPSRUsers(){
    
        
        RestResponse res = new RestResponse();
        
        System.RestContext.request = new RestRequest();
        RestContext.request.requestURI = '/services/apexrest/p360mobility/PartnerUsers/';
        RestContext.request.addParameter('offset', '0');
        RestContext.request.addParameter('limit', '200');
        RestContext.request.addParameter('id', '00Q8000000udWO1EAM');
        RestContext.request.addParameter('type', 'lead');

        
//        req.requestURI = 'https://cs1.salesforce.com/services/apexrest/SiblingUsers?offset=0';
        
        ReturnClass  results = P360_Sibling_Account_Users.getPSRUsers();
        
        System.debug('::::results.records is::::'+results.records);
        
        System.assertEquals('Success', results.success);        
    }
*/      
    


}