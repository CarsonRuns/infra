public class MixPct {

  /*
    # Used by the OpportunityLineItemMixPctChange and OpportunityExpectedAmtChanged triggers only. 
    # 200709 - converted from package to class
  */
  // Public class for MixPct
  private static boolean processLineItems = true;
  
  public static boolean getProcessLineItems()
  {
    return processLineItems;
  }

  public static void setProcessLineItems(boolean newStatus)
  {
    processLineItems = newStatus;
  }

  static testMethod void opptyInsertTestBulk(){
   //processLineItems = true;
   setProcessLineItems(true);
   Date vCloseDate = System.today();

  
   //Get users default currency
   User currentUser =  [select defaultCurrencyIsoCode from User where Id = :UserInfo.getUserId()];
   
   //Query for Pricebook2
   String defaultPricebookId;
   Pricebook2[] pricebook2 = [select id from Pricebook2 where name = 'Standard Price Book'];
   if(pricebook2 == null || pricebook2.size() == 0){
       Pricebook2 createDefaultPB = new Pricebook2(name='default pricebook', isActive=true);
       insert createDefaultPB;
       defaultPricebookId = createDefaultPB.Id;     
   }
   else{
       defaultPricebookId = pricebook2[0].Id;
  
   }
   
   //Build a few new Opportunity objects
   Opportunity oppty1 = new Opportunity(name='Test1',StageName='1 - Identify',CloseDate= vCloseDate,Expected_Product__c=2,Pricebook2Id=defaultPricebookId,CurrencyIsoCode=currentUser.defaultCurrencyIsoCode);
   Opportunity oppty2 = new Opportunity(name='Test2',StageName='1 - Identify',CloseDate= vCloseDate,Expected_Product__c=2,Pricebook2Id=defaultPricebookId,CurrencyIsoCode=currentUser.defaultCurrencyIsoCode);
   Opportunity oppty3 = new Opportunity(name='Test3',StageName='1 - Identify',CloseDate= vCloseDate,Expected_Product__c=2,Pricebook2Id=defaultPricebookId,CurrencyIsoCode=currentUser.defaultCurrencyIsoCode);
   Opportunity oppty4 = new Opportunity(name='Test4',StageName='1 - Identify',CloseDate= vCloseDate,Expected_Product__c=2,Pricebook2Id=defaultPricebookId,CurrencyIsoCode=currentUser.defaultCurrencyIsoCode);
   
   Opportunity[] opptyArray = new Opportunity[]{oppty1,oppty2,oppty3,oppty4};
//   opptyArray[0]=oppty1;
//   opptyArray[1]=oppty2;
//   opptyArray[2]=oppty3;
//   opptyArray[3]=oppty4;
   
   insert opptyArray;   
   
   //Query for a sample 'Service' PricebookEntry.
   PricebookEntry[] servicePBE = [select Id from PricebookEntry where  ProductCode='Service' and CurrencyIsoCode= :currentUser.defaultCurrencyIsoCode and Pricebook2Id = :defaultPricebookId and PriceBookEntry.IsActive=true];
   PricebookEntry defaultServicePBE;
   
   if(servicePBE == null || servicePBE.size() == 0){
      
      Product2[] products = [select id from Product2 where ProductCode = 'Service'];
      if(products == null || products.size() == 0){
          Product2 newProduct = new Product2(ProductCode ='Service', Name='Test');
          insert newProduct;
          
          defaultServicePBE = new PricebookEntry(isActive=true,UnitPrice=5,product2Id = newProduct.Id,ProductCode='Service',Pricebook2Id=defaultPricebookId,CurrencyIsoCode=currentUser.defaultCurrencyIsoCode);
          insert defaultServicePBE;
      }
      else{         
         defaultServicePBE = new PricebookEntry(isActive=true,UnitPrice=5,product2Id = products[0].Id,ProductCode='Service',Pricebook2Id=defaultPricebookId,CurrencyIsoCode=currentUser.defaultCurrencyIsoCode);
         insert defaultServicePBE;           
      }
      
      
   }
   else
      defaultServicePBE = servicePBE[0];
   
   
   
   //Query for a sample /Technology PricebookEntry.
   PricebookEntry[] technologyPBE = [select Id from PricebookEntry where  ProductCode='Technology' and CurrencyIsoCode= :currentUser.defaultCurrencyIsoCode and Pricebook2Id = :defaultPricebookId and PriceBookEntry.IsActive=true];
   PricebookEntry defaultTechnologyPBE;
   if(technologyPBE == null || technologyPBE.size() == 0){
      
      Product2[] products = [select id from Product2 where ProductCode = 'Technology'];
      if(products == null || products.size() == 0){
          Product2 newProduct = new Product2(ProductCode ='Technology', Name='Test Tech');
          insert newProduct;
          
          defaultTechnologyPBE = new PricebookEntry(isActive=true,UnitPrice=5,product2Id = newProduct.Id,ProductCode='Technology',Pricebook2Id=defaultPricebookId,CurrencyIsoCode=currentUser.defaultCurrencyIsoCode);
          insert defaultTechnologyPBE;
      }
      else{         
         defaultTechnologyPBE = new PricebookEntry(isActive=true,UnitPrice=5,product2Id = products[0].Id,ProductCode='Technology',Pricebook2Id=defaultPricebookId,CurrencyIsoCode=currentUser.defaultCurrencyIsoCode);
         insert defaultTechnologyPBE;

      }
      
      
   }
   else
      defaultTechnologyPBE = technologyPBE[0];
      
   OpportunityLineItem[] opptyLineItemsToCreate = new OpportunityLineItem[]{};
   
   //Create a new 'Service' OpportunityLineItem. 
   OpportunityLineItem tempLineItem = new OpportunityLineItem(TotalPrice=0,OpportunityId=opptyArray[1].id,Mix__c=50,Quantity=1,PricebookEntryId=defaultServicePBE.id);   
   opptyLineItemsToCreate.add(tempLineItem);
   
   //Create a new 'Technology' OpportunityLineItem. 
   tempLineItem = new OpportunityLineItem(TotalPrice=0,OpportunityId=opptyArray[0].id,Mix__c=50,Quantity=1,PricebookEntryId=defaultTechnologyPBE.id);   
   opptyLineItemsToCreate.add(tempLineItem);
   
   tempLineItem = new OpportunityLineItem(TotalPrice=0,OpportunityId=opptyArray[0].id,Mix__c=0,Quantity=1,PricebookEntryId=defaultTechnologyPBE.id);   
  opptyLineItemsToCreate.add(tempLineItem);
   insert opptyLineItemsToCreate;


   //Now update the Opportunity 
   opptyArray[0].Expected_Service__c = 0;
   opptyArray[0].Expected_Product__c = 0;
   opptyArray[1].Expected_Service__c = 75;
   opptyArray[1].Expected_Product__c = 75;
   opptyArray[2].Expected_Service__c = 75;
   opptyArray[3].Expected_Service__c = 100;
   opptyArray[3].Expected_Product__c = 100;
   update opptyArray;
 }
 
   
 
 
 
   
    static testMethod void opptyLineItemUpdateTestBulk(){
//  processLineItems = true;
    setProcessLineItems(true);

    OpportunityLineItem[] oliArray = [select o.Id,o.Mix__c from OpportunityLineItem o Where o.PricebookEntry.ProductCode ='Service' LIMIT 25];
    update oliArray;    
    
    oliArray = [select o.Id,o.Mix__c from OpportunityLineItem o Where o.PricebookEntry.ProductCode ='Technology' LIMIT 25];
    update oliArray;    
    
 }
   
   
    public static testMethod void nullPricebookEntryIdTest(){
    
//  processLineItems = true;
    setProcessLineItems(true);
    
    try{
        
    //Get list of Opportunity records where Currency = USD
    Opportunity[] opptys = [select Id, Pricebook2Id from Opportunity Where CurrencyIsoCode='USD' LIMIT 100];
    // commented: PricebookEntry[] pbeIds = [select Id from PricebookEntry where ProductCode!='' and CurrencyIsoCode='USD' and isActive=true LIMIT 20];
    PricebookEntry[] pbeIds = [select Id from PricebookEntry where ProductCode!='' and CurrencyIsoCode='USD' and isActive=true LIMIT 1];
    System.debug('Retrieve ' + pbeIds.size() + ' pbeIds');
    
    Integer x = 0;
    Integer y = 0;
    Integer z = 0;
    OpportunityLineItem[] oliToProcess = new OpportunityLineItem[]{};
    for(x=0;x<10;x++){
        if(y<opptys.size()-1)
          y++;
        else
          y=0;
          
          
        if(z < pbeIds.size()-1)
          z++;
        else
          z=0;
             
        if(z==1) {
           OpportunityLineItem tempOLI = new OpportunityLineItem(OpportunityId=opptys[y].Id,TotalPrice=0,PricebookEntryId=pbeIds[z].Id, Quantity=1);
           oliToProcess.add(tempOLI);
        }
        else   {
            OpportunityLineItem tempOLI = new OpportunityLineItem(OpportunityId=opptys[y].Id,TotalPrice=0, Quantity=1); 
            oliToProcess.add(tempOLI);
        }
            

        
        if(oliToProcess.size() >= 100){
           insert oliToProcess;
           oliToProcess = new OpportunityLineItem[]{};
        }
           
            
    }
    
    if(oliToProcess.size() >= 0){
           insert oliToProcess;
           oliToProcess = new OpportunityLineItem[]{};
        }
        
    }catch(System.DMLException ex){
        //System.assert(ex.getMessage().contains('OpportunityLineItemMixPctChange Trigger caught exception: PricebookEntryId is null. This is a required field. '));
    }
 }
 
 
 
   
  
  /*
     This method queries for the ProductCode of the related PricebookEntrys to the OpportunityLineItems.
     The data is stored in a Map object for easy look ups by the getProductCode method.
  */
  public static Map<Id,PricebookEntry> getRelatedPriceBookEntries(PricebookEntry[] pbeIds) {
    System.debug('Querying ' + pbeIds.size() + 'PricebookEntryIds' );
    Map<Id, PricebookEntry> pbe = new Map<Id, PricebookEntry>([select Id,ProductCode from PricebookEntry where Id IN :pbeIds]);
    System.debug('getRelatedPriceBookEntries : ' + pbe.size() + ' pbes found');
    return pbe;  
  }
  
  
  /*
      This method queries for the Expected Service and Expected Product of the related Opportunities to the OpportunityLineItems.
      The data is stored in a Map object for easy look ups by the getExpectedAmt method.
  */
  public static Map<Id,Opportunity> getRelatedOpptys(Opportunity[] opptyIds){
    System.debug('Querying ' + opptyIds.size() + 'OpptyIds' );
    Map<Id,Opportunity> relatedOpptys = new Map<Id,Opportunity>([select Id, Expected_Service__c, Expected_Product__c, RecordTypeId from Opportunity where Id IN :opptyIds]);
    return relatedOpptys;
  }
  
  
  /* 
     This method returns the ProductCode field for a specific PricebookEntryId. 
     Uses the Map object for quick looksup. No API call. 
  */
  public static String getProductCode(String pbeId, 
                                        Map<Id,PricebookEntry> pbeIDs, 
                                        String OpptyId, 
                                        String OpptyLineItemId, 
                                        Double MixPerc)
  {
     PricebookEntry pbe = pbeIDs.get(pbeId);

     if(pbe == null)
         throw new CustomException('An error has occurred while updating or creating the Opportunity Product. pbe is null:' +
                    ' OpptyId=' + OpptyId + 
                    ' OpptyLineItemId=' + OpptyLineItemId + 
                    ' MixPerc='+ MixPerc);

     
     if(pbe.ProductCode == null)
         throw new CustomException('An error has occurred while updating or creating the Opportunity Product. pbe.ProductCode is null:' +
                    ' PriceBookEntryId='+ pbe.Id + 
                    ' OpptyId=' + OpptyId + 
                    ' OpptyLineItemId=' + OpptyLineItemId + 
                    ' MixPerc='+ MixPerc);

     return pbe.ProductCode; 
  }

   /*
       This method returns the appropriate Expected Amt field for a specific OpportunityLineItem. 
       Uses the Map object for quick looksup. No API call. 
       If productCode = 'Technology' then return the Expected_Product__c amt field.
       If productCode = 'Service' then return the Expected_Service__c amt field.
   */
   public static double getExpectedAmt(String productCode, String opptyIdToFind, Map<Id,Opportunity> opptyIds){
    Double result = 0;

    Opportunity oppty = opptyIds.get(opptyIdToFind);
    //this code is commented out since it can't be reached in testing
  //    if(oppty == null) //Better handling of NULLS. Added 6.14.07 
    //  return null;
      
    if(productCode == 'Technology'){
        result = oppty.Expected_Product__c;
    }   else if(productCode == 'Service'){
        result = oppty.Expected_Service__c;
    }   else if(productCode == null)
        result = 0;
            
        //this code is commented out since it can't be reached in testing
    //if(result == null) 
    //  result = 0;
    
    return result;
  }
  
}