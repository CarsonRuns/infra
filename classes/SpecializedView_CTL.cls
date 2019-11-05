/*
Author          : Awnish Kumar
Release         : PSS MVP March 29, 2019 Release
Created         : Feb 11, 2019
Functionality   : Specialist View Controller


Modification History:
Itrack#        Date        Author              Change 
US291448       2/5/2019    Kavya M          PSS - Quote Overwrite Specialist View   
US307507       5/3/2019    Awnish K.        Add Product Family Lookup on the Specialist View
US319469:      Jun 23,2019 R.Hari Krishna    PSS Pilot - Specialist Summary Calculation Correction
*/
public class SpecializedView_CTL {
    
    //Fetching Opportunity and Tech/Service Lines
    @AuraEnabled
    public static Opportunity getOpportunityDetails(String optyId){
        Opportunity opty = [select id,CurrencyIsoCode,name,Account.name,DealID__c,Forecast_Status__c,closedate, Expected_Product__c, Expected_Service__c,StageName,
                            (select id,Service_Level__c,Service_Level_Ref__c,Service_Level_Ref__r.Name,Service_Category__c,Product2.Service_Program__c,Opportunity_Line_Value__c,Product2.Business_Entity__c,Product2.Sub_Business_Entity__c,PriceBookEntry.ProductCode,Product_Family__c,Product_Family_Ref__c from OpportunityLineItems where PriceBookEntry.isactive = true order by PriceBookEntry.ProductCode,Product2.name desc) 
                            from opportunity where id=:optyId limit 1];
        return opty;
    }
    
    //Fetching Specialist lines based on opportunity ID
    @AuraEnabled
    public static List<OpportunityLinesSV__c> getSpecializedLines(String optyId){
        List<OpportunityLinesSV__c> specialistLines = [select id,RecordType.Name,Business_Entity__c,Sub_Business_Entity__c,Product_Family__c,Expected_000_Value__c,Service_Category__c,Service_Program__c,Service_Level_Tech__c,Service_Level_Description__c,Expected_Book_Date__c,Opportunity_Stage__c,Architecture_Specialist__c,Software_Specialist__c,Software_Specialist__r.name,Architecture_Specialist__r.name,Incubation_Specialist__c,Incubation_Specialist__r.name,Product_Code__c,Opportunity_Line_Item_Reference__c from OpportunityLinesSV__c where Opportunity__c=: optyId order by Technology_Service__r.name asc];
        List<OpportunityLineItem> optyLineItems = [select id,Service_Level__c,Service_Level_Ref__c,Service_Level_Ref__r.Name,Service_Category__c,Product2.Service_Program__c,Opportunity_Line_Value__c,Product2.Business_Entity__c,Product2.Sub_Business_Entity__c,PriceBookEntry.ProductCode,Product_Family__c from OpportunityLineItem where OpportunityId =: optyId];
        for(OpportunityLinesSV__c specialistLine : specialistLines){
            if(specialistLine.Expected_000_Value__c == null){
                for(OpportunityLineItem optyLineItem : optyLineItems){
                    if(specialistLine.Product_Code__c== 'Technology' && optyLineItem.PriceBookEntry.ProductCode == 'Technology' && specialistLine.Business_Entity__c == optyLineItem.Product2.Business_Entity__c && specialistLine.Sub_Business_Entity__c == optyLineItem.Product2.Sub_Business_Entity__c && specialistLine.Product_Family__c == optyLineItem.Product_Family__c){
                        if(specialistLine.Expected_000_Value__c == null){
                            specialistLine.Expected_000_Value__c = optyLineItem.Opportunity_Line_Value__c;
                        }else{
                            specialistLine.Expected_000_Value__c = specialistLine.Expected_000_Value__c + optyLineItem.Opportunity_Line_Value__c;
                        }
                    }
                    if(specialistLine.Product_Code__c== 'Service' && optyLineItem.PriceBookEntry.ProductCode == 'Service' && specialistLine.Service_Category__c == optyLineItem.Service_Category__c && specialistLine.Service_Program__c == optyLineItem.Product2.Service_Program__c && specialistLine.Service_Level_Tech__c == optyLineItem.Service_Level_Ref__r.Name && specialistLine.Service_Level_Description__c == optyLineItem.Service_Level__c){
                        if(specialistLine.Expected_000_Value__c == null){
                            specialistLine.Expected_000_Value__c = optyLineItem.Opportunity_Line_Value__c;
                        }else{
                            specialistLine.Expected_000_Value__c = specialistLine.Expected_000_Value__c + optyLineItem.Opportunity_Line_Value__c;
                        }
                    }
                    
                }
            }
        }
        return specialistLines;
    }
    
