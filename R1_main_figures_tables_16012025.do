/*
The COVID-19 pandemic changed the socioeconomic composition of parents: A register-based study of 77.9 million live births in 15 countries

Code: Moritz Oberndorfer

Code for Figures and tables in REVISED main manuscript:

Producing estimates shown in Figures 1,2,3
Figure 1
Figure 2
Figure 3

Producing estimates shown in Figures 4
Figure 4

Table 1


*/
**# Bookmark #6
*********Producing estimates shown in Figures 1,2,3**********

/*
create time series with prop for all countries
Top and bottom income quintile: Finland, Netherlands, Denmark, Sweden
Area deprivation: England, Scotland, Wales, Brazil, Ecuador, South Australia
Education: Austria, Colombia, Spain, USA, Mexico

DATA CONTAINS:
top and bottom prop
top and bottom nr of births
predicted number of births for top and bottom
deseasonalised fitted number of births for top and bottom
counterfactual deseasonalised fitted number of births for top and bottom


create time series for all countries and make on data set out of it
*top_prop ... # live births in least disadvantaged group / # all live births
*bot_prop ... # live births in most disadvantaged group / # all live births

For income countries: top_prop ...top 20% income 
For income countries: bot_prop ...bottom 20% income 
For area deprivation countries: top_prop ...20% least disadvantaged areas 
For area deprivation countries: bot_prop ... 20% most disadvantaged areas
For maternal education countries:  top_prop ... Post-secondary + Tertiary education 
For maternal education countries:  bot_prop ... Lower secondary education or lower (primary, none)

*/

clear all
global username "`c(username)'"
dis "$username" // Displays your user name on your computer
if "$username" == "moritzob" {
global master = "C:\Users\moritzob\OneDrive - University of Helsinki\postdoc life helsinki\LoCo-effect\International exchangeability paper\Comparative figures"
global code "C:\Users\moritzob\OneDrive - University of Helsinki\postdoc life helsinki\LoCo-effect\International exchangeability paper\Comparative figures\scripts"
global log 		"C:\Users\moritzob\OneDrive - University of Helsinki\postdoc life helsinki\LoCo-effect\International exchangeability paper\Comparative figures\out\log"
global dta 		"C:\Users\moritzob\OneDrive - University of Helsinki\postdoc life helsinki\LoCo-effect\International exchangeability paper\Comparative figures/dta"
global docx 	"C:\Users\moritzob\OneDrive - University of Helsinki\postdoc life helsinki\LoCo-effect\International exchangeability paper\Comparative figures\out\docx"
global graph  	"C:\Users\moritzob\OneDrive - University of Helsinki\postdoc life helsinki\LoCo-effect\International exchangeability paper\Comparative figures\out\graphs"
global table 	"C:\Users\moritzob\OneDrive - University of Helsinki\postdoc life helsinki\LoCo-effect\International exchangeability paper\Comparative figures\out\tables"
}


*************************** AUSTRIA AUSTRIA AUSTRIA ******************************
*************************** AUSTRIA AUSTRIA AUSTRIA ******************************
*************************** AUSTRIA AUSTRIA AUSTRIA ******************************
*************************** AUSTRIA AUSTRIA AUSTRIA ******************************

use "C:\Users\moritzob\OneDrive - University of Helsinki\postdoc life helsinki\LoCo-effect\LoCo-effect Austria\dta\Austria_births_2015.dta",clear
* overview of educational system
* https://gpseducation.oecd.org/CountryProfile?primaryCountry=AUT&treshold=10&topic=EO
* data access restricted - indvidual-level data

* compulsory vs post-secondary
tab BILDUNG_M, m
/*
gen mom_edu_comp=. 
replace mom_edu_comp=1 if BILDUNG_M==1 // Compulsory school (ISCED 2 - lower secondary school)
replace mom_edu_comp=2 if BILDUNG_M==2 // Apprenticeship (ISCED 3)
replace mom_edu_comp=3 if BILDUNG_M==3 // Intermediate technical & vocational school (ISCED 3)
replace mom_edu_comp=4 if BILDUNG_M==4 // Academic upper secondary school (ISCED 3)
replace mom_edu_comp=5 if BILDUNG_M>4 & BILDUNG_M<9 // College for higher vocational edu, post-secondary vocational, post-secondary academic, Bachelor's, Master's, PhD
replace mom_edu_comp=6 if BILDUNG_M==90 |  BILDUNG_M==95  //  Unknwon or not collected

tab mom_edu_comp, m
label define edulab2 1 "Compulsory school" 2 "Apprenticeship" 3 "Interm. Technical & vocational school" 4 "Academic upper secondary school" 5 "Post-secondary; Tertiary" 6 "Unknown or not collected"
label values mom_edu_comp edulab2
*/

tab mom_edu_comp, m

collapse loco month_nr (count) n_births= mom_age_cat, by(mdate mom_edu_comp)
bysort mdate: egen total_births=total(n_births)
gen prop= n_births/ total_births
gen str country="Austria"

save "$dta/AT_ts",replace

*keep mom_edu_comp month_nr mdate prop loco n_births
reshape wide prop n_births, i(mdate) j(mom_edu_comp)
rename prop1 bot_prop
rename prop5 top_prop
rename n_births1 bot_nr
rename n_births5 top_nr
keep top_prop bot_prop month_nr mdate loco total_births top_nr bot_nr

*create variables for all time series figures
*TOP EDU
poisson top_nr i.loco c.mdate##c.mdate i.month_nr, irr
predict pred_top_nr, n

margins, ///
at(mdate=(660(1)743) loco=0) ///
at(mdate=(731(1)743) loco=1) ///
predict(n) ///
saving("$dta/margins_poisson_week_QUAD.dta", replace)

preserve 
use "$dta/margins_poisson_week_QUAD.dta", clear
rename _at2 mdate
rename _at1 loco
rename _margin lin_top_nr
keep lin_top_nr mdate loco
drop if loco==0 & mdate >=tm(2020m12)
save "$dta/margins_lin_pred.dta",replace

use "$dta/margins_poisson_week_QUAD.dta", clear
rename _at2 mdate
rename _at1 loco
rename _margin cf_lin_top_nr
keep cf_lin_top_nr mdate loco
keep if loco==0 & mdate >=tm(2020m12)
save "$dta/margins_cf_lin_pred.dta",replace
restore

merge 1:1 mdate using "$dta/margins_lin_pred.dta", nogen
merge 1:1 mdate using "$dta/margins_cf_lin_pred.dta", nogen

*BOT EDU
poisson bot_nr i.loco c.mdate##c.mdate i.month_nr, irr
predict pred_bot_nr, n

margins, ///
at(mdate=(660(1)743) loco=0) ///
at(mdate=(731(1)743) loco=1) ///
predict(n) ///
saving("$dta/margins_poisson_week_QUAD.dta", replace)

preserve 
use "$dta/margins_poisson_week_QUAD.dta", clear
rename _at2 mdate
rename _at1 loco
rename _margin lin_bot_nr
keep lin_bot_nr mdate loco
drop if loco==0 & mdate >=tm(2020m12)
save "$dta/margins_lin_pred.dta",replace

use "$dta/margins_poisson_week_QUAD.dta", clear
rename _at2 mdate
rename _at1 loco
rename _margin cf_lin_bot_nr
keep cf_lin_bot_nr mdate loco
keep if loco==0 & mdate >=tm(2020m12)
save "$dta/margins_cf_lin_pred.dta",replace
restore

merge 1:1 mdate using "$dta/margins_lin_pred.dta", nogen
merge 1:1 mdate using "$dta/margins_cf_lin_pred.dta", nogen
gen str country="Austria"

save "$dta/AT_comp.dta", replace

**# Bookmark #12

*************************** USA  USA  USA ******************************
*************************** USA  USA  USA ******************************
*************************** USA  USA  USA ******************************
*************************** USA  USA  USA ******************************

import delimited "C:\Users\moritzob\OneDrive - University of Helsinki\postdoc life helsinki\LoCo-effect\LoCo-effect USA Composition\dta\births_mom_edu_2016_2021.txt", clear 

gen mdate=ym( year, monthcode)
format mdate %tm
tab mdate

rename monthcode month_nr
drop if notes=="Total"
encode motherseducation, gen(edu_mom_det)
drop if mdate>tm(2021m12) // only include 2021 latest
gen loco=0
replace loco=1 if mdate>tm(2020m11)


/*
1 - 8th grade or less
2 - 9th through 12th grade with no diploma
3 - Associate degree (AA, AS)
4 - Bachelor's degree (BA, AB, BS)
5 - Doctorate (PhD, EdD) or Professional Degree (MD, DDS, DVM, LLB, JD)
6 - High school graduate or GED completed
7 - Master's degree (MA, MS, MEng, MEd, MSW, MBA)
8 - Some college credit, but not a degree
9 - Unknown or Not Stated

SIMPLIFED 

ranked: 1,2,6,8,3,4,7,5,9
can group 1 +2 = no highschool diploma
7+5: doctoral+ master

and maybe associate with some college: 3+8

COMPARE LOWER SECONDARY WITH POST SECONDARY

*/
gen edu_sum=.
replace edu_sum=1 if edu_mom_det==1 | edu_mom_det==2 // no highschool diploma
replace edu_sum=2 if edu_mom_det==6 // highschool completed
replace edu_sum=3 if edu_mom_det==8 // some college but no degree
replace edu_sum=4 if edu_mom_det==3 // Associate degree
replace edu_sum=5 if edu_mom_det==4 // Bachelor
replace edu_sum=6 if edu_mom_det==7 | edu_mom_det==5 // Master or Doctorate
replace edu_sum=7 if edu_mom_det==9 // no known or stated

collapse  loco month_nr (sum) births, by(mdate edu_sum) 

label define edu_sum 1 "No Highschool diploma" 2 "Highschool or GED" 3 "College without Degree" 4 "Associate Degree" 5 "Bachelor's Degree" 6 "Master's or Doctorate" 7 "Unknown or not stated"
label values edu_sum edu_sum

gen mom_edu_comp=. 
replace mom_edu_comp=1 if edu_sum==1 // primary and lower secondary
replace mom_edu_comp=2 if edu_sum==2 | edu_sum==3 // upper secondary
replace mom_edu_comp=3 if edu_sum>3 & edu_sum<7 // post-secondary
replace mom_edu_comp=4 if edu_sum==7 // not known or not stated

collapse  loco month_nr (sum) births, by(mdate mom_edu_comp) 

tab mom_edu_comp,m

label define edu_sum2 1 "No Highschool diploma" 2 "Upper secondary" 3 "Post-secondary; Tertiary" 4 "Unknown or not collected"
label values mom_edu_comp edu_sum2

tab mom_edu_comp,m

rename births n_births

bysort mdate: egen total_births=total(n_births)
gen prop= n_births/ total_births

reshape wide prop n_births, i(mdate) j(mom_edu_comp)
gen str country="United States"

rename prop1 bot_prop
rename prop3 top_prop
rename n_births1 bot_nr
rename n_births3 top_nr
keep top_prop bot_prop month_nr mdate loco total_births top_nr bot_nr country

*create variables for all time series figures
*TOP EDU
poisson top_nr i.loco c.mdate##c.mdate i.month_nr, irr
predict pred_top_nr, n

margins, ///
at(mdate=(672(1)743) loco=0) ///
at(mdate=(731(1)743) loco=1) ///
predict(n) ///
saving("$dta/margins_poisson_week_QUAD.dta", replace)

preserve 
use "$dta/margins_poisson_week_QUAD.dta", clear
rename _at2 mdate
rename _at1 loco
rename _margin lin_top_nr
keep lin_top_nr mdate loco
drop if loco==0 & mdate >=tm(2020m12)
save "$dta/margins_lin_pred.dta",replace

use "$dta/margins_poisson_week_QUAD.dta", clear
rename _at2 mdate
rename _at1 loco
rename _margin cf_lin_top_nr
keep cf_lin_top_nr mdate loco
keep if loco==0 & mdate >=tm(2020m12)
save "$dta/margins_cf_lin_pred.dta",replace
restore

merge 1:1 mdate using "$dta/margins_lin_pred.dta", nogen
merge 1:1 mdate using "$dta/margins_cf_lin_pred.dta", nogen

*BOT EDU
poisson bot_nr i.loco c.mdate##c.mdate i.month_nr, irr
predict pred_bot_nr, n

margins, ///
at(mdate=(672(1)743) loco=0) ///
at(mdate=(731(1)743) loco=1) ///
predict(n) ///
saving("$dta/margins_poisson_week_QUAD.dta", replace)

preserve 
use "$dta/margins_poisson_week_QUAD.dta", clear
rename _at2 mdate
rename _at1 loco
rename _margin lin_bot_nr
keep lin_bot_nr mdate loco
drop if loco==0 & mdate >=tm(2020m12)
save "$dta/margins_lin_pred.dta",replace

use "$dta/margins_poisson_week_QUAD.dta", clear
rename _at2 mdate
rename _at1 loco
rename _margin cf_lin_bot_nr
keep cf_lin_bot_nr mdate loco
keep if loco==0 & mdate >=tm(2020m12)
save "$dta/margins_cf_lin_pred.dta",replace
restore

merge 1:1 mdate using "$dta/margins_lin_pred.dta", nogen
merge 1:1 mdate using "$dta/margins_cf_lin_pred.dta", nogen

save "$dta/USA_comp.dta", replace

**# Bookmark #15

*************************** SPAIN SPAIN SPAIN  ******************************
*************************** SPAIN SPAIN SPAIN  ******************************
*************************** SPAIN SPAIN SPAIN  ******************************
*************************** SPAIN SPAIN SPAIN  ******************************
/*
data available from:
https://www.ine.es/dyngs/INEbase/en/operacion.htm?c=Estadistica_C&cid=1254736177007&menu=resultados&secc=1254736195443&idp=1254735573002#!tabs-1254736195443


--------------------------------------------------
--------------------------------------------------
 ----------- EDUCATION ---------
  ----------- EDUCATION ---------

 ***** OVER 25 OVER 25 OVER 25 ****
--------------------------------------------------
--------------------------------------------------

*/

use "C:\Users\moritzob\OneDrive - University of Helsinki\postdoc life helsinki\LoCo-effect\LoCo-effect Spain Composition\dta/births_2015_2021.dta", clear
drop if EDADM<26 // drop those for which edu is not measured age<26
drop if year==2015
collapse year month_nr pop_26_49 (count) n_births=mom_age_cat, by(mdate edu_mom)
bysort mdate: egen total_births= total(n_births)
gen prop= n_births/total_births
gen loco=0
replace loco=1 if mdate>tm(2020m11)
* gen dummies to correct for jump in data
forval i=2016(1)2020 {
	gen d_`i'=1 if year==`i'
	replace d_`i'=0 if year!=`i'
}

rename edu_mom edu_mom_det
xtset edu_mom_det mdate
gen d_16_17=1 if year<2018 
recode d_16_17 (.=0)
gen mom_edu_comp=.
replace mom_edu_comp=1 if edu_mom_det==1 | edu_mom_det==2 // primary or lower secondary
replace mom_edu_comp=2 if edu_mom_det==3 // upper secondary
replace mom_edu_comp=3 if edu_mom_det>3 & edu_mom_det <6 // post secondary + teriary
replace mom_edu_comp=4 if edu_mom_det==6 // not recorded
collapse d_16_17 loco month_nr (sum) n_births, by(mdate mom_edu_comp) 
tab mom_edu_comp,m

label define edu_sum2 1 "No Highschool diploma" 2 "Upper secondary" 3 "Post-secondary; Tertiary" 4 "Unknown or not collected"
label values mom_edu_comp edu_sum2
tab mom_edu_comp,m
bysort mdate: egen total_births=total(n_births)
gen prop= n_births/ total_births

reshape wide prop n_births , i(mdate) j(mom_edu_comp)
gen str country="Spain"

rename prop1 bot_prop
rename prop3 top_prop
rename n_births1 bot_nr
rename n_births3 top_nr
keep top_prop bot_prop month_nr mdate loco total_births top_nr bot_nr country d_16_17

*create variables for all time series figures
*TOP EDU
poisson top_nr i.loco c.mdate##c.mdate i.month_nr i.d_16_17, irr
predict pred_top_nr, n

margins, ///
at(mdate=(672(1)695) loco=0 d_16_17=1) ///
at(mdate=(696(1)743)  loco=0 d_16_17=0) ///
at(mdate=(731(1)743)  loco=1 d_16_17=0) ///
saving("$dta/margins_poisson_week_QUAD.dta", replace)

preserve 
use "$dta/margins_poisson_week_QUAD.dta", clear
rename _at2 mdate
rename _at1 loco
rename _margin lin_top_nr
keep lin_top_nr mdate loco
drop if loco==0 & mdate >=tm(2020m12)
save "$dta/margins_lin_pred.dta",replace

use "$dta/margins_poisson_week_QUAD.dta", clear
rename _at2 mdate
rename _at1 loco
rename _margin cf_lin_top_nr
keep cf_lin_top_nr mdate loco
keep if loco==0 & mdate >=tm(2020m12)
save "$dta/margins_cf_lin_pred.dta",replace
restore

merge 1:1 mdate using "$dta/margins_lin_pred.dta", nogen
merge 1:1 mdate using "$dta/margins_cf_lin_pred.dta", nogen

*BOT EDU
poisson bot_nr i.loco c.mdate##c.mdate i.month_nr i.d_16_17, irr
predict pred_bot_nr, n

margins, ///
at(mdate=(672(1)695) loco=0 d_16_17=1) ///
at(mdate=(696(1)743)  loco=0 d_16_17=0) ///
at(mdate=(731(1)743)  loco=1 d_16_17=0) ///
saving("$dta/margins_poisson_week_QUAD.dta", replace)

preserve 
use "$dta/margins_poisson_week_QUAD.dta", clear
rename _at2 mdate
rename _at1 loco
rename _margin lin_bot_nr
keep lin_bot_nr mdate loco
drop if loco==0 & mdate >=tm(2020m12)
save "$dta/margins_lin_pred.dta",replace

use "$dta/margins_poisson_week_QUAD.dta", clear
rename _at2 mdate
rename _at1 loco
rename _margin cf_lin_bot_nr
keep cf_lin_bot_nr mdate loco
keep if loco==0 & mdate >=tm(2020m12)
save "$dta/margins_cf_lin_pred.dta",replace
restore

merge 1:1 mdate using "$dta/margins_lin_pred.dta", nogen
merge 1:1 mdate using "$dta/margins_cf_lin_pred.dta", nogen

save "$dta/ESP_comp.dta", replace

**# Bookmark #18

*************************** COLOMBIA COLOMBIA COLOMBIA  ******************************
*************************** COLOMBIA COLOMBIA COLOMBIA  ******************************
*************************** COLOMBIA COLOMBIA COLOMBIA  ******************************

/*** openly available micro data 
Data openly available from DANE. LINK:
https://microdatos.dane.gov.co/index.php/catalog/DEM-Microdatos#_r=1700214975152&collection=&country=&dtype=&from=2015&page=1&ps=&sid=&sk=&sort_by=title&sort_order=&to=2023&topic=&view=s&vk=
*/

use "C:\Users\moritzob\OneDrive - University of Helsinki\postdoc life helsinki\LoCo-effect\LoCo-effect Colombia\dta\colombia_births_2015.dta", clear
/*
label define edulab 1 "Primary school or lower" 2 "Lower secondary" 3 "Upper secondary" 4 "Post-secondary & short-cycle tertiary" 5 "Profesional" 6 "Equivalent to Master's or Doctorate" 7 "Missing information"
label values mom_edu edulab

gen mom_edu_comp=.
replace mom_edu_comp=1 if mom_edu ==1 | mom_edu==2 // primary or secondary
replace mom_edu_comp=2 if mom_edu ==3  // upper secondary
replace mom_edu_comp=3 if mom_edu >3 & mom_edu<7  // post secondary
replace mom_edu_comp=4 if mom_edu==7  // post secondary
label define edulab2 1 "Primary or lower secondary" 2 "Upper secondary" 3 "Post-secondary; tertiary" 4 "Missing information"
label values mom_edu_comp edulab2
*/
tab mom_edu_comp,m
collapse loco month_nr (count) n_births=mom_edu,by(mdate mom_edu_comp)
gen zika=0
replace zika=1 if mdate >=tm(2016m8) & mdate <=tm(2016m12)
bysort mdate: egen total_births=total(n_births)
gen prop= n_births/ total_births
reshape wide prop n_births , i(mdate) j(mom_edu_comp)
gen str country="Colombia"
rename prop1 bot_prop
rename prop3 top_prop
rename n_births1 bot_nr
rename n_births3 top_nr
keep top_prop bot_prop month_nr mdate loco total_births top_nr bot_nr country zika



*create variables for all time series figures
*TOP EDU
poisson top_nr i.loco c.mdate##c.mdate i.month_nr i.zika, irr
predict pred_top_nr, n

margins, ///
at(mdate=(660(1)743) loco=(0) zika=(0)) ///
at(mdate=(731(1)743) loco=(1) zika=(0)) ///
predict(n) ///
saving("$dta/margins_poisson_week_QUAD.dta", replace)

preserve 
use "$dta/margins_poisson_week_QUAD.dta", clear
rename _at2 mdate
rename _at1 loco
rename _margin lin_top_nr
keep lin_top_nr mdate loco
drop if loco==0 & mdate >=tm(2020m12)
save "$dta/margins_lin_pred.dta",replace

use "$dta/margins_poisson_week_QUAD.dta", clear
rename _at2 mdate
rename _at1 loco
rename _margin cf_lin_top_nr
keep cf_lin_top_nr mdate loco
keep if loco==0 & mdate >=tm(2020m12)
save "$dta/margins_cf_lin_pred.dta",replace
restore

merge 1:1 mdate using "$dta/margins_lin_pred.dta", nogen
merge 1:1 mdate using "$dta/margins_cf_lin_pred.dta", nogen

*BOT EDU
poisson bot_nr i.loco c.mdate##c.mdate i.month_nr i.zika, irr
predict pred_bot_nr, n

margins, ///
at(mdate=(660(1)743) loco=(0) zika=(0)) ///
at(mdate=(731(1)743) loco=(1) zika=(0)) ///
predict(n) ///
saving("$dta/margins_poisson_week_QUAD.dta", replace)

preserve 
use "$dta/margins_poisson_week_QUAD.dta", clear
rename _at2 mdate
rename _at1 loco
rename _margin lin_bot_nr
keep lin_bot_nr mdate loco
drop if loco==0 & mdate >=tm(2020m12)
save "$dta/margins_lin_pred.dta",replace

use "$dta/margins_poisson_week_QUAD.dta", clear
rename _at2 mdate
rename _at1 loco
rename _margin cf_lin_bot_nr
keep cf_lin_bot_nr mdate loco
keep if loco==0 & mdate >=tm(2020m12)
save "$dta/margins_cf_lin_pred.dta",replace
restore

merge 1:1 mdate using "$dta/margins_lin_pred.dta", nogen
merge 1:1 mdate using "$dta/margins_cf_lin_pred.dta", nogen

save "$dta/COL_comp.dta", replace


