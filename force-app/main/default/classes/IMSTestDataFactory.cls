//@isTest
public class IMSTestDataFactory {
    //ADT JSON TO SYSLOG
    public static String ADTA04JSONStatic(Integer insurancelength) {
        String ADTjson = '';
        if (insurancelength == -1) {
            ADTjson = '{"ADT_A04":{"MSH":{"MSH.10":201706231226591000,"MSH.3":{"HD.1":"MTAB"},"MSH.11":{"PT.1":"P"},"MSH.2":"^~\\\\&","MSH.12":2.3,"MSH.1":"|","MSH.7":{"TS.1":20170623122659},"MSH.6":{"HD.1":"OCH"},"MSH.5":{"HD.1":"ORCHARDSOFT"},"MSH.4":{"HD.1":"HFMC"},"MSH.9":{"CM_MSG.1":"ADT","CM_MSG.2":"A04"}},"GT1":{"GT1.6":{"XTN.1":"(606)298-3601"},"GT1.3":{"XPN.1":"MCCOY","XPN.2":"OWYN"},"GT1.1":1},"PID":{"PID.18":{"CX.1":"PT00090126"},"PID.19":"000090126","PID.2":{"CX.1":"PT00090126"},"PID.1":1,"PID.3":{"CX.6":{"HD.1":"MCCHC"},"CX.5":"MR","CX.1":""},"PID.10":"WHITE","PID.5":{"XPN.1":"MCCOY","XPN.3":"A","XPN.2":"TEST"},"PID.11":{"XAD.5":41230,"XAD.3":"LOUISA","XAD.4":"KY","XAD.1":"10983 YELLOW CREEK"},"PID.22":"NON - HISPANIC/LATINO","PID.8":"F","PID.7":{"TS.1":"20061204"},"PID.13":{"XTN.1":"(606)298-3601"}},"PV1":{"PV1.2":"O","PV1.1":1,"PV1.7":{"XCN.2":"MCCOY","XCN.1":1982071213,"XCN.3":"CARA"},"PV1.18":"P","PV1.4":"R","PV1.16":"N","PV1.3":{"PL.1":"MCCHC"}},"ADT_A04.INSURANCE":{"IN1":{"IN1.1":1,"IN1.2":{"CE.1":76236},"IN1.3":{"CX.1":76236},"IN1.31":"N","IN1.16":{"XPN.1":"MCCOY","XPN.3":"A","XPN.2":"OWYN"},"IN1.15":"PI","IN1.36":"NLM114590102001","IN1.47":"C","IN1.19":{"XAD.5":41230,"XAD.3":"LOUISA","XAD.4":"KY","XAD.1":"10983 YELLOW CREEK"},"IN1.4":{"XON.1":"ANTHEM BLUE CROSS BLUE SHIELD"},"IN1.18":{"TS.1":20061204},"IN1.5":{"XAD.5":30348,"XAD.3":"ATLANTA","XAD.4":"GA","XAD.1":"PO BOX 105187"},"IN1.17":1,"IN1.8":"NLM363"}},"EVN":{"EVN.1":"A08","EVN.2":{"TS.1":20170623122659}}}}';
        }
        else if (insurancelength == 1) {
            ADTjson = '{"ADT_A04":{"MSH":{"MSH.10":201706231226591000,"MSH.3":{"HD.1":"MTAB"},"MSH.11":{"PT.1":"P"},"MSH.2":"^~\\\\&","MSH.12":2.3,"MSH.1":"|","MSH.7":{"TS.1":20170623122659},"MSH.6":{"HD.1":"OCH"},"MSH.5":{"HD.1":"ORCHARDSOFT"},"MSH.4":{"HD.1":"HFMC"},"MSH.9":{"CM_MSG.1":"ADT","CM_MSG.2":"A04"}},"GT1":{"GT1.6":{"XTN.1":"(606)298-3601"},"GT1.3":{"XPN.1":"MCCOY","XPN.2":"OWYN"},"GT1.1":1},"PID":{"PID.18":{"CX.1":"PT00090126"},"PID.19":"000090126","PID.2":{"CX.1":"PT00090126"},"PID.1":1,"PID.3":{"CX.6":{"HD.1":"MCCHC"},"CX.5":"MR","CX.1":75412},"PID.10":"WHITE","PID.5":{"XPN.1":"MCCOY","XPN.3":"A","XPN.2":"TEST"},"PID.11":{"XAD.5":41230,"XAD.3":"LOUISA","XAD.4":"KY","XAD.1":"10983 YELLOW CREEK"},"PID.22":"NON - HISPANIC/LATINO","PID.8":"F","PID.7":{"TS.1":"20061204"},"PID.13":{"XTN.1":"(606)298-3601"}},"PV1":{"PV1.2":"O","PV1.1":1,"PV1.7":{"XCN.2":"MCCOY","XCN.1":1982071213,"XCN.3":"CARA"},"PV1.18":"P","PV1.4":"R","PV1.16":"N","PV1.3":{"PL.1":"MCCHC"}},"ADT_A04.INSURANCE":{"IN1":{"IN1.1":1,"IN1.2":{"CE.1":76236},"IN1.3":{"CX.1":76236},"IN1.31":"N","IN1.16":{"XPN.1":"MCCOY","XPN.3":"A","XPN.2":"OWYN"},"IN1.15":"PI","IN1.36":"NLM114590102001","IN1.47":"C","IN1.19":{"XAD.5":41230,"XAD.3":"LOUISA","XAD.4":"KY","XAD.1":"10983 YELLOW CREEK"},"IN1.4":{"XON.1":"ANTHEM BLUE CROSS BLUE SHIELD"},"IN1.18":{"TS.1":20061204},"IN1.5":{"XAD.5":30348,"XAD.3":"ATLANTA","XAD.4":"GA","XAD.1":"PO BOX 105187"},"IN1.17":1,"IN1.8":"NLM363"}},"EVN":{"EVN.1":"A08","EVN.2":{"TS.1":20170623122659}}}}';
        } else if (insurancelength == 2) {
            ADTjson = '{"ADT_A04":{"MSH":{"MSH.10":201706231226591000,"MSH.3":{"HD.1":"MTAB"},"MSH.11":{"PT.1":"P"},"MSH.2":"^~\\\\&","MSH.12":2.3,"MSH.1":"|","MSH.7":{"TS.1":20170623122659},"MSH.6":{"HD.1":"OCH"},"MSH.5":{"HD.1":"ORCHARDSOFT"},"MSH.4":{"HD.1":"HFMC"},"MSH.9":{"CM_MSG.1":"ADT","CM_MSG.2":"A04"}},"GT1":{"GT1.6":{"XTN.1":"(606)298-3601"},"GT1.3":{"XPN.1":"MCCOY","XPN.2":"OWYN"},"GT1.1":1},"PID":{"PID.18":{"CX.1":"PT00090126"},"PID.19":"000090126","PID.2":{"CX.1":"PT00090126"},"PID.1":1,"PID.3":{"CX.6":{"HD.1":"MCCHC"},"CX.5":"MR","CX.1":75412},"PID.10":"WHITE","PID.5":{"XPN.1":"MCCOY","XPN.3":"A","XPN.2":"TEST"},"PID.11":{"XAD.5":41230,"XAD.3":"LOUISA","XAD.4":"KY","XAD.1":"10983 YELLOW CREEK"},"PID.22":"NON - HISPANIC/LATINO","PID.8":"F","PID.7":{"TS.1":"20061204"},"PID.13":{"XTN.1":"(606)298-3601"}},"PV1":{"PV1.2":"O","PV1.1":1,"PV1.7":{"XCN.2":"MCCOY","XCN.1":1982071213,"XCN.3":"CARA"},"PV1.18":"P","PV1.4":"R","PV1.16":"N","PV1.3":{"PL.1":"MCCHC"}},"ADT_A04.INSURANCE":[{"IN1":{"IN1.1":1,"IN1.2":{"CE.1":76236},"IN1.3":{"CX.1":76236},"IN1.31":"N","IN1.16":{"XPN.1":"MCCOY","XPN.3":"A","XPN.2":"OWYN"},"IN1.15":"PI","IN1.36":"NLM114590102001","IN1.47":"C","IN1.19":{"XAD.5":41230,"XAD.3":"LOUISA","XAD.4":"KY","XAD.1":"10983 YELLOW CREEK"},"IN1.4":{"XON.1":"ANTHEM BLUE CROSS BLUE SHIELD"},"IN1.18":{"TS.1":20061204},"IN1.5":{"XAD.5":30348,"XAD.3":"ATLANTA","XAD.4":"GA","XAD.1":"PO BOX 105187"},"IN1.17":1,"IN1.8":"NLM363"}},{"IN1":{"IN1.1":2,"IN1.2":{"CE.1":76237},"IN1.3":{"CX.1":76237},"IN1.31":"N","IN1.16":{"XPN.1":"MCCOY","XPN.3":"A","XPN.2":"OWYN"},"IN1.15":"PI","IN1.36":"NLM114590102001","IN1.47":"C","IN1.19":{"XAD.5":41230,"XAD.3":"LOUISA","XAD.4":"KY","XAD.1":"10983 YELLOW CREEK"},"IN1.4":{"XON.1":"ANTHEM BLUE CROSS BLUE SHIELD"},"IN1.18":{"TS.1":20061204},"IN1.5":{"XAD.5":30348,"XAD.3":"ATLANTA","XAD.4":"GA","XAD.1":"PO BOX 105187"},"IN1.17":1,"IN1.8":"NLM363"}}],"EVN":{"EVN.1":"A08","EVN.2":{"TS.1":20170623122659}}}}';
        } else {
            ADTjson = '{"ADT_A04":{"MSH":{"MSH.10":201706231226591000,"MSH.3":{"HD.1":"MTAB"},"MSH.11":{"PT.1":"P"},"MSH.2":"^~\\\\&","MSH.12":2.3,"MSH.1":"|","MSH.7":{"TS.1":20170623122659},"MSH.6":{"HD.1":"OCH"},"MSH.5":{"HD.1":"ORCHARDSOFT"},"MSH.4":{"HD.1":"HFMC"},"MSH.9":{"CM_MSG.1":"ADT","CM_MSG.2":"A04"}},"GT1":{"GT1.6":{"XTN.1":"(606)298-3601"},"GT1.3":{"XPN.1":"MCCOY","XPN.2":"OWYN"},"GT1.1":1},"PID":{"PID.18":{"CX.1":"PT00090126"},"PID.19":"000090126","PID.2":{"CX.1":"PT00090126"},"PID.1":1,"PID.3":{"CX.6":{"HD.1":"MCCHC"},"CX.5":"MR","CX.1":75412},"PID.10":"WHITE","PID.5":{"XPN.1":"MCCOY","XPN.3":"A","XPN.2":"TEST"},"PID.11":{"XAD.5":41230,"XAD.3":"LOUISA","XAD.4":"KY","XAD.1":"10983 YELLOW CREEK"},"PID.22":"NON - HISPANIC/LATINO","PID.8":"F","PID.7":{"TS.1":"20061204"},"PID.13":{"XTN.1":"(606)298-3601"}},"PV1":{"PV1.2":"O","PV1.1":1,"PV1.7":{"XCN.2":"MCCOY","XCN.1":1982071213,"XCN.3":"CARA"},"PV1.18":"P","PV1.4":"R","PV1.16":"N","PV1.3":{"PL.1":"MCCHC"}},"EVN":{"EVN.1":"A08","EVN.2":{"TS.1":20170623122659}}}}';
        }
        return ADTjson;
    }
    public static String ADTA08JSONStatic(Integer insurancelength) {
        String ADTjson = '';
        if (insurancelength == 1) {
            ADTjson = '{"ADT_A08":{"MSH":{"MSH.10":202108100458201000,"MSH.3":{"HD.1":"MTAB"},"MSH.11":{"PT.1":"P"},"MSH.2":"^~\\\\&","MSH.12":2.3,"MSH.1":"|","MSH.7":{"TS.1":20210810045820},"MSH.6":{"HD.1":"ONCO"},"MSH.5":{"HD.1":"ONCO"},"MSH.4":{"HD.1":"CCSC"},"MSH.9":{"CM_MSG.1":"ADT","CM_MSG.2":"A08"}},"GT1":{"GT1.8":{"TS.1":20150701},"GT1.6":{"XTN.1":"(954)573-7503"},"GT1.3":{"XPN.1":"TEST","XPN.2":"COVIDD"},"GT1.1":1},"PID":{"PID.18":{"CX.1":"PT00005817"},"PID.19":110443940,"PID.2":{"CX.1":"A80525"},"PID.1":1,"PID.10":"WHITE","PID.11":{"XAD.5":33442,"XAD.3":"DEERFIELD BEACH","XAD.4":"FL","XAD.1":"2032 CAMBRIDGE B,"},"PID.22":"HISPANIC/LATINO","PID.13":{"XTN.1":"(954)573-7503"},"PID.4":{"CX.1":"A80525"},"PID.3":{"CX.1":"A80525"},"PID.5":{"XPN.1":"TEST","XPN.3":"TEST","XPN.2":"COVIDD"},"PID.8":"F","PID.7":{"TS.1":20150701}},"PV1":{"PV1.2":"O","PV1.1":1,"PV1.8":{"XCN.2":"KARISSA","XCN.1":"DOUGHERTY"},"PV1.7":{"XCN.2":"DOUGHERTY","XCN.1":1225535701,"XCN.3":"KARISSA"},"PV1.18":"P","PV1.4":"R","PV1.16":"N","PV1.3":{"PL.1":"00001"}},"ADT_A08.INSURANCE":{"IN1":{"IN1.1":1,"IN1.2":{"CE.1":76236},"IN1.3":{"CX.1":76236},"IN1.31":"N","IN1.16":{"XPN.1":"TEST","XPN.3":"T","XPN.2":"COVIDD"},"IN1.15":"PI","IN1.36":"00168597600","IN1.47":"C","IN1.19":{"XAD.5":33442,"XAD.3":"DEERFIELD BEACH","XAD.4":"FL","XAD.1":"2032 CAMBRIDGE B,"},"IN1.4":{"XON.1":"UCARE OF MINNESOTA - MWE"},"IN1.18":{"TS.1":20150701},"IN1.5":{"XAD.5":55337,"XAD.3":"BURNSVILLE","XAD.4":"MN","XAD.1":"111 23"},"IN1.17":1,"IN1.8":"MEMTMA"}},"EVN":{"EVN.1":"A08","EVN.2":{"TS.1":20210810045820}}}}';
        } else if (insurancelength == 2) {
            ADTjson = '{"ADT_A08":{"MSH":{"MSH.10":202108100458201000,"MSH.3":{"HD.1":"MTAB"},"MSH.11":{"PT.1":"P"},"MSH.2":"^~\\\\&","MSH.12":2.3,"MSH.1":"|","MSH.7":{"TS.1":20210810045820},"MSH.6":{"HD.1":"ONCO"},"MSH.5":{"HD.1":"ONCO"},"MSH.4":{"HD.1":"CCSC"},"MSH.9":{"CM_MSG.1":"ADT","CM_MSG.2":"A08"}},"GT1":{"GT1.8":{"TS.1":20150701},"GT1.6":{"XTN.1":"(954)573-7503"},"GT1.3":{"XPN.1":"TEST","XPN.2":"COVIDD"},"GT1.1":1},"PID":{"PID.18":{"CX.1":"PT00005817"},"PID.19":110443940,"PID.2":{"CX.1":"A80525"},"PID.1":1,"PID.10":"WHITE","PID.11":{"XAD.5":33442,"XAD.3":"DEERFIELD BEACH","XAD.4":"FL","XAD.1":"2032 CAMBRIDGE B,"},"PID.22":"HISPANIC/LATINO","PID.13":{"XTN.1":"(954)573-7503"},"PID.4":{"CX.1":"A80525"},"PID.3":{"CX.1":"A80525"},"PID.5":{"XPN.1":"TEST","XPN.3":"TEST","XPN.2":"COVIDD"},"PID.8":"F","PID.7":{"TS.1":20150701}},"PV1":{"PV1.2":"O","PV1.1":1,"PV1.8":{"XCN.2":"KARISSA","XCN.1":"DOUGHERTY"},"PV1.7":{"XCN.2":"DOUGHERTY","XCN.1":1225535701,"XCN.3":"KARISSA"},"PV1.18":"P","PV1.4":"R","PV1.16":"N","PV1.3":{"PL.1":"00001"}},"ADT_A08.INSURANCE":[{"IN1":{"IN1.1":1,"IN1.2":{"CE.1":76236},"IN1.3":{"CX.1":76236},"IN1.31":"N","IN1.16":{"XPN.1":"TEST","XPN.3":"T","XPN.2":"COVIDD"},"IN1.15":"PI","IN1.36":"00168597600","IN1.47":"C","IN1.19":{"XAD.5":33442,"XAD.3":"DEERFIELD BEACH","XAD.4":"FL","XAD.1":"2032 CAMBRIDGE B,"},"IN1.4":{"XON.1":"UCARE OF MINNESOTA - MWE"},"IN1.18":{"TS.1":20150701},"IN1.5":{"XAD.5":55337,"XAD.3":"BURNSVILLE","XAD.4":"MN","XAD.1":"111 23"},"IN1.17":1,"IN1.8":"MEMTMA"}},{"IN1":{"IN1.1":2,"IN1.31":"N","IN1.16":{"XPN.1":"TEST1","XPN.3":"T","XPN.2":"COVIDD1"},"IN1.15":"PI","IN1.36":"00168597600","IN1.47":"C","IN1.2":{"CE.1":76237},"IN1.3":{"CX.1":76237},"IN1.19":{"XAD.5":33442,"XAD.3":"DEERFIELD BEACH","XAD.4":"FL","XAD.1":"2032 CAMBRIDGE B,"},"IN1.4":{"XON.1":"UCARE OF MINNESOTA - MWE"},"IN1.18":{"TS.1":20150701},"IN1.5":{"XAD.5":55337,"XAD.3":"BURNSVILLE","XAD.4":"MN","XAD.1":"111 23"},"IN1.17":1,"IN1.8":"MEMTMA"}}],"EVN":{"EVN.1":"A08","EVN.2":{"TS.1":20210810045820}}}}';
        } else {
            ADTjson = '{"ADT_A08":{"MSH":{"MSH.10":202108100458201000,"MSH.3":{"HD.1":"MTAB"},"MSH.11":{"PT.1":"P"},"MSH.2":"^~\\\\&","MSH.12":2.3,"MSH.1":"|","MSH.7":{"TS.1":20210810045820},"MSH.6":{"HD.1":"ONCO"},"MSH.5":{"HD.1":"ONCO"},"MSH.4":{"HD.1":"CCSC"},"MSH.9":{"CM_MSG.1":"ADT","CM_MSG.2":"A08"}},"GT1":{"GT1.8":{"TS.1":20150701},"GT1.6":{"XTN.1":"(954)573-7503"},"GT1.3":{"XPN.1":"TEST","XPN.2":"COVIDD"},"GT1.1":1},"PID":{"PID.18":{"CX.1":"PT00005817"},"PID.19":110443940,"PID.2":{"CX.1":"A80525"},"PID.1":1,"PID.10":"WHITE","PID.11":{"XAD.5":33442,"XAD.3":"DEERFIELD BEACH","XAD.4":"FL","XAD.1":"2032 CAMBRIDGE B,"},"PID.22":"HISPANIC/LATINO","PID.13":{"XTN.1":"(954)573-7503"},"PID.4":{"CX.1":"A80525"},"PID.3":{"CX.1":"A80525"},"PID.5":{"XPN.1":"TEST","XPN.3":"TEST","XPN.2":"COVIDD"},"PID.8":"F","PID.7":{"TS.1":20150701}},"PV1":{"PV1.2":"O","PV1.1":1,"PV1.8":{"XCN.2":"KARISSA","XCN.1":"DOUGHERTY"},"PV1.7":{"XCN.2":"DOUGHERTY","XCN.1":1225535701,"XCN.3":"KARISSA"},"PV1.18":"P","PV1.4":"R","PV1.16":"N","PV1.3":{"PL.1":"00001"}},"EVN":{"EVN.1":"A08","EVN.2":{"TS.1":20210810045820}}}}';
        }
        return ADTjson;
    }

