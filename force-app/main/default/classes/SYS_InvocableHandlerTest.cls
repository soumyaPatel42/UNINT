@isTest
public class SYS_InvocableHandlerTest {
    @isTest static void SYS_InvocableHandlerTest() {
        string resJson = '{"Customer":{"Taxable":true,"BillAddr":{"Id":"322","Line1":"Delaware","City":"Corolla","Country":"United States","CountrySubDivisionCode":"NC","PostalCode":"27927"},"ShipAddr":{"Id":"323","Line1":"Delaware","City":"Corolla","Country":"United States","CountrySubDivisionCode":"NC","PostalCode":"27927"},"Job":false,"BillWithParent":false,"Balance":0,"BalanceWithJobs":0,"CurrencyRef":{"value":"USD","name":"United States Dollar"},"PreferredDeliveryMethod":"Print","IsProject":false,"domain":"QBO","sparse":false,"Id":"106","SyncToken":"0","MetaData":{"CreateTime":"2021-10-21T14:15:17-07:00","LastUpdatedTime":"2021-10-21T14:15:17-07:00"},"FamilyName":"AccountTesting","FullyQualifiedName":"sk15","DisplayName":"sk15","PrintOnCheckName":"AccountTesting","Active":true,"Mobile":{"FreeFormNumber":"+19999999999"},"PrimaryEmailAddr":{"Address":"js@gmail.com"},"DefaultTaxCodeRef":{"value":"2"}},"time":"2021-10-21T14:16:17.286-07:00"}';
		Map < String, String > responseHeaders = new Map < String, String > ();
		responseHeaders.put('Content-Type', 'application/json');

		Test.setMock(HttpCalloutMock.class, new QuickBookCalloutMock(200, 'OK', resJson, responseHeaders));
		Account AccountData = QuickbooksTestDataFactory.createAccountData();
		
		insert AccountData;
        Test.startTest();
        SYS_InvocableHandler.MyInvocableVariable invokeVar = new SYS_InvocableHandler.MyInvocableVariable();
		List < SYS_InvocableHandler.MyInvocableVariable > invokeList = new List < SYS_InvocableHandler.MyInvocableVariable > ();
		invokeVar.integrationSetting = 'Quickbooks';
		invokeVar.newVal = AccountData;
		invokeVar.recId = AccountData.Id;
        invokeVar.operationType ='INSERT';
		invokeList.add(invokeVar);
                
        SYS_InvocableHandler.printOldAndCurrentValues(invokeList);
        Test.stopTest();
        List < SYS_IntegrationLog__c > insertedLogs = [SELECT Name, Status__c, SYS_Http_Status__c, SYS_Operation_Type__c, SYS_RequestId__c, Type__c, WhatId__c, data0__c, data1__c, data2__c, data3__c, data4__c, data5__c, data6__c, data7__c, data8__c, data9__c FROM SYS_IntegrationLog__c];
        system.debug('syslog len=='+insertedLogs.size());
        SYS_IntegrationLog__c syslog = (insertedLogs.size() > 0)? insertedLogs[0] : new SYS_IntegrationLog__c();
        System.debug('syslog=='+syslog); 
        system.assertEquals(syslog.Type__c,'OUTBOUND'); 
    }
}