**# Bookmark #21
*************************** MEXICO MEXICO MEXICO  ******************************
*************************** MEXICO MEXICO MEXICO  ******************************
*************************** MEXICO MEXICO MEXICO  ******************************

use "C:\Users\moritzob\OneDrive - University of Helsinki\postdoc life helsinki\LoCo-effect\LoCo-effect Mexico\dta\Mexico_births_2015_2021.dta", clear
tab mom_edu, m
drop if bdate_w==. 
*Mexico does not have post-secondary or teritary in data. 
*we use elementary vs upper secondary + other
 
gen mom_edu_comp=.
replace mom_edu_comp=1 if mom_edu==1 | mom_edu==2 | mom_edu==3 |mom_edu==4 
replace mom_edu_comp=2 if mom_edu==5 // lower secondary
replace mom_edu_comp=3 if mom_edu==6 | mom_edu==7 | mom_edu==8 
replace mom_edu_comp=4 if mom_edu==9 // unspecified
tab mom_edu_comp,m
collapse loco bweek (count) n_births=mom_edu,by(bdate_w mom_edu_comp)
gen zika=0
replace zika=1 if bdate_w >=tw(2016w31) & bdate_w <=tw(2016m52)
bysort bdate_w: egen total_births=total(n_births)
gen prop= n_births/ total_births
reshape wide prop n_births , i(bdate_w) j(mom_edu_comp)
gen str country="Mexico"
rename prop1 bot_prop
rename prop3 top_prop
rename n_births1 bot_nr
rename n_births3 top_nr
rename loco_w loco
keep top_prop bot_prop bweek bdate_w loco total_births top_nr bot_nr country zika

*** create variables
*TOP
poisson top_nr i.loco c.bdate_w##c.bdate_w i.bweek i.zika, irr
predict pred_top_nr, n

quietly: margins, ///
at(bdate_w=(2860(1)3223) loco=0 zika=0) ///
at(bdate_w=(3170(1)3223) loco=1 zika=0) ///
predict(n) ///
saving("$dta/margins_poisson_week_QUAD.dta", replace)

preserve 
use "$dta/margins_poisson_week_QUAD.dta", clear
rename _at2 bdate_w
rename _at1 loco
rename _margin lin_top_nr
keep lin_top_nr bdate_w loco
drop if loco==0 & bdate_w >=tw(2020w51)
save "$dta/margins_lin_pred.dta",replace

use "$dta/margins_poisson_week_QUAD.dta", clear
rename _at2 bdate_w
rename _at1 loco
rename _margin cf_lin_top_nr
keep cf_lin_top_nr bdate_w loco
keep if loco==0 & bdate_w >=tw(2020w51)
save "$dta/margins_cf_lin_pred.dta",replace
restore

merge 1:1 bdate_w using "$dta/margins_lin_pred.dta", nogen
merge 1:1 bdate_w using "$dta/margins_cf_lin_pred.dta", nogen

*BOT EDU
poisson bot_nr i.loco c.bdate_w##c.bdate_w i.bweek i.zika, irr
predict pred_bot_nr, n

quietly: margins, ///
at(bdate_w=(2860(1)3223) loco=0 zika=0) ///
at(bdate_w=(3170(1)3223) loco=1 zika=0) ///
predict(n) ///
saving("$dta/margins_poisson_week_QUAD.dta", replace)

preserve 
use "$dta/margins_poisson_week_QUAD.dta", clear
rename _at2 bdate_w
rename _at1 loco
rename _margin lin_bot_nr
keep lin_bot_nr bdate_w loco
drop if loco==0 & bdate_w >=tw(2020w51)
save "$dta/margins_lin_pred.dta",replace

use "$dta/margins_poisson_week_QUAD.dta", clear
rename _at2 bdate_w
rename _at1 loco
rename _margin cf_lin_bot_nr
keep cf_lin_bot_nr bdate_w loco
keep if loco==0 & bdate_w >=tw(2020w51)
save "$dta/margins_cf_lin_pred.dta",replace
restore

merge 1:1 bdate_w using "$dta/margins_lin_pred.dta", nogen
merge 1:1 bdate_w using "$dta/margins_cf_lin_pred.dta", nogen

save "$dta/MEX_comp.dta", replace



**# Bookmark #23

*************************** FINLAND FINLAND FINLAND ******************************
*************************** FINLAND FINLAND FINLAND ******************************
*************************** FINLAND FINLAND FINLAND ******************************
use "C:\Users\moritzob\OneDrive - University of Helsinki\postdoc life helsinki\LoCo-effect\LoCo-effect Finland\dta\inc_ts_week_12 Dec 2023.dta", clear

keep quint_equi_kturaha bdate_w bweek loco n_births prop total_births
replace quint_equi_kturaha=6 if quint_equi_kturaha==.
reshape wide prop n_births , i(bdate_w) j(quint_equi_kturaha)
gen str country="Finland"
rename prop1 bot_prop
rename prop5 top_prop
rename n_births1 bot_nr
rename n_births5 top_nr
keep top_prop bot_prop bweek bdate_w loco total_births top_nr bot_nr country 

*** create variables
*TOP
poisson top_nr i.loco c.bdate_w##c.bdate_w i.bweek , irr
predict pred_top_nr, n

quietly: margins, ///
at(bdate_w=(2860(1)3223) loco=0) ///
at(bdate_w=(3170(1)3223) loco=1) ///
predict(n) ///
saving("$dta/margins_poisson_week_QUAD.dta", replace)

preserve 
use "$dta/margins_poisson_week_QUAD.dta", clear
rename _at2 bdate_w
rename _at1 loco
rename _margin lin_top_nr
keep lin_top_nr bdate_w loco
drop if loco==0 & bdate_w >=tw(2020w51)
save "$dta/margins_lin_pred.dta",replace

use "$dta/margins_poisson_week_QUAD.dta", clear
rename _at2 bdate_w
rename _at1 loco
rename _margin cf_lin_top_nr
keep cf_lin_top_nr bdate_w loco
keep if loco==0 & bdate_w >=tw(2020w51)
save "$dta/margins_cf_lin_pred.dta",replace
restore

merge 1:1 bdate_w using "$dta/margins_lin_pred.dta", nogen
merge 1:1 bdate_w using "$dta/margins_cf_lin_pred.dta", nogen

*BOT EDU
poisson bot_nr i.loco c.bdate_w##c.bdate_w i.bweek , irr
predict pred_bot_nr, n

quietly: margins, ///
at(bdate_w=(2860(1)3223) loco=0) ///
at(bdate_w=(3170(1)3223) loco=1) ///
predict(n) ///
saving("$dta/margins_poisson_week_QUAD.dta", replace)

preserve 
use "$dta/margins_poisson_week_QUAD.dta", clear
rename _at2 bdate_w
rename _at1 loco
rename _margin lin_bot_nr
keep lin_bot_nr bdate_w loco
drop if loco==0 & bdate_w >=tw(2020w51)
save "$dta/margins_lin_pred.dta",replace

use "$dta/margins_poisson_week_QUAD.dta", clear
rename _at2 bdate_w
rename _at1 loco
rename _margin cf_lin_bot_nr
keep cf_lin_bot_nr bdate_w loco
keep if loco==0 & bdate_w >=tw(2020w51)
save "$dta/margins_cf_lin_pred.dta",replace
restore

merge 1:1 bdate_w using "$dta/margins_lin_pred.dta", nogen
merge 1:1 bdate_w using "$dta/margins_cf_lin_pred.dta", nogen

save "$dta/FI_comp.dta", replace

**# Bookmark #27

*************************** NETHERLANDS NETHERLANDS NETHERLANDS ******************************
*************************** NETHERLANDS NETHERLANDS NETHERLANDS ******************************
*************************** NETHERLANDS NETHERLANDS NETHERLANDS ******************************
use "C:\Users\moritzob\OneDrive - University of Helsinki\postdoc life helsinki\LoCo-effect\LoCo-effect Netherlands\dta\Netherlands_births_2015_2021.dta", clear


gen prop= n_births/ total_births
*keep mom_edu_comp month_nr mdate prop loco n_births
reshape wide prop n_births, i(mdate) j(quint_hhinc)
rename prop1 bot_prop
rename prop5 top_prop
rename n_births1 bot_nr
rename n_births5 top_nr
keep top_prop bot_prop month_nr mdate loco total_births top_nr bot_nr

*create variables for all time series figures
*TOP EDU
poisson top_nr i.loco c.mdate##c.mdate i.month_nr, irr
predict pred_top_nr, n

margins, ///
at(mdate=(660(1)743) loco=0) ///
at(mdate=(731(1)743) loco=1) ///
predict(n) ///
saving("$dta/margins_poisson_week_QUAD.dta", replace)

preserve 
use "$dta/margins_poisson_week_QUAD.dta", clear
rename _at2 mdate
rename _at1 loco
rename _margin lin_top_nr
keep lin_top_nr mdate loco
drop if loco==0 & mdate >=tm(2020m12)
save "$dta/margins_lin_pred.dta",replace

use "$dta/margins_poisson_week_QUAD.dta", clear
rename _at2 mdate
rename _at1 loco
rename _margin cf_lin_top_nr
keep cf_lin_top_nr mdate loco
keep if loco==0 & mdate >=tm(2020m12)
save "$dta/margins_cf_lin_pred.dta",replace
restore

merge 1:1 mdate using "$dta/margins_lin_pred.dta", nogen
merge 1:1 mdate using "$dta/margins_cf_lin_pred.dta", nogen

*BOT EDU
poisson bot_nr i.loco c.mdate##c.mdate i.month_nr, irr
predict pred_bot_nr, n

margins, ///
at(mdate=(660(1)743) loco=0) ///
at(mdate=(731(1)743) loco=1) ///
predict(n) ///
saving("$dta/margins_poisson_week_QUAD.dta", replace)

preserve 
use "$dta/margins_poisson_week_QUAD.dta", clear
rename _at2 mdate
rename _at1 loco
rename _margin lin_bot_nr
keep lin_bot_nr mdate loco
drop if loco==0 & mdate >=tm(2020m12)
save "$dta/margins_lin_pred.dta",replace

use "$dta/margins_poisson_week_QUAD.dta", clear
rename _at2 mdate
rename _at1 loco
rename _margin cf_lin_bot_nr
keep cf_lin_bot_nr mdate loco
keep if loco==0 & mdate >=tm(2020m12)
save "$dta/margins_cf_lin_pred.dta",replace
restore

merge 1:1 mdate using "$dta/margins_lin_pred.dta", nogen
merge 1:1 mdate using "$dta/margins_cf_lin_pred.dta", nogen
gen str country="Netherlands"

save "$dta/NET_comp.dta", replace


**# Bookmark #29

******************** SCOTLAND *************************
******************** SCOTLAND *************************
******************** SCOTLAND *************************
******************** SCOTLAND *************************
use "C:\Users\moritzob\OneDrive - University of Helsinki\postdoc life helsinki\LoCo-effect\LoCo-effect Scotland Composition\dta\SIMD_data_20062023.dta", clear

replace SIMD=6 if SIMD==99
*1 - most deprived , 5 least deprived -> has to change
rename allbirths n_births

keep SIMD n_births total_births mdate month_nr 
gen prop=n_births/total_births
gen loco =0
replace loco=1 if mdate>tm(2020m11)
drop if mdate>tm(2021m12) 
reshape wide prop n_births, i(mdate) j(SIMD)
rename prop1 bot_prop
rename prop5 top_prop
rename n_births1 bot_nr
rename n_births5 top_nr
keep top_prop bot_prop month_nr mdate loco total_births top_nr bot_nr


*create variables for all time series figures
*TOP EDU
poisson top_nr i.loco c.mdate##c.mdate i.month_nr, irr
predict pred_top_nr, n

margins, ///
at(mdate=(660(1)743) loco=0) ///
at(mdate=(731(1)743) loco=1) ///
predict(n) ///
saving("$dta/margins_poisson_week_QUAD.dta", replace)

preserve 
use "$dta/margins_poisson_week_QUAD.dta", clear
rename _at2 mdate
rename _at1 loco
rename _margin lin_top_nr
keep lin_top_nr mdate loco
drop if loco==0 & mdate >=tm(2020m12)
save "$dta/margins_lin_pred.dta",replace

use "$dta/margins_poisson_week_QUAD.dta", clear
rename _at2 mdate
rename _at1 loco
rename _margin cf_lin_top_nr
keep cf_lin_top_nr mdate loco
keep if loco==0 & mdate >=tm(2020m12)
save "$dta/margins_cf_lin_pred.dta",replace
restore

merge 1:1 mdate using "$dta/margins_lin_pred.dta", nogen
merge 1:1 mdate using "$dta/margins_cf_lin_pred.dta", nogen

*BOT EDU
poisson bot_nr i.loco c.mdate##c.mdate i.month_nr, irr
predict pred_bot_nr, n

margins, ///
at(mdate=(660(1)743) loco=0) ///
at(mdate=(731(1)743) loco=1) ///
predict(n) ///
saving("$dta/margins_poisson_week_QUAD.dta", replace)

preserve 
use "$dta/margins_poisson_week_QUAD.dta", clear
rename _at2 mdate
rename _at1 loco
rename _margin lin_bot_nr
keep lin_bot_nr mdate loco
drop if loco==0 & mdate >=tm(2020m12)
save "$dta/margins_lin_pred.dta",replace

use "$dta/margins_poisson_week_QUAD.dta", clear
rename _at2 mdate
rename _at1 loco
rename _margin cf_lin_bot_nr
keep cf_lin_bot_nr mdate loco
keep if loco==0 & mdate >=tm(2020m12)
save "$dta/margins_cf_lin_pred.dta",replace
restore

merge 1:1 mdate using "$dta/margins_lin_pred.dta", nogen
merge 1:1 mdate using "$dta/margins_cf_lin_pred.dta", nogen
gen str country="Scotland"

save "$dta/SCOT_comp.dta", replace

**# Bookmark #33

******************** ENGLAND ENGLAND ENGLAND  *************************
******************** ENGLAND ENGLAND ENGLAND  *************************
******************** ENGLAND ENGLAND ENGLAND  *************************
******************** ENGLAND ENGLAND ENGLAND  *************************
import excel "C:\Users\moritzob\OneDrive - University of Helsinki\postdoc life helsinki\LoCo-effect\LoCo-effect England Wales\dta\England_births_2015_2022.xlsx", sheet("Sheet1") firstrow clear

rename Yearofoccurrence year
rename Monthofoccurrence month_nr

forval i=1/10 {
	rename IMD`i' dec_IMD`i'
}

gen quint_IMD1=dec_IMD1 + dec_IMD2
gen quint_IMD2=dec_IMD3 + dec_IMD4
gen quint_IMD3=dec_IMD5 + dec_IMD6
gen quint_IMD4=dec_IMD7 + dec_IMD8
gen quint_IMD5=dec_IMD9 + dec_IMD10

drop dec_IMD1-dec_IMD10

gen mdate=ym(year, month_nr)
format mdate %tm
gen loco=0
replace loco=1 if mdate>tm(2020m11)
reshape long quint_IMD, i(mdate) j(IMD)
rename quint_IMD n_births
drop if year>2021

bysort mdate: egen total_births=total(n_births)
gen prop=n_births/total_births

reshape wide prop n_births, i(mdate) j(IMD)
rename prop1 bot_prop
rename prop5 top_prop
rename n_births1 bot_nr
rename n_births5 top_nr
keep top_prop bot_prop month_nr mdate loco total_births top_nr bot_nr

*create variables for all time series figures
*TOP EDU
poisson top_nr i.loco c.mdate##c.mdate i.month_nr, irr
predict pred_top_nr, n

margins, ///
at(mdate=(660(1)743) loco=0) ///
at(mdate=(731(1)743) loco=1) ///
predict(n) ///
saving("$dta/margins_poisson_week_QUAD.dta", replace)

preserve 
use "$dta/margins_poisson_week_QUAD.dta", clear
rename _at2 mdate
rename _at1 loco
rename _margin lin_top_nr
keep lin_top_nr mdate loco
drop if loco==0 & mdate >=tm(2020m12)
save "$dta/margins_lin_pred.dta",replace

use "$dta/margins_poisson_week_QUAD.dta", clear
rename _at2 mdate
rename _at1 loco
rename _margin cf_lin_top_nr
keep cf_lin_top_nr mdate loco
keep if loco==0 & mdate >=tm(2020m12)
save "$dta/margins_cf_lin_pred.dta",replace
restore

merge 1:1 mdate using "$dta/margins_lin_pred.dta", nogen
merge 1:1 mdate using "$dta/margins_cf_lin_pred.dta", nogen

*BOT EDU
poisson bot_nr i.loco c.mdate##c.mdate i.month_nr, irr
predict pred_bot_nr, n

margins, ///
at(mdate=(660(1)743) loco=0) ///
at(mdate=(731(1)743) loco=1) ///
predict(n) ///
saving("$dta/margins_poisson_week_QUAD.dta", replace)

preserve 
use "$dta/margins_poisson_week_QUAD.dta", clear
rename _at2 mdate
rename _at1 loco
rename _margin lin_bot_nr
keep lin_bot_nr mdate loco
drop if loco==0 & mdate >=tm(2020m12)
save "$dta/margins_lin_pred.dta",replace

use "$dta/margins_poisson_week_QUAD.dta", clear
rename _at2 mdate
rename _at1 loco
rename _margin cf_lin_bot_nr
keep cf_lin_bot_nr mdate loco
keep if loco==0 & mdate >=tm(2020m12)
save "$dta/margins_cf_lin_pred.dta",replace
restore

merge 1:1 mdate using "$dta/margins_lin_pred.dta", nogen
merge 1:1 mdate using "$dta/margins_cf_lin_pred.dta", nogen
gen str country="England"

save "$dta/ENG_comp.dta", replace

**# Bookmark #35

******************** WALES WALES WALES *************************
******************** WALES WALES WALES *************************
******************** WALES WALES WALES *************************
******************** WALES WALES WALES *************************
import excel "C:\Users\moritzob\OneDrive - University of Helsinki\postdoc life helsinki\LoCo-effect\LoCo-effect England Wales\dta\Wales_births_2015_2022.xlsx", sheet("Sheet1") firstrow clear

rename Yearofoccurrence year
rename Monthofoccurrence month_nr

forval i=1/10 {
	rename IMD`i' dec_IMD`i'
}

gen quint_IMD1=dec_IMD1 + dec_IMD2
gen quint_IMD2=dec_IMD3 + dec_IMD4
gen quint_IMD3=dec_IMD5 + dec_IMD6
gen quint_IMD4=dec_IMD7 + dec_IMD8
gen quint_IMD5=dec_IMD9 + dec_IMD10

drop dec_IMD1-dec_IMD10

gen mdate=ym(year, month_nr)
format mdate %tm
gen loco=0
replace loco=1 if mdate>tm(2020m11)
reshape long quint_IMD, i(mdate) j(IMD)
rename quint_IMD n_births
drop if year>2021

bysort mdate: egen total_births=total(n_births)
gen prop=n_births/total_births

reshape wide prop n_births, i(mdate) j(IMD)
rename prop1 bot_prop
rename prop5 top_prop
rename n_births1 bot_nr
rename n_births5 top_nr
keep top_prop bot_prop month_nr mdate loco total_births top_nr bot_nr

*create variables for all time series figures
*TOP EDU
poisson top_nr i.loco c.mdate##c.mdate i.month_nr, irr
predict pred_top_nr, n

margins, ///
at(mdate=(660(1)743) loco=0) ///
at(mdate=(731(1)743) loco=1) ///
predict(n) ///
saving("$dta/margins_poisson_week_QUAD.dta", replace)

preserve 
use "$dta/margins_poisson_week_QUAD.dta", clear
rename _at2 mdate
rename _at1 loco
rename _margin lin_top_nr
keep lin_top_nr mdate loco
drop if loco==0 & mdate >=tm(2020m12)
save "$dta/margins_lin_pred.dta",replace

use "$dta/margins_poisson_week_QUAD.dta", clear
rename _at2 mdate
rename _at1 loco
rename _margin cf_lin_top_nr
keep cf_lin_top_nr mdate loco
keep if loco==0 & mdate >=tm(2020m12)
save "$dta/margins_cf_lin_pred.dta",replace
restore

merge 1:1 mdate using "$dta/margins_lin_pred.dta", nogen
merge 1:1 mdate using "$dta/margins_cf_lin_pred.dta", nogen

*BOT EDU
poisson bot_nr i.loco c.mdate##c.mdate i.month_nr, irr
predict pred_bot_nr, n

margins, ///
at(mdate=(660(1)743) loco=0) ///
at(mdate=(731(1)743) loco=1) ///
predict(n) ///
saving("$dta/margins_poisson_week_QUAD.dta", replace)

preserve 
use "$dta/margins_poisson_week_QUAD.dta", clear
rename _at2 mdate
rename _at1 loco
rename _margin lin_bot_nr
keep lin_bot_nr mdate loco
drop if loco==0 & mdate >=tm(2020m12)
save "$dta/margins_lin_pred.dta",replace

use "$dta/margins_poisson_week_QUAD.dta", clear
rename _at2 mdate
rename _at1 loco
rename _margin cf_lin_bot_nr
keep cf_lin_bot_nr mdate loco
keep if loco==0 & mdate >=tm(2020m12)
save "$dta/margins_cf_lin_pred.dta",replace
restore

merge 1:1 mdate using "$dta/margins_lin_pred.dta", nogen
merge 1:1 mdate using "$dta/margins_cf_lin_pred.dta", nogen
gen str country="Wales"

save "$dta/WAL_comp.dta", replace

**# Bookmark #36

**************** BRAZIL BRAZIL BRAZIL ***********************
**************** BRAZIL BRAZIL BRAZIL ***********************
**************** BRAZIL BRAZIL BRAZIL ***********************
**************** BRAZIL BRAZIL BRAZIL ***********************

use "C:\Users\moritzob\OneDrive - University of Helsinki\postdoc life helsinki\LoCo-effect\LoCo-effect Brazil\dta\SINASC_2015_2021_0611.dta", clear
replace bpi_quint=6 if bpi_quint==. // very few weekly births... like 10 mean
drop if bdate_w==.

collapse (mean) year bweek loco_w bdate_m  (count) n_births=bmonth, by(bdate_w bpi_quint)
* 1 is least deprived and 5 most deprived. needs to be reverse

recode bpi_quint (5=1) (4=2) (3=3) (2=4) (1=5) (6=6)

label define q 5 "Least deprived 20%" 4 "Q2" 3 "Q3" 2 "Q4" 1 "Most deprived 20%" 6 "Missing information" 
label values bpi_quint q
*replace bpi_quint=6 if bpi_quint==. // very few weekly births... like 10 mean
drop if bdate_w==.
sort bpi_quint bdate_w
gen zika=0
replace zika=1 if bdate_w >=tw(2016w31) & bdate_w <=tw(2016m52)
bysort bdate_w: egen total_births=total(n_births)
gen prop= n_births/ total_births
drop bdate_m year
reshape wide prop n_births , i(bdate_w) j(bpi_quint)
gen str country="Brazil"
rename prop1 bot_prop
rename prop5 top_prop
rename n_births1 bot_nr
rename n_births5 top_nr
rename loco_w loco
keep top_prop bot_prop bweek bdate_w loco total_births top_nr bot_nr country zika

