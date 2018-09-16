---
layout: post
title: How to Make Peak Time Analysis based on Records with Start Time and End Time
subtitle:  Tips of using GENERATESERIES
image: /img/post8/avatar.png
tags:
  - PowerBI
  - Interval
  - GENERATESERIES
published: true
category: blog
---

I was just recovered from a really bad flu, luckily I got a fun project after recovery and found some new ideas to blog which I see it as a compensation :)

I keep trying to blog solution with real case instead of theories (actually sometime I am not able to explain the theories..lol), so they might use simple method but solve the true problems.

There are two tips about using *GENERATESERIES / CALENDAR* in this project, I am going to introduce the first one in this blog.


### Scenario:

There is one roster about each nurse's shift with a start time and a finish time per day, requester would like analyze the peak time of all the nurses and the interval period is 30 minutes in order to identify the current resources allocation.

The idea output is like below screenshot

![screenshot](/img/post8/Image1.png)

---

### Solution:

Firstly we need to prepare a time table with 30 minutes interval which will used as the X axis in the chart.

Create a calculated Table by using [GENERATESERIES](https://msdn.microsoft.com/en-us/query-bi/dax/generateseries-function)

![GENERATESERIES](/img/post8/Image2.png)

```
TimeTable = GENERATESERIES(TIMEVALUE("00:00"),TIMEVALUE("23:59"),TIME(0,30,0))
```

Then, we will see a time table like this

![screenshot2](/img/post8/Image3.png)

Create two measures under this table

```
Maxtime = MAX(TimeTable[Value])
```

```
Mintime = MIN(TimeTable[Value]) 
```

Secondly, let's check the roster data

![screenshot3](/img/post8/Image4.png)

Apparently, we can't use starttime and finishtime directly, because we need compare with time only without date.

Created two calculated columns to contain time only of start and finish by using *FORMAT*.

```
Starttime_timeonly = FORMAT(Roster[Start_Time],"hh:mm:ss")
```

```
Finishtime_timeonly = FORMAT(Roster[Finish_Time],"hh:mm:ss")
```

![screenshot4](/img/post8/Image5.png)

Till now, all the preparation work is done. We just need one Measure to calculate what we want, in this case we would like to know how many nurses are rostered in each 30 minutes per day.

The Measure will like this


```
Nursecount = CALCULATE(DISTINCTCOUNT(RosterOn[emp_id]),
				FILTER(RosterOn, and(RosterOn[Starttime_timeonly]<=[Mintime] , RosterOn[Finishtime_timeonly]>[Maxtime])))
``` 

Now that's create the chart, please remember that there is no relationship needed between the timetable and the Roster table in the data model.

Drag the [Value] from Timetable to Axis, and the measure just created to the Value

![screenshot5](/img/post8/Image6.png)

The output is exact same as we expected.

![screenshot6](/img/post8/Image8.png)

We could also change the Type of Axis to be exact the same as first screenshot at the beginning of this blog

![screenshot7](/img/post8/Image7.png)

To make a comparison between Roster and Actual shift, I created a separate measure based on the same method as above with "ActualShift" table. And I personally prefer Area chart to present this type of analysis, so the final result is as below which completely show us what happened per day.

![screenshot8](/img/post8/Image9.png)

Have Fun~

Thanks
Eric Dong

---