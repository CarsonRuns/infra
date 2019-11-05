public class AttritionReasonCode {

    public AttritionReasonCode(ApexPages.standardController controller) {

    }

    public string selectedValue { get;set; }
    public List<SelectOption> AttritionReason { get;set; }
    
   {
        Schema.DescribeFieldResult AttritionReasonField = OpportunityLineItem.Attrition_Reason_Code__c.getDescribe();
        AttritionReason = new list<SelectOption>();
       // AttritionReason.add(new SelectOption('--Select--','--Select--'));
        for (Schema.Picklistentry picklistEntry : AttritionReasonField.getPicklistValues())
        {
            AttritionReason.add(new SelectOption(pickListEntry.getValue(),pickListEntry.getLabel()));
        }
       
    }
    
}