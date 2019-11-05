public class OpptyGetDealId{

    // SCAVA Helper Method to validate Update Access at field level
     public static Boolean flsUpdateGet(SObjectField field)
    {
        return field.getDescribe().isUpdateable() ? true : false;
    }
     // SCAVA Helper Method to validate Create Access at field level
     public static Boolean flsGet(SObjectField field)
    {
        return field.getDescribe().isCreateable() ? true : false;
    }
     public static void assignDealids(Map<id,Opportunity> mapOptysObj){
     
    
        List<Opportunity> lstOpty = new List<Opportunity>();
        List<Opptys_Requiring_DealIDs__c> failureList = new List<Opptys_Requiring_DealIDs__c>();
        for(Opportunity o3: mapOptysObj.values()){            
             String logName;             
            if(o3.DealID__c == null && o3.dealID_AutoNum__c != null){
                Decimal opptyAutoNum = decimal.valueOf(o3.dealID_AutoNum__c);                
                Deal_ID_Queue__c mc = Deal_ID_Queue__c.getValues('Deal ID Queue 1');               
                Double endNum = mc.Deal_ID_Queue_Stop__c;
                Double startNum = mc.Deal_ID_Queue_Start__c;
                
                if(endNum-startNum <=0 || endNum <=0 || startNum <=0){
                    logName ='Denominator Zero - Deal ID Assignment Error';
                    opportunity opp = new opportunity(id=o3.Id); 
                    if(flsUpdateGet(opportunity.Deal_ID_Stack_Has_Error__c)||flsGet(opportunity.Deal_ID_Stack_Has_Error__c))           //SCAVA FIX 
                    {
                    opp.Deal_ID_Stack_Has_Error__c = true;
                    }
                    insertMailRecord(logName, o3.dealID_AutoNum__c);
                    Opptys_Requiring_DealIDs__c failure = new Opptys_Requiring_DealIDs__c(); 
                    if(flsUpdateGet(Opptys_Requiring_DealIDs__c.error__c)||flsGet(Opptys_Requiring_DealIDs__c.error__c)) //SCAVA FIX
                {
                    failure.error__c='Class.OpptyGetDealId';
                }
                if(flsUpdateGet(Opptys_Requiring_DealIDs__c.Opportunity__c)||flsGet(Opptys_Requiring_DealIDs__c.Opportunity__c)) //SCAVA FIX
                {
                    failure.Opportunity__c=o3.Id;
                }
                    failureList.add(failure);
                    lstOpty.add(opp);
                }
               
                else {
                    if((!(opptyAutoNum < startNum || opptyAutoNum > endNum)) && opptyAutoNum <= endNum && !o3.Deal_ID_Stack_Has_Error__c){ //&& stack has error is false (F)){ //check to see if the AutoNum is within the Queue.                          
                        opportunity opp = new opportunity(id=o3.Id);
                        if(flsUpdateGet(opportunity.DealID__c)||flsGet(opportunity.DealID__c))           //SCAVA FIX 
                    {
                        opp.DealID__c = o3.dealID_AutoNum__c; 
                    }                       
                        validateDealId(o3.dealID_AutoNum__c); //call the threshold class 
                         if(flsUpdateGet(opportunity.Deal_Id_Status__c)||flsGet(opportunity.Deal_Id_Status__c))           //SCAVA FIX 
                    {
                        opp.Deal_Id_Status__c = 'Obtained (' + o3.dealID_AutoNum__c + ')'; 
                    }                       
                        lstOpty.add(opp);                       
                    }
                    else{
                        opportunity opp = new opportunity(id=o3.Id);
                        logName ='Deal ID out of bounds';                           
                        insertMailRecord(logName, o3.dealID_AutoNum__c); 
                        opp.Deal_ID_Stack_Has_Error__c = true;   
                        Opptys_Requiring_DealIDs__c failure = new Opptys_Requiring_DealIDs__c(); 
                if(flsUpdateGet(Opptys_Requiring_DealIDs__c.error__c)||flsGet(Opptys_Requiring_DealIDs__c.error__c)) //SCAVA FIX
                {
                failure.error__c='Class.OpptyGetDealId';
                }
                if(flsUpdateGet(Opptys_Requiring_DealIDs__c.Opportunity__c)||flsGet(Opptys_Requiring_DealIDs__c.Opportunity__c)) //SCAVA FIX
                {
                failure.Opportunity__c=o3.Id;
                }
                        failureList.add(failure); 
                        lstOpty.add(opp);                       
                    }
                }
            }
            else{
                logName ='Deal ID Not Previously Assigned';
                insertMailRecord(logName, o3.dealID_AutoNum__c);                        
                Opptys_Requiring_DealIDs__c failure = new Opptys_Requiring_DealIDs__c(); 
                if(flsUpdateGet(Opptys_Requiring_DealIDs__c.error__c)||flsGet(Opptys_Requiring_DealIDs__c.error__c)) //SCAVA FIX
                {
                failure.error__c='Class.OpptyGetDealId';
                }
                if(flsUpdateGet(Opptys_Requiring_DealIDs__c.Opportunity__c)||flsGet(Opptys_Requiring_DealIDs__c.Opportunity__c)) //SCAVA FIX
                {
                failure.Opportunity__c=o3.Id;
                }
                failureList.add(failure);                 
            }
        }            
        if(!lstOpty.isEmpty()){
            update lstOpty;
        }
        if(!failureList.isEmpty()){
            insert failureList;
        }
    }   
  
    
    public static void validateDealId(String AutoNum){

      //Retrieve custom settings value for the queue stack. Retrieve the stop date.
       Deal_ID_Queue__c mc = Deal_ID_Queue__c.getValues('Deal ID Queue 1');
       Decimal endNum = mc.Deal_ID_Queue_Stop__c;
       Decimal startNum = mc.Deal_ID_Queue_Start__c;
       String logName; //String to use as Name field for TX_Log to be used in mailer as indicator for which threshold hit. 
       Double newDealID = double.valueOf(AutoNum);                       
        Deal_ID_Thresholds__c dt = Deal_ID_Thresholds__c.getValues('Deal ID Queue Thresholds 1'); //Get values for custom setting email tracker             
       Decimal numerator = (newDealID - startNum).setScale(2);
       Decimal denominator = (endNum - startNum).setScale(2);
       Decimal fraction = (numerator/denominator).setScale(2);
       Decimal percentUtilized = ((fraction)*100).setScale(2);
      
       try{ 
           
            //built in logic to see if a record is in Threshold Custom Setting (70, 80, 90%), if Threshold field is empty insert new record in Tx_Log__c which will trigger mailer workflow                   
            if(percentUtilized >= 70.00 && percentUtilized < 80.00){ 
                if(!dt.Seventy_Percent_Email__c){ 
                   if(flsUpdateGet(Deal_ID_Thresholds__c.Seventy_Percent_Email__c)||flsGet(Deal_ID_Thresholds__c.Seventy_Percent_Email__c))          //SCAVA FIX 
                    {               
                    dt.Seventy_Percent_Email__c = true;
                    }
                    if(flsUpdateGet(Deal_ID_Thresholds__c.Seventy_Percent_Email_Date__c)||flsGet(Deal_ID_Thresholds__c.Seventy_Percent_Email_Date__c))           //SCAVA FIX 
                    {
                    dt.Seventy_Percent_Email_Date__c = Date.today();
                    }
                    logName = '70 Deal ID Percent Threshold Hit';
                    insertMailRecord(logName, AutoNum);
                    update dt;
                }
            }                                   
            else if (percentUtilized >=80.00 && percentUtilized <90.00){                                  
                if(!dt.Eighty_Percent_Email__c){
                if(flsUpdateGet(Deal_ID_Thresholds__c.Eighty_Percent_Email__c)||flsGet(Deal_ID_Thresholds__c.Eighty_Percent_Email__c))          //SCAVA FIX 
                    {
                    dt.Eighty_Percent_Email__c = true;
                    }
                    if(flsUpdateGet(Deal_ID_Thresholds__c.Eighty_Percent_Email_Date__c)||flsGet(Deal_ID_Thresholds__c.Eighty_Percent_Email_Date__c))          //SCAVA FIX 
                    {
                    dt.Eighty_Percent_Email_Date__c = Date.today();
                    }
                    logName = '80 Deal ID Percent Threshold Hit';
                    insertMailRecord(logName, AutoNum);
                    update dt;
                }
            }                                   
            else if(percentUtilized >=90.00 && percentUtilized < 100.00){                  
                if(!dt.Ninety_Percent_Email__c){
                if(flsUpdateGet(Deal_ID_Thresholds__c.Ninety_Percent_Email__c)||flsGet(Deal_ID_Thresholds__c.Ninety_Percent_Email__c))            //SCAVA FIX 
                    {
                    dt.Ninety_Percent_Email__c = true;
                    }
                    if(flsUpdateGet(Deal_ID_Thresholds__c.Ninety_Percent_Email_Date__c)||flsGet(Deal_ID_Thresholds__c.Ninety_Percent_Email_Date__c))           //SCAVA FIX 
                    {
                    dt.Ninety_Percent_Email_Date__c = Date.today();
                    }
                    logName = '90 Deal ID Percent Threshold Hit';
                    insertMailRecord(logName, AutoNum);
                    update dt;                   
                }
                //Special condition for 90 percent. Since we want an email to go out daily while queue is 
                //still in 90% consumption and the mail checkbox has been checked, the date is evaluated 
                //to see if an email has been sent that day. If not, send another email. 
                else if(dt.Ninety_Percent_Email__c  && dt.Ninety_Percent_Email_Date__c < Date.today()){
                    if(flsUpdateGet(Deal_ID_Thresholds__c.Ninety_Percent_Email_Date__c )||flsGet(Deal_ID_Thresholds__c.Ninety_Percent_Email_Date__c))            //SCAVA FIX 
                    {
                    dt.Ninety_Percent_Email_Date__c = Date.today();
                    }
                    logName = '90 Deal ID Percent Threshold Hit'; //add iterative number or percentage change by day *
                    insertMailRecord(logName, AutoNum);
                    update dt;                 
                 }  
            }
        }catch(MathException ex){ 
            //This exception will be called if the denominator is zero               
            logName = 'Denominator Zero Math Error';
            insertMailRecord(logName, AutoNum);
        }                      
    }

    //This method will create a new Tx Log Record when a threshold is met. 
    public static void insertMailRecord(String logName, String autoNumber){
        List<Tx_Log__c> txList = new List<Tx_Log__c>();        
        Tx_Log__c txRec = new Tx_Log__c();
        if(flsUpdateGet(Tx_Log__c.name)||flsGet(Tx_Log__c.name)) //SCAVA FIX
        {
        txRec.name = logName;
        }
        if(flsUpdateGet(Tx_Log__c.originated__c)||flsGet(Tx_Log__c.originated__c)) //SCAVA FIX
        {
        txRec.originated__c = 'OptyGetDealID Class';
        }
        if(flsUpdateGet(Tx_Log__c.type__c)||flsGet(Tx_Log__c.type__c)) //SCAVA FIX
        {
        txRec.type__c = 'Mailer flag';
        }
        if(flsUpdateGet(Tx_Log__c.exception__c)||flsGet(Tx_Log__c.exception__c)) //SCAVA FIX
        {
        txRec.exception__c = false;
        }
        if(logname.containsIgnoreCase('Deal ID Percent Threshold')){
             if(flsUpdateGet(Tx_Log__c.message__c)||flsGet(Tx_Log__c.message__c)) //SCAVA FIX
             {
             txRec.message__c = 'This email was sparked by a flag change in OptyGetDealId class when an AutoNumber from the queue has reached a consumption threshold. The Deal ID that invoked the workflow is ' + autoNumber;
             }
        }
        else if(logname.containsIgnoreCase('Deal Id Not Previously')){
             if(flsUpdateGet(Tx_Log__c.message__c)||flsGet(Tx_Log__c.message__c)) //SCAVA FIX
            {
            txRec.message__c = 'This log was sparked by a legacy Oppty with no Deal Id previously assigned.';
            }
        }
        else{
            if(flsUpdateGet(Tx_Log__c.message__c)||flsGet(Tx_Log__c.message__c)) //SCAVA FIX
             {
            txRec.message__c = 'This email was sparked by a MATH EXCEPTION on DIVISION BY ZERO. The Deal ID last used was ' + autoNumber +'. Refer to custom setting field for Deal ID Queue Start and Stop values for further information on the error. \n';
              }
        }
            txList.add(txRec);        
        Database.SaveResult[] txListInsertResult = Database.insert(txList, false);        
    }
}