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


    topojson -o $tmpDir/tmp.json -q 1e5 --id-property=+iso_n3 -p -- land=shpfiles/$2 countries=$3
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

## Use the ogr2ogr command to generate the shp files we want
create_shp "world-no-antartica.shp" "ADM0_A3 NOT IN ('ATA')" "ne_50m_admin_0_countries.shp"
create_topojson "out/json/world/world-no-antartica.json" "ne_50m_land.shp" "out/world-no-antartica.shp/world-no-antartica.shp"

