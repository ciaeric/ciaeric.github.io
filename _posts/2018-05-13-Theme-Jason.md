---
layout: post
title: How to Setup Your Own Theme of PowerBI Reports
subtitle: Tips and Examples of creating JSON File
thumbnail-img: /assets/img/post5/avatar.png
tags:
  - PowerBI
  - Theme
  - JSON
  - Color palette
published: true
category: blog
---

When you start designing a lot of PowerBI reports, you will meet two questions. 
1. Company has a certain color palette for you to use, Or you want to make your own one.
2. The Matrix, Card ,etc. the frequently used visual, you want to make them consistent looking in every report with your design. But adjusting the format each time when adding them into a new report is really a waste of time.

Microsoft provides "Switch Theme" feature for us to design our own Theme template to solve above questions.
Actually Microsoft has already provides the [guidance](https://docs.microsoft.com/en-us/power-bi/desktop-report-themes), I just want to add some tips and detail example in this post.


---

### A simple theme with color palette only:

Follow the official [guidance](https://docs.microsoft.com/en-us/power-bi/desktop-report-themes) to enable the **Custom Report Theme** feature. And then create your own JSON file.

If you know Notepad++, you can directly create a JSON file. 
If not, simply new a Windows default Text Document

Paste below scripts into the file

```
{
	"name": "MyTheme",
	"dataColors": [
	"#56C5D0",
	"#FFD54B",
	"#4A4A49",
	"#fc6360",
	"#466BB4",
	"#ED9C29",
	"#74A6D9",
	"#3FC380"
	],
	"background":"#FFFFFF",
    "foreground": "#466BB4",
    "tableAccent": "#4A4A49"
}
```
Save the file, if it's a Text Document, change the extension name from **.txt** to **.json**  

Then import the JSON file, you will get below theme color.

![sample](/assets/img/post5/Image1.png)

The official [guidance](https://docs.microsoft.com/en-us/power-bi/desktop-report-themes) explained above codes
>That JSON file has the following required lines:

>**name** - this is the theme name, which is the only required field
>
**dataColors** - A list of hexcode color codes to use for data in Power BI Desktop visuals. The list can contain as many or as few colors as desired
>
**background, foreground, and tableAccent** - These values are colors that should be used in table and matrix >visuals. How you use these colors depends on the specific table or matrix style applied. The table and >matrix visuals apply these styles by default.

Tips here are using tools to get Hex Color Code from different sources.

1. Select your own color by using free online tool [**color picker**](https://htmlcolorcodes.com/color-picker)

![online](/assets/img/post5/Image2.png)

2. The color palette is only a picture. Then use free tool [**PicPick**](http://ngwin.com/picpick) to get the Hex Color Code

-Select "Color Picker" tool

![picker](/assets/img/post5/Image3.png)

-Mouse over the part in the picture with the color you want, then click, you will get below color palette with Hex Color Code

![code](/assets/img/post5/Image4.png)

3. If you have RBG color code, you could also use above PicPick to get Hex Color Code.


---
### Custom format frequently used Visuals:


>Beginning with the September 2017 release of Power BI Desktop, the JSON file can be much more elaborate. In the JSON file, you only define the formatting that you want to affect, and anything not specified in your JSON file simply reverts to the Power BI default settings.

As official [guidance](https://docs.microsoft.com/en-us/power-bi/desktop-report-themes) has listed all the properties. I will just give you guys some example as below, which is also the theme I am using.


**Slicer**
```
"slicer": {
			"*": {
				"general": [{
					"outlineColor": { "solid": { "color": "#444444"}},
					"outlineWeight": 1,
					"orientation": "horizontal",
					"responsive": true
				}],
				"data": [{
					"mode": "Basic",
					"relativeRange": "",
					"relativePeriod": ""
				}],
				"selection": [{
					"selectAllCheckboxEnabled": false,
					"singleSelect": true
				}],
				"header": [{
					"show": true,
					"fontColor": { "solid": { "color": "#000000"}},
					"background": { "solid": { "color": ""}},
					"outline": "None",
					"textSize": 10,
					"fontFamily": "Segoe UI"
				}],
				"items": [{
					"fontColor": { "solid": { "color": "#FFFFFF"}},
					"background": { "solid": { "color": "#466BB4"}},
					"outline": "None",
					"textSize": 11,
					"fontFamily": "Segoe UI"
				}]
			}
		}
```

**Matrix**
```
"pivotTable": {
			"*": {
				"grid": [{
					"gridVertical": true,
					"gridVerticalColor": { "solid": { "color": "#FFFFFF"}},
					"gridVerticalWeight": 1,
					"gridHorizontal": true,
					"gridHorizontalColor": { "solid": { "color": "#FFFFFF"}},
					"gridHorizontalWeight": 1,
					"rowPadding": 2,
					"outlineColor": { "solid": { "color": "#FFD54B"}},
					"outlineWeight": 1,
					"textSize": 8,
					"imageHeight": 75
				}],
				"columnHeaders": [{
					"fontColor": { "solid": { "color": "#ffffff"}},
					"backColor": { "solid": { "color": "#466BB4"}},
					"outline": "Bottom Only",
					"autoSizeColumnWidth": true,
					"fontFamily": "Segoe UI",
					"fontSize": 8,
					"alignment": "Left",
					"urlIcon": true,
					"wordWrap": true
				}],
				"rowHeaders": [{
					"fontColor": { "solid": { "color": "#ffffff"}},
					"backColor": { "solid": { "color": "#466BB4"}},
					"outline": "Right Only",
					"stepped": true,
					"steppedLayoutIndentation": 10,					
					"urlIcon": true,
					"wordWrap": true,
					"fontFamily": "Segoe UI",
					"fontSize": 8,
					"alignment": "Left"
				}],
				"values": [{
					"fontColorPrimary": { "solid": { "color": "#4A4A49"}},
					"backColorPrimary": { "solid": { "color": "#ffffff"}},
					"fontColorSecondary": { "solid": { "color": "#4A4A49"}},
					"backColorSecondary": { "solid": { "color": "#f0f3f9"}},
					"bandedRowHeaders": true,
					"valuesOnRow": false,
					"outline": "None",
					"urlIcon": true,
					"wordWrap": true,
					"fontFamily": "Segoe UI",
					"fontSize": 8
				}],
				"subTotals": [{
					"rowSubtotals": true,
					"columnSubtotals": false,
					"fontColor": { "solid": { "color": ""}},
					"fontFamily": "Segoe UI",
					"backColor": { "solid": { "color": ""}},
					"fontSize": 8,
					"applyToHeaders": false,
					"rowSubtotalsPosition": "Top",
					"perRowLevel": false,
					"perColumnLevel": false					
				}],
				"total": [{
					"fontColor": { "solid": { "color": "#ffffff"}},
					"fontFamily": "Segoe UI",
					"backColor": { "solid": { "color": "#466BB4"}},
					"applyToHeaders": false,
					"fontSize": 8
				}]
			}
		}
```

**Table**
```
"tableEx": {
			"*": {
				"grid": [{
					"gridVertical": true,
					"gridVerticalColor": { "solid": { "color": "#FFFFFF"}},
					"gridVerticalWeight": 1,
					"gridHorizontal": true,
					"gridHorizontalColor": { "solid": { "color": "#FFFFFF"}},
					"gridHorizontalWeight": 1,
					"rowPadding": 2,
					"outlineColor": { "solid": { "color": "#FFD54B"}},
					"outlineWeight": 1,
					"textSize": 8,
					"imageHeight": 75
				}],
				"columnHeaders": [{
					"fontColor": { "solid": { "color": "#ffffff"}},
					"backColor": { "solid": { "color": "#466BB4"}},
					"outline": "Bottom Only",
					"autoSizeColumnWidth": true,
					"fontFamily": "Segoe UI",
					"fontSize": 8,
					"alignment": "Left",
					"wordWrap": true
				}],
				"values": [{
					"fontColorPrimary": { "solid": { "color": "#4A4A49"}},
					"backColorPrimary": { "solid": { "color": "#ffffff"}},
					"fontColorSecondary": { "solid": { "color": "#4A4A49"}},
					"backColorSecondary": { "solid": { "color": "#f0f3f9"}},
					"outline": "None",
					"urlIcon": true,
					"wordWrap": true,
					"fontFamily": "Segoe UI",
					"fontSize": 8
				}],
				"total": [{
					"totals": true,
					"fontColor": { "solid": { "color": "#ffffff"}},
					"backColor": { "solid": { "color": "#466BB4"}},
					"outline": "None",
					"fontFamily": "Segoe UI",
					"fontSize": 8
				}]
			}
		}
```

**Multi-row Card**
```
"multiRowCard": {
			"*": {
				"dataLabels": [{
					"color": { "solid": { "color": "#4A4A49"}},
					"fontSize": 12,
					"fontFamily": "Segoe UI"
				}],
				"categoryLabels": [{
					"show": true,
					"color": { "solid": { "color": "#466BB4"}},
					"fontSize": 12,
					"fontFamily": "Segoe UI"
				}],
				"cardTitle": [{
					"color": { "solid": { "color": "#4A4A49"}},
					"fontSize": 10,
					"fontFamily": "Segoe UI"
				}],
				"card": [{
					"outline": "None",
					"outlineColor": { "solid": { "color": ""}},
					"outlineWeight": 1,
					"barShow": true,
					"barColor": { "solid": { "color": "#FFD54B"}},
					"barWeight": 3,
					"cardPadding": 20,
					"cardBackground": { "solid": { "color": ""}}
				}]
			}
		}
```

The whole JSON file will be like 

```
{
"name": "MyTheme",
	"dataColors": [
	"#56C5D0",
	"#FFD54B",
	"#4A4A49",
	"#fc6360",
	"#466BB4",
	"#ED9C29",
	"#74A6D9",
	"#3FC380"
	],
	"background":"#FFFFFF",
    "foreground": "#466BB4",
    "tableAccent": "#4A4A49",
"visualStyles": {
----Above code of each format visual, by using "," to split-----
                }
}
```

Now, you can create your own Theme now, have fun!~



Thanks
Eric Dong

---
