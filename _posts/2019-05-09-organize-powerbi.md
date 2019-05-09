---  
layout: post  
title: How to Keep Power BI Report Neat?  
subtitle: Well organized report is the start of the collaboration 
image: /img/post14/avatar.png  
tags:  
- PowerBI  
- Parameter
- Measure
- Relationship
- Queries
  
published: true  
category: blog  
---  
  
![screenshot1](/img/post14/index.png)  

If you have a Power BI report growing bigger and bigger because of more requirements or you used to take over a complicated report from another developer, you might have the experience like below picture.

![screenshot1](/img/post14/mess.png) 

And I assume you may meet below problems

* Too many measures messed up with the fields in different tables, hard to locate? 
* Complicated model with many tables, difficult to check the relationships?
* What's sources and types of these queries? 
* ......

I am going to introduce you some methods in this blog to keep your Power BI report neat which will definitely increase the efficiency for yourself and collaboration in your team. The topics include:
1. How to organise measures
2. How to make the layout more structured
3. How to manage connections of data sources
4. How to manage queries 
5. How to manage model and relationships

Let's rock!

###How to organize measures

If you ever created a report with more than 10 tables and 50 measures, you will know organizing measures well will save tons of time.

My solution is keeping all the measures in one place with a different category, then you will easily find and use them in any visuals. (Like below screenshot)

![screenshot1](/img/post14/measure.png) 

The step is quite simple: 
Step One - create a table by using "Enter Data" under home tab, give the table name as "#Measures", click ok. The "#" makes your Measures Group always display on the top of the Fields.
Step Two - create measures under this table then delete that only default column under this table, now you have a place for your measures.
Step Three - Go to Model, select/Multi-select measures, set up "Display Folder".Once you have a folder created, you can move measures into the folder by dragging. You can also put a description of certain measures if they are complicated. (You can use this method to organize the fields in other normal tables as well)

![screenshot1](/img/post14/measure2.png) 

If you'd like to "clean" a report you have already created with measures in different tables, you can move them by using  "Home Table" option under "Modeling" tab.

![screenshot1](/img/post14/measure3.png) 

###How to make the layout more structured

People have different ways to design the "front end", so I won't comment too much here. 

What I recommended is **ticking "Show Gridlines" and "Snap Objects to Grid" under "View" tab, use "Actual Size" in "Page View", and don't overlay two many tiles in one page but try to keep them separated.**

![screenshot1](/img/post14/snap.png) 

###How to manage connections of data sources

I have introduced this topic in my previous blog [Best Practice and Advanced Usage of Parameters in Power BI](http://funbiworld.com/2018-12-11-Parameters-power-bi/).

Manage all your connections in parameters, it's easy for 
* creating a new query by using the same data source
* switching data source from test to prod
* managing connections in Power BI services directly

![screenshot1](/img/post14/connection.png) 

![screenshot1](/img/post14/connection2.png) 

###How to manage queries 

We can group our queries in Query Editor, the method is simply "New Group" and move your queries into different Groups.

The Grouping method could be based on 
* Type (function, parameter, query, etc.)
* Source Type (Excel, SQL Server, etc.)
* Database Name 
* ...

It depends on the data environment and the queries you are using, just make it clear and understandable by others.

![screenshot1](/img/post14/query.png) 


###How to manage model and relationships

Day after day, your data model could get much bigger with dozens of tables involved. It becomes increasingly difficult to understand and maintain the network of relationships in a single diagram.

![screenshot1](/img/post14/relationship.png) 

But we can create multiple layouts to show a subset of the model. Like the below example, I created a new layout with only two tables, the relationship is the same as the all tables view.

Please be noticed that though there is only one relationship between them, the other relationships with two tables are still there which are just not displayed. E.g. if you'd like to change this relationship to both direction filter, you will see a warning message. You can treat this layout as a "Zoom out" for a couple of tables are relevant to a subject area. 

![screenshot1](/img/post14/relationship2.png) 


Have fun!
![screenshot1](/img/post14/avatar.png) 


Thanks  
  
Eric Dong  