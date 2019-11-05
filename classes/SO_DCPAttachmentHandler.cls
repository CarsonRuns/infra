/********************************************************************************************************************
Name    : SO_DCPAttachmentHandler 
Author  : Apex User
Purpose : Controller contains logic to parse DCP Response
Created Date:  3/4/2018

**********************************************************************************************************************/

global class SO_DCPAttachmentHandler {
    
    public string JSONResponse {get;set;}
    public SO_DCPAttachmentWrapper oResponse{get;set;}
    public List<SO_DCPAttachmentWrapper.DCPOutput> dcpFileList {get;set;}
    public string filterKeyword{get;set;}
    public string bannerMsg{get;set;}
    public string bannerStatus{get;set;}
    public ID CurrentPageID{get;set;}
    public static blob fileContent {get;set;}
    //public string SparkChatLogfileName {get;set;} 
    //public static string fileContent1 {get;set;}
    public string csrf_Token {get;set;}
    public string ObjName {get;set;}
    public Map<String,String> map_FiledLabel {get;set;}
    
    public SO_DCPAttachmentHandler() {
         
      // To get the End Point URL from Custom Setting - SO_CalloutParameters__c, for the API Passed in the "name" parameter
        fileListURL =SO_CalloutUtilities.getEndPointUrl('getDCPDocuments');
        system.debug('fileListURL::::' +fileListURL);
        downloadFilesURL = SO_CalloutUtilities.getEndPointUrl('DownloadDCPDocuments');
        system.debug('downloadFilesURL::::' +downloadFilesURL);
        dcpAttachmentsURL =SO_CalloutUtilities.getEndPointUrl('DCPDocuments');
        system.debug('dcpAttachmentsURL::::' +dcpAttachmentsURL);
        dcpUploadURL = SO_CalloutUtilities.getEndPointUrl('DCPAttachmentUpload');
        system.debug('dcpUploadURL::::' +dcpUploadURL);
        CurrentPageID = ApexPages.currentPage().getParameters().get('id');
        system.debug('CurrentPageID::::' +CurrentPageID);
        objName = CurrentPageID.getSObjectType().getDescribe().getName();
        //csrf_Token = SO_DCPAuthentication.generateCSRFToken('jsundare');
        //hardcoding csrf token for dev testing . this needs to be replaced with actual csrf token value when going to QA and production
        csrf_Token = 'LOCALTOKEN';
        system.debug('$$$csrf_Token: '+ csrf_Token);
        //SparkChatLogfileName = SparkConstants.chatLogName ;
        dcpVersionURL = SO_CalloutUtilities.getEndPointUrl('DCPversionCheckin');
        //To Get Field Label based on Object Name
 
        map_FiledLabel = new Map<String,String>();
        Map<String, Schema.SObjectType> schemaMap = Schema.getGlobalDescribe();
        Schema.SObjectType projActSchema = schemaMap.get(objName);
        Map<String, Schema.SObjectField> fieldMap = projActSchema.getDescribe().fields.getMap();
        for (String fieldName: fieldMap.keySet()) {  
            map_FiledLabel.put(fieldName, fieldMap.get(fieldName).getDescribe().getLabel());
       }
    }
    public string fileListURL{get;set;}
    public string downloadFilesURL{get;set;}
    public string dcpAttachmentsURL{get;set;}
    public string dcpUploadURL{get;set;}
    public string dcpVersionURL{get;set;}
    public static Id LoggedInUSerId{get;set;}
   
    
    
    public static string getcecId(){
        LoggedInUSerId = UserInfo.getUserId();
        String CurrentUserName = Userinfo.getuserName();
        String cecId = (CurrentUserName).split('@')[0];
        system.debug('cecId=====>'+cecId);
        return cecId;
       
    }
    
   
    public static string getDCPContentAuthToken(){
        HttpRequest authReq = null;
        HttpResponse authRes = new HttpResponse(); 
        Http auth = new Http();
        Map<string,string> headerMap = new Map<string,string>();
        headerMap.put('Content-Type', 'application/json');
        authReq = SO_CalloutUtilities.getRequest(headerMap, 'DCPContentAuthorizationAPI', Null, 'POST');  
        authres = auth.send(authReq);               
        map<String,Object> mapAuthRes = (map<String,Object>)JSON.deserializeUntyped(authres.getBody());
        String access_token = (String)mapAuthRes.get('access_token');
        system.debug('access_token::'+access_token);        
        return access_token;
    }
    
   public static string getDCPUploadAuthToken(){
        HttpRequest authReq = null;
        HttpResponse authRes = new HttpResponse(); 
        Http auth = new Http();
        Map<string,string> headerMap = new Map<string,string>();
        headerMap.put('Content-Type', 'application/json');
        authReq = SO_CalloutUtilities.getRequest(headerMap, 'DCPUploadDownAuthorationAPI', Null, 'POST');  
        authres = auth.send(authReq);               
        map<String,Object> mapAuthRes = (map<String,Object>)JSON.deserializeUntyped(authres.getBody());
        String access_token = (String)mapAuthRes.get('access_token');
        system.debug('access_token::'+access_token); 
        return access_token;
    }   
    
   
    
    /**
* @description method to parse the DCP list of attachments response, and method called from actionfunction
* 
* @param 
* 
* @return void
*/
    public void parseDCPResponse(){
        Set<String> CECIdSet=new set<String>();
        
        Map<string,string> userNameMap=new Map<string,string>(); 
        
        system.debug('$$$Method called');
        //JSONResponse = '{"contentListing":[{"accessGroupName":null,"accessId":0,"activityId":[],"approverId":null,"author":"idhiman","boldFlag":"N","checkedInBy":"idhiman","checkedInDate":"26-Sep-2017","checkedOutBy":null,"checkedOutDate":null,"checkoutStatus":"N","contentCategory":"Reference Material","contentId":606019,"contentSequenceId":1227470,"contributorId":null,"createdBy":null,"customerContentList":[],"customerNames":null,"customerNumbers":null,"description":null,"dirtyFlag":null,"editable":"Y","edmContentId":"versionStore://version2Store/84cec456-59de-4436-845a-b44230362b0d","eolDate":"26-Sep-2019","errorResponse":null,"extSysDocId":null,"fileName":"world-map.pdf","fileSize":"787","folderId":null,"folderName":null,"folderUpdatedDate":null,"imageGuid":null,"isComplete":"Y","justMyContent":"YES","keywords":"s1optyID:0067A000004CbGa","language":"English - Worldwide","lastCheckedInBy":"idhiman","lastDownloadedDate":null,"lastModifiedDate":"2017092607495300","linkedToMCC":"N","linkFlag":null,"massPublish":"0","massPublishGroup":null,"mimeType":"pdf","missingMetaData":"","ownerId":["jsundare"],"parentFolderId":null,"partyId":[],"projectId":null,"publishDate":"26-Sep-2017","publishFlag":null,"relatedContentStatus":"N","reviewApprovalRecipient":"","reviewerId":null,"showContentId":"Y","status":"Pre-Draft","title":"world-map","version":"0.1"}],"contentSignedList":[],"customerAcceptorList":[],"date":null,"errorResponse":null,"noOfDays":null,"statusFlag":null,"statusMessage":null,"totalRecords":1}';
        if(JSONResponse.length()>0){
            oResponse = (SO_DCPAttachmentWrapper)SO_CalloutUtilities.deserializeJSONTyped(JSONResponse,Type.forname('SO_DCPAttachmentWrapper'));
            system.debug('oResponse---->'+oResponse);
            dcpFileList = oResponse.contentListing;
            for(SO_DCPAttachmentWrapper.DCPOutput dcpRes:dcpFileList){
                CECIdSet.add(dcpRes.author);
            }
            
            if(CECIdSet!= Null && !CECIdSet.isEmpty()){
                //List<User> userList=[SELECT Id,Name,Email FROM User WHERE Email=:CECIdSet];
                List<User> userList=[SELECT Id,Name,Email FROM User WHERE CommunityNickname =:CECIdSet];
                
                if(userList != null && !userList.isEmpty()){
                    for(user usr:userList){
                    String ffps = (usr.Email).split('@')[0];
                    system.debug('ffps=====>'+ffps);
                        if(ffps != Null){
                            userNameMap.put(ffps, usr.Name);
                        }
                    }
                }
            }
            for(SO_DCPAttachmentWrapper.DCPOutput dcpRes:dcpFileList){
                if(userNameMap != Null && !userNameMap.isEmpty()){
                dcpRes.CreatedBy = userNameMap.get(dcpRes.author) != Null? userNameMap.get(dcpRes.author):dcpRes.author;
                   
    }
                
                
                
                dcpRes.ObjectType = getObjectTypeFromDCP(dcpRes.keywords);
                dcpRes.fileSize   = getFileSize(dcpRes.fileSize);
                
            }
         //   updateNotes();
            system.debug('$$$'+oResponse);
        } 
    }    
   //Method to display success Method or Error Method whenever File is uploaded 
    public void setBannerMsg(){
        if(bannerStatus =='Success'){
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.CONFIRM,bannerMsg));
        }
        else{
            ApexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,bannerMsg));            
        }
        
    }
   //Method to Fetch DCP file Attachment contents
    webservice static void getAttachment(Id attachmentId )
    {
        try
        {
            Attachment attch=[select ID,name,lastmodifieddate,parentId,body,contenttype,bodylength from attachment where parentId=:attachmentId ORDER BY lastmodifieddate DESC LIMIT 1];
            String MyFile=EncodingUtil.base64Encode(attch.body);
            fileContent = EncodingUtil.base64Decode(MyFile);
            System.debug('fileContent' + fileContent);
        } catch (exception ex)
        {
            system.debug('exception--->'+ex);
            
        }
        
    }
    //method copied of utils
    public static string getObjectTypeFromDCP(string inputStr){
        string returnStr ='';  
        
        if(inputStr != Null && !string.isBlank(inputStr)){
            if(inputStr.indexOf('s1CaseId')> -1){
                returnStr = 'Case';
            }
            else if(inputStr.indexOf('s1PARId')> -1){ 
                returnStr = 'Project Activation Request';
            }
            else if(inputStr.indexOf('s1ProjectId')> -1){
                returnStr = 'Project';
            }
            
            else if(inputStr.indexOf('s1OpptyId')> -1){ 
                returnStr = 'Opportunity';
            }
            
        }
        return returnStr;
    }
    
    //method to get filesize which is being uploaded 
     public static string getFileSize (String input) {
        string fileSize ='';
        fileSize = input.toUpperCase();
        Long longValue = Long.valueOf(input);        
        if (longValue < 1024)
            fileSize =  string.valueOf(longValue) + ' B';
        else
            if (longValue >= 1024 && longValue < (1024*1024))
        {
            //KB
            Decimal kb = Decimal.valueOf(longValue);
            kb = kb.divide(1024,2);
            fileSize = string.valueOf(kb) + ' KB';
        }
        else
            if (longValue >= (1024*1024) && longValue < (1024*1024*1024))
        {
            //MB
            Decimal mb = Decimal.valueOf(longValue);
            mb = mb.divide((1024*1024),2);
            fileSize = string.valueOf(mb) + ' MB';
        }
        else
        {
            //GB
            Decimal gb = Decimal.valueOf(longValue);
            gb = gb.divide((1024*1024*1024),2);            
            fileSize = string.valueOf(gb) + ' GB';
        }   
        return fileSize;
    }
}