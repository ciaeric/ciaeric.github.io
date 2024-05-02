---
layout: post
title: Flattening Nested JSON with BigQuery UDF and dbt Macros
subtitle: A workaround with limited ETL tooling
share-img: /assets/img/post22/socialshare.png
thumbnail-img: /assets/img/post22/avatar.png
tags:
- ETL
- Nested JSON
- Bigquery
- UDF
- dbt

published: true
---

Dealing with nested JSON data can feel like you’re trying to solve a puzzle where the pieces keep changing shapes. It's tricky, especially when you don't have access to heavy-duty tools like PySpark in Databricks that are built to tackle these kinds of jobs with ease.

So, what do you do when you're working within limitations? In this blog post, we’re going to break down a cool workaround using Google BigQuery's User-Defined Functions (UDFs) alongside dbt macros. This method lets you handle and transform nested JSON data right where it lives, using good old SQL and some clever dbt tricks.

I’ll walk through how to set this up with examples and code snippets that you can tweak and use in your projects. It’s all about making things easier and keeping your data pipelines running smoothly without needing extra tools.

Let’s get into how you can make your data work for you, not against you!

![socialshare](/assets/img/post22/socialshare.png)

### Challenges This Solution Addresses:

- **Inconsistency in JSON Objects:** JSON data can vary greatly in structure, especially when coming from different sources or systems. Fields might appear in some objects but not in others, making standard transformations tricky. This solution ensures that all potential fields are accounted for and extracted effectively.

- **Dynamic Extraction Without Manual Input:** Manually specifying fields to extract from JSON can be laborious and error-prone, especially as data structures evolve over time. I'll show you how to dynamically parse and flatten JSON data, adapting automatically to changes in the data structure without any manual intervention.

- **Ease of Replication and Reusability:** Instead of dealing with complicated configurations or bespoke scripts, my approach uses modular and reusable components. This makes it easy to replicate the process across different projects or datasets with minimal adjustments.

### Solution Logic Explained:

The core of this solution revolves around efficiently managing JSON data within BigQuery and dbt. Here’s a step-by-step breakdown of the logic:

1. **Extracting JSON Objects:**
   - First, identify and extract all objects from the column that holds JSON values. This is done by parsing the column to output each JSON object as an element in a list.

2. **Looping Through JSON Objects in dbt:**
   - Utilize BigQuery’s built-in function `json_extract_scalar` within a dbt model. This function is crucial for pulling out scalar values from the JSON objects.
   - Implement a for loop that iterates over the list of JSON objects. For each object, `json_extract_scalar` is used to extract specific data elements based on your needs.

This approach ensures that every piece of relevant data within any JSON object is identified and extracted without manual intervention, making the process dynamic and scalable.

### Step 1: Create a Recursive JavaScript UDF in BigQuery

To handle nested JSON data effectively, we need a function that can traverse through all levels of nesting to extract every key. We'll accomplish this by defining a JavaScript UDF in BigQuery. This UDF will use a recursive approach to navigate through both objects and arrays within the JSON structure.

We know in JavaScript, JSON.parse can directly help us to get the key from the object, but remember that we need feed output to `json_extract_scalar` later, so the output need to be entire key path, e.g. `product.detail.brand`

#### SQL to Create the UDF

```sql
CREATE OR REPLACE FUNCTION GetNestedJsonKeys(jsonStr STRING)
RETURNS ARRAY<STRING>
LANGUAGE js AS """
  function extractKeys(obj) {
    var keys = [];
    for (var key in obj) {
      if (obj.hasOwnProperty(key)) {
        keys.push(key);  // Add current key to the keys array
        if (typeof obj[key] === 'object') {  // Recursively handle nested objects and arrays
          keys = keys.concat(extractKeys(obj[key]));  // Concatenate keys from nested object or array
        }
      }
    }
    return keys;
  }

  var obj = JSON.parse(jsonStr);  // Parse the JSON string into an object
  return extractKeys(obj);        // Start extracting keys recursively
""";
```

#### Explanation:
We know in JavaScript, leveraging JSON.parse, we can get the key from the object easily, but remember that we need feed output to `json_extract_scalar` later, so the output need to be entire key path, e.g. `product.detail.brand`.
That's why for each key, if the value is another object (either nested object or array), it recursively calls extractKeys on it and concatenates the keys.

#### Example Output

Suppose your table `your_table` has a column `json_column` with the following nested JSON data:

