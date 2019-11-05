/* 
   Name    : NGCC_MobilePostChat_Survey_Cls
   Author  : 
   Purpose : 
   Created Date: 
   Modification History: 
    1.  Author  : Ghattamaneni Chaithanya
        Purpose : US245983 : NPS_New Landing Pages for Post-Chat Surveys
        Changes : 
            1. Added logic in Constructor to get Eloqua post chat URL from NGCC Pre Chat Configuration Custom settings.
        Date    : DEC 03,2018

*/
public class NGCC_MobilePostChat_Survey_Cls{
    public static List < Lead > leadTemp;
    public static List < CC_Response__c > responseTemp;
    public static List < User > user;
    Public static String createdDateStamp;
    Public static String createdTimeStamp;
    public static String responseMessage;
    public static Map < String, String > tempMap;
    public NGCC_Pre_Chat_Configuration__c pcc;
    public static String eloquaURL {
        get;
        set;
    }
    public NGCC_MobilePostChat_Survey_Cls() {
        String Buttonid = ApexPages.currentPage().getParameters().get('buttonId');
        if(Buttonid != null){
            pcc = NGCC_Pre_Chat_Configuration__c.getValues(Buttonid);            
        }
        if(pcc != null){
            eloquaURL = pcc.PostChat_URL__c;
        }
    }
    @RemoteAction
    public static Map < String, String > getAgentDetails(String LeadID, String UserID) {
        responseMessage = '';
        tempMap = new Map < String, String > ();
        try {            
            //Passing Agent ID to the list
            if (String.isNotBlank(UserID)) {
                user = [select id, username, alias, name, Marketing_Call_Center__c from User where Id =: UserID.trim() Order By createdDate asc limit 1];
                if(!user.isEmpty()){
                    responseMessage += user[0].name + ',';
                    tempMap.put('UserName', String.isNotBlank(user[0].name)?user[0].name:null);
                }                
            }
            //Passing lead Id to the list
            if (String.isNotBlank(LeadID)) {
                leadTemp = [select id, name, company, campaign_name__c, email, phone, createddate from lead where Id =: LeadID.trim() Order By createdDate asc limit 1];
                if(!leadTemp.isEmpty()){
                    //Splitting createddate into date and time
                    cmdGetDateTime(String.valueOf(!leadTemp.isEmpty() ? leadTemp[0].createddate : System.now()));
                }               
            }
            if(String.isNotBlank(LeadID)){
                responseTemp = [SELECT Id, Lead__c, createddate from CC_Response__c where Lead__c =: LeadID.trim() Order By createdDate asc limit 1];               
                if(!responseTemp.isEmpty()){
                    responseMessage += responseTemp[0].Id + ',';
                    tempMap.put('Id',String.isNotBlank(responseTemp[0].Id)?responseTemp[0].Id:null);
                }                
            }
        } catch (exception e) {
        }
        if (!tempMap.isEmpty()) {
            return tempMap;
        } else {
            return null;
        }        
    }
    //Splitting createddate into date and time
    public static void cmdGetDateTime(String dateTimeStamp) {
        Datetime chatDateTime = !leadTemp.isEmpty() ? leadTemp[0].CreatedDate : System.now();
        String dtConverted = chatDateTime.format('MM/dd/yyyy hh:mm:ss a');
        List < String > splitTimeStamp = dtConverted.split(' ');
        createdDateStamp = splitTimeStamp[0];
        createdTimeStamp = splitTimeStamp[1];
        responseMessage += createdDateStamp + ',';
        responseMessage += createdTimeStamp + ',';
        tempMap.put('CreatedDate', String.isNotBlank(createdDateStamp)?createdDateStamp:null);
        tempMap.put('CreatedTime', String.isNotBlank(createdTimeStamp)?createdTimeStamp:null);
    }
}