@isTest
public class CPQTestDataFactory {
    public static Map < Id, String > createData() {
        List < PricebookEntry > listPriceEntry = new List < PricebookEntry > ();
        List < Account > acc = createAccounts(1, true);
        Id accId= (acc.size() >0 ) ? acc[0].Id : null ;
        List < Opportunity > opp = createOpportunitys( accId , 1, true);
        //Opportunity oppdata = getOpportunitywithAccount();
        Product2 addprod1 = createProduct('PRP 22ml + ACELL', 'BD00125', true, false);
        Product2 addprod2 = createProduct('PRP - 22mL', '1834', true, false);
        Product2 addprod3 = createProduct('ACell - Add-on', '1637', true, false);
        Product2 addprod4 = createProduct('Gift Certificate', '1986', true, false);
        insert addprod1;
        insert addprod2;
        insert addprod3;
        insert addprod4;
        List < Product2 > insertedProducts =  getProducts();
        System.debug('inserted Products ' + insertedProducts);
        PricebookEntry priceentry1 = createPriceBookEntry(addprod1.Id, 1692.50, false);
        PricebookEntry priceentry2 = createPriceBookEntry(addprod2.Id, 1192.50, false);
        PricebookEntry priceentry3 = createPriceBookEntry(addprod3.Id, 500, false);
        PricebookEntry priceentry4 = createPriceBookEntry(addprod4.Id, 0, false);
        listPriceEntry.add(priceentry1);
        listPriceEntry.add(priceentry2);
        listPriceEntry.add(priceentry3);
        listPriceEntry.add(priceentry4);
        insert listPriceEntry;
        List < Product2 > listprobwithprice =  getProductswithPrice();
        System.debug('inserted Products listprobwithprice ' + listprobwithprice);
        SBQQ__ProductOption__c addProdOptions = createProductOptions(addprod1.Id, addprod2.Id,
        10, 1, 0, true );
        system.debug('addProdOptions=='+addProdOptions);
        SBQQ__ProductOption__c addProdOptions1 = createProductOptions(addprod1.Id, addprod3.Id,
        20, 1, 0, true );
        SBQQ__ProductOption__c addProdOptions2 = createProductOptions(addprod1.Id, addprod4.Id,
        30, 1, 0, true );
        Map < Id, String > prodIdMap= new Map < Id, String >();
        prodIdMap.put(addprod1.Id,addprod1.Name);
        prodIdMap.put(addprod2.Id,addprod2.Name);
        prodIdMap.put(addprod3.Id,addprod3.Name);
        prodIdMap.put(addprod4.Id,addprod4.Name);
        List < SBQQ__ProductOption__c > prodoptionsdata = getProductOptions(addprod1.Id);
        System.debug('Inserted prodoptionsdata' + prodoptionsdata);
        return prodIdMap;
    }
    public static List < Account > createAccounts(Integer total, Boolean doInsert) {
        // Insert List Accounts
        List < Account > accList = new List < Account > ();
        String paRecordTypeID = Schema.SObjectType.Account.getRecordTypeInfosByName().get('Person Account').getRecordTypeId();
        for (Integer cnum=0; cnum< total ; cnum++) {
            Account acc = new Account();
            acc.RecordTypeId = paRecordTypeID;
            acc.Type = 'Patient';
            //acc.Name = 'CPQ Account ' + cnum;
            acc.LastName = 'Patient Account ' + cnum;
            acc.FirstName = 'CPQ';
            acc.BillingStreet = 'California 1';
            acc.BillingCity = 'Long Beach';
            acc.BillingPostalCode = '20001';
            acc.BillingState = 'CA';
            acc.BillingCountry = 'United States';
            acc.ShippingStreet = 'California 1';
            acc.ShippingCity = 'Long Beach';
            acc.ShippingPostalCode = '20001';
            acc.ShippingState = 'CA';
            acc.ShippingCountry = 'United States';
            acc.PersonEmail = 'dev@salesforce.com';
            acc.Phone = '9999999999';
            accList.add(acc);
        }
        if (doInsert) {
            insert accList;
        }
        return accList;
    }
    public static List < Opportunity > createOpportunitys(Id accId , Integer total, Boolean doInsert) {
        // Create List of Opportunitys
        List < Opportunity > oppList = new List < Opportunity > ();
        for (Integer cnum=0; cnum< total ; cnum++) {
            Opportunity opp = new Opportunity();
            opp.AccountId = accId;
            opp.Name = 'CPQ Opportunity ' + cnum;
            opp.CloseDate = System.Today().addMonths(12);
            opp.StageName = 'Prospecting';
            opp.Pricebook2Id = Test.getStandardPricebookId();
            oppList.add(opp);
        }
        if (doInsert) {
            insert oppList;
        }
        return oppList;
    }
    
