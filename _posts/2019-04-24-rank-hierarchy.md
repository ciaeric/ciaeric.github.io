---  
layout: post  
title: How to Create a Dynamic Rank in Matrix with Hierarchy?  
subtitle: Tips for using RANKX and ISINSCOPE
image: /img/post13/avatar.png  
tags:  
- PowerBI  
- RANKX
- ISINSCOPE
  
published: true  
category: blog  
---  
  
![screenshot1](/img/post13/index.png)  

If you are familiar with `RANKX` DAX expression, you should know how to do a quick rank measure can be used in a Matrix. 

```
RANKX(ALLSELECTED(ColumnName), CALCULATE(Measure),,DESC,Dense)
```

Now we have a Matrix with Hierarchy in Rows, and we would like our ranking dynamically changed based on different Hierarchy level, we need to leverage `ISINSCOPE`

In this case as below screenshot, we have two levels Hierarchy in rows and we'd like user can switch between Location(parent level of shops) view and shop view, and we hope our Rank measures can work when users do this switch by clicking `Go to the next level in the hierarchy` and `Drill Up`.

![screenshot](/img/post13/img1.png)  

We know the key concept `Context` of DAX, I introduced it in my other blog [How to Calculate Percentage of Total in Matrix in Power BI](http://funbiworld.com/2018-04-20-How-to-Get-Perctage-of-Total-in-Matrix/). So we will use `ISINSOCPE` to judge what kind of context the measures are under, and use `ALLSELECTED` to restrain the `context` in the iterative calculation.

```
Shop Comm Movement Rank = 
Var isLocationFiltered = ISINSCOPE(LocationView[ShopName])
Var isShopFiltered = ISINSCOPE(Core[Shop name])
return 
SWITCH(TRUE(), 
      AND(AND(isLocationFiltered,NOT(isShopFiltered)),CALCULATE([Daily Comm])<>BLANK()),
      RANKX(ALLSELECTED(LocationView[ShopName]), CALCULATE([Daily Comm]),,DESC,Dense),
      AND(isShopFiltered,[Daily Comm]<>BLANK()),
      RANKX(ALLSELECTED(Core[Shop name]),CALCULATE( [Daily Comm]),,DESC,Dense),
      BLANK()
      )
```

This works well for this Shop Matrix. You noticed that I put `[Daily Comm]<>BLANK()` in my conditions and you may say "why don't you just filter it as `IS NOT BLANK` in FILTERS?". Because once you filter value on this Matrix, the Rank Measure will not work anymore. (I struggled a lot before I realized this). My understanding is the dynamic filter(measure) will break the `ALLSELETECD` somehow. 

![screenshot](/img/post13/img2.png)  


I have another complicated example which is also a Matrix with a dynamic filter(measure), in this case, I need to slice this dynamic filter. (I may introduce how to slice a measure in another blog)

The filter is like this
```
AgeFilter = IF (
    ISFILTERED ( Age[Age Group] ),
    VAR SelectedCutoff =
        MAX ( Dates[Date] )
    RETURN
        CALCULATE (
            COUNTROWS ( Employee ),
            FILTER (
                VALUES ( Employee[Employee Date Accredited] ),
                VAR AgeCalculated =
                    IF (
                        Employee[Employee Date Accredited] <= SelectedCutoff,
                        TRUNC ( YEARFRAC ( Employee[Employee Date Accredited], SelectedCutoff,1 ) )
                    )
                RETURN
                    CONTAINS ( VALUES ( Age[Age] ), Age[Age], AgeCalculated )
            )
        ),
    COUNTROWS ( Employee )
)
```
And I have an Age Group slicer to slice this Matrix, which means I have to put this filter in Matrix level and make it as "AgeFilter =1".

The Rank measure is very simple just like below, as users don't need to drill up.

```
Consultant Comm Movement Rank = if(
                                    [Daily Comm]<>BLANK(), 
                                    RANKX(ALL(Employee),CALCULATE([Daily Comm]),,DESC,Dense),
                                    BLANK()
                                  )

```
It looks fine, but when I sliced the Age Group, the result will be like this, the table is filtered but the Rank calculation is still based on `ALL(Employee)`

![screenshot](/img/post13/img3.png)  

Then I include this filter into my Rank measure, it works all good. 

```
Consultant Comm Movement Rank = if(
                                    [Daily Comm]<>BLANK(), 
                                    RANKX(FILTER(ALL(Employee),[AgeFilter]=1),CALCULATE([Daily Comm]),,DESC,Dense),
                                    BLANK()
                                  )
```

So beware of "Filter" of Matrix when you use RANKX function to create measures.


Thanks  
  
Eric Dong  