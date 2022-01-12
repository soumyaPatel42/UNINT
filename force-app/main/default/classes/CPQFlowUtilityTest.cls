@isTest
public class CPQFlowUtilityTest {
    @isTest static void checkGetProductList() {
        Test.startTest();
        String resJson = '{"Customer":{"Taxable":true,"BillAddr":{"Id":"356","Line1":"California 1","City":"Long Beach","Country":"United States","CountrySubDivisionCode":"CA","PostalCode":"20001"},"Job":false,"BillWithParent":false,"Balance":0,"BalanceWithJobs":0,"CurrencyRef":{"value":"USD","name":"United States Dollar"},"PreferredDeliveryMethod":"Print","IsProject":false,"domain":"QBO","sparse":false,"Id":"125","SyncToken":"0","MetaData":{"CreateTime":"2021-10-28T09:19:30-07:00","LastUpdatedTime":"2021-10-28T09:19:30-07:00"},"GivenName":"CPQ","FamilyName":"Patient Account 0","FullyQualifiedName":"CPQ Patient Account 0","DisplayName":"CPQ Patient Account 0","PrintOnCheckName":"CPQ Patient Account 0","Active":true,"PrimaryPhone":{"FreeFormNumber":"+19999999999"},"PrimaryEmailAddr":{"Address":"dev@salesforce.com"},"DefaultTaxCodeRef":{"value":"2"}},"time":"2021-10-28T09:19:48.162-07:00"}';
        Map < String, String > responseHeaders = new Map < String, String > ();
		responseHeaders.put('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, new QuickBookCalloutMock(200, 'OK', resJson, responseHeaders));
        Map < Id, String > prodIdMap = CPQTestDataFactory.createData();
        Product2 getSelectedprod =  CPQTestDataFactory.getSingleProductwithPrice('PRP - 22mL');
        //Get Actual Data
        Product2 getResultprod =  CPQTestDataFactory.getSingleProductwithPrice('PRP 22ml + ACELL');
        
        List < SBQQ__ProductOption__c > prodoptionsdata = CPQTestDataFactory.getProductOptions(getResultprod.Id);
        System.debug('Inserted prodoptionsdata' + prodoptionsdata);

        String key = 'PRP';
        List<String> selectedProduct = new List<String>();
        selectedProduct.add(getSelectedprod.Id);
        System.debug('selectedProduct ' + selectedProduct); 

        List < Product2 > np = CPQFlowUtility.getProductList(key, selectedProduct);
        String prodId= (np.size() > 0 ) ? np[0].Id : '' ;
        
        Test.stopTest();

        System.debug('np is=' + np);
        System.assertNotEquals(0 , np.size(), 'Successfully Fetched Product List');
        System.assertEquals(getResultprod.Id, prodId, 'Successfully Fetched Product List');
        //System.assertEquals(getResultprod[0].Id,np[0].Id, 'Successfully Fetched Product List');
    }
    @isTest static void checkQuoteBundleDeletion() {
        Test.startTest();
        String resJson = '{"Customer":{"Taxable":true,"BillAddr":{"Id":"356","Line1":"California 1","City":"Long Beach","Country":"United States","CountrySubDivisionCode":"CA","PostalCode":"20001"},"Job":false,"BillWithParent":false,"Balance":0,"BalanceWithJobs":0,"CurrencyRef":{"value":"USD","name":"United States Dollar"},"PreferredDeliveryMethod":"Print","IsProject":false,"domain":"QBO","sparse":false,"Id":"125","SyncToken":"0","MetaData":{"CreateTime":"2021-10-28T09:19:30-07:00","LastUpdatedTime":"2021-10-28T09:19:30-07:00"},"GivenName":"CPQ","FamilyName":"Patient Account 0","FullyQualifiedName":"CPQ Patient Account 0","DisplayName":"CPQ Patient Account 0","PrintOnCheckName":"CPQ Patient Account 0","Active":true,"PrimaryPhone":{"FreeFormNumber":"+19999999999"},"PrimaryEmailAddr":{"Address":"dev@salesforce.com"},"DefaultTaxCodeRef":{"value":"2"}},"time":"2021-10-28T09:19:48.162-07:00"}';
        Map < String, String > responseHeaders = new Map < String, String > ();
		responseHeaders.put('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, new QuickBookCalloutMock(200, 'OK', resJson, responseHeaders));
        Map < Id, String > prodIdMap = CPQTestDataFactory.createData();
        Product2 prod1 =  CPQTestDataFactory.getSingleProductwithPrice('PRP - 22mL');
        Product2 prod2 =  CPQTestDataFactory.getSingleProductwithPrice('ACell - Add-on');
        Product2 prod3 =  CPQTestDataFactory.getSingleProductwithPrice('Gift Certificate');
        //Get Actual Data
        system.debug('products::'+prod1+''+prod2+''+prod3);
        Product2 bundleprod =  CPQTestDataFactory.getSingleProductwithPrice('PRP 22ml + ACELL');

        SBQQ__ProductOption__c prodoption1 = CPQTestDataFactory.getSingleProductOption(prod1.Id);
        SBQQ__ProductOption__c prodoption2 = CPQTestDataFactory.getSingleProductOption(prod2.Id);
        SBQQ__ProductOption__c prodoption3 = CPQTestDataFactory.getSingleProductOption(prod3.Id);

        List < SBQQ__ProductOption__c > prodoptionsdata = CPQTestDataFactory.getProductOptions(bundleprod.Id);
        Opportunity oppdata = CPQTestDataFactory.getOpportunitywithAccount();
        system.debug('productopp::::'+prodoption1+''+prodoption2+''+prodoption3);
        system.debug('productbundle::::'+bundleprod);

		System.debug('oppdata '+oppdata);
        String quote = '{"quoteName":"Adisols Test Cls","selectedLocation":"West Hollywood","quoteDescription":"Test Cls","closeDate":"2021-10-08","expiryDate":"2021-12-07","OpportunityId":"'+ oppdata.Id +'","accountId":"'+ oppdata.Account.Id +'","totalPrice":0}';
        //String quoteLine = '[{"finalProdPrice":"1692.50","maxPercentageVal":"1692.50","options":[{"prodDicountReason":true,"prodOptDescriptions":"PRP - 22mL","prodOptDiscount":"0","prodOptId":"01t6A000003m9XYQAY","prodOptlistPrice":"1192.50","prodOptName":"PRP - 22mL","prodOptQuantity":"1","prodOptServiceDate":"2021-09-07","prodOptTaxable":false,"realId":"a4k2C000000MWsWQAW"},{"prodDicountReason":true,"prodOptDescriptions":"A Cell Add-on","prodOptDiscount":"0","prodOptId":"01t6A000000wUe9QAE","prodOptlistPrice":"500.00","prodOptName":"ACell - Add-on","prodOptQuantity":"1","prodOptServiceDate":"2021-09-07","prodOptTaxable":false,"realId":"a4k2C000000MWsbQAG"},{"prodDicountReason":true,"prodOptDiscount":"0","prodOptId":"01t3u000004wjXYAAY","prodOptlistPrice":"0.00","prodOptName":"Gift Certificate","prodOptQuantity":"1","prodOptServiceDate":"2021-09-07","prodOptTaxable":false,"realId":"a4k2C000000MWsgQAG"}],"prodDicountReason":true,"prodDiscount":"0","prodDiscountgeneric":0,"prodDiscountType":"USD","prodId":"01t2C000002n1MHQAY","prodlistPrice":"1692.50","prodName":"PRP 22ml + ACELL","prodQuantity":"1","prodServiceDate":"2021-09-07","prodTaxable":true,"productIcon":"standard:bundle_config","productType":"bundle","prodDescription":"Test","prodBillingProvider":"Dr. Emer"},{"finalProdPrice":"7000.00","maxPercentageVal":"7000.00","options":[{"prodDicountReason":true,"prodOptDiscount":"0","prodOptId":"01t3u000004wjXKAAY","prodOptlistPrice":"1500.00","prodOptName":"Halo Laser","prodOptQuantity":"1","prodOptServiceDate":"2021-09-07","prodOptTaxable":false,"realId":"a4k2C000000MWRzQAO"},{"prodDicountReason":true,"prodOptDescriptions":"Microneedling","prodOptDiscount":"0","prodOptId":"01t6A000000Gc4BQAS","prodOptlistPrice":"500.00","prodOptName":"Microneedling","prodOptQuantity":"1","prodOptServiceDate":"2021-09-07","prodOptTaxable":false,"realId":"a4k2C000000MWRpQAO"},{"prodDicountReason":true,"prodOptDescriptions":"PRP -11ml","prodOptDiscount":"0","prodOptId":"01t3u000004wjWvAAI","prodOptlistPrice":"795.00","prodOptName":"PRP -11ml","prodOptQuantity":"1","prodOptServiceDate":"2021-09-07","prodOptTaxable":false,"realId":"a4k2C000000MWRuQAO"},{"prodDicountReason":true,"prodOptDiscount":"0","prodOptId":"01t3u000004wjXLAAY","prodOptlistPrice":"3500.00","prodOptName":"Halo Laser / Pro-Fractional Full-Face","prodOptQuantity":"1","prodOptServiceDate":"2021-09-07","prodOptTaxable":false,"realId":"a4k2C000000MWS4QAO"},{"prodDicountReason":true,"prodOptDescriptions":"Clear and Brilliant - Touch","prodOptDiscount":"0","prodOptId":"01t3u000007ff4RAAQ","prodOptlistPrice":"0.00","prodOptName":"Clear and Brilliant - Touch","prodOptQuantity":"1","prodOptServiceDate":"2021-09-07","prodOptTaxable":false,"realId":"a4k2C000000MWRkQAO"}],"prodDescription":"Laser Treatment Package","prodDicountReason":true,"prodDiscount":"0","prodDiscountgeneric":0,"prodDiscountType":"USD","prodId":"01t2C000002VnEhQAK","prodlistPrice":"7000.00","prodName":"Laser Package","prodQuantity":"1","prodServiceDate":"2021-09-07","prodTaxable":false,"productIcon":"standard:bundle_config","productType":"bundle","prodBillingProvider":"Dr. Bruno"},{"finalProdPrice":"550.00","maxPercentageVal":"550.00","options":[],"prodDescription":"4 in 1 Facial Serum","prodDicountReason":true,"prodDiscount":"0","prodDiscountgeneric":0,"prodDiscountType":"USD","prodId":"01t6A000000Gc8rQAC","prodlistPrice":"550.00","prodName":"4 in 1 Facial Serum","prodQuantity":"1","prodServiceDate":"2021-09-07","prodTaxable":true,"productIcon":"standard:case","productType":"product","prodBillingProvider":"Dr. Tsai"}]';
        String quoteLine ='[{"finalProdPrice":"1692.50","maxPercentageVal":"1692.50","options":[{"prodDicountReason":true,"prodOptDescriptions":"'+prod1.Name+'","prodOptDiscount":"0","prodOptId":"'+prod1.Id+'","prodOptlistPrice":"1192.50","prodOptName":"'+prod1.Name+'","prodOptQuantity":"1","prodOptServiceDate":"2021-09-07","prodOptTaxable":false,"realId":"'+prodoption1.Id+'"},{"prodDicountReason":true,"prodOptDescriptions":"A Cell Add-on","prodOptDiscount":"0","prodOptId":"'+prod2.Id+'","prodOptlistPrice":"500.00","prodOptName":"'+prod2.Name+'","prodOptQuantity":"1","prodOptServiceDate":"2021-09-07","prodOptTaxable":false,"realId":"'+prodoption2.Id+'"},{"prodDicountReason":true,"prodOptDiscount":"0","prodOptId":"'+prod3.Id+'","prodOptlistPrice":"0.00","prodOptName":"'+prod3.Name+'","prodOptQuantity":"1","prodOptServiceDate":"2021-09-07","prodOptTaxable":false,"realId":"'+prodoption3.Id+'"}],"prodDicountReason":true,"prodDiscount":"0","prodDiscountgeneric":0,"prodDiscountType":"USD","prodId":"'+bundleprod.Id+'","prodlistPrice":"1692.50","prodName":"'+bundleprod.Name+'","prodQuantity":"1","prodServiceDate":"2021-09-07","prodTaxable":true,"productIcon":"standard:bundle_config","productType":"bundle","prodDescription":"Test","prodBillingProvider":"Dr. Emer"}]';
        List<CPQFlowUtility.QuoteWrapper> cq = CPQFlowUtility.createQuote( quote, quoteLine);
        Test.stopTest();
        List< SBQQ__QuoteLine__c >  quoteLines = CPQTestDataFactory.getQuoteLines();
        SBQQ__QuoteLine__c  bundleQuoteLine = CPQTestDataFactory.getQuoteLineByName(bundleprod.Id);
        System.debug('bundleQuoteLine' + bundleQuoteLine);
        delete bundleQuoteLine;
        List< SBQQ__QuoteLine__c >  quoteLinesafterDelete = CPQTestDataFactory.getQuoteLines();
        System.debug('quoteLinesafterDelete' + quoteLinesafterDelete);

        System.assertNotEquals(quoteLines.size(),quoteLinesafterDelete.size(), 'Successfully Deleted Bundle');
    }
    @isTest static void checkGetProductDetails() {
        Test.startTest();
        String resJson = '{"Customer":{"Taxable":true,"BillAddr":{"Id":"356","Line1":"California 1","City":"Long Beach","Country":"United States","CountrySubDivisionCode":"CA","PostalCode":"20001"},"Job":false,"BillWithParent":false,"Balance":0,"BalanceWithJobs":0,"CurrencyRef":{"value":"USD","name":"United States Dollar"},"PreferredDeliveryMethod":"Print","IsProject":false,"domain":"QBO","sparse":false,"Id":"125","SyncToken":"0","MetaData":{"CreateTime":"2021-10-28T09:19:30-07:00","LastUpdatedTime":"2021-10-28T09:19:30-07:00"},"GivenName":"CPQ","FamilyName":"Patient Account 0","FullyQualifiedName":"CPQ Patient Account 0","DisplayName":"CPQ Patient Account 0","PrintOnCheckName":"CPQ Patient Account 0","Active":true,"PrimaryPhone":{"FreeFormNumber":"+19999999999"},"PrimaryEmailAddr":{"Address":"dev@salesforce.com"},"DefaultTaxCodeRef":{"value":"2"}},"time":"2021-10-28T09:19:48.162-07:00"}';
        Map < String, String > responseHeaders = new Map < String, String > ();
		responseHeaders.put('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, new QuickBookCalloutMock(200, 'OK', resJson, responseHeaders));
        Map < Id, String > prodIdMap = CPQTestDataFactory.createData();
        Product2 sampleProd =  CPQTestDataFactory.getSingleProductwithPrice('PRP 22ml + ACELL');
        String prodId = sampleProd.Id;
        List<CPQFlowUtility.ProductWrapper> pd = CPQFlowUtility.getProductDetails(prodId);
        String prodName= (pd.size() > 0 ) ? pd[0].prodName : '' ;
        Test.stopTest();
        System.debug('pd is='+ pd);
        System.assertEquals('PRP 22ml + ACELL',prodName, 'Successfully Feteched Product Details');
        //System.assertEquals('PRP 22ml + ACELL',pd[0].prodName, 'Successfully Feteched Product Details');
    }
    @isTest static void checkCreateQuote() {
        Test.startTest();
        String resJson = '{"Customer":{"Taxable":true,"BillAddr":{"Id":"356","Line1":"California 1","City":"Long Beach","Country":"United States","CountrySubDivisionCode":"CA","PostalCode":"20001"},"Job":false,"BillWithParent":false,"Balance":0,"BalanceWithJobs":0,"CurrencyRef":{"value":"USD","name":"United States Dollar"},"PreferredDeliveryMethod":"Print","IsProject":false,"domain":"QBO","sparse":false,"Id":"125","SyncToken":"0","MetaData":{"CreateTime":"2021-10-28T09:19:30-07:00","LastUpdatedTime":"2021-10-28T09:19:30-07:00"},"GivenName":"CPQ","FamilyName":"Patient Account 0","FullyQualifiedName":"CPQ Patient Account 0","DisplayName":"CPQ Patient Account 0","PrintOnCheckName":"CPQ Patient Account 0","Active":true,"PrimaryPhone":{"FreeFormNumber":"+19999999999"},"PrimaryEmailAddr":{"Address":"dev@salesforce.com"},"DefaultTaxCodeRef":{"value":"2"}},"time":"2021-10-28T09:19:48.162-07:00"}';
        Map < String, String > responseHeaders = new Map < String, String > ();
		responseHeaders.put('Content-Type', 'application/json');
        Test.setMock(HttpCalloutMock.class, new QuickBookCalloutMock(200, 'OK', resJson, responseHeaders));
        Map < Id, String > prodIdMap = CPQTestDataFactory.createData();
        Product2 prod1 =  CPQTestDataFactory.getSingleProductwithPrice('PRP - 22mL');
        Product2 prod2 =  CPQTestDataFactory.getSingleProductwithPrice('ACell - Add-on');
        Product2 prod3 =  CPQTestDataFactory.getSingleProductwithPrice('Gift Certificate');
        //Get Actual Data
        system.debug('products::'+prod1+''+prod2+''+prod3);
        Product2 bundleprod =  CPQTestDataFactory.getSingleProductwithPrice('PRP 22ml + ACELL');

        SBQQ__ProductOption__c prodoption1 = CPQTestDataFactory.getSingleProductOption(prod1.Id);
        SBQQ__ProductOption__c prodoption2 = CPQTestDataFactory.getSingleProductOption(prod2.Id);
        SBQQ__ProductOption__c prodoption3 = CPQTestDataFactory.getSingleProductOption(prod3.Id);

        List < SBQQ__ProductOption__c > prodoptionsdata = CPQTestDataFactory.getProductOptions(bundleprod.Id);
        Opportunity oppdata = CPQTestDataFactory.getOpportunitywithAccount();
        system.debug('productopp::::'+prodoption1+''+prodoption2+''+prodoption3);
        system.debug('productbundle::::'+bundleprod);

		System.debug('oppdata '+oppdata);
        String quote = '{"quoteName":"Adisols Test Cls","selectedLocation":"West Hollywood","quoteDescription":"Test Cls","closeDate":"2021-10-08","expiryDate":"2021-12-07","OpportunityId":"'+ oppdata.Id +'","accountId":"'+ oppdata.Account.Id +'","totalPrice":0}';
        //String quoteLine = '[{"finalProdPrice":"1692.50","maxPercentageVal":"1692.50","options":[{"prodDicountReason":true,"prodOptDescriptions":"PRP - 22mL","prodOptDiscount":"0","prodOptId":"01t6A000003m9XYQAY","prodOptlistPrice":"1192.50","prodOptName":"PRP - 22mL","prodOptQuantity":"1","prodOptServiceDate":"2021-09-07","prodOptTaxable":false,"realId":"a4k2C000000MWsWQAW"},{"prodDicountReason":true,"prodOptDescriptions":"A Cell Add-on","prodOptDiscount":"0","prodOptId":"01t6A000000wUe9QAE","prodOptlistPrice":"500.00","prodOptName":"ACell - Add-on","prodOptQuantity":"1","prodOptServiceDate":"2021-09-07","prodOptTaxable":false,"realId":"a4k2C000000MWsbQAG"},{"prodDicountReason":true,"prodOptDiscount":"0","prodOptId":"01t3u000004wjXYAAY","prodOptlistPrice":"0.00","prodOptName":"Gift Certificate","prodOptQuantity":"1","prodOptServiceDate":"2021-09-07","prodOptTaxable":false,"realId":"a4k2C000000MWsgQAG"}],"prodDicountReason":true,"prodDiscount":"0","prodDiscountgeneric":0,"prodDiscountType":"USD","prodId":"01t2C000002n1MHQAY","prodlistPrice":"1692.50","prodName":"PRP 22ml + ACELL","prodQuantity":"1","prodServiceDate":"2021-09-07","prodTaxable":true,"productIcon":"standard:bundle_config","productType":"bundle","prodDescription":"Test","prodBillingProvider":"Dr. Emer"},{"finalProdPrice":"7000.00","maxPercentageVal":"7000.00","options":[{"prodDicountReason":true,"prodOptDiscount":"0","prodOptId":"01t3u000004wjXKAAY","prodOptlistPrice":"1500.00","prodOptName":"Halo Laser","prodOptQuantity":"1","prodOptServiceDate":"2021-09-07","prodOptTaxable":false,"realId":"a4k2C000000MWRzQAO"},{"prodDicountReason":true,"prodOptDescriptions":"Microneedling","prodOptDiscount":"0","prodOptId":"01t6A000000Gc4BQAS","prodOptlistPrice":"500.00","prodOptName":"Microneedling","prodOptQuantity":"1","prodOptServiceDate":"2021-09-07","prodOptTaxable":false,"realId":"a4k2C000000MWRpQAO"},{"prodDicountReason":true,"prodOptDescriptions":"PRP -11ml","prodOptDiscount":"0","prodOptId":"01t3u000004wjWvAAI","prodOptlistPrice":"795.00","prodOptName":"PRP -11ml","prodOptQuantity":"1","prodOptServiceDate":"2021-09-07","prodOptTaxable":false,"realId":"a4k2C000000MWRuQAO"},{"prodDicountReason":true,"prodOptDiscount":"0","prodOptId":"01t3u000004wjXLAAY","prodOptlistPrice":"3500.00","prodOptName":"Halo Laser / Pro-Fractional Full-Face","prodOptQuantity":"1","prodOptServiceDate":"2021-09-07","prodOptTaxable":false,"realId":"a4k2C000000MWS4QAO"},{"prodDicountReason":true,"prodOptDescriptions":"Clear and Brilliant - Touch","prodOptDiscount":"0","prodOptId":"01t3u000007ff4RAAQ","prodOptlistPrice":"0.00","prodOptName":"Clear and Brilliant - Touch","prodOptQuantity":"1","prodOptServiceDate":"2021-09-07","prodOptTaxable":false,"realId":"a4k2C000000MWRkQAO"}],"prodDescription":"Laser Treatment Package","prodDicountReason":true,"prodDiscount":"0","prodDiscountgeneric":0,"prodDiscountType":"USD","prodId":"01t2C000002VnEhQAK","prodlistPrice":"7000.00","prodName":"Laser Package","prodQuantity":"1","prodServiceDate":"2021-09-07","prodTaxable":false,"productIcon":"standard:bundle_config","productType":"bundle","prodBillingProvider":"Dr. Bruno"},{"finalProdPrice":"550.00","maxPercentageVal":"550.00","options":[],"prodDescription":"4 in 1 Facial Serum","prodDicountReason":true,"prodDiscount":"0","prodDiscountgeneric":0,"prodDiscountType":"USD","prodId":"01t6A000000Gc8rQAC","prodlistPrice":"550.00","prodName":"4 in 1 Facial Serum","prodQuantity":"1","prodServiceDate":"2021-09-07","prodTaxable":true,"productIcon":"standard:case","productType":"product","prodBillingProvider":"Dr. Tsai"}]';
        String quoteLine ='[{"finalProdPrice":"1692.50","maxPercentageVal":"1692.50","options":[{"prodDicountReason":true,"prodOptDescriptions":"'+prod1.Name+'","prodOptDiscount":"0","prodOptId":"'+prod1.Id+'","prodOptlistPrice":"1192.50","prodOptName":"'+prod1.Name+'","prodOptQuantity":"1","prodOptServiceDate":"2021-09-07","prodOptTaxable":false,"realId":"'+prodoption1.Id+'"},{"prodDicountReason":true,"prodOptDescriptions":"A Cell Add-on","prodOptDiscount":"0","prodOptId":"'+prod2.Id+'","prodOptlistPrice":"500.00","prodOptName":"'+prod2.Name+'","prodOptQuantity":"1","prodOptServiceDate":"2021-09-07","prodOptTaxable":false,"realId":"'+prodoption2.Id+'"},{"prodDicountReason":true,"prodOptDiscount":"0","prodOptId":"'+prod3.Id+'","prodOptlistPrice":"0.00","prodOptName":"'+prod3.Name+'","prodOptQuantity":"1","prodOptServiceDate":"2021-09-07","prodOptTaxable":false,"realId":"'+prodoption3.Id+'"}],"prodDicountReason":true,"prodDiscount":"0","prodDiscountgeneric":0,"prodDiscountType":"USD","prodId":"'+bundleprod.Id+'","prodlistPrice":"1692.50","prodName":"'+bundleprod.Name+'","prodQuantity":"1","prodServiceDate":"2021-09-07","prodTaxable":true,"productIcon":"standard:bundle_config","productType":"bundle","prodDescription":"Test","prodBillingProvider":"Dr. Emer"}]';
        List<CPQFlowUtility.QuoteWrapper> cq = CPQFlowUtility.createQuote( quote, quoteLine);
        Test.stopTest();
        List< SBQQ__QuoteLine__c >  quoteLines = CPQTestDataFactory.getQuoteLines();
        System.debug('cq is=' + cq);    
        System.assertNotEquals(0,quoteLines.size(), 'Successfully Created Quote');
        System.assertEquals('Adisols Test Cls',cq[0].quoteName, 'Successfully Created Quote');
    }
}