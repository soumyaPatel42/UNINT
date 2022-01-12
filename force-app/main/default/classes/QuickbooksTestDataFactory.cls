@isTest
public class QuickbooksTestDataFactory {
    
    //creating single account
    public static account createAccountData() {
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
        accountdata.ShippingStreet = 'Delaware';
        accountdata.ShippingCity = 'Corolla';
        accountdata.ShippingState ='NC';
        accountdata.ShippingPostalCode ='27927';
        accountdata.ShippingCountry = 'USA';
        accountdata.FirstName = 'Test1';
        accountdata.LastName =''+ (math.random() * 10);
        accountdata.Industry = 'Banking';
        accountdata.QB_isActive__c = true;
        return accountdata;
        
    }
    
    //update single account
    public static account UpDateAccountData(string accountId) {
        Account accountUpdate = [select Id, FirstName,LastName, Rating, Industry from Account where Id =: accountId];
        //accountUpdate.name = 'Testing';
        accountUpdate.FirstName = 'Testing';
        accountUpdate.LastName =''+ (math.random() * 10);
        accountUpdate.Industry = 'accountUpdate';
        return accountUpdate;
    }
    //Deactivating the active checkbox for single account
    public static account DeleteAccountData(string accountId) {
        Account accountRecord = [select FirstName,LastName, Id, Rating, industry from account where Id =: accountId];
        accountRecord.QB_isActive__c = false;
        return accountRecord;
        
    }
    //creating list of accounts
    public static list < account > BulkAccountInsert() {
        List < Account > acclist = new List < Account > ();
        for (Integer i = 0; i < 2; i++) {
            Account acc = new Account();
            //acc.name = 'ACC - 00' + i;
            acc.FirstName = 'ACC - 00';
            acc.LastName =''+ i;
            acc.Site = '1234';
            acc.BillingStreet = 'IN';
            acclist.add(acc);
        }
        return acclist;
        
    }
    //updating the list of accounts
    public static list < account > mokeupdateAccount() {
        list<Account> accList1 =[select FirstName,LastName,Id,Site,Description from account ];
        List < Account > acclist = new List < Account > ();
        for (account acc :accList1 ) {
            acc.Description = 'Testttting';
            acclist.add(acc);
        }
        return acclist;
    }
    //Deleting the accounts in quick books by deativating the check box
    public static list < account > mokeDeleteAccount() {
        list<Account> accList1 =[select QB_isActive__c from account ];
        List < Account > acclist = new List < Account > ();
        
        for (account acc :accList1 ) {
            acc.QB_isActive__c= false;
            acclist.add(acc);
        }
        return acclist;
        
    }
    //geting the account details 
    public static list < account > GetAccountList() {
        list < account > Accountdetails = [select FirstName,LastName, Rating, Industry, QB_isActive__c, Quickbooks_Id__c, QB_SyncToken__c from account];
        return Accountdetails;
    }
    //geting the account details 
    public static list < Account > GetQBAccountList() {
        list < Account > Accountdetails = [select FirstName,LastName, Rating, Industry, QB_isActive__c, Quickbooks_Id__c, QB_SyncToken__c from Account WHERE Quickbooks_Id__c != NULL];
        return Accountdetails;
    }
    public static list < account > GetAccountData(string accountId) {
        list < account > Accountdetails = [select FirstName,LastName, Rating, Industry, Quickbooks_Id__c, QB_SyncToken__c from account where id =: accountId];
        return Accountdetails;
    }
    
    //quering the sysintegration logs
    public static SYS_IntegrationLog__c getSyslog() {
        List < SYS_IntegrationLog__c > insertedLogs = [SELECT Name, Status__c, SYS_Http_Status__c, SYS_Operation_Type__c, SYS_RequestId__c, Type__c, WhatId__c, data0__c, data1__c, data2__c, data3__c, data4__c, data5__c, data6__c, data7__c, data8__c, data9__c FROM SYS_IntegrationLog__c];
        system.debug('syslog' + insertedLogs);
        
        return insertedLogs.size() > 0 ? insertedLogs[0] : new SYS_IntegrationLog__c();
    }
    
