# Scripts

| Script                           | Purpose                                              |
|----------------------------------|------------------------------------------------------|
| `convert_gpkg_to_geojson.py`     | Convert GeoPackage → GeoJSON for web map             |
| `convert_gpkg_to_geojson.sh`     | Same, using GDAL ogr2ogr                             |
| `update_docs_for_github_pages.sh`| Run conversion and prepare docs for deploy           |

Sources: `results/grids/no_buffers/`, `data/networks/`, `data/destinations/`, `data/boundaries/`.
Output: `docs/data/*.geojson`. Run from project root.
