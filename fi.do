

*****		FI Portfolio Data 2011 December			****


/*
---------------------------------------------------------

DOCSTRING

This do-file summarizes the NBIM's bond porfolio - for holdings
as of December 2011. This includes government, corporate and other types
of bonds.

The main outputs of this file are:
	- summary of bond investments (visualization)
	- preparation of data for mapping

-----------------------------------------------------------
*/


log using govbonds, smcl replace

*setup and get data from pwd

clear all
set more off
set matsize 800
insheet using holdings.csv, clear
gen id = _n

* have a look...

li in 1/10
su
des


*create some useful variables and check them out

* value in millions of NOK
gen value_mill = value/100000000  

di 	"0: corporate" _newline ///
	"1: government" _newline ///
	"2: subnational" _newline ///
	"3: supra-national" _newline ///
	"4: organization"

forvalues x = 0/4 {
	su value_mill if gov == `x'
}

su value_mill if gov == 1, det

* which governments' bonds? 
gsort -value_mill 
li value_mill country if gov == 1
li country value_mill if gov == 1 & value_mill > 500 // top 5 gov bonds

sort id
li id in 1/5 

* get totals of categories of bonds in scalars

quietly su value_mill
scalar totalbonds = r(sum)
di totalbonds


*absolute contributions of types to portfolio

forvalues i = 0/4 {	
	quietly su value_mill if gov == `i'
	scalar bondtype`i' = r(sum)
	di "total value of bond type `i': " bondtype`i' 
}

* percentage share of types in portfolio

forvalues i = 0/4 {
	scalar bondtype`i'_pc = (bondtype`i' / totalbonds*100)
	di "percentage of total for bond type `i': " bondtype`i'_pc 
}

* percentage share of individual countries relative to all countries

gen pc_bond_govbonds = value_mill/totalbonds*100
gsort -pc_bond_govbonds
li country pc_bond_govbonds if gov == 1 
sort id

*** Value of all bonds by type in millions of NOK: a figure

quietly scatter value_mill id if gov == 0, mcolor(green) ///
|| scatter value_mill id if gov == 1, mcolor(blue) ///
|| scatter value_mill id if gov == 2, mcolor(orange) ///
|| scatter value_mill id if gov == 3, mcolor(black) ///
|| scatter value_mill id if gov == 4, mcolor(yellow) ///
	title("Value of bonds in GPFG's portfolio (by type)", margin(5 2 5 2)) ///
	ytitle("Bond value (millions, NOK)") ///
	ylab(, angle(hor) labsize(medium) format(%12.0fc)) ///
	xlab(, format(%12.0fc)) ///
	yscale(nofextend) xscale(nofextend) ///
	plotregion(margin(5 2 5 2)) ///
	xtitle("Bonds") ///
	legend(label(1 "Corporate") label(2 "Government") label(3 "Subnational") ///
		label(4 "Supra-national") label(5 "Organization")) ///
	graphregion(fcolor(255 255 255))
graph export bond_graph.png, replace

/*

notes: ytitle(, margin ($1 $2 $3 $4))
	$1: padding between y-title text and edge pf graphic space
	$2: distance away from y-axis
	$3: padding from bottom
	$4: padding from top
*/



* create subset of data  to merge on mergetest

keep if gov == 1
gen lcname = "."
replace lcname = lower(country)
drop id
 


* outsheet to csv; enter id's to merge on (brute force is not beautiful...)

outsheet country value_mill pc_bond_govbonds using map_data, comma replace
clear

insheet using map_data.out
gsort country
input id
201
23
73
19
144
242
88
217
124
72
24
212
168
89
231
111
100
. // Hong Kong not included in the map
28
101
222
80
48
235
84 
36
20
104
175
203
142
109
105
75
98
74
30
25
107
137
87
221
91
227
229


li 
save "mergedata.dta", replace



log close
translate govbonds.smcl govbonds.pdf, replace
clear all 		





