/**
 * Created by patryk.witkowski_bri on 5/16/2025.
 */

public class MockHttpFailed implements HttpCalloutMock {
    public HttpResponse respond(HttpRequest request) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setStatusCode(400);
        response.setBody('{"message": "Mission failed successfully"}');
        return response;
    }
}