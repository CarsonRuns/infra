/*
1.Apex Rest Web Service to search for the whole phrase and individual words in Opportunity Object and in the Opportunity Line Item Object 
*/
@RestResource(urlMapping='/SalesConnect/MyOpportunity/*')
global with sharing class SCMyOpportunityRestService {
   @HttpPost
    global static ResponseData doPost() {
        RestRequest req = RestContext.request;
        RestResponse res = RestContext.response;
        // Fetch the json request body and store in string
        String jSONRequestBody=req.requestBody.toString().trim(); 
        //Convert the request body into JSON
        ReqJSON reqBodyObj = (ReqJSON)JSON.deserialize(jSONRequestBody,ReqJSON.class);  
        ResponseData  resp=new ResponseData ();
        if(reqBodyObj.action.equalsIgnoreCase('globalSearchOpportunity'))
        {
         //If the whole phrase has to be searched in the opportunity object
         if(reqBodyObj.whereClause.get('andOppClause')!=null)
         {
         //Setting the offset value for the query based on the pagesize and page number
         Integer offsetValue=(reqBodyObj.pageNum-1)*reqBodyObj.pageSize;
         String andQuery='Select '+reqBodyObj.displayAttributes+' from Opportunity where  opportunity_status__c in (\'active\',\'booked\') and '+reqBodyObj.whereClause.get('andOppClause')+' limit '+reqBodyObj.pageSize+' offset '+offsetValue;
         List<Opportunity> andOpty=Database.query(andQuery);
         resp.records.addAll(andOpty);
         }
         List<String> optyIDs=new List<String>();
         System.debug('The and record size is '+resp.records.size());
         /*if the no. of records received from the search of the whole phrase in opportunity object is less than the pagesize then search
           for the whole phrase in the Opportunity Line Item */
         if(resp.records.size()<reqBodyObj.pageSize)
         {
             //Fetch the opportunity ids from the previous search to not repeat the same opportunity id in the resultset
             List<Opportunity> allIdsAndOpty=new  List<Opportunity>();
             if(reqBodyObj.whereClause.get('andOppClause')!=null)
             {
                 String allIdsAndOptyQuery='Select id from Opportunity where  opportunity_status__c in (\'active\',\'booked\') and '+reqBodyObj.whereClause.get('andOppClause')+' limit 2000';
                 allIdsAndOpty=Database.query(allIdsAndOptyQuery);
                 System.debug('The length of total records is '+ allIdsAndOpty.size());
                 for (Opportunity opportunity : allIdsAndOpty)
                 {
                     optyIDS.add(opportunity.id);
                 }
             }
             Integer limitValue;
             //Search for the whole phrase in the attributes mentioned in the filter by in opportunity line items.
             List<String> optyLineItemIDs=new List<String>();
             if(reqBodyObj.whereClause.get('andOptyLineClause')!=null)
             {
                 limitValue= reqBodyObj.pageSize-resp.records.size();
                 System.debug('limit Value for and opty line items '+limitValue);
                 Integer andOptyLineSearchoffVal=0;
                 //If the size of the previous records is 0 for the particular page number then set the offset.                                                                   
                 if(resp.records.size()==0)          
                 { 
                   andOptyLineSearchoffVal=reqBodyObj.pageSize*(reqBodyObj.pageNum-1)- allIdsAndOpty.size();
                 }
                 System.debug('Offset Value for and opty line items '+andOptyLineSearchoffVal);
                 String andOptyLineQuery;
                 andOptyLineQuery='Select opportunityid from OpportunityLineItem where opportunityid not in:optyIDS and opportunity.opportunity_status__c in (\'active\',\'booked\') and'+reqBodyObj.whereClause.get('andOptyLineClause')+' limit 2000';
                  //andOptyLineQuery='Select opportunityid from OpportunityLineItem where opportunity.opportunity_status__c in (\'active\',\'booked\') and'+reqBodyObj.whereClause.get('andOptyLineClause')+' limit 2000';
                 List<OpportunityLineItem> andOptyLine=Database.query(andOptyLineQuery);
                 for (OpportunityLineItem optylineitem :andOptyLine)
                 {
                     optyLineItemIDs.add(optylineitem.opportunityid);
                     optyIDS.add(optylineitem.opportunityid);
                 }  
                 //For all the opportunity line item matching the search criteria fetch the Opportunity information
                 String fetchAndOptyLineQuery='Select '+reqBodyObj.displayAttributes+' from Opportunity where id in:optyLineItemIDs limit '+limitValue+' offset '+andOptyLineSearchoffVal;
                 List<Opportunity> andOptyLineItemOpty=Database.query(fetchAndOptyLineQuery);
                 resp.records.addAll(andOptyLineItemOpty);
             }
             System.debug('The and optylineitems record size is '+resp.records.size());
             /*if the no. of records received from the search of the whole phrase in opportunity line item object is less than the pagesize then search
               for the individual words in the Opportunity Object */
             if(resp.records.size()<reqBodyObj.pageSize)
             {
                 
                  if(reqBodyObj.whereClause.get('orOppClause')!=null)
                  {
                      limitValue= reqBodyObj.pageSize-resp.records.size();
                      System.debug('limit Value for or opty items '+limitValue);
                      Integer orOptySearchOffVal=0;
                     //If the size of the previous records is 0 for the particular page number then set the offset.                                                  
                      if(resp.records.size()==0)          
                       { 
                      orOptySearchOffVal=reqBodyObj.pageSize*(reqBodyObj.pageNum-1)- allIdsAndOpty.size()-optyLineItemIDs.size();
                      } 
                      System.debug('Offset Value for Or Search '+orOptySearchOffVal);
                     System.debug('The or query is '+reqBodyObj.whereClause.get('orOppClause'));
                     String orOptyQuery='Select '+reqBodyObj.displayAttributes+' from Opportunity where  opportunity_status__c in (\'active\',\'booked\')  and  id not in:optyIDs and '+reqBodyObj.whereClause.get('orOppClause')+' limit '+limitValue+' offset '+orOptySearchOffVal;
                     List<Opportunity> orOpty=Database.query(orOptyQuery);
                     resp.records.addAll(orOpty); 
                     System.debug('The or opty record size is '+resp.records.size());
                  }
                  /*if the no. of records received from the search of the individual words in opportunity object is less than the pagesize then search
                    for the individual words in the Opportunity Line Item Object */
                 if(resp.records.size()<reqBodyObj.pageSize)
                 {
                     //Fetch the opportunity ids from the previous search to not repeat the same opportunity id in the resultset
                      List<Opportunity> allIdsOrOpty=new List<Opportunity>();
                      if(reqBodyObj.whereClause.get('orOppClause')!=null)
                      {
                         String allIdsOrOptyQuery='Select id from Opportunity where  opportunity_status__c in (\'active\',\'booked\') and '+reqBodyObj.whereClause.get('orOppClause')+' limit 2000';
                         allIdsOrOpty=Database.query(allIdsOrOptyQuery);
                         System.debug('The length of total records is '+ allIdsOrOpty.size());
                         for (Opportunity opportunity : allIdsOrOpty)
                         {
                             optyIDS.add(opportunity.id);
                         }
                      }
                 if(reqBodyObj.whereClause.get('orOptyLineClause')!=null)
                 {
                     limitValue= reqBodyObj.pageSize-resp.records.size();
                     System.debug('limit Value for or opty line items '+limitValue);
                     Integer orOptyLineSearchoffVal=0;
                      //If the size of the previous records is 0 for the particular page number then set the offset.                                      
                     if(resp.records.size()==0)          
                     {
                        orOptyLineSearchoffVal=reqBodyObj.pageSize*(reqBodyObj.pageNum-1)- allIdsAndOpty.size()-optyLineItemIDs.size()-allIdsOrOpty.size();                
                     }
                     System.debug('Offset Value for Or opty line items Search '+orOptyLineSearchoffVal);
                     String orOptyLineQuery='Select opportunityid from OpportunityLineItem where opportunityid not in:optyIDs and opportunity.opportunity_status__c in (\'active\',\'booked\') and'+reqBodyObj.whereClause.get('orOptyLineClause')+' limit 2000';
                     List<OpportunityLineItem> orOptyLine=Database.query(orOptyLineQuery);
                     List<String> orOptyLineItemIDs=new List<String>();
                     for (OpportunityLineItem optylineitem :orOptyLine)
                     {
                         orOptyLineItemIDs.add(optylineitem.opportunityid);
                     }
                     String fetchOrOptyLineQuery='Select '+reqBodyObj.displayAttributes+' from Opportunity where  id in:orOptyLineItemIDs limit '+limitValue+' offset '+orOptyLineSearchoffVal;
                     List<Opportunity> orOptyLineItemOpty=Database.query(fetchOrOptyLineQuery);
                     resp.records.addAll(orOptyLineItemOpty);
                 }
             }
             }
           }
        resp.totalSize=resp.records.size();
        if(resp.totalSize!=0)
        resp.done=true;
        return resp;
        }
        return resp;
    }
    
    global class ReqJSON {
        global String action;
        global Integer pageNum;
        global Integer pageSize;
        global String displayAttributes;
        global Map<String,String> whereClause;
        global String filterBy;
        global String filterByValue;
    }
     global class ResponseData {
        public Boolean done;
        public List<Opportunity> records{get;set;}
        public Integer totalSize;
        public ResponseData()
        {
            this.records=new List<Opportunity>(); 
            this.totalSize=0;
        }
    }
}