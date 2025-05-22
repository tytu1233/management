/**
 * Created by patryk.witkowski_bri on 5/16/2025.
 */

public class MockHttpResponse implements HttpCalloutMock {
    private Integer statusCode;
    private String responseBody;

    public MockHttpResponse(Integer statusCode, String responseBody) {
        this.statusCode = statusCode;
        this.responseBody = responseBody;
    }

    public HttpResponse respond(HttpRequest req) {
        if (responseBody == '') {
            throw new CalloutException('Network error');
        }

        HttpResponse res = new HttpResponse();
        res.setHeader('Content-Type', 'application/json');
        res.setBody(responseBody);
        res.setStatusCode(statusCode);
        return res;
    }
}