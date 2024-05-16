---
layout: post
title: How to Create Custom Function in Power BI
subtitle:  Geocoding in Power BI by connecting API
thumbnail-img: /assets/img/post7/avatar.png
tags:
  - PowerBI
  - Geocoding
  - Custom Function
  - API
published: true
category: blog
---

This blog introduces how to create a "custom function" in Power BI, and I am using geocoding in Power BI by connecting API as a practice.

To be honest, at first beginning I think if I want to create a powerful custom function, I have to grasp M language at a certain level first to do this job, because all the samples I've seen are with many lines M scripts. 

After some practice I realized, actually custom function is **not that difficult**. *(Of course, grasping M language might help us generating more powerful Custom Function)*

Why?

1. **Custom Function** is just like **a formula to solve a math problem**. E.g. f(x) = x + 2 , you give x a value "1", the function gives the result "3", and it's **reusable**. The difference is that you might have a more complex problem with multiple steps to solve. But, the concept is the same.

2. **Creating Custom Function** in Power BI is **you solve a sample of problem first, then replace that sample as a parameter, DONE**!  

---

### Scenario:

Normally we directly put address fields (country, state, postcode,etc) in to a Power BI Map tile if the data is **not geocoded in database**, and the issues could be


- Sometimes the locations on the map are **not correctly** shown up. 
- **Take very long time** if you have thousands rows of address, my guess is the map visual is geocoding the address in background process. 

So if we feed Longitude and Latitude to the map visual directly, we will get correct results more efficiently. There are a lot of Geocoding API provider for using, and what we are going do is connecting Geocoding API to retrieve Longitude and Latitude directly in Power BI.

---

### Preparation:

I applied an API Key from [MapQuest](https://developer.mapquest.com/) which provides 15,000 free transactions per month. You could also use Google API or any other provider you like. 

![mapquest](/assets/img/post7/Image2.png)


And I got the Get URL from [Documentation](https://developer.mapquest.com/documentation/geocoding-api/) like below

```
https://www.mapquestapi.com/geocoding/v1/address?key=KEY&location=Washington,DC
```

The KEY in this URL needs to be replaced later with my own KEY.


---

### Create Custom Function:

As I said previously, what we need to do first is **simply solve one problem by using one sample**. In this case it is geocoding one address. Let's go!

**Step 1:** This step is to record all the steps of solving problem.

Get data from Web, input the Get URL and replace two parts: 

- "KEY" to the API KEY you applied
- "Washington,DC" to the sample we would like use, I use "Leon Capra Dr, Augustine Heights, QLD, 4300" for this case

![key](/assets/img/post7/Image3.png)

The result is coming back as JSON file, so we need to transform it to the format you could use, below couples of steps to doing that

- Expand list

![key](/assets/img/post7/Image4.png)


- Expand record

![key](/assets/img/post7/Image5.png)

- Expand list

![key](/assets/img/post7/Image6.png)

- Transform to table

![key](/assets/img/post7/Image7.png)

- Expand to columns, select the columns we need, in this case is "latLng"

![key](/assets/img/post7/Image8.png)

- Keep expanding columns

![key](/assets/img/post7/Image11.png)

- Rename column names

![key](/assets/img/post7/Image12.png)

After above transformation, we all know these **transformation steps are recorded**, and when we open advanced editor, we find the **M scripts are coded there.** And **this is the major part of our custom function.**

![key](/assets/img/post7/Image13.png)

I put an address without street number on purpose, as Mapquest sometimes returns more than one result. As we only need one result for one address, we need to record transformation steps of filtering one result.

- Add index column

![key](/assets/img/post7/Image15.png)

- Filter to get one result only

![key](/assets/img/post7/Image16.png)

Till now, the first step is done!

**Step 2:**
This step is to replace the sample with parameter.

Create a parameter

![key](/assets/img/post7/Image17.png)

Right click the table we are working on, select "create function"

![key](/assets/img/post7/Image18.png)

![key](/assets/img/post7/Image20.png)

It should be like this, you will find there is no parameter to use for now.

![key](/assets/img/post7/Image21.png)

Open Advanced editor of function, add "Location as text" in bracket and replace the sample "Leon Capra Dr, Augustine Heights, QLD, 4300" with parameter we just created ' "&Location" '

![key](/assets/img/post7/Image31.png)

**Congratulations! Your custom function is created.**


### Consume Custom Function:

Now let's try the function.

- Go to the table with the address column you would like to geocode, and select **"Invoke Custom Function"**

![key](/assets/img/post7/Image22.png)

- Select the function and the column for location parameter

![key](/assets/img/post7/Image23.png)

- Result is coming back, simply expand the columns

![key](/assets/img/post7/Image26.png)

![key](/assets/img/post7/Image28.png)

- Play with it in the map visual

![key](/assets/img/post7/Image30.png)

You see? Looks like we have a lot of steps of creating this custom function. Actually there are only two major steps. Hopefully this blog helps.


Thanks
Eric Dong

---