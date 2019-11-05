/**************************************
Author          : Shivi Srivastava 
Release         : March Release
Created         : Feb,2019
Functionality   : This class is used to fetch email templates

Modification History:
Itrack#        Date        Author              Change
****************************************************************************/
public class Email_Template {
    
//fetching all template folders    
@AuraEnabled
    public static List<etWrapper> fetchTempFolder(){
        String includeValue = Utilities.getConstant_CS('IncludeEmailTemplates');
        List<Folder> tempFolder=[Select id,Name from Folder where Type=:'Email' and Name like :('%'+includeValue+'%') and (NOT Name like '%REMOVED%') and (NOT Name like '%OLD%')];
        System.debug('>>'+tempFolder);
        List<etWrapper> lstETWrapper=new List<etWrapper>();
        for(Folder tFold:tempFolder){
            etWrapper ew=new etWrapper();
            ew.label=tFold.Name;
            ew.value=tFold.Id;
            lstETWrapper.add(ew);
        }
            
      return lstETWrapper;
    }
    
    public class etWrapper{
        
    @AuraEnabled
    public String label;
    @AuraEnabled
    public string value;
    }

//fetching all templates from the selected folders    
    @AuraEnabled
    public static List<EmailTemplate> getTemplates(String folderId){
        List<EmailTemplate> templateLst=[Select id,Name,TemplateType,Description,Subject,Body from EmailTemplate where FolderId=:folderId and IsActive=true];
        return templateLst;
    }
//returning email template information
    @AuraEnabled
    public static EmailTemplate getSelectedTemplates(String templateId){
        EmailTemplate templateLst=[Select id,Name,TemplateType,Description,Subject,Body from EmailTemplate where Id=:templateId];
        System.debug('>>'+templateLst);
        return templateLst;
    }
}