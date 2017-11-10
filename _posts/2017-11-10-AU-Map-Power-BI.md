---
layout: post
title: How to draw an Australia Map with Label in Power BI by using R
image: /img/aumapsquare.jpg
tags:
  - R
  - Power BI
published: true
---

I’ve been struggling to get an Australia Map with _Label_ in **Power BI**, finally I crack it and I just want to share my experience to you guys.

---

### Limitations and Problems I met:

1. Existing Map function in Power BI can’t show label.
2. Packages like `map`, `worldmap` supported by Power BI service have NO Australia state boundaries data.
3. `oz package` in R includes state boundaries data, BUT Power BI service doesn’t support this package, and we can’t directly use it with `ggplot2`.
4. Drawing a map in R-studio is all good with prepared map data, but the map is teared up in Power BI by using the same code.

---

### Step1: Collect Australia state/coast boundaries data

Based on a lot of googling, I find this great [**post**](http://www.elaliberte.info/code), _Etienne Laliberté_ has already helped us to converted `ozRegion()` data to a data frame that can be used in `ggplot2`, which is super. So, download `ozdata.csv` file.

Becuase There is no ACT state boundaries in this data, I found official ACT data from [data.gov.au](https://data.gov.au/dataset/act-state-boundary-psma-administrative-boundaries). I spent a lot of efforts here to convert `shp` to `csv` file here, all failed. If you understand this kind of data type conversion, just use it.

You can also consolidate an Australia map based on [data.gov.au](https://data.gov.au) directly.

#### What I did are

- Click the third link to get JSON file
![Download JSON file from data.gov.au](/img/I2.png)
