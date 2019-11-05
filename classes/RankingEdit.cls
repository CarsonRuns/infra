public class RankingEdit {
    public apexpages.standardsetcontroller con {get;set;}
      public apexpages.standardcontroller con1 {get;set;}
    public Integer noOfRecords{get; set;}
    public Integer size{get; set;}
    public  Ranking__C ranks;
   
    private Date setControllerBirthday {get; set;}
    private static string qString;
    
    
    private void BubblewrapSetController() {
        if (setControllerBirthday < Datetime.now().addMinutes(-10)) {
            integer pageNum = setCon.getPageNumber();  //maintain current page
            setCon = new ApexPages.StandardSetController(Database.getQueryLocator(qString));
            setCon.setPageNumber(pageNum);             //restore page
        }
    }
    
    public  Ranking__C r {get; set;}

    public List<Ranking__c> AllSearchRanks
    {
        get
        {
            if (con!= null)
                return (List<Ranking__c>)con.getRecords();
            else
                return null;
        }
        set;
    }
    
    
    public RankingEdit(ApexPages.StandardController controller) { 
        
       
        this.con1 = controller;
        this.r = (Ranking__C)this.con1.getRecord();
        AllSearchRanks = new List<Ranking__C>();
        
        
        
    } 
    
    public PageReference saveRank()
    {
        
       	if (this.r.id!= null)
        update this.r;
        return new PageReference('/' + this.r.ID); 
    }
    
     
    public ApexPages.StandardSetController setCon {
        get{
            if(setCon == null){
                 size = 15;
                Ranking__c ranks1;
                if (Test.isRunningTest())
                {
                    
                     ranks1 = [select id,theatre__C, Attribute_Name__c from Ranking__C where theatre__C = 'AMERICAS'  and attribute_name__C = 'LEAD CATEGORY' and attribute_value__C = 'BANT' ];
          	 
                    
                }
               
               else
               {
                 ranks1 = [select id,theatre__C, Attribute_Name__c from Ranking__C where id=:ApexPages.currentPage().getParameters().get('Id') ];
               }
          		string queryString = 'SELECT Theatre__c,Attribute_Name__C, Attribute_Value__c, Attribute_Ranking__C from Ranking__C where theatre__C = \''
                    + ranks1.theatre__C+'\' and attribute_name__c = \''+ranks1.Attribute_Name__c+'\' order by Theatre__c, Attribute_Name__C, Attribute_Value__c ';
                setCon = new ApexPages.StandardSetController(Database.getQueryLocator(queryString));
                queryString = qstring;
                setCon.setPageSize(size);
                noOfRecords = setCon.getResultSize();
                
                system.debug('SetCon: '+ noOfRecords);
                
            }
            return setCon;
        }
        set;
    }
    
    public List<Ranking__c> getRanks()
    {

        return (List <Ranking__C> )setCon.getRecords();//rankList;
    } 
    
    public PageReference refresh() {
        setCon = null;
        
        setCon.setPageNumber(1);
        return null;
    }
    
    
    
 
    public Boolean hasNext {
        get {
            return setCon.getHasNext();
        }
        set;
    }
    public Boolean hasPrevious {
        get {
            return setCon.getHasPrevious();
        }
        set;
    }
    
    public Integer pageNumber {
        get {
            return setCon.getPageNumber();
        }
        set;
    }
    
   
    
    
    public void first() {
        setCon.first();
    }
    
    public void last() {
        setCon.last();
    }
    
    public void previous() {
        setCon.previous();
    }
    
    public void next() {
        setCon.next();
    }
    
    
}