     //Insert/Update Specialist Lines when the Opportunity Lines are copied 
    @AuraEnabled
    public static Map<String,List<String>> saveSpecializedLine(String optyId, String optyLineItems){
        Map<String,List<String>> specialistLinesResultMap = new Map<String,List<String>>();
        try{
            List<String> existingSpecializedLines= new List<String>();
            List<String> newSpecializedLines= new List<String>();
            SpecialistViewJSON spjson = SpecialistViewJSON.parse(optyLineItems);
            String role = spjson.role;            
            List<OpportunityLinesSV__c> existingLineItems = [select id,Opportunity_Line_Item_Reference__c,Technology_Service__c,
                                                             Product_Family__c,Service_Category__c,Service_Level__c,RecordTypeId,RecordType.Name,
                                                             Service_Level_Description__c,Product_Code__c,Architecture_Specialist__c,
                                                             Incubation_Specialist__c,Software_Specialist__c 
                                                             from OpportunityLinesSV__c 
                                                             where Opportunity__c=: optyId ];
            List<SpecialistViewJSON.LineItems> lineItems = spjson.lineItems;
            List<OpportunityLinesSV__c> specialistLines = new List<OpportunityLinesSV__c>();
            //US319469: Inseted of Upsert use Insert and Update separately added by R.Hari Krishna
            List<OpportunityLinesSV__c> specialistLinesToUpdte = new List<OpportunityLinesSV__c>();
            Set<Id> existedLinesOpptyLineRefSet = new Set<Id>(); 
            //allow specialist to add same line to Architecture/Incubation and Software 
            //check existed recs OpptyRef Id and it's recordtype so that allow specialist to add same to other recordType
            Map<Id,List<String>> existdSpslstLinesRefndRecTypeMap = new Map<Id,List<String>>();            
            for(OpportunityLinesSV__c speilitLine : existingLineItems) {
                String recTypeNamendRecId = speilitLine.RecordType.Name+','+ speilitLine.Id;
                existedLinesOpptyLineRefSet.add(speilitLine.Opportunity_Line_Item_Reference__c);
                if(existdSpslstLinesRefndRecTypeMap.containsKey(speilitLine.Opportunity_Line_Item_Reference__c)) {
                    List<String> temp = existdSpslstLinesRefndRecTypeMap.get(speilitLine.Opportunity_Line_Item_Reference__c);                    
                    temp.add(recTypeNamendRecId);
                    existdSpslstLinesRefndRecTypeMap.put(speilitLine.Opportunity_Line_Item_Reference__c,temp);
                }else {                    
                    existdSpslstLinesRefndRecTypeMap.put(speilitLine.Opportunity_Line_Item_Reference__c,new List<String>{recTypeNamendRecId});
                }
            }
            system.debug('-------lineItems-------'+lineItems);
            for(SpecialistViewJSON.LineItems LineItem:lineItems){
                if(checkSpecialistExistingLines(role,LineItem,existingLineItems)==null){                      
                    OpportunityLinesSV__c  specialistLine = new OpportunityLinesSV__c();                     
                    if(role=='archspecialist'){
                        specialistLine.Architecture_Specialist__c = UserInfo.getUserId();
                        specialistLine.RecordTypeId = ObjectRecordTypeIds__c.getInstance().Architecture_Specialist_Record_Type__c;
                    }else if(role=='incubationspecialist'){
                        specialistLine.Incubation_Specialist__c = UserInfo.getUserId();
                        specialistLine.RecordTypeId = ObjectRecordTypeIds__c.getInstance().Architecture_Specialist_Record_Type__c;
                    }else if(role=='softwarespecialist'){
                         system.debug('in if software'+specialistLine);
                        specialistLine.Software_Specialist__c = UserInfo.getUserId();
                        specialistLine.RecordTypeId = ObjectRecordTypeIds__c.getInstance().Software_Specialist_Record_Type__c;
                    }
                    specialistLine.Product_Code__c = LineItem.category;
                    specialistLine.Opportunity__c = optyId;
                    specialistLine.Opportunity_Line_Item_Reference__c = LineItem.id;
                    if(LineItem.category=='Technology'){
                        specialistLine.Technology_Service__c = LineItem.besubbe;
                        specialistLine.Product_Family__c = LineItem.productfamily;
                        //Populate Product Family Lookup Field - US307507
                        specialistLine.Product_Family_Ref__c = LineItem.productfamilyref;
                        if(LineItem.expectedProductvalue!=null){
                            specialistLine.Expected_000_Value__c = LineItem.expectedProductvalue;
                        }
                    }else{
                        specialistLine.Service_Category__c = LineItem.cat;
                        specialistLine.Technology_Service__c = LineItem.serviceprogram;
                        specialistLine.Service_Level__c = LineItem.serviceleveltech;
                        specialistLine.Service_Level_Description__c = LineItem.servicedesc;
                        if(LineItem.expectedServicevalue!=null){
                            specialistLine.Expected_000_Value__c = LineItem.expectedServicevalue;
                        }
                    }
                    if( LineItem.bookdate != null){
                        specialistLine.Expected_Book_Date__c = LineItem.bookdate;
                    }if(LineItem.stage!=null && LineItem.stage!=''){
                        specialistLine.Opportunity_Stage__c = LineItem.stage;                       
                    }
                    Boolean isNewLine = true;
                    if(existdSpslstLinesRefndRecTypeMap.containsKey(LineItem.Id)) {  
                        List<String> recTypeNamendRecIdLst = existdSpslstLinesRefndRecTypeMap.get(LineItem.Id);
                        for(String tempRecTypeNamendRecId : recTypeNamendRecIdLst) {
                            List<String> tempSplitVals = tempRecTypeNamendRecId.split(',');
                            String recTypeName = tempSplitVals[0];
                            String recId =  tempSplitVals[1];   
                            if(recTypeName.contains('Architecture') && 
                               	(role.equalsIgnoreCase('archspecialist') || role.equalsIgnoreCase('incubationspecialist'))) {
                                isNewLine = false;
                                specialistLine.Id = recId;    
                                break;
                            }else if(recTypeName.contains('Software') && role.equalsIgnoreCase('softwarespecialist')) {
                                isNewLine = false;
                                specialistLine.Id = recId;
                                break;
                            }else {
                                isNewLine = true;
                            }
                        }
                    }
                    
                    /*if(existedLinesOpptyLineRefSet.contains(LineItem.Id)) {
                        specialistLinesToUpdte.add(specialistLine);
                    }else {
                    	specialistLines.add(specialistLine);    
                    } */
                    
                    if(isNewLine == false) { // specific to lines which have oppty Ref Id
                        specialistLinesToUpdte.add(specialistLine);
                    }else if(isNewLine) { // specific to lines which have oppty Ref Id
                    	specialistLines.add(specialistLine);    
                    }else {
                        specialistLines.add(specialistLine);    
                    } 
                    
                    newSpecializedLines.add(LineItem.techservice);
                }else{
                   
                    OpportunityLinesSV__c specialistLine = checkSpecialistExistingLines(role,LineItem,existingLineItems);                    
                     system.debug('------specialistLine------'+specialistLine);
                    for(OpportunityLinesSV__c existingSpecialistLine : specialistLines){
                        if(existingSpecialistLine.Id== specialistLine.Id){
                            List<String> errors = new List<String>();
                            errors.add('Duplicate lines exists in the current selection, please remove duplicates and try again.');
                            specialistLinesResultMap.put('DuplicateLins',errors);
                            return specialistLinesResultMap;
                        }
                    }
                    if(LineItem.category=='Technology'){
                        if(LineItem.expectedProductvalue!=null){
                            specialistLine.Expected_000_Value__c = LineItem.expectedProductvalue;
                        }
                    }else{
                        if(LineItem.expectedServicevalue!=null){
                            specialistLine.Expected_000_Value__c = LineItem.expectedServicevalue;
                        }
                    }
                    if(role=='archspecialist'){
                        specialistLine.Architecture_Specialist__c = UserInfo.getUserId();
                        if(specialistLine.Incubation_Specialist__c == UserInfo.getUserId()){
                            specialistLine.Incubation_Specialist__c=null;
                        }
                    }else if(role=='incubationspecialist'){
                        specialistLine.Incubation_Specialist__c = UserInfo.getUserId();
                        if(specialistLine.Architecture_Specialist__c == UserInfo.getUserId()){
                            specialistLine.Architecture_Specialist__c=null;
                        }
                    }                        
                    
                    if( LineItem.bookdate != null){
                        specialistLine.Expected_Book_Date__c = LineItem.bookdate;
                    }
                    if(LineItem.stage!=null && LineItem.stage!=''){
                        specialistLine.Opportunity_Stage__c = LineItem.stage;                       
                    }         
                    //Existed line so need to update
                    specialistLinesToUpdte.add(specialistLine);
                    newSpecializedLines.add(LineItem.techservice);
                }
            }
            
            system.debug('------specialistLines------'+specialistLines);
            system.debug('------specialistLinesToUpdte------'+specialistLinesToUpdte);
            
            if(!specialistLines.isEmpty()) {
            	insert specialistLines;    
            }
            if(!specialistLinesToUpdte.isEmpty()) {
            	update specialistLinesToUpdte;
            }
            
            specialistLinesResultMap.put('New',newSpecializedLines);
            specialistLinesResultMap.put('Existing',existingSpecializedLines);
        }catch(Exception ex){
            List<String> errors = new List<String>();
            system.debug(ex.getStackTraceString());
            errors.add('Expected Product/Service ($000s): value outside of valid range on numeric field.');
            specialistLinesResultMap.put('Error',errors);
        }
        return specialistLinesResultMap;
        
    }
    
    
    //Logic to check if the Specialist Lines already exists for the Opportunity
    public static OpportunityLinesSV__c checkSpecialistExistingLines(String role,SpecialistViewJSON.LineItems LineItem, List<OpportunityLinesSV__c> specialistLineItems){
        for(OpportunityLinesSV__c specilizedLineItem : specialistLineItems){
            String specialistID = '';
            String swspecialistID ='';
            Boolean softwareSpecialist= false;
            Boolean hasOpptyLineRef = false;
            if(role=='archspecialist'){
                specialistID = specilizedLineItem.Architecture_Specialist__c;
            }else if(role=='incubationspecialist'){
                specialistID = specilizedLineItem.Incubation_Specialist__c;
            }else if(role == 'softwarespecialist'){
                swspecialistID = specilizedLineItem.Software_Specialist__c;
            }
            if(String.isNotEmpty(specilizedLineItem.Software_Specialist__c)){
                softwareSpecialist = false;
            }else{
                 softwareSpecialist = true;
            }
			system.debug('---------specilizedLineItem.Opportunity_Line_Item_Reference__c------'+specilizedLineItem.Opportunity_Line_Item_Reference__c);            
            system.debug('---------LineItem.id------'+LineItem.id);            
            //Logic to check copied lines Opportunity Line Item Reference Id : US319469
            if(String.isNotBlank(specilizedLineItem.Opportunity_Line_Item_Reference__c) 
               &&  (LineItem.id).equalsIgnoreCase(specilizedLineItem.Opportunity_Line_Item_Reference__c)) {
            	hasOpptyLineRef = true;    
            }else {
                hasOpptyLineRef = false;
            }
            
            if(LineItem.category=='Technology'){
                if(LineItem.besubbe == specilizedLineItem.Technology_Service__c 
                   && LineItem.productfamily == specilizedLineItem.Product_Family__c && hasOpptyLineRef
                   && (
                       (swspecialistID=='' && softwareSpecialist && (specialistID == UserInfo.getUserId() || specialistID==null || specialistID=='')) 
                       || (specialistID =='' && swspecialistID ==  UserInfo.getUserId()))){
                       
                    return specilizedLineItem;
                }
            }else{
                if(LineItem.cat==specilizedLineItem.Service_Category__c 
                   && LineItem.serviceprogram == specilizedLineItem.Technology_Service__c 
                   && LineItem.serviceleveltech ==specilizedLineItem.Service_Level__c && hasOpptyLineRef
                   && LineItem.servicedesc==specilizedLineItem.Service_Level_Description__c 
                   && ((swspecialistID=='' && softwareSpecialist && (specialistID == UserInfo.getUserId() || specialistID==null || specialistID=='')) 
                       || (specialistID =='' && swspecialistID ==  UserInfo.getUserId()))){
                    return specilizedLineItem;
                }
            }
        }
        return null;
    }
    
