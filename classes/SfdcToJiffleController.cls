public with sharing class SfdcToJiffleController {
public string idFromUrl {get;set;}
public string url{get;set;}
public List<Account> accObj = new List<Account>();
public List<Opportunity> oppObj = new List<Opportunity>();
    public SfdcToJiffleController(){
    
        idFromUrl = ApexPages.currentPage().getParameters().get('id');
        if(idFromUrl!= null){
        
                if(idFromUrl.startsWith('001')) {
                    accObj = [SELECT Id, Name FROM Account WHERE Id=: idFromUrl LIMIT 1];
                    String encodedAccName = EncodingUtil.urlEncode(accObj.get(0).Name , 'UTF-8');
                    url = System.Label.Jiffle_URL+'&acc='+accObj.get(0).Id+'&acc_name='+ encodedAccName +'&source=sfdc';
                }
                else if(idFromUrl.startsWith('006')) {
                    oppObj = [SELECT Id, Name, Account.Id, Account.Name FROM Opportunity WHERE Id=: idFromUrl LIMIT 1];
                    String encodedAccName = EncodingUtil.urlEncode(oppObj.get(0).Account.Name , 'UTF-8');                
                    String encodedOppName = EncodingUtil.urlEncode(oppObj.get(0).Name , 'UTF-8');
                    url = System.Label.Jiffle_URL+'&acc='+oppObj.get(0).Account.Id+'&acc_name='+ encodedAccName +'&opp='+oppObj.get(0).Id+'&opp_name='+ encodedOppName +'&source=sfdc';
                }
        }else{
        
                url = System.Label.Jiffle_URL+'&source=sfdc';
        
        }
        System.debug('*url*'+url);
       
    }
    
    }