
# Milestone 2 - Writeup

## Rationale

The Crime Buster App is a classic tool for anyone who wants insights into the crime situation in particular area in the United States of America, including citizens who are concerned with the safety of their local area or someone moving to a new location. This app is also potentially useful for sheriffs to plan the deployment of their police force based past crimes and incidents. The Crime Buster App helps visualize incidental data of robbery, rape, assault and homicide reported from 1975 to 2014.

## Description of the App :

Crime data over a period of 40 years (1975 and 2015) has been complied under the Marshall project from the FBI's Uniform Crime Reporting (UCR) Program. The most serious crime incidents namely robbery, rape, assault and homicides from 68
police jurisdictions have been used for creating the Crime_buster_App.

The data under consideration has the following features :

| Features   | Description   |
|---|---|
|`State`   | State within Unites States  |
|`Department`   |  Jurisdiction  |
| `year`  |  Year of consideration |
| `violent_crime` , `violent_per_100k`  | Total Violent crimes and crimes per 100k residents  |
| `homs`,`homs_per_100k`  | Total Homicides and homicides per 100k residents |
| `rape`, `rape_per_100k`  | Total Rapes and rapes per 100k residents   |
|  `rob`,`rob_per_100k` |  Total robberies and robberies per 100k residents  |
|`assault`,`agg_ass_per_100k`| Total assaults and assaults per 100k residents  |

The app in its current form us contains the information about the major jurisdictions of 6 states viz. Texas, Arizona, California, Colorado and New York of Unites States of America.
Information about the four major crime incidents viz. Robbery, Assault, Rape and Homicide in total and per 100,000 residents of have been can be seen on the app.

## Data Extraction :

R Studio has been used for data wrangling and any further modification in the app shall be done through the src and app scripts written in R Studio. Departments have been combined State
wise covering the 6 major States. There are some missing entries in the data but the missing data will not create any hindrance in the usage of the app. Some of the Departments did not
data for 12 months. Crime incidents for any such department with the data for more than 9 months but less than 12 months has been scaled to 12 months. Besides the number of incidents in total
and per 100,000 residents user can also extract the proportion of the occurrence of any of the four crimes per total crimes in the area. This additional information can shed some light for
Police to infer what kind of crimes lets say incidents of Robbery have been more frequent in their jurisdiction.

## Usage of the app :

The app is highly user friendly and easy to use. <br> The Interface looks like the image below and it contains following features:

![Usage](/figure/CromeBusters_App.PNG)

1. Year Slider (Slider)
2. State Selector (Drop Down)
3. Department Selector (Drop Down)
4. Count Measurement choice (Drop Down)
5. Crime Type Selector (Check Box)

##### 1. Year Slider

![Year](/figure/Year_Slider.PNG)

The Year slider can be used to choose from 1975 to 2014 by just sliding the bar. All the
results will be displayed only for the chosen year range.

##### 2. State Selector

![State_Selector](/figure/State_Selector_1.PNG)

The State selector can be used to choose the state for which we want to see the crime data.
Users can chose out of the shown 6 states.

##### 3. Department Selector

![Dep_selector](/figure/Dep_Selector.PNG)

User can chose out of total 30 departments/Jurisdictions and see the crime data for specific department within that state.

#### 4. Count Measurement choice

![](/figure/Count_Measure.PNG)

User can choose to see the data for either total number of crimes in the area or crimes per 100,000 residents of the area.

#### 5. Crime Type choice

![](/figure/Crime_type.PNG)

User can also select out of the 4 crimes for which he/she is interested in looking at the data.

There are two outputs that the user gets after all these selections :

#### Panel 1

![](/figure/Crime_Line_Plot.PNG)

Panel 1 shows the line plot for the selected State, Department and the year of interest. Different
crimes are shown for each of these years through different colors as shown by the legend.

#### Panel 2

![](/figure/Usage1.PNG)

User also gets access to the bar charts showing the proportion of different crimes out of the
total crime incidents in that jurisdiction.
The plots like this shows that there have been few incidents of homicides out of the total crime reported
but much more Assault and Robberies in this area. Police can take necessary steps accordingly.

#### Table 1

![](/figure/Table.PNG)

Not just the plots if the user is interested he/she can get the to see the table with the number of incidents in the specific
jurisdiction for the chosen year.

We hope that the app will be helpful to the police and citizens in getting information
about the crime situations around them.
