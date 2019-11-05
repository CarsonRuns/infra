/**************************************
Author          : Shivi Srivastava 
Release         : March Release
Created         : Feb,2019
Functionality   : This is Server side class for the component used to send New email from cases object 

Modification History:
Itrack#        Date        Author              Change
****************************************************************************/

public class lxSendEmail {
    //Get the OrgWideEmailAddress to display in FROM picklist 
    @AuraEnabled
    public static List<csWrapper> fetchFromValues(){
        List<csWrapper> returnList=new List<csWrapper>();
        String utilCS=Utilities.getConstant_CS('OrgWideAddress');
        if(String.valueOf(UserInfo.getProfileId()).contains(Utilities.getConstant_CS('CiscoSalesCases'))){
            OrgWideEmailAddress objCP= [SELECT Id, Address, DisplayName from OrgWideEmailAddress where DisplayName LIKE '%Cisco Case Management' and IsAllowAllProfiles=true limit 1];
            csWrapper fc=new csWrapper();
            fc.label=objCP.DisplayName;
            fc.value=objCP.Id;
            returnList.add(fc);    
            //system.debug('returnList'+returnList[0]);
        }
        else{
            List<OrgWideEmailAddress> objCP= [SELECT Id, Address, DisplayName from OrgWideEmailAddress where IsAllowAllProfiles=true];
            for(OrgWideEmailAddress ce:objCP){
                csWrapper fc=new csWrapper();
                fc.label=ce.DisplayName;
                fc.value=ce.Id;
                returnList.add(fc);
            }
            
            List<JSON2Apex> wrapList =JSON2Apex.parse(utilCS);
            for(JSON2Apex wL:wrapList){
                csWrapper fc=new csWrapper();
                fc.label=String.valueOf(wL.Name);
                fc.value=String.valueOf(wL.Id);
                //System.debug('Hello>>'+wL.Name);
                returnList.add(fc);
            }
            
        }
        
        //System.debug('>>'+returnList);
        return returnList;
    }
    
    @AuraEnabled
    public static List<String> getCaseUserInfo(String caseId){
        List<String> caseUser=new List<String>();
        caseUser.add(UserInfo.getUserEmail());
        caseUser.add(String.valueOf(UserInfo.getProfileId()));
        ProfileID__c profiles = ProfileID__c.getOrgDefaults();
        caseUser.add(profiles.Cisco_ADMIN__c );
        caseUser.add(profiles.Cisco_GSTS__c);
        caseUser.add(Utilities.getConstant_CS('CiscoSalesCases'));
        //System.debug('caseUser>>'+Utilities.getConstant_CS('CiscoSalesCases'));
        return caseUser;
    }
    
