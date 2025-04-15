/**
 * Created by patryk.witkowski_bri on 4/11/2025.
 */

@IsTest
private class LeadCrudCalloutTest {

    @TestSetup
    static void setup() {
        Lead testLead = new Lead(
                FirstName = 'John',
                LastName = 'Doe',
                Email = 'john.doe@example.com',
                Company = 'Test Company',
                Title = 'Developer'
        );
        insert testLead;
    }

    @IsTest
    static void testGetLeadSuccess() {
        // Arrange
        Lead testLead = [
                SELECT Id, FirstName, LastName, Email, Company, Title
                FROM Lead
                LIMIT 1
        ];
        RestRequest request = new RestRequest();
        request.requestURI = '/services/apexrest/lead/crud';
        request.httpMethod = 'GET';
        request.params.put('id', testLead.Id);
        RestContext.request = request;
        RestContext.response = new RestResponse();

        // Act
        Test.startTest();
        LeadCrudOperations.getLead();
        Test.stopTest();

        // Assert
        System.assertEquals(200, RestContext.response.statusCode, 'Status code should be 200');
        Lead responseLead = (Lead) JSON.deserialize(RestContext.response.responseBody.toString(), Lead.class);
        System.assertEquals(testLead.Id, responseLead.Id, 'Lead ID should match');
        System.assertEquals(testLead.FirstName, responseLead.FirstName, 'FirstName should match');
    }

    @IsTest
    static void testGetLeadNoIdParameter() {
        // Arrange
        RestRequest request = new RestRequest();
        request.requestURI = '/services/apexrest/lead/crud';
        request.httpMethod = 'GET';
        RestContext.request = request;
        RestContext.response = new RestResponse();

        // Act
        Test.startTest();
        LeadCrudOperations.getLead();
        Test.stopTest();

        // Assert
        System.assertEquals(400, RestContext.response.statusCode, 'Status code should be 400');
        List<LeadCrudOperations.ErrorResponse> errorResponse = (List<LeadCrudOperations.ErrorResponse>) JSON.deserialize(RestContext.response.responseBody.toString(), List<LeadCrudOperations.ErrorResponse>.class);
        System.assertEquals('Specify the ID parameter', errorResponse.get(0).message, 'Error message should indicate missing ID');
        System.assertEquals('NO_PARAMETER', errorResponse.get(0).errorCode, 'Code should be NO_PARAMETER');
    }

    @IsTest
    static void testGetLeadNoLead() {
        RestRequest request = new RestRequest();
        request.requestURI = '/services/apexrest/lead/crud';
        request.httpMethod = 'GET';
        request.params.put('id', '222221111111');

        RestResponse response = new RestResponse();
        RestContext.request = request;
        RestContext.response = response;

        Test.startTest();
        LeadCrudOperations.getLead();
        Test.stopTest();

        System.assertEquals(404, RestContext.response.statusCode, 'Status code should be 404');
        List<LeadCrudOperations.ErrorResponse> errorResponse = (List<LeadCrudOperations.ErrorResponse>) JSON.deserialize(RestContext.response.responseBody.toString(), List<LeadCrudOperations.ErrorResponse>.class);
        System.assertEquals('NOT_FOUND', errorResponse.get(0).errorCode, 'Code should be NOT_FOUND');
        System.assertEquals('There is no record with given ID', errorResponse.get(0).message, 'Record shouldn\'t exist');

    }

    @IsTest
    static void testDeleteLeadSuccess() {
        Lead testLead = [
                SELECT Id
                FROM Lead
                LIMIT 1
        ];
        RestRequest request = new RestRequest();
        request.requestURI = '/services/apexrest/lead/crud';
        request.httpMethod = 'DELETE';
        request.params.put('id', testLead.Id);

        RestResponse response = new RestResponse();
        RestContext.request = request;
        RestContext.response = response;

        Test.startTest();
        LeadCrudOperations.deleteLead();
        Test.stopTest();

        System.assertEquals(200, response.statusCode, 'Status code should be 200');
        String result = RestContext.response.responseBody.toString();
        System.assertEquals('"Record deleted successfully"', result);
        List<Lead> deletedLead = [SELECT Id FROM Lead WHERE Id = :testLead.Id];
        System.assertEquals(true, deletedLead.isEmpty(), 'List should be empty');

    }