    //Delete Specialist lines based on access control
    @AuraEnabled
    public static String deleteSpecializedLine(String recId){
        OpportunityLinesSV__c specializedLine  = [select id,Architecture_Specialist__c,Software_Specialist__c,Incubation_Specialist__c from OpportunityLinesSV__c where id=:recId limit 1];
        if(UserInfo.getUserId()==specializedLine.Architecture_Specialist__c || UserInfo.getUserId()==specializedLine.Incubation_Specialist__c || UserInfo.getUserId()==specializedLine.Software_Specialist__c){
            delete specializedLine;
            return 'Success';
        }else{
            return 'Failure';
        }
    }
    
    //Fetch All Technologies from Product2 Object
    @AuraEnabled
    public static Map<String,String> getTechnologyLines(){
        Map<String,String> techLines  = new Map<String,String>();
        List<product2> products = [select id,name,(select id,Product_Family_Description__c from Product_Families__r where Searchable__c = 'Yes' order by Product_Family_Description__c  asc) from product2 where ProductCode = 'Technology' and searchable__c = 'Yes'];
        //Changed Logic to Pull Product Family ID & Description from Product Family Object - US307507
        for(product2 product : products){
            for(Product_Family__c productFamily : product.Product_Families__r){
                techLines.put(product.id+'|'+productFamily.Product_Family_Description__c+'|'+productFamily.Id,product.Name+':'+productFamily.Product_Family_Description__c);
            }
        }
        return techLines;
    }
    
