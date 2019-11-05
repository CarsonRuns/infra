Public Class NGCC_Assign_Master_Answers_CTE{

    private String answer_record_type_id;           //'012S00000000cKZ' in .ngcc;
    private String integration_profile_id;    //'00e30000000eca0' in .ngcc


    private CC_Master_Question_Answer_Bank__c question;
    public List<AnswerWrapper> answer_map {get; set;}
    
    public Boolean refresh {get; set;}
    public String newAnswerURL {get; set;}
    public String answerOptionId {get;set;}
    
    public String filterText {get; set;}
       
    public NGCC_Assign_Master_Answers_CTE(ApexPages.StandardController controller) {
    
        //Org_constants__c answer_rec_type = [select non_prod_value__c from Org_constants__c where key__c = 'answer_record_type_id' limit 1];
        Org_Constant_CS__c orgCS = Org_Constant_CS__c.getValues('NGCC_Answer_RecordType_Id');
        answer_record_type_id = orgCS.Production_Value__c;
       // Org_constants__c integration_profile = [select non_prod_value__c from Org_constants__c where key__c = 'integration_profile_id' limit 1];
        Org_Constant_CS__c orgCSUser = Org_Constant_CS__c.getValues('NGCC_Integration_User');
        integration_profile_id = orgCSUser.Production_Value__c;
        
        Org_Constant_CS__c orgCSId = Org_Constant_CS__c.getValues('NGCC_Answer_Option_Id');
        answerOptionId = orgCSId.Production_Value__c;
        
        this.refresh = false;
        this.newAnswerURL = '';
        this.question = [select id, owner.profileid, Answer_Options_Id__c, Local_to_SFDC__c , RecordTypeId from CC_Master_Question_Answer_Bank__c where id = :controller.getId() limit 1];
        answer_map = new List<AnswerWrapper>();
        
        populate_selected();
        
    }
    
    public void populate_selected(){
        system.debug('question='+question);
        if(this.question != null){
            if(this.question.Answer_Options_Id__c != null){
                Map<String, Integer> answer_seq_map = new Map<String, Integer>();
                String[] answers_string = this.question.Answer_Options_Id__c.split(',');
                for(String s:answers_string){
                    String[] seq_id = s.split(':');
                    answer_seq_map.put(seq_id[1], Integer.valueOf(seq_id[0]));
                }
                system.debug('answers_string='+answers_string);
                
                List<CC_Master_Question_Answer_Bank__c> selected_answers = [select id, MODS_Question_Answer_Code__c, Answer_Text__c from CC_Master_Question_Answer_Bank__c where id in :answer_seq_map.keyset()];
                system.debug('selected_answers count='+selected_answers.size()); 
                system.debug('selected_answers='+selected_answers);
                for(CC_Master_Question_Answer_Bank__c checked : selected_answers){
                
                    answer_map.add(new AnswerWrapper(checked, true, answer_seq_map.get(checked.id)));
                }
                answer_map.sort();
                system.debug('answer_map size:'+answer_map.size());
                system.debug('answer_map:'+answer_map);
            }
        }
    }
    
    public PageReference doSearch(){
        this.answer_map.clear();
        populate_selected();
        String filter = this.filterText + '%';
        system.debug('this.filterText='+this.filterText);
        system.debug('filter='+filter);
        List<CC_Master_Question_Answer_Bank__c> answer_search = [select id, Answer_Sequence__c, MODS_Question_Answer_Code__c, Answer_Text__c from CC_Master_Question_Answer_Bank__c where MODS_Question_Answer_Code__c like :filter limit 10];
        system.debug('selected_answers count='+answer_search.size()); 
        for(CC_Master_Question_Answer_Bank__c answer : answer_search){
            system.debug('---->Answer Code='+answer.MODS_Question_Answer_Code__c);
            this.answer_map.add(new AnswerWrapper(answer, false, null));
        }
        return null;
    }
    
    public Boolean getIsRendered(){
        List<RecordType> rtypes = [Select Name, Id From RecordType where sObjectType='CC_Master_Question_Answer_Bank__c' and isActive=true];
        Map<String,String> rtMap = new Map<String,String>{};
        for(RecordType rt: rtypes)
            rtMap.put(rt.Name,rt.Id);

        if(this.question.RecordTypeId != rtMap.get('Question')){
            return false;
        }
        return true;
    }
    
    public Boolean getIsLocal(){
        return this.question.Local_to_SFDC__c;
    }
    
    public Boolean getIsDummyOwner(){
        return this.question.owner.profileid == integration_profile_id;
    }
    
    public PageReference update_selection(){
        String answerOptions = '';
        for(AnswerWrapper a:answer_map){
            if(a.selected){
                 String seq = String.valueOf(a.sequence);
                if (seq.length() == 1){
                    seq = '0' + seq;
                }
            
              answerOptions += seq + ':' + a.answer.id + ',';
            }
        }
        if(answerOptions.endswith(',')){
            answerOptions = answerOptions.substring(0,answerOptions.length() - 1);
        }
        this.question.Answer_Options_Id__c = answerOptions;
        update this.question;
        this.refresh = true;
        return null;
    }
    
    public PageReference add_option(){
        newAnswerURL = '/'+Schema.getGlobalDescribe().get('CC_Master_Question_Answer_Bank__c').getDescribe().getKeyPrefix()+'/e?RecordType='+answer_record_type_id;
        return null;
    }
    
    public class AnswerWrapper implements Comparable{
        public CC_Master_Question_Answer_Bank__c answer {get; set;}
        public Boolean selected {get; set;}
        public Integer sequence {get; set;}
        public answerWrapper(CC_Master_Question_Answer_Bank__c ans, Boolean sel, Integer seq){
            this.answer=ans;
            this.selected=sel;
            this.sequence=seq;
        }
        
        public Integer CompareTo(Object compareTo){
            if(compareTo instanceof AnswerWrapper)
            {
                AnswerWrapper other = (AnswerWrapper)compareTo;
                if(this.sequence > other.sequence){
                    return 1;
                }
                if(this.sequence < other.sequence){
                    return -1;
                }
                if(this.sequence == other.sequence){
                    return 0;
                }
            }
            return null;
        }
    }

}