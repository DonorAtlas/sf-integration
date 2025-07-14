public class DonorAtlasMapper {
    /**
     * Build the outbound JSON payload for one Contact.
     * Extend this method as you add more enrichment fields.
     */
    public static Map<String, Object> buildRequest(Contact c) {
        return new Map<String, Object>{
            'firstName' => c.FirstName,
            'lastName'  => c.LastName,
            'email'     => c.Email
        };
    }

    /**
     * Apply inbound enrichment data to the Contact record.
     */
    public static void apply(Id contactId, Map<String, Object> enrich) {
        Contact updateContact = new Contact(
            Id                     = contactId,
            Age__c                 = (Integer)  enrich.get('age'),
            Bio__c                 = (String)   enrich.get('bio'),
            Religion__c            = (String)   enrich.get('religion'),
            NetWorthMin__c         = (Decimal)  enrich.get('netWorthMin'),
            NetWorthMax__c         = (Decimal)  enrich.get('netWorthMax'),
            PredictedAnnualGiving__c = (Decimal) enrich.get('annualGiving'),
            Donations__c           = JSON.serialize(enrich.get('donations'))
        );
        update updateContact;
    }
}