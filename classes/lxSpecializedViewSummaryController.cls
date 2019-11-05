/*
Author          : R.Hari Krishna(ratharik)
Release         : Mar,2019
Created         : Feb 15,2019
Description     : Apex Controller for SpcializedView List Lightning Component

Modification History:
*------------------------------------------------------------------------------------
Itrack#        Date        Author                             Change  
*------------------------------------------------------------------------------------
US251583    Feb 15,2019   R.Hari Krishna(ratharik)        Initial version
US290913    May 14,2019   R.Hari Krishna(ratharik)        PSS - SW Summary View of Oppty Difference Of Opinion
US319469    June 18,2019  R.Hari krishna(ratharik)        PSS Pilot - Specialist Summary Calculation Correction
*------------------------------------------------------------------------------------
*/


public class lxSpecializedViewSummaryController {
    
    @AuraEnabled
    public static summaryWrap getSummaryViewList(Id OpptyId) {
        List<summaryViewDetails> summaryViewDetlsLst = new List<summaryViewDetails>();
        //Software Summary view
        List<softwareSummaryViewDetails> swsummaryViewDetlsLst = new List<softwareSummaryViewDetails>();
        Boolean isError = False;
        List<OpportunityLinesSV__c> opptyLinesSVList = new List<OpportunityLinesSV__c>();
        List<OpportunityLineItem> opptyLinesList = new List<OpportunityLineItem>();        
        Map<Id,OpportunityLineItem> opptyLinesIdLine = new Map<Id,OpportunityLineItem>();
        Map<Id,OpportunityLinesSV__c> opptyLinesSVMap = new Map<Id,OpportunityLinesSV__c>();
        Map<String,OpportunityLineItem> opptyLinesMap = new Map<String,OpportunityLineItem>();
        String keyStr;
        
        try {            
            // Getting the list of OpportunityLinesSV, OpportunityLineItems from Opp where Id is in OpptyId                        
            Opportunity opp = [SELECT Id,StageName,CloseDate,OwnerId,Owner.Name,CurrencyIsoCode,Enterprise_Agreement_Opportunity__c, 
            CCW_BOM_Integrated_Date__c,
                               
                               (SELECT Id,Technology_Service__c,Technology_Service__r.Name,Business_Entity__c,Product_Family__c,
                                Sub_Business_Entity__c,Expected_000_Value__c,recordtypeId,                                                     
                                Opportunity_Stage__c,Incubation_Specialist__c,Incubation_Specialist__r.Name,Expected_Book_Date__c, 
                                Architecture_Specialist__c,Architecture_Specialist__r.Name,Opportunity__r.StageName,
                                Service_Category__c,Service_Program__c,Service_Level_Tech__c,Service_Level_Description__c,Product_Code__c,
                                Software_Specialist__c,Software_Specialist__r.Name,Opportunity_Line_Item_Reference__c                                
                                FROM OpportunityLinesSV__r),                                                                                           
                               
                               (SELECT id,PriceBookEntry.ProductCode,Opportunity_Line_Value__c,Product2Id,Product2.Name,Product2.Business_Entity__c,
                                Product2.Sub_Business_Entity__c,Product_Family__c                                
                                FROM OpportunityLineItems WHERE PriceBookEntry.isactive = true )                                
                               
                               FROM Opportunity 
                               WHERE ID =:OpptyId
                              ];
            
            IF((opp.StageName).containsIgnoreCase('1')) {
                isError = True;
            }
            
            
            opptyLinesSVList = opp.OpportunityLinesSV__r;
            opptyLinesList = opp.OpportunityLineItems;
            system.debug('-----------opptyLinesList------------'+opptyLinesList);
            if(!opptyLinesList.isEmpty()) {
                for(OpportunityLineItem oppLines : opptyLinesList) {
                    opptyLinesIdLine.put(oppLines.Id,oppLines); // for the duplicate Tech/Services 
                    if(String.isNotBlank(oppLines.Product_Family__c)) {
                        keyStr = oppLines.Product2Id + oppLines.Product_Family__c;    
                    }else {
                        keyStr = oppLines.Product2Id;
                    }                    
                    opptyLinesMap.put(keyStr,oppLines);
                }
            }
            
            system.debug('-----------opptyLinesMap------------'+opptyLinesMap);
            
            //stage should be 3/4/5
            if(isError) {
                summaryViewDetails summaryViewDetls = new summaryViewDetails();
                summaryViewDetls.error = true;
                summaryViewDetls.techOrService = 'Summary view will be available after Stage 1';
                summaryViewDetlsLst.add(summaryViewDetls);
                
                //Software Summary view
                softwareSummaryViewDetails swSummaryViewDetls = new softwareSummaryViewDetails();
                //EA Oppty or not
                if(opp.Enterprise_Agreement_Opportunity__c == 'Yes') {
                    swSummaryViewDetls.isEAOppty = True;
                }else {
                    swSummaryViewDetls.isEAOppty = false;
                }
                swSummaryViewDetls.error = true;
                swSummaryViewDetls.techOrService = 'Summary view will be available after Stage 1';
                swsummaryViewDetlsLst.add(swSummaryViewDetls);
                
            }else if(opptyLinesSVList.isEmpty()) { //no Specialist lines available
                summaryViewDetails summaryViewDetls = new summaryViewDetails();
                summaryViewDetls.error = false;
                summaryViewDetls.techOrService = '';                
                summaryViewDetls.forecastStage = '';
                summaryViewDetls.expectedValueDiscrepancy ='';
                summaryViewDetls.bookDateDiscrepancy='';
                summaryViewDetls.owner='';
                summaryViewDetlsLst.add(summaryViewDetls);  
                //Software Summary view
                softwareSummaryViewDetails swSummaryViewDetls = new softwareSummaryViewDetails();
                //EA Oppty or not
                if(opp.Enterprise_Agreement_Opportunity__c == 'Yes') {
                    swSummaryViewDetls.isEAOppty = True;
                }else {
                    swSummaryViewDetls.isEAOppty = false;
                }
                swSummaryViewDetls.error = false;
                swSummaryViewDetls.techOrService = '';                
                swSummaryViewDetls.forecastStage = '';
                swSummaryViewDetls.expectedValueDiscrepancy ='';
                swSummaryViewDetls.bookDateDiscrepancy='';
                swSummaryViewDetls.owner='';
                swsummaryViewDetlsLst.add(swSummaryViewDetls);  
                
            } else {
                //Oppty Specialist Lines available
                if(!opptyLinesSVList.isEmpty()) {
                    
                    for(OpportunityLinesSV__c svDetls : opptyLinesSVList) {   
                        
                        String Owner = '';
                        Boolean isArchSpecialistAssocted = String.isNotBlank(svDetls.Architecture_Specialist__r.Name);
                        Boolean isIncubSpecialistAssocted = String.isNotBlank(svDetls.Incubation_Specialist__r.Name);
                        Boolean isSoftwareSpecialistAssocted;// = String.isNotBlank(svDetls.Software_Specialist__c);
                        
                        if(svDetls.RecordTypeId == ObjectRecordTypeIds__c.getInstance().Software_Specialist_Record_Type__c) {
                            isSoftwareSpecialistAssocted = true;
                        }else {
                            isSoftwareSpecialistAssocted = false;
                        }                        
                        
                        Integer numberOfDays = 0;
                        Decimal expectedValue = 0;
                        
                        if(String.isNotBlank(svDetls.Product_Family__c)) {
                            keyStr = svDetls.Technology_Service__c + svDetls.Product_Family__c;    
                        }else {
                            keyStr = svDetls.Technology_Service__c;
                        }
                        
                        summaryViewDetails summaryViewDetls = new summaryViewDetails();
                        
                        //Software Summary view
                        softwareSummaryViewDetails swSummaryViewDetls = new softwareSummaryViewDetails();
                        
                        if(isSoftwareSpecialistAssocted) {
                            swSummaryViewDetls.error = false;
                            //EA Oppty or not
                            if(opp.Enterprise_Agreement_Opportunity__c == 'Yes') {
                                swSummaryViewDetls.isEAOppty = True;
                            }else {
                                swSummaryViewDetls.isEAOppty = false;
                            }
                        }
                        
                        if(!isSoftwareSpecialistAssocted) { //Archi/Incubation
                            summaryViewDetls.error = false;
                        }
                        
                        if((svDetls.Product_Code__c).equalsIgnoreCase('Technology') ) {
                            
                            if(String.isBlank(svDetls.Business_Entity__c) && String.isBlank(svDetls.Sub_Business_Entity__c)) {                                
                                //Software Summary view
                                if(isSoftwareSpecialistAssocted) {
                                    swSummaryViewDetls.techOrService = svDetls.Technology_Service__r.Name;                                    
                                }else {//Archi/Incubation
                                    summaryViewDetls.techOrService = svDetls.Technology_Service__r.Name;
                                }
                                
                            }else {                                
                                //Software Summary view
                                if(isSoftwareSpecialistAssocted) { 
                                    swSummaryViewDetls.techOrService = svDetls.Business_Entity__c; 
                                }else { //Archi/Incubation
                                    summaryViewDetls.techOrService = svDetls.Business_Entity__c; 
                                }
                                
                                //assign sub BE if not null
                                if(String.isNotBlank(svDetls.Sub_Business_Entity__c)) {                                    
                                    //Software Summary view
                                    if(isSoftwareSpecialistAssocted) { 
                                        swSummaryViewDetls.techOrService +=  '-' + svDetls.Sub_Business_Entity__c;
                                    }else { //Archi/Incubation
                                        summaryViewDetls.techOrService +=  '-' + svDetls.Sub_Business_Entity__c;
                                    }
                                } 
                                //assign Prod Family if not null
                                if(String.isNotBlank(svDetls.Product_Family__c)) {                                    
                                    //Software Summary view
                                    if(isSoftwareSpecialistAssocted) { 
                                        swSummaryViewDetls.techOrService += ':'+svDetls.Product_Family__c;
                                    }else { //Archi/Incubation
                                        summaryViewDetls.techOrService += ':'+svDetls.Product_Family__c;
                                    }
                                }
                                //Software Summary view
                                if(isSoftwareSpecialistAssocted) {
                                    swSummaryViewDetls.techOrService = (swSummaryViewDetls.techOrService).removeStart('-');                                                                 
                                }else { //Archi/Incubation
                                    summaryViewDetls.techOrService = (summaryViewDetls.techOrService).removeStart('-');                                                             
                                }
                            }
                        } else {
                            if(String.isNotBlank(svDetls.Service_Category__c)) {                                
                                //Software Summary view
                                if(isSoftwareSpecialistAssocted) { 
                                    swSummaryViewDetls.techOrService = svDetls.Service_Category__c;
                                }else { //Archi/Incubation
                                    summaryViewDetls.techOrService = svDetls.Service_Category__c;
                                }
                            }
                            if(String.isNotBlank(svDetls.Service_Program__c)) {                                
                                //Software Summary view
                                if(isSoftwareSpecialistAssocted) { 
                                    swSummaryViewDetls.techOrService += '-' +svDetls.Service_Program__c;
                                }else { //Archi/Incubation
                                    summaryViewDetls.techOrService += '-' +svDetls.Service_Program__c;
                                }
                            }
                            if(String.isNotBlank(svDetls.Service_Level_Tech__c)) {                                
                                //Software Summary view
                                if(isSoftwareSpecialistAssocted) { 
                                    swSummaryViewDetls.techOrService += '-' +svDetls.Service_Level_Tech__c;
                                }else { //Archi/Incubation
                                    summaryViewDetls.techOrService += '-' +svDetls.Service_Level_Tech__c;
                                }
                            }
                            if(String.isNotBlank(svDetls.Service_Level_Description__c)) {                                
                                //Software Summary view
                                if(isSoftwareSpecialistAssocted) { 
                                    swSummaryViewDetls.techOrService += '-' +svDetls.Service_Level_Description__c;
                                } else { //Archi/Incubation
                                    summaryViewDetls.techOrService += '-' +svDetls.Service_Level_Description__c;
                                }
                            }                            
                            
                            //Software Summary view    
                            if(isSoftwareSpecialistAssocted) {   
                                if(String.isNotBlank(summaryViewDetls.techOrService)) {
                                    swSummaryViewDetls.techOrService = (summaryViewDetls.techOrService).removeStart('-');
                                    swSummaryViewDetls.techOrService = (summaryViewDetls.techOrService).removeEnd('-');                                                                
                                }                                
                            } else { //Archi/Incubation
                                if(String.isNotBlank(summaryViewDetls.techOrService)) {
                                    summaryViewDetls.techOrService = (summaryViewDetls.techOrService).removeStart('-');
                                    summaryViewDetls.techOrService = (summaryViewDetls.techOrService).removeEnd('-');                                   
                                }
                            }
                        }   
                        
                        if(String.isBlank(svDetls.Opportunity_Stage__c)) {                            
                            //Software Summary view
                            if(isSoftwareSpecialistAssocted) {                         
                                swSummaryViewDetls.forecastStage = opp.StageName;
                                swSummaryViewDetls.isStageDiscrepancy = False;  
                            }else { //Archi/Incubation
                                summaryViewDetls.forecastStage = opp.StageName;
                                summaryViewDetls.isStageDiscrepancy = False;  
                            }
                        }else {
                            if((opp.StageName).equalsIgnoreCase(svDetls.Opportunity_Stage__c)) {                                
                                //Software Summary view
                                if(isSoftwareSpecialistAssocted) {                                                          
                                    swSummaryViewDetls.isStageDiscrepancy = False;  
                                }else { //Archi/Incubation
                                    summaryViewDetls.isStageDiscrepancy = False; 
                                }
                            }else {                                
                                //Software Summary view
                                if(isSoftwareSpecialistAssocted) { 
                                    swSummaryViewDetls.isStageDiscrepancy = True;  
                                }else { //Archi/Incubation
                                    summaryViewDetls.isStageDiscrepancy = True; 
                                }
                            }                                                        
                            //Software Summary view
                            if(isSoftwareSpecialistAssocted) {                         
                                swSummaryViewDetls.forecastStage = svDetls.Opportunity_Stage__c;
                            }else { //Archi/Incubation
                                summaryViewDetls.forecastStage = svDetls.Opportunity_Stage__c;
                            }
                        }
                        //logical assignment of Owner
                        //Software Summary view
                        if(isSoftwareSpecialistAssocted) {                         
                            swSummaryViewDetls.owner = svDetls.Software_Specialist__r.Name;
                        }else { //Archi/Incubation  
                            if( isArchSpecialistAssocted &&  isIncubSpecialistAssocted) {
                                Owner = svDetls.Architecture_Specialist__r.Name + ' / '+ svDetls.Incubation_Specialist__r.Name;
                            } else if(isArchSpecialistAssocted) {
                                Owner = svDetls.Architecture_Specialist__r.Name;
                            } else if(isIncubSpecialistAssocted) {
                                Owner = svDetls.Incubation_Specialist__r.Name;
                            }
                            summaryViewDetls.owner = Owner;                            
                        }
                        //Logic to check Book Date Discrepancy
                        if(opp.CloseDate < svDetls.Expected_Book_Date__c) {
                            numberOfDays = (opp.CloseDate).daysBetween(svDetls.Expected_Book_Date__c);                            
                            //Software Summary view
                            if(isSoftwareSpecialistAssocted) {                         
                                swSummaryViewDetls.bookDateDiscrepancy = 'Pushed out '+ numberOfDays +' days '+ String.valueOf(svDetls.Expected_Book_Date__c);  
                                swSummaryViewDetls.isDateDiscrepancy = True;
                            } else { //Archi/Incubation  
                                summaryViewDetls.bookDateDiscrepancy = 'Pushed out '+ numberOfDays +' days '+ String.valueOf(svDetls.Expected_Book_Date__c);  
                                summaryViewDetls.isDateDiscrepancy = True;
                            }
                        }else if(opp.CloseDate > svDetls.Expected_Book_Date__c) {
                            numberOfDays = (svDetls.Expected_Book_Date__c).daysBetween(opp.CloseDate);                            
                            //Software Summary view
                            if(isSoftwareSpecialistAssocted) {                         
                                swSummaryViewDetls.bookDateDiscrepancy = 'Pulled in '+ numberOfDays +' days '+ String.valueOf(svDetls.Expected_Book_Date__c);                        
                                swSummaryViewDetls.isDateDiscrepancy = True;
                            } else { //Archi/Incubation  
                                summaryViewDetls.bookDateDiscrepancy = 'Pulled in '+ numberOfDays +' days '+ String.valueOf(svDetls.Expected_Book_Date__c);                        
                                summaryViewDetls.isDateDiscrepancy = True;
                            }
                        }else { // no Discrepancy
                            
                            //Software Summary view
                            if(isSoftwareSpecialistAssocted) {              
                                swSummaryViewDetls.bookDateDiscrepancy = String.valueOf(opp.CloseDate);   
                                swSummaryViewDetls.isDateDiscrepancy = False; 
                            } else { //Archi/Incubation  
                                summaryViewDetls.bookDateDiscrepancy = String.valueOf(opp.CloseDate);   
                                summaryViewDetls.isDateDiscrepancy = False; 
                            }
                        }
                        
                        
                        //Existed Lines for Opp
                        if((!opptyLinesIdLine.isEmpty() || !opptyLinesMap.isEmpty())) {
                            Decimal opptyLineValue = 0.00;
                            //Logic to get accurate Opportunity Line and it's values when we have duplicate Tech/Service : US319469
                            //check whether Opportunity_Line_Item_Reference__c value existed or not,otherwise Opportunity Line Value is Zero for AM
                            if(String.isNotBlank(svDetls.Opportunity_Line_Item_Reference__c) && opptyLinesIdLine.containsKey(svDetls.Opportunity_Line_Item_Reference__c)) {
                                opptyLineValue = opptyLinesIdLine.get(svDetls.Opportunity_Line_Item_Reference__c).Opportunity_Line_Value__c;
                            }else if(opptyLinesMap.containsKey(keyStr)) {
                                opptyLineValue = opptyLinesMap.get(keyStr).Opportunity_Line_Value__c;
                            }else {
                                opptyLineValue = 0.00;
                            }                        
                            
                            if(opptyLineValue != null && svDetls.Expected_000_Value__c !=null) {
                                //Logic to check Expected Value Discrepancy.
                                if(opptyLineValue < svDetls.Expected_000_Value__c) {
                                    expectedValue = svDetls.Expected_000_Value__c - opptyLineValue;                                         
                                    //Software Summary view
                                    if(isSoftwareSpecialistAssocted) {              
                                        swSummaryViewDetls.expectedValueDiscrepancy = opp.CurrencyIsoCode+' +'+String.valueOf(expectedValue.setScale(2));
                                        swSummaryViewDetls.isValueDiscrepancy = True;
                                    }else { //Archi/Incubation  
                                        summaryViewDetls.expectedValueDiscrepancy = opp.CurrencyIsoCode+' +'+String.valueOf(expectedValue.setScale(2));
                                        summaryViewDetls.isValueDiscrepancy = True;
                                    }
                                }else if(opptyLineValue > svDetls.Expected_000_Value__c) {                                
                                    expectedValue = opptyLineValue - svDetls.Expected_000_Value__c;                                         
                                    //Software Summary view
                                    if(isSoftwareSpecialistAssocted) {              
                                        swSummaryViewDetls.expectedValueDiscrepancy = opp.CurrencyIsoCode+' -'+String.valueOf(expectedValue.setScale(2));
                                        swSummaryViewDetls.isValueDiscrepancy = True;
                                    } else { //Archi/Incubation  
                                        summaryViewDetls.expectedValueDiscrepancy = opp.CurrencyIsoCode+' -'+String.valueOf(expectedValue.setScale(2));//.round(System.RoundingMode.CEILING); 
                                        summaryViewDetls.isValueDiscrepancy = True;
                                    }
                                }else { // No Discrepancy                                    
                                    //Software Summary view
                                    if(isSoftwareSpecialistAssocted) {                                                  
                                        swSummaryViewDetls.expectedValueDiscrepancy = '';
                                        swSummaryViewDetls.isValueDiscrepancy = False; 
                                    }else {  //Archi/Incubation  
                                        summaryViewDetls.expectedValueDiscrepancy = '';
                                        summaryViewDetls.isValueDiscrepancy = False; 
                                    }
                                } 
                            }else {
                                //Specialist didn't add value default to Oppty Line Value if not null 
                                if(svDetls.Expected_000_Value__c == null && opptyLineValue != null) {                                     
                                    //Software Summary view
                                    if(isSoftwareSpecialistAssocted) {              
                                        swSummaryViewDetls.expectedValueDiscrepancy = opp.CurrencyIsoCode+' 0.00';//opp.CurrencyIsoCode+' '+String.valueOf((opptyLineValue).setScale(2));
                                        swSummaryViewDetls.isValueDiscrepancy = false;  
                                    }else { //Archi/Incubation  
                                        summaryViewDetls.expectedValueDiscrepancy = opp.CurrencyIsoCode+' 0.00';//opp.CurrencyIsoCode+' '+String.valueOf((opptyLineValue).setScale(2));
                                        summaryViewDetls.isValueDiscrepancy = false;    
                                    }
                                }else {                                     
                                    //Software Summary view
                                    if(isSoftwareSpecialistAssocted) {              
                                        swSummaryViewDetls.expectedValueDiscrepancy = opp.CurrencyIsoCode+' 0.00';
                                        swSummaryViewDetls.isValueDiscrepancy = True;   
                                    }else { //Archi/Incubation  
                                        summaryViewDetls.expectedValueDiscrepancy = opp.CurrencyIsoCode+' 0.00';
                                        summaryViewDetls.isValueDiscrepancy = True;                                
                                    }
                                }
                                
                            }                            
                        }else { //new Lines added by Specialist                            
                            if(svDetls.Expected_000_Value__c != null) {                                
                                //Software Summary view
                                if(isSoftwareSpecialistAssocted) {              
                                    swSummaryViewDetls.expectedValueDiscrepancy = opp.CurrencyIsoCode+' '+ String.valueOf(svDetls.Expected_000_Value__c.setScale(2));
                                } else { //Archi/Incubation  
                                    summaryViewDetls.expectedValueDiscrepancy = opp.CurrencyIsoCode+' '+ String.valueOf(svDetls.Expected_000_Value__c.setScale(2));
                                }
                            }else {                                
                                //Software Summary view
                                if(isSoftwareSpecialistAssocted) {              
                                    swSummaryViewDetls.expectedValueDiscrepancy = opp.CurrencyIsoCode+' 0.00';
                                } else { //Archi/Incubation  
                                    summaryViewDetls.expectedValueDiscrepancy = opp.CurrencyIsoCode+' 0.00'; 
                                }
                            }                                                        
                            //Software Summary view
                            if(isSoftwareSpecialistAssocted) {              
                                swSummaryViewDetls.isValueDiscrepancy = True;  
                            }else { //Archi/Incubation  
                                summaryViewDetls.isValueDiscrepancy = True;  
                            }
                        }
                        if(isSoftwareSpecialistAssocted) {              
                            swSummaryViewDetlsLst.add(swSummaryViewDetls);  
                        }else { //Archi/Incubation  
                            summaryViewDetlsLst.add(summaryViewDetls);      
                        }
                    }            
                } 
            } 
            //if swSummaryViewDetlsLst blank
            if(summaryViewDetlsLst.isEmpty() && summaryViewDetlsLst.size() == 0) {
                summaryViewDetails summaryViewDetls = new summaryViewDetails();
                summaryViewDetls.error = false;
                summaryViewDetls.techOrService = '';                
                summaryViewDetls.forecastStage = '';
                summaryViewDetls.expectedValueDiscrepancy ='';
                summaryViewDetls.bookDateDiscrepancy='';
                summaryViewDetls.owner='';
                summaryViewDetlsLst.add(summaryViewDetls);  
            }
            
            //if swSummaryViewDetlsLst blank
            if(swSummaryViewDetlsLst.isEmpty() && swSummaryViewDetlsLst.size() == 0) {
                softwareSummaryViewDetails swSummaryViewDetls = new softwareSummaryViewDetails();
                //EA Oppty or not
                if(opp.Enterprise_Agreement_Opportunity__c == 'Yes') {
                    swSummaryViewDetls.isEAOppty = True;
                }else {
                    swSummaryViewDetls.isEAOppty = false;
                }
                swSummaryViewDetls.error = false;
                swSummaryViewDetls.techOrService = '';                
                swSummaryViewDetls.forecastStage = '';
                swSummaryViewDetls.expectedValueDiscrepancy ='';
                swSummaryViewDetls.bookDateDiscrepancy='';
                swSummaryViewDetls.owner='';
                swSummaryViewDetlsLst.add(swSummaryViewDetls);  
            }
        }catch(Exception e) {
            system.debug('----------Exception --------'+e.getLineNumber()+'@@'+e.getCause()+'@@@'+e.getMessage()+'@@@@'+e.getStackTraceString());
        }
        
        system.debug('-----summaryViewDetlsLst---------'+summaryViewDetlsLst);
        system.debug('-----swSummaryViewDetlsLst---------'+swSummaryViewDetlsLst);
        
        summaryWrap sumryWrap = new summaryWrap();
        sumryWrap.specialistDtls = summaryViewDetlsLst;
        sumryWrap.swSpecialistDtls = swSummaryViewDetlsLst;
        // Returning the Summary details
        return sumryWrap;
    }
    
    
    /***************
* @Author : R.Hari Krishna(ratharik)
* @Description : Wrapper class to hold summarized View Details
*****************************/
    public class summaryViewDetails {
        @AuraEnabled
        public String techOrService{get;set;}       
        @AuraEnabled
        public String expectedValueDiscrepancy{get;set;}
        @AuraEnabled
        public String bookDateDiscrepancy{get;set;}
        @AuraEnabled
        public String forecastStage{get;set;}
        @AuraEnabled
        public String owner{get;set;}
        @AuraEnabled
        public Boolean isValueDiscrepancy{get;set;}
        @AuraEnabled
        public Boolean isDateDiscrepancy{get;set;}
        @AuraEnabled
        public Boolean isStageDiscrepancy{get;set;}
        @AuraEnabled
        public Boolean error{get;set;}        
    }
    
    
    /***************
* @Author : R.Hari Krishna(ratharik)
* @Description : Wrapper class to hold Software summarized View Details
*****************************/
    public class softwareSummaryViewDetails {
        @AuraEnabled
        public String techOrService{get;set;}        
        @AuraEnabled
        public String expectedValueDiscrepancy{get;set;}
        @AuraEnabled
        public String bookDateDiscrepancy{get;set;}
        @AuraEnabled
        public String forecastStage{get;set;}
        @AuraEnabled
        public String owner{get;set;}
        @AuraEnabled
        public Boolean isValueDiscrepancy{get;set;}
        @AuraEnabled
        public Boolean isDateDiscrepancy{get;set;}
        @AuraEnabled
        public Boolean isStageDiscrepancy{get;set;}
        @AuraEnabled
        public Boolean error{get;set;}
        @AuraEnabled
        public Boolean isEAOppty{get;set;}        
    }
    
    /***************
* @Author : R.Hari Krishna(ratharik)
* @Description : Wrapper class to hold both Software & Specialist Summary details
*****************************/
    public class summaryWrap {
        @AuraEnabled
        public List<summaryViewDetails> specialistDtls{get;set;}        
        @AuraEnabled
        public List<softwareSummaryViewDetails> swSpecialistDtls{get;set;}
    }
    @AuraEnabled
    public static void deleteRecords(){
        List<OpportunityLinesSV__c> opptySV =[Select id,Software_Specialist__c,Incubation_Specialist__c,Architecture_Specialist__c from OpportunityLinesSV__c WHERE Software_Specialist__c=null and Incubation_Specialist__c= null and Architecture_Specialist__c =null];
        if(opptySV.size()>0){
            delete opptySV;
        }
    }
    
   // Method for checking the EA opportunity   
    @AuraEnabled
    public static string checkEAOppty(String recId){
        Opportunity  eaAccess = [ SELECT id, Enterprise_Agreement_Opportunity__c FROM Opportunity WHERE id =:recId limit 1];
        return eaAccess.Enterprise_Agreement_Opportunity__c;
    }
}