global class SYS_PricePriceBookSnycScheduler implements Schedulable {
    global void execute(SchedulableContext ctx) {
        List<PriceBookEntry> PBEUpdated15mins = [SELECT Id,Pricebook2Id,Product2Id,UnitPrice,IsActive FROM PriceBookEntry WHERE SystemModStamp >:Datetime.now().addMinutes(-15)];
        Set<Id> ChangedProductIds = new Set<Id>();
        for(PriceBookEntry PBprodId : PBEUpdated15mins){
			ChangedProductIds.add(PBprodId.Product2Id);            
        }
        
 		List <Product2> Products2changedproducts = Database.query('SELECT ' + String.join(new List<String>(Schema.getGlobalDescribe().get('Product2').getDescribe().fields.getMap().keySet()), ',') + ' FROM Product2 WHERE Is_Bundle__c = FALSE AND Id IN :ChangedProductIds');
        
        //List <Product2> Products2changedproducts = [SELECT Id,Name FROM Product2 WHERE Id IN :ChangedProductIds];  
        /*
         //Map of Product id and Unit Price from PBE
        Map<Id,Decimal> mapOfProductPBPrice = new Map<Id,Decimal>();
        for(PriceBookEntry PBprodId : PBEUpdated15mins){
            if((PBprodId.IsActive == true) && (PBprodId.UnitPrice != NULL) )
               {
					mapOfProductPBPrice.put(PBprodId.Product2Id,PBprodId.UnitPrice); 
               }
        }
         List <Product2> Products2Update = new List <Product2>();  
        //Update Price in product Object
        for (Product2 changedProd: Products2changedproducts) {
            if(changedProd.PriceBook_Price__c != mapOfProductPBPrice.get(changedProd.Id)){
                changedProd.PriceBook_Price__c = mapOfProductPBPrice.get(changedProd.Id);
                Products2Update.add(changedProd);
            }
            if( changedProd.PriceBook_Price__c == NULL ){
               changedProd.PriceBook_Price__c = mapOfProductPBPrice.get(changedProd.Id); 
                Products2Update.add(changedProd);
            }
        }
        
        List<Database.UpsertResult> results = new List<Database.UpsertResult>();
        if(Products2Update.size() > 0) { 
            results = Database.upsert(Products2Update, false);
            SYS_integrationLogHandler.checkDatabaseResults(results);
        }*/
		if(!Products2changedproducts.isEmpty()){
			//Do Outbound Callout
			try{
                List < SYS_InvocableHandler.MyInvocableVariable > invokeList = new List < SYS_InvocableHandler.MyInvocableVariable > ();
                for (Product2 changedProd: Products2changedproducts) {
                    SYS_InvocableHandler.MyInvocableVariable invokeVar = new SYS_InvocableHandler.MyInvocableVariable();
                    invokeVar.integrationSetting = 'QuickBooks';
                    invokeVar.newVal = changedProd;
                    invokeVar.recId = changedProd.Id;
                    invokeVar.operationType ='UPDATE';     
                    invokeList.add(invokeVar);
                    system.debug('invokeList=='+invokeList.size());
                }
                
                SYS_InvocableHandler.printOldAndCurrentValues(invokeList);
            }catch(Exception e) {
					//If update fails - the reason will be shown with a message like 'An exception occurred: + Exception Details'
					System.debug('An exception occurred: ' + e.getMessage());
			}
		}
    }
}