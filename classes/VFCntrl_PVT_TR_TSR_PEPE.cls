/*
Name    : VFCntrl_PVT_TR_TSR_PEPE
Author  : Sathish Selvaraj
Purpose : Created part of Apr FY15 release to simplify the TR and TSR add functionality by using VF page for PVT platform  
Created Date: Mar 20 2015

Modification History:
Version  Date            Modified By     Description
--------------------------------------------------------------------------------------
 
*/

public class VFCntrl_PVT_TR_TSR_PEPE {
    
    public PEPE_Training_Request__c TRObj{get; set;}
    public list<trEventDayWrapper> trEventDayList{get; set;}
    public list<PEPE_Training_Sessions_Requested__c> lstTSRDtlsForViewPage{get; set;}
    public PEPE_Training_Sessions_Requested__c TSRObj;
    list<PEPE_Training_Sessions_Requested__c> TSRLstToSave = new list<PEPE_Training_Sessions_Requested__c>();
    list<PEPE_Training_Sessions_Requested__c> TSRLstToDelete = new list<PEPE_Training_Sessions_Requested__c>();
    List<PEPE_Event_Day__c> currTREDLst;
    list<PEPE_Training_Sessions_Requested__c> TSRLstFromTR;
    public string RecTypeNameFromURL;
    RecordType RecTypeDetails;
    public Id TR_Id;
    string retUrl;
    public Integer counter{get;set;}
    public Id RecTypeIdFromURL;
    public string[] tcValSplitFromUrl;
    PEPE_Training_Event__c TEObjDtls;

    public VFCntrl_PVT_TR_TSR_PEPE(ApexPages.StandardController controller) {
        try{
            initialize();
            
                                 
        }catch (Exception e){
            System.debug('### error : ' + e.getStackTraceString());
        } 
    }
    
