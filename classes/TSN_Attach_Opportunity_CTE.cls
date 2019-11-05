// ********************** Change History **********************
// 6/19 Manju - Removed logic to stop attaching Opportunity to TSN Closed case.
// **************************************************************

public class TSN_Attach_Opportunity_CTE {

// SCAVA Helper Method to validate Update Access at field level
     public static Boolean flsUpdateGet(SObjectField field)
    {
        return field.getDescribe().isUpdateable() ? true : false;
    }
     // SCAVA Helper Method to validate Create Access at field level
     public static Boolean flsGet(SObjectField field)
    {
        return field.getDescribe().isCreateable() ? true : false;
    }
    

// Variables used for the search criteria.
public String  searchDealId { get; set; }
public String  searchOptyOwner { get; set; }
public String  searchOptyName { get; set; }



//Flags for the errors on the VF.
public Boolean opptyAttachMessage { get; set; }
public Boolean ownerGroupMessage { get; set; }
public Boolean statusMessage { get; set; }
public Boolean errorFlag { get; set; }
public Boolean limitFlag { get; set; }
public Boolean SearchBlockFlag { get; set; }
public Boolean ResultBlockFlag { get; set; }
public Boolean PanelBlockFlag { get; set; }
public Boolean successBlockFlag { get; set; }

//Variables for this class not be accessed on VF.
public List<Opportunity> my_list;
public Case c ;
public String caseOwner; 
public String profileId;
public Boolean caseOwnerGroup = false;
public integer npages;
public integer remainder;
public integer acpage = 1;
public Integer PageSize = 50 ;


public List<Multi_Object_Quote__c> moq_list;
public Multi_Object_Quote__c moq;
public Boolean Moqflag {get;set;}
public Boolean invalidDeal {get; set;}
public Boolean Jsonresp {get; set;}
public String CCW_URL {get; set;}



//Class Constructor fetches the values from the VF of case object.
public TSN_Attach_Opportunity_CTE(ApexPages.StandardController controller) {
    c = [select ID,Opportunity__c,OwnerId,Status,RecordTypeId,CCW_Deal_or_Quote__c,Deal_ID__c,Quote_Product_List_Amount__c,Quote_Product_Net_Price_000__c,Expected_Product_List_Amount__c,CCW_Quote_Status__c,Eligible_for_NS__c,
     Deal_Created_Date__c,Deal_Desk_Status__c,Quote_ID__c,Quote_Service_Net_Price_000__c,Expected_Service_List_Amount__c,Promotion_Name__c,Program_Name__c,Deal_Expiration_Date__c,Discount_Type__c from Case where id = :ApexPages.currentPage().getParameters().get('id')];   
    caseOwner = c.OwnerId;    
    profileId=Userinfo.getProfileId();
    //kikamara- WR-01662 Replaced getOrgConstant object to getConstant_CS Custom setting
    CCW_URL = Utilities.getConstant_CS('PDR URL');  
    CCW_URL += '/SFDCRequestHandler';
}


//Retrieves the list size returned by the SOQL query
public Integer getResultSize() {
         if(my_list == null)
            return 0;
        else if(my_list.size() >= 0)
            return my_list.size();
        else if(moq_list == null)
        return 0;
        else
        return moq_list.size();
   }
   

// checks whether the case owner is group or not.
public Boolean OwnerGroup(){
      caseOwnerGroup = caseOwner.substring(0,3).contains('00G');
      return caseOwnerGroup; 
}


//executes when the search button is clicked.
// search the results in the database and set the results into the list(my_list)
public PageReference doAdvanceSearch() {
    limitFlag = false;
    Moqflag = false;
    my_list = new List<Opportunity>();
    
    if(searchDealId.length()>1 || searchOptyName.length()>1 || searchOptyOwner.length()>1 )
    {
    searchDealId = searchDealId.trim();
    searchOptyName = searchOptyName.trim();
    searchOptyOwner = searchOptyOwner.trim();
    errorFlag = false;
    acpage = 1;
      
      
    moq_list = [select Id, Deal_ID__c, Deal_Name__c, DM_Quote_ID__c,Opportunity_Name__c, Name,Expected_Product_List_Amount__c,Quote_Product_List_Amount__c,Quote_Service_List_Amount__c,Quote_Status__c,End_Customer_Name__c,Address_Line_1__c,Address_Line_2__c,Address_Line_3__c,City__c,Country__c,Expected_Service_List_Amount__c,Quote_Service_Net_Price__c,Quote_Product_Net_Price__c,Deal_Status__c,Deal_Create_Date__c,Deal_Expiration_Date__c,Program_Name__c,Promotion_Name__c,Discount_Type__c,Eligible_for_NS__c,CR_Party_ID__c,Is_Dummy_Quote__c from Multi_Object_Quote__c where Deal_ID__c like :('%'+searchDealId +'%') limit 1000 ];
    system.debug('moq_list'+moq_list);
    Moqflag = true;
    
    if(moq_list.size()< 1){
    my_list = [select Id,Name,CloseDate,DealID__c,StageName,Opportunity_Status__c,Owner.Name from Opportunity o where DealID__c like :('%'+searchDealId +'%') and name like :('%'+searchOptyName +'%')  and Owner.Name like :('%'+searchOptyOwner +'%') limit 1000];
    Moqflag = false;
    }
    
      system.debug('@*@*'+ my_list);
        if(my_list.size() >999 ||moq_list.size()>999)
        {
        limitFlag = true;
        }  
        
        if(moq_list.size()>0 || my_list.size()>0)
        Jsonresp = false;
        else
        Jsonresp = true;      
    }
    else
    {
     errorFlag = true;  
    }
    System.debug('Jsonresp:'+Jsonresp);
    return null;
}


//executes on the click of save button.
//updates the opportunity Attached to the case
public PageReference Save(){
  
    opptyAttachMessage = false;
    ownerGroupMessage  = false;
    statusMessage = false;
    
     List<Multi_Object_Quote__c> moqlist = new List<Multi_Object_Quote__c>();
     Multi_Object_Quote__c Multioq;
     
     Date createdate;
     Date enddate;
     
   /* if(profileId!=Utilities.getTSNProfileId() &&  c.recordtypeId==Utilities.getCaseTSNRecordTypeId())
    { 
        opptyAttachMessage = true;
    }
    else if(c.recordtypeId==Utilities.getCaseTSNRecordTypeId() && OwnerGroup())
    {
        ownerGroupMessage  = true;
    }*/
    
    /* Removed the logic to stop user from attaching an Opportunity to closed TSN Case.
     if(c.recordtypeId==Utilities.getCaseTSNRecordTypeId() && c.Status == 'Closed')
    {
        statusMessage = true;
    }
    else
    { 
        System.debug('OpptyId:'+ApexPages.currentPage().getParameters().get('opptyId'));
        System.debug('QuoteId:'+ApexPages.currentPage().getParameters().get('QuoteId'));
        */
    
         if(c.Deal_ID__c == searchDealId)
         ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,'The Deal is already attached to the Case'));
         else{         
         if(ApexPages.currentPage().getParameters().get('opptyId') != null && ApexPages.currentPage().getParameters().get('opptyId') != ''){
         System.debug('Hello World');
         if(flsUpdateGet(Case.Opportunity__c )||flsGet(Case.Opportunity__c)) //SCAVA FIX   
         {
         c.Opportunity__c = ApexPages.currentPage().getParameters().get('opptyId');
         }
         
         }
         else if(ApexPages.currentPage().getParameters().get('QuoteId') != null && ApexPages.currentPage().getParameters().get('QuoteId') != '')
         {
             //moqlist = [select Id from Multi_Object_Quote__c where Deal_ID__c = :ApexPages.currentPage().getParameters().get('DealId') limit 1];
             
             
             Multioq = new Multi_Object_Quote__c();
             
             Multioq.Id = ApexPages.currentPage().getParameters().get('QuoteId');
           
             
          if(flsUpdateGet(Case.CCW_Deal_or_Quote__c)||flsGet(Case.CCW_Deal_or_Quote__c)) //SCAVA FIX   
          {
             c.CCW_Deal_or_Quote__c = Multioq.Id;
          }
         }
         else if((ApexPages.currentPage().getParameters().get('QuoteId') == null || ApexPages.currentPage().getParameters().get('QuoteId') == '') && (ApexPages.currentPage().getParameters().get('opptyId') == null || ApexPages.currentPage().getParameters().get('opptyId') == ''))
         {
             System.debug('MultiObjectQuote');
              if(ApexPages.currentPage().getParameters().get('DealCreatedOn') != '' && ApexPages.currentPage().getParameters().get('DealCreatedOn') != null)
              createdate = Date.valueof(ApexPages.currentPage().getParameters().get('DealCreatedOn'));
              if(ApexPages.currentPage().getParameters().get('DealExpirationDate') != '' && ApexPages.currentPage().getParameters().get('DealExpirationDate') != null)
              enddate = Date.valueof(ApexPages.currentPage().getParameters().get('DealExpirationDate'));
              
              Multioq = new Multi_Object_Quote__c();
              
              if(flsUpdateGet(Multi_Object_Quote__c.OwnerID)||flsGet(Multi_Object_Quote__c.OwnerID)) //SCAVA FIX
              {
              Multioq.OwnerID = '00580000001pY4y';
              }
              if(flsUpdateGet(Multi_Object_Quote__c.Name)||flsGet(Multi_Object_Quote__c.Name)) //SCAVA FIX
              {
              Multioq.Name = ApexPages.currentPage().getParameters().get('DealName');
              }
             if(flsUpdateGet(Multi_Object_Quote__c.Deal_ID__c)||flsGet(Multi_Object_Quote__c.Deal_ID__c)) //SCAVA FIX
              {
              Multioq.Deal_ID__c = ApexPages.currentPage().getParameters().get('dealid');
              }
              if(flsUpdateGet(Multi_Object_Quote__c.Deal_Name__c)||flsGet(Multi_Object_Quote__c.Deal_Name__c)) //SCAVA FIX
              {
              Multioq.Deal_Name__c = ApexPages.currentPage().getParameters().get('DealName');
              }
              if(flsUpdateGet(Multi_Object_Quote__c.Quote_Product_List_Amount__c)||flsGet(Multi_Object_Quote__c.Quote_Product_List_Amount__c)) //SCAVA FIX
              {
              Multioq.Quote_Product_List_Amount__c=Decimal.valueOf(ApexPages.currentPage().getParameters().get('QuoteProdListAmt'));
              }
              if(flsUpdateGet(Multi_Object_Quote__c.Quote_Service_List_Amount__c)||flsGet(Multi_Object_Quote__c.Quote_Service_List_Amount__c)) //SCAVA FIX
              {
              Multioq.Quote_Service_List_Amount__c=Decimal.valueOf(ApexPages.currentPage().getParameters().get('QuoteServListAmt'));
              }
              if(flsUpdateGet(Multi_Object_Quote__c.Quote_Status__c)||flsGet(Multi_Object_Quote__c.Quote_Status__c)) //SCAVA FIX
              {
              Multioq.Quote_Status__c=ApexPages.currentPage().getParameters().get('QuoteStatus');
              }
              if(flsUpdateGet(Multi_Object_Quote__c.End_Customer_Name__c)||flsGet(Multi_Object_Quote__c.End_Customer_Name__c)) //SCAVA FIX
              {
              Multioq.End_Customer_Name__c=ApexPages.currentPage().getParameters().get('ExpCustAccName');
              }
              if(flsUpdateGet(Multi_Object_Quote__c.Address_Line_1__c)||flsGet(Multi_Object_Quote__c.Address_Line_1__c)) //SCAVA FIX
              {
              Multioq.Address_Line_1__c=ApexPages.currentPage().getParameters().get('EndCustAddr1');
              }
              if(flsUpdateGet(Multi_Object_Quote__c.Address_Line_2__c)||flsGet(Multi_Object_Quote__c.Address_Line_2__c)) //SCAVA FIX
              {
                  Multioq.Address_Line_2__c=ApexPages.currentPage().getParameters().get('EndCustAddr2');
              }
              if(flsUpdateGet(Multi_Object_Quote__c.Address_Line_3__c)||flsGet(Multi_Object_Quote__c.Address_Line_3__c)) //SCAVA FIX
              {
                        Multioq.Address_Line_3__c=ApexPages.currentPage().getParameters().get('EndCustAddr3');
              }
              if(flsUpdateGet(Multi_Object_Quote__c.City__c)||flsGet(Multi_Object_Quote__c.City__c)) //SCAVA FIX
              {
                        Multioq.City__c=ApexPages.currentPage().getParameters().get('EndCustCity');
              }
             if(flsUpdateGet(Multi_Object_Quote__c.Country__c)||flsGet(Multi_Object_Quote__c.Country__c)) //SCAVA FIX
              {
                        Multioq.Country__c=ApexPages.currentPage().getParameters().get('EndCustCounty');
              }
            if(flsUpdateGet(Multi_Object_Quote__c.Expected_Product_List_Amount__c)||flsGet(Multi_Object_Quote__c.Expected_Product_List_Amount__c)) //SCAVA FIX
              {
                        Multioq.Expected_Product_List_Amount__c=Decimal.valueOf(ApexPages.currentPage().getParameters().get('ExpProdListAmt'));
              }
             if(flsUpdateGet(Multi_Object_Quote__c.Expected_Service_List_Amount__c)||flsGet(Multi_Object_Quote__c.Expected_Service_List_Amount__c)) //SCAVA FIX
              {
                        Multioq.Expected_Service_List_Amount__c=Decimal.valueOf(ApexPages.currentPage().getParameters().get('ExpServListAmt'));
              }
              if(flsUpdateGet(Multi_Object_Quote__c.Quote_Product_Net_Price__c)||flsGet(Multi_Object_Quote__c.Quote_Product_Net_Price__c)) //SCAVA FIX
              {
                        Multioq.Quote_Product_Net_Price__c = Decimal.valueOf(ApexPages.currentPage().getParameters().get('QuoteProdNetAmt'));
              }
             if(flsUpdateGet(Multi_Object_Quote__c.Quote_Service_Net_Price__c)||flsGet(Multi_Object_Quote__c.Quote_Service_Net_Price__c)) //SCAVA FIX
              {
                        Multioq.Quote_Service_Net_Price__c =Decimal.valueof(ApexPages.currentPage().getParameters().get('QuoteServNetAmt'));
              }
              if(flsUpdateGet(Multi_Object_Quote__c.Deal_Create_Date__c)||flsGet(Multi_Object_Quote__c.Deal_Create_Date__c)) //SCAVA FIX
              {
                       Multioq.Deal_Create_Date__c=createdate;
              }
              if(flsUpdateGet(Multi_Object_Quote__c.Deal_Expiration_Date__c)||flsGet(Multi_Object_Quote__c.Deal_Expiration_Date__c)) //SCAVA FIX
              {
                        Multioq.Deal_Expiration_Date__c=enddate;
              }
              if(flsUpdateGet(Multi_Object_Quote__c.Program_Name__c)||flsGet(Multi_Object_Quote__c.Program_Name__c)) //SCAVA FIX
              {
                        Multioq.Program_Name__c=ApexPages.currentPage().getParameters().get('ProgramName');
              }
              if(flsUpdateGet(Multi_Object_Quote__c.Promotion_Name__c)||flsGet(Multi_Object_Quote__c.Promotion_Name__c)) //SCAVA FIX
              {
                        Multioq.Promotion_Name__c=ApexPages.currentPage().getParameters().get('PromotionName');
              }
              if(flsUpdateGet(Multi_Object_Quote__c.Discount_Type__c)||flsGet(Multi_Object_Quote__c.Discount_Type__c)) //SCAVA FIX
              {
                        Multioq.Discount_Type__c=ApexPages.currentPage().getParameters().get('DiscountType');
              }
              if(flsUpdateGet(Multi_Object_Quote__c.Deal_Status__c)||flsGet(Multi_Object_Quote__c.Deal_Status__c)) //SCAVA FIX
              {
                        Multioq.Deal_Status__c=ApexPages.currentPage().getParameters().get('DealStatus');
              }
              if(flsUpdateGet(Multi_Object_Quote__c.Eligible_for_NS__c)||flsGet(Multi_Object_Quote__c.Eligible_for_NS__c)) //SCAVA FIX
              {
                        Multioq.Eligible_for_NS__c=ApexPages.currentPage().getParameters().get('EligibleforNS');
              }
              if(flsUpdateGet(Multi_Object_Quote__c.DM_Quote_ID__c)||flsGet(Multi_Object_Quote__c.DM_Quote_ID__c)) //SCAVA FIX
              {
                        Multioq.DM_Quote_ID__c=ApexPages.currentPage().getParameters().get('Quote');
              }
            
             //moqlist.add(Multioq);
             
         }
         
      
       
         try{
         
             //if(moqlist.size()>0)
             //upsert moqlist;
             
             
            if(Multioq != null) 
            {
            System.debug('Yes yes:'+Multioq);
            upsert Multioq ;
            if(flsUpdateGet(Case.CCW_Deal_or_Quote__c)||flsGet(Case.CCW_Deal_or_Quote__c)) //SCAVA FIX   
            {
            c.CCW_Deal_or_Quote__c = Multioq.Id;
            }
            }
            update c;
            // these flags will hide the page block sections and show that opportunity is attached.
            SearchBlockFlag = true ; 
            ResultBlockFlag = true ;
            PanelBlockFlag  = true ;
            successBlockFlag = true;
        }
        catch(Exception e){}  
    }
    //}
    return null;
    }

