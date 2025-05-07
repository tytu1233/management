/**
 * Created by patryk.witkowski_bri on 5/7/2025.
 */

@IsTest
private class LeadSubmissionControllerTest {
    @IsTest
    static void testLeadExists() {
        Lead existingLead = new Lead(
                FirstName = 'John',
                LastName = 'Doe',
                Company = 'Acme Corp',
                Email = 'john.doe@example.com',
                LeadSource = 'Web',
                Status = 'Open - Not Contacted'
        );
        insert existingLead;

        String result = LeadSubmissionController.createAndVerifyLead(
                'John',
                'Doe',
                'Acme Corp',
                'john.doe@example.com'
        );

        Assert.areEqual('Exist', result, 'Should return Exist when a matching Lead is found');

        List<Lead> leads = [SELECT Id FROM Lead WHERE Email = 'john.doe@example.com'];
        Assert.areEqual(1, leads.size(), 'Only the original Lead should remain');
    }

    @IsTest
    static void testLeadDoesNotExist() {

        String result = LeadSubmissionController.createAndVerifyLead(
                'Jane',
                'Smith',
                'Test Corp',
                'jane.smith@example.com'
        );

        Assert.areEqual('Not_Exist', result, 'Should return Not_Exist when no matching Lead is found');

        List<Lead> leads = [SELECT Id FROM Lead WHERE Email = 'jane.smith@example.com'];
        Assert.areEqual(0, leads.size(), 'No Leads should remain');
    }

    @IsTest
    static void testBlankEmail() {
        String result = LeadSubmissionController.createAndVerifyLead(
                'John',
                'Doe',
                'Acme Corp',
                ''
        );

        Assert.areEqual('Error: Email is required', result, 'Should return error for blank email');

        List<Lead> leads = [SELECT Id FROM Lead];
        Assert.areEqual(0, leads.size(), 'No Leads should be created');
    }

    @IsTest
    static void testNullEmail() {
        String result = LeadSubmissionController.createAndVerifyLead(
                'John',
                'Doe',
                'Acme Corp',
                null
        );

        Assert.areEqual('Error: Email is required', result, 'Should return error for null email');

        List<Lead> leads = [SELECT Id FROM Lead];
        Assert.areEqual(0, leads.size(), 'No Leads should be created');
    }

    @IsTest
    static void testEmailWithSpacesAndCase() {
        Lead existingLead = new Lead(
                FirstName = 'John',
                LastName = 'Doe',
                Company = 'Acme Corp',
                Email = 'john.doe@example.com',
                LeadSource = 'Web',
                Status = 'Open - Not Contacted'
        );
        insert existingLead;

        String result = LeadSubmissionController.createAndVerifyLead(
                'John',
                'Doe',
                'Acme Corp',
                '  JOHN.DOE@EXAMPLE.COM  '
        );

        Assert.areEqual('Exist', result, 'Should return Exist when email matches after trimming and lowercase');
    }

    @IsTest
    static void testExceptionHandling() {
        Lead existingLead = new Lead(
                FirstName = 'John',
                LastName = 'Doe',
                Company = 'Acme Corp',
                Email = 'john.doe@example.com',
                LeadSource = 'Web',
                Status = 'Open - Not Contacted'
        );
        insert existingLead;

        String result = LeadSubmissionController.createAndVerifyLead(
                'John',
                'Doe',
                'Acme Corp',
                'john.doe@example.com'
        );

        Assert.areEqual('Exist', result, 'Should handle valid case correctly');
    }

    @IsTest
    static void testMultipleLeads() {
        Lead matchingLead = new Lead(
                FirstName = 'John',
                LastName = 'Doe',
                Company = 'Acme Corp',
                Email = 'john.doe@example.com',
                LeadSource = 'Web',
                Status = 'Open - Not Contacted'
        );
        Lead nonMatchingLead = new Lead(
                FirstName = 'Jane',
                LastName = 'Smith',
                Company = 'Test Corp',
                Email = 'jane.smith@example.com',
                LeadSource = 'Web',
                Status = 'Open - Not Contacted'
        );
        insert new List<Lead>{matchingLead, nonMatchingLead};

        String result = LeadSubmissionController.createAndVerifyLead(
                'John',
                'Doe',
                'Acme Corp',
                'john.doe@example.com'
        );

        Assert.areEqual('Exist', result, 'Should return Exist when a matching Lead is found among multiple');
    }
}