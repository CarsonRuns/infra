public class Bookings_CT {

String URL = Utilities.getConstant_CS('wwwin-tools');
String iweURL = Utilities.getConstant_CS('iwe');

public String getURL() {
        return URL;
}
public String getIweURL() {
        return iweURL;
    }


//TEST METHOD//
    public static testMethod void test_Bookings_CT(){
        Bookings_CT controller = new Bookings_CT();
        controller.getURL();
        controller.getIweURL();
    }
}