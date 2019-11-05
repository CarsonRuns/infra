/**
   @Author :Jay Dash
   @name :POVlineitem 
   @CreateDate : 9/11/2014
   @Description :Getting POV and LineItem details from object<POV_eStar_Lineitem__c> after data received from estar through webservice
   @Version :1.0
   
       *********** Change History ***********
    9/11 - Remvoed the DLP URL hardcoding and using the custom setting value via domainUrl variable.
  */
  
  public with sharing class POVlineitem {
    string povId ;
    string povName ;    
    string povcrcountry ;
    string povordercategory ; 
    public string domainUrl;
    
    public string getDomainUrl(){       
        return Utilities.getConstant_CS('dlpDomainUrl');
    }
    public String getMySessionID(){
        return UserInfo.getSessionID();
    }
    public POVlineitem (ApexPages.StandardController controller) {
        Proof_of_Value__c pv =  (Proof_of_Value__c)controller.getRecord();
        povId = pv.id;
        povName = pv.Name;        
        povcrcountry = pv.CRCountry__c;
        povordercategory = pv.PoV_Order_Category__c;        
    }
    public List<string> getDlpPage(){
        return new List<string>();
    } 
    Public boolean getIsDisable() {
        //boolean isDisable=false;
        List<Proof_of_Value__c > povls=[ SELECT id,name,country__c,CRCountry__c,PoV_Order_Category__c,POV_Approval_Status__c FROM Proof_of_Value__c WHERE id=:povId ];
        if(!povls.isEmpty()){
            if(povls[0].POV_Approval_Status__c  !='SAM Work in Progress')
            if(povls[0].POV_Approval_Status__c  !='SE Manager Rejected')
            if(povls[0].POV_Approval_Status__c  !='RM Rejected')
            if(povls[0].POV_Approval_Status__c  !='OD Rejected')
                 {return true;}
            else 
                 {return false;}
        } 
         return false;
    }
    
    public List<POV_eStar_Lineitem__c> getValuesfromdlp()
    {    
        List<POV_eStar_Lineitem__c> lstDlp = [SELECT id,Name,Ship_Set_Number__c,Line_Number__c,Item_Path__c,Ordrered_Quantity__c,Unit_List_Price__c,Ext_Price__c,Session_ID__c,Proof_of_Value__c 
                                              FROM POV_eStar_Lineitem__c WHERE proof_of_Value__c =:povId order by Line_Number__c]; 
        return lstDlp; 
    } 
    public PageReference redirect(){
         String cfField = Utilities.getConstant_CS('povcustomfieldname');
         String cfFieldid = Utilities.getConstant_CS('povcustomfieldid');
         string optyName = ApexPages.currentPage().getParameters().get(cfField);
         string optyid = ApexPages.currentPage().getParameters().get(cfFieldid);       
         if(optyName == null){
             PageReference pgr;    
             pgr = new PageReference('/apex/POVListView');        
             pgr.setRedirect(true);
             return pgr; 
         }else{
            string objId = Proof_of_Value__c.SObjectType.getDescribe().getKeyPrefix();
            PageReference prEdit;
            prEdit = new Pagereference('/' + objId + '/e');
            prEdit.getParameters().put('nooverride','1');
            prEdit.getParameters().put(cfField,optyName);
            prEdit.getParameters().put(cfFieldid,optyid);
            prEdit.getParameters().put('retURL',optyid);
            prEdit.getParameters().put('cancelURL',optyid);
            prEdit.getParameters().put('saveURL',povId);           
            prEdit.setRedirect(true);
            return prEdit.setRedirect(true);        
         }
         return null;             
    }
 
 }