    public static PricebookEntry createPriceBookEntry(Id productId, Decimal price, Boolean doInsert) {
        // insert pricebook entry for the product
        PricebookEntry priceEntry = new PricebookEntry();
        priceEntry.Pricebook2Id = Test.getStandardPricebookId();
        priceEntry.Product2Id = productId;
        priceEntry.UnitPrice = price;
        priceEntry.IsActive = true;
        priceEntry.UseStandardPrice = false;
        if (doInsert) {
            insert priceEntry;
        }
        return priceEntry;
    }
    public static Product2 createProduct(String name, String prodCode, Boolean isTaxable, Boolean doInsert) {
        Product2 product = new Product2();
        product.Name = name;
        product.Description = name;
        product.ProductCode = prodCode;
        //product.Family = prodFamily;
        product.Taxable__c = isTaxable;
        product.IsActive = true;
        if (doInsert) {
            insert product;
        }
        return product;
    }
    public static SBQQ__ProductOption__c createProductOptions(Id bundleId, Id prodId, Integer sortnumber, Integer quantity, Decimal discountpercent, Boolean doInsert) {
        SBQQ__ProductOption__c prodOption = new SBQQ__ProductOption__c ();
        prodOption.SBQQ__Bundled__c = true;
        prodOption.SBQQ__ConfiguredSKU__c = bundleId; //Contains Bundle|Parent Product Id
        prodOption.SBQQ__OptionalSKU__c = prodId; //Contains Bundle Option Product Id
        prodOption.SBQQ__Number__c = sortnumber; //multiples of 10 for sequence order
        prodOption.SBQQ__Quantity__c = quantity;
        prodOption.SBQQ__Discount__c = discountpercent;
        //prodOption.SBQQ__DiscountAmount__c = quantity;
        //prodOption.SBQQ__Required__c = true;
        //prodOption.SBQQ__UnitPrice__c = 12345;
        //prodOption.SBQQ__MinQuantity__c = 1;
        //prodOption.SBQQ__MaxQuantity__c = 10;
        //prodOption.SBQQ__QuantityEditable__c = true;
        if (doInsert) {
            insert prodOption;
        }
        return prodOption;

    }

    public static SBQQ__Quote__c createQuote(Id accountId, Id opportunityId, String quoteName, String description, String serviceLocation) {
        SBQQ__Quote__c quote = new SBQQ__Quote__c();
        quote.Quote_Name__c = quoteName;
        quote.SBQQ__ExpirationDate__c = System.Today().addMonths(12);
        quote.Expected_Close_Date__c = System.Today().addMonths(6);
        quote.Description__c = description;
        quote.Service_Location__c = serviceLocation;
        quote.SBQQ__Account__c = accountId;
        quote.Treatment_Plan_Opportunities__c = opportunityId;
        Opportunity opp = getOpportunitywithAccount();
        if (opp != null) {
            quote.ContactId__c = opp.Patient_Contact_Id__c;
            quote.SBQQ__BillingStreet__c = opp.Account.BillingStreet;
            quote.SBQQ__BillingCity__c = opp.Account.BillingCity;
            quote.SBQQ__BillingState__c = opp.Account.BillingState;
            quote.SBQQ__BillingPostalCode__c = opp.Account.BillingPostalCode;
            quote.SBQQ__BillingCountry__c = opp.Account.BillingCountry;

            quote.SBQQ__ShippingStreet__c = opp.Account.ShippingStreet;
            quote.SBQQ__ShippingCity__c = opp.Account.ShippingCity;
            quote.SBQQ__ShippingState__c = opp.Account.ShippingState;
            quote.SBQQ__ShippingPostalCode__c = opp.Account.ShippingPostalCode;
            quote.SBQQ__ShippingCountry__c = opp.Account.ShippingCountry;

            quote.Email__c = opp.Account.PersonEmail;
            quote.Phone__c = opp.Account.Phone;
        }
        insert quote;
        return quote;
    }

