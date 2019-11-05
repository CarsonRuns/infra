public class AutomationCCOIdSearch 
{

Public @future(callout=true) static void doCCOIdSearch(Id CaseId)
{
    Case C = [select accountid,contactid,Web_CCO_ID__c,CCO_ID_Search_Result_Rich__c from case where Id = :CaseId];
    String NoMatchesMsg = 'Sorry, there are no matching partner contacts based on the search criteria.<br/>';
    String CCO_ID = C.Web_CCO_ID__c;


    Vc_CT vcct =  new Vc_CT(); // Create instance of class Vc_CT
    vcct.CCO_ID = CCO_ID;  // assign Web CCO Id of Case to Vc_CT instance
    String Message ;

    try
    {
        vcct.search(); // do search

        if(vcct.CCOSearchStatus == 'FAILURE' && vcct.CCOSearchStatusDescription =='CCO id does not exist.') 
         Message = '<font color="red">' + NoMatchesMsg+CCO_ID+' not found.'+ '</font>';
    
        else if(vcct.CCOSearchStatus == 'FAILURE' && vcct.CCOSearchStatusDescription !='CCO id does not exist.')
        Message = '<font color="red">' + 'CCO Service Error.<br/>'+ CCO_ID+ '</font>';
    
        else if(vcct.CCOSearchStatusDescription == 'NO HIERARCHY EXISTS FOR THE INPUT')
        Message = '<font color="red">' + NoMatchesMsg + CCO_ID +' not associated to any Partner Account'+ '</font>';
    
        else if(vcct.VCServiceUp == true && vcct.SFDCChannelAccountFound == false && vcct.CCOSearchPartnerId <> null)
        Message = '<font color="red">' + NoMatchesMsg + CCO_ID + ' associated to Partner Id:' + vcct.CCOSearchPartnerId + ' CSC Site Id:' +vcct.PGTMVSiteId+' Country:' +vcct.sfdc_country_desc+' not found in SFDC.'+ vcct.getLineBreak() + vcct.getSBCLink()+ '</font>';
    
        else if(vcct.SFDCChannelAccountFound)
        {
            C.Accountid = vcct.SFDCChannelAccount.Id;
            C.ContactId = [Select Id from Contact where accountid = :vcct.SFDCChannelAccount.Id and CCO_ID__c =:CCO_ID limit 1].Id;
            Message = 'CCO Id '+CCO_ID+'. Account: '+vcct.getSFDCChannelAccount()+vcct.getVCEligibleMessage();
        }
    }
    catch(Exception e)
    {
       Message  = '<font color="red">' + e.getMessage()+ '</font>';      
    }

    C.CCO_ID_Search_Result_Rich__c = Message;
    c.CCO_Search_Result_Updated__c = true;
    Utilities.setskipFuture(true); 
    Utilities.setValidationSkip(true);
    update C;
    
}


}