```json
{
  "person": {
    "name": "John",
    "age": 30,
    "address": {
      "city": "New York",
      "zipcode": "10001"
    }
  }
},
{
  "product": {
    "name": "Laptop",
    "price": 1200,
    "specs": {
      "brand": "HP",
      "screen_size": 15.6
    }
  }
}
```
Running the above query will produce the following results displayed in a table:

| json_column                                                                                          | nested_json_keys                                                                  |
|------------------------------------------------------------------------------------------------------|-----------------------------------------------------------------------------------|
| `{"person": {"name": "John", "age": 30, "address": {"city": "New York", "zipcode": "10001"}}, "items": ["laptop", "phone"]}` | `["person.name", "person.age", "person.address.city", "person.address.zipcode"]`       |
| `{"product": {"name": "Laptop", "price": 1200, "specs": {"brand": "HP", "screen_size": 15.6}}}`       | `["product.name", "product.price", "product.specs.brand", "product.specs.screen_size"]`                  |

> **_NOTE:_** you can use on-start hook to create this UDF in dbt build, not going to display how to in this blog.


### Step 2: Create a dbt Macro to Utilize the UDF

To make our solution dynamic and reusable across different tables and JSON columns, we’ll encapsulate the logic into a dbt macro. This macro will call our previously created BigQuery UDF, extract all keys, and output them as a list.

#### dbt Macro Code

```sql
{% macro get_nest_json_keys(source_name, table_name, json_column) %}
  {% set query %}
    WITH flat AS (
    SELECT {{function_schema()}}.get_nest_json_keys({{json_column}}) as flattened_json_keys
    FROM  {{ source(source_name, table_name) }})
    SELECT DISTINCT key
    FROM flat 
    CROSS JOIN
    UNNEST(flattened_json_keys) AS key
  {% endset %}

  {% set results = run_query(query) %}

  {% set json_keys = [] %}
  {% for row in results %}
    {% do json_keys.append(row['key']) %}
  {% endfor %}

  {{ return(json_keys) }}
{% endmacro %}
```
#### Explanation

- **Macro Definition:** The `get_nest_json_keys` macro is defined to take three parameters: `source_name`, `table_name`, and `json_column`. These parameters allow the macro to be flexible and used across different sources and tables.

- **SQL Query:** The macro constructs a SQL query that first calls the `get_nest_json_keys` UDF to flatten the JSON keys into an array called `flattened_json_keys`.

- **Flattening and Distinct Keys:** The flattened keys are then unnested in a CROSS JOIN to transform them into a list of distinct keys.

- **Execution and Results Handling:** The `run_query` function is used to execute the query and store the results. A loop then iterates over these results, appending each key to a list called `json_keys`.

- **Output:** Finally, the macro returns the list of JSON keys, which can be used in further transformations or analyses within your dbt project.

This macro enhances modularity and reuse within your dbt projects, allowing you to dynamically extract JSON keys with minimal setup for each new table or source.

### Step 3: Create the dbt Model Using the Macro

The final piece of our solution is to create a dbt model that utilizes the `get_nest_json_keys` macro to dynamically generate SQL for a fully flattened table based on the keys extracted from the nested JSON. This process makes the model highly adaptable to changes in the JSON structure.

#### dbt Model Code

```sql
{% set keys = get_nest_json_keys('your database name', 'your table name', 'json column name') %}

SELECT
    `json column name`,
    {% for key in keys %}
    JSON_EXTRACT_SCALAR(value, '$.{{ key }}') AS {{ key.replace('.', '_').replace('-', '_') }}{{ "," if not loop.last }}
    {% endfor %}
FROM 
    {{ source('your database name', 'your table name') }}
```
#### Explanation

- **Setting Keys:** The macro `get_nest_json_keys` is called to retrieve all keys from the specified JSON column in the given database and table. This set of keys is stored in the variable `keys`.

- **Dynamic SQL Generation:** A SELECT statement is constructed where for each key in `keys`, a column is dynamically created in the output. `JSON_EXTRACT_SCALAR` is used to extract each scalar value from the JSON object based on the key.

- **Handling JSON Paths:** Keys that contain special characters such as periods or dashes are replaced with underscores to ensure valid SQL identifiers.

And there you have it! By integrating BigQuery's UDF capabilities with dbt's powerful macro and model management, we've developed a flexible, dynamic solution to handle nested JSON data with ease. This approach minimizes manual overhead and adapts to data changes without requiring constant updates to your ETL processes.

Whether you're dealing with slightly varying data formats or fully dynamic data structures, this solution scales to meet your needs, ensuring that your data transformation processes are as efficient and effective as possible.

I hope this guide has been helpful in showing you how to leverage BigQuery and dbt to simplify your data handling challenges. Happy data transforming!


Eric