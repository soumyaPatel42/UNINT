@isTest
public class QB_AccountTestScenariosInbound {
	@isTest static void AccountInsertInboundTest() {
		string resJson = '{"eventNotifications":[{"realmId":"4620816365172373180","dataChangeEvent":{"entities":[{"operation":"Create","name":"Customer","lastUpdated":"2021-10-27T20:00:38.000Z","id":"106"}]}}]}';
		String resJsonImport = '{"Customer":{"Taxable":true,"BillAddr":{"Id":"322","Line1":"Delaware","City":"Corolla","Country":"United States","CountrySubDivisionCode":"NC","PostalCode":"27927"},"ShipAddr":{"Id":"323","Line1":"Delaware","City":"Corolla","Country":"United States","CountrySubDivisionCode":"NC","PostalCode":"27927"},"Job":false,"BillWithParent":false,"Balance":0,"BalanceWithJobs":0,"CurrencyRef":{"value":"USD","name":"United States Dollar"},"PreferredDeliveryMethod":"Print","IsProject":false,"domain":"QBO","sparse":false,"Id":"106","SyncToken":"0","MetaData":{"CreateTime":"2021-10-21T14:15:17-07:00","LastUpdatedTime":"2021-10-21T14:15:17-07:00"},"FamilyName":"AccountTesting","FullyQualifiedName":"sk15","DisplayName":"sk15","PrintOnCheckName":"AccountTesting","Active":true,"Mobile":{"FreeFormNumber":"+19999999999"},"PrimaryEmailAddr":{"Address":"js@gmail.com"},"DefaultTaxCodeRef":{"value":"2"}},"time":"2021-10-21T14:16:17.286-07:00"}';
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
	    List < SYS_IntegrationLog__c > insertedLogs = [SELECT Name, Status__c, SYS_Http_Status__c, SYS_Operation_Type__c, SYS_RequestId__c, Type__c, WhatId__c FROM SYS_IntegrationLog__c];
	    system.debug('sysintegration123' + insertedLogs);
        list<Account>  AccountDetails = [select Id, name, QB_isActive__c, Quickbooks_Id__c, QB_SyncToken__c from Account];
        system.debug('AccountDetails'+AccountDetails);
        Account acc = (AccountDetails.size()>0)?AccountDetails[0]:new Account();
        
        system.debug('accountRecord' + acc.QB_SyncToken__c);
		system.debug('sysintegrationlog' + insertedLogs.size());
		system.assertEquals('106',acc.Quickbooks_Id__c );
		system.assertEquals('0',acc.QB_SyncToken__c );
        /*system.debug('accountRecord' + AccountDetails[1].QB_SyncToken__c);
		system.debug('sysintegrationlog' + insertedLogs.size());
		system.assertEquals(AccountDetails[0].Quickbooks_Id__c, '83');
		system.assertEquals(AccountDetails[0].QB_SyncToken__c, '1');*/
	}
	@isTest static void AccountUpdateInboundTest() {
		string resJson = '{"eventNotifications":[{"realmId":"4620816365172373180","dataChangeEvent":{"entities":[{"operation":"Update","name":"Customer","lastUpdated":"2021-10-27T20:00:38.000Z","id":"106"}]}}]}';
		String resJsonImport = '{"Customer":{"Taxable":true,"BillAddr":{"Id":"322","Line1":"Delaware","City":"Corolla","Country":"United States","CountrySubDivisionCode":"NC","PostalCode":"27927"},"ShipAddr":{"Id":"323","Line1":"Delaware","City":"Corolla","Country":"United States","CountrySubDivisionCode":"NC","PostalCode":"27927"},"Job":false,"BillWithParent":false,"Balance":0,"BalanceWithJobs":0,"CurrencyRef":{"value":"USD","name":"United States Dollar"},"PreferredDeliveryMethod":"Print","IsProject":false,"domain":"QBO","sparse":false,"Id":"106","SyncToken":"1","MetaData":{"CreateTime":"2021-10-21T14:15:17-07:00","LastUpdatedTime":"2021-10-21T14:15:17-07:00"},"FamilyName":"AccountTesting","FullyQualifiedName":"sk15","DisplayName":"sk15","PrintOnCheckName":"AccountTesting","Active":true,"Mobile":{"FreeFormNumber":"+19999999999"},"PrimaryEmailAddr":{"Address":"js@gmail.com"},"DefaultTaxCodeRef":{"value":"2"}},"time":"2021-10-21T14:16:17.286-07:00"}';
		Map < String, String > responseHeaders = new Map < String, String > ();
		responseHeaders.put('Content-Type', 'application/json');
        QB_restmokecallout.requestRestCallout(resJson, 200);
		Test.setMock(HttpCalloutMock.class, new QuickBookCalloutMock(200, 'OK', resJsonImport, responseHeaders));
         Account  Accountinsert = QuickbooksTestDataFactory.createAccountData();
        insert Accountinsert;
       Test.startTest();
      SYS_webhook.processWebhookResponse('', resJson);
        Test.stopTest();
        SYS_IntegrationLog__c sys = QuickbooksTestDataFactory.getSyslog();
	    List < SYS_IntegrationLog__c > insertedLogs = [SELECT Name, Status__c, SYS_Http_Status__c, SYS_Operation_Type__c, SYS_RequestId__c, Type__c, WhatId__c FROM SYS_IntegrationLog__c];
	    system.debug('sysintegration123' + insertedLogs);
        list<Account>  AccountDetails = [select Id, name, QB_isActive__c, Quickbooks_Id__c, QB_SyncToken__c from Account WHERE Quickbooks_Id__c !=''];
        system.debug('AccountDetails'+AccountDetails);
        Account acc = (AccountDetails.size()>0)?AccountDetails[0]:new Account();
        
        system.debug('accountRecord' + acc.QB_SyncToken__c);
		system.debug('sysintegrationlog' + insertedLogs.size());
		system.assertEquals('106',acc.Quickbooks_Id__c );
		system.assertEquals('1',acc.QB_SyncToken__c );
       
	}
    @isTest static void AccountDeleteInboundTest() {
        string resJson = '{"eventNotifications":[{"realmId":"4620816365172373180","dataChangeEvent":{"entities":[{"operation":"Update","name":"Customer","lastUpdated":"2021-10-27T20:00:38.000Z","id":"106"}]}}]}';
		String resJsonImport = '{"Customer":{"Taxable":true,"BillAddr":{"Id":"322","Line1":"Delaware","City":"Corolla","Country":"United States","CountrySubDivisionCode":"NC","PostalCode":"27927"},"ShipAddr":{"Id":"323","Line1":"Delaware","City":"Corolla","Country":"United States","CountrySubDivisionCode":"NC","PostalCode":"27927"},"Job":false,"BillWithParent":false,"Balance":0,"BalanceWithJobs":0,"CurrencyRef":{"value":"USD","name":"United States Dollar"},"PreferredDeliveryMethod":"Print","IsProject":false,"domain":"QBO","sparse":false,"Id":"106","SyncToken":"2","MetaData":{"CreateTime":"2021-10-21T14:15:17-07:00","LastUpdatedTime":"2021-10-21T14:15:17-07:00"},"FamilyName":"AccountTesting","FullyQualifiedName":"sk15","DisplayName":"sk15","PrintOnCheckName":"AccountTesting","Active":false,"Mobile":{"FreeFormNumber":"+19999999999"},"PrimaryEmailAddr":{"Address":"js@gmail.com"},"DefaultTaxCodeRef":{"value":"2"}},"time":"2021-10-21T14:16:17.286-07:00"}';
		Map < String, String > responseHeaders = new Map < String, String > ();
		responseHeaders.put('Content-Type', 'application/json');
        QB_restmokecallout.requestRestCallout(resJson, 200);
		Test.setMock(HttpCalloutMock.class, new QuickBookCalloutMock(200, 'OK', resJsonImport, responseHeaders));
        /* Account  Accountinsert = QuickbooksTestDataFactory.createAccountData();
        insert Accountinsert;*/
       Test.startTest();
      SYS_webhook.processWebhookResponse('', resJson);
        Test.stopTest();
        SYS_IntegrationLog__c sys = QuickbooksTestDataFactory.getSyslog();
	    List < SYS_IntegrationLog__c > insertedLogs = [SELECT Name, Status__c, SYS_Http_Status__c, SYS_Operation_Type__c, SYS_RequestId__c, Type__c, WhatId__c FROM SYS_IntegrationLog__c];
	    system.debug('sysintegration123' + insertedLogs);
        list<Account>  AccountDetails = [select Id, name, QB_isActive__c, Quickbooks_Id__c, QB_SyncToken__c from Account];
        system.debug('AccountDetails'+AccountDetails);
        Account acc = (AccountDetails.size()>0)?AccountDetails[0]:new Account();
        
        system.debug('accountRecord' + acc.QB_SyncToken__c);
		system.debug('sysintegrationlog' + insertedLogs.size());
		system.assertEquals('106',acc.Quickbooks_Id__c );
		system.assertEquals('2',acc.QB_SyncToken__c );
        
    }
    @isTest static void responsecodeAccountInboundTest() {
		string resJson = '{"eventNotifications":[{"realmId":"4620816365172373180","dataChangeEvent":{"entities":[{"operation":"Create","name":"Customer","lastUpdated":"2021-10-27T20:00:38.000Z","id":"106"}]}}]}';
		String resJsonImport = '{"Customer":{"Taxable":true,"BillAddr":{"Id":"322","Line1":"Delaware","City":"Corolla","Country":"United States","CountrySubDivisionCode":"NC","PostalCode":"27927"},"ShipAddr":{"Id":"323","Line1":"Delaware","City":"Corolla","Country":"United States","CountrySubDivisionCode":"NC","PostalCode":"27927"},"Job":false,"BillWithParent":false,"Balance":0,"BalanceWithJobs":0,"CurrencyRef":{"value":"USD","name":"United States Dollar"},"PreferredDeliveryMethod":"Print","IsProject":false,"domain":"QBO","sparse":false,"Id":"106","SyncToken":"0","MetaData":{"CreateTime":"2021-10-21T14:15:17-07:00","LastUpdatedTime":"2021-10-21T14:15:17-07:00"},"FamilyName":"AccountTesting","FullyQualifiedName":"sk15","DisplayName":"sk15","PrintOnCheckName":"AccountTesting","Active":true,"Mobile":{"FreeFormNumber":"+19999999999"},"PrimaryEmailAddr":{"Address":"js@gmail.com"},"DefaultTaxCodeRef":{"value":"2"}},"time":"2021-10-21T14:16:17.286-07:00"}';
		Map < String, String > responseHeaders = new Map < String, String > ();
		responseHeaders.put('Content-Type', 'application/json');
        QB_restmokecallout.requestRestCallout(resJson, 400);
		Test.setMock(HttpCalloutMock.class, new QuickBookCalloutMock(400, 'OK', resJsonImport, responseHeaders));
		Test.startTest();
      SYS_webhook.processWebhookResponse('', resJson);
        Test.stopTest();
         List < SYS_IntegrationLog__c > insertedLogResponse = [SELECT Name, Status__c, SYS_Http_Status__c, SYS_Operation_Type__c, SYS_RequestId__c, Type__c, WhatId__c, data0__c, data1__c, data2__c, data3__c, data4__c, data5__c, data6__c, data7__c, data8__c, data9__c FROM SYS_IntegrationLog__c
                                                              WHERE WhatId__c != null AND Type__c = 'INBOUND' AND SYS_Operation_Type__c = 'RESPONSE' LIMIT 1];
        System.debug('size=='+insertedLogResponse.size());
        if(insertedLogResponse.size() > 0)
        	SYS_processQuickbooksResponse.updateIdAndToken(insertedLogResponse);
        
		SYS_IntegrationLog__c sys = QuickbooksTestDataFactory.getSyslog();
	    List < SYS_IntegrationLog__c > insertedLogs = [SELECT Name, Status__c, SYS_Http_Status__c, SYS_Operation_Type__c, SYS_RequestId__c, Type__c, WhatId__c FROM SYS_IntegrationLog__c];
	    system.debug('sysintegration123' + insertedLogs);
        list<Account>  AccountDetails = [select Id, name, QB_isActive__c, Quickbooks_Id__c, QB_SyncToken__c from Account];
        system.debug('AccountDetails'+AccountDetails);
        Account acc = (AccountDetails.size()>0)?AccountDetails[0]:new Account();
        system.assert(insertedLogs.size() > 0);
		
}

