global class TSNRemoveCaseDelLinks_CTE {

public Case c ;
public String caseOwner; 
public String caseownerMail = '';
public Boolean caseOwnerGroup = false;

public TSNRemoveCaseDelLinks_CTE(ApexPages.StandardController controller) {
    c = [select ID,OwnerId from Case where id = :ApexPages.currentPage().getParameters().get('id')];    
    caseOwner = c.OwnerId;  
    caseOwnerGroup = caseOwner.substring(0,3).contains('00G');
    System.debug('caseownergroup>>>'+caseOwnerGroup );
    if(!caseOwnerGroup)
    caseownerMail = [Select Email from User where Id =:caseOwner].Email;
  }

public String getCaseOwnerMail(){
   return caseownerMail;
  }
  
@RemoteAction
global static String getCiscoCaseMgmtAdd(){return Utilities.getConstant_CS('Case Mgmt Email Relay');}
}