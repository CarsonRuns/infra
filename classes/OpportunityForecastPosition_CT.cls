global class OpportunityForecastPosition_CT {
    
    public Opportunity oppty{get;set;}
    public String showMsg { get; set; }     // Added By Naresh(nkalahas@cisco.com)
    public String uiTheme;      
    
    public OpportunityForecastPosition_CT (ApexPages.StandardController controller) {
        system.debug('::::Test'+ApexPages.currentPage().getParameters().get('id'));
        this.oppty = [Select id, name,
                      Position__c, Description,Opportunity_Owner_AM__c, OwnerId
                      from Opportunity
                      where id=:ApexPages.currentPage().getParameters().get('id')];
        
        
        if(this.oppty.Position__c == null){                                  // Added By Naresh(nkalahas@cisco.com)
            showMsg=system.label.LightningcontinueForecast;                      // Added By Naresh(nkalahas@cisco.com)
            
        }             
        System.debug('Opportunity object found:--'+ this.oppty);
    }
    
    public List <SelectOption> getForecastPositionOptions() {
        
        list<SelectOption> forecastLOV = new list<SelectOption>();
        forecastLOV.add(new SelectOption('','-None-'));
        
        try
        {
            // Updated where clause to refer ownerId on 3/9/15
            String positionUserId = oppty.OwnerId;
            
            string forecastPstns = [select Position_1__c from User where ID =:positionUserId ].Position_1__c;
            System.debug('forecastPstns='+forecastPstns);
            String[] forecastPstnsArray=forecastPstns.split('\n');
            System.debug('Debug 2');
            for(integer i=0;i< forecastPstnsArray.size();i++)
            {
                System.debug('Debug 3');
                forecastLOV.add(new SelectOption(forecastPstnsArray[i].trim(),forecastPstnsArray[i].trim()));
                System.debug('Debug 4='+ forecastLOV);
            }
        }
        catch(Exception e)
        {
            System.debug('No Forecast position');
        }
        
        return forecastLOV;
    }
    
    public PageReference saveDesc(){
        update oppty;
        return (new ApexPages.StandardController(oppty)).view();
    }
    
    public PageReference saveRecord() {
        PageReference returnView = null;
        System.debug('oppty object='+ oppty);
        System.debug('oppty ID='+ oppty.ID);
        System.debug('oppty position value='+ oppty.Position__c );
        
        //Skip opportunity validaitons
        Utilities.setValidationSkip(true);
        try{
            update oppty;
            Opportunity parentOpp = [Select id, OwnerId,Position__c from Opportunity where id=:oppty.id];                    
            //Changing the Owner of the Phase Opportunity when Parent Opportunity owner changes, Refer WR-3070
            Set<Id> OpptyIds = new Set<Id>();
            OpptyIds.add(oppty.id);
            String Querystring = 'select ';
            for(Schema.FieldSetMember fld: sObjectType.opportunity.FieldSets.PhaseOpptyfields.getFields()) 
            {
                Querystring =Querystring+ fld.getFieldPath() + ', ';
            }
            Querystring = Querystring+ 'id from opportunity where Parent_ID__c IN:OpptyIds' ;
            
            System.debug('**Query string**'+Querystring );
            List<Opportunity> optyList = new List<Opportunity>();
            List<opportunity> phaseOpptys = Database.query(Querystring);
            for(Opportunity phaseOpp: phaseOpptys)
            {                     
                phaseOpp.OwnerId = parentOpp.OwnerId;
                phaseOpp.Position__c = parentOpp.Position__c ;
                phaseOpp.skipValidations__c =true;    
                optyList.add(phaseOpp); 
            }
            system.debug('optyList>>'+optyList);
            if(!optyList.isEmpty())
            {
                OpptyChildUpdate.setProcessOpptyChild(true);
                // update optyList;
            }
            
            system.debug('optyList>>>'+optyList);
            /*****
Modified by Pradeep Adla: redirection to record page not working in Lightnigng Console due to URL mismatch. 
So we are using diffrent URL for different UI
*****/
            //To find the user in which UI
            if(!(TEST.isRunningTEst())){
                uiTheme = UserInfo.getUiTheme();
            }
            //If the user in either "Lightning" or "Lightning Console" 
            if( uiTheme == 'Theme4d' || uiTheme == 'Theme4u') {
                String s = '{"componentDef":"c:LXLead2OptyConvert","attributes":{"recordId":"'+oppty.Id+'","recordName":"'+oppty.Name+'"}}';
                Blob b = blob.valueOf(s);
                //returnView= new pagereference('/one/one.app#'+EncodingUtil.base64Encode(b)); 
                returnView= new pagereference('/lightning/r/Opportunity/'+oppty.Id+'/view');
            }
            //If the user in "Classic" 
            else{
                //returnView  =   new pagereference('/' + oppty.Id+ '/e?retURL=' + oppty.Id);
                returnView  =   new pagereference('/' + oppty.Id);
            }
        } catch(Exception ex){
            //ApexPages.addmessage(new apexpages.message(apexpages.severity.ERROR, ex.getMessage()));
        }
        return returnView ;
    }
    
    @RemoteAction
    global static String updateForecastingPosition(string OppId,String forecastingPosition) {
        String status = 'Success';
        Opportunity o = new Opportunity(id = OppId);
        
        //Skip opportunity validaitons
        Utilities.setValidationSkip(true);
        
        o.Position__c = forecastingPosition;
        try {
            update o;
        }
        catch(DmlException dmlEx) {
            System.debug(dmlEx);
            Exception ex = (Exception)dmlEx;
            ex.setMessage(dmlEx.getDmlMessage(0));
            status = ex.getDmlMessage(0);
            throw ex;
        }/*finally{
return status;
}*/
        return status;
    }
    
    public PageReference cancel() {
        System.debug('oppty object in cancel='+ oppty);
        return (new ApexPages.StandardController(oppty)).view();
    }
    
    @RemoteAction
    global static String saveRecordUpdated(Id opptyId, String forecastPosition) {
        String message = '';
        Opportunity oppty = [select id,Position__c from opportunity where id=:opptyId limit 1];
        oppty.Position__c = forecastPosition;
        //Skip opportunity validaitons
        Utilities.setValidationSkip(true);
        try{
            update oppty;
            Opportunity parentOpp = [Select id, OwnerId,Position__c from Opportunity where id=:oppty.id];                    
            //Changing the Owner of the Phase Opportunity when Parent Opportunity owner changes, Refer WR-3070
            Set<Id> OpptyIds = new Set<Id>();
            OpptyIds.add(oppty.id);
            String Querystring = 'select ';
            for(Schema.FieldSetMember fld: sObjectType.opportunity.FieldSets.PhaseOpptyfields.getFields()) 
            {
                Querystring =Querystring+ fld.getFieldPath() + ', ';
            }
            Querystring = Querystring+ 'id from opportunity where Parent_ID__c IN:OpptyIds' ;
            
            System.debug('**Query string**'+Querystring );
            List<Opportunity> optyList = new List<Opportunity>();
            List<opportunity> phaseOpptys = Database.query(Querystring);
            for(Opportunity phaseOpp: phaseOpptys)
            {                     
                phaseOpp.OwnerId = parentOpp.OwnerId;
                phaseOpp.Position__c = parentOpp.Position__c ;
                phaseOpp.skipValidations__c =true;    
                optyList.add(phaseOpp); 
            }
            system.debug('optyList>>'+optyList);
            if(!optyList.isEmpty())
            {
                OpptyChildUpdate.setProcessOpptyChild(true);
            }
            message = 'Success';
        } catch(Exception ex){
            //ApexPages.addmessage(new apexpages.message(apexpages.severity.ERROR, ex.getMessage()));
            if(ex.getMessage().contains('team')){
                message = 'You must be part of the opportunity team for editing privileges.';
            }else{
                message=ex.getMessage();
            }
            
        }
        return message ;
    }
}