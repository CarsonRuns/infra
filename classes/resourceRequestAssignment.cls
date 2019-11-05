/****************************************************************************************************
* Description - To Check the Permission for Resource Request Assignment 
* Author - Naresh Kalahasthi(nkalahas@cisco.com)
****************************************************************************************************/
public class resourceRequestAssignment{
    
    
    public boolean permissionflag { get; set; }
    public resourceRequestAssignment(ApexPages.StandardController controller) {
        
        
        list<user> raeWorkspace = [select Additional_User_Permissions__c from user where id =: UserInfo.getUserId()];
        
        if(raeWorkspace[0].additional_user_permissions__c == null)
        {
            permissionflag = false;
        }
        
        else { 
            string  split_val = raeWorkspace[0].Additional_User_Permissions__c; 
            List<string> split_val1 = split_val.split(';'); 
            for (integer i=0; i< split_val1.size(); i++) { 
                if(split_val1[i] == 'SE User') { 
                    permissionflag = true; 
                    
                    
                    break; 
                } 
                
            }
            
        }
        
    }
        
}