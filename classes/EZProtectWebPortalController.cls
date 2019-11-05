public class EZProtectWebPortalController 
{
    public string getEZProtectBaseURL()
    {
         List<EZProtect_Setting__mdt> setting = new List<EZProtect_Setting__mdt>([SELECT ID, EZProtectBaseURL__c FROM EZProtect_Setting__mdt]);
         
         if(setting != null && setting.size() > 0)
         {
             return setting[0].EZProtectBaseURL__c;
         }
        
        return null;
    }
}