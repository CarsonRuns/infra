/********** Change History **********
 * @Release: Q1FY17
 * @Modification History: 
  01-kikamara:WR-01662 Replaced getOrgConstant object to getConstant_CS Custom setting

  ***************************************/
public class OpptySearch_CT {
    //Class for VF page in Quote       
    String ActiveStatus = 'Active';
    String BookedStatus = 'Booked';
    String QualifiedDMStatus = 'Qualified'; 
    public Pagination myPaginator = new Pagination(5);    
    String qry = 'Select Name from opportunity where id = :testid';
    
    String userTheme = UserInfo.getUiThemeDisplayed();
       
    
    public PageReference SortResults(String ColumnName) {    
       String qry1 = qry.replace('limit 800','order by '+ColumnName+' limit 800');
       myPaginator.setMy_list(qry1);       
       return null;
    }

    public PageReference SortResultsName() {    
       String qry1 = qry.replace('limit 800','order by name limit 800');
       myPaginator.setMy_list(qry1);
       return null;
    }
    
    public PageReference SortResultsAccount() {    
       String qry1 = qry.replace('limit 800','order by account.name limit 800');
       myPaginator.setMy_list(qry1);
       return null;
    }
    
    public PageReference SortResultsAddress() {
       String qry1 = qry.replace('limit 800','order by Account.AddressLine1__c limit 800');
       myPaginator.setMy_list(qry1);
       return null;
    }

    public PageReference SortResultsStage() {
       String qry1 = qry.replace('limit 800','order by stagename limit 800');
       myPaginator.setMy_list(qry1);
       return null;
    }    
    
     public PageReference SortResultsCloseDate() {
       String qry1 = qry.replace('limit 800','order by CloseDate limit 800');
       myPaginator.setMy_list(qry1);
       return null;
    }

    public PageReference SortResultsOwner() {
       String qry1 = qry.replace('limit 800','order by Owner.Name limit 800');
       myPaginator.setMy_list(qry1);
       return null;
    }   
    
    public PageReference cancel() {    
       /* String hostname = System.currentPageReference().getParameters().get('theHiddenBase');
        return new PageReference(hostname + ApexPages.currentPage().getParameters().get('retURL'));*/
        //SCAVA FIX
        string host=null;
        String hostname = System.currentPageReference().getParameters().get('theHiddenBase');
        if(hostname!=null && hostname!='')
          host = String.escapeSingleQuotes(hostname); 
         if(host!=null && host.startsWith('https')){
          host = host.replaceFirst('https',''); 
         }
        return new PageReference('https'+host + ApexPages.currentPage().getParameters().get('retURL'));
        
    }
    
    String OrderColumn ='owner.name';
    Public String getOrderColumn()
    {
        return OrderColumn;
    }

    Public void setOrderColumn(String ColumnName)
    {
        OrderColumn=ColumnName;
    }

    public PageReference view() {
        String parent = Utilities.getOpptyParentRecordTypeId();
        system.debug('parent>>'+parent);
        String PartnerParent = Utilities.getOpptyPartnerParentRecordTypeId();
        system.debug('PartnerParent>>'+PartnerParent);
        String ret = ApexPages.currentPage().getParameters().get('retURL');
        system.debug('ret>>'+ret );
        String AcctId = '';
        system.debug('AcctId>>'+AcctId);
        
        
        if(ret != null && ret.startsWith('/001') && AcctName == null && PartnerName == null && OpptyName == null){
            AcctId = ret.substring(1); 
            OpptyName = '';
            PartnerName = ''; 
            AcctName = ''; 
        }
        
        if(AcctName != null || PartnerName != null ||  OpptyName != null){       
           qry = 'Select Name, DealID__c, Id, Account.Name, Primary_Partner__r.Name, StageName, CloseDate, Owner.Name, Owner.Alias, Account.AddressLine1__c, Account.City__c, Account.State__c, Account.Country__c From Opportunity Where Opportunity_Status__c IN(\'' + ActiveStatus + '\', \'Booked\') AND DealID__c != null AND territory2Id != null AND ((RecordTypeId = \'' + parent + '\' AND DM_STATUS_CODE__c Like \'C%\') OR (RecordTypeId = \'' + PartnerParent + '\' AND Partner_Deal_Status__c = \'Qualified\')) '; 
           system.debug('qry>>');            
            
            if(AcctId != '' && AcctName == '' && PartnerName == '' && OpptyName == ''){
               //qry = qry + 'AND AccountId = \'' + AcctId + '\' ';
               //SCAVA FIX
                qry = qry + 'AND AccountId = \'' + String.escapeSingleQuotes(AcctId) + '\' ';
                system.debug('qry>>'+qry);
            }         
            if(OpptyName != null && OpptyName.trim() != ''){
                opptyName = opptyName.replace('*','%');
               //qry = qry + 'AND Name Like \'' + OpptyName.trim() + '\' ';
               //SCAVA FIX
                qry = qry + 'AND Name Like \'' + String.escapeSingleQuotes(OpptyName.trim()) + '\' ';
                system.debug('qry>>'+qry);
                system.debug('>>:String.escapeSingleQuotes(OpptyName.trim())');
            }
            if(AcctName != null && AcctName.trim() != ''){
                AcctName = AcctName.replace('*','%');
               //qry = qry + 'AND Account.Name Like \'' + AcctName.trim() + '\' ';
               //SCAVA FIX
                qry = qry + 'AND Account.Name Like \'' + String.escapeSingleQuotes(AcctName.trim()) + '\' ';
                system.debug('>>>qry'+qry );
            }
            if(PartnerName != null && PartnerName.trim() != ''){
                PartnerName = PartnerName.replace('*','%');
               //qry = qry + 'AND (Primary_Partner__r.Name Like \'' + PartnerName.trim() + '\' OR Partner_2__r.Name Like \'' + PartnerName.trim() + '\' OR Partner_3__r.Name Like \'' + PartnerName.trim() + '\' OR Partner_4__r.Name Like \'' + PartnerName.trim() + '\' OR Partner_5__r.Name Like \'' + PartnerName.trim() + '\') ';
                //SCAVA FIX
                qry = qry + 'AND (Primary_Partner__r.Name Like \'' + String.escapeSingleQuotes(PartnerName.trim()) + '\' OR Partner_2__r.Name Like \'' + String.escapeSingleQuotes(PartnerName.trim()) + '\' OR Partner_3__r.Name Like \'' + String.escapeSingleQuotes(PartnerName.trim()) + '\' OR Partner_4__r.Name Like \'' + String.escapeSingleQuotes(PartnerName.trim()) + '\' OR Partner_5__r.Name Like \'' + String.escapeSingleQuotes(PartnerName.trim())+ '\') ';
            }
            if(ownOpptys == true){
                qry = qry + 'AND OwnerId = \'' + UserInfo.getUserId() + '\' ' ;
            }                    
            
            qry = qry + 'limit 800';                    
            myPaginator.setMy_list(qry); 
            system.debug('>>:myPaginator.setMy_list()');
            opptyName = opptyName.replace('%','*');
            AcctName = AcctName.replace('%','*');
            PartnerName = PartnerName.replace('%','*'); 
            if(AcctId != '' && AcctName == '' && PartnerName == '' && OpptyName == ''){
               if(OpptySet.size() > 0){
                   for(Opportunity o : OpptySet){
                      AcctName = o.Account.Name;
                   }
               }
               else{
                   Account a = [Select Name From Account Where id = :AcctId];
                   AcctName = a.Name;
                   system.debug('AcctName>>'+AcctName );
               }
            }                  
       }
       return null;
    }

