// ****************** Change History ******************
// WR-01199 - Consolidated the Oppty redirection to PUI for both Prod/Serv & FP.
//Modified By - karkamt for 16.02.19 Release
//Description - Added redirection logic for Buying Program.
// ****************** Change History ******************
public class Product_UI_Redirect_Skip_Stage1_CTE {
     //Variable to store stage 5- Cancelled value to skip PUI Redirection
    public String stage5 {get; set;}
      
    // FLAG TO CHECK IF isdtp parameter exists
    private Boolean isISTDP {
        get;
        set;
    }
    
    // Opportunity record
    public Opportunity opp {
        get;
        private set;
    }
    
    // Flag to check if redirection required based on forecast position
    @TestVisible
    public Boolean ForcastRedirect {
        get;
        private set;
    }
    
    //SCAVA fix, convert boolean into string
    @TestVisible
    public String ForcastRedirect1 {
        get{
            ForcastRedirect1 = (ForcastRedirect) ? 'true' : 'false' ;
            system.debug('ForcastRedirect1>>>>'+ForcastRedirect1);
            return ForcastRedirect1;
            
        }
        private set;
        
    }    
    
    // Flag to check if redirection required based on products
    @TestVisible
    public Boolean ProductRedirect {
        get;
        private set;
    }
  
    //SCAVA fix, convert boolean into string
    @TestVisible
    public String ProductRedirect1 {
        get{
            ProductRedirect1 = (ProductRedirect) ? 'true' : 'false' ;
            system.debug('ProductRedirect1>>>>'+ProductRedirect1);
            return ProductRedirect1;
        }
        private set;
    }
      
    // Product redirect URL (PUI page url)
    @TestVisible
    public PageReference PUI_URL {
        get {
          if(PUI_URL == null){
              if(opp.recordtypeid == Utilities.getOpptyRenewalRecordTypeId())
                    PUI_URL = Page.QI_ProductUI_Renew;
              else
                    PUI_URL = Page.QI_ProductUI_New;
          }
          return PUI_URL;
        }
        private set;
    }    
       
    //SCAVA fix, convert PageReference into string
    @TestVisible
    public string PUI_URL1 {
        get {
          if(PUI_URL1 == null)
            PUI_URL1 = PUI_URL.getUrl();
            return PUI_URL1;
        }
        private set;
    } 
        
    // Product redirect URL (PUI page url)
    @TestVisible
    public PageReference FP_URL {
        get {
          if(FP_URL == null )
            FP_URL = Page.ForecastPosition;           
            return FP_URL;
        }
        private set;
    }   
    
    
    //SCAVA fix, convert PageReference into string
    @TestVisible
    public string FP_URL1 {
        get {
          if(FP_URL1 == null)
            FP_URL1 = FP_URL.getUrl();
            return FP_URL1;
        }
        private set;
    } 
    
