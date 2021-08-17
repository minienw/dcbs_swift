//
/*
* Copyright (c) 2021 De Staat der Nederlanden, Ministerie van Volksgezondheid, Welzijn en Sport.
*  Licensed under the EUROPEAN UNION PUBLIC LICENCE v. 1.2
*
*  SPDX-License-Identifier: EUPL-1.2
*/
// swiftlint:disable all
import Foundation

enum DCCTestManufacturer: String {
    
    case astraZeneca = "ORG-100001699"
    case bioNTech = "ORG-100030215"
    case janssen = "ORG-100001417"
    case moderna = "ORG-100031184"
    case cureVac = "ORG-100006270"
    case cansino = "ORG-100013793"
    case chinaSinopharm = "ORG-100020693"
    case europeSinopharm = "ORG-100010771"
    case zhijunSinopharm = "ORG-100024420"
    case novavax = "ORG-100032020"
    case gamaleya = "Gamaleya-Research-Institute"
    case vector = "Vector-Institute"
    case sinoVac = "Sinovac-Biotech"
    case bharat = "Bharat-Biotech"
    case serumInstituteIndia = "ORG-100001981"
    
    case QingdaoHightop = "1341"
         case BectonDickinson = "1065"
         case CTKBiotech = "1581"
         case BioRadLaboratories = "2031"
         case MEDsanGmbH = "1180"
         case GAGenericAssays = "1855"
         case GuangdongLongsee = "1216"
         case MerlinBiomedical = "2029"
         case HangzhouLaihe = "1215"
         case AconBiotech = "1457"
         case XiamenWiz1 = "1456"
         case HangzhouClongene1 = "1610"
         case Joinstar = "1333"
         case Fujirebio = "2147"
         case ShenzhenZhenrui = "1574"
         case ShenzhenMicroprofit1 = "1178"
         case BeijingLepu = "1331"
         case Eurobio = "1739"
         case Artron = "1618"
         case AnhuiDeepBlue1 = "1736"
         case SiemensHealthineers = "1218"
         case MoLab = "1190"
         case Goldsite = "1197"
         case HangzhouImmuno = "2317"
         case NewGene = "1501"
         case ACONLaboratories = "1468"
         case DdsDiagnostic = "1225"
         case TodaPharma = "1466"
         case TriplexInternationalBiosciences = "1465"
         case ShenzhenMicroprofit = "1223"
         case ZhezhiangOrientGene = "1343"
         case BioMaxima = "2035"
         case Azure = "1906"
         case ArcDia1 = "768"
         case GuangdongHecin = "1747"
         case Boditech = "1989"
         case RapidPathogenScreening = "2290"
         case CoreTechnology = "1919"
         case HangzhouClongene2 = "1363"
         case Bionote = "1242"
         case BeijingWantai1 = "1484"
         case MPBiomedicals = "1481"
         case GuangdongWesail = "1360"
         case SDBiosensor1 = "2052"
         case AssureTech1 = "770"
         case SGAMedikal1 = "1357"
         case BTNX = "1236"
         case Biomerica = "1599"
         case Sugentech = "1114"
         case Oncosem = "1199"
         case NanoRepro = "2200"
         case BeijingHotgen = "1870"
         case Abbott = "1232"
         case HubeiJinjian = "1759"
         case Prognosis = "1495"
         case GenSure = "1253"
         case Bioteke = "2067"
         case Biosynex2 = "1494"
         case Quidel = "1097"
         case Safecare1 = "1490"
         case Getein1 = "2183"
         case Healgen = "1767"
         case AVALUN = "1800"
         case Jiangsu = "1920"
         case Safecare2 = "1489"
         case JOYSBIO = "1764"
         case XiamenWiz2 = "1884"
         case XiamenAmonMed = "1763"
         case Novatech = "1762"
         case HangzhouClongene3 = "1365"
         case GenBody = "1244"
         case EdinburghGenetics = "1243"
         case BeijingWantai2 = "1485"
         case PCL1 = "308"
         case ShenzhenWatmind1 = "1769"
         case ShenzhenWatmind2 = "1768"
         case ArcDia2 = "2078"
         case Humasis = "1263"
         case AssureTech2 = "2350"
         case Triplex = "2074"
         case BeijingJinwofu = "2072"
         case AESKU = "2108"
         case Roche1 = "2228"
         case JiangsuBioperfectus = "2107"
         case MEXACARE = "1775"
         case Asan = "1654"
         case NalVonMinden1 = "2104"
         case HangzhouAllTest = "1257"
         case WuhanLife = "1773"
         case VivaChek = "2103"
         case DIALAB = "1375"
         case AXIOM = "2101"
         case AnhuiDeepBlue2 = "1815"
         case Tody = "1934"
         case ShenzhenLvshiyuan = "2109"
         case PCL2 = "2243"
         case DNADiagnostic = "2242"
         case NesaporEuropa = "2241"
         case PrecisionBiosensor = "1271"
         case HangzhouTestsea = "1392"
         case AnbioXiamen = "1822"
         case AMEDALabordiagnostik = "1304"
         case Getein2 = "1820"
         case PerGrande = "2116"
         case LumiraDX = "1268"
         case LumiQuick = "1267"
         case NanoEntek = "1420"
         case Labnovation = "1266"
         case GreenCross = "1144"
         case ArcDia3 = "2079"
         case WuhanUNscience = "2090"
         case Genrui = "2012"
         case BIOHIT = "1286"
         case WuhanEasyDiagnosis = "2098"
         case AtlasLink = "2010"
         case NalVonMinden2 = "1162"
         case Affimedix = "2130"
         case GuangzhouWondfo = "1437"
         case AAZ_LMB = "1833"
         case Lumigenex = "2128"
         case JiangsuMedomics = "2006"
         case BioGnost = "2247"
         case XiamenBoson = "1278"
         case ZhuhaiLituo = "1957"
         case SGAMedikal2 = "1319"
         case ZhejiangAndLucky = "1296"
         case ZhejiangReOpenTest = "1295"
         case CerTest = "1173"
         case Hangzhou = "1844"
         case HangzhouLysun = "2139"
         case ShenzhenUltraDiagnostics = "2017"
         case SDBiosensor2 = "344"
         case GuangzhouDecheng = "1324"
         case SDBiosensor3 = "345"
         case Vitrosens = "1443"
         case ScheBo = "1201"
         case BioticalHealth = "2013"
         case RapiGEN = "1606"
         case ShenzhenMicroprofit2 = "1967"
         case Roche2 = "1604"
    
