@RestResource(urlMapping='/donoratlas/enrichment/*')
global with sharing class DonorAtlasCallback {
    /**
     * DonorAtlas pushes results when a job finishes.
     * Body example:
     * {
     *   "salesforceId" : "003xxxxxxxxxxxx",
     *   "data" : { "age":55, "capacityScore":85, ... }
     * }
     */
    @HttpPost
    global static void receive() {
        String body = RestContext.request.requestBody.toString();
        Map<String, Object> wrapper =
            (Map<String, Object>) JSON.deserializeUntyped(body);

        Id contactId                  = (Id)    wrapper.get('salesforceId');
        Map<String, Object> enrich    = (Map<String, Object>) wrapper.get('data');

        DonorAtlasMapper.apply(contactId, enrich);
    }
}