---
layout: post
title: Ingesting and Flattening XML Files in Databricks
subtitle: A Schema-Driven Approach with Bad Record Handling
share-img: /assets/img/post23/socialshare.png
thumbnail-img: /assets/img/post23/avatar.png
tags:
- ETL
- Nested XML
- Datatbricks

published: true
category: blog
---

It feels good to be back in the Databricks environment! After my last adventure tackling JSON in BigQuery, I’m excited to share a solution that’s much more straightforward thanks to the powerful tools Databricks offers. Today, we're diving into how to ingest XML files, flatten them, and handle bad records all within Databricks.

![socialshare](/assets/img/post23/socialshare.png)

### Challenges This Solution Addresses:

- **Ingesting Deeply Nested XML Data:** 

    XML is a versatile format often used in various industries to represent complex data structures. However, this flexibility comes at a cost: XML files frequently contain deeply nested elements, mixed content, and varying data types. Transforming these intricate structures into a flat, tabular format suitable for analysis or further processing is not straightforward. 
$~$
- **Schema Variability and Enforcement:** 

    Unlike more rigid data formats, XML allows for a great deal of variability in its structure. This can lead to inconsistencies across files or even within the same file over time, as new elements are introduced or the structure evolves. This variability poses a significant challenge when trying to enforce a consistent schema across all XML files in a dataset. 
$~$
- **Handling Bad Records:** 
    Even with schema enforcement in place, XML data can still present challenges due to malformed or corrupted records. These can occur for various reasons, such as incomplete data transmission, manual errors during XML generation, or inconsistencies in the data source. Malformed records can disrupt the ingestion process, leading to failures or incomplete data capture. Identifying and managing these bad records is crucial to ensure that your data pipeline remains robust and reliable. The challenge lies in capturing these errors at the row level, isolating them from the valid data, and storing them separately for further analysis and correction, without interrupting the overall data processing flow.

### Solution Logic Explained:

This solution is designed to be configuration and schema-driven, providing flexibility and ease of use across different datasets. Here’s an overview of the key components:

1. **Reading XML Files in Spark:**
   - Spark provides native support for reading XML files. By leveraging the rowTag option, we can accurately parse the XML data into a DataFrame. The rowTag specifies the element in the XML that represents the root of the records we want to extract. This ensures that even complex and deeply nested XML structures are correctly interpreted by Spark.

2. **Schema Enforcement:**
   - We enforce a predefined schema when reading the XML files. This ensures that the data conforms to an expected format, which helps prevent issues during processing. The schema is inferred from an initial read of the XML data, saved as a JSON file, and then reloaded for subsequent reads to maintain consistency across jobs or datasets.

3. **Flattening the XML Data:**
   - After ingestion, we will generate a dynamic function that detects and flattens nested data types, such as struct and array, converting them into a flat, tabular format. This process involves recursively traversing the schema and expanding nested fields into individual columns.

4. **Handling Corrupted Records:**
   - We make use of Spark’s _corrupt_record option, which allows us to capture these problematic records at the row level. These corrupted records are then inserted into a separate location, such as a JSON file, for further analysis and troubleshooting. This ensures that bad data doesn’t disrupt the processing of valid records.

### Step 1: Parsing the XML File
Let’s start by defining a sample XML structure that is slightly more complex and mimics a real-world scenario. In this example, each category contains multiple book elements, each with nested details.

Here’s the XML string:
```
xmlString = """
<categories>
  <category name="Fiction">
    <book id="bk103">
      <author>Corets, Eva</author>
      <title>Maeve Ascendant</title>
      <details>
        <genre>Fantasy</genre>
        <price>5.95</price>
        <publication>
          <year>2000</year>
          <publisher>Ransom House</publisher>
        </publication>
      </details>
    </book>
    <book id="bk104">
      <author>Corets, Eva</author>
      <title>Oberon's Legacy</title>
      <details>
        <genre>Fantasy</genre>
        <price>6.95</price>
        <publication>
          <year>2001</year>
          <publisher>Random House</publisher>
        </publication>
      </details>
    </book>
  </category>
  <category name="Non-Fiction">
    <book id="bk105">
      <author>Smith, John</author>
      <title>Understanding AI</title>
      <details>
        <genre>Technology</genre>
        <price>15.95</price>
        <publication>
          <year>2023</year>
          <publisher>TechBooks</publisher>
        </publication>
      </details>
    </book>
  </category>
</categories>
"""
```

