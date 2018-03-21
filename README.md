# engine

This folder includes coding work for the Future of Military Engines project. 

There are three main datasets. 

1. **inventory**: `USAF aircraft inventory` / `engines` / `specs` (.../inventory) 

2. **contracts**: Federal Procurement Data System (FPDS) contract numbers for military engines (.../contracts) 

3. **budget**: Future Years Defense Program RDTE funding for military engines (.../budget) 

# 1. inventory 

The purpose of the inventory dataset is to map out the history of USAF engine trends from 1950-present. This includes the number of aircraft, the number of engines, the age of the fleet, and performance specs of the entire fleet. 

**Aircraft inventory**

We began with a 2010 Air Force Association report, “Arsenal of Airpower: USAF Aircraft Inventory 1950-2009." This report provides the number of each platform that make up the USAF Total Aircraft Inventory. We then used the USAF Almanacs from 2010 to 2017 to update the inventory numbers. With this information, we had four variables: aircraft, type, year, and amount. 

**Engine inventory**

We then added a new variable, engine, which identifies the engine for every platform. For instance, the F-35 has the F135 and the F-22 has the F119. Further, we determined the number of engines for each platform and created the variable: engine_amount. For instance, the F-35 only has one engine and the F-22 has two. 

**Aircraft performance specs**

We identified the most relevant and consistently available aircraft performance specs for FighterAttack. These variables included: takeoff weight, speed, range, ceiling, climb rate, and thrust to weight ratio of the aircraft. 

**Engine performance specs** 

We identified the most relevant and consistently available engine performance specs for FighterAttack that had turbojet or turbofan engines. These variables included: maximum thrust, overall pressure ratio, engine weight, and thrust to weight ratio of the engine.

**Weaknesses**

This dataset has two main weaknesses. 1) While it is more comprehensive than any other publicly available dataset on aircraft and engines, it lacks data for some major categories. For example, we did not assign performance specs for other categories beyond FighterAttack and we did not assign engine inventory data to Helicopter or Trainer aircraft. This is due mainly to the limited scope of this project and to the limited sources that have this type of information. 2) For performance specs, we relied heavily on Wikipedia pages. The primary sources listed on these pages were generally reputable (i.e. Jane’s all the World’s Aircraft), especially for heavily produced aircraft. And when the sources were not listed or the numbers were unclear, we found secondary sources or made assumptions based on our analysis of other platforms. Despite these shortcomings, this dataset is a valuable resource for this project because we have a high degree of confidence in the numbers for heavily produced aircraft and because we are focused on overall trend analysis.  

**Inventory variables** 

`aircraft`: the name of each platform 

`type`: the type of aircraft. Includes: Bomber, FighterAttack, Helicopter, Recon, Tanker, Trainer, and Transport

`year`: the fiscal year  

`amount`: the number for each platform in the USAF Total Active Inventory 

`engine`: the name of each engine

`engine_type`: the type of engine. Includes: Radial, Turbofan, Turbojet, Turboprop, and Turboshaft 

`engine_number`: the number of engines on the specific aircraft 

`engine_company`: the main manufacturer for each engine 

`takeoff_weight`: max listed takeoff weight in pounds 

`speed`: max listed speed in mph

`range`: max listed range in mi 

`ceiling`: max listed service ceiling in ft 

`climb_rate`: listed rate of climb in ft/min

`thrust_weight_aircraft`: listed thrust/weight ratio of the aircraft

`thrust`: max listed thrust of the engine in lbs  

`pressure_ratio`: listed overall pressure ratio 

`engine_weight`: listed engine weight in lbs 

`thrust_weight_engine`: listed thurst/weight ratio of the engine 

`intro_year`: the first year that the aircraft appeared in the USAF Total Active Inventory 

`peak_amount`: the max amount for each aircraft between 1950 - present

`generation`: the fighter generation for FighterAttack aircraft 

# 2. contracts

**FPDS methodology**

For nearly a decade, the Defense-Industrial Initiatives Group (DIIG) has issued a series of analytical reports on federal contract spending for national security across the government. These reports are built on FPDS data, presently downloaded in bulk from USAspending.gov. DIIG now maintains its own database of federal spending, including years 1990–2017, that is a combination of data download from FPDS and legacy DD350 data. For this report, however, the study team primarily relied on FY2000–2017. Data before FY2000 require mixing sources and incur limitations.

**Inherent restrictions of FPDS**

Since the analysis presented in this report relies almost exclusively on FPDS data, it incurs four notable restrictions. First, contracts awarded as part of overseas contingency operations are not separately classified in FPDS. As a result, we do not distinguish between contracts funded by base budgets and those funded by supplemental appropriations. Second, FPDS includes only prime contracts, and the separate subcontract database (Federal Subaward Reporting System, FSRS) has historically been radically incomplete; only in the last few years have the subcontract data started to approach required levels of quality and comprehensiveness. Therefore, only prime contract data are included in this report. Third, reporting regulations require that only unclassified contracts be included in FPDS. We interpret this to mean that few, if any, classified contracts are in the database. For DoD, this omits a substantial amount of total contract spending, perhaps as much as 10 percent. Such omissions are probably most noticeable in R&D contracts. Finally, classifications of contracts differ between FPDS and individual vendors. For example, some contracts that a vendor may consider as services are labeled as products in FPDS and vice versa. This may cause some discrepancies between vendors’ reports and those of the federal government.

**Constant dollars and fiscal years**

All dollar amounts in this data analysis section are reported as constant FY 2016 dollars unless specifically noted otherwise. Dollar amounts for all years are deflated by the implicit GDP deflator calculated by the U.S. Bureau of Economic Analysis, with FY2016 as the base year, allowing the CSIS team to more accurately compare and analyze changes in spending across time. Similarly, all compound annual growth values and percentage growth comparisons are based on constant dollars and thus adjusted for inflation. Due to the native format of FPDS and the ease of comparison with government databases, all references to years conform to the federal fiscal year. FY2017, the most recent complete year in the database, spans from October 1, 2016, to September 30, 2017.

Any analysis based on FPDS information is naturally limited by the quality of the underlying data. Several Government Accountability Office (GAO) studies have highlighted the problems of FPDS (for example, William T. Woods’ 2003 report “Reliability of Federal Procurement Data,” and Katherine V. Schinasi’s 2005 report “Improvements Needed for the Federal Procurement Data System—Next Generation”).

In addition, FPDS data from past years are continuously updated over time. While FY2007 was long closed, over $100 billion worth of entries for that year were modified in 2010. This explains any discrepancies between the data presented in this report and those in previous editions. The study team changes over prior-year data when a significant change in topline spending is observed in the updates. Tracking these changes does reduce ease of comparison to past years, but the revisions also enable the report to use the best available data and monitor for abuse of updates. 

Despite its flaws, FPDS is the only comprehensive data source of government contracting activity, and it is more than adequate for any analysis focused on trends and order-of-magnitude comparisons. To be transparent about weaknesses in the data, this report consistently describes data that could not be classified due to missing entries or contradictory information as “unlabeled” rather than including it in an “other” category.

The 2016 data used in this report were downloaded in January 2017. The 2017 data used in this report were downloaded in January 2018; a full re-download of all back-year data was performed simultaneously.

# 3. budget

  
