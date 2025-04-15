public class CalloutsTest {
	
    public static void makeCallout(String url) {
        HttpRequest req = new HttpRequest();
        req.setEndpoint(url);
        req.setMethod('GET');
        
        Http http = new Http();
        HttpResponse res = http.send(req);
    }
    
    public static void exceedCalloutLimit() {
        for(Integer i = 0; i < 101; i++) {
            String endpoint = 'https://jsonplaceholder.typicode.com/users/1';
            makeCallout(endpoint);
        }
    }
}