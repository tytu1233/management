/**
 * Created by patryk.witkowski_bri on 4/8/2025.
 */

global without sharing class LeadSubmissionController {

    @RemoteAction
    global static String createAndVerifyLead(String firstName, String lastName, String company, String email) {

        try {
            if (String.isBlank(email)) {
                return 'Error: Email is required';
            }

            Lead lead = new Lead();
            lead.FirstName = firstName;
            lead.LastName = lastName;
            lead.Company = company;
            lead.Email = email;
            lead.LeadSource = 'Web';
            lead.Status = 'Open - Not Contacted';

            insert lead;

            delete lead;

            email = email.trim().toLowerCase();
            firstName = firstName.trim();
            lastName = lastName.trim();

            List<Lead> existingLeads = [SELECT Id, FirstName FROM Lead WHERE FirstName = :firstName AND LastName = :lastName AND Email = :email];

            return !existingLeads.isEmpty() ? 'Exist' : 'Not_Exist';
        } catch (Exception e) {
            return 'Error: ' + e.getMessage();
        }
    }
}