@isTest
public class QB_ProductTestScenariosInbound {
	//product senarios============================================
   
	@isTest static void ProductInsertInboundTest() {

		String resJson = '{"eventNotifications":[{"realmId":"4620816365172373180","dataChangeEvent":{"entities":[{"operation":"Create","name":"Item","lastUpdated":"2021-10-05T20:06:36.000Z","id":"40"}]}}]}';
		String resJsonImport = '{"Item":{"Name":"cosmatics","Description":"p1","Active":true,"FullyQualifiedName":"cosmatics","Taxable":true,"UnitPrice":100,"Type":"NonInventory","IncomeAccountRef":{"value":"94","name":"Generic Income Acc"},"PurchaseCost":0,"TrackQtyOnHand":false,"domain":"QBO","sparse":false,"Id":"40","SyncToken":"0","MetaData":{"CreateTime":"2021-10-05T13:06:36-07:00","LastUpdatedTime":"2021-10-05T13:06:36-07:00"}},"time":"2021-10-05T13:06:38.571-07:00"}';
		Map < String, String > responseHeaders = new Map < String, String > ();
		responseHeaders.put('Content-Type', 'application/json');
		QB_restmokecallout.requestRestCallout(resJson, 200);
        Test.setMock(HttpCalloutMock.class, new QuickBookCalloutMock(200, 'OK', resJsonImport, responseHeaders));
		Test.startTest();
        SYS_webhook.processWebhookResponse('', resJson);
		Test.stopTest();
         List < SYS_IntegrationLog__c > insertedLogResponse = [SELECT Name, Status__c, SYS_Http_Status__c, SYS_Operation_Type__c, SYS_RequestId__c, Type__c, WhatId__c, data0__c, data1__c, data2__c, data3__c, data4__c, data5__c, data6__c, data7__c, data8__c, data9__c FROM SYS_IntegrationLog__c
                                                              WHERE WhatId__c != null AND Type__c = 'INBOUND' AND SYS_Operation_Type__c = 'RESPONSE' LIMIT 1];
        System.debug('size=='+insertedLogResponse.size());
        if(insertedLogResponse.size() > 0)
        	SYS_processQuickbooksResponse.updateIdAndToken(insertedLogResponse);
		SYS_IntegrationLog__c sys = QuickbooksTestDataFactory.getSyslog();
        list < Product2 > ProductDetails = [select Id, ProductCode, Description, Quickbooks_Id__c, QB_SyncToken__c from Product2];
        system.debug('sys' + sys);
		List < SYS_IntegrationLog__c > insertedLogs = [SELECT Name, Status__c, SYS_Http_Status__c, SYS_Operation_Type__c, SYS_RequestId__c, Type__c, WhatId__c, data0__c, data1__c, data2__c, data3__c, data4__c, data5__c, data6__c, data7__c, data8__c, data9__c FROM SYS_IntegrationLog__c];
		system.debug('productRecord' + ProductDetails);
		 Product2 prod = (ProductDetails.size()>0)?ProductDetails[0]:new Product2();
        system.debug('prod==='+prod);
		system.debug('sysintegrationlog' + insertedLogs.size());
		system.assertEquals(prod.Quickbooks_Id__c, '40');
		system.assertEquals(prod.QB_SyncToken__c, '0');

	}
      