    //creating the single product
    public static Product2 productCreate() {
        Product2 productData = new Product2();
        productData.Name = 'Design';
        productData.ProductCode = 'GC1060';
        productData.Description = 'Custom Design2';
        productData.IsActive = true;
        productData.Type__c = 'Service';
        productData.Taxable__c = true;
        return productData;
        
    }
    
    //updating the single product
    public static Product2 productUpdate(string productId) {
        Product2 productUp = [select name, Id, Description from Product2 where Id =: productId];
        productUp.Description = 'p125';
        return productUp;
    }
    //product Deletion from QB by deactivating the active check box
    public static Product2 productDelete(string productId) {
        Product2 productDe = [select name, Id, Description from Product2 where Id =: productId];
        
        productDe.IsActive = false;
        return productDe;
    }
    //creation of pricebook entry with standerd price book
    public static PricebookEntry PricebookEntryCreate(string productId) {
        PricebookEntry pbe2 = new PricebookEntry(unitprice = 100, Product2Id = productId, Pricebook2Id = Test.getStandardPricebookId(),
                                                 isActive = true, UseStandardPrice = false);
        return pbe2;
    }
    //creating the list of products
    public static list < Product2 > productCreateList() {
        list < Product2 > productList = new list < Product2 > ();
        for (integer i = 0; i <=2; i++) {
            Product2 productData = new Product2();
            productData.Name = 'Design'+i;
            productData.ProductCode = 'GC1060'+i;
            productData.Purchase_Cost__c = 125;
            productData.Type__c ='Service';
            productData.Taxable__c = true;
            productData.Description = 'Custom Design2'+i;
            productData.IsActive = true;
            productList.add(productData);
            
        }
        return productList;
    }
    //updating the list of products
    public static list < Product2 > productmokeUpdate() {
        list < Product2 > productList = [select name, Id, description from product2];
        list < Product2 > prodList = new list < Product2 > ();
        
        for (Product2 pro: productList) {
            pro.Description = 'Custom';
            prodList.add(pro);
        }
        return prodList;
    }
    // list of product Deletion from QB by deactivating the active check box
    public static list < Product2 > product2mokeDelete() {
        list < Product2 > productList = [select name, Id, description from product2];
        list < Product2 > prodList = new list < Product2 > ();
        
        for (Product2 pro: productList) {
            pro.IsActive = false;
            pro.Description = 'testerrrrr';
            prodList.add(pro);
        }
        return prodList;
    }
   
    public static SBQQ__Quote__c Quotecreation2() {
        SBQQ__Quote__c quote = new SBQQ__Quote__c();
        if (Schema.sObjectType.SBQQ__Quote__c.fields.Quote_Name__c.isCreateable()) {
            quote.Quote_Name__c = 'QuoteTesting'+math.random() * 10;
        }
        if (Schema.sObjectType.SBQQ__Quote__c.fields.SBQQ__Status__c.isCreateable()) {
            quote.SBQQ__Status__c = 'Draft';
        }
        if (Schema.sObjectType.SBQQ__Quote__c.fields.SBQQ__ExpirationDate__c.isCreateable()) {
            quote.SBQQ__ExpirationDate__c = System.Today().addMonths(12);
        }
        if (Schema.sObjectType.SBQQ__Quote__c.fields.Expected_Close_Date__c.isCreateable()) {   
            quote.Expected_Close_Date__c = System.Today().addMonths(6);
        }
        if (Schema.sObjectType.SBQQ__Quote__c.fields.Description__c.isCreateable()) {
            quote.Description__c = 'Quote Test';
        }
        if (Schema.sObjectType.SBQQ__Quote__c.fields.Quickbooks_Id__c.isCreateable()) {
            quote.Quickbooks_Id__c ='93';
        }
        if (Schema.sObjectType.SBQQ__Quote__c.fields.Service_Location__c.isCreateable()) {
            quote.Service_Location__c = 'West Hollywood';
        }
        return quote;
    }
   
