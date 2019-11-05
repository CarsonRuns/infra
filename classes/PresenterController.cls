/*
    Story - US6281
    Release - November 2014
    Author - Bramha, Accenture
    Functionality -  Presenter -- Profile.
*/
public with sharing class PresenterController{
    // SCAVA Helper Method to validate Create Access at field level
   
     public static Boolean flsGet(SObjectField field)
    {
        return field.getDescribe().isCreateable() ? true : false;
    }
     // SCAVA Helper Method to validate Update Access at field level
    
     public static Boolean flsUpdate(SObjectField field)
    {
        return field.getDescribe().isUpdateable() ? true : false;
    }
    public ApexPages.StandardController sc {get;set;}    
    private  Presenter__c  prc;
    String pUserid;
    public string prId{get;set;} 
    public List<Topic__c> tpc{get;set;} 
    public List<wrperClass> wrTopic{get; set;}

    public PresenterController(ApexPages.StandardController sc) {
        pUserid = ApexPages.currentPage().getParameters().get('sfdc.userId');         
        this.sc = sc;
        this.prc = (Presenter__c)sc.getRecord();
        prId =sc.getId();

    }   

    public PageReference saveExp() {  
        string pnUserid = ApexPages.currentPage().getParameters().get('uid');
        prId= ApexPages.currentPage().getParameters().get('id');
        List<Presenter__c> pcs = [select id from Presenter__c where User__c =: pUserid limit 1];
        PageReference customPage;     
        if(pcs.isEmpty()){
            customPage =  Page.PresenterNew;
            Presenter__c prcen = new Presenter__c();
            if(flsGet(Presenter__c.User__c)) 
            {           
            prcen.User__c = pUserid;
            }
            //SCAVA FIX
            if(Presenter__c.SobjectType.getDescribe().isCreateable()){
            insert prcen;
            }
            prId = prcen.id;
            customPage.getParameters().put('id', prcen.id);           
        }else{
            customPage =  Page.PresenterNew;
            prId = pcs[0].id;
            customPage.getParameters().put('id', prId);
        }           

        customPage.setRedirect(true);         
        return customPage;
    }

    public void topics(){
        prId= ApexPages.currentPage().getParameters().get('id');
        List<Presenter__c> prnt = [SELECT id,Presentation_Topics__c FROM Presenter__c WHERE id=:prId];
        string[] str;
        Map<string, string> strMap = new Map<string,string>();
        if(!prnt.isEmpty() && prnt[0].Presentation_Topics__c != null){
            str =  prnt[0].Presentation_Topics__c.split(';');
            for(string strs:str){
                strMap.put(strs,strs);
            }
        } 

        tpc =[SELECT id,name FROM Topic__c]; 
        wrTopic = new List<wrperClass>(); 
        for(Topic__c tp : tpc){
            wrperClass wp = new wrperClass();
            if(strMap.containsKey(tp.name)){
                wp.isCheck = true;
            }else{
                wp.isCheck = false;
            }
            wp.tpName = tp.name;
            wrTopic.add(wp);
        }  
    }

    // public Getter to provide table headers
    public string[] getheaders() { 
        return new string []    {'','Topic Name'} ;
    }    

    public class wrperClass{
        public boolean isCheck{get; set;}
        public string tpName{get; set;}
    } 

    public void updateTopic(){
        prId= ApexPages.currentPage().getParameters().get('id');
        List<Presenter__c> prnt = [SELECT id,Presentation_Topics__c FROM Presenter__c WHERE id=:prId];
        string isValue='';        
        for(wrperClass wc : wrTopic){
            if(wc.isCheck){
                if(isValue== ''){
                    isValue+=wc.tpName;
                }else{
                    isValue+=';'+wc.tpName;
                }
            }
        }
        if(!prnt.isEmpty()){
            if(flsUpdate(Presenter__c.Presentation_Topics__c)) 
            {
            prnt[0].Presentation_Topics__c = isValue;
            }
            update prnt;
        }

    }

    public string[] getTopics(){
        prId= ApexPages.currentPage().getParameters().get('id');
        string[] str = new string[] {''};   
        List<Presenter__c> tpcs = [SELECT id,Presentation_Topics__c FROM Presenter__c WHERE id=:prId];      
        return (!tpcs.isEmpty() && tpcs[0].Presentation_Topics__c != null)? tpcs[0].Presentation_Topics__c.split(';'):str;    

    }
}