*** create variables
*TOP
poisson top_nr i.loco c.bdate_w##c.bdate_w i.bweek i.zika, irr
predict pred_top_nr, n

quietly: margins, ///
at(bdate_w=(2860(1)3223) loco=0 zika=0) ///
at(bdate_w=(3170(1)3223) loco=1 zika=0) ///
predict(n) ///
saving("$dta/margins_poisson_week_QUAD.dta", replace)

preserve 
use "$dta/margins_poisson_week_QUAD.dta", clear
rename _at2 bdate_w
rename _at1 loco
rename _margin lin_top_nr
keep lin_top_nr bdate_w loco
drop if loco==0 & bdate_w >=tw(2020w51)
save "$dta/margins_lin_pred.dta",replace

use "$dta/margins_poisson_week_QUAD.dta", clear
rename _at2 bdate_w
rename _at1 loco
rename _margin cf_lin_top_nr
keep cf_lin_top_nr bdate_w loco
keep if loco==0 & bdate_w >=tw(2020w51)
save "$dta/margins_cf_lin_pred.dta",replace
restore

merge 1:1 bdate_w using "$dta/margins_lin_pred.dta", nogen
merge 1:1 bdate_w using "$dta/margins_cf_lin_pred.dta", nogen

*BOT EDU
poisson bot_nr i.loco c.bdate_w##c.bdate_w i.bweek i.zika, irr
predict pred_bot_nr, n

quietly: margins, ///
at(bdate_w=(2860(1)3223) loco=0 zika=0) ///
at(bdate_w=(3170(1)3223) loco=1 zika=0) ///
predict(n) ///
saving("$dta/margins_poisson_week_QUAD.dta", replace)

preserve 
use "$dta/margins_poisson_week_QUAD.dta", clear
rename _at2 bdate_w
rename _at1 loco
rename _margin lin_bot_nr
keep lin_bot_nr bdate_w loco
drop if loco==0 & bdate_w >=tw(2020w51)
save "$dta/margins_lin_pred.dta",replace

use "$dta/margins_poisson_week_QUAD.dta", clear
rename _at2 bdate_w
rename _at1 loco
rename _margin cf_lin_bot_nr
keep cf_lin_bot_nr bdate_w loco
keep if loco==0 & bdate_w >=tw(2020w51)
save "$dta/margins_cf_lin_pred.dta",replace
restore

merge 1:1 bdate_w using "$dta/margins_lin_pred.dta", nogen
merge 1:1 bdate_w using "$dta/margins_cf_lin_pred.dta", nogen

save "$dta/BRA_comp.dta", replace


**# Bookmark #40

********** ECUADOR************************
********** ECUADOR************************
********** ECUADOR************************

use "C:\Users\moritzob\OneDrive - University of Helsinki\postdoc life helsinki\LoCo-effect\LoCo-effect Ecuador\dta\Ecuador_births_DPI_2015_2021.dta", clear

collapse (mean) year bweek loco zika  mdate (count) n_births=month_nr, by(bdate_w quint_DPI)
replace quint_DPI=6 if quint_DPI==. // very few weekly births... like 10 mean
drop if bdate_w==.
* 1 is least deprived and 5 most deprived. needs to be reverse
recode quint_DPI (5=1) (4=2) (3=3) (2=4) (1=5) (6=6)
label values quint_DPI q
bysort bdate_w: egen total_births=total(n_births)
gen prop= n_births/ total_births
drop  year mdate
reshape wide prop n_births , i(bdate_w) j(quint_DPI)
gen str country="Ecuador"
rename prop1 bot_prop
rename prop5 top_prop
rename n_births1 bot_nr
rename n_births5 top_nr
keep top_prop bot_prop bweek bdate_w loco total_births top_nr bot_nr country zika

*** create variables
*TOP
poisson top_nr i.loco c.bdate_w##c.bdate_w i.bweek i.zika, irr
predict pred_top_nr, n

quietly: margins, ///
at(bdate_w=(2860(1)3223) loco=0 zika=0) ///
at(bdate_w=(3170(1)3223) loco=1 zika=0) ///
predict(n) ///
saving("$dta/margins_poisson_week_QUAD.dta", replace)

preserve 
use "$dta/margins_poisson_week_QUAD.dta", clear
rename _at2 bdate_w
rename _at1 loco
rename _margin lin_top_nr
keep lin_top_nr bdate_w loco
drop if loco==0 & bdate_w >=tw(2020w51)
save "$dta/margins_lin_pred.dta",replace

use "$dta/margins_poisson_week_QUAD.dta", clear
rename _at2 bdate_w
rename _at1 loco
rename _margin cf_lin_top_nr
keep cf_lin_top_nr bdate_w loco
keep if loco==0 & bdate_w >=tw(2020w51)
save "$dta/margins_cf_lin_pred.dta",replace
restore

merge 1:1 bdate_w using "$dta/margins_lin_pred.dta", nogen
merge 1:1 bdate_w using "$dta/margins_cf_lin_pred.dta", nogen

*BOT EDU
poisson bot_nr i.loco c.bdate_w##c.bdate_w i.bweek i.zika, irr
predict pred_bot_nr, n

quietly: margins, ///
at(bdate_w=(2860(1)3223) loco=0 zika=0) ///
at(bdate_w=(3170(1)3223) loco=1 zika=0) ///
predict(n) ///
saving("$dta/margins_poisson_week_QUAD.dta", replace)

preserve 
use "$dta/margins_poisson_week_QUAD.dta", clear
rename _at2 bdate_w
rename _at1 loco
rename _margin lin_bot_nr
keep lin_bot_nr bdate_w loco
drop if loco==0 & bdate_w >=tw(2020w51)
save "$dta/margins_lin_pred.dta",replace

use "$dta/margins_poisson_week_QUAD.dta", clear
rename _at2 bdate_w
rename _at1 loco
rename _margin cf_lin_bot_nr
keep cf_lin_bot_nr bdate_w loco
keep if loco==0 & bdate_w >=tw(2020w51)
save "$dta/margins_cf_lin_pred.dta",replace
restore

merge 1:1 bdate_w using "$dta/margins_lin_pred.dta", nogen
merge 1:1 bdate_w using "$dta/margins_cf_lin_pred.dta", nogen

save "$dta/ECU_comp.dta", replace


**# Bookmark #1

********** SWEDEN ************************
********** SWEDEN ************************
********** SWEDEN ************************
********** SWEDEN ************************

import delimited "C:\Users\moritzob\OneDrive - University of Helsinki\postdoc life helsinki\LoCo-effect\LoCo-effect Sweden\dta\income_27012025.csv", clear

gen bdate_w=yw(year, week)
format bdate_w %tw

gen loco=0 // create loco var
replace loco=1 if bdate_w>=tw(2020w51)

replace income=6 if income==0 // make missing value 6 for loops

rename week bweek // rename for old code

bysort bdate_w: egen total_births=sum(n)

rename n n_births
gen prop=n_births/total_births

keep income bdate_w bweek loco n_births prop total_births year

label define inclab 1 "Q1 - lowest income" 2 "Q2" 3 "Q3" 4 "Q4" 5 "   Q5 - highest income" 6 "Unknown" // 19 characters without spaces
label values income inclab
rename income hh_inc // to make main code work
save "$dta/SWE_ts.dta" ,replace

reshape wide prop n_births , i(bdate_w) j(hh_inc)
gen str country="Sweden"
rename prop1 bot_prop
rename prop5 top_prop
rename n_births1 bot_nr
rename n_births5 top_nr
keep top_prop bot_prop bweek bdate_w loco total_births top_nr bot_nr country 


*** create variables
*TOP
poisson top_nr i.loco c.bdate_w##c.bdate_w i.bweek , irr
predict pred_top_nr, n

quietly: margins, ///
at(bdate_w=(2860(1)3223) loco=0) ///
at(bdate_w=(3170(1)3223) loco=1) ///
predict(n) ///
saving("$dta/margins_poisson_week_QUAD.dta", replace)

preserve 
use "$dta/margins_poisson_week_QUAD.dta", clear
rename _at2 bdate_w
rename _at1 loco
rename _margin lin_top_nr
keep lin_top_nr bdate_w loco
drop if loco==0 & bdate_w >=tw(2020w51)
save "$dta/margins_lin_pred.dta",replace

use "$dta/margins_poisson_week_QUAD.dta", clear
rename _at2 bdate_w
rename _at1 loco
rename _margin cf_lin_top_nr
keep cf_lin_top_nr bdate_w loco
keep if loco==0 & bdate_w >=tw(2020w51)
save "$dta/margins_cf_lin_pred.dta",replace
restore

merge 1:1 bdate_w using "$dta/margins_lin_pred.dta", nogen
merge 1:1 bdate_w using "$dta/margins_cf_lin_pred.dta", nogen

*BOT EDU
poisson bot_nr i.loco c.bdate_w##c.bdate_w i.bweek , irr
predict pred_bot_nr, n

quietly: margins, ///
at(bdate_w=(2860(1)3223) loco=0) ///
at(bdate_w=(3170(1)3223) loco=1) ///
predict(n) ///
saving("$dta/margins_poisson_week_QUAD.dta", replace)

preserve 
use "$dta/margins_poisson_week_QUAD.dta", clear
rename _at2 bdate_w
rename _at1 loco
rename _margin lin_bot_nr
keep lin_bot_nr bdate_w loco
drop if loco==0 & bdate_w >=tw(2020w51)
save "$dta/margins_lin_pred.dta",replace

use "$dta/margins_poisson_week_QUAD.dta", clear
rename _at2 bdate_w
rename _at1 loco
rename _margin cf_lin_bot_nr
keep cf_lin_bot_nr bdate_w loco
keep if loco==0 & bdate_w >=tw(2020w51)
save "$dta/margins_cf_lin_pred.dta",replace
restore

merge 1:1 bdate_w using "$dta/margins_lin_pred.dta", nogen
merge 1:1 bdate_w using "$dta/margins_cf_lin_pred.dta", nogen

save "$dta/SWE_comp.dta", replace

**# Bookmark #1

********** DENMARK ************************
********** DENMARK ************************
********** DENMARK ************************
********** DENMARK ************************

use "$dta/DEN_ts.dta" ,replace

reshape wide prop n_births , i(bdate_w) j(hh_inc)
gen str country="Denmark"
rename prop1 bot_prop
rename prop5 top_prop
rename n_births1 bot_nr
rename n_births5 top_nr
keep top_prop bot_prop bweek bdate_w loco total_births top_nr bot_nr country 


*** create variables
*TOP
poisson top_nr i.loco c.bdate_w##c.bdate_w i.bweek , irr
predict pred_top_nr, n

quietly: margins, ///
at(bdate_w=(2860(1)3223) loco=0) ///
at(bdate_w=(3170(1)3223) loco=1) ///
predict(n) ///
saving("$dta/margins_poisson_week_QUAD.dta", replace)

preserve 
use "$dta/margins_poisson_week_QUAD.dta", clear
rename _at2 bdate_w
rename _at1 loco
rename _margin lin_top_nr
keep lin_top_nr bdate_w loco
drop if loco==0 & bdate_w >=tw(2020w51)
save "$dta/margins_lin_pred.dta",replace

use "$dta/margins_poisson_week_QUAD.dta", clear
rename _at2 bdate_w
rename _at1 loco
rename _margin cf_lin_top_nr
keep cf_lin_top_nr bdate_w loco
keep if loco==0 & bdate_w >=tw(2020w51)
save "$dta/margins_cf_lin_pred.dta",replace
restore

merge 1:1 bdate_w using "$dta/margins_lin_pred.dta", nogen
merge 1:1 bdate_w using "$dta/margins_cf_lin_pred.dta", nogen

*BOT EDU
poisson bot_nr i.loco c.bdate_w##c.bdate_w i.bweek , irr
predict pred_bot_nr, n

quietly: margins, ///
at(bdate_w=(2860(1)3223) loco=0) ///
at(bdate_w=(3170(1)3223) loco=1) ///
predict(n) ///
saving("$dta/margins_poisson_week_QUAD.dta", replace)

preserve 
use "$dta/margins_poisson_week_QUAD.dta", clear
rename _at2 bdate_w
rename _at1 loco
rename _margin lin_bot_nr
keep lin_bot_nr bdate_w loco
drop if loco==0 & bdate_w >=tw(2020w51)
save "$dta/margins_lin_pred.dta",replace

use "$dta/margins_poisson_week_QUAD.dta", clear
rename _at2 bdate_w
rename _at1 loco
rename _margin cf_lin_bot_nr
keep cf_lin_bot_nr bdate_w loco
keep if loco==0 & bdate_w >=tw(2020w51)
save "$dta/margins_cf_lin_pred.dta",replace
restore

merge 1:1 bdate_w using "$dta/margins_lin_pred.dta", nogen
merge 1:1 bdate_w using "$dta/margins_cf_lin_pred.dta", nogen

save "$dta/DEN_comp.dta", replace

**# Bookmark #3

************** SOUTH AUSTRALIA **************
************** SOUTH AUSTRALIA **************
************** SOUTH AUSTRALIA **************
************** SOUTH AUSTRALIA **************

*Results were sent by collaborators at the University of Adelaide




**# Bookmark #1

******************************** UNITE THEM ALL*********************
******************************** UNITE THEM ALL*********************
******************************** UNITE THEM ALL*********************
******************************** UNITE THEM ALL*********************

use "$dta/AT_comp.dta", clear
append using "$dta/BRA_comp.dta"
append using "$dta/COL_comp.dta"
append using "$dta/ECU_comp.dta"
append using "$dta/ENG_comp.dta"
append using "$dta/FI_comp.dta"
append using "$dta/MEX_comp.dta"
append using "$dta/NET_comp.dta"
append using "$dta/SCOT_comp.dta"
append using "$dta/ESP_comp.dta"
append using "$dta/USA_comp.dta"
append using "$dta/WAL_comp.dta"
append using "$dta/SWE_comp.dta"
append using "$dta/DEN_comp.dta"

set scheme white_tableau
graph set window fontface "Arial Narrow"

replace zika=0 if zika==.
replace d_16_17=0 if d_16_17==.
encode country, gen(countrycode)

gen week=0
replace week=1 if country=="Brazil" | country=="Finland" | country=="Ecuador" | country=="Mexico" | country=="Sweden" | country=="Denmark"



**# Bookmark #1
******************* FIGURE 3 **************************

*************** WITH COMBINED LEGEND ***********************
*************** WITH COMBINED LEGEND ***********************
*************** WITH COMBINED LEGEND ***********************


tw ///
(line top_prop mdate if country=="Scotland", lpattern(solid) lwidth(medthick) lcolor(gs1)) /// 
(line bot_prop mdate if country=="Scotland", lpattern(shortdash) lwidth(medthick) lcolor(gs8)) /// 
, ///
xlab(660(12)731 , angle(h) grid) ///
xt(Month of Birth) ///
ylab(0.15(0.05)0.3, gmax) ///
yt(Share of All Live Births) ///
xline(731, lpattern(solid) lcolor(red)) ///
title({bf:Scotland} (Area Deprivation)) ///
legend(ring(0) position(9) order(2 "20% Most Deprived Areas" 1 "20% Least Deprived Areas")) ///
plotregion(lcolor(black)) ///
name(Scot, replace)

tw ///
(line top_prop mdate if country=="England", lpattern(solid) lwidth(medthick) lcolor(gs1)) /// 
(line bot_prop mdate if country=="England", lpattern(shortdash) lwidth(medthick) lcolor(gs8)) /// 
, ///
xlab(660(12)731 , angle(h) grid) ///
xt(Month of Birth) ///
ylab(0.15(0.05)0.3) ///
yt(Share of All Live Births) ///
xline(731, lpattern(solid) lcolor(red)) ///
title({bf:England} (Area Deprivation)) ///
legend(ring(0) position(9) order(2 "20% Most Deprived Areas" 1 "20% Least Deprived Areas")) ///
plotregion(lcolor(black)) ///
name(ENG, replace)


tw ///
(line top_prop mdate if country=="Wales", lpattern(solid) lwidth(medthick) lcolor(gs1)) /// 
(line bot_prop mdate if country=="Wales", lpattern(shortdash) lwidth(medthick) lcolor(gs8)) /// 
, ///
xlab(660(12)731 , angle(h) grid) ///
xt(Month of Birth) ///
ylab(0.15(0.05)0.3) ///
yt(Share of All Live Births) ///
xline(731, lpattern(solid) lcolor(red)) ///
title({bf:Wales} (Area Deprivation)) ///
legend(ring(0) position(9) order(2 "20% Most Deprived Areas" 1 "20% Least Deprived Areas")) ///
plotregion(lcolor(black)) ///
name(WAL, replace)


tw ///
(line top_prop bdate_w if country=="Ecuador", lpattern(solid) lwidth(medthick) lcolor(gs1)) /// 
(line bot_prop bdate_w if country=="Ecuador", lpattern(shortdash) lwidth(medthick) lcolor(gs8)) /// 
, ///
xlab(2860(52)3171, angle(h)) ///
xt(Week of Birth) ///
ylab(0.05(0.1)0.65) ///
yt(Share of All Live Births) ///
xline(3170, lpattern(solid) lcolor(red)) ///
title({bf:Ecuador} (Area Deprivation)) ///
legend(ring(0) position(9) order(1 "20% Least Deprived Areas" 2 "20% Most Deprived Areas" )) ///
plotregion(lcolor(black)) ///
name(ECU, replace)

tw ///
(line top_prop bdate_w if country=="Brazil", lpattern(solid) lwidth(medthick) lcolor(gs1)) /// 
(line bot_prop bdate_w if country=="Brazil", lpattern(shortdash) lwidth(medthick) lcolor(gs8)) /// 
, ///
xlab(2860(52)3171, angle(h)) ///
xt(Week of Birth) ///
ylab(0.1(0.1)0.5) ///
yt(Share of All Live Births) ///
xline(3170, lpattern(solid) lcolor(red)) ///
title({bf:Brazil} (Area Deprivation)) ///
legend(ring(0) position(9) order(1 "20% Least Deprived Areas" 2 "20% Most Deprived Areas" )) ///
plotregion(lcolor(black)) ///
name(BRA, replace)


tw ///
(line top_prop bdate_w if country=="Finland", lpattern(solid) lwidth(medium) lcolor(gs1)) /// 
(line bot_prop bdate_w if country=="Finland", lpattern(shortdash) lwidth(medium) lcolor(gs8)) /// 
, ///
xlab(2860(52)3171, angle(h)) ///
xt(Week of Birth) ///
ylab(0.10(0.05)0.30) ///
yt(Share of All Live Births) ///
xline(3170, lpattern(solid) lcolor(red)) ///
title({bf:Finland} (Household Income)) ///
legend(ring(0) position(10) order(1 "Top 20% Household Income" 2 "Bottom 20% Household Income" )) ///
plotregion(lcolor(black)) ///
name(FI, replace)


tw ///
(line top_prop bdate_w if country=="Sweden", lpattern(solid) lwidth(medium) lcolor(gs1)) /// 
(line bot_prop bdate_w if country=="Sweden", lpattern(shortdash) lwidth(medium) lcolor(gs8)) /// 
, ///
xlab(2860(52)3171, angle(h)) ///
xt(Week of Birth) ///
ylab(0.10(0.05)0.25, gmin) ///
yt(Share of All Live Births) ///
xline(3170, lpattern(solid) lcolor(red)) ///
title({bf:Sweden} (Household Income)) ///
legend(ring(0) position(10) order(1 "Top 20% Household Income" 2 "Bottom 20% Household Income" )) ///
plotregion(lcolor(black)) ///
name(SWE, replace)


tw ///
(line top_prop bdate_w if country=="Denmark", lpattern(solid) lwidth(medium) lcolor(gs1)) /// 
(line bot_prop bdate_w if country=="Denmark", lpattern(shortdash) lwidth(medium) lcolor(gs8)) /// 
, ///
xlab(2860(52)3171, angle(h)) ///
xt(Week of Birth) ///
ylab() ///
yt(Share of All Live Births) ///
xline(3170, lpattern(solid) lcolor(red)) ///
title({bf:Denmark} (Household Income)) ///
legend(ring(0) position(10) order(1 "Top 20% Household Income" 2 "Bottom 20% Household Income" )) ///
plotregion(lcolor(black)) ///
name(DEN, replace)



tw ///
(line top_prop mdate if country=="Netherlands", lpattern(solid) lwidth(medthick) lcolor(gs1)) /// 
(line bot_prop mdate if country=="Netherlands", lpattern(shortdash) lwidth(medthick) lcolor(gs8)) /// 
, ///
xlab(660(12)731 , angle(h) grid) ///
xt(Month of Birth) ///
ylab(0.10(0.05)0.30) ///
yt(Share of All Live Births) ///
xline(731, lpattern(solid) lcolor(red)) ///
title({bf:Netherlands} (Household Income)) ///
legend(ring(0) position(9) order(1 "Top 20% Household Income" 2 "Bottom 20% Household Income" )) ///
plotregion(lcolor(black)) ///
name(NET, replace)

tw ///
(line top_prop mdate if country=="Austria", lpattern(solid) lwidth(medthick) lcolor(gs1)) /// 
(line bot_prop mdate if country=="Austria", lpattern(shortdash) lwidth(medthick) lcolor(gs8)) /// 
, ///
xlab(660(12)731 , angle(h) grid) ///
xt("Week / Month of Birth") ///
ylab(0.15(0.05)0.40) ///
yt(Share of All Live Births) ///
xline(731, lpattern(solid) lcolor(red)) ///
title({bf:Austria} (Education)) ///
legend(position(6) row(1) order(1 "Top 20% Household Income;" "20% Least Deprived Areas;" "Post-secondary/Tertiary Education" 2 "Bottom 20% Household Income;" "20% Most Deprived Areas;"  "Lower Secondary/Primary Education" )) ///
plotregion(lcolor(black)) ///
name(AT, replace)

tw ///
(line top_prop mdate if country=="Colombia", lpattern(solid) lwidth(medthick) lcolor(gs1)) /// 
(line bot_prop mdate if country=="Colombia", lpattern(shortdash) lwidth(medthick) lcolor(gs8)) /// 
, ///
xlab(660(12)731 , angle(h) grid) ///
xt(Month of Birth) ///
ylab(0.2(0.05)0.40, gmin) ///
yt(Share of All Live Births) ///
xline(731, lpattern(solid) lcolor(red)) ///
title({bf:Colombia} (Education)) ///
legend(ring(0) position(9) order(1 "Post-secondary/Tertiary Education" 2 "Lower Secondary/Primary Education" )) ///
plotregion(lcolor(black)) ///
name(COL, replace)


tw ///
(line top_prop mdate if country=="United States", lpattern(solid) lwidth(medthick) lcolor(gs1)) /// 
(line bot_prop mdate if country=="United States", lpattern(shortdash) lwidth(medthick) lcolor(gs8)) /// 
, ///
xlab(660(12)731 , angle(h) grid) ///
xt(Month of Birth) ///
ylab(0.10(0.05)0.45) ///
yt(Share of All Live Births) ///
xline(731, lpattern(solid) lcolor(red)) ///
title({bf:United States} (Education)) ///
legend(ring(0) position(9) order(1 "Post-secondary/Tertiary Education" 2 "Lower Secondary/Primary Education" )) ///
plotregion(lcolor(black)) ///
name(US, replace)

