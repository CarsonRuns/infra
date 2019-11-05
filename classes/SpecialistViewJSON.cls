/*
    Author          : Awnish Kumar
    Release         : PSS MVP March 29, 2019 Release
    Created         : Feb 11, 2019
    Functionality   : Specialist View JSON used for copying lines from Line Item to specialist view

                      
    Modification History:
    User Story#        Date        Author              Change  
	US307507           5/3/2019    Awnish K.           Add Product Family Lookup on the Specialist View
*/
public class SpecialistViewJSON {

	public class LineItems {
		public String id;
        public Date bookdate;
        public String stage; 
        
		public String besubbe;
		public String productfamily;
        //Added Product Family Lookup - US307507
        public String productfamilyref;
		public String techservice;
		public Double productvalue;
        public Double expectedProductvalue;
        
        public Double expectedServicevalue;
		public Double servicevalue;
		public String category;
		public String cat;
		public String serviceprogram;
		public String serviceleveltech;
		public String servicedesc;
	}

	public String role;
	public List<LineItems> lineItems;

	
	public static SpecialistViewJSON parse(String json) {
		return (SpecialistViewJSON) System.JSON.deserialize(json, SpecialistViewJSON.class);
	}
}