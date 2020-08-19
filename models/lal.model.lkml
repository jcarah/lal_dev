connection: "thelook_events_redshift"

include: "/views/*.view.lkml"                # include all views in the views/ folder in this project

explore: events {

}

map_layer: canadian_provinces {
  format: "vector_tile_region"
  url: "https://a.tiles.mapbox.com/v4/looker-maps.oh_canada/{z}/{x}/{y}.mvt?access_token=@{mapbox_api_key}"
  feature_key: "provinces"
  extents_json_url: "https://rawcdn.githack.com/dwmintz/looker_map_layers/c98a443cfd7dc93191a3f3f6c54059b9a35a9134/canada_provinces.json"
  min_zoom_level: 2
  max_zoom_level: 10
  property_key: "PRENAME"
}
explore: fake_data {}
