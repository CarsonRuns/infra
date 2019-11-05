public class Case_Email {

public String CaseId;
public List<CaseComment> comment; 
public List<CaseHistory> history; 
public List<EmailMessage> message;

public String getCaseId(){
    return CaseId;
}
public void setCaseId(String CaseId){
    this.CaseId = CaseId;
}

public List<CaseInfo> getBody()
{
 List<CaseInfo> listCaseInfo;
 // STEP 1 - get the case and related comments, email and case history info
 Case caseRecord = [Select c.Id,  
                     (Select CommentBody, CreatedDate From CaseComments order by CreatedDate desc), 
                     (Select HtmlBody,TextBody,MessageDate, Subject From EmailMessages order by MessageDate desc limit 1), 
                     (Select CreatedDate, Field, NewValue, OldValue From Histories order by CreatedDate desc) 
             from Case c where CaseNumber = :CaseId];

  // STEP 2 - Create objects of case info and populate the list case info
  listCaseInfo = populateCaseInfoList(caseRecord.CaseComments, caseRecord.EmailMessages, caseRecord.Histories);
  
  
  // STEP 3 - Sort objects of case info based on dates
  sortList(listCaseInfo);
  
 return listCaseInfo;
}

public void sortList(List<CaseInfo> listCaseData)
{
  for(Integer i = 0; i < listCaseData.size(); i++)
  {
    for(Integer j = i+1; j < listCaseData.size(); j++)
    {
        if(listCaseData[i].caseDate < listCaseData[j].caseDate)
        {
           CaseInfo caseInfo = listCaseData[i];
           listCaseData[i] = listCaseData[j];
           listCaseData[j] = caseInfo;        
        }
    }   
  }
}




public List<CaseInfo> populateCaseInfoList(List<CaseComment> listCaseComments, List<EmailMessage> listEmailMessages, List<CaseHistory> listHistories)
{
  List<CaseInfo> listCaseData = new List<CaseInfo>();
   String EmailBody = '';
  
      // add case comments
  
  for(CaseComment c : listCaseComments)
  {
    CaseInfo caseInfo = new CaseInfo();
    caseInfo.caseText = 'Case Comments' + '- ' + c.commentBody;
    caseInfo.caseDate = c.CreatedDate;
    
    listCaseData.add(caseInfo);
  
  }
  
    // add emails
  
  for(EmailMessage msg : listEmailMessages)
  {
    CaseInfo caseInfo = new CaseInfo();
    if(msg.htmlBody !=null)
    EmailBody = msg.htmlBody;
    else
    EmailBody = msg.textBody;
    caseInfo.caseText = 'Email Message' + '-' + msg.Subject + '- ' + EmailBody;
    caseInfo.caseDate = msg.MessageDate;
    
    listCaseData.add(caseInfo);
  
  }
  
    // add case histories
    
  for(CaseHistory ch : listHistories)
  {
    
    // logic to check if the new value or the old value is a 18 char ID
    boolean isId = true;
    try
    {
      Id idNewValue = (Id)ch.newValue;
      Id idOldValue = (Id)ch.oldValue;
    }
    catch(Exception ex)
    {
      isId = false;
    } 
    
    // only if the new value and the old value is not an Id, add it to the list
    if (!isId) {
        CaseInfo caseInfo = new CaseInfo();
        if(ch.NewValue != null && ch.OldValue != null){
            caseInfo.caseText = 'Case History' + '-' + 'Changed' + ' ' + ch.Field + ' ' + 'from' + ' ' + ch.OldValue + ' ' + 'to' + ' ' + ch.NewValue;
            }
        else if(ch.NewValue != null){
             caseInfo.caseText = 'Case History' + '-' + 'Changed' + ' ' + ch.Field + ' ' + 'to' + ' ' + ch.NewValue;
            }
        else {
            caseInfo.caseText = 'Case History' + '-' + ' ' + ch.Field;
            }   
        caseInfo.caseDate = ch.CreatedDate;
        
        listCaseData.add(caseInfo);  
    }
  }
  
  
  return listCaseData ;
}

public Class caseInfo {
public String caseText {get;set;}
public DateTime caseDate {get;set;}
}
}