---
layout: post
title: Is Power BI a "Self Service" Tool?
subtitle:  Skills requirements of Power BI development
image: /img/post11/avatar.png
tags:
  - PowerBI

published: true
category: blog
---

![screenshot1](/img/post11/image1.png)

Is Power BI a "Self Service" Tool? It depends on how do you define "Self Service" and how much do you know about Power BI.

The reason why I want to write this article is that when I am delivering Power BI development training and communicating with Management Team, I feel like people are misled by the word "Self Service".

For example:

1. people with some excel experience (you know I am not saying the Excel guru with Power Query/Pivot/View experience) don't expect any learning curve of this tool, because it's "Self Service" and everything should be very simple to learn

2. people think generate a table in Power BI should be much simpler than in Excel, if they can't move/calculate any cell as they used to do in Excel, they started to deny Power BI

If some senior managers buy in above "Self Service" idea, then.....you can tell the result.

---

My understanding of "Self Service" Power BI includes two parts: One is more from consumer point of view, they don't see a static report from SSRS or spreadsheets. They can consume the insights, slice data, drill down to the detail, interact with the visuals, export them and even save the report as a PowerPoint file to present if they prefer paper. The other one is in field analysts extract adhoc data or design a simple visual report from existing dataset, and based on my experience, simple visual reports not always end well due to more complicated analysis requirements. You may question analysts can learn DAX to do their analysis as well, I will explain later.

When I draft one first version of training deck, I put below content in it on purpose. It seems like to clarify BI's responsibility, but my idea is to show that there are lots of skills needed to develop a Power BI report if they like to use data from source system of a data warehouse

![screenshot1](/img/post11/image2.png)

---

Then, I developed a new chart to explain my thought in a more structured way as below which I would like to share with you. I am always trying to provide a solution instead of report, that's my goal to achieve the best outcome. And till today I can't even say I am a DAX expert or a Power Query expert, so Power BI is not as easy as a "Self Service" Macdonald Order Machine.

![screenshot1](/img/post11/image3.png)

Do I support Analysts in field to do their own report to make in-depth analysis? I strongly encourage them to use DAX to do that. But the thing is Tabular model is the foundation knowledge of DAX, analysts need to understand the relationship between tables and how DAX works with them, because per official definition - The Data Analysis expressions (DAX) language provides a specialized syntax for querying Analysis Services tabular model. *DAX is NOT a programming language. DAX is primarily a formula language and is also a query language.*

Let's say these are all sorted, this other thing is how do analysts get data from database, then they need grasp a query language (Dataflow might be an option here, will see). Or, if they are working on an existing dataset, then they need all the access to the database to refresh the PBIX file locally, otherwise, it's difficult to do the testing.

You see the dependency here? What I want to say is people should have a reasonable expectation to use Power BI and then move step by step.

In conclusion, my suggestion is an organization should pay more attention to developing a proper Power BI deployment strategy based on its own technical environment evaluation and related processes/standardizations to implement the strategy instead of focusing fancy "Self Service".

Thanks

Eric Dong

---
