// ******** Change History ***********
// 7/14 - Removed beforeAccs method as part of Trigger Factory implementation and moved to AccountServices

public class DelOppAccLead{

  public void beforeOpptys(List<Opportunity> optList) {
  
      Map<string,string> mpstd=new Map<string,string>(); 
      String profileId = Userinfo.getProfileId();
      String profileIds  = profileId.substring(0,15);      
      string accDeleteId = Utilities.getConstant_CS('ProfileIds_for_Delete');      
      string[] accDeleteIds;    
      if(accDeleteId != null){
          accDeleteIds= accDeleteId.split(';');
          for(string stIds:accDeleteIds){
               mpstd.put(stIds,stIds);    
          }    
       }   
      for(Opportunity opp : optList){
          if(!(mpstd.containsKey(profileIds) || mpstd.containsKey(profileId))){  
              opp.addError('You do not have permission to delete the Opportunity. Please contact your Administrator.');          
           }     
      }
   }
 
   public void beforeLeds(List<Lead> LdsList) {
     Map<string,string> mpstd=new Map<string,string>();  
     String profileId = Userinfo.getProfileId();
     String profileIds  = profileId.substring(0,15);      
     string LedDeleteId = Utilities.getConstant_CS('ProfileIds_for_Delete');      
     string[] LedDeleteIds;    
     if(LedDeleteId != null){
          LedDeleteIds= LedDeleteId.split(';');
          for(string stIds:LedDeleteIds){
               mpstd.put(stIds,stIds); 
          }
     }
     for(Lead Leds :LdsList){
         if(!(mpstd.containsKey(profileIds) || mpstd.containsKey(profileId))){
              Leds.addError('You do not have permission to delete the Lead. Please contact your Administrator.');
            
          }
      }
}
}