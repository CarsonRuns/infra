public class BTx_Revenue {

    public BTx_Engagement_Activity__c btxa = new BTx_Engagement_Activity__c();
    public BTx_Engagement_Revenue__c btxr = new BTx_Engagement_Revenue__c();
    public BTx_Engagement_Activity__c btxac = new BTx_Engagement_Activity__c();
    public String BTxid = ApexPages.currentPage().getParameters().get('CF00N80000004vwCK_lkid');
    public String BTxName = ApexPages.currentPage().getParameters().get('CF00N80000004vwCK');
    String verti = '';
    public String retURL {get; set;}
    public String saveNewURL {get; set;}
    public String cancelURL {get; set;}
    public String confirmationToken {get; set;}
    public String Recordtype = ApexPages.currentPage().getParameters().get('RecordType');
   
    public String ent = ApexPages.currentPage().getParameters().get('ent');
    
    PageReference pageref;

    
    public BTx_Revenue(ApexPages.StandardController controller) {
    
        System.debug('Demo:'+BTxid);
        System.debug('Demo2:'+ ApexPages.currentPage().getParameters().get('CF00N80000004vwCK_lkid'));
        retURL = ApexPages.currentPage().getParameters().get('retURL');
        saveNewURL = ApexPages.currentPage().getParameters().get('save_new_url');
         
        if(ApexPages.currentPage().getParameters().get('CF00N80000004vwCK_lkid')  != '' && ApexPages.currentPage().getParameters().get('CF00N80000004vwCK_lkid')  != null)
        {
              System.debug('Demo3:'+ ApexPages.currentPage().getParameters().get('CF00N80000004vwCK_lkid'));
            btxa = [select Id, Name, Vertical__c from BTx_Engagement_Activity__c where Id = :ApexPages.currentPage().getParameters().get('CF00N80000004vwCK_lkid') limit 1];
        }
        else if(retURL != '' && retURL != null &&  retURL != '/a1Z/o')
        {
            System.debug('retURL:'+retURL.substring(1,3));
           if(retURL.substring(1,3).contains('a1'))
            btxr = [select Engagement__r.Id, Engagement__r.Name, Engagement__r.Vertical__c from BTx_Engagement_Revenue__c where Id = :retURL.substring(1) limit 1];
           else if(retURL.substring(1,3).contains('a0'))
            btxac = [select Id, Name, Vertical__c from BTx_Engagement_Activity__c where Id = :retURL.substring(1) limit 1];
        }
       
        

      
    }
    
    public PageReference pageredir(){
    
         if(btxa.Vertical__c != null || btxa.Vertical__c != '')
         {
           verti = btxa.Vertical__c;
           BTxid = btxa.Id;
           BTxName = btxa.Name;
         }
       if(btxr.Engagement__r.Vertical__c != null)
       {
         verti = btxr.Engagement__r.Vertical__c;
       
       BTxid = btxr.Engagement__r.Id;
       BTxName = btxr.Engagement__r.Name;
       }
       if(btxac.Vertical__c != null)
       {
           verti = btxac.Vertical__c;
           BTxid = btxac.Id;
           BTxName = btxac.Name;
       }
     String note = ApexPages.currentPage().getParameters().get('note');
     String sn = ApexPages.currentPage().getParameters().get('sn');
     
     
     if(note != 'true' && sn != '0')
     {
     
     if(verti == null)
     verti = '';
     if(BTxid == null)
     BTxid = '';
     if(BTxName == null)
     BTxName = '';
     
     if(verti != '')
     verti =  EncodingUtil.urlEncode(verti,'UTF-8');
     
            
     pageref = new PageReference('/a1Z/e?CF00N80000004vwCK='+BTxName+'&CF00N80000004vwCK_lkid='+BTxid+'&00N80000004x4dS='+verti+'&retURL=%2F'+BTxid+'&note=true&nooverride=1&sn=0');
     pageref.setRedirect(true);
     pageref.getParameters().put('retURL', retURL);
     pageref.getParameters().put('save_new_url', saveNewURL);
     }
     else if(note == 'true' && sn == '0')
     {
         if(verti == null)
     verti = '';
     if(BTxid == null)
     BTxid = '';
     if(BTxName == null)
     BTxName = '';
     
     if(verti != '')
     verti =  EncodingUtil.urlEncode(verti,'UTF-8');
     
              
     pageref = new PageReference('/a1Z/e?CF00N80000004vwCK='+BTxName+'&CF00N80000004vwCK_lkid='+BTxid+'&00N80000004x4dS='+verti+'&retURL=%2F'+BTxid+'&note=true&nooverride=1&sn=1');
     pageref.setRedirect(true);
     System.debug('pageref:'+pageref);
     pageref.getParameters().put('retURL', retURL);
     pageref.getParameters().put('save_new_url', saveNewURL);
      
     }
     
  
     return pageref;
    }
    
    
 }