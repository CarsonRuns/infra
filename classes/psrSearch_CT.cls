public class psrSearch_CT {
    
    // SCAVA Helper Method to validate Update Access at field level
     public static Boolean flsUpdate(SObjectField field)
    {
        return field.getDescribe().isUpdateable() ? true : false;
    }


    public psrSearch_CT() {
        submit();
    }


    public psrSearch_CT(ApexPages.StandardController controller) {

    }


String channelAccount;
String testId;


List<ViewObject> UserSet; 

public List<ViewObject> getUserSet() {
    return UserSet;
}
public String getPsrName(){
    String assignedPartner = System.currentPageReference().getParameters().get('Id');
    if(assignedPartner.startsWith('a'))
        return [Select Assigned_Partner_Sales_Rep__r.Name From Assigned_Partner__c Where Id= :assignedPartner].Assigned_Partner_Sales_Rep__r.Name;
    else
        return [Select PSR_1__r.Name From Lead Where Id= :assignedPartner].PSR_1__r.Name;
}
public String getPsrName2(){
    String assignedPartner = System.currentPageReference().getParameters().get('Id');
    if(assignedPartner.startsWith('a'))
        return [Select Assigned_Partner_Sales_Rep_2__r.Name From Assigned_Partner__c Where Id= :assignedPartner].Assigned_Partner_Sales_Rep_2__r.Name;
    else
        return [Select PSR_2__r.Name From Lead Where Id= :assignedPartner].PSR_2__r.Name;
}
public String getPsrName3(){
    String assignedPartner = System.currentPageReference().getParameters().get('Id');
    if(assignedPartner.startsWith('a'))
        return [Select Assigned_Partner_Sales_Rep_3__r.Name From Assigned_Partner__c Where Id= :assignedPartner].Assigned_Partner_Sales_Rep_3__r.Name;
    else
        return [Select PSR_3__r.Name From Lead Where Id= :assignedPartner].PSR_3__r.Name;
}
public String getPsrRecommended(){
    String assignedPartner = System.currentPageReference().getParameters().get('Id');
    if(assignedPartner.startsWith('a'))
        return [Select Cisco_Recomended_Partner_Sales_Rep__r.Name From Assigned_Partner__c Where Id= :assignedPartner].Cisco_Recomended_Partner_Sales_Rep__r.Name;
    else
        return [Select Cisco_Rec_PSR__r.Name From Lead Where Id= :assignedPartner].Cisco_Rec_PSR__r.Name;
}


public boolean getIsPartnerAdmin(){
    if(UserInfo.getUserRoleId() != null){
        String uRole = [Select Name from UserRole Where Id = :UserInfo.getUserRoleId()].Name;
        if(uRole.endsWith('Partner Executive'))   
            return true;
        else
            return false;    
    }
    else return false;
}
    
public void submit() {
    channelAccount = System.currentPageReference().getParameters().get('testId');
    Account channelAccount = [Select ParentId from Account where Id= :channelAccount];   
    
    List<User> listUser = [Select Name, Street, State, City, Country, PostalCode, UserRole.Name 
                            from User 
                            where Contact.Account.ParentId = :channelAccount.ParentId and isActive=true];
    
    UserSet = new List<ViewObject>();                       
    for(User u: listUser)
    {
        ViewObject v = new ViewObject();
        v.userObj = u;
        
        if(u.userRole.Name.contains(Partner360Utils.PARTNER_PORTAL_USER_ROLE_ADMIN))
        {
            v.userRoleName = Partner360Utils.SFDC_LABEL_PARTNER_ADMIN;   
        }
        if(u.userRole.Name.contains(Partner360Utils.PARTNER_PORTAL_USER_ROLE_PSR))
        {
            v.userRoleName = Partner360Utils.SFDC_LABEL_PSR;
        }
        
        UserSet.add(v);
    }  
    
                            

}

public PageReference cancel(){
    String assignedPartner = System.currentPageReference().getParameters().get('apId');
    return new PageReference ('/' + assignedPartner);
}

public PageReference save() {
    String group1 = System.currentPageReference().getParameters().get('group1');
    String psrFeild = System.currentPageReference().getParameters().get('psr');
    String assignedPartner = System.currentPageReference().getParameters().get('apId');
    
    System.debug('SELECTED VALUE>>>>' + group1);
    System.debug('PSR FIELD>>>>>' + psrFeild);
    System.debug('ID>>>>>' + assignedPartner);
        
    
    if(assignedPartner.startsWith('a')){
        System.debug('IN AP');
        Assigned_Partner__c ap = [Select Id From Assigned_Partner__c Where Id= :assignedPartner];
        
        if(psrFeild == '1')
            // SCAVA FIX
                if(flsUpdate(Assigned_Partner__c.Assigned_Partner_Sales_Rep__c))
                {
                    ap.Assigned_Partner_Sales_Rep__c = group1;
                }
        else if(psrFeild == '2')
                // SCAVA FIX
                if(flsUpdate(Assigned_Partner__c.Assigned_Partner_Sales_Rep_2__c))
                {
                    ap.Assigned_Partner_Sales_Rep_2__c = group1;
                }
        else if(psrFeild == '3')
                // SCAVA FIX
                if(flsUpdate(Assigned_Partner__c.Assigned_Partner_Sales_Rep_3__c))
                {
                    ap.Assigned_Partner_Sales_Rep_3__c = group1; 
                }
        else if(psrFeild == '4')
                // SCAVA FIX
                if(flsUpdate(Assigned_Partner__c.Cisco_Recomended_Partner_Sales_Rep__c))
                {
                    ap.Cisco_Recomended_Partner_Sales_Rep__c = group1;       
                }
            
        update ap;
    }
    else{
        System.debug('IN LEAD');
        Lead l = [Select Id From Lead Where Id= :assignedPartner];
    
        if(psrFeild == '1')
            // SCAVA FIX
                if(flsUpdate(Lead.PSR_1__c))
                {
                    l.PSR_1__c = group1;
                }
        else if(psrFeild == '2')
                // SCAVA FIX
                if(flsUpdate(Lead.PSR_2__c))
                {
                    l.PSR_2__c = group1;
                }
        else if(psrFeild == '3')    
            // SCAVA FIX
                if(flsUpdate(Lead.PSR_3__c))
                {
                    l.PSR_3__c = group1; 
                }
        else if(psrFeild == '4')
            // SCAVA FIX
                if(flsUpdate(Lead.Cisco_Rec_PSR__c))
                {
                    l.Cisco_Rec_PSR__c = group1;       
                }
            
        update l;
    }
    return new PageReference ('/' + assignedPartner);
}

public PageReference methodOne() {
    String assignedPartner = System.currentPageReference().getParameters().get('Id');
    if(assignedPartner.startsWith('a')){
        Assigned_Partner__c ap = [Select Id From Assigned_Partner__c Where Id= :assignedPartner];
        ap.Assigned_Partner_Sales_Rep__c = null;
        update ap;
    }
    else{
        Lead l = [Select Id From Lead Where Id= :assignedPartner];
        // SCAVA FIX
                if(flsUpdate(Lead.PSR_1__c))
                {
                    l.PSR_1__c = null;
                }
        update l;        
    }
    return null;
}

public PageReference methodTwo() {
    String assignedPartner = System.currentPageReference().getParameters().get('Id');
    if(assignedPartner.startsWith('a')){
        Assigned_Partner__c ap = [Select Id From Assigned_Partner__c Where Id= :assignedPartner];
        // SCAVA FIX
                if(flsUpdate(Assigned_Partner__c.Assigned_Partner_Sales_Rep_2__c))
                {
                ap.Assigned_Partner_Sales_Rep_2__c = null;
                }
        update ap;
    }
    else{
        Lead l = [Select Id From Lead Where Id= :assignedPartner];
        // SCAVA FIX
                if(flsUpdate(Lead.PSR_2__c))
                {
                    l.PSR_2__c = null;
                }
        update l;        
    }
    return null;
}

public PageReference methodThree() {
    String assignedPartner = System.currentPageReference().getParameters().get('Id');
    if(assignedPartner.startsWith('a')){
        Assigned_Partner__c ap = [Select Id From Assigned_Partner__c Where Id= :assignedPartner];
        // SCAVA FIX
                if(flsUpdate(Assigned_Partner__c.Assigned_Partner_Sales_Rep_3__c))
                {
                    ap.Assigned_Partner_Sales_Rep_3__c = null;
                }
        update ap;
    }
    else{
        Lead l = [Select Id From Lead Where Id= :assignedPartner];
        // SCAVA FIX
                if(flsUpdate(Lead.PSR_3__c))
                {
                    l.PSR_3__c = null;
                }
        update l;        
    }
    return null;
}

public PageReference methodFour() {
    String assignedPartner = System.currentPageReference().getParameters().get('Id');
    if(assignedPartner.startsWith('a')){
        Assigned_Partner__c ap = [Select Id From Assigned_Partner__c Where Id= :assignedPartner];
        // SCAVA FIX
                if(flsUpdate(Assigned_Partner__c.Cisco_Recomended_Partner_Sales_Rep__c))
                {
                    ap.Cisco_Recomended_Partner_Sales_Rep__c = null;
                }
        update ap;
    }
    else{
        Lead l = [Select Id From Lead Where Id= :assignedPartner];
        // SCAVA FIX
                if(flsUpdate(Lead.Cisco_Rec_PSR__c))
                {
                    l.Cisco_Rec_PSR__c = null;
                }       
        update l;        
    }
    return null;
}


public PageReference psrSearchPage(){
    testId = System.currentPageReference().getParameters().get('testId');
    String apId = System.currentPageReference().getParameters().get('apId');
    String psr = System.currentPageReference().getParameters().get('psr');
    return new PageReference ('/apex/psrSearch?psr=' + psr + '&testId=' + testId + '&apId=' + apId);
}

// This object will be used to bind data to the VF page.
Class ViewObject
{
    public User userObj {get; set;}
    public String userRoleName {get; set;}
    
}





}