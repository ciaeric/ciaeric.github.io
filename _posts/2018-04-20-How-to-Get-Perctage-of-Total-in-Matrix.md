---
layout: post
title: How to Calculate Percentage of Total in Matrix in Power BI
subtitle:  row and column groups from different tables
image: /img/post3/avatar.png
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

Dealer A would like to see in the first three months of 2018, the percetage of total sales of each type of car by each sales rep in one table. As sales rep is not only used once during analysis, so it's calculation happened within a model instead of one table.

---

### Introduction of ALLEXCEPT:

[Official Description](https://msdn.microsoft.com/query-bi/dax/allexcept-function-dax)
>Removes all context filters in the table except filters that are applied to the specified columns.  
>This is a convenient shortcut for situations in which you want to remove the filters on many, but not all, columns in a table.

The key concept is "context", when you put a measure in a Matrix, the column group and row group will create the "context" telling the "measure" to calculate the number filtered by me (row or group item). So we use this function to ingore the filter to get the denominator (total) part.

---

### Calculation:
I created a simple model with sales data and date as below
![modelsample](/img/post3/post3-1.png)
If we would like to calculate sales number percentage of total by sales rep, we put the the DAX expression should be like this 
```
PercentageofTotal = 
	SUM(Sales[Sales Number])
	/CALCULATE(sum(Sales[Sales Number])
		,ALLEXCEPT(Sales,Sales[Sales ID]))
```
We get the right result, the reason is the measure ingored `Car Type` context but preserved `Sales ID`.
![firstresult](/img/post3/post3-2.png)

Of course, we would like show Sales Name instead of ID, so we will drag `Sales Rep Name` from Sales Rep table to the `Columns` in matrix, then the result turn to be like this.
![wrongresult](/img/post3/post3-3.png)

Apparently, this is incorrect. Though there is relationship between these two tables, the context of `Column` is not correctly set. 
So, we need to fix the context by adding one more filter:
```
PercentageofTotal = 
		SUM(Sales[Sales Number])/
		CALCULATE(sum(Sales[Sales Number]),
			ALLEXCEPT(sales,Sales[Sales ID]),
			Sales[Sales ID] in VALUES('Sales Rep'[Sales ID]))
```
![finalresult](/img/post3/post3-4.png)
Now, we get the correct result. It's just a small tip, hope you guys enjoy it. 

Thanks
Eric Dong

---
