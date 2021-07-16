public class SYS_BatchOutboundHandler implements Database.Batchable<sObject> {
    
    public Database.QueryLocator start(Database.BatchableContext bc){
        
        return Database.getQueryLocator('SELECT id, '+
                                        	'data0__c,'+
                                        	'data1__c,'+
                                        	'data2__c,'+
                                        	'data3__c,'+
                                            'data4__c,'+
                                            'data5__c,'+
                                            'data6__c,'+
                                            'data7__c,'+
                                            'data8__c,'+
                                            'data9__c,'+
                                        	'Type__c,WhatId__c,Parent__c,Order__c'+
                                        	' FROM SYS_IntegrationLog__c WHERE Status__c!=\'DONE\'');
    }
    
    public void execute(Database.BatchableContext bc, List<sObject> sObjects){
        //A single Apex transaction can make a maximum of 100 callouts to an HTTP request or an API call.
        
        //SObjectType objectType = objsList[0].getSObjectType();
        //String primaryObj = JSON.serialize(objectType.getDescribe().getName()).replace('\"','');
        //System.debug('hbdebug objectType.getDescribe().getName() '+ primaryObj);
        
    }
    
    public void finish(Database.BatchableContext bc){
        
    }

}