connection: "thelook_events_redshift"

include: "/views/*.view.lkml"                # include all views in the views/ folder in this project
# include: "/refinements/*.view.lkml"
explore: events {

}

explore: users {}
