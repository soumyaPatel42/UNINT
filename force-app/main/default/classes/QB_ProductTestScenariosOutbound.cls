@isTest
public class QB_ProductTestScenariosOutbound {
	//Testing the product senarios====================================================== 

	@isTest static void productInsertOutboundTest() {
		string resJson = '{"Item":{"Name":"cosmatics","Description":"p1","Active":true,"FullyQualifiedName":"cosmatics","Taxable":true,"UnitPrice":100,"Type":"NonInventory","IncomeAccountRef":{"value":"94","name":"Generic Income Acc"},"PurchaseCost":0,"TrackQtyOnHand":false,"domain":"QBO","sparse":false,"Id":"40","SyncToken":"0","MetaData":{"CreateTime":"2021-10-05T13:06:36-07:00","LastUpdatedTime":"2021-10-05T13:06:36-07:00"}},"time":"2021-10-05T13:06:38.571-07:00"}';
		Map < String, String > responseHeaders = new Map < String, String > ();
		responseHeaders.put('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, new QuickBookCalloutMock(200, 'OK', resJson, responseHeaders));
        sys_InvocableHandler.MyInvocableVariable invokeVar = new sys_InvocableHandler.MyInvocableVariable();
		List < sys_InvocableHandler.MyInvocableVariable > invokeList = new List < sys_InvocableHandler.MyInvocableVariable > ();
        Product2 productData = QuickbooksTestDataFactory.productCreate();
        
		insert productData;
         
        system.debug('productdetails' + productData);
		PricebookEntry pricebookEntryData = QuickbooksTestDataFactory.PricebookEntryCreate(productData.Id);
        insert pricebookEntryData;
         test.startTest();
         
		system.debug('productRecords' + productData);
		invokeVar.integrationSetting = 'Quickbooks';
		invokeVar.newVal = productData;
		invokeVar.recId = productData.Id;
        invokeVar.operationType ='INSERT'; 
		invokeList.add(invokeVar);
         sys_InvocableHandler.printOldAndCurrentValues(invokeList);
        test.stopTest();
       
        
        List < SYS_IntegrationLog__c > insertedLogResponse = [SELECT Name, Status__c, SYS_Http_Status__c, SYS_Operation_Type__c, SYS_RequestId__c, Type__c, WhatId__c, data0__c, data1__c, data2__c, data3__c, data4__c, data5__c, data6__c, data7__c, data8__c, data9__c FROM SYS_IntegrationLog__c
                                                              WHERE WhatId__c != null AND Type__c = 'INBOUND' AND SYS_Operation_Type__c = 'RESPONSE' LIMIT 1];
        System.debug('size=='+insertedLogResponse.size());
        if(insertedLogResponse.size() > 0)
        	SYS_processQuickbooksResponse.updateIdAndToken(insertedLogResponse);
		SYS_IntegrationLog__c sys = QuickbooksTestDataFactory.getSyslog();
		List < SYS_IntegrationLog__c > insertedLogs = [SELECT Name, Status__c, SYS_Http_Status__c, SYS_Operation_Type__c, SYS_RequestId__c, Type__c, WhatId__c, data0__c, data1__c, data2__c, data3__c, data4__c, data5__c, data6__c, data7__c, data8__c, data9__c FROM SYS_IntegrationLog__c];
		list < Product2 > productDetails = [select Name, Id, ProductCode, Description, Quickbooks_Id__c, QB_SyncToken__c from Product2];
        system.debug('productDetails' + productDetails);
		system.debug('sysintegrationlog' + insertedLogs.size());
		Product2 prod = (ProductDetails.size()>0)?ProductDetails[0]:new Product2();
        system.debug('prod==='+prod);
		system.debug('sysintegrationlog' + insertedLogs.size());
		system.assertEquals(prod.Quickbooks_Id__c, '40');
		system.assertEquals(prod.QB_SyncToken__c, '0');

	}
	@isTest static void productupdateOutboundTest() {
		string resJson = '{"Item":{"Name":"cosmatics","Description":"p1","Active":true,"FullyQualifiedName":"cosmatics","Taxable":true,"UnitPrice":100,"Type":"NonInventory","IncomeAccountRef":{"value":"94","name":"Generic Income Acc"},"PurchaseCost":0,"TrackQtyOnHand":false,"domain":"QBO","sparse":false,"Id":"40","SyncToken":"0","MetaData":{"CreateTime":"2021-10-05T13:06:36-07:00","LastUpdatedTime":"2021-10-05T13:06:36-07:00"}},"time":"2021-10-05T13:06:38.571-07:00"}';
		Map < String, String > responseHeaders = new Map < String, String > ();
		responseHeaders.put('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, new QuickBookCalloutMock(200, 'OK', resJson, responseHeaders));
		Product2 productData = QuickbooksTestDataFactory.productCreate();
		insert productData;
		system.debug('productdetails' + productData);
		PricebookEntry pricebookEntryData = QuickbooksTestDataFactory.PricebookEntryCreate(productData.Id);
        insert pricebookEntryData;
		system.debug('productRecords' + productData);
		
		Product2 productdel = QuickbooksTestDataFactory.productUpdate(productData.Id);
		update productdel;
        system.debug('productdel=='+productdel);
		
		Sys_InvocableHandler.MyInvocableVariable invokeVar = new Sys_InvocableHandler.MyInvocableVariable();
		List < Sys_InvocableHandler.MyInvocableVariable > invokeList = new List < Sys_InvocableHandler.MyInvocableVariable > ();
		invokeVar.integrationSetting = 'Quickbooks';
		invokeVar.newVal = productdel;
        invokeVar.operationType ='UPDATE';     
        invokeVar.recId = productdel.Id;
		invokeList.add(invokeVar);
        test.startTest();
		Sys_InvocableHandler.printOldAndCurrentValues(invokeList);
        test.stopTest();
        List < SYS_IntegrationLog__c > insertedLogResponse = [SELECT Name, Status__c, SYS_Http_Status__c, SYS_Operation_Type__c, SYS_RequestId__c, Type__c, WhatId__c, data0__c, data1__c, data2__c, data3__c, data4__c, data5__c, data6__c, data7__c, data8__c, data9__c FROM SYS_IntegrationLog__c
                                                              WHERE WhatId__c != null AND Type__c = 'INBOUND' AND SYS_Operation_Type__c = 'RESPONSE' LIMIT 1];
        System.debug('size=='+insertedLogResponse.size());
        if(insertedLogResponse.size() > 0)
        	SYS_processQuickbooksResponse.updateIdAndToken(insertedLogResponse);
	    SYS_IntegrationLog__c sys = QuickbooksTestDataFactory.getSyslog();
		List < SYS_IntegrationLog__c > insertedLogs = [SELECT Name, Status__c, SYS_Http_Status__c, SYS_Operation_Type__c, SYS_RequestId__c, Type__c, WhatId__c, data0__c, data1__c, data2__c, data3__c, data4__c, data5__c, data6__c, data7__c, data8__c, data9__c FROM SYS_IntegrationLog__c];
		list < Product2 > productDetails = [select Name, Id, ProductCode, Description,  Quickbooks_Id__c, QB_SyncToken__c from Product2];
        system.debug('productDetails' + productDetails[0].QB_SyncToken__c);
		system.debug('sysintegrationlog' + insertedLogs.size());
		Product2 prod = (ProductDetails.size()>0)?ProductDetails[0]:new Product2();
        system.debug('prod==='+prod);
		system.debug('sysintegrationlog' + insertedLogs.size());
		system.assertEquals(prod.Quickbooks_Id__c, '40');
		system.assertEquals(prod.QB_SyncToken__c, '0');

	}
    @isTest static void productDeleteOutboundTest() {
		string resJson = '{"Item":{"Name":"cosmatics","Description":"p1","Active":true,"FullyQualifiedName":"cosmatics","Taxable":true,"UnitPrice":100,"Type":"NonInventory","IncomeAccountRef":{"value":"94","name":"Generic Income Acc"},"PurchaseCost":0,"TrackQtyOnHand":false,"domain":"QBO","sparse":false,"Id":"40","SyncToken":"0","MetaData":{"CreateTime":"2021-10-05T13:06:36-07:00","LastUpdatedTime":"2021-10-05T13:06:36-07:00"}},"time":"2021-10-05T13:06:38.571-07:00"}';
		Map < String, String > responseHeaders = new Map < String, String > ();
		responseHeaders.put('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, new QuickBookCalloutMock(200, 'OK', resJson, responseHeaders));
		Product2 productData = QuickbooksTestDataFactory.productCreate();
		insert productData;
		system.debug('productdetails' + productData);
		PricebookEntry pricebookEntryData = QuickbooksTestDataFactory.PricebookEntryCreate(productData.Id);
        insert pricebookEntryData;
		system.debug('productRecords' + productData);
		
		Product2 productdel = QuickbooksTestDataFactory.productDelete(productData.Id);
		update productdel;
        system.debug('productdel=='+productdel);
		
		Sys_InvocableHandler.MyInvocableVariable invokeVar = new Sys_InvocableHandler.MyInvocableVariable();
		List < Sys_InvocableHandler.MyInvocableVariable > invokeList = new List < Sys_InvocableHandler.MyInvocableVariable > ();
		invokeVar.integrationSetting = 'Quickbooks';
		invokeVar.newVal = productdel;
        invokeVar.operationType ='UPDATE';     
        invokeVar.recId = productdel.Id;
		invokeList.add(invokeVar);
        test.startTest();
		Sys_InvocableHandler.printOldAndCurrentValues(invokeList);
        test.stopTest();
        List < SYS_IntegrationLog__c > insertedLogResponse = [SELECT Name, Status__c, SYS_Http_Status__c, SYS_Operation_Type__c, SYS_RequestId__c, Type__c, WhatId__c, data0__c, data1__c, data2__c, data3__c, data4__c, data5__c, data6__c, data7__c, data8__c, data9__c FROM SYS_IntegrationLog__c
                                                              WHERE WhatId__c != null AND Type__c = 'INBOUND' AND SYS_Operation_Type__c = 'RESPONSE' LIMIT 1];
        System.debug('size=='+insertedLogResponse.size());
        if(insertedLogResponse.size() > 0)
        	SYS_processQuickbooksResponse.updateIdAndToken(insertedLogResponse);
	    SYS_IntegrationLog__c sys = QuickbooksTestDataFactory.getSyslog();
		List < SYS_IntegrationLog__c > insertedLogs = [SELECT Name, Status__c, SYS_Http_Status__c, SYS_Operation_Type__c, SYS_RequestId__c, Type__c, WhatId__c, data0__c, data1__c, data2__c, data3__c, data4__c, data5__c, data6__c, data7__c, data8__c, data9__c FROM SYS_IntegrationLog__c];
		list < Product2 > productDetails = [select Name, Id, ProductCode, Description,  Quickbooks_Id__c, QB_SyncToken__c from Product2];
        system.debug('productDetails' + productDetails[0].QB_SyncToken__c);
		system.debug('sysintegrationlog' + insertedLogs.size());
		Product2 prod = (ProductDetails.size()>0)?ProductDetails[0]:new Product2();
        system.debug('prod==='+prod);
		system.debug('sysintegrationlog' + insertedLogs.size());
		system.assertEquals(prod.Quickbooks_Id__c, '40');
		system.assertEquals(prod.QB_SyncToken__c, '0');

	}
	@isTest static void productresponsecodeOutboundTest() {
		string resJson = '{"Item":{"Name":"cosmatics","Description":"p1","Active":true,"FullyQualifiedName":"cosmatics","Taxable":true,"UnitPrice":100,"Type":"NonInventory","IncomeAccountRef":{"value":"94","name":"Generic Income Acc"},"PurchaseCost":0,"TrackQtyOnHand":false,"domain":"QBO","sparse":false,"Id":"40","SyncToken":"0","MetaData":{"CreateTime":"2021-10-05T13:06:36-07:00","LastUpdatedTime":"2021-10-05T13:06:36-07:00"}},"time":"2021-10-05T13:06:38.571-07:00"}';
		Map < String, String > responseHeaders = new Map < String, String > ();
		responseHeaders.put('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, new QuickBookCalloutMock(400, 'OK', resJson, responseHeaders));
		Product2 productData = QuickbooksTestDataFactory.productCreate();
		insert productData;
		system.debug('productdetails' + productData);
		PricebookEntry pricebookEntryData = QuickbooksTestDataFactory.PricebookEntryCreate(productData.Id);
        insert pricebookEntryData;
		system.debug('productRecords' + productData);
		sys_InvocableHandler.MyInvocableVariable invokeVar = new sys_InvocableHandler.MyInvocableVariable();
		List < sys_InvocableHandler.MyInvocableVariable > invokeList = new List < sys_InvocableHandler.MyInvocableVariable > ();
		invokeVar.integrationSetting = 'Quickbooks';
		invokeVar.newVal = productData;
		invokeVar.recId = productData.Id;
        invokeVar.operationType ='INSERT'; 
		invokeList.add(invokeVar);
        test.startTest();
		sys_InvocableHandler.printOldAndCurrentValues(invokeList);
        test.stopTest();
        List < SYS_IntegrationLog__c > insertedLogResponse = [SELECT Name, Status__c, SYS_Http_Status__c, SYS_Operation_Type__c, SYS_RequestId__c, Type__c, WhatId__c, data0__c, data1__c, data2__c, data3__c, data4__c, data5__c, data6__c, data7__c, data8__c, data9__c FROM SYS_IntegrationLog__c
                                                              WHERE WhatId__c != null AND Type__c = 'INBOUND' AND SYS_Operation_Type__c = 'RESPONSE' LIMIT 1];
        System.debug('size=='+insertedLogResponse.size());
        if(insertedLogResponse.size() > 0)
        	SYS_processQuickbooksResponse.updateIdAndToken(insertedLogResponse);
		SYS_IntegrationLog__c sys = QuickbooksTestDataFactory.getSyslog();
		List < SYS_IntegrationLog__c > insertedLogs = [SELECT Name, Status__c, SYS_Http_Status__c, SYS_Operation_Type__c, SYS_RequestId__c, Type__c, WhatId__c, data0__c, data1__c, data2__c, data3__c, data4__c, data5__c, data6__c, data7__c, data8__c, data9__c FROM SYS_IntegrationLog__c];
		list < Product2 > productDetails = [select Name, Id, ProductCode, Description, Quickbooks_Id__c, QB_SyncToken__c from Product2];
        system.debug('productDetails' + productDetails[0].QB_SyncToken__c);
		system.debug('sysintegrationlog' + insertedLogs.size());
		Product2 prod = (ProductDetails.size()>0)?ProductDetails[0]:new Product2();
        system.debug('prod==='+prod);
		system.debug('sysintegrationlog' + insertedLogs.size());
		system.assert(insertedLogs.size() > 0);


	}
	//moke insert============
	@isTest static void productmokeInsertTest() {
		string resJson1 = '{"Item":{"Name":"cosmatics","Description":"p1","Active":true,"FullyQualifiedName":"cosmatics","Taxable":true,"UnitPrice":100,"Type":"NonInventory","IncomeAccountRef":{"value":"94","name":"Generic Income Acc"},"PurchaseCost":0,"TrackQtyOnHand":false,"domain":"QBO","sparse":false,"Id":"40","SyncToken":"0","MetaData":{"CreateTime":"2021-10-05T13:06:36-07:00","LastUpdatedTime":"2021-10-05T13:06:36-07:00"}},"time":"2021-10-05T13:06:38.571-07:00"}';
        string resJson2 = '{"Item":{"Name":"Testing","Description":"p1","Active":true,"FullyQualifiedName":"Testing","Taxable":true,"UnitPrice":100,"Type":"NonInventory","IncomeAccountRef":{"value":"94","name":"Generic Income Acc"},"PurchaseCost":0,"TrackQtyOnHand":false,"domain":"QBO","sparse":false,"Id":"41","SyncToken":"0","MetaData":{"CreateTime":"2021-10-05T13:06:36-07:00","LastUpdatedTime":"2021-10-05T13:06:36-07:00"}},"time":"2021-10-05T13:06:38.571-07:00"}';
		Map < String, String > responseHeaders = new Map < String, String > ();
		responseHeaders.put('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, new QuickBookCalloutMock(400, 'OK', resJson1, responseHeaders));
        Test.setMock(HttpCalloutMock.class, new QuickBookCalloutMock2(400, 'OK', resJson2, responseHeaders));

		list<Product2> productData = QuickbooksTestDataFactory.productCreateList();
		insert productData;
		system.debug('productdetails' + productData);

		 list<PricebookEntry>priceEnt = new list <PricebookEntry>();
        for(Product2 proId :productData){
		PricebookEntry pricebookEntryData = QuickbooksTestDataFactory.PricebookEntryCreate(proId.Id);
            priceEnt.add(pricebookEntryData);
        }
		
		insert priceEnt;
		system.debug('pppppeee'+priceEnt);
        sys_InvocableHandler.MyInvocableVariable invokeVar = new sys_InvocableHandler.MyInvocableVariable();
		List < sys_InvocableHandler.MyInvocableVariable > invokeList = new List < sys_InvocableHandler.MyInvocableVariable > ();
		for (Product2 prodts: productData) {
			invokeVar.integrationSetting = 'Quickbooks';
			invokeVar.newVal = prodts;
			invokeVar.recId = prodts.Id;
            invokeVar.operationType ='INSERT';     
            invokeList.add(invokeVar);
        }
          system.debug('invokeList=='+invokeList.size());
          system.debug('invokeList=='+invokeList);
        Test.startTest();
		sys_InvocableHandler.printOldAndCurrentValues(invokeList);
		Test.stopTest();
        system.debug('invokeList=='+invokeList);
        List < SYS_IntegrationLog__c > insertedLogResponse = [SELECT Name, Status__c, SYS_Http_Status__c, SYS_Operation_Type__c, SYS_RequestId__c, Type__c, WhatId__c, data0__c, data1__c, data2__c, data3__c, data4__c, data5__c, data6__c, data7__c, data8__c, data9__c FROM SYS_IntegrationLog__c
                                                              WHERE WhatId__c != null AND Type__c = 'INBOUND' AND SYS_Operation_Type__c = 'RESPONSE' LIMIT 1];
        System.debug('size=='+insertedLogResponse.size());
        if(insertedLogResponse.size() > 0)
        SYS_processQuickbooksResponse.updateIdAndToken(insertedLogResponse);
		SYS_IntegrationLog__c sys = QuickbooksTestDataFactory.getSyslog();
		List < SYS_IntegrationLog__c > insertedLogs = [SELECT Name, Status__c, SYS_Http_Status__c, SYS_Operation_Type__c, SYS_RequestId__c, Type__c, WhatId__c, data0__c, data1__c, data2__c, data3__c, data4__c, data5__c, data6__c, data7__c, data8__c, data9__c FROM SYS_IntegrationLog__c];
		list < Product2 > productDetails = [select Name, Id, ProductCode, Description,Quickbooks_Id__c, QB_SyncToken__c from Product2];
	    system.debug('productDetails' + productDetails);
		Product2 prod = (ProductDetails.size()>0)?ProductDetails[2]:new Product2();
        system.debug('prod==='+prod);
		system.debug('sysintegrationlog' + insertedLogs.size());
		system.assertEquals( '41',prod.Quickbooks_Id__c); 
		system.assertEquals( '0',prod.QB_SyncToken__c);
	}
	//moke update==============
	@isTest static void productmokeUpdateTest() {
		string resJson1 = '{"Item":{"Name":"cosmatics","Description":"p1","Active":true,"FullyQualifiedName":"cosmatics","Taxable":true,"UnitPrice":100,"Type":"NonInventory","IncomeAccountRef":{"value":"94","name":"Generic Income Acc"},"PurchaseCost":0,"TrackQtyOnHand":false,"domain":"QBO","sparse":false,"Id":"40","SyncToken":"1","MetaData":{"CreateTime":"2021-10-05T13:06:36-07:00","LastUpdatedTime":"2021-10-05T13:06:36-07:00"}},"time":"2021-10-05T13:06:38.571-07:00"}';
        string resJson2 = '{"Item":{"Name":"Testing","Description":"p1","Active":true,"FullyQualifiedName":"Testing","Taxable":true,"UnitPrice":100,"Type":"NonInventory","IncomeAccountRef":{"value":"94","name":"Generic Income Acc"},"PurchaseCost":0,"TrackQtyOnHand":false,"domain":"QBO","sparse":false,"Id":"41","SyncToken":"1","MetaData":{"CreateTime":"2021-10-05T13:06:36-07:00","LastUpdatedTime":"2021-10-05T13:06:36-07:00"}},"time":"2021-10-05T13:06:38.571-07:00"}';
		Map < String, String > responseHeaders = new Map < String, String > ();
		responseHeaders.put('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, new QuickBookCalloutMock(400, 'OK', resJson1, responseHeaders));
        Test.setMock(HttpCalloutMock.class, new QuickBookCalloutMock2(400, 'OK', resJson2, responseHeaders));

		list<Product2> productData = QuickbooksTestDataFactory.productCreateList();
		insert productData;
		system.debug('productdetails' + productData);
    list<PricebookEntry>priceEnt = new list <PricebookEntry>();
        for(Product2 proId :productData){
		PricebookEntry pricebookEntryData = QuickbooksTestDataFactory.PricebookEntryCreate(proId.Id);
            priceEnt.add(pricebookEntryData);
        }
		
		insert priceEnt;
		system.debug('pppppeee'+priceEnt);
		
		list < Product2 > productUpdate = QuickbooksTestDataFactory.productmokeUpdate();
		update productUpdate;
        system.debug('productUpdate=='+productUpdate);
		
		system.debug('productRecords' + productData);
        system.debug('productDatasize'+productData.size());
		Sys_InvocableHandler.MyInvocableVariable invokeVar = new Sys_InvocableHandler.MyInvocableVariable();
		List < Sys_InvocableHandler.MyInvocableVariable > invokeList = new List < Sys_InvocableHandler.MyInvocableVariable > ();
        for(Product2 prod :productUpdate){
        invokeVar.integrationSetting = 'Quickbooks';
		invokeVar.newVal = prod;
		invokeVar.recId = prod.Id;
        invokeVar.operationType ='UPDATE'; 
		invokeList.add(invokeVar);
        }
        test.startTest();
		Sys_InvocableHandler.printOldAndCurrentValues(invokeList);
        test.stopTest();
        List < SYS_IntegrationLog__c > insertedLogResponse = [SELECT Name, Status__c, SYS_Http_Status__c, SYS_Operation_Type__c, SYS_RequestId__c, Type__c, WhatId__c, data0__c, data1__c, data2__c, data3__c, data4__c, data5__c, data6__c, data7__c, data8__c, data9__c FROM SYS_IntegrationLog__c
                                                              WHERE WhatId__c != null AND Type__c = 'INBOUND' AND SYS_Operation_Type__c = 'RESPONSE' LIMIT 1];
        System.debug('size=='+insertedLogResponse.size());
        if(insertedLogResponse.size() > 0)
        SYS_processQuickbooksResponse.updateIdAndToken(insertedLogResponse);
		list < Product2 > productDetails = [select Name, Id, ProductCode, Description, IsActive, Quickbooks_Id__c, QB_SyncToken__c from Product2 WHERE Quickbooks_Id__c != NULL];
        system.debug('productDetails'+productDetails);
		SYS_IntegrationLog__c sys = QuickbooksTestDataFactory.getSyslog();
		List < SYS_IntegrationLog__c > insertedLogs = [SELECT Name, Status__c, SYS_Http_Status__c, SYS_Operation_Type__c, SYS_RequestId__c, Type__c, WhatId__c, data0__c, data1__c, data2__c, data3__c, data4__c, data5__c, data6__c, data7__c, data8__c, data9__c FROM SYS_IntegrationLog__c];
		Product2 prod = (ProductDetails.size()>0)?ProductDetails[0]:new Product2();
        system.debug('prod==='+prod);
		system.debug('sysintegrationlog' + insertedLogs.size());
		system.assertEquals(prod.Quickbooks_Id__c, '41');
		system.assertEquals(prod.QB_SyncToken__c, '1');

	}
	//moke Delete==============
	@isTest static void productmokeDeleteTest() {
	string resJson1 = '{"Item":{"Name":"cosmatics","Description":"p1","Active":false,"FullyQualifiedName":"cosmatics","Taxable":true,"UnitPrice":100,"Type":"NonInventory","IncomeAccountRef":{"value":"94","name":"Generic Income Acc"},"PurchaseCost":0,"TrackQtyOnHand":false,"domain":"QBO","sparse":false,"Id":"40","SyncToken":"1","MetaData":{"CreateTime":"2021-10-05T13:06:36-07:00","LastUpdatedTime":"2021-10-05T13:06:36-07:00"}},"time":"2021-10-05T13:06:38.571-07:00"}';
        string resJson2 = '{"Item":{"Name":"Testing","Description":"p1","Active":false,"FullyQualifiedName":"Testing","Taxable":true,"UnitPrice":100,"Type":"NonInventory","IncomeAccountRef":{"value":"94","name":"Generic Income Acc"},"PurchaseCost":0,"TrackQtyOnHand":false,"domain":"QBO","sparse":false,"Id":"41","SyncToken":"1","MetaData":{"CreateTime":"2021-10-05T13:06:36-07:00","LastUpdatedTime":"2021-10-05T13:06:36-07:00"}},"time":"2021-10-05T13:06:38.571-07:00"}';
		Map < String, String > responseHeaders = new Map < String, String > ();
		responseHeaders.put('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, new QuickBookCalloutMock(400, 'OK', resJson1, responseHeaders));
        Test.setMock(HttpCalloutMock.class, new QuickBookCalloutMock2(400, 'OK', resJson2, responseHeaders));

		list<Product2> productData = QuickbooksTestDataFactory.productCreateList();
		insert productData;
		system.debug('productdetails' + productData);
    list<PricebookEntry>priceEnt = new list <PricebookEntry>();
        for(Product2 proId :productData){
		PricebookEntry pricebookEntryData = QuickbooksTestDataFactory.PricebookEntryCreate(proId.Id);
            priceEnt.add(pricebookEntryData);
        }
		
		insert priceEnt;
		system.debug('pppppeee'+priceEnt);
		
		list < Product2 > productUpdate = QuickbooksTestDataFactory.product2mokeDelete();
		update productUpdate;
        system.debug('productUpdate=='+productUpdate);
		
		system.debug('productRecords' + productData);
        system.debug('productDatasize'+productData.size());
		Sys_InvocableHandler.MyInvocableVariable invokeVar = new Sys_InvocableHandler.MyInvocableVariable();
		List < Sys_InvocableHandler.MyInvocableVariable > invokeList = new List < Sys_InvocableHandler.MyInvocableVariable > ();
        for(Product2 prod :productUpdate){
        invokeVar.integrationSetting = 'Quickbooks';
		invokeVar.newVal = prod;
		invokeVar.recId = prod.Id;
        invokeVar.operationType ='UPDATE'; 
		invokeList.add(invokeVar);
        }
        test.startTest();
		Sys_InvocableHandler.printOldAndCurrentValues(invokeList);
        test.stopTest();
        List < SYS_IntegrationLog__c > insertedLogResponse = [SELECT Name, Status__c, SYS_Http_Status__c, SYS_Operation_Type__c, SYS_RequestId__c, Type__c, WhatId__c, data0__c, data1__c, data2__c, data3__c, data4__c, data5__c, data6__c, data7__c, data8__c, data9__c FROM SYS_IntegrationLog__c
                                                              WHERE WhatId__c != null AND Type__c = 'INBOUND' AND SYS_Operation_Type__c = 'RESPONSE' LIMIT 1];
        System.debug('size=='+insertedLogResponse.size());
        if(insertedLogResponse.size() > 0)
        SYS_processQuickbooksResponse.updateIdAndToken(insertedLogResponse);
		list < Product2 > productDetails = [select Name, Id, ProductCode, Description, IsActive, Quickbooks_Id__c, QB_SyncToken__c from Product2];
        system.debug('productDetails'+productDetails);
		SYS_IntegrationLog__c sys = QuickbooksTestDataFactory.getSyslog();
		List < SYS_IntegrationLog__c > insertedLogs = [SELECT Name, Status__c, SYS_Http_Status__c, SYS_Operation_Type__c, SYS_RequestId__c, Type__c, WhatId__c, data0__c, data1__c, data2__c, data3__c, data4__c, data5__c, data6__c, data7__c, data8__c, data9__c FROM SYS_IntegrationLog__c];
		Product2 prod = (ProductDetails.size()>0)?ProductDetails[2]:new Product2();
        system.debug('prod==='+prod);
		system.debug('sysintegrationlog' + insertedLogs.size());
		system.assertEquals(prod.Quickbooks_Id__c, '41');
		system.assertEquals(prod.QB_SyncToken__c, '1');
    }
}