    //Fetch All Services from Product2 Object
    @AuraEnabled
    public static Map<String,String> getServiceLines(String searchString){
        Map<String,String> serviceLinesMap  = new Map<String,String>();
        List<product2> serviceLines  = [select id,name,Service_Category__c,Service_Program__c,(select id,name from Service_Levels__r),SERVICE_LEVEL_1__c from product2 where ProductCode = 'Service' and searchable__c = 'Yes'];
        for(product2 serviceLine : serviceLines){
            List<String> serviceLevelsDesc = serviceLine.SERVICE_LEVEL_1__c.split(';');
            for(String serviceLevelDesc : serviceLevelsDesc){
                for(Service_Level__c serviceLevel : serviceLine.Service_Levels__r){
                    String serviceLabel = serviceLine.Service_Category__c+ '-'+ serviceLine.Service_Program__c+'-'+ serviceLevel.name+'-'+serviceLevelDesc;
                    String serviveId = serviceLine.id+'|'+serviceLine.Service_Category__c+ '|'+ serviceLine.Service_Program__c+ '|'+ serviceLevel.id+'|'+serviceLevelDesc;
                    if(serviceLabel.toUpperCase().contains(searchString.toUpperCase())){
                        serviceLinesMap.put(serviveId,serviceLabel);
                        if(serviceLinesMap.size()==50){
                            return serviceLinesMap;
                        }
                    }
                }
                
            }
        }
        return serviceLinesMap;
    }
    //Create new specialist line when user adds new Technology
    @AuraEnabled
    public static String saveSpecializedViewTech(String optyID, String role, String tech, Decimal techDollarValue, String expectedBookDate, String expectedStage){
        try{
            List<String> techLine = tech.split('\\|');
            String techService = '';
            String productFamily = '';
            //Populate Product Family Lookup Field - US307507
            String productFamilyRef = '';
            Date bookDate = null;
            if(expectedBookDate!=''){
                bookDate = date.valueOf(expectedBookDate);
            }
            if(!techLine.isEmpty()){
                techService = techLine[0];
                productFamily = techLine[1];
                //Populate Product Family Lookup Field - US307507
                productFamilyRef = techLine[2];
            }
            List<OpportunityLinesSV__c> lineItems = new List<OpportunityLinesSV__c>();
            List<OpportunityLinesSV__c> existingLineItems  = new List<OpportunityLinesSV__c>();
            List<OpportunityLinesSV__c> specialistLineItems = new List<OpportunityLinesSV__c>();
            if(role=='Software Specialist'){
                existingLineItems  = [select id,RecordTypeId,Software_Specialist__c,Expected_000_Value__c, Expected_Book_Date__c, Opportunity_Stage__c
                                      from OpportunityLinesSV__c where Opportunity__c=: optyId and Technology_Service__c =: techService
                                      and Product_Family__c =: productFamily and Product_Code__c=:'Technology' and RecordTypeId = : ObjectRecordTypeIds__c.getInstance().Software_Specialist_Record_Type__c];
            }else{
                existingLineItems  = [select id, Architecture_Specialist__c,RecordTypeId,Incubation_Specialist__c,Expected_000_Value__c, Expected_Book_Date__c, Opportunity_Stage__c
                                      from OpportunityLinesSV__c where Opportunity__c=: optyId and Technology_Service__c =: techService   
                                      and Product_Family__c =: productFamily and Product_Code__c=:'Technology' and RecordTypeId = : ObjectRecordTypeIds__c.getInstance().Architecture_Specialist_Record_Type__c ];
            }
            //Logic to check whether the current user is part of the selected line item
            if(existingLineItems.size()==0){
                lineItems  = [select id,Incubation_Specialist__c,Architecture_Specialist__c,Software_Specialist__c,Expected_000_Value__c, Expected_Book_Date__c, Opportunity_Stage__c
                              from OpportunityLinesSV__c where Opportunity__c=: optyId and Technology_Service__c =: techService
                              and Product_Family__c =: productFamily and Product_Code__c=:'Technology'];
                if(lineItems.size()>0){
                    for(OpportunityLinesSV__c LineItem : lineItems){
                        if(role=='Software Specialist'){
                            if( lineItem.Architecture_Specialist__c==UserInfo.getUserId() || lineItem.Incubation_Specialist__c==UserInfo.getUserId()){
                                return 'sferror';
                            }
                        }else{
                            if(lineItem.Software_Specialist__c==UserInfo.getUserId()){
                                return 'inArcherror';
                            }
                        }
                    }
                }  
            }
            
            //Check for Line with existing assignment
            for(OpportunityLinesSV__c existingLineItem : existingLineItems){
                if(role=='Architecture Specialist' && (existingLineItem.Architecture_Specialist__c == UserInfo.getUserId())){
                    return 'Error';
                }else if(role=='Incubation Specialist' && (existingLineItem.Incubation_Specialist__c == UserInfo.getUserId())){
                    return 'Error';
                }
                else if(role=='Software Specialist' && (existingLineItem.Software_Specialist__c == UserInfo.getUserId())){
                    return 'Error';
                }
                else if(role=='Architecture Specialist' && existingLineItem.Architecture_Specialist__c == null){
                    if(existingLineItem.Incubation_Specialist__c == UserInfo.getUserId()){
                        existingLineItem.Incubation_Specialist__c = null;
                    }
                    existingLineItem.Architecture_Specialist__c = UserInfo.getUserId();
                    existingLineItem.Expected_000_Value__c = techDollarValue;
                    if( bookDate != null){
                        existingLineItem.Expected_Book_Date__c = bookDate;
                    }
                    if(expectedStage!=null && expectedStage!=''){
                        existingLineItem.Opportunity_Stage__c = expectedStage;                      
                    }  
                    update existingLineItem;
                    return 'Success';
                }else if(role=='Incubation Specialist' && existingLineItem.Incubation_Specialist__c == null){
                    if(existingLineItem.Architecture_Specialist__c == UserInfo.getUserId()){
                        existingLineItem.Architecture_Specialist__c = null;
                    }
                    existingLineItem.Incubation_Specialist__c = UserInfo.getUserId();
                    existingLineItem.Expected_000_Value__c = techDollarValue;
                    if( bookDate != null){
                        existingLineItem.Expected_Book_Date__c = bookDate;
                    }
                    if(expectedStage!=null && expectedStage!=''){
                        existingLineItem.Opportunity_Stage__c = expectedStage;                      
                    }  
                    update existingLineItem;
                    return 'Success';
                }  
            }
            OpportunityLinesSV__c specialistLine = new OpportunityLinesSV__c();
            specialistLine.Opportunity__c = optyID;
            specialistLine.Product_Family__c = productFamily;
            //Populate Product Family Lookup Field - US307507
            specialistLine.Product_Family_Ref__c = productFamilyRef;
            specialistLine.Technology_Service__c = techService;
            specialistLine.Expected_000_Value__c = techDollarValue;
            if(bookDate!=null){
                specialistLine.Expected_Book_Date__c = bookDate;
            }
            if(expectedStage!=null && expectedStage!=''){
                specialistLine.Opportunity_Stage__c = expectedStage;
            }
            specialistLine.Product_Code__c = 'Technology';
            //Updating the record type on insertion of record
            if(role=='Architecture Specialist'){
                specialistLine.Architecture_Specialist__c = UserInfo.getUserId();
                specialistLine.RecordTypeId = ObjectRecordTypeIds__c.getInstance().Architecture_Specialist_Record_Type__c;
            }else if(role=='Incubation Specialist'){
                specialistLine.Incubation_Specialist__c = UserInfo.getUserId();
                specialistLine.RecordTypeId = ObjectRecordTypeIds__c.getInstance().Architecture_Specialist_Record_Type__c;
            }else{
                specialistLine.Software_Specialist__c = UserInfo.getUserId();
                specialistLine.RecordTypeId = ObjectRecordTypeIds__c.getInstance().Software_Specialist_Record_Type__c;
            }
            specialistLineItems.add(specialistLine);
            
            if(!specialistLineItems.isEmpty()){
                insert specialistLineItems;
            }
        }catch(Exception ex){
            return 'Exception';
        }
        return 'Success';
    }
    //Create new specialist line when user adds new Service
    @AuraEnabled
    public static String saveSpecializedViewService(String optyID, String role, String service, Decimal serviceDollarValue, String expectedBookDate, String expectedStage){
        try{  
            List<String> serviceLine = service.split('\\|');
            String checkValue='';
            String techService ='';
            String category = '';
            String program = '';
            String serviceLevel = '';
            String description = '';
            String specialViewQuery ='';
            Date bookDate = null;
            String roleVal = null;
            if(expectedBookDate!=''){
                bookDate = date.valueOf(expectedBookDate);
            }
            if(!serviceLine.isEmpty()){
                techService = serviceLine[0];
                category = serviceLine[1];
                program = serviceLine[2];
                serviceLevel = serviceLine[3];
                description = serviceLine[4];
            }
            List<OpportunityLinesSV__c> lineItems = new List<OpportunityLinesSV__c>();
            List<OpportunityLinesSV__c> existingLineItems = new List<OpportunityLinesSV__c>();
            List<OpportunityLinesSV__c> specialistLineItems = new List<OpportunityLinesSV__c>();
            if(role=='Software Specialist'){
                existingLineItems = [select id,Software_Specialist__c,Expected_000_Value__c,Expected_Book_Date__c,Opportunity_Stage__c
                                     from OpportunityLinesSV__c where Opportunity__c=: optyId and Technology_Service__c =: techService and Service_Category__c =: category
                                     and Service_Level__c =:serviceLevel and Service_Level_Description__c =:description and Product_Code__c=:'Service'and RecordTypeId = : ObjectRecordTypeIds__c.getInstance().Software_Specialist_Record_Type__c];
                
            }else{
                existingLineItems = [select id,Architecture_Specialist__c,Incubation_Specialist__c,Expected_000_Value__c,Expected_Book_Date__c,Opportunity_Stage__c
                                     from OpportunityLinesSV__c where Opportunity__c=: optyId and Technology_Service__c =: techService and Service_Category__c =: category
                                     and Service_Level__c =:serviceLevel and Service_Level_Description__c =:description and Product_Code__c=:'Service' and RecordTypeId = : ObjectRecordTypeIds__c.getInstance().Architecture_Specialist_Record_Type__c ];
            }
            //Logic to check whether the current user is part of the selected line item
            if(existingLineItems.size()==0){
                lineItems  = [select id,Architecture_Specialist__c,Incubation_Specialist__c,Expected_000_Value__c,Expected_Book_Date__c,Opportunity_Stage__c
                              from OpportunityLinesSV__c where Opportunity__c=: optyId and Technology_Service__c =: techService and Service_Category__c =: category
                              and Service_Level__c =:serviceLevel and Service_Level_Description__c =:description and Product_Code__c=:'Service'];
                if(lineItems.size()>0){
                    for(OpportunityLinesSV__c LineItem : lineItems){
                        if(role=='Software Specialist'){
                            if( lineItem.Architecture_Specialist__c==UserInfo.getUserId() || lineItem.Incubation_Specialist__c==UserInfo.getUserId()){
                                return 'sferror';
                            }
                        }else{
                            if(lineItem.Software_Specialist__c==UserInfo.getUserId()){
                                return 'inArcherror';
                            }
                        }
                    }
                }
            }            
            //Check for Line with existing assignment
            system.debug('existingLineItems'+existingLineItems);
            for(OpportunityLinesSV__c existingLineItem : existingLineItems){
                if(role=='Architecture Specialist' && (existingLineItem.Architecture_Specialist__c == UserInfo.getUserId())){
                    return 'Error';
                }else if(role=='Incubation Specialist' && (existingLineItem.Incubation_Specialist__c == UserInfo.getUserId())){
                    return 'Error';
                }
                else if(role=='Software Specialist' && (existingLineItem.Software_Specialist__c == UserInfo.getUserId())){
                    return 'Error';
                }
                else if(role=='Architecture Specialist' && existingLineItem.Architecture_Specialist__c == null){
                    if(existingLineItem.Incubation_Specialist__c == UserInfo.getUserId()){
                        existingLineItem.Incubation_Specialist__c = null;
                    }
                    existingLineItem.Architecture_Specialist__c = UserInfo.getUserId();
                    existingLineItem.Expected_000_Value__c = serviceDollarValue;
                    if( bookDate != null){
                        existingLineItem.Expected_Book_Date__c = bookDate;
                    }
                    if(expectedStage!=null && expectedStage!=''){
                        existingLineItem.Opportunity_Stage__c = expectedStage;                      
                    }  
                    update existingLineItem;
                    return 'Success';
                }else if(role=='Incubation Specialist' && existingLineItem.Incubation_Specialist__c == null){
                    if(existingLineItem.Architecture_Specialist__c == UserInfo.getUserId()){
                        existingLineItem.Architecture_Specialist__c = null;
                    }
                    existingLineItem.Incubation_Specialist__c = UserInfo.getUserId();
                    existingLineItem.Expected_000_Value__c = serviceDollarValue;
                    if( bookDate != null){
                        existingLineItem.Expected_Book_Date__c = bookDate;
                    }
                    if(expectedStage!=null && expectedStage!=''){
                        existingLineItem.Opportunity_Stage__c = expectedStage;                      
                    }  
                    update existingLineItem;
                    return 'Success';
                }
            }
            OpportunityLinesSV__c specialistLine = new OpportunityLinesSV__c();
            specialistLine.Opportunity__c = optyID;
            specialistLine.Service_Category__c = category;
            specialistLine.Service_Level__c = serviceLevel;
            specialistLine.Service_Level_Description__c = description;
            specialistLine.Technology_Service__c = techService;
            specialistLine.Expected_000_Value__c = serviceDollarValue;
            specialistLine.Expected_Book_Date__c = bookDate;
            specialistLine.Opportunity_Stage__c = expectedStage;
            specialistLine.Product_Code__c = 'Service';
            //Updating the record type on insertion of record
            if(role=='Architecture Specialist'){
                specialistLine.Architecture_Specialist__c = UserInfo.getUserId();
                specialistLine.RecordTypeId = ObjectRecordTypeIds__c.getInstance().Architecture_Specialist_Record_Type__c;
            }else if(role=='Incubation Specialist'){
                specialistLine.Incubation_Specialist__c = UserInfo.getUserId();
                specialistLine.RecordTypeId = ObjectRecordTypeIds__c.getInstance().Architecture_Specialist_Record_Type__c;
            }else{
                specialistLine.Software_Specialist__c = UserInfo.getUserId();
                specialistLine.RecordTypeId = ObjectRecordTypeIds__c.getInstance().Software_Specialist_Record_Type__c;
            }
            specialistLineItems.add(specialistLine);
            
            if(!specialistLineItems.isEmpty()){
                insert specialistLineItems;
            }
        }catch(Exception ex){
            return 'Exception';
        }
        return 'Success';
    }
    
