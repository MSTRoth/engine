# engine

This folder includes coding work for the Future of Military Engines project. 

There are three main datasets. 

1. `USAF aircraft inventory` / `engines` / `specs` (.../inventory) 

2. Future Years Defense Program RDTE funding for military engines (.../fydp) 

3. Federal Procurement Data System contract numbers for military engiens (.../fpds) 

``` r
library(ggplot2)

ggplot(mpg, aes(displ, hwy, colour = class)) + 
  geom_point()
```

Inventory 

The purpose of the inventory dataset is to map out the history of USAF engine trends from 1950-present. This includes the number of aircraft, the number of engines, the age of the fleet, and performance specs of the entire fleet. 

Aircraft inventory: We began with a 2010 Air Force Association report, “Arsenal of Airpower: USAF Aircraft Inventory 1950-2009”. This report provides the number of each platform that make of the USAF Total Aircraft Inventory. We then used the USAF Almanacs from 2010 to 2017 to update the inventory numbers. With this information, we had four variables: aircraft, type, year, and amount. 

Engine inventory: We then added a new variable, engine, which identifies the engine for every platform. For instance, the F-35 has the F135 and the F-22 has the F119. And, we determined the number of engines for each platform and created the variable: engine_amount. For instance, the F-35 only has one engine and the F-22 has two. 

Aircraft performance specs: We identified the most relevant and consistently available aircraft performance specs for FighterAttack. These variables included: takeoff weight, speed, range, ceiling, climb rate, and thrust to weight ratio of the aircraft. 
Engine performance specs: We identified the most relevant and consistently available engine performance specs for FighterAttack that had turbojet or turbofan engines. These variables included: maximum thrust, overall pressure ratio, engine weight, and thrust to weight ratio of the engine.

This dataset has two main weaknesses. 1) While it is more comprehensive than any other publicly available dataset on aircraft and engines, it lacks data for some major categories. For example, we did not assign performance spec for other categories beyond FighterAttack and we did not assign engine inventory data to Helicopter or Trainer aircraft. This is due mainly to the limited scope of this project and to the limited sources that have this type of information. 2) For performance specs, we relied heavily on Wikipedia pages. The primary sources listed on these pages were generally reputable (i.e. Jane’s all the World’s Aircraft), especially for heavily produced aircraft. And when the sources were not listed or the numbers were unclear, we found secondary sources or made assumptions based our analysis of other platforms. Despite these shortcomings, this dataset is a valuable resource for this project because we have a high degree of confidence in the numbers for heavily produced aircraft and because we are focused on overall trend analysis.  

Inventory variables 

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



  
