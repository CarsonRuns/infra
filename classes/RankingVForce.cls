public class RankingVForce {
    public apexpages.standardsetcontroller con {get;set;}
    public Integer noOfRecords{get; set;}
    public Integer size{get; set;}
    public Ranking__C ranks;
    public Lead_prioritization_model__c model {get; set;}
    private Date setControllerBirthday {get; set;} 
    private static string qString;
    public Boolean var1;
    
    private void BubblewrapSetController() {
        if (setControllerBirthday < Datetime.now().addMinutes(-10)) {
            integer pageNum = setCon.getPageNumber();  //maintain current page
            setCon = new ApexPages.StandardSetController(Database.getQueryLocator(qString));
            setCon.setPageNumber(pageNum);             //restore page
        }
    }
    public List<Ranking__c> AllSearchRanks
    {
        get
        {
            if (con== null)
                return null;
            
            else
                return (List<Ranking__c>)con.getRecords();
            
        }
        set;
    }
    
    
    public RankingVForce(ApexPages.StandardController controller) {
        
        AllSearchRanks = new List<Ranking__C>();
        ranks = new Ranking__C(); 
        model = new Lead_prioritization_model__c();
        model = (Lead_Prioritization_model__C) Controller.getRecord();
        
        
        
        
    } 
    
    public PageReference save()
    {
        update ranks;
        return new PageReference('/' + model.id); 
    }
    
    public PageReference edit()
    {
        String url = '/'+model.id+ '/e?retURL=%2F'+ model.id;
        return new PageReference('/' + url); 
    }
    
    public ApexPages.StandardSetController setCon {
        get{
            if(setCon == null){
                size = 15;
                
                if (Test.isRunningTest())
                {
                    
					model = [select id, theatre__C from Lead_prioritization_model__c where theatre__C = 'AMERICAS' limit 1];                    
                    
                }
                else
                {
                	String ModelID = ApexPages.currentPage().getParameters().get('Id');
                	if (ModelID != null)
                    model = [select Id, theatre__C from lead_prioritization_model__C where id = :ModelID ];
                    else
                    model = [select id, theatre__C from Lead_prioritization_model__c where theatre__C = 'AMERICAS' limit 1];                    
                    
                }
               
                String queryString = 'SELECT Theatre__c,Attribute_Name__C, Attribute_Value__c, Attribute_Ranking__C from Ranking__C where theatre__C = \''+ model.theatre__C+'\' order by Theatre__c, Attribute_Name__C, Attribute_Value__c ';
                setCon = new ApexPages.StandardSetController(Database.getQueryLocator(queryString));
                queryString = qString;
                setCon.setPageSize(size);
                noOfRecords = setCon.getResultSize();
                var1 = false;
                system.debug('SetCon: '+ noOfRecords);
                
            }
            return setCon;
        }
        set;
    }
    
    public List<Ranking__c> getRanks()
    {
         BubblewrapSetController();
        return (List <Ranking__C> )setCon.getRecords();//rankList;
    } 
    
    public PageReference refresh() {
        setCon = null;
        BubblewrapSetController();
        //getRanks();
        setCon.setPageNumber(1);
        return null;
    }
    
    
    
    public PageReference Search()
    {
        if (ranks.Theatre__c == null)
        {
            con=null;
        }
        else
        {
            con = new ApexPages.StandardSetController(Database.getQueryLocator([SELECT Theatre__c, Attribute_Name__C, Attribute_Value__c, Attribute_Ranking__C 
                                                                                FROM Ranking__c  ]));  
            con.setPageSize(10);
        }
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
        var1 = true;
        BubblewrapSetController();
        setCon.first();
    }
    
    public void last() {
        var1 = true;
        BubblewrapSetController();
        setCon.last();
    }
    
    public void previous() {
        var1 = true;
        BubblewrapSetController();
        setCon.previous();
    }
    
    public void next() {
        var1 = true;
        BubblewrapSetController();
        setCon.next();
    }
    
    
}