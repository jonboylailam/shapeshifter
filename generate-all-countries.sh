#!/bin/sh
# todo finish him
# http://www.gdal.org/ogr2ogr.html
# https://github.com/mbostock/topojson/wiki/Command-Line-Reference

if [ ! -d "out" ]; then
    mkdir -p out/json
    echo "Creating the out directory out/json"
fi

# $1 is the file for the generated shp file
# $2 this is the ogr2ogr filter e.g. "ADM0_A3 NOT IN ('ATA')" > don't include antartica in the generated shp file
# $3 is the shape file which will be filtered
create_shp () {
    out=out/$1
    echo $out

    if [ -d $out ]; then
        rm -rf $out
    fi

    mkdir $out
    ogr2ogr -f "ESRI Shapefile" -where "$2" $out/$1 shpfiles/$3
}

# Creates the topoJson file from the filtered shp file.
# Expects 3 params:
# $1 is the file for the generated json file
# $2 is the shape file which is used to create the land
# $3 is the shape file which is used to create the countries
create_topojson () {
    if [ -f "$1" ]; then
        rm $1
    fi

    tmpDir=$1.tmp
    if [ ! -d $tmpDir ]; then
        mkdir -p $tmpDir
        echo "Creating the temp directory $tmpDir"
    fi

    topojson -o $tmpDir/tmp.json -q 1e5 --id-property=+iso_n3 -p iso_a2,adm0_a3,gn_a1_code,gns_region,name -- land=$3 countries=$3
    topojson-merge -o $1 --io=land --oo=land --no-key -- $tmpDir/tmp.json
    rm -rf $tmpDir
}

create_region () {
    create_shp "$1.shp" "$2" "ne_10m_admin_0_countries.shp"
    create_topojson "out/json/region/$1/topo.json" "ne_10m_land.shp" "out/$1.shp/$1.shp"
}

# with provinces
create_region_s () {
    create_shp "$1-s.shp" "$2" "ne_10m_admin_1_states_provinces.shp"
    create_topojson "out/json/region/$1/topo-s.json" "ne_10m_land.shp" "out/$1-s.shp/$1-s.shp"
}

