public class TSN_Add_Attachment_CTE {



public Boolean attachFlag {get;set;}
public Case c;
public String caseNumber {get;set;}
public List<String> attach = new List<String>();

public TSN_Add_Attachment_CTE(ApexPages.StandardController controller) {
        c = [Select Status,RecordTypeId,CaseNumber from Case where id =:ApexPages.CurrentPage().getparameters().get('id')]; 
        caseNumber = c.CaseNumber;
        attachFlag = false;
    }

public Attachment attachment {
  get {
      if (attachment == null)
        attachment = new Attachment();
        return attachment;
    }
  set;
  }
 
public PageReference upload() {
    // SCAVA FIX , Oct 16th 2019
    if (Schema.sObjectType.Attachment.fields.OwnerId.isCreateable()) {
    attachment.OwnerId = UserInfo.getUserId();
    }
    // SCAVA FIX , Oct 16th 2019
    if (Schema.sObjectType.Attachment.fields.ParentId.isCreateable()) {
    attachment.ParentId = ApexPages.currentPage().getParameters().get('id'); // the record the file is attached to
    }
   // attachment.IsPrivate = true; 
    try {
      insert attachment;
      attach.add(attachment.Name);
    } 
    catch (DMLException e) {
      ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'Error uploading attachment'));
      return null;
    } 
    finally {
      attachment = new Attachment(); 
    }
    ApexPages.addMessage(new ApexPages.message(ApexPages.severity.INFO,'Attachment uploaded successfully'));
    attachFlag = true;
    getResults();

    /*pageRef.setredirect(true);
    return pageRef; */
    
    return null;
  }
public PageReference checkAttachmentSize(){      
     if(c.RecordTypeId == Utilities.getCaseTSNRecordTypeId() && c.Status == 'Closed'){
          ApexPages.addMessage(new ApexPages.message(ApexPages.severity.ERROR,'You cannot add an attachment to a closed case'));    
          attachment = new Attachment();
          return null;
     }
    else{
        upload();
    }
      return null;
  }
public PageReference close(){
    return new PageReference('/' + ApexPages.CurrentPage().getparameters().get('id'));
  }
public List<String> getResults(){      
        return attach;
    }  
    
    
    
}