    //SIU JSON TO SYSLOG
    public static String SIU12JSONStatic() {
        String SIUjson = '{"SIU_S12":{"MSH":{"MSH.10":202105031119501000,"MSH.3":{"HD.1":"MTAB"},"MSH.11":{"PT.1":"P"},"MSH.2":"^~\\\\&","MSH.12":2.3,"MSH.1":"|","MSH.7":{"TS.1":20210503111950},"MSH.6":{"HD.1":"ONCO"},"MSH.5":{"HD.1":"ONCO"},"MSH.4":{"HD.1":"FAA"},"MSH.9":{"CM_MSG.1":"SIU","CM_MSG.2":"S12"}},"SCH":{"SCH.7":{"CE.1":"CHECKUP"},"SCH.9":15,"SCH.8":{"CE.1":"O"},"SCH.11":{"TQ.4":{"TS.1":202105181045}},"SCH.10":{"CE.1":"MIN"},"SCH.2":{"EI.1":1234567}},"SIU_S12.RESOURCES":{"SIU_S12.PERSONNEL_RESOURCE":{"AIP":{"AIP.4":{"CE.1":"DOCTOR"},"AIP.3":{"XCN.2":"RICHARDS","XCN.1":1497968366,"XCN.3":"NATHAN"},"AIP.1":1}},"AIP":{"AIP.4":{"CE.1":"REFERRING MD"},"AIP.1":2},"SIU_S12.SERVICE":{"AIS":{"AIS.7":15,"AIS.8":{"CE.1":"MIN"},"AIS.3":{"CE.2":"CHECKUP"},"AIS.4":{"TS.1":202105181045},"AIS.1":1}},"RGS":{"RGS.1":1},"SIU_S12.LOCATION_RESOURCE":{"AIL":{"AIL.1":1,"AIL.3":{"PL.2":"CLARKSVILLE","PL.1":"CLRKS"}}}},"SIU_S12.PATIENT":{"PID":{"PID.16":"(502)295-4422","PID.17":279366,"PID.2":{"CX.1":279366},"PID.1":1,"PID.10":"WHITE","PID.21":{"CX.1":"NON - HISPANIC/LATINO"},"PID.11":{"XAD.5":47129,"XAD.3":"CLARKSVILLE","XAD.4":"IN","XAD.1":"1523 ALTAWOOD DRIVE"},"PID.15":{"CE.1":"ENGLISH"},"PID.4":{"CX.1":279366},"PID.3":{"CX.1":321217},"PID.5":{"XPN.1":"TEST","XPN.3":"M","XPN.2":"PAUL"},"PID.8":"M","PID.7":{"TS.1":19800624}},"PV1":{"PV1.2":"O","PV1.1":1,"PV1.7":{"XCN.2":"RICHARDS","XCN.1":1497968366,"XCN.3":"NATHAN"},"PV1.18":"P","PV1.4":"R","PV1.16":"N","PV1.3":{"PL.1":"CLRKS"}}}}}';
        return SIUjson;
    }
    public static String SIU13JSONStatic() {
        String SIUjson = '{"SIU_S13":{"MSH":{"MSH.10":202105031119191000,"MSH.3":{"HD.1":"MTAB"},"MSH.11":{"PT.1":"P"},"MSH.2":"^~\\\\&","MSH.12":2.3,"MSH.1":"|","MSH.7":{"TS.1":20210503111919},"MSH.6":{"HD.1":"ONCO"},"MSH.5":{"HD.1":"ONCO"},"MSH.4":{"HD.1":"FAA"},"MSH.9":{"CM_MSG.1":"SIU","CM_MSG.2":"S13"}},"SIU_S13.PATIENT":{"PID":{"PID.16":"(502)418-2804","PID.17":167351,"PID.2":{"CX.1":167351},"PID.1":1,"PID.10":"WHITE","PID.21":{"CX.1":"NON HISPANIC/LATINO"},"PID.11":{"XAD.5":40243,"XAD.3":"LOUISVILLE","XAD.4":"KY","XAD.1":"429 WHITEHEATH LANE"},"PID.13":{"XTN.1":"(502)254-9656"},"PID.15":{"CE.1":"ENGLISH"},"PID.4":{"CX.1":167351},"PID.3":{"CX.1":153449},"PID.5":{"XPN.1":"TEST","XPN.3":"TJ","XPN.2":"COREY"},"PID.8":"M","PID.7":{"TS.1":20080425}},"PV1":{"PV1.2":"O","PV1.1":1,"PV1.7":{"XCN.2":"POLLARD","XCN.1":1629077698,"XCN.3":"STEPHEN"},"PV1.18":"P","PV1.4":"R","PV1.16":"N","PV1.3":{"PL.1":"EE"}}},"SCH":{"SCH.7":{"CE.1":"CHECKUP"},"SCH.9":15,"SCH.8":{"CE.1":"O"},"SCH.11":{"TQ.4":{"TS.1":202105271015}},"SCH.10":{"CE.1":"MIN"},"SCH.2":{"EI.1":2150781}},"SIU_S13.RESOURCES":{"SIU_S13.LOCATION_RESOURCE":{"AIL":{"AIL.1":1,"AIL.3":{"PL.2":"EAST END","PL.1":"EE"}}},"SIU_S13.SERVICE":{"AIS":{"AIS.7":15,"AIS.8":{"CE.1":"MIN"},"AIS.3":{"CE.2":"CHECKUP"},"AIS.4":{"TS.1":202105271015},"AIS.1":1}},"AIP":{"AIP.4":{"CE.1":"REFERRING MD"},"AIP.1":2},"SIU_S13.PERSONNEL_RESOURCE":{"AIP":{"AIP.4":{"CE.1":"DOCTOR"},"AIP.3":{"XCN.2":"POLLARD","XCN.1":1629077698,"XCN.3":"STEPHEN"},"AIP.1":1}},"RGS":{"RGS.1":1}}}}';
        return SIUjson;
    }
    public static String SIU14JSONStatic() {
        String SIUjson = '{"SIU_S14":{"MSH":{"MSH.10":202108100501361000,"MSH.3":{"HD.1":"MTAB"},"MSH.11":{"PT.1":"P"},"MSH.2":"^~\\\\&","MSH.12":2.3,"MSH.1":"|","MSH.7":{"TS.1":20210810050136},"MSH.6":{"HD.1":"ONCO"},"MSH.5":{"HD.1":"ONCO"},"MSH.4":{"HD.1":"CCSC"},"MSH.9":{"CM_MSG.1":"SIU","CM_MSG.2":"S14"}},"SIU_S14.RESOURCES":{"SIU_S14.LOCATION_RESOURCE":{"AIL":{"AIL.1":1}},"SIU_S14.SERVICE":{"AIS":{"AIS.7":40,"AIS.8":{"CE.1":"MIN"},"AIS.3":{"CE.2":"F/U PATIENT 40"},"AIS.4":{"TS.1":202108121620},"AIS.1":1}},"RGS":{"RGS.1":1},"SIU_S14.PERSONNEL_RESOURCE":{"AIP":{"AIP.4":{"CE.1":"DOCTOR"},"AIP.3":{"XCN.2":"ZAYDMAN","XCN.1":"H400124996","XCN.8":"U","XCN.3":"SVETLANA"},"AIP.1":1}}},"SCH":{"SCH.9":40,"SCH.11":{"TQ.4":{"TS.1":202108121620}},"SCH.10":{"CE.1":"MIN"},"SCH.2":{"EI.1":631617}},"SIU_S14.PATIENT":{"PID":{"PID.1":1,"PID.2":{"CX.1":"PT000681"},"PID.3":{"CX.1":376},"PID.4":{"CX.1":"PT000681"},"PID.5":{"XPN.1":"YOUNG","XPN.2":"RANDY","XPN.3":"CURTIS"},"PID.7":{"TS.1":19570905},"PID.8":"M","PID.10":"WHITE","PID.11":{"XAD.1":"30127 3RD AVE S","XAD.3":"DANBURY","XAD.4":"WI","XAD.5":54840},"PID.13":{"XTN.1":"(651)247-6924"},"PID.18":{"CX.1":"PT000681"},"PID.19":427725546,"PID.22":"NON - HISPANIC/LATINO"},"PV1":{"PV1.1":1,"PV1.2":"O","PV1.3":{"PL.1":"00001"},"PV1.4":"R","PV1.16":"N","PV1.18":"P"}}}}';
        return SIUjson;
    }
    public static String SIU15JSONStatic() {
        String SIUjson = '{"SIU_S15":{"SIU_S15.RESOURCES":{"SIU_S15.LOCATION_RESOURCE":{"AIL":{"AIL.1":1,"AIL.3":{"PL.2":"MEMPHIS POPLAR","PL.1":"MEPOP"}}},"AIP":{"AIP.4":{"CE.1":"REFERRING MD"},"AIP.1":2},"SIU_S15.SERVICE":{"AIS":{"AIS.7":15,"AIS.8":{"CE.1":"MIN"},"AIS.3":{"CE.2":"CHECKUP"},"AIS.4":{"TS.1":202105030930},"AIS.1":1}},"RGS":{"RGS.1":1},"SIU_S15.PERSONNEL_RESOURCE":{"AIP":{"AIP.4":{"CE.1":"DOCTOR"},"AIP.3":{"XCN.2":"LIEBERMAN","XCN.1":1629009717,"XCN.3":"PHILLIP"},"AIP.1":1}}},"MSH":{"MSH.10":202105031119091000,"MSH.3":{"HD.1":"MTAB"},"MSH.11":{"PT.1":"P"},"MSH.2":"^~\\\\&","MSH.12":2.3,"MSH.1":"|","MSH.7":{"TS.1":20210503111909},"MSH.6":{"HD.1":"ONCO"},"MSH.5":{"HD.1":"ONCO"},"MSH.4":{"HD.1":"FAA"},"MSH.9":{"CM_MSG.1":"SIU","CM_MSG.2":"S15"}},"SCH":{"SCH.7":{"CE.1":"CHECKUP"},"SCH.9":15,"SCH.8":{"CE.1":"O"},"SCH.11":{"TQ.4":{"TS.1":202105030930}},"SCH.10":{"CE.1":"MIN"},"SCH.2":{"EI.1":2133651}},"SIU_S15.PATIENT":{"PID":{"PID.16":"(731)445-1773","PID.17":644384,"PID.2":{"CX.1":644384},"PID.1":1,"PID.10":"WHITE","PID.21":{"CX.1":"NON HISPANIC/LATINO"},"PID.11":{"XAD.5":38063,"XAD.3":"RIPLEY","XAD.4":"TN","XAD.1":"1690 NANKIPOO ROAD"},"PID.15":{"CE.1":"ENGLISH"},"PID.4":{"CX.1":644384},"PID.3":{"CX.1":562760},"PID.5":{"XPN.1":"TEST","XPN.3":"B","XPN.2":"NICHOLAS"},"PID.8":"M","PID.7":{"TS.1":19980621}},"PV1":{"PV1.2":"O","PV1.1":1,"PV1.7":{"XCN.2":"LIEBERMAN","XCN.1":1629009717,"XCN.3":"PHILLIP"},"PV1.18":"P","PV1.4":"R","PV1.16":"N","PV1.3":{"PL.1":"MEPOP"}}}}}';
        return SIUjson;
    }
    //Get Data Form SYS_Integrationlog
    public static SYS_IntegrationLog__c getSyslog() {
        List < SYS_IntegrationLog__c > insertedLogs = [SELECT Name, Status__c, SYS_Http_Status__c, SYS_Operation_Type__c, SYS_RequestId__c, Type__c, WhatId__c, data0__c, data1__c, data2__c, data3__c, data4__c, data5__c, data6__c, data7__c, data8__c, data9__c FROM SYS_IntegrationLog__c];
        System.debug('syslog List' + insertedLogs);
		for(SYS_IntegrationLog__c insertedlog:insertedLogs){
            if ((insertedlog.data1__c == null)) {
                insertedlog.data1__c = '';
            }
            if ((insertedlog.data2__c == null)) {
                insertedlog.data2__c = '';
            }
            if ((insertedlog.data3__c == null)) {
                insertedlog.data3__c = '';
            }
            if ((insertedlog.data4__c == null)) {
                insertedlog.data4__c = '';
            }
            if ((insertedlog.data5__c == null)) {
                insertedlog.data5__c = '';
            }
            if ((insertedlog.data6__c == null)) {
                insertedlog.data6__c = '';
            }
            if ((insertedlog.data7__c == null)) {
                insertedlog.data7__c = '';
            }
            if ((insertedlog.data8__c == null)) {
                insertedlog.data8__c = '';
            }
            if ((insertedlog.data9__c == null)) {
                insertedlog.data9__c = '';
            }
		}
        return insertedLogs.size() > 0 ? insertedLogs[0] : new SYS_IntegrationLog__c();
    }
    //Get Data Form Account
    public static Account getAccountDetails() {
        List < Account > accounts = [SELECT Name, Site, CS_External_ID__c, Last_Event__c FROM Account];
        System.debug('TD Account ' + accounts);
        if (accounts.size() == 2) {
            return accounts[1];
        }
        return accounts[0];
    }
    //Get Data Form Insurance
    public static List < MemberPlan > getInsuranceDetails(String accextid) {
        // WHERE SYS_Parent__c = : accextid
        List < MemberPlan > insurances = [SELECT Id, MemberId, SYS_Parent__c, Insurance_Company_Organization_Name__c FROM MemberPlan];
        System.debug('TD Insurance ' + insurances);
        return insurances;
    }

