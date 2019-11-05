/*
	Name    		: LeadTACSharingHelper 
	Author  		: Eric Pesch (epesch)
	Release 		: 1.0
	Functionality 	: Future class for forcing Salesforce to Salesforce field updates
	Created			: Sep 14 2015
	
	Modification History:
	Date		Author			Change 
*/

public class LeadTACSharingHelper {
	private final static String TAG  = '[LeadTACSharingHelper] - ';
	
	/*
	 * @description Touch leads to force SFDC2SFDC update
	 *
	 * @param leadsSet Set of Leads
	 */
	@future
	public static void touchLeads(Set<Id> leadsSet){
		List<Lead> touchLeads = new List<Lead>();
		List<Lead> newLeads = [select Id, LeadSource from Lead where Id in : leadsSet];
		
		for(Lead newLead : newLeads){
			if(newLead.LeadSource == System.label.Lead_TAC_Generated_Source){
				touchLeads.add(newLead);
			}
		}
		
		if(!touchLeads.isEmpty()){
			try{
				update touchLeads;
			} catch (Exception e){
				System.debug(TAG + 'Error touching leads - ' + e.getStackTraceString());
			}
		}
	}
}