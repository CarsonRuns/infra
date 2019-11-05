public class SPLink{

public list<configuration_development_only__c> newobj = new list<configuration_development_only__c>();

public String cuc {get;set;}

public Integer delim1;

public Integer delim2;

public Integer delim3;

public Integer delim4;

public Integer delim5;

public Integer getDelim1(){
return delim1;
}

public Integer getDelim2(){
return delim2;
}

public Integer getDelim3(){
return delim3;
}

public Integer getDelim4(){
return delim4;
}

public Integer getDelim5(){
return delim5;
}


public List<SPLinks__c> mcs = SPLinks__c.getall().values();

public list<configuration_development_only__c> getNewobj() {
        
        if(cuc != null && newobj.size()==0)
        {
            String cucval = cuc;
                        
            for(Integer i =0 ; i< mcs.size() ; i++)
            {
                if(cucval!=null && cucval.contains(mcs.get(i).Name))
                {
                    configuration_development_only__c obj = new configuration_development_only__c();
                    if(mcs.get(i).SP_URL_1__c != null && mcs.get(i).SP_URL_1__c != '')
                    {
                        obj.text_2__c = mcs.get(i).SP_URL_1__c;
                        delim1 = mcs.get(i).SP_URL_1__c.indexOf('*');
                    }
                    if(mcs.get(i).SP_URL_2__c != null && mcs.get(i).SP_URL_2__c != '')
                    {
                        obj.text_3__c = mcs.get(i).SP_URL_2__c;
                        delim2 = mcs.get(i).SP_URL_2__c.indexOf('*');
                    }
                    if(mcs.get(i).SP_URL_3__c != null && mcs.get(i).SP_URL_3__c != '')
                    {
                        obj.text_4__c = mcs.get(i).SP_URL_3__c;
                        delim3 = mcs.get(i).SP_URL_3__c.indexOf('*');
                    
                    }
                    if(mcs.get(i).SP_URL_4__c != null && mcs.get(i).SP_URL_4__c != '')
                    {
                        obj.text_5__c = mcs.get(i).SP_URL_4__c;
                        delim4 = mcs.get(i).SP_URL_4__c.indexOf('*');
                    }
                    if(mcs.get(i).SP_URL_5__c != null && mcs.get(i).SP_URL_5__c != '')
                    {
                        obj.text_6__c = mcs.get(i).SP_URL_5__c;
                        delim5 = mcs.get(i).SP_URL_5__c.indexOf('*');
                    }    
                               
                    newobj.add(obj);
                }
            } 
         }
       
        return newobj;
    }
    
    public static testMethod void test_SPLink(){
    
    Test.StartTest();
    
    SPLink controller1 = new SPLink();
    controller1.cuc = 'Carrier Ethernet - Aggregation & Pre-Agg';
    controller1.getDelim1();
    controller1.getDelim2();
    controller1.getDelim3();
    controller1.getDelim4();
    controller1.getDelim5();
    controller1.getNewobj();
    
    Test.StopTest();
    }
}