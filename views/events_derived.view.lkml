include: "events.view.lkml"
view: +events {
  measure: big_count {
    sql: ${events.count} * 100 ;;
  }
}