    var displayName: String {
        switch self {
        
            case .astraZeneca:
                return "AstraZeneca AB"
            case .bioNTech:
                return "Biontech Manufacturing GmbH"
            case .janssen:
                return "Janssen-Cilag International"
            case .moderna:
                return "Moderna Biotech Spain S.L."
            case .cureVac:
                return "Curevac AG"
            case .cansino:
                return "CanSino Biologics"
            case .chinaSinopharm:
                return "Sinopharm Beijing"
            case .europeSinopharm:
                return "Sinopharm Praag"
            case .zhijunSinopharm:
                return "Sinopharm Shenzhen"
            case .novavax:
                return "Novavax CZ AS"
            case .gamaleya:
                return "Gamaleya Research Institute"
            case .vector:
                return "Vector Institute"
            case .sinoVac:
                return "Sinovac Biotech"
            case .bharat:
                return "Bharat Biotech"
        case .serumInstituteIndia:
            return "Serum Institute Of India Private Limited"
        case .QingdaoHightop:
                return  "Qingdao Hightop Biotech Co., Ltd, SARS-CoV-2 Antigen Rapid Test (Immunochromatography)"
        case .BectonDickinson:
                return "Becton Dickinson, BD Veritor™ System for Rapid Detection of SARS CoV 2"
        case .CTKBiotech:
                return "CTK Biotech, Inc, OnSite COVID-19 Ag Rapid Test"
        case .BioRadLaboratories:
                return "Bio-Rad Laboratories / Zhejiang Orient Gene Biotech, Coronavirus Ag Rapid Test Cassette (Swab)"
        case .MEDsanGmbH:
                return "MEDsan GmbH, MEDsan SARS-CoV-2 Antigen Rapid Test"
        case .GAGenericAssays:
                return "GA Generic Assays GmbH, GA CoV-2 Antigen Rapid Test"
        case .GuangdongLongsee:
                return "Guangdong Longsee Biomedical Co., Ltd, COVID-19 Ag Rapid Test Kit (Immuno-Chromatography)"
        case .MerlinBiomedical:
                return "Merlin Biomedical (Xiamen) Co., Ltd., SARS-CoV-2 Antigen Rapid Test Cassette"
        case .HangzhouLaihe:
                return "Hangzhou Laihe Biotech Co., Ltd, LYHER Novel Coronavirus (COVID-19) Antigen Test Kit(Colloidal Gold)"
        case .AconBiotech:
                return "Acon Biotech (Hangzhou) Co., Ltd, SARS-CoV-2 Antigen Rapid Test"
        case .XiamenWiz1:
                return "Xiamen Wiz Biotech Co., Ltd, SARS-CoV-2 Antigen Rapid Test"
        case .HangzhouClongene1:
                return "Hangzhou Clongene Biotech Co., Ltd, COVID-19 Antigen Rapid Test Cassette"
        case .Joinstar:
                return "Joinstar Biomedical Technology Co., Ltd, COVID-19 Rapid Antigen Test (Colloidal Gold)"
        case .Fujirebio:
                return "Fujirebio, ESPLINE SARS-CoV-2"
        case .ShenzhenZhenrui:
                return "Shenzhen Zhenrui Biotechnology Co., Ltd, Zhenrui ®COVID-19 Antigen Test Cassette"
        case .ShenzhenMicroprofit1:
                return "Shenzhen Microprofit Biotech Co., Ltd, SARS-CoV-2 Spike Protein Test Kit (Colloidal Gold Chromatographic Immunoassay)"
        case .BeijingLepu:
                return "Beijing Lepu Medical Technology Co., Ltd, SARS-CoV-2 Antigen Rapid Test Kit"
        case .Eurobio:
                return "Eurobio Scientific, EBS SARS-CoV-2 Ag Rapid Test"
        case .Artron:
                return "Artron Laboratories Inc, Artron COVID-19 Antigen Test"
        case .AnhuiDeepBlue1:
                return "Anhui Deep Blue Medical Technology Co., Ltd, COVID-19 (SARS-CoV-2) Antigen Test Kit(Colloidal Gold)"
        case .SiemensHealthineers:
                return "Siemens Healthineers, CLINITEST Rapid Covid-19 Antigen Test"
        case .MoLab:
                return "möLab, mö-screen Corona Antigen Test"
        case .Goldsite:
                return "Goldsite Diagnostics Inc, SARS-CoV-2 Antigen Kit (Colloidal Gold)"
        case .HangzhouImmuno:
                return "Hangzhou Immuno Biotech Co.,Ltd, SARS-CoV-2 Antigen Rapid Test"
        case .NewGene:
                return "New Gene (Hangzhou) Bioengineering Co., Ltd, COVID-19 Antigen Detection Kit"
        case .ACONLaboratories:
                return "ACON Laboratories, Inc, Flowflex SARS-CoV-2 Antigen rapid test"
        case .DdsDiagnostic:
                return "DDS DIAGNOSTIC, Test Rapid Covid-19 Antigen (tampon nazofaringian)"
        case .TodaPharma:
                return "TODA PHARMA, TODA CORONADIAG Ag"
        case .TriplexInternationalBiosciences:
                return "Triplex International Biosciences Co., Ltd, SARS-CoV-2 Antigen Rapid Test Kit"
        case .ShenzhenMicroprofit:
                return "BIOSYNEX S.A., BIOSYNEX COVID-19 Ag BSS"
        case .ZhezhiangOrientGene:
                return "Zhezhiang Orient Gene Biotech Co., Ltd, Coronavirus Ag Rapid Test Cassette (Swab)"
        case .BioMaxima:
                return "BioMaxima SA, SARS-CoV-2 Ag Rapid Test"
        case .Azure:
                return "Azure Biotech Inc, COVID-19 Antigen Rapid Test Device"
        case .ArcDia1:
                return "ArcDia International Ltd, mariPOC SARS-CoV-2"
        case .GuangdongHecin:
                return "Guangdong Hecin Scientific, Inc., 2019-nCoV Antigen Test Kit (colloidal gold method)"
        case .Boditech:
                return "Boditech Med Inc, AFIAS COVID-19 Ag"
        case .RapidPathogenScreening:
                return "Rapid Pathogen Screening, Inc., LIAISON® Quick Detect Covid Ag Assay"
        case .CoreTechnology:
                return "Core Technology Co., Ltd, Coretests COVID-19 Ag Test"
        case .HangzhouClongene2:
                return "Hangzhou Clongene Biotech Co., Ltd, Covid-19 Antigen Rapid Test Kit"
        case .Bionote:
                return "Bionote, Inc, NowCheck COVID-19 Ag Test"
        case .BeijingWantai1:
                return "Beijing Wantai Biological Pharmacy Enterprise Co., Ltd, Wantai SARS-CoV-2 Ag Rapid Test (FIA)"
        case .MPBiomedicals:
                return "MP Biomedicals, Rapid SARS-CoV-2 Antigen Test Card"
        case .GuangdongWesail:
                return "Guangdong Wesail Biotech Co., Ltd, COVID-19 Ag Test Kit"
        case .SDBiosensor1:
                return "SD BIOSENSOR Inc, STANDARD Q COVID-19 Ag Test Nasal"
        case .AssureTech1:
                return "Assure Tech. (Hangzhou) Co., Ltd, ECOTEST COVID-19 Antigen Rapid Test Device"
        case .SGAMedikal1:
                return "SGA Medikal, V-Chek SARS-CoV-2 Rapid Ag Test (colloidal gold)"
        case .BTNX:
                return "BTNX Inc, Rapid Response COVID-19 Antigen Rapid Test"
        case .Biomerica:
                return "Biomerica, Inc., Biomerica COVID-19 Antigen Rapid Test (nasopharyngeal swab)"
        case .Sugentech:
                return "Sugentech, Inc, SGTi-flex COVID-19 Ag"
        case .Oncosem:
                return "Oncosem Onkolojik Sistemler San. ve Tic. A.S., CAT"
        case .NanoRepro:
                return "NanoRepro AG, NanoRepro SARS-CoV-2 Antigen Rapid Test"
        case .BeijingHotgen:
                return "Beijing Hotgen Biotech Co., Ltd, Novel Coronavirus 2019-nCoV Antigen Test (Colloidal Gold)"
        case .Abbott:
                return "Abbott Rapid Diagnostics, Panbio Covid-19 Ag Rapid Test"
        case .HubeiJinjian:
                return "Hubei Jinjian Biology Co., Ltd, SARS-CoV-2 Antigen Test Kit"
        case .Prognosis:
                return "Prognosis Biotech, Rapid Test Ag 2019-nCov"
        case .GenSure:
                return "GenSure Biotech Inc, GenSure COVID-19 Antigen Rapid Kit"
        case .Bioteke:
                return "BIOTEKE CORPORATION (WUXI) CO., LTD, SARS-CoV-2 Antigen Test Kit (colloidal gold method)"
        case .Biosynex2:
                return "BIOSYNEX S.A., BIOSYNEX COVID-19 Ag+ BSS"
        case .Quidel:
                return "Quidel Corporation, Sofia SARS Antigen FIA"
        case .Safecare1:
                return "Safecare Biotech (Hangzhou) Co. Ltd, Multi-Respiratory Virus Antigen Test Kit(Swab) (Influenza A+B/ COVID-19)"
        case .Getein1:
                return "Getein Biotech, Inc., One Step Test for SARS-CoV-2 Antigen (Colloidal Gold)"
        case .Healgen:
                return "Healgen Scientific, Coronavirus Ag Rapid Test Cassette"
        case .AVALUN:
                return "AVALUN SAS, Ksmart® SARS-COV2 Antigen Rapid Test"
        case .Jiangsu:
                return "Jiangsu Diagnostics Biotechnology Co.,Ltd., COVID-19 Antigen Rapid Test Cassette (Colloidal Gold)"
        case .Safecare2:
                return "Safecare Biotech (Hangzhou) Co. Ltd, COVID-19 Antigen Rapid Test Kit (Swab)"
        case .JOYSBIO:
                return "JOYSBIO (Tianjin) Biotechnology Co., Ltd, SARS-CoV-2 Antigen Rapid Test Kit (Colloidal Gold)"
        case .XiamenWiz2:
                return "Xiamen Wiz Biotech Co., Ltd, SARS-CoV-2 Antigen Rapid Test (Colloidal Gold)"
        case .XiamenAmonMed:
                return "Xiamen AmonMed Biotechnology Co., Ltd, COVID-19 Antigen Rapid Test Kit (Colloidal Gold)"
        case .Novatech:
                return "Novatech, SARS CoV-2 Antigen Rapid Test"
        case .HangzhouClongene3:
                return "Hangzhou Clongene Biotech Co., Ltd, COVID-19/Influenza A+B Antigen Combo Rapid Test"
        case .GenBody:
                return "GenBody, Inc, Genbody COVID-19 Ag Test"
        case .EdinburghGenetics:
                return "Edinburgh Genetics Limited, ActivXpress+ COVID-19 Antigen Complete Testing Kit"
        case .BeijingWantai2:
                return "Beijing Wantai Biological Pharmacy Enterprise Co., Ltd, WANTAI SARS-CoV-2 Ag Rapid Test (Colloidal Gold)"
        case .PCL1:
                return "PCL Inc, PCL COVID19 Ag Rapid FIA"
        case .ShenzhenWatmind1:
                return "Shenzhen Watmind Medical Co., Ltd, SARS-CoV-2 Ag Diagnostic Test Kit (Colloidal Gold)"
        case .ShenzhenWatmind2:
                return "Shenzhen Watmind Medical Co., Ltd, SARS-CoV-2 Ag Diagnostic Test Kit (Immuno-fluorescence)"
        case .ArcDia2:
                return "ArcDia International Oy Ltd, mariPOC Respi+"
        case .Humasis:
                return "Humasis, Humasis COVID-19 Ag Test"
        case .AssureTech2:
                return "Assure Tech. (Hangzhou) Co., Ltd., ECOTEST COVID-19 Antigen Rapid Test Device"
        case .Triplex:
                return "Triplex International Biosciences (China) Co., LTD., SARS-CoV-2 Antigen Rapid Test Kit"
        case .BeijingJinwofu:
                return "Beijing Jinwofu Bioengineering Technology Co.,Ltd., Novel Coronavirus (SARS-CoV-2) Antigen Rapid Test Kit"
        case .AESKU:
                return "AESKU.DIAGNOSTICS GmbH & Co. KG, AESKU.RAPID SARS-CoV-2"
        case .Roche1:
                return "Roche (SD BIOSENSOR), SARS-CoV-2 Rapid Antigen Test Nasal"
        case .JiangsuBioperfectus:
                return "Jiangsu Bioperfectus Technologies Co., Ltd., Novel Corona Virus (SARS-CoV-2) Ag Rapid Test Kit"
        case .MEXACARE:
                return "MEXACARE GmbH, MEXACARE COVID-19 Antigen Rapid Test"
        case .Asan:
                return "Asan Pharmaceutical CO., LTD, Asan Easy Test COVID-19 Ag"
        case .NalVonMinden1:
                return "Nal von minden GmbH, NADAL COVID -19 Ag +Influenza A/B Test"
        case .HangzhouAllTest:
                return "Hangzhou AllTest Biotech Co., Ltd, COVID-19 Antigen Rapid Test"
        case .WuhanLife:
                return "Wuhan Life Origin Biotech Joint Stock Co., Ltd., The SARS-CoV-2 Antigen Assay Kit (Immunochromatography)"
        case .VivaChek:
                return "VivaChek Biotech (Hangzhou) Co., Ltd, VivaDiag Pro SARS-CoV-2 Ag Rapid Test"
        case .DIALAB:
                return "DIALAB GmbH, DIAQUICK COVID-19 Ag Cassette"
        case .AXIOM:
                return "AXIOM Gesellschaft fü Diagnostica und Biochemica mbH, COVID-19 Antigen Rapid Test"
        case .AnhuiDeepBlue2:
                return "Anhui Deep Blue Medical Technology Co., Ltd, COVID-19 (SARS-CoV-2) Antigen Test Kit (Colloidal Gold) - Nasal Swab"
        case .Tody:
                return "Tody Laboratories Int., Coronavirus (SARS-CoV 2) Antigen - Oral Fluid"
        case .ShenzhenLvshiyuan:
                return "Shenzhen Lvshiyuan Biotechnology Co., Ltd., Green Spring SARS-CoV-2 Antigen-Rapid test-Set"
        case .PCL2:
                return "PCL Inc., PCL COVID19 Ag Gold"
        case .DNADiagnostic:
                return "DNA Diagnostic, COVID-19 Antigen Detection Kit"
        case .NesaporEuropa:
                return "NESAPOR EUROPA SL, MARESKIT"
        case .PrecisionBiosensor:
                return "Precision Biosensor, Inc, Exdia COVID-19 Ag"
        case .HangzhouTestsea:
                return "Hangzhou Testsea Biotechnology Co., Ltd, COVID-19 Antigen Test Cassette"
        case .AnbioXiamen:
                return "Anbio (Xiamen) Biotechnology Co., Ltd, Rapid COVID-19 Antigen Test(Colloidal Gold)"
        case .AMEDALabordiagnostik:
                return "AMEDA Labordiagnostik GmbH, AMP Rapid Test SARS-CoV-2 Ag"
        case .Getein2:
                return "Getein Biotech, Inc, SARS-CoV-2 Antigen (Colloidal Gold)"
        case .PerGrande:
                return "PerGrande BioTech Development Co., Ltd., SARS-CoV-2 Antigen Detection Kit (Colloidal Gold Immunochromatographic Assay)"
        case .LumiraDX:
                return "LumiraDX, LumiraDx SARS-CoV-2 Ag Test"
        case .LumiQuick:
                return "LumiQuick Diagnostics Inc, QuickProfile COVID-19 Antigen Test"
        case .NanoEntek:
                return "NanoEntek, FREND COVID-19 Ag"
        case .Labnovation:
                return "Labnovation Technologies Inc, SARS-CoV-2 Antigen Rapid Test Kit"
        case .GreenCross:
                return "Green Cross Medical Science Corp., GENEDIA W COVID-19 Ag"
        case .ArcDia3:
                return "ArcDia International Oy Ltd, mariPOC Quick Flu+"
        case .WuhanUNscience:
                return "Wuhan UNscience Biotechnology Co., Ltd., SARS-CoV-2 Antigen Rapid Test Kit"
        case .Genrui:
                return "Genrui Biotech Inc, SARS-CoV-2 Antigen Test Kit (Colloidal Gold)"
        case .BIOHIT:
                return "BIOHIT HealthCare (Hefei) Co., Ltd, SARS-CoV-2 Antigen Rapid Test Kit (Fluorescence Immunochromatography)"
        case .WuhanEasyDiagnosis:
                return "Wuhan EasyDiagnosis Biomedicine Co., Ltd., COVID-19 (SARS-CoV-2) Antigen Test Kit"
        case .AtlasLink:
                return "Atlas Link Technology Co., Ltd., NOVA Test® SARS-CoV-2 Antigen Rapid Test Kit (Colloidal Gold Immunochromatography)"
        case .NalVonMinden2:
                return "Nal von minden GmbH, NADAL COVID-19 Ag Test"
        case .Affimedix:
                return "Affimedix, Inc., TestNOW® - COVID-19 Antigen Test"
        case .GuangzhouWondfo:
                return "Guangzhou Wondfo Biotech Co., Ltd, Wondfo 2019-nCoV Antigen Test (Lateral Flow Method)"
        case .AAZ_LMB:
                return "AAZ-LMB, COVID-VIRO"
        case .Lumigenex:
                return "Lumigenex (Suzhou) Co., Ltd, PocRoc®SARS-CoV-2 Antigen Rapid Test Kit (Colloidal Gold)"
        case .JiangsuMedomics:
                return "Jiangsu Medomics medical technology Co.,Ltd., SARS-CoV-2 antigen Test Kit (LFIA)"
        case .BioGnost:
                return "BioGnost Ltd, CoviGnost AG Test Device 1x20"
        case .XiamenBoson:
                return "Xiamen Boson Biotech Co. Ltd, Rapid SARS-CoV-2 Antigen Test Card"
        case .ZhuhaiLituo:
                return "Zhuhai Lituo Biotechnology Co., Ltd, COVID-19 Antigen Detection Kit (Colloidal Gold)"
        case .SGAMedikal2:
                return "SGA Medikal, V-Chek SARS-CoV-2 Ag Rapid Test Kit (Colloidal Gold)"
        case .ZhejiangAndLucky:
                return "Zhejiang Anji Saianfu Biotech Co., Ltd, AndLucky COVID-19 Antigen Rapid Test"
        case .ZhejiangReOpenTest:
                return "Zhejiang Anji Saianfu Biotech Co., Ltd, reOpenTest COVID-19 Antigen Rapid Test"
        case .CerTest:
                return "CerTest Biotec, CerTest SARS-CoV-2 Card test"
        case .Hangzhou:
                return "Hangzhou Immuno Biotech Co.,Ltd, Immunobio SARS-CoV-2 Antigen ANTERIOR NASAL Rapid Test Kit (minimal invasive)"
        case .HangzhouLysun:
                return "HANGZHOU LYSUN BIOTECHNOLOGY CO., LTD., COVID-19 Antigen Rapid Test Device 'Colloidal Gold'"
        case .ShenzhenUltraDiagnostics:
                return "Shenzhen Ultra-Diagnostics Biotec.Co.,Ltd, SARS-CoV-2 Antigen Test Kit"
        case .SDBiosensor2:
                return "SD BIOSENSOR Inc, STANDARD F COVID-19 Ag FIA"
        case .GuangzhouDecheng:
                return "Guangzhou Decheng Biotechnology Co., LTD, V-CHEK, 2019-nCoV Ag Rapid Test Kit (Immunochromatography)"
        case .SDBiosensor3:
                return "SD BIOSENSOR Inc, STANDARD Q COVID-19 Ag Test"
        case .Vitrosens:
                return "Vitrosens Biotechnology Co., Ltd, RapidFor SARS-CoV-2 Rapid Ag Test"
        case .ScheBo:
                return "ScheBo Biotech AG, ScheBo SARS CoV-2 Quick Antigen"
        case .BioticalHealth:
                return "Biotical Health S.L.U., biotical SARS-CoV-2 Ag Card"
        case .RapiGEN:
                return "RapiGEN Inc, BIOCREDIT COVID-19 Ag - SARS-CoV 2 Antigen test"
        case .ShenzhenMicroprofit2:
                return "Shenzhen Microprofit Biotech Co., Ltd, SARS-CoV-2 Antigen Test Kit (Colloidal Gold Chromatographic Immunoassay)"
        case .Roche2:
                return "Roche (SD BIOSENSOR), SARS-CoV-2 Rapid Antigen Test"
        }
    }
    
}