tw ///
(line top_prop mdate if country=="Spain", lpattern(solid) lwidth(medthick) lcolor(gs1)) /// 
(line bot_prop mdate if country=="Spain", lpattern(shortdash) lwidth(medthick) lcolor(gs8)) /// 
, ///
xlab(660(12)731 , angle(h) grid) ///
xt(Month of Birth) ///
ylab(0.25(0.05)0.6) ///
yt(Share of All Live Births) ///
xline(731, lpattern(solid) lcolor(red)) ///
title({bf:Spain} (Education)) ///
legend(ring(0) position(9) order(1 "Post-secondary/Tertiary Education" 2 "Lower Secondary/Primary Education" )) ///
plotregion(lcolor(black)) ///
name(ESP, replace)


*we use elementary vs upper secondary + other
tw ///
(line top_prop bdate_w if country=="Mexico", lpattern(solid) lwidth(medthick) lcolor(gs1)) /// 
(line bot_prop bdate_w if country=="Mexico", lpattern(shortdash) lwidth(medthick) lcolor(gs8)) /// 
, ///
xlab(2860(52)3171, angle(h)) ///
xt(Week of Birth) ///
ylab(0.15(0.05)0.45, gmin) ///
yt(Share of All Live Births) ///
xline(3170, lpattern(solid) lcolor(red)) ///
title({bf:Mexico} (Education)) ///
legend(ring(0) position(9) order(1 "Upper Secondary/Other" 2 "Elementary" )) ///
plotregion(lcolor(black)) ///
name(MEX, replace)


graph use "C:\Users\moritzob\OneDrive - University of Helsinki\postdoc life helsinki\LoCo-effect\LoCo-effect Australia/AUS_prop_IRSAD2016.gph", name(AUS,replace)


grc1leg2  AT BRA COL DEN ECU ENG FI MEX NET Scot AUS ESP SWE US WAL  , ///
col(3) legscale(*0.7) legendfrom(AT) ///
plotregion(margin(zero)) imargin(zero) ///
xtob1title ytol1title ///
title("", size(medsmall)) 

graph save "$graph/Prop_all$S_DATE.gph", replace
graph export "$graph/Prop_all$S_DATE.svg", replace height(2800) width(3000)




**# Bookmark #2
******************* FIGURE 4 **************************


********** NUMBER OF BIRTHS MODELLED FOR TOP ****************
********** NUMBER OF BIRTHS MODELLED FOR TOP ****************
********** NUMBER OF BIRTHS MODELLED FOR TOP ****************

* NUmber of births and counterfactual with 15 panels

tw ///
(scatter top_nr mdate if country=="Scotland",  msize(vsmall) msym(o) mcolor(ebblue%60)) /// 
(line pred_top_nr mdate if country=="Scotland",  lwidth(thin) lcolor(gs10)) /// 
(line lin_top_nr mdate if country=="Scotland", lwidth(medium) lcolor(black)) ///
(line cf_lin_top_nr mdate if loco==1 & country=="Scotland", lpattern(shortdash) lwidth(medium) lcolor(black)) ///
, ///
xlab(660(12)731 , angle(h) grid) ///
xt(Month of Birth) ///
ylab(, gmin gmax) ///
yt(Share of All Live Births) ///
xline(731, lpattern(solid) lcolor(red) lwidth(thin)) ///
title({bf:Scotland} (Area Deprivation)) ///
legend(ring(0) position(9) order(2 "20% Most Deprived Areas" 1 "20% Least Deprived Areas")) ///
plotregion(lcolor(black)) ///
name(Scot, replace)

tw ///
(scatter top_nr mdate if country=="England",  msize(vsmall) msym(o) mcolor(ebblue%60)) /// 
(line pred_top_nr mdate if country=="England",  lwidth(thin) lcolor(gs10)) /// 
(line lin_top_nr mdate if country=="England", lwidth(medium) lcolor(black)) ///
(line cf_lin_top_nr mdate if loco==1 & country=="England", lpattern(shortdash) lwidth(medium) lcolor(black)) ///
, ///
xlab(660(12)731 , angle(h) grid) ///
xt(Month of Birth) ///
ylab() ///
yt(Share of All Live Births) ///
xline(731, lpattern(solid) lcolor(red) lwidth(thin)) ///
title({bf:England} (Area Deprivation)) ///
legend(ring(0) position(9) order(2 "20% Most Deprived Areas" 1 "20% Least Deprived Areas")) ///
plotregion(lcolor(black)) ///
name(ENG, replace)


tw ///
(scatter top_nr mdate if country=="Wales",  msize(vsmall) msym(o) mcolor(ebblue%60)) /// 
(line pred_top_nr mdate if country=="Wales",  lwidth(thin) lcolor(gs10)) /// 
(line lin_top_nr mdate if country=="Wales", lwidth(medium) lcolor(black)) ///
(line cf_lin_top_nr mdate if loco==1 & country=="Wales", lpattern(shortdash) lwidth(medium) lcolor(black)) ///
, ///
xlab(660(12)731 , angle(h) grid) ///
xt(Month of Birth) ///
ylab() ///
yt(Share of All Live Births) ///
xline(731, lpattern(solid) lcolor(red) lwidth(thin)) ///
title({bf:Wales} (Area Deprivation)) ///
legend(ring(0) position(9) order(2 "20% Most Deprived Areas" 1 "20% Least Deprived Areas")) ///
plotregion(lcolor(black)) ///
name(WAL, replace)


tw ///
(scatter top_nr bdate_w if country=="Ecuador",  msize(tiny) msym(o) mcolor(ebblue%60)) /// 
(line pred_top_nr bdate_w if country=="Ecuador",  lwidth(thin) lcolor(gs10)) /// 
(line lin_top_nr bdate_w if country=="Ecuador", lwidth(medium) lcolor(black)) ///
(line cf_lin_top_nr bdate_w if loco==1 & country=="Ecuador", lpattern(shortdash) lwidth(medium) lcolor(black)) ///
, ///
xlab(2860(52)3171, angle(h)) ///
xt(Week of Birth) ///
ylab() ///
yt(Share of All Live Births) ///
xline(3170, lpattern(solid) lcolor(red) lwidth(thin)) ///
title({bf:Ecuador} (Area Deprivation)) ///
legend(ring(0) position(9) order(1 "20% Least Deprived Areas" 2 "20% Most Deprived Areas" )) ///
plotregion(lcolor(black)) ///
name(ECU, replace)

tw ///
(scatter top_nr bdate_w if country=="Brazil",  msize(tiny) msym(o) mcolor(ebblue%60)) /// 
(line pred_top_nr bdate_w if country=="Brazil",  lwidth(thin) lcolor(gs10)) /// 
(line lin_top_nr bdate_w if country=="Brazil", lwidth(medium) lcolor(black)) ///
(line cf_lin_top_nr bdate_w if loco==1 & country=="Brazil", lpattern(shortdash) lwidth(medium) lcolor(black)) ///
, ///
xlab(2860(52)3171, angle(h)) ///
xt(Week of Birth) ///
ylab() ///
yt(Share of All Live Births) ///
xline(3170, lpattern(solid) lcolor(red) lwidth(thin)) ///
title({bf:Brazil} (Area Deprivation)) ///
legend(ring(0) position(9) order(1 "20% Least Deprived Areas" 2 "20% Most Deprived Areas" )) ///
plotregion(lcolor(black)) ///
name(BRA, replace)


tw ///
(scatter top_nr bdate_w if country=="Finland",  msize(tiny) msym(o) mcolor(ebblue%60)) /// 
(line pred_top_nr bdate_w if country=="Finland",  lwidth(thin) lcolor(gs10)) /// 
(line lin_top_nr bdate_w if country=="Finland", lwidth(medium) lcolor(black)) ///
(line cf_lin_top_nr bdate_w if loco==1 & country=="Finland", lpattern(shortdash) lwidth(medium) lcolor(black)) ///
, ///
xlab(2860(52)3171, angle(h)) ///
xt(Week of Birth) ///
ylab() ///
yt(Share of All Live Births) ///
xline(3170, lpattern(solid) lcolor(red) lwidth(thin)) ///
title({bf:Finland} (Household Income)) ///
legend(ring(0) position(10) order(1 "Top 20% Household Income" 2 "Bottom 20% Household Income" )) ///
plotregion(lcolor(black)) ///
name(FI, replace)


tw ///
(scatter top_nr bdate_w if country=="Sweden",  msize(tiny) msym(o) mcolor(ebblue%60)) /// 
(line pred_top_nr bdate_w if country=="Sweden",  lwidth(thin) lcolor(gs10)) /// 
(line lin_top_nr bdate_w if country=="Sweden", lwidth(medium) lcolor(black)) ///
(line cf_lin_top_nr bdate_w if loco==1 & country=="Sweden", lpattern(shortdash) lwidth(medium) lcolor(black)) ///
, ///
xlab(2860(52)3171, angle(h)) ///
xt(Week of Birth) ///
ylab() ///
yt(Share of All Live Births) ///
xline(3170, lpattern(solid) lcolor(red) lwidth(thin)) ///
title({bf:Sweden} (Household Income)) ///
legend(ring(0) position(10) order(1 "Top 20% Household Income" 2 "Bottom 20% Household Income" )) ///
plotregion(lcolor(black)) ///
name(SWE, replace)

tw ///
(scatter top_nr bdate_w if country=="Denmark",  msize(tiny) msym(o) mcolor(ebblue%60)) /// 
(line pred_top_nr bdate_w if country=="Denmark",  lwidth(thin) lcolor(gs10)) /// 
(line lin_top_nr bdate_w if country=="Denmark", lwidth(medium) lcolor(black)) ///
(line cf_lin_top_nr bdate_w if loco==1 & country=="Denmark", lpattern(shortdash) lwidth(medium) lcolor(black)) ///
, ///
xlab(2860(52)3171, angle(h)) ///
xt(Week of Birth) ///
ylab() ///
yt(Share of All Live Births) ///
xline(3170, lpattern(solid) lcolor(red) lwidth(thin)) ///
title({bf:Denmark} (Household Income)) ///
legend(ring(0) position(10) order(1 "Top 20% Household Income" 2 "Bottom 20% Household Income" )) ///
plotregion(lcolor(black)) ///
name(DEN, replace)


tw ///
(scatter top_nr mdate if country=="Netherlands",  msize(vsmall) msym(o) mcolor(ebblue%60)) /// 
(line pred_top_nr mdate if country=="Netherlands",  lwidth(thin) lcolor(gs10)) /// 
(line lin_top_nr mdate if country=="Netherlands", lwidth(medium) lcolor(black)) ///
(line cf_lin_top_nr mdate if loco==1 & country=="Netherlands", lpattern(shortdash) lwidth(medium) lcolor(black)) ///
, ///
xlab(660(12)731 , angle(h) grid) ///
xt(Month of Birth) ///
ylab() ///
yt(Share of All Live Births) ///
xline(731, lpattern(solid) lcolor(red) lwidth(thin)) ///
title({bf:Netherlands} (Household Income)) ///
legend(ring(0) position(9) order(1 "Top 20% Household Income" 2 "Bottom 20% Household Income" )) ///
plotregion(lcolor(black)) ///
name(NET, replace)

tw ///
(scatter top_nr mdate if country=="Austria",  msize(vsmall) msym(o) mcolor(ebblue%60)) /// 
(line pred_top_nr mdate if country=="Austria",  lwidth(thin) lcolor(gs10)) /// 
(line lin_top_nr mdate if country=="Austria", lwidth(medium) lcolor(black)) ///
(line cf_lin_top_nr mdate if loco==1 & country=="Austria", lpattern(shortdash) lwidth(medium) lcolor(black)) ///
, ///
xlab(660(12)731 , angle(h) grid) ///
xt(Week / Month of Birth) ///
ylab() ///
yt(Number of Live Births) ///
xline(731, lpattern(solid) lcolor(red) lwidth(thin)) ///
title({bf:Austria} (Education)) ///
legend(position(6) row(1) order(1 "Observed" 2 "Fitted" 3 "Deseasonalised Fitted" 4 "Deseasonalised Expected" )) ///
plotregion(lcolor(black)) ///
name(AT, replace)

tw ///
(scatter top_nr mdate if country=="Colombia",  msize(vsmall) msym(o) mcolor(ebblue%60)) /// 
(line pred_top_nr mdate if country=="Colombia",  lwidth(thin) lcolor(gs10)) /// 
(line lin_top_nr mdate if country=="Colombia", lwidth(medium) lcolor(black)) ///
(line cf_lin_top_nr mdate if loco==1 & country=="Colombia", lpattern(shortdash) lwidth(medium) lcolor(black)) ///
, ///
xlab(660(12)731 , angle(h) grid) ///
xt(Month of Birth) ///
ylab() ///
yt(Share of All Live Births) ///
xline(731, lpattern(solid) lcolor(red) lwidth(thin)) ///
title({bf:Colombia} (Education)) ///
legend(ring(0) position(9) order(1 "Post-secondary/Tertiary Education" 2 "Lower Secondary/Primary Education" )) ///
plotregion(lcolor(black)) ///
name(COL, replace)


tw ///
(scatter top_nr mdate if country=="United States",  msize(vsmall) msym(o) mcolor(ebblue%60)) /// 
(line pred_top_nr mdate if country=="United States",  lwidth(thin) lcolor(gs10)) /// 
(line lin_top_nr mdate if country=="United States", lwidth(medium) lcolor(black)) ///
(line cf_lin_top_nr mdate if loco==1 & country=="United States", lpattern(shortdash) lwidth(medium) lcolor(black)) ///
, ///
xlab(660(12)731 , angle(h) grid) ///
xt(Month of Birth) ///
ylab() ///
yt(Share of All Live Births) ///
xline(731, lpattern(solid) lcolor(red) lwidth(thin)) ///
title({bf:United States} (Education)) ///
legend(ring(0) position(9) order(1 "Post-secondary/Tertiary Education" 2 "Lower Secondary/Primary Education" )) ///
plotregion(lcolor(black)) ///
name(US, replace)

tw ///
(scatter top_nr mdate if country=="Spain",  msize(vsmall) msym(o) mcolor(ebblue%60)) /// 
(line pred_top_nr mdate if country=="Spain",  lwidth(thin) lcolor(gs10)) /// 
(line lin_top_nr mdate if country=="Spain", lwidth(medium) lcolor(black)) ///
(line cf_lin_top_nr mdate if loco==1 & country=="Spain", lpattern(shortdash) lwidth(medium) lcolor(black)) ///
, ///
xlab(660(12)731 , angle(h) grid) ///
xt(Month of Birth) ///
ylab() ///
yt(Share of All Live Births) ///
xline(731, lpattern(solid) lcolor(red) lwidth(thin)) ///
title({bf:Spain} (Education)) ///
legend(ring(0) position(9) order(1 "Post-secondary/Tertiary Education" 2 "Lower Secondary/Primary Education" )) ///
plotregion(lcolor(black)) ///
name(ESP, replace)


*we use elementary vs upper secondary + other
tw ///
(scatter top_nr bdate_w if country=="Mexico",  msize(tiny) msym(o) mcolor(ebblue%60)) /// 
(line pred_top_nr bdate_w if country=="Mexico",  lwidth(thin) lcolor(gs10)) /// 
(line lin_top_nr bdate_w if country=="Mexico", lwidth(medium) lcolor(black)) ///
(line cf_lin_top_nr bdate_w if loco==1 & country=="Mexico", lpattern(shortdash) lwidth(medium) lcolor(black)) ///
, ///
xlab(2860(52)3171, angle(h)) ///
xt(Week of Birth) ///
ylab() ///
yt(Share of All Live Births) ///
xline(3170, lpattern(solid) lcolor(red) lwidth(thin)) ///
title({bf:Mexico} (Education)) ///
legend(ring(0) position(9) order(1 "Upper Secondary/Other" 2 "Elementary" )) ///
plotregion(lcolor(black)) ///
name(MEX, replace)


graph use "C:\Users\moritzob\OneDrive - University of Helsinki\postdoc life helsinki\LoCo-effect\LoCo-effect Australia/AUS_top_nr_IRSAD2016.gph", name(AUS,replace)


grc1leg2 AT BRA COL DEN ECU ENG FI MEX NET Scot AUS ESP SWE US WAL , ///
col(3)  legscale(*1.0) legendfrom(AT) ///
plotregion(margin(zero)) imargin(zero) ///
xtob1title ytol1title ///
title("Number of Live Births in Socioeconomically {bf:Advantaged }Groups", size(medsmall)) 

graph save "$graph/top_number_all$S_DATE.gph", replace
graph export "$graph/top_number_all$S_DATE.svg", replace height(3000) width(3000)



**# Bookmark #3
******************* FIGURE 5 **************************


********** NUMBER OF BIRTHS MODELLED FOR BOT ****************
********** NUMBER OF BIRTHS MODELLED FOR BOT ****************
********** NUMBER OF BIRTHS MODELLED FOR BOT ****************

* NUmber of births and counterfactual with 12 panels


tw ///
(scatter bot_nr mdate if country=="Scotland",  msize(vsmall) msym(o) mcolor(ebblue%60)) /// 
(line pred_bot_nr mdate if country=="Scotland",  lwidth(thin) lcolor(gs10)) /// 
(line lin_bot_nr mdate if country=="Scotland", lwidth(medium) lcolor(black)) ///
(line cf_lin_bot_nr mdate if loco==1 & country=="Scotland", lpattern(shortdash) lwidth(medium) lcolor(black)) ///
, ///
xlab(660(12)731 , angle(h) grid) ///
xt(Month of Birth) ///
ylab() ///
yt(Share of All Live Births) ///
xline(731, lpattern(solid) lcolor(red) lwidth(thin)) ///
title({bf:Scotland} (Area Deprivation)) ///
legend(ring(0) position(9) order(2 "20% Most Deprived Areas" 1 "20% Least Deprived Areas")) ///
plotregion(lcolor(black)) ///
name(Scot, replace)

tw ///
(scatter bot_nr mdate if country=="England",  msize(vsmall) msym(o) mcolor(ebblue%60)) /// 
(line pred_bot_nr mdate if country=="England",  lwidth(thin) lcolor(gs10)) /// 
(line lin_bot_nr mdate if country=="England", lwidth(medium) lcolor(black)) ///
(line cf_lin_bot_nr mdate if loco==1 & country=="England", lpattern(shortdash) lwidth(medium) lcolor(black)) ///
, ///
xlab(660(12)731 , angle(h) grid) ///
xt(Month of Birth) ///
ylab() ///
yt(Share of All Live Births) ///
xline(731, lpattern(solid) lcolor(red) lwidth(thin)) ///
title({bf:England} (Area Deprivation)) ///
legend(ring(0) position(9) order(2 "20% Most Deprived Areas" 1 "20% Least Deprived Areas")) ///
plotregion(lcolor(black)) ///
name(ENG, replace)


tw ///
(scatter bot_nr mdate if country=="Wales",  msize(vsmall) msym(o) mcolor(ebblue%60)) /// 
(line pred_bot_nr mdate if country=="Wales",  lwidth(thin) lcolor(gs10)) /// 
(line lin_bot_nr mdate if country=="Wales", lwidth(medium) lcolor(black)) ///
(line cf_lin_bot_nr mdate if loco==1 & country=="Wales", lpattern(shortdash) lwidth(medium) lcolor(black)) ///
, ///
xlab(660(12)731 , angle(h) grid) ///
xt(Month of Birth) ///
ylab() ///
yt(Share of All Live Births) ///
xline(731, lpattern(solid) lcolor(red) lwidth(thin)) ///
title({bf:Wales} (Area Deprivation)) ///
legend(ring(0) position(9) order(2 "20% Most Deprived Areas" 1 "20% Least Deprived Areas")) ///
plotregion(lcolor(black)) ///
name(WAL, replace)


tw ///
(scatter bot_nr bdate_w if country=="Ecuador",  msize(tiny) msym(o) mcolor(ebblue%60)) /// 
(line pred_bot_nr bdate_w if country=="Ecuador",  lwidth(thin) lcolor(gs10)) /// 
(line lin_bot_nr bdate_w if country=="Ecuador", lwidth(medium) lcolor(black)) ///
(line cf_lin_bot_nr bdate_w if loco==1 & country=="Ecuador", lpattern(shortdash) lwidth(medium) lcolor(black)) ///
, ///
xlab(2860(52)3171, angle(h)) ///
xt(Week of Birth) ///
ylab() ///
yt(Share of All Live Births) ///
xline(3170, lpattern(solid) lcolor(red) lwidth(thin)) ///
title({bf:Ecuador} (Area Deprivation)) ///
legend(ring(0) position(9) order(1 "20% Least Deprived Areas" 2 "20% Most Deprived Areas" )) ///
plotregion(lcolor(black)) ///
name(ECU, replace)

tw ///
(scatter bot_nr bdate_w if country=="Brazil",  msize(tiny) msym(o) mcolor(ebblue%60)) /// 
(line pred_bot_nr bdate_w if country=="Brazil",  lwidth(thin) lcolor(gs10)) /// 
(line lin_bot_nr bdate_w if country=="Brazil", lwidth(medium) lcolor(black)) ///
(line cf_lin_bot_nr bdate_w if loco==1 & country=="Brazil", lpattern(shortdash) lwidth(medium) lcolor(black)) ///
, ///
xlab(2860(52)3171, angle(h)) ///
xt(Week of Birth) ///
ylab() ///
yt(Share of All Live Births) ///
xline(3170, lpattern(solid) lcolor(red) lwidth(thin)) ///
title({bf:Brazil} (Area Deprivation)) ///
legend(ring(0) position(9) order(1 "20% Least Deprived Areas" 2 "20% Most Deprived Areas" )) ///
plotregion(lcolor(black)) ///
name(BRA, replace)


tw ///
(scatter bot_nr bdate_w if country=="Finland",  msize(tiny) msym(o) mcolor(ebblue%60)) /// 
(line pred_bot_nr bdate_w if country=="Finland",  lwidth(thin) lcolor(gs10)) /// 
(line lin_bot_nr bdate_w if country=="Finland", lwidth(medium) lcolor(black)) ///
(line cf_lin_bot_nr bdate_w if loco==1 & country=="Finland", lpattern(shortdash) lwidth(medium) lcolor(black)) ///
, ///
xlab(2860(52)3171, angle(h)) ///
xt(Week of Birth) ///
ylab() ///
yt(Share of All Live Births) ///
xline(3170, lpattern(solid) lcolor(red) lwidth(thin)) ///
title({bf:Finland} (Household Income)) ///
legend(ring(0) position(10) order(1 "Bot 20% Household Income" 2 "Bottom 20% Household Income" )) ///
plotregion(lcolor(black)) ///
name(FI, replace)

