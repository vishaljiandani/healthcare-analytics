# healthcare-analytics
Let's play around with some sample healthcare data by answering the prompts below.

### PROMPT 1

Given the data provided:
1a) construct an aggregate provider table(s) (using NPI as a unique identifier). This table should seek to:
1. Allow Product, Clinical, and Operations teams to easily gain insight and answer business questions about these providers, and
2. Serve as a feature store to feed machine learning models

Examples of questions users might want to answer are listed below:

● Which providers are likely to be the most cost effective?
● Do certain providers specialize or excel in particular types of procedures?
● How might we understand which providers garner the most optimal results for their patients?
● How will we know when we need to expand our network of providers?
● Where should we ideally be routing incoming demand?

PROMPT 2

The final table is at the patient grain, and contains results from the patients table as well as the referrals table - since both tables contain a distinct set of patients.

Since the patients table does not contain information on the procedure that was done or their zip code, I had to get this information from the encounters_details and providers tables. Since patients only saw providers in the same zip code, their provider’s zip code was used to get each patient's zip code. I then merged this table with the referrals table to create the final updated patients table.

Note that it is not possible to identify a patient’s employer because a patient can see a provider that can belong to multiple employers as part of the network. I’ve hence only included employer_id from the referrals table.

PROMPT 3

3a.
Ingestion Layer:
Use a data ingestion framework like Apache Kafka or AWS Kinesis for streaming data like Health Information Exchange feeds.
For batch transfers, use an ETL workflow orchestrator like Apache Airflow to fetch periodic data like claims files or patient demographics.

Data Validation & Transformation Layer:
Implement a data validation framework like Great Expectations to handle schema validation.
Data quality rules to detect missing, duplicate, or invalid data.
Use Apache Spark or Databricks to process data at scale, transforming raw source data into standardized formats.

Data Storage Layer:
Use a data lake architecture like Google Cloud Storage for raw, semi-structured, and structured data.
* Raw Zone: Stores raw ingested data as-is.
* Processed Zone: Stores normalized and cleaned data.
* Curated Zone: Maintains aggregated tables.

Create a data warehouse like Snowflake or Google BigQuery for downstream analytical queries and dashboards.

Aggregation & Analytics Layer:
Build reusable ETL/ELT processes for creating:
* Provider aggregation tables
* Patient tables

Use dbt for data transformations, version control and business logic.
.
Output Delivery Layer:
Expose processed data to internal tools using:
* APIs (e.g., sending aggregated provider/patient data to CRM platforms or Provider-Facing products).
* Data visualization tools like Tableau or Power BI for dashboards.

Integration with EHR systems using HL7/FHIR standards.

3b.
Data Volume Challenges
Rapid growth in claims, EHR, HIE, and referral data will stress storage and compute resources.
Using scalable cloud storage like BigQuery and distributed compute can solve this issue.

High cardinality data across NPIs, procedures or employers will increase query complexity.
Indexing and partitioning data by the correct dimensions can improve query performance.

HIPAA compliance and other security concerns.
Make use of features like row level security.

Data Variety Challenges
Inconsistent data formats and missing fields could undermine insights.
Use a data schema registry to enforce a schema.
Implement data imputation techniques.

Inconsistent data quality like anomalies and duplicates.
Implement data quality checks.
Flag missing data for manual review while allowing pipelines to continue processing valid data.

Data Velocity Challenges
Real-time streaming data may overwhelm processing systems if not correctly configured.
Use streaming processing tools like Kafka for real-time transformations.
Introduce micro batching for near real-time processing when full streaming isn’t required.

3c.
Claims Data: Provides granular cost and usage insights, enabling deeper analysis of provider efficiency and patient demands.

Patient Outcome Data: To improve metrics such as provider success rates by linking post-procedure outcomes.

Provider Credentialing Data: To validate provider NPIs, specialties, and certifications.

Real-Time Appointment Availability: To match patient referrals to providers with open slots, reducing wait times.

External Benchmarking Data: To compare provider performance against industry standards.