    @IsTest
    static void testDeleteLeadNoParameter() {
        RestRequest request = new RestRequest();
        request.requestURI = '/services/apexrest/lead/crud';
        request.httpMethod = 'DELETE';

        RestResponse response = new RestResponse();
        RestContext.response = response;
        RestContext.request = request;

        Test.startTest();
        LeadCrudOperations.deleteLead();
        Test.stopTest();

        System.assertEquals(400, RestContext.response.statusCode, 'Status code should be 400');
        List<LeadCrudOperations.ErrorResponse> errorResponse = (List<LeadCrudOperations.ErrorResponse>) JSON.deserialize(RestContext.response.responseBody.toString(), List<LeadCrudOperations.ErrorResponse>.class);
        System.assertEquals('NO_PARAMETER', errorResponse.get(0).errorCode, 'Id parameter shouldn\'t exist');
        System.assertEquals('Specify the ID parameter', errorResponse.get(0).message, 'Id parameter should be specified');
    }

    @IsTest
    static void testDeleteLeadNoLead() {
        RestRequest request = new RestRequest();
        request.requestURI = '/services/apexrest/lead/crud';
        request.httpMethod = 'DELETE';
        request.params.put('id', 'bfdbdfvfdvsdcds');

        RestResponse response = new RestResponse();
        RestContext.response = response;
        RestContext.request = request;

        Test.startTest();
        LeadCrudOperations.deleteLead();
        Test.stopTest();

        System.assertEquals(404, RestContext.response.statusCode, 'Status code should be 404');
        List<LeadCrudOperations.ErrorResponse> errorResponse = (List<LeadCrudOperations.ErrorResponse>) JSON.deserialize(RestContext.response.responseBody.toString(), List<LeadCrudOperations.ErrorResponse>.class);
        System.assertEquals('NOT_FOUND', errorResponse.get(0).errorCode, 'Code should be NOT_FOUND');
        System.assertEquals('There is no record with given ID', errorResponse.get(0).message, 'Record shouldn\'t exist');
    }

    @IsTest
    static void testCreateLeadSuccess() {
        Map<String, Object> leadMap = new Map<String, Object>{
          'firstname' => 'Marek',
          'lastname' => 'Markowski',
          'company' => 'Britenet',
          'email' => 'marek.markowski@britenet.eu'
        };

        RestRequest request = new RestRequest();
        request.requestURI = '/services/apexrest/lead/crud';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueOf(JSON.serialize(leadMap));

        RestResponse response = new RestResponse();
        RestContext.response = response;
        RestContext.request = request;

        Test.startTest();
        LeadCrudOperations.createLead();
        Test.stopTest();

        String email = leadMap.get('email').toString();

        System.assertEquals(201, RestContext.response.statusCode, 'Status code should be 201');
        List<Lead> leads = [
                SELECT FirstName
                FROM Lead
                WHERE Email = :email
        ];
        System.assertEquals(false, leads.isEmpty(), 'Lead should be created');
        System.assertEquals('Marek', leads.get(0).FirstName, 'First name should match');
    }

    @IsTest
    static void testCreateLeadUnsuccessfull() {
        Map<String, Object> leadMap = new Map<String, Object> {
          'firstname' => 'Patryk',
          'woda' => 'Patryk'
        };

        RestRequest request = new RestRequest();
        request.requestURI = '/services/apexrest/lead/crud';
        request.httpMethod = 'POST';
        request.requestBody = Blob.valueOf(JSON.serialize(leadMap));

        RestResponse response = new RestResponse();
        RestContext.response = response;
        RestContext.request = request;

        Test.startTest();
        LeadCrudOperations.createLead();
        Test.stopTest();

        System.assertEquals(500, RestContext.response.statusCode, 'Status code should be 500');
        List<LeadCrudOperations.ErrorResponse> errorResponse = (List<LeadCrudOperations.ErrorResponse>) JSON.deserialize(RestContext.response.responseBody.toString(), List<LeadCrudOperations.ErrorResponse>.class);
        System.assertEquals('Invalid field woda for Lead', errorResponse.get(0).message, 'Lead has no that field');
        System.assertEquals('SERVER_PROBLEM', errorResponse.get(0).errorCode);
    }

