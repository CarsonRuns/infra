/******************************************************
Name    : batchUpdateOpptLine 
Author  : prilahir
Purpose : batchUpdateOpptLine class for update opptyline product_Family_ref__c 
Created Date: 16/04/2019
Modification History: 

*******************************************************/
global class batchUpdateOpptLine implements Database.Batchable<sObject>,Database.Stateful,Schedulable { 
    global list<OpportunityLineItem> updatedOppLineItem=new list<OpportunityLineItem>(); 
    global Org_Constant_Custom_Settings__c g_orgConstant = Org_Constant_Custom_Settings__c.getInstance();
     global Database.QueryLocator start(Database.BatchableContext BC) {
         String query;
         decimal daysCount=g_orgConstant.daysCount__c; 
         string productCode=Label.Product_Code;
         string familyValueUnspecified=Label.QI_PF_Unspecified;
         string productFamilyUnknown=Label.QI_PF_Unknown;
         string recordTypeId=g_orgConstant.recordTypeId__c;
         if(daysCount!=null){
         datetime dt=Date.Today().addDays(-daysCount.intvalue());
         string Formateddt=dt.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
         system.debug('Date Value'+Formateddt);   
         query ='select id, PricebookEntry.Product2Id,Product_Family__c,PriceBookEntry.ProductCode,product_family_ref__c from OpportunityLineItem where ';
         query=query+' Product_Family__c!=null AND Product_Family__c!=\''+productFamilyUnknown+'\' AND Product_Family__c!=\''+familyValueUnspecified+'\' AND product_family_ref__c=null';
         query=query+' AND PriceBookEntry.ProductCode=\''+productCode+'\' AND CreatedDate >='+Formateddt;
         query=query+' AND Opportunity.recordtypeid=\''+recordTypeId+'\' AND Opportunity.is_product_quote_integrated__c= null';    
   
         }
         else{
       
             Datetime startDate=g_orgConstant.startDate__c;
             string startFormateddt=startDate.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
             Datetime enddate=g_orgConstant.enddate__c;
             string endFormateddt=enddate.format('yyyy-MM-dd\'T\'hh:mm:ss\'Z\'');
             query ='select id, PricebookEntry.Product2Id,Product_Family__c,PriceBookEntry.ProductCode,product_family_ref__c from OpportunityLineItem where ';
             query=query+' Product_Family__c!=null AND Product_Family__c!=\''+productFamilyUnknown+'\' AND Product_Family__c!=\''+familyValueUnspecified+'\' AND product_family_ref__c=null';
             query=query+' AND PriceBookEntry.ProductCode=\''+productCode+'\' AND CreatedDate >='+startFormateddt;
             query=query+' AND Opportunity.recordtypeid=\''+recordTypeId+'\' AND Opportunity.is_product_quote_integrated__c= null';
             query=query+' AND CreatedDate <='+endFormateddt;
             
               
         }
         return Database.getQueryLocator(query);    
     }
    
    global void execute(Database.BatchableContext BC, List<OpportunityLineItem> scope) {
       
        set<string> productFamily = new  set<string>();
        //map<string,id> mapValue=new map<string,id>();
        if(!scope.isEmpty()){
         for(OpportunityLineItem btObj: scope){
             // OpportunityLineItem btObj = (OpportunityLineItem) sobj;
              productFamily.add(String.valueOf(btObj.Product_Family__c)); 
             // mapValue.put(String.valueOf(btObj.Product_Family__c),btObj.PricebookEntry.Product2Id);
             
         }
        
        list<Product_Family__c> lstprodFamily=[SELECT Id,product__c,Product_Family_Description__c FROM Product_Family__c where Product_Family_Description__c IN:productFamily  And Product_Family_Status__c = 'ACTIVE'];
          
          if(!lstprodFamily.isEmpty()){
            for(OpportunityLineItem objLine:scope){
            for(Product_Family__c objFamily:lstprodFamily){
                if(objFamily.Product_Family_Description__c==objLine.Product_Family__c && objFamily.product__c==objLine.PricebookEntry.Product2Id){
                    objLine.Product_Family_Ref__c=objFamily.id;
                    updatedOppLineItem.add(objLine);
                    break;
                }  
                
            }   
            
        }
         
         if(!updatedOppLineItem.isEmpty()){
            database.update(updatedOppLineItem, false);
         }
            }
       }
    }
  
     global void finish(Database.BatchableContext BC) {
         if(!updatedOppLineItem.isEmpty()){
         string header = 'OpportunityLineItemId, PriceBook , Product Family,Product Family Ref \n';
         string finalstr = header ;
         for(OpportunityLineItem Objopptline: updatedOppLineItem)
        {
            string recordString = '"'+Objopptline.id+'","'+Objopptline.PricebookEntry+'","'+Objopptline.Product_Family__c+'","'+Objopptline.product_family_ref__c +'"\n';
             finalstr = finalstr +recordString;
        }
      system.debug('Finish Method String Value'+finalstr);
      Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
      blob csvBlob = Blob.valueOf(finalstr);
      string csvname= 'Modified_Opportunity_Line.csv';
      csvAttc.setFileName(csvname);
      csvAttc.setBody(csvBlob);
      Messaging.SingleEmailMessage email =new Messaging.SingleEmailMessage();
      String[] toAddresses = new list<string> {'prilahir@cisco.com'};
      String subject ='Modified Opportunity Line';
      email.setSubject(subject);
      email.setToAddresses( toAddresses );
      email.setPlainTextBody('Please find the attachment for updated OpportunityLineItem  Record ');
      email.setFileAttachments(new Messaging.EmailFileAttachment[]{csvAttc});
      Messaging.SendEmailResult [] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {email});       
  } 
        
    }
     
    global void execute(SchedulableContext SC) {        
       batchUpdateOpptLine processBatch = new batchUpdateOpptLine();
       Database.executeBatch(processBatch);
    }

}