    public PageReference redirectToPage() {
        RecTypeIdFromURL = ApexPages.currentPage().getParameters().get('RecordType');
        TR_Id = ApexPages.currentPage().getParameters().get('Id');
        retUrl = ApexPages.currentPage().getParameters().get('retURL');
        string currUsrId = UserInfo.getUserId();
        list<PermissionSetAssignment> lstPVTPermSetAssmt = [select Id, AssigneeId from PermissionSetAssignment where AssigneeId=:currUsrId and PermissionSet.Name like '%PVT%'];
        
        String urlStringForRedirect;
        String urlVal = Apexpages.currentPage().getUrl();
        system.debug('urlVal @@@@### '+urlVal);
        string[] urlSplitVal = urlVal.split('=');
        tcValSplitFromUrl = urlSplitVal[1].split('&');
        
       if(TR_Id != null) {
            TRObj = [select Id, Status__c, Geography__c, Cisco_Location__c, Theatre_Region__c, Address_1__c, 
            Country_Cluster__c, Address_2__c, Country__c, Address_3__c, Location__c, City__c, Training_Offering_Id__c, RecordTypeId, RecordType.Name 
            from PEPE_Training_Request__c where Id =:TR_Id];
            system.debug('TRObj redirect@@@@' + TRObj);

            //Redirect to standard edit page if TR record type not belongs to PVT
            if(TRObj.RecordType.Name != 'PVT' 
            && TRObj.RecordType.Name != 'Calendar_Based_Host_Requested' 
            && TRObj.RecordType.Name != 'Calendar_Based_Host_CancellationRejectedDieliveredClosed') {
            
                String urlString = '/'+TR_Id+'/e?retURL='+retUrl+'&nooverride=1';
                PageReference pageRef = new PageReference(urlString);
                return pageRef;
            }
            else {
                initialize();
            }
         }
         
         //if(RecTypeIdFromURL != null) {
         system.debug('tcValSplitFromUrl$$$'+tcValSplitFromUrl);
         if(tcValSplitFromUrl[0].contains('TC-')) {
            TEObjDtls = [select Id, Name, RecordType.Name from PEPE_Training_Event__c where Name =:tcValSplitFromUrl[0] limit 1];
         }
         if(RecTypeIdFromURL != null) {
             RecTypeDetails = [select Id, Name from RecordType where Id =:RecTypeIdFromURL];
         }
             if((RecTypeDetails != null&& RecTypeDetails.Name != 'PVT' 
             && RecTypeDetails.Name != 'Calendar_Based_Host_Requested' 
             && RecTypeDetails.Name != 'Calendar_Based_Host_CancellationRejectedDieliveredClosed') || 
             (TEObjDtls != null && TEObjDtls.RecordType.Name != 'PVT' && 
             TEObjDtls.RecordType.Name != 'Calendar Published RT' && 
             TEObjDtls.RecordType.Name != 'Calendar_Submitted_RT') 
           //  || (lstPVTPermSetAssmt.size() == 0)) {
           ) {
                //Id entFromURL = ApexPages.currentPage().getParameters().get('ent');
                /*if(tcValSplitFromUrl[0].contains('TC-')) {
                    TEObjDtls = [select Id, Name, RecordType.Name from PEPE_Training_Event__c where Name =:tcValSplitFromUrl[0] limit 1];
                    urlStringForRedirect = '/a1w/e?'+urlSplitVal[0]+'='+tcValSplitFromUrl[0]+'&'+urlSplitVal[0]+'_lkid='+TEObjDtls.Id+'&retURL='+retUrl+'&RecordType='+RecTypeIdFromURL+'&ent='+entFromURL+'&nooverride=1';*/
                    urlVal = urlVal.replace('apex','a1w');
                    urlVal = urlVal.replace('PVT_TR_TSR_PEPE','e');
                    urlVal = urlVal.replace('sfdc.override=1','nooverride=1');
                    urlVal = urlVal.replace('save_new=1','&');
                    urlVal = urlVal.replace('scontrolCaching=1','&');
                    system.debug('urlVal ##### '+urlVal);
                    urlStringForRedirect = urlVal;
               /* }
                else {
                    urlStringForRedirect = '/a1w/e?retURL='+retUrl+'&RecordType='+RecTypeIdFromURL+'&ent='+entFromURL+'&nooverride=1';
                }*/
                
                PageReference pageRef = new PageReference(urlStringForRedirect);
                return pageRef;
             }
             else {
                 initialize();
             }
         //}
         return null;
        
    }
    
    public PageReference showTSRRecInViewPage() {
        Id TR_ID = ApexPages.currentPage().getParameters().get('Id');
        lstTSRDtlsForViewPage = getTSRRecords(TR_ID);
        system.debug('lstTSRDtlsForViewPage ### @@@'+lstTSRDtlsForViewPage);
        return null;
    }
    
    public list<PEPE_Training_Sessions_Requested__c> getTSRRecords(Id trId) {
        list<PEPE_Training_Sessions_Requested__c> lstTSRRecordsFromTR = [Select Event_Day__c , Training_Request__c, TP_Room_Name__c, Room_Capacity__c, Host_Name__c, Host_Email__c, 
            Training_Event_Id__c, Training_Event_Name__c, Event_Day__r.Name, Training_Request__r.Training_Offering_Id__c from PEPE_Training_Sessions_Requested__c where Training_Request__c =:trId];
        if(lstTSRRecordsFromTR != null && lstTSRRecordsFromTR.size() > 0) {
            return lstTSRRecordsFromTR;
        }    
        return null;
    }
    