tw ///
(scatter bot_nr bdate_w if country=="Sweden",  msize(tiny) msym(o) mcolor(ebblue%60)) /// 
(line pred_bot_nr bdate_w if country=="Sweden",  lwidth(thin) lcolor(gs10)) /// 
(line lin_bot_nr bdate_w if country=="Sweden", lwidth(medium) lcolor(black)) ///
(line cf_lin_bot_nr bdate_w if loco==1 & country=="Sweden", lpattern(shortdash) lwidth(medium) lcolor(black)) ///
, ///
xlab(2860(52)3171, angle(h)) ///
xt(Week of Birth) ///
ylab(350(50)500, gmin gmax) ///
yt(Share of All Live Births) ///
xline(3170, lpattern(solid) lcolor(red) lwidth(thin)) ///
title({bf:Sweden} (Household Income)) ///
legend(ring(0) position(10) order(1 "Bot 20% Household Income" 2 "Bottom 20% Household Income" )) ///
plotregion(lcolor(black)) ///
name(SWE, replace)

tw ///
(scatter bot_nr bdate_w if country=="Denmark",  msize(tiny) msym(o) mcolor(ebblue%60)) /// 
(line pred_bot_nr bdate_w if country=="Denmark",  lwidth(thin) lcolor(gs10)) /// 
(line lin_bot_nr bdate_w if country=="Denmark", lwidth(medium) lcolor(black)) ///
(line cf_lin_bot_nr bdate_w if loco==1 & country=="Denmark", lpattern(shortdash) lwidth(medium) lcolor(black)) ///
, ///
xlab(2860(52)3171, angle(h)) ///
xt(Week of Birth) ///
ylab() ///
yt(Share of All Live Births) ///
xline(3170, lpattern(solid) lcolor(red) lwidth(thin)) ///
title({bf:Denmark} (Household Income)) ///
legend(ring(0) position(10) order(1 "Bot 20% Household Income" 2 "Bottom 20% Household Income" )) ///
plotregion(lcolor(black)) ///
name(DEN, replace)



tw ///
(scatter bot_nr mdate if country=="Netherlands",  msize(vsmall) msym(o) mcolor(ebblue%60)) /// 
(line pred_bot_nr mdate if country=="Netherlands",  lwidth(thin) lcolor(gs10)) /// 
(line lin_bot_nr mdate if country=="Netherlands", lwidth(medium) lcolor(black)) ///
(line cf_lin_bot_nr mdate if loco==1 & country=="Netherlands", lpattern(shortdash) lwidth(medium) lcolor(black)) ///
, ///
xlab(660(12)731 , angle(h) grid) ///
xt(Month of Birth) ///
ylab() ///
yt(Share of All Live Births) ///
xline(731, lpattern(solid) lcolor(red) lwidth(thin)) ///
title({bf:Netherlands} (Household Income)) ///
legend(ring(0) position(9) order(1 "Bot 20% Household Income" 2 "Bottom 20% Household Income" )) ///
plotregion(lcolor(black)) ///
name(NET, replace)

tw ///
(scatter bot_nr mdate if country=="Austria",  msize(vsmall) msym(o) mcolor(ebblue%60)) /// 
(line pred_bot_nr mdate if country=="Austria",  lwidth(thin) lcolor(gs10)) /// 
(line lin_bot_nr mdate if country=="Austria", lwidth(medium) lcolor(black)) ///
(line cf_lin_bot_nr mdate if loco==1 & country=="Austria", lpattern(shortdash) lwidth(medium) lcolor(black)) ///
, ///
xlab(660(12)731 , angle(h) grid) ///
xt(Week / Month of Birth) ///
ylab() ///
yt(Number of Live Births) ///
xline(731, lpattern(solid) lcolor(red) lwidth(thin)) ///
title({bf:Austria} (Education)) ///
legend(position(6) row(1) order(1 "Observed" 2 "Fitted" 3 "Deseasonalised Fitted" 4 "Deseasonalised Expected" )) ///
plotregion(lcolor(black)) ///
name(AT, replace)

tw ///
(scatter bot_nr mdate if country=="Colombia",  msize(vsmall) msym(o) mcolor(ebblue%60)) /// 
(line pred_bot_nr mdate if country=="Colombia",  lwidth(thin) lcolor(gs10)) /// 
(line lin_bot_nr mdate if country=="Colombia", lwidth(medium) lcolor(black)) ///
(line cf_lin_bot_nr mdate if loco==1 & country=="Colombia", lpattern(shortdash) lwidth(medium) lcolor(black)) ///
, ///
xlab(660(12)731 , angle(h) grid) ///
xt(Month of Birth) ///
ylab() ///
yt(Share of All Live Births) ///
xline(731, lpattern(solid) lcolor(red) lwidth(thin)) ///
title({bf:Colombia} (Education)) ///
legend(ring(0) position(9) order(1 "Post-secondary/Tertiary Education" 2 "Lower Secondary/Primary Education" )) ///
plotregion(lcolor(black)) ///
name(COL, replace)


tw ///
(scatter bot_nr mdate if country=="United States",  msize(vsmall) msym(o) mcolor(ebblue%60)) /// 
(line pred_bot_nr mdate if country=="United States",  lwidth(thin) lcolor(gs10)) /// 
(line lin_bot_nr mdate if country=="United States", lwidth(medium) lcolor(black)) ///
(line cf_lin_bot_nr mdate if loco==1 & country=="United States", lpattern(shortdash) lwidth(medium) lcolor(black)) ///
, ///
xlab(660(12)731 , angle(h) grid) ///
xt(Month of Birth) ///
ylab() ///
yt(Share of All Live Births) ///
xline(731, lpattern(solid) lcolor(red) lwidth(thin)) ///
title({bf:United States} (Education)) ///
legend(ring(0) position(9) order(1 "Post-secondary/Tertiary Education" 2 "Lower Secondary/Primary Education" )) ///
plotregion(lcolor(black)) ///
name(US, replace)

tw ///
(scatter bot_nr mdate if country=="Spain",  msize(vsmall) msym(o) mcolor(ebblue%60)) /// 
(line pred_bot_nr mdate if country=="Spain",  lwidth(thin) lcolor(gs10)) /// 
(line lin_bot_nr mdate if country=="Spain", lwidth(medium) lcolor(black)) ///
(line cf_lin_bot_nr mdate if loco==1 & country=="Spain", lpattern(shortdash) lwidth(medium) lcolor(black)) ///
, ///
xlab(660(12)731 , angle(h) grid) ///
xt(Month of Birth) ///
ylab() ///
yt(Share of All Live Births) ///
xline(731, lpattern(solid) lcolor(red) lwidth(thin)) ///
title({bf:Spain} (Education)) ///
legend(ring(0) position(9) order(1 "Post-secondary/Tertiary Education" 2 "Lower Secondary/Primary Education" )) ///
plotregion(lcolor(black)) ///
name(ESP, replace)

*we use elementary vs upper secondary + other
tw ///
(scatter bot_nr bdate_w if country=="Mexico",  msize(tiny) msym(o) mcolor(ebblue%60)) /// 
(line pred_bot_nr bdate_w if country=="Mexico",  lwidth(thin) lcolor(gs10)) /// 
(line lin_bot_nr bdate_w if country=="Mexico", lwidth(medium) lcolor(black)) ///
(line cf_lin_bot_nr bdate_w if loco==1 & country=="Mexico", lpattern(shortdash) lwidth(medium) lcolor(black)) ///
, ///
xlab(2860(52)3171, angle(h)) ///
xt(Week of Birth) ///
ylab(, ) ///
yt(Share of All Live Births) ///
xline(3170, lpattern(solid) lcolor(red) lwidth(thin)) ///
title({bf:Mexico} (Education)) ///
legend(ring(0) position(9) order(1 "Upper Secondary/Other" 2 "Elementary" )) ///
plotregion(lcolor(black)) ///
name(MEX, replace)

graph use "C:\Users\moritzob\OneDrive - University of Helsinki\postdoc life helsinki\LoCo-effect\LoCo-effect Australia/AUS_bot_nr_IRSAD2016.gph", name(AUS,replace)


grc1leg2 AT BRA COL DEN ECU ENG FI MEX NET Scot AUS ESP SWE US WAL , ///
col(3)  legscale(*1.0) legendfrom(AT) ///
plotregion(margin(zero)) imargin(zero) ///
xtob1title ytol1title ///
title("Number of Live Births in Socioeconomically {bf:Disadvantaged } Groups", size(medsmall)) 

graph save "$graph/bot_number_all$S_DATE.gph", replace
graph export "$graph/bot_number_all$S_DATE.svg", replace height(3000) width(3000)



**# Bookmark #7

*******Producing estimates shown in Figures 6,7, Table 1 *********
*******Producing estimates shown in Figures 6,7, Table 1 *********
*******Producing estimates shown in Figures 6,7, Table 1 *********



*************************** AUSTRIA AUSTRIA AUSTRIA ******************************
*************************** AUSTRIA AUSTRIA AUSTRIA ******************************
*************************** AUSTRIA AUSTRIA AUSTRIA ******************************
*************************** AUSTRIA AUSTRIA AUSTRIA ******************************
use "$dta/AT_ts.dta", clear

clear all
use "$dta/AT_ts", clear
preserve // get numbers for table later
collapse (sum) n_births if loco==1, by(mom_edu_comp)
egen total_births=sum(n_births)
gen prop= n_births/total_births
save "$dta/AT_obs.dta" ,replace
restore 

****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=1/6 {
use "$dta/AT_ts.dta", clear
keep if mom_edu_comp==`i'
poisson n_births i.loco c.mdate c.mdate#c.mdate i.month_nr , irr
count if loco==1 & e(sample)==1
scalar r=r(N) 
di r

margins, ///
at(loco=0 ) ///
exp(predict(n)*r) ///
subpop(if loco==1 ) ///
saving("$dta\cf_count_`i'.dta", replace)

preserve 
use "$dta/cf_count_`i'.dta", clear
rename _margin cf_count
rename _ci_lb cf_count_lb 
rename _ci_ub cf_count_ub
rename _se_margin se_cf_count
gen mom_edu_comp=`i'
keep mom_edu_comp cf_count se_cf_count cf_count_lb cf_count_ub
save "$dta/cf_estimate_`i'.dta", replace
restore


margins, ///
at(loco=0) ///
at((asobs) _all ) ///
exp(predict(n)*r) ///
subpop(if loco==1) ///
pwcompare ///
saving("$dta\countdiff_`i'.dta", replace)

preserve 
use "$dta/countdiff_`i'.dta", clear
rename _margin countdiff
rename _ci_lb countdiff_lb
rename _ci_ub countdiff_ub
gen mom_edu_comp=`i'
keep mom_edu_comp countdiff countdiff_lb countdiff_ub
save "$dta/countdiff_estimate_`i'.dta", replace
restore

}


use "$dta/cf_estimate_1", clear
forval i=2/6 {
	append using "$dta/cf_estimate_`i'"
}


merge 1:1  mom_edu_comp using "$dta/AT_obs.dta", nogen
order mom_edu_comp n_births cf_count se_cf_count 
egen total_cf_count=sum(cf_count)
gen cf_prop=cf_count/total_cf_count
gen propdiff=prop-cf_prop
save "$dta/AT_cf_estimate.dta", replace


use "$dta/countdiff_estimate_1", clear
forval i=2/6 {
	append using "$dta/countdiff_estimate_`i'"
}

merge 1:1  mom_edu_comp using "$dta/AT_cf_estimate.dta", nogen
order mom_edu_comp n_births cf_count se_cf_count 
save "$dta/AT_cf_estimate.dta", replace

*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
set seed 123456789
forval d=1/10000 {
use "$dta/AT_cf_estimate.dta", clear
keep mom_edu_comp cf_count se_cf_count prop
gen cf_count_i_d=rnormal(cf_count , se_cf_count) // generate random draw d from mean SE estimated from poisson ITS for each SIMD group i
egen sum_cf_count_i_d=sum(cf_count_i_d) // sum random draws d of all groups i
gen cf_prop_i_d=cf_count_i_d/sum_cf_count_i_d // create counterfactual proportion for each group i based on draw d
gen propdiff_i_d=prop- cf_prop_i_d // get m_i_d which is the difference in proportion between observed and counterfactual from draw d
keep mom_edu_comp propdiff_i_d
gen draw=`d'

tempfile draw_`d'
save `draw_`d'',replace
}

*merge data
use `draw_1' ,clear
forval d=2/10000 {
	append using `draw_`d''
}

*generate lower and upper bound of difference in proportion
_pctile propdiff_i_d if mom_edu_comp==1, percentiles(2.5) 
return list
gen propdiff_lb=r(r1) if mom_edu_comp==1
_pctile propdiff_i_d if mom_edu_comp==1, percentiles(97.5) 
return list
gen propdiff_ub=r(r1) if mom_edu_comp==1

forval i=2/6 {
_pctile propdiff_i_d if mom_edu_comp==`i', percentiles(2.5) 
return list
replace propdiff_lb=r(r1) if mom_edu_comp==`i'
_pctile propdiff_i_d if mom_edu_comp==`i', percentiles(97.5) 
return list
replace propdiff_ub=r(r1) if mom_edu_comp==`i'
}

collapse propdiff_lb propdiff_ub, by(mom_edu_comp)
save "$dta/AT_prop_uncertainty", replace
use "$dta/AT_cf_estimate", clear
merge 1:1 mom_edu_comp using "$dta/AT_prop_uncertainty", nogen
gen country="Austria"
save "$dta/AT_comp_diff", replace


**# Bookmark #6
*************************** USA  USA  USA ******************************
*************************** USA  USA  USA ******************************
*************************** USA  USA  USA ******************************
*************************** USA  USA  USA ******************************

clear all
use "$dta/US_ts", clear
preserve // get numbers for table later
collapse (sum) n_births if loco==1, by(mom_edu_comp)
egen total_births=sum(n_births)
gen prop= n_births/total_births
save "$dta/US_obs.dta" ,replace
restore 

****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=1/4 {
use "$dta/US_ts.dta", clear
keep if mom_edu_comp==`i'
poisson n_births i.loco c.mdate c.mdate#c.mdate i.month_nr , irr
count if loco==1 & e(sample)==1
scalar r=r(N) 
di r

margins, ///
at(loco=0 ) ///
exp(predict(n)*r) ///
subpop(if loco==1 ) ///
saving("$dta\cf_count_`i'.dta", replace)

preserve 
use "$dta/cf_count_`i'.dta", clear
rename _margin cf_count
rename _ci_lb cf_count_lb 
rename _ci_ub cf_count_ub
rename _se_margin se_cf_count
gen mom_edu_comp=`i'
keep mom_edu_comp cf_count se_cf_count cf_count_lb cf_count_ub
save "$dta/cf_estimate_`i'.dta", replace
restore


margins, ///
at(loco=0) ///
at((asobs) _all ) ///
exp(predict(n)*r) ///
subpop(if loco==1) ///
pwcompare ///
saving("$dta\countdiff_`i'.dta", replace)

preserve 
use "$dta/countdiff_`i'.dta", clear
rename _margin countdiff
rename _ci_lb countdiff_lb
rename _ci_ub countdiff_ub
gen mom_edu_comp=`i'
keep mom_edu_comp countdiff countdiff_lb countdiff_ub
save "$dta/countdiff_estimate_`i'.dta", replace
restore

}


use "$dta/cf_estimate_1", clear
forval i=2/4 {
	append using "$dta/cf_estimate_`i'"
}


merge 1:1  mom_edu_comp using "$dta/US_obs.dta", nogen
order mom_edu_comp n_births cf_count se_cf_count 
egen total_cf_count=sum(cf_count)
gen cf_prop=cf_count/total_cf_count
gen propdiff=prop-cf_prop
save "$dta/US_cf_estimate.dta", replace


use "$dta/countdiff_estimate_1", clear
forval i=2/4 {
	append using "$dta/countdiff_estimate_`i'"
}

merge 1:1  mom_edu_comp using "$dta/US_cf_estimate.dta", nogen
order mom_edu_comp n_births cf_count se_cf_count 
save "$dta/US_cf_estimate.dta", replace

*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
set seed 123456789
forval d=1/10000 {
use "$dta/US_cf_estimate.dta", clear
keep mom_edu_comp cf_count se_cf_count prop
gen cf_count_i_d=rnormal(cf_count , se_cf_count) // generate random draw d from mean SE estimated from poisson ITS for each SIMD group i
egen sum_cf_count_i_d=sum(cf_count_i_d) // sum random draws d of all groups i
gen cf_prop_i_d=cf_count_i_d/sum_cf_count_i_d // create counterfactual proportion for each group i based on draw d
gen propdiff_i_d=prop- cf_prop_i_d // get m_i_d which is the difference in proportion between observed and counterfactual from draw d
keep mom_edu_comp propdiff_i_d
gen draw=`d'

tempfile draw_`d'
save `draw_`d'',replace
}

*merge data
use `draw_1' ,clear
forval d=2/10000 {
	append using `draw_`d''
}

*generate lower and upper bound of difference in proportion
_pctile propdiff_i_d if mom_edu_comp==1, percentiles(2.5) 
return list
gen propdiff_lb=r(r1) if mom_edu_comp==1
_pctile propdiff_i_d if mom_edu_comp==1, percentiles(97.5) 
return list
gen propdiff_ub=r(r1) if mom_edu_comp==1

forval i=2/4 {
_pctile propdiff_i_d if mom_edu_comp==`i', percentiles(2.5) 
return list
replace propdiff_lb=r(r1) if mom_edu_comp==`i'
_pctile propdiff_i_d if mom_edu_comp==`i', percentiles(97.5) 
return list
replace propdiff_ub=r(r1) if mom_edu_comp==`i'
}

collapse propdiff_lb propdiff_ub, by(mom_edu_comp)
save "$dta/US_prop_uncertainty", replace
use "$dta/US_cf_estimate", clear
merge 1:1 mom_edu_comp using "$dta/US_prop_uncertainty", nogen
gen country="United States"
save "$dta/US_comp_diff", replace

**# Bookmark #7

*************************** SPAIN ******************************
*************************** SPAIN ******************************
*************************** SPAIN ******************************

clear all
use "$dta/ESP_ts", clear
preserve // get numbers for table later
collapse (sum) n_births if loco==1, by(mom_edu_comp)
egen total_births=sum(n_births)
gen prop= n_births/total_births
save "$dta/ESP_obs.dta" ,replace
restore 

****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=1/4 {
use "$dta/ESP_ts.dta", clear
keep if mom_edu_comp==`i'
poisson n_births i.loco c.mdate c.mdate#c.mdate i.month_nr i.d_16_17 , irr
count if loco==1 & e(sample)==1
scalar r=r(N) 
di r

margins, ///
at(loco=0 ) ///
exp(predict(n)*r) ///
subpop(if loco==1 ) ///
saving("$dta\cf_count_`i'.dta", replace)

preserve 
use "$dta/cf_count_`i'.dta", clear
rename _margin cf_count
rename _ci_lb cf_count_lb 
rename _ci_ub cf_count_ub
rename _se_margin se_cf_count
gen mom_edu_comp=`i'
keep mom_edu_comp cf_count se_cf_count cf_count_lb cf_count_ub
save "$dta/cf_estimate_`i'.dta", replace
restore


margins, ///
at(loco=0) ///
at((asobs) _all ) ///
exp(predict(n)*r) ///
subpop(if loco==1) ///
pwcompare ///
saving("$dta\countdiff_`i'.dta", replace)

preserve 
use "$dta/countdiff_`i'.dta", clear
rename _margin countdiff
rename _ci_lb countdiff_lb
rename _ci_ub countdiff_ub
gen mom_edu_comp=`i'
keep mom_edu_comp countdiff countdiff_lb countdiff_ub
save "$dta/countdiff_estimate_`i'.dta", replace
restore

}


use "$dta/cf_estimate_1", clear
forval i=2/4 {
	append using "$dta/cf_estimate_`i'"
}


merge 1:1  mom_edu_comp using "$dta/ESP_obs.dta", nogen
order mom_edu_comp n_births cf_count se_cf_count 
egen total_cf_count=sum(cf_count)
gen cf_prop=cf_count/total_cf_count
gen propdiff=prop-cf_prop
save "$dta/ESP_cf_estimate.dta", replace


use "$dta/countdiff_estimate_1", clear
forval i=2/4 {
	append using "$dta/countdiff_estimate_`i'"
}

merge 1:1  mom_edu_comp using "$dta/ESP_cf_estimate.dta", nogen
order mom_edu_comp n_births cf_count se_cf_count 
save "$dta/ESP_cf_estimate.dta", replace

set seed 123456789
forval d=1/10000 {
use "$dta/ESP_cf_estimate.dta", clear
keep mom_edu_comp cf_count se_cf_count prop
gen cf_count_i_d=rnormal(cf_count , se_cf_count) // generate random draw d from mean SE estimated from poisson ITS for each SIMD group i
egen sum_cf_count_i_d=sum(cf_count_i_d) // sum random draws d of all groups i
gen cf_prop_i_d=cf_count_i_d/sum_cf_count_i_d // create counterfactual proportion for each group i based on draw d
gen propdiff_i_d=prop- cf_prop_i_d // get m_i_d which is the difference in proportion between observed and counterfactual from draw d
keep mom_edu_comp propdiff_i_d
gen draw=`d'

tempfile draw_`d'
save `draw_`d'',replace
}

*merge data
use `draw_1' ,clear
forval d=2/10000 {
	append using `draw_`d''
}

*generate lower and upper bound of difference in proportion
_pctile propdiff_i_d if mom_edu_comp==1, percentiles(2.5) 
return list
gen propdiff_lb=r(r1) if mom_edu_comp==1
_pctile propdiff_i_d if mom_edu_comp==1, percentiles(97.5) 
return list
gen propdiff_ub=r(r1) if mom_edu_comp==1

forval i=2/4 {
_pctile propdiff_i_d if mom_edu_comp==`i', percentiles(2.5) 
return list
replace propdiff_lb=r(r1) if mom_edu_comp==`i'
_pctile propdiff_i_d if mom_edu_comp==`i', percentiles(97.5) 
return list
replace propdiff_ub=r(r1) if mom_edu_comp==`i'
}

collapse propdiff_lb propdiff_ub, by(mom_edu_comp)
save "$dta/ESP_prop_uncertainty", replace
use "$dta/ESP_cf_estimate", clear
merge 1:1 mom_edu_comp using "$dta/ESP_prop_uncertainty", nogen
gen country="Spain"
save "$dta/ESP_comp_diff", replace

**# Bookmark #8


*************************** COLOMBIA COLOMBIA COLOMBIA  ******************************
*************************** COLOMBIA COLOMBIA COLOMBIA  ******************************
*************************** COLOMBIA COLOMBIA COLOMBIA  ******************************

clear all
use "$dta/COL_ts", clear
preserve // get numbers for table later
collapse (sum) n_births if loco==1, by(mom_edu_comp)
egen total_births=sum(n_births)
gen prop= n_births/total_births
save "$dta/COL_obs.dta" ,replace
restore 

****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=1/4 {
use "$dta/COL_ts.dta", clear
keep if mom_edu_comp==`i'
poisson n_births i.loco c.mdate c.mdate#c.mdate i.month_nr i.zika, irr
count if loco==1 & e(sample)==1
scalar r=r(N) 
di r

margins, ///
at(loco=0 ) ///
exp(predict(n)*r) ///
subpop(if loco==1 ) ///
saving("$dta\cf_count_`i'.dta", replace)