    //Send SingleEmailMessage record (with or without template/attachments) 
    @AuraEnabled
    public static void sendEmail(Map<String,Object> values, String attach, String templateId, String caseId,String contactId ){
        
        //System.debug(attach); 
        System.debug(values);
        List<Object>To=(List<Object>)values.get('To');
        List<Object>addCC=(List<Object>)values.get('addCC');
        List<Object>addBCC=(List<Object>)values.get('addBCC');
        //String attach=String.valueOf(values.get('attach'));
        List<String> selectedIdsList = new List<String>();
        Object[] attachments = (Object[])System.JSON.deserializeUntyped(attach);
        if(attachments.size()>0){         
            for (Object id : attachments) {
                selectedIdsList.add(string.valueof(id));
            }
        }
        List<String> toList=new List<String>();
        List<String> ccList=new List<String>();
        List<String> bccList=new List<String>();
        for(Object toVal:To){
            toList.add(String.valueOf(toVal));
        }
        for(Object ccVal:addCC){
            ccList.add(String.valueOf(ccVal));
        }
        for(Object bccVal:addBCC){
            bccList.add(String.valueOf(bccVal));
        }
        //Getting the details of attachment from contentVersion to attach in email
        Messaging.EmailFileAttachment[] efaList = new List<Messaging.EmailFileAttachment>();  
        List<contentVersion> contVer=[Select id,versiondata,Title,FileExtension from contentVersion where ContentDocumentId IN:selectedIdsList];
        for (contentVersion a : contVer){
            Messaging.Emailfileattachment efa = new Messaging.Emailfileattachment();
            efa.setFileName(a.Title+'.'+a.FileExtension);
            efa.setContentType('text/calendar');
            efa.setBody(a.versiondata);
            efaList.add(efa);
        }
        //system.debug('>>'+contactId);
        //system.debug('>>'+caseId);
        
        List<Messaging.SingleEmailMessage> mails = new List<Messaging.SingleEmailMessage>();
        if(templateId==null){
            EmailTemplate dummyTemplate=[Select id from EmailTemplate where Name like '%GVE%'  limit 1];
            templateId=String.valueOf(dummyTemplate.Id);
        }
        //system.debug(templateId);
        Messaging.SingleEmailMessage mail = Messaging.renderStoredEmailTemplate(templateId,contactId,caseId);
        
        mail.setTemplateId(templateId);//Template Id
        mail.setTargetObjectId(contactId);//Contact,Lead,User Id
        mail.setWhatId(caseId); //Custom, Few Standard objs
        mail.setFileAttachments(efaList);
        mail.setToAddresses(toList);
        mail.setBccAddresses(bccList);
        mail.setCcAddresses(ccList);
        mail.setSubject(String.valueOf(values.get('subject')));
        //system.debug('From>>'+values.get('From'));
        if(String.isBlank(String.valueOf(values.get('From'))) ==false){
            //system.debug('Hello');
            mail.setOrgWideEmailAddressId(Id.valueOf(String.valueOf(values.get('From'))));
        }
        
        if(mail.getHtmlBody()==null){
            if(String.isBlank(String.valueOf(values.get('body')))==false){
                String finalBody=String.valueOf(values.get('body')).replace('<p>','');
                finalBody=finalBody.replace('</p>','<br />' );
                mail.setHtmlBody(finalBody);
            }
        }
        else{
            mail.setHtmlBody(String.valueOf(values.get('body')));
        }
        mails.add(mail);
        //System.debug('Email-->>'+mail.getHtmlBody());
        
        //Messaging.sendEmail(mails);
        //System.debug('Email-->> '+mail.getPlainTextBody());
        List <String> returnList=new List<String>();
        String msg;
        returnList.add(mail.getSubject());
        returnList.add(mail.getHtmlBody());
        try{
            if(contactId==''||contactId==null){
                System.debug('contactId is >>'+contactId);
                insertMailRecord(values,returnList,contVer,mails); 
            }
            else{
                Messaging.sendEmail(mails);
            }
        }
        catch(DmlException e) { 
            System.debug('The following exception has occurred: ' + e.getMessage());
            for (Integer i = 0; i < e.getNumDml(); i++) {
                //Get Validation Rule & Trigger Error Messages
                msg =+ e.getDmlMessage(i) +  '\n' ;
            } 
            throw new AuraHandledException(msg);
        }
        catch(Exception e){
            //throw all other exception message
            throw new AuraHandledException(e.getMessage());
        }
        //return message;
    }
    public static void insertMailRecord(Map<String,Object> values,List <String> returnList,List<contentVersion> contVer,List<Messaging.SingleEmailMessage> mails){
        List<Object>To=(List<Object>)values.get('To');
        List<Object>addCC=(List<Object>)values.get('addCC');
        List<Object>addBCC=(List<Object>)values.get('addBCC');
        EmailMessage em=new EmailMessage();
        if(String.isBlank(String.valueOf(values.get('From'))) ==false){
            String fromId=String.valueOf(values.get('From'));
            OrgWideEmailAddress owe=[SELECT DisplayName,Address from OrgWideEmailAddress where Id=:fromId];
            em.FromAddress=owe.Address;
            em.FromName=owe.DisplayName;
        }
        else{
            em.FromAddress=UserInfo.getUserEmail();
            em.FromName=UserInfo.getName();
        }
        em.ParentId=Id.valueOf(String.valueOf(values.get('Case')));   
        em.ToAddress =String.join(To,',');
        em.CcAddress=String.join(addCC,',');
        em.BccAddress=String.join(addBCC,',');
        em.Subject=returnList[0];
        em.HtmlBody=returnList[1];
        Id newRec;
        String errorMessage;
        //try{
        Database.SaveResult srList=Database.insert(em);
        if (srList.isSuccess()) {
            newRec=srList.getId();
            Messaging.sendEmail(mails);
        }
        /* }
catch(DmlException e) { 
System.debug('The following exception has occurred: ' + e.getMessage());
errorMessage=e.getMessage();

}*/
        //System.debug(System.JSON.deserializeUntyped(attachment));
        
        if((newRec!=null ||newRec!='')&& !contVer.isEmpty()){
            insertAttachment(newRec,contVer);
        }
        
        // return errorMessage;
    }
    /* @AuraEnabled
public static boolean insertEmail(Map<String,Object> values,String attachment){

List<Object>To=(List<Object>)values.get('To');
List<Object>addCC=(List<Object>)values.get('addCC');
List<Object>addBCC=(List<Object>)values.get('addBCC');
EmailMessage em=new EmailMessage();
if(String.isBlank(String.valueOf(values.get('From'))) ==false){
String fromId=String.valueOf(values.get('From'));
OrgWideEmailAddress owe=[SELECT DisplayName,Address from OrgWideEmailAddress where Id=:fromId];
em.FromAddress=owe.Address;
em.FromName=owe.DisplayName;
}
else{
em.FromAddress=UserInfo.getUserEmail();
em.FromName=UserInfo.getName();
}
em.ParentId=Id.valueOf(String.valueOf(values.get('Case')));   
em.ToAddress =String.join(To,',');
em.CcAddress=String.join(addCC,',');
em.BccAddress=String.join(addBCC,',');
em.Subject=String.valueOf(values.get('subject'));
em.HtmlBody=String.valueOf(values.get('body'));

//insert em;
Id newRec;
try{
Database.SaveResult srList=Database.insert(em);
if (srList.isSuccess()) {
newRec=srList.getId();
}
}
catch(DmlException e) { 
System.debug('The following exception has occurred: ' + e.getMessage());
}
//System.debug(System.JSON.deserializeUntyped(attachment));

if(newRec!=null ||newRec!=''){
insertAttachment(newRec,attachment);
}
//System.debug('attachments'+attachment.size());

return true;
}*/
    public static void insertAttachment(Id emailId, List<contentVersion> contVer){
        //Object[] values = (Object[])System.JSON.deserializeUntyped(attachments);
        
        List<Attachment> attachList = new List<Attachment>();
        //List<JSON2Apex> wrapList =JSON2Apex.parse(attachments);
        for(contentVersion cv:contVer){
            Attachment att=new Attachment();
            //for(String attach:Attachment){
            //if(values.size()>0){         
            //for (Object val : values) {
            att.parentid=emailId;
            att.Name=cv.Title+'.'+cv.FileExtension;
            //String strBody=EncodingUtil.Base64Encode();
            //Blob Ebody=EncodingUtil.base64Decode(wL.VersionData);
            att.body=cv.VersionData;
            att.ContentType='.'+cv.FileExtension;
            attachList.add(att);
        }
        
        insert attachList;
        
    }
    public class csWrapper{
        @AuraEnabled
        public String label;
        @AuraEnabled
        public string value;
    }
    //Get the uploaded attachment records to display on UI
    @AuraEnabled
    public static List<ContentVersion> fetchAttachments(String attach){
        try{
            //System.debug('>>'+attach);
            List<String> selectedIdsList = new List<String>();
            Object[] values = (Object[])System.JSON.deserializeUntyped(attach);
            
            if(values.size()>0){         
                for (Object id : values) {
                    selectedIdsList.add(string.valueof(id));
                }
            }
            List<contentVersion> contVer=[Select id,versiondata,Title,FileExtension,ContentDocumentId from contentVersion where ContentDocumentId IN:selectedIdsList];
            return contVer;
        }catch(Exception ex){
            ex.getMessage();
            return null;
        }
    }
    //Get the Email Body if in case template is attached
    @AuraEnabled
    public static List<String> setEmailBody(String templateId, String caseId,String contactId){
        try{
            Messaging.SingleEmailMessage mail = Messaging.renderStoredEmailTemplate(templateId,contactId,caseId);//new Messaging.SingleEmailMessage(); 
            List<String> mails = new List<String>();
            mail.setTemplateId(templateId);//Template Id
            mail.setTargetObjectId(contactId);//Contact,Lead,User Id
            mail.setWhatId(caseId); //Custom, Few Standard objs
            //System.debug('>>'+mail.getHtmlBody());
            //System.debug('>>'+mail.getPlainTextBody());
            
            if(mail.getSubject()!=null){
                mail.setSubject(mail.getSubject());
                mails.add(mail.getSubject());
            }
            if((mail.getHtmlBody()) == null) {
                mails.add(mail.getPlainTextBody()); 
            }
            else {
                mails.add('HTML Value');
                //EmailTemplate tempID = [SELECT Id,HTMLValue,Name FROM EmailTemplate WHERE Id =:templateId];
                mails.add(mail.getHtmlBody());    
            }
            
            return mails;
        }catch(Exception ex){
            ex.getMessage();
            return null;
        }
        
    }
    public class JSON2Apex {
        
        public String id;
        public String Name;
        public String Email;
        public String Title;
        public Blob VersionData;
        
    }
    public static List<JSON2Apex> parse(String json) {
        return (List<JSON2Apex>) System.JSON.deserialize(json, List<JSON2Apex>.class);
    }
    
}