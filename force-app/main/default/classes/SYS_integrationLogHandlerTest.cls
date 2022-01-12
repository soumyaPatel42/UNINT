@isTest
private class SYS_integrationLogHandlerTest {
    @isTest static void transformGETResponseTest(){
        string getResponse = '{"Customer":{"Taxable":true,"BillAddr":{"Id":"387","Line1":"10010 West Geiger Boulevard","City":"Spokane","Country":"United States","CountrySubDivisionCode":"WA","PostalCode":"99224"},"ShipAddr":{"Id":"388","Line1":"10001 Doolittle Drive","City":"Oakland","Country":"United States","CountrySubDivisionCode":"CA","PostalCode":"94603"},"Job":false,"BillWithParent":false,"Balance":0,"BalanceWithJobs":0,"CurrencyRef":{"value":"USD","name":"United States Dollar"},"PreferredDeliveryMethod":"Print","IsProject":false,"domain":"QBO","sparse":false,"Id":"136","SyncToken":"3","MetaData":{"CreateTime":"2021-10-29T05:55:52-07:00","LastUpdatedTime":"2021-10-29T06:09:51-07:00"},"GivenName":"Jennifer","MiddleName":"Junior","FamilyName":"Aniston","FullyQualifiedName":"Jennifer Aniston","DisplayName":"Jennifer Aniston","PrintOnCheckName":"Jennifer Junior Aniston","Active":true,"PrimaryPhone":{"FreeFormNumber":"+19844567890"},"Mobile":{"FreeFormNumber":"+11234567890"},"PrimaryEmailAddr":{"Address":"aniston@gmail.com"},"DefaultTaxCodeRef":{"value":"2"}},"time":"2021-10-29T06:09:51.214-07:00"}';
        string whatId = '0010500000MXwZbAAL';
        SYS_integrationLogHandler.transformGETResponse(getResponse, whatId);
        SYS_IntegrationLog__c sys = QuickbooksTestDataFactory.getSyslog();
		List < SYS_IntegrationLog__c > insertedLogs = [SELECT Name, Status__c, SYS_Http_Status__c, SYS_Operation_Type__c, SYS_RequestId__c, Type__c, WhatId__c, data0__c, data1__c, data2__c, data3__c, data4__c, data5__c, data6__c, data7__c, data8__c, data9__c FROM SYS_IntegrationLog__c];
        system.debug('syslog' + sys);
        system.debug('sysInserted'+insertedLogs);
        //system.assert(insertedLogs.size()>0);  
    }
}