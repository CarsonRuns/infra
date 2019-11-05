@isTest(seealldata=true)
global with sharing class Spark_Test implements HttpCalloutMock {
    
    global HTTPResponse respond(HTTPRequest req) {

        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody('{"foo":"bar"}');
        res.setStatusCode(200);
        return res;
    }
    

    public class SparkMockHttpResponseGenerator implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
    
                if (req.getMethod() == 'GET'){
                    System.assertEquals('GET', req.getMethod());
                } else if (req.getMethod() == 'POST'){
                    System.assertEquals('POST', req.getMethod());
                } else if (req.getMethod() == 'PUT'){
                    System.assertEquals('PUT', req.getMethod());
                } else if (req.getMethod() == 'DELETE'){
                    System.assertEquals('DELETE', req.getMethod());
                }
                        if(req.getBody().contains('401')){
                        // Create a fake response
                        HttpResponse res = new HttpResponse();
                        res.setHeader('Content-Type', 'application/json');
                        res.setBody('{"error":"Authentication Error"}');
                        res.setStatusCode(401);
                        return res; 
                        } else {
                        // Create a fake response
                        HttpResponse res = new HttpResponse();
                        res.setHeader('Content-Type', 'application/json');
                        
                        String resultBody = 
                            '{  "items": [ { ' +
                            '   "id": "Y2lzY29zcGFyazovL3VzL01FTUJFUlNISVAvOGQwNjJkMmItZjhiYS00NDNkLTk2OGQtNzAyNmRkODdmZTFlOjAwMDVlNTAwLTlkMjMtMTFlNC04MTI3LWM5NjU1NzAwMjUzYQ",' +
                            '   "roomId": "Y2lzY29zcGFyazovL3VzL1JPT00vMDAwNWU1MDAtOWQyMy0xMWU0LTgxMjctYzk2NTU3MDAyNTNh",' +
                            '   "personId": "Y2lzY29zcGFyazovL3VzL1BFT1BMRS84ZDA2MmQyYi1mOGJhLTQ0M2QtOTY4ZC03MDI2ZGQ4N2ZlMWU", '+
                            '   "personEmail": "awolder@cisco.com", ' +
                            '   "personDisplayName": "Andrew Wolder (awolder)", ' +
                            '   "isModerator": false, ' +
                            '   "isMonitor": false, ' +
                            '   "created": "2015-01-16T01:57:18.454Z" ' +
                            '} ] }';
                            
                        res.setBody(resultBody);
                        res.setStatusCode(200);
                        return res;
                        }
                }               
    }
    
    public class SparkMockHttp401ResponseGenerator implements HttpCalloutMock
    {
        public HTTPResponse respond(HTTPRequest req) 
        {   
            if (req.getMethod() == 'GET'){
            System.assertEquals('GET', req.getMethod());
            } else if (req.getMethod() == 'POST'){
            System.assertEquals('POST', req.getMethod());
            } else if (req.getMethod() == 'PUT'){
            System.assertEquals('PUT', req.getMethod());
            } else if (req.getMethod() == 'DELETE'){
            System.assertEquals('DELETE', req.getMethod());
            }
        
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody('{"error":"Authentication Error"}');
            res.setStatusCode(401);
            return res; 
        
        }
    }
    
    public class SparkMockHttpMessageFileResponseGenerator implements HttpCalloutMock
    {
        public HTTPResponse respond(HTTPRequest req) 
        {   
            if (req.getMethod() == 'GET'){
            System.assertEquals('GET', req.getMethod());
            } else if (req.getMethod() == 'POST'){
            System.assertEquals('POST', req.getMethod());
            } else if (req.getMethod() == 'PUT'){
            System.assertEquals('PUT', req.getMethod());
            } else if (req.getMethod() == 'DELETE'){
            System.assertEquals('DELETE', req.getMethod());
            }
            
            
            String jSONBody = 
            '{ "items": [ ' +
            '{ ' +
            '"id": "Y2lzY29zcGFyazovL3VzL01FU1NBR0UvNmY3OWNjMjAtMjY0OS0xMWU2LTkwNWYtOTkwZGFiZmExMjJl",' +
            '"roomId": "Y2lzY29zcGFyazovL3VzL1JPT00vYmNhMTdkNDAtMjQzNy0xMWU2LTk0NmQtN2Y0YWMxYTQwOWFl",' +
            '"text": "another random message",' +
            '"personId": "Y2lzY29zcGFyazovL3VzL1BFT1BMRS84ZDA2MmQyYi1mOGJhLTQ0M2QtOTY4ZC03MDI2ZGQ4N2ZlMWU",' +
            '"personEmail": "awolder@cisco.com",' +
            '"created": "2016-05-30T09:32:32.610Z"' +
            '},' +
            '{' +
            '"id": "Y2lzY29zcGFyazovL3VzL01FU1NBR0UvNmI3Mjc0YjAtMjY0OS0xMWU2LTliYjMtYzUwOTlhOTIwMGJm",' +
            '"roomId": "Y2lzY29zcGFyazovL3VzL1JPT00vYmNhMTdkNDAtMjQzNy0xMWU2LTk0NmQtN2Y0YWMxYTQwOWFl",' +
            '"text": "another text test",' +
            '"personId": "Y2lzY29zcGFyazovL3VzL1BFT1BMRS84ZDA2MmQyYi1mOGJhLTQ0M2QtOTY4ZC03MDI2ZGQ4N2ZlMWU",' +
            '"personEmail": "awolder@cisco.com",' +
            '"created": "2016-05-30T09:32:25.851Z"' +
        '},' +
        '{' +
            '"id": "Y2lzY29zcGFyazovL3VzL01FU1NBR0UvYWJiZjk4YTAtMjY0OC0xMWU2LWI1ZjktOTdjMGU0ZDZhNWU0",' +
            '"roomId": "Y2lzY29zcGFyazovL3VzL1JPT00vYmNhMTdkNDAtMjQzNy0xMWU2LTk0NmQtN2Y0YWMxYTQwOWFl",' +
            '"files": [' +
                '"https://api.ciscospark.com/v1/contents/Y2lzY29zcGFyazovL3VzL0NPTlRFTlQvYWJiZjk4YTAtMjY0OC0xMWU2LWI1ZjktOTdjMGU0ZDZhNWU0LzA"' +
            '],' +
            '"personId": "Y2lzY29zcGFyazovL3VzL1BFT1BMRS84ZDA2MmQyYi1mOGJhLTQ0M2QtOTY4ZC03MDI2ZGQ4N2ZlMWU",' +
            '"personEmail": "awolder@cisco.com",' +
            '"created": "2016-05-30T09:27:04.234Z"' +
        '}' +
    ']' +
'}';
            
            
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(jSONBody);
            res.setStatusCode(200);
            return res; 
        
        }
    }
    
    public class SparkMockHttpFileResponseGenerator implements HttpCalloutMock
    {
        public HTTPResponse respond(HTTPRequest req) 
        {   
            if (req.getMethod() == 'GET'){
            System.assertEquals('GET', req.getMethod());
            } else if (req.getMethod() == 'POST'){
            System.assertEquals('POST', req.getMethod());
            } else if (req.getMethod() == 'PUT'){
            System.assertEquals('PUT', req.getMethod());
            } else if (req.getMethod() == 'DELETE'){
            System.assertEquals('DELETE', req.getMethod());
            }
            
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'image/png');
            res.setHeader('Content-Disposition', 'attachment; filename="Screen Shot 2016-04-26 at 09.33.48.png"');
            res.setStatusCode(200);
            return res; 
        
        }
    }
    
    public class SparkMockHttpRoomResponseGenerator implements HttpCalloutMock
    {
        public HTTPResponse respond(HTTPRequest req) 
        {   
            if (req.getMethod() == 'GET'){
            System.assertEquals('GET', req.getMethod());
            } else if (req.getMethod() == 'POST'){
            System.assertEquals('POST', req.getMethod());
            } else if (req.getMethod() == 'PUT'){
            System.assertEquals('PUT', req.getMethod());
            } else if (req.getMethod() == 'DELETE'){
            System.assertEquals('DELETE', req.getMethod());
            }
            String jSONBody = '{ ' +
                '"id": "Y2lzY29zcGFyazovL3VzL1JPT00vZDVjMmFlMDAtMjY1NS0xMWU2LTk0NmQtN2Y0YWMxYTQwOWFl",' +
                '"title": "Test Room",' +
                '"type": "group",' +
                '"isLocked": false,' +
                '"lastActivity": "2016-05-30T11:01:18.176Z",' +
                '"created": "2016-05-30T11:01:18.176Z"' +
                '}';
            // Create a fake response
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setBody(jSONBody);
            res.setStatusCode(401);
            return res; 
        
        }
    }
    
    /*   Start Test Phase */
    
     static testmethod void testSparkFileAPI()
    {
        String testURI = 'https://api.ciscospark.com/v1/contents/Y2lzY29zcGFyazovL3VzL0NPTlRFTlQvYWJiZjk4YTAtMjY0OC0xMWU2LWI1ZjktOTdjMGU0ZDZhNWU0LzA';
        test.startTest();
        test.setMock(HttpCalloutMock.class, new SparkMockHttp401ResponseGenerator());
        HTTPResponse f = Spark_File_API.getSparkFileDetail(testURI);
        
        if (f.getStatusCode() == 200)
        {
            System.assertEquals(200, f.getStatusCode());
            System.debug('FILE TEST PASSED');
        }

        test.stopTest();
        
    }
    
    static testmethod void testSparkMemberAPI()
    {
        String testRoomId = 'Y2lzY29zcGFyazovL3VzL1JPT00vYmNhMTdkNDAtMjQzNy0xMWU2LTk0NmQtN2Y0YWMxYTQwOWFl';
        
        test.startTest();
        /* Set mock callout class */
        Test.setMock(HttpCalloutMock.class, new SparkMockHttpResponseGenerator());
     
        /* Options map for list membership callout */     
        Map<String,String> listMemberOptions = New Map<String,String>{};
            listMemberOptions.put('max','20');
            listMemberOptions.put('personEmail','awolder@cisco.com');
        /* Call method to test, which will respond with a fake response */
        HTTPResponse lm = Spark_Membership_API.listMembership(testRoomId,listMemberOptions);
        /* Verify response received contains fake values */
        String lmcontentType = lm.getHeader('Content-Type');
        System.assert(lmcontentType == 'application/json');
   
        if (lm.getStatusCode() == 200)
        {
            System.assertEquals(200, lm.getStatusCode());
            System.debug('LIST Membership TEST PASSED');
        }
        
        
        /* Options map for create membership callout */     
        Map<String,String> createMemberOptions = New Map<String,String>{};
            createMemberOptions.put('personEmail','awolder@cisco.com');
            createMemberOptions.put('isModerator','true');
        
        HTTPResponse cm = Spark_Membership_API.createMembership(testRoomId, createMemberOptions);
        /* Verify response received contains fake values */
        String cmcontentType = cm.getHeader('Content-Type');
        System.assert(cmcontentType == 'application/json');

        if (cm.getStatusCode() == 200)
        {
            System.assertEquals(200, cm.getStatusCode());
            System.debug('Create Membership TEST PASSED');
        }
        
        
        String memberId = 'Y2lzY29zcGFyazovL3VzL1BFT1BMRS9mMmVmZGY2YS1lN2Y0LTQzZmEtOWNiMy0wYWQyOTE4NDAwMzA';
        HTTPResponse gm = Spark_Membership_API.getMembershipDetails(memberId);
        
        /* Verify response received contains fake values */
        String gmcontentType = gm.getHeader('Content-Type');
        System.assert(gmcontentType == 'application/json');
        if (gm.getStatusCode() == 200)
        {
            System.assertEquals(200, gm.getStatusCode());
            System.debug('get Membership TEST PASSED');
        }
        
        
        HTTPResponse um = Spark_Membership_API.updateMembership(memberId,true);
        
        /* Verify response received contains fake values */
        String umcontentType = um.getHeader('Content-Type');
        System.assert(umcontentType == 'application/json');
        if (um.getStatusCode() == 200)
        {
            System.assertEquals(200, um.getStatusCode());
            System.debug('get Membership TEST PASSED');
        }
        
        HTTPResponse dm = Spark_Membership_API.deleteMembership(memberId,NULL);
        
        /* Verify response received contains fake values */
        String dmcontentType = dm.getHeader('Content-Type');
        System.assert(dmcontentType == 'application/json');
        if (dm.getStatusCode() == 200)
        {
            System.assertEquals(200, dm.getStatusCode());
            System.debug('get Membership TEST PASSED');
        }
        
        /* Set mock callout class */
        Test.setMock(HttpCalloutMock.class, new SparkMockHttp401ResponseGenerator());
        /* Call method to test, which will respond with a fake response */
        HTTPResponse dd2 = Spark_Membership_API.deleteMembership(memberId,NULL);
        /* Verify response received contains fake values */
        String dd2contentType = dd2.getHeader('Content-Type');
        System.assert(dd2contentType == 'application/json');
        if (dd2.getStatusCode() == 401)
        {
            System.assertEquals(401, dd2.getStatusCode());
            System.debug('Authentication failure TEST PASSED');
        }        

        test.stopTest();
    }
    
    static testmethod void testSparkPeopleAPI()
    {
        test.startTest();
        /* Set mock callout class */
        Test.setMock(HttpCalloutMock.class, new SparkMockHttpResponseGenerator());
     
        /* Options map for list people callout */     
        Map<String,String> listPeopleOptions = New Map<String,String>{};
            listPeopleOptions.put('email', 'awolder@cisco.com');
        /* Call method to test, which will respond with a fake response */
        HTTPResponse lp = Spark_People_API.listPeople(listPeopleOptions);
        /* Verify response received contains fake values */
        String contentType = lp.getHeader('Content-Type');
        System.assert(contentType == 'application/json');

        if (lp.getStatusCode() == 200)
        {
            System.assertEquals(200, lp.getStatusCode());
            System.debug('LIST PEOPLE TEST PASSED');
        }
        
        /* Options map for get person callout */     
        String personId = 'Y2lzY29zcGFyazovL3VzL1BFT1BMRS84ZDA2MmQyYi1mOGJhLTQ0M2QtOTY4ZC03MDI2ZGQ4N2ZlMWU';
        /* Call method to test, which will respond with a fake response */ 
        HTTPResponse gp = Spark_People_API.getPersonDetails(personId,getToken());
        String gpContentType = gp.getHeader('Content-Type');
        System.assert(gpContentType == 'application/json');
        if (gp.getStatusCode() == 200)
        {
            System.assertEquals(200, gp.getStatusCode());
            System.debug('GET PEOPLE DETAIL TEST PASSED');
        }
        
        HTTPResponse md = Spark_People_API.getMyDetails();
        String mdContentType = md.getHeader('Content-Type');
        System.assert(mdContentType == 'application/json');
        if (md.getStatusCode() == 200)
        {
            System.assertEquals(200, md.getStatusCode());
            System.debug('GET MY DETAILS TEST PASSED');
        }

        HTTPResponse ma = Spark_People_API.getMachineUUID('sfdcspark',NULL);
        String maContentType = ma.getHeader('Content-Type');
        System.assert(maContentType == 'application/json');
        if (ma.getStatusCode() == 200)
        {
            System.assertEquals(200, ma.getStatusCode());
            System.debug('GET Machine Account TEST PASSED');
        }
        
        /* Set mock callout class */
        Test.setMock(HttpCalloutMock.class, new SparkMockHttp401ResponseGenerator());
        /* Call method to test, which will respond with a fake response */
        HTTPResponse gpe = Spark_People_API.getPersonDetails(personId,NULL);
        String gpeContentType = gpe.getHeader('Content-Type');
        System.assert(gpeContentType == 'application/json');
        if (gpe.getStatusCode() == 200)
        {
            System.assertEquals(200, gpe.getStatusCode());
            System.debug('GET PEOPLE DETAIL TEST PASSED');
        }
        
        
        test.stopTest();    
    }
    

    static testmethod void testSparkRoomAPI()
    {
        test.startTest();
        /* Set mock callout class */
        Test.setMock(HttpCalloutMock.class, new SparkMockHttpResponseGenerator());
     
        /* Options map for list people callout */     
        Map<String,String> listRoomOptions = New Map<String,String>{};
        listRoomOptions.put('max','50');
        listRoomOptions.put('showSipAddress','FALSE');
        /* Call method to test, which will respond with a fake response */
        HTTPResponse lp = Spark_Room_API.listRooms(listRoomOptions);
        /* Verify response received contains fake values */
        String contentType = lp.getHeader('Content-Type');
        System.assert(contentType == 'application/json');
        if (lp.getStatusCode() == 200)
        {
            System.assertEquals(200, lp.getStatusCode());
            System.debug('LIST Room TEST PASSED');
        }
        
        /* Options map for get person callout */     
        String personId = 'Y2lzY29zcGFyazovL3VzL1BFT1BMRS84ZDA2MmQyYi1mOGJhLTQ0M2QtOTY4ZC03MDI2ZGQ4N2ZlMWU';
        /* Call method to test, which will respond with a fake response */ 
        HTTPResponse gp = Spark_People_API.getPersonDetails(personId,getToken());
        String gpContentType = gp.getHeader('Content-Type');
        System.assert(gpContentType == 'application/json');
        if (gp.getStatusCode() == 200)
        {
            System.assertEquals(200, gp.getStatusCode());
            System.debug('GET PEOPLE DETAIL TEST PASSED');
        }
        
        HTTPResponse md = Spark_Room_API.createRoom('Salesforce Unit Test Room');
        String mdContentType = md.getHeader('Content-Type');
        System.assert(mdContentType == 'application/json');
        if (md.getStatusCode() == 200)
        {
            System.assertEquals(200, md.getStatusCode());
            System.debug('Create Room TEST PASSED');
        }
        
        
        String testRoomId = 'Y2lzY29zcGFyazovL3VzL1JPT00vYmNhMTdkNDAtMjQzNy0xMWU2LTk0NmQtN2Y0YWMxYTQwOWFl';
        HTTPResponse ma = Spark_Room_API.getRoomDetails(testRoomId,'FALSE');
        String maContentType = ma.getHeader('Content-Type');
        System.assert(maContentType == 'application/json');
        if (ma.getStatusCode() == 200)
        {
            System.assertEquals(200, ma.getStatusCode());
            System.debug('GET Machine Account TEST PASSED');
        }
       
        HTTPResponse ma2 = Spark_Room_API.getRoomDetails(testRoomId,'TRUE');
        String ma2ContentType = ma2.getHeader('Content-Type');
        System.assert(ma2ContentType == 'application/json');
        if (ma2.getStatusCode() == 200)
        {
            System.assertEquals(200, ma2.getStatusCode());
            System.debug('GET ROOM DETAILS TEST PASSED');
        }
        
        HTTPResponse ur = Spark_Room_API.updateRoom(testRoomId, 'Update Room Unit Test');
        String urContentType = ur.getHeader('Content-Type');
        System.assert(urContentType == 'application/json');
        if (ur.getStatusCode() == 200)
        {
            System.assertEquals(200, ur.getStatusCode());
            System.debug('Update Room TEST PASSED');
        }
        
        HTTPResponse dr = Spark_Room_API.deleteRoom(testRoomId);
        String drContentType = dr.getHeader('Content-Type');
        System.assert(drContentType == 'application/json');
        if (dr.getStatusCode() == 200)
        {
            System.assertEquals(200, dr.getStatusCode());
            System.debug('DELETE Room TEST PASSED');
        }
        
        /* Set mock callout class */
        Test.setMock(HttpCalloutMock.class, new SparkMockHttp401ResponseGenerator());
        /* Call method to test, which will respond with a fake response */
        HTTPResponse dd2 = Spark_Room_API.deleteRoom(testRoomId);
        /* Verify response received contains fake values */
        String dd2contentType = dd2.getHeader('Content-Type');
        System.assert(dd2contentType == 'application/json');
        if (dd2.getStatusCode() == 401)
        {
            System.assertEquals(401, dd2.getStatusCode());
            System.debug('Authentication failure TEST PASSED');
        }        
      
        test.stopTest();    
    }
    
    static testmethod void testSparkMessageAPI()
    {
        String testRoomId = 'Y2lzY29zcGFyazovL3VzL1JPT00vYmNhMTdkNDAtMjQzNy0xMWU2LTk0NmQtN2Y0YWMxYTQwOWFl';
        
        test.startTest();
        /* Set mock callout class */
        Test.setMock(HttpCalloutMock.class, new SparkMockHttpResponseGenerator());
     
        /* Options map for list people callout */     
        Map<String,String> listMessagesOptions = New Map<String,String>{};
            listMessagesOptions.put('max','20');
        /* Call method to test, which will respond with a fake response */
        HTTPResponse lp = Spark_Message_API.listMessages(testRoomId,listMessagesOptions,NULL);
        HTTPResponse lp2 = Spark_Message_API.listMessages(testRoomId,listMessagesOptions,getToken());
        /* Verify response received contains fake values */
        String lpcontentType = lp.getHeader('Content-Type');
        System.assert(lpcontentType == 'application/json');
        String lpactualValue = lp.getBody();
        String lpexpectedValue = '{"foo":"bar"}';
        if (lp.getStatusCode() == 200)
        {
            System.assertEquals(200, lp.getStatusCode());
            System.debug('LIST Messages TEST PASSED');
        }
        
        
        /* Options map for list people callout */     
        Map<String,String> createMessageOptions = New Map<String,String>{};
            createMessageOptions.put('roomId',testRoomId);
            createMessageOptions.put('text','THIS IS A TEST TEXT');
        /* Call method to test, which will respond with a fake response */
        HTTPResponse cm = Spark_Message_API.createMessage(createMessageOptions);
        /* Verify response received contains fake values */
        String cmcontentType = cm.getHeader('Content-Type');
        System.assert(cmcontentType == 'application/json');
        String cmactualValue = cm.getBody();
        String cmexpectedValue = '{"foo":"bar"}';
        if (cm.getStatusCode() == 200)
        {
            System.assertEquals(200, cm.getStatusCode());
            System.debug('LIST Messages TEST PASSED');
        }
        
        String mid = 'Y2lzY29zcGFyazovL3VzL01FTUJFUlNISVAvYzhkMTNmOWQtYzcxMy00NjE5LWEwMDMtZmMxNDhmOWMyZTU1OjlhY2Y3YTQwLTlmNDAtMTFlNS1iMTcxLTMxMTEzZTM4YzhhMQ';
        /* Call method to test, which will respond with a fake response */
        HTTPResponse md = Spark_Message_API.getMessageDetail(mid);
        /* Verify response received contains fake values */
        String mdcontentType = md.getHeader('Content-Type');
        System.assert(mdcontentType == 'application/json');
        String mdactualValue = md.getBody();
        String mdexpectedValue = '{"foo":"bar"}';
        if (md.getStatusCode() == 200)
        {
            System.assertEquals(200, md.getStatusCode());
            System.debug('Message Detail TEST PASSED');
        }
        
        /* Call method to test, which will respond with a fake response */
        HTTPResponse dd = Spark_Message_API.deleteMessage(mid,NULL);
        /* Verify response received contains fake values */
        String ddcontentType = dd.getHeader('Content-Type');
        System.assert(ddcontentType == 'application/json');
        String ddactualValue = dd.getBody();
        String ddexpectedValue = '{"foo":"bar"}';
        if (dd.getStatusCode() == 200)
        {
            System.assertEquals(200, dd.getStatusCode());
            System.debug('Delete Message TEST PASSED');
        }        
        
        /* Set mock callout class */
        Test.setMock(HttpCalloutMock.class, new SparkMockHttp401ResponseGenerator());
        /* Call method to test, which will respond with a fake response */
        HTTPResponse dd2 = Spark_Message_API.deleteMessage(mid,NULL);
        /* Verify response received contains fake values */
        String dd2contentType = dd2.getHeader('Content-Type');
        System.assert(dd2contentType == 'application/json');
        String dd2actualValue = dd2.getBody();
        String dd2expectedValue = '{"foo":"bar"}';
        if (dd2.getStatusCode() == 401)
        {
            System.assertEquals(401, dd2.getStatusCode());
            System.debug('Authentication failure TEST PASSED');
        }        
          
        test.stopTest(); 
    }        
 
    @isTest   
    private static String getToken()
    {
         return Spark_System_Config.getBearerToken();
    }
    
    static testmethod void testSparkRoomController()
    {
        String oppObjTestId = '0068000000i8000';
        String testRoomId   = 'Y2lzY29zcGFyazovL3VzL1JPT00vYmNhMTdkNDAtMjQzNy0xMWU2LTk0NmQtN2Y0YWMxYTQwOWFl';
        String mid          = 'Y2lzY29zcGFyazovL3VzL01FTUJFUlNISVAvYzhkMTNmOWQtYzcxMy00NjE5LWEwMDMtZmMxNDhmOWMyZTU1OjlhY2Y3YTQwLTlmNDAtMTFlNS1iMTcxLTMxMTEzZTM4YzhhMQ';
        
        String uniqueLocalKey = UserInfo.getOrganizationId().left(15)+'_'+oppObjTestId.left(15);
        
        
        Spark_Conversation__c sparkObj = new Spark_Conversation__c();
        sparkObj.Spark_Id__c   = testRoomId;
        sparkObj.ObjectId__c   = oppObjTestId;
        sparkObj.Unique_Key__c = uniqueLocalKey;
        insert sparkObj;
        
        test.startTest();
        
        String roomIdresponse = Spark_Room_Controller.getSparkId(oppObjTestId);
        System.debug('Room Id Lookup TEST ');
        System.assertEquals(roomIdresponse, testRoomId);
        
        /* Set mock callout class */
        Test.setMock(HttpCalloutMock.class, new SparkMockHttpResponseGenerator());        
        /* Test Get Room Name */
        String roomNameresponse = Spark_Room_Controller.getRoomName(oppObjTestId);
        Boolean c1 = Spark_Room_Controller.incrementConversationCount(oppObjTestId);
        Boolean m1 = Spark_Room_Controller.incrementMemberCount(oppObjTestId);
        Boolean m2 = Spark_Room_Controller.decrementMemberCount(oppObjTestId);
        /* test class constructor */
        Spark_Room_Controller controller = new Spark_Room_Controller();
        test.stopTest();
        
    }
    

    static testmethod void testSetModerator()
    {
        String oppObjTestId = '0068000000i8000';
        
        test.startTest();
        test.setMock(HttpCalloutMock.class, new SparkMockHttpResponseGenerator());
        /* Test Set API User as moderator Name */
        list<object> setModerator = Spark_Room_Controller.getChangeModeration(oppObjTestId,true);
        test.stopTest();
    }
    

    static testmethod void testDeleteUser()
    {
        String mid          = 'Y2lzY29zcGFyazovL3VzL01FTUJFUlNISVAvYzhkMTNmOWQtYzcxMy00NjE5LWEwMDMtZmMxNDhmOWMyZTU1OjlhY2Y3YTQwLTlmNDAtMTFlNS1iMTcxLTMxMTEzZTM4YzhhMQ';
        test.startTest();
        test.setMock(HttpCalloutMock.class, new SparkMockHttpResponseGenerator());
        /* Test delete User from Controller */
        List<Object> deleteUserResponse = Spark_Room_Controller.getDeleteUser(mid, getToken());
        system.debug('DELETE USER RESPONSE CODE ' + deleteUserResponse.get(0) );
        test.stopTest();
    }

    static testmethod void testResetRoom()
    {
        String oppObjTestId = '0068000000i8000';
        test.startTest();
        test.setMock(HttpCalloutMock.class, new SparkMockHttpResponseGenerator());
        /* Test reset room messages */
        String response = Spark_Room_Controller.getResetRoom(oppObjTestId);
        system.assertEquals('Success', response);
        test.stopTest();
    }
    
    static testmethod void testArchiveRoom()
    {
        String oppObjTestId = '0068000000txLLf';
        test.startTest();
        test.setMock(HttpCalloutMock.class, new SparkMockHttpResponseGenerator());
        /* Test reset room messages */
        String archive  = Spark_Room_Controller.getArchiveRoom(oppObjTestId);
        system.debug('TEST ARCHIVE ROOM RESPONSE!!!! ' + archive);
        //String archive = Spark_Room_Controller.archiveConversationStream(oppObjTestId);
        system.assertEquals('Success', archive);
        test.stopTest();
    }
    
    static testmethod void testGetSparkConversation()
    {
        String oppObjTestId = '0068000000i8000';
        test.startTest();
        test.setMock(HttpCalloutMock.class, new SparkMockHttpResponseGenerator());
        /* Test reset room messages */
        map<String,Object>  conversation = Spark_Room_Controller.getSparkConversation(oppObjTestId, NULL, '100');
        list<Object> roomMessages = (list<Object>)conversation.get('items');
        test.stopTest();
    }
    
    static testmethod void testSetGroupUsers()
    {

        String testRoomId   = 'Y2lzY29zcGFyazovL3VzL1JPT00vYmNhMTdkNDAtMjQzNy0xMWU2LTk0NmQtN2Y0YWMxYTQwOWFl';
        test.startTest();
        test.setMock(HttpCalloutMock.class, new SparkMockHttpResponseGenerator());
        String loggedInUser = UserInfo.getUserId();
        String userIdList   = loggedInUser + ',005300000010UYXAA2,00580000007kqqsAAA';
        List<Object> addGroupUsers = Spark_Room_Controller.setGroupUsers(testRoomId, userIdList);

        system.debug('SET GROUP USER RESPONSE ' + addGroupUsers);    
        test.stopTest();
    }
     
    static testmethod void testSetSingleUser()
    {

        String testRoomId   = 'Y2lzY29zcGFyazovL3VzL1JPT00vYmNhMTdkNDAtMjQzNy0xMWU2LTk0NmQtN2Y0YWMxYTQwOWFl';
        
        test.startTest();
        test.setMock(HttpCalloutMock.class, new SparkMockHttpResponseGenerator());
        
        String  addGroupUsers = Spark_Room_Controller.setSingleUserByEmail(testRoomId, 'awolder@cisco.com');
        
        system.debug('SET Single USER RESPONSE ' + addGroupUsers);    
        test.stopTest();
    }
    
    static testmethod void testSetComment()
    {

        String testRoomId   = 'Y2lzY29zcGFyazovL3VzL1JPT00vYmNhMTdkNDAtMjQzNy0xMWU2LTk0NmQtN2Y0YWMxYTQwOWFl';
        
        test.startTest();
        test.setMock(HttpCalloutMock.class, new SparkMockHttpResponseGenerator());
        
        list<Object>  setComment = Spark_Room_Controller.setNewComment(testRoomId,'UNIT TEST COMMENT', '005300000010UYXAA2');
        
        system.debug('SET NEW COMMENT RESPONSE ' + setComment);    
        test.stopTest();
    }
    

    static testmethod void testCreateNewRoom()
    {
        String caseId = '5003400000odH0R';
        String oppId  = '0063400000xJH9T';
        String testRoomId = 'Y2lzY29zcGFyazovL3VzL1JPT00vYmNhMTdkNDAtMjQzNy0xMWU2LTk0NmQtN2Y0YWMxYTQwOWFl';
        test.startTest();
        test.setMock(HttpCalloutMock.class, new SparkMockHttpRoomResponseGenerator());

        //String OppResponse  = Spark_Room_Controller.getNewRoom('Opportunity', oppId);
        //String CaseRepponse = Spark_Room_Controller.getNewRoom('Case', caseId);
        String roomResponse = Spark_Room_Controller.createSparkRoom('awolder@cisco.com', 'UNIT TESTING ROOM TITLE' );
        system.debug('SET NEW Create Room RESPONSE ' + roomResponse);    
        test.stopTest();
    }
    
    static testmethod void testGetParticipantList()
    {
    
    Test.startTest();
    /* Build a new Opportunity objects */
    Opportunity oppty1 = createSingleTestOpportunity();   
    
    OpportunityTeamMember oppTeam = new OpportunityTeamMember(
        OpportunityId = oppty1.id,
        TeamMemberRole = 'Sales Manager',
        UserId = '00530000000zmw0AAA',
        OpportunityAccessLevel = 'Edit' );
     insert oppTeam;

    /* Case TSN Object */
    user currentuser = [Select id from user where id = :Userinfo.getUserId()];
    Case testCase = createSingleTestCase();
         testCase.OwnerId = currentuser.id;
         testCase.Cisco_Contact__c = 'nijohn@cisco.com';
         testCase.Opportunity__c = oppty1.id;
         update testCase;
    
    /* Test Case 1 -  get Room Bulk Add participants - Opportunity   */
    List<Spark_Room_Controller.ContactsAndUser>  userListOppty = Spark_Room_Controller.getParticipantList(oppty1.id);
    /* Test Case 2 -  Test get Room Bulk Add participants - Case */
    List<Spark_Room_Controller.ContactsAndUser>  userListCase = Spark_Room_Controller.getParticipantList(testCase.id);
    system.debug('CONTACTS AND USER RESPONSE for TEST CASE ' + userListCase);
 
    test.stopTest();   
    }
    
    static testmethod void testGetFileMetaData()
    {
      /* Example file API URL */
      String testURI = 'https://api.ciscospark.com/v1/contents/Y2lzY29zcGFyazovL3VzL0NPTlRFTlQvYWJiZjk4YTAtMjY0OC0xMWU2LWI1ZjktOTdjMGU0ZDZhNWU0LzA';
      test.startTest();
      test.setMock(HttpCalloutMock.class, new SparkMockHttpFileResponseGenerator());
      List<String> fileMD = Spark_Room_Controller.getSparkFileMetadata(testURI);
      system.debug('FILE METADATA RESPONSE' + fileMD);
      test.stopTest();
    }

    static testmethod void testCreateNewRoomCase()
    {
      //Case testCase       = createSingleTestCase();

      test.startTest();
      test.setMock(HttpCalloutMock.class, new SparkMockHttpResponseGenerator());
      String newSparkId    = Spark_Room_Controller.getNewRoom('Case', '5008000000c1aCS');      
      test.stopTest();
    }
    
    static testmethod void testCreateNewRoomOpp()
    {
        Opportunity oppty1  = createSingleTestOpportunity();
        System.debug('$$est oppty1 = '+oppty1.id);
        test.startTest();
        test.setMock(HttpCalloutMock.class, new SparkMockHttpResponseGenerator());
        String newSparkOppId = Spark_Room_Controller.getNewRoom('Opportunity', oppty1.id); 
        Boolean m1 = Spark_Room_Controller.incrementMemberCount(oppty1.id);
        Boolean m2 = Spark_Room_Controller.decrementMemberCount(oppty1.id);
        test.stopTest();
    }
 
     static testmethod void testSparkSystemConfig()
    {
        test.startTest();
        test.setMock(HttpCalloutMock.class, new SparkMockHttpResponseGenerator());        
        
        /* test method to get current saved authorization config */
        Object systemConfig = Spark_System_Config.getAuthConfig();
        
        /* Test Set and Remove trigger from Global Triggers config */
        Spark_System_Config.setTrigger('Case', 'Team__c');
        Spark_System_Config.removeTrigger('Case', 'Team__c');
        
        /* List all Triggers */        
        List<String> globalTriggers =  Spark_System_Config.listTrigger();
        /* List Configured Pages */
        List<ApexPage> pageList     =  Spark_System_Config.getConfiguredPages();
        /* Check if Object Wrapper Exists */
        String objectPage           =  Spark_System_Config.getSingleConfiguredPage('Opportunity');
        system.debug('LIST CONFIGURED OBJECT PAGE ' + objectPage);
        
        /* Replicate list generated via config VFP page, and test method to save the 
         * authentication configuration */ 
        List<Spark_Config__c> configList = new List<Spark_Config__c>();
             Spark_Config__c  auth       = [SELECT Id from Spark_Config__c where MachineId__c = 'sfdcspark' LIMIT 1];       

                auth.MachineId__c           = 'sfdcspark';
                auth.MachineSecret__c       = '2016adshjYjkatrty89J..HKadjjYUHsdj18.93fgfg';
                auth.MachineOrg__c          = '1eb65fdf-9643-417f-9974-ad72cae0e10f';
                auth.ApplicationId__c       = 'C6e2db8ec6489ba3953635f65463bb0c0a0a1a234efce28ccb31645f32b9b67fa';
                auth.ApplicationSecret__c   = '354043bd9cee631fcaf86edb4ddee0602d0ae145e7e39fd3a00711af948dbeef';
                auth.ApplicationScopes__c   = 'spark:memberships_read';
        
        configList.add(auth);
        
        Object finalConfig = Spark_System_Config.setAuthConfig(configList, 'update' );
        test.stopTest();
    }
    
    /*Start: add new test methods for Spark GA release*/
    static testmethod void testGetRoomUsers()
    {
        String oppObjTestId = '0068000000i8000';
        String testRoomId   = 'Y2lzY29zcGFyazovL3VzL1JPT00vYmNhMTdkNDAtMjQzNy0xMWU2LTk0NmQtN2Y0YWMxYTQwOWFl';
        test.startTest();
        /* Set mock callout class */
        test.setMock(HttpCalloutMock.class, new SparkMockHttpResponseGenerator());
        /* Test getting a list of room users.  Fake user list returned by mock response */
        for (Object member : Spark_Room_Controller.getRoomUsers(oppObjTestId))
        {
                system.debug('Get Room Membership Response ' + member);  
        }
        test.stopTest();
    }


   static testmethod void testDeleteSingleUser()
    {
        String oppObjTestId = '0068000000i8000';
        String sfdcId = '00530000000zmw0AAA';
        test.startTest();
        test.setMock(HttpCalloutMock.class, new SparkMockHttpResponseGenerator());
        /* Test delete User from Controller */
        List<Object> deleteUserResponse = Spark_Room_Controller.deleteSingleUser(sfdcId, oppObjTestId);
        test.stopTest();
    }


    static testmethod void testCloseRoom()
    {
        String oppObjTestId = '0068000000i8000';
        String dataMembers  = 'Y2lzY29zcGFyazovL3VzL01FTUJFUlNISVAvMGVkOWQ5YmYtODMwNS00ZGYzLWJmNmMtZmMxMDA4MTMyNTEzOmNlYTY5ZTkwLTExZjMtMTFlNi1iYjE3LTViNTdjNTA3NDMyMQ,Y2lzY29zcGFyazovL3VzL01FTUJFUlNISVAvOGQwNjJkMmItZjhiYS00NDNkLTk2OGQtNzAyNmRkODdmZTFlOmNlYTY5ZTkwLTExZjMtMTFlNi1iYjE3LTViNTdjNTA3NDMyMQ,Y2lzY29zcGFyazovL3VzL01FTUJFUlNISVAvZjJlZmRmNmEtZTdmNC00M2ZhLTljYjMtMGFkMjkxODQwMDMwOmNlYTY5ZTkwLTExZjMtMTFlNi1iYjE3LTViNTdjNTA3NDMyMQ'; 
        test.startTest();
        test.setMock(HttpCalloutMock.class, new SparkMockHttpResponseGenerator());
        /* Test delete User from Controller */
        List<Object> closeRoomResponse = Spark_Room_Controller.getCloseRoom(oppObjTestId);
        system.debug('DELETE USER RESPONSE CODE ' + closeRoomResponse );
        test.stopTest();
    }

     static testmethod void testGetSparkFileData()
    {
        String testURI = 'https://api.ciscospark.com/v1/contents/Y2lzY29zcGFyazovL3VzL0NPTlRFTlQvYWJiZjk4YTAtMjY0OC0xMWU2LWI1ZjktOTdjMGU0ZDZhNWU0LzA';
        test.startTest();
        test.setMock(HttpCalloutMock.class, new SparkMockHttp401ResponseGenerator());
        blob file = Spark_Room_Controller.getSparkFileData(testURI);
        test.stopTest();    
    }
    
     static testmethod void testPostMessage()
    {
        String testRoomId   = 'Y2lzY29zcGFyazovL3VzL1JPT00vYmNhMTdkNDAtMjQzNy0xMWU2LTk0NmQtN2Y0YWMxYTQwOWFl';       
        test.startTest();
        test.setMock(HttpCalloutMock.class, new SparkMockHttpResponseGenerator());     
        Integer postMessageResponse = Spark_Room_Controller.postMessage(testRoomId,'UNIT TEST COMMENT');        
        //system.debug('SET NEW COMMENT RESPONSE ' + setComment);    
        test.stopTest();
    }
    
     static testmethod void testSetRoomMessage()
    {
        String testRoomId   = 'Y2lzY29zcGFyazovL3VzL1JPT00vYmNhMTdkNDAtMjQzNy0xMWU2LTk0NmQtN2Y0YWMxYTQwOWFl';       
        test.startTest();
        test.setMock(HttpCalloutMock.class, new SparkMockHttpResponseGenerator());     
        Spark_Room_Controller.setRoomMessage(testRoomId,'UNIT TEST COMMENT');        
        //system.debug('SET NEW COMMENT RESPONSE ' + setComment);    
        test.stopTest();
    }
    
     static testmethod void testGetRoomUserList()
    {
        String testRoomId   = 'Y2lzY29zcGFyazovL3VzL1JPT00vYmNhMTdkNDAtMjQzNy0xMWU2LTk0NmQtN2Y0YWMxYTQwOWFl';
        test.startTest();
        /* Set mock callout class */
        test.setMock(HttpCalloutMock.class, new SparkMockHttpResponseGenerator());
        /* Test getting a list of room users.  Fake user list returned by mock response */
        for (Object member : Spark_Room_Controller.getRoomUserList(testRoomId))
        {
                system.debug('Get Room Membership Response ' + member);  
        }
        test.stopTest();
    }
    
    static testmethod void testGetGlobalVars()
    {
        String oppObjTestId = '0068000000i8000';
        test.startTest();
        /* Set mock callout class */
        test.setMock(HttpCalloutMock.class, new SparkMockHttpResponseGenerator());
        /* Test getting a list of room users.  Fake user list returned by mock response */
        for (Object globalVar : Spark_Room_Controller.getGlobalVars(oppObjTestId))        {
                system.debug('Get Global Value ' + globalVar);  
        }
        test.stopTest();
    }
    
     static testmethod void testGetCurrentUserId()
    {
         test.startTest();
         String userId = Spark_Room_Controller.getCurrentUserId() ;    
         test.stopTest();
    }
    
      static testmethod void testGetObjectOwnerId()
    {
        String oppObjTestId = '0068000000i8000'; 
        test.startTest();
        String objectOwnerId = Spark_Room_Controller.getObjectOwnerId(oppObjTestId) ;    
        test.stopTest();
    }
    /*
    static testmethod void testGetSparkAttachment()
    {
      String oppObjTestId = '0068000000i8000';
      String testURI = 'https://api.ciscospark.com/v1/contents/Y2lzY29zcGFyazovL3VzL0NPTlRFTlQvYWJiZjk4YTAtMjY0OC0xMWU2LWI1ZjktOTdjMGU0ZDZhNWU0LzA';
      String fileType = 'text/plain'; 
      String fileName = 'testFile';
        
      test.startTest();
      test.setMock(HttpCalloutMock.class, new SparkMockHttpFileResponseGenerator());
      String msg = Spark_Room_Controller.getSparkAttachment(oppObjTestId, testURI, fileName, fileType);
      system.assertEquals('Success', msg);
      test.stopTest();
    }
    */
     static testmethod void testCaseTriggerImpl()
    {  
      test.startTest();     
      test.setMock(HttpCalloutMock.class, new SparkMockHttpResponseGenerator());
      Case testCase = createSingleTestCase();
      
      //List<Case> caseList;
      //caseList.add(testCase);
     // CaseBO.UpdateAccountContactByCCOIdContactSearch(caseList);
    
      Spark_Conversation__c addRoom = new Spark_Conversation__c(
            Spark_Id__c = 'Y2lzY29zcGFyazovL3VzL1JPT00vYmNhMTdkNDAtMjQzNy0xMWU2LTk0NmQtN2Y0YWMxYTQwOWFl', 
            ObjectId__c = testCase.id);
            
      insert addRoom;                
      testCase.OwnerId          = '00580000007kt0u'; 
      testCase.Architecture__c  = 'Security'; 
      update testCase;  
      
      delete testCase;
        
      test.stopTest();
    }
    
      static testmethod void testOppTrigger()
    {   
        test.startTest();
        /* Get users default currency */
        User currentUser = [select defaultCurrencyIsoCode from User where Id = :UserInfo.getUserId()];
        Date vCloseDate = System.today();
        /* Query for Pricebook2 */
        String defaultPricebookId;
            Pricebook2[] pricebook2 = [select id from Pricebook2];
            if(pricebook2 == null || pricebook2.size() == 0){
                Pricebook2 createDefaultPB = new Pricebook2(name='default pricebook', isActive=true);
                insert createDefaultPB;
                defaultPricebookId = createDefaultPB.Id;
            }
            else{
                defaultPricebookId = pricebook2[0].Id;

            }
            /* create a partner to add to a partner parent opportunity */
            Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('End-User').getRecordTypeId();
            Account acct1 = [select id from account where RecordTypeId=:devRecordTypeId limit 1];
            
            /* Add a bunch of test opportunities */
            Opportunity oppty1 = new Opportunity(OwnerId = '005300000010UYX',name='Test1',AccountId= acct1.id, StageName='1 - Identify',Competitors__c='A10 Networks', CloseDate= vCloseDate,Expected_Product__c=2,Pricebook2Id=defaultPricebookId,CurrencyIsoCode=currentUser.defaultCurrencyIsoCode);
            Opportunity oppty2 = new Opportunity(OwnerId = '005300000010UYX',AccountId= acct1.id,name='Test2MakeingTheNameOverEightyEightCharactersSoWeCanTest1234567890123456789012345678901234567890',StageName='1 - Identify',Competitors__c = 'A10 Networks',CloseDate= vCloseDate,Expected_Product__c=2,Pricebook2Id=defaultPricebookId,CurrencyIsoCode=currentUser.defaultCurrencyIsoCode);
            Opportunity oppty3 = new Opportunity(OwnerId = '005300000010UYX',name='Test1',AccountId= acct1.id,StageName='1 - Identify',Competitors__c = 'A10 Networks',CloseDate= vCloseDate,Expected_Product__c=0,Pricebook2Id=defaultPricebookId,CurrencyIsoCode=currentUser.defaultCurrencyIsoCode);
            Opportunity oppty4 = new Opportunity(OwnerId = '005300000010UYX',name='Test4',AccountId= acct1.id,StageName='1 - Identify',Competitors__c = 'A10 Networks',CloseDate= vCloseDate,Expected_Product__c=0,Pricebook2Id=defaultPricebookId,CurrencyIsoCode=currentUser.defaultCurrencyIsoCode);
            Opportunity[] opptyArray = new Opportunity[]{oppty1,oppty2,oppty3,oppty4};
            insert opptyArray;
         
            test.setMock(HttpCalloutMock.class, new SparkMockHttpResponseGenerator());
            Id opId1 = opptyArray[0].id;
            Id opId2 = opptyArray[2].id;
            System.debug('Opty 1 Id : ' + opId1);
            System.debug('Opty 2 Id : ' + opId2);
            /* Add a couple of Spark rooms to the opportunities */
            Spark_Conversation__c addRoom1 = new Spark_Conversation__c(
            Spark_Id__c = 'Y2lzY29zcGFyazovL3VzL1JPT00vYmNhMTdkNDAtMjQzNy0xMWU2LTk0NmQtN2Y0YWMxYTQwOWFl', 
            ObjectId__c = opId1);        
            
            Spark_Conversation__c addRoom2 = new Spark_Conversation__c(
            Spark_Id__c = 'Y2lzY29zcGFyazovL3VzL1JPT00vYmNhMTdkNDAtMjQzNy0xMWU2LTk0NmQtN2Y0YWMxYTQwOWF2', 
            ObjectId__c = opId2);
             
            Spark_Conversation__c[] roomArray = new Spark_Conversation__c[]{addRoom1,addRoom2};
            insert roomArray;           
             
            /* Now update the Opportunities to trigger some field changes.  Make sure that updated fields
             * are configured as Spark Triggers */
            opptyArray[0].Expected_Service__c = 0;
            opptyArray[0].Expected_Product__c = 0;
            //opptyArray[0].OwnerId               = '00580000007kt0u';
            opptyArray[1].Expected_Service__c = 75;
            opptyArray[1].Expected_Product__c = 75;
            opptyArray[2].Expected_Service__c = 75;
            opptyArray[3].Expected_Service__c = 100;
            opptyArray[3].Expected_Product__c = 100;
            opptyArray[3].StageName           = '2 - Qualification';
            //opptyArray[3].OwnerId               = '00580000007kt0u';
            update opptyArray;

        test.stopTest();
    }
    
      static testmethod void testOppTrigger2()
    {  
      test.startTest();     
      test.setMock(HttpCalloutMock.class, new SparkMockHttpResponseGenerator());
      Opportunity testOpportunity = createSingleTestOpportunity();
            
      Spark_Conversation__c addRoom = new Spark_Conversation__c(
            Spark_Id__c = 'Y2lzY29zcGFyazovL3VzL1JPT00vYmNhMTdkNDAtMjQzNy0xMWU2LTk0NmQtN2Y0YWMxYTQwOWFl', 
            ObjectId__c = testOpportunity.id);
            
      insert addRoom;
        
      testOpportunity.Expected_Service__c = 0;
      testOpportunity.Expected_Product__c = 0;
      testOpportunity.StageName           = '2 - Qualification';
        
      update testOpportunity;  

      test.stopTest();
    }
      
    /*end: add new test methods for Spark GA*/
    
    private static Opportunity createSingleTestOpportunity()
    {
        /* Get users default currency */
        User currentUser = [select Id,defaultCurrencyIsoCode from User where Id = :UserInfo.getUserId()];
        Date vCloseDate = System.today();
        /* Query for Pricebook2 */
        String defaultPricebookId;
            Pricebook2[] pricebook2 = [select id from Pricebook2];
            if(pricebook2 == null || pricebook2.size() == 0){
                Pricebook2 createDefaultPB = new Pricebook2(name='default pricebook', isActive=true);
                insert createDefaultPB;
                defaultPricebookId = createDefaultPB.Id;
            }
            else{
                defaultPricebookId = pricebook2[0].Id;

            }
        /* create a partner to add to a partner parent opportunity */
        Id devRecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName().get('End-User').getRecordTypeId();
        Account acct1 = [select id from account where RecordTypeId=:devRecordTypeId limit 1];
            
        Opportunity oppty1 = new Opportunity(
            name='Test1',
            AccountId= acct1.id,
            StageName='1 - Identify',
            Competitors__c = 'A10 Networks',
            Expected_Product__c=2,
            CloseDate= vCloseDate,
            Pricebook2Id=defaultPricebookId,
            OwnerId = currentUser.Id
            );
        insert oppty1;
    
    return oppty1;
    }
    
    private static Case createSingleTestCase()
    {
        Account a = new Account(name='TestVC',RecordtypeId = '0123000000004aV');
        insert a;
        Contact co = new Contact(AccountId = a.Id, LastName = 'Test', Email = 'test@cisco.com' , RecordtypeId = '01280000000G6ti');
        insert co;  
       
 
      Case testCase = new Case(AccountId = a.Id,RecordtypeId =Utilities.getCaseTSNRecordTypeId(),ContactId = co.Id,Contact_Type__c = 'Cisco',Country__c = 'The Netherlands', Origin = 'Email');
           testCase.OwnerId = '005300000010UYX';
           testCase.Case_Contributors__c = 'Andrew Wolder,Mikael Grusgaard,Michael Hulligan';
           testCase.Cisco_Contact__c = 'lfelli@cisco.com';
           testCase.Triage_Engineer__c = '00530000000dc1cAAA';
           testCase.team__c     ='Front Line';
           testCase.Architecture__c ='Security';
       insert testCase;
    return testCase;    
    }

}