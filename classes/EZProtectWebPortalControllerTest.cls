@istest
public class EZProtectWebPortalControllerTest 
{
       static testMethod void getEZProtectBaseURLTest()
       {
           EZProtectWebPortalController controller = new EZProtectWebPortalController();
            string url = controller.getEZProtectBaseURL();
           
           url = controller.getEZProtectBaseURL();
           
           System.assertNotEquals(null, url);
       }
}