    //Fetch existing specialist line by passing the specialist line ID
    @AuraEnabled
    public static OpportunityLinesSV__c getExistingSpecialistLine(String recID){
        return [select id,Opportunity_Line_Item_Reference__c,Architecture_Specialist__c,Incubation_Specialist__c,Software_Specialist__c,Service_Category__c,Service_Program__c,Service_Level_Tech__c,Service_Level_Description__c,Expected_000_Value__c,Opportunity_Stage__c,Product_Code__c,Business_Entity__c,Sub_Business_Entity__c,Product_Family__c,Expected_Book_Date__c from OpportunityLinesSV__c where id =: recID limit 1];
    }
    
    //Save existing specialist line
    @AuraEnabled
    public static String saveExistingSpecializedViewTechServiceLines(String recID,String role, String techDollarValue, String serviceDollarValue,String expectedBookDate,String expectedStage){
        try{
            Date bookDate = null;
            if(expectedBookDate!=''){
                bookDate = date.valueOf(expectedBookDate);
            }
            OpportunityLinesSV__c specilaistLine =  [select id,Software_Specialist__c,Product_Code__c, Architecture_Specialist__c,Incubation_Specialist__c,Expected_000_Value__c, Expected_Book_Date__c, Opportunity_Stage__c
                                                     from OpportunityLinesSV__c
                                                     where id =:recID limit 1];
            system.debug('id'+recID);
            if((specilaistLine.Architecture_Specialist__c!=null && specilaistLine.Architecture_Specialist__c == UserInfo.getUserId())
                || ( specilaistLine.Incubation_Specialist__c != null && specilaistLine.Incubation_Specialist__c == UserInfo.getUserId())
               ||(specilaistLine.Software_Specialist__c != null && specilaistLine.Software_Specialist__c == UserInfo.getUserId()) ){
                if(role=='Architecture Specialist'){
                    if(specilaistLine.Architecture_Specialist__c!=null && specilaistLine.Architecture_Specialist__c != UserInfo.getUserId()){
                        return 'Error';
                    }else if(specilaistLine.Architecture_Specialist__c == null){
                        specilaistLine.Architecture_Specialist__c = UserInfo.getUserId();
                        specilaistLine.RecordTypeId = ObjectRecordTypeIds__c.getInstance().Architecture_Specialist_Record_Type__c;
                        if(specilaistLine.Incubation_Specialist__c!= null && specilaistLine.Incubation_Specialist__c == UserInfo.getUserId()){
                            specilaistLine.Incubation_Specialist__c =null; 
                        }
                        if(specilaistLine.Software_Specialist__c!=null && specilaistLine.Software_Specialist__c == UserInfo.getUserId()){
                            specilaistLine.Software_Specialist__c =null;
                        }
                    }
                }else if(role=='Incubation Specialist'){
                    if(specilaistLine.Incubation_Specialist__c!=null && specilaistLine.Incubation_Specialist__c != UserInfo.getUserId()){
                        return 'Error';
                    }else if(specilaistLine.Incubation_Specialist__c == null){
                        specilaistLine.Incubation_Specialist__c = UserInfo.getUserId();
                        specilaistLine.RecordTypeId = ObjectRecordTypeIds__c.getInstance().Architecture_Specialist_Record_Type__c;
                        if(specilaistLine.Architecture_Specialist__c!=null && specilaistLine.Architecture_Specialist__c == UserInfo.getUserId()){
                            specilaistLine.Architecture_Specialist__c =null;
                        }
                        if(specilaistLine.Software_Specialist__c!=null && specilaistLine.Software_Specialist__c == UserInfo.getUserId()){
                            specilaistLine.Software_Specialist__c =null;
                        }
                    }
                }else if(role=='Software Specialist'){
                    system.debug('val@@'+specilaistLine.Software_Specialist__c);
                    if(specilaistLine.Software_Specialist__c!=null && specilaistLine.Software_Specialist__c != UserInfo.getUserId()){
                        system.debug('in if 540');
                        return 'Error';
                    }else if(specilaistLine.Software_Specialist__c == null){
                        specilaistLine.Software_Specialist__c = UserInfo.getUserId();
                        specilaistLine.RecordTypeId = ObjectRecordTypeIds__c.getInstance().Software_Specialist_Record_Type__c;
                        if(specilaistLine.Architecture_Specialist__c!=null && specilaistLine.Architecture_Specialist__c == UserInfo.getUserId()){
                            specilaistLine.Architecture_Specialist__c =null;
                        }
                        if(specilaistLine.Incubation_Specialist__c!= null && specilaistLine.Incubation_Specialist__c == UserInfo.getUserId()){
                            specilaistLine.Incubation_Specialist__c =null; 
                        }
                    }
                }
            }else{
                 system.debug('in if 555');
                return 'Error';
               
            }
            
            
            if(specilaistLine.Product_Code__c=='Technology'){
                if(techDollarValue!=null){
                    specilaistLine.Expected_000_Value__c =  decimal.valueOf(techDollarValue);
                }else{
                    specilaistLine.Expected_000_Value__c = null;
                }
            }else if(specilaistLine.Product_Code__c=='Service'){
                if(serviceDollarValue!=null){
                    specilaistLine.Expected_000_Value__c =  decimal.valueOf(serviceDollarValue);
                }else{
                    specilaistLine.Expected_000_Value__c =  null;
                }
            }
            specilaistLine.Expected_Book_Date__c = bookDate;
            specilaistLine.Opportunity_Stage__c = expectedStage;
            update specilaistLine;
        }catch(Exception ex){
            return 'Exception';
        }
        return 'Success';
    }
    
