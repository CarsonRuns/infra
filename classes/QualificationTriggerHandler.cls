/*
Author          : Hardik S.
Release         : CMRDB Qualification and CRMDB Integration
Created         : May 17, 2019
Functionality   : Logic to do summation of Annual and Total CMS CRS 


Modification History:
Itrack#        Date        Author             Change 
US293454       05/17/2019  Hardik S.          Change Request (CR) Automation
DE258765       06/01/2019  Awnish K.          Code Cleanup & Parent Sum twice on Active Contract change
*/
public class QualificationTriggerHandler {
    
    //Set CRMDD fields to blank when Qulification Record is Cloned
    Public static void UpdateCRMDBIntegrationFields(list <Qualification__c> qualifications){
        try{
            for(Qualification__c qualification : qualifications){
                qualification.Integrated_with_CRMDB__c=false;
                qualification.CRMDB__c = null;
            }
        }catch(Exception ex){
            system.debug(ex);
        }
        
    }
    //Update Annual and Total CMS CRs contract values when CR is integrated with CRMDB record
    Public static void ChangeRequestFieldUpdate(list <Qualification__c> recordListNew,Map<ID,Qualification__c> recordListOldMap){
        try{
            List<ID> oldCrmdbIDs = new List<ID>();
            List<ID> newCrmdbIDs = new List<ID>();
            if(recordListNew.size()>0 && recordListOldMap.size()>0){
                //Fectch previous and current CRMDb records when the CR is moved from Parent/Child to another Child
                for(Qualification__c quel : recordListNew){
                    if(quel.CRMDB__c!=recordListOldMap.get(quel.Id).CRMDB__c && quel.CMS_Pursuit_Type__c == 'Change Request'){
                        system.debug('@@@@@'+quel.CRMDB__c);
                        if(quel.CRMDB__c!=null){
                            newCrmdbIDs.add(quel.CRMDB__c);
                        }
                        system.debug('@@@@TEST'+recordListOldMap.get(quel.Id));
                        if(recordListOldMap.get(quel.Id).CRMDB__c!=null){
                            oldCrmdbIDs.add(recordListOldMap.get(quel.Id).CRMDB__c);
                        }
                    }
                }
            }
            //Quering previous CRMDB Records
            List<CRMDB__c> oldCrmdLst = [select id,Annual_CMS_Contract_Value_CR_S__c,Annual_Child_CMS_CR__c,Total_CMS_Contract_Value_CR_S__c,Total_Child_CMS_CR__c,Master_Customer_Name__c from CRMDB__c where id in : oldCrmdbIDs]; 
            //Quering Current CRMDB Records
            List<CRMDB__c> newCrmdLst = [select id,Annual_CMS_Contract_Value_CR_S__c,Annual_Child_CMS_CR__c,Total_CMS_Contract_Value_CR_S__c,Total_Child_CMS_CR__c,Master_Customer_Name__c from CRMDB__c where id in : newCrmdbIDs];
            List<CRMDB__c> updateOldCrmdbLst = new List<CRMDB__c>();
            List<CRMDB__c> updateNewCrmdbLst = new List<CRMDB__c>();
            //Remove CR $ value from Annual and Total fields from the previous CRMDB Records
            system.debug('oldCrmdLst'+oldCrmdLst);
            system.debug('recordListNew'+recordListNew);
            for(CRMDB__c crmdbOld : oldCrmdLst){
                for(Qualification__c qualification : recordListNew){
                    if(recordListOldMap.get(qualification.Id).CRMDB__c !=null && crmdbOld.id==recordListOldMap.get(qualification.Id).CRMDB__c){
                        crmdbOld.Annual_Child_CMS_CR__c -= recordListOldMap.get(qualification.Id).Contract_Year_1_Revenue__c;
                        crmdbOld.Total_Child_CMS_CR__c -= recordListOldMap.get(qualification.Id).Total_CMS_Booking_Value_000__c;
                    }
                }
                updateOldCrmdbLst.add(crmdbOld);
            }
            //Add CR $ value from Annual and Total fields on the current CRMDB Records
            for(CRMDB__c crmdb : newCrmdLst){
                for(Qualification__c qualification : recordListNew){
                    if(qualification.CRMDB__c!=null && crmdb.id==qualification.CRMDB__c){
                        system.debug('master'+crmdb.Master_Customer_Name__c);
                        if(crmdb.Master_Customer_Name__c==null){
                            crmdb.Annual_Child_CMS_CR__c += qualification.Contract_Year_1_Revenue__c;
                            crmdb.Annual_CMS_Contract_Value_CR_S__c += qualification.Contract_Year_1_Revenue__c;
                            crmdb.Total_Child_CMS_CR__c += qualification.Total_CMS_Booking_Value_000__c;
                            crmdb.Total_CMS_Contract_Value_CR_S__c += qualification.Total_CMS_Booking_Value_000__c;
                        }else{
                            crmdb.Annual_Child_CMS_CR__c += qualification.Contract_Year_1_Revenue__c;
                            crmdb.Total_Child_CMS_CR__c += qualification.Total_CMS_Booking_Value_000__c;
                        }
                    }
                }
                updateNewCrmdbLst.add(crmdb);
            }
            if(!updateOldCrmdbLst.isEmpty()){
                Update updateOldCrmdbLst;
            }
            if(!updateNewCrmdbLst.isEmpty()){
                Update updateNewCrmdbLst;
            }
        }catch(Exception ex){
            System.debug('@@@87'+ex.getLineNumber());
            System.debug('@@@87'+ex.getCause());
            System.debug('@@@87'+ex.getMessage());
            System.debug('@@@87'+ex.getStackTraceString());
        }
    }
}