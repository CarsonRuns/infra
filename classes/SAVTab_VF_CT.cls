public class SAVTab_VF_CT {

    public SAVTab_VF_CT(ApexPages.StandardController controller) {}
    public SAVTab_VF_CT() {}
    
    String mslURL = Utilities.getConstant_CS('tools.cisco.com');
    
    
    public Boolean getUserPermission(){
        return true;
    }     
    

    public String getMslURL() {
        return mslURL;
    }
    

    
    
}