create_region_s "AW" "ADM0_A3 IN ('ABW')"
create_region_s "AF" "ADM0_A3 IN ('AFG')"
create_region_s "AO" "ADM0_A3 IN ('AGO')"
create_region_s "AI" "ADM0_A3 IN ('AIA')"
create_region_s "AL" "ADM0_A3 IN ('ALB')"
create_region_s "AX" "ADM0_A3 IN ('ALA')"
create_region_s "AD" "ADM0_A3 IN ('AND')"
create_region_s "AE" "ADM0_A3 IN ('ARE')"
create_region_s "AR" "ADM0_A3 IN ('ARG')"
create_region_s "AM" "ADM0_A3 IN ('ARM')"
create_region_s "AS" "ADM0_A3 IN ('ASM')"
create_region_s "AU" "ADM0_A3 IN ('AUS')"
create_region_s "TF" "ADM0_A3 IN ('ATF')"
create_region_s "AG" "ADM0_A3 IN ('ATG')"
create_region_s "AU" "ADM0_A3 IN ('AUS')"
create_region_s "AT" "ADM0_A3 IN ('AUT')"
create_region_s "AZ" "ADM0_A3 IN ('AZE')"
create_region_s "BI" "ADM0_A3 IN ('BDI')"
create_region_s "BE" "ADM0_A3 IN ('BEL')"
create_region_s "BJ" "ADM0_A3 IN ('BEN')"
create_region_s "BF" "ADM0_A3 IN ('BFA')"
create_region_s "BD" "ADM0_A3 IN ('BGD')"
create_region_s "BG" "ADM0_A3 IN ('BGR')"
create_region_s "BH" "ADM0_A3 IN ('BHR')"
create_region_s "BS" "ADM0_A3 IN ('BHS')"
create_region_s "BA" "ADM0_A3 IN ('BIH')"
create_region_s "BL" "ADM0_A3 IN ('BLM')"
create_region_s "BY" "ADM0_A3 IN ('BLR')"
create_region_s "BZ" "ADM0_A3 IN ('BLZ')"
create_region_s "BM" "ADM0_A3 IN ('BMU')"
create_region_s "BO" "ADM0_A3 IN ('BOL')"
create_region_s "BR" "ADM0_A3 IN ('BRA')"
create_region_s "BB" "ADM0_A3 IN ('BRB')"
create_region_s "BN" "ADM0_A3 IN ('BRN')"
create_region_s "BT" "ADM0_A3 IN ('BTN')"
create_region_s "BW" "ADM0_A3 IN ('BWA')"
create_region_s "CF" "ADM0_A3 IN ('CAF')"
create_region_s "CA" "ADM0_A3 IN ('CAN')"
create_region_s "CH" "ADM0_A3 IN ('CHE')"
create_region_s "CL" "ADM0_A3 IN ('CHL')"
create_region_s "CN" "ADM0_A3 IN ('CHN')"
create_region_s "CI" "ADM0_A3 IN ('CIV')"
create_region_s "CM" "ADM0_A3 IN ('CMR')"
create_region_s "CD" "ADM0_A3 IN ('COD')"
create_region_s "CG" "ADM0_A3 IN ('COG')"
create_region_s "CK" "ADM0_A3 IN ('COK')"
create_region_s "CO" "ADM0_A3 IN ('COL')"
create_region_s "KM" "ADM0_A3 IN ('COM')"
create_region_s "CV" "ADM0_A3 IN ('CPV')"
create_region_s "CR" "ADM0_A3 IN ('CRI')"
create_region_s "CU" "ADM0_A3 IN ('CUB')"
create_region_s "CW" "ADM0_A3 IN ('CUW')"
create_region_s "KY" "ADM0_A3 IN ('CYM')"
create_region_s "CY" "ADM0_A3 IN ('CYP')"
create_region_s "CY" "ADM0_A3 IN ('CYP')"
create_region_s "CZ" "ADM0_A3 IN ('CZE')"
create_region_s "DE" "ADM0_A3 IN ('DEU')"
create_region_s "DJ" "ADM0_A3 IN ('DJI')"
create_region_s "DM" "ADM0_A3 IN ('DMA')"
create_region_s "DK" "ADM0_A3 IN ('DNK')"
create_region_s "DO" "ADM0_A3 IN ('DOM')"
create_region_s "DZ" "ADM0_A3 IN ('DZA')"
create_region_s "EC" "ADM0_A3 IN ('ECU')"
create_region_s "EG" "ADM0_A3 IN ('EGY')"
create_region_s "ER" "ADM0_A3 IN ('ERI')"
create_region_s "ES" "ADM0_A3 IN ('ESP')"
create_region_s "EE" "ADM0_A3 IN ('EST')"
create_region_s "ET" "ADM0_A3 IN ('ETH')"
create_region_s "FI" "ADM0_A3 IN ('FIN')"
create_region_s "FJ" "ADM0_A3 IN ('FJI')"
create_region_s "FK" "ADM0_A3 IN ('FLK')"
create_region_s "FR" "ADM0_A3 IN ('FRA') AND TYPE_EN like 'Metropolitan%'"
create_region_s "FO" "ADM0_A3 IN ('FRO')"
create_region_s "FM" "ADM0_A3 IN ('FSM')"
create_region_s "GA" "ADM0_A3 IN ('GAB')"
create_region_s "GB" "ADM0_A3 IN ('GBR')"
create_region_s "GE" "ADM0_A3 IN ('GEO')"
create_region_s "GG" "ADM0_A3 IN ('GGY')"
create_region_s "GH" "ADM0_A3 IN ('GHA')"
create_region_s "GN" "ADM0_A3 IN ('GIN')"
create_region_s "GM" "ADM0_A3 IN ('GMB')"
create_region_s "GW" "ADM0_A3 IN ('GNB')"
create_region_s "GQ" "ADM0_A3 IN ('GNQ')"
create_region_s "GR" "ADM0_A3 IN ('GRC')"
create_region_s "GD" "ADM0_A3 IN ('GRD')"
create_region_s "GL" "ADM0_A3 IN ('GRL')"
create_region_s "GT" "ADM0_A3 IN ('GTM')"
create_region_s "GU" "ADM0_A3 IN ('GUM')"
create_region_s "GY" "ADM0_A3 IN ('GUY')"
create_region_s "HK" "ADM0_A3 IN ('HKG')"
create_region_s "HM" "ADM0_A3 IN ('HMD')"
create_region_s "HN" "ADM0_A3 IN ('HND')"
create_region_s "HR" "ADM0_A3 IN ('HRV')"
create_region_s "HT" "ADM0_A3 IN ('HTI')"
create_region_s "HU" "ADM0_A3 IN ('HUN')"
create_region_s "ID" "ADM0_A3 IN ('IDN')"
create_region_s "IM" "ADM0_A3 IN ('IMN')"
create_region_s "IN" "ADM0_A3 IN ('IND')"
create_region_s "IO" "ADM0_A3 IN ('IOT')"
create_region_s "IE" "ADM0_A3 IN ('IRL')"
create_region_s "IR" "ADM0_A3 IN ('IRN')"
create_region_s "IQ" "ADM0_A3 IN ('IRQ')"
create_region_s "IS" "ADM0_A3 IN ('ISL')"
create_region_s "IL" "ADM0_A3 IN ('ISR')"
create_region_s "IT" "ADM0_A3 IN ('ITA')"
create_region_s "JM" "ADM0_A3 IN ('JAM')"
create_region_s "JE" "ADM0_A3 IN ('JEY')"
create_region_s "JO" "ADM0_A3 IN ('JOR')"
create_region_s "JP" "ADM0_A3 IN ('JPN')"
create_region_s "KZ" "ADM0_A3 IN ('KAZ')"
create_region_s "KE" "ADM0_A3 IN ('KEN')"
create_region_s "KG" "ADM0_A3 IN ('KGZ')"
create_region_s "KH" "ADM0_A3 IN ('KHM')"
create_region_s "KI" "ADM0_A3 IN ('KIR')"
create_region_s "KN" "ADM0_A3 IN ('KNA')"
create_region_s "KR" "ADM0_A3 IN ('KOR')"
create_region_s "RS" "ADM0_A3 IN ('SRB')"
create_region_s "KW" "ADM0_A3 IN ('KWT')"
create_region_s "LA" "ADM0_A3 IN ('LAO')"
create_region_s "LB" "ADM0_A3 IN ('LBN')"
create_region_s "LR" "ADM0_A3 IN ('LBR')"
create_region_s "LY" "ADM0_A3 IN ('LBY')"
create_region_s "LC" "ADM0_A3 IN ('LCA')"
create_region_s "LI" "ADM0_A3 IN ('LIE')"
create_region_s "LK" "ADM0_A3 IN ('LKA')"
create_region_s "LS" "ADM0_A3 IN ('LSO')"
create_region_s "LT" "ADM0_A3 IN ('LTU')"
create_region_s "LU" "ADM0_A3 IN ('LUX')"
create_region_s "LV" "ADM0_A3 IN ('LVA')"
create_region_s "MO" "ADM0_A3 IN ('MAC')"
create_region_s "MF" "ADM0_A3 IN ('MAF')"
create_region_s "MA" "ADM0_A3 IN ('MAR')"
create_region_s "MC" "ADM0_A3 IN ('MCO')"
create_region_s "MD" "ADM0_A3 IN ('MDA')"
create_region_s "MG" "ADM0_A3 IN ('MDG')"
create_region_s "MV" "ADM0_A3 IN ('MDV')"
create_region_s "MX" "ADM0_A3 IN ('MEX')"
create_region_s "MH" "ADM0_A3 IN ('MHL')"
create_region_s "MK" "ADM0_A3 IN ('MKD')"
create_region_s "ML" "ADM0_A3 IN ('MLI')"
create_region_s "MT" "ADM0_A3 IN ('MLT')"
create_region_s "MM" "ADM0_A3 IN ('MMR')"
create_region_s "ME" "ADM0_A3 IN ('MNE')"
create_region_s "MN" "ADM0_A3 IN ('MNG')"
create_region_s "MP" "ADM0_A3 IN ('MNP')"
create_region_s "MZ" "ADM0_A3 IN ('MOZ')"
create_region_s "MR" "ADM0_A3 IN ('MRT')"
create_region_s "MS" "ADM0_A3 IN ('MSR')"
create_region_s "MU" "ADM0_A3 IN ('MUS')"
create_region_s "MW" "ADM0_A3 IN ('MWI')"
create_region_s "MY" "ADM0_A3 IN ('MYS')"
create_region_s "NA" "ADM0_A3 IN ('NAM')"
create_region_s "NC" "ADM0_A3 IN ('NCL')"
create_region_s "NE" "ADM0_A3 IN ('NER')"
create_region_s "NF" "ADM0_A3 IN ('NFK')"
create_region_s "NG" "ADM0_A3 IN ('NGA')"
create_region_s "NI" "ADM0_A3 IN ('NIC')"
create_region_s "NU" "ADM0_A3 IN ('NIU')"
create_region_s "NL" "ADM0_A3 IN ('NLD') AND TYPE_EN NOT LIKE 'Special%'"
create_region_s "NO" "ADM0_A3 IN ('NOR')"
create_region_s "NP" "ADM0_A3 IN ('NPL')"
create_region_s "NR" "ADM0_A3 IN ('NRU')"
create_region_s "NZ" "ADM0_A3 IN ('NZL')"
create_region_s "OM" "ADM0_A3 IN ('OMN')"
create_region_s "PK" "ADM0_A3 IN ('PAK')"
create_region_s "PA" "ADM0_A3 IN ('PAN')"
create_region_s "PN" "ADM0_A3 IN ('PCN')"
create_region_s "PE" "ADM0_A3 IN ('PER')"
create_region_s "PH" "ADM0_A3 IN ('PHL')"
create_region_s "PW" "ADM0_A3 IN ('PLW')"
create_region_s "PG" "ADM0_A3 IN ('PNG')"
create_region_s "PL" "ADM0_A3 IN ('POL')"
create_region_s "PR" "ADM0_A3 IN ('PRI')"
create_region_s "KP" "ADM0_A3 IN ('PRK')"
create_region_s "PT" "ADM0_A3 IN ('PRT')"
create_region_s "PY" "ADM0_A3 IN ('PRY')"
create_region_s "PS" "ADM0_A3 IN ('PSE')"
create_region_s "PF" "ADM0_A3 IN ('PYF')"
create_region_s "QA" "ADM0_A3 IN ('QAT')"
create_region_s "RO" "ADM0_A3 IN ('ROU')"
create_region_s "RU" "ADM0_A3 IN ('RUS')"
create_region_s "RW" "ADM0_A3 IN ('RWA')"
create_region_s "EH" "ADM0_A3 IN ('EH')"
create_region_s "SA" "ADM0_A3 IN ('SAU')"
create_region_s "SD" "ADM0_A3 IN ('SDN')"
create_region_s "SS" "ADM0_A3 IN ('SDN')"
create_region_s "SN" "ADM0_A3 IN ('SEN')"
create_region_s "SG" "ADM0_A3 IN ('SGP')"
create_region_s "GS" "ADM0_A3 IN ('SGS')"
create_region_s "SH" "ADM0_A3 IN ('SHN')"
create_region_s "SB" "ADM0_A3 IN ('SLB')"
create_region_s "SL" "ADM0_A3 IN ('SLE')"
create_region_s "SV" "ADM0_A3 IN ('SLV')"
create_region_s "SM" "ADM0_A3 IN ('SMR')"
create_region_s "SO" "ADM0_A3 IN ('SOM')"
create_region_s "SO" "ADM0_A3 IN ('SOM')"
create_region_s "PM" "ADM0_A3 IN ('SPM')"
create_region_s "RS" "ADM0_A3 IN ('SRB')"
create_region_s "ST" "ADM0_A3 IN ('STP')"
create_region_s "SR" "ADM0_A3 IN ('SUR')"
create_region_s "SK" "ADM0_A3 IN ('SVK')"
create_region_s "SI" "ADM0_A3 IN ('SVN')"
create_region_s "SE" "ADM0_A3 IN ('SWE')"
create_region_s "SZ" "ADM0_A3 IN ('SWZ')"
create_region_s "SX" "ADM0_A3 IN ('SXM')"
create_region_s "SC" "ADM0_A3 IN ('SYC')"
create_region_s "SY" "ADM0_A3 IN ('SYR')"
create_region_s "TC" "ADM0_A3 IN ('TCA')"
create_region_s "TD" "ADM0_A3 IN ('TCD')"
create_region_s "TG" "ADM0_A3 IN ('TGO')"
create_region_s "TH" "ADM0_A3 IN ('THA')"
create_region_s "TJ" "ADM0_A3 IN ('TJK')"
create_region_s "TM" "ADM0_A3 IN ('TKM')"
create_region_s "TL" "ADM0_A3 IN ('TLS')"
create_region_s "TO" "ADM0_A3 IN ('TON')"
create_region_s "TT" "ADM0_A3 IN ('TTO')"
create_region_s "TN" "ADM0_A3 IN ('TUN')"
create_region_s "TR" "ADM0_A3 IN ('TUR')"
create_region_s "TW" "ADM0_A3 IN ('TWN')"
create_region_s "TZ" "ADM0_A3 IN ('TZA')"
create_region_s "UG" "ADM0_A3 IN ('UGA')"
create_region_s "UA" "ADM0_A3 IN ('UKR')"
create_region_s "UY" "ADM0_A3 IN ('URY')"
create_region_s "US" "ADM0_A3 IN ('USA')"
create_region_s "UZ" "ADM0_A3 IN ('UZB')"
create_region_s "VA" "ADM0_A3 IN ('VAT')"
create_region_s "VC" "ADM0_A3 IN ('VCT')"
create_region_s "VE" "ADM0_A3 IN ('VEN')"
create_region_s "VG" "ADM0_A3 IN ('VGB')"
create_region_s "VI" "ADM0_A3 IN ('VIR')"
create_region_s "VN" "ADM0_A3 IN ('VNM')"
create_region_s "VU" "ADM0_A3 IN ('VUT')"
create_region_s "WF" "ADM0_A3 IN ('WLF')"
create_region_s "WS" "ADM0_A3 IN ('WSM')"
create_region_s "YE" "ADM0_A3 IN ('YEM')"
create_region_s "ZA" "ADM0_A3 IN ('ZAF')"
create_region_s "ZM" "ADM0_A3 IN ('ZMB')"
create_region_s "ZW" "ADM0_A3 IN ('ZWE')"