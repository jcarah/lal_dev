connection: "thelook_events_redshift"

include: "/refinements/*.view"
include: "/views/*.view.lkml"                # include all views in the views/ folder in this project
# include: "/refinements/*.view.lkml"

# explore: events {


# }

explore: events_new {

}

explore: users {}
