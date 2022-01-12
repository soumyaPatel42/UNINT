@isTest
public class OrderItemTriggerHandlerTest {
    @isTest static void productInsertOutboundTest(){
        string resJson = '{"Customer":{"Taxable":true,"BillAddr":{"Id":"322","Line1":"Delaware","City":"Corolla","Country":"United States","CountrySubDivisionCode":"NC","PostalCode":"27927"},"ShipAddr":{"Id":"323","Line1":"Delaware","City":"Corolla","Country":"United States","CountrySubDivisionCode":"NC","PostalCode":"27927"},"Job":false,"BillWithParent":false,"Balance":0,"BalanceWithJobs":0,"CurrencyRef":{"value":"USD","name":"United States Dollar"},"PreferredDeliveryMethod":"Print","IsProject":false,"domain":"QBO","sparse":false,"Id":"106","SyncToken":"0","MetaData":{"CreateTime":"2021-10-21T14:15:17-07:00","LastUpdatedTime":"2021-10-21T14:15:17-07:00"},"FamilyName":"AccountTesting","FullyQualifiedName":"sk15","DisplayName":"sk15","PrintOnCheckName":"AccountTesting","Active":true,"Mobile":{"FreeFormNumber":"+19999999999"},"PrimaryEmailAddr":{"Address":"js@gmail.com"},"DefaultTaxCodeRef":{"value":"2"}},"time":"2021-10-21T14:16:17.286-07:00"}';
        Map < String, String > responseHeaders = new Map < String, String > ();
		//responseHeaders.put('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, new QuickBookCalloutMock(200, 'OK', resJson, responseHeaders));
        Account accountdata = new account();
       // accountdata.RecordTypeId
        //accountdata.RecordTypeId ='0126A000000l0kFQAQ';
        //accountdata.PersonEmail = 'kate@gmail.com';
        //accountdata.PersonMobilePhone='9999999999';
        //accountdata.PersonLeadSource = 'google';
        // accountdata.Type ='patient'; 
        // accountdata.Patient_Type__c ='VIP';
		accountdata.Display_Name__c = 'sk200'+(math.random() * 10);
        accountdata.DOB__c = date.newInstance(1997,12,10);
        accountdata.Gender__c = 'Male';
        accountdata.BillingStreet = 'Delaware';
        accountdata.BillingCity = 'Corolla';
        accountdata.BillingState ='NC';
        accountdata.BillingPostalCode ='27927';
        accountdata.BillingCountry = 'USA';
        accountdata.Quickbooks_Id__c='106';
        accountdata.QB_SyncToken__c='0';
        accountdata.ShippingStreet = 'Delaware';
        accountdata.ShippingCity = 'Corolla';
        accountdata.ShippingState ='NC';
        accountdata.ShippingPostalCode ='27927';
        accountdata.ShippingCountry = 'USA';
		accountdata.Name = 'Test1'+(math.random() * 10);
		accountdata.Industry = 'Banking';
		accountdata.QB_isActive__c = true;
        Test.startTest();
        insert accountdata;
        /*account acc = QuickbooksTestDataFactory.createAccountData();
        insert acc;*/
        system.debug('accountdata'+accountdata);
        order odd =  QuickbooksTestDataFactory.orderCreate(accountdata.Id);
        insert odd;
        system.debug('odd=='+odd);
        /* order oddup = [select name,Id from order where Id =:odd.Id];
               oddup.SYS_Parent__c = '106';
               oddup.Quickbooks_Id__c ='96';
           update oddup;*/
        Product2 prod = QuickbooksTestDataFactory.productCreate();
        insert prod;
        PricebookEntry Proen =QuickbooksTestDataFactory.PricebookEntryCreate(prod.Id);
        insert Proen;
       
        OrderItem oddIt = QuickbooksTestDataFactory.OrderItemcreation(odd.Id,prod.Id,Proen.Id);
          insert oddIt;
        Test.stopTest();
        system.debug('oddIt='+oddIt); 
       list<OrderItem>oddItem = [select Quantity,UnitPrice,Product2id,OrderId,SYS_Parent__c from OrderItem];
        // OrderItemTriggerHandler.mapProductToOrderItem(oddItem);
        // OrderItemTriggerHandler.processBefore(oddItem);
        system.assertEquals(oddItem[0].SYS_Parent__c, '96');
		system.assertEquals(odd.SYS_Parent__c, '106');
    }
}