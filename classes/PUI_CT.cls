public class PUI_CT {

    public PageReference PbePickListinact() {
        return null;
    }


    public PageReference qs() {
        return new PageReference('/006/o');
    }


    private String Service = 'Service';
    private String Technology = 'Technology';
    private String Active = 'Active';
    

    private OpportunityLineItem[] lit = new OpportunityLineItem[]{};
    //Technology Line Items

    private OpportunityLineItem[] lis = new OpportunityLineItem[]{};
    //Service Line Items

    private OpportunityLineItem[] toDelete = new OpportunityLineItem[]{};
    //Line Items to delete on Save. 
    
    private OpportunityLineItem[] olis;
    //all Line Items    
    
    private Final String oid = System.currentPageReference().getParameters().get('id');
    //Opportunity Id
    
    private Final String delID = System.currentPageReference().getParameters().get('delId');
    //Line Item selected to delete from Oppty Detail page
    
    //object for CreateRequestDetails Class related to SAC
    
    public String getQs() {
        Quote__c q = [Select Quote_Summary__c From Quote__c where Opportunity_Name__c = :oid limit 1];
        return q.Quote_Summary__c;
    }
    
    Opportunity Oppty = new opportunity();
    public Opportunity getOpportunity() {
    //Opportunity information displayed on Opportunity details section of page.     
        Oppty = [select 
            Account.Name, CloseDate, Name,
            Expected_Product__c, StageName, Expected_Service__c,
                Competitors__c,Sales_Support_Details__c,
            DealID__c,Sales_Support_Reminder__c,
            CurrencyIsoCode, Quote_Count__c,Opportunity_Status__c        
                from Opportunity 
                    where Id = :oid];
        
        getOpportunityLineItems();

        return Oppty;
    }
    

    public Account getAccountName(){//if Oppty.Account.Name is null, like on a new solution plan, the pui page generates an internal SFDC error when trying to access it directly on the Oppty Object.
        Account acctName = new Account();
        acctName.Name = Oppty.Account.Name;
        return acctName;
    }       
    
    
    public void getOpportunityLineItems() {
        if ( olis == null ){
            olis = [select Mix__c, Quantity,Technology_Competitor__c ,UnitPrice, Service_Level__c, Service_Category__c, Product_Family_US__c, PriceBookEntryId, PriceBookEntry.ProductCode, PriceBookEntry.Name                       
                from OpportunityLineItem where OpportunityId = :oid and PriceBookEntry.ProductCode in (:Service,:Technology) order by PriceBookEntry.Name];
        
            for ( OpportunityLineItem li : olis ){
                if(li.Id != delID){
                    if (li.PriceBookEntry.ProductCode == Technology){   lit.add(li);}
                    else if (li.PriceBookEntry.ProductCode == Service){ lis.add(li);}
                }
                else{
                    toDelete.add(li);
                    errorMsg = 'Click save to delete the line item ' + li.PriceBookEntry.Name;
                }       
            }
        }
    }       


    public List<OpportunityLineItem> getLineItemsService() {
        return lis;     
    }       
        
    public List<OpportunityLineItem> getLineItemsTechnology() {
        return lit;
    }   
                        
    //pbeId_Tech is a comma delimited list of price book id's to be added as Technology line items
    private String pbeId_Tech;
    public String getPbeId_Tech() { return pbeId_Tech;}
    public void setPbeId_Tech(String data) { pbeId_Tech = data; }

    //pbeId_Svc is a comma delimited list of price book id's to be added as Service line items
    private String pbeId_Svc;
    public String getPbeId_Svc() { return pbeId_Svc;}
    public void setPbeId_Svc(String data) { pbeId_Svc = data; }


    public PageReference addTech() {
    //adds new Technology line items to lit based on pbeId's passed from the page.      
        formatProductFamily(lit);
        for( String el: pbeId_Tech.split(',') ){
    
            OpportunityLineItem newOLI = new OpportunityLineItem(
                PriceBookEntryId=el,
                OpportunityId=oid,
                Quantity=1,
                TotalPrice=0,
                Mix__c=0
                              );
                
            lit.add(newOLI);
        }

        pbeId_Tech = '';

        return null;
    }

    public PageReference addSvc() {
    //adds new Service line items to lis based on pbeId's passed from the page.
        for( String el: pbeId_Svc.split(',') ){     

            OpportunityLineItem newOLI = new OpportunityLineItem(
                PriceBookEntryId=el,
                OpportunityId=oid,
                Quantity=1,
                
                TotalPrice=0,
                Mix__c=0);

            lis.add(newOLI);                
        }               

        pbeId_Svc = '';

        return null;
    }

    //delTechRowNum is rownumber of the Technology row to be removed from lit when the user clicks Del Technology
    private String delTechRowNum;
    public String getTechRowNum() { return delTechRowNum;}
    public void setTechRowNum(String data) { delTechRowNum = data; }

    //delSvcRowNum is rownumber of the Service row to be removed from lis when the user clicks Del Service
    private String delSvcRowNum;
    public String getSvcRowNum() { return delSvcRowNum;}
    public void setSvcRowNum(String data) { delSvcRowNum = data; }


    public PageReference delTech() {
    //removes the row from lit that the user has selected
        Integer i = Integer.valueOf(delTechRowNum);  
        if(lit.get(i).id != null){
            toDelete.add(lit.get(i));
        }
        lit.remove(i);
        formatProductFamily(lit);

        return null;
    }

    public PageReference delSvc() {
    //removes the row from lis that the user has selected
        Integer i = Integer.valueOf(delSvcRowNum);  
        if(lis.get(i).id != null){
            toDelete.add(lis.get(i));   
        }
        lis.remove(i); 
        return null;

    }

    public List<OpportunityLineItem> formatProductFamily(List<OpportunityLineItem> techOlis){
    //The javascript used in maintaining what Product Families are selected for a Technology uses a semicolon delimited list to pass the ProductFamily
    //ex. Pix;Router;Switch
    //      The user clicks del to remove the picklist for 'Router' the resulting value for ProductFamily becomes Pix;;Switch
    //This method removes multiple semicolons and leading semicolons 
        String tmp;
        Pattern dcPattern = Pattern.compile(';+');//remove multiple semicolon
        Pattern leadingcPattern = Pattern.compile('^;');//remove leading semicolon
        
        for( OpportunityLineItem oli: techOlis ){  
            tmp = oli.Product_Family_US__c;
            tmp =  dcPattern.matcher(tmp).replaceAll(';') ;
            tmp = leadingcPattern.matcher(tmp).replaceFirst('');
            oli.Product_Family_US__c = tmp;
            
        }
        return techOlis;
    }       
    
    public class PuiException extends Exception {}  
    
    private String errorMsg;
    public String getError_msg() { return errorMsg;}    
    
    public PageReference save() {
        Savepoint sp = Database.setSavepoint();        
        PageReference newpage = null;
        
        try{
            formatProductFamily(lit);
            
            Utilities.setSkip(true);//skips certain trigger functionality
            Utilities.setValidationSkip(true);                  
                        
            upsert lit;
            upsert lis;
            //SCAVA FIX
            if (OpportunityLineItem.sObjectType.getDescribe().isDeletable())
               {
                delete toDelete;
                }
                
            update Oppty;           
            
            newpage = new PageReference('/'+ oid);
            newpage.setRedirect(true);          
        } 
        catch (Exception e) {
            errorMsg = '**** Operation not committed. ****    ' + e;
            Database.rollback(sp);
          throw new PuiException('**** Operation not committed. **** ' + e);
        }
           return newpage;
           
   }
    Private List<SelectOption> pbePL;
    public List<SelectOption> getPbePickList(){
    //sets active PriceBookEntries in picklist created in a hidden div on the vf page.      
        if (pbePL == null){
            pricebook2 pb2 = [select Id from pricebook2 where name = 'Standard Price Book'];
            
            pbePL = new List<SelectOption>();
            String tmp;
            for(PriceBookEntry p : [Select Id,Name,Product2Id,ProductCode From PricebookEntry 
                            where isactive = true 
                                and ProductCode in (:Technology,:Service) 
                                and CurrencyIsoCode = :Oppty.CurrencyIsoCode
                                and pricebook2id = :pb2.Id]) { 
                tmp = p.Product2Id;
                tmp += ';'+p.ProductCode +';'+ p.Name;
                pbePL.add(new SelectOption(p.Id, tmp));
            }
            
           }
           
        return pbePL;
    }
    
    
    Private List<SelectOption> pbePLinact;
    public List<SelectOption> getPbePickListinact(){
    if(pbePLinact == null){
           pricebook2 pb21 = [select Id from pricebook2 where name = 'Standard Price Book'];
            
            pbePLinact = new List<SelectOption>();
            String tmp;
            for(PriceBookEntry p : [Select Id,Name,Product2Id,ProductCode From PricebookEntry 
                            where isactive = false 
                                and ProductCode in (:Technology,:Service) 
                                and CurrencyIsoCode = :Oppty.CurrencyIsoCode
                                and pricebook2id = :pb21.Id]) { 
                tmp = p.Product2Id;
                tmp += ';'+p.ProductCode +';'+ p.Name;
                pbePLinact.add(new SelectOption(p.Id, tmp));
           }
           }
           return pbePLinact;
    }



    public String splitSort(String workString, String delimiter){
    //sort picklist values so they don't need to be sorted in the browser.      
            List<String> pieces = new List<String>{};   
            String tmp ='';
    
            for (String el: workString.split(delimiter)){
                pieces.add(el);
            }
            pieces.sort();

            for (String el:pieces){
                tmp += el +';';
            }
            tmp= tmp.substring(0, tmp.length()-1);

            return tmp;
    }           




    Private List<SelectOption> Product2PL;
    public List<SelectOption> getProduct2PL(){
    //Create Product2 Picklist in hidden div of page.       
        if (Product2PL == null){

            Product2PL = new List<SelectOption>();
            String tmp;

            for (Product2 p : [Select Id, ProductCode,
                        Product_Family_1__c, Product_Family_2__c, Product_Family_3__c, Product_Family_4__c,
                        Name, 
                        Service_Level_1__c, Service_Level_2__c, Service_Level_3__c, Service_Level_4__c
                            From Product2 
                            where isactive = true and ProductCode in (:Technology,:Service) 
                            //and CurrencyIsoCode = :Oppty.CurrencyIsoCode
                            ]) {

                if(p.ProductCode == Technology){
                    
                    if (p.Product_Family_1__c != null){
                        tmp = p.Product_Family_1__c;
                    }
                    if (p.Product_Family_2__c != null){
                        if(tmp != null){tmp += ';'+ p.Product_Family_2__c;}
                        else{tmp = p.Product_Family_2__c;}
                    }
                    if (p.Product_Family_3__c != null){
                        if(tmp != null){tmp += ';'+ p.Product_Family_3__c;}
                        else{tmp = p.Product_Family_3__c;}
                    }
                    if (p.Product_Family_4__c != null){
                        if(tmp != null){tmp += ';'+ p.Product_Family_4__c;}
                        else{tmp = p.Product_Family_4__c;}
                    }

                    if (tmp != null){
                        tmp = splitSort( tmp, ';');
                        Product2PL.add(new SelectOption(tmp, p.Id));
                        tmp = null;
                    }


                }
                if(p.ProductCode == Service){
                    if (p.Service_Level_1__c != null){
                        tmp = p.Service_Level_1__c;
                    }
                    if (p.Service_Level_2__c != null){
                        if(tmp != null){tmp += ';'+ p.Service_Level_2__c;}
                        else{tmp = p.Service_Level_2__c;}
                    }
                    if (p.Service_Level_3__c != null){
                        if(tmp != null){tmp += ';'+ p.Service_Level_3__c;}
                        else{tmp = p.Service_Level_3__c;}
                    }
                    if (p.Service_Level_4__c != null){
                        if(tmp != null){tmp += ';'+ p.Service_Level_4__c;}
                        else{tmp = p.Service_Level_4__c;}
                    }

                    if (tmp != null){
//                      Product2PL.add(new SelectOption(p.Service_Level_1__c,p.Id));
                        tmp = splitSort( tmp, ';');
                        Product2PL.add(new SelectOption(tmp, p.Id));
                        tmp = null;
                    }
                }
            }
        }
        return Product2PL;  
    }

    String[] idk = new String[]{};
    public String[] getidk() {
        return idk;
    }
    public void setidk(String[] idk) {
        this.idk = idk;
    }

}