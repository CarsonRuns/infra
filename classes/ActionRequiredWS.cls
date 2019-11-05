global class ActionRequiredWS { 

    global class Action {
        webservice String url;
        webservice String count;
        webservice String description;
    }   
   
    WebService static Action[] getActionMessages(){
       
        Action[] actions = new Action[]{}; 
        HomePageMsg_CT hp = new HomePageMsg_CT();
        
        String overDueUrl = '/006?fcf=00B80000006PlIK';
        //String mdmQualFormUrl = '/apex/MDMAuto';
        String over30DayDueUrl = '/006?fcf=00B80000006PlQM';
        //String missingFieldsUrl = '/00O800000033XUc';  
        //String uncovertedPartnerUrl = '/006/o';
        
        Integer overDueCount = hp.getOverDueOpptysLt30Days();       
        //Integer mdmQualCount = hp.getMdmQualFormOpptys();
        Integer over30DayCount = hp.getOverDueOpptys();
       // Integer missingFieldCount = hp.getMissingFieldOpptys();
       // Integer unconvertedCount = hp.getUnconvertedOpptys();
        
        String over30DayCol = 'Overdue Opportunity(s) are Preventing Forecasting.  Expected Book Date that is greater than 30 days overdue';
        //String mdmQualFormCol = 'Opportunity(s) Have a MDM Qualification Submitted.  Recommended to move to Stage 3';                
        String overDueCol = 'Opportunity(s) have an Overdue Expected Book Date.  Expected Book Date that is between 14 days and 30 days overdue';       
        String missingFieldCol = 'Opportunity(s) with Missing Partners';
        //String unconvertedPartnerCol = 'Partner Opportunity(s) are ready for Conversion';

        Action over30DayDue = new Action();
            over30DayDue.url = over30DayDueUrl;
            over30DayDue.count = String.valueOf(over30DayCount);
            over30DayDue.description = over30DayCol;   
        actions.add(over30DayDue);  

        Action overDue = new Action();
            overDue.url = overDueUrl;
            overDue.count = String.valueOf(overDueCount);
            overDue.description = overDueCol;
        actions.add(overDue); 
        
        //Action mdmQualForm = new Action();
          //  mdmQualForm.url = mdmQualFormUrl;
            //mdmQualForm.count = String.valueOf(mdmQualCount);
            //mdmQualForm.description = mdmQualFormCol;   
        //actions.add(mdmQualForm);
                
        /*Action missingField = new Action();
            missingField.url = missingFieldsUrl;
            //missingField.count = String.valueOf(missingFieldCount);
            missingField.description = missingFieldCol;
        actions.add(missingField);   
        */
        /*Action unconverted = new Action();
            unconverted.url = uncovertedPartnerUrl;
           // unconverted.count = String.valueOf(unconvertedCount);
            unconverted.description = unconvertedPartnerCol;
        actions.add(unconverted);                   
        */
        return actions;
           
    }
    
    public static testMethod void test_ActionRequiredWS(){
        getActionMessages();
    }

    
}