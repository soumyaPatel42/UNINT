public class SYS_processInboundResponse_IMS implements Queueable {
    private List<Id> sysLogIds = new List<Id>();
    
    public SYS_processInboundResponse_IMS(List<Id> idList){
        this.sysLogIds = idList;
    }

    public void execute(QueueableContext context) {
        List<SYS_IntegrationLog__c> respLogs = [SELECT id,
                                                data0__c,
                                                data1__c,
                                                data2__c,
                                                data3__c,
                                                data4__c,
                                                data5__c,
                                                data6__c,
                                                data7__c,
                                                data8__c,
                                                data9__c,
                                                Type__c,WhatId__c,Parent__c,Order__c, Status__c
                                                FROM SYS_IntegrationLog__c WHERE Id in : sysLogIds AND SYS_Operation_Type__c = 'RESPONSE' 
                                                AND Status__c = 'NEW'];
        String jsonBody = '';
        List<sObject> upsertEvent = new List<sObject>();
        List<sObject> upsertAccount = new List<sObject>();
        List<sObject> upsertInsurance = new List<sObject>();
        List<sObject> upsertGuarantor = new List<sObject>();
        String accExtId = '';
        String accId;
        List<Id> accountIdList = new List<Id>(); 
        Map<String, String> mapExtToAcc = new Map<String, String>();
        Map<String, String> mapInsidToAccid = new Map<String, String>();

        // List<Account> acc = Database.query('SELECT Id FROM Account WHERE Name = \'JOHN-DOE-DUMMY-ACC\' ' );
        // if(acc.size() > 0) {
        //     accId = acc[0].Id;
        // } else {
        //     Account a = new Account(Name = 'JOHN-DOE-DUMMY-ACC', RecordTypeId = SYS_integrationLogHandler.getObjectRecordTypeId('Account','Provider'));
        //     insert a;
        //     accId = a.Id;
        // }
        
        for(SYS_IntegrationLog__c log : respLogs) {
            jsonBody = log.data0__c != null ? log.data0__c : '' +
                            log.data1__c != null ? log.data1__c : '' +
                            log.data2__c != null ? log.data2__c : '' +
                            log.data3__c != null ? log.data3__c : '' +
                            log.data4__c != null ? log.data4__c : '' +
                            log.data5__c != null ? log.data5__c : '' +
                            log.data6__c != null ? log.data6__c : '' +
                            log.data7__c != null ? log.data7__c : '' +
                            log.data8__c != null ? log.data8__c : '' +
                            log.data9__c != null ? log.data9__c : '' ; 
            Map<String, String> rootBody = SYS_integrationLogHandler.getRootKey(jsonBody);
            System.debug('@@rootkey ==' + rootBody.get('root'));
            if(rootBody.get('root') == 'ADT_A04' || rootBody.get('root') == 'ADT_A08') {
                SYS_Constants.INT_TYPE = 'Middleware_hl7';
                SYS_DataCache.rootKey = rootBody.get('root');
                String body = rootBody.get('body');
                List<sObject> accountList = SYS_ApexHandler.convertJSONToSObjects( new List<String>{body}, 'blank');
                accountList[0].put('Last_Event__c', rootBody.get('root'));
                upsertAccount.addAll(accountList);
                if(accountList.size() > 0) {
                    accExtId = accountList[0].get('CS_External_ID__c') + '';
                    for(sObject account : accountList) {
                        mapExtToAcc.put(account.get('CS_External_ID__c') + '', '');
                    } 
                    //map of insExtId to acc extId and accextId to accId - 2 maps
                }
                System.debug('Account size=='+upsertAccount.size());
                String insuranceKey = SYS_DataCache.rootKey + '.INSURANCE';
                String guarantorKey = 'GT1';
                System.debug('key@@=='+insuranceKey);
                Object parseObj = JSON.deserializeUntyped(body);
                System.debug('insurance is '+((Map<String, Object>)parseObj).get(insuranceKey));
                if(((Map<String, Object>)parseObj).get(insuranceKey) instanceof List<Object>) {
                    System.debug('inside insurance');
                    List<sObject> insuranceList = SYS_ApexHandler_IMS.convertJSONToChildSObjects(new List<String>{body}, 'blank','INS');
                    for(sObject obj : insuranceList) {
                        String insId = obj.get('Insurance_Set_Plan__c') != null ? obj.get('Insurance_Set_Plan__c')+'' : '' ;
                        // String 
                        // String hash = SYS_integrationLogHandler.getHashOfRecord(insId + accExtId);
                        // obj.put('SYS_Hash__c', hash);
                        obj.put('SYS_Parent__c', accExtId);
                        // obj.put('MemberId', accId);
                        // obj.put('Name', 'INSURANCE - '+ hash.substring(0, 4));
                        // System.debug('insurance =='+obj.get('SYS_Parent__c'));
                    }
                    upsertInsurance.addAll(insuranceList);
                } else if (((Map<String, Object>)parseObj).get(insuranceKey) instanceof Map<String, Object>) {
                    List<Object> insurances = new List<Object>{((Map<String, Object>)parseObj).get(insuranceKey)};
                    ((Map<String, Object>)parseObj).put(insuranceKey, insurances);
                    body = JSON.serialize(parseObj);
                    System.debug('body=='+body);
                    System.debug('inside single insurance');
                    List<sObject> insuranceList = SYS_ApexHandler_IMS.convertJSONToChildSObjects(new List<String>{body}, 'blank', 'INS');
                    for(sObject obj : insuranceList) {
                        String insId = obj.get('Insurance_Set_Plan__c') != null ? obj.get('Insurance_Set_Plan__c')+'' : '' ;
                        // String hash = SYS_integrationLogHandler.getHashOfRecord(insId + accExtId);
                        // obj.put('SYS_Hash__c', hash);
                        obj.put('SYS_Parent__c', accExtId);
                        // obj.put('MemberId', accId);
                        // obj.put('Name', 'INSURANCE - '+ hash.substring(0, 4));
                    }
                    upsertInsurance.addAll(insuranceList);
                } if (((Map<String, Object>)parseObj).get(guarantorKey) instanceof List<Object>) {
                    System.debug('inside guarantor');
                    SYS_Transformer_IMS.childFlatKeyList = new List<Map<String, Object>>();
                    List<sObject> guarantorList = SYS_ApexHandler_IMS.convertJSONToChildSObjects(new List<String>{body}, 'blank','GT1');
                    for(sObject gtr : guarantorList) {
                        gtr.put('SYS_Parent__c', accExtId);
                    }
                    upsertGuarantor.addAll(guarantorList);
                } else if (((Map<String, Object>)parseObj).get(guarantorKey) instanceof Map<String, Object>) {
                    List<Object> guarantors = new List<Object>{((Map<String, Object>)parseObj).get(guarantorKey)};
                    ((Map<String, Object>)parseObj).put(guarantorKey, guarantors);
                    body = JSON.serialize(parseObj);
                    System.debug('body=='+body);
                    System.debug('inside single guarantor');
                    SYS_Transformer_IMS.childFlatKeyList = new List<Map<String, Object>>();
                    List<sObject> guarantorList = SYS_ApexHandler_IMS.convertJSONToChildSObjects(new List<String>{body}, 'blank','GT1');
                    for(sObject gtr : guarantorList) {
                        gtr.put('SYS_Parent__c', accExtId);
                    }
                    upsertGuarantor.addAll(guarantorList);
                } 
                /*else {
                    System.debug('inside else no insurance');
                    List<sObject> insuranceList = SYS_ApexHandler_IMS.convertJSONToChildSObjects(new List<String>{body}, 'blank');
                    for(sObject obj : insuranceList) {
                        String insId = obj.get('Insurance_Set_Plan__c') != null ? obj.get('Insurance_Set_Plan__c')+'' : '' ;
                        String hash = SYS_integrationLogHandler.getHashOfRecord(insId + accExtId);
                        obj.put('SYS_Hash__c', hash);
                        obj.put('SYS_Parent__c', accExtId);
                        obj.put('MemberId', accId);
                        obj.put('Name', 'INSURANCE - '+ hash.substring(0, 4));
                    }
                    upsertInsurance.addAll(insuranceList);
                } */
            }
            else if (rootBody.get('root').contains('SIU')) {
                SYS_Constants.INT_TYPE = 'IMS_SIU';
                SYS_DataCache.rootKey = rootBody.get('root');
                String body = rootBody.get('body');
                List<sObject> eventUpsert = SYS_ApexHandler.convertJSONToSObjects( new List<String>{body}, 'blanksiu');
                for(sObject rec : eventUpsert) {
                    rec.put('Status__c', (rootBody.get('root') != 'SIU_S15') ? 'Booked' : 'Cancelled');
                    rec.put('Subject', 'Appointment - '+ ( rec.get('Universal_Service_Description__c') != null ? ( rec.get('Universal_Service_Description__c') ) : '' ) );
                    rec.put('StartDateTime' , rec.get('Appointment_Start_Date_Time__c') != null ? rec.get('Appointment_Start_Date_Time__c') : DateTime.Now() );
                    rec.put('EndDateTime', rec.get('Appointment_Start_Date_Time__c') != null ? DateTime.valueOf(rec.get('Appointment_Start_Date_Time__c')).addMinutes(rec.get('Appointment_Duration__c') != null ? integer.valueOf(rec.get('Appointment_Duration__c')) : 10 ) : DateTime.Now().addMinutes(10) );
                    System.debug('start=='+ rec.get('StartDateTime')+ ' end=='+ (DateTime.valueOf(rec.get('EndDateTime'))) );
                }
                upsertEvent.addAll(eventUpsert);
                List<sObject> account = SYS_ApexHandler_IMS.convertJSONToParentSobject( new List<String>{body}, 'blanksiu');
                upsertAccount.addAll(account);
                System.debug('Account size=='+upsertAccount.size());
            }
        }
         if (upsertAccount.size() > 0) {
            SYS_integrationLogHandler.addAccountName(upsertAccount);
            System.debug('check--'+upsertAccount[0].get('CS_External_ID__c')+'--'+SYS_integrationLogHandler.checkSFexternalId(String.valueOf(upsertAccount[0].get('Patient_External_ID__c'))));
            if(upsertAccount.size() == 1 && upsertAccount[0].get('CS_External_ID__c') == null && SYS_DataCache.rootKey.contains('ADT')) {
                System.debug('new condition');
                Database.UpsertResult[] upsertResult = Database.upsert(upsertAccount, false);
                for(Database.UpsertResult itr : upsertResult) {
                    if(itr.isSuccess()) {
                        accountIdList.add(itr.getId());
                        System.debug('Successful Account upsert!!');
                        if (upsertInsurance.size() > 0) {
                            SYS_integrationLogHandler.addInsuranceName(upsertInsurance);
                            for(sObject member : upsertInsurance) {
                                String insId = member.get('Insurance_Set_Plan__c') != null ? member.get('Insurance_Set_Plan__c')+'' : '' ;
                                // String hash = SYS_integrationLogHandler.getHashOfRecord(insId + itr.getId());
                                member.put('MemberId', itr.getId());
                                member.put('SYS_Parent__c', itr.getId());
                                
                                // member.put('SYS_Hash__c', hash);
                            }
                            Database.UpsertResult[] upsertResultIns = Database.upsert(upsertInsurance, false);
                            for(Database.UpsertResult itrIns : upsertResultIns) {
                                if(itrIns.isSuccess()) {
                                    System.debug('Successful Insurence upsert!!');
                                } else {
                                    System.debug('error occured '+ itrIns.getErrors());
                                }
                            }
                        } if (upsertEvent.size() > 0) {
                            Database.UpsertResult[] upsertResultevent = Database.upsert(upsertEvent, Schema.getGlobalDescribe().get('Event').getDescribe().fields.getMap().get('Filler_Appointment_ID__c'), false);
                            for(Database.UpsertResult itrEvent : upsertResultevent) {
                                if(itrEvent.isSuccess()) {
                                    System.debug('Successful!!');
                                } else {
                                    System.debug('error occured '+ itrEvent.getErrors());
                                }
                            }
                        }
                    } else {
                        System.debug('error occured '+ itr.getErrors());
                    }
                }
                return;
            } 
            if(upsertAccount.size() == 1 && SYS_DataCache.rootKey.contains('ADT')) {

            }
            if( SYS_integrationLogHandler.checkSFexternalId(String.valueOf(upsertAccount[0].get('Patient_External_ID__c'))) ) {
                System.debug('external inbound SF Id= '+upsertAccount[0].get('Patient_External_ID__c'));

                Database.UpsertResult[] upsertResult = Database.upsert(upsertAccount, Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get('Patient_External_ID__c'), false);
                for(Database.UpsertResult itr : upsertResult) {
                    if(itr.isSuccess()) {
                        accountIdList.add(itr.getId());
                        System.debug('Successful Account upsert!!');

                    } else {
                        System.debug('error occured Account'+ itr.getErrors());
                    }
                }
            } else if(upsertAccount[0].get('CS_External_ID__c') != null ) {
                System.debug('external Id= '+upsertAccount[0].get('CS_External_ID__c'));

                Database.UpsertResult[] upsertResult = Database.upsert(upsertAccount, Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get('CS_External_ID__c'), false);
                for(Database.UpsertResult itr : upsertResult) {
                    if(itr.isSuccess()) {
                        accountIdList.add(itr.getId());
                        System.debug('Successful Account upsert!!');

                    } else {
                        System.debug('error occured Account'+ itr.getErrors());
                    }
                }
            } else {
                system.debug('account else');
            }
            
            /*else if( SYS_integrationLogHandler.checkSFexternalId(String.valueOf(upsertAccount[0].get('Patient_External_ID__c'))) && SYS_DataCache.rootKey.contains('ADT')) {
                System.debug('external inbound SF Id= '+upsertAccount[0].get('Patient_External_ID__c'));

                Database.UpsertResult[] upsertResult = Database.upsert(upsertAccount, Schema.getGlobalDescribe().get('Account').getDescribe().fields.getMap().get('Patient_External_ID__c'), false);
                for(Database.UpsertResult itr : upsertResult) {
                    if(itr.isSuccess()) {
                        System.debug('Successful Account upsert!!');

                    } else {
                        System.debug('error occured Account'+ itr.getErrors());
                    }
                }
            }*/
            
        } 
        for(Account accountIter : [SELECT Id, CS_External_ID__c FROM Account WHERE Id in:accountIdList]) {
            System.debug('account=='+accountIter);
            mapExtToAcc.put(accountIter.CS_External_ID__c , accountIter.Id);
        }
        if(upsertEvent.size() > 0) {
            Database.UpsertResult[] upsertResult = Database.upsert(upsertEvent, Schema.getGlobalDescribe().get('Event').getDescribe().fields.getMap().get('Filler_Appointment_ID__c'), false);
            for(Database.UpsertResult itr : upsertResult) {
                if(itr.isSuccess()) {
                    System.debug('Successful!!');
                } else {
                    System.debug('error occured Event'+ itr.getErrors());
                }
            }
        }if (upsertInsurance.size() > 0) {
            SYS_integrationLogHandler.addInsuranceName(upsertInsurance); 
            for(sObject ins : upsertInsurance) {
                String accidIns = mapExtToAcc.get(String.valueOf(ins.get('SYS_Parent__c')));
                String policyNo = (ins.get('Policy_Number__c') != null) ? String.valueOf(ins.get('Policy_Number__c')).toUppercase() : '';
                String groupNo = (ins.get('Group_Number__c') != null) ? String.valueOf(ins.get('Group_Number__c')).toUppercase() : '';
                String hash = SYS_integrationLogHandler.getHashOfRecord(accidIns + policyNo + groupNo);
                ins.put('SYS_Hash__c', hash);
                ins.put('MemberId', mapExtToAcc.get(String.valueOf(ins.get('SYS_Parent__c')))); 
            }
            Database.UpsertResult[] upsertResult = Database.upsert(upsertInsurance, Schema.getGlobalDescribe().get('MemberPlan').getDescribe().fields.getMap().get('SYS_Hash__c'), false);
            for(Database.UpsertResult itr : upsertResult) {
                if(itr.isSuccess()) {
                    System.debug('Successful Insurence upsert!!');
                } else {
                    System.debug('error occured Insurance'+ itr.getErrors()); 
                }
            }
        } if (upsertGuarantor.size() > 0) {
            for(sObject guarantor : upsertGuarantor) {
                String accidGuarantor = mapExtToAcc.get(String.valueOf(guarantor.get('SYS_Parent__c')));
                String firstname = (guarantor.get('First_Name__c') != null) ? String.valueOf(guarantor.get('First_Name__c')).toUppercase() : '';
                String lastname = (guarantor.get('Last_Name__c') != null) ? String.valueOf(guarantor.get('Last_Name__c')).toUppercase() : '';
                String zip =  (guarantor.get('Zip_Code__c') != null) ? String.valueOf(guarantor.get('Zip_Code__c')).toUppercase() : '';
                String hash = SYS_integrationLogHandler.getHashOfRecord(accidGuarantor + firstname + lastname + zip);
                guarantor.put('SYS_Hash__c', hash);
            }
            Database.UpsertResult[] upsertResult = Database.upsert(upsertGuarantor, Schema.getGlobalDescribe().get('Guarantor__c').getDescribe().fields.getMap().get('SYS_Hash__c'), false);
            for(Database.UpsertResult itr : upsertResult) {
                if(itr.isSuccess()) {
                    System.debug('Successful Guarantor upsert!!');
                } else {
                    System.debug('error occured Guarantor'+ itr.getErrors());
                }
            }
        }
    }
}