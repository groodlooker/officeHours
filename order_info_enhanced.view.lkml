view: orders {
  sql_table_name: public.order_info ;;

  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
  }

  dimension: city {
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
  }

  dimension: customer_id {
    type: string
    sql: ${TABLE}.customer_id ;;
  }

  dimension: customer_name {
    type: string
    sql: ${TABLE}.customer_name ;;
    drill_fields: [order_id,order_raw,product_name,total_sales,total_profit,average_discount]
    link: {
      label: "See Profile of {{value}}"
      url: "https://localhost:9999/dashboards/7?Customer%20Name={{value | url_encode }}"
  }
  }

  dimension: discount {
    type: number
    sql: ${TABLE}.discount ;;
  }

  dimension_group: order {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.order_date ;;
  }

  dimension: order_id {
    type: string
    sql: ${TABLE}.order_id ;;
  }

  dimension: postal_code {
    type: string
    sql: ${TABLE}.postal_code ;;
  }

  dimension: product_id {
    type: string
    sql: ${TABLE}.product_id ;;
  }

  dimension: product_name {
    type: string
    sql: ${TABLE}.product_name ;;
  }

  dimension: profit {
    type: number
    sql: ${TABLE}.profit ;;
  }

  dimension: quantity {
    type: number
    sql: ${TABLE}.quantity ;;
  }

  dimension: region {
    type: string
    sql: ${TABLE}.region ;;
  }

  dimension: row_id {
    type: number
    primary_key: yes
    sql: ${TABLE}.row_id ;;
  }

  dimension: sales {
    type: number
    sql: ${TABLE}.sales ;;
  }

  dimension: segment {
    type: string
    sql: ${TABLE}.segment ;;
  }

  dimension_group: ship {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.ship_date ;;
  }

  dimension: ship_mode {
    type: string
    sql: ${TABLE}.ship_mode ;;
  }

  dimension: state {
    type: string
    map_layer_name: us_states
    sql: ${TABLE}.state ;;
  }

  dimension: sub_category {
    type: string
    sql: ${TABLE}.sub_category ;;
  }

#   Parameters

  parameter: sub_category_comparison {
    type: string
    suggest_dimension: sub_category
  }

  parameter: measure_select {
    type: unquoted
    allowed_value: {
      label: "Total Sales"
      value: "sales"
    }
    allowed_value: {
      label: "Total Profit"
      value: "profit"
    }
  }

#   Parameterized Dimensions

  dimension: selected_subcategory {
    type: yesno
    sql: ${sub_category} = {% parameter sub_category_comparison %} ;;
  }

#   This section encapsulates the additional measures added to the model

  measure: total_sales {
    type: sum
    value_format_name: usd_0
    drill_fields: [order_id,order_date,product_id,total_sales,total_profit]
    sql: ${sales} ;;
  }

  measure: total_profit {
    type: sum
    value_format_name: usd_0
    sql: ${profit} ;;
  }

  measure: total_quantity {
    type: sum
    sql: ${quantity} ;;
  }

  measure: average_discount {
    type: average
    sql: ${discount} ;;
  }

  measure: selected_measure {
    type: sum
    label_from_parameter: measure_select
    sql: ${TABLE}.{% parameter measure_select %} ;;
  }

  measure: distinct_customer_count {
    type: count_distinct
    sql: ${customer_name} ;;
  }

#   ###################################
#   ###################################

#   "LOD" Calculations

#   {FIXED order_id : sum(sales) }
  dimension: total_order_size {
    type: number
    sql: (select sum(sales)
          from order_info o
          where o.order_id = ${TABLE}.order_id);;
  }

  measure: average_order_size {
    type: average
    value_format_name: usd_0
    sql: ${total_order_size} ;;
  }
#   {FIXED customer_id : sum(sales) }
  dimension: customer_total_spend {
    type: number
    value_format_name: usd_0
    sql: (select sum(sales)
          from order_info o
          where o.customer_id = ${TABLE}.customer_id);;
  }

  measure: average_customer_spend {
    type: average
    value_format_name: usd_0
    sql: ${customer_total_spend} ;;
  }

#   {FIXED customer_name : countd(order_id)}
  dimension: order_frequency {
    type: number
    sql: (select COUNT(DISTINCT order_id)
          from order_info o
          where o.customer_id = ${TABLE}.customer_id);;
  }
#   ###################################
#   ###################################

#   This section encapsulates measures added to calculate derived tables

  measure: min_order_date {
    type: date
    sql: min(${order_raw}) ;;
  }

  measure: count {
    type: count
    drill_fields: [customer_name, product_name]
  }
}
