/**************************************************************************************************
   @Author : Nishi Jain
   @name : Account_SBC_Redirection_Controller
   @CreateDate : 18/11/2016
   @Description : This controller manages the logic to allow user to be redirected to Account SBC Page. 
   @Version :1.0
   Modification History:
        
  *************************************************************************************************/

public class Account_SBC_Redirection_Controller{
    Id Profile_id;
    public String errorMsg{get;set;}
    public Boolean permissionFlag{get;set;}
    public string leadDetail {get;set;}
    public string idLead {get;set;}
    public string accRecordTypeName {get;set;}
    public Id recordTypeId = '0123000000004aUAAQ';
    Id orgId = UserInfo.getOrganizationId();
    String rTypeNameChannel = 'Channel'; 
    String rTypeNameCompetitor = 'Competitor'; 
    String rTypeNameEndUser = 'End-User'; 
    String rTypeUnregisteredReseller = 'Unregistered Reseller'; 
    public String IdChannel {get;set;}
    public String IdCompetitor {get;set;} 
    public String IdEndUser {get;set;}
    public String IdUnregisteredResller {get;set;}
    public String userCountry {get;set;}
    public String usersLanguage {get;set;}
    public String get_ccxApp_redirectURL {get;set;}
    public String accRecordTypeId {get;set;}
    Map<String, Id> mapRecTypeId = new Map<String,Id>();
    
    public Account_SBC_Redirection_Controller(ApexPages.StandardController controller){
        permissionFlag = false;
        Profile_id = userinfo.getProfileId();
        get_ccxApp_redirectURL = Utilities.getConstant_CS('SBC Redirect URL');
        Id userId = userinfo.getUserId();
        List<User> userDetails = [SELECT Id, additional_user_permissions__c,ProfileId From User WHERE Id =: userId];
         
        Set<String> userPermiSet = new Set<String>();
        List<String> additionalPermi = new List<String>{'Enable Channel ACCTCreation','Enable EndUser ACCTCreation','Enable UnregisteredReseller ACCTCreation' };
        if(!userDetails.isEmpty()){
            if(!String.isBlank(userDetails[0].additional_user_permissions__c)){
                List<String> userPermi = userDetails[0].additional_user_permissions__c.split(';');
                for(String each : userPermi){
                    userPermiSet.add(each);
                }
                for(String each : additionalPermi){
                    if(userPermiSet.contains(each)){
                        permissionFlag = true;
                    }
                }
            }
        }
        String orgConsProfile= Utilities.getConstant_CS('Acct_SBC_Redirection_Profiles');
        List<String> orgConsProfileId = orgConsProfile.split(',');
        Set<Id> profIdSet = new Set<Id>();
        for(String each : orgConsProfileId){
            profIdSet.add(each);
        }
        if(profIdSet.contains(Profile_id)){
            permissionFlag = true;
                
        }
       
    }
    public pageReference redirectToCreate(){
        getAcctRecordTypeName(recordTypeId);
        //getRecordTypeIds();
        //Get Users Language 
        usersLanguage = getUserLanguage(); 
        return null;
    }
    public String getUserLanguage(){ 
        List<User> userResult = [Select Country from User Where Id = : UserInfo.getUserId()]; 
        if(userResult.Size() > 0){
            if(userResult[0].Country != null){
                userCountry = userResult[0].Country.toUpperCase();
            }
        }
        String userlang = userInfo.getLanguage();
        User_Language__c usrLangRec = User_Language__c.getValues(userInfo.getLanguage());
        if(usrLangRec != null){
            userlang = usrLangRec.Language__c;
        }
        else{
            userlang = 'en-US';
        }
        return userlang; 
    } 
    
    public void getAcctRecordTypeName(Id RctTypeId){
        String recTypeName = '';
        Schema.DescribeSObjectResult sObjct = Schema.SObjectType.Account;
        if(RctTypeId == null ){
            for(Schema.RecordTypeInfo rtInfo : sObjct.getRecordTypeInfos()) {
                if (rtInfo.isDefaultRecordTypeMapping()) {
                    accRecordTypeName = rtInfo.getName();
                    accRecordTypeId = rtInfo.getRecordTypeId();
                }
            }
        }
        else{
            Map<Id,Schema.RecordTypeInfo> rtMapById = sObjct.getRecordTypeInfosById();
            Schema.RecordTypeInfo rtById =  rtMapById.get(RctTypeId);
            accRecordTypeName = rtById.getName();
            accRecordTypeId = RctTypeId;
        }
    }   
}