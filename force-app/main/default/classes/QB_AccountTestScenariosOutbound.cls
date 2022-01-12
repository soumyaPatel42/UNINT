@isTest
public class QB_AccountTestScenariosOutbound {
    @isTest static void AccountInsertOutboundTest() {
        string resJson = '{"Customer":{"Taxable":true,"BillAddr":{"Id":"322","Line1":"Delaware","City":"Corolla","Country":"United States","CountrySubDivisionCode":"NC","PostalCode":"27927"},"ShipAddr":{"Id":"323","Line1":"Delaware","City":"Corolla","Country":"United States","CountrySubDivisionCode":"NC","PostalCode":"27927"},"Job":false,"BillWithParent":false,"Balance":0,"BalanceWithJobs":0,"CurrencyRef":{"value":"USD","name":"United States Dollar"},"PreferredDeliveryMethod":"Print","IsProject":false,"domain":"QBO","sparse":false,"Id":"106","SyncToken":"0","MetaData":{"CreateTime":"2021-10-21T14:15:17-07:00","LastUpdatedTime":"2021-10-21T14:15:17-07:00"},"FamilyName":"AccountTesting","FullyQualifiedName":"sk15","DisplayName":"sk15","PrintOnCheckName":"AccountTesting","Active":true,"Mobile":{"FreeFormNumber":"+19999999999"},"PrimaryEmailAddr":{"Address":"js@gmail.com"},"DefaultTaxCodeRef":{"value":"2"}},"time":"2021-10-21T14:16:17.286-07:00"}';
        Map < String, String > responseHeaders = new Map < String, String > ();
        //responseHeaders.put('Content-Type', 'application/json');
        Account AccountData = QuickbooksTestDataFactory.createAccountData();
        insert AccountData;
        Test.setMock(HttpCalloutMock.class, new QuickBookCalloutMock(200, 'OK', resJson, responseHeaders));
        
        
        System.debug('AccountData=='+AccountData);
        SYS_InvocableHandler.MyInvocableVariable invokeVar = new SYS_InvocableHandler.MyInvocableVariable();
        List < SYS_InvocableHandler.MyInvocableVariable > invokeList = new List < SYS_InvocableHandler.MyInvocableVariable > ();
        invokeVar.integrationSetting = 'Quickbooks';
        invokeVar.newVal = AccountData;
        invokeVar.recId = AccountData.Id;
        invokeVar.oldVal = AccountData;
        invokeVar.operationType ='INSERT';      
        invokeList.add(invokeVar);
        Test.startTest();
        
        SYS_InvocableHandler.printOldAndCurrentValues(invokeList);
        
        Test.stopTest();
        List < SYS_IntegrationLog__c > insertedLogResponse = [SELECT Name, Status__c, SYS_Http_Status__c, SYS_Operation_Type__c, SYS_RequestId__c, Type__c, WhatId__c, data0__c, data1__c, data2__c, data3__c, data4__c, data5__c, data6__c, data7__c, data8__c, data9__c FROM SYS_IntegrationLog__c
                                                              WHERE WhatId__c != null AND Type__c = 'INBOUND' AND SYS_Operation_Type__c = 'RESPONSE' LIMIT 1];
        System.debug('size=='+insertedLogResponse.size());
        if(insertedLogResponse.size() > 0)
            SYS_processQuickbooksResponse.updateIdAndToken(insertedLogResponse);
        
        SYS_IntegrationLog__c sys = QuickbooksTestDataFactory.getSyslog();
        List < SYS_IntegrationLog__c > insertedLogs = [SELECT Name, Status__c, SYS_Http_Status__c, SYS_Operation_Type__c, SYS_RequestId__c, Type__c, WhatId__c, data0__c, data1__c, data2__c, data3__c, data4__c, data5__c, data6__c, data7__c, data8__c, data9__c FROM SYS_IntegrationLog__c];
        system.debug('syslog' + sys);
        system.debug('sysInserted'+insertedLogs);
        system.debug('sys2'+insertedLogs[0].data0__c);
        
        //list < Account > AccountDetails = QuickbooksTestDataFactory.GetAccountData(AccountData.Id);
        list < Account > AccountDetails = [select Quickbooks_Link__c, name,Display_Name__c,Quickbooks_Id__c,QB_SyncToken__c from Account ];
        system.debug('AccountDetails'+AccountDetails[0].Display_Name__c+''+AccountDetails[0].Quickbooks_Id__c);
        for(account acc :AccountDetails){
            system.debug('accountqb'+acc.Quickbooks_Id__c+ ''+acc.Display_Name__c+''+acc.Quickbooks_Link__c );
        }
        Account acc = (AccountDetails.size()>0)?AccountDetails[0]:new Account();
        system.debug('acc==='+acc);
        system.debug('sysintegrationlog' + insertedLogs.size());
        system.assertEquals(acc.Quickbooks_Id__c, '106');
        system.assertEquals(acc.QB_SyncToken__c, '0');
    }
    @isTest static void AccountUpdateOutboundTest() {
        string resJson = '{"Customer":{"Taxable":true,"BillAddr":{"Id":"322","Line1":"Delaware","City":"Corolla","Country":"United States","CountrySubDivisionCode":"NC","PostalCode":"27927"},"ShipAddr":{"Id":"323","Line1":"Delaware","City":"Corolla","Country":"United States","CountrySubDivisionCode":"NC","PostalCode":"27927"},"Job":false,"BillWithParent":false,"Balance":0,"BalanceWithJobs":0,"CurrencyRef":{"value":"USD","name":"United States Dollar"},"PreferredDeliveryMethod":"Print","IsProject":false,"domain":"QBO","sparse":false,"Id":"106","SyncToken":"0","MetaData":{"CreateTime":"2021-10-21T14:15:17-07:00","LastUpdatedTime":"2021-10-21T14:15:17-07:00"},"FamilyName":"AccountTesting","FullyQualifiedName":"sk15","DisplayName":"sk15","PrintOnCheckName":"AccountTesting","Active":true,"Mobile":{"FreeFormNumber":"+19999999999"},"PrimaryEmailAddr":{"Address":"js@gmail.com"},"DefaultTaxCodeRef":{"value":"2"}},"time":"2021-10-21T14:16:17.286-07:00"}';
        Map < String, String > responseHeaders = new Map < String, String > ();
        responseHeaders.put('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, new QuickBookCalloutMock(200, 'OK', resJson, responseHeaders));
        Account AccountData = QuickbooksTestDataFactory.createAccountData();
        insert AccountData;
        Account AccountUpdate = QuickbooksTestDataFactory.UpDateAccountData(AccountData.Id);
        update AccountUpdate;
        system.debug('AccountUpdate'+AccountUpdate);
        SYS_InvocableHandler.MyInvocableVariable invokeVar = new SYS_InvocableHandler.MyInvocableVariable();
        List < SYS_InvocableHandler.MyInvocableVariable > invokeList = new List < SYS_InvocableHandler.MyInvocableVariable > ();
        invokeVar.integrationSetting = 'Quickbooks';
        invokeVar.newVal = AccountUpdate;
        invokeVar.recId = AccountUpdate.Id;
        invokeVar.oldVal = AccountUpdate;
        invokeVar.operationType ='UPDATE';
        invokeList.add(invokeVar);
        Test.startTest();
        SYS_InvocableHandler.printOldAndCurrentValues(invokeList);
        Test.stopTest();
        List < SYS_IntegrationLog__c > insertedLogResponse = [SELECT Name, Status__c, SYS_Http_Status__c, SYS_Operation_Type__c, SYS_RequestId__c, Type__c, WhatId__c, data0__c, data1__c, data2__c, data3__c, data4__c, data5__c, data6__c, data7__c, data8__c, data9__c FROM SYS_IntegrationLog__c
                                                              WHERE WhatId__c != null AND Type__c = 'INBOUND' AND SYS_Operation_Type__c = 'RESPONSE' LIMIT 1];
        System.debug('size=='+insertedLogResponse.size());
        if(insertedLogResponse.size() > 0)
            SYS_processQuickbooksResponse.updateIdAndToken(insertedLogResponse);
        SYS_IntegrationLog__c sys = QuickbooksTestDataFactory.getSyslog();
        List < SYS_IntegrationLog__c > insertedLogs = [SELECT Name, Status__c, SYS_Http_Status__c, SYS_Operation_Type__c, SYS_RequestId__c, Type__c, WhatId__c, data0__c, data1__c, data2__c, data3__c, data4__c, data5__c, data6__c, data7__c, data8__c, data9__c FROM SYS_IntegrationLog__c];
        // list < Account > AccountDetails = QuickbooksTestDataFactory.GetAccountData(AccountUpdate.Id);
        list < Account > AccountDetails = [select Quickbooks_Link__c, name,Display_Name__c,Quickbooks_Id__c,QB_SyncToken__c from Account ];
        system.debug('AccountDetails'+AccountDetails);
        system.debug('sysintegrationlog' + insertedLogs.size());
        Account acc = (AccountDetails.size()>0)?AccountDetails[0]:new Account();
        system.debug('acc==='+acc);
        system.debug('sysintegrationlog' + insertedLogs.size());
        system.assertEquals(acc.Quickbooks_Id__c, '106');
        system.assertEquals(acc.QB_SyncToken__c, '0');
        
    }
    @isTest static void AccountInsertListOutboundTest() {
        string resJson1 = '{"Customer":{"Taxable":true,"BillAddr":{"Id":"322","Line1":"Delaware","City":"Corolla","Country":"United States","CountrySubDivisionCode":"NC","PostalCode":"27927"},"ShipAddr":{"Id":"323","Line1":"Delaware","City":"Corolla","Country":"United States","CountrySubDivisionCode":"NC","PostalCode":"27927"},"Job":false,"BillWithParent":false,"Balance":0,"BalanceWithJobs":0,"CurrencyRef":{"value":"USD","name":"United States Dollar"},"PreferredDeliveryMethod":"Print","IsProject":false,"domain":"QBO","sparse":false,"Id":"106","SyncToken":"0","MetaData":{"CreateTime":"2021-10-21T14:15:17-07:00","LastUpdatedTime":"2021-10-21T14:15:17-07:00"},"FamilyName":"AccountTesting","FullyQualifiedName":"sk15","DisplayName":"sk15","PrintOnCheckName":"AccountTesting","Active":true,"Mobile":{"FreeFormNumber":"+19999999999"},"PrimaryEmailAddr":{"Address":"js@gmail.com"},"DefaultTaxCodeRef":{"value":"2"}},"time":"2021-10-21T14:16:17.286-07:00"}';
        string resJson2 = '{"Customer":{"Taxable":true,"BillAddr":{"Id":"322","Line1":"Delaware","City":"Corolla","Country":"United States","CountrySubDivisionCode":"NC","PostalCode":"27927"},"ShipAddr":{"Id":"323","Line1":"Delaware","City":"Corolla","Country":"United States","CountrySubDivisionCode":"NC","PostalCode":"27927"},"Job":false,"BillWithParent":false,"Balance":0,"BalanceWithJobs":0,"CurrencyRef":{"value":"USD","name":"United States Dollar"},"PreferredDeliveryMethod":"Print","IsProject":false,"domain":"QBO","sparse":false,"Id":"107","SyncToken":"0","MetaData":{"CreateTime":"2021-10-21T14:15:17-07:00","LastUpdatedTime":"2021-10-21T14:15:17-07:00"},"FamilyName":"AccountTesting1","FullyQualifiedName":"sk15","DisplayName":"sk15","PrintOnCheckName":"AccountTesting","Active":true,"Mobile":{"FreeFormNumber":"+19999999999"},"PrimaryEmailAddr":{"Address":"js@gmail.com"},"DefaultTaxCodeRef":{"value":"2"}},"time":"2021-10-21T14:16:17.286-07:00"}';
        Map < String, String > responseHeaders = new Map < String, String > ();
        //responseHeaders.put('Content-Type', 'application/json');
        
        Test.setMock(HttpCalloutMock.class, new QuickBookCalloutMock(200, 'OK', resJson1, responseHeaders));
        Test.setMock(HttpCalloutMock.class, new QuickBookCalloutMock(200, 'OK', resJson2, responseHeaders));
        list < Account > AccountData = QuickbooksTestDataFactory.BulkAccountInsert();
        Test.startTest();
        insert AccountData;
        system.debug('AccountData=='+AccountData);
        sys_InvocableHandler.MyInvocableVariable invokeVar = new sys_InvocableHandler.MyInvocableVariable();
        List < sys_InvocableHandler.MyInvocableVariable > invokeList = new List < sys_InvocableHandler.MyInvocableVariable > ();
        for (account accnts: AccountData) {
            invokeVar.integrationSetting = 'Quickbooks';
            invokeVar.newVal = accnts;
            invokeVar.recId = accnts.Id;
            invokeVar.operationType ='INSERT';     
            invokeList.add(invokeVar);
            system.debug('invokeList=='+invokeList.size());
        }
        sys_InvocableHandler.printOldAndCurrentValues(invokeList);
        Test.stopTest();
        List < SYS_IntegrationLog__c > insertedLogResponse = [SELECT Name, Status__c, SYS_Http_Status__c, SYS_Operation_Type__c, SYS_RequestId__c, Type__c, WhatId__c, data0__c, data1__c, data2__c, data3__c, data4__c, data5__c, data6__c, data7__c, data8__c, data9__c FROM SYS_IntegrationLog__c
                                                              WHERE WhatId__c != null AND Type__c = 'INBOUND' AND SYS_Operation_Type__c = 'RESPONSE' LIMIT 1];
        System.debug('size=='+insertedLogResponse.size());
        if(insertedLogResponse.size() > 0)
            SYS_processQuickbooksResponse.updateIdAndToken(insertedLogResponse);
        SYS_IntegrationLog__c sys = QuickbooksTestDataFactory.getSyslog();
        List < SYS_IntegrationLog__c > insertedLogs = [SELECT Name, Status__c, SYS_Http_Status__c, SYS_Operation_Type__c, SYS_RequestId__c, Type__c, WhatId__c, data0__c, data1__c, data2__c, data3__c, data4__c, data5__c, data6__c, data7__c, data8__c, data9__c FROM SYS_IntegrationLog__c];
        system.debug('syslog' + sys);
        list < Account > AccountDetails = QuickbooksTestDataFactory.GetAccountList();
        system.debug('accountInsert' + AccountDetails);
        Account acc = (AccountDetails.size()>0)?AccountDetails[1]:new Account();
        
        system.debug('accountRecord' + acc.QB_SyncToken__c);
        system.debug('sysintegrationlog' + insertedLogs.size());
        system.assertEquals('107',acc.Quickbooks_Id__c );
        system.assertEquals('0',acc.QB_SyncToken__c );
    }
    @isTest static void AccountmokeUpdateOutboundTest() {
        string resJson1 = '{"Customer":{"Id":"106","SyncToken":"0","FamilyName":"ACC - 000","FullyQualifiedName":"ACC - 000","DisplayName":"ACC - 000","PrintOnCheckName":"ACC - 000","Active":true,"Mobile":{"FreeFormNumber":"+19999999999"},"PrimaryEmailAddr":{"Address":"js@gmail.com"},"Taxable":true,"BillAddr":{"Id":"322","Line1":"Delaware","City":"Corolla","Country":"United States","CountrySubDivisionCode":"NC","PostalCode":"27927"},"ShipAddr":{"Id":"323","Line1":"Delaware","City":"Corolla","Country":"United States","CountrySubDivisionCode":"NC","PostalCode":"27927"},"Job":false,"BillWithParent":false,"Balance":0,"BalanceWithJobs":0,"CurrencyRef":{"value":"USD","name":"United States Dollar"},"PreferredDeliveryMethod":"Print","IsProject":false,"domain":"QBO","sparse":false,"MetaData":{"CreateTime":"2021-10-21T14:15:17-07:00","LastUpdatedTime":"2021-10-21T14:15:17-07:00"},"DefaultTaxCodeRef":{"value":"2"}},"time":"2021-10-21T14:16:17.286-07:00"}';
        string resJson2 = '{"Customer":{"Id":"107","SyncToken":"1","FamilyName":"ACC - 001","FullyQualifiedName":"ACC - 001","DisplayName":"ACC - 001","PrintOnCheckName":"ACC - 001","Active":true,"Mobile":{"FreeFormNumber":"+19999999999"},"PrimaryEmailAddr":{"Address":"js@gmail.com"},"Taxable":true,"BillAddr":{"Id":"322","Line1":"Delaware","City":"Corolla","Country":"United States","CountrySubDivisionCode":"NC","PostalCode":"27927"},"ShipAddr":{"Id":"323","Line1":"Delaware","City":"Corolla","Country":"United States","CountrySubDivisionCode":"NC","PostalCode":"27927"},"Job":false,"BillWithParent":false,"Balance":0,"BalanceWithJobs":0,"CurrencyRef":{"value":"USD","name":"United States Dollar"},"PreferredDeliveryMethod":"Print","IsProject":false,"domain":"QBO","sparse":false,"MetaData":{"CreateTime":"2021-10-21T14:15:17-07:00","LastUpdatedTime":"2021-10-21T14:15:17-07:00"},"DefaultTaxCodeRef":{"value":"2"}},"time":"2021-10-21T14:16:17.286-07:00"}';
        Map < String, String > responseHeaders = new Map < String, String > ();
        //responseHeaders.put('Content-Type', 'application/json');
        //QuickBookCalloutMock.requestBody = '';
        Test.setMock(HttpCalloutMock.class, new QuickBookCalloutMock(200, 'OK', resJson1, responseHeaders));
        Test.setMock(HttpCalloutMock.class, new QuickBookCalloutMock(200, 'OK', resJson2, responseHeaders));
        list < Account > AccountRec = QuickbooksTestDataFactory.BulkAccountInsert();
        insert AccountRec;
        system.debug('AccountRec'+AccountRec);
        list < Account > AccountRecUP = QuickbooksTestDataFactory.mokeupdateAccount();
        update AccountRecUP;
        system.debug('AccountRecUP=='+AccountRec);
        
        Test.startTest();
        List < sys_InvocableHandler.MyInvocableVariable > invokeList = new List < sys_InvocableHandler.MyInvocableVariable > ();
        sys_InvocableHandler.MyInvocableVariable invokeVar = new sys_InvocableHandler.MyInvocableVariable();
        for (Account accnts: AccountRec) {
            invokeVar.integrationSetting = 'Quickbooks';
            invokeVar.newVal = accnts;
            invokeVar.recId = accnts.Id;
            invokeVar.operationType ='UPDATE';
            if(invokeList.size()==0)
            invokeList.add(invokeVar);
            system.debug('invokeList=='+invokeList.size());
            system.debug('invokeList account before add=='+accnts);   
        }
        sys_InvocableHandler.printOldAndCurrentValues(invokeList);
        Test.stopTest();
        List < SYS_IntegrationLog__c > insertedLogResponse = [SELECT Name, Status__c, SYS_Http_Status__c, SYS_Operation_Type__c, SYS_RequestId__c, Type__c, WhatId__c, data0__c, data1__c, data2__c, data3__c, data4__c, data5__c, data6__c, data7__c, data8__c, data9__c FROM SYS_IntegrationLog__c
                                                              WHERE WhatId__c != null AND Type__c = 'INBOUND' AND SYS_Operation_Type__c = 'RESPONSE'];
        System.debug('size=='+insertedLogResponse.size());
        if(insertedLogResponse.size() > 0)
            SYS_processQuickbooksResponse.updateIdAndToken(insertedLogResponse);
        SYS_IntegrationLog__c sys = QuickbooksTestDataFactory.getSyslog();
        List < SYS_IntegrationLog__c > insertedLogs = [SELECT Name, Status__c, SYS_Http_Status__c, SYS_Operation_Type__c, SYS_RequestId__c, Type__c, WhatId__c, data0__c, data1__c, data2__c, data3__c, data4__c, data5__c, data6__c, data7__c, data8__c, data9__c FROM SYS_IntegrationLog__c];
        system.debug('syslog' + sys);
        List < Account > AccountDetails = [select Quickbooks_Link__c, name,Display_Name__c,Quickbooks_Id__c,QB_SyncToken__c from Account WHERE Quickbooks_Id__c !=''];

        Account acc = (AccountDetails.size()>0)?AccountDetails[0]:new Account();
        system.debug('accountInsert' + AccountDetails);
        system.debug('sysintegrationlog' + insertedLogs.size());
        system.assertEquals(acc.Quickbooks_Id__c, '107');
        system.assertEquals(acc.QB_SyncToken__c, '0');
    }
    @isTest static void AccountmokeDeleteOutboundTest() {
        string resJson1 = '{"Customer":{"Taxable":true,"BillAddr":{"Id":"322","Line1":"Delaware","City":"Corolla","Country":"United States","CountrySubDivisionCode":"NC","PostalCode":"27927"},"ShipAddr":{"Id":"323","Line1":"Delaware","City":"Corolla","Country":"United States","CountrySubDivisionCode":"NC","PostalCode":"27927"},"Job":false,"BillWithParent":false,"Balance":0,"BalanceWithJobs":0,"CurrencyRef":{"value":"USD","name":"United States Dollar"},"PreferredDeliveryMethod":"Print","IsProject":false,"domain":"QBO","sparse":false,"Id":"106","SyncToken":"0","MetaData":{"CreateTime":"2021-10-21T14:15:17-07:00","LastUpdatedTime":"2021-10-21T14:15:17-07:00"},"FamilyName":"AccountTesting","FullyQualifiedName":"sk15","DisplayName":"sk15","PrintOnCheckName":"AccountTesting","Active":true,"Mobile":{"FreeFormNumber":"+19999999999"},"PrimaryEmailAddr":{"Address":"js@gmail.com"},"DefaultTaxCodeRef":{"value":"2"}},"time":"2021-10-21T14:16:17.286-07:00"}';
        string resJson2 = '{"Customer":{"Taxable":true,"BillAddr":{"Id":"322","Line1":"Delaware","City":"Corolla","Country":"United States","CountrySubDivisionCode":"NC","PostalCode":"27927"},"ShipAddr":{"Id":"323","Line1":"Delaware","City":"Corolla","Country":"United States","CountrySubDivisionCode":"NC","PostalCode":"27927"},"Job":false,"BillWithParent":false,"Balance":0,"BalanceWithJobs":0,"CurrencyRef":{"value":"USD","name":"United States Dollar"},"PreferredDeliveryMethod":"Print","IsProject":false,"domain":"QBO","sparse":false,"Id":"107","SyncToken":"0","MetaData":{"CreateTime":"2021-10-21T14:15:17-07:00","LastUpdatedTime":"2021-10-21T14:15:17-07:00"},"FamilyName":"AccountTesting1","FullyQualifiedName":"sk15","DisplayName":"sk15","PrintOnCheckName":"AccountTesting","Active":true,"Mobile":{"FreeFormNumber":"+19999999999"},"PrimaryEmailAddr":{"Address":"js@gmail.com"},"DefaultTaxCodeRef":{"value":"2"}},"time":"2021-10-21T14:16:17.286-07:00"}';
        Map < String, String > responseHeaders = new Map < String, String > ();
        //responseHeaders.put('Content-Type', 'application/json');
        
        Test.setMock(HttpCalloutMock.class, new QuickBookCalloutMock(200, 'OK', resJson1, responseHeaders));
        Test.setMock(HttpCalloutMock.class, new QuickBookCalloutMock(200, 'OK', resJson2, responseHeaders));
        list < Account > AccountRec = QuickbooksTestDataFactory.BulkAccountInsert();
        insert AccountRec;
        system.debug('AccountRec'+AccountRec);
        list < Account > AccountRecDE = QuickbooksTestDataFactory.mokeDeleteAccount();
        update AccountRecDE;
        system.debug('AccountRecDE=='+AccountRecDE);
        sys_InvocableHandler.MyInvocableVariable invokeVar = new sys_InvocableHandler.MyInvocableVariable();
        List < sys_InvocableHandler.MyInvocableVariable > invokeList = new List < sys_InvocableHandler.MyInvocableVariable > ();
        for (account accnts: AccountRecDE) {
            invokeVar.integrationSetting = 'Quickbooks';
            invokeVar.newVal = accnts;
            invokeVar.recId = accnts.Id;
            invokeVar.operationType ='UPDATE';     
            invokeList.add(invokeVar);
            system.debug('invokeList=='+invokeList.size());
        }
        Test.startTest();
        sys_InvocableHandler.printOldAndCurrentValues(invokeList);
        Test.stopTest();
        List < SYS_IntegrationLog__c > insertedLogResponse = [SELECT Name, Status__c, SYS_Http_Status__c, SYS_Operation_Type__c, SYS_RequestId__c, Type__c, WhatId__c, data0__c, data1__c, data2__c, data3__c, data4__c, data5__c, data6__c, data7__c, data8__c, data9__c FROM SYS_IntegrationLog__c
                                                              WHERE WhatId__c != null AND Type__c = 'INBOUND' AND SYS_Operation_Type__c = 'RESPONSE' LIMIT 1];
        System.debug('size=='+insertedLogResponse.size());
        if(insertedLogResponse.size() > 0)
            SYS_processQuickbooksResponse.updateIdAndToken(insertedLogResponse);
        SYS_IntegrationLog__c sys = QuickbooksTestDataFactory.getSyslog();
        List < SYS_IntegrationLog__c > insertedLogs = [SELECT Name, Status__c, SYS_Http_Status__c, SYS_Operation_Type__c, SYS_RequestId__c, Type__c, WhatId__c, data0__c, data1__c, data2__c, data3__c, data4__c, data5__c, data6__c, data7__c, data8__c, data9__c FROM SYS_IntegrationLog__c];
        system.debug('syslog' + sys);
        list < Account > AccountDetails = QuickbooksTestDataFactory.GetAccountList();
        List < Account > QBAccountDetails = QuickbooksTestDataFactory.GetQBAccountList();
        system.debug('accountInsert' + AccountDetails);
        system.debug('accountInsert QB' + QBAccountDetails);
        system.debug('sysintegrationlog' + insertedLogs.size());
        system.assertEquals(QBAccountDetails[0].Quickbooks_Id__c, '107');
        system.assertEquals(QBAccountDetails[0].QB_SyncToken__c, '0');
        
    }
    @isTest static void StatuscodeOutboundTest() {
        string resJson = '{"Customer":{"Taxable":true,"BillAddr":{"Id":"322","Line1":"Delaware","City":"Corolla","Country":"United States","CountrySubDivisionCode":"NC","PostalCode":"27927"},"ShipAddr":{"Id":"323","Line1":"Delaware","City":"Corolla","Country":"United States","CountrySubDivisionCode":"NC","PostalCode":"27927"},"Job":false,"BillWithParent":false,"Balance":0,"BalanceWithJobs":0,"CurrencyRef":{"value":"USD","name":"United States Dollar"},"PreferredDeliveryMethod":"Print","IsProject":false,"domain":"QBO","sparse":false,"Id":"106","SyncToken":"0","MetaData":{"CreateTime":"2021-10-21T14:15:17-07:00","LastUpdatedTime":"2021-10-21T14:15:17-07:00"},"FamilyName":"AccountTesting","FullyQualifiedName":"sk15","DisplayName":"sk15","PrintOnCheckName":"AccountTesting","Active":true,"Mobile":{"FreeFormNumber":"+19999999999"},"PrimaryEmailAddr":{"Address":"js@gmail.com"},"DefaultTaxCodeRef":{"value":"2"}},"time":"2021-10-21T14:16:17.286-07:00"}';
        Map < String, String > responseHeaders = new Map < String, String > ();
        //responseHeaders.put('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, new QuickBookCalloutMock(200, 'OK', resJson, responseHeaders));
        Account AccountData = QuickbooksTestDataFactory.createAccountData();
        insert AccountData;
        
        system.debug('AccountData=='+AccountData);
        SYS_InvocableHandler.MyInvocableVariable invokeVar = new SYS_InvocableHandler.MyInvocableVariable();
        List < SYS_InvocableHandler.MyInvocableVariable > invokeList = new List < SYS_InvocableHandler.MyInvocableVariable > ();
        invokeVar.integrationSetting = 'Quickbooks';
        invokeVar.newVal = AccountData;
        invokeVar.recId = AccountData.Id;
        invokeVar.oldVal = AccountData;
        invokeVar.operationType ='INSERT';     
        invokeList.add(invokeVar);
        Test.startTest();
        
        SYS_InvocableHandler.printOldAndCurrentValues(invokeList);
        
        Test.stopTest();
        List < SYS_IntegrationLog__c > insertedLogResponse = [SELECT Name, Status__c, SYS_Http_Status__c, SYS_Operation_Type__c, SYS_RequestId__c, Type__c, WhatId__c, data0__c, data1__c, data2__c, data3__c, data4__c, data5__c, data6__c, data7__c, data8__c, data9__c FROM SYS_IntegrationLog__c
                                                              WHERE WhatId__c != null AND Type__c = 'INBOUND' AND SYS_Operation_Type__c = 'RESPONSE' LIMIT 1];
        System.debug('size=='+insertedLogResponse.size());
        if(insertedLogResponse.size() > 0)
            SYS_processQuickbooksResponse.updateIdAndToken(insertedLogResponse);
        
        SYS_IntegrationLog__c sys = QuickbooksTestDataFactory.getSyslog();
        List < SYS_IntegrationLog__c > insertedLogs = [SELECT Name, Status__c, SYS_Http_Status__c, SYS_Operation_Type__c, SYS_RequestId__c, Type__c, WhatId__c, data0__c, data1__c, data2__c, data3__c, data4__c, data5__c, data6__c, data7__c, data8__c, data9__c FROM SYS_IntegrationLog__c];
        system.debug('syslog' + sys);
        system.debug('sysInserted'+insertedLogs);
        system.debug('sys2'+insertedLogs[0].data0__c);
        //list < Account > AccountDetails = QuickbooksTestDataFactory.GetAccountData(AccountData.Id);
        list < Account > AccountDetails = [select Quickbooks_Link__c, name,Display_Name__c,Quickbooks_Id__c,QB_SyncToken__c from Account ];
        system.debug('AccountDetails'+AccountDetails[0].Display_Name__c+''+AccountDetails[0].Quickbooks_Id__c);
        for(account acc :AccountDetails){
            system.debug('accountqb'+acc.Quickbooks_Id__c+ ''+acc.Display_Name__c+''+acc.Quickbooks_Link__c );
        }
        Account acc = (AccountDetails.size()>0)?AccountDetails[0]:new Account();
        system.debug('acc==='+acc);
        system.debug('sysintegrationlog' + insertedLogs.size());
        system.assert(insertedLogs.size()>0);
        
    }
    @isTest static void AccountDeleteOutboundTest() {
        string resJson = '{"Customer":{"Taxable":true,"BillAddr":{"Id":"322","Line1":"Delaware","City":"Corolla","Country":"United States","CountrySubDivisionCode":"NC","PostalCode":"27927"},"ShipAddr":{"Id":"323","Line1":"Delaware","City":"Corolla","Country":"United States","CountrySubDivisionCode":"NC","PostalCode":"27927"},"Job":false,"BillWithParent":false,"Balance":0,"BalanceWithJobs":0,"CurrencyRef":{"value":"USD","name":"United States Dollar"},"PreferredDeliveryMethod":"Print","IsProject":false,"domain":"QBO","sparse":false,"Id":"106","SyncToken":"0","MetaData":{"CreateTime":"2021-10-21T14:15:17-07:00","LastUpdatedTime":"2021-10-21T14:15:17-07:00"},"FamilyName":"AccountTesting","FullyQualifiedName":"sk15","DisplayName":"sk15","PrintOnCheckName":"AccountTesting","Active":true,"Mobile":{"FreeFormNumber":"+19999999999"},"PrimaryEmailAddr":{"Address":"js@gmail.com"},"DefaultTaxCodeRef":{"value":"2"}},"time":"2021-10-21T14:16:17.286-07:00"}';
        Map < String, String > responseHeaders = new Map < String, String > ();
        responseHeaders.put('Content-Type', 'application/json');
        
        Test.setMock(HttpCalloutMock.class, new QuickBookCalloutMock(200, 'OK', resJson, responseHeaders));
        Account AccountData = QuickbooksTestDataFactory.createAccountData();
        
        insert AccountData;
        account accountDelete = QuickbooksTestDataFactory.DeleteAccountData(AccountData.Id);
        update accountDelete;
        system.debug('accountdelete' + accountDelete);
        SYS_InvocableHandler.MyInvocableVariable invokeVar = new SYS_InvocableHandler.MyInvocableVariable();
        List < SYS_InvocableHandler.MyInvocableVariable > invokeList = new List < SYS_InvocableHandler.MyInvocableVariable > ();
        invokeVar.integrationSetting = 'Quickbooks';
        invokeVar.newVal = AccountData;
        invokeVar.recId = AccountData.Id;
        invokeVar.operationType ='UPDATE';
        invokeList.add(invokeVar);
        
        Test.startTest();
        SYS_InvocableHandler.printOldAndCurrentValues(invokeList);
        Test.stopTest();
        List < SYS_IntegrationLog__c > insertedLogResponse = [SELECT Name, Status__c, SYS_Http_Status__c, SYS_Operation_Type__c, SYS_RequestId__c, Type__c, WhatId__c, data0__c, data1__c, data2__c, data3__c, data4__c, data5__c, data6__c, data7__c, data8__c, data9__c FROM SYS_IntegrationLog__c
                                                              WHERE WhatId__c != null AND Type__c = 'INBOUND' AND SYS_Operation_Type__c = 'RESPONSE' LIMIT 1];
        System.debug('size=='+insertedLogResponse.size());
        if(insertedLogResponse.size() > 0)
            SYS_processQuickbooksResponse.updateIdAndToken(insertedLogResponse);
        SYS_IntegrationLog__c sys = QuickbooksTestDataFactory.getSyslog();
        List < SYS_IntegrationLog__c > insertedLogs = [SELECT Name, Status__c, SYS_Http_Status__c, SYS_Operation_Type__c, SYS_RequestId__c, Type__c, WhatId__c, data0__c, data1__c, data2__c, data3__c, data4__c, data5__c, data6__c, data7__c, data8__c, data9__c FROM SYS_IntegrationLog__c];
        system.debug('syslog' + sys);
        list < Account > AccountDetails = QuickbooksTestDataFactory.GetAccountData(accountDelete.Id);
        system.debug('account' + AccountDetails);
        system.debug('accountInsert' + AccountDetails);
        Account acc = (AccountDetails.size()>0)?AccountDetails[0]:new Account();
        system.debug('acc==='+acc);
        system.debug('sysintegrationlog' + insertedLogs.size());
        system.assertEquals(acc.Quickbooks_Id__c, '106');
        system.assertEquals(acc.QB_SyncToken__c, '0');
        
        
    }
}