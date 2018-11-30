view: table_calculations {
  derived_table: {

    explore_source: orders {
      column: product_name {}
      column: region {}
      column: order_year {field:orders.order_year}
      column: total_sales {}
      derived_column: product_rank_by_year_region {
        sql: RANK() OVER(PARTITION BY order_year, region ORDER BY total_sales desc) ;;
      }
      derived_column: product_rank_by_year {
        sql: RANK() OVER(PARTITION BY order_year ORDER BY total_sales desc) ;;
      }
      derived_column: product_rank_by_region {
        sql: RANK() OVER(PARTITION BY region ORDER BY total_sales desc) ;;
      }
      derived_column: row_num {
        sql: ROW_NUMBER() OVER() ;;
      }
    }
  }
  dimension: row_num {
    primary_key: yes
    hidden: yes
  }
  dimension: product_name {hidden:yes}
  dimension: region {hidden:yes}
  dimension: order_year {type:number hidden:yes}
  dimension: product_rank_by_year_region {
    view_label: "Product Rank Details"
    type: number
  }
  dimension: product_rank_by_year {
    view_label: "Product Rank Details"
    type: number
  }
  dimension: product_rank_by_region {
    view_label: "Product Rank Details"
    type: number
  }
#   Table calculations 1 look
  dimension: top_5_rank_by_yr_region {
    sql: ${product_rank_by_year_region} ;;
    view_label: "Product Rank Details"
    type: tier
    style: integer
    tiers: [5]
#     required_fields: [region,order_year]
  }
}