public void IWantToDebug() {
        String para = Apexpages.currentPage().getParameters().get('node');
       //Jsonresp = false;
       invalidDeal = false;
        
        String DealName = '';
        String DealId = '';
        String DealStatus = '';
        Decimal QuoteProdListAmt;
        Decimal QuoteServListAmt;
        String QuoteStatus = '';
        Decimal ExpProdListAmt;
        Decimal ExpServListAmt;
        String EndCustAccName = '';
        String EndCustAddr1 = '';
        String EndCustAddr2 = '';
        String EndCustAddr3 = '';
        String EndCustCity = '';
        String EndCustCountry = '';
        Decimal QuoteProductNetAmt;
        Decimal QuoteServiceNetAmt;
        String ProgramName = '';
        String PromotionName = '';
        String DiscountType = '';
        String DealExpirationDate = '';
        String DealCreatedOn = '';
        String EligibleforNS = '';
        String QuoteID = '';
       
       //Integer len = para.length();
       
       //String para1 = para.substring(1,len);
       
        System.debug('======================= ' + para);
        //System.debug('++++++++++++++++ ' + para1);
        
        JSONParser parser = JSON.createParser(para);
        parser.nextToken();
        parser.nextValue();
        
        System.debug('>>>>>:'+parser.getCurrentName());
        System.debug('>>>>>:'+parser.getCurrentToken());
        
        
        while (parser.nextToken() != null) {
        
            System.debug('Current Token:'+parser.getCurrentToken());
            System.debug('Parser Text:'+parser.getText());
            if ((parser.getCurrentToken() == JSONToken.FIELD_NAME) && ((parser.getText() == 'dealName')||(parser.getText() == 'quoteId')||(parser.getText() == 'dealStatus')||(parser.getText() == 'dealId') || (parser.getText() == 'status')||(parser.getText() == 'quoteProductListAmount')||(parser.getText() == 'quoteServiceListAmount')||(parser.getText() == 'CCWDealStatus')||(parser.getText() == 'expectedProductListAmount')||(parser.getText() == 'endCustAccountName')||(parser.getText() == 'endCustAddressLine1')||(parser.getText() == 'endCustAddressLine2')||(parser.getText() == 'endCustAddressLine3')||(parser.getText() == 'endCustCountry')||(parser.getText() == 'endCustCity')||(parser.getText() == 'expectedServiceListAmount')||(parser.getText() == 'quoteProdNetAmt')||(parser.getText() == 'quoteServNetAmt')||(parser.getText() == 'dealExpirationDate')||(parser.getText() == 'dealCreatedOn')||(parser.getText() == 'programName')||(parser.getText() == 'promotionName')||(parser.getText() == 'discountType')||(parser.getText() == 'allowNs'))){
            System.debug('Yuppy:'+parser.getText());
            if(parser.getText() == 'dealName'){
            parser.nextValue();
            System.debug('Yuppy1:'+parser.getText());  
            DealName = parser.getText(); 
            System.debug('Hello World1:'+DealId); 
            }
            else if(parser.getText() == 'dealId')
            {
                parser.nextValue();
                DealId = parser.getText();
                System.debug('Hello World2:'+DealId);
            }
            else if(parser.getText() == 'dealStatus')
            {
                parser.nextValue();
                DealStatus = parser.getText();
                System.debug('Hello World99:'+DealStatus);
            }
            else if(parser.getText() == 'quoteId')
            {
                parser.nextValue();
                QuoteID = parser.getText();
                System.debug('Hello World999:'+QuoteID);
            }
            else if(parser.getText() == 'allowNs')
            {
                parser.nextValue();
                EligibleforNS = parser.getText();
                System.debug('Hello World100:'+EligibleforNS);
            }
            
            else if(parser.getText() == 'quoteProductListAmount')
            {
                parser.nextValue();
                QuoteProdListAmt = Decimal.valueOf(parser.getText());
                System.debug('Hello World3:'+QuoteProdListAmt);
                
            }
            else if(parser.getText() == 'quoteServiceListAmount')
            {
                parser.nextValue();
                QuoteServListAmt = Decimal.valueOf(parser.getText());
                System.debug('Hello World4:'+QuoteServListAmt);
            }
            else if(parser.getText() == 'CCWDealStatus')
            {
                parser.nextValue();
                QuoteStatus = parser.getText();
                System.debug('Hello World5:'+QuoteStatus);
            }
            else if(parser.getText() == 'expectedProductListAmount')
            {
                parser.nextValue();
                ExpProdListAmt = Decimal.valueOf(parser.getText());
                System.debug('Hello World6:'+ExpProdListAmt);
            }
            else if(parser.getText() == 'endCustAccountName')
            {
                parser.nextValue();
                EndCustAccName = parser.getText();
                System.debug('Hello World7:'+EndCustAccName);
            }
            else if(parser.getText() == 'endCustAddressLine1')
            {
                parser.nextValue();
                EndCustAddr1 = parser.getText();
                System.debug('Hello World8:'+EndCustAddr1);
            }
            else if(parser.getText() == 'endCustAddressLine2')
            {
                parser.nextValue();
                EndCustAddr2 = parser.getText();
                System.debug('Hello World9:'+EndCustAddr2);
            }
            else if(parser.getText() == 'endCustAddressLine3')
            {
                parser.nextValue();
                EndCustAddr3 = parser.getText();
                System.debug('Hello World10:'+EndCustAddr3);
            }
            else if(parser.getText() == 'endCustCity')
            {
                parser.nextValue();
                EndCustCity = parser.getText();
                System.debug('Hello World11:'+EndCustCity);
            }
            else if(parser.getText() == 'endCustCountry')
            {
                parser.nextValue();
                EndCustCountry = parser.getText();
                System.debug('Hello World12:'+EndCustCountry);
            }
            else if(parser.getText() == 'expectedServiceListAmount')
            {
                parser.nextValue();
                ExpServListAmt = Decimal.valueOf(parser.getText());
                System.debug('Hello World13:'+ExpServListAmt);
            }
            else if(parser.getText() == 'quoteProdNetAmt')
            {
                parser.nextValue();
                QuoteProductNetAmt = Decimal.valueOf(parser.getText());
                System.debug('Hello World14:'+QuoteProductNetAmt);
            }
            else if(parser.getText() == 'quoteServNetAmt')
            {
                parser.nextValue();
                QuoteServiceNetAmt = Decimal.valueOf(parser.getText());
                System.debug('Hello World15:'+QuoteServiceNetAmt);
            }
            else if(parser.getText() == 'dealExpirationDate')
            {
                parser.nextValue();
                //String dealexpdate = Date.valueOf(parser.getText()).format();
                DealExpirationDate = parser.getText();
                System.debug('Hello World16:'+DealExpirationDate);
            }
            else if(parser.getText() == 'dealCreatedOn')
            {
                parser.nextValue();
                //String dealcreated = Date.valueOf(parser.getText()).format();
                DealCreatedOn = parser.getText();
                System.debug('Hello World17:'+DealCreatedOn);
            } 
            else if(parser.getText() == 'programName')
            {
                parser.nextValue();
                ProgramName = parser.getText();
                System.debug('Hello World18:'+ProgramName);
            } 
             else if(parser.getText() == 'promotionName')
            {
                parser.nextValue();
                PromotionName = parser.getText();
                System.debug('Hello World19:'+PromotionName);
            } 
             else if(parser.getText() == 'discountType')
            {
                parser.nextValue();
                DiscountType = parser.getText();
                System.debug('Hello World20:'+DiscountType);
            }                       
            else if(parser.getText() == 'status')
            {
                parser.nextValue();
                System.debug('Tron1:'+parser.getText());
                if(parser.getText() == '0'){
                System.debug('Tron:'+parser.getText());
                 invalidDeal = true;
                 //Jsonresp = true;
                 break;
                 }
                 else
                 invalidDeal = false;
            System.debug('Tron1:'+invalidDeal);
            }
            //parser.nextToken();
               
            
          }
                // Get the value.
                //parser.nextToken();
               
            }
            
            if(invalidDeal != true){
            
            moq = new Multi_Object_Quote__c(Name = DealName,Deal_ID__c = DealId,Deal_Name__c = DealName,Quote_Product_List_Amount__c = QuoteProdListAmt,Quote_Service_List_Amount__c=QuoteServListAmt,Quote_Status__c=QuoteStatus,Expected_Product_List_Amount__c=ExpProdListAmt,Expected_Service_List_Amount__c=ExpServListAmt,End_Customer_Name__c=EndCustAccName,Address_Line_1__c=EndCustAddr1,Address_Line_2__c=EndCustAddr2,Address_Line_3__c=EndCustAddr3,City__c=EndCustCity,Country__c=EndCustCountry,Quote_Product_Net_Price__c=QuoteProductNetAmt,Quote_Service_Net_Price__c=QuoteServiceNetAmt,CR_Party_ID__c=DealCreatedOn,Is_Dummy_Quote__c=DealExpirationDate,Program_Name__c=ProgramName,Promotion_Name__c=PromotionName,Discount_Type__c=DiscountType,Deal_Status__c=DealStatus,Eligible_for_NS__c=EligibleforNS,DM_Quote_ID__c=QuoteID);
            Moqflag = true;
            moq_list= new List<Multi_Object_Quote__c>();
            moq_list.add(moq );
            System.debug('finally:'+moq );
        }
        
      
        
    }
    
    public PageReference ClearDeal(){
    
    if(ApexPages.currentPage().getParameters().get('id') != '' || ApexPages.currentPage().getParameters().get('id') != null){
    Case c1 = new case(Id = ApexPages.currentPage().getParameters().get('id'),CCW_Deal_or_Quote__c=null);
    update c1;
    }
    return null;
    }



