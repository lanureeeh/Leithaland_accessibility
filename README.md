# Leithaland Accessibility Map

Interactive map of travel times to PT stops, schools, and kindergartens by walking and cycling in the Leithaland KLAR! region (Austria).

## Live map

**https://lanureeeh.github.io/Leithaland_accessibility/**

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

1. Push this repo (if not already done):
   ```bash
   git remote add origin https://github.com/lanureeeh/Leithaland_accessibility.git
   git push -u origin main
   ```
3. On GitHub: **Settings** → **Pages** → **Source**: Deploy from branch → `main` → `/docs` → Save.
4. The site will be at https://lanureeeh.github.io/Leithaland_accessibility/

**Updating the map:** Run `python scripts/convert_gpkg_to_geojson.py`, then `bash scripts/update_docs_for_github_pages.sh`, commit and push.
