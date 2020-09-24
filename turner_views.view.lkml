view: turner_base {
  derived_table: {
    sql: SELECT 'Mobile' AS Modality,123 AS Person_ID,array_construct('A', 'B', 'D') AS Audience
      UNION ALL
      SELECT 'CTV',NULL,NULL
      UNION ALL
      SELECT 'Desktop',NULL,NULL
      UNION ALL
      SELECT 'Desktop',234,array_construct('A', 'C')
      UNION ALL
      SELECT 'CTV',345,array_construct('B', 'C', 'D')
      UNION ALL
      SELECT 'Mobile',NULL,NULL
      UNION ALL
      SELECT 'CTV',345,array_construct('B', 'C', 'D')
      UNION ALL
      SELECT 'Desktop',234,array_construct('A', 'C')
      UNION ALL
      SELECT 'Mobile',NULL,NULL
      UNION ALL
      SELECT 'Mobile',456,array_construct('C')
      UNION ALL
      SELECT 'Mobile',567,array_construct('B', 'D')
      UNION ALL
      SELECT 'Desktop',789,array_construct('A', 'B', 'C', 'D')
      UNION ALL
      SELECT 'CTV',NULL,NULL
      UNION ALL
      SELECT 'Desktop',789,array_construct('A', 'B', 'C', 'D')
      UNION ALL
      SELECT 'Mobile',NULL,NULL
      UNION ALL
      SELECT 'CTV',NULL,NULL
       ;;
  }

  measure: total_impressions {
    type: count
    drill_fields: [detail*]
  }
#   measure:  {}

  dimension: modality {
    type: string
    sql: ${TABLE}."MODALITY" ;;
  }

  dimension: person_id {
    type: number
    sql: ${TABLE}."PERSON_ID" ;;
  }

  dimension: audience {
    type: string
    sql: ${TABLE}."AUDIENCE" ;;
  }

  set: detail {
    fields: [modality, person_id, audience]
  }
}

view: turner_flatten {
  derived_table: {
    sql: select modality, person_id, value as audience
        from ${turner_base.SQL_TABLE_NAME}, lateral flatten( input => audience) audience
    ;;
  }
   dimension: modality {
    type: string
    sql: ${TABLE}."MODALITY" ;;
  }

  dimension: person_id {
    type: number
    sql: ${TABLE}."PERSON_ID" ;;
  }

  dimension: audience {
    type: string
    sql: ${TABLE}."AUDIENCE" ;;
  }
}

explore: turner_flatten {}
