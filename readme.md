This repo contains files to describe the Norges Bank Investment Management's (NBIM) holdings of government bonds - as of December 2011.

Data is captued in the .csv file.
Stata .do files contain commands that create a data summary and visualizations.
Among these, there is an ESRI world map plot showing the value distribution of bonds over all countries. This is accomplished by using the Stata spmap package in conjunction with the .dbf .dhp and .shx files.

To recreate the results first run 'fi.do' and then 'wmap.do'.
To investigate the data summary open the 'govbonds.smcl' logfile created by Stata.

The spmap package is user-written and does not ship with Stata. You can 'findit spmap' and install.