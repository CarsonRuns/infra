/**
* @Updated      : lakshsur
* @version      : Intial version (1.0)
* @since        : 2015-10-15 (YYYY-MM-DD)
* @description  : condition updated for INC000034062858 (Renamed piklist value as Application optimization (WAAS) Line no. 57 )

*** Change History ***
INC000034062858 - Change the PDI_Level2 from 'WAN Optimization’ to ‘Application optimization (WAAS)’. 
Condition updated for WR-01308 - As part of WR Changed Queue pik list values.

**/
Public class RouteWebCase
{
    
public static void updatePHCase(List<case> PHRouteCases)
{
   for(Case c : PHRouteCases)
    {
    
    if(c.Case_Language__c == 'English')
        c.Queue__c ='PH English Web';
    else    if(c.Case_Language__c == 'Simplified Chinese')
        c.Queue__c ='PH Mandarin';
    else    if(c.Case_Language__c == 'Portuguese (Brazil)')
        c.Queue__c ='PH Portuguese';
    else    if(c.Case_Language__c == 'Spanish (LATAM)')
        c.Queue__c ='PH Spanish';

    else
        c.Queue__c = 'PH '+ c.Case_Language__c;

    c.priority = 'Low';
        if(c.suppliedemail.contains('@cisco.com'))
        {
            c.cisco_contact__c = c.suppliedEmail;
            c.contact_type__c = 'Cisco';          
        }

    }
}    
    
public static void updatePDICase(List<Case> PDIRouteCases)
{
    PDI_Collaboration_Countries__c WestCoutries = PDI_Collaboration_Countries__c.getValues('West') ;
    String CountryValues = WestCoutries.country1__c + WestCoutries.country2__c + WestCoutries.country3__c + WestCoutries.country4__c ;
     for(Case c : PDIRouteCases)
    {
      /* below condition updated for WR-01308*/
      if(c.category_PDI__c == 'Physical Security')
        c.Queue__c ='PDI Borderless Networks';
     else if(c.category_PDI__c == 'Internet of Things')
        c.Queue__c ='PDI Borderless Networks';
     else if(c.category_PDI__c == 'Data Center')
        c.Queue__c ='PDI Data Center';
    /* below condition updated for WR-1063*/
    //INC000034062858 - Changed the Level2 value
      else if(c.category_PDI__c == 'Enterprise Networking' && (c.Category_Level_2_PDI__c == 'Application optimization (WAAS)' || c.Category_Level_4_PDI__c == 'WAAS' || c.Category_Level_4_PDI__c == 'Akamai'))
        c.Queue__c ='PDI Data Center';
      else if(c.category_PDI__c == 'Enterprise Networking')
        c.Queue__c ='PDI Borderless Networks';        
     else if(c.category_PDI__c == 'Collaboration' && CountryValues.Contains(c.country__c))
        c.Queue__c ='PDI Collaboration West';
     else if(c.category_PDI__c == 'Collaboration'&& !CountryValues.Contains(c.country__c))
        c.Queue__c ='PDI Collaboration East';
    /* below condition updated for WR-1131*/
     else if(c.Category_Level_2_PDI__c == 'Smart Net Total Care'){
         c.Queue__c ='PDI Smart Net Total Care';
     } 
     c.priority = 'Low';
     if(c.suppliedemail != null){ 
        if(c.suppliedemail.contains('@cisco.com'))
        {
            c.cisco_contact__c = c.suppliedEmail;
            c.contact_type__c = 'Cisco';          
        }
      }
 
    }
} 
public static void updateTSNCase(List<case> TSNRouteCases)
{
   for(Case c : TSNRouteCases)
    {
        if(c.suppliedemail !=null && c.suppliedEmail !='' && c.suppliedemail.contains('@cisco.com'))
        {
            c.cisco_contact__c = c.suppliedEmail;
            c.contact_type__c = 'Cisco';          
        }
        else
        {
         c.contact_type__c = 'Partner';         
        }

     c.priority = 'Low';
     String dayOfWeek = DateTime.now().format('EEE');
     if(dayOfWeek == 'Fri'){
             c.Requested_Due_Date__c=DateTime.now().addDays(3).addHours(7).date();
       }
     else if(dayOfWeek == 'Sat'){
             c.Requested_Due_Date__c=DateTime.now().addDays(2).addHours(7).date();
       }
     else{
             c.Requested_Due_Date__c=DateTime.now().addDays(1).addHours(7).date();       
         }    
    }    
}  
}