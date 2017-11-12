---
layout: post
title: How to Pass Multiple-Values Parameters to SQL Statement
subtitle:  to Design a Dynamic Power BI Report
image: /img/post2/avatar.png
tags:
  - Power BI
  - SQL
  - Parameter
published: true
category: blog
---

There are many articles about _**How to pass parameter to SQL statement in PowerBI**_, but none of them address my issues, so I crack it and decide to write this article to document it. If you have better method, please do let me know! 

---

### Scenario:

1. Design a template which could be shared with sales team, the dynamic part is `customer ids`. (One sales/sales team could have multiple customer ids). The major point is if there are several datasets in one report, it’s much more easily to maintain the template.
2. Pass several values to a where clause in SQL statement, e.g. where `customerid in (4001,4002,4003,4004)`, the value in bracket is what we want to pass to the SQL statement, why not pass it to filter after the SQL query? The dataset I am working is very large, so I can’t retrieve all the data from SQL server. (Direct query is not supported in my case)
3. I have super complex queries (with if else, temp table,index,etc inside). After I modified `M scripts`, I should still be able to edit my `SQL queries` easily for further possible update.

---

### Limitations of Power BI:

We can only set one value to parameter at one time, and `Current value` is mandatory field. Even we use list query, we still need to input one current value manually.

---

### My logic to solve this problem:
1. `Pack` the values into one string with `comma` separated  
2. Set the string as parameter and pass it into the SQL statement  
3. `Unpack` the values and insert the values into a table, Where `customerid in (select id from #temp)`

---

### Step 1

Write query to pack values, then contact one indicator with values to be easily selected when opening the template, see below sample query

```SQL
SELECT 

 [ID],

 STUFF((

   SELECT ', ' + [Name] + ':' + CAST([Value] AS VARCHAR(MAX)) 

   FROM #YourTable 

   WHERE (ID = Results.ID) 

   FOR XML PATH(''),TYPE).value('(./text())[1]','VARCHAR(MAX)')

 ,1,2,'') AS NameValues

FROM #YourTable Results

GROUP BY ID
```

The final output should be like this,then load data to Power BI  
![outputable](/img/post2/p20.png)

---

### Step 2

In Query Editor, right click `Selection` column, select `Add as New Query`  
![Addnewquery](/img/post2/p21.png)

Create New Parameter, set a name, Type as Text, Suggested value as `Query`, select the query just created in last step, manually put one `customerid` as current value.  
![newpara](/img/post2/p22.png)
![para](/img/post2/p23.png)

---

### Step 3

Write an unpack query, and insert the values into a table with one column. 

```
CREATE TABLE # CustomerID
  (
       CustomerID varchar(6)
  ) ;
 
WITH StrCTE(start, stop) AS
    (
      SELECT  1, CHARINDEX(',' , @strString )
      UNION ALL
      SELECT  stop + 1, CHARINDEX(',' ,@strString  , stop + 1)
      FROM StrCTE
      WHERE stop > 0
    )
INSERT INTO # CustomerID (CustomerID)
SELECT   SUBSTRING(@strString , start, CASE WHEN stop > 0 THEN stop-start ELSE 4000 END) AS stringValue
FROM StrCTE
```
---

### Step 4 (Important)

One requirement here I listed at first beginning is 
>I have super complex queries (with if else, temp table,index,etc inside). After I modified M scripts, I >should still be able to edit my SQL queries easily for further possible update..

After importing data with SQL statement, when opening the “Advanced Editor”, I will get something like below, if I modified this M scripts (passing parameter directly), I can’t click the source to edit SQL statement anymore, of course, I can “View Native Query”, but it’s extremely hard to edit a complex SQL statement in M, because it's in one line with line feed , tab, all these annoying characters.  
![m](/img/post2/p24.png)

So, what we need to use is **Value.NativeQuery**, and the MVP is as below
```
let
  
  Source = Sql.Database(Server, Database)
  Query = Value.NativeQuery(Source, “ complex query in this quote, 
doesn’t matter the f o r m a t, 
no matter how longgggggggggggggg it is, 
the unpack part is in side with the @parameter, 
in this case is @customerid”,[customerid = #”customerid”])

in
  Query
```

The first `customerid` in square bracket is variable name in SQL statement, the second one with `#”…”` is the parameter name in PowerBI.

---

### Final Step

Save the file as Template, when opening the template, there would be a pop up window, then select sales name in the drop down list.