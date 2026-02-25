# Leithaland Accessibility Map

Interactive map of travel times to PT stops, schools, and kindergartens by walking and cycling in the Leithaland KLAR! region (Austria).

## Live map

**https://[YOUR_USERNAME].github.io/Leithaland/**

## Local development

1. Convert GeoPackage to GeoJSON:
   ```bash
   python scripts/convert_gpkg_to_geojson.py
   ```

2. Run a local server:
   ```bash
   python -m http.server 8000
   ```

3. Open http://localhost:8000/leaflet/leithaland-accessibility-map/leaflet_map.html

## Deploying to GitHub Pages

1. Push this repo to GitHub.
2. Go to **Settings** → **Pages**.
3. Under **Source**, select **Deploy from a branch**.
4. Branch: `main`, Folder: `/docs`.
5. Save. The site will be at `https://YOUR_USERNAME.github.io/Leithaland/`.

After updating data, re-run the conversion script, copy the new GeoJSON files to `docs/data/`, then commit and push.
