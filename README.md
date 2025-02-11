# healthcare-analytics
Let's play around with some sample healthcare data by answering the prompts below.

### PROMPT 1

Given the data provided:
Construct an aggregate provider table(s) (using NPI as a unique identifier). This table should seek to:
1. Allow Product, Clinical, and Operations teams to easily gain insight and answer business questions about these providers, and
2. Serve as a feature store to feed machine learning models

Examples of questions users might want to answer are listed below:

● Which providers are likely to be the most cost effective?

● Do certain providers specialize or excel in particular types of procedures?

● How might we understand which providers garner the most optimal results for their patients?

● How will we know when we need to expand our network of providers?

● Where should we ideally be routing incoming demand?

### PROMPT 2

As indicated in the encounters_details table (which you can assume was purchased in advance of go-live in this region so as to have visibility into cost data for a range of procedures performed by providers), assume that patients in the patients table only saw providers who were in their same zip code. The referrals table is meant to represent newly incoming requests for procedures for patients who are part of our rollout in the region for 3 new employers.

Construct an updated, all-time, patients table.
