connection: "postgres-sales-transactions"

# include all the views
include: "*.view"

datagroup: office_hours_default_datagroup {
  sql_trigger: SELECT MAX(order_date) FROM order_info;;
  max_cache_age: "1 hour"
}

persist_with: office_hours_default_datagroup

# - explore: date_dimension

# - explore: order_info

# - explore: regional_managers

explore: orders {
  join: customer_facts {
    sql_on: ${orders.customer_name} = ${customer_facts.customer_name} ;;
    relationship: many_to_one
    type: inner
  }
  join: table_calculations {
    sql_on: ${orders.product_name} = ${table_calculations.product_name}
    and ${orders.order_year} = ${table_calculations.order_year}
    and ${orders.region} = ${table_calculations.region};;
    relationship: many_to_one
    type: inner
  }
  join: overall_avg {
    sql_on: 1 = 1 ;;
    relationship: one_to_one
    type: inner
  }
}