preserve 
use "$dta/cf_count_`i'.dta", clear
rename _margin cf_count
rename _ci_lb cf_count_lb 
rename _ci_ub cf_count_ub
rename _se_margin se_cf_count
gen mom_edu_comp=`i'
keep mom_edu_comp cf_count se_cf_count cf_count_lb cf_count_ub
save "$dta/cf_estimate_`i'.dta", replace
restore


margins, ///
at(loco=0) ///
at((asobs) _all ) ///
exp(predict(n)*r) ///
subpop(if loco==1) ///
pwcompare ///
saving("$dta\countdiff_`i'.dta", replace)

preserve 
use "$dta/countdiff_`i'.dta", clear
rename _margin countdiff
rename _ci_lb countdiff_lb
rename _ci_ub countdiff_ub
gen mom_edu_comp=`i'
keep mom_edu_comp countdiff countdiff_lb countdiff_ub
save "$dta/countdiff_estimate_`i'.dta", replace
restore

}


use "$dta/cf_estimate_1", clear
forval i=2/4 {
	append using "$dta/cf_estimate_`i'"
}


merge 1:1  mom_edu_comp using "$dta/COL_obs.dta", nogen
order mom_edu_comp n_births cf_count se_cf_count 
egen total_cf_count=sum(cf_count)
gen cf_prop=cf_count/total_cf_count
gen propdiff=prop-cf_prop
save "$dta/COL_cf_estimate.dta", replace


use "$dta/countdiff_estimate_1", clear
forval i=2/4 {
	append using "$dta/countdiff_estimate_`i'"
}

merge 1:1  mom_edu_comp using "$dta/COL_cf_estimate.dta", nogen
order mom_edu_comp n_births cf_count se_cf_count 
save "$dta/COL_cf_estimate.dta", replace

*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
set seed 123456789
forval d=1/10000 {
use "$dta/COL_cf_estimate.dta", clear
keep mom_edu_comp cf_count se_cf_count prop
gen cf_count_i_d=rnormal(cf_count , se_cf_count) // generate random draw d from mean SE estimated from poisson ITS for each SIMD group i
egen sum_cf_count_i_d=sum(cf_count_i_d) // sum random draws d of all groups i
gen cf_prop_i_d=cf_count_i_d/sum_cf_count_i_d // create counterfactual proportion for each group i based on draw d
gen propdiff_i_d=prop- cf_prop_i_d // get m_i_d which is the difference in proportion between observed and counterfactual from draw d
keep mom_edu_comp propdiff_i_d
gen draw=`d'

tempfile draw_`d'
save `draw_`d'',replace
}

*merge data
use `draw_1' ,clear
forval d=2/10000 {
	append using `draw_`d''
}

*generate lower and upper bound of difference in proportion
_pctile propdiff_i_d if mom_edu_comp==1, percentiles(2.5) 
return list
gen propdiff_lb=r(r1) if mom_edu_comp==1
_pctile propdiff_i_d if mom_edu_comp==1, percentiles(97.5) 
return list
gen propdiff_ub=r(r1) if mom_edu_comp==1

forval i=2/4 {
_pctile propdiff_i_d if mom_edu_comp==`i', percentiles(2.5) 
return list
replace propdiff_lb=r(r1) if mom_edu_comp==`i'
_pctile propdiff_i_d if mom_edu_comp==`i', percentiles(97.5) 
return list
replace propdiff_ub=r(r1) if mom_edu_comp==`i'
}

collapse propdiff_lb propdiff_ub, by(mom_edu_comp)
save "$dta/COL_prop_uncertainty", replace
use "$dta/COL_cf_estimate", clear
merge 1:1 mom_edu_comp using "$dta/COL_prop_uncertainty", nogen
gen country="Colombia"
save "$dta/COL_comp_diff", replace


**# Bookmark #10


*************************** MEXICO MEXICO MEXICO  ******************************
*************************** MEXICO MEXICO MEXICO  ******************************
*************************** MEXICO MEXICO MEXICO  ******************************

*Mexico does not have post-secondary or teritary in data. 
*we use elementary vs upper secondary + other

clear all
use "$dta/MEX_ts", clear
preserve // get numbers for table later
collapse (sum) n_births if loco==1, by(mom_edu_comp)
egen total_births=sum(n_births)
gen prop= n_births/total_births
save "$dta/MEX_obs.dta" ,replace
restore 

****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=1/4 {
use "$dta/MEX_ts.dta", clear
keep if mom_edu_comp==`i'
poisson n_births i.loco c.bdate_w c.bdate_w#c.bdate_w i.bweek i.zika , irr
count if loco==1 & e(sample)==1
scalar r=r(N) 
di r

margins, ///
at(loco=0 ) ///
exp(predict(n)*r) ///
subpop(if loco==1 ) ///
saving("$dta\cf_count_`i'.dta", replace)

preserve 
use "$dta/cf_count_`i'.dta", clear
rename _margin cf_count
rename _ci_lb cf_count_lb 
rename _ci_ub cf_count_ub
rename _se_margin se_cf_count
gen mom_edu_comp=`i'
keep mom_edu_comp cf_count se_cf_count cf_count_lb cf_count_ub
save "$dta/cf_estimate_`i'.dta", replace
restore


margins, ///
at(loco=0) ///
at((asobs) _all ) ///
exp(predict(n)*r) ///
subpop(if loco==1) ///
pwcompare ///
saving("$dta\countdiff_`i'.dta", replace)

preserve 
use "$dta/countdiff_`i'.dta", clear
rename _margin countdiff
rename _ci_lb countdiff_lb
rename _ci_ub countdiff_ub
gen mom_edu_comp=`i'
keep mom_edu_comp countdiff countdiff_lb countdiff_ub
save "$dta/countdiff_estimate_`i'.dta", replace
restore

}


use "$dta/cf_estimate_1", clear
forval i=2/4 {
	append using "$dta/cf_estimate_`i'"
}


merge 1:1  mom_edu_comp using "$dta/MEX_obs.dta", nogen
order mom_edu_comp n_births cf_count se_cf_count 
egen total_cf_count=sum(cf_count)
gen cf_prop=cf_count/total_cf_count
gen propdiff=prop-cf_prop
save "$dta/MEX_cf_estimate.dta", replace


use "$dta/countdiff_estimate_1", clear
forval i=2/4 {
	append using "$dta/countdiff_estimate_`i'"
}

merge 1:1  mom_edu_comp using "$dta/MEX_cf_estimate.dta", nogen
order mom_edu_comp n_births cf_count se_cf_count 
save "$dta/MEX_cf_estimate.dta", replace


*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
clear all
set seed 123456789
forval d=1/10000 {
use "$dta/MEX_cf_estimate.dta", clear
keep mom_edu_comp cf_count se_cf_count prop
gen cf_count_i_d=rnormal(cf_count , se_cf_count) // generate random draw d from mean SE estimated from poisson ITS for each SIMD group i
egen sum_cf_count_i_d=sum(cf_count_i_d) // sum random draws d of all groups i
gen cf_prop_i_d=cf_count_i_d/sum_cf_count_i_d // create counterfactual proportion for each group i based on draw d
gen propdiff_i_d=prop- cf_prop_i_d // get m_i_d which is the difference in proportion between observed and counterfactual from draw d
keep mom_edu_comp propdiff_i_d
gen draw=`d'

tempfile draw_`d'
save `draw_`d'',replace
}

*merge data
use `draw_1' ,clear
forval d=2/10000 {
	append using `draw_`d''
}

*generate lower and upper bound of difference in proportion
_pctile propdiff_i_d if mom_edu_comp==1, percentiles(2.5) 
return list
gen propdiff_lb=r(r1) if mom_edu_comp==1
_pctile propdiff_i_d if mom_edu_comp==1, percentiles(97.5) 
return list
gen propdiff_ub=r(r1) if mom_edu_comp==1

forval i=2/4 {
_pctile propdiff_i_d if mom_edu_comp==`i', percentiles(2.5) 
return list
replace propdiff_lb=r(r1) if mom_edu_comp==`i'
_pctile propdiff_i_d if mom_edu_comp==`i', percentiles(97.5) 
return list
replace propdiff_ub=r(r1) if mom_edu_comp==`i'
}

collapse propdiff_lb propdiff_ub, by(mom_edu_comp)
save "$dta/MEX_prop_uncertainty", replace
use "$dta/MEX_cf_estimate", clear
merge 1:1 mom_edu_comp using "$dta/MEX_prop_uncertainty", nogen
gen country="Mexico"
save "$dta/MEX_comp_diff", replace

**# Bookmark #12

******************** SCOTLAND *************************
******************** SCOTLAND *************************
******************** SCOTLAND *************************
******************** SCOTLAND *************************
clear all

use "$dta/Scot_ts",clear
*label define deplab 1 "Q1 - most deprived" 2 "Q2" 3 "Q3" 4 "Q4" 5 "Q5 - least deprived" 6 "Unknown"
*label values area_deprivation deplab
*save "$dta/Scot_ts",replace
preserve // get numbers for table later
collapse (sum) n_births if loco==1, by(area_deprivation)
egen total_births=sum(n_births)
gen prop= n_births/total_births
save "$dta/Scot_obs.dta" ,replace
restore 



****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=1/6 {
use "$dta/Scot_ts.dta", clear
keep if area_deprivation==`i'
poisson n_births i.loco c.mdate c.mdate#c.mdate i.month_nr , irr
count if loco==1 & e(sample)==1
scalar r=r(N) 
di r

margins, ///
at(loco=0 ) ///
exp(predict(n)*r) ///
subpop(if loco==1 ) ///
saving("$dta\cf_count_`i'.dta", replace)

preserve 
use "$dta/cf_count_`i'.dta", clear
rename _margin cf_count
rename _ci_lb cf_count_lb 
rename _ci_ub cf_count_ub
rename _se_margin se_cf_count
gen area_deprivation=`i'
keep area_deprivation cf_count se_cf_count cf_count_lb cf_count_ub
save "$dta/cf_estimate_`i'.dta", replace
restore


margins, ///
at(loco=0) ///
at((asobs) _all ) ///
exp(predict(n)*r) ///
subpop(if loco==1) ///
pwcompare ///
saving("$dta\countdiff_`i'.dta", replace)

preserve 
use "$dta/countdiff_`i'.dta", clear
rename _margin countdiff
rename _ci_lb countdiff_lb
rename _ci_ub countdiff_ub
gen area_deprivation=`i'
keep area_deprivation countdiff countdiff_lb countdiff_ub
save "$dta/countdiff_estimate_`i'.dta", replace
restore

}


use "$dta/cf_estimate_1", clear
forval i=2/6 {
	append using "$dta/cf_estimate_`i'"
}


merge 1:1  area_deprivation using "$dta/Scot_obs.dta", nogen
order area_deprivation n_births cf_count se_cf_count 
egen total_cf_count=sum(cf_count)
gen cf_prop=cf_count/total_cf_count
gen propdiff=prop-cf_prop
save "$dta/Scot_cf_estimate.dta", replace


use "$dta/countdiff_estimate_1", clear
forval i=2/6 {
	append using "$dta/countdiff_estimate_`i'"
}

merge 1:1  area_deprivation using "$dta/Scot_cf_estimate.dta", nogen
order area_deprivation n_births cf_count se_cf_count 
save "$dta/Scot_cf_estimate.dta", replace

*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
set seed 123456789
forval d=1/10000 {
use "$dta/Scot_cf_estimate.dta", clear
keep area_deprivation cf_count se_cf_count prop
gen cf_count_i_d=rnormal(cf_count , se_cf_count) // generate random draw d from mean SE estimated from poisson ITS for each SIMD group i
egen sum_cf_count_i_d=sum(cf_count_i_d) // sum random draws d of all groups i
gen cf_prop_i_d=cf_count_i_d/sum_cf_count_i_d // create counterfactual proportion for each group i based on draw d
gen propdiff_i_d=prop- cf_prop_i_d // get m_i_d which is the difference in proportion between observed and counterfactual from draw d
keep area_deprivation propdiff_i_d
gen draw=`d'

tempfile draw_`d'
save `draw_`d'',replace
}

*merge data
use `draw_1' ,clear
forval d=2/10000 {
	append using `draw_`d''
}

*generate lower and upper bound of difference in proportion
_pctile propdiff_i_d if area_deprivation==1, percentiles(2.5) 
return list
gen propdiff_lb=r(r1) if area_deprivation==1
_pctile propdiff_i_d if area_deprivation==1, percentiles(97.5) 
return list
gen propdiff_ub=r(r1) if area_deprivation==1

forval i=2/6 {
_pctile propdiff_i_d if area_deprivation==`i', percentiles(2.5) 
return list
replace propdiff_lb=r(r1) if area_deprivation==`i'
_pctile propdiff_i_d if area_deprivation==`i', percentiles(97.5) 
return list
replace propdiff_ub=r(r1) if area_deprivation==`i'
}

collapse propdiff_lb propdiff_ub, by(area_deprivation)
save "$dta/Scot_prop_uncertainty", replace
use "$dta/Scot_cf_estimate", clear
merge 1:1 area_deprivation using "$dta/Scot_prop_uncertainty", nogen
gen country="Scotland"
save "$dta/Scot_comp_diff", replace


**# Bookmark #14

********* ENGLAND**************
********* ENGLAND**************
********* ENGLAND**************
clear all
use "$dta/ENG_ts",clear
*rename IMD area_deprivation // uniform labelling
*label define deplab 1 "Q1 - most deprived" 2 "Q2" 3 "Q3" 4 "Q4" 5 "Q5 - least deprived" 6 "Unknown"
*label values area_deprivation deplab
preserve // get numbers for table later
collapse (sum) n_births if loco==1, by(area_deprivation)
egen total_births=sum(n_births)
gen prop= n_births/total_births
save "$dta/ENG_obs.dta" ,replace
restore 
*save "$dta/ENG_ts", replace

****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=1/5 {
use "$dta/ENG_ts.dta", clear
keep if area_deprivation==`i'
poisson n_births i.loco c.mdate c.mdate#c.mdate i.month_nr , irr
count if loco==1 & e(sample)==1
scalar r=r(N) 
di r

margins, ///
at(loco=0 ) ///
exp(predict(n)*r) ///
subpop(if loco==1 ) ///
saving("$dta\cf_count_`i'.dta", replace)

preserve 
use "$dta/cf_count_`i'.dta", clear
rename _margin cf_count
rename _ci_lb cf_count_lb 
rename _ci_ub cf_count_ub
rename _se_margin se_cf_count
gen area_deprivation=`i'
keep area_deprivation cf_count se_cf_count cf_count_lb cf_count_ub
save "$dta/cf_estimate_`i'.dta", replace
restore


margins, ///
at(loco=0) ///
at((asobs) _all ) ///
exp(predict(n)*r) ///
subpop(if loco==1) ///
pwcompare ///
saving("$dta\countdiff_`i'.dta", replace)

preserve 
use "$dta/countdiff_`i'.dta", clear
rename _margin countdiff
rename _ci_lb countdiff_lb
rename _ci_ub countdiff_ub
gen area_deprivation=`i'
keep area_deprivation countdiff countdiff_lb countdiff_ub
save "$dta/countdiff_estimate_`i'.dta", replace
restore

}


use "$dta/cf_estimate_1", clear
forval i=2/5 {
	append using "$dta/cf_estimate_`i'"
}


merge 1:1  area_deprivation using "$dta/ENG_obs.dta", nogen
order area_deprivation n_births cf_count se_cf_count 
egen total_cf_count=sum(cf_count)
gen cf_prop=cf_count/total_cf_count
gen propdiff=prop-cf_prop
save "$dta/ENG_cf_estimate.dta", replace


use "$dta/countdiff_estimate_1", clear
forval i=2/5 {
	append using "$dta/countdiff_estimate_`i'"
}

merge 1:1  area_deprivation using "$dta/ENG_cf_estimate.dta", nogen
order area_deprivation n_births cf_count se_cf_count 
save "$dta/ENG_cf_estimate.dta", replace

*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
set seed 123456789
forval d=1/10000 {
use "$dta/ENG_cf_estimate.dta", clear
keep area_deprivation cf_count se_cf_count prop
gen cf_count_i_d=rnormal(cf_count , se_cf_count) // generate random draw d from mean SE estimated from poisson ITS for each SIMD group i
egen sum_cf_count_i_d=sum(cf_count_i_d) // sum random draws d of all groups i
gen cf_prop_i_d=cf_count_i_d/sum_cf_count_i_d // create counterfactual proportion for each group i based on draw d
gen propdiff_i_d=prop- cf_prop_i_d // get m_i_d which is the difference in proportion between observed and counterfactual from draw d
keep area_deprivation propdiff_i_d
gen draw=`d'

tempfile draw_`d'
save `draw_`d'',replace
}

*merge data
use `draw_1' ,clear
forval d=2/10000 {
	append using `draw_`d''
}

*generate lower and upper bound of difference in proportion
_pctile propdiff_i_d if area_deprivation==1, percentiles(2.5) 
return list
gen propdiff_lb=r(r1) if area_deprivation==1
_pctile propdiff_i_d if area_deprivation==1, percentiles(97.5) 
return list
gen propdiff_ub=r(r1) if area_deprivation==1

forval i=2/5 {
_pctile propdiff_i_d if area_deprivation==`i', percentiles(2.5) 
return list
replace propdiff_lb=r(r1) if area_deprivation==`i'
_pctile propdiff_i_d if area_deprivation==`i', percentiles(97.5) 
return list
replace propdiff_ub=r(r1) if area_deprivation==`i'
}

collapse propdiff_lb propdiff_ub, by(area_deprivation)
save "$dta/ENG_prop_uncertainty", replace
use "$dta/ENG_cf_estimate", clear
merge 1:1 area_deprivation using "$dta/ENG_prop_uncertainty", nogen
gen country="England"
save "$dta/ENG_comp_diff", replace

**# Bookmark #15

******************** WALES WALES WALES *************************
******************** WALES WALES WALES *************************
******************** WALES WALES WALES *************************
******************** WALES WALES WALES *************************
clear all
use "$dta/WAL_ts",clear
/*rename IMD area_deprivation // uniform labelling
label define deplab 1 "Q1 - most deprived" 2 "Q2" 3 "Q3" 4 "Q4" 5 "Q5 - least deprived" 6 "Unknown"
label values area_deprivation deplab*/
preserve // get numbers for table later
collapse (sum) n_births if loco==1, by(area_deprivation)
egen total_births=sum(n_births)
gen prop= n_births/total_births
save "$dta/WAL_obs.dta" ,replace
restore 
save "$dta/WAL_ts.dta" ,replace

****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=1/5 {
use "$dta/WAL_ts.dta", clear
keep if area_deprivation==`i'
poisson n_births i.loco c.mdate c.mdate#c.mdate i.month_nr , irr
count if loco==1 & e(sample)==1
scalar r=r(N) 
di r

margins, ///
at(loco=0 ) ///
exp(predict(n)*r) ///
subpop(if loco==1 ) ///
saving("$dta\cf_count_`i'.dta", replace)

preserve 
use "$dta/cf_count_`i'.dta", clear
rename _margin cf_count
rename _ci_lb cf_count_lb 
rename _ci_ub cf_count_ub
rename _se_margin se_cf_count
gen area_deprivation=`i'
keep area_deprivation cf_count se_cf_count cf_count_lb cf_count_ub
save "$dta/cf_estimate_`i'.dta", replace
restore

margins, ///
at(loco=0) ///
at((asobs) _all ) ///
exp(predict(n)*r) ///
subpop(if loco==1) ///
pwcompare ///
saving("$dta\countdiff_`i'.dta", replace)

preserve 
use "$dta/countdiff_`i'.dta", clear
rename _margin countdiff
rename _ci_lb countdiff_lb
rename _ci_ub countdiff_ub
gen area_deprivation=`i'
keep area_deprivation countdiff countdiff_lb countdiff_ub
save "$dta/countdiff_estimate_`i'.dta", replace
restore

}

use "$dta/cf_estimate_1", clear
forval i=2/5 {
	append using "$dta/cf_estimate_`i'"
}

merge 1:1  area_deprivation using "$dta/WAL_obs.dta", nogen
order area_deprivation n_births cf_count se_cf_count 
egen total_cf_count=sum(cf_count)
gen cf_prop=cf_count/total_cf_count
gen propdiff=prop-cf_prop
save "$dta/WAL_cf_estimate.dta", replace

use "$dta/countdiff_estimate_1", clear
forval i=2/5 {
	append using "$dta/countdiff_estimate_`i'"
}
merge 1:1  area_deprivation using "$dta/WAL_cf_estimate.dta", nogen
order area_deprivation n_births cf_count se_cf_count 
save "$dta/WAL_cf_estimate.dta", replace

*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
set seed 123456789
forval d=1/10000 {
use "$dta/WAL_cf_estimate.dta", clear
keep area_deprivation cf_count se_cf_count prop
gen cf_count_i_d=rnormal(cf_count , se_cf_count) // generate random draw d from mean SE estimated from poisson ITS for each SIMD group i
egen sum_cf_count_i_d=sum(cf_count_i_d) // sum random draws d of all groups i
gen cf_prop_i_d=cf_count_i_d/sum_cf_count_i_d // create counterfactual proportion for each group i based on draw d
gen propdiff_i_d=prop- cf_prop_i_d // get m_i_d which is the difference in proportion between observed and counterfactual from draw d
keep area_deprivation propdiff_i_d
gen draw=`d'

tempfile draw_`d'
save `draw_`d'',replace
}

*merge data
use `draw_1' ,clear
forval d=2/10000 {
	append using `draw_`d''
}

*generate lower and upper bound of difference in proportion
_pctile propdiff_i_d if area_deprivation==1, percentiles(2.5) 
return list
gen propdiff_lb=r(r1) if area_deprivation==1
_pctile propdiff_i_d if area_deprivation==1, percentiles(97.5) 
return list
gen propdiff_ub=r(r1) if area_deprivation==1

forval i=2/5 {
_pctile propdiff_i_d if area_deprivation==`i', percentiles(2.5) 
return list
replace propdiff_lb=r(r1) if area_deprivation==`i'
_pctile propdiff_i_d if area_deprivation==`i', percentiles(97.5) 
return list
replace propdiff_ub=r(r1) if area_deprivation==`i'
}

collapse propdiff_lb propdiff_ub, by(area_deprivation)
save "$dta/WAL_prop_uncertainty", replace
use "$dta/WAL_cf_estimate", clear
merge 1:1 area_deprivation using "$dta/WAL_prop_uncertainty", nogen
gen country="Wales"
save "$dta/Wal_comp_diff", replace

**# Bookmark #16

**************** BRAZIL BRAZIL BRAZIL ***********************
**************** BRAZIL BRAZIL BRAZIL ***********************
**************** BRAZIL BRAZIL BRAZIL ***********************
**************** BRAZIL BRAZIL BRAZIL ***********************
clear all
use "$dta/BRA_ts",clear
/*
rename loco_w loco
rename bpi_quint area_deprivation // uniform labelling
label define deplab 1 "Q1 - most deprived" 2 "Q2" 3 "Q3" 4 "Q4" 5 "Q5 - least deprived" 6 "Unknown"
label values area_deprivation deplab*/
preserve // get numbers for table later
collapse (sum) n_births if loco==1, by(area_deprivation)
egen total_births=sum(n_births)
gen prop= n_births/total_births
save "$dta/BRA_obs.dta" ,replace
restore 

save "$dta/BRA_ts.dta" ,replace


****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=1/6 {
use "$dta/BRA_ts.dta", clear
keep if area_deprivation==`i'
poisson n_births i.loco c.bdate_w c.bdate_w#c.bdate_w i.bweek i.zika , irr
count if loco==1 & e(sample)==1
scalar r=r(N) 
di r

