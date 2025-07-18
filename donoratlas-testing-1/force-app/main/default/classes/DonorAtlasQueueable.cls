public with sharing class DonorAtlasQueueable
        implements Queueable, Database.AllowsCallouts {

    private Id contactId;
    public DonorAtlasQueueable(Id contactId) { this.contactId = contactId; }

    public void execute(QueueableContext qc) {
        Contact c = [
            SELECT Id, FirstName, LastName, MailingStreet, MailingCity,
                   MailingState, MailingPostalCode, MailingCountry, Email
            FROM Contact WHERE Id = :contactId LIMIT 1
        ];

        Map<String,Object> payload = new Map<String,Object>{
            'organizationId' => UserInfo.getOrganizationId(),
            'contactId'      => c.Id,
            'firstName'      => c.FirstName,
            'lastName'       => c.LastName,
            'street'         => c.MailingStreet,
            'city'           => c.MailingCity,
            'state'          => c.MailingState,
            'postalCode'     => c.MailingPostalCode,
            'country'        => c.MailingCountry,
            'email'          => c.Email
        };

        HttpRequest req = new HttpRequest();
        req.setEndpoint('callout:DonorAtlas/match');
        req.setMethod('POST');
        req.setHeader('Content-Type', 'application/json');
        req.setBody(JSON.serialize(payload));

        HttpResponse res = new Http().send(req);
        System.debug('DonorAtlas match callout status: ' + res.getStatus());
    }
}