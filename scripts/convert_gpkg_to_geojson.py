#!/usr/bin/env python3
"""
Convert GeoPackage layers to GeoJSON for the accessibility map.
Run from project root: python scripts/convert_gpkg_to_geojson.py

Output: docs/data/*.geojson (used by GitHub Pages and local development)
"""

from pathlib import Path

try:
    import geopandas as gpd
except ImportError:
    print("Error: geopandas required. Install with: pip install geopandas")
    exit(1)

# Project root (parent of scripts/)
PROJECT_ROOT = Path(__file__).resolve().parent.parent
OUT_DIR = PROJECT_ROOT / "docs" / "data"
OUT_DIR.mkdir(parents=True, exist_ok=True)


def to_geojson(gdf: "gpd.GeoDataFrame", out_path: Path) -> None:
    """Write GeoDataFrame to GeoJSON in WGS84."""
    gdf = gdf.to_crs(epsg=4326)
    # Drop columns that don't serialize well
    for col in gdf.columns:
        if gdf[col].dtype == object and gdf[col].apply(lambda x: isinstance(x, (list, dict))).any():
            gdf = gdf.drop(columns=[col], errors="ignore")
    gdf.to_file(out_path, driver="GeoJSON")


def convert_gridded() -> None:
    """Convert gridded accessibility layers (polygons with travel_time_min)."""
    gridded_dir = PROJECT_ROOT / "results" / "grids" / "no_buffers"
    if not gridded_dir.exists():
        print("Skipping gridded: results/grids/no_buffers not found")
        return

    # Source files use "kindergarden" (legacy); output uses "kindergartens" (correct)
    file_map = [
        ("walk_pt_stops.gpkg", "walk_pt_stops.geojson"),
        ("walk_schools.gpkg", "walk_schools.geojson"),
        ("walk_kindergarden.gpkg", "walk_kindergartens.geojson"),
        ("bike_pt_stops.gpkg", "bike_pt_stops.geojson"),
        ("bike_schools.gpkg", "bike_schools.geojson"),
        ("bike_kindergarden.gpkg", "bike_kindergartens.geojson"),
    ]

    for src_name, out_name in file_map:
        p = gridded_dir / src_name
        if p.exists():
            try:
                gdf = gpd.read_file(p)
                # Ensure travel_time_min exists (or travel_time)
                if "travel_time_min" not in gdf.columns and "travel_time" in gdf.columns:
                    gdf["travel_time_min"] = gdf["travel_time"]
                to_geojson(gdf, OUT_DIR / out_name)
                print(f"  OK: {src_name} -> {out_name}")
            except Exception as e:
                print(f"  FAIL: {src_name}: {e}")
        else:
            print(f"  Skip: {src_name} not found")


def convert_networks() -> None:
    """Convert bike and walk network edge layers (LineString)."""
    networks_dir = PROJECT_ROOT / "data" / "networks"
    for name in ["bike_network", "walk_network"]:
        p = networks_dir / f"{name}.gpkg"
        if not p.exists():
            print(f"  Skip: {name}.gpkg not found")
            continue
        try:
            layers = gpd.list_layers(p)
            # Prefer 'edges' layer (OSMnx convention), else first layer
            layer_name = None
            if hasattr(layers, "columns") and "name" in layers.columns:
                for ln in layers["name"]:
                    if str(ln).lower() == "edges":
                        layer_name = str(ln)
                        break
                if layer_name is None and len(layers) > 0:
                    layer_name = str(layers["name"].iloc[0])
            else:
                for ln, _ in layers:
                    if str(ln).lower() == "edges":
                        layer_name = str(ln)
                        break
                if layer_name is None and layers:
                    layer_name = str(layers[0][0])

            gdf = gpd.read_file(p, layer=layer_name)
            if "geometry" in gdf.columns and gdf.geometry.notna().all():
                if gdf.geometry.is_empty.any():
                    gdf = gdf[~gdf.geometry.is_empty]
            to_geojson(gdf, OUT_DIR / f"{name}.geojson")
            print(f"  OK: {name}.gpkg -> {name}.geojson")
        except Exception as e:
            print(f"  FAIL: {name}.gpkg: {e}")


def convert_destinations() -> None:
    """Convert destination point layers."""
    dest_dir = PROJECT_ROOT / "data" / "destinations"
    if not dest_dir.exists():
        print("Skipping destinations: data/destinations not found")
        return

    for name in ["pt_stops", "kindergartens", "schools"]:
        p = dest_dir / f"{name}.gpkg"
        if not p.exists():
            print(f"  Skip: {name}.gpkg not found")
            continue
        try:
            gdf = gpd.read_file(p)
            to_geojson(gdf, OUT_DIR / f"{name}.geojson")
            print(f"  OK: {name}.gpkg -> {name}.geojson")
        except Exception as e:
            print(f"  FAIL: {name}.gpkg: {e}")


def convert_boundary() -> None:
    """Convert study area boundary for context."""
    boundaries_dir = PROJECT_ROOT / "data" / "boundaries"
    for cand in [
        boundaries_dir / "leithaland_4326.gpkg",
        boundaries_dir / "leithaland_4326_dissolved.shp",
    ]:
        if cand.exists():
            try:
                gdf = gpd.read_file(cand)
                gdf = gdf.to_crs(epsg=4326)
                gdf.to_file(OUT_DIR / "boundary.geojson", driver="GeoJSON")
                print(f"  OK: boundary -> boundary.geojson")
                return
            except Exception as e:
                print(f"  FAIL boundary: {e}")
    print("  Skip: no boundary file found")


def main() -> None:
    print("Converting GeoPackage layers to GeoJSON for web map...")
    print(f"Output directory: {OUT_DIR}")
    print("\nGridded layers:")
    convert_gridded()
    print("\nNetworks:")
    convert_networks()
    print("\nDestinations:")
    convert_destinations()
    print("\nBoundary:")
    convert_boundary()
    print("\nDone. GeoJSON files written to docs/data/")


if __name__ == "__main__":
    main()
