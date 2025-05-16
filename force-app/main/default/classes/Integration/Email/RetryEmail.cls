/**
 * Created by patryk.witkowski_bri on 5/16/2025.
 */

public class RetryEmail {

    private final List<Product_Logger__c> productLoggers;

    public RetryEmail(List<Product_Logger__c> productLoggers) {
        this.productLoggers = productLoggers;
    }

    public void sendEmail() {
        String emailBody = '<h2>Product Logger Records with 3 or More Retries</h2>';
        emailBody += '<p>The following records have failed after 3 or more retry attempts:</p>';
        emailBody += '<table border="1" cellpadding="5">';
        emailBody += '<tr><th>Record ID</th><th>Product ID</th><th>Method</th><th>Retry Count</th><th>Status</th></tr>';

        for (Product_Logger__c record : this.productLoggers) {
            emailBody += '<tr>';
            emailBody += '<td>' + record.Id + '</td>';
            emailBody += '<td>' + record.Product__c + '</td>';
            emailBody += '<td>' + record.Method__c + '</td>';
            emailBody += '<td>' + record.Retry__c + '</td>';
            emailBody += '<td>' + record.Status__c + '</td>';
            emailBody += '</tr>';
        }
        emailBody += '</table>';
        emailBody += '<p>Total Records: ' + productLoggers.size() + '</p>';

        Messaging.SingleEmailMessage emailMessage = new Messaging.SingleEmailMessage();
        emailMessage.setToAddresses(new String[]{'patryk.witkowski@britenet.eu'});
        emailMessage.setSubject('Product Logger Batch: Records with 3 or More Retries');
        emailMessage.setHtmlBody(emailBody);

        Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{emailMessage});
    }
}