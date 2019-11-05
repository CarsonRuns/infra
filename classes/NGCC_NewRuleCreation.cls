/******************************************************************************
Name    : NGCC_NewRuleCreation 
Author  : Nirup Kohir
Purpose : This Controller Class is used to validate and add records to CC Lead Priority Rule object
Created Date:  10/08/2015

Modification History
  Author: Zakeer Ahmed
  Purpose: added SortLeadAttributeAsec for sorting the LOVs in ASEC in the Lead Attribute field
  Date: Nov/16/2017 
*******************************************************************************/
public with sharing class NGCC_NewRuleCreation {
    public NGCC_Rule_Assignment__c ngcc{get; set;}
    public List<selectoption> custompicklist{get;set;}    
    public Map<String,NGCC_Lead_Attribute_Mapping__c> FieldApiMap{get;set;}
    
    // SCAVA Helper Method
     public static Boolean flsGet(SObjectField field)
    {
        return field.getDescribe().isCreateable() ? true : false;
    }
    
    // SCAVA Helper Method to validate Update Access at field level
     public static Boolean flsUpdateGet(SObjectField field)
    {
        return field.getDescribe().isUpdateable() ? true : false;
    }

    public string recID {get; set;}
    public boolean saveOnly {get; set;}
    map<string,string> fieldLabels;
    List<selectoption> sortKeys;
        
    public NGCC_NewRuleCreation(ApexPages.StandardController controller) {
        ngcc =  new NGCC_Rule_Assignment__c();
        fieldLabels = new map<string, string>();
        custompicklist = new list<selectoption>();        
        FieldApiMap = NGCC_Lead_Attribute_Mapping__c.getall();
        saveOnly = false;
     
    //Zak-adding sorting logic        
        List<NGCC_Lead_Attribute_Mapping__c> valuesOfMap = FieldApiMap.values();
        List<NGCC_Lead_Attribute_Mapping__c> valuesResult=SortLeadAttributeAsec(valuesOfMap);
        for(NGCC_Lead_Attribute_Mapping__c str: valuesResult){
        custompicklist.add(new selectoption(str.Name,str.Value__c));                             
        fieldLabels.put(str.name,str.value__c);
   } 
    
        if(apexPages.currentPage().getParameters().get('id') != null){
            recID = apexPages.currentPage().getParameters().get('id');
            list<NGCC_Rule_Assignment__c> tmp = new list<NGCC_Rule_Assignment__c>();
            tmp = [select id,Lead_Attribute_label__c,All_Countries__c, name,Countries__c,Lead_Attribute__c,MODS_Leads__c,MODS_Q_A__c,Priority__c,Rank__c,Theater__c,Value__c, Active__c from NGCC_Rule_Assignment__c where id=:recId];
            if(tmp.size() > 0){
                ngcc = tmp[0];
            }
        }    
    }
    //Zak: added selectionSort for Lead Attributes list in ASEC ORDER
    public List<NGCC_Lead_Attribute_Mapping__c> SortLeadAttributeAsec(List<NGCC_Lead_Attribute_Mapping__c> ValuesOfMap){
    for(Integer i =0; i <valuesOfMap.size();i++){
            for(Integer j=i+1; j <valuesOfMap.size();j++){
               if(valuesOfMap.get(i).value__c.compareTo(valuesOfMap.get(j).value__c)>0){
                    NGCC_Lead_Attribute_Mapping__c value = valuesOfMap.get(i);
                    valuesOfMap.set(i,valuesOfMap.get(j));
                    valuesOfMap.set(j,value);
              }    
            }
    }
        return ValuesOfMap;
    }
            
    public pageReference saveRec(){
        try{
            
            if(ngcc.Theater__c == null || ngcc.Theater__c == ''){
           
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Please select Theater');
                ApexPages.addMessage(myMsg);
            }
            if(ngcc.MODS_Leads__c == null || ngcc.MODS_Leads__c ==''){
                ApexPages.Message erMsg = new ApexPages.Message (ApexPages.Severity.ERROR,'Error:Please Select MODS/Leads');
                apexpages.addMessage(erMsg);
            }
            
            if(ngcc.MODS_Leads__c == 'MODS Q/A' && ngcc.MODS_Q_A__c == null ){
                    ApexPages.Message erMsg = new ApexPages.Message (ApexPages.Severity.ERROR,'Please Select MODS Q/A');
                    apexpages.addMessage(erMsg);
                
            }
           if(ngcc.MODS_Leads__c == 'Lead Attribute' && (ngcc.Lead_Attribute__c=='' || ngcc.Lead_Attribute__c == null)){
                    ApexPages.Message erMsg = new ApexPages.Message (ApexPages.Severity.ERROR,'Please Select Lead Attribute');
                    apexpages.addMessage(erMsg);

            }
            
             if(ngcc.Value__c == null || ngcc.Value__c ==''){
                ApexPages.Message erMsg = new ApexPages.Message (ApexPages.Severity.ERROR,'Error:Please enter Value');
                apexpages.addMessage(erMsg);
            }
            
             if(!ngcc.All_Countries__c && (ngcc.Countries__c == null || ngcc.Countries__c =='')){
                ApexPages.Message erMsg = new ApexPages.Message (ApexPages.Severity.ERROR,'Error:Please Select Country/Countries ');
                apexpages.addMessage(erMsg);
            }
            
             if(ngcc.Rank__c == null || ngcc.Rank__c ==''){
                ApexPages.Message erMsg = new ApexPages.Message (ApexPages.Severity.ERROR,'Error:Please Select Rank ');
                apexpages.addMessage(erMsg);
            }
            
             if(ngcc.Priority__c == null || ngcc.Priority__c ==''){
                ApexPages.Message erMsg = new ApexPages.Message (ApexPages.Severity.ERROR,'Error:Please Select Priority ');
                apexpages.addMessage(erMsg);
            }
            
            else{
                if(ngcc.MODS_Leads__c =='Lead Attribute' && fieldLabels.get(ngcc.Lead_Attribute__c) != null){
                    ngcc.Lead_Attribute_label__c = fieldLabels.get(ngcc.Lead_Attribute__c);
                }else{
                //SCAVA
                     if(flsGet(NGCC_Rule_Assignment__c.Lead_Attribute_label__c)||flsUpdateGet(NGCC_Rule_Assignment__c.Lead_Attribute_label__c)){
                     ngcc.Lead_Attribute_label__c = '';
                     }//SCAVA
                }
                if(ngcc.All_Countries__c){
                    //SCAVA
                    if(flsGet(NGCC_Rule_Assignment__c.Countries__c)||flsUpdateGet(NGCC_Rule_Assignment__c.Countries__c)){
                    ngcc.Countries__c = null;  
                    }//SCAVA                    
                }
                upsert ngcc;   
                return new Pagereference('/'+ngcc.id);  
                
                
            }
            return null;
                
        }catch(exception e){
            system.debug('This is Exception save>>>>' +e);
            return null;
        }
    }
    
    public pageReference saveandNew(){
        try{
            
            if(ngcc.Theater__c == null || ngcc.Theater__c == ''){
           
                ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Please select Theater');
                ApexPages.addMessage(myMsg);
            }
             if(ngcc.MODS_Leads__c == null || ngcc.MODS_Leads__c ==''){
                ApexPages.Message erMsg = new ApexPages.Message (ApexPages.Severity.ERROR,'Error:Please Select MODS/Leads');
                apexpages.addMessage(erMsg);
            }
             if(ngcc.MODS_Leads__c == 'MODS Q/A' && ngcc.MODS_Q_A__c == null ){
                    ApexPages.Message erMsg = new ApexPages.Message (ApexPages.Severity.ERROR,'Please Select MODS Q/A');
                    apexpages.addMessage(erMsg);
                
            }
            if(ngcc.MODS_Leads__c == 'Lead Attribute' && (ngcc.Lead_Attribute__c=='' || ngcc.Lead_Attribute__c == null)){
                    ApexPages.Message erMsg = new ApexPages.Message (ApexPages.Severity.ERROR,'Please Select Lead Attribute');
                    apexpages.addMessage(erMsg);

            }
            
             if(ngcc.Value__c == null || ngcc.Value__c ==''){
                ApexPages.Message erMsg = new ApexPages.Message (ApexPages.Severity.ERROR,'Error:Please enter Value');
                apexpages.addMessage(erMsg);
            }
            
             if(ngcc.All_Countries__c && (ngcc.Countries__c == null || ngcc.Countries__c =='')){
                ApexPages.Message erMsg = new ApexPages.Message (ApexPages.Severity.ERROR,'Error:Please Select Country/Countries ');
                apexpages.addMessage(erMsg);
            }
            
             if(ngcc.Rank__c == null || ngcc.Rank__c ==''){
                ApexPages.Message erMsg = new ApexPages.Message (ApexPages.Severity.ERROR,'Error:Please Select Rank ');
                apexpages.addMessage(erMsg);
            }
            
             if(ngcc.Priority__c == null || ngcc.Priority__c ==''){
                ApexPages.Message erMsg = new ApexPages.Message (ApexPages.Severity.ERROR,'Error:Please Select Priority ');
                apexpages.addMessage(erMsg);
            }
            
            else{
                if(ngcc.MODS_Leads__c =='Lead Attribute' && fieldLabels.get(ngcc.Lead_Attribute__c) != null){
                    ngcc.Lead_Attribute_label__c = fieldLabels.get(ngcc.Lead_Attribute__c);
                }else{
                     ngcc.Lead_Attribute_label__c = '';
                }
                
                if(ngcc.All_Countries__c){
                    ngcc.Countries__c = null;   
                }
                upsert ngcc;   
                pageReference pf = new pageReference('/apex/NGCC_LeadRuleassignment');
                pf.setRedirect(true);
                return pf;  
                
                
            }
            return null;
                
        }catch(exception e){
            system.debug('This is Exception save>>>>' +e);
            return null;
        }
    }
    

    
    public pageReference reRenderThePage(){
        //SCAVA 
        if(flsGet(NGCC_Rule_Assignment__c.MODS_Q_A__c)||flsUpdateGet(NGCC_Rule_Assignment__c.MODS_Q_A__c)){
        ngcc.MODS_Q_A__c = null;
        }
        if(flsGet(NGCC_Rule_Assignment__c.Lead_Attribute__c)||flsUpdateGet(NGCC_Rule_Assignment__c.Lead_Attribute__c)){
        ngcc.Lead_Attribute__c = null;
        }//SCAVA
        return null;
    }
}