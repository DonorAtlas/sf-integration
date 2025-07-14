@IsTest
private class DonorAtlasService_Test {

    /** Mock callout that returns immediately so tests are synchronous. */
    private class Mock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setStatusCode(200);
            res.setBody('{"jobId":"123"}');
            return res;
        }
    }

    @IsTest
    static void testSingleEnqueue() {
        Contact c = new Contact(LastName='Test', Email='t@example.com');
        insert c;

        Test.setMock(HttpCalloutMock.class, new Mock());
        Test.startTest();
        DonorAtlasService.startSingle(c.Id);
        Test.stopTest();

        // One queueable job should have run without uncaught errors
        System.assertEquals(1, [SELECT COUNT() FROM AsyncApexJob WHERE JobType='Queueable' AND Status='Completed']);
    }

    @IsTest
    static void testMapperApply() {
        Contact c = new Contact(LastName='Mapper');
        insert c;

        Map<String,Object> inbound = new Map<String,Object>{
            'age'          => 42,
            'bio'          => 'Philanthropist',
            'religion'     => 'Humanist',
            'netWorthMin'  => 1000000,
            'netWorthMax'  => 2000000,
            'annualGiving' => 50000,
            'donations'    => new List<Object>{}
        };

        DonorAtlasMapper.apply(c.Id, inbound);
        Contact updated = [SELECT Age__c, Bio__c FROM Contact WHERE Id=:c.Id];
        System.assertEquals(42, updated.Age__c);
    }
}