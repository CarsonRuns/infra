public class SCP_Communities_Chart_CT {

    private final Account acct;
    public boolean isLineDataWalletDataAvailable{get;set;}
    public boolean isLineDataBookingDataAvailable{get;set;}

    public SCP_Communities_Chart_CT(ApexPages.StandardController controller) {
        this.acct = [select Wallet_Data_Center_UCS_000__c ,  Wallet_Other_000__c , Wallet_Routing_000__c , 
                     Wallet_Security_000__c , Wallet_Switching_000__c ,  Wallet_Video_000__c , 
                     Wallet_Collab_Applications__c , Wallet_Services_000__c, Wallet_Unified_Communications_000__c ,
                     Wallet_Wireless_000__c, Wallet_Total_000__c, Expected_Bookings_Wireless_000__c, Expected_Bookings_Telepresence_000__c,
                     Expected_Bookings_Switching_000__c, Expected_Bookings_Services_000__c, Expected_Bookings_Security_000__c,
                     Expected_Bookings_Routing_000__c, Expected_Bookings_Data_Center_UCS_000__c, Expected_Bookings_Collab_Voice_000__c,
                     Expected_Bookings_Collab_App_000__c, Expected_Booking_Other__c, Bookings_Total_000__c 
                     from Account 
                     where Id=:controller.getRecord().id][0];
        
        if(acct.Wallet_Total_000__c > 0) 
        {
            isLineDataWalletDataAvailable = true;
        }else{
            isLineDataWalletDataAvailable = false;
        }

        if(acct.Bookings_Total_000__c > 0) 
        {
            isLineDataBookingDataAvailable = true;
        }else{
            isLineDataBookingDataAvailable = false;
        }
    }

    public class LinedataWrap{
        public String Technology {get;set;}
        public Decimal Amount {get;set;}

        public LinedataWrap(String technology, Decimal amount){
        this.Technology = technology;
        this.amount = amount;
        }
    }

    public LinedataWrap createWalletLinedata(String label, Decimal value, Decimal total){
        Decimal walletValue = 0;
        Decimal walletTotal = 0;
        Decimal walletPercentage = 0;
        if(total!=null && total>0){
            walletValue = value!=null?value:0;
            walletTotal = total;
            walletPercentage = 100*walletValue/walletTotal;
        }
        String walletLabel = label + ' ' + walletPercentage.setScale(0) + '%';
        return new LinedataWrap(walletLabel, walletValue);
    }

    public List<LinedataWrap> getLineDataWallet(){
        List<LinedataWrap> linedatawallet = new List<LinedataWrap>();
        linedatawallet.add(createWalletLinedata(System.Label.PRM_walletCollabApplications, acct.Wallet_Collab_Applications__c, acct.Wallet_Total_000__c));
        linedatawallet.add(createWalletLinedata(System.Label.PRM_walletServices, acct.Wallet_Services_000__c, acct.Wallet_Total_000__c));
        linedatawallet.add(createWalletLinedata(System.Label.PRM_walletTelepresence, acct.Wallet_Video_000__c, acct.Wallet_Total_000__c));
        linedatawallet.add(createWalletLinedata(System.Label.PRM_walletDataCenter, acct.Wallet_Data_Center_UCS_000__c, acct.Wallet_Total_000__c));
        linedatawallet.add(createWalletLinedata(System.Label.PRM_walletCollabvoice, acct.Wallet_Unified_Communications_000__c, acct.Wallet_Total_000__c));
        linedatawallet.add(createWalletLinedata(System.Label.PRM_walletWireless, acct.Wallet_Wireless_000__c, acct.Wallet_Total_000__c));
        linedatawallet.add(createWalletLinedata(System.Label.PRM_walletSecurity, acct.Wallet_Security_000__c, acct.Wallet_Total_000__c));
        linedatawallet.add(createWalletLinedata(System.Label.PRM_walletRouting, acct.Wallet_Routing_000__c, acct.Wallet_Total_000__c));
        linedatawallet.add(createWalletLinedata(System.Label.PRM_walletSwitching, acct.Wallet_Switching_000__c, acct.Wallet_Total_000__c));
        linedatawallet.add(createWalletLinedata(System.Label.PRM_walletOther, acct.Wallet_Other_000__c, acct.Wallet_Total_000__c));
        return  linedatawallet;
    }

    public List<LinedataWrap> getLineDataBooking(){
        List<LinedataWrap> linedatabooking = new List<LinedataWrap>();
        linedatabooking.add(new LinedataWrap(System.Label.PRM_walletCollabApplications, acct.Expected_Bookings_Collab_App_000__c!=null?acct.Expected_Bookings_Collab_App_000__c:0));
        linedatabooking.add(new LinedataWrap(System.Label.PRM_walletServices, acct.Expected_Bookings_Services_000__c!=null?acct.Expected_Bookings_Services_000__c:0));
        linedatabooking.add(new LinedataWrap(System.Label.PRM_walletTelepresence, acct.Expected_Bookings_Telepresence_000__c!=null?acct.Expected_Bookings_Telepresence_000__c:0));
        linedatabooking.add(new LinedataWrap(System.Label.PRM_walletDataCenter, acct.Expected_Bookings_Data_Center_UCS_000__c!=null?acct.Expected_Bookings_Data_Center_UCS_000__c:0));
        linedatabooking.add(new LinedataWrap(System.Label.PRM_walletCollabvoice, acct.Expected_Bookings_Collab_Voice_000__c!=null?acct.Expected_Bookings_Collab_Voice_000__c:0));
        linedatabooking.add(new LinedataWrap(System.Label.PRM_walletWireless, acct.Expected_Bookings_Wireless_000__c!=null?acct.Expected_Bookings_Wireless_000__c:0));
        linedatabooking.add(new LinedataWrap(System.Label.PRM_walletSecurity, acct.Expected_Bookings_Security_000__c!=null?acct.Expected_Bookings_Security_000__c:0));
        linedatabooking.add(new LinedataWrap(System.Label.PRM_walletRouting, acct.Expected_Bookings_Routing_000__c!=null?acct.Expected_Bookings_Routing_000__c:0));
        linedatabooking.add(new LinedataWrap(System.Label.PRM_walletSwitching, acct.Expected_Bookings_Switching_000__c!=null?acct.Expected_Bookings_Switching_000__c:0));
        return linedatabooking;
    }
}