/**
   *     ------Revision------
   *        Version 2.0: 
   *    By: <Developer – Suresh>
   *        <Version 2.0>
   *    Description <QueryLimit updated from 250 to 500>    
   *    CreateDate <02-06-2015> 
   *    Release -- FY'15 Release   
   */

public without sharing class prmPSRLookUp_CT {
    public class WrapperUser {
        public Boolean isSelected { get; set; }
        public User userRec { get; set;}
        public WrapperUser(User obj) {
            this.userRec = obj;
            isSelected = false;
        }
    }
    public List<String> excludeUserIds;
    public List<WrapperUser> userList;
    public Id currentUserParentAccountId;
    public string psrId { get; set; }
    public prmPSRLookUp_CT() {
        this.psrId = getPsrId(); 
        excludeUserIds = getExcludeUserIds();
        currentUserParentAccountId = getCurrentUserParentAccountId();
    }
    
    public string getPsrId() {
         psrId = ApexPages.currentPage().getParameters().get('psrId');
         return psrId;
    }
    public List<String> getExcludeUserIds(){
        if(excludeUserIds == null )
        {
            System.PageReference currentPage = ApexPages.currentPage();
            Map<String, String> prmMap = currentPage.getParameters();
            excludeUserIds = new List<String>();
            for(String prmKey : prmMap.keySet()) {
                if(prmKey.startsWith('uid') && prmMap.get(prmKey).startsWith('005')) {
                    excludeUserIds.add(prmMap.get(prmKey));
                }
            }
        }
        
        return excludeUserIds;
    }
    
    public Id getCurrentUserParentAccountId() {
        if(currentUserParentAccountId == null) {
            Id currentUserId = UserInfo.getUserId();
            User currentUserRec = [Select Id, Contact.Account.ParentId From User Where Id =:currentUserId];
            currentUserParentAccountId = currentUserRec.Contact.Account.ParentId;
            if(currentUserParentAccountId == null) {
                 ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'Current User does not have associated Parent Account!'));    
            }
        }
        return (currentUserParentAccountId);
        
    }
    public List<WrapperUser> getUserList() {
        userList = new List<WrapperUser>();
        myCon = myCon != null ? myCon : getMyCon();
        for(User userRec : (List<User>)myCon.getRecords()) {
            userList.add(new WrapperUser(userRec));
        }
        if(userList == null || userList.isEmpty()) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.ERROR,'User List is Empty!'));            
        }
        return userList;
    }
    public ApexPages.StandardSetController myCon;
    
    public ApexPages.StandardSetController getMyCon() {
            if(myCon == null) {
                if(excludeUserIds != null)
                    myCon = new ApexPages.StandardSetController(Database.getQueryLocator([Select Id, FirstName, LastName, Name From User Where isActive = true AND Contact.Account.ParentId = :currentUserParentAccountId AND Id NOT IN :excludeUserIds ORDER BY Name LIMIT :getqueryLimit()]));
                else
                    myCon = new ApexPages.StandardSetController(Database.getQueryLocator([Select Id, FirstName, LastName, Name From User Where isActive = true AND Contact.Account.ParentId = :currentUserParentAccountId ORDER BY Name LIMIT :getqueryLimit()]));
            }
            myCon.setPageSize(queryLimit);
            
            return myCon;
    }
    
    public void setMyCon(ApexPages.StandardSetController value) {
        
        if(value != null ) {
            myCon = value;
        } 
    }
    
    private Integer queryLimit;
    
    public Integer getQueryLimit() {
        if(queryLimit == null) {
            queryLimit = 500;
        }
        return queryLimit;
    }
    
    public void setQueryLimit(Integer value) {
        if(value != null) {
            this.queryLimit = value;
        }
    }
    
}