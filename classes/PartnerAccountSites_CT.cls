public with sharing class PartnerAccountSites_CT {
    public List<ViewObject> listViewData ;
    public String accountId {get; set;}
    
    private Integer pagesize = 5;
    public Integer totalPages {get; set;}
   
    public PartnerAccountSites_CT(ApexPages.StandardController controller) {
       
    }
    
    public ApexPages.StandardSetController con {
        get {
            if(con == null) {
                accountId = ApexPages.currentpage().getparameters().get('Id');
                /*con = new ApexPages.StandardSetController(Database.getQueryLocator([Select a.Id,a.Name,a.AddressLine1__c,
                                        a.AddressLine2__c,a.City__c,
                                        a.Country__c,a.State__c,
                                        (Select id from Contacts)  
                     from Account a  where a.ParentId = :accountId limit 100]));*/
                     
                List<Account> listData = [Select a.Id,a.Name,a.AddressLine1__c,
                                        a.AddressLine2__c,a.City__c,
                                        a.Country__c,a.State__c,
                                        (Select id from Contacts)  
                                         from Account a  where a.ParentId = :accountId limit 100];
                con = new ApexPages.StandardSetController(listData);
                          
                     
                // sets the number of records in each page set
                con.setPageSize(pagesize);
            }
            return con;
        }
        set;
        }
    
    
      
    public List<ViewObject> getListViewData()
    {
       
      
        listViewData = new List<ViewObject>();      

        // get resultset from the standard controller
        List<Account> listdata = (List<Account>)con.getRecords();
        
       // total page count
        totalPages = con.getResultSize()/pagesize + 1;
        
                                                                        
        for (Integer i = 0; i<= listdata.size() - 1; i++)
        {
                Account a = (Account) listdata[i]; 
                
                ViewObject v = new ViewObject();
                v.account = a;
                                
                // get the array of contacts for the account.
                Integer contactCount = 0;
                Contact[] accountContacts = a.contacts;
                for (Contact c: accountContacts )
                {
                    contactCount = contactCount + 1;               
                }               
                
                v.contactCount = contactCount;
                
                listViewData.add(v);
        }  
        
        return listViewData;                     
        
    }
    
    public pagereference dummyAction()
    {
      return null;
    }
    
    /*****************************************
    * PAGINATION METHOD START HERE
    ******************************************/
    public boolean hasNext
    {
      get {
        return con.getHasNext();    
      }  
      set;
    }
    
    public boolean hasPrevious
    {
      get { 
          return con.getHasPrevious();
      }    
    }
    
    public void previous()
    {
       con.previous();
    }
    
    public void next()
    {
      con.next();
    }
    
    public Integer pageNumber
    {
      get {
        return con.getPageNumber();
      }
      set;  
    }

    /*****************************************
    * PAGINATION METHOD END HERE
    ******************************************/

 
    // Used to send data over to the view.
    class ViewObject
    {
       public Account account{get; set;}
       public Integer contactCount {get; set;}
    }
    
    // TEST METHODS HERE
     public static testMethod void testPartnerAccountSites_CT()
     {
       test.startTest();
              
       ApexPages.StandardController con = new ApexPages.StandardController(new Account());
       PartnerAccountSites_CT controller = new PartnerAccountSites_CT(con);
            
       // get the partner record type
       String partnerAccountRecordType = Utilities.getAccountPartnerCompanyRecordTypeId();
       
       // insert a dummy partner company record
       Account partnerCompany = new Account();
       partnerCompany.RecordTypeId = partnerAccountRecordType;
       partnerCompany.Name = 'Dummy Account';
       
       insert partnerCompany;
             
       // get a partner company record type
       //Account a = [select Id from Account a where a.RecordTypeId = :partnerAccountRecordType limit 1 ];
       
       controller.accountId = partnerCompany.Id;
              
       // get the channel accounts for the partner company selected
       controller.getListViewData();
       
       //call the dummy action methof
       System.assertEquals(null, controller.dummyAction());
       
              
       test.stopTest();
       
     }
 
}