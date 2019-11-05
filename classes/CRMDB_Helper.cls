/*
Author          : Hardik S.
Release         : CMRDB Qualification and CRMDB Integration
Created         : May 17, 2019
Functionality   : Logic to do summation of Annual and Total CMS CRS 


Modification History:
Itrack#        Date        Author             Change 
US277513       5/17/2019   Kavya M            New Contract(Parent/Child) Request Automation   
US318317       6/1/2019    Awnish K.          Parent Summation should be changed when Annual/ Total CMS value on child record is edited
US318316       6/1/2019    Awnish K.          The Child contract Annual and total CR values should be editable
DE258765       6/1/2019    Awnish K.          Parent Sum twice on Active Contract change
*/
public with sharing class CRMDB_Helper{
    public static Boolean parentUpdate = false;
    public static Boolean childUpdate = false;
    
    //Updated Cap fields on the child records when Cap fields are updated on parent record.
    Public static void capFieldsUpdate(list <CRMDB__c> CRMDBList,list<CRMDB__c>oldCRMDBList){
        if(Utilities.getConstant_CS('CRMDB Trigger Skip')=='No'){
            List<CRMDB__c>childList=new List<CRMDB__C>();
            List<CRMDB__c>FinalList = new List<CRMDB__c>();
            
            if(!CRMDBList.isEmpty()){
                childList=[SELECT Is_Customer_on_CAP__c, Is_CAP_caused_by_CMS__c, CAP_Title__c, CAP_Case_Opened_Date__c, CAP_case_Number_Engagement_ID__c,
                           CAP_case_Manager_Name__c,Brief_Summary_for_Red_Yellow_Status__c,Master_Customer_Name__c FROM CRMDB__c WHERE Master_Customer_Name__c IN:CRMDBList];
            }
            if(!childList.isEmpty()){
                for(CRMDB__c CRMDB :childList){
                    for(CRMDB__c c:CRMDBList){
                        if(CRMDB.Master_Customer_Name__c== c.id){
                            CRMDB.Is_Customer_on_CAP__c=c.Is_Customer_on_CAP__c;
                            CRMDB.Is_CAP_caused_by_CMS__c=c.Is_CAP_caused_by_CMS__c;
                            CRMDB.CAP_Title__c=c.CAP_Title__c;
                            CRMDB.CAP_Case_Opened_Date__c=c.CAP_Case_Opened_Date__c;
                            CRMDB.CAP_case_Number_Engagement_ID__c=c.CAP_case_Number_Engagement_ID__c;
                            CRMDB.CAP_case_Manager_Name__c=c.CAP_case_Manager_Name__c;
                            CRMDB.Brief_Summary_for_Red_Yellow_Status__c=c.Brief_Summary_for_Red_Yellow_Status__c;
                            CRMDB.Reason_for_Yellow_Red__c=c.Reason_for_Yellow_Red__c; 
                            FinalList.add(CRMDB);
                        }   
                        
                    } 
                }
            }
            if(!FinalList.isEmpty()){
                parentUpdate=true;
                Update FinalList;
            }
        }
    }
    
    //Update Total and Annual CMS CRs field when Total and Annual CMS fields are updated
    public static void totalandAnnualContractUpdate(Map<Id,CRMDB__c>oldRecMap,List<CRMDB__c>newRecList){
        if(Utilities.getConstant_CS('CRMDB Trigger Skip')=='No'){
            for(CRMDB__c crmdbChild : newRecList){
                if((crmdbChild.Annual_Child_CMS_CR__c!= oldRecMap.get(crmdbChild.Id).Annual_Child_CMS_CR__c || crmdbChild.Annual_CMS_Contract_Value__c  != oldRecMap.get(crmdbChild.Id).Annual_CMS_Contract_Value__c) ){
                    crmdbChild.Annual_CMS_Contract_Value_CR_S__c = crmdbChild.Annual_CMS_Contract_Value__c + crmdbChild.Annual_Child_CMS_CR__c;
                }
                if((crmdbChild.Total_Child_CMS_CR__c!= oldRecMap.get(crmdbChild.Id).Total_Child_CMS_CR__c || crmdbChild.Total_CMS_Contract_Value__c  != oldRecMap.get(crmdbChild.Id).Total_CMS_Contract_Value__c)){
                    crmdbChild.Total_CMS_Contract_Value_CR_S__c =  crmdbChild.Total_CMS_Contract_Value__c + crmdbChild.Total_Child_CMS_CR__c;
                }
            }
        }
    }  
    
    //Summation of child CRs to Parent
    public static void qualificationUpdate(Map<Id,CRMDB__c>oldRecMap,List<CRMDB__c>newRecList){
        if(Utilities.getConstant_CS('CRMDB Trigger Skip')=='No'){
            List<Id> parentIDLst = new List<Id>();
            List<CRMDB__c> parentCrmdbUpdateLst = new List<CRMDB__c>();
            
            //Logic to update parent when the child is activated
            for(CRMDB__c crmdb  : newRecList){
                if(crmdb.Master_Customer_Name__c!=null && 
                   (crmdb.Active_Customer__c!=oldRecMap.get(crmdb.Id).Active_Customer__c ||
                    crmdb.Total_CMS_Contract_Value_CR_S__c!=oldRecMap.get(crmdb.Id).Total_CMS_Contract_Value_CR_S__c  ||
                    crmdb.Annual_CMS_Contract_Value_CR_S__c!=oldRecMap.get(crmdb.Id).Annual_CMS_Contract_Value_CR_S__c 
                   )){
                       parentIDLst.add(crmdb.Master_Customer_Name__c);
                   }
            }
            //Fetching parent records to update 
            List<CRMDB__c> parentLst = [select id,Total_CMS_Contract_Value_CR_S__c,Total_CMS_Contract_Value__c,Annual_CMS_Contract_Value_CR_S__c,Annual_CMS_Contract_Value__c from CRMDB__c where id in : parentIDLst];
            for(CRMDB__c parentCrmdb : parentLst){
                for(CRMDB__c crmdb  : newRecList){
                    if(crmdb.Master_Customer_Name__c==parentCrmdb.Id){
                        //Sum Annual and Total CMS Contract Value and CRs value on parent when the Active Customer Flag is Yes on child record
                        if(crmdb.Active_Customer__c==oldRecMap.get(crmdb.Id).Active_Customer__c && crmdb.Active_Customer__c.contains('Yes')){
                            if(crmdb.Annual_CMS_Contract_Value_CR_S__c!=oldRecMap.get(crmdb.Id).Annual_CMS_Contract_Value_CR_S__c){
                                parentCrmdb.Annual_CMS_Contract_Value_CR_S__c -= oldRecMap.get(crmdb.Id).Annual_CMS_Contract_Value_CR_S__c;
                                parentCrmdb.Annual_CMS_Contract_Value_CR_S__c += crmdb.Annual_CMS_Contract_Value_CR_S__c;
                            }
                            if(crmdb.Annual_CMS_Contract_Value__c!=oldRecMap.get(crmdb.Id).Annual_CMS_Contract_Value__c){
                                parentCrmdb.Annual_CMS_Contract_Value__c -= oldRecMap.get(crmdb.Id).Annual_CMS_Contract_Value__c;
                                parentCrmdb.Annual_CMS_Contract_Value__c += crmdb.Annual_CMS_Contract_Value__c;
                            }
                            if(crmdb.Total_CMS_Contract_Value_CR_S__c!=oldRecMap.get(crmdb.Id).Total_CMS_Contract_Value_CR_S__c){
                                parentCrmdb.Total_CMS_Contract_Value_CR_S__c -= oldRecMap.get(crmdb.Id).Total_CMS_Contract_Value_CR_S__c;
                                parentCrmdb.Total_CMS_Contract_Value_CR_S__c += crmdb.Total_CMS_Contract_Value_CR_S__c;
                            }
                            if(crmdb.Total_CMS_Contract_Value__c!=oldRecMap.get(crmdb.Id).Total_CMS_Contract_Value__c){
                                parentCrmdb.Total_CMS_Contract_Value__c -= oldRecMap.get(crmdb.Id).Total_CMS_Contract_Value__c;
                                parentCrmdb.Total_CMS_Contract_Value__c += crmdb.Total_CMS_Contract_Value__c;
                            }
                            
                        }
                        //Sum Annual and Total CMS Contract Value and CRs value on parent when the Active Customer Flag is changed from No to Yes on child record
                        else if(crmdb.Active_Customer__c.contains('Yes') && oldRecMap.get(crmdb.Id).Active_Customer__c.contains('No')){
                            parentCrmdb.Total_CMS_Contract_Value_CR_S__c += crmdb.Total_CMS_Contract_Value_CR_S__c;
                            parentCrmdb.Annual_CMS_Contract_Value_CR_S__c += crmdb.Annual_CMS_Contract_Value_CR_S__c;
                            parentCrmdb.Total_CMS_Contract_Value__c += crmdb.Total_CMS_Contract_Value__c;
                            parentCrmdb.Annual_CMS_Contract_Value__c += crmdb.Annual_CMS_Contract_Value__c;
                            
                            //Remove Annual and Total CMS Contract Value and CRs value on parent when the Active Customer Flag is changed from Yes to No on child record
                        }else if (crmdb.Active_Customer__c.contains('No') && oldRecMap.get(crmdb.Id).Active_Customer__c.contains('Yes')){
                            if(crmdb.Annual_CMS_Contract_Value_CR_S__c!=oldRecMap.get(crmdb.Id).Annual_CMS_Contract_Value_CR_S__c){
                                parentCrmdb.Annual_CMS_Contract_Value_CR_S__c -= oldRecMap.get(crmdb.Id).Annual_CMS_Contract_Value_CR_S__c;
                            }else{
                                parentCrmdb.Annual_CMS_Contract_Value_CR_S__c -= crmdb.Annual_CMS_Contract_Value_CR_S__c;
                            }
                            if(crmdb.Annual_CMS_Contract_Value__c!=oldRecMap.get(crmdb.Id).Annual_CMS_Contract_Value__c){
                                parentCrmdb.Annual_CMS_Contract_Value__c -= oldRecMap.get(crmdb.Id).Annual_CMS_Contract_Value__c;
                            }else{
                                parentCrmdb.Annual_CMS_Contract_Value__c -= crmdb.Annual_CMS_Contract_Value__c;
                            }
                            if(crmdb.Total_CMS_Contract_Value__c!=oldRecMap.get(crmdb.Id).Total_CMS_Contract_Value__c){
                                parentCrmdb.Total_CMS_Contract_Value__c -= oldRecMap.get(crmdb.Id).Total_CMS_Contract_Value__c;
                            }else{
                                parentCrmdb.Total_CMS_Contract_Value__c -= crmdb.Total_CMS_Contract_Value__c;
                            }
                            if(crmdb.Total_CMS_Contract_Value_CR_S__c!=oldRecMap.get(crmdb.Id).Total_CMS_Contract_Value_CR_S__c){
                                parentCrmdb.Total_CMS_Contract_Value_CR_S__c -= oldRecMap.get(crmdb.Id).Total_CMS_Contract_Value_CR_S__c;
                            }else{
                                parentCrmdb.Total_CMS_Contract_Value_CR_S__c -= crmdb.Total_CMS_Contract_Value_CR_S__c;
                            }
                        }
                        parentCrmdb.Annual_Child_CMS_CR__c = parentCrmdb.Annual_CMS_Contract_Value_CR_S__c - parentCrmdb.Annual_CMS_Contract_Value__c;
                        parentCrmdb.Total_Child_CMS_CR__c = parentCrmdb.Total_CMS_Contract_Value_CR_S__c - parentCrmdb.Total_CMS_Contract_Value__c;
                    }
                }
                parentCrmdbUpdateLst.add(parentCrmdb);
            }
            childUpdate=true;
            update parentCrmdbUpdateLst;
        }
    }
    
    //Validate CAP fields on Child
    public static void childCapFieldsUpdateValidation(list <CRMDB__c> CRMDBList,list<CRMDB__c>oldCRMDBList){
        if(Utilities.getConstant_CS('CRMDB Trigger Skip')=='No'){
            for(CRMDB__c newRec:CRMDBList){
                for(CRMDB__c oldRec:oldCRMDBList){
                    if(newRec.Master_Customer_Name__c!=null && parentUpdate==false && newRec.Master_Customer_Name__c==oldRec.Master_Customer_Name__c){
                        if(//newRec.Is_Customer_on_CAP__c!=oldRec.Is_Customer_on_CAP__c ||
                            newRec.Is_CAP_caused_by_CMS__c!=oldRec.Is_CAP_caused_by_CMS__c ||
                            newRec.CAP_Title__c!=oldRec.CAP_Title__c||
                            newRec.CAP_Case_Opened_Date__c!=oldRec.CAP_Case_Opened_Date__c||
                            newRec.CAP_case_Number_Engagement_ID__c!=oldRec.CAP_case_Number_Engagement_ID__c||
                            newRec.CAP_case_Manager_Name__c!=oldRec.CAP_case_Manager_Name__c||
                            newRec.Brief_Summary_for_Red_Yellow_Status__c!=oldRec.Brief_Summary_for_Red_Yellow_Status__c){
                                newRec.addError('Please update CAP fields on CRMDB Parent Contract.');  
                            }
                    }
                }
            }
        }
    }
    
    //Show Error message when SDM try to update parent Contract Annual and Total CMS Values 
    Public static void totalandAnnualContractValidation(list <CRMDB__c> CRMDBList,Map<Id,CRMDB__c>oldRecMap){
        if(Utilities.getConstant_CS('CRMDB Trigger Skip')=='No'){
            for(CRMDB__c crmdb:CRMDBList){
                if(crmdb.Master_Customer_Name__c==null && childUpdate==false){
                    if( crmdb.Total_CMS_Contract_Value__c!=oldRecMap.get(crmdb.Id).Total_CMS_Contract_Value__c ||
                       crmdb.Annual_CMS_Contract_Value__c!=oldRecMap.get(crmdb.Id).Annual_CMS_Contract_Value__c ||
                       crmdb.Total_CMS_Contract_Value_CR_S__c!=oldRecMap.get(crmdb.Id).Total_CMS_Contract_Value_CR_S__c ||
                       crmdb.Annual_CMS_Contract_Value_CR_S__c!=oldRecMap.get(crmdb.Id).Annual_CMS_Contract_Value_CR_S__c ||
                       crmdb.Annual_Child_CMS_CR__c!=oldRecMap.get(crmdb.Id).Annual_Child_CMS_CR__c ||
                       crmdb.Total_Child_CMS_CR__c!=oldRecMap.get(crmdb.Id).Total_Child_CMS_CR__c
                      ){
                          crmdb.addError('Please update Total and Annual CMS fields on CRMDB Child Contract.');  
                      }
                }
            }
        }
    } 
    
}