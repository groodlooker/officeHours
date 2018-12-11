connection: "postgres-sales-transactions"

# include all the views
include: "*.view"

datagroup: office_hours_default_datagroup {
  sql_trigger: SELECT MAX(order_date) FROM order_info;;
  max_cache_age: "1 hour"
}

access_grant: true_heir_to_the_throne {
  allowed_values: ["Targaryen","All"]
  user_attribute: house
}

access_grant: finance_department {
  allowed_values: ["finance"]
  user_attribute: department
}

persist_with: office_hours_default_datagroup

explore: orders {
  join: customer_facts {
    sql_on: ${orders.customer_name} = ${customer_facts.customer_name} ;;
    relationship: many_to_one
    type: inner
  }
  join: table_calculations {
    required_access_grants: [true_heir_to_the_throne]
    sql_on: ${orders.product_name} = ${table_calculations.product_name}
    and DATE_TRUNC('year', orders.order_date ) = ${table_calculations.order_year}
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
