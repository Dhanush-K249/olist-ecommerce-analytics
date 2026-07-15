import pandas as pd
# files_to_clean = [
#     "olist_order_payments_dataset.csv",
#     "olist_order_reviews_dataset.csv",
#     "olist_orders_dataset.csv",
#     "olist_products_dataset.csv",
#     "product_category_name_translation.csv"
# ]
# for file in files_to_clean:
#     #creating dataframe
#     df=pd.read_csv(file)
#     #changing coclumn names
#     df.columns.str.strip().str.replace(" ","_").str.lower()
#     output="clean_"+file
#     df.to_csv(output,index=False, encoding='utf-8')
df=pd.read_csv("clean_olist_products_dataset.csv")
print(df.isna().sum())