//**************************************Pagination Code *************************************************************//
//checks whether the Next button on the pagination should appear or not.
public boolean getHasNext() {

    if(((npages == acpage)&&(remainder==0)) || getResultSize() == 0 || getResultSize() < pageSize || (acpage*pageSize) >=getResultSize()|| errorFlag == true)
          return false;
    else    
          return true;
    }
    
//checks whether the Previous button on the pagination should appear or not.
public Boolean getHasPrevious() {
        
    if( getResultSize() == 0 || acpage == 1 || errorFlag == true)
            return false;
        else
            return true;    
    }
//increase the value of page number .Executes when next button is clicked   
public void next() {
           acpage +=1;
   }

//decrease the value of page number .Executes when previous button is clicked   
public void previous() {
           acpage-=1;
    }

//Retrieves the page size.
public Integer getPageSize() {  
           return pageSize;   
    }  

//Setting the page Size
public void setPageSize(Integer ps) {
      
    if(ps != pageSize){       
                acpage =1;
                pageSize = ps;
        }
   }

//retrieves the results for the particular page.when page next or previous button is click, results are changed according to  the page number.
    public List<Opportunity> getResults() {
        Integer results;
        if(my_list == null){
            results = 0;
        }
        else{
            results = my_list.size();
        }
         if(results > pageSize)
         {
                 List<Opportunity> my_plist = new List<Opportunity>();
                 npages = results/pagesize;
                 remainder = results - (pageSize*npages);   
                    
                  for (integer i=0; i<pagesize; i++)
                  {
                     if(((acpage-1)*pagesize +i) < results){
                         system.debug('###index='+(acpage-1)* pageSize + i);
                         my_plist.add(my_list[(acpage-1)* pageSize + i]); 
                     }
                  }
                return my_plist;
         }        
         return my_list;
    }
    
    public List<Multi_Object_Quote__c> getMOQResults(){

        Integer results;
        if(moq_list == null){
            results = 0;
        }
        else{
            results = moq_list.size();
        }
        if(results > pageSize)
         {
             List<Multi_Object_Quote__c> my_plist = new List<Multi_Object_Quote__c>();
             npages = results/pagesize;
             remainder = results - (pageSize*npages);   
                
              for (integer i=0; i<pagesize; i++)
              {
                 if(((acpage-1)*pagesize +i) < results){
                     system.debug('####index='+(acpage-1)* pageSize + i);
                     my_plist.add(moq_list[(acpage-1)* pageSize + i]); 
                 }
              }
            return my_plist;
         }        
         return moq_list;
    }  
}