    public void loadEveDayDtlsForLst() {
        trEventDayList.clear();
        system.debug('TR_Id TR_Id &&&' + TR_Id );
        system.debug('TRObj TRObj TRObj@@@' + TRObj);
        counter = 0;
        if(TR_Id != null) {
            /*TSRLstFromTR= [Select Event_Day__c , Training_Request__c, TP_Room_Name__c, Room_Capacity__c, Host_Name__c, Host_Email__c, 
            Training_Event_Id__c, Training_Event_Name__c, Event_Day__r.Name, Training_Request__r.Training_Offering_Id__c from PEPE_Training_Sessions_Requested__c where Training_Request__c =:TR_Id];*/
            TSRLstFromTR = getTSRRecords(TR_Id);
        }
 
        currTREDLst = [Select Id, Training_Event__r.Training_Event_Name__c, Training_Event__c, Name From PEPE_Event_Day__c where Training_Event__c =:TRObj.Training_Offering_Id__c];
        system.debug('currTREDLst currTREDLst ##' + currTREDLst);   
        system.debug('TSRLstFromTR TSRLstFromTR$$$' + TSRLstFromTR); 
            if(TSRLstFromTR != null && TSRLstFromTR.size() > 0) {
                for(PEPE_Training_Sessions_Requested__c tsrObj : TSRLstFromTR) {
                    trEventDayWrapper trEDW = new trEventDayWrapper(tsrObj);
                    counter++;
                    trEDW.counterWrap = counter;
                    trEventDayList.add(trEDW);
                }
                if(currTREDLst != null && currTREDLst.size() > 0) {
                    for(PEPE_Event_Day__c edObj : currTREDLst) {
                        boolean valExistCheck = false;
                        for(PEPE_Training_Sessions_Requested__c tsrObj : TSRLstFromTR) {
                        system.debug('tsrObj.Event_Day__c = edObj.Id' + tsrObj.Event_Day__c +'='+ edObj.Id); 
                            if(tsrObj.Event_Day__c == edObj.Id) {
                                
                                valExistCheck = true;
                            }
                        }
                        if(!valExistCheck) {
                            trEventDayWrapper trEDW = new trEventDayWrapper(edObj);
                            counter++;
                            trEDW.counterWrap = counter;
                            trEventDayList.add(trEDW);
                        }
                    }
                }
            }
            else {
            system.debug('inside else');
                if(!currTREDLst.isempty()) {
                    for(PEPE_Event_Day__c edObj : currTREDLst) {
                        trEventDayWrapper trEDW = new trEventDayWrapper(edObj);
                        counter++;
                        trEDW.counterWrap = counter;
                        trEventDayList.add(trEDW);
                    }
                }
            }
            
    }
    
    public void initialize(){ 
        
        trEventDayList = new list<trEventDayWrapper>();
       // TR_Id = ApexPages.currentPage().getParameters().get('Id');
       // retUrl = ApexPages.currentPage().getParameters().get('retURL');
        system.debug('TR_Id ###' + TR_Id);
       
        if(TR_Id == null ) {
            TRObj = new PEPE_Training_Request__c();
            RecTypeNameFromURL = ApexPages.currentPage().getParameters().get('RecordTypeName');
            if(tcValSplitFromUrl[0].contains('TC-')) {
                TEObjDtls = [select Id, Name from PEPE_Training_Event__c where Name =:tcValSplitFromUrl[0] limit 1];
                TRObj.Training_Offering_Id__c = TEObjDtls.Id;
           
            }

            system.debug('RecTypeNameFromURL ###' + RecTypeNameFromURL );
            if(RecTypeNameFromURL != null && RecTypeNameFromURL != '') {
                RecTypeDetails = [select Id, Name from RecordType where Name=: RecTypeNameFromURL and SobjectType='PEPE_Training_Request__c' limit 1];
            }
            if(RecTypeIdFromURL != null || RecTypeNameFromURL != null) {
                TRObj.RecordTypeId = RecTypeDetails.Id;
            }

        }
        
        system.debug('TRObj TRObj$$$$' + TRObj);

        loadEveDayDtlsForLst();
        
        
    }

    
    public PageReference cancel(){
        String urlString;
        if(retUrl == null) {
            urlString = '/'+TRObj.Training_Offering_Id__c;
        }
        else {
            urlString = retUrl;
        }
        
        PageReference pageRef = new PageReference(urlString);
        return pageRef;   
    }
    
