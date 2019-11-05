//This is a test class for Event Agenda Trigger
@isTest(SeeAllData=true)
private class PEPE_EventAgendaStatus_TestClass {

  static testMethod void PEPE_EventAgendaStatus() {
            
           datetime dtStartRange;
           datetime dtEndRange;
                      
           System.debug ('test -from meg class ');
           // Step 1 Creating the base records                       
           // 1. Inserting Training Event Record 
           PEPE_Training_Event__c teRec = new PEPE_Training_Event__c();
               teRec.Status__c = 'Published';
               teRec.Platform__c = 'Partner Plus Lounge';
               teRec.Training_Event_Name__c = 'test ppl';
               teRec.Geography__c = 'EMEAR';
               teRec.Theater_Region__c = 'North';
               teRec.Country_Cluster__c= 'DENMARK_OPS';
               teRec.Country__c ='Greenland';
               teRec.Duration_Unit__c = 'Hours';
               teRec.Duration_Value__c = 4;
               
               dtStartRange= DateTime.now().addDays(-10);
               teRec.Start_Date_Time__c =dtStartRange;
               //dtEndRange =DateTime.now().addDays(10);
               
               //** AS** Here taking dates in local cariable to compare later use 
               dtEndRange =DateTime.now();
               teRec.End_Date_Time__c =dtEndRange ;
                        
              //try{
                Insert teRec;                                                    
                // }catch(Exception e){}
              System.debug('te id:::'+teRec.id);
           
           //2. A Inserting Agenda Topic record - BLP
           PEPE_Agenda_Topic__c atRec = new PEPE_Agenda_Topic__c();
               atRec.Agenda_Description__c = 'test ppl - agenda desc';
               atRec.Delivery_Team__c = 'Business Learning Partner';   
               atRec.Business_Learning_Partner__c = 'DUMMY';   
               atRec.Agenda__c = 'Test Agenda topic';            
               atRec.Agenda_Status__c = 'Active';
              //try{
                Insert atRec;                                       
                // }catch(Exception e){}
              System.debug('at id:::'+atRec.id);
           
           //2. B Inserting Agenda Topic record - Cisco
           PEPE_Agenda_Topic__c atRec2 = new PEPE_Agenda_Topic__c();
               atRec2.Agenda_Description__c = 'test ppl - agenda desc 2';
               atRec2.Delivery_Team__c = 'Cisco';   
               atRec2.Agenda__c = 'Test Agenda topic 2';            
               atRec2.Agenda_Status__c = 'Active';
              //try{
                Insert atRec2;                                       
                // }catch(Exception e){}
              System.debug('at id:::'+atRec2.id);
            
           
           // 3. A Only if TE and AT Created then proceed - EA BLP  
           //Inserting Event Agenda Record
           PEPE_Event_Agenda__c  eaRec = new PEPE_Event_Agenda__c();
               eaRec.Agenda_Id__c = atRec.id;
               eaRec.Training_Offering_Id__c = teRec.id;
               eaRec.Status__c = 'Created'; 
               
               //** AS**  Spliting dates according to 2 EA records( 5 - 5 days for two records total TE is for 10 days 
                                  
               eaRec.Start_Date_Time__c = dtStartRange;
               eaRec.End_Date_Time__c = dtEndRange.addDays(-5);   
               //try{
                   Insert eaRec;
                 // }catch(Exception e){}
              System.debug('ea id:::'+ eaRec.id);            

//             --> 
           // 3. B Only if TE and AT Created then proceed - EA Cisco
           //Inserting Event Agenda Record
           
           PEPE_Event_Agenda__c  eaRec2 = new PEPE_Event_Agenda__c();
               eaRec2.Agenda_Id__c = atRec2.id;
               eaRec2.Training_Offering_Id__c = teRec.id;
               eaRec2.Status__c = 'Created';                   

               //**AS** dates for next EA records 
               eaRec.Start_Date_Time__c = eaRec.End_Date_Time__c;
               eaRec.End_Date_Time__c = dtEndRange;  
              // eaRec2.Start_Date_Time__c = DateTime.now();
               //eaRec2.End_Date_Time__c = DateTime.now().addDays((1/24)*2);                
              
               //try{
                 //  Insert eaRec2;
                 // }catch(Exception e){}     
             //System.debug('eaRec2 id:::'+ eaRec2.id);

                 
            // 4. A Inserting the Training Request Record PRI=YES
             
                    PEPE_Training_Request__c  trRec = new PEPE_Training_Request__c();
                        //trRec.Status__c = 'Added Into Cart';
                        trRec.Status__c =  'Learning Partner being contacted';
                        trRec.Training_Offering_Id__c = teRec.id;
                        trRec.Country__c='Austria'; 
                        trRec.Primary_request__c = 'Yes'; 
                        trRec.Geography__c = 'EMEAR';
                        trRec.Theatre_Region__c = 'North';
                        trRec.Country_Cluster__c= 'DENMARK_OPS';
                        trRec.country__c = 'Greenland';
                        System.debug('xxxxxxxxxxxxxxx'+teRec.id);                         
                        trRec.Location_details_agreed__c = 'No';
                        trRec.Alternate_Tranining_location_Address__c='ADDRESS';
                        trRec.Alternate_Training_location_City__c ='CITY';
                        trRec.Alternate_Address_1__c = 'ADDR1';
                        trRec.Alternate_Address_2__c = 'ADDR2';
                        trRec.Alternate_Address_3__c = 'ADDR3';
                        trRec.Alternate_Zip_Code__c = 'ZIP';
               
                        Insert trRec;        
                
                    System.debug('tr id:::'+ trRec.id);
             
                    //PEPE_Training_Request__c  trRec = new PEPE_Training_Request__c();
                        //trRec.Status__c = 'Added Into Cart';
                        trRec.Status__c =  'Learning Partner being contacted';
                        /*trRec.Training_Offering_Id__c = teRec.id;
                        trRec.Country__c='Austria'; 
                        trRec.Primary_request__c = 'Yes'; 
                        //trRec.country__c = 'Greenland';
                        System.debug('xxxxxxxxxxxxxxx'+teRec.id);  */   
                        
                    
                        ContextUtility_PEPE.setFirstRunTrue();
  
                        //Update trRec; 
    
                        ContextUtility_PEPE.setFirstRunFalse();
                        
               System.debug(' XXXX 1**');    
            
                test.StartTest();   
                eaRec.Status__c = 'QUOTE ACCEPTED';
                ContextUtility_PEPE.setFirstRunTrue();
                update eaRec;
                
                ContextUtility_PEPE.setFirstRunFalse();
                trRec.Status__c = 'Event Approved';
                ContextUtility_PEPE.setFirstRunTrue();
                update trRec;        
                ContextUtility_PEPE.setFirstRunFalse();
                trRec.Status__c = 'Logistics Confirmed';
                ContextUtility_PEPE.setFirstRunTrue();
                update trRec;         
                System.debug('XXXX 1 Update**'); 
                ContextUtility_PEPE.setFirstRunFalse();
                trRec.Status__c = 'Delivered';
                ContextUtility_PEPE.setFirstRunTrue();
                update trRec;          
                System.debug(' XXXX 2 Update**');      
                ContextUtility_PEPE.setFirstRunFalse();
                 System.debug('Amit XXXX After All Updates**');                                                                                 
                
                PEPE_Training_Request__c  trRec2 = new PEPE_Training_Request__c();
                       // trRec.Status__c = 'Added Into Cart';
                        //trRec2.Status__c =  'Approved';
                        //trRec2.Training_Offering_Id__c = teRec.id;
                        //trRec.Country__c='Poland'; 
                       // trRec2.Primary_request__c = 'No'; 
                       // System.debug('xxxxxxxxxxxxxxx'+teRec.id);  
                        
                        
                        //*****
                        
                       /* trRec2 .Status__c =  'Learning Partner being contacted';
                        trRec2 .Training_Offering_Id__c = teRec.id;
                        trRec.Country__c='Austria'; 
                        trRec2.Primary_request__c = 'Yes'; 
                        trRec.Geography__c = 'EMEAR';
                        trRec2 .Theatre_Region__c = 'North';
                        trRec2 .Country_Cluster__c= 'DENMARK_OPS';
                        trRec2 .country__c = 'Greenland';
                        System.debug('xxxxxxxxxxxxxxx'+teRec.id);                         
                        trRec2 .Location_details_agreed__c = 'No';
                        trRec2 .Alternate_Tranining_location_Address__c='ADDRESS';
                        trRec2.Alternate_Training_location_City__c ='CITY';
                        trRec2 .Alternate_Address_1__c = 'ADDR1';
                        trRec2.Alternate_Address_2__c = 'ADDR2';
                        trRec2.Alternate_Address_3__c = 'ADDR3';
                        trRec2.Alternate_Zip_Code__c = 'ZIP';
                        
                        */
                        //******
                        
                        
                                             
                    //try{
                       //System.debug('A XXXX before Insert**'); 
                        //Insert trRec2;
                      // System.debug('A XXXX after Insert**'); 
                
                /*trRec.Status__c = 'Event Cancelled but Paid';
                ContextUtility_PEPE.setFirstRunTrue();
                update trRec;               
                ContextUtility_PEPE.setFirstRunFalse();
                 */             
                test.stopTest();
            }
    }