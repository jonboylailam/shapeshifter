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
    create_topojson "out/json/continents/$1/topo-s.json" "ne_10m_land.shp" "out/$1-s.shp/$1-s.shp"
}

generate_topojson "europe" "ADM0_A3 IN ('AND','ALB','AUT','ALD','BIH','BEL','BGR','BLR','CHE','CYP','CZE','DEU','DNK','EST','ESP','FIN','FRO','FRA','GBR','GGY','GRC','HRV','HUN','IRL','IMN','ISL','ITA','JEY','LIE','LTU','LUX','LVA','MCO','MDA','MNE','MKD','MLT','NLD','NOR','POL','PRT','ROU','SRB','RUS','SWE','SVN','SVK','SMR','UKR','VAT')"
generate_topojson "asia" "ADM0_A3 IN ('ARE','AFG','ARM','AZE','BGD','BHR','BRN','BTN','CHN','GEO','HKG','IDN','ISR','IND','IOT','IRQ','IRN','JOR','JPN','KGZ','KHM','PRK','KOR','KWT','KAZ','LAO','LBN','LKA','MMR','MNG','MAC','MDV','MYS','NPL','OMN','PHL','PAK','PSX','QAT','SAU','SGP','SYR','THA','TJK','TKM','TUR','TWN','UZB','VNM','YEM')"
generate_topojson "north-america" "ADM0_A3 IN ('ATG','AIA','ABW','BRB','BLM','BMU','BHS','BLZ','CAN','CRI','CUB','CUW','DMA','DOM','GRD','GRL','GTM','HND','HTI','JAM','KNA','CYM','LCA','MAF','MSR','MEX','NIC','PAN','SPM','PRI','SLV','SXM','TCA','TTO','USA','VCT','VGB','VIR')"
generate_topojson "africa" "ADM0_A3 IN ('AGO','BFA','BDI','BEN','BWA','COD','CAF','COG','CIV','CMR','CPV','DJI','DZA','EGY','SAH','ERI','ETH','GAB','GHA','GMB','GIN','GNQ','GNB','KEN','COM','LBR','LSO','LBY','MAR','MDG','MLI','MRT','MUS','MWI','MOZ','NAM','NER','NGA','RWA','SYC','SDN','SHN','SLE','SEN','SOM','SDS','STP','SWZ','TCD','TGO','TUN','TZA','UGA','ZAF','ZMB','ZWE')"
generate_topojson "antarctica" "ADM0_A3 IN ('SGS','HMD','ATF')"
generate_topojson "south-america" "ADM0_A3 IN ('ARG','BOL','BRA','CHL','COL','ECU','FLK','GUY','PER','PRY','SUR','URY','VEN')"
generate_topojson "oceania" "ADM0_A3 IN ('ASM','AUS','COK','FJI','FSM','GUM','KIR','MHL','MNP','NCL','NFK','NRU','NIU','NZL','PYF','PNG','PCN','PLW','SLB','TLS','TON','VUT','WLF','WSM')"
