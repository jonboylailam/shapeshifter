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

    topojson -o $tmpDir/tmp.json -q 1e5 --id-property=+ISO_N3 -p iso_a2=ISO_A2,adm0_a3=ADM0_A3,name=NAME -- land=$3 countries=$3
    topojson-merge -o $1 --io=land --oo=land --no-key -- $tmpDir/tmp.json
    rm -rf $tmpDir
}

generate_topojson () {
    create_shp "$1-s.shp" "$2" "ne_10m_admin_0_countries.shp"
    create_topojson "out/json/groups/$1/topo-s.json" "ne_10m_land.shp" "out/$1-s.shp/$1-s.shp"
}

generate_topojson "southern-african-development-community" "ADM0_A3 IN ('AGO','BWA','COD','LSO','MDG','MWI','MUS','MOZ','NAM','SYC','ZAF','SWZ','TZA','ZMB','ZWE')"
generate_topojson "southern-africa-un" "ADM0_A3 IN ('BWA','LSO','NAM','ZAF','SWZ')"
generate_topojson "eastern-africa-un" "ADM0_A3 IN ('BDI','COM','DJI','ERI','ETH','KEN','MDG','MWI','MUS','MOZ','RWA','SYC','SOM','SDS','UGA','TZA','ZMB','ZWE')"
generate_topojson "central-africa-un" "ADM0_A3 IN ('AGO','CMR','CAF','TCD','COG','COD','GNQ','GAB','STP')"
generate_topojson "northern-africa-un" "ADM0_A3 IN ('DZA','EGY','LBY','MAR','SDN','TUN','SAH')"
generate_topojson "western-africa-un" "ADM0_A3 IN ('BEN','BFA','CPV','CIV','GMB','GHA','GIN','GNB','LBR','MLI','MRT','NER','NGA','SEN','SLE','TGO')"
generate_topojson "sub-saharan-africa-un" "ADM0_A3 IN ('BWA','LSO','NAM','ZAF','SWZ','BDI','COM','DJI','ERI','ETH','KEN','MDG','MWI','MRT','MOZ','RWA','SYC','SOM','SDS','UGA','TZA','ZMB','ZWE','AGO','CMR','CAF','TCD','COG','COD','GNQ','GAB','STP','BEN','BFA','CPV','CIV','GMB','GHA','GIN','GNB','LBR','MLI','MRT','NER','NGA','SHN','SEN','SLE','TGO','SDN')"
generate_topojson "caribbean-un" "ADM0_A3 IN ('AIA','ATG','ABW','BHS','BRB','VGB','CYM','CUB','CUW','DMA','DOM','GRD','HTI','JAM','MSR','PRI','BLM','KNA','LCA','MAF','VCT','SXM','TTO','TCA','VIR')"
generate_topojson "central-america-un" "ADM0_A3 IN ('BLZ','CRI','SLV','GTM','HND','MEX','NIC','PAN')"
generate_topojson "northern-america-un" "ADM0_A3 IN ('BMU','CAN','GRL','SPM','USA')"
generate_topojson "central-asia-un" "ADM0_A3 IN ('KAZ','KGZ','TJK','TKM','UZB')"
generate_topojson "eastern-asia-un" "ADM0_A3 IN ('CHN','HKG','MAC','PRK','JPN','MNG','KOR')"
generate_topojson "south-eastern-asia-un" "ADM0_A3 IN ('BRN','KHM','IDN','LAO','MYS','MMR','PHL','SGP','THA','TLS','VNM')"
generate_topojson "southern-asia-un" "ADM0_A3 IN ('AFG','BGD','BTN','IND','IRN','MDV','NPL','PAK','LKA')"
generate_topojson "western-asia-un" "ADM0_A3 IN ('ARM','AZE','BHR','CYP','GEO','IRQ','ISR','JOR','KWT','LBN','OMN','QAT','SAU','PSX','SYR','TUR','ARE','YEM')"
generate_topojson "eastern-europe-un" "ADM0_A3 IN ('BLR','BGR','CZE','HUN','POL','MDA','ROU','RUS','SVK','UKR')"
generate_topojson "northern-europe-un" "ADM0_A3 IN ('ALD','DNK','EST','FRO','FIN','GGY','ISL','IRL','IMN','JEY','LVA','LTU','NOR','SWE','GBR')"
generate_topojson "southern-europe-un" "ADM0_A3 IN ('ALB','AND','BIH','HRV','GRC','VAT','ITA','MLT','MNE','PRT','SMR','SRB','SVN','ESP','MKD')"
generate_topojson "western-europe-un" "ADM0_A3 IN ('AUT','BEL','FRA','DEU','LIE','LUX','MCO','NLD','CHE')"
generate_topojson "australia-and-new-zealand-un" "ADM0_A3 IN ('AUS','NZL','NFK')"
generate_topojson "melanesia-un" "ADM0_A3 IN ('FJI','NCL','PNG','SLB','VUT')"
generate_topojson "micronesia-un" "ADM0_A3 IN ('GUM','KIR','MHL','FSM','NRU','MNP','PLW')"
generate_topojson "polynesia-un" "ADM0_A3 IN ('ASM','COK','PYF','NIU','PCN','WSM','TON','WLF')"