public with sharing class DonorAtlasService {
    @AuraEnabled(cacheable=false)
    public static void enhanceContact(Id contactId) {
        if (!DonorAtlasLicenseUtil.isLicensed()) {
            throw new AuraHandledException('DonorAtlas license inactive.');
        }
        System.enqueueJob(new DonorAtlasQueueable(contactId));
    }
}