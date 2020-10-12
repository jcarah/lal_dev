connection: "thelook_events_redshift"

include: "/refinements/*.view"
include: "/views/*.view.lkml"                # include all views in the views/ folder in this project
# include: "/refinements/*.view.lkml"
explore: events {
  # join: pop_support {
  #   view_label: "PoP Support - Overrides and Tools" #(Optionally) Update view label for use in this explore here, rather than in pop_support view. You might choose to align this to your POP date's view label.
  #   relationship:one_to_one #we are intentionally fanning out, so this should stay one_to_one
  #   sql:{% if pop_support.periods_ago._in_query%}LEFT JOIN pop_support on 1=1{%endif%};;#join and fannout data for each prior_period included **if and only if** lynchpin pivot field (periods_ago) is selected. This safety measure ensures we dont fire any fannout join if the user selected PoP parameters from pop support but didn't actually select a pop pivot field.
  # }
}

explore: events_new {

}

explore: users {}
