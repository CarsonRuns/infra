public with sharing class TSN_Closed_Case_CTE {

public Case c;
public String ErrorContent{get;set;}


public TSN_Closed_Case_CTE (ApexPages.StandardController controller) {
     c = [Select Id,RecordTypeId from Case where id =:ApexPages.CurrentPage().getparameters().get('id')]; 
}
public PageReference start(){
    PageReference returnURL; 
    // ref = new PageReference('/500/s?id='+c.Id+'&retURL=%2F'+c.Id+'¬e=True');
    
    if(c.RecordTypeId == Utilities.getCaseTSNRecordTypeId()){
         ErrorContent = 'You cannot close a TSN Case.Please select Case Status as Resolving Pending to close the case';
         return null;
    }
    else{
        returnURL= new PageReference('/'+c.Id+'/s?retURL=%2F'+c.Id);
        returnURL.getParameters().put('nooverride', '1');
        returnURL.setRedirect(true);
    }    
    return returnURL;     
}
public PageReference getPageRef(){
    PageReference pageref = new PageReference('/'+ApexPages.CurrentPage().getparameters().get('id'));
    return pageref;
}
}