/*
	Name    		: ConnectionUtilities 
	Author  		: Eric Pesch (epesch)
	Release 		: 1.0
	Functionality 	: Utility methods for Salesforce to Salesforce connections
	Created			: Sep 14 2015
	
	Modification History:
	Date		Author			Change 
*/

public class ConnectionUtilities {
	
	/*
	 * @description Retrieves a connectionId based on the connection name
	 *
	 * @param connectionName Developer name of Connection
	 *
	 * @return Id of the Connection
	 */
	public static Id getConnectionId(String connectionName) {
		List<PartnerNetworkConnection> partnerNetConList = [select Id from PartnerNetworkConnection 
			where connectionStatus = 'Accepted' and connectionName = :connectionName];

		if (partnerNetConList != null && !partnerNetConList.isEmpty()) {
			return partnerNetConList.get(0).Id;
		}

		return null;
	}

	/*
	 * @description Retrieves a connection Owner Id by Connection Name
	 *
	 * @param connectionName Developer name of Connection
	 *
	 * @return Id of the Connection Owner
	 */
	public static Id getConnectionOwnerId(String connectionName) {
		List<PartnerNetworkConnection> partnerNetConList =  [select createdById from PartnerNetworkConnection 
			where connectionStatus = 'Accepted' and connectionName = :connectionName];

		if (partnerNetConList != null && !partnerNetConList.isEmpty()) {
			return partnerNetConList.get(0).createdById;
		}

		return null;
	}
}