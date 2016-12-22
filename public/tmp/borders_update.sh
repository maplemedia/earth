## this only needs to run when these data sources are updated
wget "http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/50m/physical/ne_50m_coastline.zip"
wget "http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/50m/physical/ne_50m_lakes.zip"
wget "http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/110m/physical/ne_110m_coastline.zip"
wget "http://www.naturalearthdata.com/http//www.naturalearthdata.com/download/110m/physical/ne_110m_lakes.zip"
unzip -o ne_\*.zip
rm *.zip
ogr2ogr -f GeoJSON coastline_50m.json ne_50m_coastline.shp
ogr2ogr -f GeoJSON coastline_110m.json ne_110m_coastline.shp
ogr2ogr -f GeoJSON -where "scalerank < 4" lakes_50m.json ne_50m_lakes.shp
ogr2ogr -f GeoJSON -where "scalerank < 2 AND admin='admin-0'" lakes_110m.json ne_110m_lakes.shp
ogr2ogr -f GeoJSON -simplify 1 coastline_tiny.json ne_110m_coastline.shp
ogr2ogr -f GeoJSON -simplify 1 -where "scalerank < 2 AND admin='admin-0'" lakes_tiny.json ne_110m_lakes.shp
topojson -o earth-topo.json coastline_50m.json coastline_110m.json lakes_50m.json lakes_110m.json
topojson -o earth-topo-mobile.json coastline_110m.json coastline_tiny.json lakes_110m.json lakes_tiny.json
cp earth-topo*.json ../data/
rm *.shp *.json *.prj *.html *.txt *.shx