    // Controller
    public Product_UI_Redirect_Skip_Stage1_CTE(ApexPages.StandardController controller) {
        //Set value of Stage5 
        stage5 = '5 - Closed Cancelled';
        
              
        // Check if page has isdtp=mn
        String param1 = ApexPages.currentpage().getParameters().get('isdtp');
        isISTDP = (null != param1) ? ('mn' == param1) : false;

        // Get Opportunity details
        String oppId = controller.getId();
        system.debug('oppId'+oppId );
         // set forcast redirection 
        ForcastRedirect = false;
        ProductRedirect = false;

        opp = [Select Id, Position__c, OwnerId,StageName,HasOpportunityLineItem, 
                       Expected_Product__c, Expected_Service__c, 
                      Technology_Total_Mix__c, Service_Total_Mix__c, Enterprise_Agreement_Opportunity__c, 
                      Buying_Program__c,RecordType.developername, RecordTypeId
                 FROM Opportunity 
                WHERE Id = : oppId];
                
                PUI_URL.getParameters().put('id',opp.id);
        FP_URL.getParameters().put('id',opp.id);
        
        if(isISTDP) {
          PUI_URL.getParameters().put('isdtp','mn');
          FP_URL.getParameters().put('isdtp','mn');
        }

        if(opp.StageName != '1 - Prospect') {

        // get user details    
        User cuser = [Select Id, Profile.Name From User Where Id = : userinfo.getUserId()];
        // get constants
        string profiles = Utilities.getConstant_CS('Exclude From PUI and Competitor Popup');
        System.debug('profiles value here'+profiles);
        List<string> pieces = new List<string>();
        if (profiles != null && profiles != 'NA') {
          pieces = profiles.split(',');
         System.debug('pieces value here'+pieces); 
        }

        integer n = 0;
        if (pieces.size() > 0) {
          for (string p: pieces) {
            if (p == cuser.profile.Name) {
              n = 1;
              break;
            }
          }
        }

       
        
        PUI_URL.getParameters().put('id',opp.id);
        FP_URL.getParameters().put('id',opp.id);
        
        if(isISTDP) {
          PUI_URL.getParameters().put('isdtp','mn');
          FP_URL.getParameters().put('isdtp','mn');
        }
        
        
            if (null != opp && n == 0) {
                // get oppty owners forecast position
                User optyOwner = [Select Id, Position_1__c,profile.name From User Where Id = : opp.OwnerId];
                system.debug('optyOwner<<<<>>>'+optyOwner );
                String [] postArr;
                // WR-01199 - Redirect user to PUI only when more than one position is applicable to Owner. Bypass Admin user from the login.
                if(!String.isBlank(optyOwner.Position_1__c)){
                    String[] positionArr = optyOwner.Position_1__c.split('\n');
                    postArr = optyOwner.Position_1__c.split('\n');
                    System.debug('Opty owner position ---->'+optyOwner.Position_1__c);
                    system.debug('positionArr>><<<'+positionArr);
                    if (opp.Position__c == null && (optyOwner.Position_1__c != null && positionArr.size() > 1)) {
                        ForcastRedirect = true;
                      
                    }
                    
                    
                }
                System.debug('Post Array --->'+postArr);
                              
                //Set no product redirection flag
                 if(( !OpportunityService.hasValidTechnology(opp) || !OpportunityService.hasValidService(opp))
                                && opp.recordtypeid != Utilities.getOpptyRenewalRecordTypeId()){
                    System.debug('Inside Product redirect ---->');
                    ProductRedirect = true;
                }
                
               
             
            }// End of opp null if
        } else {
             // get oppty owners forecast position
                User optyOwner = [Select Id, Position_1__c,profile.name From User Where Id = : opp.OwnerId];
                // WR-01199 - Redirect user to PUI only when more than one position is applicable to Owner. Bypass Admin user from the login.
                if(!String.isBlank(optyOwner.Position_1__c)){
                    String[] positionArr = optyOwner.Position_1__c.split('\n');
                    //system.debug(positionArr);
                    if (opp.Position__c == null && (optyOwner.Position_1__c != null)) {
                        ForcastRedirect = true;
                    }
                   
                }
            //system.debug('ForcastRedirect'+optyOwner.Position_1__c+opp.Position__c);
           } 
        system.debug('opp.Enterprise_Agreement_Opportunity__c:'+opp.Enterprise_Agreement_Opportunity__c);
        system.debug('Buying_Program__c:'+opp.Buying_Program__c);
       //if(opp.Enterprise_Agreement_Opportunity__c=='Yes' && (opp.Buying_Program__c == null || opp.Buying_Program__c=='No' || opp.Buying_Program__c=='' || opp.Buying_Program__c=='__')){
       if(opp.Enterprise_Agreement_Opportunity__c=='Yes' && (opp.Buying_Program__c == null || opp.Buying_Program__c=='No' || opp.Buying_Program__c=='' || opp.Buying_Program__c=='__') && opp.recordtypeid != Utilities.getOpptyRenewalRecordTypeId()){
          ProductRedirect = true;
      }
    }// End of constructor
}