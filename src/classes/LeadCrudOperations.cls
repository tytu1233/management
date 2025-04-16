/**
 * Created by patryk.witkowski_bri on 4/9/2025.
 */

@RestResource(UrlMapping='/lead/crud')
global without sharing class LeadCrudOperations {
    private String hello = 'Darkness my oldest friendOoOOOooOOoOOOo';
    public static List<ErrorResponse> errors = new List<ErrorResponse>();
    @HttpGet
    global static void getLead() {
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;
        Map<String, String> params = request.params;

        try {
            String id;
            Boolean idExist = false;
            for(String paramName : params.keySet()) {
                if(paramName.equalsIgnoreCase('id')) {
                    id = params.get(paramName);
                    idExist = true;
                    break;
                }
            }

            if(!idExist) {
                throw new NoParameterException('Specify the ID parameter');
            }

            List<Lead> lead = [
                    SELECT FirstName, LastName, Email, Company, Title
                    FROM Lead
                    WHERE Id = :id
                    LIMIT 1
            ];

            if(lead.size() == 0) {
                throw new NotFoundException('There is no record with given ID');
            }
            response.statusCode = 200;
            response.responseBody = Blob.valueOf(JSON.serialize(lead.get(0)));
        } catch (NotFoundException ex) {
            ErrorResponse errorResponse = new ErrorResponse();
            errorResponse.message = ex.getMessage();
            errorResponse.errorCode = 'NOT_FOUND';
            errors.add(errorResponse);
            response.statusCode = 404;
            response.responseBody = Blob.valueOf(JSON.serialize(errors));
        } catch (NoParameterException ex) {
            ErrorResponse errorResponse = new ErrorResponse();
            errorResponse.message = ex.getMessage();
            errorResponse.errorCode = 'NO_PARAMETER';
            errors.add(errorResponse);
            response.statusCode = 400;
            response.responseBody = Blob.valueOf(JSON.serialize(errors));
        } catch (Exception ex) {
            ErrorResponse errorResponse = new ErrorResponse();
            errorResponse.message = ex.getMessage();
            errorResponse.errorCode = 'SERVER_PROBLEM';
            errors.add(errorResponse);
            response.statusCode = 500;
            response.responseBody = Blob.valueOf(JSON.serialize(errors));
        }
    }

    @HttpDelete
    global static void deleteLead() {
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;
        Map<String, String> params = request.params;

        try {
            String id;
            Boolean idExist = false;
            for(String paramName : params.keySet()) {
                if(paramName.equalsIgnoreCase('id')) {
                    id = params.get(paramName);
                    idExist = true;
                    break;
                }
            }

            if(!idExist) {
                throw new NoParameterException('Specify the ID parameter');
            }

            List<Lead> lead = [
                    SELECT FirstName, LastName, Email, Company, Title
                    FROM Lead
                    WHERE Id = :id
                    LIMIT 1
            ];

            if(lead.size() == 0) {
                throw new NotFoundException('There is no record with given ID');
            }

            delete lead.get(0);

            response.statusCode = 200; // OK
            response.responseBody = Blob.valueOf(JSON.serialize('Record deleted successfully'));
        } catch (NotFoundException ex) {
            ErrorResponse errorResponse = new ErrorResponse();
            errorResponse.message = ex.getMessage();
            errorResponse.errorCode = 'NOT_FOUND';
            errors.add(errorResponse);
            response.statusCode = 404;
            response.responseBody = Blob.valueOf(JSON.serialize(errors));
        } catch (NoParameterException ex) {
            ErrorResponse errorResponse = new ErrorResponse();
            errorResponse.message = ex.getMessage();
            errorResponse.errorCode = 'NO_PARAMETER';
            errors.add(errorResponse);
            response.statusCode = 400;
            response.responseBody = Blob.valueOf(JSON.serialize(errors));
        } catch (Exception ex) {
            ErrorResponse errorResponse = new ErrorResponse();
            errorResponse.message = ex.getMessage();
            errorResponse.errorCode = 'SERVER_PROBLEM';
            errors.add(errorResponse);
            response.statusCode = 500;
            response.responseBody = Blob.valueOf(JSON.serialize(errors));
        }
    }

    @HttpPost
    global static void createLead() {
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;
        try {
            Map<String, Object> requestBody = (Map<String, Object>) JSON.deserializeUntyped(request.requestBody.toString());
            Lead lead = new Lead();

            for(String key : requestBody.keySet()) {
                lead.put(key, requestBody.get(key));
            }
            insert lead;

            SuccessResponse successResponse = new SuccessResponse();
            successResponse.code = 'CREATED';
            successResponse.Id = lead.Id;

            response.statusCode = 201;
            response.responseBody = Blob.valueOf(JSON.serialize(successResponse));

        } catch (Exception ex) {
            ErrorResponse errorResponse = new ErrorResponse();
            errorResponse.message = ex.getMessage();
            errorResponse.errorCode = 'SERVER_PROBLEM';
            errors.add(errorResponse);
            response.statusCode = 500;
            response.responseBody = Blob.valueOf(JSON.serialize(errors));
        }

    }

    @HttpPatch
    global static void updateLead() {
        RestRequest request = RestContext.request;
        RestResponse response = RestContext.response;
        try {
            Map<String, Object> requestBody = (Map<String, Object>) JSON.deserializeUntyped(request.requestBody.toString());
            String id;
            Boolean idExist = false;
            for(String data : requestBody.keySet()) {
                if(data.equalsIgnoreCase('id')) {
                    id = requestBody.get(data).toString();
                    idExist = true;
                    break;
                }
            }

            if(!idExist) {
                throw new NoParameterException('Specify the ID parameter');
            }

            List<Lead> leads = [
                    SELECT Id, FirstName, LastName, Email, Title
                    FROM Lead
                    WHERE Id = :id
            ];

            if(leads.isEmpty()) {
                throw new NotFoundException('There is no record with given ID');
            }

            Lead lead = leads.get(0);

            for(String key : requestBody.keySet()) {
                lead.put(key, requestBody.get(key));
            }

            update lead;

            SuccessResponse successResponse = new SuccessResponse();
            successResponse.code = '200';

            response.statusCode = 200;
            response.responseBody = Blob.valueOf(JSON.serialize(lead));

        } catch (NoParameterException ex) {
            ErrorResponse errorResponse = new ErrorResponse();
            errorResponse.message = ex.getMessage();
            errorResponse.errorCode = 'NO_PARAMETER';
            errors.add(errorResponse);
            response.statusCode = 400;
            response.responseBody = Blob.valueOf(JSON.serialize(errors));
        } catch (NotFoundException ex) {
            ErrorResponse errorResponse = new ErrorResponse();
            errorResponse.message = ex.getMessage();
            errorResponse.errorCode = 'NOT_FOUND';
            errors.add(errorResponse);
            response.statusCode = 404;
            response.responseBody = Blob.valueOf(JSON.serialize(errors));
        } catch (Exception ex) {
            ErrorResponse errorResponse = new ErrorResponse();
            errorResponse.message = ex.getMessage();
            errorResponse.errorCode = 'SERVER_PROBLEM';
            errors.add(errorResponse);
            response.statusCode = 500;
            response.responseBody = Blob.valueOf(JSON.serialize(errors));
        }

    }

    private class NotFoundException extends Exception {}

    private class NoParameterException extends Exception {}

    global class ErrorResponse {
        public String errorCode;
        public String message;
    }

    global class SuccessResponse {
        public String code;
        public String Id;
    }
}