trigger P360_ReassignLeadsandTPsonDeactivedUser on User (before update) {

  set<id> setUser = new set<id>();
        //if(P360_PartnerPortalUserOnboardingRedesign.inFutureContext != Null)
        //{
           if(!P360_PartnerPortalUserOnboardingRedesign.inFutureContext)
           {
               for(user usr:Trigger.new)
              {
                if(!usr.IsActive && usr.contactid != null)
                {
                    setUser.add(usr.id);
                }
              }
              if(!setUser.isEmpty()) 
              {
                P360_ReassignLeadsandTPsonDeactivedUser.ReassignLeadsandTPsFuture(setUser);
              }
          }
     //  }
}