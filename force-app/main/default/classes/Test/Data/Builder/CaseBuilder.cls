/**
 * Created by patryk.witkowski_bri on 5/23/2025.
 */

public class CaseBuilder {

    private final Case caseBuild;

    public CaseBuilder() {
        this.caseBuild = new Case();
        this.caseBuild.Status = 'New';
        this.caseBuild.Origin = 'Web';
    }

    public CaseBuilder status(String status) {
        this.caseBuild.Status = status;
        return this;
    }

    public CaseBuilder origin(String origin) {
        this.caseBuild.Origin = origin;
        return this;
    }

    public CaseBuilder priority(String priority) {
        this.caseBuild.Priority = priority;
        return this;
    }

    public CaseBuilder contact(Contact contact) {
        this.caseBuild.Contact = contact;
        return this;
    }

    public CaseBuilder order(String orderId) {
        this.caseBuild.Order__c = orderId;
        return this;
    }

    public CaseBuilder account(Account account) {
        this.caseBuild.Account = account;
        return this;
    }

    public CaseBuilder subject(String subject) {
        this.caseBuild.Subject = subject;
        return this;
    }

    public CaseBuilder description(String description) {
        this.caseBuild.Description = description;
        return this;
    }

    public CaseBuilder save() {
        insert caseBuild;
        return this;
    }

    public Case build() {
        return this.caseBuild;
    }
}