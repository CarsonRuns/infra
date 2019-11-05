global without sharing class SCP_Communities_WorkProspect_CT  {

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
    
    public Assigned_Partner__c tp1 { get; set ; }
    
    public List<SelectOption> psr1 { get; set; }
    public List<SelectOption> psr2 { get; set; }
    public List<SelectOption> psr3 { get; set; }
    
    public String psr1Id { get; set; }
    public String psr2Id { get; set; }
    public String psr3Id { get; set; }
    
    public Boolean isPA {
      get {
        return (prmFilterUtility.isPA);
      }
    }
    public static Integer errCode { 
      get
      {
        if(errCode== null ) 
          errCode= 0; 
        return errCode;
      }
      set; 
    }
    
    transient List<User> usersList;
    
    public static String accountId { 
      get {
          if(accountId == null) {
            accountId = ApexPages.currentPage().getParameters().get('Id');
          }
          return accountId;
      }
      set; }  
      
    public String returnURL { get; set; }
    
    public class MyException extends Exception {}
    
    public SCP_Communities_WorkProspect_CT() {
        tp1 = new Assigned_Partner__c();
        errCode= 0;
        // get Id's paramaters
        accountId = ApexPages.currentPage().getParameters().get('Id');
        returnURL = ApexPages.currentPage().getParameters().get('retURL');
        populateSelectOptions();
        
        
    }
    
    private List<User> getUsersList() {
        usersList = new List<User>();
        
        String [] userfields = new String [] { 'Id','firstname', 'lastname', 'name' };
        String orderBy = ' ORDER BY Name ';
        Integer qlimits = 250;
        
        prmFilterUtility filterUtility = new prmFilterUtility();
        
        usersList = filterUtility.getUserList(userfields,'',orderBy,qlimits);
        System.debug(System.LoggingLevel.INFO, '### usersList : '+usersList);
        return usersList;
    }
    
    private void populateSelectOptions() {
        
        if(usersList == null) {
            getUsersList();
        }
        
        if(usersList != null && !usersList.isEmpty()) {
            
            psr1 = new List<SelectOption>();  
            psr2 = new List<SelectOption>();
            psr3 = new List<SelectOption>();
        
            SelectOption option = new SelectOption('','');
            
            psr1.add(option);
            psr2.add(option);
            psr3.add(option);
            
            
            for(User u : usersList) {
                option = new SelectOption(u.Id, u.name);
                
                psr1.add(option);
                psr2.add(option);
                psr3.add(option);
                
            }
        }
        
        // Set PSR1 as current user
        psr1Id = userInfo.getUserId();
    }
    
    public static String save(String accId, String ta, String td, String p1, String p2, String p3 ) {
      // Validate required fields Target Architecture & Target Description
      Assigned_Partner__c tp = new Assigned_Partner__c();
      if(accId == null || accId == '') {
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.PRM_Invalid_Account_Id+''+accId+'');
        ApexPages.addMessage(myMsg);
        errCode= -1;
        return 'Error : Account Id is null : Error Code : '+errCode;
      }
      
      if(ta == null) {
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.PRM_Workprospect_Target_Architecture_Validation);
        ApexPages.addMessage(myMsg);
        errCode= -1;
        return 'Error : Please select a Target Architecture : Error Code : '+errCode;
      }
      if(td == null ) {
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.PRM_WorkProspect_Target_Description_Validation);
        ApexPages.addMessage(myMsg);
        errCode= -1;
        return 'Error : Please enter a target description : Error Code : '+errCode;
      }
      
      // For PA status = "Assigned to PSR"
      
      if(prmFilterUtility.isPA) {
        
        if(p1 == null && p2 == null && p3 == null) {
          ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.PRM_Please_select_a_psr_value);
          ApexPages.addMessage(myMsg);
          errCode= -1;
          return 'Error : Please select a psr value : Error Code : '+errCode;
        }
        if(flsUpdateGet(Assigned_Partner__c.Partner_Status__c)||flsGet(Assigned_Partner__c.Partner_Status__c)) //SCAVA FIX
        {
        tp.Partner_Status__c = 'Assigned to PSR';
        }
      }
      
      else {
        // FOR PSR status = "Actively Working"
        if(flsUpdateGet(Assigned_Partner__c.Partner_Status__c)||flsGet(Assigned_Partner__c.Partner_Status__c)) //SCAVA FIX
        {
        tp.Partner_Status__c = 'Actively Working';
        }
      }
      
      if(p1 == null || p1 == '') {
      if(flsUpdateGet(Assigned_Partner__c.assigned_PSR_SYS1__c)||flsGet(Assigned_Partner__c.assigned_PSR_SYS1__c)) //SCAVA FIX
        {
        tp.assigned_PSR_SYS1__c = null;
        }
      }
      else {
      if(flsUpdateGet(Assigned_Partner__c.assigned_PSR_SYS1__c)||flsGet(Assigned_Partner__c.assigned_PSR_SYS1__c)) //SCAVA FIX
        {
        tp.assigned_PSR_SYS1__c = p1;
        }
      }
      if(p2 == null || p2 == '') {
        if(flsUpdateGet(Assigned_Partner__c.assigned_PSR_SYS2__c)||flsGet(Assigned_Partner__c.assigned_PSR_SYS2__c)) //SCAVA FIX
        {
        tp.assigned_PSR_SYS2__c = null;
        }
      }
      else {
      if(flsUpdateGet(Assigned_Partner__c.assigned_PSR_SYS2__c)||flsGet(Assigned_Partner__c.assigned_PSR_SYS2__c)) //SCAVA FIX
        {
        tp.assigned_PSR_SYS2__c = p2;
        }
      }
      if(p3 == null || p3 == '') {
      if(flsUpdateGet(Assigned_Partner__c.assigned_PSR_SYS3__c)||flsGet(Assigned_Partner__c.assigned_PSR_SYS3__c)) //SCAVA FIX
        {
        tp.assigned_PSR_SYS3__c = null;
        }
      }
      else {
      if(flsUpdateGet(Assigned_Partner__c.assigned_PSR_SYS3__c)||flsGet(Assigned_Partner__c.assigned_PSR_SYS3__c)) //SCAVA FIX
        {
        tp.assigned_PSR_SYS3__c = p3;
        }
      }
      
      // "marketingPlayName" : 'Customer Intelligence'
      if(flsUpdateGet(Assigned_Partner__c.Target_Architecture__c)||flsGet(Assigned_Partner__c.Target_Architecture__c)) //SCAVA FIX
       {
      tp.Target_Architecture__c = ta;
      }
      if(flsUpdateGet(Assigned_Partner__c.Target_Description__c)||flsGet(Assigned_Partner__c.Target_Description__c)) //SCAVA FIX
      {
      tp.Target_Description__c = td;
      }
      if(flsUpdateGet(Assigned_Partner__c.Marketing_Play_Name__c)||flsGet(Assigned_Partner__c.Marketing_Play_Name__c)) //SCAVA FIX
       {
      tp.Marketing_Play_Name__c = 'Customer Intelligence';
      }
      if(flsUpdateGet(Assigned_Partner__c.Customer_Account__c)||flsGet(Assigned_Partner__c.Customer_Account__c)) //SCAVA FIX
      {
      tp.Customer_Account__c = accId;
      }
      String paId = prmFilterUtility.loggedInUserPartnerAccount;
      if(paId == null || paId == '') {
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,Label.PRM_Current_users_parant_account_is_null);
        ApexPages.addMessage(myMsg);
        errCode= -1;
        return 'Error : Current users parant account is null : Error Code : '+errCode;
      }
      System.debug(System.LoggingLevel.INFO,'### loggedInUserPartnerAccount :: '+paId);
      if(flsUpdateGet(Assigned_Partner__c.Assigned_Partner__c)||flsGet(Assigned_Partner__c.Assigned_Partner__c)) //SCAVA FIX
       {
      tp.Assigned_Partner__c = (Id)paId;
      }
      if(flsUpdateGet(Assigned_Partner__c.Expiration_Date__c)||flsGet(Assigned_Partner__c.Expiration_Date__c)) //SCAVA FIX
       {
      tp.Expiration_Date__c = Date.today().adddays(60);
      }
      System.debug(System.LoggingLevel.INFO,'### tp : '+tp);
      try {
        Database.SaveResult sr = Database.insert(tp);
        if(!sr.isSuccess()) {
          System.debug(System.LoggingLevel.ERROR, '############## Exception ############ '+sr.getErrors()[0].getMessage());
          ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,sr.getErrors()[0].getMessage());
          ApexPages.addMessage(myMsg);
          errCode= -1;
          return 'Error : '+sr.getErrors()[0].getMessage()+' : Error Code : '+errCode;
        }
      }
      catch(Exception ex) {
        System.debug(System.LoggingLevel.ERROR, '############## Exception ############ '+ex.getMessage());
        ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,ex.getMessage());
        ApexPages.addMessage(myMsg);
        errCode= -1;
        return 'Error : '+ex.getMessage()+' : Error Code : '+errCode;
      }
      return 'Sucess: : Error Code : '+errCode;
    }
    
    public Pagereference cancel(){
    
      if(returnURL != null ) {
        Pagereference pg = new Pagereference(returnURL);
        pg.setRedirect(true);
        return pg;
      }
      return null;
    }
    
    public Pagereference doSave() {
      String result = SCP_Communities_WorkProspect_CT.save(accountId,tp1.Target_Architecture__c,tp1.Target_Description__c,psr1Id,psr2Id,psr3Id);
      System.debug(System.LoggingLevel.INFO, '### result : '+result);
      System.debug(System.LoggingLevel.INFO, '### returnURL : '+returnURL);
      if(result.contains('Sucess')) {
        Pagereference pg = new Pagereference(returnURL);
        pg.getParameters().put('tpc','1');
        pg.setRedirect(true);
        return pg;
      }
      return null;
    }
    
}