	@isTest static void AccountmokeInsertTest() {
		string resJson1 = '{"eventNotifications":[{"realmId":"4620816365172373180","dataChangeEvent":{"entities":[{"operation":"Create","name":"Customer","lastUpdated":"2021-10-27T20:00:38.000Z","id":"110"}]}}]}';
		String resJsonImport1 = '{"Customer":{"Taxable":true,"BillAddr":{"Id":"322","Line1":"Delaware","City":"Corolla","Country":"United States","CountrySubDivisionCode":"NC","PostalCode":"27927"},"ShipAddr":{"Id":"323","Line1":"Delaware","City":"Corolla","Country":"United States","CountrySubDivisionCode":"NC","PostalCode":"27927"},"Job":false,"BillWithParent":false,"Balance":0,"BalanceWithJobs":0,"CurrencyRef":{"value":"USD","name":"United States Dollar"},"PreferredDeliveryMethod":"Print","IsProject":false,"domain":"QBO","sparse":false,"Id":"110","SyncToken":"0","MetaData":{"CreateTime":"2021-10-21T14:15:17-07:00","LastUpdatedTime":"2021-10-21T14:15:17-07:00"},"FamilyName":"AccountTesting23","FullyQualifiedName":"sk715","DisplayName":"sk15","PrintOnCheckName":"AccountTesting23","Active":true,"Mobile":{"FreeFormNumber":"+19999999999"},"PrimaryEmailAddr":{"Address":"js@gmail.com"},"DefaultTaxCodeRef":{"value":"2"}},"time":"2021-10-21T14:16:17.286-07:00"}';
        string resJson2 = '{"eventNotifications":[{"realmId":"4620816365172373180","dataChangeEvent":{"entities":[{"operation":"Create","name":"Customer","lastUpdated":"2021-10-27T20:00:38.000Z","id":"111"}]}}]}';
		String resJsonImport2 = '{"Customer":{"Taxable":true,"BillAddr":{"Id":"322","Line1":"Delaware","City":"Corolla","Country":"United States","CountrySubDivisionCode":"NC","PostalCode":"27927"},"ShipAddr":{"Id":"323","Line1":"Delaware","City":"Corolla","Country":"United States","CountrySubDivisionCode":"NC","PostalCode":"27927"},"Job":false,"BillWithParent":false,"Balance":0,"BalanceWithJobs":0,"CurrencyRef":{"value":"USD","name":"United States Dollar"},"PreferredDeliveryMethod":"Print","IsProject":false,"domain":"QBO","sparse":false,"Id":"111","SyncToken":"0","MetaData":{"CreateTime":"2021-10-21T14:15:17-07:00","LastUpdatedTime":"2021-10-21T14:15:17-07:00"},"FamilyName":"AccountTesting24","FullyQualifiedName":"sk615","DisplayName":"sk165","PrintOnCheckName":"AccountTesting24","Active":true,"Mobile":{"FreeFormNumber":"+19999999999"},"PrimaryEmailAddr":{"Address":"js@gmail.com"},"DefaultTaxCodeRef":{"value":"2"}},"time":"2021-10-21T14:16:17.286-07:00"}';

        Map < String, String > responseHeaders = new Map < String, String > ();
		responseHeaders.put('Content-Type', 'application/json');
        QB_restmokecallout.requestRestCallout(resJson1, 200);
		Test.setMock(HttpCalloutMock.class, new QuickBookCalloutMock(200, 'OK', resJsonImport1, responseHeaders));
		QB_restmokecallout2.requestRestCallout(resJson2, 200);
		Test.setMock(HttpCalloutMock.class, new QuickBookCalloutMock2(200, 'OK', resJsonImport2, responseHeaders));
		
		//list < Account > AccountUpdate = QuickbooksTestDataFactory.BulkAccountInsert();
		Test.startTest();
		//insert AccountUpdate;
		SYS_webhook.processWebhookResponse('', resJson1);
         Test.stopTest();
		SYS_IntegrationLog__c sys = QuickbooksTestDataFactory.getSyslog();
		system.debug('sys' + sys);
		list < Account > AccountDetails = [select Id, name, QB_isActive__c, Quickbooks_Id__c, QB_SyncToken__c from Account];
		List < SYS_IntegrationLog__c > insertedLogs = [SELECT Name, Status__c, SYS_Http_Status__c, SYS_Operation_Type__c, SYS_RequestId__c, Type__c, WhatId__c, data0__c, data1__c, data2__c, data3__c, data4__c, data5__c, data6__c, data7__c, data8__c, data9__c FROM SYS_IntegrationLog__c];
		system.debug('accountRecord' + AccountDetails);


		 Account acc = (AccountDetails.size()>0)?AccountDetails[0]:new Account();
        
        system.debug('accountRecord' + acc.QB_SyncToken__c);
		system.debug('sysintegrationlog' + insertedLogs.size());
		system.assertEquals('111',acc.Quickbooks_Id__c );
		system.assertEquals('0',acc.QB_SyncToken__c );

	}
	@isTest static void AccountmokeUpdateTest() {
		string resJson1 = '{"eventNotifications":[{"realmId":"4620816365172373180","dataChangeEvent":{"entities":[{"operation":"Update","name":"Customer","lastUpdated":"2021-10-27T20:00:38.000Z","id":"110"}]}}]}';
		String resJsonImport1 = '{"Customer":{"Taxable":true,"BillAddr":{"Id":"322","Line1":"Delaware","City":"Corolla","Country":"United States","CountrySubDivisionCode":"NC","PostalCode":"27927"},"ShipAddr":{"Id":"323","Line1":"Delaware","City":"Corolla","Country":"United States","CountrySubDivisionCode":"NC","PostalCode":"27927"},"Job":false,"BillWithParent":false,"Balance":0,"BalanceWithJobs":0,"CurrencyRef":{"value":"USD","name":"United States Dollar"},"PreferredDeliveryMethod":"Print","IsProject":false,"domain":"QBO","sparse":false,"Id":"110","SyncToken":"1","MetaData":{"CreateTime":"2021-10-21T14:15:17-07:00","LastUpdatedTime":"2021-10-21T14:15:17-07:00"},"FamilyName":"AccountTesting3","FullyQualifiedName":"sk715","DisplayName":"sk15","PrintOnCheckName":"AccountTesting23","Active":true,"Mobile":{"FreeFormNumber":"+19999999999"},"PrimaryEmailAddr":{"Address":"js@gmail.com"},"DefaultTaxCodeRef":{"value":"2"}},"time":"2021-10-21T14:16:17.286-07:00"}';
        string resJson2 = '{"eventNotifications":[{"realmId":"4620816365172373180","dataChangeEvent":{"entities":[{"operation":"Update","name":"Customer","lastUpdated":"2021-10-27T20:00:38.000Z","id":"111"}]}}]}';
		String resJsonImport2 = '{"Customer":{"Taxable":true,"BillAddr":{"Id":"322","Line1":"Delaware","City":"Corolla","Country":"United States","CountrySubDivisionCode":"NC","PostalCode":"27927"},"ShipAddr":{"Id":"323","Line1":"Delaware","City":"Corolla","Country":"United States","CountrySubDivisionCode":"NC","PostalCode":"27927"},"Job":false,"BillWithParent":false,"Balance":0,"BalanceWithJobs":0,"CurrencyRef":{"value":"USD","name":"United States Dollar"},"PreferredDeliveryMethod":"Print","IsProject":false,"domain":"QBO","sparse":false,"Id":"111","SyncToken":"1","MetaData":{"CreateTime":"2021-10-21T14:15:17-07:00","LastUpdatedTime":"2021-10-21T14:15:17-07:00"},"FamilyName":"AccountTesting4","FullyQualifiedName":"sk615","DisplayName":"sk165","PrintOnCheckName":"AccountTesting24","Active":true,"Mobile":{"FreeFormNumber":"+19999999999"},"PrimaryEmailAddr":{"Address":"js@gmail.com"},"DefaultTaxCodeRef":{"value":"2"}},"time":"2021-10-21T14:16:17.286-07:00"}';

        Map < String, String > responseHeaders = new Map < String, String > ();
		responseHeaders.put('Content-Type', 'application/json');
        QB_restmokecallout.requestRestCallout(resJson1, 200);
		Test.setMock(HttpCalloutMock.class, new QuickBookCalloutMock(200, 'OK', resJsonImport1, responseHeaders));
		QB_restmokecallout.requestRestCallout(resJson2, 200);
		Test.setMock(HttpCalloutMock.class, new QuickBookCalloutMock2(200, 'OK', resJsonImport2, responseHeaders));

		//list < Account > AccountUpdate = QuickbooksTestDataFactory.mokeupdateAccount();
		Test.startTest();
		//update AccountUpdate;
		SYS_webhook.processWebhookResponse('', resJson1);
		SYS_IntegrationLog__c sys = QuickbooksTestDataFactory.getSyslog();
		system.debug('sys' + sys);
		Test.stopTest();
		list < Account > AccountDetails = [select Id, name, Rating, Industry, QB_isActive__c, Quickbooks_Id__c, QB_SyncToken__c from Account];
		List < SYS_IntegrationLog__c > insertedLogs = [SELECT Name, Status__c, SYS_Http_Status__c, SYS_Operation_Type__c, SYS_RequestId__c, Type__c, WhatId__c, data0__c, data1__c, data2__c, data3__c, data4__c, data5__c, data6__c, data7__c, data8__c, data9__c FROM SYS_IntegrationLog__c];
		system.debug('accountRecord' + AccountDetails);


		 Account acc = (AccountDetails.size()>0)?AccountDetails[0]:new Account();
        
        system.debug('accountRecord' + acc.QB_SyncToken__c);
		system.debug('sysintegrationlog' + insertedLogs.size());
		system.assertEquals('111',acc.Quickbooks_Id__c );
		system.assertEquals('1',acc.QB_SyncToken__c );
	}
	@isTest static void AccountmokeDeleteTest() {
		string resJson1 = '{"eventNotifications":[{"realmId":"4620816365172373180","dataChangeEvent":{"entities":[{"operation":"Update","name":"Customer","lastUpdated":"2021-10-27T20:00:38.000Z","id":"110"}]}}]}';
		String resJsonImport1 = '{"Customer":{"Taxable":true,"BillAddr":{"Id":"322","Line1":"Delaware","City":"Corolla","Country":"United States","CountrySubDivisionCode":"NC","PostalCode":"27927"},"ShipAddr":{"Id":"323","Line1":"Delaware","City":"Corolla","Country":"United States","CountrySubDivisionCode":"NC","PostalCode":"27927"},"Job":false,"BillWithParent":false,"Balance":0,"BalanceWithJobs":0,"CurrencyRef":{"value":"USD","name":"United States Dollar"},"PreferredDeliveryMethod":"Print","IsProject":false,"domain":"QBO","sparse":false,"Id":"110","SyncToken":"2","MetaData":{"CreateTime":"2021-10-21T14:15:17-07:00","LastUpdatedTime":"2021-10-21T14:15:17-07:00"},"FamilyName":"AccountTesting3","FullyQualifiedName":"sk715","DisplayName":"sk15","PrintOnCheckName":"AccountTesting23","Active":false,"Mobile":{"FreeFormNumber":"+19999999999"},"PrimaryEmailAddr":{"Address":"js@gmail.com"},"DefaultTaxCodeRef":{"value":"2"}},"time":"2021-10-21T14:16:17.286-07:00"}';
        string resJson2 = '{"eventNotifications":[{"realmId":"4620816365172373180","dataChangeEvent":{"entities":[{"operation":"Update","name":"Customer","lastUpdated":"2021-10-27T20:00:38.000Z","id":"111"}]}}]}';
		String resJsonImport2 = '{"Customer":{"Taxable":true,"BillAddr":{"Id":"322","Line1":"Delaware","City":"Corolla","Country":"United States","CountrySubDivisionCode":"NC","PostalCode":"27927"},"ShipAddr":{"Id":"323","Line1":"Delaware","City":"Corolla","Country":"United States","CountrySubDivisionCode":"NC","PostalCode":"27927"},"Job":false,"BillWithParent":false,"Balance":0,"BalanceWithJobs":0,"CurrencyRef":{"value":"USD","name":"United States Dollar"},"PreferredDeliveryMethod":"Print","IsProject":false,"domain":"QBO","sparse":false,"Id":"111","SyncToken":"2","MetaData":{"CreateTime":"2021-10-21T14:15:17-07:00","LastUpdatedTime":"2021-10-21T14:15:17-07:00"},"FamilyName":"AccountTesting4","FullyQualifiedName":"sk615","DisplayName":"sk165","PrintOnCheckName":"AccountTesting24","Active":false,"Mobile":{"FreeFormNumber":"+19999999999"},"PrimaryEmailAddr":{"Address":"js@gmail.com"},"DefaultTaxCodeRef":{"value":"2"}},"time":"2021-10-21T14:16:17.286-07:00"}';

        Map < String, String > responseHeaders = new Map < String, String > ();
		responseHeaders.put('Content-Type', 'application/json');
        QB_restmokecallout.requestRestCallout(resJson1, 200);
		Test.setMock(HttpCalloutMock.class, new QuickBookCalloutMock(200, 'OK', resJsonImport1, responseHeaders));
		QB_restmokecallout.requestRestCallout(resJson2, 200);
		Test.setMock(HttpCalloutMock.class, new QuickBookCalloutMock2(200, 'OK', resJsonImport2, responseHeaders));

		Test.startTest();
		
		SYS_webhook.processWebhookResponse('', resJson1);
        Test.stopTest();
		SYS_IntegrationLog__c sys = QuickbooksTestDataFactory.getSyslog();
		system.debug('sys' + sys);
		
		list < Account > AccountDetails = [select Id, name, QB_isActive__c, Quickbooks_Id__c, QB_SyncToken__c from Account];
		List < SYS_IntegrationLog__c > insertedLogs = [SELECT Name, Status__c, SYS_Http_Status__c, SYS_Operation_Type__c, SYS_RequestId__c, Type__c, WhatId__c, data0__c, data1__c, data2__c, data3__c, data4__c, data5__c, data6__c, data7__c, data8__c, data9__c FROM SYS_IntegrationLog__c];
		system.debug('accountRecord' + AccountDetails);


		 Account acc = (AccountDetails.size()>0)?AccountDetails[0]:new Account();
        
        system.debug('accountRecord' + acc.QB_SyncToken__c);
		system.debug('sysintegrationlog' + insertedLogs.size());
		system.assertEquals('111',acc.Quickbooks_Id__c );
		system.assertEquals('2',acc.QB_SyncToken__c );

	}
	


}