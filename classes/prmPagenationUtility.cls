public with sharing class prmPagenationUtility {
	
	
	public prmPagenationUtility(string query, integer pgSize) {
		this.queryStr1 = query;
		this.pg_PageSize = pgSize;
	}
	
	public prmPagenationUtility(string q1, string q2, integer pgSize) {
		this.queryStr1 = q1;
		this.queryStr2 = q2;
		this.pg_PageSize = pgSize;
	}

	public string queryStr1 { 
		get
		{
			return queryStr1;
		}
		 set; 
	 }
	 
	 public string queryStr2 { get; set; }
	 
	 public Integer pg_PageSize { get; set; }
	 
	 public Boolean isUnCoveredView { get; set; }
		
		public class WrapperList {
			public Boolean isSelected { get; set; }
			
			public Lead leadRec { get; set; }
			
			public Assigned_Partner__c tp { get; set; }
			
			public Account acc { get; set; }
			
			public string hyperlink { get; set; }
			public string cname_en { get; set; }
			public string cname_loc { get; set; }
			
			public string address_en { get; set; }
			public string address_loc { get; set; }
			
			public string city_en { get; set; }
			public string city_loc { get; set; }
			
			public string state_en { get; set; }
			public string state_loc { get; set; }
			
			public string country_en { get; set; }
			public string country_loc { get; set; }
			
			public string lang  { get; set; }
			
			public string localDate { get; set; }
			
			public Boolean isExpDateIn7Days { get; set; }
			
			public String selectedStatus { get; set; }
			public Boolean disableAmt { 
				get {
					disableAmt = true;
					if(selectedStatus == 'Actively Working' || selectedStatus.startsWith('Closed-Order')) {
						disableAmt = false;
					}
					return disableAmt;
				}
				set;
			}
			public Boolean disableName {
				get {
					disableName = true;
					if(selectedStatus.equalsIgnoreCase('Closed-Order Through Disti')) {
						disableName = false;
					}
					return disableName;
				}
				set;
			}
			
			public WrapperList(Lead obj) {
				this.disableAmt = true;
				this.disableName = true;
				
				this.leadRec = obj;
				lang = prmFilterUtility.logUser.LanguageLocaleKey;
				
				cname_loc = leadRec.Company;
				cname_en = leadRec.Account_Name_English__c;
				
				if(lang.equalsIgnoreCase('en_US')) {
					hyperlink = cname_en != null ? cname_en : cname_loc;
				}
				else {
					hyperlink = (cname_loc != null ? cname_loc : cname_en);
				}
				if(hyperlink == null || hyperlink == '') {
						hyperlink = leadRec.Id;
				}				
				
				address_loc = leadRec.Address_Line_1__c;
				address_en = leadRec.Address_Line_1_English__c;
				
				city_loc = leadRec.CustomCity__c;
				city_en = leadRec.City_English__c;
				
				state_loc = leadRec.CustomState__c;
				state_en = leadRec.State_Province_English__c;
				
				country_loc = leadRec.Country_English__c;
				country_en = leadRec.CustomCountry__c;

				if(leadRec.Partner_Assigned_Date__c != null ) {

					localDate = leadRec.Partner_Assigned_Date__c.format('MM-dd-YYYY');
				}
				
				if(leadRec.Partner_Lead_Status__c == 'Actively Working') {
					disableAmt = false;
				}
				else if(leadRec.Partner_Lead_Status__c != null && leadRec.Partner_Lead_Status__c.equalsIgnoreCase('Closed-Order Through Disti')) {
					disableAmt = false;
					disableName = false;
				}
				
				
			}
			public WrapperList(Assigned_Partner__c obj) {
				this.tp = obj;
				
				lang = prmFilterUtility.logUser.LanguageLocaleKey;
				
				cname_en = tp.Customer_Account__r.CRName__c;
				cname_loc = tp.Customer_Account__r.Name;
				
				if(lang.equalsIgnoreCase('en_US')) {
					hyperlink = cname_en;
				}
				else {
					hyperlink = (cname_loc != null ? cname_loc : cname_en);					
				}
				
				if(hyperlink == null || hyperlink == '') {
						hyperlink = tp.Id;
				}				
				address_loc = tp.Customer_Account__r.AddressLine1__c;
				address_en = tp.Customer_Account__r.CRAddressLine1__c;
				
				city_loc = tp.Customer_Account__r.City__c;
				city_en = tp.Customer_Account__r.CRCity__c;
				
				state_loc = tp.Customer_Account__r.State__c;
				state_en = tp.Customer_Account__r.CRState__c;
				
				country_loc = tp.Customer_Account__r.Country__c;
				country_en = tp.Customer_Account__r.CRCountry__c;
				
				isExpDateIn7Days = false;
				
				if(tp.Partner_Assigned_Date__c != null ) {

					localDate = tp.Partner_Assigned_Date__c.format('MM-dd-YYYY');
				}
				if(tp.Expiration_Date__c != null ) {
					Date currentDate = Date.today();
					Date compDate =currentDate.addDays(7);
					System.debug(System.LoggingLevel.INFO, '>>>>> TP Id : '+tp.Id+' ExpDate : '+tp.Expiration_Date__c+' currentDate : '+currentDate+' compDate : '+compDate);
					if(tp.Expiration_Date__c <= compDate && tp.Expiration_Date__c >= currentDate) {
						isExpDateIn7Days = true;
					}
				}
				
			}
			// For Accounts for Uncovered prospects
			public WrapperList(Account obj) {
								
				this.acc = obj;
				
				lang = prmFilterUtility.logUser.LanguageLocaleKey;
				
				cname_en = acc.CRName__c;
				cname_loc = acc.Name;
				
				if(lang.equalsIgnoreCase('en_US')) {
					hyperlink = cname_en;
				}
				else {
					hyperlink = (cname_loc != null ? cname_loc : cname_en);					
				}
				
				if(hyperlink == null || hyperlink == '') {
						hyperlink = acc.Id;
				}				
				
				address_loc = acc.AddressLine1__c;
				address_en = acc.CRAddressLine1__c;
				
				city_loc = acc.City__c;
				city_en = acc.CRCity__c;
				
				state_loc = acc.State__c;
				state_en = acc.CRState__c;
				
				country_loc = acc.Country__c;
				country_en = acc.CRCountry__c;
				
			}
			public void statusChange() {
				
			}
		}
		
	  	transient List<WrapperList> pageRecords ;
		
		transient List<Lead> l_origPageRecords;
		transient List<Lead> l_PageRecords;
		
		transient List<Assigned_Partner__c> tp_origPageRecords;
		transient List<Assigned_Partner__c> tp_PageRecords;
		
		transient List<Account> acc_origPageRecords;
		transient List<Account> acc_PageRecords;
		
		public void clearPageRecords() {
			if(pageRecords != null) {
				pageRecords.clear();
			}
		}
		public List<WrapperList> getLeadPageRecords() {
			if(pageRecords == null || pageRecords.isEmpty()) {
				l_PageRecords = (List<Lead>) Database.query(queryStr1);
				System.debug(System.LoggingLevel.INFO,'### queryStr1 : '+ queryStr1);
				System.debug(System.LoggingLevel.INFO,'### query count  : '+ l_PageRecords.size());
				pageRecords = new List<WrapperList>();
				for(Lead obj : l_PageRecords) {
					pageRecords.add(new WrapperList(obj));
				}
			}
			return pageRecords;
		}
		
	   public List<WrapperList> getTPPageRecords() {
	   		
	   		DateTime sdt = DateTime.now();	   			   			   		
			if(pageRecords == null || pageRecords.isEmpty()) {
									
				isUncoveredView = isUncoveredView == null ? true : isUncoveredView;	
				pageRecords = new List<WrapperList>();
				
				if(isUncoveredView) {
					pageRecords = new List<WrapperList>();
					acc_PageRecords = (List<Account>) Database.query(queryStr1);										
					for(Account a : acc_PageRecords) {
						pageRecords = (pageRecords == null ? new List<WrapperList>() : pageRecords);						
						WrapperList accWrapper = new WrapperList(a);						
						pageRecords.add(accWrapper);
					}						
				}
				else {					
					tp_PageRecords = (List<Assigned_Partner__c>) Database.query(queryStr1);
					System.debug(System.LoggingLevel.INFO,'### query 1 count : '+ tp_PageRecords.size());
					if(queryStr2 != null) {						
						List<Assigned_Partner__c> tplist = (List<Assigned_Partner__c>) Database.query(queryStr2);
						System.debug(System.LoggingLevel.INFO,'### query 2 count : '+ tplist.size());
						if(tplist != null && !tpList.isEmpty()) {
							tp_PageRecords.addAll(tplist);
						}
					}
					
					System.debug(System.LoggingLevel.INFO,'### final count  : '+ tp_PageRecords.size());											
					for(Assigned_Partner__c obj : tp_PageRecords) {
						pageRecords.add(new WrapperList(obj));
					}
				}
			}   			   			   			
   			DateTime edt = DateTime.now();   			
			return pageRecords;
		}
}