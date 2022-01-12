public with sharing class AddProductsController {
	
	@AuraEnabled(cacheable = true)
		public static List<OpportunityLineItem> getOpportunityLineItem(String oppId) {
			if(!String.isBlank(oppId)) {
                return [SELECT id, Opportunity.Name, Product2Id, Product2.Name, Product2.Description, Quantity, ListPrice, Description,
                        Opportunity.AccountId,Opportunity.Patient_Contact_Id__c,Opportunity.Account.PersonEmail,
                        Opportunity.Account.BillingCity,Opportunity.Account.BillingStreet,
                        Opportunity.Account.BillingState,Opportunity.Account.BillingPostalCode,Opportunity.Pricebook2Id,
                        Opportunity.Account.PersonMobilePhone,PricebookEntryId 
                        FROM OpportunityLineItem 
                        WHERE OpportunityId =: oppId];
            }
		return null;
	}

	@AuraEnabled(cacheable = true)
    public static List < FetchValueWrapper > fetchPickListValue(sObject objInfo, string picklistFieldApi) {
        // Describe the SObject using its object type.
        Schema.DescribeSObjectResult objDescribe = objInfo.getSObjectType().getDescribe();
 
        // Get a map of fields for the SObject
        map < String, Schema.SObjectField > fieldMap = objDescribe.fields.getMap();
 
        // Get the list of picklist values for this field.
        list < Schema.PicklistEntry > values = fieldMap.get(picklistFieldApi).getDescribe().getPickListValues();
 
        // Create a list of wrapper to store picklist value/lable
        list < FetchValueWrapper > objWrapper = new list < FetchValueWrapper > ();
 
        for (Schema.PicklistEntry a: values) {
            FetchValueWrapper oFetchValueWrapper = new FetchValueWrapper();
            oFetchValueWrapper.slabel = a.getLabel();
            oFetchValueWrapper.svalue = a.getValue();
            oFetchValueWrapper.isDefault = a.isDefaultValue();
            objWrapper.add(oFetchValueWrapper);
        }
        System.debug(objWrapper);
        return objWrapper;
 
    }

    @AuraEnabled
    public static void createQuoteLineItem(Quote quoteObj,List<QuoteLineItem> quoteLineItemsList) {
        //String quoteObj,String quoteline
        System.Debug(LoggingLevel.ERROR, '    #### createQuote....quoteRecordParam:'+quoteObj);
        System.Debug('    #### createQuote....quoteline:' + quoteLineItemsList);
        Quote currentQuote = new Quote();
        List<QuoteLineItem> quoteLineList = new List<QuoteLineItem>();
        currentQuote = quoteObj;
        
        insert currentQuote;
        for(QuoteLineItem currentQuoteItem:quoteLineItemsList)
        {
            decimal listprice = currentQuoteItem.ListPrice;
            currentQuoteItem.QuoteId = currentQuote.id;
            if (listPrice != null) {currentQuoteItem.UnitPrice = listprice;}
            quoteLineList.add(currentQuoteItem);
        }
        insert quoteLineList;
        //insert quoteRecordParam;
        //return quoteRecordParam;
    }

 	//wrapper class 
    public with sharing class FetchValueWrapper {
        @auraEnabled public string slabel {get;set;}
        @auraEnabled public string svalue {get;set;}
        @AuraEnabled public Boolean isDefault {get; set;}
    }
	/*
    public with sharing class QuoteWrapper {
       	@auraEnabled public String Quote_Name {get;set;}
        @auraEnabled public Date Quote_Close_Date {get;set;}
        @auraEnabled public String Quote_Description {get;set;}
    }
    
    public with sharing class QuoteLineItemWrapper {
        @auraEnabled public String quoteId {get;set;}
       	@auraEnabled public String productId {get;set;}
        @auraEnabled public Double itemQuantity {get;set;}
        @auraEnabled public Double itemListPrice {get;set;}
        @auraEnabled public Double itemDiscount {get;set;}
        @auraEnabled public String itemDiscountReason {get;set;}
        @auraEnabled public String itemBillingProvider {get;set;}
    }
    */
}