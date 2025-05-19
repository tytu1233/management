/**
 * Created by patryk.witkowski_bri on 5/16/2025.
 */

//TODO: ZROBIC TO BARDZIEJ GENERYCZNIE - POMYSLEC NA WZORCEM
public class MockHttpSuccess implements HttpCalloutMock {
    public HttpResponse respond(HttpRequest request) {
        System.debug('REQUESTELO');
        System.debug(request);

        HttpResponse response = new HttpResponse();
        response.setStatusCode(200);
        response.setStatus('Success');
        //response.setBody('BLAD');
        response.setBody('[{"status":"Success","recordId":"01tgL0000023o5ZQAQ","message":"Record has been created successfully"}]');
        response.setHeader('Content-Type', 'application/json');

        return response;
    }
}