    //Get Data Form Event | Appointment
    public static List < Event > getAppointmentDetails(String accextid) {
        // WHERE SYS_Parent__c = : accextid
        List < Event > appointments = [SELECT Id, AccountId, Account__c, Appointment_Duration_Units__c, Appointment_Duration__c, Appointment_Start_Date_Time__c, Filler_Appointment_ID__c, Patient_Location_Room__c, Personnel_Resource_First_Name__c, Personnel_Resource_ID__c, Personnel_Resource_Last_Name__c, Personnel_Resource_Role_Name__c, Scheduled_Appointment_Timing__c, Schedule_Duration_Units__c, Schedule_Duration__c, SYS_Key__c, SYS_Parent__c, Type, Universal_Service_Description__c, WhatCount, WhatId, WhoCount, WhoId FROM Event];
        System.debug('TD Appointment ' + appointments);
        return appointments;
    }

    //Json to Sobject Account
    public static List < Account > getAccountSobject(String jsonBody) {
        System.debug('jsonBody ' + jsonBody);
        Map < String, String > rootBody = SYS_integrationLogHandler.getRootKey(jsonBody);
        System.debug('@@rootkey ==' + rootBody.get('root'));
        SYS_Constants.INT_TYPE = 'Middleware_hl7';
        SYS_DataCache.rootKey = rootBody.get('root');
        String body = rootBody.get('body');
        System.debug('@@body ==' + body);
        List < sObject > accountList = SYS_ApexHandler.convertJSONToSObjects(new List < String > {
            body
        }, 'blank');
        accountList[0].put('Last_Event__c', rootBody.get('root'));
        SYS_integrationLogHandler.addAccountName(accountList);
        System.debug('accountList ' + accountList);
        return accountList;
    }
    //Json to Sobject Insurance
    public static List < MemberPlan > getInsuranceSobject(String jsonBody,String accId,String accExtId) {
        List<sObject> upsertInsurance = new List<sObject>();
        System.debug('jsonBody ' + jsonBody);
        Map < String, String > rootBody = SYS_integrationLogHandler.getRootKey(jsonBody);
        SYS_Constants.INT_TYPE = 'Middleware_hl7';
        SYS_DataCache.rootKey = rootBody.get('root');
        String body = rootBody.get('body');
        System.debug('@@body ==' + body);

        String insuranceKey = SYS_DataCache.rootKey + '.INSURANCE';
        System.debug('key@@==' + insuranceKey);
        Object parseObj = JSON.deserializeUntyped(body);
        System.debug('insurance is ' + ((Map < String, Object > ) parseObj).get(insuranceKey));

        if (((Map < String, Object > ) parseObj).get(insuranceKey) instanceof List < Object > ) {
            System.debug('inside insurance');
            List < sObject > insuranceList = SYS_ApexHandler_IMS.convertJSONToChildSObjects(new List < String > {
                body
            }, 'blank',insuranceKey);
            for (sObject obj: insuranceList) {
                String insId = obj.get('Insurance_Set_Plan__c') != null ? obj.get('Insurance_Set_Plan__c') + '' : '';
                String hash = SYS_integrationLogHandler.getHashOfRecord(insId + accExtId);
                obj.put('SYS_Hash__c', hash);
                obj.put('SYS_Parent__c', accExtId);
                obj.put('MemberId', accId);
                obj.put('Name', 'INSURANCE - ' + hash.substring(0, 4));
                System.debug('insurance ==' + obj.get('SYS_Parent__c'));
            }
            upsertInsurance.addAll(insuranceList);
        } 
        if (((Map < String, Object > ) parseObj).get(insuranceKey) instanceof Map < String, Object > ) {
            List < Object > insurances = new List < Object > {
                ((Map < String, Object > ) parseObj).get(insuranceKey)
            };
            ((Map < String, Object > ) parseObj).put(insuranceKey, insurances);
            body = JSON.serialize(parseObj);
            System.debug('body==' + body);
            System.debug('inside single insurance');
            List < sObject > insuranceList = SYS_ApexHandler_IMS.convertJSONToChildSObjects(new List < String > {
                body
            }, 'blank',insuranceKey);
            for (sObject obj: insuranceList) {
                String insId = obj.get('Insurance_Set_Plan__c') != null ? obj.get('Insurance_Set_Plan__c') + '' : '';
                String hash = SYS_integrationLogHandler.getHashOfRecord(insId + accExtId);
                obj.put('SYS_Hash__c', hash);
                obj.put('SYS_Parent__c', accExtId);
                obj.put('MemberId', accId);
                obj.put('Name', 'INSURANCE - ' + hash.substring(0, 4));
            }
            upsertInsurance.addAll(insuranceList);
        } 
		SYS_integrationLogHandler.addInsuranceName(upsertInsurance);
        System.debug('upsertInsurance ' + upsertInsurance);
        return upsertInsurance;
    }
}