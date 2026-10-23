import pandas as pd

df = pd.read_csv("supply_chain_data.csv")
df.columns = df.columns.str.lower().str.replace(" ", "_")

# ----------------- basic information---------------
print(df.info())
print(df.describe())
print(df.shape)
print(df.columns)

#------------------sales and product performance---------

highest_revenue = df.groupby("product_type")["revenue_generated"].sum().sort_values(ascending=False)
print(highest_revenue)

print("Max sale:",df["sku"].max())
print("Min sale:",df["sku"].min())

high_sales = df.groupby("product_type")["revenue_generated"].sum().sort_values(ascending=False)
print(high_sales)



# Aggregate sales and revenue for each product

product_analysis = (
    df.groupby("sku")
    .agg(
        total_units_sold=("number_of_products_sold", "sum"),
        total_revenue=("revenue_generated", "sum")
    )
    .reset_index()
).head(10).sort_values

print(product_analysis)

#What percentage of total sales comes from each category

category_sales = df.groupby("product_type").agg(
    total_revenue=("revenue_generated", "sum")
)

category_sales["sales_percentage"] = (
    category_sales["total_revenue"]
    / df["revenue_generated"].sum()
    * 100
)

print(category_sales.sort_values(
    "sales_percentage", ascending=False
).round(2))

# ---------------- Inventory and demand analysis-------------------

#product have low or zero sales

product_stocks = df.groupby("product_type")["stock_levels"].sum().sort_values(ascending=False)
print(product_stocks)

zero_stocks = df[df["stock_levels"]==0]
print(zero_stocks[["sku","product_type","stock_levels"]])


low_stock = df[
    (df["stock_levels"] > 0) &
    (df["stock_levels"] <= 10)
]

print(low_stock[["sku", "product_type", "stock_levels"]])

low_or_zero_stocks = df[df["stock_levels"]<=10]

print(
    low_or_zero_stocks[
        ["sku","product_type","stock_levels"]
    ].sort_values("stock_levels")
)

#product sells well but has low inventory
#  revenue generated and stocks 

low_inventory = df.groupby("product_type")["revenue_generated"].sum().sort_values(ascending= False)
print(low_inventory)

#combine 

good_sales_and_low_inventory = df[df["stock_levels"]<=10]
print(
    good_sales_and_low_inventory[
        ["product_type","revenue_generated","stock_levels"]
    ].sort_values("revenue_generated")

)


good_sales_and_low_inventory = df[
    (df["stock_levels"]<=10) &
    (df["number_of_products_sold"] >=500)
]

print(
    good_sales_and_low_inventory[
        ["product_type","number_of_products_sold",
         "revenue_generated","stock_levels"]
    ].sort_values("number_of_products_sold",ascending=False)
)

#-------------------Logistics and transportation analysis----------------

#Which transportation mode has the lowest average cost?
lowest_average = df.groupby("transportation_modes")["costs"].mean().sort_values()
print(lowest_average.idxmax)

#-------------------Quality control analysis-----------------------

high_defect = df.groupby("supplier_name")["defect_rates"].max().sort_values(ascending=False)
print(high_defect.head(5))

#What percentage of inspections passed, failed, or remain pending?

inspection_percentage = df["inspection_results"].value_counts(normalize=True) * 100
print(inspection_percentage.round(2))

#Which product categories have higher defect rates

high_defect = df.groupby("product_type")["defect_rates"].sum().sort_values(ascending=False)
print(high_defect)

#-------------------Supplier performance analysis-----------------
#Which supplier has the lowest average manufacturing cost?
low_avg_manufacturing = df.groupby("supplier_name")["manufacturing_costs"].mean().sort_values()
print(low_avg_manufacturing)

#Which supplier has the highest average defect rate?

avg_defect_rate = df.groupby("supplier_name")["defect_rates"].mean().sort_values
print(avg_defect_rate)

#Which suppliers combine good quality with low costs?


good_quality_low_costs = df[
    (df["manufacturing_costs"] <= 50) &
    (df["defect_rates"] <= 2.5)
]

print(
    good_quality_low_costs[
        [
            "supplier_name",
            "sku",
            "manufacturing_costs",
            "defect_rates"
        ]
    ].sort_values(
        ["defect_rates", "manufacturing_costs"]
    ).head(10)
)

supplier_analysis = df.groupby("supplier_name").agg(
    avg_manufacturing_cost=("manufacturing_costs", "mean"),
    avg_defect_rate=("defect_rates", "mean"),
    product_count=("sku", "count")
)

print(
    supplier_analysis.sort_values(
        ["avg_defect_rate", "avg_manufacturing_cost"]
    )
)


numeric_df = df.select_dtypes(include="number")

correlation_matrix = numeric_df.corr()

print(correlation_matrix)

print(df[
    ["number_of_products_sold", "price",
     "production_volumes", "stock_levels"]
].corr())
