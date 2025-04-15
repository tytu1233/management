/**
 * Created by patryk.witkowski_bri on 4/15/2025.
 */

/**
 * Test class for PreventDuplicate trigger on Lead
 * Tests the prevention of duplicate web leads based on FirstName, LastName, and Email within 48 hours
 */
@isTest
private class PreventDuplicateTriggerTest {

    // Test inserting a duplicate web lead within 48 hours
    @isTest
    static void testPreventDuplicateWebLead() {
        // Create an existing lead within the last 48 hours
        Lead existingLead = new Lead(
                FirstName = 'John',
                LastName = 'Doe',
                Email = 'john.doe@test.com',
                Company = 'Test Company',
                LeadSource = 'Web',
                Status = 'Open - Not Contacted'
        );
        insert existingLead;

        // Create a new lead with the same details
        Lead newLead = new Lead(
                FirstName = 'John',
                LastName = 'Doe',
                Email = 'john.doe@test.com',
                Company = 'Test Company',
                LeadSource = 'Web',
                Status = 'Open - Not Contacted'
        );

        // Start test
        Test.startTest();
        try {
            insert newLead;
            System.assert(false, 'Insert should have failed due to duplicate lead');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('A similar lead has already been created in the last 48 hours'),
                    'Error message should indicate duplicate lead');
        }
        Test.stopTest();
    }

    // Test inserting a non-duplicate web lead
    @isTest
    static void testAllowNonDuplicateWebLead() {
        // Create an existing lead
        Lead existingLead = new Lead(
                FirstName = 'John',
                LastName = 'Doe',
                Email = 'john.doe@test.com',
                Company = 'Test Company',
                LeadSource = 'Web',
                Status = 'Open - Not Contacted'
        );
        insert existingLead;

        // Create a new lead with different details
        Lead newLead = new Lead(
                FirstName = 'Jane',
                LastName = 'Smith',
                Email = 'jane.smith@test.com',
                Company = 'Test Company',
                LeadSource = 'Web',
                Status = 'Open - Not Contacted'
        );

        // Start test
        Test.startTest();
        insert newLead;
        Test.stopTest();

        // Verify the new lead was inserted
        List<Lead> leads = [SELECT Id FROM Lead WHERE Email = 'jane.smith@test.com'];
        System.assertEquals(1, leads.size(), 'Non-duplicate lead should be inserted');
    }

    // Test inserting a web lead with null fields
    @isTest
    static void testWebLeadWithNullFields() {
        // Create a new lead with null fields
        Lead newLead = new Lead(
                FirstName = null,
                LastName = 'Doe',
                Email = 'john.doe@test.com',
                Company = 'Test Company',
                LeadSource = 'Web',
                Status = 'Open - Not Contacted'
        );

        // Start test
        Test.startTest();
        insert newLead;
        Test.stopTest();

        // Verify the lead was inserted (null fields bypass duplicate check)
        List<Lead> leads = [SELECT Id FROM Lead WHERE Email = 'john.doe@test.com'];
        System.assertEquals(1, leads.size(), 'Lead with null fields should be inserted');
    }

    // Test bulk insert with mix of duplicate and non-duplicate leads
    @isTest
    static void testBulkInsertMixedLeads() {
        // Create an existing lead
        Lead existingLead = new Lead(
                FirstName = 'John',
                LastName = 'Doe',
                Email = 'john.doe@test.com',
                Company = 'Test Company',
                LeadSource = 'Web',
                Status = 'Open - Not Contacted'
        );
        insert existingLead;

        // Prepare bulk leads
        List<Lead> newLeads = new List<Lead>();
        // Duplicate lead
        newLeads.add(new Lead(
                FirstName = 'John',
                LastName = 'Doe',
                Email = 'john.doe@test.com',
                Company = 'Test Company',
                LeadSource = 'Web',
                Status = 'Open - Not Contacted'
        ));
        // Non-duplicate lead
        newLeads.add(new Lead(
                FirstName = 'Jane',
                LastName = 'Smith',
                Email = 'jane.smith@test.com',
                Company = 'Test Company',
                LeadSource = 'Web',
                Status = 'Open - Not Contacted'
        ));

        // Start test
        Test.startTest();
        try {
            insert newLeads;
            System.assert(false, 'Bulk insert should fail due to duplicate lead');
        } catch (DmlException e) {
            System.assert(e.getMessage().contains('A similar lead has already been created in the last 48 hours'),
                    'Error message should indicate duplicate lead');
        }
        Test.stopTest();

        // Verify non-duplicate lead was not inserted due to bulk failure
        List<Lead> leads = [SELECT Id FROM Lead WHERE Email = 'jane.smith@test.com'];
        System.assertEquals(0, leads.size(), 'Non-duplicate lead should not be inserted due to bulk failure');
    }

    // Test lead older than 48 hours (no duplicate error)
    @isTest
    static void testLeadOlderThan48Hours() {
        // Create an existing lead with an older CreatedDate
        Lead existingLead = new Lead(
                FirstName = 'John',
                LastName = 'Doe',
                Email = 'john.doe@test.com',
                Company = 'Test Company',
                LeadSource = 'Web',
                Status = 'Open - Not Contacted'
        );
        insert existingLead;

        // Set CreatedDate to more than 48 hours ago using Test.setCreatedDate
        Test.setCreatedDate(existingLead.Id, DateTime.now().addDays(-3));

        // Create a new lead with the same details
        Lead newLead = new Lead(
                FirstName = 'John',
                LastName = 'Doe',
                Email = 'john.doe@test.com',
                Company = 'Test Company',
                LeadSource = 'Web',
                Status = 'Open - Not Contacted'
        );

        // Start test
        Test.startTest();
        insert newLead;
        Test.stopTest();

        // Verify the new lead was inserted
        List<Lead> leads = [SELECT Id FROM Lead WHERE Email = 'john.doe@test.com'];
        System.assertEquals(2, leads.size(), 'New lead should be inserted as existing lead is older than 48 hours');
    }
}