margins, ///
at(loco=0 ) ///
exp(predict(n)*r) ///
subpop(if loco==1 ) ///
saving("$dta\cf_count_`i'.dta", replace)

preserve 
use "$dta/cf_count_`i'.dta", clear
rename _margin cf_count
rename _ci_lb cf_count_lb 
rename _ci_ub cf_count_ub
rename _se_margin se_cf_count
gen area_deprivation=`i'
keep area_deprivation cf_count se_cf_count cf_count_lb cf_count_ub
save "$dta/cf_estimate_`i'.dta", replace
restore


margins, ///
at(loco=0) ///
at((asobs) _all ) ///
exp(predict(n)*r) ///
subpop(if loco==1) ///
pwcompare ///
saving("$dta\countdiff_`i'.dta", replace)

preserve 
use "$dta/countdiff_`i'.dta", clear
rename _margin countdiff
rename _ci_lb countdiff_lb
rename _ci_ub countdiff_ub
gen area_deprivation=`i'
keep area_deprivation countdiff countdiff_lb countdiff_ub
save "$dta/countdiff_estimate_`i'.dta", replace
restore

}


use "$dta/cf_estimate_1", clear
forval i=2/6 {
	append using "$dta/cf_estimate_`i'"
}


merge 1:1  area_deprivation using "$dta/BRA_obs.dta", nogen
order area_deprivation n_births cf_count se_cf_count 
egen total_cf_count=sum(cf_count)
gen cf_prop=cf_count/total_cf_count
gen propdiff=prop-cf_prop
save "$dta/BRA_cf_estimate.dta", replace


use "$dta/countdiff_estimate_1", clear
forval i=2/6 {
	append using "$dta/countdiff_estimate_`i'"
}

merge 1:1  area_deprivation using "$dta/BRA_cf_estimate.dta", nogen
order area_deprivation n_births cf_count se_cf_count 
save "$dta/BRA_cf_estimate.dta", replace

*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
set seed 123456789
forval d=1/10000 {
use "$dta/BRA_cf_estimate.dta", clear
keep area_deprivation cf_count se_cf_count prop
gen cf_count_i_d=rnormal(cf_count , se_cf_count) // generate random draw d from mean SE estimated from poisson ITS for each SIMD group i
egen sum_cf_count_i_d=sum(cf_count_i_d) // sum random draws d of all groups i
gen cf_prop_i_d=cf_count_i_d/sum_cf_count_i_d // create counterfactual proportion for each group i based on draw d
gen propdiff_i_d=prop- cf_prop_i_d // get m_i_d which is the difference in proportion between observed and counterfactual from draw d
keep area_deprivation propdiff_i_d
gen draw=`d'

tempfile draw_`d'
save `draw_`d'',replace
}

*merge data
use `draw_1' ,clear
forval d=2/10000 {
	append using `draw_`d''
}

*generate lower and upper bound of difference in proportion
_pctile propdiff_i_d if area_deprivation==1, percentiles(2.5) 
return list
gen propdiff_lb=r(r1) if area_deprivation==1
_pctile propdiff_i_d if area_deprivation==1, percentiles(97.5) 
return list
gen propdiff_ub=r(r1) if area_deprivation==1

forval i=2/6 {
_pctile propdiff_i_d if area_deprivation==`i', percentiles(2.5) 
return list
replace propdiff_lb=r(r1) if area_deprivation==`i'
_pctile propdiff_i_d if area_deprivation==`i', percentiles(97.5) 
return list
replace propdiff_ub=r(r1) if area_deprivation==`i'
}

collapse propdiff_lb propdiff_ub, by(area_deprivation)
save "$dta/BRA_prop_uncertainty", replace
use "$dta/BRA_cf_estimate", clear
merge 1:1 area_deprivation using "$dta/BRA_prop_uncertainty", nogen
gen country="Brazil"
save "$dta/BRA_comp_diff", replace

**# Bookmark #18

********** ECUADOR************************
********** ECUADOR************************
********** ECUADOR************************
clear all
use "$dta/ECU_ts",clear
preserve // get numbers for table later
collapse (sum) n_births if loco==1, by(area_deprivation)
egen total_births=sum(n_births)
gen prop= n_births/total_births
save "$dta/ECU_obs.dta" ,replace
restore 
save "$dta/ECU_ts.dta" ,replace

****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=1/5 {
use "$dta/ECU_ts.dta", clear
keep if area_deprivation==`i'
poisson n_births i.loco c.bdate_w c.bdate_w#c.bdate_w i.bweek i.zika , irr
count if loco==1 & e(sample)==1
scalar r=r(N) 
di r

margins, ///
at(loco=0 ) ///
exp(predict(n)*r) ///
subpop(if loco==1 ) ///
saving("$dta\cf_count_`i'.dta", replace)

preserve 
use "$dta/cf_count_`i'.dta", clear
rename _margin cf_count
rename _ci_lb cf_count_lb 
rename _ci_ub cf_count_ub
rename _se_margin se_cf_count
gen area_deprivation=`i'
keep area_deprivation cf_count se_cf_count cf_count_lb cf_count_ub
save "$dta/cf_estimate_`i'.dta", replace
restore


margins, ///
at(loco=0) ///
at((asobs) _all ) ///
exp(predict(n)*r) ///
subpop(if loco==1) ///
pwcompare ///
saving("$dta\countdiff_`i'.dta", replace)

preserve 
use "$dta/countdiff_`i'.dta", clear
rename _margin countdiff
rename _ci_lb countdiff_lb
rename _ci_ub countdiff_ub
gen area_deprivation=`i'
keep area_deprivation countdiff countdiff_lb countdiff_ub
save "$dta/countdiff_estimate_`i'.dta", replace
restore

}


use "$dta/cf_estimate_1", clear
forval i=2/5 {
	append using "$dta/cf_estimate_`i'"
}


merge 1:1  area_deprivation using "$dta/ECU_obs.dta", nogen
order area_deprivation n_births cf_count se_cf_count 
egen total_cf_count=sum(cf_count)
gen cf_prop=cf_count/total_cf_count
gen propdiff=prop-cf_prop
save "$dta/ECU_cf_estimate.dta", replace


use "$dta/countdiff_estimate_1", clear
forval i=2/5 {
	append using "$dta/countdiff_estimate_`i'"
}

merge 1:1  area_deprivation using "$dta/ECU_cf_estimate.dta", nogen
order area_deprivation n_births cf_count se_cf_count 
save "$dta/ECU_cf_estimate.dta", replace

*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
set seed 123456789
forval d=1/10000 {
use "$dta/ECU_cf_estimate.dta", clear
keep area_deprivation cf_count se_cf_count prop
gen cf_count_i_d=rnormal(cf_count , se_cf_count) // generate random draw d from mean SE estimated from poisson ITS for each SIMD group i
egen sum_cf_count_i_d=sum(cf_count_i_d) // sum random draws d of all groups i
gen cf_prop_i_d=cf_count_i_d/sum_cf_count_i_d // create counterfactual proportion for each group i based on draw d
gen propdiff_i_d=prop- cf_prop_i_d // get m_i_d which is the difference in proportion between observed and counterfactual from draw d
keep area_deprivation propdiff_i_d
gen draw=`d'

tempfile draw_`d'
save `draw_`d'',replace
}

*merge data
use `draw_1' ,clear
forval d=2/10000 {
	append using `draw_`d''
}

*generate lower and upper bound of difference in proportion
_pctile propdiff_i_d if area_deprivation==1, percentiles(2.5) 
return list
gen propdiff_lb=r(r1) if area_deprivation==1
_pctile propdiff_i_d if area_deprivation==1, percentiles(97.5) 
return list
gen propdiff_ub=r(r1) if area_deprivation==1

forval i=2/5 {
_pctile propdiff_i_d if area_deprivation==`i', percentiles(2.5) 
return list
replace propdiff_lb=r(r1) if area_deprivation==`i'
_pctile propdiff_i_d if area_deprivation==`i', percentiles(97.5) 
return list
replace propdiff_ub=r(r1) if area_deprivation==`i'
}

collapse propdiff_lb propdiff_ub, by(area_deprivation)
save "$dta/ECU_prop_uncertainty", replace
use "$dta/ECU_cf_estimate", clear
merge 1:1 area_deprivation using "$dta/ECU_prop_uncertainty", nogen
gen country="Ecuador"
save "$dta/ECU_comp_diff", replace

**# Bookmark #20

*************************** FINLAND FINLAND FINLAND ******************************
*************************** FINLAND FINLAND FINLAND ******************************
*************************** FINLAND FINLAND FINLAND ******************************
clear all
use "$dta/FI_ts", clear
/*rename quint_equi_kturaha hh_inc // uniform labelling
label define inclab 1 "Q1 - lowest income" 2 "Q2" 3 "Q3" 4 "Q4" 5 "Q5 - highest income" 6 "Unknown"
label values hh_inc inclab
replace n_births=2 if n_births==. // assign 2 for surpressed counts 3 or smaller*/
preserve // get numbers for table later
collapse (sum) n_births if loco==1, by(hh_inc)
egen total_births=sum(n_births)
gen prop= n_births/total_births
save "$dta/FI_obs.dta" ,replace
restore 
save "$dta/FI_ts.dta" ,replace

****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=1/6 {
use "$dta/FI_ts.dta", clear
keep if hh_inc==`i'
poisson n_births i.loco c.bdate_w c.bdate_w#c.bdate_w i.bweek , irr
count if loco==1 & e(sample)==1
scalar r=r(N) 
di r

margins, ///
at(loco=0 ) ///
exp(predict(n)*r) ///
subpop(if loco==1 ) ///
saving("$dta\cf_count_`i'.dta", replace)

preserve 
use "$dta/cf_count_`i'.dta", clear
rename _margin cf_count
rename _ci_lb cf_count_lb 
rename _ci_ub cf_count_ub
rename _se_margin se_cf_count
gen hh_inc=`i'
keep hh_inc cf_count se_cf_count cf_count_lb cf_count_ub
save "$dta/cf_estimate_`i'.dta", replace
restore


margins, ///
at(loco=0) ///
at((asobs) _all ) ///
exp(predict(n)*r) ///
subpop(if loco==1) ///
pwcompare ///
saving("$dta\countdiff_`i'.dta", replace)

preserve 
use "$dta/countdiff_`i'.dta", clear
rename _margin countdiff
rename _ci_lb countdiff_lb
rename _ci_ub countdiff_ub
gen hh_inc=`i'
keep hh_inc countdiff countdiff_lb countdiff_ub
save "$dta/countdiff_estimate_`i'.dta", replace
restore

}


use "$dta/cf_estimate_1", clear
forval i=2/6 {
	append using "$dta/cf_estimate_`i'"
}


merge 1:1  hh_inc using "$dta/FI_obs.dta", nogen
order hh_inc n_births cf_count se_cf_count 
egen total_cf_count=sum(cf_count)
gen cf_prop=cf_count/total_cf_count
gen propdiff=prop-cf_prop
save "$dta/FI_cf_estimate.dta", replace


use "$dta/countdiff_estimate_1", clear
forval i=2/6 {
	append using "$dta/countdiff_estimate_`i'"
}

merge 1:1  hh_inc using "$dta/FI_cf_estimate.dta", nogen
order hh_inc n_births cf_count se_cf_count 
save "$dta/FI_cf_estimate.dta", replace

*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
set seed 123456789
forval d=1/10000 {
use "$dta/FI_cf_estimate.dta", clear
keep hh_inc cf_count se_cf_count prop
gen cf_count_i_d=rnormal(cf_count , se_cf_count) // generate random draw d from mean SE estimated from poisson ITS for each SIMD group i
egen sum_cf_count_i_d=sum(cf_count_i_d) // sum random draws d of all groups i
gen cf_prop_i_d=cf_count_i_d/sum_cf_count_i_d // create counterfactual proportion for each group i based on draw d
gen propdiff_i_d=prop- cf_prop_i_d // get m_i_d which is the difference in proportion between observed and counterfactual from draw d
keep hh_inc propdiff_i_d
gen draw=`d'

tempfile draw_`d'
save `draw_`d'',replace
}

*merge data
use `draw_1' ,clear
forval d=2/10000 {
	append using `draw_`d''
}

*generate lower and upper bound of difference in proportion
_pctile propdiff_i_d if hh_inc==1, percentiles(2.5) 
return list
gen propdiff_lb=r(r1) if hh_inc==1
_pctile propdiff_i_d if hh_inc==1, percentiles(97.5) 
return list
gen propdiff_ub=r(r1) if hh_inc==1

forval i=2/6 {
_pctile propdiff_i_d if hh_inc==`i', percentiles(2.5) 
return list
replace propdiff_lb=r(r1) if hh_inc==`i'
_pctile propdiff_i_d if hh_inc==`i', percentiles(97.5) 
return list
replace propdiff_ub=r(r1) if hh_inc==`i'
}

collapse propdiff_lb propdiff_ub, by(hh_inc)
save "$dta/FI_prop_uncertainty", replace
use "$dta/FI_cf_estimate", clear
merge 1:1 hh_inc using "$dta/FI_prop_uncertainty", nogen
gen country="Finland"
save "$dta/FI_comp_diff", replace

**# Bookmark #2

*************************** SWEDEN SWEDEN SWEDEN  ******************************
*************************** SWEDEN SWEDEN SWEDEN  ******************************
*************************** SWEDEN SWEDEN SWEDEN  ******************************
clear all
use "$dta/SWE_ts", clear
preserve // get numbers for table later
collapse (sum) n_births if loco==1, by(hh_inc)
egen total_births=sum(n_births)
gen prop= n_births/total_births
save "$dta/SWE_obs.dta" ,replace
restore 

****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=1/6 {
use "$dta/SWE_ts.dta", clear
keep if hh_inc==`i'
poisson n_births i.loco c.bdate_w c.bdate_w#c.bdate_w i.bweek , irr
count if loco==1 & e(sample)==1
scalar r=r(N) 
di r

margins, ///
at(loco=0 ) ///
exp(predict(n)*r) ///
subpop(if loco==1 ) ///
saving("$dta\cf_count_`i'.dta", replace)

preserve 
use "$dta/cf_count_`i'.dta", clear
rename _margin cf_count
rename _ci_lb cf_count_lb 
rename _ci_ub cf_count_ub
rename _se_margin se_cf_count
gen hh_inc=`i'
keep hh_inc cf_count se_cf_count cf_count_lb cf_count_ub
save "$dta/cf_estimate_`i'.dta", replace
restore


margins, ///
at(loco=0) ///
at((asobs) _all ) ///
exp(predict(n)*r) ///
subpop(if loco==1) ///
pwcompare ///
saving("$dta\countdiff_`i'.dta", replace)

preserve 
use "$dta/countdiff_`i'.dta", clear
rename _margin countdiff
rename _ci_lb countdiff_lb
rename _ci_ub countdiff_ub
gen hh_inc=`i'
keep hh_inc countdiff countdiff_lb countdiff_ub
save "$dta/countdiff_estimate_`i'.dta", replace
restore

}


use "$dta/cf_estimate_1", clear
forval i=2/6 {
	append using "$dta/cf_estimate_`i'"
}


merge 1:1  hh_inc using "$dta/SWE_obs.dta", nogen
order hh_inc n_births cf_count se_cf_count 
egen total_cf_count=sum(cf_count)
gen cf_prop=cf_count/total_cf_count
gen propdiff=prop-cf_prop
save "$dta/SWE_cf_estimate.dta", replace


use "$dta/countdiff_estimate_1", clear
forval i=2/6 {
	append using "$dta/countdiff_estimate_`i'"
}

merge 1:1  hh_inc using "$dta/SWE_cf_estimate.dta", nogen
order hh_inc n_births cf_count se_cf_count 
save "$dta/SWE_cf_estimate.dta", replace

*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
set seed 123456789
forval d=1/10000 {
use "$dta/SWE_cf_estimate.dta", clear
keep hh_inc cf_count se_cf_count prop
gen cf_count_i_d=rnormal(cf_count , se_cf_count) // generate random draw d from mean SE estimated from poisson ITS for each SIMD group i
egen sum_cf_count_i_d=sum(cf_count_i_d) // sum random draws d of all groups i
gen cf_prop_i_d=cf_count_i_d/sum_cf_count_i_d // create counterfactual proportion for each group i based on draw d
gen propdiff_i_d=prop- cf_prop_i_d // get m_i_d which is the difference in proportion between observed and counterfactual from draw d
keep hh_inc propdiff_i_d
gen draw=`d'

tempfile draw_`d'
save `draw_`d'',replace
}

*merge data
use `draw_1' ,clear
forval d=2/10000 {
	append using `draw_`d''
}

*generate lower and upper bound of difference in proportion
_pctile propdiff_i_d if hh_inc==1, percentiles(2.5) 
return list
gen propdiff_lb=r(r1) if hh_inc==1
_pctile propdiff_i_d if hh_inc==1, percentiles(97.5) 
return list
gen propdiff_ub=r(r1) if hh_inc==1

forval i=2/6 {
_pctile propdiff_i_d if hh_inc==`i', percentiles(2.5) 
return list
replace propdiff_lb=r(r1) if hh_inc==`i'
_pctile propdiff_i_d if hh_inc==`i', percentiles(97.5) 
return list
replace propdiff_ub=r(r1) if hh_inc==`i'
}

collapse propdiff_lb propdiff_ub, by(hh_inc)
save "$dta/SWE_prop_uncertainty", replace
use "$dta/SWE_cf_estimate", clear
merge 1:1 hh_inc using "$dta/SWE_prop_uncertainty", nogen
gen country="Sweden"
save "$dta/SWE_comp_diff", replace

**# Bookmark #2


*************************** DENMARK DENMARK DENMARK  ******************************
*************************** DENMARK DENMARK DENMARK  ******************************
*************************** DENMARK DENMARK DENMARK  ******************************
clear all
use "$dta/DEN_ts", clear
preserve // get numbers for table later
collapse (sum) n_births if loco==1, by(hh_inc)
egen total_births=sum(n_births)
gen prop= n_births/total_births
save "$dta/DEN_obs.dta" ,replace
restore 

****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=1/6 {
use "$dta/DEN_ts.dta", clear
keep if hh_inc==`i'
poisson n_births i.loco c.bdate_w c.bdate_w#c.bdate_w i.bweek , irr
count if loco==1 & e(sample)==1
scalar r=r(N) 
di r

margins, ///
at(loco=0 ) ///
exp(predict(n)*r) ///
subpop(if loco==1 ) ///
saving("$dta\cf_count_`i'.dta", replace)

preserve 
use "$dta/cf_count_`i'.dta", clear
rename _margin cf_count
rename _ci_lb cf_count_lb 
rename _ci_ub cf_count_ub
rename _se_margin se_cf_count
gen hh_inc=`i'
keep hh_inc cf_count se_cf_count cf_count_lb cf_count_ub
save "$dta/cf_estimate_`i'.dta", replace
restore


margins, ///
at(loco=0) ///
at((asobs) _all ) ///
exp(predict(n)*r) ///
subpop(if loco==1) ///
pwcompare ///
saving("$dta\countdiff_`i'.dta", replace)

preserve 
use "$dta/countdiff_`i'.dta", clear
rename _margin countdiff
rename _ci_lb countdiff_lb
rename _ci_ub countdiff_ub
gen hh_inc=`i'
keep hh_inc countdiff countdiff_lb countdiff_ub
save "$dta/countdiff_estimate_`i'.dta", replace
restore

}


use "$dta/cf_estimate_1", clear
forval i=2/6 {
	append using "$dta/cf_estimate_`i'"
}


merge 1:1  hh_inc using "$dta/DEN_obs.dta", nogen
order hh_inc n_births cf_count se_cf_count 
egen total_cf_count=sum(cf_count)
gen cf_prop=cf_count/total_cf_count
gen propdiff=prop-cf_prop
save "$dta/DEN_cf_estimate.dta", replace


use "$dta/countdiff_estimate_1", clear
forval i=2/6 {
	append using "$dta/countdiff_estimate_`i'"
}

merge 1:1  hh_inc using "$dta/DEN_cf_estimate.dta", nogen
order hh_inc n_births cf_count se_cf_count 
save "$dta/DEN_cf_estimate.dta", replace

*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
set seed 123456789
forval d=1/10000 {
use "$dta/DEN_cf_estimate.dta", clear
keep hh_inc cf_count se_cf_count prop
gen cf_count_i_d=rnormal(cf_count , se_cf_count) // generate random draw d from mean SE estimated from poisson ITS for each SIMD group i
egen sum_cf_count_i_d=sum(cf_count_i_d) // sum random draws d of all groups i
gen cf_prop_i_d=cf_count_i_d/sum_cf_count_i_d // create counterfactual proportion for each group i based on draw d
gen propdiff_i_d=prop- cf_prop_i_d // get m_i_d which is the difference in proportion between observed and counterfactual from draw d
keep hh_inc propdiff_i_d
gen draw=`d'

tempfile draw_`d'
save `draw_`d'',replace
}

*merge data
use `draw_1' ,clear
forval d=2/10000 {
	append using `draw_`d''
}

*generate lower and upper bound of difference in proportion
_pctile propdiff_i_d if hh_inc==1, percentiles(2.5) 
return list
gen propdiff_lb=r(r1) if hh_inc==1
_pctile propdiff_i_d if hh_inc==1, percentiles(97.5) 
return list
gen propdiff_ub=r(r1) if hh_inc==1

forval i=2/6 {
_pctile propdiff_i_d if hh_inc==`i', percentiles(2.5) 
return list
replace propdiff_lb=r(r1) if hh_inc==`i'
_pctile propdiff_i_d if hh_inc==`i', percentiles(97.5) 
return list
replace propdiff_ub=r(r1) if hh_inc==`i'
}

collapse propdiff_lb propdiff_ub, by(hh_inc)
save "$dta/DEN_prop_uncertainty", replace
use "$dta/DEN_cf_estimate", clear
merge 1:1 hh_inc using "$dta/DEN_prop_uncertainty", nogen
gen country="Denmark"
save "$dta/DEN_comp_diff", replace



**# Bookmark #21

*************************** NETHERLANDS NETHERLANDS NETHERLANDS ******************************
*************************** NETHERLANDS NETHERLANDS NETHERLANDS ******************************
*************************** NETHERLANDS NETHERLANDS NETHERLANDS ******************************
clear all
use "$dta/NET_ts", clear
/*rename quint_hhinc hh_inc // uniform labelling
label define inclab 1 "Q1 - lowest income" 2 "Q2" 3 "Q3" 4 "Q4" 5 "Q5 - highest income" 6 "Unknown"
label values hh_inc inclab*/
preserve // get numbers for table later
collapse (sum) n_births if loco==1, by(hh_inc)
egen total_births=sum(n_births)
gen prop= n_births/total_births
save "$dta/NET_obs.dta" ,replace
restore 
save "$dta/NET_ts.dta" ,replace

****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=1/6 {
use "$dta/NET_ts.dta", clear
keep if hh_inc==`i'
poisson n_births i.loco c.mdate c.mdate#c.mdate i.month_nr , irr
count if loco==1 & e(sample)==1
scalar r=r(N) 
di r

