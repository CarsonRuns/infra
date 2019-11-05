/************************************************************************************************************************************
Name    : NBM_Qualification_Controller
Author  : 
Purpose : For creating Qualification record and navigating user respectively
Created Date:  
Modification History: Initial implementation.
1 DE253169 - 05/28/19- mkella- Pre-Populating Oppty Record Id in New qualification record
*************************************************************************************************************************************/

public without sharing class NBM_Qualification_Controller
{

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
    //.....................................CONTROLLER VARIABLES.................................................    
    public Qualification__c quallification {get;set;}
    public Opportunity opty = new Opportunity(); 
    private Qualification__Share manshare = new Qualification__Share();
    public Opportunity optyvar = new Opportunity ();
    public  configuration_development_only__c temp {get;set;}
    public  String quallificationStatus {get;set;}
  
    public  Id nbmid = NULL ;
    private ID oldOppty;
    public Id prevOwner;    
    public Boolean change = True;
    public Boolean related = False;
    //mkella- DE253169 Start changes
    //to check if user is in lightning experience and based on it render in vf page to navigate to create to new record
    public Boolean isLightningOptyId = False;
    public Boolean getisLightningOptyId(){return isLightningOptyId;}
    //mkella - DE253169 End changes
    ApexPages.StandardController GstdController;
    public Qualification__c getlead(){return quallification;}
    public Boolean getrelated(){return related;}
    public Id lId= ApexPages.currentPage().getParameters().get('Id');
    
    public String Recordtype = ApexPages.currentPage().getParameters().get('RecordType');
    public String retURL = ApexPages.currentPage().getParameters().get('retURL');
    public String ent = ApexPages.currentPage().getParameters().get('ent');
    public String note = '';
    public String cancelURL {get; set;}
    public String confirmationToken {get; set;}
    public String saveNewURL {get; set;}
    public String opptyname = ApexPages.currentPage().getParameters().get('CF00N80000004IXXz');
    public String opptyid = ApexPages.currentPage().getParameters().get('CF00N80000004IXXz_lkid');
    public Boolean gspobdm {get; set;}   
    public Boolean isLightng {get; set;}
    
    
    String contype = '';
    public String getContype() {
        return contype;
    }
    public void setContype(String contype) {
        this.contype = contype;
        quallification.Segment__c = contype;
    }    
    //added by Kavya
    public String defaultRecordtype = null;
    public String getDefaultRecordtype(){return defaultRecordtype;}
    //ends here
    //.......................................CONSTRUCTOR.....................................................    
    public NBM_Qualification_Controller(ApexPages.StandardController controller) 
    {
         quallification = new Qualification__c ();
         GstdController = controller;
         temp = new configuration_development_only__c();
         this.quallification = (Qualification__c)GstdController.getRecord();  
         String quallificationId=quallification.Id;
         confirmationToken = ApexPages.currentPage().getParameters().get('_CONFIRMATIONTOKEN');     
         saveNewURL = ApexPages.currentPage().getParameters().get('save_new_url');
         note =  ApexPages.currentPage().getParameters().get('note');
         cancelURL = ApexPages.currentPage().getParameters().get('cancelURL');
         retURL = ApexPages.currentPage().getParameters().get('retURL');
         Recordtype = ApexPages.currentPage().getParameters().get('RecordType');

         if(ApexPages.currentPage().getParameters().get('id') != null)
         {  
         // Changed the Static SOQL to Dynamic SOQL, Now all of the fields will be added to the Query. Implemented using Dynamic Apex.           
            SObjectType qualificationType = Schema.getGlobalDescribe().get('Qualification__c');
            Map<String,Schema.SObjectField> mfields = qualificationType.getDescribe().fields.getMap();
            String QualificationfieldAPINames='';
            for(String fieldAPIName: mfields.keyset()){
                QualificationfieldAPINames = QualificationfieldAPINames+fieldAPIName+',';
            }
            QualificationfieldAPINames = QualificationfieldAPINames.subString(0,QualificationfieldAPINames.length()-1);
            this.quallification = Database.Query('Select '+QualificationfieldAPINames+' from Qualification__c where Id=:quallificationId limit 1');
            oldOppty = quallification.Opportunity__c;
            quallificationStatus = quallification.Status__c;
            prevOwner= quallification.OwnerId;    
            contype = quallification.Segment__c;        
        }
        else
        {   
            if(quallification.Opportunity__c != null)
            {
              integer NumberOfNBMs = [Select count() from Qualification__c n where n.Opportunity__c =:quallification.opportunity__c and n.RecordTypeId = '012800000003c7X'];
              if(quallification.RecordTypeId == '012800000003c7X' )
                  related = (NumberOfNBMs >0)? TRUE: FALSE;
            }   
            // SCAVA FIX
            if(flsUpdate(Qualification__c.Requester_Name__c))
            {
            quallification.Requester_Name__c = UserInfo.getUserId();
            }
            if(flsUpdate(Qualification__c.Status__c))
            {
            quallification.Status__c = '0-Prospect';
            }
            if(flsUpdate(Qualification__c.Theater__c))
            {
            quallification.Theater__c = [select Theatre__c from User where id = :Userinfo.getUserId()].Theatre__c;
            }
        }
            
    }
    
    //................................CONSTRUCTOR METHODS............................................................  
    ///////////////////Redirection to GSPO Edit page based on the corresponding RecordTypeId/////////////////////
    public PageReference redirect()
    {
        PageReference pageref; 
        isLightng = true;
        Id gspoid = ApexPages.currentPage().getParameters().get('Id');   
        // Code added to validate the "Permission denied" error message does not show up for lightning
        if(UserInfo.getUiThemeDisplayed() == 'Theme4d' || UserInfo.getUiThemeDisplayed() == 'Theme4u'){
            isLightng = false;
        }
        //mkella - DE253169 Start changes
        //check for GSPO record type and if it has oppty record and user is in lightning experience
        if((Recordtype == Utilities.getGSPOrecordtypeId()) && (opptyname != null && opptyid != null) && (UserInfo.getUiThemeDisplayed() == 'Theme4d' || UserInfo.getUiThemeDisplayed() == 'Theme4u'))
        {
            isLightningOptyId = true;
            pageref = null;
            return pageref;
        }
        //mkella- DE253169 End change
        else if(Recordtype == Utilities.getGSPOrecordtypeId())
        {        
            if(opptyname != null && opptyid != null)
                pageref = new PageReference('/a1B/e?retURL='+retURL+'&RecordType='+Recordtype+'&ent='+ent+'&CF00N80000004IXXz='+opptyname+'&CF00N80000004IXXz_lkid='+opptyid);
            else
                pageref = new PageReference('/a1B/e?retURL='+retURL+'&RecordType='+Recordtype+'&ent='+ent);
            
            pageref.getParameters().put('retURL', retURL);
            pageref.getParameters().put('RecordType', Recordtype);
            pageref.getParameters().put('cancelURL', cancelURL);
            pageref.getParameters().put('ent', ent);
            pageref.getParameters().put('_CONFIRMATIONTOKEN', confirmationToken);
            pageref.getParameters().put('save_new_url', saveNewURL);
            pageref.getParameters().put('nooverride', '1');        
            return pageref;
        }
        else if(quallification.Id != null&& quallification.RecordTypeId == Utilities.getGSPOrecordtypeId())
        {   
            pageref = new PageReference('/'+quallification.Id+'/e?retURL='+retURL);        
            pageref.getParameters().put('retURL', retURL);
            pageref.getParameters().put('RecordType', Recordtype);
            pageref.getParameters().put('cancelURL', cancelURL);
            pageref.getParameters().put('ent', ent);
            pageref.getParameters().put('_CONFIRMATIONTOKEN', confirmationToken);
            pageref.getParameters().put('save_new_url', saveNewURL);
            pageref.getParameters().put('nooverride', '1');            
            return pageref;
        }
        else if(quallification.RecordTypeId == Utilities.getGSPOrecordtypeId() || Recordtype == Utilities.getGSPOrecordtypeId())
        {            
            gspobdm = false;
            pageref = null;           
        }
        else 
        {
            String comtext = ApexPages.currentPage().getParameters().get('comments');
            System.debug('comtext--->'+comtext);
            String optyid = ApexPages.currentPage().getParameters().get('CF00N80000004IXXz_lkid');
            String optyname = ApexPages.currentPage().getParameters().get('CF00N80000004IXXz');
            System.debug('Opty name --->'+optyname);
            if(related)
            {
                gspobdm = true;
                pageref = null;
            }
            //mkella - DE253169 Start changes
            // for other record types and check if user is in lightning experience
            else if((comtext == null || comtext == '') && ((optyid != null || optyid != '') && (optyname != null || optyname != '')) && (UserInfo.getUiThemeDisplayed() == 'Theme4d' || UserInfo.getUiThemeDisplayed() == 'Theme4u'))
            {
                isLightningOptyId = true;
                //added by Kavya
               //If default setting for user is selected , then it should navigate to lcd opportunity recordtype , so hardcoding that value
				if(Recordtype == null)
                	defaultRecordtype = Utilities.getNBMQualificationId();
                //ends here
                pageref = null;
                
            }
            //mkella- DE253169 End changes
            else if(comtext == null || comtext == '')
            {
                if((optyid == null || optyid == '')&&(optyname == null || optyname == ''))
                    pageref = new PageReference('/a1B/e?retURL='+retURL+'&RecordType='+Recordtype+'&ent='+ent+'&00N80000004IXYL='+quallification.Theater__c+'&CF00N80000004IXY8_lkid='+quallification.Requester_Name__c+'&CF00N80000004IXY8='+UserInfo.getName());
                else if((optyid != null || optyid != '') && (optyname != null || optyname != ''))
                    //System.debug('I am in exact logic');
                    pageref = new PageReference('/a1B/e?retURL='+retURL+'&RecordType='+Recordtype+'&ent='+ent+'&00N80000004IXYL='+quallification.Theater__c+'&CF00N80000004IXY8_lkid='+quallification.Requester_Name__c+'&CF00N80000004IXY8='+UserInfo.getName()+'&CF00N80000004IXXz='+optyname+'&CF00N80000004IXXz_lkid='+optyid);
                gspobdm = true;
                pageref.getParameters().put('retURL', retURL);
                pageref.getParameters().put('RecordType', Recordtype);
                pageref.getParameters().put('cancelURL', cancelURL);
                pageref.getParameters().put('ent', ent);
                pageref.getParameters().put('_CONFIRMATIONTOKEN', confirmationToken);
                pageref.getParameters().put('save_new_url', saveNewURL);
                pageref.getParameters().put('nooverride', '1');
                //System.debug('Page reference URL: '+pageref);
            }
            else if(comtext != null || comtext != '')        
            {      
                if((comtext != null || comtext != '') && comtext.contains('CreateOppty'))               
                    pageref = attachopty2();
                else if(comtext == null || comtext == '')
                    pageref = null; 
            }
        } 
        return pageref; 
    }
    
    ///////////////////Redirection to GSPO Detail page based on the corresponding RecordTypeId/////////////////////
    //.............................................ACTION METHODS............................................... 
    public PageReference attachopty2(){    
        gspobdm = false;    
       // isLightng = false; 
       // SCAVA FIX
        if(flsGet(Opportunity.Name))
        {
        optyvar.Name=quallification.Name;
        }
        if(flsGet(Opportunity.CloseDate))
        {
        optyvar.CloseDate = quallification.Solution_Delivery__c;
        }
        if(flsGet(Opportunity.Expected_Product__c))
        {
        optyvar.Expected_Product__c= quallification.Total_Product_Size__c;
        }
        if(flsGet(Opportunity.Expected_Service__c))
        {
        optyvar.Expected_Service__c= quallification.Total_Service_Size__c;    
        }
        if(flsGet(Opportunity.StageName))
        {
        optyvar.StageName= '1 - Prospect';
        }
        if(flsGet(Opportunity.Competitors__c))
        {
        optyvar.Competitors__c= 'Competitors';
        }
        if(flsGet(Opportunity.Position__c))
        {
        optyvar.Position__c='None'; 
        }
        if(flsGet(Opportunity.Theater__c))
        {
        optyvar.Theater__c = quallification.Theater__c;    
        }
        try
        {
          Utilities.setSkip(true);
          Utilities.setValidationSkip(true);  
          insert optyvar;
        }
        catch(Exception e)
        {            
            return null;
        }  
        // SCAVA FIX
        if(flsUpdate(Qualification__c.Opportunity__c))
        {
        quallification.Opportunity__c = optyvar.Id;
        }
        update quallification;    
        String hostname = ApexPages.currentPage().getHeaders().get('Host');     
        String optyURL2 = 'https://'+hostname+'/'+optyvar.Id+'/e?retURL='+lId;
        System.debug('Opty URl 2: '+optyURL2);
        pagereference pageref = new pagereference(optyURL2);
        pageref.setredirect(true);
        return pageref;    
    } 
}