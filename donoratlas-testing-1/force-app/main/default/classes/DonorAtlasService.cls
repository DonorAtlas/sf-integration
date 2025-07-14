public with sharing class DonorAtlasService {
    private static final String NC = 'DonorAtlas';      // Named Credential (Per-User)

    /**
     * Enqueue a single-record enrichment job.
     * Called by the LWC quick-action.
     */
    @AuraEnabled
    public static void startSingle(Id contactId) {
        System.enqueueJob(new DonorAtlasQueueable(new List<Id>{ contactId }));
    }

    /**
     * Enqueue many contacts (list-view mass action).
     */
    @AuraEnabled
    public static void startBulk(List<Id> contactIds) {
        System.enqueueJob(new DonorAtlasQueueable(contactIds));
    }
}