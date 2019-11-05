global class ATFunnelWS { 
       
    global class MyATTech {
        webservice String Technology;
        webservice Integer Stage1NotForecastable;
        webservice Integer Stage2Upside;
        webservice Integer Stage2Commit;
        webservice Integer Stage3Upside;
        webservice Integer Stage3Commit;
        webservice Integer Stage4Upside;
        webservice Integer Stage4Commit;
        webservice Integer Stage5Upside;
        webservice Integer Stage5Commit;
    }
   
    WebService static MyATTech[] getATFunnel(){
        
        Map<String,Integer[]> m = new Map<String, Integer[]>();
        String commitStatus = 'Commit';
        String upsideStatus = 'Upside';
        MyATTech[] ATsums = new MyATTech[]{};
        
        for(AT_Workspace__c w: [Select AT_Technology__c, AT_Expected_Product__c, Stage__c, AT_Forecast_Status__c From AT_Workspace__c Where PSS__c= :UserInfo.getUserId() and Opportunity_Status__c = 'Active' and (AT_Expected_Book_Date__c = THIS_FISCAL_QUARTER OR  AT_Expected_Book_Date__c = NEXT_FISCAL_QUARTER)]){
            
            if(m.containsKey(w.AT_Technology__c)){
                if(w.Stage__c.contains('1'))
                    m.get(w.AT_Technology__c)[0] += integer.valueOf(String.valueOf(w.AT_Expected_Product__c));
                else if(w.Stage__c.contains('2') && w.AT_Forecast_Status__c == upsideStatus)
                    m.get(w.AT_Technology__c)[1] += integer.valueOf(String.valueOf(w.AT_Expected_Product__c)); 
                else if(w.Stage__c.contains('2') && w.AT_Forecast_Status__c == commitStatus)
                    m.get(w.AT_Technology__c)[2] += integer.valueOf(String.valueOf(w.AT_Expected_Product__c));      
                else if(w.Stage__c.contains('3') && w.AT_Forecast_Status__c == upsideStatus)
                    m.get(w.AT_Technology__c)[3] += integer.valueOf(String.valueOf(w.AT_Expected_Product__c));
                else if(w.Stage__c.contains('3') && w.AT_Forecast_Status__c == commitStatus)
                    m.get(w.AT_Technology__c)[4] += integer.valueOf(String.valueOf(w.AT_Expected_Product__c));      
                else if(w.Stage__c.contains('4') && w.AT_Forecast_Status__c == upsideStatus)
                    m.get(w.AT_Technology__c)[5] += integer.valueOf(String.valueOf(w.AT_Expected_Product__c));
                else if(w.Stage__c.contains('4') && w.AT_Forecast_Status__c == commitStatus)
                    m.get(w.AT_Technology__c)[6] += integer.valueOf(String.valueOf(w.AT_Expected_Product__c)); 
                else if(w.Stage__c.contains('5') && w.AT_Forecast_Status__c == upsideStatus)
                    m.get(w.AT_Technology__c)[7] += integer.valueOf(String.valueOf(w.AT_Expected_Product__c));
                else if(w.Stage__c.contains('5') && w.AT_Forecast_Status__c == commitStatus)
                    m.get(w.AT_Technology__c)[8] += integer.valueOf(String.valueOf(w.AT_Expected_Product__c));     
            }
            else{
                String Technology = w.AT_Technology__c;
                Integer Stage1NotForecastable = 0;
                Integer Stage2Upside = 0;
                Integer Stage2Commit = 0;
                Integer Stage3Upside = 0;
                Integer Stage3Commit = 0;
                Integer Stage4Upside = 0;
                Integer Stage4Commit = 0;
                Integer Stage5Upside = 0;
                Integer Stage5Commit = 0;
                
                if(w.Stage__c.contains('1'))
                    Stage1NotForecastable = integer.valueOf(String.valueOf(w.AT_Expected_Product__c));
                else if(w.Stage__c.contains('2') && w.AT_Forecast_Status__c == upsideStatus)
                    Stage2Upside = integer.valueOf(String.valueOf(w.AT_Expected_Product__c)); 
                else if(w.Stage__c.contains('2') && w.AT_Forecast_Status__c == commitStatus)
                    Stage2Commit = integer.valueOf(String.valueOf(w.AT_Expected_Product__c));      
                else if(w.Stage__c.contains('3') && w.AT_Forecast_Status__c == upsideStatus)
                    Stage3Upside = integer.valueOf(String.valueOf(w.AT_Expected_Product__c));
                else if(w.Stage__c.contains('3') && w.AT_Forecast_Status__c == commitStatus)
                    Stage3Commit = integer.valueOf(String.valueOf(w.AT_Expected_Product__c));      
                else if(w.Stage__c.contains('4') && w.AT_Forecast_Status__c == upsideStatus)
                    Stage4Upside = integer.valueOf(String.valueOf(w.AT_Expected_Product__c));
                else if(w.Stage__c.contains('4') && w.AT_Forecast_Status__c == commitStatus)
                    Stage4Commit = integer.valueOf(String.valueOf(w.AT_Expected_Product__c)); 
                else if(w.Stage__c.contains('5') && w.AT_Forecast_Status__c == upsideStatus)
                    Stage5Upside = integer.valueOf(String.valueOf(w.AT_Expected_Product__c));
                else if(w.Stage__c.contains('5') && w.AT_Forecast_Status__c == commitStatus)
                    Stage5Commit = integer.valueOf(String.valueOf(w.AT_Expected_Product__c)); 
                
                Integer[] dollarSums = new Integer[]{Stage1NotForecastable,Stage2Upside,Stage2Commit,Stage3Upside,Stage3Commit,Stage4Upside,Stage4Commit,Stage5Upside,Stage5Commit};
                
                m.put(Technology,dollarSums);
                             
            }
            
        }
        
        for(String Tech: m.keySet()){  
          
            MyATTech at = new MyATTech();
            
            at.Technology = Tech;
            at.Stage1NotForecastable= m.get(Tech)[0];
            at.Stage2Upside= m.get(Tech)[1];
            at.Stage2Commit= m.get(Tech)[2];
            at.Stage3Upside= m.get(Tech)[3];
            at.Stage3Commit= m.get(Tech)[4];
            at.Stage4Upside= m.get(Tech)[5];
            at.Stage4Commit= m.get(Tech)[6];
            at.Stage5Upside= m.get(Tech)[7];
            at.Stage5Commit= m.get(Tech)[8];
            
            ATsums.add(at);            
        }

        return ATsums;
        
   }
   
   public static testMethod void test_ActionRequiredWS(){
       
        Opportunity oppty1 = new Opportunity(name='Test1',StageName='1 - Prospect',CloseDate= System.today());
        Opportunity oppty3 = new Opportunity(name='Test3',StageName='2 - Qualification',CloseDate= System.today());
        Opportunity oppty5 = new Opportunity(name='Test5',StageName='3 - Proposal',CloseDate= System.today());
        Opportunity oppty7 = new Opportunity(name='Test7',StageName='4 - Agreement',CloseDate= System.today());
        Opportunity oppty9 = new Opportunity(name='Test9',StageName='5 - Closed Won',CloseDate= System.today());
       
        Opportunity[] opptyArray = new Opportunity[]{oppty1,oppty3,oppty5,oppty7,oppty9};

        Database.SaveResult[]  result = Database.Insert(opptyArray);
        
        AT_Workspace__c[] workspaceArray = new AT_Workspace__c[]{};
        
        for(Database.SaveResult o : result){
            AT_Workspace__c temp = new AT_Workspace__c(AT_Technology__c='UC',AT_Expected_Product__c=integer.valueOf(2),PSS__c=UserInfo.getUserId(),AT_Expected_Book_Date__c=System.today(),AT_Forecast_Status__c='Upside',Opportunity__c=o.Id);
            AT_Workspace__c temp2 = new AT_Workspace__c(AT_Technology__c='UC',AT_Expected_Product__c=integer.valueOf(2),PSS__c=UserInfo.getUserId(),AT_Expected_Book_Date__c=System.today(),AT_Forecast_Status__c='Commit',Opportunity__c=o.Id);
            workspaceArray.add(temp);
            workspaceArray.add(temp2);
            
            AT_Workspace__c temp3 = new AT_Workspace__c(AT_Technology__c=o.id,AT_Expected_Product__c=integer.valueOf(2),PSS__c=UserInfo.getUserId(),AT_Expected_Book_Date__c=System.today(),AT_Forecast_Status__c='Upside',Opportunity__c=o.Id);
            AT_Workspace__c temp4 = new AT_Workspace__c(AT_Technology__c=o.id+'ANS',AT_Expected_Product__c=integer.valueOf(2),PSS__c=UserInfo.getUserId(),AT_Expected_Book_Date__c=System.today(),AT_Forecast_Status__c='Commit',Opportunity__c=o.Id);
            workspaceArray.add(temp3);
            workspaceArray.add(temp4);   
        }
        
        Insert workspaceArray;
       
        getATFunnel();
   }

}