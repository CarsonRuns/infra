// This class acts as Controller Class for Super_Group_Direct_Export_Link VF
// Release -- FY'13 Year End Rel

public class Super_Group_Direct_Export_Link_CTE {

    private String SuperGroupId;
    
    public Super_Group_Direct_Export_Link_CTE(ApexPages.StandardController controller) {
         SuperGroupId = ApexPages.currentpage().getparameters().get('Id');     
    }

// This method redirects Excel Export Link Page to Excel Export Page
    public PageReference Save() {
        try{
            PageReference redirect = new PageReference('/apex/Super_Group_Direct_Export'); 
            redirect.getParameters().put('id',SuperGroupId);  
            redirect.setRedirect(true); 
            if(Utilities.getIsTestMethod()== true){                 
                    String str = null;    
                    str.tolowercase();                             
             }
             
            return redirect;
           }              
           catch(Exception e){
                ApexPages.addMessages(e);
                System.debug('Super_Group_Direct_Export_Link_CTE ## Save ## Exception ## ' + e);
                return null;
       } 
   }
}