@RestResource(urlMapping='/donoratlas/callback')
global with sharing class DonorAtlasCallback {

    /** Called by DonorAtlas once enrichment is finished. */
    @HttpPost
    global static void receive() {
        RestRequest req = RestContext.request;
        Map<String,Object> wrapper =
            (Map<String,Object>)JSON.deserializeUntyped(req.requestBody.toString());

        Id contactId = (Id)wrapper.get('contactId');
        Map<String,Object> enrichment = (Map<String,Object>)wrapper.get('enrichment');

        if (contactId == null || enrichment == null) {
            RestContext.response.statusCode = 400;
            return;
        }

        Contact updateContact = new Contact(Id = contactId);
        if (enrichment.containsKey('Age'))               updateContact.Age__c               = (Integer)enrichment.get('Age');
        if (enrichment.containsKey('Bio'))               updateContact.Bio__c               = (String)enrichment.get('Bio');
        if (enrichment.containsKey('Donations'))         updateContact.Donations__c         = (String)enrichment.get('Donations');
        if (enrichment.containsKey('NetWorthMin'))       updateContact.NetWorthMin__c       = (Decimal)enrichment.get('NetWorthMin');
        if (enrichment.containsKey('NetWorthMax'))       updateContact.NetWorthMax__c       = (Decimal)enrichment.get('NetWorthMax');
        if (enrichment.containsKey('PredictedAnnualGiving'))
             updateContact.PredictedAnnualGiving__c      = (Decimal)enrichment.get('PredictedAnnualGiving');
        if (enrichment.containsKey('Religion'))          updateContact.Religion__c          = (String) enrichment.get('Religion');
        updateContact.DonorAtlasEnhanced__c = true;

        update updateContact;
    }
}