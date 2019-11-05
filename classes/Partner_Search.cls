public class Partner_Search{

//defining variables
public String searchText { get; set; }
public Boolean errorFlag { get; set; }
public String errorMsg { get; set; }
public String pntrType { get; set; }
public String pntrGroup { get; set; }
public String pntrTypeId { get; set; }
public String pntrGroupId { get; set; }
public String prdSvcDDVal { get; set; }
public String mboPgmId { get; set; }
public String pgIds { get; set; }
public String trackName { get; set; }
public String pgmName { get; set; }
public Boolean limitFlag { get; set; }
public Boolean partnerGroupFlag { get; set; }
public Boolean partnersFlag { get; set; }

public String searchType { get; set; }
public List<MBO_Partner_Group__c> partnerGroups;
public List<MBO_Partner_Enrollment__c> partners;

    //defining Constructor
    public Partner_Search(ApexPages.StandardSetController controller) 
    {
        //getting all the parameters provided in the URL
        this.searchText = ApexPages.currentPage().getParameters().get('stringvalue');
        this.searchType = ApexPages.currentPage().getParameters().get('stringtype');
        this.pntrTypeId = ApexPages.currentPage().getParameters().get('pntrTypeId');
        this.pntrGroupId = ApexPages.currentPage().getParameters().get('pntrGroupId');
        this.pntrType = ApexPages.currentPage().getParameters().get('pntrType');
        this.pntrGroup = ApexPages.currentPage().getParameters().get('pntrGroup');
        this.prdSvcDDVal= ApexPages.currentPage().getParameters().get('prdSvcDDVal');
        this.mboPgmId= ApexPages.currentPage().getParameters().get('mboPgmId');
        this.pgIds= ApexPages.currentPage().getParameters().get('usedPGIds');
        
        //this.searchText = '';
        errorFlag = false;
        limitFlag = false;
        
        Integer pgmCnt=[select count() from MBO_Program__c where Id=:mboPgmId];
        System.debug('***pgmCnt'+pgmCnt);
        System.debug('***searchText'+searchText);
        if(pgmCnt > 0)
        {
            MBO_Program__c pgm=[select Name, Track__c from MBO_Program__c where Id=:mboPgmId];
            System.debug('***pgm'+pgm);
            trackName=pgm.Track__c;
            pgmName=pgm.Name;
            if(searchText.length()==1)
            {
               System.debug('***searchText'+searchText);
                errorFlag = true;
            }
            else 
            {
                Set<String> pgIdSet=new Set<String>();
                System.debug('***Inside Else');
                if(this.pgIds!=null && this.pgIds!='')
                {
                    System.debug('***pgIds not null');
                    pgIdSet=new Set<String>(this.pgIds.split(',',-2));
                }
                
                //if selected type is group then getting all the active groups
                if(searchType=='Partner Group')
                { 
                    partnerGroupFlag = true;
                    partnersFlag = false;
                    partnerGroups = [select Name, Group_Level__c, Id, Active__c, Country_Country_Group__c, Enrollment_Period__c , Partner_Group_Type__c from MBO_Partner_Group__c where MBO_Program__c=:mboPgmId and name like :('%'+ searchText+'%') and Id not in :pgIdSet and  (NOT UsedBy__c like:'%'+prdSvcDDVal+'%') and active__c = true];
                    System.debug('***partnerGroups'+partnerGroups);
                    
                    //If there are many records to display then provide this message to User
                    if(partnerGroups.size() >1000)
                    {
                    limitFlag = true;
                    }
                    else if(partnerGroups.size() == 0)
                    {
                        errorMsg='No Partner Groups found';
                    }
                }  
                else
                {
                    //if selected type is partner then getting all the active partners
                    partnerGroupFlag = false;
                    partnersFlag = true;
                    system.debug('***2'+searchText);
                    partners = [select Name, Id, PARTNER_ENROLLMENT_STATUS__c, Partner__r.name, Country_Group__c, Country__c,PROGRAM_NAME__c  from MBO_Partner_Enrollment__c where Partner__r.name like :('%'+ searchText+'%') 
                    and PARTNER_ENROLLMENT_STATUS__c = 'APPROVED' and Program_Name__c=:pgmName and SUBTRACK_NAME__c=:prdSvcDDVal and TRACK_NAME__c =:trackName and Partner__c not in :pgIdSet and Used_Count__c =null];
                    //If there are many records to display then provide this message to User                
                    System.debug('***partners :'+partners);
                    if(partners.size() >1000)
                    {
                    limitFlag = true;
                    }
                    else if(partners.size() == 0)
                    {
                        errorMsg='No Partners found';
                    }
              }
         }
     }    
 }

//Setup for displaying Records Per Page 
    public integer npages;
    public integer remainder;
    public integer acpage = 1;
    public Integer PageSize = 10 ;

    //This method will give boolean result 'TRUE' if there is more data to display and 'FALSE' if not
    public boolean getHasNext() {
         if(((npages == acpage)&&(remainder==0)) || getResultSize() == 0 || getResultSize() < pageSize || (acpage*pageSize) >=getResultSize()|| errorFlag == true)
            return false;
        else    
            return true;
    }
    
    //This method will give boolean result 'TRUE' if there is previous data/records to display and 'FALSE' if not
    public Boolean getHasPrevious() {
        if( getResultSize() == 0 || acpage == 1 || errorFlag == true)
            return false;
        else
            return true;    
    }
    
    //This method will give the page size
    public Integer getPageSize() {  
           return pageSize;   
    }  

    //This method will set the page size
    public void setPageSize(Integer ps) {
           if(ps != pageSize)
            {       
                acpage =1;
                pageSize = ps;
            }
   }
   
   //This method will give the number of records in the result list
    public Integer getResultSize() {
        
        system.debug('***searchType'+searchType);
        system.debug('***partnerGroups'+partnerGroups);
        system.debug('***partners'+partners);
        
        if(searchType=='Partner Group')
        {
            if(partnerGroups == null)
                return 0;
            else
                return partnerGroups.size();
            }
        else
        {
            if(partners == null)
                return 0;
            else
                return partners.size();
        }
   }
   
   //This method will give the list of records of Partner Groups
    public List<MBO_Partner_Group__c> getPartnerGroups() {

     system.debug('***getResultSize()'+getResultSize());
     system.debug('***pageSize'+pageSize);
     system.debug('***partnerGroupFlag'+partnerGroupFlag);
     system.debug('***partnersFlag'+partnersFlag);
     
     //If there are more records then the page size then will display the records in different pages using Pagination.
     if(getResultSize() > pageSize && partnerGroupFlag)
     {
             List<MBO_Partner_Group__c> my_plist = new List<MBO_Partner_Group__c>();
             npages = getResultsize()/pagesize;
             remainder = getResultsize() - (pageSize*npages);   
              
              for (integer i=0; i<pagesize; i++)
              {
                 if(((acpage-1)*pagesize +i) < getResultsize())
                    my_plist.add(partnerGroups[(acpage-1)* pageSize + i]); 
               }
            
            return my_plist;
    }
    //If number of records are less than the page size then will display all the records in a single page.  
    return partnerGroups;

}

   //This method will give the list of records of Partners (Accounts in SFDC)
    public List<MBO_Partner_Enrollment__c> getPartners() {
    
    system.debug('***getResultSize()'+getResultSize());
     system.debug('***pageSize'+pageSize);
     system.debug('***partnerGroupFlag'+partnerGroupFlag);
     system.debug('***partnersFlag'+partnersFlag);
     
    
    
    //If there are more records then the page size then will display the records in different pages using Pagination.
    if(getResultSize() > pageSize && partnersFlag)
     {
             List<MBO_Partner_Enrollment__c> my_plist = new List<MBO_Partner_Enrollment__c>();
             npages = getResultsize()/pagesize;
             remainder = getResultsize() - (pageSize*npages);   
             
              for (integer i=0; i<pagesize; i++)
              {
                if(((acpage-1)*pagesize +i) < getResultsize())
                 my_plist.add(partners[(acpage-1)* pageSize + i]); 
               }
            return my_plist;
     }    
     //If number of records are less than the page size then will display all the records in a single page.    
     return partners;
      

}
    //This method increments the page counter when user hits the NEXT button
    public void next() {
           acpage +=1;
           }
  
    //This method decrements the page counter when user hits the PREVIOUS button
    public void previous() {
           acpage-=1;
    }
 

    //This method Search the records based on the given search string
    public PageReference doSearch() {
    limitFlag = false;
 
    if(searchText.length()>1 )
    {
        if(searchText.contains('*'))
        { errorMsg='Search Text cannot contain *'; }
        else { errorMsg=''; }
     errorFlag = false;
    
     acpage = 1;
     
            Set<String> pgIdSet=new Set<String>();
           if(this.pgIds!=null && this.pgIds!='')
           {
            pgIdSet=new Set<String>(this.pgIds.split(',',-2));
           }                

            if(searchType=='Partner Group')
            {
                partnerGroups = [select Name, Id, Group_Level__c, Active__c , Country_Country_Group__c, Enrollment_Period__c, Partner_Group_Type__c from MBO_Partner_Group__c where MBO_Program__c=:mboPgmId and name like :(searchText+'%') and Id not in :pgIdSet and (NOT UsedBy__c like:'%'+prdSvcDDVal+'%') and active__c = true];
                            
                if(partnerGroups.size() >1000)
                {
                limitFlag = true;
                }else if(partnerGroups.size() == 0)
                {
                    errorMsg='No Partner Groups found';
                }
            }
            else
            {
                system.debug('***'+searchText);
             
                partners = [select Name, Id, PARTNER_ENROLLMENT_STATUS__c, Partner__r.name, Country_Group__c, Country__c, PROGRAM_NAME__c  from MBO_Partner_Enrollment__c where Partner__r.name like :(searchText+'%') 
                and PARTNER_ENROLLMENT_STATUS__c = 'APPROVED' and Program_Name__c=:pgmName and SUBTRACK_NAME__c=:prdSvcDDVal and Partner__c not in :pgIdSet and Used_Count__c =null and TRACK_NAME__c =:trackName];
             
                            
                if(partners.size() >1000)
                {
                limitFlag = true;
                }else if(partners.size() == 0)
                {
                    errorMsg='No Partners found';
                }                
            }
                
    }
    else
    {
     errorFlag = true;    
    }
return null;
}



}