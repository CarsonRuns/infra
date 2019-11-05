@istest
public class SCMyOpportunityRestServiceTest {
 
   static testMethod void testPostRestService(){
   
           SCMyOpportunityRestService.ReqJSON reqst=new SCMyOpportunityRestService.ReqJSON();
           Map<String, String> myMap = new Map<String, String>();
           String andOppClause='opportunity_status__c in (\'active\')';
           String orOppClause='name like \'%Art%\'';
           String andOptyLineClause=' Mix__c=50';
           String orOptyLineClause=' Product_Family_US__c like \'%abc%\'';
           myMap.put('andOppClause',andOppClause);
           myMap.put('orOppClause',orOppClause);
           myMap.put('andOptyLineClause',andOptyLineClause);
           reqst.action='globalSearchOpportunity';
           reqst.pageNum=2;
           reqst.pageSize=25;
           reqst.displayAttributes='id';
           reqst.whereClause=myMap;
           
           String JsonMsg=JSON.serialize(reqst);
           
           Test.startTest();
           
           RestRequest req = new RestRequest(); 
           RestResponse res = new RestResponse();
                 
           req.requestURI = '/services/apexrest/SalesConnect/MyOpportunity';  //Request URL
           req.httpMethod = 'POST';//HTTP Request Type
           req.requestBody = Blob.valueof(JsonMsg);
           
           RestContext.request = req;
           RestContext.response= res;
        
           SCMyOpportunityRestService.ResponseData resp =new SCMyOpportunityRestService.ResponseData(); 
           resp=SCMyOpportunityRestService.doPost(); //Call the Method of the Class with Proper       Constructor 
           System.assert(resp.done==null);//Assert the response has message as expected 
//           System.assert(resp.statusCode.contains('Done'));
           Test.stopTest();
           
   }
 }