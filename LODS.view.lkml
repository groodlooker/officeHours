include: "order_info_enhanced.view"

view: customer_facts {
  derived_table: {
    explore_source: orders {
      column: customer_name {}
      column: first_purchase {field:orders.min_order_date}
      column: lifetime_spend {field:orders.total_sales}
    }
  }
  dimension: customer_name {
    primary_key: yes
    hidden: yes
  }
  dimension_group: first_purchase {
    type: time
    timeframes: [
      month,
      year
    ]
  }
  dimension: lifetime_spend {
    type: number
  }
}

# If necessary, uncomment the line below to include explore_source.
# include: "office_hours.model.lkml"

view: overall_avg {
  derived_table: {
    explore_source: orders {
      column: average_order_size_d {field:orders.average_order_size}
      column: average_customer_spend_d {field:orders.average_customer_spend}
    }
  }
  dimension: average_order_size_d {
    type: number
    value_format_name: usd_0
  }
  measure: average_order_size {
    type: max
    value_format_name: usd_0
    sql: ${average_order_size_d} ;;
  }
  dimension: average_customer_spend_d {
    type: number
    value_format_name: usd_0
  }
  measure: average_customer_spend {
    type: max
    value_format_name: usd_0
    sql: ${average_customer_spend_d} ;;
  }
  dimension: pk {
    type: number
    hidden: yes
    sql: 1 ;;
  }
}