    public static SBQQ__QuoteLine__c Quotecreation2(string AccId,string oppId,string prodId, string priceId) {
        
        
        SBQQ__Quote__c quote = new SBQQ__Quote__c();
        if (Schema.sObjectType.SBQQ__Quote__c.fields.Quote_Name__c.isCreateable()) {
            quote.Quote_Name__c = 'QuoteTesting'+math.random() * 10;
        }
        if (Schema.sObjectType.SBQQ__Quote__c.fields.SBQQ__Status__c.isCreateable()) {
            quote.SBQQ__Status__c = 'Draft';
        }
        if (Schema.sObjectType.SBQQ__Quote__c.fields.SBQQ__ExpirationDate__c.isCreateable()) {
            quote.SBQQ__ExpirationDate__c = System.Today().addMonths(12);
        }
        if (Schema.sObjectType.SBQQ__Quote__c.fields.Expected_Close_Date__c.isCreateable()) {
            quote.Expected_Close_Date__c = System.Today().addMonths(6);
        }
        if (Schema.sObjectType.SBQQ__Quote__c.fields.Description__c.isCreateable()) {
            quote.Description__c = 'Quote Test';
        }
        if (Schema.sObjectType.SBQQ__Quote__c.fields.Quote_Name__c.isCreateable()) {
            quote.Service_Location__c = 'West Hollywood';
        }
        if (Schema.sObjectType.SBQQ__Quote__c.fields.SBQQ__Account__c.isCreateable()) {
            quote.SBQQ__Account__c = AccId;
        }
        if (Schema.sObjectType.SBQQ__Quote__c.fields.Treatment_Plan_Opportunities__c.isCreateable()) {
            quote.Treatment_Plan_Opportunities__c = oppId;
        }
        insert quote;
        SBQQ__QuoteLine__c quoteline = new SBQQ__QuoteLine__c();
        quoteline.SBQQ__Quote__c = quote.Id;
        quoteline.SBQQ__Product__c = prodId;
        quoteline.SBQQ__PricebookEntryId__c = priceId;
        quoteline.SBQQ__Quantity__c = 20;
        // quoteline.Service_Date__c = system.today();
        return quoteline;
    }

    //creation of QuotelineItem
    
    
    public static SBQQ__QuoteLine__c quotelinecreation(string quoteId,string prodId,string priceId){
        SBQQ__QuoteLine__c quoteline = new SBQQ__QuoteLine__c();
        quoteline.SBQQ__Quote__c = quoteId;
        quoteline.SBQQ__Product__c = prodId;
        quoteline.SBQQ__PricebookEntryId__c = priceId;
        quoteline.SBQQ__Quantity__c = 20;
        // quoteline.Service_Date__c = system.today();
        return quoteline;
        
    }
    
    
    //order senarios======
    //creation of order object
    /*
     * 
    public static order orderCreate(string accId) {
        Order order = new Order();
        order.AccountId = accId;
        order.EffectiveDate = System.today();
        order.Status = 'Draft'; 
        order.Type =	'Shopify';
        //order.SYS_Parent__c = '106';
        order.Quickbooks_Id__c = '96';
        order.PriceBook2Id = Test.getStandardPricebookId();
        
        
        return order;
    }
    //creation of orderlineItem===
    public static OrderItem OrderItemcreation(string ordId, string proId, string proEntryId) {
        OrderItem lineItem = new OrderItem();
        lineItem.OrderId = ordId;
        lineItem.Quantity = 24;
        lineItem.UnitPrice = 240;
        lineItem.Product2id = proId;
        lineItem.PricebookEntryId = proEntryId;
        //lineItem.SYS_Parent__c = '96';
        return lineItem;
    }
	*/
    
}