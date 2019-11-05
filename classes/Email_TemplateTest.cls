@isTest(SeeAllData=true)
public class Email_TemplateTest {
	@isTest(SeeAllData=true)
    static void testMethod1()
    {
        EmailTemplate templateLst = [Select id,Name,TemplateType,Description,Subject,Body,folderId,IsActive from EmailTemplate where IsActive=true limit 1];
        Email_Template.getTemplates(templateLst.FolderId);
        Email_Template.fetchTempFolder();
        Email_Template.getSelectedTemplates(templateLst.Id);
    }
}