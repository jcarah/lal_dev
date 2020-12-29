view: events {
  sql_table_name: public.events ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

# dimension: foo {sql:${bar}}

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension: type_id {
    type: number
    sql: ${TABLE}.type_id ;;
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  dimension: value {
    type: string
    sql: ${TABLE}.value ;;
  }

  dimension: is_yesterday {
    type: yesno
    sql: ${created_date} = date(dateadd(day, -1, current_date)) ;;
  }

  dimension: is_two_days_ago {
    type: yesno
    sql: ${created_date} = date(dateadd(day, -2, current_date)) ;;
  }

  measure: count {
    type: count
    drill_fields: [id, users.first_name, users.last_name, users.id]
  }
}

view: events_new {
  extends: [events]
  measure: count {
    type: number
    sql: case when date_part(dow, ${created_date}) = 6
      then sum(${user_id}) else count(*) end
    ;;
  }
}