    @IsTest
    static void testUpdateLeadSuccess() {
        List<Lead> lead = [SELECT Id FROM Lead LIMIT 1];

        Map<String, Object> updateLeadMap = new Map<String, Object>{
          'id' => lead.get(0).Id,
          'firstname' => 'Wladek'
        };

        RestRequest request = new RestRequest();
        request.requestURI = '/services/apexrest/lead/crud';
        request.httpMethod = 'PATCH';
        request.requestBody = Blob.valueOf(JSON.serialize(updateLeadMap));

        RestResponse response = new RestResponse();
        RestContext.request = request;
        RestContext.response = response;

        Test.startTest();
        LeadCrudOperations.updateLead();
        Test.stopTest();

        System.assertEquals(200, RestContext.response.statusCode, 'Status code should be 200');
        List<Lead> updatedLead = [SELECT Id, FirstName FROM Lead WHERE Id = :lead.get(0).Id LIMIT 1];
        System.assertEquals('Wladek', updatedLead.get(0).FirstName, 'First name should be updated');
    }

    @IsTest
    static void testUpdateLeadNoParameter() {
        Map<String, Object> noIdLeadMap = new Map<String, Object> {
          'firstname' => 'Patryk'
        };
        RestRequest request = new RestRequest();
        request.requestURI = '/services/apexrest/lead/crud';
        request.httpMethod = 'PATCH';
        request.requestBody = Blob.valueOf(JSON.serialize(noIdLeadMap));

        RestResponse response = new RestResponse();
        RestContext.response = response;
        RestContext.request = request;

        Test.startTest();
        LeadCrudOperations.updateLead();
        Test.stopTest();

        System.assertEquals(400, RestContext.response.statusCode, 'Status code should be 400');
        List<LeadCrudOperations.ErrorResponse> errorResponse = (List<LeadCrudOperations.ErrorResponse>) JSON.deserialize(RestContext.response.responseBody.toString(), List<LeadCrudOperations.ErrorResponse>.class);
        System.assertEquals('NO_PARAMETER', errorResponse.get(0).errorCode, 'Code should be NO_PARAMETER');
        System.assertEquals('Specify the ID parameter', errorResponse.get(0).message, 'Id parameter should be specified');
    }

    @IsTest
    static void testUpdateLeadNoBody() {
        RestRequest request = new RestRequest();
        request.requestURI = '/services/apexrest/lead/crud';
        request.httpMethod = 'PATCH';

        RestResponse response = new RestResponse();

        RestContext.request = request;
        RestContext.response = response;

        Test.startTest();
        LeadCrudOperations.updateLead();
        Test.stopTest();

        System.assertEquals(500, RestContext.response.statusCode, 'Status code should be 500');
        List<LeadCrudOperations.ErrorResponse> errorResponse = (List<LeadCrudOperations.ErrorResponse>) JSON.deserialize(RestContext.response.responseBody.toString(), List<LeadCrudOperations.ErrorResponse>.class);
        System.assertEquals('Argument cannot be null.', errorResponse.get(0).message, 'There is no body send in request');
        System.assertEquals('SERVER_PROBLEM', errorResponse.get(0).errorCode);
    }

    @IsTest
    static void testUpdateLeadNotFound() {
        Map<String, Object> leadMapNoId = new Map<String, Object> {
          'id' => 'asfsacascas',
          'firstname' => 'Zenon'
        };

        RestRequest request = new RestRequest();
        request.httpMethod = 'PATCH';
        request.requestURI = '/services/apexrest/lead/crud';
        request.requestBody = Blob.valueOf(JSON.serialize(leadMapNoId));

        RestResponse response = new RestResponse();
        RestContext.response = response;
        RestContext.request = request;

        Test.startTest();
        LeadCrudOperations.updateLead();
        Test.stopTest();

        System.assertEquals(404, RestContext.response.statusCode, 'Status code should be 404');
        List<LeadCrudOperations.ErrorResponse> errorResponse = (List<LeadCrudOperations.ErrorResponse>) JSON.deserialize(RestContext.response.responseBody.toString(), List<LeadCrudOperations.ErrorResponse>.class);
        System.assertEquals('NOT_FOUND', errorResponse.get(0).errorCode);
        System.assertEquals('There is no record with given ID', errorResponse.get(0).message);
    }
}