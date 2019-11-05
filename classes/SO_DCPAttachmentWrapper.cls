/*************************************************************************************************************************************************************************************************************
Name    : SO_DCPAttachmentWrapper 
Author  : Apex User
Purpose : SO_DCPAttachmentWrapper contains methods to get the content List used in DCPAttachment Section, List is being in 
          SO_DCPAttachmentHandler Controller to fetch the List of documents uploaded to DCP 
Created Date:  3/4/2018

***************************************************************************************************************************************************************************************************************/

public class SO_DCPAttachmentWrapper {
    public List<DCPOutput> contentListing {get;set;}
    public class DCPOutput{
        public string fileName {get;set;}
        public string fileSize {get;set;}
        public string author {get;set;}
        public string CreatedBy {get;set;}
        public string contentId {get;set;}
        public string edmContentId {get;set;}
        public string keywords {get;set;}
        public string mimeType {get;set;}
        public string title {get;set;}
        public string description {get;set;}
        public string checkedInDate {get;set;}
        public string version {get;set;}
        public string ObjectType {get;set;}
        /*public string opportunityId{get{ return SO_Utils.getIDFromString(keywords, 's1optyID:');}set;}
        public string projectId {get{ return SO_Utils.getIDFromString(keywords, 'projectID:');} set;}
        public string caseId {get{ return SO_Utils.getIDFromString(keywords, 'caseID:');} set;} */
    }
}