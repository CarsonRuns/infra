/**
* @author       Sudi Pitchaiah
* @version      Intial version (1.0)
* @since        2015-05-01 (YYYY-MM-DD)
* @description  Opportunity object extension controller class
* @modification log
* saduvvur 6/19/2015 updated method UpdateOpptydetails to fix adding more then 10 line items 
* WR-01199 - FP picklist value added as part of WR.
* Modified By - bodurais on 02.16.2018
* Description - Added new variable to store Feedback URL.
* Modified By - udkatta on 04.05.2018
* Description - Added new input parameter EAFlag.
* Modified By - karkamt for 16.02.19 Release
* Description - Added new input parament BP and updated the same.
* Modified By - Surya for Renewals Release 22 - Feb - 2019
* Modified By - shasheik for QI Release 10 - March - 2019
* Description - Added new input paramenst for displaying Quote net Product Amount and Quote net Product Amount on PUI page and updated the same.
**/

global class AddTechnologyServices_CT
{
    /*May 2018 Lightning Release change: start*/
    /*'Add Technology & Service' from Opportunity record detail page*/
    String opptyId = ApexPages.currentPage().getParameters().get('id');
    //String uiTheme = ApexPages.currentPage().getParameters().get('uiTheme');
    /*May 2018 Lightning Release change: end*/ 
    public string StandPricebookId {get;set;}
    public string QuoteSummaryLink{get;set;}
    public string ServiceCatagory{get;set;}
    public string FeedbackURL{get;set;}
     /*May 2018 Lightning Release change: start*/
    //public Boolean isLightning{get;set;}
     /*May 2018 Lightning Release change: end*/
    public opportunity oppty;    
     //March release 10th March - shasheik
    public opportunity opptyValues;
    public String QuoteNetProductAmount {get;set;}
    public String QuoteNetServiceAmount {get;set;}
    public Boolean netAmountSyncUpFlag {get;set;}
    
    
    public AddTechnologyServices_CT(ApexPages.StandardController controller) { 
        
        StandPricebookId = [select Id from pricebook2 where name = 'Standard Price Book'].Id;
        FeedbackURL = Org_Constant_CS__c.getInstance('OpptyACVFeedbackUrl').Production_Value__C;
       
        /*May 2018 Lightning Release change: start*/
        // opportunity opp = (Opportunity)controller.getRecord();
        
         //March 10th release - shasheik
         opptyValues = (Opportunity)controller.getRecord();
         
       opportunity opp;
       /*'Add Technology & Service' from Opportunity record detail page, opptyId is passed as parameter from url */
       if (opptyId != null){   
          opp = new Opportunity();
            opp.Id = opptyId;
         }
         /*'Add Technology & Service' from Technology&Service related list, the opportunity can be retrieved */
        else{
            opp = (Opportunity)controller.getRecord();
        }
       /* if(uiTheme != null && uiTheme == 'lightning' ){           
                isLightning = true;
        }
        else{
             isLightning = false;
        }*/
        /*May 2018 Lightning Release change: end*/
         if(opp.Id != null){
           oppty = [select OwnerId,Id,position__c,Expected_Product__c,Expected_Service__c, CCW_BOM_Integrated_Quote_Id__c,Is_Product_Quote_Integrated__c,Is_Service_Quote_Integrated__c,Enterprise_Agreement_Opportunity__c,Buying_Program__c,RecordTypeId,Line_Item_Tech_Count__c,Line_Item_Service_Count__c  from opportunity where Id=:opp.Id limit 1];  
        }
        
    //    oppty = [select OwnerId,Id,position__c from opportunity where Id=:opp.Id limit 1];  
    //    list<Quote__c> q = [Select Quote_Summary__c From Quote__c where Opportunity_Name__c = :oppty.Id limit 1];
    
       list<Quote__c> q = [select Quote_Summary__c,DM_Quote_ID__c,  Quote_Service_List_Amount__c,  Quote_Product_List_Amount__c, 
                            Quote_Service_Net_Amount__c, Quote_Product_Net_Amount__c, CCW_Deal_Status_MQ__c, 
                            CCW_Deal_Status__c,Integrated_Quote__c from Quote__c where Opportunity_Name__c = :oppty.Id ];
                            
        if(!q.isEmpty()){
           QuoteSummaryLink = q[0].Quote_Summary__c ;
           //Start  Changes Made here for Displaying net Amounts on PUI page US- Shasheik
        for(Quote__c qt : q){   
                // if(qt.Integrated_Quote__c=='Yes' && (qt.Quote_Product_Net_Amount__c!= null || qt.Quote_Service_Net_Amount__c!= null)){
                if(qt.Integrated_Quote__c=='Yes'){

                    QuoteNetProductAmount =  String.valueOf(qt.Quote_Product_Net_Amount__c);
                    QuoteNetServiceAmount =  String.valueOf(qt.Quote_Service_Net_Amount__c);
               
                           
                    if(QuoteNetProductAmount == String.valueOf(oppty.Expected_Product__c) && QuoteNetServiceAmount == String.valueOf(oppty.Expected_Service__c) ){
                                     netAmountSyncUpFlag = true;
                    }                
                        //changes for NA requirement
                    if(qt.Quote_Product_Net_Amount__c==null && qt.Quote_Service_Net_Amount__c==null ){
                        QuoteNetServiceAmount = 'N/A' ;
                        QuoteNetProductAmount = 'N/A' ;
                    }                    
                    else{
                     // Quote is integrated with Product Line
                        if( (oppty.Is_Product_Quote_Integrated__c =='Yes' && oppty.Is_Service_Quote_Integrated__c == null)  || oppty.Line_Item_Service_Count__c==0.0 ){
                                QuoteNetServiceAmount = 'N/A' ;
                               if(QuoteNetProductAmount == String.valueOf(oppty.Expected_Product__c)  ){
                                     netAmountSyncUpFlag = true;
                               }
                        }
                        
                        // Quote is integrated with Service Line
                        if( (oppty.Is_Service_Quote_Integrated__c =='Yes' && oppty.Is_Product_Quote_Integrated__c ==null)  || oppty.Line_Item_Tech_Count__c==0.0  ){
                               QuoteNetProductAmount = 'N/A' ;                         
                               if(QuoteNetServiceAmount == String.valueOf(oppty.Expected_Service__c)  ){
                                     netAmountSyncUpFlag = true;
                               }
                        }
                     }                   
                }
     }          
            system.debug('QuoteNetProductAmount==>'+QuoteNetProductAmount );
            system.debug('QuoteNetServiceAmount ==>'+QuoteNetServiceAmount );
            
        //End Changes made for 10th March Release here-shasheik
            
        }
        
        Schema.DescribeFieldResult fieldResult = OpportunityLineItem.Service_Category__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResult.getPicklistValues();
        for( Schema.PicklistEntry f : ple)
         {
             if(ServiceCatagory == null){
                 ServiceCatagory = f.getValue() +';';
             }else{         
                 ServiceCatagory += f.getValue() + ';';
             }
         }
         if(ServiceCatagory != null)
             ServiceCatagory  = ServiceCatagory.substring(0,ServiceCatagory.length()-1); 
    }

    //Removed Additional Renewal Methods - aditys, Surya - 8/3/2019
   
  
    // saduvvur modified method to fix issue with adding more then 10 line items
    // add logic to do line items upsert, line items delete and opportunity update
    // to this method
    // Date modified : 6/19/2015
    @RemoteAction
    global static String UpdateOpptydetails(string OppId,Decimal expProduct, Decimal expService,string forecastPostion, string EAFlag,string BP, String jLineItemsUpsert, String jDelLineItems) {
      //Fix for Defect DE237503
     //  List<Opportunity> optList = [select Id from Opportunity where id= :OppId and CCW_BOM_Integrated_Date__c != null];
     List<Opportunity> optList = [select Id from Opportunity where id= :OppId and (CCW_BOM_Integrated_Date__c = null OR Is_Product_Quote_Integrated__c=null OR Is_Service_Quote_Integrated__c = null )];
        String status = 'Success';
      
         //Fix for Defect DE237503   
          if(optList != null || !optList.isEmpty()){   
        
          List<OpportunityLineItem> upsertList = new List<OpportunityLineItem>();
          List<OpportunityLineItem> delList = new List<OpportunityLineItem>();
          
          System.debug(System.LoggingLevel.INFO, 'oppId = '+OppId+ ' expProduct = '+expProduct+' expService = '+expService+' jLineItemsUpsert = '+jLineItemsUpsert+' jDelLineItems = '+jDelLineItems);
          
          
          // Convert jsonline items to list lineitems
          if(jLineItemsUpsert != null && jLineItemsUpsert != '' ) {
              upsertList = (List<OpportunityLineItem>)JSON.deserialize(jLineItemsUpsert,List<OpportunityLineItem>.class);
          }
          
          if(jDelLineItems != null && jDelLineItems != '' ) {
              delList = (List<OpportunityLineItem>)JSON.deserialize(jDelLineItems,List<OpportunityLineItem>.class);
          }
          
          // Upsert OpportunityLine Items
          if(upsertList != null && !upsertList.isEmpty()) {
              upsert (upsertList);
          }
          
          // Delete opportunity line itens
          if(delList != null && !delList.isEmpty()) {
              delete (delList);
          }
          
        } else {
          status = 'Opportunity is already integrated with CCW lines';
          System.debug(status);
        }
        
        Opportunity o = new Opportunity(id = OppId);
          
        //Skip opportunity validaitons
        Utilities.setValidationSkip(true);
        o.Expected_Product__c = expProduct;
        o.Expected_Service__c = expService;
        o.position__c = forecastPostion;
        o.Buying_Program__c = BP ; 
        //if(EAFlag !='' && EAFlag != null)     // Added null check to avoid CCW EA overwrite by udkatta   
            o.Enterprise_Agreement_Opportunity__c = EAFlag; 
            
        try {
            update o;
        }
        catch(DmlException dmlEx) {
            System.debug(dmlEx);
            Exception ex = (Exception)dmlEx;
            ex.setMessage(dmlEx.getDmlMessage(0));
            status = ex.getDmlMessage(0);
            throw ex;
      }
        
        return status;
    }
    
     @RemoteAction
    global static String UpdateRenewalOpptydetails(string OppId, string forecastPostion, string EAFlag,string BP, String jLineItemsUpsert, String jDelLineItems) {
        String status = 'Success';
        
        List<OpportunityLineItem> upsertList = new List<OpportunityLineItem>();
        List<OpportunityLineItem> delList = new List<OpportunityLineItem>();
            
        System.debug(System.LoggingLevel.INFO, 'oppId = '+OppId+ ' jLineItemsUpsert = '+jLineItemsUpsert+' jDelLineItems = '+jDelLineItems);
            
        // Convert jsonline items to list lineitems
        if(jLineItemsUpsert != null && jLineItemsUpsert != '' ) {
            upsertList = (List<OpportunityLineItem>)JSON.deserialize(jLineItemsUpsert,List<OpportunityLineItem>.class);
        }
        
        if(jDelLineItems != null && jDelLineItems != '' ) {
            delList = (List<OpportunityLineItem>)JSON.deserialize(jDelLineItems,List<OpportunityLineItem>.class);
        }
        
        // Upsert OpportunityLine Items
        if(upsertList != null && !upsertList.isEmpty()) {
            upsert (upsertList);
        }
        
        // Delete opportunity line itens
        if(delList != null && !delList.isEmpty()) {
            delete (delList);
        }
        
        Opportunity o = new Opportunity(id = OppId);
        
        //Skip opportunity validaitons
        Utilities.setValidationSkip(true);
        o.position__c = forecastPostion;
        o.Buying_Program__c = BP;
        if(EAFlag !='' && EAFlag != null)     // Added null check to avoid CCW EA overwrite by udkatta   
            o.Enterprise_Agreement_Opportunity__c = EAFlag; 
        
        try {
            update o;
        }
        catch(DmlException dmlEx) {
            System.debug(dmlEx);
            Exception ex = (Exception)dmlEx;
            ex.setMessage(dmlEx.getDmlMessage(0));
            status = ex.getDmlMessage(0);
            throw ex;
        }
        return status;
    }
    
}