    //Check if the logged in user is on pilot profile and has the PSS/VSS additional permissions
    @AuraEnabled
    public static Boolean checkPilotUserPermission(){
        List<User> usrs = [select id, Additional_User_Permissions__c,ProfileId from user where id=:UserInfo.getUserId() limit 1];
        String profileID = Utilities.getConstant_CS('PilotProfileId');
        if(!usrs.isEmpty()){
            User usr = usrs[0];
            if(profileID==usr.ProfileId && (usr.Additional_User_Permissions__c.contains('Enable_ePSS')||usr.Additional_User_Permissions__c.contains('Enable_VSS'))){
                return false;
            }
        }
        return true;
    }
    // Method for Checking User has view Permissions on Opportunity      
    @AuraEnabled
    public static Boolean checkUserViewPermission(String recId){
        UserRecordAccess userAccess = [ SELECT RecordId, HasReadAccess FROM UserRecordAccess WHERE UserId =:UserInfo.getUserId()   AND RecordId =:recId limit 1];
        return userAccess.HasReadAccess;
    }
    
    // Method for checking the EA opportunity   
    @AuraEnabled
    public static string checkEAOppty(String recId){
        Opportunity  eaAccess = [ SELECT id, Enterprise_Agreement_Opportunity__c FROM Opportunity WHERE id =:recId limit 1];
        return eaAccess.Enterprise_Agreement_Opportunity__c;
    }
    
