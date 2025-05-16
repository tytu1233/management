/**
 * Created by patryk.witkowski_bri on 5/16/2025.
 */

//TODO: ZROBIC TO BARDZIEJ GENERYCZNIE - POMYSLEC NA WZORCEM
public class MockHttpSuccess implements HttpCalloutMock {
    public HttpResponse respond(HttpRequest request) {
        HttpResponse response = new HttpResponse();
        response.setStatusCode(200);
        response.setBody('{"message": "Record inserted successfully"}');
        response.setHeader('Content-Type', 'application/json');

        return response;
    }
}