    public void saveTR(PEPE_Training_Request__c trObjToSave) {
        if(trObjToSave != null) {
            upsert trObjToSave;
  
        }
    }
    
    public void saveTSR(list<PEPE_Training_Sessions_Requested__c> lstTSRToSave) {
        system.debug('lstTSRToSave#####'+lstTSRToSave);
        if(!lstTSRToSave.isempty()) {
            upsert lstTSRToSave;
        }
    }
    
    public PageReference saveTRAndTSR(){
        system.debug('TRObj TRObj# inside save initiate'+TRObj);
      boolean returnBoolean = false;  
      
      //code to check TR fields and make mandatory as like standard PL
      if(TRObj != null) {
          if(TRObj.Status__c == null) {
              TRObj.Status__c.addError('You must enter a value');
              returnBoolean = true;
          }
          if(TRObj.Geography__c == null) {
              TRObj.Geography__c.addError('You must enter a value');
              returnBoolean = true;
          }
          if(TRObj.Cisco_Location__c == null) {
              TRObj.Cisco_Location__c.addError('You must enter a value');
              returnBoolean = true;
          }
          if(TRObj.Address_1__c == null) {
              TRObj.Address_1__c.addError('You must enter a value');
              returnBoolean = true;
          }
          if(TRObj.City__c == null) {
              TRObj.City__c.addError('You must enter a value');
              returnBoolean = true;
          }

      }
        
      if(!trEventDayList.isempty()) {
          
            system.debug('trEventDayList###'+trEventDayList);
            TSRLstToSave.clear();
          for(Integer index=0;index<trEventDayList.size();index++){
              system.debug('trEventDayList[index]%%%' + trEventDayList[index]);
              if((trEventDayList[index].wTSR.TP_Room_Name__c != null && trEventDayList[index].wTSR.TP_Room_Name__c != '')
               || (trEventDayList[index].wTSR.Room_Capacity__c != null)
               || (trEventDayList[index].wTSR.Host_Name__c != null && trEventDayList[index].wTSR.Host_Name__c != '')
               || (trEventDayList[index].wTSR.Host_Email__c != null && trEventDayList[index].wTSR.Host_Email__c != '')) {
               
                  if(trEventDayList[index].wTSR.TP_Room_Name__c == null || trEventDayList[index].wTSR.TP_Room_Name__c == '') {
                      trEventDayList[index].wTSR.TP_Room_Name__c.addError('You must enter a value');
                      returnBoolean = true;
                  }
                  if(trEventDayList[index].wTSR.Room_Capacity__c == null ) {
                      trEventDayList[index].wTSR.Room_Capacity__c.addError('You must enter a value');
                      returnBoolean = true;
                   
                  }
                  if(trEventDayList[index].wTSR.Host_Name__c == null || trEventDayList[index].wTSR.Host_Name__c == '') {
                      trEventDayList[index].wTSR.Host_Name__c.addError('You must enter a value');
                      returnBoolean = true;
                  }
                  if(trEventDayList[index].wTSR.Host_Email__c == null || trEventDayList[index].wTSR.Host_Email__c == '') {
                      trEventDayList[index].wTSR.Host_Email__c.addError('You must enter a value');
                      returnBoolean = true;
                  }
                  
                  
                    
                  TSRObj = trEventDayList[index].wTSR;
                  
                  TSRLstToSave.add(TSRObj);
                  
                  system.debug('TSRObj #####'+TSRObj);
              }
              if(trEventDayList[index].wTSR.Id != null) {
                  if(trEventDayList[index].wTSR.TP_Room_Name__c == null && trEventDayList[index].wTSR.Room_Capacity__c == null
                   && trEventDayList[index].wTSR.Host_Name__c == null && trEventDayList[index].wTSR.Host_Email__c == null ) {
                   
                       TSRLstToDelete.add(trEventDayList[index].wTSR);
                  }
              }
          }
          system.debug('TSRLstToSave$$$'+TSRLstToSave);
          if(returnBoolean == true){
            return null;
          }
          system.debug('TR_Id ###' + TR_Id);
          if(TRObj != null) {
              system.debug('TRObj TRObj@@@ savepart' + TRObj);
              saveTR(TRObj);
          }
          
          if(!TSRLstToSave.isempty()) {
              for(PEPE_Training_Sessions_Requested__c objTSR: TSRLstToSave) {
              
                  objTSR.Training_Request__c = TRObj.Id;
              }
              saveTSR(TSRLstToSave);
              TSRLstToSave.clear();
          }
          
          if(TSRLstToDelete != null && TSRLstToDelete.size() > 0) {
              //SCAVA FIX
            if (PEPE_Training_Sessions_Requested__c.sObjectType.getDescribe().isDeletable())
             {
              delete TSRLstToDelete;
             }
          }
      }
        
        //return cancel();
        PageReference pageRef2 = new PageReference('/'+TRObj.Id);
        pageRef2.setRedirect(true);
        return pageRef2;
           
    }
    
