---
layout: post
title: Visualize Complex Hierarchy and Slice with Any Node
subtitle: Data Modelling and Custom Visual
thumbnail-img: /assets/img/post19/avatar.png
tags:
- PowerBI
- Hierarchy
- Data Model
- Node

published: true
category: blog
---

I was majorly involved in Power BI deployment and United Analytics Platform investigation recently, and did a lot of documenting work in architect, general practices or guidance level, which is a good chance to help me reviewing my knowledge but nothing very new to me. Luckily I got an interesting and bit of tricky small piece of Power BI work, so I have this chance to write a new blog and share this with you. 

This piece of Power BI work is about "Hierarchy". We all know Power BI visuals supporting drill up/down to each level of a hierarchy, but this case is under a special situation with special needs:
1. The hierarchy is very deep with 7 levels
2. Parent child is not exclusively defined, a child can be a parent in different hierarchy path
3. End users would like to search any node of this hierarchy (top - down, down - top, middle - any) to see all the related paths instead using drilling feature

Another interesting part is the fact table in the DataMart is like blow screenshot (dummy data)

![screenshot1](/assets/img/post19/dummy1.png)

The issues with it includes:
1. The path indicates the hierarchy information is not treated as a separate Dimension table, bring this repeated long string into multi million rows dataset will increase the size significantly
2. The path contains path code but not the final presenting business name, so using split string feature in Power Query is not very straightforward
3. The path_id corresponding to path string is not one to one relationship, but many to one, which means `path_id` needs to be dealt with to avoid unnecessary duplicate strings 

So, 
### Step 1:  we need to model our dataset to separate the dimension of hierarchy

Load a `Dim_Path` table in Power BI Dataset
```
/* clean the string in Path column and get the distinct values*/
WITH pathstring
AS (SELECT distinct
        path,
        replace(replace(replace(path, '{', ''), '}', ''), '/', ',') as pathclean
    FROM [dbo].[fact_sales_value] 
   ),   
/* Convert the path string into rows*/   
     pathsplit
AS (SELECT path,
           value,
           ROW_NUMBER() OVER (PARTITION BY pathclean ORDER BY (SELECT NULL)) as rn
    FROM pathstring 
        CROSS APPLY STRING_SPLIT(pathclean, ',')
   ),
/* Join the dimension table and get all the business names of each path code*/      
     pathsplitname
AS (SELECT p.path,
           a.name,
           p.rn
    FROM pathsplit p
        LEFT JOIN [dbo].[dim_level_name] a
            ON p.value = a.level_code
   ),
/* Pivot the path names into each level*/     
     pathnames
AS (SELECT path,
           [1] AS LEVEL1,
           [2] AS LEVEL2,
           [3] AS LEVEL3,
           [4] AS LEVEL4,
           [5] AS LEVEL5,
           [6] AS LEVEL6,
           [7] AS LEVEL7
    FROM pathsplitname
        PIVOT
        (
            MAX(name)
            FOR RN IN ([1], [2], [3], [4], [5], [6], [7])
        ) as PVT
   ),
/* Get the primary key of this newly create dimension table from original fact table, 
the max window function is trying to get the unique path_id for each path to reduce the redundant strings*/     
     pathall
AS (select distinct
        h.path,
        MAX(path_id) OVER (PARTITION BY path) as pathnewid, 
        /*Note: the fact table needs to do the same calculation*/
        h.depth
    FROM [dbo].[fact_sales_value] h
   )
/* Generate the final Dimension table*/   
SELECT pl.pathnewid,
       pl.depth,
       Level1,
       level2,
       level3,
       level4,
       level5,
       level6,
       level7
FROM pathall pl
    LEFT JOIN pathnames pn
        ON pl.path = pn.path
```

![screenshot1](/assets/img/post19/dummy2.png)

Because the need is "search" any Node in the hierarchy, so we need another dimension table to lookup `Dim_Path` and served as a slicer, I am writing another similar SQL code to get it (no pivot calculation), actually you can unpivot previous table in Power Query to achieve the same result
```
WITH pathstring
AS (SELECT distinct
        path,
        replace(replace(replace(path, '{', ''), '}', ''), '/', ',') as pathclean
    FROM [dbo].[fact_sales_value] 
   ),   
/* Convert the path string into rows*/   
     pathsplit
AS (SELECT path,
           value,
           ROW_NUMBER() OVER (PARTITION BY pathclean ORDER BY (SELECT NULL)) as rn
    FROM pathstring 
        CROSS APPLY STRING_SPLIT(pathclean, ',')
   ),
/* Join the dimension table and get all the business names of each path code*/      
     pathsplitname
AS (SELECT p.path,
           a.name,
           p.rn
    FROM pathsplit p
        LEFT JOIN [dbo].[dim_level_name] a
            ON p.value = a.level_code
   ),
/* Get the primary key of this newly create dimension table from original fact table, 
the max window function is trying to get the unique path_id for each path to reduce the redundant strings*/     
     pathall
AS (select distinct
        h.path,
        MAX(path_id) OVER (PARTITION BY path) as pathnewid, 
        /*Note: the fact table needs to do the same calculation*/
        h.depth
    FROM [dbo].[fact_sales_value] h
   )
/* Generate the final Dimension table*/   
SELECT DISTINCT pl.pathnewid,
       pl.depth,
       pn.name
FROM pathall pl
    LEFT JOIN pathsplitname pn
        ON pl.path = pn.path   
```
![screenshot1](/assets/img/post19/dummy3.png)

Now, we can build a model like below screenshot, the key of each table is very clear, just link the `PathNewID`

![screenshot1](/assets/img/post19/dummy6.png)

### Step 2: Visualize the hierarchy by using a Custom Visual called [xViz Hierarchy Tree](https://xviz.com/visuals/hierarchy-tree/)

Create the visual and simply configure as below

![screenshot1](/assets/img/post19/dummy7.png)

Then create a slicer using the `name` value of `Dim_Path_Search` table.

### Now, let's play. 

Once you select a nod in [name] slicer, you will get all the related paths with it, which includes all its children and consolidate back to the ultimate parent. You can click any node to expand to next level. Another good part of this visual is it provides contribution % and data bar as well.

![screenshot1](/assets/img/post19/dummy4.png)

There is one more feature is it has a built in "Search" feature. If after the [name] slice, we will have a relatively bigger tree, you can use this feature to narrow down and find that specific path.

![screenshot1](/assets/img/post19/dummy5.png)

There are many configurations you can try. But the to get rid of the pop up ads in Power BI service, you have to pay for it. 

Have Fun.

Eric Dong  

