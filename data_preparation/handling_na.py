import pandas as pd
# df=pd.read_csv("clean_olist_products_dataset.csv")
# for column in df.columns:
#     # Check if the column is of object type (string)
#     if df[column].dtype == 'object':
#         df[column].fillna('unknown', inplace=True)
#     elif df[column].dtype in ['int64', 'float64']:
#         df[column].fillna(df[column].median(), inplace=True)
# df.to_csv("clean_olist_products_dataset.csv", index=False, encoding='utf-8')
df=pd.read_csv("clean_olist_order_reviews_dataset.csv", usecols=["review_id", "order_id", "review_score", "review_creation_date", "review_answer_timestamp"])
for column in df.columns:
    # Check if the column is of object type (string)
    if df[column].dtype == 'object':
        df[column].fillna('unknown', inplace=True)
df.to_csv("clean_olist_order_reviews_dataset.csv", index=False, encoding='utf-8')