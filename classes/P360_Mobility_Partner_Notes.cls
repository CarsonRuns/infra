@RestResource(urlMapping='/p360mobility/PartnerNotes/*')
global class P360_Mobility_Partner_Notes{

    public static String test_type = '';
    public static String test_lead_id = '00Q8000000udWO1EAM';
    public static String test_tp_id = 'a1i800000009pvi';

    @HttpGet
//    global static ReturnClass  getPSRUsers(String off, String lm, String id, String objtype){
    global static ReturnClass  getNotes(){
        String lm = RestContext.request.params.get('limit');
        String id = RestContext.request.params.get('id');
        String objtype = RestContext.request.params.get('type');
        
        String theuserid = UserInfo.getUserId();
        system.debug('userid='+theuserid );
        
        if(Test.isRunningTest()){
            theuserid = GenericStaticTestData.gettestAMUserRecord().id;
            lm = '200';
            objtype = test_type;
            if('tp'.equals(test_type)){
                id = GenericStaticTestData.gettestTargetProspectRecord().id;
            }
            else{
                id = GenericStaticTestData.gettesteLeadRecord().id;
            }
        }
        
        Integer lim = Integer.valueOf((lm==null?'200':lm));
                
        List<Note> notes = null;
        Integer totalCount;
        
        User u = [Select u.contact.account.parentId, profileId from user u where u.id = :theuserid];
        String theuserparentacct = u.contact.account.parentId;
        String theuserprofileid = u.profileId;
        
        system.debug('theuserparentacct ='+theuserparentacct );        

        system.debug('objtype='+objtype);        
        if('lead'.equals(objtype)){
            Lead l = [Select Channel_Partner__r.Parent.id from Lead where id = :id];
            String theparentacctid = l.Channel_Partner__r.Parent.id;
            system.debug('theparentacctid ='+theparentacctid );        
                        
            if('00e800000011h7J'.equals(theuserprofileid )){
                if(theparentacctid == null || ''.equals(theparentacctid )){
                      return  new ReturnClass('Success', 'No Assigned Partner', 0, null);        
                }
                if(theparentacctid != theuserparentacct){
                    system.debug('access denied');       
                    return  new ReturnClass('Error', 'access_denied', 0, null); 
                }
            }
            
            notes = [SELECT n.CreatedDate,n.CreatedBy.Name, n.CreatedById, n.LastModifiedBy.Name, n.Id, n.LastModifiedDate,n.LastModifiedById, n.Title,n.Body,n.IsPrivate 
                     FROM Note n 
                     WHERE n.ParentId=:id 
                     AND (n.IsPrivate = false OR n.OwnerId =:theuserid) order by LastModifiedDate desc limit :lim ];

        }
        else if('tp'.equals(objtype)){
            Assigned_Partner__c tp = [SELECT Assigned_Partner__r.Parent.id FROM Assigned_Partner__c where id = :id];
            String theparentacctid = tp.Assigned_Partner__r.Parent.id;
            system.debug('theparentacctid ='+theparentacctid );        
            
            
            if('00e800000011h7J'.equals(theuserprofileid )){
                if(theparentacctid == null || ''.equals(theparentacctid )){
                      return  new ReturnClass('Success', 'No Assigned Partner', 0, null);        
                }
                if(theparentacctid != theuserparentacct){
                    system.debug('access denied');       
                    return  new ReturnClass('Error', 'access_denied', 0, null); 
                }
            }

            notes = [SELECT n.CreatedDate,n.CreatedBy.Name, n.CreatedById, n.LastModifiedBy.Name, n.Id, n.LastModifiedDate,n.LastModifiedById, n.Title,n.Body,n.IsPrivate 
                     FROM Note n 
                     WHERE n.ParentId=:id 
                     AND (n.IsPrivate = false OR n.OwnerId =:theuserid) order by LastModifiedDate desc limit :lim];
                        
        }
        else{
            return  new ReturnClass('Error', 'invalid_request', 0, null);
        }
        
        ReturnClass result = new ReturnClass('Success', 'OK', notes.size(), notes);
        return result ;
    }
    
    global class ReturnClass {
    
        global String success;
        global String message;
        global Integer total;
        global List<Note> records;
        
        global ReturnClass(String success, String message, Integer total, List<Note> records) {
            this.success = success;
            this.message = message;
            this.total = total;
            this.records = records;
        }
    }

   
    @isTest(SeeAllData=true)
    public static void testGetNotes(){
    
        
        RestResponse res = new RestResponse();
        
        System.RestContext.request = new RestRequest();
        RestContext.request.requestURI = '/services/apexrest/p360mobility/PartnerUsers/';
        RestContext.request.addParameter('offset', '0');
        RestContext.request.addParameter('limit', '200');
        RestContext.request.addParameter('id', '00QS0000006SO9F');
        RestContext.request.addParameter('type', 'lead');

        
//        req.requestURI = 'https://cs1.salesforce.com/services/apexrest/SiblingUsers?offset=0';
        
        P360_Mobility_Partner_Notes.test_type = 'tp';
        ReturnClass  results = P360_Mobility_Partner_Notes.getNotes();        
        System.debug('::::results.records is::::'+results.records);
        
        
       System.assertEquals('Success', results.success);        
    }
    
    @isTest(SeeAllData=true)
   public static void testGetNotes2(){
    
        
        RestResponse res = new RestResponse();
        
        System.RestContext.request = new RestRequest();
        RestContext.request.requestURI = '/services/apexrest/p360mobility/PartnerUsers/';
        RestContext.request.addParameter('offset', '0');
        RestContext.request.addParameter('limit', '200');
        RestContext.request.addParameter('id', '00QS0000006SO9F');
        RestContext.request.addParameter('type', 'lead');

        
//        req.requestURI = 'https://cs1.salesforce.com/services/apexrest/SiblingUsers?offset=0';        
        
        P360_Mobility_Partner_Notes.test_type = 'lead';
        ReturnClass results = P360_Mobility_Partner_Notes.getNotes();        
        System.debug('::::results.records is::::'+results.records);
        
        System.assertEquals('Success', results.success);        
    }
        
    


}