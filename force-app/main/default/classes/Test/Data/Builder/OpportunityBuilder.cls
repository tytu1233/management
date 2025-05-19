/**
 * Created by patryk.witkowski_bri on 5/14/2025.
 */

public class OpportunityBuilder {
    private final Opportunity opportunity;

    public OpportunityBuilder(String name, Datetime eventDate, Date closeDate, String street, String city, String postalCode) {
        this.opportunity = new Opportunity();
        this.opportunity.Name = name;
        this.opportunity.Event_Date__c = eventDate;
        this.opportunity.Event_Address__Street__s = street;
        this.opportunity.Event_Address__City__s = city;
        this.opportunity.Event_Address__PostalCode__s = postalCode;
        this.opportunity.CloseDate = closeDate;
        this.opportunity.StageName = 'Prospecting';
    }

    public OpportunityBuilder name(String name) {
        this.opportunity.Name = name;
        return this;
    }

    public OpportunityBuilder street(String street) {
        this.opportunity.Event_Address__Street__s = street;
        return this;
    }

    public OpportunityBuilder country(String country) {
        this.opportunity.Event_Address__CountryCode__s = country;
        return this;
    }

    public OpportunityBuilder city(String city) {
        this.opportunity.Event_Address__City__s = city;
        return this;
    }

    public OpportunityBuilder postalCode(String postalCode) {
        this.opportunity.Event_Address__PostalCode__s = postalCode;
        return this;
    }

    public OpportunityBuilder stage(String stage) {
        this.opportunity.StageName = stage;
        return this;
    }

    public OpportunityBuilder eventDate(Datetime eventDate) {
        this.opportunity.Event_Date__c = eventDate;
        return this;
    }

    public OpportunityBuilder closeDate(Date closeDate) {
        this.opportunity.CloseDate = closeDate;
        return this;
    }

    public OpportunityBuilder save() {
        insert this.opportunity;
        return this;
    }

    public Opportunity build() {
        return this.opportunity;
    }
}