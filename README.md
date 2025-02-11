# healthcare-analytics
Let's play around with some sample healthcare data

PROMPT 1

On querying the providers and encounters_details tables, we see that there are 23 distinct providers in each table. However, the providers table contains a missing npi belonging to “Ortega-Garcia, Jose-Raul”, while the encounters_details table contains the missing npi (1992787402). Since this is the only provider without an npi, I have manually assigned npi 1992787402 to Jose-Raul Ortega-Garcia.

The final table is at the npi grain, where I have calculated the following metrics:

top_procedure: This is the most successful procedure performed by each provider, using their success rate as a ranking mechanism. If 2 or more procedures have the same success rate, then the number of times the provider has done the procedure takes precedence, and if that is also equal, then the generally more common procedure wins. This will help see which procedure each provider excels at.

total_encounters: Total number of encounters for that provider.

incoming_demand: The total number of patients that need that particular top_procedure who live in the same zip code as the provider. Can be used along with other metrics to decide where to route incoming demand.

provider_avg_cost: This is the average amount they’ve charged per encounter, derived directly from the encounters_details table. This metric helps to figure out which providers could be the most cost effective.

adverse_event_count: Number of encounters with adverse events.

provider_success_rate: This is the ratio of successful encounters to all encounters for a provider. A “successful” encounter is defined as one with no entry in the adverse_events table. This metric could be used to ascertain which providers are getting the most optimal results for their patients.

in_network_employers: Count of distinct employers where the provider is in-network. Can be used along with other metrics to check if the size of the network needs to expand.

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
