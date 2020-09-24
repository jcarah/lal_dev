view: turner {
  derived_table: {
    sql: with turner_base as (
      SELECT 'Mobile' AS Modality,123 AS Person_ID,array_construct('A', 'B', 'D') AS Audience, 'site_1' as site
      UNION ALL
      SELECT 'CTV',NULL,NULL, 'site_1'
      UNION ALL
      SELECT 'Desktop',NULL,NULL, 'site_1'
      UNION ALL
      SELECT 'Desktop',234,array_construct('A', 'C'), 'site_1'
      UNION ALL
      SELECT 'CTV',345,array_construct('B', 'C', 'D'), 'site_1'
      UNION ALL
      SELECT 'Mobile',NULL,NULL, 'site_2'
      UNION ALL
      SELECT 'CTV',345,array_construct('B', 'C', 'D'), 'site_2'
      UNION ALL
      SELECT 'Desktop',234,array_construct('A', 'C'), 'site_1'
      UNION ALL
      SELECT 'Mobile',NULL,NULL, 'site_1'
      UNION ALL
      SELECT 'Mobile',456,array_construct('C'), 'site_2'
      UNION ALL
      SELECT 'Mobile',567,array_construct('B', 'D'), 'site_1'
      UNION ALL
      SELECT 'Desktop',789,array_construct('A', 'B', 'C', 'D'), 'site_1'
      UNION ALL
      SELECT 'CTV',NULL,NULL, 'site_2'
      UNION ALL
      SELECT 'Desktop',789,array_construct('A', 'B', 'C', 'D'), 'site_1'
      UNION ALL
      SELECT 'Mobile',NULL,NULL, 'site_1'
      UNION ALL
      SELECT 'CTV',NULL,NULL, 'site_2'
      ),

      // First transform
      turner_flatten as(
      select modality, site, person_id, value as audience
      from turner_base, lateral flatten( input => audience) audience
      )

      select
          {% if modality._is_selected %}
              foo.modality,
           {% endif %}
          {% if site._is_selected %}
            foo.site,
          {% endif %}
          foo.audience,
          impressions,
          total_audience_impressions,
          total_impressions
      from
        (
          select
            audience,
            {% if modality._is_selected %}
              modality,
            {% endif %}
            {% if site._is_selected %}
              site,
            {% endif %}
              'a' -- comma buffer
            ,
            count(*) as impressions
          from turner_flatten
          group by
            audience,
            {% if modality._is_selected %}
                modality,
            {% endif %}
            {% if site._is_selected %}
              site,
            {% endif %}
              'a' -- comma buffer
          -- I would add templated filters here
        ) foo
      left join
          (
          select
            {% if modality._is_selected %}
              modality,
            {% endif %}
            {% if site._is_selected %}
              site,
            {% endif %}
              'a' -- comma buffer
            ,
            sum(case when audience is not null then 1 end) as total_audience_impressions,
            count(*) as total_impressions
            from turner_base
            group by
            {% if modality._is_selected %}
                modality,
            {% endif %}
            {% if site._is_selected %}
              site,
            {% endif %}
            'a' -- comma buffer
            -- I would add templated filters here
          ) bar
      on
       1=1 -- in case no dimensions selected
        {% if modality._is_selected %}
          AND foo.modality = bar.modality
        {% endif %}
        {% if site._is_selected %}
          AND foo.site = bar.site
        {% endif %}
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: modality {
    type: string
    sql: ${TABLE}."MODALITY" ;;
  }
  dimension: site {
    type: string
    sql: ${TABLE}."SITE" ;;
  }

  dimension: audience {
    type: string
    sql: ${TABLE}."AUDIENCE" ;;
  }

  dimension: impressions {
    type: number
    sql: ${TABLE}."IMPRESSIONS" ;;
  }

  dimension: total_audience_impressions {
    type: number
    sql: ${TABLE}."TOTAL_AUDIENCE_IMPRESSIONS" ;;
  }

  dimension: total_impressions {
    type: number
    sql: ${TABLE}."TOTAL_IMPRESSIONS" ;;
  }

  set: detail {
    fields: [modality, audience, impressions, total_audience_impressions, total_impressions]
  }
}
explore: turner {}