This XML structure has a categories element at the top, containing multiple category elements. Each category contains an array of book elements, with each book having nested details like genre, price, and publication information.

#### Parsing the XML in Spark
To parse this XML file into a Spark DataFrame, we use the rowTag option. The rowTag specifies the XML element that represents the root of the records we want to extract—in this case, the category tag.

```
df = spark.read.format("xml").option("rowTag", "category").load("/path/to/xmlfile")
```

Structure will still be nested. Here’s an example of what the output might look like:

|    name      |                                                                 book                                                                |
|--------------|------------------------------------------------------------------------------------------------------------------------------------|
| Fiction      | [{bk103, Corets, Eva, Maeve Ascendant, {Fantasy, 5.95, {2000, Ransom House}}}, {bk104, Corets, Eva, Oberon's Legacy, {Fantasy, 6.95, {2001, Random House}}}] |
| Non-Fiction  | [{bk105, Smith, John, Understanding AI, {Technology, 15.95, {2023, TechBooks}}}]                                                    |

In this structure:

The name column represents the category name.
The book column is an array containing multiple book records, each of which has nested fields like details.

#### Schema Inference and Enforcement

Now that we have the DataFrame, we can infer the schema from this initial read. Inferring the schema is essential because it allows us to understand the structure of the XML data and enforce this structure on subsequent reads to ensure consistency.

Here’s how you can infer the schema:

```
inferred_schema = df.schema
print(inferred_schema.json())
```

The inferred schema can then be saved to a JSON file, which ensures that it can be reused across different stages of the data pipeline or with different datasets that share the same structure.

```
# Saving the schema
dbutils.fs.put("/path/to/schema.json", inferred_schema.json())

```

#### Reading XML with Schema Enforcement
With the schema saved, we can enforce this schema the next time we read the XML file. Enforcing the schema helps ensure that the XML data conforms to the expected structure, reducing the risk of processing errors due to unexpected variations in the data.

Here’s how to read the XML file again with schema enforcement:

```
import json
from pyspark.sql.types import StructType

# Loading the schema
schema_path = "/path/to/schema.json"
inferred_schema = StructType.fromJson(json.loads(dbutils.fs.head(schema_path)))

# Reading the XML file with the enforced schema
df_with_schema = spark.read.format("xml").option("rowTag", "category").schema(inferred_schema).load("/path/to/xmlfile")

df_with_schema.show(truncate=False)
```

By enforcing the schema, you ensure that the DataFrame adheres to the expected structure, which is crucial for maintaining data integrity across your pipeline. This approach is particularly useful when working with XML data from multiple sources or when the structure of the XML file might change over time.

This schema enforcement step is critical for any production-level data pipeline, as it adds a layer of validation and consistency to your data ingestion process.

### Step 2: Flattening the XML Data
After parsing the XML file, the data often remains nested, making it challenging to work with directly. We’ll flatten the DataFrame, converting nested structures like arrays and structs into a flat, tabular format. Here’s how the key functions work:

- **`flatten_schema(schema, prefix=None)`:**
Recursively traverses the schema to flatten nested structs, generating a list of fully qualified field names.

```
def flatten_schema(schema, prefix=None):
    fields = []
    for field in schema.fields:
        name = f"{prefix}.{field.name}" if prefix else field.name
        if isinstance(field.dataType, StructType):
            fields += flatten_schema(field.dataType, prefix=name)
        else:
            fields.append(name)
    return fields
```

- **`explode_df(df)`:**
Expands arrays into separate rows using Spark’s `explode` function, making each array element its own row in the DataFrame.

```
def explode_df(df):
    for (name, dtype) in df.dtypes:
        if "array" in dtype:
            df = df.withColumn(name, explode(name))
    return df
```

- **`is_flat(df)`:**
Checks if the DataFrame is fully flattened by scanning for any `array` or `struct` data types. Returns False if nested structures are found.

```
from pyspark.sql.functions import explode, col

def is_flat(df):
    for (_, dtype) in df.dtypes:
        if "array" in dtype or "struct" in dtype:
            return False
    return True
```

- **`flatten_nest_df(df)`:**
The main function that orchestrates the flattening process:
1. Flatten the Schema: Uses `flatten_schema()` to generate a flat list of field names.
2. Rename Columns: Replaces dots (.) with underscores (_) in column names. This step ensures that the column names are compatible with SQL and other processing tasks that might have limitations on special characters.
3. Explode Arrays: Applies `explode_df()` to handle any arrays.
4. Loop Until Flat: Continues until the DataFrame is fully flat.

```
def flatten_nest_df(df):
    keep_going = True
    while(keep_going):
        fields = flatten(df.schema)
        new_fields = [item.replace(".", "_").lower() for item in fields]
        df = df.select(fields).toDF(*new_fields)
        df = explode_df(df)
        if is_flat(df):
            keep_going = False
    return df
```

#### Expected Output After Flattening
Assuming the original XML structure we defined earlier, after applying the flatNestDF function, the expected output would look like this:

|  category_name  |  book_id  |  author     |      title         |  genre      |  price  |  publication_year  |  publication_publisher  |
|-----------------|-----------|-------------|--------------------|-------------|---------|--------------------|-------------------------|
|  Fiction        |  bk103    |  Corets, Eva|  Maeve Ascendant   |  Fantasy    |  5.95   |  2000              |  Ransom House           |
|  Fiction        |  bk104    |  Corets, Eva|  Oberon's Legacy   |  Fantasy    |  6.95   |  2001              |  Random House           |
|  Non-Fiction    |  bk105    |  Smith, John|  Understanding AI  |  Technology |  15.95  |  2023              |  TechBooks              |


- `category_name`: The name of the category (e.g., Fiction, Non-Fiction).
- `book_id`: The unique identifier for each book.
- `author`, `title`, `genre`, `price`: Information about each book.
- `publication_year`, `publication_publisher`: Details about the book’s publication.

This flat structure is much easier to work with, enabling you to perform SQL queries, aggregations, and other analyses directly on the DataFrame without needing to handle nested structures manually.

### Step 3: Handling Bad Records

In any data processing pipeline, handling bad records is crucial to maintaining data quality and ensuring that the pipeline runs smoothly. When working with XML files, corrupted or malformed records can cause ingestion failures or lead to inaccurate analysis. Spark’s XML format doesn’t natively support a badRecordPath like some other formats (CSV and JSON), so we need to implement our own approach to capture and manage these problematic records.

#### Capturing Corrupted Records
To capture corrupted records, we can add a special column, typically named _corrupt_record, to our schema. This column will store any records that fail to parse according to the defined schema. By adding this field, Spark can safely load the data while isolating the corrupted records for further inspection.

Here’s how you can modify the schema to include the _corrupt_record field:

```
from pyspark.sql.types import StringType, StructField

corrupted_column_name = '_corrupt_record'
corrupted_column = StructField(corrupted_column_name, StringType(), True)
inferred_schema = inferred_schema.add(corrupted_column)
```

After modifying the schema, we can reload the XML data with this schema enforcement in place:

```
df = spark.read.format("xml").option("rowTag", "category").schema(inferred_schema).load("/path/to/xmlfile")
```

#### Identifying and Handling Bad Records

Once the data is loaded, we can identify rows that contain corrupted records by checking if the _corrupt_record column is not null. This allows us to flag these records and separate them from the rest of the data:

```
from pyspark.sql.functions import col, when, lit

# Flagging corrupted records
df = df.withColumn('error_flag', when(col('_corrupt_record').isNotNull(), 1).otherwise(0))

# Caching the DataFrame to ensure corrupted records are captured correctly
df.cache()

# Extracting bad records for further analysis
bad_records_df = df.select(lit('unable to parse xml schema').alias('reason'), df._corrupt_record.alias('record')).filter(df.error_flag == 1)
bad_records_df.show(truncate=False)
```

Explanation:

`error_flag Column`:
The error_flag column is used to mark records that contain corrupted data. This is done by checking if the _corrupt_record field is not null. If it’s not null, the record is flagged with a 1, indicating an issue.

`cache()`:
Caching the DataFrame is crucial in this step because Spark may not fully materialize the _corrupt_record column unless the DataFrame is cached. This ensures that all bad records are properly identified.

`Extracting Bad Records`:
The bad_records_df DataFrame contains only the corrupted records, along with a reason for the failure. This allows you to analyze these records separately, helping you understand what went wrong and how to fix the underlying issues.

#### Storing and Analyzing Bad Records

After identifying the bad records, you can store them in a separate location, such as a JSON file or a database table, for further analysis. This practice ensures that you maintain a clean dataset for processing while still retaining the problematic records for debugging purposes.

```
# Writing bad records to a JSON file for further analysis
bad_records_df.write.json("/path/to/bad_records")
```

By storing bad records separately, you create a clear separation between valid and invalid data. This helps maintain data quality while allowing you to investigate and resolve issues with the corrupted records.


### Further Tips for Robust Data Handling

When building a resilient ETL pipeline in Databricks, it’s essential to manage data ingestion, transformation, and consistent data writes efficiently. Here are some key strategies to achieve these goals:

#### Using Auto Loader for Incremental Data Ingestion

Databricks Auto Loader simplifies the process of ingesting large or streaming datasets by automatically detecting and processing new files as they arrive in your data lake. This capability is particularly useful for real-time or near-real-time data processing.

Key Features:

- Scalability: Auto Loader efficiently manages high volumes of incoming data.
- Schema Evolution: Auto Loader can adapt to schema changes automatically, ensuring your pipeline remains robust as your data evolves.
- Checkpointing: It keeps track of processed files, ensuring that each file is processed only once.

#### Transforming and Writing Data with `foreachBatch`

The foreachBatch function in Spark is particularly useful for applying complex transformations and writing results to multiple destinations within each micro-batch. This flexibility is essential when separating clean records from corrupted ones or writing to multiple tables while maintaining data consistency.

Example Case: Handling Clean and Corrupted Records

Let’s revisit our example where we process XML data, separating clean records from corrupted ones. We can use foreachBatch to apply transformations and ensure idempotent writes for both clean and bad records.

```
from delta.tables import DeltaTable

app_id = "my_unique_app_id"  # A unique string used as an application ID.

def process_batch(batch_df, batch_id):
    # Separate clean and corrupted records
    cleaned_df = batch_df.filter(col("_corrupt_record").isNull())
    bad_records_df = batch_df.filter(col("_corrupt_record").isNotNull())

    # Write cleaned data to the primary sink, ensuring idempotency
    cleaned_df.write.format("delta")\
        .option("txnVersion", batch_id)\
        .option("txnAppId", app_id)\
        .mode("append")\
        .save("/path/to/cleaned_data/")

    # Write corrupted records to a separate sink, ensuring idempotency
    bad_records_df.write.format("delta")\
        .option("txnVersion", batch_id)\
        .option("txnAppId", app_id)\
        .mode("append")\
        .save("/path/to/bad_records/")

df.writeStream.foreachBatch(process_batch).start()
```

**Explanation**:

`txnAppId` and `txnVersion`: These options are crucial for ensuring that writes are idempotent. txnAppId is the application ID that remains constant for all batches, while txnVersion is the batch ID that increments with each batch. This combination allows Delta Lake to identify and ignore duplicate writes, ensuring that reprocessing the same batch does not result in duplicate data.

`Separate Writes`: Even though cleaned_df and bad_records_df are different DataFrames, using txnAppId and txnVersion ensures that if a batch is retried, Delta Lake will correctly recognize that these records have already been written and will skip the duplicate writes.

By applying these practices—using Auto Loader for efficient data ingestion and ensuring idempotent writes with foreachBatch—you can build a robust and scalable ETL pipeline that handles large and complex datasets effectively, while maintaining data integrity.


### Summary

In this post, we've explored how to effectively manage the ingestion, transformation, and storage of XML data within a Databricks environment. By leveraging Databricks Auto Loader, we can efficiently process large volumes of XML data incrementally, ensuring scalability and robustness in our data pipelines.

Happy data engineering!

Eric