    public PageReference go() {
        group1 = System.currentPageReference().getParameters().get('group1');
        String entUrl = System.currentPageReference().getParameters().get('theHiddenInput');
        String hostname = System.currentPageReference().getParameters().get('theHiddenBase');       
        String pdrUrl = Utilities.getConstant_CS('PDR URL');
        
         string sfdcmode = ApexPages.currentPage().getParameters().get('mode');
        //Added mode cls or lgt to send to CCW for navigation back and forth
        
        if (sfdcmode == null) 
        {
            if (UserInfo.getUiThemeDisplayed() == 'Theme3') {
                sfdcmode = 'cls'; 
            }
            else 
            {
                sfdcmode = 'lgt';
            }
        }
            
        
        if(group1 != null && group1 != '')
            return new PageReference(pdrUrl + '/SFDCRequestHandler?at=fieldQuote&optyNumber='+group1+'&userid='+userInfo.getUserId()+'&email='+userInfo.getUserName()+'&sessionid='+userInfo.getSessionId()+'&url='+entUrl+'&hostname='+hostname+'&cancel=apex/OpptySearch'+'&mode='+sfdcmode);
        else
            return null;
    }
    
    public PageReference newOppty() {
    
         string sfdcmode = ApexPages.currentPage().getParameters().get('mode');
        //Added mode cls or lgt to send to CCW for navigation back and forth
        
        if (sfdcmode == null) 
        {
            if (UserInfo.getUiThemeDisplayed() == 'Theme3') {
                sfdcmode = 'cls'; 
            }
            else 
            {
                sfdcmode = 'lgt';
            }
        }
            
        String parent = Utilities.getOpptyParentRecordTypeId();
        User u = [Select Theatre__c From User Where Id = :UserInfo.getUserId()];
        String Theater = u.Theatre__c;
        if(Theater == null)
            Theater = '--None--';
        String theaterField = '&00N30000001c5cL=';
        return new PageReference('/006/e?retURL=/apex/OpptySearch&RecordType=' + parent + theaterField + theater + '&rt=Opportunity&nooverride=1'+'&mode='+sfdcmode);
    }
    
    String group1 = System.currentPageReference().getParameters().get('group1');
    
    public String AcctName {get; set;}
    
    public String PartnerName {get; set;}
    
    public String OpptyName {get; set;}
    
    public Boolean OwnOpptys {get; set;}
    
    public String getGroup1(){
        return group1;
    }
    List<opportunity> OpptySet = new List<opportunity>{}; 
    
    public List<Opportunity> getOpptySet() {
        return (List<opportunity>)myPaginator.getList();
    }
    public Integer getPageSize() {
        return myPaginator.pageSize;
    }
    public void setPageSize(Integer i) {
        myPaginator.Pg_setPageSize(i);
    }
    public Integer getResultSize() {
        return myPaginator.getListSize();
    }
    public void previous() {
        myPaginator.Pg_previous();
    } 
    public Boolean getHasPrevious() {
        return myPaginator.Pg_HasPrevious();
    }
    public void next() {
        myPaginator.Pg_next();
    } 
    public Boolean getHasNext() {
      return myPaginator.Pg_HasNext();
    } 
    
}