margins, ///
at(loco=0 ) ///
exp(predict(n)*r) ///
subpop(if loco==1 ) ///
saving("$dta\cf_count_`i'.dta", replace)

preserve 
use "$dta/cf_count_`i'.dta", clear
rename _margin cf_count
rename _ci_lb cf_count_lb 
rename _ci_ub cf_count_ub
rename _se_margin se_cf_count
gen hh_inc=`i'
keep hh_inc cf_count se_cf_count cf_count_lb cf_count_ub
save "$dta/cf_estimate_`i'.dta", replace
restore


margins, ///
at(loco=0) ///
at((asobs) _all ) ///
exp(predict(n)*r) ///
subpop(if loco==1) ///
pwcompare ///
saving("$dta\countdiff_`i'.dta", replace)

preserve 
use "$dta/countdiff_`i'.dta", clear
rename _margin countdiff
rename _ci_lb countdiff_lb
rename _ci_ub countdiff_ub
gen hh_inc=`i'
keep hh_inc countdiff countdiff_lb countdiff_ub
save "$dta/countdiff_estimate_`i'.dta", replace
restore

}


use "$dta/cf_estimate_1", clear
forval i=2/6 {
	append using "$dta/cf_estimate_`i'"
}


merge 1:1  hh_inc using "$dta/NET_obs.dta", nogen
order hh_inc n_births cf_count se_cf_count 
egen total_cf_count=sum(cf_count)
gen cf_prop=cf_count/total_cf_count
gen propdiff=prop-cf_prop
save "$dta/NET_cf_estimate.dta", replace


use "$dta/countdiff_estimate_1", clear
forval i=2/6 {
	append using "$dta/countdiff_estimate_`i'"
}

merge 1:1  hh_inc using "$dta/NET_cf_estimate.dta", nogen
order hh_inc n_births cf_count se_cf_count 
save "$dta/NET_cf_estimate.dta", replace
*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
clear all
set seed 123456789
forval d=1/10000 {
use "$dta/NET_cf_estimate.dta", clear
keep hh_inc cf_count se_cf_count prop
gen cf_count_i_d=rnormal(cf_count , se_cf_count) // generate random draw d from mean SE estimated from poisson ITS for each SIMD group i
egen sum_cf_count_i_d=sum(cf_count_i_d) // sum random draws d of all groups i
gen cf_prop_i_d=cf_count_i_d/sum_cf_count_i_d // create counterfactual proportion for each group i based on draw d
gen propdiff_i_d=prop- cf_prop_i_d // get m_i_d which is the difference in proportion between observed and counterfactual from draw d
keep hh_inc propdiff_i_d
gen draw=`d'

tempfile draw_`d'
save `draw_`d'',replace
}

*merge data
use `draw_1' ,clear
forval d=2/10000 {
	append using `draw_`d''
}

*generate lower and upper bound of difference in proportion
_pctile propdiff_i_d if hh_inc==1, percentiles(2.5) 
return list
gen propdiff_lb=r(r1) if hh_inc==1
_pctile propdiff_i_d if hh_inc==1, percentiles(97.5) 
return list
gen propdiff_ub=r(r1) if hh_inc==1

forval i=2/6 {
_pctile propdiff_i_d if hh_inc==`i', percentiles(2.5) 
return list
replace propdiff_lb=r(r1) if hh_inc==`i'
_pctile propdiff_i_d if hh_inc==`i', percentiles(97.5) 
return list
replace propdiff_ub=r(r1) if hh_inc==`i'
}

collapse propdiff_lb propdiff_ub, by(hh_inc)
save "$dta/NET_prop_uncertainty", replace
use "$dta/NET_cf_estimate", clear
merge 1:1 hh_inc using "$dta/NET_prop_uncertainty", nogen
gen country="Netherlands"
save "$dta/NET_comp_diff", replace


**# Bookmark #4
****************** SOUTH AUSTRALIA ***********************
****************** SOUTH AUSTRALIA ***********************
****************** SOUTH AUSTRALIA ***********************
****************** SOUTH AUSTRALIA ***********************
*results have been sent by collaborators at the University of Adelaide

import delimited "C:\Users\moritzob\OneDrive - University of Helsinki\postdoc life helsinki\LoCo-effect\LoCo-effect Australia\export 12122024\AUS_comp_diff_IRSAD2016.csv", clear 

gen area_deprivation2=_n
drop area_deprivation
rename area_deprivation2 area_deprivation

replace country="South Australia" if country=="Australia"

save "$dta/AUS_comp_diff",replace

**# Bookmark #4
******************* FIGURE 6 **************************
********* FOREST PLOT********
********* FOREST PLOT********
********* FOREST PLOT********
********* FOREST PLOT********

use "$dta/AT_comp_diff",clear
append using "$dta/COL_comp_diff"
append using "$dta/ESP_comp_diff"
append using "$dta/MEX_comp_diff"
append using "$dta/US_comp_diff"
label val mom_edu_comp 

append using "$dta/BRA_comp_diff"
append using "$dta/ENG_comp_diff"
append using "$dta/SCOT_comp_diff"
append using "$dta/WAL_comp_diff"
append using "$dta/ECU_comp_diff"
append using "$dta/AUS_comp_diff"

append using "$dta/FI_comp_diff"
append using "$dta/SWE_comp_diff"
append using "$dta/DEN_comp_diff"
append using "$dta/NET_comp_diff"


order country mom_edu_comp area_deprivation hh_inc propdiff_lb propdiff propdiff_ub

* create top and bottom table
drop if area_deprivation >1 & area_deprivation<5 | area_deprivation==6
drop if hh_inc >1 & hh_inc<5 | hh_inc==6
drop if mom_edu_comp==2 | mom_edu_comp==6 | mom_edu_comp==4
drop if mom_edu_comp==3 & country=="Austria"
gen top=1 if mom_edu_comp==3 | area_deprivation==5 | hh_inc==5 | mom_edu_comp==5
replace top=00 if top==.

gen bot_propdiff=propdiff if top==0
gen bot_propdiff_lb=propdiff_lb if top==0
gen bot_propdiff_ub=propdiff_ub if top==0
replace propdiff=. if top==0
replace propdiff_lb=. if top==0
replace propdiff_ub=. if top==0

*TOP
encode country, gen(Country)
order country Country mom_edu_comp area_deprivation hh_inc propdiff_lb propdiff propdiff_ub
gsort - propdiff

myaxis wanted=Country, sort(mean propdiff) 

set scheme stcolor
graph set window fontface "Arial Narrow"

**create forst plot for percentage change in top groups

tw ///
(rcap propdiff_lb propdiff_ub wanted, horizontal lcolor(black)) ///
(scatter wanted propdiff, mcolor(black) msize(vsmall)) ///
if top==1, ///
legend(off) ///
ylab(1(1)15,val) ///
yt("") ///
xlab(-0.03(0.01)0.03) ///
xt("Absolute Difference in the Proportion of Live Births between Observed and Counterfactual Composition" ) ///
xline(0) ///
title("Post-Secondary or Tertiary Maternal Education;" "20% Least Deprived Areas;" "Highest 20% Household Incomes", size(medium)) ///
fxsize(80) ///
name(top_forest, replace)

*BOT
**create forst plot for percentage change in top groups


tw ///
(rcap bot_propdiff_lb bot_propdiff_ub wanted, horizontal lcolor(black)) ///
(scatter wanted bot_propdiff, mcolor(black) msize(vsmall)) ///
if top==0, ///
legend(off) ///
ylab(1(1)15, nolab grid) ///
yt("") ///
xlab(-0.03 (0.01) 0.03) ///
xt("Absolute Difference in the Proportion of Live Births") ///
xline(0) ///
title("Primary or Lower-Secondary Maternal Education;" "20% Most Deprived Areas;" "Lowest 20% Household Incomes", size(medium)) ///
fxsize(65) ///
name(bot_forest, replace)

grc1leg2  top_forest bot_forest, ///
xtob1title loff

graph export "$graph/top_bot_forest_$S_DATE.svg" ,replace




**# Bookmark #5
******************* FIGURE 7 **************************

******************* TRY COUNTRY PANEL COMPOSITION PLOT *************
******************* TRY COUNTRY PANEL COMPOSITION PLOT *************
******************* TRY COUNTRY PANEL COMPOSITION PLOT *************
* One forest with all groups by country = 12 panels

use "$dta/AT_comp_diff",clear
append using "$dta/COL_comp_diff"
append using "$dta/ESP_comp_diff"
append using "$dta/MEX_comp_diff"
append using "$dta/US_comp_diff"
label val mom_edu_comp 

append using "$dta/BRA_comp_diff"
append using "$dta/ENG_comp_diff"
append using "$dta/SCOT_comp_diff"
append using "$dta/WAL_comp_diff"
append using "$dta/ECU_comp_diff"
append using "$dta/AUS_comp_diff"

append using "$dta/FI_comp_diff"
append using "$dta/SWE_comp_diff"
append using "$dta/DEN_comp_diff"
append using "$dta/NET_comp_diff"

order country mom_edu_comp area_deprivation hh_inc propdiff_lb propdiff propdiff_ub

/*
Longest labels must have same length of characters so vertical axis is algine
22 is longest for Austria, Col
*/

label define deplab 1 "Q1 - most deprived" 2 "Q2" 3 "Q3" 4 "Q4" 5 "   Q5 - least deprived" 6 "Unknown" // 19 characters without spaces
label values area_deprivation deplab
label define inclab 1 "Q1 - lowest income" 2 "Q2" 3 "Q3" 4 "Q4" 5 "   Q5 - highest income" 6 "Unknown" // 19 characters without spaces
label values hh_inc inclab


**# Bookmark #17
* AT
tw ///
(rcap propdiff_lb propdiff_ub mom_edu_comp, horizontal lcolor(black)) ///
(scatter mom_edu_comp propdiff, mcolor(black) msize(vsmall)) ///
if country=="Austria", ///
legend(off) ///
yt("", ) ///
ylab(1 "Compulsory" 2 "Apprenticeship" 3 "Techn. & Voc. School" 4 "Acad. Upper Second." 5 "Post-Second./Tert." 6 "Unknown") ///
xlab(-0.03 (0.01) 0.03) ///
xt("Absolute Difference in the Proportion of Live Births between Observed vs. Counterfactual Composition") ///
xline(0) ///
title("{bf:Austria} (Education)", size(medium)) ///
name(AT, replace)


* COL
tw ///
(rcap propdiff_lb propdiff_ub mom_edu_comp, horizontal lcolor(black)) ///
(scatter mom_edu_comp propdiff, mcolor(black) msize(vsmall)) ///
if country=="Colombia", ///
legend(off) ///
yt("", ) ///
ylab(1 " Prim./Lower Second." 2 "Upper Second." 3 "Post-Second./Tert." 4 "Unknown") /// 21 characters long
xlab(-0.03 (0.01) 0.03) ///
xt("Absolute Difference in the Proportion of Live Births between Observed vs. Counterfactual Composition") ///
xline(0) ///
title("{bf:Colombia} (Education)", size(medium)) ///
name(COL, replace)

* ESP
tw ///
(rcap propdiff_lb propdiff_ub mom_edu_comp, horizontal lcolor(black)) ///
(scatter mom_edu_comp propdiff, mcolor(black) msize(vsmall)) ///
if country=="Spain", ///
legend(off) ///
yt("", ) ///
ylab(1 " Prim./Lower Second." 2 "Upper Second." 3 "Post-Second./Tert." 4 "Unknown") ///
xlab(-0.03 (0.01) 0.03) ///
xt("Absolute Difference in the Proportion of Live Births between Observed vs. Counterfactual Composition") ///
xline(0) ///
title("{bf:Spain} (Education)", size(medium)) ///
name(ESP, replace)


* USA
tw ///
(rcap propdiff_lb propdiff_ub mom_edu_comp, horizontal lcolor(black)) ///
(scatter mom_edu_comp propdiff, mcolor(black) msize(vsmall)) ///
if country=="United States", ///
legend(off) ///
yt("", ) ///
ylab(1 "No Highschool" 2 "Highschool" 3 "    Post-Second./Tert." 4 "Unknown") /// 18 characters without spaces
xlab(-0.03 (0.01) 0.03) ///
xt("Absolute Difference in the Proportion of Live Births between Observed vs. Counterfactual Composition") ///
xline(0) ///
title("{bf:United States} (Education)", size(medium)) ///
name(US, replace)

*MEXICO
tw ///
(rcap propdiff_lb propdiff_ub mom_edu_comp, horizontal lcolor(black)) ///
(scatter mom_edu_comp propdiff, mcolor(black) msize(vsmall)) ///
if country=="Mexico", ///
legend(off) ///
yt("", ) ///
ylab(1 "Elementary" 2 "Lower Second." 3 "         Upper Second." 4 "Unknown") /// 13 characters without spaces
xlab(-0.03 (0.01) 0.03) ///
xt("Absolute Difference in the Proportion of Live Births between Observed vs. Counterfactual Composition") ///
xline(0) ///
title("{bf:Mexico} (Education)", size(medium)) ///
name(MEX, replace)



* BRA
tw ///
(rcap propdiff_lb propdiff_ub area_deprivation, horizontal lcolor(black)) ///
(scatter area_deprivation propdiff, mcolor(black) msize(vsmall)) ///
if country=="Brazil", ///
legend(off) ///
yt("", ) ///
ylab(1(1)6, val) ///
xlab(-0.03 (0.01) 0.03) ///
xt("Absolute Difference in the Proportion of Live Births between Observed vs. Counterfactual Composition") ///
xline(0) ///
title("{bf:Brazil} (Area Deprivation)", size(medium)) ///
name(BRA, replace)

* SCOT
tw ///
(rcap propdiff_lb propdiff_ub area_deprivation, horizontal lcolor(black)) ///
(scatter area_deprivation propdiff, mcolor(black) msize(vsmall)) ///
if country=="Scotland", ///
legend(off) ///
yt("", ) ///
ylab(1(1)6, val) ///
xlab(-0.03 (0.01) 0.03) ///
xt("Absolute Difference in the Proportion of Live Births between Observed vs. Counterfactual Composition") ///
xline(0) ///
title("{bf:Scotland} (Area Deprivation)", size(medium)) ///
name(SCOT, replace)


* ENG
tw ///
(rcap propdiff_lb propdiff_ub area_deprivation, horizontal lcolor(black)) ///
(scatter area_deprivation propdiff, mcolor(black) msize(vsmall)) ///
if country=="England", ///
legend(off) ///
yt("", ) ///
ylab(1(1)5, val) ///
xlab(-0.03 (0.01) 0.03) ///
xt("Absolute Difference in the Proportion of Live Births between Observed vs. Counterfactual Composition") ///
xline(0) ///
title("{bf:England} (Area Deprivation)", size(medium)) ///
name(ENG, replace)


* Wales
tw ///
(rcap propdiff_lb propdiff_ub area_deprivation, horizontal lcolor(black)) ///
(scatter area_deprivation propdiff, mcolor(black) msize(vsmall)) ///
if country=="Wales", ///
legend(off) ///
yt("", ) ///
ylab(1(1)5, val) ///
xlab(-0.03 (0.01) 0.03) ///
xt("Absolute Difference in the Proportion of Live Births between Observed vs. Counterfactual Composition") ///
xline(0) ///
title("{bf:Wales} (Area Deprivation)", size(medium)) ///
name(WAL, replace)


* ECUADOR************************
tw ///
(rcap propdiff_lb propdiff_ub area_deprivation, horizontal lcolor(black)) ///
(scatter area_deprivation propdiff, mcolor(black) msize(vsmall)) ///
if country=="Ecuador", ///
legend(off) ///
yt("", ) ///
ylab(1(1)5, val) ///
xlab(-0.03 (0.01) 0.03) ///
xt("Absolute Difference in the Proportion of Live Births between Observed vs. Counterfactual Composition") ///
xline(0) ///
title("{bf:Ecuador} (Area Deprivation)", size(medium)) ///
name(ECU, replace)

*Netherlands
tw ///
(rcap propdiff_lb propdiff_ub hh_inc, horizontal lcolor(black)) ///
(scatter hh_inc propdiff, mcolor(black) msize(vsmall)) ///
if country=="Netherlands", ///
legend(off) ///
yt("", ) ///
ylab(1(1)6, val) ///
xlab(-0.03 (0.01) 0.03) ///
xt("Absolute Difference in the Proportion of Live Births between Observed vs. Counterfactual Composition") ///
xline(0) ///
title("{bf:Netherlands} (Household Income)", size(medium)) ///
name(NET, replace)


*FI
tw ///
(rcap propdiff_lb propdiff_ub hh_inc, horizontal lcolor(black)) ///
(scatter hh_inc propdiff, mcolor(black) msize(vsmall)) ///
if country=="Finland", ///
legend(off) ///
yt("", ) ///
ylab(1(1)6, val) ///
xlab(-0.03 (0.01) 0.03) ///
xt("Absolute Difference in the Proportion of Live Births between Observed vs. Counterfactual Composition") ///
xline(0) ///
title("{bf:Finland} (Household Income)", size(medium)) ///
name(FI, replace)

*SWEDEN
tw ///
(rcap propdiff_lb propdiff_ub hh_inc, horizontal lcolor(black)) ///
(scatter hh_inc propdiff, mcolor(black) msize(vsmall)) ///
if country=="Sweden", ///
legend(off) ///
yt("", ) ///
ylab(1(1)6, val) ///
xlab(-0.03 (0.01) 0.03) ///
xt("Absolute Difference in the Proportion of Live Births between Observed vs. Counterfactual Composition") ///
xline(0) ///
title("{bf:Sweden} (Household Income)", size(medium)) ///
name(SWE, replace)


*DENMARK
tw ///
(rcap propdiff_lb propdiff_ub hh_inc, horizontal lcolor(black)) ///
(scatter hh_inc propdiff, mcolor(black) msize(vsmall)) ///
if country=="Denmark", ///
legend(off) ///
yt("", ) ///
ylab(1(1)6, val) ///
xlab(-0.03 (0.01) 0.03) ///
xt("Absolute Difference in the Proportion of Live Births between Observed vs. Counterfactual Composition") ///
xline(0) ///
title("{bf:Denmark} (Household Income)", size(medium)) ///
name(DEN, replace)

*South Australia
tw ///
(rcap propdiff_lb propdiff_ub area_deprivation, horizontal lcolor(black)) ///
(scatter area_deprivation propdiff, mcolor(black) msize(vsmall)) ///
if country=="South Australia", ///
legend(off) ///
yt("", ) ///
ylab(1(1)5, val) ///
xlab(-0.03 (0.01) 0.03) ///
xt("Absolute Difference in the Proportion of Live Births between Observed vs. Counterfactual Composition") ///
xline(0) ///
title("{bf:South Australia} (Area Deprivation)", size(medium)) ///
name(AUS, replace)



**# Bookmark #19

grc1leg2  AT BRA COL DEN ECU ENG FI MEX NET SCOT AUS ESP SWE US WAL , ///
col(3)  ///
plotregion(margin(zero)) imargin(zero) ///
xtob1title  ///
title("Difference between Observed and Counterfactual Socioeconomic Composition" "of Live Births December 2020-December 2021", size(medsmall)) loff


graph export "$graph/Composition_all$S_DATE.svg", replace height(2800) width(3000)




**# Bookmark #8
****************** TABLE 1 ***************************


***** CREATE TABLE **********'
***** CREATE TABLE **********'
***** CREATE TABLE **********'
***** CREATE TABLE **********'
***** CREATE TABLE **********'



use "$dta/AT_comp_diff",clear
append using "$dta/BRA_comp_diff"
append using "$dta/COL_comp_diff"
append using "$dta/ECU_comp_diff"
append using "$dta/ENG_comp_diff"
append using "$dta/ESP_comp_diff"
append using "$dta/FI_comp_diff"
append using "$dta/MEX_comp_diff"
append using "$dta/NET_comp_diff"
append using "$dta/SCOT_comp_diff"
append using "$dta/US_comp_diff"
append using "$dta/WAL_comp_diff"
append using "$dta/SWE_comp_diff"
append using "$dta/DEN_comp_diff"
append using "$dta/AUS_comp_diff"
drop rel_count_diff rel_count_diff_ub rel_count_diff_lb

label val mom_edu_comp 

gen group=mom_edu_comp
replace group=hh_inc if group==.
replace group=area_deprivation if group==.

gen rel_count_diff=(n_births-cf_count)/(abs(cf_count))*100
gen rel_count_diff_ub=(n_births-cf_count_lb)/(abs(cf_count_lb))*100
gen rel_count_diff_lb=(n_births-cf_count_ub)/(abs(cf_count_ub))*100

order country group n_births cf_count countdiff rel_count_diff prop cf_prop propdiff

format %9.0f n_births cf_count countdiff
replace cf_count_lb=round(cf_count_lb)
replace cf_count_ub=round(cf_count_ub)
tostring cf_count_lb cf_count_ub, replace force
gen cf_count_ci="(" + cf_count_lb + "; " + cf_count_ub + ")"
drop cf_count_lb cf_count_ub
replace countdiff_lb=round(countdiff_lb)
replace countdiff_ub=round(countdiff_ub)
tostring countdiff_lb countdiff_ub, replace force
gen countdiff_ci="(" +countdiff_lb + "; " + countdiff_ub+ ")"
drop countdiff_lb countdiff_ub
replace rel_count_diff_lb=round(rel_count_diff_lb, 0.1)
replace rel_count_diff_ub=round(rel_count_diff_ub, 0.1)
format %03.1f rel_count_diff_lb rel_count_diff_ub
tostring rel_count_diff_lb rel_count_diff_ub, replace force format(%03.1f)
gen str rel_diff_ci="(" +rel_count_diff_lb + "; " + rel_count_diff_ub+ ")"
drop rel_count_diff_lb rel_count_diff_ub

foreach var of varlist prop cf_prop propdiff propdiff_lb propdiff_ub {
	replace `var'=`var'*100
}

format %03.1f rel_count_diff prop cf_prop propdiff propdiff_lb propdiff_ub
tostring propdiff_lb propdiff_ub, replace force format(%03.1f)
gen str propdiff_ci="(" +propdiff_lb + "; " + propdiff_ub+ ")"
drop propdiff_lb propdiff_ub

order country group n_births cf_count  cf_count_ci countdiff countdiff_ci  rel_count_diff rel_diff_ci prop cf_prop propdiff propdiff_ci total_births total_cf_count
drop se_cf_count

export excel using "C:\Users\moritzob\OneDrive - University of Helsinki\postdoc life helsinki\LoCo-effect\International exchangeability paper\Comparative tables\Main_SEC_Comp_table_all_uncert_$S_DATE.csv", replace firstrow(variables)












