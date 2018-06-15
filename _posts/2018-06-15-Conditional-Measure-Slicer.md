---
layout: post
title: How to Write A Conditional Measure Linked with Slicer
subtitle:  a rolling up model
image: /img/post6/avatar.png
tags:
  - PowerBI
  - Measure
  - DAX
  - Matrix
  - VALUES
  - Slicer
published: true
category: blog
---

This blog introduces how to write a conditional measure linked with slicer, which also combines a rolling up model as extra content.  The key DAX built-in function is ``VALUES``.

---

### Scenario:

Bank A have multiple subsidiaries, one customer can have only one account in one subsidiary, but can have another account in a different subsidiary. Bank A would like to check each subsidiary’s customer number, deposit balance and admin fee. And all the figures could be rolling up to the Head Office without duplication. The other special requirement is they would check the deposit based on customer level, admin fee based on subsidiary level.

---

### Sample:


I drafted sample table as below

1. Bank hierarchy (the real case can have Bank B, Bank C…)

2. An already aggregated table from transaction table (the real case could have more categories or different fields)

![modelsample1](/img/post6/post6-1.png)

![modelsample2](/img/post6/post6-2.png)

---

### Build Up Model:

After imported the data, I created two calculated table based on Table 2 ( renamed as Detail) to get Quarter table and CustomerRelationship table per Subsidiary and Quarter.
```
Quarter = DISTINCT(Detail[Quarter])
```
```
CustomerRelationship = DISTINCT(SELECTCOLUMNS(Detail,
	"Quarter",Detail[Quarter],
	"Child",Detail[Child],
	"CustomerID",Detail[CustomerID]))
```
Calculate new column as unique key concatenate Quarter, Child and Customer ID as “KEY”
```
KEY = CustomerRelationship[Quarter]&CustomerRelationship[CustomerID]
```
Generate a derived table from CustomerRelationship table to get de-duplicated KEY
```
KEY = DISTINCT(CustomerRelationship[KEY])
```
Create a calculated column in Detail table as well
```
KEY = Detail[Quarter]&Detail[CustomerID]
```
Then I build up below model to figure out the **“Rolling up”** requirement, we could attach more data to the KEY to roll up the number per customer level. Please do remember to check the link direction, as we are going to use the filter from left to right. If you have better solution, please do let me know.

![modelsample3](/img/post6/post6-3.png)

### Calculation:

Then, we could start design the report

1. add slicers from Quarter table and Hierarchy table

2. add a measure to count Customers
```
CustomerCount = DISTINCTCOUNT(Detail[CustomerID])
```

> The reason why I did this is because the Detail table could be more
> complex with different segmentations. Use **DISTINCTCOUNT is a safer
> way to count numbers**.

3. add a matrix as below

![matrix](/img/post6/post6-4.png)
![matrix](/img/post6/post6-5.png)

Then let’s test the number, Customer Count is 4 which is obviously correct.

I create a matrix purely from Detail table like this

![matrix2](/img/post6/post6-6.png)

Then we could tell the Deposit is correct, as the some Customers have account in other subsidiary as well. But Admin fee is **incorrect**, because the amount is also rolling up, and based on the requirements they would like see the admin fee **per subsidiary only**.

Of course, you can create another table and join the subsidiary only, but the model will be not neat and efficient. As there is no relationship between Hierarchy and Detail table on subsidiary level, then what’s the simplest way to calculate the number? And also leverage slicer to get dynamic calculation?

**Create a new measure like this**
```
NewAdminFee = CALCULATE(SUM(Detail[Admin Fee]),
	FILTER(Detail,Detail[Child] in VALUES('Hierarchy'[Child])))
```
The key part is **FILTER(Detail,Detail[Child] in VALUES('Hierarchy'[Child]))**, which is building the dynamic filter based on the slicer, just like an invisible relationship.

Now, we get the right number and have fun.

![matrix2](/img/post6/post6-7.png)

Thanks
Eric Dong

---
