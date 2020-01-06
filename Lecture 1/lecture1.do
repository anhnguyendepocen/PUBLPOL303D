/* Lecture 1
PUBLPOL 330D Winter 2020
Jack Blundell 
	
Worked example of analysis of lalonde 1986 data.
Structure:
0. Setup
1. Import raw data
2. Clean data
3. Explore data
4. Test for differences in means by group 
*/	

*** 0. Setup

// clear all existing data and other objects
clear
	
// allow stata to print large output to screen
set more off

// set working directory (this folder should contain lalonde_experiment.txt)
cd "~/Dropbox/Documents/Teaching/PUBLPOL330D/Lectures/Lecture 1"

// close any existing log file
capture log close

// open new log
log using "lecture1log", replace

*** 1. Import raw data

// import the raw data
import delimited "lalonde_experiment.txt", delimiter(" ", collapse)

*** 2. Clean the data

// tidy variables
drop v1
rename v2 t
rename v3 y
label variable t "Treatment"
label variable y "Earnings ($1,000's)"

// check variable names and types	
describe

// convert t to numeric
destring t, replace force

// check types again
des

// check for missing values	
generate missing_y = 0
replace missing_y = 1 if y == .
tabulate missing_y

// drop if missing y
drop if missing_y == 1

// save cleaned dataset
save "lalonde_clean.dta", replace

*** 3. Explore data

// load cleaned data
use "lalonde_clean.dta", clear

// summarize variables
summarize y
sum y, detail
tab t
				
// histogram of earnings
histogram y, width(1)
graph export "histogram_y.png", width(500) replace
	
*** 4. Test for differences in means by group 

// summarize by treatment
sum y if t == 0
sum y if t == 1

// box plot by treatment	
graph box y, by(t)
graph export "boxplot_y_by_t.png", width(500) replace

// t-test for difference in y by t
ttest y, by(t)

// export t-test		
estpost ttest y, by(t)
esttab using "ttest_y_by_t.rtf", replace

// close the log file
log close