	@isTest static void productUpdateInboundTest() {
		String resJson = '{"eventNotifications":[{"realmId":"4620816365172373180","dataChangeEvent":{"entities":[{"operation":"Update","name":"Item","lastUpdated":"2021-10-05T20:06:36.000Z","id":"40"}]}}]}';
		String resJsonImport = '{"Item":{"Name":"cosmatics12","Description":"p21","Active":true,"FullyQualifiedName":"cosmatics","Taxable":true,"UnitPrice":100,"Type":"NonInventory","IncomeAccountRef":{"value":"94","name":"Generic Income Acc"},"PurchaseCost":0,"TrackQtyOnHand":false,"domain":"QBO","sparse":false,"Id":"40","SyncToken":"1","MetaData":{"CreateTime":"2021-10-05T13:06:36-07:00","LastUpdatedTime":"2021-10-05T13:06:36-07:00"}},"time":"2021-10-05T13:06:38.571-07:00"}';
		Map < String, String > responseHeaders = new Map < String, String > ();
		responseHeaders.put('Content-Type', 'application/json');
		Test.setMock(HttpCalloutMock.class, new QuickBookCalloutMock(200, 'OK', resJsonImport, responseHeaders));
		QB_restmokecallout.requestRestCallout(resJson, 200);
       /*Product2 productData = QuickbooksTestDataFactory.productCreate();
		Insert productData;
		PricebookEntry pricebookEntryData = QuickbooksTestDataFactory.PricebookEntryCreate(productData.Id);
		Insert pricebookEntryData;
        system.debug('productData'+productData);
        Product2 productUpdate = QuickbooksTestDataFactory.productUpdate(productData.Id);
		update productUpdate;*/
        Test.startTest();
		SYS_webhook.processWebhookResponse('', resJson);
		Test.stopTest();
 		SYS_IntegrationLog__c sys = QuickbooksTestDataFactory.getSyslog();
        list<Product2>  ProductDetails = [select Id, ProductCode, Description, Quickbooks_Id__c, QB_SyncToken__c from Product2];
		List < SYS_IntegrationLog__c > insertedLogs = [SELECT Name, Status__c, SYS_Http_Status__c, SYS_Operation_Type__c, SYS_RequestId__c, Type__c, WhatId__c, data0__c, data1__c, data2__c, data3__c, data4__c, data5__c, data6__c, data7__c, data8__c, data9__c FROM SYS_IntegrationLog__c];
		system.debug('sys' + sys);
		system.debug('productRecord' + ProductDetails);
        Product2 prod = (ProductDetails.size()>0)?ProductDetails[0]:new Product2();
		system.assertEquals(prod.Quickbooks_Id__c, '40');
		system.assertEquals(prod.QB_SyncToken__c, '1');
        
	}
	@isTest static void productDeleteInboundTest() {

		String resJson = '{"eventNotifications":[{"realmId":"4620816365172373180","dataChangeEvent":{"entities":[{"operation":"Update","name":"Item","lastUpdated":"2021-10-05T20:06:36.000Z","id":"40"}]}}]}';
		String resJsonImport = '{"Item":{"Name":"cosmatics","Description":"p1","Active":false,"FullyQualifiedName":"cosmatics12","Taxable":true,"UnitPrice":100,"Type":"NonInventory","IncomeAccountRef":{"value":"94","name":"Generic Income Acc"},"PurchaseCost":0,"TrackQtyOnHand":false,"domain":"QBO","sparse":false,"Id":"40","SyncToken":"2","MetaData":{"CreateTime":"2021-10-05T13:06:36-07:00","LastUpdatedTime":"2021-10-05T13:06:36-07:00"}},"time":"2021-10-05T13:06:38.571-07:00"}';
		Map < String, String > responseHeaders = new Map < String, String > ();
		responseHeaders.put('Content-Type', 'application/json');
		Test.setMock(HttpCalloutMock.class, new QuickBookCalloutMock(200, 'OK', resJsonImport, responseHeaders));
		QB_restmokecallout.requestRestCallout(resJson, 200);
        /*Product2 productData = QuickbooksTestDataFactory.productCreate();
		Insert productData;
		PricebookEntry pricebookEntryData = QuickbooksTestDataFactory.PricebookEntryCreate(productData.Id);
		Insert pricebookEntryData;
		Product2 productDelete = QuickbooksTestDataFactory.productDelete(productData.Id);
		update productDelete;*/
        Test.startTest();
		SYS_webhook.processWebhookResponse('', resJson);
		SYS_IntegrationLog__c sys = QuickbooksTestDataFactory.getSyslog();
		Test.stopTest();
		list < Product2 > ProductDetails = [select Id, ProductCode, Description, Quickbooks_Id__c, QB_SyncToken__c from Product2];
		List < SYS_IntegrationLog__c > insertedLogs = [SELECT Name, Status__c, SYS_Http_Status__c, SYS_Operation_Type__c, SYS_RequestId__c, Type__c, WhatId__c, data0__c, data1__c, data2__c, data3__c, data4__c, data5__c, data6__c, data7__c, data8__c, data9__c FROM SYS_IntegrationLog__c];
		system.debug('sys' + sys);
		 Product2 prod = (ProductDetails.size()>0)?ProductDetails[0]:new Product2();
		system.assertEquals(prod.Quickbooks_Id__c, '40');
		system.assertEquals(prod.QB_SyncToken__c, '2');

	}
	@isTest static void responsecodeProductInboundTest() {
		String resJson = '{"eventNotifications":[{"realmId":"4620816365172373180","dataChangeEvent":{"entities":[{"operation":"Create","name":"Item","lastUpdated":"2021-10-05T20:06:36.000Z","id":"40"}]}}]}';
		String resJsonImport = '{"Item":{"Name":"cosmatics","Description":"p1","Active":true,"FullyQualifiedName":"cosmatics","Taxable":true,"UnitPrice":100,"Type":"NonInventory","IncomeAccountRef":{"value":"94","name":"Generic Income Acc"},"PurchaseCost":0,"TrackQtyOnHand":false,"domain":"QBO","sparse":false,"Id":"40","SyncToken":"4","MetaData":{"CreateTime":"2021-10-05T13:06:36-07:00","LastUpdatedTime":"2021-10-05T13:06:36-07:00"}},"time":"2021-10-05T13:06:38.571-07:00"}';
		Map < String, String > responseHeaders = new Map < String, String > ();
		responseHeaders.put('Content-Type', 'application/json');
		Test.setMock(HttpCalloutMock.class, new QuickBookCalloutMock(400, 'OK', resJsonImport, responseHeaders));
		QB_restmokecallout.requestRestCallout(resJson, 400);
		/*Product2 productData = QuickbooksTestDataFactory.productCreate();
		Test.startTest();
		insert productData;
		PricebookEntry pricebookEntryData = QuickbooksTestDataFactory.PricebookEntryCreate(productData.Id);
		Insert pricebookEntryData;*/
		Test.startTest();
        SYS_webhook.processWebhookResponse('', resJson);
		SYS_IntegrationLog__c sys = QuickbooksTestDataFactory.getSyslog();
		Test.stopTest();
		list < Product2 > ProductDetails = [select Id, ProductCode, Description, Quickbooks_Id__c, QB_SyncToken__c from Product2];
		List < SYS_IntegrationLog__c > insertedLogs = [SELECT Name, Status__c, SYS_Http_Status__c, SYS_Operation_Type__c, SYS_RequestId__c, Type__c, WhatId__c, data0__c, data1__c, data2__c, data3__c, data4__c, data5__c, data6__c, data7__c, data8__c, data9__c FROM SYS_IntegrationLog__c];
		system.debug('sys' + sys);
		system.debug('productRecord' + ProductDetails);

		system.debug('sysintegrationlog' + insertedLogs.size());
		system.debug('sysintegrationlog11' + insertedLogs[1].SYS_Http_Status__c);
		system.assert(insertedLogs.size() > 0);
		system.assertEquals(400, insertedLogs[1].SYS_Http_Status__c);

	}
	@isTest static void productMokeInsertTest() {
		String resJson1 = '{"eventNotifications":[{"realmId":"4620816365172373180","dataChangeEvent":{"entities":[{"operation":"Create","name":"Item","lastUpdated":"2021-10-05T20:06:36.000Z","id":"50"}]}}]}';
		String resJsonImport1 = '{"Item":{"Name":"cosmatics","Description":"p1","Active":true,"FullyQualifiedName":"cosmatics1","Taxable":true,"UnitPrice":100,"Type":"NonInventory","IncomeAccountRef":{"value":"94","name":"Generic Income Acc"},"PurchaseCost":0,"TrackQtyOnHand":false,"domain":"QBO","sparse":false,"Id":"50","SyncToken":"0","MetaData":{"CreateTime":"2021-10-05T13:06:36-07:00","LastUpdatedTime":"2021-10-05T13:06:36-07:00"}},"time":"2021-10-05T13:06:38.571-07:00"}';
		String resJson2 = '{"eventNotifications":[{"realmId":"4620816365172373180","dataChangeEvent":{"entities":[{"operation":"Create","name":"Item","lastUpdated":"2021-10-05T20:06:36.000Z","id":"51"}]}}]}';
		String resJsonImport2 = '{"Item":{"Name":"cosmat","Description":"p1","Active":true,"FullyQualifiedName":"cosmat","Taxable":true,"UnitPrice":100,"Type":"NonInventory","IncomeAccountRef":{"value":"94","name":"Generic Income Acc"},"PurchaseCost":0,"TrackQtyOnHand":false,"domain":"QBO","sparse":false,"Id":"51","SyncToken":"0","MetaData":{"CreateTime":"2021-10-05T13:06:36-07:00","LastUpdatedTime":"2021-10-05T13:06:36-07:00"}},"time":"2021-10-05T13:06:38.571-07:00"}';
        Map < String, String > responseHeaders = new Map < String, String > ();
		responseHeaders.put('Content-Type', 'application/json');
		Test.setMock(HttpCalloutMock.class, new QuickBookCalloutMock(200, 'OK', resJsonImport1, responseHeaders));
		QB_restmokecallout.requestRestCallout(resJson2, 200);
        Test.setMock(HttpCalloutMock.class, new QuickBookCalloutMock2(200, 'OK', resJsonImport2, responseHeaders));
		QB_restmokecallout2.requestRestCallout(resJson2, 200);
		/*list < Product2 > productData = QuickbooksTestDataFactory.productCreateList();
		
		Insert productData;
		PricebookEntry pricebookEntryData1 = QuickbooksTestDataFactory.PricebookEntryCreate(productData[0].Id);
		PricebookEntry pricebookEntryData2 = QuickbooksTestDataFactory.PricebookEntryCreate(productData[1].Id);
		PricebookEntry pricebookEntryData3 = QuickbooksTestDataFactory.PricebookEntryCreate(productData[2].Id);
		Insert pricebookEntryData1;
		Insert pricebookEntryData2;
		Insert pricebookEntryData3;*/
        Test.startTest();
		SYS_webhook.processWebhookResponse('', resJson1);
        Test.stopTest();
		SYS_IntegrationLog__c sys = QuickbooksTestDataFactory.getSyslog();
		list < Product2 > ProductDetails = [select Id, ProductCode, Description, Quickbooks_Id__c, QB_SyncToken__c from Product2 ];
		List < SYS_IntegrationLog__c > insertedLogs = [SELECT Name, Status__c, SYS_Http_Status__c, SYS_Operation_Type__c, SYS_RequestId__c, Type__c, WhatId__c, data0__c, data1__c, data2__c, data3__c, data4__c, data5__c, data6__c, data7__c, data8__c, data9__c FROM SYS_IntegrationLog__c];
		system.debug('sys' + sys);
		system.debug('productRecord' + ProductDetails);
         Product2 prod = (ProductDetails.size()>0)?ProductDetails[0]:new Product2();
        system.debug('prod==='+prod);
		system.debug('sysintegrationlog' + insertedLogs.size());
		system.assertEquals(prod.Quickbooks_Id__c, '51');
		system.assertEquals(prod.QB_SyncToken__c, '0');
	}
	@isTest static void productMokeupdateTest() {
		String resJson1 = '{"eventNotifications":[{"realmId":"4620816365172373180","dataChangeEvent":{"entities":[{"operation":"Update","name":"Item","lastUpdated":"2021-10-05T20:06:36.000Z","id":"50"}]}}]}';
		String resJsonImport1 = '{"Item":{"Name":"cosmatics","Description":"p1435","Active":true,"FullyQualifiedName":"cosmatics1","Taxable":true,"UnitPrice":100,"Type":"NonInventory","IncomeAccountRef":{"value":"94","name":"Generic Income Acc"},"PurchaseCost":0,"TrackQtyOnHand":false,"domain":"QBO","sparse":false,"Id":"50","SyncToken":"1","MetaData":{"CreateTime":"2021-10-05T13:06:36-07:00","LastUpdatedTime":"2021-10-05T13:06:36-07:00"}},"time":"2021-10-05T13:06:38.571-07:00"}';
		String resJson2 = '{"eventNotifications":[{"realmId":"4620816365172373180","dataChangeEvent":{"entities":[{"operation":"Update","name":"Item","lastUpdated":"2021-10-05T20:06:36.000Z","id":"51"}]}}]}';
		String resJsonImport2 = '{"Item":{"Name":"cosmat","Description":"p1ty","Active":true,"FullyQualifiedName":"cosmat","Taxable":true,"UnitPrice":100,"Type":"NonInventory","IncomeAccountRef":{"value":"94","name":"Generic Income Acc"},"PurchaseCost":0,"TrackQtyOnHand":false,"domain":"QBO","sparse":false,"Id":"51","SyncToken":"1","MetaData":{"CreateTime":"2021-10-05T13:06:36-07:00","LastUpdatedTime":"2021-10-05T13:06:36-07:00"}},"time":"2021-10-05T13:06:38.571-07:00"}';
        Map < String, String > responseHeaders = new Map < String, String > ();
		responseHeaders.put('Content-Type', 'application/json');
		Test.setMock(HttpCalloutMock.class, new QuickBookCalloutMock(200, 'OK', resJsonImport1, responseHeaders));
		QB_restmokecallout.requestRestCallout(resJson2, 200);
        Test.setMock(HttpCalloutMock.class, new QuickBookCalloutMock2(200, 'OK', resJsonImport2, responseHeaders));
		QB_restmokecallout2.requestRestCallout(resJson2, 200);

		/*list < Product2 > productData = QuickbooksTestDataFactory.productCreateList();
		
		Insert productData;
		PricebookEntry pricebookEntryData1 = QuickbooksTestDataFactory.PricebookEntryCreate(productData[0].Id);
		PricebookEntry pricebookEntryData2 = QuickbooksTestDataFactory.PricebookEntryCreate(productData[1].Id);
		PricebookEntry pricebookEntryData3 = QuickbooksTestDataFactory.PricebookEntryCreate(productData[2].Id);
		Insert pricebookEntryData1;
		Insert pricebookEntryData2;
		Insert pricebookEntryData3;*/
        Test.startTest();
		SYS_webhook.processWebhookResponse('', resJson1);
		SYS_IntegrationLog__c sys = QuickbooksTestDataFactory.getSyslog();
		Test.stopTest();
		list < Product2 > ProductDetails = [select Id, ProductCode, Description, Quickbooks_Id__c, QB_SyncToken__c from Product2];
		List < SYS_IntegrationLog__c > insertedLogs = [SELECT Name, Status__c, SYS_Http_Status__c, SYS_Operation_Type__c, SYS_RequestId__c, Type__c, WhatId__c, data0__c, data1__c, data2__c, data3__c, data4__c, data5__c, data6__c, data7__c, data8__c, data9__c FROM SYS_IntegrationLog__c];
		system.debug('sys' + sys);
		Product2 prod = (ProductDetails.size()>0)?ProductDetails[0]:new Product2();
        system.debug('prod==='+prod);
		system.debug('sysintegrationlog' + insertedLogs.size());
		system.assertEquals(prod.Quickbooks_Id__c, '51');
		system.assertEquals(prod.QB_SyncToken__c, '1');
	}
	@isTest static void productMokeDeleteTest() {
		String resJson1 = '{"eventNotifications":[{"realmId":"4620816365172373180","dataChangeEvent":{"entities":[{"operation":"Update","name":"Item","lastUpdated":"2021-10-05T20:06:36.000Z","id":"50"}]}}]}';
		String resJsonImport1 = '{"Item":{"Name":"cosmatics","Description":"p14359","Active":false,"FullyQualifiedName":"cosmatics1","Taxable":true,"UnitPrice":100,"Type":"NonInventory","IncomeAccountRef":{"value":"94","name":"Generic Income Acc"},"PurchaseCost":0,"TrackQtyOnHand":false,"domain":"QBO","sparse":false,"Id":"50","SyncToken":"2","MetaData":{"CreateTime":"2021-10-05T13:06:36-07:00","LastUpdatedTime":"2021-10-05T13:06:36-07:00"}},"time":"2021-10-05T13:06:38.571-07:00"}';
		String resJson2 = '{"eventNotifications":[{"realmId":"4620816365172373180","dataChangeEvent":{"entities":[{"operation":"Update","name":"Item","lastUpdated":"2021-10-05T20:06:36.000Z","id":"51"}]}}]}';
		String resJsonImport2 = '{"Item":{"Name":"cosmat","Description":"p1ty123","Active":false,"FullyQualifiedName":"cosmat","Taxable":true,"UnitPrice":100,"Type":"NonInventory","IncomeAccountRef":{"value":"94","name":"Generic Income Acc"},"PurchaseCost":0,"TrackQtyOnHand":false,"domain":"QBO","sparse":false,"Id":"51","SyncToken":"2","MetaData":{"CreateTime":"2021-10-05T13:06:36-07:00","LastUpdatedTime":"2021-10-05T13:06:36-07:00"}},"time":"2021-10-05T13:06:38.571-07:00"}';
        Map < String, String > responseHeaders = new Map < String, String > ();
		responseHeaders.put('Content-Type', 'application/json');
		Test.setMock(HttpCalloutMock.class, new QuickBookCalloutMock(200, 'OK', resJsonImport1, responseHeaders));
		QB_restmokecallout.requestRestCallout(resJson2, 200);
        Test.setMock(HttpCalloutMock.class, new QuickBookCalloutMock2(200, 'OK', resJsonImport2, responseHeaders));
		QB_restmokecallout2.requestRestCallout(resJson2, 200);
		/*list < Product2 > productData = QuickbooksTestDataFactory.productCreateList();
		Test.startTest();
		Insert productData;
		PricebookEntry pricebookEntryData1 = QuickbooksTestDataFactory.PricebookEntryCreate(productData[0].Id);
		PricebookEntry pricebookEntryData2 = QuickbooksTestDataFactory.PricebookEntryCreate(productData[1].Id);
		PricebookEntry pricebookEntryData3 = QuickbooksTestDataFactory.PricebookEntryCreate(productData[2].Id);
		Insert pricebookEntryData1;
		Insert pricebookEntryData2;
		Insert pricebookEntryData3;
		//list<Product2> productupdate = QuickbooksTestDataFactory.product2mokeDelete(productData[0].Id);*/
	    Test.startTest();
        SYS_webhook.processWebhookResponse('', resJson1); 
		SYS_IntegrationLog__c sys = QuickbooksTestDataFactory.getSyslog();
		Test.stopTest();
		list < Product2 > ProductDetails = [select Id, ProductCode, Description, Quickbooks_Id__c, QB_SyncToken__c from Product2];
		List < SYS_IntegrationLog__c > insertedLogs = [SELECT Name, Status__c, SYS_Http_Status__c, SYS_Operation_Type__c, SYS_RequestId__c, Type__c, WhatId__c, data0__c, data1__c, data2__c, data3__c, data4__c, data5__c, data6__c, data7__c, data8__c, data9__c FROM SYS_IntegrationLog__c];
		system.debug('sys' + sys);
		system.debug('productRecord' + ProductDetails);
		Product2 prod = (ProductDetails.size()>0)?ProductDetails[0]:new Product2();
        system.debug('prod==='+prod);
		system.debug('sysintegrationlog' + insertedLogs.size());
		system.assertEquals(prod.Quickbooks_Id__c, '51');
		system.assertEquals(prod.QB_SyncToken__c, '2');
	}

}