    public static SBQQ__QuoteLine__C createQuoteLine(Id quoteId, Id productId, PricebookEntry priceEntry, Integer quantity) {
        SBQQ__QuoteLine__C line = new SBQQ__QuoteLine__C(
            SBQQ__Product__c = productId,
            SBQQ__Quote__c = quoteId,
            SBQQ__PricebookEntryId__c = priceEntry.Id,
            SBQQ__Quantity__c = quantity
        );

        insert line;
        return line;
    }
    //Get Data
    public static Opportunity getOpportunitywithAccount() {
        List < Opportunity > opp = [SELECT Id, Patient_Contact_Id__c, Account.Id, Account.BillingCity, Account.BillingCountry, Account.BillingPostalCode,
            Account.BillingState, Account.BillingStreet, Account.ShippingCity, Account.ShippingCountry, Account.ShippingPostalCode,
            Account.ShippingState, Account.ShippingStreet, Account.PersonEmail, Account.Phone
            FROM Opportunity
        ];
        return (opp.size() > 0) ? opp[0] : new Opportunity();
    }
    public static List < Product2 >  getProducts() {
        List < Product2 > products = [SELECT Id, Name, Description, ProductCode , Family , Taxable__c , IsActive  From Product2];
        return products;
    }

    public static List < Product2 >  getProductswithPrice() {
        List < Product2 > products = [SELECT Id, Name, Description, ProductCode, Taxable__c ,(SELECT Id FROM SBQQ__Options__r),
        (SELECT Id, UnitPrice FROM PricebookEntries order by createddate DESC LIMIT 1 ) FROM product2 WHERE IsActive = true];
        return products;
    }
    public static Product2  getSingleProductwithPrice(String prodName) {
        List < Product2 > products = [SELECT Id, Name, Description, ProductCode, Taxable__c ,(SELECT Id FROM SBQQ__Options__r),
        (SELECT Id, UnitPrice FROM PricebookEntries order by createddate DESC LIMIT 1 ) FROM product2 WHERE Name =: prodName AND IsActive = true];
        return (products.size() > 0) ? products[0] : new Product2();
    }
    public static SBQQ__ProductOption__c  getSingleProductOption(Id prodId) {
        List<SBQQ__ProductOption__c> prodOptList = [SELECT Id, SBQQ__ConfiguredSKU__c, SBQQ__OptionalSKU__c,SBQQ__OptionalSKU__r.Name,SBQQ__OptionalSKU__r.Taxable__c, 
                                                SBQQ__OptionalSKU__r.Description, SBQQ__OptionalSKU__r.ProductCode 
                                                FROM SBQQ__ProductOption__c WHERE SBQQ__ConfiguredSKU__c =: prodId];
        return (prodOptList.size() > 0) ? prodOptList[0] : new SBQQ__ProductOption__c();                                       
    }
    public static List < SBQQ__ProductOption__c >  getProductOptions(Id prodId) {
        List<SBQQ__ProductOption__c> prodOptList = [SELECT Id, SBQQ__ConfiguredSKU__c, SBQQ__OptionalSKU__c,SBQQ__OptionalSKU__r.Name,SBQQ__OptionalSKU__r.Taxable__c, 
                                                SBQQ__OptionalSKU__r.Description, SBQQ__OptionalSKU__r.ProductCode 
                                                FROM SBQQ__ProductOption__c WHERE SBQQ__ConfiguredSKU__c =: prodId];
        return prodOptList;                                        
    }
	public static List< SBQQ__QuoteLine__c >  getQuoteLines() {
        List<SBQQ__QuoteLine__c> quoteLines = [Select Id,Name, SBQQ__Quantity__c, SBQQ__Product__r.name, SBQQ__ProductOption__r.SBQQ__Feature__r.SBQQ__Category__c from SBQQ__QuoteLine__c];
        return quoteLines;                                       
    }
    public static SBQQ__QuoteLine__c  getQuoteLineByName(Id prodId) {
        List<SBQQ__QuoteLine__c> quoteLines = [Select Id,Name, SBQQ__Quantity__c, SBQQ__Product__r.name, SBQQ__ProductOption__r.SBQQ__Feature__r.SBQQ__Category__c from SBQQ__QuoteLine__c WHERE SBQQ__Product__c =: prodId];
        return (quoteLines.size() > 0) ? quoteLines[0] : new SBQQ__QuoteLine__c();                                       
    }
}