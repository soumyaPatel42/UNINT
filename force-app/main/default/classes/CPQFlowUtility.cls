public class CPQFlowUtility {
    @AuraEnabled(cacheable = true)
    public static List<Product2> getProductList(String key, List<String> selectedProduct){
        String queryStr;
        List<Product2> productList = new List<Product2>();
        System.debug('getProductList name '+key + 'prod selected '+selectedProduct);
        if(key != null){
            queryStr =  'SELECT Id, Name, Description, ProductCode, Taxable__c ,(SELECT id FROM SBQQ__Options__r),'+
                        '(SELECT id, UnitPrice FROM PricebookEntries order by createddate DESC LIMIT 1)'+ 
                        'FROM product2 WHERE Name like \'%'+key+'%\' AND IsActive = true AND Id NOT IN : selectedProduct LIMIT 7';
        }
        try {
            if(queryStr != null)
                productList = Database.query(queryStr);
            
        } catch (Exception e) { 
            throw new AuraHandledException(e.getMessage());
        }
        QuoteWrapper sw = (QuoteWrapper)JSON.deserialize('{"quoteName":"","selectedLocation":"","quoteDescription":"","closeDate":"2021-07-28","expiryDate":"2021-07-02","OpportunityId":"0066A0000095Ii8QAE","accountId":"0016A00000FHjqnQAD","totalPrice":150}',QuoteWrapper.class);
        System.debug(sw);
        system.debug(sw.closeDate);
        return productList;
    }
   
    public static List<SBQQ__QuoteLine__c> processQuoteLineBundleDeletion(String quoteId , String prodId){
        System.debug('processQuoteLineBundleDeletion prodId: ' + prodId);
        List<String> idsList = new List<String>();
        List<SBQQ__QuoteLine__c> quoteLineList = new List<SBQQ__QuoteLine__c>();
        List<SBQQ__ProductOption__c> prodOptList = [SELECT Id, SBQQ__OptionalSKU__c , SBQQ__ConfiguredSKU__c,SBQQ__OptionalSKU__r.Name,SBQQ__OptionalSKU__r.Taxable__c, 
                                                SBQQ__OptionalSKU__r.Description, SBQQ__OptionalSKU__r.ProductCode 
                                                FROM SBQQ__ProductOption__c WHERE SBQQ__ConfiguredSKU__c =: prodId];
        if(prodOptList.size() != 0){
            for(SBQQ__ProductOption__c cid:prodOptList){
                idsList.add(cid.SBQQ__OptionalSKU__c);
            }
            System.debug('Selected Products of Bundle idsList: ' + idsList);
            quoteLineList = [SELECT Id,SBQQ__Product__c,SBQQ__Quote__c,Is_Bundle__c,SBQQ__Number__c
                                            FROM SBQQ__QuoteLine__c WHERE SBQQ__Quote__c =: quoteId AND SBQQ__Product__c IN :idsList];
            System.debug('Deleting QuoteLine Items of Bundle  quoteLineList: ' + quoteLineList);
            if (Schema.sObjectType.SBQQ__QuoteLine__c.isDeletable()) {
            delete quoteLineList;
            }
        }       
        
        return quoteLineList;                                                                    
    }
    @AuraEnabled(cacheable = true)
    public static List<ProductWrapper> getProductDetails(String prodId){
        System.debug('getProductDetails prodId ' + prodId);
        List<Product2> book = new List<Product2>();
        ProductWrapper prodGrid = new ProductWrapper();
        List<ProductWrapper> returnVal = new List<ProductWrapper>();
        List<prodOptions> child = new List<ProdOptions>();
        try {
            book = [SELECT Id, Name,Description, ProductCode, Taxable__c
                    FROM product2
                    WHERE Id = :prodId ORDER By createddate DESC LIMIT 1];
            List<PricebookEntry> bookEntry = [SELECT UnitPrice FROM PricebookEntry WHERE Product2Id = :prodId order by createddate DESC LIMIT 1];
            List<SBQQ__ProductOption__c> prodOptList = [SELECT Id, SBQQ__ConfiguredSKU__c, SBQQ__OptionalSKU__c,SBQQ__OptionalSKU__r.Name,SBQQ__OptionalSKU__r.Taxable__c, 
                                                SBQQ__OptionalSKU__r.Description, SBQQ__OptionalSKU__r.ProductCode 
                                                FROM SBQQ__ProductOption__c WHERE SBQQ__ConfiguredSKU__c =: prodId];
            List<Id> prodOptListId = new List<Id>();
            prodGrid.prodDicountReason = true;
            prodGrid.prodDiscountgeneric = 0; //this amount is used to populate either discount% or discount $
            prodGrid.prodDiscountType = 'USD';
            if(prodOptList.size() != 0){
                prodGrid.productIcon = 'standard:bundle_config';
                prodGrid.productType = 'bundle';
                prodGrid.prodDicountReason = true;
                for(SBQQ__ProductOption__c opt:prodOptList){
                    prodOptListId.add(opt.SBQQ__OptionalSKU__c);
                }
                List<PricebookEntry> listprice = [SELECT UnitPrice,Product2Id FROM PricebookEntry WHERE Product2Id in: prodOptListId];
                Map<String, String> mapIdToPrice = new Map<String, String>();
                for(Id item:prodOptListId){
                    for(PricebookEntry ent:listprice){
                        if(item == ent.Product2Id){
                            mapIdToPrice.put(String.valueOf(item), String.valueOf(ent.UnitPrice));
                        }
                    }
                }

                for(SBQQ__ProductOption__c opt:prodOptList){
                    prodOptions op = new prodOptions();
                    op.realId = opt.Id;
                    op.prodOptId = opt.SBQQ__OptionalSKU__c; //Contains Product Id
                    op.prodOptName = opt.SBQQ__OptionalSKU__r.Name;
                    op.prodOptTaxable = opt.SBQQ__OptionalSKU__r.Taxable__c;
                    op.prodOptQuantity = '1';
                    op.prodOptDescriptions = opt.SBQQ__OptionalSKU__r.Description;
                    op.prodOptlistPrice = mapIdToPrice.get(opt.SBQQ__OptionalSKU__c) != null ? String.valueOf(mapIdToPrice.get(opt.SBQQ__OptionalSKU__c)):'N/A';
                    op.prodDicountReason = true;
                    child.add(op);
                }
                prodGrid.options = child;
            }
            else{
                prodGrid.productIcon = 'standard:case';
                prodGrid.productType = 'product';
                prodGrid.options = child;
            }
            

            if(bookEntry.size() != 0){
                prodGrid.prodlistPrice = String.valueOf(bookEntry[0].UnitPrice);
            }
            else{
                prodGrid.prodlistPrice = 'N/A';
            }
            
            prodGrid.prodId = book[0].Id;
            prodGrid.prodName = book[0].Name;
            prodGrid.prodTaxable = book[0].Taxable__c;
            prodGrid.prodDescription = book[0].Description;
            prodGrid.prodQuantity = '1';
            returnVal.add(prodGrid);
            
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
        System.debug('return val=='+JSON.serialize(returnVal));
        return returnVal;
    }
    @AuraEnabled(cacheable = false)
    public static List<QuoteWrapper> createQuote(String quote, String quoteLine){
        // System.debug('createQuote ' + quote +' && '+quoteLine);
        List<Tax_Rate__c> taxRate = [SELECT Id , Active__c FROM Tax_Rate__c WHERE Active__c = true];
        List<QuoteWrapper> quoteReturn = new List<QuoteWrapper>();
        QuoteWrapper qt = (QuoteWrapper)JSON.deserialize(quote, QuoteWrapper.class);
        List<String> strExprDt = qt.expiryDate.split('-');
        List<String> strCloseDt = qt.closeDate.split('-');
        List<SBQQ__Quote__c> createQtList = new List<SBQQ__Quote__c>();
        List<SBQQ__QuoteLine__c> createQtLnLst = new List<SBQQ__QuoteLine__c>();

        SBQQ__Quote__c createQt = new SBQQ__Quote__c();
        createQt.Tax_Rate__c = (taxRate.size() > 0) ? taxRate[0].Id : null;
        createQt.Quote_Name__c = qt.quoteName;
        createQt.SBQQ__ExpirationDate__c = Date.newInstance(integer.valueof(strExprDt[0]), integer.valueof(strExprDt[1]), integer.valueof(strExprDt[2]));
        createQt.Expected_Close_Date__c = Date.newInstance(integer.valueof(strCloseDt[0]), integer.valueof(strCloseDt[1]), integer.valueof(strCloseDt[2]));
        createQt.Description__c = qt.quoteDescription;
        createQt.Service_Location__c = qt.selectedLocation;
        createQt.SBQQ__Account__c = qt.accountId;
        createQt.Treatment_Plan_Opportunities__c = qt.OpportunityId;
        if(qt.OpportunityId != null) {
            List<Opportunity> opp = [SELECT Id, Patient_Contact_Id__c ,Account.BillingCity,Account.BillingCountry,Account.BillingPostalCode,
                                Account.BillingState,Account.BillingStreet,Account.ShippingCity,Account.ShippingCountry,Account.ShippingPostalCode,
                                Account.ShippingState,Account.ShippingStreet, Account.PersonEmail, Account.Phone
                                FROM Opportunity WHERE Id = : qt.OpportunityId LIMIT 1];
            if(opp.size() > 0) {
                createQt.ContactId__c = opp[0].Patient_Contact_Id__c;
                createQt.SBQQ__BillingStreet__c = opp[0].Account.BillingStreet;
                createQt.SBQQ__BillingCity__c = opp[0].Account.BillingCity;
                createQt.SBQQ__BillingState__c =  opp[0].Account.BillingState;
                createQt.SBQQ__BillingPostalCode__c = opp[0].Account.BillingPostalCode;
                createQt.SBQQ__BillingCountry__c = opp[0].Account.BillingCountry;

                createQt.SBQQ__ShippingStreet__c = opp[0].Account.ShippingStreet;
                createQt.SBQQ__ShippingCity__c = opp[0].Account.ShippingCity;
                createQt.SBQQ__ShippingState__c = opp[0].Account.ShippingState;
                createQt.SBQQ__ShippingPostalCode__c = opp[0].Account.ShippingPostalCode;
                createQt.SBQQ__ShippingCountry__c = opp[0].Account.ShippingCountry;

                createQt.Email__c = opp[0].Account.PersonEmail;
                createQt.Phone__c = opp[0].Account.Phone;
            }
            
        }
        //createQt.ContactId__c = qt.accountId;
        // createQt.SBQQ__PriceBook__c = [SELECT Id from Pricebook2 WHERE name LIKE '%Standard Price Book%' LIMIT 1][0].Id;
        //Id priceBookEntry = [SELECT Id from Pricebook2 WHERE name LIKE '%Standard Price Book%' LIMIT 1][0].Id;
        

        //createQt.SBQQ__Opportunity2__c = qt.OpportunityId;

        createQtList.add(createQt);
        // System.debug('pricebook is='+priceBookEntry);

        List<ProductWrapper> quoteLineItem = (List<ProductWrapper>)JSON.deserialize(quoteLine, List<productWrapper>.class);
        // System.debug('prod'+quoteLineItem);
        
        try{
            //Database.SaveResult[] srList = Database.insert(createQtList, false);
             insert createQt;
            //  createQt.SBQQ__PriceBook__c = priceBookEntry; //TODO - price book entry is not being updated...
            //  update createQt;
            
             integer count = 1;
            for(ProductWrapper pwrap:quoteLineItem){
                Boolean isBundle = False;
                Decimal prodQuantity = decimal.valueOf(pwrap.prodQuantity);
                if(pwrap.options != null) {
                    if(pwrap.options.size()  != 0){
                        isBundle = True;
                    }
                }
                SBQQ__QuoteLine__c qtLine = new SBQQ__QuoteLine__c();
                qtLine.SBQQ__Quote__c = createQt.id;
                qtLine.SBQQ__Product__c = pwrap.prodId;
                qtLine.Is_Taxable__c = pwrap.prodTaxable;
                qtLine.SBQQ__ProductOption__c = pwrap.prodOptionid;
                qtLine.SBQQ__Quantity__c = prodQuantity;
                qtLine.Is_Bundle__c = isBundle;
                qtLine.Billing_Provider__c = pwrap.prodBillingProvider != null ? pwrap.prodBillingProvider : '';
                qtLine.Discount_Reason__c = pwrap.prodDiscountReasons != null ? pwrap.prodDiscountReasons : '';
                qtLine.SBQQ__Number__c = count;
                if(pwrap.prodDiscountType == 'USD'){
                    qtLine.SBQQ__AdditionalDiscountAmount__c = pwrap.prodDiscountgeneric;
                } else {
                    qtLine.SBQQ__Discount__c = pwrap.prodDiscountType == '%' ? pwrap.prodDiscountgeneric : 0;
                }
                 
                qtLine.SBQQ__ListPrice__c = pwrap.prodlistPrice != null ? decimal.valueOf(pwrap.prodlistPrice):0;
                qtLine.Product_Description__c = pwrap.prodDescription;
                // List<String> serviceDate = pwrap.prodServiceDate.split('-');
                // qtLine.Service_Date__c = Date.newInstance(integer.valueof(serviceDate[0]), integer.valueof(serviceDate[1]), integer.valueof(serviceDate[2]));
                qtLine.Service_Date__c = pwrap.prodServiceDate;
                // system.debug('quoteLine is='+qtLine);
                createQtLnLst.add(qtLine);
                count ++;
                if(pwrap.options != null) {
                    Decimal optionSize = pwrap.options.size() * prodQuantity;
                    Decimal sumOfProductsPrice = 0.0;
                    // System.debug('inside options=='+ optionSize);
                    for(prodOptions option : pwrap.options) {
                        sumOfProductsPrice += option.prodOptlistPrice != null ? decimal.valueOf(option.prodOptlistPrice):0;
                    }
                    for(prodOptions option : pwrap.options) {
                        SBQQ__QuoteLine__c qtLineOpt = new SBQQ__QuoteLine__c();
                        qtLineOpt.SBQQ__Quote__c = createQt.id;
                        qtLineOpt.SBQQ__Product__c = option.prodOptId;
                        qtLineOpt.Is_Taxable__c = option.prodOptTaxable;
                        qtLineOpt.Associated_Bundle__c = pwrap.prodId; // Associate Bundle to bundle options
                        // qtLine.SBQQ__ProductOption__c = pwrap.prodOptionid;
                        qtLineOpt.Is_Bundle__c = False;
                        qtLineOpt.SBQQ__Quantity__c = prodQuantity;
                        qtLineOpt.Billing_Provider__c = pwrap.prodBillingProvider != null ? pwrap.prodBillingProvider : '';
                        // qtLine.Discount_Reason__c = pwrap.prodDiscountReasons != null ? pwrap.prodDiscountReasons : '';
                        qtLineOpt.SBQQ__Number__c = count;
                        if(pwrap.prodDiscountType == 'USD'){
                            qtLineOpt.SBQQ__AdditionalDiscountAmount__c = ( (pwrap.prodDiscountgeneric) * (option.prodOptlistPrice != null ? decimal.valueOf(option.prodOptlistPrice):0) ) / sumOfProductsPrice;
                        } else {
                            qtLineOpt.SBQQ__Discount__c = pwrap.prodDiscountType == '%' ? pwrap.prodDiscountgeneric : 0;
                        }
                        // if(pwrap.prodDiscountType == 'USD'){
                        //     qtLine.SBQQ__AdditionalDiscountAmount__c = pwrap.prodDiscountgeneric;
                        // } else {
                        //     qtLine.SBQQ__Discount__c = pwrap.prodDiscountType == '%' ? pwrap.prodDiscountgeneric : 0;
                        // }
                        qtLineOpt.SBQQ__ListPrice__c = option.prodOptlistPrice != null ? decimal.valueOf(option.prodOptlistPrice):0;
                        qtLineOpt.Product_Description__c = option.prodOptName;
                        // List<String> serviceDate = pwrap.prodServiceDate.split('-');
                        // qtLine.Service_Date__c = Date.newInstance(integer.valueof(serviceDate[0]), integer.valueof(serviceDate[1]), integer.valueof(serviceDate[2]));
                        qtLineOpt.Service_Date__c = pwrap.prodServiceDate;
                        count ++;
                        createQtLnLst.add(qtLineOpt);
                    }
                }
            }
            insert createQtLnLst;
            // System.debug('quote created'+createQt.Id+'ye=='+JSON.serialize(createQtLnLst));
            QuoteWrapper warpper = new QuoteWrapper();
            warpper.url = '/'+createQt.Id;
            warpper.quoteName = createQt.Quote_Name__c;
            quoteReturn.add(warpper);
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }    
        // system.debug('Obj is='+quoteReturn);
        return quoteReturn;
    }


    public class ProductWrapper {
        @auraenabled
        public string prodOptionid { get; set;}
        @AuraEnabled
        public string prodId { get; set; }
        @auraEnabled
        public string prodName { get; set; }
        @auraEnabled
        public Boolean prodTaxable { get; set; } //prod Taxable
        @auraEnabled
        public string prodQuantity { get; set; }
        @auraEnabled
        public string prodDescription { get; set; }
        @auraEnabled
        public string prodlistPrice { get; set; }
        @auraEnabled
        public string productIcon { get; set; }
        @auraEnabled
        public string productType { get; set; }
        @auraEnabled
        public string prodBillingProvider { get; set; }
        @auraEnabled
        public string prodDiscount = '0';
        @auraEnabled
        public string prodDiscountReasons { get; set; }
        @auraEnabled
        public boolean prodDicountReason { get; set;}
        @auraEnabled
        public Date prodServiceDate = Date.today();
        @auraEnabled
        public Decimal prodDiscountgeneric { get; set;}
        @auraEnabled
        public String prodDiscountType { get; set; }
        @auraEnabled
        public List<prodOptions> options { get; set; }
    }
    public class prodOptions {
        @auraEnabled
        public string realId { get; set;} //prod option id
        @AuraEnabled
        public string prodOptId { get; set; } //prod id 
        @auraEnabled
        public string prodOptName { get; set; }
        @auraEnabled
        public Boolean prodOptTaxable { get; set; } //prod Taxable
        @auraEnabled
        public string prodOptQuantity { get; set; }
        @auraEnabled
        public string prodOptDescriptions { get; set; }
        @auraEnabled
        public string prodOptlistPrice { get; set; }
        @auraEnabled
        public string prodOptBillingProvider { get; set; }
        @auraEnabled
        public string prodOptDiscount = '0';
        @auraEnabled
        public string prodOptDiscountReasons { get; set; }
        @auraEnabled
        public boolean prodDicountReason { get; set;}
        @auraEnabled
        public Date prodOptServiceDate = Date.today();
    }
    public class QuoteWrapper{ 
        @auraEnabled
        public string quoteName;
        public string selectedLocation;
        public string quoteDescription;
        public string closeDate;
        public string expiryDate;
        public string OpportunityId;
        public string accountId;
        public string totalPrice;
        @auraEnabled
        public string url;
    }
}