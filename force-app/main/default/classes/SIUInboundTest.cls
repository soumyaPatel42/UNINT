@isTest
private class SIUInboundTest {
    public static String combinedjsonBody = '';
    public static String accExtId = '';
    public static String accId;
    public static SYS_IntegrationLog__c insertedlog;
    public static Map < String, String > responseHeaders = new Map < String, String > ();
    //SIU_S12
    @isTest static void CheckSIU12InboundRequest() {
        String siujson = IMSTestDataFactory.SIU12JSONStatic();
        responseHeaders.put('Content-Type', 'application/json');
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new IMSCalloutMock(200, 'OK', siujson, responseHeaders));
        //INBOUND Mock Rest Callout
        IMSCallout.requestRestCallout(siujson,200);
        Test.StartTest();
        SYS_WebServiceIMS.doPostMethod();
        //Get Inserted SysLog Record
        insertedlog = IMSTestDataFactory.getSyslog();
        Test.StopTest();
        System.debug('SYS_IntegrationLog After Insert ' + insertedlog);
        System.assertEquals('INBOUND', insertedlog.Type__c, 'Inbound Request Received Successfully');
    }
    @isTest static void CheckSIU12InsertSysIntegrationLog() {
        String siujson = IMSTestDataFactory.SIU12JSONStatic();
        responseHeaders.put('Content-Type', 'application/json');
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new IMSCalloutMock(200, 'OK', siujson, responseHeaders));
        //INBOUND Mock Rest Callout
        IMSCallout.requestRestCallout(siujson,200);
        Test.StartTest();
        SYS_WebServiceIMS.doPostMethod();
        //Get Inserted SysLog Record
        insertedlog = IMSTestDataFactory.getSyslog();
        Test.StopTest();
        combinedjsonBody = insertedlog.data0__c + insertedlog.data1__c + insertedlog.data2__c + insertedlog.data3__c +
            insertedlog.data4__c + insertedlog.data5__c + insertedlog.data6__c + insertedlog.data7__c +
            insertedlog.data8__c + insertedlog.data9__c;
        System.debug('Actual: ' + siujson);
        System.debug('Received : ' + combinedjsonBody);
        System.assertEquals('INBOUND', insertedlog.Type__c, 'Successfully Inserted SysLog Type');
        System.assertEquals('RESPONSE', insertedlog.SYS_Operation_Type__c, 'Successfully Inserted SysLog Operation Type');
        System.assertEquals(siujson, combinedjsonBody, 'Successfully Inserted SysLog JSON');
    }

    @isTest static void CheckSIU12AccountUpserted() {
        String siujson = IMSTestDataFactory.SIU12JSONStatic();
        responseHeaders.put('Content-Type', 'application/json');
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new IMSCalloutMock(200, 'OK', siujson, responseHeaders));
        //INBOUND Mock Rest Callout
        IMSCallout.requestRestCallout(siujson,200);
        Test.StartTest();
        SYS_WebServiceIMS.doPostMethod();
        //Get Inserted SysLog Record
        insertedlog = IMSTestDataFactory.getSyslog();
        Test.StopTest();
        Account acc = IMSTestDataFactory.getAccountDetails();
        System.debug('Account Data : ' + acc);
        System.assertEquals('321217', acc.CS_External_ID__c, 'Successfully Upserted Account');
    }

    @isTest static void CheckSIU12AppointmentCreated() {
        String siujson = IMSTestDataFactory.SIU12JSONStatic();
        responseHeaders.put('Content-Type', 'application/json');
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new IMSCalloutMock(200, 'OK', siujson, responseHeaders));
        //INBOUND Mock Rest Callout
        IMSCallout.requestRestCallout(siujson,200);
        Test.StartTest();
        SYS_WebServiceIMS.doPostMethod();
        //Get Inserted SysLog Record
        insertedlog = IMSTestDataFactory.getSyslog();
        Test.StopTest();
        Account acc = IMSTestDataFactory.getAccountDetails();
        List < Event > appointments = IMSTestDataFactory.getAppointmentDetails(acc.CS_External_ID__c);
        System.debug('Account Data : ' + acc);
        System.assertNotEquals(appointments.size(), 0, 'Successfully Upserted Appointment');

        for (Event appoint: appointments) {
            System.assertEquals('1234567', appoint.Filler_Appointment_ID__c, 'Successfully Created Appointment');
            System.assertEquals('CHECKUP', appoint.Universal_Service_Description__c, 'Successfully Created Appointment');
            System.assertEquals('321217', appoint.SYS_Parent__c, 'Appointment Successfully Linked to Account');
            System.debug('Appointment Data : ' + appoint);
        }
    }
    //SIU_S13
    @isTest static void CheckSIU13InboundRequest() {
        String siujson = IMSTestDataFactory.SIU13JSONStatic();
        responseHeaders.put('Content-Type', 'application/json');
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new IMSCalloutMock(200, 'OK', siujson, responseHeaders));
        //INBOUND Mock Rest Callout
        IMSCallout.requestRestCallout(siujson,200);
        Test.StartTest();
        SYS_WebServiceIMS.doPostMethod();
        //Get Inserted SysLog Record
        insertedlog = IMSTestDataFactory.getSyslog();
        Test.StopTest();
        System.debug('SYS_IntegrationLog After Insert ' + insertedlog);
        System.assertEquals('INBOUND', insertedlog.Type__c, 'Inbound Request Received Successfully');
    }
    @isTest static void CheckSIU13InsertSysIntegrationLog() {
        String siujson = IMSTestDataFactory.SIU13JSONStatic();
        responseHeaders.put('Content-Type', 'application/json');
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new IMSCalloutMock(200, 'OK', siujson, responseHeaders));
        //INBOUND Mock Rest Callout
        IMSCallout.requestRestCallout(siujson,200);
        Test.StartTest();
        SYS_WebServiceIMS.doPostMethod();
        //Get Inserted SysLog Record
        insertedlog = IMSTestDataFactory.getSyslog();
        Test.StopTest();
        combinedjsonBody = insertedlog.data0__c + insertedlog.data1__c + insertedlog.data2__c + insertedlog.data3__c +
            insertedlog.data4__c + insertedlog.data5__c + insertedlog.data6__c + insertedlog.data7__c +
            insertedlog.data8__c + insertedlog.data9__c;
        System.debug('Actual: ' + siujson);
        System.debug('Received : ' + combinedjsonBody);
        System.assertEquals('INBOUND', insertedlog.Type__c, 'Successfully Inserted SysLog Type');
        System.assertEquals('RESPONSE', insertedlog.SYS_Operation_Type__c, 'Successfully Inserted SysLog Operation Type');
        System.assertEquals(siujson, combinedjsonBody, 'Successfully Inserted SysLog JSON');
    }

    @isTest static void CheckSIU13AccountUpserted() {
        String siujson = IMSTestDataFactory.SIU13JSONStatic();
        responseHeaders.put('Content-Type', 'application/json');
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new IMSCalloutMock(200, 'OK', siujson, responseHeaders));
        //INBOUND Mock Rest Callout
        IMSCallout.requestRestCallout(siujson,200);
        Test.StartTest();
        SYS_WebServiceIMS.doPostMethod();
        //Get Inserted SysLog Record
        insertedlog = IMSTestDataFactory.getSyslog();
        Test.StopTest();
        Account acc = IMSTestDataFactory.getAccountDetails();
        System.debug('Account Data : ' + acc);
        System.assertEquals('153449', acc.CS_External_ID__c, 'Successfully Upserted Account');
    }

    @isTest static void CheckSIU13AppointmentCreated() {
        String siujson = IMSTestDataFactory.SIU13JSONStatic();
        responseHeaders.put('Content-Type', 'application/json');
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new IMSCalloutMock(200, 'OK', siujson, responseHeaders));
        //INBOUND Mock Rest Callout
        IMSCallout.requestRestCallout(siujson,200);
        Test.StartTest();
        SYS_WebServiceIMS.doPostMethod();
        //Get Inserted SysLog Record
        insertedlog = IMSTestDataFactory.getSyslog();
        Test.StopTest();
        Account acc = IMSTestDataFactory.getAccountDetails();
        List < Event > appointments = IMSTestDataFactory.getAppointmentDetails(acc.CS_External_ID__c);
        System.debug('Account Data : ' + acc);
        System.assertNotEquals(appointments.size(), 0, 'Successfully Upserted Appointment');

        for (Event appoint: appointments) {
            System.assertEquals('2150781', appoint.Filler_Appointment_ID__c, 'Successfully Created Appointment');
            System.assertEquals('CHECKUP', appoint.Universal_Service_Description__c, 'Successfully Created Appointment');
            System.assertEquals('153449', appoint.SYS_Parent__c, 'Appointment Successfully Linked to Account');
            System.debug('Appointment Data : ' + appoint);
        }
    }
    //SIU_S14
    @isTest static void CheckSIU14InboundRequest() {
        String siujson = IMSTestDataFactory.SIU14JSONStatic();
        responseHeaders.put('Content-Type', 'application/json');
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new IMSCalloutMock(200, 'OK', siujson, responseHeaders));
        //INBOUND Mock Rest Callout
        IMSCallout.requestRestCallout(siujson,200);
        Test.StartTest();
        SYS_WebServiceIMS.doPostMethod();
        //Get Inserted SysLog Record
        insertedlog = IMSTestDataFactory.getSyslog();
        Test.StopTest();
        System.debug('SYS_IntegrationLog After Insert ' + insertedlog);
        System.assertEquals('INBOUND', insertedlog.Type__c, 'Inbound Request Received Successfully');
    }
    @isTest static void CheckSIU14InsertSysIntegrationLog() {
        String siujson = IMSTestDataFactory.SIU14JSONStatic();
        responseHeaders.put('Content-Type', 'application/json');
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new IMSCalloutMock(200, 'OK', siujson, responseHeaders));
        //INBOUND Mock Rest Callout
        IMSCallout.requestRestCallout(siujson,200);
        Test.StartTest();
        SYS_WebServiceIMS.doPostMethod();
        //Get Inserted SysLog Record
        insertedlog = IMSTestDataFactory.getSyslog();
        Test.StopTest();
        combinedjsonBody = insertedlog.data0__c + insertedlog.data1__c + insertedlog.data2__c + insertedlog.data3__c +
            insertedlog.data4__c + insertedlog.data5__c + insertedlog.data6__c + insertedlog.data7__c +
            insertedlog.data8__c + insertedlog.data9__c;
        System.debug('Actual: ' + siujson);
        System.debug('Received : ' + combinedjsonBody);
        System.assertEquals('INBOUND', insertedlog.Type__c, 'Successfully Inserted SysLog Type');
        System.assertEquals('RESPONSE', insertedlog.SYS_Operation_Type__c, 'Successfully Inserted SysLog Operation Type');
        System.assertEquals(siujson, combinedjsonBody, 'Successfully Inserted SysLog JSON');
    }

    @isTest static void CheckSIU14AccountUpserted() {
        String siujson = IMSTestDataFactory.SIU14JSONStatic();
        responseHeaders.put('Content-Type', 'application/json');
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new IMSCalloutMock(200, 'OK', siujson, responseHeaders));
        //INBOUND Mock Rest Callout
        IMSCallout.requestRestCallout(siujson,200);
        Test.StartTest();
        SYS_WebServiceIMS.doPostMethod();
        //Get Inserted SysLog Record
        insertedlog = IMSTestDataFactory.getSyslog();
        Test.StopTest();
        Account acc = IMSTestDataFactory.getAccountDetails();
        System.debug('Account Data : ' + acc);
        System.assertEquals('376', acc.CS_External_ID__c, 'Successfully Upserted Account');
    }

    @isTest static void CheckSIU14AppointmentCreated() {
        String siujson = IMSTestDataFactory.SIU14JSONStatic();
        responseHeaders.put('Content-Type', 'application/json');
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new IMSCalloutMock(200, 'OK', siujson, responseHeaders));
        //INBOUND Mock Rest Callout
        IMSCallout.requestRestCallout(siujson,200);
        Test.StartTest();
        SYS_WebServiceIMS.doPostMethod();
        //Get Inserted SysLog Record
        insertedlog = IMSTestDataFactory.getSyslog();
        Test.StopTest();
        Account acc = IMSTestDataFactory.getAccountDetails();
        List < Event > appointments = IMSTestDataFactory.getAppointmentDetails(acc.CS_External_ID__c);
        System.debug('Account Data : ' + acc);
        System.assertNotEquals(appointments.size(), 0, 'Successfully Upserted Appointment');

        for (Event appoint: appointments) {
            System.assertEquals('631617', appoint.Filler_Appointment_ID__c, 'Successfully Created Appointment');
            System.assertEquals('F/U PATIENT 40', appoint.Universal_Service_Description__c, 'Successfully Created Appointment');
            System.assertEquals('376', appoint.SYS_Parent__c, 'Appointment Successfully Linked to Account');
            System.debug('Appointment Data : ' + appoint);
        }
    }
    //SIU_S15
    @isTest static void CheckSIU15InboundRequest() {
        String siujson = IMSTestDataFactory.SIU15JSONStatic();
        responseHeaders.put('Content-Type', 'application/json');
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new IMSCalloutMock(200, 'OK', siujson, responseHeaders));
        //INBOUND Mock Rest Callout
        IMSCallout.requestRestCallout(siujson,200);
        Test.StartTest();
        SYS_WebServiceIMS.doPostMethod();
        //Get Inserted SysLog Record
        insertedlog = IMSTestDataFactory.getSyslog();
        Test.StopTest();
        System.debug('SYS_IntegrationLog After Insert ' + insertedlog);
        System.assertEquals('INBOUND', insertedlog.Type__c, 'Inbound Request Received Successfully');
    }
    @isTest static void CheckSIU15InsertSysIntegrationLog() {
        String siujson = IMSTestDataFactory.SIU15JSONStatic();
        responseHeaders.put('Content-Type', 'application/json');
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new IMSCalloutMock(200, 'OK', siujson, responseHeaders));
        //INBOUND Mock Rest Callout
        IMSCallout.requestRestCallout(siujson,200);
        Test.StartTest();
        SYS_WebServiceIMS.doPostMethod();
        //Get Inserted SysLog Record
        insertedlog = IMSTestDataFactory.getSyslog();
        Test.StopTest();
        combinedjsonBody = insertedlog.data0__c + insertedlog.data1__c + insertedlog.data2__c + insertedlog.data3__c +
            insertedlog.data4__c + insertedlog.data5__c + insertedlog.data6__c + insertedlog.data7__c +
            insertedlog.data8__c + insertedlog.data9__c;
        System.debug('Actual: ' + siujson);
        System.debug('Received : ' + combinedjsonBody);
        System.assertEquals('INBOUND', insertedlog.Type__c, 'Successfully Inserted SysLog Type');
        System.assertEquals('RESPONSE', insertedlog.SYS_Operation_Type__c, 'Successfully Inserted SysLog Operation Type');
        System.assertEquals(siujson, combinedjsonBody, 'Successfully Inserted SysLog JSON');
    }

    @isTest static void CheckSIU15AccountUpserted() {
        String siujson = IMSTestDataFactory.SIU15JSONStatic();
        responseHeaders.put('Content-Type', 'application/json');
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new IMSCalloutMock(200, 'OK', siujson, responseHeaders));
        //INBOUND Mock Rest Callout
        IMSCallout.requestRestCallout(siujson,200);
        Test.StartTest();
        SYS_WebServiceIMS.doPostMethod();
        //Get Inserted SysLog Record
        insertedlog = IMSTestDataFactory.getSyslog();
        Test.StopTest();
        Account acc = IMSTestDataFactory.getAccountDetails();
        System.debug('Account Data : ' + acc);
        System.assertEquals('562760', acc.CS_External_ID__c, 'Successfully Upserted Account');
    }

    @isTest static void CheckSIU15AppointmentCreated() {
        String siujson = IMSTestDataFactory.SIU15JSONStatic();
        responseHeaders.put('Content-Type', 'application/json');
        // Set mock callout class 
        Test.setMock(HttpCalloutMock.class, new IMSCalloutMock(200, 'OK', siujson, responseHeaders));
        //INBOUND Mock Rest Callout
        IMSCallout.requestRestCallout(siujson,200);
        Test.StartTest();
        SYS_WebServiceIMS.doPostMethod();
        //Get Inserted SysLog Record
        insertedlog = IMSTestDataFactory.getSyslog();
        Test.StopTest();
        Account acc = IMSTestDataFactory.getAccountDetails();
        List < Event > appointments = IMSTestDataFactory.getAppointmentDetails(acc.CS_External_ID__c);
        System.debug('Account Data : ' + acc);
        System.assertNotEquals(appointments.size(), 0, 'Successfully Upserted Appointment');

        for (Event appoint: appointments) {
            System.assertEquals('2133651', appoint.Filler_Appointment_ID__c, 'Successfully Created Appointment');
            System.assertEquals('CHECKUP', appoint.Universal_Service_Description__c, 'Successfully Created Appointment');
            System.assertEquals('562760', appoint.SYS_Parent__c, 'Appointment Successfully Linked to Account');
            System.debug('Appointment Data : ' + appoint);
        }
    }
}