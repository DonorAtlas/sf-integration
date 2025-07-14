global class DonorAtlasQueueable implements Queueable, Database.AllowsCallouts {
    private final List<Id> contactIds;
    private static final String NC = 'DonorAtlas';

    public DonorAtlasQueueable(List<Id> ids) {
        contactIds = ids;
    }

    global void execute(QueueableContext qc) {
        // Get minimal data for each Contact
        List<Contact> contacts = [
            SELECT Id, FirstName, LastName, Email
            FROM Contact
            WHERE Id IN :contactIds
        ];

        // Build one request per Contact (≤10 per transaction to respect limits)
        for (Contact c : contacts) {
            HttpRequest req = new HttpRequest();
            req.setEndpoint('callout:' + NC + '/v1/enrichment/jobs');
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/json');
            req.setBody(JSON.serialize(new Map<String, Object>{
                'salesforceId' => c.Id,
                'payload'      => DonorAtlasMapper.buildRequest(c)
            }));
            new Http().send(req);      // governor-safe because we allow callouts
        }

        /* Chain additional jobs if we have more than 10 contacts
           (omitted for brevity—add paging logic here). */
    }
}