@RestResource(urlMapping='/p360mobility/PartnerUsers/*')
global class P360_Mobility_Partner_Users{

    @HttpGet
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
        
        List<User>  partnerProfile = [SELECT id FROM User where profileId = '00e800000011h7J' and id = :theuserid];
        if(partnerProfile.size() > 0){
            system.debug('access denied');       
            return  new ReturnClass('Error', 'access_denied', 0, null); 
        }

        system.debug('objtype='+objtype);        
        if('lead'.equals(objtype)){
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
    public static void testGetPSRUsers(){
    
        
        RestResponse res = new RestResponse();
        
        System.RestContext.request = new RestRequest();
        RestContext.request.requestURI = '/services/apexrest/p360mobility/PartnerUsers/';
        RestContext.request.addParameter('offset', '0');
        RestContext.request.addParameter('limit', '200');
        RestContext.request.addParameter('id', GenericStaticTestData.gettesteLeadRecord().id);
        RestContext.request.addParameter('type', 'lead');

        
//        req.requestURI = 'https://cs1.salesforce.com/services/apexrest/SiblingUsers?offset=0';
        
        ReturnClass  results = P360_Mobility_Partner_Users.getPSRUsers();
        
        System.debug('::::results.records is::::'+results.records);
        
        System.assertEquals('Success', results.success);        
    }
        
    


}