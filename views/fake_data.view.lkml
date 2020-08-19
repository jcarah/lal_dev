view: fake_data {
  derived_table: {
    sql: select 100::int as val, 'British Columbia'::text as province, 'Vancouver'::text as city
          union all
         select 200::int as val, 'British Columbia'::text as province, 'Victoria'::text as city

          ;;
  }
  dimension: province {
    map_layer_name: canadian_provinces
    drill_fields: [city, value, province]
  }
  dimension: city {}
  measure: value {
    type: sum
    sql: ${TABLE}.val ;;
  }
dimension: text{
  sql: 1 ;;
  html:
<div class="alert vis">
  <h1>
     <b>TARGETINGNOW POST SUMMARY</b>
     <p style="color:#EECE8D;">__________________________________________________________</p>
     <b>TARGETINGNOW</b> works within the constraints of your regular media plan with a twist. We add a layer of optimization to your plan so that you receive a guaranteed increase in your target impressions.
  </h1>
</div>
  ;;
}
}
