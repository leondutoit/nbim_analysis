*** Creating a world map of the investments --> total & proportional value of bonds


/*
--------------------------------------------- 

DOCSTRING

This do-file creates a world map showing the distribution of government bond investments
for the Norwegian Government Pension Fund. In this implementation December 2011 data are
used.

Dependencies - Stata user-written commands:
	- spmap
	- shp2data
	- mfi2dta (although this is not used here it may well have been)

Worldmap source: http://aprsworld.net/gisdata/world/

-----------------------------------------------
*/





*uncomment this when using this for the first time:
// shp2dta using world, database(world_database) coordinates(world_coords) genid(id)

use world_database.dta, clear
des
li in 1/10


* create strings to match on -> lowercase no space

gen lcname = "."
replace lcname = lower(NAME)
li NAME lcname in 1/10


* merge 1:1

merge 1:1 id using mergedata

* fix Canada data by brute force:

replace value_mill = 120.4541 in 243
replace pc_bond_govbonds = .9011047 in 243
replace country = "Canada" in 243

* World Map

spmap pc_bond_govbonds using world_coords, id(id) fcolor(Blues) ///
title("Value distribution - Norwegian Oil Fund's government bond investments", margin(5 2 5 2)) ///
legend(	///
		title("Proportion of portfolio", size(*0.5)) ///
		position(8) ///
		region(lcolor(black) fcolor(white)) ///
		lab(1 "No Investment") ///
		lab(2 "0 	  - 	  0.02 %") ///
		lab(3 "0.02 	- 	1 %") ///
		lab(4 "1 	  -	  10 %") ///
		lab(5 "10 	 -	 18 % ") ///
	)


graph export map_percentage.png, replace




*clear all
