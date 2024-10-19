import pyodbc
import pandas as pd
from sqlalchemy import create_engine, exc

# Correct connection string format for SQLAlchemy
source_connection_string = "mssql+pyodbc://localhost/Wesal?driver=ODBC+Driver+17+for+SQL+Server&trusted_connection=yes&TrustServerCertificate=yes"
target_connection_string = "mssql+pyodbc://localhost/WesalPro?driver=ODBC+Driver+17+for+SQL+Server&trusted_connection=yes&TrustServerCertificate=yes"

try:
    # Create engines for both databases
    source_engine = create_engine(source_connection_string)
    target_engine = create_engine(target_connection_string)

    # Function to load table data from Wesal to WesalPro
    def load_table(source_table, target_table):
        try:
            # Read data from source database (Wesal)
            data = pd.read_sql(f"SELECT * FROM {source_table}", source_engine)
            
            # Write data to target database (WesalPro)
            data.to_sql(target_table, target_engine, if_exists='append', index=False)
            print(f"{target_table} data loaded successfully.")
        except exc.SQLAlchemyError as e:
            print(f"An error occurred while loading {target_table}: {e}")

    # Load data into DimCustomer
    load_table("dbo.CustomerProfiles", "DimCustomer")

    # Load data into DimFeedbackCategory
    load_table("dbo.FeedbackCategories", "DimFeedbackCategory")

    # Load data into FactFeedback
    load_table("dbo.FeedbackForms", "FactFeedback")

    # Load data into DimProductReview
    load_table("dbo.Reviews", "DimProductReview")

    # If you have a DimDate table, you need to process and convert dates correctly
    def load_date_table():
        try:
            # Fetching feedback dates from FeedbackForms
            query = """
            SELECT DISTINCT
                CONVERT(DATE, feedback_date) AS Date,
                YEAR(feedback_date) AS Year,
                MONTH(feedback_date) AS Month,
                DAY(feedback_date) AS Day
            FROM dbo.FeedbackForms
            """
            date_data = pd.read_sql(query, source_engine)

            # Generate unique DateID for DimDate
            date_data['DateID'] = range(1, len(date_data) + 1)

            # Load into DimDate table
            date_data.to_sql("DimDate", target_engine, if_exists='append', index=False)
            print("DimDate data loaded successfully.")
        except exc.SQLAlchemyError as e:
            print(f"An error occurred while loading DimDate: {e}")

    # Load data into DimDate
    load_date_table()

except exc.SQLAlchemyError as e:
    print(f"An error occurred during the data load: {e}")
