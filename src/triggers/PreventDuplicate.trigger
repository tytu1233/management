/**
 * Created by patryk.witkowski_bri on 4/9/2025.
 */

trigger PreventDuplicate on Lead (before insert) {
    if (Trigger.isBefore && Trigger.isInsert) {
        List<Lead> webLeads = new List<Lead>();

        Set<String> newLeadKeys = new Set<String>();

        for (Lead l : Trigger.new) {
            if (l.LeadSource == 'Web' &&
                    String.isNotBlank(l.FirstName) &&
                    String.isNotBlank(l.LastName) &&
                    String.isNotBlank(l.Email)) {

                String key = l.FirstName.trim().toLowerCase() + '|' +
                        l.LastName.trim().toLowerCase() + '|' +
                        l.Email.trim().toLowerCase();

                newLeadKeys.add(key);
                webLeads.add(l);
            }
        }

        if (webLeads.isEmpty()) return;

        List<Lead> recentLeads = [
                SELECT FirstName, LastName, Email, CreatedDate
                FROM Lead
                WHERE CreatedDate = LAST_N_DAYS:2
                AND LeadSource = 'Web'
                AND FirstName != null AND LastName != null AND Email != null
        ];

        Set<String> recentLeadKeys = new Set<String>();
        for (Lead l : recentLeads) {
            String key = l.FirstName.trim().toLowerCase() + '|' +
                    l.LastName.trim().toLowerCase() + '|' +
                    l.Email.trim().toLowerCase();
            recentLeadKeys.add(key);
        }

        for (Lead l : webLeads) {
            String key = l.FirstName.trim().toLowerCase() + '|' +
                    l.LastName.trim().toLowerCase() + '|' +
                    l.Email.trim().toLowerCase();
            if (recentLeadKeys.contains(key)) {
                l.addError('A similar lead has already been created in the last 48 hours.');
            }
        }
    }
}