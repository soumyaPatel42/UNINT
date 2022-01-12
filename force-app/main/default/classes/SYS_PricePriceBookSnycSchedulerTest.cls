@isTest
public class SYS_PricePriceBookSnycSchedulerTest {
	@isTest
    public static void checkPricebookProductOutboundScheduler(){
        String resJson = '{"Item":{"Name":"cosmatics","Description":"p1","Active":true,"FullyQualifiedName":"cosmatics","Taxable":true,"UnitPrice":100,"Type":"NonInventory","IncomeAccountRef":{"value":"94","name":"Generic Income Acc"},"PurchaseCost":0,"TrackQtyOnHand":false,"domain":"QBO","sparse":false,"Id":"40","SyncToken":"0","MetaData":{"CreateTime":"2021-10-05T13:06:36-07:00","LastUpdatedTime":"2021-10-05T13:06:36-07:00"}},"time":"2021-10-05T13:06:38.571-07:00"}';
		Map < String, String > responseHeaders = new Map < String, String > ();
		responseHeaders.put('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, new QuickBookCalloutMock(200, 'OK', resJson, responseHeaders));
		Product2 productData = QuickbooksTestDataFactory.productCreate();
		insert productData;
		system.debug('productdetails' + productData);
		PricebookEntry pricebookEntryData = QuickbooksTestDataFactory.PricebookEntryCreate(productData.Id);
        insert pricebookEntryData;
		system.debug('productRecords' + productData);
        Test.startTest();
			SYS_PricePriceBookSnycScheduler syncPrice = new SYS_PricePriceBookSnycScheduler();
			String CRON_EXP = '0 0 * * * ?';
            String jobId = System.schedule('Sync Changed Price from PriceBook into Quickbooks Every '+System.now()+' Minute', CRON_EXP, syncPrice);
            CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];
            System.assertEquals(CRON_EXP, ct.CronExpression);
            System.assertEquals(0, ct.TimesTriggered);

        Test.stopTest();
    }
}