    //Code to clear values for row if Clear link clicked
    public PageReference removingRow(){
    
        Integer param = Integer.valueOf(Apexpages.currentpage().getParameters().get('index'));
        
        for(Integer i=0;i<trEventDayList.size();i++){
            if(trEventDayList[i].counterWrap == param ){
                //trEventDayList.remove(i);
               trEventDayList[i].wTSR.TP_Room_Name__c = null;
               trEventDayList[i].wTSR.Room_Capacity__c = null;
               trEventDayList[i].wTSR.Host_Name__c = null;
               trEventDayList[i].wTSR.Host_Email__c = null;     
            }
        }
        
        
        counter--;
        return null;    
    }
    
    //create error message to be displayed on VF UI
    private void createError(boolean canProceedBool, String errMsg){
    
        apexPages.addmessage(new ApexPages.message(ApexPages.severity.ERROR,errMsg)); 
        System.debug('## errMsg  : ' + errMsg );
        
    }
    
    public class trEventDayWrapper {
        public Id eventDayId{get;set;}
        public Id TENameId{get;set;}
        public string edName{get;set;}
        public string eveName{get;set;}
        public PEPE_Training_Sessions_Requested__c wTSR {get; set;}
        public Integer counterWrap{get;set;}
        public RecordType tsrPVTRecTypeId = [select Id, Name from RecordType where Name = 'PVT' and SobjectType = 'PEPE_Training_Sessions_Requested__c' limit 1];
                
        public trEventDayWrapper(PEPE_Event_Day__c EDaysDtls) {
            this.wTSR = new PEPE_Training_Sessions_Requested__c();
            this.wTSR.Event_Day__c = EDaysDtls.Id;
            this.wTSR.RecordTypeId = tsrPVTRecTypeId.Id;
             
            this.eventDayId = EDaysDtls.Id;
            this.TENameId = EDaysDtls.Training_Event__c;
            this.edName = EDaysDtls.Name;
            this.eveName = EDaysDtls.Training_Event__r.Training_Event_Name__c;
        
        }
        public trEventDayWrapper(PEPE_Training_Sessions_Requested__c TSRDtls) {
            this.wTSR = TSRDtls;
            this.wTSR.Event_Day__c = TSRDtls.Event_Day__c;
            this.wTSR.RecordTypeId = tsrPVTRecTypeId.Id;
             
            this.eventDayId = TSRDtls.Event_Day__c;
            this.TENameId = TSRDtls.Training_Event_Id__c;
            this.edName = TSRDtls.Event_Day__r.Name;
            this.eveName = TSRDtls.Training_Event_Name__c;
        
        }
    }
   
}