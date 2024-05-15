---
layout: post
title: Best Practice and Advanced Usage of Parameters in Power BI 
subtitle:  Interacting with SQL Server
thumbnail-img: /assets/img/post10/avatar.png
tags:
  - PowerBI
  - Parameter
  - Dynamic SQL Query
published: true
category: blog
---

Parameters in Power BI could be used in a lot of places: *connection details, conditional column, M Query, etc*. There is another "What if Parameter" which is not included in today's topic.

I won't introduce basic usage of Power BI Parameters here and you could read the [*ariticle*](https://powerbi.microsoft.com/en-us/blog/deep-dive-into-query-parameters-and-power-bi-templates/) in MS Power BI Blog to understand Parameters and Power BI Templates. What I am trying to introduce is the experience of developing the Power BI report as an Analyst by using SQL quite often, which saved me tons of time. 

---

## Always using Parameters to configure your connection details

### Benefits: 

1. Save you from typing connection details again and again when you have multiple queries from the same SQL Server
2. When you have test SQL server to develop your report, it's easy to switch between Test and Prod Server
3. Once the server changed from one to the other, you only need to maintain several parameters
4. And you don't modify the connections through your desktop, but easily manage parameters in Power BI Service


### Quick Example:

Before connecting to/importing data from SQL Server, open Power Query Editor and create server/database parameters over there. You could use `Any Value` for free input,`List of Values` for selection or `Query` from other queries. In this case, I am using `List of Values` then I could directly select the value from the drop-down list later when switching the data source.

![screenshot1](/assets/img/post10/image2.png)

Connect to SQL Server, change to Parameters Option, then select the Parameters from the drop-down list next to it.

![screenshot2](/assets/img/post10/image3.png)

If you have more than one servers or databases, or a different type of connections, you could create a bunch of parameters to manage them. Below screenshot is a sample about parameters in Power BI Service after you published the dataset, you could directly update the value of parameters from there instead of update your PBIX file and publish again.

![screenshot3](/assets/img/post10/image4.png)


## Use your Parameterized SQL Query directly in Power BI:

### Benefits:

1. Consistent working experience when you need to test your query between Power BI and SSMS
2. If you are going to create a Power BI Template (PBIT) For `Import` query option, instead of filtering in Power Query when retrieved all the data, just import what you need for this report, which reduces the cost of SQL Server

### Quick Example:

Actually, I have an article to explain [**How to pass multi-value Parameters into Power BI SQL Statement**](https://dataink.com.au/2017-11-12-Pass-ParametertoPowerbI/), which is a much more complicated case but using the same method.

When we develop a report, we will always think what's the possible change or extension, so we prefer to write SQL query with parameters before you moving to Power BI development, like below screenshot, an extremely simple one

```
DECLARE @Department VARCHAR(20)
SET @Department = 'Marketing'

SELECT [USER_ID]
      ,[USERNAME]
      ,[LANGUAGE]
      ,[DEFDEPT]
  FROM [dbo].[USERS]
  WHERE [DEFDEPT] = @Department
```

Then you can create a parameter in Power BI, maybe named it as `Parameter Department` and `Text`Type, and just directly create a blank query with below scripts. The key function is **Value.NativeQuery**, you keep your original query in it and just comment out the Parameters in SQL, which you might go back to SSMS to test later for changes. `[Department = #"Parameter Department"]` is connecting the parameters in SQL and Power BI. Do you find another two parameters in this M query? Yes, `Server` and `Database` are also parameters I introduced in the previous section.

```
let
  
  Source = Sql.Database(Server, Database)
  Query = Value.NativeQuery(Source,"

--DECLARE @Department VARCHAR(20)
--SET @Department = 'Marketing'

SELECT [USER_ID]
      ,[USERNAME]
      ,[LANGUAGE]
      ,[DEFDEPT]
  FROM [dbo].[USERS]
  WHERE [DEFDEPT] = @Department

",[Department = #"Parameter Department"])

in
  Query
```

## Design Dynamic SQL in Power BI by leveraging M Scripts:

### Benefits:

1. If the query is not a very complex query, you could directly do it in Power BI instead of creating a Stored Proc which saves some time.
2. If you would like to control this dynamic report through Power BI Service directly, then it's also a good option.

### Quick Example:

Let's use previous SQL statement as an example, if in the Prod database, that ``[Users]`` table's schema is not `dbo` but `prddb`, when we switch the connection from test to prod, this query will be broken. So we can create a parameter called `schema name` name in Power BI, then modify the scripts like below

```
let
  
  Source = Sql.Database(Server, Database)
  Query = Value.NativeQuery(Source,Text.Combine({"

--DECLARE @Department VARCHAR(20)
--SET @Department = 'Marketing'

SELECT [USER_ID]
      ,[USERNAME]
      ,[LANGUAGE]
      ,[DEFDEPT]
  FROM "
	,#"schema name", ".[USERS]
  WHERE [DEFDEPT] = @Department

"},""),[Department = #"Parameter Department"])

in
  Query
```

The logic is exactly the same as when we design dynamic SQL in SSMS.
 


Have Fun~

Thanks
Eric Dong

---