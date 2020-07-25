---
layout: post
title: How to Calculate Percentage of Total in Matrix in Power BI
subtitle:  row and column groups from different tables
thumbnail-img: /assets/img/post3/avatar.png
tags:
  - PowerBI
  - SQL
  - DAX
  - Matrix
  - ALLEXCEPT
published: true
category: blog
---

This blog simply introduces how to calculate percentage of total in Matrix with **row and column groups from different tables in the model**.  The key DAX built-in function is ``ALLEXCEPT``.

---

### Scenario:

Dealer A would like to see in the first three months of 2018, the percetage of total sales of each type of cars by each sales rep in one table. Because sales rep data is not only used once during creating the report, the calculation happened within a model instead of one table.

---

### Introduction of ALLEXCEPT:

[Official Description](https://msdn.microsoft.com/query-bi/dax/allexcept-function-dax)
>Removes all context filters in the table except filters that are applied to the specified columns.  
>This is a convenient shortcut for situations in which you want to remove the filters on many, but not all, columns in a table.

The key concept is "context", when we put a measure in a Matrix, the column group and row group will create the "context" telling the "measure" to calculate the number filtered by me (row or group item). So we use this function to ingore the filter to get the denominator (total) part.

---

### Calculation:
I created a simple model with sales data and date as below ,(in real life, could be multi-tables connected with sales rep table)
![modelsample](/assets/img/post3/post3-1.PNG)

If we would like to calculate sales number percentage of total by sales rep, we create a measure with the DAX expression like this 
```
PercentageofTotal = 
	SUM(Sales[Sales Number])
	/CALCULATE(sum(Sales[Sales Number])
		,ALLEXCEPT(Sales,Sales[Sales ID]))
```
We get the right result, the logic is the measure ingored `Car Type` context but preserved `Sales ID` to calculate the total sales number.
![firstresult](/assets/img/post3/post3-2.PNG)

Of course, we would like show Sales Name instead of ID, so we will drag `Sales Rep Name` from Sales Rep table to the `Columns` in matrix, then the result turn to be like this.
![wrongresult](/assets/img/post3/post3-3.PNG)

Apparently, this is incorrect. Though there is relationship between these two tables, the context of `Column` is not correctly set. 
So, we need to fix the context by adding one more filter:
```
PercentageofTotal = 
		SUM(Sales[Sales Number])/
		CALCULATE(sum(Sales[Sales Number]),
			ALLEXCEPT(sales,Sales[Sales ID]),
			Sales[Sales ID] in VALUES('Sales Rep'[Sales ID]))
```
![finalresult](/assets/img/post3/post3-4.PNG)

Now, we get the correct result. It's just a small tip, hope you guys enjoy it. 

Thanks
Eric Dong

---