    //Method to get logged in user role from Opportunity Team
    @AuraEnabled
    public static String getSpecialistRole(String recId){
        List<OpportunityTeamMember> OptyTeamMembers = [select UserId,TeamMemberRole from OpportunityTeamMember where OpportunityId=:recId and UserId=:UserInfo.getUserId()];
        if(!OptyTeamMembers.isEmpty()){
            return OptyTeamMembers[0].TeamMemberRole;
        }else{
            return null;
        }
    }
    //added by kavya to remove all Specialist lines
    @AuraEnabled
    public static String RemoveAllSpecialistLine(String optyId){
        List<OpportunityLinesSV__c> specializedLineList  = [select id,Architecture_Specialist__c,Incubation_Specialist__c,Software_Specialist__c  from OpportunityLinesSV__c where Opportunity__c=:optyId AND (Architecture_Specialist__c=:UserInfo.getUserId() or Incubation_Specialist__c=:UserInfo.getUserId() or Software_Specialist__c =:UserInfo.getUserId())];
        if(!specializedLineList.isEmpty()){
            delete specializedLineList;
        }
        return 'Success';
    }
    @AuraEnabled
    public static Boolean CheckSpecialistLineExist(String optyId){
        List<OpportunityLinesSV__c> specializedLineList  = [select id,Architecture_Specialist__c,Incubation_Specialist__c,Software_Specialist__c from OpportunityLinesSV__c where Opportunity__c=:optyId AND (Architecture_Specialist__c=:UserInfo.getUserId() or Incubation_Specialist__c=:UserInfo.getUserId() or Software_Specialist__c=:UserInfo.getUserId())];
        if(!specializedLineList.isEmpty())
        {
            return true;
        }
        return false;
    }
}