/**************************************
Author          : 
Release         : 
Created         : 
Functionality   : class helps us to create engage resource

Modification History:
Itrack#        Date        Author                       Change  
****************************************************************************
DE229732     Feb 6,2019   R.Hari Krishna(ratharik)    Encoded special chareters of Oppty Name

**********************************************/

public class Engage_Resource{
    public Opportunity opp {get;set;}
    public string usernm {get;set;}
    public String sesId{get;set;}
    public String userId{get;set;}
    public Id OppRecId{get;set;}
    public String terID{get;set;}
    public String optyNam{get;set;}
    public String perm{get;set;}
    public String nprodCons{get;set;}
    public String prodCons{get;set;}
    public String terName{get;set;}    
    /*Lightning November 2018 release start*/
    public String ASPageVisibleTheaters{get;set;}
    public String caseRecTypeId{get;set;}
    public Boolean caseExist{get;set;}
    
    // SCAVA FIX , CONVERT BOOLEAN INTO STRING   
    @TestVisible
    public String caseExist1{
        get{
            caseExist1 =(caseExist)? 'true' : 'false';
            return caseExist1;
        }
        public set;
    }
    
    /*Lightning November 2018 release end*/
    public Engage_Resource(ApexPages.StandardController controller) {
        this.opp = (Opportunity)Controller.getRecord();        
        OppRecId = ApexPages.currentPage().getParameters().get('id');
        System.debug('@@@@@@ID-->' + OppRecId );
        /*Lightning November 2018 release start*/        
        Opportunity  oppRec = [Select Id,Territory2Id,Territory_Level_01__c, Theater__c,Name From Opportunity where Id =: OppRecId] ;
        terName = oppRec.Theater__c;
        /*Lightning November 2018 release end*/  
        terID = oppRec.Territory2Id; 
        //[Added by: R.Hari Kirshna(ratharik),US/Defect #: DE229732]    
        optyNam = EncodingUtil.urlEncode(oppRec.Name, 'UTF-8');        
        User u = [Select UserName, additional_user_permissions__c From User where Id = :UserInfo.getUserId()];
        perm = u.additional_user_permissions__c ;
        usernm=u.username;
        userid=u.id;
        sesId = UserInfo.getSessionId();
        
        Org_Constants__c orgCon = [SELECT prod_value__c, non_prod_value__c,Key__c  FROM Org_Constants__c WHERE Key__c = 'SE Link'];
        prodCons = orgCon.prod_value__c;
        nprodCons = orgCon.non_prod_value__c;
        /*Lightning November 2018 release start*/
        Org_Constant_CS__c orgCon2 = [SELECT Name,Non_Production_Value__c,Production_Value__c FROM Org_Constant_CS__c WHERE Name = 'AS_Engagement_Request_Theaters'];                   
        ASPageVisibleTheaters = orgCon2.Production_Value__c;
        
        caseRecTypeId = Utilities.getEngageServicesResourcesRecordTypeID();
        
        //Check for the opportunity any ER Case is already created or not
        Case[] existingCases = [select id from case where opportunity__c = :oppRec.Id and RecordTypeId = :caseRecTypeId];          
        
        caseExist = false; 
        
        if (existingCases.size() > 0){ 
            caseExist = true; 
        } 
        else { 
            caseExist =false; 
        } 
        /*Lightning November 2018 release end*/      
    }
    
    public PageReference redirct(){
        OppRecId = ApexPages.currentPage().getParameters().get('id');
        list<case> caselist = [select id from case where Opportunity__c =:OppRecId and RecordTypeid = '012n00000008oPv' limit 1];
        if(!caselist.isEmpty())
        {
            ApexPages.Message myMsg = new ApexPages.Message(ApexPages.Severity.ERROR,'Error: Invalid Input.');
            ApexPages.addMessage(myMsg);
            return new PageReference('/'+OppRecId);
        }
        return null;
    }
}