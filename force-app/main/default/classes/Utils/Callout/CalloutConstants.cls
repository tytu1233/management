/**
 * Created by patryk.witkowski_bri on 5/30/2025.
 */

public with sharing class CalloutConstants {
    public Method METHOD { get { return new Method(); } }


    public class Method {
        public String PUT { get { return 'PUT'; } }
        public String POST { get { return 'POST'; } }
    }

}