global with sharing class ModifyUserForecastCtrl 
{
    // SCAVA Helper Method to validate Update Access at field level
     public static Boolean flsUpdate(SObjectField field)
    {
        return field.getDescribe().isUpdateable() ? true : false;
    }
    public List<SelectOption> myList {get;set;}
    public string defaultChoice {get;set;}
    public User u;
    public ModifyUserForecastCtrl() 
    {
        pullCurrent();
    }

    public void pullCurrent()
    {
        myList = new List<SelectOption>();
        u = [select Default_Position__c, Position_1__c from user where id=:UserInfo.getUserID()];
        //u = [select Default_Position__c, Position_1__c from user where id='00580000003G25nAAC'];
        if(u.Default_Position__c!=null & u.Default_Position__c!='')
        {
            myList.add(new selectOption(u.Default_Position__c.trim(),u.Default_Position__c.trim()));
        }

        if(u.Position_1__c!=null && u.Position_1__c!='')
        {
            List<String> myPositions =  u.Position_1__c.split('\n');
            //myPositions.sort();
            for(String item: myPositions)
            {
                if(item.trim()!=u.Default_Position__c)
                {
                    myList.add(new selectOption(item.trim(),item.trim()));
                }
            } 
        }
    }

    public pagereference newdefault()
    {
        //SCAVA FIX
               if(flsUpdate(User.Default_Position__c))
                {
                    u.Default_Position__c = defaultChoice;
                }
        update u;
        pullCurrent();
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.defaultForecastingPositionSaved ));
        return null;
    }
    
    @RemoteAction
    global static void updateDefaultForecastingPosition(String forecastingPosition) {
        User u = [select Default_Position__c, Position_1__c from user where id=:UserInfo.getUserID()];
        u.Default_Position__c = forecastingPosition;
        update u;
        ApexPages.addmessage(new ApexPages.message(ApexPages.severity.INFO,Label.defaultForecastingPositionSaved ));
    }
}