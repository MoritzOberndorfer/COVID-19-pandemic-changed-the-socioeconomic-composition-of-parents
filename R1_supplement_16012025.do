/*
The COVID-19 pandemic changed the socioeconomic composition of parents: A register-based study of 77.9 million live births in 15 countries

Code: Moritz Oberndorfer

Code for:
REVISED Supplement

12 panel figure for change in relative number of births along primary SEC variable

12 panel figure for compositional change along secondary SEC variable
12 panel figure for change in relative number of births along secondary SEC variable


12 panel figure for compositional change along maternal age
12 panel figure for change in relative number of births along maternal age

12 panel figure for compositional change along parity
12 panel figure for change in relative number of births along parity


COUNTRY PROFILES (estimates for 12 panel figures above are generated here)

Panel figure for counts:
- all categories of main SEC variable
- more detailed country-specific measure of SEC variable (EDCUATION)
- paternal education
- highest of maternal and paternal education where paternal is available
- age groups <20, 20-24, 25-29, 30-34, >34
- parity or # living children ... 0,1,2,3,4 or more. especially to see difference between number of first born

Table: 
Country-specific table with uncertainty estimates


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


**# Bookmark #1

**12 panel figure for change in relative number of births along primary SEC variable

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

label val mom_edu_comp 

drop rel_count_diff rel_count_diff_lb rel_count_diff_ub
gen group=mom_edu_comp
replace group=hh_inc if group==.
replace group=area_deprivation if group==.

gen rel_count_diff=(n_births-cf_count)/(abs(cf_count))*100
gen rel_count_diff_lb=(n_births-cf_count_lb)/(abs(cf_count_lb))*100
gen rel_count_diff_ub=(n_births-cf_count_ub)/(abs(cf_count_ub))*100


order country mom_edu_comp area_deprivation hh_inc rel_count_diff_lb rel_count_diff rel_count_diff_ub 

drop propdiff_lb propdiff_ub propdiff
rename rel_count_diff_lb propdiff_lb
rename rel_count_diff propdiff
rename rel_count_diff_ub propdiff_ub

*MAKE OLD CODE WORK BY RENAMING


**# Bookmark #17
/*
Longest labels must have same length of characters so vertical axis is algine
22 is longest for Austria, Col
*/

label define deplab 1 "Q1 - most deprived" 2 "Q2" 3 "Q3" 4 "Q4" 5 "   Q5 - least deprived" 6 "Unknown" // 19 characters without spaces
label values area_deprivation deplab
label define inclab 1 "Q1 - lowest income" 2 "Q2" 3 "Q3" 4 "Q4" 5 "   Q5 - highest income" 6 "Unknown" // 19 characters without spaces
label values hh_inc inclab

*** NO UNKNOWN FOR VISUAL (they are in tables) ********
drop if mom_edu_comp==4 & country!="Austria"
drop if mom_edu_comp==6 & country=="Austria"
drop if area_deprivation==6
drop if hh_inc==6


**# Bookmark #17
* AT
tw ///
(rcap propdiff_lb propdiff_ub mom_edu_comp, horizontal lcolor(black)) ///
(scatter mom_edu_comp propdiff, mcolor(black) msize(vsmall)) ///
if country=="Austria", ///
legend(off) ///
yt("", ) ///
ylab(1 "Compulsory" 2 "Apprenticeship" 3 "Techn. & Voc. School" 4 "Acad. Upper Second." 5 "Post-Second./Tert.") ///
xlab(-10(5)20) ///
xt("Relative Difference between Observed vs. Expected Number of Live Births") ///
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
ylab(1 " Prim./Lower Second." 2 "Upper Second." 3 "Post-Second./Tert." ) /// 21 characters long
xlab(-10(5)20) ///
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
ylab(1 " Prim./Lower Second." 2 "Upper Second." 3 "Post-Second./Tert." ) ///
xlab(-10(5)20) ///
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
ylab(1 "No Highschool" 2 "Highschool" 3 "    Post-Second./Tert." ) /// 18 characters without spaces
xlab(-10(5)20) ///
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
ylab(1 "Elementary" 2 "Lower Second." 3 "         Upper Second." ) /// 13 characters without spaces
xlab(-10(5)20) ///
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
ylab(1(1)5, val) ///
xlab(-10(5)20) ///
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
ylab(1(1)5, val) ///
xlab(-10(5)20) ///
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
xlab(-10(5)20) ///
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
xlab(-10(5)20) ///
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
xlab(-10(5)20) ///
xt("Absolute Difference in the Proportion of Live Births between Observed vs. Counterfactual Composition") ///
xline(0) ///
title("{bf:Ecuador} (Area Deprivation)", size(medium)) ///
name(ECU, replace)

*South Australia
tw ///
(rcap propdiff_lb propdiff_ub area_deprivation, horizontal lcolor(black)) ///
(scatter area_deprivation propdiff, mcolor(black) msize(vsmall)) ///
if country=="South Australia", ///
legend(off) ///
yt("", ) ///
ylab(1(1)5, val) ///
xlab(-10(5)20) ///
xt("Absolute Difference in the Proportion of Live Births between Observed vs. Counterfactual Composition") ///
xline(0) ///
title("{bf:South Australia} (Area Deprivation)", size(medium)) ///
name(AUS, replace)


*Netherlands
tw ///
(rcap propdiff_lb propdiff_ub hh_inc, horizontal lcolor(black)) ///
(scatter hh_inc propdiff, mcolor(black) msize(vsmall)) ///
if country=="Netherlands", ///
legend(off) ///
yt("", ) ///
ylab(1(1)5, val) ///
xlab(-10(5)20) ///
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
ylab(1(1)5, val) ///
xlab(-10(5)20) ///
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
ylab(1(1)5, val) ///
xlab(-10(5)20) ///
xt("Absolute Difference in the Proportion of Live Births between Observed vs. Counterfactual Composition") ///
xline(0) ///
title("{bf:Sweden} (Household Income)", size(medium)) ///
name(SWE, replace)

*Denmark
tw ///
(rcap propdiff_lb propdiff_ub hh_inc, horizontal lcolor(black)) ///
(scatter hh_inc propdiff, mcolor(black) msize(vsmall)) ///
if country=="Denmark", ///
legend(off) ///
yt("", ) ///
ylab(1(1)5, val) ///
xlab(-10(5)20) ///
xt("Absolute Difference in the Proportion of Live Births between Observed vs. Counterfactual Composition") ///
xline(0) ///
title("{bf:Denmark} (Household Income)", size(medium)) ///
name(DEN, replace)



**# Bookmark #2

grc1leg2 AT BRA COL DEN ECU ENG FI MEX NET SCOT AUS ESP SWE US WAL , ///
col(3)  ///
plotregion(margin(zero)) imargin(zero) ///
xtob1title  ///
title("Relative Difference between Observed and Expected Number" "of Live Births December 2020-December 2021", size(medsmall)) loff


graph export "$graph/Rel_diff_no_unknown_all$S_DATE.svg", replace height(2800) width(3000)



**# Bookmark #2
****12 panel figure for compositional change along secondary SEC variable
/*
12 panel figure for compositional change along secondary SEC variable
Austria: Highest edu of parents
Brazil: Education in years
Colombia: Highest education of parents
Denmark: Highest maternal education
Ecuador: - (education not time consitent)
England: IMD Deciles
Finland: Maternal Education
Mexico: Highest education of parents
Netherlands: -
Scotland: -
South Australia: -
Spain: highest education of parents
Sweden: highest maternal education
United States: Parental Education
Wales: IMD Deciles

*/

* One forest with all groups by country = 12 panels

use "$dta/AT_comp_diff_mom_dad_edu_comp",clear
append using "$dta/COL_comp_diff_mom_dad_edu_comp"
append using "$dta/ESP_comp_diff_mom_dad_edu_comp"
append using "$dta/MEX_comp_diff_mom_dad_edu_comp"
append using "$dta/US_comp_diff_dad_edu_comp"

append using "$dta/BR_comp_diff_mom_edu_years"
append using "$dta/ENG_comp_diff_area_deprivation"
append using "$dta/SCOT_comp_diff"
append using "$dta/WAL_comp_diff_area_deprivation"
append using "$dta/ECU_comp_diff"
append using "$dta/AUS_comp_diff_area_deprivation10"

append using "$dta/FI_comp_diff_edu_mom_det"
append using "$dta/DEN_comp_diff_mom_edu_comp"
append using "$dta/SWE_comp_diff_mom_edu_comp"
append using "$dta/NET_comp_diff"


/* CREATE LABELS
Longest labels must have same length of characters so vertical axis is algine
22 is longest for Austria, Col
*/


gen area_deprivation_10=area_deprivation if country!="Scotland" & country!="Ecuador"
replace area_deprivation=. if country!="Scotland" & country!="Ecuador"
order country mom_dad_edu_comp mom_edu_years edu_mom_det area_deprivation_10 area_deprivation hh_inc propdiff_lb propdiff propdiff_ub

label define inclab 1 "Q1 - Lowest Income" 2 "Q2" 3 "Q3" 4 "Q4" 5 "   Q5 - Highest Income" 6 "Unknown" // 19 characters without spaces
label values hh_inc inclab

label define deplab 1 "Q1 - Most deprived" 2 "Q2" 3 "Q3" 4 "Q4" 5 "   Q5 - Least deprived" 6 "Unknown" // 19 characters without spaces
label values area_deprivation deplab

label define deplab10 1 "D1 - Most deprived" 2 "D2" 3 "D3" 4 "D4" 5 "D5" 6 "D6" 7 "D7" 8 "D8" 9 "D9" 10 "  D10 - Least deprived" 11 "Unknown" // 19 characters without spaces
label values area_deprivation_10 area_deprivation_dec deplab10

*Brazil
label define edu_y2 1 "None" 2 "1 to 3 years" 3 "4 to 7 years" 4 "8 to 11 years" 5 "    12 and more years" 6 "Unknown"
label values mom_edu_year edu_y2



**# Bookmark #17
* AT
tw ///
(rcap propdiff_lb propdiff_ub mom_dad_edu_comp, horizontal lcolor(black)) ///
(scatter mom_dad_edu_comp propdiff, mcolor(black) msize(vsmall)) ///
if country=="Austria", ///
legend(off) ///
yt("", ) ///
ylab(1 "Compulsory" 2 "Apprenticeship" 3 "Techn. & Voc. School" 4 "Acad. Upper Second." 5 "Post-Second./Tert." 6 "Unknown") ///
xlab(-0.03 (0.01) 0.03) ///
xt("Absolute Difference in the Proportion of Live Births between Observed vs. Counterfactual Composition") ///
xline(0) ///
title("{bf:Austria} (Highest of Parental Education)", size(medium)) ///
name(AT, replace)


* COL
tw ///
(rcap propdiff_lb propdiff_ub mom_dad_edu_comp, horizontal lcolor(black)) ///
(scatter mom_dad_edu_comp propdiff, mcolor(black) msize(vsmall)) ///
if country=="Colombia", ///
legend(off) ///
yt("", ) ///
ylab(1 " Prim./Lower Second." 2 "Upper Second." 3 "Post-Second./Tert." 4 "Unknown") /// 21 characters long
xlab(-0.03 (0.01) 0.03) ///
xt("Absolute Difference in the Proportion of Live Births between Observed vs. Counterfactual Composition") ///
xline(0) ///
title("{bf:Colombia} (Highest of Parental Education)", size(medium)) ///
name(COL, replace)

* ESP
tw ///
(rcap propdiff_lb propdiff_ub mom_dad_edu_comp, horizontal lcolor(black)) ///
(scatter mom_dad_edu_comp propdiff, mcolor(black) msize(vsmall)) ///
if country=="Spain", ///
legend(off) ///
yt("", ) ///
ylab(1 " Prim./Lower Second." 2 "Upper Second." 3 "Post-Second./Tert." 4 "Unknown") ///
xlab(-0.03 (0.01) 0.03) ///
xt("Absolute Difference in the Proportion of Live Births between Observed vs. Counterfactual Composition") ///
xline(0) ///
title("{bf:Spain} (Highest of Parental Education)", size(medium)) ///
name(ESP, replace)


* USA
tw ///
(rcap propdiff_lb propdiff_ub dad_edu_comp, horizontal lcolor(black)) ///
(scatter dad_edu_comp propdiff, mcolor(black) msize(vsmall)) ///
if country=="United States", ///
legend(off) ///
yt("", ) ///
ylab(1 "No Highschool" 2 "Highschool" 3 "    Post-Second./Tert." 4 "Unknown") /// 18 characters without spaces
xlab(-0.03 (0.01) 0.03) ///
xt("Absolute Difference in the Proportion of Live Births between Observed vs. Counterfactual Composition") ///
xline(0) ///
title("{bf:United States} (Father's Education)", size(medium)) ///
name(US, replace)

*MEXICO
tw ///
(rcap propdiff_lb propdiff_ub mom_dad_edu_comp, horizontal lcolor(black)) ///
(scatter mom_dad_edu_comp propdiff, mcolor(black) msize(vsmall)) ///
if country=="Mexico", ///
legend(off) ///
yt("", ) ///
ylab(1 "Elementary" 2 "Lower Second." 3 "         Upper Second." 4 "Unknown") /// 13 characters without spaces
xlab(-0.03 (0.01) 0.03) ///
xt("Absolute Difference in the Proportion of Live Births between Observed vs. Counterfactual Composition") ///
xline(0) ///
title("{bf:Mexico} (Highest of Parental Education)", size(medium)) ///
name(MEX, replace)



* BRA
tw ///
(rcap propdiff_lb propdiff_ub mom_edu_years, horizontal lcolor(black)) ///
(scatter mom_edu_years propdiff, mcolor(black) msize(vsmall)) ///
if country=="Brazil", ///
legend(off) ///
yt("", ) ///
ylab(1(1)6, val) ///
xlab(-0.03 (0.01) 0.03) ///
xt("Absolute Difference in the Proportion of Live Births between Observed vs. Counterfactual Composition") ///
xline(0) ///
title("{bf:Brazil} (Maternal Education in Years)", size(medium)) ///
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
(rcap propdiff_lb propdiff_ub area_deprivation_10, horizontal lcolor(black)) ///
(scatter area_deprivation_10 propdiff, mcolor(black) msize(vsmall)) ///
if country=="England", ///
legend(off) ///
yt("", ) ///
ylab(1(1)10, val) ///
xlab(-0.03 (0.01) 0.03) ///
xt("Absolute Difference in the Proportion of Live Births between Observed vs. Counterfactual Composition") ///
xline(0) ///
title("{bf:England} (Area Deprivation in Deciles)", size(medium)) ///
name(ENG, replace)


* Wales
tw ///
(rcap propdiff_lb propdiff_ub area_deprivation_10, horizontal lcolor(black)) ///
(scatter area_deprivation_10 propdiff, mcolor(black) msize(vsmall)) ///
if country=="Wales", ///
legend(off) ///
yt("", ) ///
ylab(1(1)10, val) ///
xlab(-0.03 (0.01) 0.03) ///
xt("Absolute Difference in the Proportion of Live Births between Observed vs. Counterfactual Composition") ///
xline(0) ///
title("{bf:Wales} (Area Deprivation in Deciles)", size(medium)) ///
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
(rcap propdiff_lb propdiff_ub edu_mom_det, horizontal lcolor(black)) ///
(scatter edu_mom_det propdiff, mcolor(black) msize(vsmall)) ///
if country=="Finland", ///
legend(off) ///
yt("", ) ///
ylab(1 "Basic" 2 "      Upper Secondary" 3 "Bachelor's Degree" 4 "Master's/Doc. Degree") /// 13 characters without spaces
xlab(-0.03 (0.01) 0.03) ///
xt("Absolute Difference in the Proportion of Live Births between Observed vs. Counterfactual Composition") ///
xline(0) ///
title("{bf:Finland} (Maternal Education)", size(medium)) ///
name(FI, replace)

*DEN
tw ///
(rcap propdiff_lb propdiff_ub mom_edu_comp, horizontal lcolor(black)) ///
(scatter mom_edu_comp propdiff, mcolor(black) msize(vsmall)) ///
if country=="Denmark", ///
legend(off) ///
yt("", ) ///
ylab(1 "Basic" 2 "      Upper Secondary" 3 "Bachelor's Degree" 4 "Master's/Doc. Degree") /// 13 characters without spaces
xlab(-0.03 (0.01) 0.03) ///
xt("Absolute Difference in the Proportion of Live Births between Observed vs. Counterfactual Composition") ///
xline(0) ///
title("{bf:Denmark} (Maternal Education)", size(medium)) ///
name(DEN, replace)

*SWEDEN
tw ///
(rcap propdiff_lb propdiff_ub mom_edu_comp, horizontal lcolor(black)) ///
(scatter mom_edu_comp propdiff, mcolor(black) msize(vsmall)) ///
if country=="Sweden", ///
legend(off) ///
yt("", ) ///
ylab(1 "Basic" 2 "      Upper Secondary" 3 "Bachelor's Degree" 4 "Master's/Doc. Degree" 5 "Unknown") /// 13 characters without spaces
xlab(-0.03 (0.01) 0.03) ///
xt("Absolute Difference in the Proportion of Live Births between Observed vs. Counterfactual Composition") ///
xline(0) ///
title("{bf:Sweden} (Maternal Education)", size(medium)) ///
name(SWE, replace)

*SOUTH AUSTRALIA
tw ///
(rcap propdiff_lb propdiff_ub area_deprivation_dec, horizontal lcolor(black)) ///
(scatter area_deprivation_dec propdiff, mcolor(black) msize(vsmall)) ///
if country=="Australia", ///
legend(off) ///
yt("", ) ///
ylab(1(1)10, val) ///
xlab(-0.03 (0.01) 0.03) ///
xt("Absolute Difference in the Proportion of Live Births between Observed vs. Counterfactual Composition") ///
xline(0) ///
title("{bf:South Australia} (Area Deprivation in Deciles)", size(medium)) ///
name(AUS, replace)






**# Bookmark #19

grc1leg2 AT BRA COL DEN ECU ENG FI MEX NET SCOT AUS ESP SWE US WAL , ///
col(3)  ///
plotregion(margin(zero)) imargin(zero) ///
xtob1title  ///
title("Difference between Observed and Counterfactual Composition for Alternative Socioeconomic Indicator" "of Live Births December 2020-December 2021", size(medsmall)) loff


graph export "$graph/Composition_all_SEC_$S_DATE.svg", replace height(2800) width(3000)


**# Bookmark #5
****15 panel figure for change in relative number of births along secondary SEC variable

*******************  COUNTRY PANEL RELATIVE CHANGE PLOT *************
*******************  COUNTRY PANEL RELATIVE CHANGE PLOT *************
*******************  COUNTRY PANEL RELATIVE CHANGE PLOT *************
* One forest with all groups by country = 12 panels


gen rel_count_diff=(n_births-cf_count)/(abs(cf_count))*100
gen rel_count_diff_lb=(n_births-cf_count_lb)/(abs(cf_count_lb))*100
gen rel_count_diff_ub=(n_births-cf_count_ub)/(abs(cf_count_ub))*100

*rename to make old code work
drop propdiff_lb propdiff_ub propdiff
rename rel_count_diff_lb propdiff_lb
rename rel_count_diff propdiff
rename rel_count_diff_ub propdiff_ub

* no unknown for visual
drop if mom_dad_edu_comp==4 & country!="Austria"
drop if mom_dad_edu_comp==6 & country=="Austria"
drop if area_deprivation==6
drop if hh_inc==6
drop if dad_edu_comp==4 & country=="United States"
drop if mom_edu_years==6 & country=="Brazil"
drop if mom_edu_comp==5 & country=="Sweden"

* AT
tw ///
(rcap propdiff_lb propdiff_ub mom_dad_edu_comp, horizontal lcolor(black)) ///
(scatter mom_dad_edu_comp propdiff, mcolor(black) msize(vsmall)) ///
if country=="Austria", ///
legend(off) ///
yt("", ) ///
ylab(1 "Compulsory" 2 "Apprenticeship" 3 "Techn. & Voc. School" 4 "Acad. Upper Second." 5 "Post-Second./Tert.") ///
xlab(-10(5)20) ///
xt("Relative Difference between Observed vs. Expected Number of Live Births") ///
xline(0) ///
title("{bf:Austria} (Highest of Parental Education)", size(medium)) ///
name(AT, replace)


* COL
tw ///
(rcap propdiff_lb propdiff_ub mom_dad_edu_comp, horizontal lcolor(black)) ///
(scatter mom_dad_edu_comp propdiff, mcolor(black) msize(vsmall)) ///
if country=="Colombia", ///
legend(off) ///
yt("", ) ///
ylab(1 " Prim./Lower Second." 2 "Upper Second." 3 "Post-Second./Tert." ) /// 21 characters long
xlab(-10(5)20) ///
xt("Absolute Difference in the Proportion of Live Births between Observed vs. Counterfactual Composition") ///
xline(0) ///
title("{bf:Colombia} (Highest of Parental Education)", size(medium)) ///
name(COL, replace)

* ESP
tw ///
(rcap propdiff_lb propdiff_ub mom_dad_edu_comp, horizontal lcolor(black)) ///
(scatter mom_dad_edu_comp propdiff, mcolor(black) msize(vsmall)) ///
if country=="Spain", ///
legend(off) ///
yt("", ) ///
ylab(1 " Prim./Lower Second." 2 "Upper Second." 3 "Post-Second./Tert." ) ///
xlab(-10(5)20) ///
xt("Absolute Difference in the Proportion of Live Births between Observed vs. Counterfactual Composition") ///
xline(0) ///
title("{bf:Spain} (Highest of Parental Education)", size(medium)) ///
name(ESP, replace)


* USA
tw ///
(rcap propdiff_lb propdiff_ub dad_edu_comp, horizontal lcolor(black)) ///
(scatter dad_edu_comp propdiff, mcolor(black) msize(vsmall)) ///
if country=="United States", ///
legend(off) ///
yt("", ) ///
ylab(1 "No Highschool" 2 "Highschool" 3 "    Post-Second./Tert." ) /// 18 characters without spaces
xlab(-10(5)20) ///
xt("Absolute Difference in the Proportion of Live Births between Observed vs. Counterfactual Composition") ///
xline(0) ///
title("{bf:United States} (Father's Education)", size(medium)) ///
name(US, replace)

*MEXICO
tw ///
(rcap propdiff_lb propdiff_ub mom_dad_edu_comp, horizontal lcolor(black)) ///
(scatter mom_dad_edu_comp propdiff, mcolor(black) msize(vsmall)) ///
if country=="Mexico", ///
legend(off) ///
yt("", ) ///
ylab(1 "Elementary" 2 "Lower Second." 3 "         Upper Second." ) /// 13 characters without spaces
xlab(-10(5)20) ///
xt("Absolute Difference in the Proportion of Live Births between Observed vs. Counterfactual Composition") ///
xline(0) ///
title("{bf:Mexico} (Highest of Parental Education)", size(medium)) ///
name(MEX, replace)



* BRA
tw ///
(rcap propdiff_lb propdiff_ub mom_edu_years, horizontal lcolor(black)) ///
(scatter mom_edu_years propdiff, mcolor(black) msize(vsmall)) ///
if country=="Brazil", ///
legend(off) ///
yt("", ) ///
ylab(1(1)5, val) ///
xlab(-10(5)20) ///
xt("Absolute Difference in the Proportion of Live Births between Observed vs. Counterfactual Composition") ///
xline(0) ///
title("{bf:Brazil} (Maternal Education in Years)", size(medium)) ///
name(BRA, replace)

* SCOT
tw ///
(rcap propdiff_lb propdiff_ub area_deprivation, horizontal lcolor(black)) ///
(scatter area_deprivation propdiff, mcolor(black) msize(vsmall)) ///
if country=="Scotland", ///
legend(off) ///
yt("", ) ///
ylab(1(1)5, val) ///
xlab(-10(5)20) ///
xt("Absolute Difference in the Proportion of Live Births between Observed vs. Counterfactual Composition") ///
xline(0) ///
title("{bf:Scotland} (Area Deprivation)", size(medium)) ///
name(SCOT, replace)


* ENG
tw ///
(rcap propdiff_lb propdiff_ub area_deprivation_10, horizontal lcolor(black)) ///
(scatter area_deprivation_10 propdiff, mcolor(black) msize(vsmall)) ///
if country=="England", ///
legend(off) ///
yt("", ) ///
ylab(1(1)10, val) ///
xlab(-10(5)20) ///
xt("Absolute Difference in the Proportion of Live Births between Observed vs. Counterfactual Composition") ///
xline(0) ///
title("{bf:England} (Area Deprivation in Deciles)", size(medium)) ///
name(ENG, replace)


* Wales
tw ///
(rcap propdiff_lb propdiff_ub area_deprivation_10, horizontal lcolor(black)) ///
(scatter area_deprivation_10 propdiff, mcolor(black) msize(vsmall)) ///
if country=="Wales", ///
legend(off) ///
yt("", ) ///
ylab(1(1)10, val) ///
xlab(-10(5)20) ///
xt("Absolute Difference in the Proportion of Live Births between Observed vs. Counterfactual Composition") ///
xline(0) ///
title("{bf:Wales} (Area Deprivation in Deciles)", size(medium)) ///
name(WAL, replace)


* ECUADOR************************
tw ///
(rcap propdiff_lb propdiff_ub area_deprivation, horizontal lcolor(black)) ///
(scatter area_deprivation propdiff, mcolor(black) msize(vsmall)) ///
if country=="Ecuador", ///
legend(off) ///
yt("", ) ///
ylab(1(1)5, val) ///
xlab(-10(5)20) ///
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
ylab(1(1)5, val) ///
xlab(-10(5)20) ///
xt("Absolute Difference in the Proportion of Live Births between Observed vs. Counterfactual Composition") ///
xline(0) ///
title("{bf:Netherlands} (Household Income)", size(medium)) ///
name(NET, replace)


*FI
tw ///
(rcap propdiff_lb propdiff_ub edu_mom_det, horizontal lcolor(black)) ///
(scatter edu_mom_det propdiff, mcolor(black) msize(vsmall)) ///
if country=="Finland", ///
legend(off) ///
yt("", ) ///
ylab(1 "Basic" 2 "      Upper Secondary" 3 "Bachelor's Degree" 4 "Master's/Doc. Degree") /// 13 characters without spaces
xlab(-10(5)20) ///
xt("Absolute Difference in the Proportion of Live Births between Observed vs. Counterfactual Composition") ///
xline(0) ///
title("{bf:Finland} (Maternal Education)", size(medium)) ///
name(FI, replace)


*DEN
tw ///
(rcap propdiff_lb propdiff_ub mom_edu_comp, horizontal lcolor(black)) ///
(scatter mom_edu_comp propdiff, mcolor(black) msize(vsmall)) ///
if country=="Denmark", ///
legend(off) ///
yt("", ) ///
ylab(1 "Basic" 2 "      Upper Secondary" 3 "Bachelor's Degree" 4 "Master's/Doc. Degree") /// 13 characters without spaces
xlab(-10(5)20) ///
xt("Absolute Difference in the Proportion of Live Births between Observed vs. Counterfactual Composition") ///
xline(0) ///
title("{bf:Denmark} (Maternal Education)", size(medium)) ///
name(DEN, replace)

*SWEDEN
tw ///
(rcap propdiff_lb propdiff_ub mom_edu_comp, horizontal lcolor(black)) ///
(scatter mom_edu_comp propdiff, mcolor(black) msize(vsmall)) ///
if country=="Sweden", ///
legend(off) ///
yt("", ) ///
ylab(1 "Basic" 2 "      Upper Secondary" 3 "Bachelor's Degree" 4 "Master's/Doc. Degree" ) /// 13 characters without spaces
xlab(-10(5)20) ///
xt("Absolute Difference in the Proportion of Live Births between Observed vs. Counterfactual Composition") ///
xline(0) ///
title("{bf:Sweden} (Maternal Education)", size(medium)) ///
name(SWE, replace)

*SOUTH AUSTRALIA
tw ///
(rcap propdiff_lb propdiff_ub area_deprivation_dec, horizontal lcolor(black)) ///
(scatter area_deprivation_dec propdiff, mcolor(black) msize(vsmall)) ///
if country=="Australia", ///
legend(off) ///
yt("", ) ///
ylab(1(1)10, val) ///
xlab(-10(5)20) ///
xt("Absolute Difference in the Proportion of Live Births between Observed vs. Counterfactual Composition") ///
xline(0) ///
title("{bf:South Australia} (Area Deprivation in Deciles)", size(medium)) ///
name(AUS, replace)




**# Bookmark #19

grc1leg2 AT BRA COL DEN ECU ENG FI MEX NET SCOT AUS ESP SWE US WAL , ///
col(3)  ///
plotregion(margin(zero)) imargin(zero) ///
xtob1title  ///
title("Relative Difference between Observed and Expected Number" "of Live Births December 2020-December 2021", size(medsmall)) loff


graph export "$graph/Rel_diff_SEC_$S_DATE.svg", replace height(2800) width(3000)




**# Bookmark #3
****12 panel figure for compositional change along maternal age

*----------------------- AGE COMPOSITION -----------------------
*----------------------- AGE COMPOSITION -----------------------
*----------------------- AGE COMPOSITION -----------------------


/*
10 panel figure for compositional change along maternal age

No age data for england and wales
*/
**# Bookmark #3

* One forest with all groups by country = 12 panels
clear all
use "$dta/AT_comp_diff_mom_age_cat",clear
append using "$dta/COL_comp_diff_mom_age_cat"
append using "$dta/ESP_comp_diff_mom_age_cat"
append using "$dta/MEX_comp_diff_mom_age_cat"
append using "$dta/US_comp_diff_mom_age_cat"

append using "$dta/BR_comp_diff_mom_age_cat"
append using "$dta/SCOT_comp_diff_mom_age_cat"
append using "$dta/ECU_comp_diff_mom_age_cat"

append using "$dta/FI_comp_diff_mom_age_cat"
append using "$dta/NET_comp_diff_mom_age_cat"
append using "$dta/DEN_comp_diff_mom_age_cat"
append using "$dta/SWE_comp_diff_mom_age_cat"
append using "$dta/AUS_comp_diff_mom_age_cat"


gen age3=mom_age_cat if country=="Netherlands"
replace mom_age_cat=. if country=="Netherlands"

label define agelab 1 "Maternal Age Under 20" 2 "20-24" 3 "25-29" 4 "30-34" 5 "35 and Above" 6 "Unknown"
label values mom_age_cat agelab

label define age3lab 1 "Maternal Age Under 26" 2 "26-35" 3 "Older than 35"
label values age3 age3lab


**# Bookmark #4

* AT
tw ///
(rcap propdiff_lb propdiff_ub mom_age_cat, horizontal lcolor(black)) ///
(scatter mom_age_cat propdiff, mcolor(black) msize(vsmall)) ///
if country=="Austria", ///
legend(off) ///
yt("", ) ///
ylab(,val) ///
xlab(-0.03 (0.01) 0.03) ///
xt("Absolute Difference in the Proportion of Live Births between Observed vs. Counterfactual Composition") ///
xline(0) ///
title("{bf:Austria} (Maternal Age)", size(medium)) ///
name(AT, replace)


* COL
tw ///
(rcap propdiff_lb propdiff_ub mom_age_cat, horizontal lcolor(black)) ///
(scatter mom_age_cat propdiff, mcolor(black) msize(vsmall)) ///
if country=="Colombia", ///
legend(off) ///
yt("", ) ///
ylab(,val) ///
xlab(-0.03 (0.01) 0.03) ///
xt("Absolute Difference in the Proportion of Live Births between Observed vs. Counterfactual Composition") ///
xline(0) ///
title("{bf:Colombia} (Maternal Age)", size(medium)) ///
name(COL, replace)

* ESP
tw ///
(rcap propdiff_lb propdiff_ub mom_age_cat, horizontal lcolor(black)) ///
(scatter mom_age_cat propdiff, mcolor(black) msize(vsmall)) ///
if country=="Spain", ///
legend(off) ///
yt("", ) ///
ylab(,val) ///
xlab(-0.03 (0.01) 0.03) ///
xt("Absolute Difference in the Proportion of Live Births between Observed vs. Counterfactual Composition") ///
xline(0) ///
title("{bf:Spain} (Maternal Age)", size(medium)) ///
name(ESP, replace)


* USA
tw ///
(rcap propdiff_lb propdiff_ub mom_age_cat, horizontal lcolor(black)) ///
(scatter mom_age_cat propdiff, mcolor(black) msize(vsmall)) ///
if country=="United States", ///
legend(off) ///
yt("", ) ///
ylab(,val) ///
xlab(-0.03 (0.01) 0.03) ///
xt("Absolute Difference in the Proportion of Live Births between Observed vs. Counterfactual Composition") ///
xline(0) ///
title("{bf:United States} (Maternal Age)", size(medium)) ///
name(US, replace)

*MEXICO
tw ///
(rcap propdiff_lb propdiff_ub mom_age_cat, horizontal lcolor(black)) ///
(scatter mom_age_cat propdiff, mcolor(black) msize(vsmall)) ///
if country=="Mexico", ///
legend(off) ///
yt("", ) ///
ylab(,val) ///
xlab(-0.03 (0.01) 0.03) ///
xt("Absolute Difference in the Proportion of Live Births between Observed vs. Counterfactual Composition") ///
xline(0) ///
title("{bf:Mexico} (Maternal Age)", size(medium)) ///
name(MEX, replace)



* BRA
tw ///
(rcap propdiff_lb propdiff_ub mom_age_cat, horizontal lcolor(black)) ///
(scatter mom_age_cat propdiff, mcolor(black) msize(vsmall)) ///
if country=="Brazil", ///
legend(off) ///
yt("", ) ///
ylab(,val) ///
xlab(-0.03 (0.01) 0.03) ///
xt("Absolute Difference in the Proportion of Live Births between Observed vs. Counterfactual Composition") ///
xline(0) ///
title("{bf:Brazil} (Maternal Age)", size(medium)) ///
name(BRA, replace)

* SCOT
tw ///
(rcap propdiff_lb propdiff_ub mom_age_cat, horizontal lcolor(black)) ///
(scatter mom_age_cat propdiff, mcolor(black) msize(vsmall)) ///
if country=="Scotland", ///
legend(off) ///
yt("", ) ///
ylab(,val) ///
xlab(-0.03 (0.01) 0.03) ///
xt("Absolute Difference in the Proportion of Live Births between Observed vs. Counterfactual Composition") ///
xline(0) ///
title("{bf:Scotland} (Maternal Age)", size(medium)) ///
name(SCOT, replace)




* ECUADOR************************
tw ///
(rcap propdiff_lb propdiff_ub mom_age_cat, horizontal lcolor(black)) ///
(scatter mom_age_cat propdiff, mcolor(black) msize(vsmall)) ///
if country=="Ecuador", ///
legend(off) ///
yt("", ) ///
ylab(,val) ///
xlab(-0.03 (0.01) 0.03) ///
xt("Absolute Difference in the Proportion of Live Births between Observed vs. Counterfactual Composition") ///
xline(0) ///
title("{bf:Ecuador} (Maternal Age)", size(medium)) ///
name(ECU, replace)

*Netherlands
tw ///
(rcap propdiff_lb propdiff_ub age3, horizontal lcolor(black)) ///
(scatter age3 propdiff, mcolor(black) msize(vsmall)) ///
if country=="Netherlands", ///
legend(off) ///
yt("", ) ///
ylab(1 2 3 ,val) ///
xlab(-0.03 (0.01) 0.03) ///
xt("Absolute Difference in the Proportion of Live Births between Observed vs. Counterfactual Composition") ///
xline(0) ///
title("{bf:Netherlands} (Maternal Age)", size(medium)) ///
name(NET, replace)


*FI
tw ///
(rcap propdiff_lb propdiff_ub mom_age_cat, horizontal lcolor(black)) ///
(scatter mom_age_cat propdiff, mcolor(black) msize(vsmall)) ///
if country=="Finland", ///
legend(off) ///
yt("", ) ///
ylab(,val) ///
xlab(-0.03 (0.01) 0.03) ///
xt("Absolute Difference in the Proportion of Live Births between Observed vs. Counterfactual Composition") ///
xline(0) ///
title("{bf:Finland} (Maternal Age)", size(medium)) ///
name(FI, replace)


*SWE
tw ///
(rcap propdiff_lb propdiff_ub mom_age_cat, horizontal lcolor(black)) ///
(scatter mom_age_cat propdiff, mcolor(black) msize(vsmall)) ///
if country=="Sweden", ///
legend(off) ///
yt("", ) ///
ylab(,val) ///
xlab(-0.03 (0.01) 0.03) ///
xt("Absolute Difference in the Proportion of Live Births between Observed vs. Counterfactual Composition") ///
xline(0) ///
title("{bf:Sweden} (Maternal Age)", size(medium)) ///
name(SWE, replace)

*DEN
tw ///
(rcap propdiff_lb propdiff_ub mom_age_cat, horizontal lcolor(black)) ///
(scatter mom_age_cat propdiff, mcolor(black) msize(vsmall)) ///
if country=="Denmark", ///
legend(off) ///
yt("", ) ///
ylab(,val) ///
xlab(-0.03 (0.01) 0.03) ///
xt("Absolute Difference in the Proportion of Live Births between Observed vs. Counterfactual Composition") ///
xline(0) ///
title("{bf:Denmark} (Maternal Age)", size(medium)) ///
name(DEN, replace)

*South Australia
tw ///
(rcap propdiff_lb propdiff_ub mom_age_cat, horizontal lcolor(black)) ///
(scatter mom_age_cat propdiff, mcolor(black) msize(vsmall)) ///
if country=="Australia", ///
legend(off) ///
yt("", ) ///
ylab(,val) ///
xlab(-0.03 (0.01) 0.03) ///
xt("Absolute Difference in the Proportion of Live Births between Observed vs. Counterfactual Composition") ///
xline(0) ///
title("{bf:South Australia} (Maternal Age)", size(medium)) ///
name(AUS, replace)



**# Bookmark #19

grc1leg2 AT BRA COL DEN ECU FI MEX NET SCOT AUS ESP SWE US  , ///
col(3)  ///
plotregion(margin(zero)) imargin(zero) ///
xtob1title  ///
title("Difference between Observed and Counterfactual Maternal Age Composition" "of Live Births December 2020-December 2021", size(medsmall)) loff


graph export "$graph/Composition_all_AGE_$S_DATE.svg", replace height(2800) width(3000)


**# Bookmark #6
****12 panel figure for change in relative number of births along maternal age
************** RELATIVE CHANGE IN NUMBER ************
************** RELATIVE CHANGE IN NUMBER ************
************** RELATIVE CHANGE IN NUMBER ************

gen rel_count_diff=(n_births-cf_count)/(abs(cf_count))*100
gen rel_count_diff_lb=(n_births-cf_count_lb)/(abs(cf_count_lb))*100
gen rel_count_diff_ub=(n_births-cf_count_ub)/(abs(cf_count_ub))*100

*rename to make old code work
drop propdiff_lb propdiff_ub propdiff
rename rel_count_diff_lb propdiff_lb
rename rel_count_diff propdiff
rename rel_count_diff_ub propdiff_ub

* drop unknown for visual
drop if mom_age_cat==6



* AT
tw ///
(rcap propdiff_lb propdiff_ub mom_age_cat, horizontal lcolor(black)) ///
(scatter mom_age_cat propdiff, mcolor(black) msize(vsmall)) ///
if country=="Austria", ///
legend(off) ///
yt("", ) ///
ylab(,val) ///
xlab(-15(5)15) ///
xt("Relative Difference between Observed vs. Expected Number of Live Births") ///
xline(0) ///
title("{bf:Austria} (Maternal Age)", size(medium)) ///
name(AT, replace)


* COL
tw ///
(rcap propdiff_lb propdiff_ub mom_age_cat, horizontal lcolor(black)) ///
(scatter mom_age_cat propdiff, mcolor(black) msize(vsmall)) ///
if country=="Colombia", ///
legend(off) ///
yt("", ) ///
ylab(,val) ///
xlab(-15(5)15) ///
xt("Absolute Difference in the Proportion of Live Births between Observed vs. Counterfactual Composition") ///
xline(0) ///
title("{bf:Colombia} (Maternal Age)", size(medium)) ///
name(COL, replace)

* ESP
tw ///
(rcap propdiff_lb propdiff_ub mom_age_cat, horizontal lcolor(black)) ///
(scatter mom_age_cat propdiff, mcolor(black) msize(vsmall)) ///
if country=="Spain", ///
legend(off) ///
yt("", ) ///
ylab(,val) ///
xlab(-15(5)15) ///
xt("Absolute Difference in the Proportion of Live Births between Observed vs. Counterfactual Composition") ///
xline(0) ///
title("{bf:Spain} (Maternal Age)", size(medium)) ///
name(ESP, replace)


* USA
tw ///
(rcap propdiff_lb propdiff_ub mom_age_cat, horizontal lcolor(black)) ///
(scatter mom_age_cat propdiff, mcolor(black) msize(vsmall)) ///
if country=="United States", ///
legend(off) ///
yt("", ) ///
ylab(,val) ///
xlab(-15(5)15) ///
xt("Absolute Difference in the Proportion of Live Births between Observed vs. Counterfactual Composition") ///
xline(0) ///
title("{bf:United States} (Maternal Age)", size(medium)) ///
name(US, replace)

*MEXICO
tw ///
(rcap propdiff_lb propdiff_ub mom_age_cat, horizontal lcolor(black)) ///
(scatter mom_age_cat propdiff, mcolor(black) msize(vsmall)) ///
if country=="Mexico", ///
legend(off) ///
yt("", ) ///
ylab(,val) ///
xlab(-15(5)15) ///
xt("Absolute Difference in the Proportion of Live Births between Observed vs. Counterfactual Composition") ///
xline(0) ///
title("{bf:Mexico} (Maternal Age)", size(medium)) ///
name(MEX, replace)



* BRA
tw ///
(rcap propdiff_lb propdiff_ub mom_age_cat, horizontal lcolor(black)) ///
(scatter mom_age_cat propdiff, mcolor(black) msize(vsmall)) ///
if country=="Brazil", ///
legend(off) ///
yt("", ) ///
ylab(,val) ///
xlab(-15(5)15) ///
xt("Absolute Difference in the Proportion of Live Births between Observed vs. Counterfactual Composition") ///
xline(0) ///
title("{bf:Brazil} (Maternal Age)", size(medium)) ///
name(BRA, replace)

* SCOT
tw ///
(rcap propdiff_lb propdiff_ub mom_age_cat, horizontal lcolor(black)) ///
(scatter mom_age_cat propdiff, mcolor(black) msize(vsmall)) ///
if country=="Scotland", ///
legend(off) ///
yt("", ) ///
ylab(,val) ///
xlab(-15(5)15) ///
xt("Absolute Difference in the Proportion of Live Births between Observed vs. Counterfactual Composition") ///
xline(0) ///
title("{bf:Scotland} (Maternal Age)", size(medium)) ///
name(SCOT, replace)




* ECUADOR************************
tw ///
(rcap propdiff_lb propdiff_ub mom_age_cat, horizontal lcolor(black)) ///
(scatter mom_age_cat propdiff, mcolor(black) msize(vsmall)) ///
if country=="Ecuador", ///
legend(off) ///
yt("", ) ///
ylab(,val) ///
xlab(-15(5)15) ///
xt("Absolute Difference in the Proportion of Live Births between Observed vs. Counterfactual Composition") ///
xline(0) ///
title("{bf:Ecuador} (Maternal Age)", size(medium)) ///
name(ECU, replace)

*Netherlands
tw ///
(rcap propdiff_lb propdiff_ub age3, horizontal lcolor(black)) ///
(scatter age3 propdiff, mcolor(black) msize(vsmall)) ///
if country=="Netherlands", ///
legend(off) ///
yt("", ) ///
ylab(1 2 3 ,val) ///
xlab(-15(5)15) ///
xt("Absolute Difference in the Proportion of Live Births between Observed vs. Counterfactual Composition") ///
xline(0) ///
title("{bf:Netherlands} (Maternal Age)", size(medium)) ///
name(NET, replace)


*FI
tw ///
(rcap propdiff_lb propdiff_ub mom_age_cat, horizontal lcolor(black)) ///
(scatter mom_age_cat propdiff, mcolor(black) msize(vsmall)) ///
if country=="Finland", ///
legend(off) ///
yt("", ) ///
ylab(,val) ///
xlab(-15(5)15) ///
xt("Absolute Difference in the Proportion of Live Births between Observed vs. Counterfactual Composition") ///
xline(0) ///
title("{bf:Finland} (Maternal Age)", size(medium)) ///
name(FI, replace)

*SWE
tw ///
(rcap propdiff_lb propdiff_ub mom_age_cat, horizontal lcolor(black)) ///
(scatter mom_age_cat propdiff, mcolor(black) msize(vsmall)) ///
if country=="Sweden", ///
legend(off) ///
yt("", ) ///
ylab(,val) ///
xlab(-15(5)15) ///
xt("Absolute Difference in the Proportion of Live Births between Observed vs. Counterfactual Composition") ///
xline(0) ///
title("{bf:Sweden} (Maternal Age)", size(medium)) ///
name(SWE, replace)

*DEN
tw ///
(rcap propdiff_lb propdiff_ub mom_age_cat, horizontal lcolor(black)) ///
(scatter mom_age_cat propdiff, mcolor(black) msize(vsmall)) ///
if country=="Denmark", ///
legend(off) ///
yt("", ) ///
ylab(,val) ///
xlab(-15(5)15) ///
xt("Absolute Difference in the Proportion of Live Births between Observed vs. Counterfactual Composition") ///
xline(0) ///
title("{bf:Denmark} (Maternal Age)", size(medium)) ///
name(DEN, replace)

*South Australia
tw ///
(rcap propdiff_lb propdiff_ub mom_age_cat, horizontal lcolor(black)) ///
(scatter mom_age_cat propdiff, mcolor(black) msize(vsmall)) ///
if country=="Australia", ///
legend(off) ///
yt("", ) ///
ylab(,val) ///
xlab(-15(5)15) ///
xt("Absolute Difference in the Proportion of Live Births between Observed vs. Counterfactual Composition") ///
xline(0) ///
title("{bf:South Australia} (Maternal Age)", size(medium)) ///
name(AUS, replace)


**# Bookmark #19

grc1leg2 AT BRA COL DEN ECU FI MEX NET SCOT AUS ESP SWE US  , ///
col(3)  ///
plotregion(margin(zero)) imargin(zero) ///
xtob1title  ///
title("Relative Difference between Observed and Expected Number" "of Live Births December 2020-December 2021", size(medsmall)) loff


graph export "$graph/Rel_diff_all_AGE_$S_DATE.svg", replace height(2800) width(3000)



**# Bookmark #4
****12 panel figure for compositional change along parity

*----------------------- PARITY COMPOSITION -----------------------
*----------------------- PARITY COMPOSITION -----------------------
*----------------------- PARITY COMPOSITION -----------------------

**** ABSOLUTE DIFFERENCE

/*
9 panel figure for compositional change along parity

No age data for england and wales and Scotland
*/
**# Bookmark #3

* One forest with all groups by country = 12 panels
clear all
use "$dta/AT_comp_diff_parity",clear
append using "$dta/COL_comp_diff_parity"
append using "$dta/ESP_comp_diff_parity"
append using "$dta/MEX_comp_diff_parity"
append using "$dta/US_comp_diff_parity"

append using "$dta/BR_comp_diff_parity"
append using "$dta/ECU_comp_diff_liv_child"

append using "$dta/FI_comp_diff_parity"
append using "$dta/NET_comp_diff_parity"
append using "$dta/DEN_comp_diff_parity"

gen firstborn=parity if country=="Netherlands"
replace parity=. if country=="Netherlands"
replace parity = liv_child if country=="Ecuador"

replace parity = parity +1 if country=="Spain" | country=="Finland"
label define parlab 1 "Parity 0" 2 "1" 3 "2" 4 "3" 5 "4 or more" 6 "Unknown"
label values parity parlab

label define fborn 0 "Parity 0" 1 "1 or more" 
label values firstborn fborn



**# Bookmark #4
* AT
tw ///
(rcap propdiff_lb propdiff_ub parity, horizontal lcolor(black)) ///
(scatter parity propdiff, mcolor(black) msize(vsmall)) ///
if country=="Austria", ///
legend(off) ///
yt("", ) ///
ylab(,val) ///
xlab(-0.03 (0.01) 0.03) ///
xt("Absolute Difference in the Proportion of Live Births between Observed vs. Counterfactual Composition") ///
xline(0) ///
title("{bf:Austria} (Parity)", size(medium)) ///
name(AT, replace)


* COL
tw ///
(rcap propdiff_lb propdiff_ub parity, horizontal lcolor(black)) ///
(scatter parity propdiff, mcolor(black) msize(vsmall)) ///
if country=="Colombia", ///
legend(off) ///
yt("", ) ///
ylab(,val) ///
xlab(-0.03 (0.01) 0.03) ///
xt("Absolute Difference in the Proportion of Live Births between Observed vs. Counterfactual Composition") ///
xline(0) ///
title("{bf:Colombia} (Parity)", size(medium)) ///
name(COL, replace)

* ESP
tw ///
(rcap propdiff_lb propdiff_ub parity, horizontal lcolor(black)) ///
(scatter parity propdiff, mcolor(black) msize(vsmall)) ///
if country=="Spain", ///
legend(off) ///
yt("", ) ///
ylab(,val) ///
xlab(-0.03 (0.01) 0.03) ///
xt("Absolute Difference in the Proportion of Live Births between Observed vs. Counterfactual Composition") ///
xline(0) ///
title("{bf:Spain} (Parity)", size(medium)) ///
name(ESP, replace)


* USA
tw ///
(rcap propdiff_lb propdiff_ub parity, horizontal lcolor(black)) ///
(scatter parity propdiff, mcolor(black) msize(vsmall)) ///
if country=="United States", ///
legend(off) ///
yt("", ) ///
ylab(,val) ///
xlab(-0.03 (0.01) 0.03) ///
xt("Absolute Difference in the Proportion of Live Births between Observed vs. Counterfactual Composition") ///
xline(0) ///
title("{bf:United States} (Parity)", size(medium)) ///
name(US, replace)

*MEXICO
tw ///
(rcap propdiff_lb propdiff_ub parity, horizontal lcolor(black)) ///
(scatter parity propdiff, mcolor(black) msize(vsmall)) ///
if country=="Mexico", ///
legend(off) ///
yt("", ) ///
ylab(,val) ///
xlab(-0.03 (0.01) 0.03) ///
xt("Absolute Difference in the Proportion of Live Births between Observed vs. Counterfactual Composition") ///
xline(0) ///
title("{bf:Mexico} (Parity)", size(medium)) ///
name(MEX, replace)



* BRA
tw ///
(rcap propdiff_lb propdiff_ub parity, horizontal lcolor(black)) ///
(scatter parity propdiff, mcolor(black) msize(vsmall)) ///
if country=="Brazil", ///
legend(off) ///
yt("", ) ///
ylab(,val) ///
xlab(-0.03 (0.01) 0.03) ///
xt("Absolute Difference in the Proportion of Live Births between Observed vs. Counterfactual Composition") ///
xline(0) ///
title("{bf:Brazil} (Parity)", size(medium)) ///
name(BRA, replace)



* ECUADOR************************
tw ///
(rcap propdiff_lb propdiff_ub parity, horizontal lcolor(black)) ///
(scatter parity propdiff, mcolor(black) msize(vsmall)) ///
if country=="Ecuador", ///
legend(off) ///
yt("", ) ///
ylab(,val) ///
xlab(-0.03 (0.01) 0.03) ///
xt("Absolute Difference in the Proportion of Live Births between Observed vs. Counterfactual Composition") ///
xline(0) ///
title("{bf:Ecuador} (Parity)", size(medium)) ///
name(ECU, replace)

*Netherlands
tw ///
(rcap propdiff_lb propdiff_ub firstborn, horizontal lcolor(black)) ///
(scatter firstborn propdiff, mcolor(black) msize(vsmall)) ///
if country=="Netherlands", ///
legend(off) ///
yt("", ) ///
ylab(0 1 ,val) ///
xlab(-0.03 (0.01) 0.03) ///
xt("Absolute Difference in the Proportion of Live Births between Observed vs. Counterfactual Composition") ///
xline(0) ///
title("{bf:Netherlands} (Parity)", size(medium)) ///
name(NET, replace)


*FI
tw ///
(rcap propdiff_lb propdiff_ub parity, horizontal lcolor(black)) ///
(scatter parity propdiff, mcolor(black) msize(vsmall)) ///
if country=="Finland", ///
legend(off) ///
yt("", ) ///
ylab(,val) ///
xlab(-0.03 (0.01) 0.03) ///
xt("Absolute Difference in the Proportion of Live Births between Observed vs. Counterfactual Composition") ///
xline(0) ///
title("{bf:Finland} (Parity)", size(medium)) ///
name(FI, replace)


*DEN
tw ///
(rcap propdiff_lb propdiff_ub parity, horizontal lcolor(black)) ///
(scatter parity propdiff, mcolor(black) msize(vsmall)) ///
if country=="Denmark", ///
legend(off) ///
yt("", ) ///
ylab(,val) ///
xlab(-0.03 (0.01) 0.03) ///
xt("Absolute Difference in the Proportion of Live Births between Observed vs. Counterfactual Composition") ///
xline(0) ///
title("{bf:Denmark} (Parity)", size(medium)) ///
name(DEN, replace)



**# Bookmark #19

grc1leg2 AT BRA COL DEN ECU FI MEX NET  ESP US  , ///
col(3)  ///
plotregion(margin(zero)) imargin(zero) ///
xtob1title  ///
title("Difference between Observed and Counterfactual Parity Composition" "of Live Births December 2020-December 2021", size(medsmall)) loff


graph export "$graph/Composition_all_Parity_$S_DATE.svg", replace height(2800) width(3000)





**# Bookmark #7
****12 panel figure for change in relative number of births along parity


********** RELATIVE DIFFERENCE *************
********** RELATIVE DIFFERENCE *************
********** RELATIVE DIFFERENCE *************
********** RELATIVE DIFFERENCE *************


gen rel_count_diff=(n_births-cf_count)/(abs(cf_count))*100
gen rel_count_diff_lb=(n_births-cf_count_lb)/(abs(cf_count_lb))*100
gen rel_count_diff_ub=(n_births-cf_count_ub)/(abs(cf_count_ub))*100

*rename to make old code work
drop propdiff_lb propdiff_ub propdiff
rename rel_count_diff_lb propdiff_lb
rename rel_count_diff propdiff
rename rel_count_diff_ub propdiff_ub

* drop unknown for visual
drop if parity==6


**# Bookmark #4
tw ///
(rcap propdiff_lb propdiff_ub parity, horizontal lcolor(black)) ///
(scatter parity propdiff, mcolor(black) msize(vsmall)) ///
if country=="Austria", ///
legend(off) ///
yt("", ) ///
ylab(,val) ///
xlab(-10(5)25) ///
xt("Relative Difference between Observed vs. Expected Number of Live Births") ///
xline(0) ///
title("{bf:Austria} (Parity)", size(medium)) ///
name(AT, replace)


* COL
tw ///
(rcap propdiff_lb propdiff_ub parity, horizontal lcolor(black)) ///
(scatter parity propdiff, mcolor(black) msize(vsmall)) ///
if country=="Colombia", ///
legend(off) ///
yt("", ) ///
ylab(,val) ///
xlab(-10(5)25) ///
xt("Absolute Difference in the Proportion of Live Births between Observed vs. Counterfactual Composition") ///
xline(0) ///
title("{bf:Colombia} (Parity)", size(medium)) ///
name(COL, replace)

* ESP
tw ///
(rcap propdiff_lb propdiff_ub parity, horizontal lcolor(black)) ///
(scatter parity propdiff, mcolor(black) msize(vsmall)) ///
if country=="Spain", ///
legend(off) ///
yt("", ) ///
ylab(,val) ///
xlab(-10(5)25) ///
xt("Absolute Difference in the Proportion of Live Births between Observed vs. Counterfactual Composition") ///
xline(0) ///
title("{bf:Spain} (Parity)", size(medium)) ///
name(ESP, replace)


* USA
tw ///
(rcap propdiff_lb propdiff_ub parity, horizontal lcolor(black)) ///
(scatter parity propdiff, mcolor(black) msize(vsmall)) ///
if country=="United States", ///
legend(off) ///
yt("", ) ///
ylab(,val) ///
xlab(-10(5)25) ///
xt("Absolute Difference in the Proportion of Live Births between Observed vs. Counterfactual Composition") ///
xline(0) ///
title("{bf:United States} (Parity)", size(medium)) ///
name(US, replace)

*MEXICO
tw ///
(rcap propdiff_lb propdiff_ub parity, horizontal lcolor(black)) ///
(scatter parity propdiff, mcolor(black) msize(vsmall)) ///
if country=="Mexico", ///
legend(off) ///
yt("", ) ///
ylab(,val) ///
xlab(-10(5)25) ///
xt("Absolute Difference in the Proportion of Live Births between Observed vs. Counterfactual Composition") ///
xline(0) ///
title("{bf:Mexico} (Parity)", size(medium)) ///
name(MEX, replace)



* BRA
tw ///
(rcap propdiff_lb propdiff_ub parity, horizontal lcolor(black)) ///
(scatter parity propdiff, mcolor(black) msize(vsmall)) ///
if country=="Brazil", ///
legend(off) ///
yt("", ) ///
ylab(,val) ///
xlab(-10(5)25) ///
xt("Absolute Difference in the Proportion of Live Births between Observed vs. Counterfactual Composition") ///
xline(0) ///
title("{bf:Brazil} (Parity)", size(medium)) ///
name(BRA, replace)



* ECUADOR************************
tw ///
(rcap propdiff_lb propdiff_ub parity, horizontal lcolor(black)) ///
(scatter parity propdiff, mcolor(black) msize(vsmall)) ///
if country=="Ecuador", ///
legend(off) ///
yt("", ) ///
ylab(,val) ///
xlab(-10(5)25) ///
xt("Absolute Difference in the Proportion of Live Births between Observed vs. Counterfactual Composition") ///
xline(0) ///
title("{bf:Ecuador} (Parity)", size(medium)) ///
name(ECU, replace)

*Netherlands
tw ///
(rcap propdiff_lb propdiff_ub firstborn, horizontal lcolor(black)) ///
(scatter firstborn propdiff, mcolor(black) msize(vsmall)) ///
if country=="Netherlands", ///
legend(off) ///
yt("", ) ///
ylab(0 1 ,val) ///
xlab(-10(5)25) ///
xt("Absolute Difference in the Proportion of Live Births between Observed vs. Counterfactual Composition") ///
xline(0) ///
title("{bf:Netherlands} (Parity)", size(medium)) ///
name(NET, replace)


*FI
tw ///
(rcap propdiff_lb propdiff_ub parity, horizontal lcolor(black)) ///
(scatter parity propdiff, mcolor(black) msize(vsmall)) ///
if country=="Finland", ///
legend(off) ///
yt("", ) ///
ylab(,val) ///
xlab(-10(5)25) ///
xt("Absolute Difference in the Proportion of Live Births between Observed vs. Counterfactual Composition") ///
xline(0) ///
title("{bf:Finland} (Parity)", size(medium)) ///
name(FI, replace)

tw ///
(rcap propdiff_lb propdiff_ub parity, horizontal lcolor(black)) ///
(scatter parity propdiff, mcolor(black) msize(vsmall)) ///
if country=="Denmark", ///
legend(off) ///
yt("", ) ///
ylab(,val) ///
xlab(-10(5)25) ///
xt("Absolute Difference in the Proportion of Live Births between Observed vs. Counterfactual Composition") ///
xline(0) ///
title("{bf:Denmark} (Parity)", size(medium)) ///
name(DEN, replace)



**# Bookmark #19

grc1leg2 AT BRA COL DEN ECU FI MEX NET  ESP US  , ///
col(3)  ///
plotregion(margin(zero)) imargin(zero) ///
xtob1title  ///
title("Relative Difference between Observed and Expected Number" "of Live Births December 2020-December 2021", size(medsmall)) loff
graph export "$graph/Rel_diff_all_Parity_$S_DATE.svg", replace height(2800) width(3000)











**# Bookmark #8
**************** COUNTRY PROFILES ***********************
**************** COUNTRY PROFILES ***********************
**************** COUNTRY PROFILES ***********************
**************** COUNTRY PROFILES ***********************

/*
Panel figure for counts:
- all categories of main SEC variable
- more detailed country-specific measure of SEC variable (EDCUATION)
- paternal education
- highest of maternal and paternal education where paternal is available
- age groups <20, 20-24, 25-29, 30-34, >34
- parity or # living children ... 0,1,2,3,4 or more. especially to see difference between number of first born

Table: 
Country-specific table with uncertainty estimates


*/



**# Bookmark #1

*************************** AUSTRIA AUSTRIA AUSTRIA ******************************
*************************** AUSTRIA AUSTRIA AUSTRIA ******************************
*************************** AUSTRIA AUSTRIA AUSTRIA ******************************
*************************** AUSTRIA AUSTRIA AUSTRIA ******************************
****** MAIN SEC variable, all categories
****** MAIN SEC variable, all categories

clear all
use "$dta/AT_ts", clear
global ts_data "$dta/AT_ts"
global variable "mom_edu_comp" // determine group
su $variable, 
global max=r(max)
global min=r(min)
global min_1=r(min)+1
di $max
di $min
di $min_1

global trend "mdate" // insert variable names
global season "month_nr"
global tw_tm "tm"
global cutoff "2020m12"

****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=$min/$max {
use "$ts_data.dta", clear
keep if $variable==`i'
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season , irr

quietly: margins, ///
at($trend=(660(1)743) loco=(0)) ///
at($trend=(731(1)743) loco=(1)) ///
predict(n) ///
saving("$dta/margins_ts_`i'.dta", replace)

preserve 
use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin lin_count
keep lin_count $trend loco
drop if loco==0 & $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/lin_pred_`i'.dta",replace

use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin cf_lin_count
keep cf_lin_count $trend loco
keep if loco==0 &  $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/cf_lin_pred_`i'.dta",replace
restore

}

use "$dta/lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/lin_pred_`i'"
}
save "$dta/lin_pred_all", replace

use "$dta/cf_lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/cf_lin_pred_`i'"
}
save "$dta/cf_lin_pred_all", replace


use "$ts_data", clear
merge 1:1 $trend $variable using "$dta/lin_pred_all", nogen
merge 1:1 $trend $variable using "$dta/cf_lin_pred_all", nogen

forval i=$min/$max {
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season if $variable==`i', irr
predict pred_count_`i' if $variable==`i'
}
gen pred_count=pred_count_$min
forval i=$min_1/$max{
	replace pred_count=pred_count_`i' if pred_count==.
}
drop pred_count_$min - pred_count_$max
*PLOT IT
forvalues i=$min/$max {
  local v : label ($variable) `i'
   display "`i' is `v'"
   }

local forlab: value label $variable
forvalues i = $min/$max {
	local label: label `forlab' `i'
	di "`label'" 

tw ///
(line pred_count $trend if $variable==`i', lwidth(thin) lcolor(gs10)) ///
(line lin_count $trend if loco==0 & $variable==`i', lwidth(medium) lcolor(black)) ///
(line cf_lin_count $trend if loco==1 & $variable==`i', lpattern(shortdash) lwidth(medium) lcolor(black)) ///
(line lin_count $trend if loco==1 & $variable==`i', lpattern(solid) lwidth(medium) lcolor(black)) ///
(scatter n_births $trend if $variable==`i', msize(vsmall) mcolor(ebblue%60) msym(o)) ///
, ///
xline(731, lpattern(solid) lcolor(red) lwidth(vthin)) ///
xt("Month of Birth") ///
xlab(660(24)731, ) ///
ylab(, angle(h)) ///
yt("Number of Live Births") ///
legend(order(5 "Observed" 1 "Fitted" 2 "Deseasonalised Fitted" 3 "Deseasonalised Expected") row(1)) ///
title("{bf:`label'}", size(medsmall)) ///
plotregion(lcolor(black)) ///
name(C`i', replace) ///
scheme(white_tableau)

}

*combine plots
grc1leg2 C1 C2 C3 C4 C5 C6, ///
legendfrom(C1) ///
position(6) lyoffset(0) lxoffset(0) ///
legscale(*1) plotregion(margin(zero)) imargin(tiny) ///
xtob1title ytol1title ///
title("Austria, Maternal Education", size(medsmall)) ///
scheme(white_tableau)

graph export "$graph/AT_mom_edu_comp_$S_DATE.png", replace


**# Bookmark #15

***** MORE DETAILED EDUCATION ****
***** MORE DETAILED EDUCATION ****
***** MORE DETAILED EDUCATION ****

clear all
use "C:\Users\moritzob\OneDrive - University of Helsinki\postdoc life helsinki\LoCo-effect\LoCo-effect Austria\dta\Austria_births_2015.dta", clear

global variable "mom_edu" // determine group
su $variable, 
global max=r(max)
global min=r(min)
global min_1=r(min)+1
di $max
di $min
di $min_1

global trend "mdate" // insert variable names
global season "month_nr"
global tw_tm "tm"
global cutoff "2020m12"

*create ts_data
collapse loco $season (count) n_births= mom_age_cat, by($trend $variable)
save "$dta/AT_ts_$variable", replace
global ts_data "$dta/AT_ts_$variable"


****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=$min/$max {
use "$ts_data.dta", clear
keep if $variable==`i'
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season , irr

quietly: margins, ///
at($trend=(660(1)743) loco=(0)) ///
at($trend=(731(1)743) loco=(1)) ///
predict(n) ///
saving("$dta/margins_ts_`i'.dta", replace)

preserve 
use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin lin_count
keep lin_count $trend loco
drop if loco==0 & $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/lin_pred_`i'.dta",replace

use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin cf_lin_count
keep cf_lin_count $trend loco
keep if loco==0 &  $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/cf_lin_pred_`i'.dta",replace
restore

}

use "$dta/lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/lin_pred_`i'"
}
save "$dta/lin_pred_all", replace

use "$dta/cf_lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/cf_lin_pred_`i'"
}
save "$dta/cf_lin_pred_all", replace


use "$ts_data", clear
merge 1:1 $trend $variable using "$dta/lin_pred_all", nogen
merge 1:1 $trend $variable using "$dta/cf_lin_pred_all", nogen

forval i=$min/$max {
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season if $variable==`i', irr
predict pred_count_`i' if $variable==`i'
}
gen pred_count=pred_count_$min
forval i=$min_1/$max{
	replace pred_count=pred_count_`i' if pred_count==.
}
drop pred_count_$min - pred_count_$max
*PLOT IT
forvalues i=$min/$max {
  local v : label ($variable) `i'
   display "`i' is `v'"
   }

local forlab: value label $variable
forvalues i = $min/$max {
	local label: label `forlab' `i'
	di "`label'" 

tw ///
(line pred_count $trend if $variable==`i', lwidth(thin) lcolor(gs10)) ///
(line lin_count $trend if loco==0 & $variable==`i', lwidth(medium) lcolor(black)) ///
(line cf_lin_count $trend if loco==1 & $variable==`i', lpattern(shortdash) lwidth(medium) lcolor(black)) ///
(line lin_count $trend if loco==1 & $variable==`i', lpattern(solid) lwidth(medium) lcolor(black)) ///
(scatter n_births $trend if $variable==`i', msize(vsmall) mcolor(ebblue%60) msym(o)) ///
, ///
xline(731, lpattern(solid) lcolor(red) lwidth(vthin)) ///
xt("Month of Birth") ///
xlab(660(24)731, ) ///
ylab(, angle(h)) ///
yt("Number of Live Births") ///
legend(order(5 "Observed" 1 "Fitted" 2 "Deseasonalised Fitted" 3 "Deseasonalised Expected") row(1)) ///
title("{bf:`label'}", size(medsmall)) ///
plotregion(lcolor(black)) ///
name(C`i', replace) ///
scheme(white_tableau)

}

*combine plots
grc1leg2 C1 C2 C3 C4 C5 C6 C7 C8 C9, ///
legendfrom(C1) ///
position(6) lyoffset(0) lxoffset(0) ///
legscale(*1) plotregion(margin(zero)) imargin(tiny) ///
xtob1title ytol1title ///
title("Austria, Maternal Education", size(medsmall)) ///
scheme(white_tableau)

graph export "$graph/AT_mom_edu_det_$S_DATE.svg", replace


**# Bookmark #16

**** HIGHEST EDU MOM OR DAD***
**** HIGHEST EDU MOM OR DAD***
**** HIGHEST EDU MOM OR DAD***

clear all
use "C:\Users\moritzob\OneDrive - University of Helsinki\postdoc life helsinki\LoCo-effect\LoCo-effect Austria\dta\Austria_births_2015.dta", clear
tab mom_edu dad_edu,m
tab mom_edu_comp,m 
tab dad_edu_comp,m 
tab mom_dad_edu_comp,m
tab mom_edu_comp,m

global variable "mom_dad_edu_comp" // determine group
su $variable, 
global max=r(max)
global min=r(min)
global min_1=r(min)+1
di $max
di $min
di $min_1

global trend "mdate" // insert variable names
global season "month_nr"
global tw_tm "tm"
global cutoff "2020m12"

*create ts_data
collapse loco $season (count) n_births= mom_age_cat, by($trend $variable)
save "$dta/AT_ts_$variable", replace
global ts_data "$dta/AT_ts_$variable"


****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=$min/$max {
use "$ts_data.dta", clear
keep if $variable==`i'
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season , irr

quietly: margins, ///
at($trend=(660(1)743) loco=(0)) ///
at($trend=(731(1)743) loco=(1)) ///
predict(n) ///
saving("$dta/margins_ts_`i'.dta", replace)

preserve 
use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin lin_count
keep lin_count $trend loco
drop if loco==0 & $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/lin_pred_`i'.dta",replace

use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin cf_lin_count
keep cf_lin_count $trend loco
keep if loco==0 &  $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/cf_lin_pred_`i'.dta",replace
restore

}

use "$dta/lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/lin_pred_`i'"
}
save "$dta/lin_pred_all", replace

use "$dta/cf_lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/cf_lin_pred_`i'"
}
save "$dta/cf_lin_pred_all", replace


use "$ts_data", clear
merge 1:1 $trend $variable using "$dta/lin_pred_all", nogen
merge 1:1 $trend $variable using "$dta/cf_lin_pred_all", nogen

forval i=$min/$max {
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season if $variable==`i', irr
predict pred_count_`i' if $variable==`i'
}
gen pred_count=pred_count_$min
forval i=$min_1/$max{
	replace pred_count=pred_count_`i' if pred_count==.
}
drop pred_count_$min - pred_count_$max
*PLOT IT
forvalues i=$min/$max {
  local v : label ($variable) `i'
   display "`i' is `v'"
   }

local forlab: value label $variable
forvalues i = $min/$max {
	local label: label `forlab' `i'
	di "`label'" 

tw ///
(line pred_count $trend if $variable==`i', lwidth(thin) lcolor(gs10)) ///
(line lin_count $trend if loco==0 & $variable==`i', lwidth(medium) lcolor(black)) ///
(line cf_lin_count $trend if loco==1 & $variable==`i', lpattern(shortdash) lwidth(medium) lcolor(black)) ///
(line lin_count $trend if loco==1 & $variable==`i', lpattern(solid) lwidth(medium) lcolor(black)) ///
(scatter n_births $trend if $variable==`i', msize(vsmall) mcolor(ebblue%60) msym(o)) ///
, ///
xline(731, lpattern(solid) lcolor(red) lwidth(vthin)) ///
xt("Month of Birth") ///
xlab(660(24)731, ) ///
ylab(, angle(h)) ///
yt("Number of Live Births") ///
legend(order(5 "Observed" 1 "Fitted" 2 "Deseasonalised Fitted" 3 "Deseasonalised Expected") row(1)) ///
title("{bf:`label'}", size(medsmall)) ///
plotregion(lcolor(black)) ///
name(C`i', replace) ///
scheme(white_tableau)

}

*combine plots
grc1leg2 C1 C2 C3 C4 C5 C6 , ///
legendfrom(C1) ///
position(6) lyoffset(0) lxoffset(0) ///
legscale(*1) plotregion(margin(zero)) imargin(tiny) ///
xtob1title ytol1title ///
title("Austria, Highest of Parental Education", size(medsmall)) ///
scheme(white_tableau)

graph export "$graph/AT_mom_dad_edu_comp_$S_DATE.svg", replace



**# Bookmark #18

*** AGE ********
*** AGE ********
*** AGE ********

clear all
use "C:\Users\moritzob\OneDrive - University of Helsinki\postdoc life helsinki\LoCo-effect\LoCo-effect Austria\dta\Austria_births_2015.dta", clear

tab mom_age_cat,m

global variable "mom_age_cat" // determine group
su $variable, 
global max=r(max)
global min=r(min)
global min_1=r(min)+1
di $max
di $min
di $min_1

global trend "mdate" // insert variable names
global season "month_nr"
global tw_tm "tm"
global cutoff "2020m12"

*create ts_data
collapse loco $season (count) n_births= year, by($trend $variable)
save "$dta/AT_ts_$variable", replace
global ts_data "$dta/AT_ts_$variable"


****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=$min/$max {
use "$ts_data.dta", clear
keep if $variable==`i'
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season , irr

quietly: margins, ///
at($trend=(660(1)743) loco=(0)) ///
at($trend=(731(1)743) loco=(1)) ///
predict(n) ///
saving("$dta/margins_ts_`i'.dta", replace)

preserve 
use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin lin_count
keep lin_count $trend loco
drop if loco==0 & $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/lin_pred_`i'.dta",replace

use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin cf_lin_count
keep cf_lin_count $trend loco
keep if loco==0 &  $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/cf_lin_pred_`i'.dta",replace
restore

}

use "$dta/lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/lin_pred_`i'"
}
save "$dta/lin_pred_all", replace

use "$dta/cf_lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/cf_lin_pred_`i'"
}
save "$dta/cf_lin_pred_all", replace


use "$ts_data", clear
merge 1:1 $trend $variable using "$dta/lin_pred_all", nogen
merge 1:1 $trend $variable using "$dta/cf_lin_pred_all", nogen

forval i=$min/$max {
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season if $variable==`i', irr
predict pred_count_`i' if $variable==`i'
}
gen pred_count=pred_count_$min
forval i=$min_1/$max{
	replace pred_count=pred_count_`i' if pred_count==.
}
drop pred_count_$min - pred_count_$max
*PLOT IT
forvalues i=$min/$max {
  local v : label ($variable) `i'
   display "`i' is `v'"
   }

local forlab: value label $variable
forvalues i = $min/$max {
	local label: label `forlab' `i'
	di "`label'" 

tw ///
(line pred_count $trend if $variable==`i', lwidth(thin) lcolor(gs10)) ///
(line lin_count $trend if loco==0 & $variable==`i', lwidth(medium) lcolor(black)) ///
(line cf_lin_count $trend if loco==1 & $variable==`i', lpattern(shortdash) lwidth(medium) lcolor(black)) ///
(line lin_count $trend if loco==1 & $variable==`i', lpattern(solid) lwidth(medium) lcolor(black)) ///
(scatter n_births $trend if $variable==`i', msize(vsmall) mcolor(ebblue%60) msym(o)) ///
, ///
xline(731, lpattern(solid) lcolor(red) lwidth(vthin)) ///
xt("Month of Birth") ///
xlab(660(24)731, ) ///
ylab(, angle(h)) ///
yt("Number of Live Births") ///
legend(order(5 "Observed" 1 "Fitted" 2 "Deseasonalised Fitted" 3 "Deseasonalised Expected") col(1)) ///
title("{bf:`label'}", size(medsmall)) ///
plotregion(lcolor(black)) ///
name(C`i', replace) ///
scheme(white_tableau)

}

*combine plots
grc1leg2 C1 C2 C3 C4 C5 , ///
legendfrom(C1) ///
position(4) ring(0) lyoffset(10) lxoffset(0) ///
legscale(*1) plotregion(margin(zero)) imargin(tiny) ///
xtob1title ytol1title ///
title("Austria, Maternal Age", size(medsmall)) ///
scheme(white_tableau)

graph export "$graph/AT_mom_age_cat_$S_DATE.svg", replace

**# Bookmark #19

*** PARITY  ********
*** PARITY  ********
*** PARITY  ********

clear all
use "C:\Users\moritzob\OneDrive - University of Helsinki\postdoc life helsinki\LoCo-effect\LoCo-effect Austria\dta\Austria_births_2015.dta", clear

tab parity,m

global variable "parity" // determine group
su $variable, 
global max=r(max)
global min=r(min)
global min_1=r(min)+1
di $max
di $min
di $min_1

global trend "mdate" // insert variable names
global season "month_nr"
global tw_tm "tm"
global cutoff "2020m12"

*create ts_data
collapse loco $season (count) n_births= year, by($trend $variable)
save "$dta/AT_ts_$variable", replace
global ts_data "$dta/AT_ts_$variable"


****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=$min/$max {
use "$ts_data.dta", clear
keep if $variable==`i'
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season , irr

quietly: margins, ///
at($trend=(660(1)743) loco=(0)) ///
at($trend=(731(1)743) loco=(1)) ///
predict(n) ///
saving("$dta/margins_ts_`i'.dta", replace)

preserve 
use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin lin_count
keep lin_count $trend loco
drop if loco==0 & $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/lin_pred_`i'.dta",replace

use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin cf_lin_count
keep cf_lin_count $trend loco
keep if loco==0 &  $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/cf_lin_pred_`i'.dta",replace
restore

}

use "$dta/lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/lin_pred_`i'"
}
save "$dta/lin_pred_all", replace

use "$dta/cf_lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/cf_lin_pred_`i'"
}
save "$dta/cf_lin_pred_all", replace


use "$ts_data", clear
merge 1:1 $trend $variable using "$dta/lin_pred_all", nogen
merge 1:1 $trend $variable using "$dta/cf_lin_pred_all", nogen

forval i=$min/$max {
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season if $variable==`i', irr
predict pred_count_`i' if $variable==`i'
}
gen pred_count=pred_count_$min
forval i=$min_1/$max{
	replace pred_count=pred_count_`i' if pred_count==.
}
drop pred_count_$min - pred_count_$max
*PLOT IT
forvalues i=$min/$max {
  local v : label ($variable) `i'
   display "`i' is `v'"
   }

local forlab: value label $variable
forvalues i = $min/$max {
	local label: label `forlab' `i'
	di "`label'" 

tw ///
(line pred_count $trend if $variable==`i', lwidth(thin) lcolor(gs10)) ///
(line lin_count $trend if loco==0 & $variable==`i', lwidth(medium) lcolor(black)) ///
(line cf_lin_count $trend if loco==1 & $variable==`i', lpattern(shortdash) lwidth(medium) lcolor(black)) ///
(line lin_count $trend if loco==1 & $variable==`i', lpattern(solid) lwidth(medium) lcolor(black)) ///
(scatter n_births $trend if $variable==`i', msize(vsmall) mcolor(ebblue%60) msym(o)) ///
, ///
xline(731, lpattern(solid) lcolor(red) lwidth(vthin)) ///
xt("Month of Birth") ///
xlab(660(24)731, ) ///
ylab(, angle(h)) ///
yt("Number of Live Births") ///
legend(order(5 "Observed" 1 "Fitted" 2 "Deseasonalised Fitted" 3 "Deseasonalised Expected") col(1)) ///
title("{bf:`label'}", size(medsmall)) ///
plotregion(lcolor(black)) ///
name(C`i', replace) ///
scheme(white_tableau)

}

*combine plots
grc1leg2 C1 C2 C3 C4 C5 , ///
legendfrom(C1) ///
position(4) ring(0) lyoffset(10) lxoffset(0) ///
legscale(*1) plotregion(margin(zero)) imargin(tiny) ///
xtob1title ytol1title ///
title("Austria, Parity", size(medsmall)) ///
scheme(white_tableau)

graph export "$graph/AT_parity_$S_DATE.svg", replace

**# Bookmark #21

****************************************************
****************************************************
*---------------- Tables ---------------------------
*---------------- Tables ---------------------------


**# Bookmark #22

******EDUCATION MOM DETAIL ****
******EDUCATION MOM DETAIL ****
******EDUCATION MOM DETAIL ****

clear all
*
global variable "mom_edu" // determine group
global ts_data "$dta\AT_ts_$variable.dta"
use "$ts_data", clear

tab $variable
su $variable, 
global max=r(max)
global min=r(min)
global min_1=r(min)+1
di $max
di $min
di $min_1

global trend "mdate" // insert variable names
global season "month_nr"
global tw_tm "tm"
global cutoff "2020m12"

*
preserve // get numbers for table later
collapse (sum) n_births if loco==1, by($variable)
egen total_births=sum(n_births)
gen prop= n_births/total_births
save "$dta/AT_obs_$variable.dta" ,replace
restore 

****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=$min/$max {
use "$ts_data", clear
keep if $variable==`i'
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season , irr
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
gen $variable=`i'
keep $variable cf_count se_cf_count cf_count_lb cf_count_ub
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
gen $variable=`i'
keep $variable countdiff countdiff_lb countdiff_ub
save "$dta/countdiff_estimate_`i'.dta", replace
restore
}

use "$dta/cf_estimate_$min", clear
forval i=$min_1/$max {
	append using "$dta/cf_estimate_`i'"
}

merge 1:1  $variable using "$dta/AT_obs_$variable.dta", nogen
order $variable n_births cf_count se_cf_count 
egen total_cf_count=sum(cf_count)
gen cf_prop=cf_count/total_cf_count
gen propdiff=prop-cf_prop
save "$dta/AT_cf_estimate.dta", replace

use "$dta/countdiff_estimate_$min", clear
forval i=$min_1/$max {
	append using "$dta/countdiff_estimate_`i'"
}

merge 1:1  $variable using "$dta/AT_cf_estimate.dta", nogen
order $variable n_births cf_count se_cf_count 
save "$dta/AT_cf_estimate.dta", replace

*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
set seed 123456789
forval d=1/10000 {
use "$dta/AT_cf_estimate.dta", clear
keep $variable cf_count se_cf_count prop
gen cf_count_i_d=rnormal(cf_count , se_cf_count) // generate random draw d from mean SE estimated from poisson ITS for each SIMD group i
egen sum_cf_count_i_d=sum(cf_count_i_d) // sum random draws d of all groups i
gen cf_prop_i_d=cf_count_i_d/sum_cf_count_i_d // create counterfactual proportion for each group i based on draw d
gen propdiff_i_d=prop- cf_prop_i_d // get m_i_d which is the difference in proportion between observed and counterfactual from draw d
keep $variable propdiff_i_d
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
_pctile propdiff_i_d if $variable==$min, percentiles(2.5) 
return list
gen propdiff_lb=r(r1) if $variable==$min
_pctile propdiff_i_d if $variable==$min, percentiles(97.5) 
return list
gen propdiff_ub=r(r1) if $variable==$min

forval i=$min_1/$max {
_pctile propdiff_i_d if $variable==`i', percentiles(2.5) 
return list
replace propdiff_lb=r(r1) if $variable==`i'
_pctile propdiff_i_d if $variable==`i', percentiles(97.5) 
return list
replace propdiff_ub=r(r1) if $variable==`i'
}

collapse propdiff_lb propdiff_ub, by($variable)
save "$dta/AT_prop_uncertainty", replace
use "$dta/AT_cf_estimate", clear
merge 1:1 $variable using "$dta/AT_prop_uncertainty", nogen
gen country="Austria"
order country $variable n_births cf_count se_cf_count cf_count_lb cf_count_ub countdiff countdiff_lb countdiff_ub prop cf_prop propdiff propdiff_lb propdiff_ub total_births total_cf_count
save "$dta/AT_comp_diff_$variable", replace

**# Bookmark #24
****** HIGHEST EDU OF BOTH PARENTS ****
****** HIGHEST EDU OF BOTH PARENTS ****
****** HIGHEST EDU OF BOTH PARENTS ****´
clear all
*
global variable "mom_dad_edu_comp" // determine group
global ts_data "$dta\AT_ts_$variable.dta"
use "$ts_data", clear

tab $variable
su $variable, 
global max=r(max)
global min=r(min)
global min_1=r(min)+1
di $max
di $min
di $min_1

global trend "mdate" // insert variable names
global season "month_nr"
global tw_tm "tm"
global cutoff "2020m12"

*
preserve // get numbers for table later
collapse (sum) n_births if loco==1, by($variable)
egen total_births=sum(n_births)
gen prop= n_births/total_births
save "$dta/AT_obs_$variable.dta" ,replace
restore 

****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=$min/$max {
use "$ts_data", clear
keep if $variable==`i'
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season , irr
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
gen $variable=`i'
keep $variable cf_count se_cf_count cf_count_lb cf_count_ub
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
gen $variable=`i'
keep $variable countdiff countdiff_lb countdiff_ub
save "$dta/countdiff_estimate_`i'.dta", replace
restore
}

use "$dta/cf_estimate_$min", clear
forval i=$min_1/$max {
	append using "$dta/cf_estimate_`i'"
}

merge 1:1  $variable using "$dta/AT_obs_$variable.dta", nogen
order $variable n_births cf_count se_cf_count 
egen total_cf_count=sum(cf_count)
gen cf_prop=cf_count/total_cf_count
gen propdiff=prop-cf_prop
save "$dta/AT_cf_estimate.dta", replace

use "$dta/countdiff_estimate_$min", clear
forval i=$min_1/$max {
	append using "$dta/countdiff_estimate_`i'"
}

merge 1:1  $variable using "$dta/AT_cf_estimate.dta", nogen
order $variable n_births cf_count se_cf_count 
save "$dta/AT_cf_estimate.dta", replace

*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
set seed 123456789
forval d=1/10000 {
use "$dta/AT_cf_estimate.dta", clear
keep $variable cf_count se_cf_count prop
gen cf_count_i_d=rnormal(cf_count , se_cf_count) // generate random draw d from mean SE estimated from poisson ITS for each SIMD group i
egen sum_cf_count_i_d=sum(cf_count_i_d) // sum random draws d of all groups i
gen cf_prop_i_d=cf_count_i_d/sum_cf_count_i_d // create counterfactual proportion for each group i based on draw d
gen propdiff_i_d=prop- cf_prop_i_d // get m_i_d which is the difference in proportion between observed and counterfactual from draw d
keep $variable propdiff_i_d
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
_pctile propdiff_i_d if $variable==$min, percentiles(2.5) 
return list
gen propdiff_lb=r(r1) if $variable==$min
_pctile propdiff_i_d if $variable==$min, percentiles(97.5) 
return list
gen propdiff_ub=r(r1) if $variable==$min

forval i=$min_1/$max {
_pctile propdiff_i_d if $variable==`i', percentiles(2.5) 
return list
replace propdiff_lb=r(r1) if $variable==`i'
_pctile propdiff_i_d if $variable==`i', percentiles(97.5) 
return list
replace propdiff_ub=r(r1) if $variable==`i'
}

collapse propdiff_lb propdiff_ub, by($variable)
save "$dta/AT_prop_uncertainty", replace
use "$dta/AT_cf_estimate", clear
merge 1:1 $variable using "$dta/AT_prop_uncertainty", nogen
gen country="Austria"
order country $variable n_births cf_count se_cf_count cf_count_lb cf_count_ub countdiff countdiff_lb countdiff_ub prop cf_prop propdiff propdiff_lb propdiff_ub total_births total_cf_count
save "$dta/AT_comp_diff_$variable", replace

**# Bookmark #25

********** MATERNAL AGE **********
********** MATERNAL AGE **********
********** MATERNAL AGE **********

clear all
*
global variable "mom_age_cat" // determine group
global ts_data "$dta\AT_ts_$variable.dta"
use "$ts_data", clear

tab $variable
su $variable, 
global max=r(max)
global min=r(min)
global min_1=r(min)+1
di $max
di $min
di $min_1

global trend "mdate" // insert variable names
global season "month_nr"
global tw_tm "tm"
global cutoff "2020m12"

*
preserve // get numbers for table later
collapse (sum) n_births if loco==1, by($variable)
egen total_births=sum(n_births)
gen prop= n_births/total_births
save "$dta/AT_obs_$variable.dta" ,replace
restore 

****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=$min/$max {
use "$ts_data", clear
keep if $variable==`i'
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season , irr
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
gen $variable=`i'
keep $variable cf_count se_cf_count cf_count_lb cf_count_ub
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
gen $variable=`i'
keep $variable countdiff countdiff_lb countdiff_ub
save "$dta/countdiff_estimate_`i'.dta", replace
restore
}

use "$dta/cf_estimate_$min", clear
forval i=$min_1/$max {
	append using "$dta/cf_estimate_`i'"
}

merge 1:1  $variable using "$dta/AT_obs_$variable.dta", nogen
order $variable n_births cf_count se_cf_count 
egen total_cf_count=sum(cf_count)
gen cf_prop=cf_count/total_cf_count
gen propdiff=prop-cf_prop
save "$dta/AT_cf_estimate.dta", replace

use "$dta/countdiff_estimate_$min", clear
forval i=$min_1/$max {
	append using "$dta/countdiff_estimate_`i'"
}

merge 1:1  $variable using "$dta/AT_cf_estimate.dta", nogen
order $variable n_births cf_count se_cf_count 
save "$dta/AT_cf_estimate.dta", replace

*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
set seed 123456789
forval d=1/10000 {
use "$dta/AT_cf_estimate.dta", clear
keep $variable cf_count se_cf_count prop
gen cf_count_i_d=rnormal(cf_count , se_cf_count) // generate random draw d from mean SE estimated from poisson ITS for each SIMD group i
egen sum_cf_count_i_d=sum(cf_count_i_d) // sum random draws d of all groups i
gen cf_prop_i_d=cf_count_i_d/sum_cf_count_i_d // create counterfactual proportion for each group i based on draw d
gen propdiff_i_d=prop- cf_prop_i_d // get m_i_d which is the difference in proportion between observed and counterfactual from draw d
keep $variable propdiff_i_d
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
_pctile propdiff_i_d if $variable==$min, percentiles(2.5) 
return list
gen propdiff_lb=r(r1) if $variable==$min
_pctile propdiff_i_d if $variable==$min, percentiles(97.5) 
return list
gen propdiff_ub=r(r1) if $variable==$min

forval i=$min_1/$max {
_pctile propdiff_i_d if $variable==`i', percentiles(2.5) 
return list
replace propdiff_lb=r(r1) if $variable==`i'
_pctile propdiff_i_d if $variable==`i', percentiles(97.5) 
return list
replace propdiff_ub=r(r1) if $variable==`i'
}

collapse propdiff_lb propdiff_ub, by($variable)
save "$dta/AT_prop_uncertainty", replace
use "$dta/AT_cf_estimate", clear
merge 1:1 $variable using "$dta/AT_prop_uncertainty", nogen
gen country="Austria"
order country $variable n_births cf_count se_cf_count cf_count_lb cf_count_ub countdiff countdiff_lb countdiff_ub prop cf_prop propdiff propdiff_lb propdiff_ub total_births total_cf_count
save "$dta/AT_comp_diff_$variable", replace



**# Bookmark #26
********** PARITY **********
********** PARITY **********
********** PARITY **********

clear all
*
global variable "parity" // determine group
global ts_data "$dta\AT_ts_$variable.dta"
use "$ts_data", clear

tab $variable
su $variable, 
global max=r(max)
global min=r(min)
global min_1=r(min)+1
di $max
di $min
di $min_1

global trend "mdate" // insert variable names
global season "month_nr"
global tw_tm "tm"
global cutoff "2020m12"

*
preserve // get numbers for table later
collapse (sum) n_births if loco==1, by($variable)
egen total_births=sum(n_births)
gen prop= n_births/total_births
save "$dta/AT_obs_$variable.dta" ,replace
restore 

****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=$min/$max {
use "$ts_data", clear
keep if $variable==`i'
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season , irr
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
gen $variable=`i'
keep $variable cf_count se_cf_count cf_count_lb cf_count_ub
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
gen $variable=`i'
keep $variable countdiff countdiff_lb countdiff_ub
save "$dta/countdiff_estimate_`i'.dta", replace
restore
}

use "$dta/cf_estimate_$min", clear
forval i=$min_1/$max {
	append using "$dta/cf_estimate_`i'"
}

merge 1:1  $variable using "$dta/AT_obs_$variable.dta", nogen
order $variable n_births cf_count se_cf_count 
egen total_cf_count=sum(cf_count)
gen cf_prop=cf_count/total_cf_count
gen propdiff=prop-cf_prop
save "$dta/AT_cf_estimate.dta", replace

use "$dta/countdiff_estimate_$min", clear
forval i=$min_1/$max {
	append using "$dta/countdiff_estimate_`i'"
}

merge 1:1  $variable using "$dta/AT_cf_estimate.dta", nogen
order $variable n_births cf_count se_cf_count 
save "$dta/AT_cf_estimate.dta", replace

*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
set seed 123456789
forval d=1/10000 {
use "$dta/AT_cf_estimate.dta", clear
keep $variable cf_count se_cf_count prop
gen cf_count_i_d=rnormal(cf_count , se_cf_count) // generate random draw d from mean SE estimated from poisson ITS for each SIMD group i
egen sum_cf_count_i_d=sum(cf_count_i_d) // sum random draws d of all groups i
gen cf_prop_i_d=cf_count_i_d/sum_cf_count_i_d // create counterfactual proportion for each group i based on draw d
gen propdiff_i_d=prop- cf_prop_i_d // get m_i_d which is the difference in proportion between observed and counterfactual from draw d
keep $variable propdiff_i_d
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
_pctile propdiff_i_d if $variable==$min, percentiles(2.5) 
return list
gen propdiff_lb=r(r1) if $variable==$min
_pctile propdiff_i_d if $variable==$min, percentiles(97.5) 
return list
gen propdiff_ub=r(r1) if $variable==$min

forval i=$min_1/$max {
_pctile propdiff_i_d if $variable==`i', percentiles(2.5) 
return list
replace propdiff_lb=r(r1) if $variable==`i'
_pctile propdiff_i_d if $variable==`i', percentiles(97.5) 
return list
replace propdiff_ub=r(r1) if $variable==`i'
}

collapse propdiff_lb propdiff_ub, by($variable)
save "$dta/AT_prop_uncertainty", replace
use "$dta/AT_cf_estimate", clear
merge 1:1 $variable using "$dta/AT_prop_uncertainty", nogen
gen country="Austria"
order country $variable n_births cf_count se_cf_count cf_count_lb cf_count_ub countdiff countdiff_lb countdiff_ub prop cf_prop propdiff propdiff_lb propdiff_ub total_births total_cf_count
save "$dta/AT_comp_diff_$variable", replace


**# Bookmark #27
************** AUSTRIA TABLE ***********
************** AUSTRIA TABLE ***********
************** AUSTRIA TABLE ***********

use "$dta/AT_comp_diff_mom_edu", clear
append using "$dta/AT_comp_diff_mom_dad_edu_comp"
append using "$dta/AT_comp_diff_mom_age_cat"
append using "$dta/AT_comp_diff_parity"
gen rel_count_diff=(n_births-cf_count)/(abs(cf_count))*100
gen rel_count_diff_ub=(n_births-cf_count_lb)/(abs(cf_count_lb))*100
gen rel_count_diff_lb=(n_births-cf_count_ub)/(abs(cf_count_ub))*100
order country mom_edu mom_dad_edu_comp mom_age_cat parity n_births cf_count se_cf_count cf_count_lb cf_count_ub countdiff countdiff_lb countdiff_ub rel_count_diff rel_count_diff_lb rel_count_diff_ub prop cf_prop propdiff propdiff_lb propdiff_ub total_births total_cf_count
drop se_cf_count
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

order country mom_edu mom_dad_edu_comp mom_age_cat parity n_births cf_count  cf_count_ci countdiff countdiff_ci  rel_count_diff rel_diff_ci prop cf_prop propdiff propdiff_ci total_births total_cf_count

save "$dta/AT_table_profile_$S_DATE", replace
export excel using "$table\AT_table_profile_$S_DATE.xls", firstrow(variables) replace


**# Bookmark #28


*************************** BRAZIL BRAZIL BRAZIL ******************************
*************************** BRAZIL BRAZIL BRAZIL ******************************
*************************** BRAZIL BRAZIL BRAZIL ******************************
*************************** BRAZIL BRAZIL BRAZIL ******************************

****** MAIN SEC variable, all categories
****** MAIN SEC variable, all categories

clear all
use "$dta/BRA_ts", clear
global ts_data "$dta/BRA_ts"
global variable "area_deprivation" // determine group
su $variable, 
global max=r(max)
global min=r(min)
global min_1=r(min)+1
di $max
di $min
di $min_1

global trend "bdate_w" // insert variable names
global season "bweek"
global tw_tm "tw"
global cutoff "2020w51"

****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=$min/$max {
use "$ts_data.dta", clear
keep if $variable==`i'
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season i.zika , irr

quietly: margins, ///
at($trend=(2860(1)3223) loco=0 zika=0) ///
at($trend=(3170(1)3223) loco=1 zika=0) ///
predict(n) ///
saving("$dta/margins_ts_`i'.dta", replace)

preserve 
use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin lin_count
keep lin_count $trend loco
drop if loco==0 & $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/lin_pred_`i'.dta",replace

use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin cf_lin_count
keep cf_lin_count $trend loco
keep if loco==0 &  $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/cf_lin_pred_`i'.dta",replace
restore

}

use "$dta/lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/lin_pred_`i'"
}
save "$dta/lin_pred_all", replace

use "$dta/cf_lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/cf_lin_pred_`i'"
}
save "$dta/cf_lin_pred_all", replace


use "$ts_data", clear
merge 1:1 $trend $variable using "$dta/lin_pred_all", nogen
merge 1:1 $trend $variable using "$dta/cf_lin_pred_all", nogen

forval i=$min/$max {
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season i.zika if $variable==`i', irr
predict pred_count_`i' if $variable==`i'
}
gen pred_count=pred_count_$min
forval i=$min_1/$max{
	replace pred_count=pred_count_`i' if pred_count==.
}
drop pred_count_$min - pred_count_$max
*PLOT IT
forvalues i=$min/$max {
  local v : label ($variable) `i'
   display "`i' is `v'"
   }

local forlab: value label $variable
forvalues i = $min/$max {
	local label: label `forlab' `i'
	di "`label'" 

tw ///
(line pred_count $trend if $variable==`i', lwidth(thin) lcolor(gs10)) ///
(line lin_count $trend if loco==0 & $variable==`i', lwidth(medium) lcolor(black)) ///
(line cf_lin_count $trend if loco==1 & $variable==`i', lpattern(shortdash) lwidth(medium) lcolor(black)) ///
(line lin_count $trend if loco==1 & $variable==`i', lpattern(solid) lwidth(medium) lcolor(black)) ///
(scatter n_births $trend if $variable==`i', msize(vsmall) mcolor(ebblue%60) msym(o)) ///
, ///
xline(3170, lpattern(solid) lcolor(red) lwidth(vthin)) ///
xt("Week of Birth") ///
xlab(2860(104)3223, angle(h) ) ///
ylab(, angle(h)) ///
yt("Number of Live Births") ///
legend(order(5 "Observed" 1 "Fitted" 2 "Deseasonalised Fitted" 3 "Deseasonalised Expected") row(1)) ///
title("{bf:`label'}", size(medsmall)) ///
plotregion(lcolor(black)) ///
name(C`i', replace) ///
scheme(white_tableau)

}

*combine plots
grc1leg2 C1 C2 C3 C4 C5 C6, ///
legendfrom(C1) ///
position(6) lyoffset(0) lxoffset(0) ///
legscale(*1) plotregion(margin(zero)) imargin(tiny) ///
xtob1title ytol1title ///
title("Brazil, Area Deprivation", size(medsmall)) ///
scheme(white_tableau)

graph export "$graph/BR_area_deprivation_$S_DATE.svg", replace

**# Bookmark #29
****** Maternal education in years ***
****** Maternal education in years ***
****** Maternal education in years ***
****** Maternal education in years ***

clear all

use "C:\Users\moritzob\OneDrive - University of Helsinki\postdoc life helsinki\LoCo-effect\LoCo-effect Brazil/dta/SINASC_2015_2021_0611.dta", clear
replace mom_edu_years=6 if mom_edu_years==9
replace mom_edu_years=6 if mom_edu_years==. // include missing
label define edu_y2 1 "None" 2 "1 to 3 years" 3 "4 to 7 years" 4 "8 to 11 years" 5 "12 and more years" 6 "Ignored/Missing information"
label values mom_edu_year edu_y2

tab mom_edu_years,m
rename loco_w loco
global variable "mom_edu_years" // determine group
su $variable, 
global max=r(max)
global min=r(min)
global min_1=r(min)+1
di $max
di $min
di $min_1

global trend "bdate_w" // insert variable names
global season "bweek"
global tw_tm "tw"
global cutoff "2020w51"

*create ts_data
collapse loco $season (count) n_births= year, by($trend $variable)

* zika period from August 2016 to end of Dec 2016
gen zika=0
replace zika=1 if bdate_w >=tw(2016w31) & bdate_w <=tw(2016w52)

save "$dta/BR_ts_$variable", replace
global ts_data "$dta/BR_ts_$variable"


****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=$min/$max {
use "$ts_data.dta", clear
keep if $variable==`i'
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season i.zika , irr

quietly: margins, ///
at($trend=(2860(1)3223) loco=0 zika=0) ///
at($trend=(3170(1)3223) loco=1 zika=0) ///
predict(n) ///
saving("$dta/margins_ts_`i'.dta", replace)

preserve 
use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin lin_count
keep lin_count $trend loco
drop if loco==0 & $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/lin_pred_`i'.dta",replace

use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin cf_lin_count
keep cf_lin_count $trend loco
keep if loco==0 &  $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/cf_lin_pred_`i'.dta",replace
restore

}

use "$dta/lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/lin_pred_`i'"
}
save "$dta/lin_pred_all", replace

use "$dta/cf_lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/cf_lin_pred_`i'"
}
save "$dta/cf_lin_pred_all", replace


use "$ts_data", clear
merge 1:1 $trend $variable using "$dta/lin_pred_all", nogen
merge 1:1 $trend $variable using "$dta/cf_lin_pred_all", nogen

forval i=$min/$max {
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season i.zika if $variable==`i', irr
predict pred_count_`i' if $variable==`i'
}
gen pred_count=pred_count_$min
forval i=$min_1/$max{
	replace pred_count=pred_count_`i' if pred_count==.
}
drop pred_count_$min - pred_count_$max
*PLOT IT
forvalues i=$min/$max {
  local v : label ($variable) `i'
   display "`i' is `v'"
   }

local forlab: value label $variable
forvalues i = $min/$max {
	local label: label `forlab' `i'
	di "`label'" 

tw ///
(line pred_count $trend if $variable==`i', lwidth(thin) lcolor(gs10)) ///
(line lin_count $trend if loco==0 & $variable==`i', lwidth(medium) lcolor(black)) ///
(line cf_lin_count $trend if loco==1 & $variable==`i', lpattern(shortdash) lwidth(medium) lcolor(black)) ///
(line lin_count $trend if loco==1 & $variable==`i', lpattern(solid) lwidth(medium) lcolor(black)) ///
(scatter n_births $trend if $variable==`i', msize(vsmall) mcolor(ebblue%60) msym(o)) ///
, ///
xline(3170, lpattern(solid) lcolor(red) lwidth(vthin)) ///
xt("Week of Birth") ///
xlab(2860(104)3223, angle(h) ) ///
ylab(, angle(h)) ///
yt("Number of Live Births") ///
legend(order(5 "Observed" 1 "Fitted" 2 "Deseasonalised Fitted" 3 "Deseasonalised Expected") row(1)) ///
title("{bf:`label'}", size(medsmall)) ///
plotregion(lcolor(black)) ///
name(C`i', replace) ///
scheme(white_tableau)

}

*combine plots
grc1leg2 C1 C2 C3 C4 C5 C6, ///
legendfrom(C1) ///
position(6) lyoffset(0) lxoffset(0) ///
legscale(*1) plotregion(margin(zero)) imargin(tiny) ///
xtob1title ytol1title ///
title("Brazil, Maternal Education in Years", size(medsmall)) ///
scheme(white_tableau)

graph export "$graph/BR_mom_edu_years_$S_DATE.svg", replace


**# Bookmark #31

****** Maternal education in degrees ***
****** Maternal education in degrees ***
****** Maternal education in degrees ***

clear all

use "C:\Users\moritzob\OneDrive - University of Helsinki\postdoc life helsinki\LoCo-effect\LoCo-effect Brazil/dta/SINASC_2015_2021_0611.dta", clear

gen mom_edu= escmae2010
tab mom_edu,m
replace mom_edu=6 if mom_edu==9
replace mom_edu=6 if mom_edu==. // include missing
replace mom_edu= mom_edu+1
label define edu_y3 1 "No education" 2 "Elementary 1 (1st-4th Grade)" 3 "Elementary 2 (5th-8th Grade)" 4 "Médio (High School)" 5 "Higher Education incomplete" 6 "Tertiary Education" 7 "Ignored/Missing information"
label values mom_edu edu_y3

tab mom_edu,m
rename loco_w loco
global variable "mom_edu" // determine group
su $variable, 
global max=r(max)
global min=r(min)
global min_1=r(min)+1
di $max
di $min
di $min_1

global trend "bdate_w" // insert variable names
global season "bweek"
global tw_tm "tw"
global cutoff "2020w51"

*create ts_data
collapse loco $season (count) n_births= year, by($trend $variable)

* zika period from August 2016 to end of Dec 2016
gen zika=0
replace zika=1 if bdate_w >=tw(2016w31) & bdate_w <=tw(2016w52)

save "$dta/BR_ts_$variable", replace
global ts_data "$dta/BR_ts_$variable"


****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=$min/$max {
use "$ts_data.dta", clear
keep if $variable==`i'
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season i.zika , irr

quietly: margins, ///
at($trend=(2860(1)3223) loco=0 zika=0) ///
at($trend=(3170(1)3223) loco=1 zika=0) ///
predict(n) ///
saving("$dta/margins_ts_`i'.dta", replace)

preserve 
use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin lin_count
keep lin_count $trend loco
drop if loco==0 & $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/lin_pred_`i'.dta",replace

use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin cf_lin_count
keep cf_lin_count $trend loco
keep if loco==0 &  $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/cf_lin_pred_`i'.dta",replace
restore

}

use "$dta/lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/lin_pred_`i'"
}
save "$dta/lin_pred_all", replace

use "$dta/cf_lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/cf_lin_pred_`i'"
}
save "$dta/cf_lin_pred_all", replace


use "$ts_data", clear
merge 1:1 $trend $variable using "$dta/lin_pred_all", nogen
merge 1:1 $trend $variable using "$dta/cf_lin_pred_all", nogen

forval i=$min/$max {
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season i.zika if $variable==`i', irr
predict pred_count_`i' if $variable==`i'
}
gen pred_count=pred_count_$min
forval i=$min_1/$max{
	replace pred_count=pred_count_`i' if pred_count==.
}
drop pred_count_$min - pred_count_$max
*PLOT IT
forvalues i=$min/$max {
  local v : label ($variable) `i'
   display "`i' is `v'"
   }

local forlab: value label $variable
forvalues i = $min/$max {
	local label: label `forlab' `i'
	di "`label'" 

tw ///
(line pred_count $trend if $variable==`i', lwidth(thin) lcolor(gs10)) ///
(line lin_count $trend if loco==0 & $variable==`i', lwidth(medium) lcolor(black)) ///
(line cf_lin_count $trend if loco==1 & $variable==`i', lpattern(shortdash) lwidth(medium) lcolor(black)) ///
(line lin_count $trend if loco==1 & $variable==`i', lpattern(solid) lwidth(medium) lcolor(black)) ///
(scatter n_births $trend if $variable==`i', msize(vsmall) mcolor(ebblue%60) msym(o)) ///
, ///
xline(3170, lpattern(solid) lcolor(red) lwidth(vthin)) ///
xt("Week of Birth") ///
xlab(2860(104)3223, angle(h) ) ///
ylab(, angle(h)) ///
yt("Number of Live Births") ///
legend(order(5 "Observed" 1 "Fitted" 2 "Deseasonalised Fitted" 3 "Deseasonalised Expected") row(2)) ///
title("{bf:`label'}", size(medsmall)) ///
plotregion(lcolor(black)) ///
name(C`i', replace) ///
scheme(white_tableau)

}

*combine plots
grc1leg2 C1 C2 C3 C4 C5 C6 C7, ///
legendfrom(C1) ///
position(4) ring (0) lyoffset(10) lxoffset(-10) ///
legscale(*1) plotregion(margin(zero)) imargin(tiny) ///
xtob1title ytol1title ///
title("Brazil, Maternal Education", size(medsmall)) ///
scheme(white_tableau)

graph export "$graph/BR_mom_edu_$S_DATE.svg", replace


**# Bookmark #33

****** Maternal AGE  ***
****** Maternal AGE  ***
****** Maternal AGE  ***
****** Maternal AGE  ***

clear all

use "C:\Users\moritzob\OneDrive - University of Helsinki\postdoc life helsinki\LoCo-effect\LoCo-effect Brazil/dta/SINASC_2015_2021_0611.dta", clear
tab mom_age_cat, m
drop if mom_age_cat==. // 445 missing age can be ignored if there are 20 mill birhts

label define agel 1 "Maternal Age Under 20" 2 "20-24" 3 "25-29" 4 "30-34" 5 "35 and Above" 
label values mom_age_cat agel
rename loco_w loco
global variable "mom_age_cat" // determine group
su $variable, 
global max=r(max)
global min=r(min)
global min_1=r(min)+1
di $max
di $min
di $min_1

global trend "bdate_w" // insert variable names
global season "bweek"
global tw_tm "tw"
global cutoff "2020w51"

*create ts_data
collapse loco $season (count) n_births= year, by($trend $variable)

* zika period from August 2016 to end of Dec 2016
gen zika=0
replace zika=1 if bdate_w >=tw(2016w31) & bdate_w <=tw(2016w52)

save "$dta/BR_ts_$variable", replace
global ts_data "$dta/BR_ts_$variable"


****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=$min/$max {
use "$ts_data.dta", clear
keep if $variable==`i'
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season i.zika , irr

quietly: margins, ///
at($trend=(2860(1)3223) loco=0 zika=0) ///
at($trend=(3170(1)3223) loco=1 zika=0) ///
predict(n) ///
saving("$dta/margins_ts_`i'.dta", replace)

preserve 
use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin lin_count
keep lin_count $trend loco
drop if loco==0 & $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/lin_pred_`i'.dta",replace

use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin cf_lin_count
keep cf_lin_count $trend loco
keep if loco==0 &  $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/cf_lin_pred_`i'.dta",replace
restore

}

use "$dta/lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/lin_pred_`i'"
}
save "$dta/lin_pred_all", replace

use "$dta/cf_lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/cf_lin_pred_`i'"
}
save "$dta/cf_lin_pred_all", replace


use "$ts_data", clear
merge 1:1 $trend $variable using "$dta/lin_pred_all", nogen
merge 1:1 $trend $variable using "$dta/cf_lin_pred_all", nogen

forval i=$min/$max {
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season i.zika if $variable==`i', irr
predict pred_count_`i' if $variable==`i'
}
gen pred_count=pred_count_$min
forval i=$min_1/$max{
	replace pred_count=pred_count_`i' if pred_count==.
}
drop pred_count_$min - pred_count_$max
*PLOT IT
forvalues i=$min/$max {
  local v : label ($variable) `i'
   display "`i' is `v'"
   }

local forlab: value label $variable
forvalues i = $min/$max {
	local label: label `forlab' `i'
	di "`label'" 

tw ///
(line pred_count $trend if $variable==`i', lwidth(thin) lcolor(gs10)) ///
(line lin_count $trend if loco==0 & $variable==`i', lwidth(medium) lcolor(black)) ///
(line cf_lin_count $trend if loco==1 & $variable==`i', lpattern(shortdash) lwidth(medium) lcolor(black)) ///
(line lin_count $trend if loco==1 & $variable==`i', lpattern(solid) lwidth(medium) lcolor(black)) ///
(scatter n_births $trend if $variable==`i', msize(vsmall) mcolor(ebblue%60) msym(o)) ///
, ///
xline(3170, lpattern(solid) lcolor(red) lwidth(vthin)) ///
xt("Week of Birth") ///
xlab(2860(104)3223, angle(h) ) ///
ylab(, angle(h)) ///
yt("Number of Live Births") ///
legend(order(5 "Observed" 1 "Fitted" 2 "Deseasonalised Fitted" 3 "Deseasonalised Expected") col(1)) ///
title("{bf:`label'}", size(medsmall)) ///
plotregion(lcolor(black)) ///
name(C`i', replace) ///
scheme(white_tableau)

}

*combine plots
grc1leg2 C1 C2 C3 C4 C5 , ///
legendfrom(C1) ///
position(4) ring(0) lyoffset(10) lxoffset(0) ///
legscale(*1) plotregion(margin(zero)) imargin(tiny) ///
xtob1title ytol1title ///
title("Brazil, Maternal Age", size(medsmall)) ///
scheme(white_tableau)

graph export "$graph/BR_mom_age_cat_$S_DATE.svg", replace

**# Bookmark #34

****** PARITY *******
****** PARITY *******
****** PARITY *******
****** PARITY *******

clear all

use "C:\Users\moritzob\OneDrive - University of Helsinki\postdoc life helsinki\LoCo-effect\LoCo-effect Brazil/dta/SINASC_2015_2021_0611.dta", clear
tab parity, m

replace parity=5 if parity==.
replace parity=parity+1 // make old code work

label define parlab 1 "Parity 0" 2 "1" 3 "2" 4 "3" 5 "4 or more" 6 "Missing information" 
label values parity parlab
tab parity,m
rename loco_w loco
global variable "parity" // determine group
su $variable, 
global max=r(max)
global min=r(min)
global min_1=r(min)+1
di $max
di $min
di $min_1

global trend "bdate_w" // insert variable names
global season "bweek"
global tw_tm "tw"
global cutoff "2020w51"

*create ts_data
collapse loco $season (count) n_births= year, by($trend $variable)

* zika period from August 2016 to end of Dec 2016
gen zika=0
replace zika=1 if bdate_w >=tw(2016w31) & bdate_w <=tw(2016w52)

save "$dta/BR_ts_$variable", replace
global ts_data "$dta/BR_ts_$variable"


****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=$min/$max {
use "$ts_data.dta", clear
keep if $variable==`i'
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season i.zika , irr

quietly: margins, ///
at($trend=(2860(1)3223) loco=0 zika=0) ///
at($trend=(3170(1)3223) loco=1 zika=0) ///
predict(n) ///
saving("$dta/margins_ts_`i'.dta", replace)

preserve 
use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin lin_count
keep lin_count $trend loco
drop if loco==0 & $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/lin_pred_`i'.dta",replace

use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin cf_lin_count
keep cf_lin_count $trend loco
keep if loco==0 &  $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/cf_lin_pred_`i'.dta",replace
restore

}

use "$dta/lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/lin_pred_`i'"
}
save "$dta/lin_pred_all", replace

use "$dta/cf_lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/cf_lin_pred_`i'"
}
save "$dta/cf_lin_pred_all", replace


use "$ts_data", clear
merge 1:1 $trend $variable using "$dta/lin_pred_all", nogen
merge 1:1 $trend $variable using "$dta/cf_lin_pred_all", nogen

forval i=$min/$max {
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season i.zika if $variable==`i', irr
predict pred_count_`i' if $variable==`i'
}
gen pred_count=pred_count_$min
forval i=$min_1/$max{
	replace pred_count=pred_count_`i' if pred_count==.
}
drop pred_count_$min - pred_count_$max
*PLOT IT
forvalues i=$min/$max {
  local v : label ($variable) `i'
   display "`i' is `v'"
   }

local forlab: value label $variable
forvalues i = $min/$max {
	local label: label `forlab' `i'
	di "`label'" 

tw ///
(line pred_count $trend if $variable==`i', lwidth(thin) lcolor(gs10)) ///
(line lin_count $trend if loco==0 & $variable==`i', lwidth(medium) lcolor(black)) ///
(line cf_lin_count $trend if loco==1 & $variable==`i', lpattern(shortdash) lwidth(medium) lcolor(black)) ///
(line lin_count $trend if loco==1 & $variable==`i', lpattern(solid) lwidth(medium) lcolor(black)) ///
(scatter n_births $trend if $variable==`i', msize(vsmall) mcolor(ebblue%60) msym(o)) ///
, ///
xline(3170, lpattern(solid) lcolor(red) lwidth(vthin)) ///
xt("Week of Birth") ///
xlab(2860(104)3223, angle(h) ) ///
ylab(, angle(h)) ///
yt("Number of Live Births") ///
legend(order(5 "Observed" 1 "Fitted" 2 "Deseasonalised Fitted" 3 "Deseasonalised Expected") row(1)) ///
title("{bf:`label'}", size(medsmall)) ///
plotregion(lcolor(black)) ///
name(C`i', replace) ///
scheme(white_tableau)

}

*combine plots
grc1leg2 C1 C2 C3 C4 C5 C6, ///
legendfrom(C1) ///
position(6) lyoffset(0) lxoffset(0) ///
legscale(*1) plotregion(margin(zero)) imargin(tiny) ///
xtob1title ytol1title ///
title("Brazil, Parity", size(medsmall)) ///
scheme(white_tableau)

graph export "$graph/BR_parity_$S_DATE.svg", replace

**# Bookmark #35


****************************************************
****************************************************
*---------------- Tables ---------------------------
*---------------- Tables ---------------------------

******EDUCATION MOM YEARS ****
******EDUCATION MOM YEARS ****
******EDUCATION MOM YEARS ****

clear all
*
global variable "mom_edu_years" // determine group
global ts_data "$dta\BR_ts_$variable.dta"
use "$ts_data", clear

tab $variable
su $variable, 
global max=r(max)
global min=r(min)
global min_1=r(min)+1
di $max
di $min
di $min_1

global trend "bdate_w" // insert variable names
global season "bweek"
global tw_tm "tw"
global cutoff "2020w51"

*
preserve // get numbers for table later
collapse (sum) n_births if loco==1, by($variable)
egen total_births=sum(n_births)
gen prop= n_births/total_births
save "$dta/BR_obs_$variable.dta" ,replace
restore 

****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=$min/$max {
use "$ts_data", clear
keep if $variable==`i'
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season i.zika , irr
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
gen $variable=`i'
keep $variable cf_count se_cf_count cf_count_lb cf_count_ub
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
gen $variable=`i'
keep $variable countdiff countdiff_lb countdiff_ub
save "$dta/countdiff_estimate_`i'.dta", replace
restore
}

use "$dta/cf_estimate_$min", clear
forval i=$min_1/$max {
	append using "$dta/cf_estimate_`i'"
}

merge 1:1  $variable using "$dta/BR_obs_$variable.dta", nogen
order $variable n_births cf_count se_cf_count 
egen total_cf_count=sum(cf_count)
gen cf_prop=cf_count/total_cf_count
gen propdiff=prop-cf_prop
save "$dta/BR_cf_estimate.dta", replace

use "$dta/countdiff_estimate_$min", clear
forval i=$min_1/$max {
	append using "$dta/countdiff_estimate_`i'"
}

merge 1:1  $variable using "$dta/BR_cf_estimate.dta", nogen
order $variable n_births cf_count se_cf_count 
save "$dta/BR_cf_estimate.dta", replace

*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
set seed 123456789
forval d=1/10000 {
use "$dta/BR_cf_estimate.dta", clear
keep $variable cf_count se_cf_count prop
gen cf_count_i_d=rnormal(cf_count , se_cf_count) // generate random draw d from mean SE estimated from poisson ITS for each SIMD group i
egen sum_cf_count_i_d=sum(cf_count_i_d) // sum random draws d of all groups i
gen cf_prop_i_d=cf_count_i_d/sum_cf_count_i_d // create counterfactual proportion for each group i based on draw d
gen propdiff_i_d=prop- cf_prop_i_d // get m_i_d which is the difference in proportion between observed and counterfactual from draw d
keep $variable propdiff_i_d
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
_pctile propdiff_i_d if $variable==$min, percentiles(2.5) 
return list
gen propdiff_lb=r(r1) if $variable==$min
_pctile propdiff_i_d if $variable==$min, percentiles(97.5) 
return list
gen propdiff_ub=r(r1) if $variable==$min

forval i=$min_1/$max {
_pctile propdiff_i_d if $variable==`i', percentiles(2.5) 
return list
replace propdiff_lb=r(r1) if $variable==`i'
_pctile propdiff_i_d if $variable==`i', percentiles(97.5) 
return list
replace propdiff_ub=r(r1) if $variable==`i'
}

collapse propdiff_lb propdiff_ub, by($variable)
save "$dta/BR_prop_uncertainty", replace
use "$dta/BR_cf_estimate", clear
merge 1:1 $variable using "$dta/BR_prop_uncertainty", nogen
gen country="Brazil"
order country $variable n_births cf_count se_cf_count cf_count_lb cf_count_ub countdiff countdiff_lb countdiff_ub prop cf_prop propdiff propdiff_lb propdiff_ub total_births total_cf_count
save "$dta/BR_comp_diff_$variable", replace


**# Bookmark #36
******EDUCATION MOM DEGREES ****
******EDUCATION MOM DEGREES ****
******EDUCATION MOM DEGREES ****

clear all
*
global variable "mom_edu" // determine group
global ts_data "$dta\BR_ts_$variable.dta"
use "$ts_data", clear

tab $variable
su $variable, 
global max=r(max)
global min=r(min)
global min_1=r(min)+1
di $max
di $min
di $min_1

global trend "bdate_w" // insert variable names
global season "bweek"
global tw_tm "tw"
global cutoff "2020w51"

*
preserve // get numbers for table later
collapse (sum) n_births if loco==1, by($variable)
egen total_births=sum(n_births)
gen prop= n_births/total_births
save "$dta/BR_obs_$variable.dta" ,replace
restore 

****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=$min/$max {
use "$ts_data", clear
keep if $variable==`i'
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season i.zika , irr
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
gen $variable=`i'
keep $variable cf_count se_cf_count cf_count_lb cf_count_ub
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
gen $variable=`i'
keep $variable countdiff countdiff_lb countdiff_ub
save "$dta/countdiff_estimate_`i'.dta", replace
restore
}

use "$dta/cf_estimate_$min", clear
forval i=$min_1/$max {
	append using "$dta/cf_estimate_`i'"
}

merge 1:1  $variable using "$dta/BR_obs_$variable.dta", nogen
order $variable n_births cf_count se_cf_count 
egen total_cf_count=sum(cf_count)
gen cf_prop=cf_count/total_cf_count
gen propdiff=prop-cf_prop
save "$dta/BR_cf_estimate.dta", replace

use "$dta/countdiff_estimate_$min", clear
forval i=$min_1/$max {
	append using "$dta/countdiff_estimate_`i'"
}

merge 1:1  $variable using "$dta/BR_cf_estimate.dta", nogen
order $variable n_births cf_count se_cf_count 
save "$dta/BR_cf_estimate.dta", replace

*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
set seed 123456789
forval d=1/10000 {
use "$dta/BR_cf_estimate.dta", clear
keep $variable cf_count se_cf_count prop
gen cf_count_i_d=rnormal(cf_count , se_cf_count) // generate random draw d from mean SE estimated from poisson ITS for each SIMD group i
egen sum_cf_count_i_d=sum(cf_count_i_d) // sum random draws d of all groups i
gen cf_prop_i_d=cf_count_i_d/sum_cf_count_i_d // create counterfactual proportion for each group i based on draw d
gen propdiff_i_d=prop- cf_prop_i_d // get m_i_d which is the difference in proportion between observed and counterfactual from draw d
keep $variable propdiff_i_d
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
_pctile propdiff_i_d if $variable==$min, percentiles(2.5) 
return list
gen propdiff_lb=r(r1) if $variable==$min
_pctile propdiff_i_d if $variable==$min, percentiles(97.5) 
return list
gen propdiff_ub=r(r1) if $variable==$min

forval i=$min_1/$max {
_pctile propdiff_i_d if $variable==`i', percentiles(2.5) 
return list
replace propdiff_lb=r(r1) if $variable==`i'
_pctile propdiff_i_d if $variable==`i', percentiles(97.5) 
return list
replace propdiff_ub=r(r1) if $variable==`i'
}

collapse propdiff_lb propdiff_ub, by($variable)
save "$dta/BR_prop_uncertainty", replace
use "$dta/BR_cf_estimate", clear
merge 1:1 $variable using "$dta/BR_prop_uncertainty", nogen
gen country="Brazil"
order country $variable n_births cf_count se_cf_count cf_count_lb cf_count_ub countdiff countdiff_lb countdiff_ub prop cf_prop propdiff propdiff_lb propdiff_ub total_births total_cf_count
save "$dta/BR_comp_diff_$variable", replace

**# Bookmark #38

******* MATERNAL AGE ************
******* MATERNAL AGE ************
******* MATERNAL AGE ************

clear all
*
global variable "mom_age_cat" // determine group
global ts_data "$dta\BR_ts_$variable.dta"
use "$ts_data", clear

tab $variable
su $variable, 
global max=r(max)
global min=r(min)
global min_1=r(min)+1
di $max
di $min
di $min_1

global trend "bdate_w" // insert variable names
global season "bweek"
global tw_tm "tw"
global cutoff "2020w51"

*
preserve // get numbers for table later
collapse (sum) n_births if loco==1, by($variable)
egen total_births=sum(n_births)
gen prop= n_births/total_births
save "$dta/BR_obs_$variable.dta" ,replace
restore 

****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=$min/$max {
use "$ts_data", clear
keep if $variable==`i'
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season i.zika , irr
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
gen $variable=`i'
keep $variable cf_count se_cf_count cf_count_lb cf_count_ub
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
gen $variable=`i'
keep $variable countdiff countdiff_lb countdiff_ub
save "$dta/countdiff_estimate_`i'.dta", replace
restore
}

use "$dta/cf_estimate_$min", clear
forval i=$min_1/$max {
	append using "$dta/cf_estimate_`i'"
}

merge 1:1  $variable using "$dta/BR_obs_$variable.dta", nogen
order $variable n_births cf_count se_cf_count 
egen total_cf_count=sum(cf_count)
gen cf_prop=cf_count/total_cf_count
gen propdiff=prop-cf_prop
save "$dta/BR_cf_estimate.dta", replace

use "$dta/countdiff_estimate_$min", clear
forval i=$min_1/$max {
	append using "$dta/countdiff_estimate_`i'"
}

merge 1:1  $variable using "$dta/BR_cf_estimate.dta", nogen
order $variable n_births cf_count se_cf_count 
save "$dta/BR_cf_estimate.dta", replace

*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
set seed 123456789
forval d=1/10000 {
use "$dta/BR_cf_estimate.dta", clear
keep $variable cf_count se_cf_count prop
gen cf_count_i_d=rnormal(cf_count , se_cf_count) // generate random draw d from mean SE estimated from poisson ITS for each SIMD group i
egen sum_cf_count_i_d=sum(cf_count_i_d) // sum random draws d of all groups i
gen cf_prop_i_d=cf_count_i_d/sum_cf_count_i_d // create counterfactual proportion for each group i based on draw d
gen propdiff_i_d=prop- cf_prop_i_d // get m_i_d which is the difference in proportion between observed and counterfactual from draw d
keep $variable propdiff_i_d
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
_pctile propdiff_i_d if $variable==$min, percentiles(2.5) 
return list
gen propdiff_lb=r(r1) if $variable==$min
_pctile propdiff_i_d if $variable==$min, percentiles(97.5) 
return list
gen propdiff_ub=r(r1) if $variable==$min

forval i=$min_1/$max {
_pctile propdiff_i_d if $variable==`i', percentiles(2.5) 
return list
replace propdiff_lb=r(r1) if $variable==`i'
_pctile propdiff_i_d if $variable==`i', percentiles(97.5) 
return list
replace propdiff_ub=r(r1) if $variable==`i'
}

collapse propdiff_lb propdiff_ub, by($variable)
save "$dta/BR_prop_uncertainty", replace
use "$dta/BR_cf_estimate", clear
merge 1:1 $variable using "$dta/BR_prop_uncertainty", nogen
gen country="Brazil"
order country $variable n_births cf_count se_cf_count cf_count_lb cf_count_ub countdiff countdiff_lb countdiff_ub prop cf_prop propdiff propdiff_lb propdiff_ub total_births total_cf_count
save "$dta/BR_comp_diff_$variable", replace

**# Bookmark #40

******* PARITY PARITY  ************
******* PARITY PARITY  ************
******* PARITY PARITY  ************

clear all
*
global variable "parity" // determine group
global ts_data "$dta\BR_ts_$variable.dta"
use "$ts_data", clear

tab $variable
su $variable, 
global max=r(max)
global min=r(min)
global min_1=r(min)+1
di $max
di $min
di $min_1

global trend "bdate_w" // insert variable names
global season "bweek"
global tw_tm "tw"
global cutoff "2020w51"

*
preserve // get numbers for table later
collapse (sum) n_births if loco==1, by($variable)
egen total_births=sum(n_births)
gen prop= n_births/total_births
save "$dta/BR_obs_$variable.dta" ,replace
restore 

****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=$min/$max {
use "$ts_data", clear
keep if $variable==`i'
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season i.zika , irr
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
gen $variable=`i'
keep $variable cf_count se_cf_count cf_count_lb cf_count_ub
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
gen $variable=`i'
keep $variable countdiff countdiff_lb countdiff_ub
save "$dta/countdiff_estimate_`i'.dta", replace
restore
}

use "$dta/cf_estimate_$min", clear
forval i=$min_1/$max {
	append using "$dta/cf_estimate_`i'"
}

merge 1:1  $variable using "$dta/BR_obs_$variable.dta", nogen
order $variable n_births cf_count se_cf_count 
egen total_cf_count=sum(cf_count)
gen cf_prop=cf_count/total_cf_count
gen propdiff=prop-cf_prop
save "$dta/BR_cf_estimate.dta", replace

use "$dta/countdiff_estimate_$min", clear
forval i=$min_1/$max {
	append using "$dta/countdiff_estimate_`i'"
}

merge 1:1  $variable using "$dta/BR_cf_estimate.dta", nogen
order $variable n_births cf_count se_cf_count 
save "$dta/BR_cf_estimate.dta", replace

*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
set seed 123456789
forval d=1/10000 {
use "$dta/BR_cf_estimate.dta", clear
keep $variable cf_count se_cf_count prop
gen cf_count_i_d=rnormal(cf_count , se_cf_count) // generate random draw d from mean SE estimated from poisson ITS for each SIMD group i
egen sum_cf_count_i_d=sum(cf_count_i_d) // sum random draws d of all groups i
gen cf_prop_i_d=cf_count_i_d/sum_cf_count_i_d // create counterfactual proportion for each group i based on draw d
gen propdiff_i_d=prop- cf_prop_i_d // get m_i_d which is the difference in proportion between observed and counterfactual from draw d
keep $variable propdiff_i_d
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
_pctile propdiff_i_d if $variable==$min, percentiles(2.5) 
return list
gen propdiff_lb=r(r1) if $variable==$min
_pctile propdiff_i_d if $variable==$min, percentiles(97.5) 
return list
gen propdiff_ub=r(r1) if $variable==$min

forval i=$min_1/$max {
_pctile propdiff_i_d if $variable==`i', percentiles(2.5) 
return list
replace propdiff_lb=r(r1) if $variable==`i'
_pctile propdiff_i_d if $variable==`i', percentiles(97.5) 
return list
replace propdiff_ub=r(r1) if $variable==`i'
}

collapse propdiff_lb propdiff_ub, by($variable)
save "$dta/BR_prop_uncertainty", replace
use "$dta/BR_cf_estimate", clear
merge 1:1 $variable using "$dta/BR_prop_uncertainty", nogen
gen country="Brazil"
order country $variable n_births cf_count se_cf_count cf_count_lb cf_count_ub countdiff countdiff_lb countdiff_ub prop cf_prop propdiff propdiff_lb propdiff_ub total_births total_cf_count
save "$dta/BR_comp_diff_$variable", replace

**# Bookmark #41

************** BRAZIL TABLE ***********
************** BRAZIL TABLE ***********
************** BRAZIL TABLE ***********

use "$dta/BR_comp_diff_mom_edu_years", clear
append using "$dta/BR_comp_diff_mom_edu"
append using "$dta/BR_comp_diff_mom_age_cat"
append using "$dta/BR_comp_diff_parity"
gen rel_count_diff=(n_births-cf_count)/(abs(cf_count))*100
gen rel_count_diff_ub=(n_births-cf_count_lb)/(abs(cf_count_lb))*100
gen rel_count_diff_lb=(n_births-cf_count_ub)/(abs(cf_count_ub))*100
order country mom_edu_years mom_edu mom_age_cat parity n_births cf_count se_cf_count cf_count_lb cf_count_ub countdiff countdiff_lb countdiff_ub rel_count_diff rel_count_diff_lb rel_count_diff_ub prop cf_prop propdiff propdiff_lb propdiff_ub total_births total_cf_count

drop se_cf_count
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

order country mom_edu_years mom_edu mom_age_cat parity n_births cf_count  cf_count_ci countdiff countdiff_ci  rel_count_diff rel_diff_ci prop cf_prop propdiff propdiff_ci total_births total_cf_count

save "$dta/BR_table_profile_$S_DATE", replace
export excel using "$table\BR_table_profile_$S_DATE.xls", firstrow(variables) replace


**# Bookmark #42

******************* COLOMBIA COLOMBIA ******************
******************* COLOMBIA COLOMBIA ******************
******************* COLOMBIA COLOMBIA ******************
******************* COLOMBIA COLOMBIA ******************

****** MAIN SEC variable, all categories
****** MAIN SEC variable, all categories

clear all
use "$dta/COL_ts", clear
global ts_data "$dta/COL_ts"
global variable "mom_edu_comp" // determine group
su $variable, 
global max=r(max)
global min=r(min)
global min_1=r(min)+1
di $max
di $min
di $min_1

global trend "mdate" // insert variable names
global season "month_nr"
global tw_tm "tm"
global cutoff "2020m12"

****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=$min/$max {
use "$ts_data.dta", clear
keep if $variable==`i'
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season i.zika , irr

quietly: margins, ///
at($trend=(660(1)743) loco=(0) zika=(0)) ///
at($trend=(731(1)743) loco=(1) zika=(0)) ///
predict(n) ///
saving("$dta/margins_ts_`i'.dta", replace)

preserve 
use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin lin_count
keep lin_count $trend loco
drop if loco==0 & $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/lin_pred_`i'.dta",replace

use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin cf_lin_count
keep cf_lin_count $trend loco
keep if loco==0 &  $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/cf_lin_pred_`i'.dta",replace
restore

}

use "$dta/lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/lin_pred_`i'"
}
save "$dta/lin_pred_all", replace

use "$dta/cf_lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/cf_lin_pred_`i'"
}
save "$dta/cf_lin_pred_all", replace


use "$ts_data", clear
merge 1:1 $trend $variable using "$dta/lin_pred_all", nogen
merge 1:1 $trend $variable using "$dta/cf_lin_pred_all", nogen

forval i=$min/$max {
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season i.zika if $variable==`i', irr
predict pred_count_`i' if $variable==`i'
}
gen pred_count=pred_count_$min
forval i=$min_1/$max{
	replace pred_count=pred_count_`i' if pred_count==.
}
drop pred_count_$min - pred_count_$max
*PLOT IT
forvalues i=$min/$max {
  local v : label ($variable) `i'
   display "`i' is `v'"
   }

local forlab: value label $variable
forvalues i = $min/$max {
	local label: label `forlab' `i'
	di "`label'" 

tw ///
(line pred_count $trend if $variable==`i', lwidth(thin) lcolor(gs10)) ///
(line lin_count $trend if loco==0 & $variable==`i', lwidth(medium) lcolor(black)) ///
(line cf_lin_count $trend if loco==1 & $variable==`i', lpattern(shortdash) lwidth(medium) lcolor(black)) ///
(line lin_count $trend if loco==1 & $variable==`i', lpattern(solid) lwidth(medium) lcolor(black)) ///
(scatter n_births $trend if $variable==`i', msize(vsmall) mcolor(ebblue%60) msym(o)) ///
, ///
xline(731, lpattern(solid) lcolor(red) lwidth(vthin)) ///
xt("Month of Birth") ///
xlab(660(24)731, ) ///
ylab(, angle(h)) ///
yt("Number of Live Births") ///
legend(order(5 "Observed" 1 "Fitted" 2 "Deseasonalised Fitted" 3 "Deseasonalised Expected") row(1)) ///
title("{bf:`label'}", size(medsmall)) ///
plotregion(lcolor(black)) ///
name(C`i', replace) ///
scheme(white_tableau)

}

*combine plots
grc1leg2 C1 C2 C3 C4, ///
legendfrom(C1) ///
position(6) lyoffset(0) lxoffset(0) ///
legscale(*1) plotregion(margin(zero)) imargin(tiny) ///
xtob1title ytol1title ///
title("Colombia, Maternal Education", size(medsmall)) ///
scheme(white_tableau)

graph export "$graph/COL_mom_edu_comp_$S_DATE.svg", replace

**# Bookmark #1


****** Maternal education in detail
****** Maternal education in detail

clear all
use "C:\Users\moritzob\OneDrive - University of Helsinki\postdoc life helsinki\LoCo-effect\LoCo-effect Colombia/dta/colombia_births_2015.dta", clear
tab mom_edu,m

global variable "mom_edu" // determine group
su $variable, 
global max=r(max)
global min=r(min)
global min_1=r(min)+1
di $max
di $min
di $min_1

global trend "mdate" // insert variable names
global season "month_nr"
global tw_tm "tm"
global cutoff "2020m12"

collapse zika loco $season (count) n_births= year, by($trend $variable)


save "$dta/COL_ts_$variable", replace
global ts_data "$dta/COL_ts_$variable"
****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=$min/$max {
use "$ts_data.dta", clear
keep if $variable==`i'
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season i.zika , irr

quietly: margins, ///
at($trend=(660(1)743) loco=(0) zika=(0)) ///
at($trend=(731(1)743) loco=(1) zika=(0)) ///
predict(n) ///
saving("$dta/margins_ts_`i'.dta", replace)

preserve 
use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin lin_count
keep lin_count $trend loco
drop if loco==0 & $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/lin_pred_`i'.dta",replace

use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin cf_lin_count
keep cf_lin_count $trend loco
keep if loco==0 &  $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/cf_lin_pred_`i'.dta",replace
restore

}

use "$dta/lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/lin_pred_`i'"
}
save "$dta/lin_pred_all", replace

use "$dta/cf_lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/cf_lin_pred_`i'"
}
save "$dta/cf_lin_pred_all", replace


use "$ts_data", clear
merge 1:1 $trend $variable using "$dta/lin_pred_all", nogen
merge 1:1 $trend $variable using "$dta/cf_lin_pred_all", nogen

forval i=$min/$max {
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season i.zika if $variable==`i', irr
predict pred_count_`i' if $variable==`i'
}
gen pred_count=pred_count_$min
forval i=$min_1/$max{
	replace pred_count=pred_count_`i' if pred_count==.
}
drop pred_count_$min - pred_count_$max
*PLOT IT
forvalues i=$min/$max {
  local v : label ($variable) `i'
   display "`i' is `v'"
   }

local forlab: value label $variable
forvalues i = $min/$max {
	local label: label `forlab' `i'
	di "`label'" 

tw ///
(line pred_count $trend if $variable==`i', lwidth(thin) lcolor(gs10)) ///
(line lin_count $trend if loco==0 & $variable==`i', lwidth(medium) lcolor(black)) ///
(line cf_lin_count $trend if loco==1 & $variable==`i', lpattern(shortdash) lwidth(medium) lcolor(black)) ///
(line lin_count $trend if loco==1 & $variable==`i', lpattern(solid) lwidth(medium) lcolor(black)) ///
(scatter n_births $trend if $variable==`i', msize(vsmall) mcolor(ebblue%60) msym(o)) ///
, ///
xline(731, lpattern(solid) lcolor(red) lwidth(vthin)) ///
xt("Month of Birth") ///
xlab(660(24)731, ) ///
ylab(, angle(h)) ///
yt("Number of Live Births") ///
legend(order(5 "Observed" 1 "Fitted" 2 "Deseasonalised Fitted" 3 "Deseasonalised Expected") row(2)) ///
title("{bf:`label'}", size(medsmall)) ///
plotregion(lcolor(black)) ///
name(C`i', replace) ///
scheme(white_tableau)

}

*combine plots
grc1leg2 C1 C2 C3 C4 C5 C6 C7, ///
legendfrom(C1) ///
position(4) ring(0) lyoffset(10) lxoffset(-10) ///
legscale(*1) plotregion(margin(zero)) imargin(tiny) ///
xtob1title ytol1title ///
title("Colombia, Maternal Education in Detail", size(medsmall)) ///
scheme(white_tableau)

graph export "$graph/COL_mom_edu_$S_DATE.svg", replace


**# Bookmark #44

****** MOM OR DAD HIGHEST EDU *********
****** MOM OR DAD HIGHEST EDU *********
****** MOM OR DAD HIGHEST EDU *********
****** MOM OR DAD HIGHEST EDU *********

clear all
use "C:\Users\moritzob\OneDrive - University of Helsinki\postdoc life helsinki\LoCo-effect\LoCo-effect Colombia/dta/colombia_births_2015.dta", clear
tab mom_dad_edu_comp,m

global variable "mom_dad_edu_comp" // determine group
su $variable, 
global max=r(max)
global min=r(min)
global min_1=r(min)+1
di $max
di $min
di $min_1

global trend "mdate" // insert variable names
global season "month_nr"
global tw_tm "tm"
global cutoff "2020m12"

collapse zika loco $season (count) n_births= year, by($trend $variable)


save "$dta/COL_ts_$variable", replace
global ts_data "$dta/COL_ts_$variable"


****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=$min/$max {
use "$ts_data.dta", clear
keep if $variable==`i'
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season i.zika , irr

quietly: margins, ///
at($trend=(660(1)743) loco=(0) zika=(0)) ///
at($trend=(731(1)743) loco=(1) zika=(0)) ///
predict(n) ///
saving("$dta/margins_ts_`i'.dta", replace)

preserve 
use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin lin_count
keep lin_count $trend loco
drop if loco==0 & $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/lin_pred_`i'.dta",replace

use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin cf_lin_count
keep cf_lin_count $trend loco
keep if loco==0 &  $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/cf_lin_pred_`i'.dta",replace
restore

}

use "$dta/lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/lin_pred_`i'"
}
save "$dta/lin_pred_all", replace

use "$dta/cf_lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/cf_lin_pred_`i'"
}
save "$dta/cf_lin_pred_all", replace


use "$ts_data", clear
merge 1:1 $trend $variable using "$dta/lin_pred_all", nogen
merge 1:1 $trend $variable using "$dta/cf_lin_pred_all", nogen

forval i=$min/$max {
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season i.zika if $variable==`i', irr
predict pred_count_`i' if $variable==`i'
}
gen pred_count=pred_count_$min
forval i=$min_1/$max{
	replace pred_count=pred_count_`i' if pred_count==.
}
drop pred_count_$min - pred_count_$max
*PLOT IT
forvalues i=$min/$max {
  local v : label ($variable) `i'
   display "`i' is `v'"
   }

local forlab: value label $variable
forvalues i = $min/$max {
	local label: label `forlab' `i'
	di "`label'" 

tw ///
(line pred_count $trend if $variable==`i', lwidth(thin) lcolor(gs10)) ///
(line lin_count $trend if loco==0 & $variable==`i', lwidth(medium) lcolor(black)) ///
(line cf_lin_count $trend if loco==1 & $variable==`i', lpattern(shortdash) lwidth(medium) lcolor(black)) ///
(line lin_count $trend if loco==1 & $variable==`i', lpattern(solid) lwidth(medium) lcolor(black)) ///
(scatter n_births $trend if $variable==`i', msize(vsmall) mcolor(ebblue%60) msym(o)) ///
, ///
xline(731, lpattern(solid) lcolor(red) lwidth(vthin)) ///
xt("Month of Birth") ///
xlab(660(24)731, ) ///
ylab(, angle(h)) ///
yt("Number of Live Births") ///
legend(order(5 "Observed" 1 "Fitted" 2 "Deseasonalised Fitted" 3 "Deseasonalised Expected") row(1)) ///
title("{bf:`label'}", size(medsmall)) ///
plotregion(lcolor(black)) ///
name(C`i', replace) ///
scheme(white_tableau)

}

*combine plots
grc1leg2 C1 C2 C3 C4, ///
legendfrom(C1) ///
position(6) lyoffset(0) lxoffset(0) ///
legscale(*1) plotregion(margin(zero)) imargin(tiny) ///
xtob1title ytol1title ///
title("Colombia, Highest of Parental Education", size(medsmall)) ///
scheme(white_tableau)

graph export "$graph/COL_mom_dad_edu_comp_$S_DATE.svg", replace

**# Bookmark #45
****** MOM AGE *********
****** MOM AGE *********
****** MOM AGE *********
****** MOM AGE *********

clear all
use "C:\Users\moritzob\OneDrive - University of Helsinki\postdoc life helsinki\LoCo-effect\LoCo-effect Colombia/dta/colombia_births_2015.dta", clear
tab mom_age_cat,m

global variable "mom_age_cat" // determine group
su $variable, 
global max=r(max)
global min=r(min)
global min_1=r(min)+1
di $max
di $min
di $min_1

global trend "mdate" // insert variable names
global season "month_nr"
global tw_tm "tm"
global cutoff "2020m12"

collapse zika loco $season (count) n_births= year, by($trend $variable)


save "$dta/COL_ts_$variable", replace
global ts_data "$dta/COL_ts_$variable"


****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=$min/$max {
use "$ts_data.dta", clear
keep if $variable==`i'
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season i.zika , irr

quietly: margins, ///
at($trend=(660(1)743) loco=(0) zika=(0)) ///
at($trend=(731(1)743) loco=(1) zika=(0)) ///
predict(n) ///
saving("$dta/margins_ts_`i'.dta", replace)

preserve 
use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin lin_count
keep lin_count $trend loco
drop if loco==0 & $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/lin_pred_`i'.dta",replace

use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin cf_lin_count
keep cf_lin_count $trend loco
keep if loco==0 &  $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/cf_lin_pred_`i'.dta",replace
restore

}

use "$dta/lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/lin_pred_`i'"
}
save "$dta/lin_pred_all", replace

use "$dta/cf_lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/cf_lin_pred_`i'"
}
save "$dta/cf_lin_pred_all", replace


use "$ts_data", clear
merge 1:1 $trend $variable using "$dta/lin_pred_all", nogen
merge 1:1 $trend $variable using "$dta/cf_lin_pred_all", nogen

forval i=$min/$max {
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season i.zika if $variable==`i', irr
predict pred_count_`i' if $variable==`i'
}
gen pred_count=pred_count_$min
forval i=$min_1/$max{
	replace pred_count=pred_count_`i' if pred_count==.
}
drop pred_count_$min - pred_count_$max
*PLOT IT
forvalues i=$min/$max {
  local v : label ($variable) `i'
   display "`i' is `v'"
   }

local forlab: value label $variable
forvalues i = $min/$max {
	local label: label `forlab' `i'
	di "`label'" 

tw ///
(line pred_count $trend if $variable==`i', lwidth(thin) lcolor(gs10)) ///
(line lin_count $trend if loco==0 & $variable==`i', lwidth(medium) lcolor(black)) ///
(line cf_lin_count $trend if loco==1 & $variable==`i', lpattern(shortdash) lwidth(medium) lcolor(black)) ///
(line lin_count $trend if loco==1 & $variable==`i', lpattern(solid) lwidth(medium) lcolor(black)) ///
(scatter n_births $trend if $variable==`i', msize(vsmall) mcolor(ebblue%60) msym(o)) ///
, ///
xline(731, lpattern(solid) lcolor(red) lwidth(vthin)) ///
xt("Month of Birth") ///
xlab(660(24)731, ) ///
ylab(, angle(h)) ///
yt("Number of Live Births") ///
legend(order(5 "Observed" 1 "Fitted" 2 "Deseasonalised Fitted" 3 "Deseasonalised Expected") row(1)) ///
title("{bf:`label'}", size(medsmall)) ///
plotregion(lcolor(black)) ///
name(C`i', replace) ///
scheme(white_tableau)

}

*combine plots
grc1leg2 C1 C2 C3 C4 C5 C6, ///
legendfrom(C1) ///
position(6) lyoffset(0) lxoffset(0) ///
legscale(*1) plotregion(margin(zero)) imargin(tiny) ///
xtob1title ytol1title ///
title("Colombia, Maternal Age", size(medsmall)) ///
scheme(white_tableau)

graph export "$graph/COL_mom_age_cat_$S_DATE.svg", replace

**# Bookmark #1

****** MOM PARITY  *********
****** MOM PARITY  *********
****** MOM PARITY  *********

clear all
use "C:\Users\moritzob\OneDrive - University of Helsinki\postdoc life helsinki\LoCo-effect\LoCo-effect Colombia/dta/colombia_births_2015.dta", clear
tab parity,m

global variable "parity" // determine group
su $variable, 
global max=r(max)
global min=r(min)
global min_1=r(min)+1
di $max
di $min
di $min_1

global trend "mdate" // insert variable names
global season "month_nr"
global tw_tm "tm"
global cutoff "2020m12"

collapse zika loco $season (count) n_births= year, by($trend $variable)


save "$dta/COL_ts_$variable", replace
global ts_data "$dta/COL_ts_$variable"


****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=$min/$max {
use "$ts_data.dta", clear
keep if $variable==`i'
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season i.zika , irr

quietly: margins, ///
at($trend=(660(1)743) loco=(0) zika=(0)) ///
at($trend=(731(1)743) loco=(1) zika=(0)) ///
predict(n) ///
saving("$dta/margins_ts_`i'.dta", replace)

preserve 
use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin lin_count
keep lin_count $trend loco
drop if loco==0 & $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/lin_pred_`i'.dta",replace

use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin cf_lin_count
keep cf_lin_count $trend loco
keep if loco==0 &  $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/cf_lin_pred_`i'.dta",replace
restore

}

use "$dta/lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/lin_pred_`i'"
}
save "$dta/lin_pred_all", replace

use "$dta/cf_lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/cf_lin_pred_`i'"
}
save "$dta/cf_lin_pred_all", replace


use "$ts_data", clear
merge 1:1 $trend $variable using "$dta/lin_pred_all", nogen
merge 1:1 $trend $variable using "$dta/cf_lin_pred_all", nogen

forval i=$min/$max {
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season i.zika if $variable==`i', irr
predict pred_count_`i' if $variable==`i'
}
gen pred_count=pred_count_$min
forval i=$min_1/$max{
	replace pred_count=pred_count_`i' if pred_count==.
}
drop pred_count_$min - pred_count_$max
*PLOT IT
forvalues i=$min/$max {
  local v : label ($variable) `i'
   display "`i' is `v'"
   }

local forlab: value label $variable
forvalues i = $min/$max {
	local label: label `forlab' `i'
	di "`label'" 

tw ///
(line pred_count $trend if $variable==`i', lwidth(thin) lcolor(gs10)) ///
(line lin_count $trend if loco==0 & $variable==`i', lwidth(medium) lcolor(black)) ///
(line cf_lin_count $trend if loco==1 & $variable==`i', lpattern(shortdash) lwidth(medium) lcolor(black)) ///
(line lin_count $trend if loco==1 & $variable==`i', lpattern(solid) lwidth(medium) lcolor(black)) ///
(scatter n_births $trend if $variable==`i', msize(vsmall) mcolor(ebblue%60) msym(o)) ///
, ///
xline(731, lpattern(solid) lcolor(red) lwidth(vthin)) ///
xt("Month of Birth") ///
xlab(660(24)731, ) ///
ylab(, angle(h)) ///
yt("Number of Live Births") ///
legend(order(5 "Observed" 1 "Fitted" 2 "Deseasonalised Fitted" 3 "Deseasonalised Expected") row(1)) ///
title("{bf:`label'}", size(medsmall)) ///
plotregion(lcolor(black)) ///
name(C`i', replace) ///
scheme(white_tableau)

}

*combine plots
grc1leg2 C1 C2 C3 C4 C5 C6, ///
legendfrom(C1) ///
position(6) lyoffset(0) lxoffset(0) ///
legscale(*1) plotregion(margin(zero)) imargin(tiny) ///
xtob1title ytol1title ///
title("Colombia, Parity", size(medsmall)) ///
scheme(white_tableau)

graph export "$graph/COL_parity_$S_DATE.svg", replace


**# Bookmark #2

****************************************************
****************************************************
*---------------- Tables ---------------------------
*---------------- Tables ---------------------------

**# Bookmark #24
****** HIGHEST EDU OF BOTH PARENTS ****
****** HIGHEST EDU OF BOTH PARENTS ****
****** HIGHEST EDU OF BOTH PARENTS ****´
clear all
*
global variable "mom_dad_edu_comp" // determine group
global ts_data "$dta\COL_ts_$variable.dta"
use "$ts_data", clear

tab $variable
su $variable, 
global max=r(max)
global min=r(min)
global min_1=r(min)+1
di $max
di $min
di $min_1

global trend "mdate" // insert variable names
global season "month_nr"
global tw_tm "tm"
global cutoff "2020m12"

*
preserve // get numbers for table later
collapse (sum) n_births if loco==1, by($variable)
egen total_births=sum(n_births)
gen prop= n_births/total_births
save "$dta/COL_obs_$variable.dta" ,replace
restore 

****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=$min/$max {
use "$ts_data", clear
keep if $variable==`i'
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season i.zika , irr
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
gen $variable=`i'
keep $variable cf_count se_cf_count cf_count_lb cf_count_ub
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
gen $variable=`i'
keep $variable countdiff countdiff_lb countdiff_ub
save "$dta/countdiff_estimate_`i'.dta", replace
restore
}

use "$dta/cf_estimate_$min", clear
forval i=$min_1/$max {
	append using "$dta/cf_estimate_`i'"
}

merge 1:1  $variable using "$dta/COL_obs_$variable.dta", nogen
order $variable n_births cf_count se_cf_count 
egen total_cf_count=sum(cf_count)
gen cf_prop=cf_count/total_cf_count
gen propdiff=prop-cf_prop
save "$dta/COL_cf_estimate.dta", replace

use "$dta/countdiff_estimate_$min", clear
forval i=$min_1/$max {
	append using "$dta/countdiff_estimate_`i'"
}

merge 1:1  $variable using "$dta/COL_cf_estimate.dta", nogen
order $variable n_births cf_count se_cf_count 
save "$dta/COL_cf_estimate.dta", replace

*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
set seed 123456789
forval d=1/10000 {
use "$dta/COL_cf_estimate.dta", clear
keep $variable cf_count se_cf_count prop
gen cf_count_i_d=rnormal(cf_count , se_cf_count) // generate random draw d from mean SE estimated from poisson ITS for each SIMD group i
egen sum_cf_count_i_d=sum(cf_count_i_d) // sum random draws d of all groups i
gen cf_prop_i_d=cf_count_i_d/sum_cf_count_i_d // create counterfactual proportion for each group i based on draw d
gen propdiff_i_d=prop- cf_prop_i_d // get m_i_d which is the difference in proportion between observed and counterfactual from draw d
keep $variable propdiff_i_d
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
_pctile propdiff_i_d if $variable==$min, percentiles(2.5) 
return list
gen propdiff_lb=r(r1) if $variable==$min
_pctile propdiff_i_d if $variable==$min, percentiles(97.5) 
return list
gen propdiff_ub=r(r1) if $variable==$min

forval i=$min_1/$max {
_pctile propdiff_i_d if $variable==`i', percentiles(2.5) 
return list
replace propdiff_lb=r(r1) if $variable==`i'
_pctile propdiff_i_d if $variable==`i', percentiles(97.5) 
return list
replace propdiff_ub=r(r1) if $variable==`i'
}

collapse propdiff_lb propdiff_ub, by($variable)
save "$dta/COL_prop_uncertainty", replace
use "$dta/COL_cf_estimate", clear
merge 1:1 $variable using "$dta/COL_prop_uncertainty", nogen
gen country="Colombia"
order country $variable n_births cf_count se_cf_count cf_count_lb cf_count_ub countdiff countdiff_lb countdiff_ub prop cf_prop propdiff propdiff_lb propdiff_ub total_births total_cf_count
save "$dta/COL_comp_diff_$variable", replace

**# Bookmark #2

****** MATERNAL EDUCATION IN DETAIL ****
****** MATERNAL EDUCATION IN DETAIL ****
****** MATERNAL EDUCATION IN DETAIL ****
clear all
*
global variable "mom_edu" // determine group
global ts_data "$dta\COL_ts_$variable.dta"
use "$ts_data", clear

tab $variable
su $variable, 
global max=r(max)
global min=r(min)
global min_1=r(min)+1
di $max
di $min
di $min_1

global trend "mdate" // insert variable names
global season "month_nr"
global tw_tm "tm"
global cutoff "2020m12"

*
preserve // get numbers for table later
collapse (sum) n_births if loco==1, by($variable)
egen total_births=sum(n_births)
gen prop= n_births/total_births
save "$dta/COL_obs_$variable.dta" ,replace
restore 

****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=$min/$max {
use "$ts_data", clear
keep if $variable==`i'
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season i.zika , irr
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
gen $variable=`i'
keep $variable cf_count se_cf_count cf_count_lb cf_count_ub
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
gen $variable=`i'
keep $variable countdiff countdiff_lb countdiff_ub
save "$dta/countdiff_estimate_`i'.dta", replace
restore
}

use "$dta/cf_estimate_$min", clear
forval i=$min_1/$max {
	append using "$dta/cf_estimate_`i'"
}

merge 1:1  $variable using "$dta/COL_obs_$variable.dta", nogen
order $variable n_births cf_count se_cf_count 
egen total_cf_count=sum(cf_count)
gen cf_prop=cf_count/total_cf_count
gen propdiff=prop-cf_prop
save "$dta/COL_cf_estimate.dta", replace

use "$dta/countdiff_estimate_$min", clear
forval i=$min_1/$max {
	append using "$dta/countdiff_estimate_`i'"
}

merge 1:1  $variable using "$dta/COL_cf_estimate.dta", nogen
order $variable n_births cf_count se_cf_count 
save "$dta/COL_cf_estimate.dta", replace

*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
set seed 123456789
forval d=1/10000 {
use "$dta/COL_cf_estimate.dta", clear
keep $variable cf_count se_cf_count prop
gen cf_count_i_d=rnormal(cf_count , se_cf_count) // generate random draw d from mean SE estimated from poisson ITS for each SIMD group i
egen sum_cf_count_i_d=sum(cf_count_i_d) // sum random draws d of all groups i
gen cf_prop_i_d=cf_count_i_d/sum_cf_count_i_d // create counterfactual proportion for each group i based on draw d
gen propdiff_i_d=prop- cf_prop_i_d // get m_i_d which is the difference in proportion between observed and counterfactual from draw d
keep $variable propdiff_i_d
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
_pctile propdiff_i_d if $variable==$min, percentiles(2.5) 
return list
gen propdiff_lb=r(r1) if $variable==$min
_pctile propdiff_i_d if $variable==$min, percentiles(97.5) 
return list
gen propdiff_ub=r(r1) if $variable==$min

forval i=$min_1/$max {
_pctile propdiff_i_d if $variable==`i', percentiles(2.5) 
return list
replace propdiff_lb=r(r1) if $variable==`i'
_pctile propdiff_i_d if $variable==`i', percentiles(97.5) 
return list
replace propdiff_ub=r(r1) if $variable==`i'
}

collapse propdiff_lb propdiff_ub, by($variable)
save "$dta/COL_prop_uncertainty", replace
use "$dta/COL_cf_estimate", clear
merge 1:1 $variable using "$dta/COL_prop_uncertainty", nogen
gen country="Colombia"
order country $variable n_births cf_count se_cf_count cf_count_lb cf_count_ub countdiff countdiff_lb countdiff_ub prop cf_prop propdiff propdiff_lb propdiff_ub total_births total_cf_count
save "$dta/COL_comp_diff_$variable", replace




**# Bookmark #25

********** MATERNAL AGE **********
********** MATERNAL AGE **********
********** MATERNAL AGE **********

clear all
*
global variable "mom_age_cat" // determine group
global ts_data "$dta\COL_ts_$variable.dta"
use "$ts_data", clear

tab $variable
su $variable, 
global max=r(max)
global min=r(min)
global min_1=r(min)+1
di $max
di $min
di $min_1

global trend "mdate" // insert variable names
global season "month_nr"
global tw_tm "tm"
global cutoff "2020m12"

*
preserve // get numbers for table later
collapse (sum) n_births if loco==1, by($variable)
egen total_births=sum(n_births)
gen prop= n_births/total_births
save "$dta/COL_obs_$variable.dta" ,replace
restore 

****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=$min/$max {
use "$ts_data", clear
keep if $variable==`i'
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season i.zika , irr
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
gen $variable=`i'
keep $variable cf_count se_cf_count cf_count_lb cf_count_ub
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
gen $variable=`i'
keep $variable countdiff countdiff_lb countdiff_ub
save "$dta/countdiff_estimate_`i'.dta", replace
restore
}

use "$dta/cf_estimate_$min", clear
forval i=$min_1/$max {
	append using "$dta/cf_estimate_`i'"
}

merge 1:1  $variable using "$dta/COL_obs_$variable.dta", nogen
order $variable n_births cf_count se_cf_count 
egen total_cf_count=sum(cf_count)
gen cf_prop=cf_count/total_cf_count
gen propdiff=prop-cf_prop
save "$dta/COL_cf_estimate.dta", replace

use "$dta/countdiff_estimate_$min", clear
forval i=$min_1/$max {
	append using "$dta/countdiff_estimate_`i'"
}

merge 1:1  $variable using "$dta/COL_cf_estimate.dta", nogen
order $variable n_births cf_count se_cf_count 
save "$dta/COL_cf_estimate.dta", replace

*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
set seed 123456789
forval d=1/10000 {
use "$dta/COL_cf_estimate.dta", clear
keep $variable cf_count se_cf_count prop
gen cf_count_i_d=rnormal(cf_count , se_cf_count) // generate random draw d from mean SE estimated from poisson ITS for each SIMD group i
egen sum_cf_count_i_d=sum(cf_count_i_d) // sum random draws d of all groups i
gen cf_prop_i_d=cf_count_i_d/sum_cf_count_i_d // create counterfactual proportion for each group i based on draw d
gen propdiff_i_d=prop- cf_prop_i_d // get m_i_d which is the difference in proportion between observed and counterfactual from draw d
keep $variable propdiff_i_d
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
_pctile propdiff_i_d if $variable==$min, percentiles(2.5) 
return list
gen propdiff_lb=r(r1) if $variable==$min
_pctile propdiff_i_d if $variable==$min, percentiles(97.5) 
return list
gen propdiff_ub=r(r1) if $variable==$min

forval i=$min_1/$max {
_pctile propdiff_i_d if $variable==`i', percentiles(2.5) 
return list
replace propdiff_lb=r(r1) if $variable==`i'
_pctile propdiff_i_d if $variable==`i', percentiles(97.5) 
return list
replace propdiff_ub=r(r1) if $variable==`i'
}

collapse propdiff_lb propdiff_ub, by($variable)
save "$dta/COL_prop_uncertainty", replace
use "$dta/COL_cf_estimate", clear
merge 1:1 $variable using "$dta/COL_prop_uncertainty", nogen
gen country="Colombia"
order country $variable n_births cf_count se_cf_count cf_count_lb cf_count_ub countdiff countdiff_lb countdiff_ub prop cf_prop propdiff propdiff_lb propdiff_ub total_births total_cf_count
save "$dta/COL_comp_diff_$variable", replace



**# Bookmark #26
********** PARITY **********
********** PARITY **********
********** PARITY **********

clear all
*
global variable "parity" // determine group
global ts_data "$dta\COL_ts_$variable.dta"
use "$ts_data", clear

tab $variable
su $variable, 
global max=r(max)
global min=r(min)
global min_1=r(min)+1
di $max
di $min
di $min_1

global trend "mdate" // insert variable names
global season "month_nr"
global tw_tm "tm"
global cutoff "2020m12"

*
preserve // get numbers for table later
collapse (sum) n_births if loco==1, by($variable)
egen total_births=sum(n_births)
gen prop= n_births/total_births
save "$dta/COL_obs_$variable.dta" ,replace
restore 

****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=$min/$max {
use "$ts_data", clear
keep if $variable==`i'
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season i.zika , irr
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
gen $variable=`i'
keep $variable cf_count se_cf_count cf_count_lb cf_count_ub
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
gen $variable=`i'
keep $variable countdiff countdiff_lb countdiff_ub
save "$dta/countdiff_estimate_`i'.dta", replace
restore
}

use "$dta/cf_estimate_$min", clear
forval i=$min_1/$max {
	append using "$dta/cf_estimate_`i'"
}

merge 1:1  $variable using "$dta/COL_obs_$variable.dta", nogen
order $variable n_births cf_count se_cf_count 
egen total_cf_count=sum(cf_count)
gen cf_prop=cf_count/total_cf_count
gen propdiff=prop-cf_prop
save "$dta/COL_cf_estimate.dta", replace

use "$dta/countdiff_estimate_$min", clear
forval i=$min_1/$max {
	append using "$dta/countdiff_estimate_`i'"
}

merge 1:1  $variable using "$dta/COL_cf_estimate.dta", nogen
order $variable n_births cf_count se_cf_count 
save "$dta/COL_cf_estimate.dta", replace

*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
set seed 123456789
forval d=1/10000 {
use "$dta/COL_cf_estimate.dta", clear
keep $variable cf_count se_cf_count prop
gen cf_count_i_d=rnormal(cf_count , se_cf_count) // generate random draw d from mean SE estimated from poisson ITS for each SIMD group i
egen sum_cf_count_i_d=sum(cf_count_i_d) // sum random draws d of all groups i
gen cf_prop_i_d=cf_count_i_d/sum_cf_count_i_d // create counterfactual proportion for each group i based on draw d
gen propdiff_i_d=prop- cf_prop_i_d // get m_i_d which is the difference in proportion between observed and counterfactual from draw d
keep $variable propdiff_i_d
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
_pctile propdiff_i_d if $variable==$min, percentiles(2.5) 
return list
gen propdiff_lb=r(r1) if $variable==$min
_pctile propdiff_i_d if $variable==$min, percentiles(97.5) 
return list
gen propdiff_ub=r(r1) if $variable==$min

forval i=$min_1/$max {
_pctile propdiff_i_d if $variable==`i', percentiles(2.5) 
return list
replace propdiff_lb=r(r1) if $variable==`i'
_pctile propdiff_i_d if $variable==`i', percentiles(97.5) 
return list
replace propdiff_ub=r(r1) if $variable==`i'
}

collapse propdiff_lb propdiff_ub, by($variable)
save "$dta/COL_prop_uncertainty", replace
use "$dta/COL_cf_estimate", clear
merge 1:1 $variable using "$dta/COL_prop_uncertainty", nogen
gen country="Colombia"
order country $variable n_births cf_count se_cf_count cf_count_lb cf_count_ub countdiff countdiff_lb countdiff_ub prop cf_prop propdiff propdiff_lb propdiff_ub total_births total_cf_count
save "$dta/COL_comp_diff_$variable", replace


**# Bookmark #27
************** COLOMBIA TABLE ***********
************** COLOMBIA TABLE ***********
************** COLOMBIA TABLE ***********

use "$dta/COL_comp_diff_mom_dad_edu_comp",clear
append using "$dta/COL_comp_diff_mom_edu"
append using "$dta/COL_comp_diff_mom_age_cat"
append using "$dta/COL_comp_diff_parity"
gen rel_count_diff=(n_births-cf_count)/(abs(cf_count))*100
gen rel_count_diff_ub=(n_births-cf_count_lb)/(abs(cf_count_lb))*100
gen rel_count_diff_lb=(n_births-cf_count_ub)/(abs(cf_count_ub))*100
order country  mom_dad_edu_comp mom_age_cat parity n_births cf_count se_cf_count cf_count_lb cf_count_ub countdiff countdiff_lb countdiff_ub rel_count_diff rel_count_diff_lb rel_count_diff_ub prop cf_prop propdiff propdiff_lb propdiff_ub total_births total_cf_count

drop se_cf_count
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

order country mom_dad_edu_comp mom_edu mom_age_cat parity n_births cf_count  cf_count_ci countdiff countdiff_ci  rel_count_diff rel_diff_ci prop cf_prop propdiff propdiff_ci total_births total_cf_count

save "$dta/COL_table_profile_$S_DATE", replace
export excel using "$table\COL_table_profile_$S_DATE.xls", firstrow(variables) replace



**# Bookmark #4

*************************** ECuADOR  ECuADOR ECuADOR ******************************
*************************** ECuADOR  ECuADOR ECuADOR ******************************
*************************** ECuADOR  ECuADOR ECuADOR ******************************
*************************** ECuADOR  ECuADOR ECuADOR ******************************

****** MAIN SEC variable, all categories
****** MAIN SEC variable, all categories
clear all
use "$dta/ECU_ts", clear
global ts_data "$dta/ECU_ts"
global variable "area_deprivation" // determine group
su $variable, 
global max=r(max)
global min=r(min)
global min_1=r(min)+1
di $max
di $min
di $min_1

global trend "bdate_w" // insert variable names
global season "bweek"
global tw_tm "tw"
global cutoff "2020w51"

****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=$min/$max {
use "$ts_data.dta", clear
keep if $variable==`i'
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season i.zika , irr

quietly: margins, ///
at($trend=(2860(1)3223) loco=0 zika=0) ///
at($trend=(3170(1)3223) loco=1 zika=0) ///
predict(n) ///
saving("$dta/margins_ts_`i'.dta", replace)

preserve 
use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin lin_count
keep lin_count $trend loco
drop if loco==0 & $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/lin_pred_`i'.dta",replace

use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin cf_lin_count
keep cf_lin_count $trend loco
keep if loco==0 &  $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/cf_lin_pred_`i'.dta",replace
restore

}

use "$dta/lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/lin_pred_`i'"
}
save "$dta/lin_pred_all", replace

use "$dta/cf_lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/cf_lin_pred_`i'"
}
save "$dta/cf_lin_pred_all", replace


use "$ts_data", clear
merge 1:1 $trend $variable using "$dta/lin_pred_all", nogen
merge 1:1 $trend $variable using "$dta/cf_lin_pred_all", nogen

forval i=$min/$max {
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season i.zika if $variable==`i', irr
predict pred_count_`i' if $variable==`i'
}
gen pred_count=pred_count_$min
forval i=$min_1/$max{
	replace pred_count=pred_count_`i' if pred_count==.
}
drop pred_count_$min - pred_count_$max
*PLOT IT
forvalues i=$min/$max {
  local v : label ($variable) `i'
   display "`i' is `v'"
   }

local forlab: value label $variable
forvalues i = $min/$max {
	local label: label `forlab' `i'
	di "`label'" 

tw ///
(line pred_count $trend if $variable==`i', lwidth(thin) lcolor(gs10)) ///
(line lin_count $trend if loco==0 & $variable==`i', lwidth(medium) lcolor(black)) ///
(line cf_lin_count $trend if loco==1 & $variable==`i', lpattern(shortdash) lwidth(medium) lcolor(black)) ///
(line lin_count $trend if loco==1 & $variable==`i', lpattern(solid) lwidth(medium) lcolor(black)) ///
(scatter n_births $trend if $variable==`i', msize(vsmall) mcolor(ebblue%60) msym(o)) ///
, ///
xline(3170, lpattern(solid) lcolor(red) lwidth(vthin)) ///
xt("Week of Birth") ///
xlab(2860(104)3223, angle(h) ) ///
ylab(, angle(h)) ///
yt("Number of Live Births") ///
legend(order(5 "Observed" 1 "Fitted" 2 "Deseasonalised Fitted" 3 "Deseasonalised Expected") col(1)) ///
title("{bf:`label'}", size(medsmall)) ///
plotregion(lcolor(black)) ///
name(C`i', replace) ///
scheme(white_tableau)

}

*combine plots
grc1leg2 C1 C2 C3 C4 C5, ///
legendfrom(C1) ///
position(4) ring(0) lyoffset(10) lxoffset(0) ///
legscale(*1) plotregion(margin(zero)) imargin(tiny) ///
xtob1title ytol1title ///
title("Ecuador, Area Deprivation", size(medsmall)) ///
scheme(white_tableau)

graph export "$graph/ECU_area_deprivation_$S_DATE.svg", replace


**# Bookmark #5


****** Maternal AGE  ***
****** Maternal AGE  ***
****** Maternal AGE  ***
****** Maternal AGE  ***

clear all

use "C:\Users\moritzob\OneDrive - University of Helsinki\postdoc life helsinki\LoCo-effect\LoCo-effect Ecuador/dta/Ecuador_births_DPI_2015_2021.dta", clear
tab mom_age_cat, m

global variable "mom_age_cat" // determine group
su $variable, 
global max=r(max)
global min=r(min)
global min_1=r(min)+1
di $max
di $min
di $min_1

global trend "bdate_w" // insert variable names
global season "bweek"
global tw_tm "tw"
global cutoff "2020w51"

*create ts_data
collapse zika loco $season (count) n_births= year, by($trend $variable)


save "$dta/ECU_ts_$variable", replace
global ts_data "$dta/ECU_ts_$variable"


****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=$min/$max {
use "$ts_data.dta", clear
keep if $variable==`i'
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season i.zika , irr

quietly: margins, ///
at($trend=(2860(1)3223) loco=0 zika=0) ///
at($trend=(3170(1)3223) loco=1 zika=0) ///
predict(n) ///
saving("$dta/margins_ts_`i'.dta", replace)

preserve 
use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin lin_count
keep lin_count $trend loco
drop if loco==0 & $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/lin_pred_`i'.dta",replace

use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin cf_lin_count
keep cf_lin_count $trend loco
keep if loco==0 &  $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/cf_lin_pred_`i'.dta",replace
restore

}

use "$dta/lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/lin_pred_`i'"
}
save "$dta/lin_pred_all", replace

use "$dta/cf_lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/cf_lin_pred_`i'"
}
save "$dta/cf_lin_pred_all", replace


use "$ts_data", clear
merge 1:1 $trend $variable using "$dta/lin_pred_all", nogen
merge 1:1 $trend $variable using "$dta/cf_lin_pred_all", nogen

forval i=$min/$max {
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season i.zika if $variable==`i', irr
predict pred_count_`i' if $variable==`i'
}
gen pred_count=pred_count_$min
forval i=$min_1/$max{
	replace pred_count=pred_count_`i' if pred_count==.
}
drop pred_count_$min - pred_count_$max
*PLOT IT
forvalues i=$min/$max {
  local v : label ($variable) `i'
   display "`i' is `v'"
   }

local forlab: value label $variable
forvalues i = $min/$max {
	local label: label `forlab' `i'
	di "`label'" 

tw ///
(line pred_count $trend if $variable==`i', lwidth(thin) lcolor(gs10)) ///
(line lin_count $trend if loco==0 & $variable==`i', lwidth(medium) lcolor(black)) ///
(line cf_lin_count $trend if loco==1 & $variable==`i', lpattern(shortdash) lwidth(medium) lcolor(black)) ///
(line lin_count $trend if loco==1 & $variable==`i', lpattern(solid) lwidth(medium) lcolor(black)) ///
(scatter n_births $trend if $variable==`i', msize(vsmall) mcolor(ebblue%60) msym(o)) ///
, ///
xline(3170, lpattern(solid) lcolor(red) lwidth(vthin)) ///
xt("Week of Birth") ///
xlab(2860(104)3223, angle(h) ) ///
ylab(, angle(h)) ///
yt("Number of Live Births") ///
legend(order(5 "Observed" 1 "Fitted" 2 "Deseasonalised Fitted" 3 "Deseasonalised Expected") row(1)) ///
title("{bf:`label'}", size(medsmall)) ///
plotregion(lcolor(black)) ///
name(C`i', replace) ///
scheme(white_tableau)

}

*combine plots
grc1leg2 C1 C2 C3 C4 C5 C6, ///
legendfrom(C1) ///
position(6) lyoffset(0) lxoffset(0) ///
legscale(*1) plotregion(margin(zero)) imargin(tiny) ///
xtob1title ytol1title ///
title("Ecuador, Maternal Age", size(medsmall)) ///
scheme(white_tableau)

graph export "$graph/ECU_mom_age_cat_$S_DATE.svg", replace

**# Bookmark #6

****** PARITY *******
****** PARITY *******
****** PARITY *******
****** PARITY *******
clear all

use "C:\Users\moritzob\OneDrive - University of Helsinki\postdoc life helsinki\LoCo-effect\LoCo-effect Ecuador/dta/Ecuador_births_DPI_2015_2021.dta", clear
tab liv_child, m

global variable "liv_child" // determine group
su $variable, 
global max=r(max)
global min=r(min)
global min_1=r(min)+1
di $max
di $min
di $min_1

global trend "bdate_w" // insert variable names
global season "bweek"
global tw_tm "tw"
global cutoff "2020w51"

*create ts_data
collapse zika loco $season (count) n_births= year, by($trend $variable)


save "$dta/ECU_ts_$variable", replace
global ts_data "$dta/ECU_ts_$variable"


****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=$min/$max {
use "$ts_data.dta", clear
keep if $variable==`i'
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season i.zika , irr

quietly: margins, ///
at($trend=(2860(1)3223) loco=0 zika=0) ///
at($trend=(3170(1)3223) loco=1 zika=0) ///
predict(n) ///
saving("$dta/margins_ts_`i'.dta", replace)

preserve 
use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin lin_count
keep lin_count $trend loco
drop if loco==0 & $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/lin_pred_`i'.dta",replace

use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin cf_lin_count
keep cf_lin_count $trend loco
keep if loco==0 &  $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/cf_lin_pred_`i'.dta",replace
restore

}

use "$dta/lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/lin_pred_`i'"
}
save "$dta/lin_pred_all", replace

use "$dta/cf_lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/cf_lin_pred_`i'"
}
save "$dta/cf_lin_pred_all", replace


use "$ts_data", clear
merge 1:1 $trend $variable using "$dta/lin_pred_all", nogen
merge 1:1 $trend $variable using "$dta/cf_lin_pred_all", nogen

forval i=$min/$max {
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season i.zika if $variable==`i', irr
predict pred_count_`i' if $variable==`i'
}
gen pred_count=pred_count_$min
forval i=$min_1/$max{
	replace pred_count=pred_count_`i' if pred_count==.
}
drop pred_count_$min - pred_count_$max
*PLOT IT
forvalues i=$min/$max {
  local v : label ($variable) `i'
   display "`i' is `v'"
   }

local forlab: value label $variable
forvalues i = $min/$max {
	local label: label `forlab' `i'
	di "`label'" 

tw ///
(line pred_count $trend if $variable==`i', lwidth(thin) lcolor(gs10)) ///
(line lin_count $trend if loco==0 & $variable==`i', lwidth(medium) lcolor(black)) ///
(line cf_lin_count $trend if loco==1 & $variable==`i', lpattern(shortdash) lwidth(medium) lcolor(black)) ///
(line lin_count $trend if loco==1 & $variable==`i', lpattern(solid) lwidth(medium) lcolor(black)) ///
(scatter n_births $trend if $variable==`i', msize(vsmall) mcolor(ebblue%60) msym(o)) ///
, ///
xline(3170, lpattern(solid) lcolor(red) lwidth(vthin)) ///
xt("Week of Birth") ///
xlab(2860(104)3223, angle(h) ) ///
ylab(, angle(h)) ///
yt("Number of Live Births") ///
legend(order(5 "Observed" 1 "Fitted" 2 "Deseasonalised Fitted" 3 "Deseasonalised Expected") col(1)) ///
title("{bf:`label'}", size(medsmall)) ///
plotregion(lcolor(black)) ///
name(C`i', replace) ///
scheme(white_tableau)

}

*combine plots
grc1leg2 C1 C2 C3 C4 C5, ///
legendfrom(C1) ///
position(4) ring(0) lyoffset(10) lxoffset(0) ///
legscale(*1) plotregion(margin(zero)) imargin(tiny) ///
xtob1title ytol1title ///
title("Ecuador, Living Children", size(medsmall)) ///
scheme(white_tableau)

graph export "$graph/ECU_liv_child_$S_DATE.svg", replace


**# Bookmark #7


****************************************************
****************************************************
*---------------- Tables ---------------------------
*---------------- Tables ---------------------------

**** MOM AGE *******
**** MOM AGE *******
**** MOM AGE *******

clear all
*
global variable "mom_age_cat" // determine group
global ts_data "$dta\ECU_ts_$variable.dta"
use "$ts_data", clear

tab $variable
su $variable, 
global max=r(max)
global min=r(min)
global min_1=r(min)+1
di $max
di $min
di $min_1

global trend "bdate_w" // insert variable names
global season "bweek"
global tw_tm "tw"
global cutoff "2020w51"

*
preserve // get numbers for table later
collapse (sum) n_births if loco==1, by($variable)
egen total_births=sum(n_births)
gen prop= n_births/total_births
save "$dta/ECU_obs_$variable.dta" ,replace
restore 

****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=$min/$max {
use "$ts_data", clear
keep if $variable==`i'
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season i.zika , irr
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
gen $variable=`i'
keep $variable cf_count se_cf_count cf_count_lb cf_count_ub
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
gen $variable=`i'
keep $variable countdiff countdiff_lb countdiff_ub
save "$dta/countdiff_estimate_`i'.dta", replace
restore
}

use "$dta/cf_estimate_$min", clear
forval i=$min_1/$max {
	append using "$dta/cf_estimate_`i'"
}

merge 1:1  $variable using "$dta/ECU_obs_$variable.dta", nogen
order $variable n_births cf_count se_cf_count 
egen total_cf_count=sum(cf_count)
gen cf_prop=cf_count/total_cf_count
gen propdiff=prop-cf_prop
save "$dta/ECU_cf_estimate.dta", replace

use "$dta/countdiff_estimate_$min", clear
forval i=$min_1/$max {
	append using "$dta/countdiff_estimate_`i'"
}

merge 1:1  $variable using "$dta/ECU_cf_estimate.dta", nogen
order $variable n_births cf_count se_cf_count 
save "$dta/ECU_cf_estimate.dta", replace

*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
set seed 123456789
forval d=1/10000 {
use "$dta/ECU_cf_estimate.dta", clear
keep $variable cf_count se_cf_count prop
gen cf_count_i_d=rnormal(cf_count , se_cf_count) // generate random draw d from mean SE estimated from poisson ITS for each SIMD group i
egen sum_cf_count_i_d=sum(cf_count_i_d) // sum random draws d of all groups i
gen cf_prop_i_d=cf_count_i_d/sum_cf_count_i_d // create counterfactual proportion for each group i based on draw d
gen propdiff_i_d=prop- cf_prop_i_d // get m_i_d which is the difference in proportion between observed and counterfactual from draw d
keep $variable propdiff_i_d
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
_pctile propdiff_i_d if $variable==$min, percentiles(2.5) 
return list
gen propdiff_lb=r(r1) if $variable==$min
_pctile propdiff_i_d if $variable==$min, percentiles(97.5) 
return list
gen propdiff_ub=r(r1) if $variable==$min

forval i=$min_1/$max {
_pctile propdiff_i_d if $variable==`i', percentiles(2.5) 
return list
replace propdiff_lb=r(r1) if $variable==`i'
_pctile propdiff_i_d if $variable==`i', percentiles(97.5) 
return list
replace propdiff_ub=r(r1) if $variable==`i'
}

collapse propdiff_lb propdiff_ub, by($variable)
save "$dta/ECU_prop_uncertainty", replace
use "$dta/ECU_cf_estimate", clear
merge 1:1 $variable using "$dta/ECU_prop_uncertainty", nogen
gen country="Ecuador"
order country $variable n_births cf_count se_cf_count cf_count_lb cf_count_ub countdiff countdiff_lb countdiff_ub prop cf_prop propdiff propdiff_lb propdiff_ub total_births total_cf_count
save "$dta/ECU_comp_diff_$variable", replace


**# Bookmark #9

**** PARITY *******
**** PARITY *******
**** PARITY *******

clear all
*
global variable "liv_child" // determine group
global ts_data "$dta\ECU_ts_$variable.dta"
use "$ts_data", clear

tab $variable
su $variable, 
global max=r(max)
global min=r(min)
global min_1=r(min)+1
di $max
di $min
di $min_1

global trend "bdate_w" // insert variable names
global season "bweek"
global tw_tm "tw"
global cutoff "2020w51"

*
preserve // get numbers for table later
collapse (sum) n_births if loco==1, by($variable)
egen total_births=sum(n_births)
gen prop= n_births/total_births
save "$dta/ECU_obs_$variable.dta" ,replace
restore 

****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=$min/$max {
use "$ts_data", clear
keep if $variable==`i'
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season i.zika , irr
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
gen $variable=`i'
keep $variable cf_count se_cf_count cf_count_lb cf_count_ub
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
gen $variable=`i'
keep $variable countdiff countdiff_lb countdiff_ub
save "$dta/countdiff_estimate_`i'.dta", replace
restore
}

use "$dta/cf_estimate_$min", clear
forval i=$min_1/$max {
	append using "$dta/cf_estimate_`i'"
}

merge 1:1  $variable using "$dta/ECU_obs_$variable.dta", nogen
order $variable n_births cf_count se_cf_count 
egen total_cf_count=sum(cf_count)
gen cf_prop=cf_count/total_cf_count
gen propdiff=prop-cf_prop
save "$dta/ECU_cf_estimate.dta", replace

use "$dta/countdiff_estimate_$min", clear
forval i=$min_1/$max {
	append using "$dta/countdiff_estimate_`i'"
}

merge 1:1  $variable using "$dta/ECU_cf_estimate.dta", nogen
order $variable n_births cf_count se_cf_count 
save "$dta/ECU_cf_estimate.dta", replace

*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
set seed 123456789
forval d=1/10000 {
use "$dta/ECU_cf_estimate.dta", clear
keep $variable cf_count se_cf_count prop
gen cf_count_i_d=rnormal(cf_count , se_cf_count) // generate random draw d from mean SE estimated from poisson ITS for each SIMD group i
egen sum_cf_count_i_d=sum(cf_count_i_d) // sum random draws d of all groups i
gen cf_prop_i_d=cf_count_i_d/sum_cf_count_i_d // create counterfactual proportion for each group i based on draw d
gen propdiff_i_d=prop- cf_prop_i_d // get m_i_d which is the difference in proportion between observed and counterfactual from draw d
keep $variable propdiff_i_d
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
_pctile propdiff_i_d if $variable==$min, percentiles(2.5) 
return list
gen propdiff_lb=r(r1) if $variable==$min
_pctile propdiff_i_d if $variable==$min, percentiles(97.5) 
return list
gen propdiff_ub=r(r1) if $variable==$min

forval i=$min_1/$max {
_pctile propdiff_i_d if $variable==`i', percentiles(2.5) 
return list
replace propdiff_lb=r(r1) if $variable==`i'
_pctile propdiff_i_d if $variable==`i', percentiles(97.5) 
return list
replace propdiff_ub=r(r1) if $variable==`i'
}

collapse propdiff_lb propdiff_ub, by($variable)
save "$dta/ECU_prop_uncertainty", replace
use "$dta/ECU_cf_estimate", clear
merge 1:1 $variable using "$dta/ECU_prop_uncertainty", nogen
gen country="Ecuador"
order country $variable n_births cf_count se_cf_count cf_count_lb cf_count_ub countdiff countdiff_lb countdiff_ub prop cf_prop propdiff propdiff_lb propdiff_ub total_births total_cf_count
save "$dta/ECU_comp_diff_$variable", replace
**# Bookmark #10

************** ECUADOR TABLE ***********
************** ECUADOR TABLE ***********
************** ECUADOR TABLE ***********
use "$dta/ECU_comp_diff",clear
append using "$dta/ECU_comp_diff_mom_age_cat"
append using "$dta/ECU_comp_diff_liv_child"
gen rel_count_diff=(n_births-cf_count)/(abs(cf_count))*100
gen rel_count_diff_ub=(n_births-cf_count_lb)/(abs(cf_count_lb))*100
gen rel_count_diff_lb=(n_births-cf_count_ub)/(abs(cf_count_ub))*100
order country  area_deprivation mom_age_cat liv_child n_births cf_count se_cf_count cf_count_lb cf_count_ub countdiff countdiff_lb countdiff_ub rel_count_diff rel_count_diff_lb rel_count_diff_ub prop cf_prop propdiff propdiff_lb propdiff_ub total_births total_cf_count

drop se_cf_count
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

order country area_deprivation mom_age_cat liv_child n_births cf_count  cf_count_ci countdiff countdiff_ci  rel_count_diff rel_diff_ci prop cf_prop propdiff propdiff_ci total_births total_cf_count

save "$dta/ECU_table_profile_$S_DATE", replace
export excel using "$table\ECU_table_profile_$S_DATE.xls", firstrow(variables) replace



**# Bookmark #11

******************* ENGLAND ENGLAND ENGLAND ****************
******************* ENGLAND ENGLAND ENGLAND ****************
******************* ENGLAND ENGLAND ENGLAND ****************
******************* ENGLAND ENGLAND ENGLAND ****************

clear all
use "$dta/ENG_ts", clear
global ts_data "$dta/ENG_ts"
global variable "area_deprivation" // determine group
su $variable, 
global max=r(max)
global min=r(min)
global min_1=r(min)+1
di $max
di $min
di $min_1

global trend "mdate" // insert variable names
global season "month_nr"
global tw_tm "tm"
global cutoff "2020m12"

****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=$min/$max {
use "$ts_data.dta", clear
keep if $variable==`i'
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season , irr

quietly: margins, ///
at($trend=(660(1)743) loco=(0)) ///
at($trend=(731(1)743) loco=(1)) ///
predict(n) ///
saving("$dta/margins_ts_`i'.dta", replace)

preserve 
use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin lin_count
keep lin_count $trend loco
drop if loco==0 & $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/lin_pred_`i'.dta",replace

use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin cf_lin_count
keep cf_lin_count $trend loco
keep if loco==0 &  $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/cf_lin_pred_`i'.dta",replace
restore

}

use "$dta/lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/lin_pred_`i'"
}
save "$dta/lin_pred_all", replace

use "$dta/cf_lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/cf_lin_pred_`i'"
}
save "$dta/cf_lin_pred_all", replace


use "$ts_data", clear
merge 1:1 $trend $variable using "$dta/lin_pred_all", nogen
merge 1:1 $trend $variable using "$dta/cf_lin_pred_all", nogen

forval i=$min/$max {
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season if $variable==`i', irr
predict pred_count_`i' if $variable==`i'
}
gen pred_count=pred_count_$min
forval i=$min_1/$max{
	replace pred_count=pred_count_`i' if pred_count==.
}
drop pred_count_$min - pred_count_$max
*PLOT IT
forvalues i=$min/$max {
  local v : label ($variable) `i'
   display "`i' is `v'"
   }

local forlab: value label $variable
forvalues i = $min/$max {
	local label: label `forlab' `i'
	di "`label'" 

tw ///
(line pred_count $trend if $variable==`i', lwidth(thin) lcolor(gs10)) ///
(line lin_count $trend if loco==0 & $variable==`i', lwidth(medium) lcolor(black)) ///
(line cf_lin_count $trend if loco==1 & $variable==`i', lpattern(shortdash) lwidth(medium) lcolor(black)) ///
(line lin_count $trend if loco==1 & $variable==`i', lpattern(solid) lwidth(medium) lcolor(black)) ///
(scatter n_births $trend if $variable==`i', msize(vsmall) mcolor(ebblue%60) msym(o)) ///
, ///
xline(731, lpattern(solid) lcolor(red) lwidth(vthin)) ///
xt("Month of Birth") ///
xlab(660(24)731, ) ///
ylab(, angle(h)) ///
yt("Number of Live Births") ///
legend(order(5 "Observed" 1 "Fitted" 2 "Deseasonalised Fitted" 3 "Deseasonalised Expected") col(1)) ///
title("{bf:`label'}", size(medsmall)) ///
plotregion(lcolor(black)) ///
name(C`i', replace) ///
scheme(white_tableau)

}

*combine plots
grc1leg2 C1 C2 C3 C4 C5, ///
legendfrom(C1) ///
position(4) ring(0) lyoffset(10) lxoffset(0) ///
legscale(*1) plotregion(margin(zero)) imargin(tiny) ///
xtob1title ytol1title ///
title("England, Index of Multiple Deprivation", size(medsmall)) ///
scheme(white_tableau)

graph export "$graph/ENG_area_deprivationQ5_$S_DATE.svg", replace


**# Bookmark #12

*** IMD DECILES ****
*** IMD DECILES ****
*** IMD DECILES ****
clear all

global variable "area_deprivation" // determine group

import excel "C:\Users\moritzob\OneDrive - University of Helsinki\postdoc life helsinki\LoCo-effect\LoCo-effect England Wales\dta\England_births_2015_2022.xlsx", sheet("Sheet1") firstrow clear

rename Yearofoccurrence year
rename Monthofoccurrence month_nr
gen mdate=ym(year, month_nr)
format mdate %tm
gen loco=0
replace loco=1 if mdate>tm(2020m11)
reshape long IMD, i(mdate) j(area_deprivation)
rename IMD n_births
drop if year>2021
bysort mdate: egen total_births=total(n_births)
gen prop=n_births/total_births
gen country="England"

save "$dta/ENG_ts_$variable.dta", replace

su $variable, 
global max=r(max)
global min=r(min)
global min_1=r(min)+1
di $max
di $min
di $min_1

global trend "mdate" // insert variable names
global season "month_nr"
global tw_tm "tm"
global cutoff "2020m12"

global ts_data "$dta/ENG_ts_$variable"

****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=$min/$max {
use "$ts_data.dta", clear
keep if $variable==`i'
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season , irr

quietly: margins, ///
at($trend=(660(1)743) loco=(0)) ///
at($trend=(731(1)743) loco=(1)) ///
predict(n) ///
saving("$dta/margins_ts_`i'.dta", replace)

preserve 
use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin lin_count
keep lin_count $trend loco
drop if loco==0 & $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/lin_pred_`i'.dta",replace

use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin cf_lin_count
keep cf_lin_count $trend loco
keep if loco==0 &  $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/cf_lin_pred_`i'.dta",replace
restore

}

use "$dta/lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/lin_pred_`i'"
}
save "$dta/lin_pred_all", replace

use "$dta/cf_lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/cf_lin_pred_`i'"
}
save "$dta/cf_lin_pred_all", replace


use "$ts_data", clear
merge 1:1 $trend $variable using "$dta/lin_pred_all", nogen
merge 1:1 $trend $variable using "$dta/cf_lin_pred_all", nogen

forval i=$min/$max {
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season if $variable==`i', irr
predict pred_count_`i' if $variable==`i'
}
gen pred_count=pred_count_$min
forval i=$min_1/$max{
	replace pred_count=pred_count_`i' if pred_count==.
}
drop pred_count_$min - pred_count_$max
label define decile 1 "Most deprived 10%" 2 "Q2" 3 "Q3" 4 "Q4" 5 "Q5" 6 "Q6" 7 "Q7" 8 "Q8" 9 "Q9" 10 "Least deprived 10%"
label values area_deprivation decile

*PLOT IT
forvalues i=$min/$max {
  local v : label ($variable) `i'
   display "`i' is `v'"
   }

local forlab: value label $variable
forvalues i = $min/$max {
	local label: label `forlab' `i'
	di "`label'" 

tw ///
(line pred_count $trend if $variable==`i', lwidth(thin) lcolor(gs10)) ///
(line lin_count $trend if loco==0 & $variable==`i', lwidth(medium) lcolor(black)) ///
(line cf_lin_count $trend if loco==1 & $variable==`i', lpattern(shortdash) lwidth(medium) lcolor(black)) ///
(line lin_count $trend if loco==1 & $variable==`i', lpattern(solid) lwidth(medium) lcolor(black)) ///
(scatter n_births $trend if $variable==`i', msize(vsmall) mcolor(ebblue%60) msym(o)) ///
, ///
xline(731, lpattern(solid) lcolor(red) lwidth(vthin)) ///
xt("Month of Birth") ///
xlab(660(24)731, ) ///
ylab(, angle(h)) ///
yt("Number of Live Births") ///
legend(order(5 "Observed" 1 "Fitted" 2 "Deseasonalised Fitted" 3 "Deseasonalised Expected") col(2)) ///
title("{bf:`label'}", size(medsmall)) ///
plotregion(lcolor(black)) ///
name(C`i', replace) ///
scheme(white_tableau)

}

*combine plots
grc1leg2 C1 C2 C3 C4 C5 C6 C7 C8 C9 C10, ///
legendfrom(C1) col(3) ///
position(4) ring(0) lyoffset(5) lxoffset(-5) ///
legscale(*1) plotregion(margin(zero)) imargin(tiny) ///
xtob1title ytol1title ///
title("England, Index of Multiple Deprivation (Deciles)", size(medsmall)) ///
scheme(white_tableau)

graph export "$graph/ENG_area_deprivationQ10_$S_DATE.svg", replace

**# Bookmark #15


****************************************************
****************************************************
*---------------- Tables ---------------------------
*---------------- Tables ---------------------------

****** IMD DECILES ****
****** IMD DECILES ****
****** IMD DECILES ****

clear all
*
global variable "area_deprivation" // determine group
global ts_data "$dta\ENG_ts_$variable.dta"
use "$ts_data", clear

tab $variable
su $variable, 
global max=r(max)
global min=r(min)
global min_1=r(min)+1
di $max
di $min
di $min_1

global trend "mdate" // insert variable names
global season "month_nr"
global tw_tm "tm"
global cutoff "2020m12"

*
preserve // get numbers for table later
collapse (sum) n_births if loco==1, by($variable)
egen total_births=sum(n_births)
gen prop= n_births/total_births
save "$dta/ENG_obs_$variable.dta" ,replace
restore 

****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=$min/$max {
use "$ts_data", clear
keep if $variable==`i'
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season , irr
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
gen $variable=`i'
keep $variable cf_count se_cf_count cf_count_lb cf_count_ub
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
gen $variable=`i'
keep $variable countdiff countdiff_lb countdiff_ub
save "$dta/countdiff_estimate_`i'.dta", replace
restore
}

use "$dta/cf_estimate_$min", clear
forval i=$min_1/$max {
	append using "$dta/cf_estimate_`i'"
}

merge 1:1  $variable using "$dta/ENG_obs_$variable.dta", nogen
order $variable n_births cf_count se_cf_count 
egen total_cf_count=sum(cf_count)
gen cf_prop=cf_count/total_cf_count
gen propdiff=prop-cf_prop
save "$dta/ENG_cf_estimate.dta", replace

use "$dta/countdiff_estimate_$min", clear
forval i=$min_1/$max {
	append using "$dta/countdiff_estimate_`i'"
}

merge 1:1  $variable using "$dta/ENG_cf_estimate.dta", nogen
order $variable n_births cf_count se_cf_count 
save "$dta/ENG_cf_estimate.dta", replace

*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
set seed 123456789
forval d=1/10000 {
use "$dta/ENG_cf_estimate.dta", clear
keep $variable cf_count se_cf_count prop
gen cf_count_i_d=rnormal(cf_count , se_cf_count) // generate random draw d from mean SE estimated from poisson ITS for each SIMD group i
egen sum_cf_count_i_d=sum(cf_count_i_d) // sum random draws d of all groups i
gen cf_prop_i_d=cf_count_i_d/sum_cf_count_i_d // create counterfactual proportion for each group i based on draw d
gen propdiff_i_d=prop- cf_prop_i_d // get m_i_d which is the difference in proportion between observed and counterfactual from draw d
keep $variable propdiff_i_d
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
_pctile propdiff_i_d if $variable==$min, percentiles(2.5) 
return list
gen propdiff_lb=r(r1) if $variable==$min
_pctile propdiff_i_d if $variable==$min, percentiles(97.5) 
return list
gen propdiff_ub=r(r1) if $variable==$min

forval i=$min_1/$max {
_pctile propdiff_i_d if $variable==`i', percentiles(2.5) 
return list
replace propdiff_lb=r(r1) if $variable==`i'
_pctile propdiff_i_d if $variable==`i', percentiles(97.5) 
return list
replace propdiff_ub=r(r1) if $variable==`i'
}

collapse propdiff_lb propdiff_ub, by($variable)
save "$dta/ENG_prop_uncertainty", replace
use "$dta/ENG_cf_estimate", clear
merge 1:1 $variable using "$dta/ENG_prop_uncertainty", nogen
gen country="England"
order country $variable n_births cf_count se_cf_count cf_count_lb cf_count_ub countdiff countdiff_lb countdiff_ub prop cf_prop propdiff propdiff_lb propdiff_ub total_births total_cf_count
save "$dta/ENG_comp_diff_$variable", replace

**# Bookmark #16

************** ENGLAND TABLE ***********
************** ENGLAND TABLE ***********
************** ENGLAND TABLE ***********
************** ENGLAND TABLE ***********
use "$dta/ENG_comp_diff_area_deprivation", clear
gen rel_count_diff=(n_births-cf_count)/(abs(cf_count))*100
gen rel_count_diff_ub=(n_births-cf_count_lb)/(abs(cf_count_lb))*100
gen rel_count_diff_lb=(n_births-cf_count_ub)/(abs(cf_count_ub))*100
order country area_deprivation n_births cf_count se_cf_count cf_count_lb cf_count_ub countdiff countdiff_lb countdiff_ub rel_count_diff rel_count_diff_lb rel_count_diff_ub prop cf_prop propdiff propdiff_lb propdiff_ub total_births total_cf_count

drop se_cf_count
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
order country area_deprivation n_births cf_count  cf_count_ci countdiff countdiff_ci  rel_count_diff rel_diff_ci prop cf_prop propdiff propdiff_ci total_births total_cf_count


save "$dta/ENG_table_profile_$S_DATE", replace
export excel using "$table\ENG_table_profile_$S_DATE.xls", firstrow(variables) replace


**# Bookmark #17
*************** WALES WALES WALES ********************
*************** WALES WALES WALES ********************
*************** WALES WALES WALES ********************
*************** WALES WALES WALES ********************

clear all
use "$dta/WAL_ts", clear
global ts_data "$dta/WAL_ts"
global variable "area_deprivation" // determine group
su $variable, 
global max=r(max)
global min=r(min)
global min_1=r(min)+1
di $max
di $min
di $min_1

global trend "mdate" // insert variable names
global season "month_nr"
global tw_tm "tm"
global cutoff "2020m12"

****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=$min/$max {
use "$ts_data.dta", clear
keep if $variable==`i'
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season , irr

quietly: margins, ///
at($trend=(660(1)743) loco=(0)) ///
at($trend=(731(1)743) loco=(1)) ///
predict(n) ///
saving("$dta/margins_ts_`i'.dta", replace)

preserve 
use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin lin_count
keep lin_count $trend loco
drop if loco==0 & $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/lin_pred_`i'.dta",replace

use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin cf_lin_count
keep cf_lin_count $trend loco
keep if loco==0 &  $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/cf_lin_pred_`i'.dta",replace
restore

}

use "$dta/lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/lin_pred_`i'"
}
save "$dta/lin_pred_all", replace

use "$dta/cf_lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/cf_lin_pred_`i'"
}
save "$dta/cf_lin_pred_all", replace


use "$ts_data", clear
merge 1:1 $trend $variable using "$dta/lin_pred_all", nogen
merge 1:1 $trend $variable using "$dta/cf_lin_pred_all", nogen

forval i=$min/$max {
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season if $variable==`i', irr
predict pred_count_`i' if $variable==`i'
}
gen pred_count=pred_count_$min
forval i=$min_1/$max{
	replace pred_count=pred_count_`i' if pred_count==.
}
drop pred_count_$min - pred_count_$max
*PLOT IT
forvalues i=$min/$max {
  local v : label ($variable) `i'
   display "`i' is `v'"
   }

local forlab: value label $variable
forvalues i = $min/$max {
	local label: label `forlab' `i'
	di "`label'" 

tw ///
(line pred_count $trend if $variable==`i', lwidth(thin) lcolor(gs10)) ///
(line lin_count $trend if loco==0 & $variable==`i', lwidth(medium) lcolor(black)) ///
(line cf_lin_count $trend if loco==1 & $variable==`i', lpattern(shortdash) lwidth(medium) lcolor(black)) ///
(line lin_count $trend if loco==1 & $variable==`i', lpattern(solid) lwidth(medium) lcolor(black)) ///
(scatter n_births $trend if $variable==`i', msize(vsmall) mcolor(ebblue%60) msym(o)) ///
, ///
xline(731, lpattern(solid) lcolor(red) lwidth(vthin)) ///
xt("Month of Birth") ///
xlab(660(24)731, ) ///
ylab(, angle(h)) ///
yt("Number of Live Births") ///
legend(order(5 "Observed" 1 "Fitted" 2 "Deseasonalised Fitted" 3 "Deseasonalised Expected") col(1)) ///
title("{bf:`label'}", size(medsmall)) ///
plotregion(lcolor(black)) ///
name(C`i', replace) ///
scheme(white_tableau)

}

*combine plots
grc1leg2 C1 C2 C3 C4 C5, ///
legendfrom(C1) ///
position(4) ring(0) lyoffset(10) lxoffset(0) ///
legscale(*1) plotregion(margin(zero)) imargin(tiny) ///
xtob1title ytol1title ///
title("Wales, Index of Multiple Deprivation", size(medsmall)) ///
scheme(white_tableau)

graph export "$graph/WAL_area_deprivationQ5_$S_DATE.svg", replace


**# Bookmark #12

*** IMD DECILES ****
*** IMD DECILES ****
*** IMD DECILES ****
clear all

global variable "area_deprivation" // determine group

import excel "C:\Users\moritzob\OneDrive - University of Helsinki\postdoc life helsinki\LoCo-effect\LoCo-effect England Wales\dta\Wales_births_2015_2022.xlsx", sheet("Sheet1") firstrow clear

rename Yearofoccurrence year
rename Monthofoccurrence month_nr
gen mdate=ym(year, month_nr)
format mdate %tm
gen loco=0
replace loco=1 if mdate>tm(2020m11)
reshape long IMD, i(mdate) j(area_deprivation)
rename IMD n_births
drop if year>2021
bysort mdate: egen total_births=total(n_births)
gen prop=n_births/total_births
gen country="Wales"

save "$dta/WAL_ts_$variable.dta", replace

su $variable, 
global max=r(max)
global min=r(min)
global min_1=r(min)+1
di $max
di $min
di $min_1

global trend "mdate" // insert variable names
global season "month_nr"
global tw_tm "tm"
global cutoff "2020m12"

global ts_data "$dta/WAL_ts_$variable"

****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=$min/$max {
use "$ts_data.dta", clear
keep if $variable==`i'
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season , irr

quietly: margins, ///
at($trend=(660(1)743) loco=(0)) ///
at($trend=(731(1)743) loco=(1)) ///
predict(n) ///
saving("$dta/margins_ts_`i'.dta", replace)

preserve 
use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin lin_count
keep lin_count $trend loco
drop if loco==0 & $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/lin_pred_`i'.dta",replace

use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin cf_lin_count
keep cf_lin_count $trend loco
keep if loco==0 &  $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/cf_lin_pred_`i'.dta",replace
restore

}

use "$dta/lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/lin_pred_`i'"
}
save "$dta/lin_pred_all", replace

use "$dta/cf_lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/cf_lin_pred_`i'"
}
save "$dta/cf_lin_pred_all", replace


use "$ts_data", clear
merge 1:1 $trend $variable using "$dta/lin_pred_all", nogen
merge 1:1 $trend $variable using "$dta/cf_lin_pred_all", nogen

forval i=$min/$max {
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season if $variable==`i', irr
predict pred_count_`i' if $variable==`i'
}
gen pred_count=pred_count_$min
forval i=$min_1/$max{
	replace pred_count=pred_count_`i' if pred_count==.
}
drop pred_count_$min - pred_count_$max
label define decile 1 "Most deprived 10%" 2 "Q2" 3 "Q3" 4 "Q4" 5 "Q5" 6 "Q6" 7 "Q7" 8 "Q8" 9 "Q9" 10 "Least deprived 10%"
label values area_deprivation decile

*PLOT IT
forvalues i=$min/$max {
  local v : label ($variable) `i'
   display "`i' is `v'"
   }

local forlab: value label $variable
forvalues i = $min/$max {
	local label: label `forlab' `i'
	di "`label'" 

tw ///
(line pred_count $trend if $variable==`i', lwidth(thin) lcolor(gs10)) ///
(line lin_count $trend if loco==0 & $variable==`i', lwidth(medium) lcolor(black)) ///
(line cf_lin_count $trend if loco==1 & $variable==`i', lpattern(shortdash) lwidth(medium) lcolor(black)) ///
(line lin_count $trend if loco==1 & $variable==`i', lpattern(solid) lwidth(medium) lcolor(black)) ///
(scatter n_births $trend if $variable==`i', msize(vsmall) mcolor(ebblue%60) msym(o)) ///
, ///
xline(731, lpattern(solid) lcolor(red) lwidth(vthin)) ///
xt("Month of Birth") ///
xlab(660(24)731, ) ///
ylab(, angle(h)) ///
yt("Number of Live Births") ///
legend(order(5 "Observed" 1 "Fitted" 2 "Deseasonalised Fitted" 3 "Deseasonalised Expected") col(2)) ///
title("{bf:`label'}", size(medsmall)) ///
plotregion(lcolor(black)) ///
name(C`i', replace) ///
scheme(white_tableau)

}

*combine plots
grc1leg2 C1 C2 C3 C4 C5 C6 C7 C8 C9 C10, ///
legendfrom(C1) col(3) ///
position(4) ring(0) lyoffset(5) lxoffset(-5) ///
legscale(*1) plotregion(margin(zero)) imargin(tiny) ///
xtob1title ytol1title ///
title("Wales, Index of Multiple Deprivation (Deciles)", size(medsmall)) ///
scheme(white_tableau)

graph export "$graph/WAL_area_deprivationQ10_$S_DATE.svg", replace

**# Bookmark #15


****************************************************
****************************************************
*---------------- Tables ---------------------------
*---------------- Tables ---------------------------

****** IMD DECILES ****
****** IMD DECILES ****
****** IMD DECILES ****

clear all
*
global variable "area_deprivation" // determine group
global ts_data "$dta\WAL_ts_$variable.dta"
use "$ts_data", clear

tab $variable
su $variable, 
global max=r(max)
global min=r(min)
global min_1=r(min)+1
di $max
di $min
di $min_1

global trend "mdate" // insert variable names
global season "month_nr"
global tw_tm "tm"
global cutoff "2020m12"

*
preserve // get numbers for table later
collapse (sum) n_births if loco==1, by($variable)
egen total_births=sum(n_births)
gen prop= n_births/total_births
save "$dta/WAL_obs_$variable.dta" ,replace
restore 

****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=$min/$max {
use "$ts_data", clear
keep if $variable==`i'
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season , irr
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
gen $variable=`i'
keep $variable cf_count se_cf_count cf_count_lb cf_count_ub
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
gen $variable=`i'
keep $variable countdiff countdiff_lb countdiff_ub
save "$dta/countdiff_estimate_`i'.dta", replace
restore
}

use "$dta/cf_estimate_$min", clear
forval i=$min_1/$max {
	append using "$dta/cf_estimate_`i'"
}

merge 1:1  $variable using "$dta/WAL_obs_$variable.dta", nogen
order $variable n_births cf_count se_cf_count 
egen total_cf_count=sum(cf_count)
gen cf_prop=cf_count/total_cf_count
gen propdiff=prop-cf_prop
save "$dta/WAL_cf_estimate.dta", replace

use "$dta/countdiff_estimate_$min", clear
forval i=$min_1/$max {
	append using "$dta/countdiff_estimate_`i'"
}

merge 1:1  $variable using "$dta/WAL_cf_estimate.dta", nogen
order $variable n_births cf_count se_cf_count 
save "$dta/WAL_cf_estimate.dta", replace

*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
set seed 123456789
forval d=1/10000 {
use "$dta/WAL_cf_estimate.dta", clear
keep $variable cf_count se_cf_count prop
gen cf_count_i_d=rnormal(cf_count , se_cf_count) // generate random draw d from mean SE estimated from poisson ITS for each SIMD group i
egen sum_cf_count_i_d=sum(cf_count_i_d) // sum random draws d of all groups i
gen cf_prop_i_d=cf_count_i_d/sum_cf_count_i_d // create counterfactual proportion for each group i based on draw d
gen propdiff_i_d=prop- cf_prop_i_d // get m_i_d which is the difference in proportion between observed and counterfactual from draw d
keep $variable propdiff_i_d
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
_pctile propdiff_i_d if $variable==$min, percentiles(2.5) 
return list
gen propdiff_lb=r(r1) if $variable==$min
_pctile propdiff_i_d if $variable==$min, percentiles(97.5) 
return list
gen propdiff_ub=r(r1) if $variable==$min

forval i=$min_1/$max {
_pctile propdiff_i_d if $variable==`i', percentiles(2.5) 
return list
replace propdiff_lb=r(r1) if $variable==`i'
_pctile propdiff_i_d if $variable==`i', percentiles(97.5) 
return list
replace propdiff_ub=r(r1) if $variable==`i'
}

collapse propdiff_lb propdiff_ub, by($variable)
save "$dta/WAL_prop_uncertainty", replace
use "$dta/WAL_cf_estimate", clear
merge 1:1 $variable using "$dta/WAL_prop_uncertainty", nogen
gen country="Wales"
order country $variable n_births cf_count se_cf_count cf_count_lb cf_count_ub countdiff countdiff_lb countdiff_ub prop cf_prop propdiff propdiff_lb propdiff_ub total_births total_cf_count
save "$dta/WAL_comp_diff_$variable", replace

**# Bookmark #16

************** WALES TABLE ***********
************** WALES TABLE ***********
************** WALES TABLE ***********

use "$dta/WAL_comp_diff_area_deprivation", clear
gen rel_count_diff=(n_births-cf_count)/(abs(cf_count))*100
gen rel_count_diff_ub=(n_births-cf_count_lb)/(abs(cf_count_lb))*100
gen rel_count_diff_lb=(n_births-cf_count_ub)/(abs(cf_count_ub))*100
order country area_deprivation n_births cf_count se_cf_count cf_count_lb cf_count_ub countdiff countdiff_lb countdiff_ub rel_count_diff rel_count_diff_lb rel_count_diff_ub prop cf_prop propdiff propdiff_lb propdiff_ub total_births total_cf_count

drop se_cf_count
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

order country area_deprivation n_births cf_count  cf_count_ci countdiff countdiff_ci  rel_count_diff rel_diff_ci prop cf_prop propdiff propdiff_ci total_births total_cf_count

save "$dta/WAL_table_profile_$S_DATE", replace
export excel using "$table\WAL_table_profile_$S_DATE.xls", firstrow(variables) replace


**# Bookmark #18

****************** MEXICO MEXICO MEXICO ***************
****************** MEXICO MEXICO MEXICO ***************
****************** MEXICO MEXICO MEXICO ***************
****************** MEXICO MEXICO MEXICO ***************

**# Bookmark #21

***** MAIN SEC VARIABLE ************
***** MAIN SEC VARIABLE ************
***** MAIN SEC VARIABLE ************

clear all
use "$dta/MEX_ts", clear
global ts_data "$dta/MEX_ts"
global variable "mom_edu_comp" // determine group
su $variable, 
global max=r(max)
global min=r(min)
global min_1=r(min)+1
di $max
di $min
di $min_1

global trend "bdate_w" // insert variable names
global season "bweek"
global tw_tm "tw"
global cutoff "2020w51"

****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=$min/$max {
use "$ts_data.dta", clear
keep if $variable==`i'
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season i.zika , irr

quietly: margins, ///
at($trend=(2860(1)3223) loco=0 zika=0) ///
at($trend=(3170(1)3223) loco=1 zika=0) ///
predict(n) ///
saving("$dta/margins_ts_`i'.dta", replace)

preserve 
use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin lin_count
keep lin_count $trend loco
drop if loco==0 & $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/lin_pred_`i'.dta",replace

use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin cf_lin_count
keep cf_lin_count $trend loco
keep if loco==0 &  $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/cf_lin_pred_`i'.dta",replace
restore

}

use "$dta/lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/lin_pred_`i'"
}
save "$dta/lin_pred_all", replace

use "$dta/cf_lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/cf_lin_pred_`i'"
}
save "$dta/cf_lin_pred_all", replace


use "$ts_data", clear
merge 1:1 $trend $variable using "$dta/lin_pred_all", nogen
merge 1:1 $trend $variable using "$dta/cf_lin_pred_all", nogen

forval i=$min/$max {
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season i.zika if $variable==`i', irr
predict pred_count_`i' if $variable==`i'
}
gen pred_count=pred_count_$min
forval i=$min_1/$max{
	replace pred_count=pred_count_`i' if pred_count==.
}
drop pred_count_$min - pred_count_$max
label define edulab2 1 "Elementary" 2 "Lower Secondary" 3 "Upper Secondary" 4 "Missing information"
label values mom_edu_comp edulab2

*PLOT IT
forvalues i=$min/$max {
  local v : label ($variable) `i'
   display "`i' is `v'"
   }

local forlab: value label $variable
forvalues i = $min/$max {
	local label: label `forlab' `i'
	di "`label'" 

tw ///
(line pred_count $trend if $variable==`i', lwidth(thin) lcolor(gs10)) ///
(line lin_count $trend if loco==0 & $variable==`i', lwidth(medium) lcolor(black)) ///
(line cf_lin_count $trend if loco==1 & $variable==`i', lpattern(shortdash) lwidth(medium) lcolor(black)) ///
(line lin_count $trend if loco==1 & $variable==`i', lpattern(solid) lwidth(medium) lcolor(black)) ///
(scatter n_births $trend if $variable==`i', msize(vsmall) mcolor(ebblue%60) msym(o)) ///
, ///
xline(3170, lpattern(solid) lcolor(red) lwidth(vthin)) ///
xt("Week of Birth") ///
xlab(2860(104)3223, angle(h) ) ///
ylab(, angle(h)) ///
yt("Number of Live Births") ///
legend(order(5 "Observed" 1 "Fitted" 2 "Deseasonalised Fitted" 3 "Deseasonalised Expected") row(1)) ///
title("{bf:`label'}", size(medsmall)) ///
plotregion(lcolor(black)) ///
name(C`i', replace) ///
scheme(white_tableau)

}

*combine plots
grc1leg2 C1 C2 C3 C4 , ///
legendfrom(C1) ///
position(6) lyoffset(0) lxoffset(0) ///
legscale(*1) plotregion(margin(zero)) imargin(tiny) ///
xtob1title ytol1title ///
title("Mexico, Maternal Education", size(medsmall)) ///
scheme(white_tableau)

graph export "$graph/MEX_mom_edu_comp_$S_DATE.svg", replace


**# Bookmark #23

****** DETAILED MOM EDU ***********
****** DETAILED MOM EDU ***********
****** DETAILED MOM EDU ***********
clear all
use "C:\Users\moritzob\OneDrive - University of Helsinki\postdoc life helsinki\LoCo-effect\LoCo-effect Mexico\dta\Mexico_births_2015_2021.dta", clear

tab mom_edu,m
rename loco_w loco
global variable "mom_edu" // determine group
su $variable, 
global max=r(max)
global min=r(min)
global min_1=r(min)+1
di $max
di $min
di $min_1

global trend "bdate_w" // insert variable names
global season "bweek"
global tw_tm "tw"
global cutoff "2020w51"

*create ts_data
collapse loco $season (count) n_births= year, by($trend $variable)

* zika period from August 2016 to end of Dec 2016
gen zika=0
replace zika=1 if bdate_w >=tw(2016w31) & bdate_w <=tw(2016w52)
drop if bdate_w==.
save "$dta/MEX_ts_$variable", replace
global ts_data "$dta/MEX_ts_$variable"


****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=$min/$max {
use "$ts_data.dta", clear
keep if $variable==`i'
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season i.zika , irr

quietly: margins, ///
at($trend=(2860(1)3223) loco=0 zika=0) ///
at($trend=(3170(1)3223) loco=1 zika=0) ///
predict(n) ///
saving("$dta/margins_ts_`i'.dta", replace)

preserve 
use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin lin_count
keep lin_count $trend loco
drop if loco==0 & $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/lin_pred_`i'.dta",replace

use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin cf_lin_count
keep cf_lin_count $trend loco
keep if loco==0 &  $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/cf_lin_pred_`i'.dta",replace
restore

}

use "$dta/lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/lin_pred_`i'"
}
save "$dta/lin_pred_all", replace

use "$dta/cf_lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/cf_lin_pred_`i'"
}
save "$dta/cf_lin_pred_all", replace


use "$ts_data", clear
merge 1:1 $trend $variable using "$dta/lin_pred_all", nogen
merge 1:1 $trend $variable using "$dta/cf_lin_pred_all", nogen

forval i=$min/$max {
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season i.zika if $variable==`i', irr
predict pred_count_`i' if $variable==`i'
}
gen pred_count=pred_count_$min
forval i=$min_1/$max{
	replace pred_count=pred_count_`i' if pred_count==.
}
drop pred_count_$min - pred_count_$max
*PLOT IT
forvalues i=$min/$max {
  local v : label ($variable) `i'
   display "`i' is `v'"
   }

local forlab: value label $variable
forvalues i = $min/$max {
	local label: label `forlab' `i'
	di "`label'" 

tw ///
(line pred_count $trend if $variable==`i', lwidth(thin) lcolor(gs10)) ///
(line lin_count $trend if loco==0 & $variable==`i', lwidth(medium) lcolor(black)) ///
(line cf_lin_count $trend if loco==1 & $variable==`i', lpattern(shortdash) lwidth(medium) lcolor(black)) ///
(line lin_count $trend if loco==1 & $variable==`i', lpattern(solid) lwidth(medium) lcolor(black)) ///
(scatter n_births $trend if $variable==`i', msize(vsmall) mcolor(ebblue%60) msym(o)) ///
, ///
xline(3170, lpattern(solid) lcolor(red) lwidth(vthin)) ///
xt("Week of Birth") ///
xlab(2860(104)3223, angle(h) ) ///
ylab(, angle(h)) ///
yt("Number of Live Births") ///
legend(order(5 "Observed" 1 "Fitted" 2 "Deseasonalised Fitted" 3 "Deseasonalised Expected") row(1)) ///
title("{bf:`label'}", size(medsmall)) ///
plotregion(lcolor(black)) ///
name(C`i', replace) ///
scheme(white_tableau)

}

*combine plots
grc1leg2 C1 C2 C3 C4 C5 C6 C7 C8 C9, ///
legendfrom(C1) ///
position(6) lyoffset(0) lxoffset(0) ///
legscale(*1) plotregion(margin(zero)) imargin(tiny) ///
xtob1title ytol1title ///
title("Mexico, Maternal Education in detail", size(medsmall)) ///
scheme(white_tableau)

graph export "$graph/MEX_mom_edu_$S_DATE.svg", replace

**# Bookmark #25


****** DETAILED MOM EDU ***********
****** DETAILED MOM EDU ***********
****** DETAILED MOM EDU ***********
clear all
use "C:\Users\moritzob\OneDrive - University of Helsinki\postdoc life helsinki\LoCo-effect\LoCo-effect Mexico\dta\Mexico_births_2015_2021.dta", clear

tab mom_dad_edu_comp,m
rename loco_w loco
global variable "mom_dad_edu_comp" // determine group
su $variable, 
global max=r(max)
global min=r(min)
global min_1=r(min)+1
di $max
di $min
di $min_1

global trend "bdate_w" // insert variable names
global season "bweek"
global tw_tm "tw"
global cutoff "2020w51"

*create ts_data
collapse loco $season (count) n_births= year, by($trend $variable)

* zika period from August 2016 to end of Dec 2016
gen zika=0
replace zika=1 if bdate_w >=tw(2016w31) & bdate_w <=tw(2016w52)
drop if bdate_w==.
save "$dta/MEX_ts_$variable", replace
global ts_data "$dta/MEX_ts_$variable"


****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=$min/$max {
use "$ts_data.dta", clear
keep if $variable==`i'
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season i.zika , irr

quietly: margins, ///
at($trend=(2860(1)3223) loco=0 zika=0) ///
at($trend=(3170(1)3223) loco=1 zika=0) ///
predict(n) ///
saving("$dta/margins_ts_`i'.dta", replace)

preserve 
use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin lin_count
keep lin_count $trend loco
drop if loco==0 & $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/lin_pred_`i'.dta",replace

use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin cf_lin_count
keep cf_lin_count $trend loco
keep if loco==0 &  $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/cf_lin_pred_`i'.dta",replace
restore

}

use "$dta/lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/lin_pred_`i'"
}
save "$dta/lin_pred_all", replace

use "$dta/cf_lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/cf_lin_pred_`i'"
}
save "$dta/cf_lin_pred_all", replace


use "$ts_data", clear
merge 1:1 $trend $variable using "$dta/lin_pred_all", nogen
merge 1:1 $trend $variable using "$dta/cf_lin_pred_all", nogen

forval i=$min/$max {
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season i.zika if $variable==`i', irr
predict pred_count_`i' if $variable==`i'
}
gen pred_count=pred_count_$min
forval i=$min_1/$max{
	replace pred_count=pred_count_`i' if pred_count==.
}
drop pred_count_$min - pred_count_$max
*PLOT IT
forvalues i=$min/$max {
  local v : label ($variable) `i'
   display "`i' is `v'"
   }

local forlab: value label $variable
forvalues i = $min/$max {
	local label: label `forlab' `i'
	di "`label'" 

tw ///
(line pred_count $trend if $variable==`i', lwidth(thin) lcolor(gs10)) ///
(line lin_count $trend if loco==0 & $variable==`i', lwidth(medium) lcolor(black)) ///
(line cf_lin_count $trend if loco==1 & $variable==`i', lpattern(shortdash) lwidth(medium) lcolor(black)) ///
(line lin_count $trend if loco==1 & $variable==`i', lpattern(solid) lwidth(medium) lcolor(black)) ///
(scatter n_births $trend if $variable==`i', msize(vsmall) mcolor(ebblue%60) msym(o)) ///
, ///
xline(3170, lpattern(solid) lcolor(red) lwidth(vthin)) ///
xt("Week of Birth") ///
xlab(2860(104)3223, angle(h) ) ///
ylab(, angle(h)) ///
yt("Number of Live Births") ///
legend(order(5 "Observed" 1 "Fitted" 2 "Deseasonalised Fitted" 3 "Deseasonalised Expected") row(1)) ///
title("{bf:`label'}", size(medsmall)) ///
plotregion(lcolor(black)) ///
name(C`i', replace) ///
scheme(white_tableau)

}

*combine plots
grc1leg2 C1 C2 C3 C4 , ///
legendfrom(C1) ///
position(6) lyoffset(0) lxoffset(0) ///
legscale(*1) plotregion(margin(zero)) imargin(tiny) ///
xtob1title ytol1title ///
title("Mexico, Highest of Parental Education", size(medsmall)) ///
scheme(white_tableau)

graph export "$graph/MEX_mom_dad_edu_comp_$S_DATE.svg", replace



**# Bookmark #24

******  MOM AGE ***********
******  MOM AGE ***********
******  MOM AGE ***********

clear all
use "C:\Users\moritzob\OneDrive - University of Helsinki\postdoc life helsinki\LoCo-effect\LoCo-effect Mexico\dta\Mexico_births_2015_2021.dta", clear

tab mom_edu,m
rename loco_w loco
global variable "mom_age_cat" // determine group
su $variable, 
global max=r(max)
global min=r(min)
global min_1=r(min)+1
di $max
di $min
di $min_1

global trend "bdate_w" // insert variable names
global season "bweek"
global tw_tm "tw"
global cutoff "2020w51"

*create ts_data
collapse loco $season (count) n_births= year, by($trend $variable)

* zika period from August 2016 to end of Dec 2016
gen zika=0
replace zika=1 if bdate_w >=tw(2016w31) & bdate_w <=tw(2016w52)
drop if bdate_w==.
save "$dta/MEX_ts_$variable", replace
global ts_data "$dta/MEX_ts_$variable"


****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=$min/$max {
use "$ts_data.dta", clear
keep if $variable==`i'
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season i.zika , irr

quietly: margins, ///
at($trend=(2860(1)3223) loco=0 zika=0) ///
at($trend=(3170(1)3223) loco=1 zika=0) ///
predict(n) ///
saving("$dta/margins_ts_`i'.dta", replace)

preserve 
use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin lin_count
keep lin_count $trend loco
drop if loco==0 & $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/lin_pred_`i'.dta",replace

use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin cf_lin_count
keep cf_lin_count $trend loco
keep if loco==0 &  $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/cf_lin_pred_`i'.dta",replace
restore

}

use "$dta/lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/lin_pred_`i'"
}
save "$dta/lin_pred_all", replace

use "$dta/cf_lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/cf_lin_pred_`i'"
}
save "$dta/cf_lin_pred_all", replace


use "$ts_data", clear
merge 1:1 $trend $variable using "$dta/lin_pred_all", nogen
merge 1:1 $trend $variable using "$dta/cf_lin_pred_all", nogen

forval i=$min/$max {
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season i.zika if $variable==`i', irr
predict pred_count_`i' if $variable==`i'
}
gen pred_count=pred_count_$min
forval i=$min_1/$max{
	replace pred_count=pred_count_`i' if pred_count==.
}
drop pred_count_$min - pred_count_$max
*PLOT IT
forvalues i=$min/$max {
  local v : label ($variable) `i'
   display "`i' is `v'"
   }

local forlab: value label $variable
forvalues i = $min/$max {
	local label: label `forlab' `i'
	di "`label'" 

tw ///
(line pred_count $trend if $variable==`i', lwidth(thin) lcolor(gs10)) ///
(line lin_count $trend if loco==0 & $variable==`i', lwidth(medium) lcolor(black)) ///
(line cf_lin_count $trend if loco==1 & $variable==`i', lpattern(shortdash) lwidth(medium) lcolor(black)) ///
(line lin_count $trend if loco==1 & $variable==`i', lpattern(solid) lwidth(medium) lcolor(black)) ///
(scatter n_births $trend if $variable==`i', msize(vsmall) mcolor(ebblue%60) msym(o)) ///
, ///
xline(3170, lpattern(solid) lcolor(red) lwidth(vthin)) ///
xt("Week of Birth") ///
xlab(2860(104)3223, angle(h) ) ///
ylab(, angle(h)) ///
yt("Number of Live Births") ///
legend(order(5 "Observed" 1 "Fitted" 2 "Deseasonalised Fitted" 3 "Deseasonalised Expected") row(1)) ///
title("{bf:`label'}", size(medsmall)) ///
plotregion(lcolor(black)) ///
name(C`i', replace) ///
scheme(white_tableau)

}

*combine plots
grc1leg2 C1 C2 C3 C4 C5 C6, ///
legendfrom(C1) ///
position(6) lyoffset(0) lxoffset(0) ///
legscale(*1) plotregion(margin(zero)) imargin(tiny) ///
xtob1title ytol1title ///
title("Mexico, Maternal Age", size(medsmall)) ///
scheme(white_tableau)

graph export "$graph/MEX_mom_age_cat_$S_DATE.svg", replace

**# Bookmark #26

******  PARITY ***********
******  PARITY ***********
******  PARITY ***********

clear all
use "C:\Users\moritzob\OneDrive - University of Helsinki\postdoc life helsinki\LoCo-effect\LoCo-effect Mexico\dta\Mexico_births_2015_2021.dta", clear

tab parity,m
drop if parity ==6 // only 63 missing out of > 13 mill
rename loco_w loco
global variable "parity" // determine group
su $variable, 
global max=r(max)
global min=r(min)
global min_1=r(min)+1
di $max
di $min
di $min_1

global trend "bdate_w" // insert variable names
global season "bweek"
global tw_tm "tw"
global cutoff "2020w51"

*create ts_data
collapse loco $season (count) n_births= year, by($trend $variable)

* zika period from August 2016 to end of Dec 2016
gen zika=0
replace zika=1 if bdate_w >=tw(2016w31) & bdate_w <=tw(2016w52)
drop if bdate_w==.
save "$dta/MEX_ts_$variable", replace
global ts_data "$dta/MEX_ts_$variable"


****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=$min/$max {
use "$ts_data.dta", clear
keep if $variable==`i'
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season i.zika , irr

quietly: margins, ///
at($trend=(2860(1)3223) loco=0 zika=0) ///
at($trend=(3170(1)3223) loco=1 zika=0) ///
predict(n) ///
saving("$dta/margins_ts_`i'.dta", replace)

preserve 
use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin lin_count
keep lin_count $trend loco
drop if loco==0 & $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/lin_pred_`i'.dta",replace

use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin cf_lin_count
keep cf_lin_count $trend loco
keep if loco==0 &  $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/cf_lin_pred_`i'.dta",replace
restore

}

use "$dta/lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/lin_pred_`i'"
}
save "$dta/lin_pred_all", replace

use "$dta/cf_lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/cf_lin_pred_`i'"
}
save "$dta/cf_lin_pred_all", replace


use "$ts_data", clear
merge 1:1 $trend $variable using "$dta/lin_pred_all", nogen
merge 1:1 $trend $variable using "$dta/cf_lin_pred_all", nogen

forval i=$min/$max {
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season i.zika if $variable==`i', irr
predict pred_count_`i' if $variable==`i'
}
gen pred_count=pred_count_$min
forval i=$min_1/$max{
	replace pred_count=pred_count_`i' if pred_count==.
}
drop pred_count_$min - pred_count_$max
*PLOT IT
forvalues i=$min/$max {
  local v : label ($variable) `i'
   display "`i' is `v'"
   }

local forlab: value label $variable
forvalues i = $min/$max {
	local label: label `forlab' `i'
	di "`label'" 

tw ///
(line pred_count $trend if $variable==`i', lwidth(thin) lcolor(gs10)) ///
(line lin_count $trend if loco==0 & $variable==`i', lwidth(medium) lcolor(black)) ///
(line cf_lin_count $trend if loco==1 & $variable==`i', lpattern(shortdash) lwidth(medium) lcolor(black)) ///
(line lin_count $trend if loco==1 & $variable==`i', lpattern(solid) lwidth(medium) lcolor(black)) ///
(scatter n_births $trend if $variable==`i', msize(vsmall) mcolor(ebblue%60) msym(o)) ///
, ///
xline(3170, lpattern(solid) lcolor(red) lwidth(vthin)) ///
xt("Week of Birth") ///
xlab(2860(104)3223, angle(h) ) ///
ylab(, angle(h)) ///
yt("Number of Live Births") ///
legend(order(5 "Observed" 1 "Fitted" 2 "Deseasonalised Fitted" 3 "Deseasonalised Expected") col(1)) ///
title("{bf:`label'}", size(medsmall)) ///
plotregion(lcolor(black)) ///
name(C`i', replace) ///
scheme(white_tableau)

}

*combine plots
grc1leg2 C1 C2 C3 C4 C5 , ///
legendfrom(C1) ///
position(4) ring(0) lyoffset(10) lxoffset(0) ///
legscale(*1) plotregion(margin(zero)) imargin(tiny) ///
xtob1title ytol1title ///
title("Mexico, Parity", size(medsmall)) ///
scheme(white_tableau)

graph export "$graph/MEX_parity_$S_DATE.svg", replace

**# Bookmark #27

****************************************************
****************************************************
*---------------- Tables ---------------------------
*---------------- Tables ---------------------------

**** MOM EDU IN DETAIL ***
**** MOM EDU IN DETAIL ***
**** MOM EDU IN DETAIL ***

clear all
*
global variable "mom_edu" // determine group
global ts_data "$dta\MEX_ts_$variable.dta"
use "$ts_data", clear

tab $variable
su $variable, 
global max=r(max)
global min=r(min)
global min_1=r(min)+1
di $max
di $min
di $min_1

global trend "bdate_w" // insert variable names
global season "bweek"
global tw_tm "tw"
global cutoff "2020w51"

*
preserve // get numbers for table later
collapse (sum) n_births if loco==1, by($variable)
egen total_births=sum(n_births)
gen prop= n_births/total_births
save "$dta/MEX_obs_$variable.dta" ,replace
restore 

****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=$min/$max {
use "$ts_data", clear
keep if $variable==`i'
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season i.zika , irr
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
gen $variable=`i'
keep $variable cf_count se_cf_count cf_count_lb cf_count_ub
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
gen $variable=`i'
keep $variable countdiff countdiff_lb countdiff_ub
save "$dta/countdiff_estimate_`i'.dta", replace
restore
}

use "$dta/cf_estimate_$min", clear
forval i=$min_1/$max {
	append using "$dta/cf_estimate_`i'"
}

merge 1:1  $variable using "$dta/MEX_obs_$variable.dta", nogen
order $variable n_births cf_count se_cf_count 
egen total_cf_count=sum(cf_count)
gen cf_prop=cf_count/total_cf_count
gen propdiff=prop-cf_prop
save "$dta/MEX_cf_estimate.dta", replace

use "$dta/countdiff_estimate_$min", clear
forval i=$min_1/$max {
	append using "$dta/countdiff_estimate_`i'"
}

merge 1:1  $variable using "$dta/MEX_cf_estimate.dta", nogen
order $variable n_births cf_count se_cf_count 
save "$dta/MEX_cf_estimate.dta", replace

*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
set seed 123456789
forval d=1/10000 {
use "$dta/MEX_cf_estimate.dta", clear
keep $variable cf_count se_cf_count prop
gen cf_count_i_d=rnormal(cf_count , se_cf_count) // generate random draw d from mean SE estimated from poisson ITS for each SIMD group i
egen sum_cf_count_i_d=sum(cf_count_i_d) // sum random draws d of all groups i
gen cf_prop_i_d=cf_count_i_d/sum_cf_count_i_d // create counterfactual proportion for each group i based on draw d
gen propdiff_i_d=prop- cf_prop_i_d // get m_i_d which is the difference in proportion between observed and counterfactual from draw d
keep $variable propdiff_i_d
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
_pctile propdiff_i_d if $variable==$min, percentiles(2.5) 
return list
gen propdiff_lb=r(r1) if $variable==$min
_pctile propdiff_i_d if $variable==$min, percentiles(97.5) 
return list
gen propdiff_ub=r(r1) if $variable==$min

forval i=$min_1/$max {
_pctile propdiff_i_d if $variable==`i', percentiles(2.5) 
return list
replace propdiff_lb=r(r1) if $variable==`i'
_pctile propdiff_i_d if $variable==`i', percentiles(97.5) 
return list
replace propdiff_ub=r(r1) if $variable==`i'
}

collapse propdiff_lb propdiff_ub, by($variable)
save "$dta/MEX_prop_uncertainty", replace
use "$dta/MEX_cf_estimate", clear
merge 1:1 $variable using "$dta/MEX_prop_uncertainty", nogen
gen country="Mexico"
order country $variable n_births cf_count se_cf_count cf_count_lb cf_count_ub countdiff countdiff_lb countdiff_ub prop cf_prop propdiff propdiff_lb propdiff_ub total_births total_cf_count
save "$dta/MEX_comp_diff_$variable", replace


**# Bookmark #28

**** PARENTAL HIGHEST EDU ***
**** PARENTAL HIGHEST EDU ***
**** PARENTAL HIGHEST EDU ***

clear all
*
global variable "mom_dad_edu_comp" // determine group
global ts_data "$dta\MEX_ts_$variable.dta"
use "$ts_data", clear

tab $variable
su $variable, 
global max=r(max)
global min=r(min)
global min_1=r(min)+1
di $max
di $min
di $min_1

global trend "bdate_w" // insert variable names
global season "bweek"
global tw_tm "tw"
global cutoff "2020w51"

*
preserve // get numbers for table later
collapse (sum) n_births if loco==1, by($variable)
egen total_births=sum(n_births)
gen prop= n_births/total_births
save "$dta/MEX_obs_$variable.dta" ,replace
restore 

****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=$min/$max {
use "$ts_data", clear
keep if $variable==`i'
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season i.zika , irr
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
gen $variable=`i'
keep $variable cf_count se_cf_count cf_count_lb cf_count_ub
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
gen $variable=`i'
keep $variable countdiff countdiff_lb countdiff_ub
save "$dta/countdiff_estimate_`i'.dta", replace
restore
}

use "$dta/cf_estimate_$min", clear
forval i=$min_1/$max {
	append using "$dta/cf_estimate_`i'"
}

merge 1:1  $variable using "$dta/MEX_obs_$variable.dta", nogen
order $variable n_births cf_count se_cf_count 
egen total_cf_count=sum(cf_count)
gen cf_prop=cf_count/total_cf_count
gen propdiff=prop-cf_prop
save "$dta/MEX_cf_estimate.dta", replace

use "$dta/countdiff_estimate_$min", clear
forval i=$min_1/$max {
	append using "$dta/countdiff_estimate_`i'"
}

merge 1:1  $variable using "$dta/MEX_cf_estimate.dta", nogen
order $variable n_births cf_count se_cf_count 
save "$dta/MEX_cf_estimate.dta", replace

*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
set seed 123456789
forval d=1/10000 {
use "$dta/MEX_cf_estimate.dta", clear
keep $variable cf_count se_cf_count prop
gen cf_count_i_d=rnormal(cf_count , se_cf_count) // generate random draw d from mean SE estimated from poisson ITS for each SIMD group i
egen sum_cf_count_i_d=sum(cf_count_i_d) // sum random draws d of all groups i
gen cf_prop_i_d=cf_count_i_d/sum_cf_count_i_d // create counterfactual proportion for each group i based on draw d
gen propdiff_i_d=prop- cf_prop_i_d // get m_i_d which is the difference in proportion between observed and counterfactual from draw d
keep $variable propdiff_i_d
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
_pctile propdiff_i_d if $variable==$min, percentiles(2.5) 
return list
gen propdiff_lb=r(r1) if $variable==$min
_pctile propdiff_i_d if $variable==$min, percentiles(97.5) 
return list
gen propdiff_ub=r(r1) if $variable==$min

forval i=$min_1/$max {
_pctile propdiff_i_d if $variable==`i', percentiles(2.5) 
return list
replace propdiff_lb=r(r1) if $variable==`i'
_pctile propdiff_i_d if $variable==`i', percentiles(97.5) 
return list
replace propdiff_ub=r(r1) if $variable==`i'
}

collapse propdiff_lb propdiff_ub, by($variable)
save "$dta/MEX_prop_uncertainty", replace
use "$dta/MEX_cf_estimate", clear
merge 1:1 $variable using "$dta/MEX_prop_uncertainty", nogen
gen country="Mexico"
order country $variable n_births cf_count se_cf_count cf_count_lb cf_count_ub countdiff countdiff_lb countdiff_ub prop cf_prop propdiff propdiff_lb propdiff_ub total_births total_cf_count
save "$dta/MEX_comp_diff_$variable", replace

**# Bookmark #29

*** MATERNAL AGE ***
*** MATERNAL AGE ***
*** MATERNAL AGE ***

clear all
*
global variable "mom_age_cat" // determine group
global ts_data "$dta\MEX_ts_$variable.dta"
use "$ts_data", clear

tab $variable
su $variable, 
global max=r(max)
global min=r(min)
global min_1=r(min)+1
di $max
di $min
di $min_1

global trend "bdate_w" // insert variable names
global season "bweek"
global tw_tm "tw"
global cutoff "2020w51"

*
preserve // get numbers for table later
collapse (sum) n_births if loco==1, by($variable)
egen total_births=sum(n_births)
gen prop= n_births/total_births
save "$dta/MEX_obs_$variable.dta" ,replace
restore 

****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=$min/$max {
use "$ts_data", clear
keep if $variable==`i'
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season i.zika , irr
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
gen $variable=`i'
keep $variable cf_count se_cf_count cf_count_lb cf_count_ub
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
gen $variable=`i'
keep $variable countdiff countdiff_lb countdiff_ub
save "$dta/countdiff_estimate_`i'.dta", replace
restore
}

use "$dta/cf_estimate_$min", clear
forval i=$min_1/$max {
	append using "$dta/cf_estimate_`i'"
}

merge 1:1  $variable using "$dta/MEX_obs_$variable.dta", nogen
order $variable n_births cf_count se_cf_count 
egen total_cf_count=sum(cf_count)
gen cf_prop=cf_count/total_cf_count
gen propdiff=prop-cf_prop
save "$dta/MEX_cf_estimate.dta", replace

use "$dta/countdiff_estimate_$min", clear
forval i=$min_1/$max {
	append using "$dta/countdiff_estimate_`i'"
}

merge 1:1  $variable using "$dta/MEX_cf_estimate.dta", nogen
order $variable n_births cf_count se_cf_count 
save "$dta/MEX_cf_estimate.dta", replace

*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
set seed 123456789
forval d=1/10000 {
use "$dta/MEX_cf_estimate.dta", clear
keep $variable cf_count se_cf_count prop
gen cf_count_i_d=rnormal(cf_count , se_cf_count) // generate random draw d from mean SE estimated from poisson ITS for each SIMD group i
egen sum_cf_count_i_d=sum(cf_count_i_d) // sum random draws d of all groups i
gen cf_prop_i_d=cf_count_i_d/sum_cf_count_i_d // create counterfactual proportion for each group i based on draw d
gen propdiff_i_d=prop- cf_prop_i_d // get m_i_d which is the difference in proportion between observed and counterfactual from draw d
keep $variable propdiff_i_d
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
_pctile propdiff_i_d if $variable==$min, percentiles(2.5) 
return list
gen propdiff_lb=r(r1) if $variable==$min
_pctile propdiff_i_d if $variable==$min, percentiles(97.5) 
return list
gen propdiff_ub=r(r1) if $variable==$min

forval i=$min_1/$max {
_pctile propdiff_i_d if $variable==`i', percentiles(2.5) 
return list
replace propdiff_lb=r(r1) if $variable==`i'
_pctile propdiff_i_d if $variable==`i', percentiles(97.5) 
return list
replace propdiff_ub=r(r1) if $variable==`i'
}

collapse propdiff_lb propdiff_ub, by($variable)
save "$dta/MEX_prop_uncertainty", replace
use "$dta/MEX_cf_estimate", clear
merge 1:1 $variable using "$dta/MEX_prop_uncertainty", nogen
gen country="Mexico"
order country $variable n_births cf_count se_cf_count cf_count_lb cf_count_ub countdiff countdiff_lb countdiff_ub prop cf_prop propdiff propdiff_lb propdiff_ub total_births total_cf_count
save "$dta/MEX_comp_diff_$variable", replace

**# Bookmark #30

clear all
*
global variable "parity" // determine group
global ts_data "$dta\MEX_ts_$variable.dta"
use "$ts_data", clear

tab $variable
su $variable, 
global max=r(max)
global min=r(min)
global min_1=r(min)+1
di $max
di $min
di $min_1

global trend "bdate_w" // insert variable names
global season "bweek"
global tw_tm "tw"
global cutoff "2020w51"

*
preserve // get numbers for table later
collapse (sum) n_births if loco==1, by($variable)
egen total_births=sum(n_births)
gen prop= n_births/total_births
save "$dta/MEX_obs_$variable.dta" ,replace
restore 

****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=$min/$max {
use "$ts_data", clear
keep if $variable==`i'
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season i.zika , irr
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
gen $variable=`i'
keep $variable cf_count se_cf_count cf_count_lb cf_count_ub
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
gen $variable=`i'
keep $variable countdiff countdiff_lb countdiff_ub
save "$dta/countdiff_estimate_`i'.dta", replace
restore
}

use "$dta/cf_estimate_$min", clear
forval i=$min_1/$max {
	append using "$dta/cf_estimate_`i'"
}

merge 1:1  $variable using "$dta/MEX_obs_$variable.dta", nogen
order $variable n_births cf_count se_cf_count 
egen total_cf_count=sum(cf_count)
gen cf_prop=cf_count/total_cf_count
gen propdiff=prop-cf_prop
save "$dta/MEX_cf_estimate.dta", replace

use "$dta/countdiff_estimate_$min", clear
forval i=$min_1/$max {
	append using "$dta/countdiff_estimate_`i'"
}

merge 1:1  $variable using "$dta/MEX_cf_estimate.dta", nogen
order $variable n_births cf_count se_cf_count 
save "$dta/MEX_cf_estimate.dta", replace

*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
set seed 123456789
forval d=1/10000 {
use "$dta/MEX_cf_estimate.dta", clear
keep $variable cf_count se_cf_count prop
gen cf_count_i_d=rnormal(cf_count , se_cf_count) // generate random draw d from mean SE estimated from poisson ITS for each SIMD group i
egen sum_cf_count_i_d=sum(cf_count_i_d) // sum random draws d of all groups i
gen cf_prop_i_d=cf_count_i_d/sum_cf_count_i_d // create counterfactual proportion for each group i based on draw d
gen propdiff_i_d=prop- cf_prop_i_d // get m_i_d which is the difference in proportion between observed and counterfactual from draw d
keep $variable propdiff_i_d
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
_pctile propdiff_i_d if $variable==$min, percentiles(2.5) 
return list
gen propdiff_lb=r(r1) if $variable==$min
_pctile propdiff_i_d if $variable==$min, percentiles(97.5) 
return list
gen propdiff_ub=r(r1) if $variable==$min

forval i=$min_1/$max {
_pctile propdiff_i_d if $variable==`i', percentiles(2.5) 
return list
replace propdiff_lb=r(r1) if $variable==`i'
_pctile propdiff_i_d if $variable==`i', percentiles(97.5) 
return list
replace propdiff_ub=r(r1) if $variable==`i'
}

collapse propdiff_lb propdiff_ub, by($variable)
save "$dta/MEX_prop_uncertainty", replace
use "$dta/MEX_cf_estimate", clear
merge 1:1 $variable using "$dta/MEX_prop_uncertainty", nogen
gen country="Mexico"
order country $variable n_births cf_count se_cf_count cf_count_lb cf_count_ub countdiff countdiff_lb countdiff_ub prop cf_prop propdiff propdiff_lb propdiff_ub total_births total_cf_count
save "$dta/MEX_comp_diff_$variable", replace


**# Bookmark #31

*********** MEXICO TABLE *****************
*********** MEXICO TABLE *****************
*********** MEXICO TABLE *****************
use "$dta/MEX_comp_diff_mom_edu", clear
append using "$dta/MEX_comp_diff_mom_dad_edu_comp", 
append using "$dta/MEX_comp_diff_mom_age_cat"
append using "$dta/MEX_comp_diff_parity"
gen rel_count_diff=(n_births-cf_count)/(abs(cf_count))*100
gen rel_count_diff_ub=(n_births-cf_count_lb)/(abs(cf_count_lb))*100
gen rel_count_diff_lb=(n_births-cf_count_ub)/(abs(cf_count_ub))*100
order country  mom_edu mom_dad_edu_comp mom_age_cat parity n_births cf_count se_cf_count cf_count_lb cf_count_ub countdiff countdiff_lb countdiff_ub rel_count_diff rel_count_diff_lb rel_count_diff_ub prop cf_prop propdiff propdiff_lb propdiff_ub total_births total_cf_count

drop se_cf_count
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

order country mom_edu mom_dad_edu_comp mom_age_cat parity n_births cf_count  cf_count_ci countdiff countdiff_ci  rel_count_diff rel_diff_ci prop cf_prop propdiff propdiff_ci total_births total_cf_count

save "$dta/MEX_table_profile_$S_DATE", replace
export excel using "$table\MEX_table_profile_$S_DATE.xls", firstrow(variables) replace


**# Bookmark #32

*************** NETHERLANDS NETHERLANDS **************
*************** NETHERLANDS NETHERLANDS **************
*************** NETHERLANDS NETHERLANDS **************
*************** NETHERLANDS NETHERLANDS **************

**** MAIN SEC VARIABLE
**** MAIN SEC VARIABLE

clear all
use "$dta/NET_ts", clear
global ts_data "$dta/NET_ts"
global variable "hh_inc" // determine group
su $variable, 
global max=r(max)
global min=r(min)
global min_1=r(min)+1
di $max
di $min
di $min_1

global trend "mdate" // insert variable names
global season "month_nr"
global tw_tm "tm"
global cutoff "2020m12"

****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=$min/$max {
use "$ts_data.dta", clear
keep if $variable==`i'
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season , irr

quietly: margins, ///
at($trend=(660(1)743) loco=(0)) ///
at($trend=(731(1)743) loco=(1)) ///
predict(n) ///
saving("$dta/margins_ts_`i'.dta", replace)

preserve 
use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin lin_count
keep lin_count $trend loco
drop if loco==0 & $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/lin_pred_`i'.dta",replace

use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin cf_lin_count
keep cf_lin_count $trend loco
keep if loco==0 &  $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/cf_lin_pred_`i'.dta",replace
restore

}

use "$dta/lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/lin_pred_`i'"
}
save "$dta/lin_pred_all", replace

use "$dta/cf_lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/cf_lin_pred_`i'"
}
save "$dta/cf_lin_pred_all", replace


use "$ts_data", clear
merge 1:1 $trend $variable using "$dta/lin_pred_all", nogen
merge 1:1 $trend $variable using "$dta/cf_lin_pred_all", nogen

forval i=$min/$max {
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season if $variable==`i', irr
predict pred_count_`i' if $variable==`i'
}
gen pred_count=pred_count_$min
forval i=$min_1/$max{
	replace pred_count=pred_count_`i' if pred_count==.
}
drop pred_count_$min - pred_count_$max
*PLOT IT
forvalues i=$min/$max {
  local v : label ($variable) `i'
   display "`i' is `v'"
   }

local forlab: value label $variable
forvalues i = $min/$max {
	local label: label `forlab' `i'
	di "`label'" 

tw ///
(line pred_count $trend if $variable==`i', lwidth(thin) lcolor(gs10)) ///
(line lin_count $trend if loco==0 & $variable==`i', lwidth(medium) lcolor(black)) ///
(line cf_lin_count $trend if loco==1 & $variable==`i', lpattern(shortdash) lwidth(medium) lcolor(black)) ///
(line lin_count $trend if loco==1 & $variable==`i', lpattern(solid) lwidth(medium) lcolor(black)) ///
(scatter n_births $trend if $variable==`i', msize(vsmall) mcolor(ebblue%60) msym(o)) ///
, ///
xline(731, lpattern(solid) lcolor(red) lwidth(vthin)) ///
xt("Month of Birth") ///
xlab(660(24)731, ) ///
ylab(, angle(h)) ///
yt("Number of Live Births") ///
legend(order(5 "Observed" 1 "Fitted" 2 "Deseasonalised Fitted" 3 "Deseasonalised Expected") row(1)) ///
title("{bf:`label'}", size(medsmall)) ///
plotregion(lcolor(black)) ///
name(C`i', replace) ///
scheme(white_tableau)

}

*combine plots
grc1leg2 C1 C2 C3 C4 C5 C6, ///
legendfrom(C1) ///
position(6) lyoffset(0) lxoffset(0) ///
legscale(*1) plotregion(margin(zero)) imargin(tiny) ///
xtob1title ytol1title ///
title("Netherlands, Household Income", size(medsmall)) ///
scheme(white_tableau)

graph export "$graph/NET_hh_inc_$S_DATE.svg", replace

**# Bookmark #33

****** MOM AGE *****
****** MOM AGE *****
****** MOM AGE *****
****** MOM AGE *****
import excel "C:\Users\moritzob\OneDrive - University of Helsinki\postdoc life helsinki\LoCo-effect\LoCo-effect Netherlands\dta\Monthly_births_counts.xlsx", sheet("Counts") firstrow clear
rename birthmonth month_nr
rename birthyear year
gen mdate=ym(year, month_nr)
format mdate %tm
gen age1=totalbirths - sumAbove25 // younger than 26
gen age2=sumAbove25 - sumAbove35 // aged 26-35
gen age3= sumAbove35 // older than 35
gen total_births= age1 + age2 + age3
keep mdate month_nr age1 age2 age3 total_births
reshape long age, i(mdate) j(mom_age)
rename age n_births
gen loco =0
replace loco=1 if mdate>tm(2020m11)
label define agelab 1 "Maternal age under 26" 2 "26-35" 3 "Older than 35"
label values mom_age agelab
rename mom_age mom_age_cat

global variable "mom_age_cat" // determine group
su $variable, 
global max=r(max)
global min=r(min)
global min_1=r(min)+1
di $max
di $min
di $min_1
global trend "mdate" // insert variable names
global season "month_nr"
global tw_tm "tm"
global cutoff "2020m12"

save "$dta/NET_ts_$variable", replace
global ts_data "$dta/NET_ts_$variable"

****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=$min/$max {
use "$ts_data.dta", clear
keep if $variable==`i'
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season , irr

quietly: margins, ///
at($trend=(660(1)743) loco=(0)) ///
at($trend=(731(1)743) loco=(1)) ///
predict(n) ///
saving("$dta/margins_ts_`i'.dta", replace)

preserve 
use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin lin_count
keep lin_count $trend loco
drop if loco==0 & $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/lin_pred_`i'.dta",replace

use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin cf_lin_count
keep cf_lin_count $trend loco
keep if loco==0 &  $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/cf_lin_pred_`i'.dta",replace
restore

}

use "$dta/lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/lin_pred_`i'"
}
save "$dta/lin_pred_all", replace

use "$dta/cf_lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/cf_lin_pred_`i'"
}
save "$dta/cf_lin_pred_all", replace


use "$ts_data", clear
merge 1:1 $trend $variable using "$dta/lin_pred_all", nogen
merge 1:1 $trend $variable using "$dta/cf_lin_pred_all", nogen

forval i=$min/$max {
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season if $variable==`i', irr
predict pred_count_`i' if $variable==`i'
}
gen pred_count=pred_count_$min
forval i=$min_1/$max{
	replace pred_count=pred_count_`i' if pred_count==.
}
drop pred_count_$min - pred_count_$max
*PLOT IT
forvalues i=$min/$max {
  local v : label ($variable) `i'
   display "`i' is `v'"
   }

local forlab: value label $variable
forvalues i = $min/$max {
	local label: label `forlab' `i'
	di "`label'" 

tw ///
(line pred_count $trend if $variable==`i', lwidth(thin) lcolor(gs10)) ///
(line lin_count $trend if loco==0 & $variable==`i', lwidth(medium) lcolor(black)) ///
(line cf_lin_count $trend if loco==1 & $variable==`i', lpattern(shortdash) lwidth(medium) lcolor(black)) ///
(line lin_count $trend if loco==1 & $variable==`i', lpattern(solid) lwidth(medium) lcolor(black)) ///
(scatter n_births $trend if $variable==`i', msize(vsmall) mcolor(ebblue%60) msym(o)) ///
, ///
xline(731, lpattern(solid) lcolor(red) lwidth(vthin)) ///
xt("Month of Birth") ///
xlab(660(24)731, ) ///
ylab(, angle(h)) ///
yt("Number of Live Births") ///
legend(order(5 "Observed" 1 "Fitted" 2 "Deseasonalised Fitted" 3 "Deseasonalised Expected") col(1)) ///
title("{bf:`label'}", size(medsmall)) ///
plotregion(lcolor(black)) ///
name(C`i', replace) ///
scheme(white_tableau)

}

*combine plots
grc1leg2 C1 C2 C3 , ///
legendfrom(C1) ///
position(4) ring(0) lyoffset(10) lxoffset(-10) ///
legscale(*1) plotregion(margin(zero)) imargin(tiny) ///
xtob1title ytol1title ///
title("Netherlands, Maternal Age", size(medsmall)) ///
scheme(white_tableau)

graph export "$graph/NET_mom_age_cat_$S_DATE.svg", replace


**# Bookmark #34

****** PARITY *****
****** PARITY *****
****** PARITY *****
import excel "C:\Users\moritzob\OneDrive - University of Helsinki\postdoc life helsinki\LoCo-effect\LoCo-effect Netherlands\dta\Monthly_births_counts.xlsx", sheet("Counts") firstrow clear
rename birthmonth month_nr
rename birthyear year
gen mdate=ym(year, month_nr)
format mdate %tm
gen parity0= sumfirstchild
gen parity1= totalbirths- parity0
gen total_births= parity0+parity1
keep mdate month_nr parity0 parity1 total_births
reshape long parity, i(mdate) j(new)
rename parity n_births
rename new parity
gen loco =0
replace loco=1 if mdate>tm(2020m11)
label define parlab 0 "Parity 0" 1 "Parity greater than 0"
label values parity parlab

global variable "parity" // determine group
su $variable, 
global max=r(max)
global min=r(min)
global min_1=r(min)+1
di $max
di $min
di $min_1
global trend "mdate" // insert variable names
global season "month_nr"
global tw_tm "tm"
global cutoff "2020m12"

save "$dta/NET_ts_$variable", replace
global ts_data "$dta/NET_ts_$variable"

****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=$min/$max {
use "$ts_data.dta", clear
keep if $variable==`i'
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season , irr

quietly: margins, ///
at($trend=(660(1)743) loco=(0)) ///
at($trend=(731(1)743) loco=(1)) ///
predict(n) ///
saving("$dta/margins_ts_`i'.dta", replace)

preserve 
use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin lin_count
keep lin_count $trend loco
drop if loco==0 & $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/lin_pred_`i'.dta",replace

use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin cf_lin_count
keep cf_lin_count $trend loco
keep if loco==0 &  $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/cf_lin_pred_`i'.dta",replace
restore

}

use "$dta/lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/lin_pred_`i'"
}
save "$dta/lin_pred_all", replace

use "$dta/cf_lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/cf_lin_pred_`i'"
}
save "$dta/cf_lin_pred_all", replace


use "$ts_data", clear
merge 1:1 $trend $variable using "$dta/lin_pred_all", nogen
merge 1:1 $trend $variable using "$dta/cf_lin_pred_all", nogen

forval i=$min/$max {
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season if $variable==`i', irr
predict pred_count_`i' if $variable==`i'
}
gen pred_count=pred_count_$min
forval i=$min_1/$max{
	replace pred_count=pred_count_`i' if pred_count==.
}
drop pred_count_$min - pred_count_$max
*PLOT IT
forvalues i=$min/$max {
  local v : label ($variable) `i'
   display "`i' is `v'"
   }

local forlab: value label $variable
forvalues i = $min/$max {
	local label: label `forlab' `i'
	di "`label'" 

tw ///
(line pred_count $trend if $variable==`i', lwidth(thin) lcolor(gs10)) ///
(line lin_count $trend if loco==0 & $variable==`i', lwidth(medium) lcolor(black)) ///
(line cf_lin_count $trend if loco==1 & $variable==`i', lpattern(shortdash) lwidth(medium) lcolor(black)) ///
(line lin_count $trend if loco==1 & $variable==`i', lpattern(solid) lwidth(medium) lcolor(black)) ///
(scatter n_births $trend if $variable==`i', msize(vsmall) mcolor(ebblue%60) msym(o)) ///
, ///
xline(731, lpattern(solid) lcolor(red) lwidth(vthin)) ///
xt("Month of Birth") ///
xlab(660(24)731, ) ///
ylab(, angle(h)) ///
yt("Number of Live Births") ///
legend(order(5 "Observed" 1 "Fitted" 2 "Deseasonalised Fitted" 3 "Deseasonalised Expected") row(1)) ///
title("{bf:`label'}", size(medsmall)) ///
plotregion(lcolor(black)) ///
name(C`i', replace) ///
scheme(white_tableau)

}

*combine plots
grc1leg2 C0 C1  , ///
legendfrom(C1) ///
position(6) lyoffset(0) lxoffset(0) ///
legscale(*1) plotregion(margin(zero)) imargin(tiny) ///
xtob1title ytol1title ///
title("Netherlands, Parity", size(medsmall)) ///
scheme(white_tableau)

graph export "$graph/NET_parity_$S_DATE.svg", replace

**# Bookmark #35

****************************************************
****************************************************
*---------------- Tables ---------------------------
*---------------- Tables ---------------------------

********** MATERNAL AGE **********
********** MATERNAL AGE **********
********** MATERNAL AGE **********

clear all
*
global variable "mom_age_cat" // determine group
global ts_data "$dta\NET_ts_$variable.dta"
use "$ts_data", clear

tab $variable
su $variable, 
global max=r(max)
global min=r(min)
global min_1=r(min)+1
di $max
di $min
di $min_1

global trend "mdate" // insert variable names
global season "month_nr"
global tw_tm "tm"
global cutoff "2020m12"

*
preserve // get numbers for table later
collapse (sum) n_births if loco==1, by($variable)
egen total_births=sum(n_births)
gen prop= n_births/total_births
save "$dta/NET_obs_$variable.dta" ,replace
restore 

****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=$min/$max {
use "$ts_data", clear
keep if $variable==`i'
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season , irr
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
gen $variable=`i'
keep $variable cf_count se_cf_count cf_count_lb cf_count_ub
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
gen $variable=`i'
keep $variable countdiff countdiff_lb countdiff_ub
save "$dta/countdiff_estimate_`i'.dta", replace
restore
}

use "$dta/cf_estimate_$min", clear
forval i=$min_1/$max {
	append using "$dta/cf_estimate_`i'"
}

merge 1:1  $variable using "$dta/NET_obs_$variable.dta", nogen
order $variable n_births cf_count se_cf_count 
egen total_cf_count=sum(cf_count)
gen cf_prop=cf_count/total_cf_count
gen propdiff=prop-cf_prop
save "$dta/NET_cf_estimate.dta", replace

use "$dta/countdiff_estimate_$min", clear
forval i=$min_1/$max {
	append using "$dta/countdiff_estimate_`i'"
}

merge 1:1  $variable using "$dta/NET_cf_estimate.dta", nogen
order $variable n_births cf_count se_cf_count 
save "$dta/NET_cf_estimate.dta", replace

*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
set seed 123456789
forval d=1/10000 {
use "$dta/NET_cf_estimate.dta", clear
keep $variable cf_count se_cf_count prop
gen cf_count_i_d=rnormal(cf_count , se_cf_count) // generate random draw d from mean SE estimated from poisson ITS for each SIMD group i
egen sum_cf_count_i_d=sum(cf_count_i_d) // sum random draws d of all groups i
gen cf_prop_i_d=cf_count_i_d/sum_cf_count_i_d // create counterfactual proportion for each group i based on draw d
gen propdiff_i_d=prop- cf_prop_i_d // get m_i_d which is the difference in proportion between observed and counterfactual from draw d
keep $variable propdiff_i_d
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
_pctile propdiff_i_d if $variable==$min, percentiles(2.5) 
return list
gen propdiff_lb=r(r1) if $variable==$min
_pctile propdiff_i_d if $variable==$min, percentiles(97.5) 
return list
gen propdiff_ub=r(r1) if $variable==$min

forval i=$min_1/$max {
_pctile propdiff_i_d if $variable==`i', percentiles(2.5) 
return list
replace propdiff_lb=r(r1) if $variable==`i'
_pctile propdiff_i_d if $variable==`i', percentiles(97.5) 
return list
replace propdiff_ub=r(r1) if $variable==`i'
}

collapse propdiff_lb propdiff_ub, by($variable)
save "$dta/NET_prop_uncertainty", replace
use "$dta/NET_cf_estimate", clear
merge 1:1 $variable using "$dta/NET_prop_uncertainty", nogen
gen country="Netherlands"
order country $variable n_births cf_count se_cf_count cf_count_lb cf_count_ub countdiff countdiff_lb countdiff_ub prop cf_prop propdiff propdiff_lb propdiff_ub total_births total_cf_count
save "$dta/NET_comp_diff_$variable", replace

**# Bookmark #36

********** PARITY  **********
********** PARITY  **********
********** PARITY  **********

clear all
*
global variable "parity" // determine group
global ts_data "$dta\NET_ts_$variable.dta"
use "$ts_data", clear

tab $variable
su $variable, 
global max=r(max)
global min=r(min)
global min_1=r(min)+1
di $max
di $min
di $min_1

global trend "mdate" // insert variable names
global season "month_nr"
global tw_tm "tm"
global cutoff "2020m12"

*
preserve // get numbers for table later
collapse (sum) n_births if loco==1, by($variable)
egen total_births=sum(n_births)
gen prop= n_births/total_births
save "$dta/NET_obs_$variable.dta" ,replace
restore 

****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=$min/$max {
use "$ts_data", clear
keep if $variable==`i'
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season , irr
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
gen $variable=`i'
keep $variable cf_count se_cf_count cf_count_lb cf_count_ub
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
gen $variable=`i'
keep $variable countdiff countdiff_lb countdiff_ub
save "$dta/countdiff_estimate_`i'.dta", replace
restore
}

use "$dta/cf_estimate_$min", clear
forval i=$min_1/$max {
	append using "$dta/cf_estimate_`i'"
}

merge 1:1  $variable using "$dta/NET_obs_$variable.dta", nogen
order $variable n_births cf_count se_cf_count 
egen total_cf_count=sum(cf_count)
gen cf_prop=cf_count/total_cf_count
gen propdiff=prop-cf_prop
save "$dta/NET_cf_estimate.dta", replace

use "$dta/countdiff_estimate_$min", clear
forval i=$min_1/$max {
	append using "$dta/countdiff_estimate_`i'"
}

merge 1:1  $variable using "$dta/NET_cf_estimate.dta", nogen
order $variable n_births cf_count se_cf_count 
save "$dta/NET_cf_estimate.dta", replace

*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
set seed 123456789
forval d=1/10000 {
use "$dta/NET_cf_estimate.dta", clear
keep $variable cf_count se_cf_count prop
gen cf_count_i_d=rnormal(cf_count , se_cf_count) // generate random draw d from mean SE estimated from poisson ITS for each SIMD group i
egen sum_cf_count_i_d=sum(cf_count_i_d) // sum random draws d of all groups i
gen cf_prop_i_d=cf_count_i_d/sum_cf_count_i_d // create counterfactual proportion for each group i based on draw d
gen propdiff_i_d=prop- cf_prop_i_d // get m_i_d which is the difference in proportion between observed and counterfactual from draw d
keep $variable propdiff_i_d
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
_pctile propdiff_i_d if $variable==$min, percentiles(2.5) 
return list
gen propdiff_lb=r(r1) if $variable==$min
_pctile propdiff_i_d if $variable==$min, percentiles(97.5) 
return list
gen propdiff_ub=r(r1) if $variable==$min

forval i=$min_1/$max {
_pctile propdiff_i_d if $variable==`i', percentiles(2.5) 
return list
replace propdiff_lb=r(r1) if $variable==`i'
_pctile propdiff_i_d if $variable==`i', percentiles(97.5) 
return list
replace propdiff_ub=r(r1) if $variable==`i'
}

collapse propdiff_lb propdiff_ub, by($variable)
save "$dta/NET_prop_uncertainty", replace
use "$dta/NET_cf_estimate", clear
merge 1:1 $variable using "$dta/NET_prop_uncertainty", nogen
gen country="Netherlands"
order country $variable n_births cf_count se_cf_count cf_count_lb cf_count_ub countdiff countdiff_lb countdiff_ub prop cf_prop propdiff propdiff_lb propdiff_ub total_births total_cf_count
save "$dta/NET_comp_diff_$variable", replace

**# Bookmark #37

****************** NETHERLANDS TABLE **********
****************** NETHERLANDS TABLE **********
****************** NETHERLANDS TABLE **********
use "$dta/NET_comp_diff_mom_age_cat", clear
append using "$dta/NET_comp_diff_parity"
gen rel_count_diff=(n_births-cf_count)/(abs(cf_count))*100
gen rel_count_diff_ub=(n_births-cf_count_lb)/(abs(cf_count_lb))*100
gen rel_count_diff_lb=(n_births-cf_count_ub)/(abs(cf_count_ub))*100
order country  mom_age_cat parity n_births cf_count se_cf_count cf_count_lb cf_count_ub countdiff countdiff_lb countdiff_ub rel_count_diff rel_count_diff_lb rel_count_diff_ub prop cf_prop propdiff propdiff_lb propdiff_ub total_births total_cf_count

drop se_cf_count
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

order country mom_age_cat parity n_births cf_count  cf_count_ci countdiff countdiff_ci  rel_count_diff rel_diff_ci prop cf_prop propdiff propdiff_ci total_births total_cf_count


save "$dta/NET_table_profile_$S_DATE", replace
export excel using "$table\NET_table_profile_$S_DATE.xls", firstrow(variables) replace


**# Bookmark #38

**************** SCOTLAND SCOTLAND ************
**************** SCOTLAND SCOTLAND ************
**************** SCOTLAND SCOTLAND ************

*** MAIN SEC VARIABLE 
*** MAIN SEC VARIABLE 
*** MAIN SEC VARIABLE 

clear all
use "$dta/Scot_ts", clear
global ts_data "$dta/Scot_ts"
global variable "area_deprivation" // determine group
su $variable, 
global max=r(max)
global min=r(min)
global min_1=r(min)+1
di $max
di $min
di $min_1

global trend "mdate" // insert variable names
global season "month_nr"
global tw_tm "tm"
global cutoff "2020m12"

****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=$min/$max {
use "$ts_data.dta", clear
keep if $variable==`i'
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season , irr

quietly: margins, ///
at($trend=(660(1)743) loco=(0)) ///
at($trend=(731(1)743) loco=(1)) ///
predict(n) ///
saving("$dta/margins_ts_`i'.dta", replace)

preserve 
use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin lin_count
keep lin_count $trend loco
drop if loco==0 & $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/lin_pred_`i'.dta",replace

use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin cf_lin_count
keep cf_lin_count $trend loco
keep if loco==0 &  $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/cf_lin_pred_`i'.dta",replace
restore

}

use "$dta/lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/lin_pred_`i'"
}
save "$dta/lin_pred_all", replace

use "$dta/cf_lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/cf_lin_pred_`i'"
}
save "$dta/cf_lin_pred_all", replace


use "$ts_data", clear
merge 1:1 $trend $variable using "$dta/lin_pred_all", nogen
merge 1:1 $trend $variable using "$dta/cf_lin_pred_all", nogen

forval i=$min/$max {
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season if $variable==`i', irr
predict pred_count_`i' if $variable==`i'
}
gen pred_count=pred_count_$min
forval i=$min_1/$max{
	replace pred_count=pred_count_`i' if pred_count==.
}
drop pred_count_$min - pred_count_$max
*PLOT IT
forvalues i=$min/$max {
  local v : label ($variable) `i'
   display "`i' is `v'"
   }

local forlab: value label $variable
forvalues i = $min/$max {
	local label: label `forlab' `i'
	di "`label'" 

tw ///
(line pred_count $trend if $variable==`i', lwidth(thin) lcolor(gs10)) ///
(line lin_count $trend if loco==0 & $variable==`i', lwidth(medium) lcolor(black)) ///
(line cf_lin_count $trend if loco==1 & $variable==`i', lpattern(shortdash) lwidth(medium) lcolor(black)) ///
(line lin_count $trend if loco==1 & $variable==`i', lpattern(solid) lwidth(medium) lcolor(black)) ///
(scatter n_births $trend if $variable==`i', msize(vsmall) mcolor(ebblue%60) msym(o)) ///
, ///
xline(731, lpattern(solid) lcolor(red) lwidth(vthin)) ///
xt("Month of Birth") ///
xlab(660(24)731, ) ///
ylab(, angle(h)) ///
yt("Number of Live Births") ///
legend(order(5 "Observed" 1 "Fitted" 2 "Deseasonalised Fitted" 3 "Deseasonalised Expected") row(1)) ///
title("{bf:`label'}", size(medsmall)) ///
plotregion(lcolor(black)) ///
name(C`i', replace) ///
scheme(white_tableau)

}

*combine plots
grc1leg2 C1 C2 C3 C4 C5 C6, ///
legendfrom(C1) ///
position(6) lyoffset(0) lxoffset(0) ///
legscale(*1) plotregion(margin(zero)) imargin(tiny) ///
xtob1title ytol1title ///
title("Scotland, Scottish Index of Multiple Deprivation", size(medsmall)) ///
scheme(white_tableau)

graph export "$graph/SCOT_area_deprivationQ5_$S_DATE.svg", replace

**# Bookmark #39

***** MATERNAL AGE *********
***** MATERNAL AGE *********
***** MATERNAL AGE *********

import delimited "C:\Users\moritzob\OneDrive - University of Helsinki\postdoc life helsinki\LoCo-effect\LoCo-effect Scotland Composition\dta\WI_DELIVERIES_DOWNLOAD_mode_2022-11-04.csv", clear
keep if nhs_board_of_residence=="Scotland" & subgroup=="AGEGRP"
keep variable  month_of_discharge  births
*create date variable
gen date = date(month_of_discharge,"YMD")
format date %td
gen mdate=mofd(date)
format mdate %tm
gen year=yofd(date)
rename births allbirths
gen month_nr=month(date)
encode variable, gen(agegrp)
replace agegrp=0 if agegrp==6

gen loco=0
replace loco=1 if mdate>tm(2020m11)
*FIXED EFFECTS POISSON
*nonlinear trends?
drop if mdate>tm(2021m12) // only until 2021 for harmonisation

*reshape to create sum of oldest groups
keep allbirths loco  mdate agegrp month_nr
reshape wide allbirths   , i(mdate) j(agegrp)

gen allbirths6=allbirths4+allbirths5
reshape long

drop if agegrp==4 | agegrp==5
replace agegrp=4 if agegrp==6

gen mom_age_cat= 1 + agegrp
label define age_lab 1 "Maternal Age Under 20" 2 "20-24" 3 "25-29" 4 "30-34" 5 "35 and Above"
label values mom_age_cat age_lab
drop agegrp
rename allbirths n_births
global variable "mom_age_cat" // determine group
su $variable, 
global max=r(max)
global min=r(min)
global min_1=r(min)+1
di $max
di $min
di $min_1
global trend "mdate" // insert variable names
global season "month_nr"
global tw_tm "tm"
global cutoff "2020m12"

save "$dta/Scot_ts_$variable", replace
global ts_data "$dta/Scot_ts_$variable"

****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=$min/$max {
use "$ts_data.dta", clear
keep if $variable==`i'
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season , irr

quietly: margins, ///
at($trend=(660(1)743) loco=(0)) ///
at($trend=(731(1)743) loco=(1)) ///
predict(n) ///
saving("$dta/margins_ts_`i'.dta", replace)

preserve 
use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin lin_count
keep lin_count $trend loco
drop if loco==0 & $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/lin_pred_`i'.dta",replace

use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin cf_lin_count
keep cf_lin_count $trend loco
keep if loco==0 &  $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/cf_lin_pred_`i'.dta",replace
restore

}

use "$dta/lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/lin_pred_`i'"
}
save "$dta/lin_pred_all", replace

use "$dta/cf_lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/cf_lin_pred_`i'"
}
save "$dta/cf_lin_pred_all", replace


use "$ts_data", clear
merge 1:1 $trend $variable using "$dta/lin_pred_all", nogen
merge 1:1 $trend $variable using "$dta/cf_lin_pred_all", nogen

forval i=$min/$max {
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season if $variable==`i', irr
predict pred_count_`i' if $variable==`i'
}
gen pred_count=pred_count_$min
forval i=$min_1/$max{
	replace pred_count=pred_count_`i' if pred_count==.
}
drop pred_count_$min - pred_count_$max
*PLOT IT
forvalues i=$min/$max {
  local v : label ($variable) `i'
   display "`i' is `v'"
   }

local forlab: value label $variable
forvalues i = $min/$max {
	local label: label `forlab' `i'
	di "`label'" 

tw ///
(line pred_count $trend if $variable==`i', lwidth(thin) lcolor(gs10)) ///
(line lin_count $trend if loco==0 & $variable==`i', lwidth(medium) lcolor(black)) ///
(line cf_lin_count $trend if loco==1 & $variable==`i', lpattern(shortdash) lwidth(medium) lcolor(black)) ///
(line lin_count $trend if loco==1 & $variable==`i', lpattern(solid) lwidth(medium) lcolor(black)) ///
(scatter n_births $trend if $variable==`i', msize(vsmall) mcolor(ebblue%60) msym(o)) ///
, ///
xline(731, lpattern(solid) lcolor(red) lwidth(vthin)) ///
xt("Month of Birth") ///
xlab(660(24)731, ) ///
ylab(, angle(h)) ///
yt("Number of Live Births") ///
legend(order(5 "Observed" 1 "Fitted" 2 "Deseasonalised Fitted" 3 "Deseasonalised Expected") col(1)) ///
title("{bf:`label'}", size(medsmall)) ///
plotregion(lcolor(black)) ///
name(C`i', replace) ///
scheme(white_tableau)

}

*combine plots
grc1leg2 C1 C2 C3 C4 C5 , ///
legendfrom(C1) ///
position(4) ring(0) lyoffset(10) lxoffset(0) ///
legscale(*1) plotregion(margin(zero)) imargin(tiny) ///
xtob1title ytol1title ///
title("Scotland, Maternal Age", size(medsmall)) ///
scheme(white_tableau)

graph export "$graph/Scot_mom_age_cat_$S_DATE.svg", replace

**# Bookmark #42

****************************************************
****************************************************
*---------------- Tables ---------------------------
*---------------- Tables ---------------------------

********* MOM AGE   **********
********* MOM AGE   **********
********* MOM AGE   **********

clear all
*
global variable "mom_age_cat" // determine group
global ts_data "$dta\Scot_ts_$variable.dta"
use "$ts_data", clear

tab $variable
su $variable, 
global max=r(max)
global min=r(min)
global min_1=r(min)+1
di $max
di $min
di $min_1

global trend "mdate" // insert variable names
global season "month_nr"
global tw_tm "tm"
global cutoff "2020m12"

*
preserve // get numbers for table later
collapse (sum) n_births if loco==1, by($variable)
egen total_births=sum(n_births)
gen prop= n_births/total_births
save "$dta/Scot_obs_$variable.dta" ,replace
restore 

****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=$min/$max {
use "$ts_data", clear
keep if $variable==`i'
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season , irr
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
gen $variable=`i'
keep $variable cf_count se_cf_count cf_count_lb cf_count_ub
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
gen $variable=`i'
keep $variable countdiff countdiff_lb countdiff_ub
save "$dta/countdiff_estimate_`i'.dta", replace
restore
}

use "$dta/cf_estimate_$min", clear
forval i=$min_1/$max {
	append using "$dta/cf_estimate_`i'"
}

merge 1:1  $variable using "$dta/Scot_obs_$variable.dta", nogen
order $variable n_births cf_count se_cf_count 
egen total_cf_count=sum(cf_count)
gen cf_prop=cf_count/total_cf_count
gen propdiff=prop-cf_prop
save "$dta/Scot_cf_estimate.dta", replace

use "$dta/countdiff_estimate_$min", clear
forval i=$min_1/$max {
	append using "$dta/countdiff_estimate_`i'"
}

merge 1:1  $variable using "$dta/Scot_cf_estimate.dta", nogen
order $variable n_births cf_count se_cf_count 
save "$dta/Scot_cf_estimate.dta", replace

*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
set seed 123456789
forval d=1/10000 {
use "$dta/Scot_cf_estimate.dta", clear
keep $variable cf_count se_cf_count prop
gen cf_count_i_d=rnormal(cf_count , se_cf_count) // generate random draw d from mean SE estimated from poisson ITS for each SIMD group i
egen sum_cf_count_i_d=sum(cf_count_i_d) // sum random draws d of all groups i
gen cf_prop_i_d=cf_count_i_d/sum_cf_count_i_d // create counterfactual proportion for each group i based on draw d
gen propdiff_i_d=prop- cf_prop_i_d // get m_i_d which is the difference in proportion between observed and counterfactual from draw d
keep $variable propdiff_i_d
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
_pctile propdiff_i_d if $variable==$min, percentiles(2.5) 
return list
gen propdiff_lb=r(r1) if $variable==$min
_pctile propdiff_i_d if $variable==$min, percentiles(97.5) 
return list
gen propdiff_ub=r(r1) if $variable==$min

forval i=$min_1/$max {
_pctile propdiff_i_d if $variable==`i', percentiles(2.5) 
return list
replace propdiff_lb=r(r1) if $variable==`i'
_pctile propdiff_i_d if $variable==`i', percentiles(97.5) 
return list
replace propdiff_ub=r(r1) if $variable==`i'
}

collapse propdiff_lb propdiff_ub, by($variable)
save "$dta/Scot_prop_uncertainty", replace
use "$dta/Scot_cf_estimate", clear
merge 1:1 $variable using "$dta/Scot_prop_uncertainty", nogen
gen country="Scotland"
order country $variable n_births cf_count se_cf_count cf_count_lb cf_count_ub countdiff countdiff_lb countdiff_ub prop cf_prop propdiff propdiff_lb propdiff_ub total_births total_cf_count
save "$dta/Scot_comp_diff_$variable", replace

**# Bookmark #45

****************** SCOTLAND TABLE **********
****************** SCOTLAND TABLE **********
****************** SCOTLAND TABLE **********
use "$dta/Scot_comp_diff_mom_age_cat", clear
gen rel_count_diff=(n_births-cf_count)/(abs(cf_count))*100
gen rel_count_diff_ub=(n_births-cf_count_lb)/(abs(cf_count_lb))*100
gen rel_count_diff_lb=(n_births-cf_count_ub)/(abs(cf_count_ub))*100
order country  mom_age_cat  n_births cf_count se_cf_count cf_count_lb cf_count_ub countdiff countdiff_lb countdiff_ub rel_count_diff rel_count_diff_lb rel_count_diff_ub prop cf_prop propdiff propdiff_lb propdiff_ub total_births total_cf_count

drop se_cf_count
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

order country mom_age_cat  n_births cf_count  cf_count_ci countdiff countdiff_ci  rel_count_diff rel_diff_ci prop cf_prop propdiff propdiff_ci total_births total_cf_count

save "$dta/Scot_table_profile_$S_DATE", replace
export excel using "$table\Scot_table_profile_$S_DATE.xls", firstrow(variables) replace



**# Bookmark #2


************************ FINLAND *************************
************************ FINLAND *************************
************************ FINLAND *************************

****** MAIN SEC variable, all categories
****** MAIN SEC variable, all categories

clear all
use "$dta/FI_ts", clear

****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=1/6 {
use "$dta/FI_ts.dta", clear
keep if hh_inc==`i'
poisson n_births i.loco c.bdate_w c.bdate_w#c.bdate_w i.bweek , irr


quietly: margins, ///
at(bdate_w=(2860(1)3223) loco=0) ///
at(bdate_w=(3170(1)3223) loco=1) ///
predict(n) ///
saving("$dta/margins_ts_`i'.dta", replace)

preserve 
use "$dta/margins_ts_`i'.dta", clear
rename _at2 bdate_w
rename _at1 loco
rename _margin lin_count
keep lin_count bdate_w loco
drop if loco==0 & bdate_w >=tw(2020w51)
gen hh_inc=`i'
save "$dta/lin_pred_`i'.dta",replace

use "$dta/margins_ts_`i'.dta", clear
rename _at2 bdate_w
rename _at1 loco
rename _margin cf_lin_count
keep cf_lin_count bdate_w loco
keep if loco==0 & bdate_w >=tw(2020w51)
gen hh_inc=`i'
save "$dta/cf_lin_pred_`i'.dta",replace
restore

}

use "$dta/lin_pred_1", clear
forval i=2/6 {
	append using "$dta/lin_pred_`i'"
}
save "$dta/lin_pred_all", replace

use "$dta/cf_lin_pred_1", clear
forval i=2/6 {
	append using "$dta/cf_lin_pred_`i'"
}
save "$dta/cf_lin_pred_all", replace


use "$dta/FI_ts", clear
merge 1:1 bdate_w hh_inc using "$dta/lin_pred_all", nogen
merge 1:1 bdate_w hh_inc using "$dta/cf_lin_pred_all", nogen

forval i=1/6 {
	
poisson n_births i.loco c.bdate_w c.bdate_w#c.bdate_w i.bweek if hh_inc==`i', irr
predict pred_count_`i' if hh_inc==`i'
}
gen pred_count=pred_count_1
forval i=2/6{
	replace pred_count=pred_count_`i' if pred_count==.
}
drop pred_count_1 - pred_count_6
replace n_births=5 if n_births<5 // to comply with Findata (and not just Stats Finland)
*PLOT IT
forvalues i=1/6 {
  local v : label (hh_inc) `i'
   display "`i' is `v'"
   }

local forlab: value label hh_inc
forvalues i = 1/6 {
	local label: label `forlab' `i'
	di "`label'" 

tw ///
(line pred_count bdate_w if hh_inc==`i', lwidth(thin) lcolor(gs10)) ///
(line lin_count bdate_w if loco==0 & hh_inc==`i', lwidth(medium) lcolor(black)) ///
(line cf_lin_count bdate_w if loco==1 & hh_inc==`i', lpattern(shortdash) lwidth(medium) lcolor(black)) ///
(line lin_count bdate_w if loco==1 & hh_inc==`i', lpattern(solid) lwidth(medium) lcolor(black)) ///
(scatter n_births bdate_w if hh_inc==`i', msize(vsmall) mcolor(ebblue%60) msym(o)) ///
, ///
xline(3170, lpattern(solid) lcolor(red) lwidth(vthin)) ///
xt("Week of Birth") ///
xlab(2860(104)3223, angle(h)) ///
ylab(0(50)300, angle(h)) ///
yt("Number of Live Births") ///
legend(order(5 "Observed "1 "Fitted" 2 "Deseasonalised Fitted" 3 "Deseasonalised Expected") row(1)) ///
title("{bf:`label'}", size(medsmall)) ///
plotregion(lcolor(black)) ///
name(C`i', replace) ///
scheme(white_tableau)

}

*combine plots
grc1leg2 C1 C2 C3 C4 C5 C6, ///
legendfrom(C1) ///
position(6) lyoffset(0) lxoffset(0) ///
legscale(*1.) plotregion(margin(zero)) imargin(tiny) ///
xtob1title ytol1title ///
title("Finland, Household Income", size(medsmall)) ///
scheme(white_tableau)

graph export "$graph/Finland_quint_hhinc_$S_DATE.svg", replace

*export underlying data for Findata clearance

export delimited "$dta/FI_inc_figures_ts.csv", replace

**# Bookmark #3

******EDUCATION
******EDUCATION
******EDUCATION
clear all
global ts_data "C:\Users\moritzob\OneDrive - University of Helsinki\postdoc life helsinki\LoCo-effect\LoCo-effect Finland\dta\edu_det_ts_week_12 Dec 2023.dta"
use "$ts_data", clear

****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
tab edu_mom_det
su edu_mom_det, 
global max=r(max)
di $max
forval i=1/$max {
use "$ts_data", clear
rename edu_mom_det hh_inc // to make old code work
keep if hh_inc==`i'
poisson n_births i.loco c.bdate_w c.bdate_w#c.bdate_w i.bweek , irr


quietly: margins, ///
at(bdate_w=(2860(1)3223) loco=0) ///
at(bdate_w=(3170(1)3223) loco=1) ///
predict(n) ///
saving("$dta/margins_ts_`i'.dta", replace)

preserve 
use "$dta/margins_ts_`i'.dta", clear
rename _at2 bdate_w
rename _at1 loco
rename _margin lin_count
keep lin_count bdate_w loco
drop if loco==0 & bdate_w >=tw(2020w51)
gen hh_inc=`i'
save "$dta/lin_pred_`i'.dta",replace

use "$dta/margins_ts_`i'.dta", clear
rename _at2 bdate_w
rename _at1 loco
rename _margin cf_lin_count
keep cf_lin_count bdate_w loco
keep if loco==0 & bdate_w >=tw(2020w51)
gen hh_inc=`i'
save "$dta/cf_lin_pred_`i'.dta",replace
restore

}

use "$dta/lin_pred_1", clear
forval i=2/$max {
	append using "$dta/lin_pred_`i'"
}
save "$dta/lin_pred_all", replace

use "$dta/cf_lin_pred_1", clear
forval i=2/$max {
	append using "$dta/cf_lin_pred_`i'"
}
save "$dta/cf_lin_pred_all", replace


use "$ts_data", clear
rename edu_mom_det hh_inc // to make old code work

merge 1:1 bdate_w hh_inc using "$dta/lin_pred_all", nogen
merge 1:1 bdate_w hh_inc using "$dta/cf_lin_pred_all", nogen

forval i=1/$max {
	
poisson n_births i.loco c.bdate_w c.bdate_w#c.bdate_w i.bweek if hh_inc==`i', irr
predict pred_count_`i' if hh_inc==`i'
}
gen pred_count=pred_count_1
forval i=2/$max{
	replace pred_count=pred_count_`i' if pred_count==.
}
drop pred_count_1 - pred_count_$max
*PLOT IT
forvalues i=1/$max {
  local v : label (hh_inc) `i'
   display "`i' is `v'"
   }

local forlab: value label hh_inc
forvalues i = 1/$max {
	local label: label `forlab' `i'
	di "`label'" 

tw ///
(line pred_count bdate_w if hh_inc==`i', lwidth(thin) lcolor(gs10)) ///
(line lin_count bdate_w if loco==0 & hh_inc==`i', lwidth(medium) lcolor(black)) ///
(line cf_lin_count bdate_w if loco==1 & hh_inc==`i', lpattern(shortdash) lwidth(medium) lcolor(black)) ///
(line lin_count bdate_w if loco==1 & hh_inc==`i', lpattern(solid) lwidth(medium) lcolor(black)) ///
(scatter n_births bdate_w if hh_inc==`i', msize(vsmall) mcolor(ebblue%60) msym(o)) ///
, ///
xline(3170, lpattern(solid) lcolor(red) lwidth(vthin)) ///
xt("Week of Birth") ///
xlab(2860(104)3223, angle(h)) ///
ylab(50(100)550, angle(h)) ///
yt("Number of Live Births") ///
legend(order(5 "Observed "1 "Fitted" 2 "Deseasonalised Fitted" 3 "Deseasonalised Expected") row(1)) ///
title("{bf:`label'}", size(medsmall)) ///
plotregion(lcolor(black)) ///
name(C`i', replace) ///
scheme(white_tableau)

}

*combine plots
grc1leg2 C1 C2 C3 C4 , ///
legendfrom(C1) ///
position(6) lyoffset(0) lxoffset(0) ///
legscale(*1) plotregion(margin(zero)) imargin(tiny) ///
xtob1title ytol1title ///
title("Finland, Maternal Education", size(medsmall)) ///
scheme(white_tableau)

graph export "$graph/Finland_edu_mom$S_DATE.svg", replace

export delimited "$dta/FI_mom_edu_figures_ts.csv", replace

**# Bookmark #46


******AGE
******AGE
******AGE
clear all
global ts_data "C:\Users\moritzob\OneDrive - University of Helsinki\postdoc life helsinki\LoCo-effect\LoCo-effect Finland\dta\age_ts_week_12 Dec 2023.dta"
use "$ts_data",clear
****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
tab mom_age
su mom_age, 
global max=r(max)
di $max
forval i=1/$max {
use "$ts_data",clear
rename mom_age hh_inc // to make old code work
keep if hh_inc==`i'
poisson n_births i.loco c.bdate_w c.bdate_w#c.bdate_w i.bweek , irr


quietly: margins, ///
at(bdate_w=(2860(1)3223) loco=0) ///
at(bdate_w=(3170(1)3223) loco=1) ///
predict(n) ///
saving("$dta/margins_ts_`i'.dta", replace)

preserve 
use "$dta/margins_ts_`i'.dta", clear
rename _at2 bdate_w
rename _at1 loco
rename _margin lin_count
keep lin_count bdate_w loco
drop if loco==0 & bdate_w >=tw(2020w51)
gen hh_inc=`i'
save "$dta/lin_pred_`i'.dta",replace

use "$dta/margins_ts_`i'.dta", clear
rename _at2 bdate_w
rename _at1 loco
rename _margin cf_lin_count
keep cf_lin_count bdate_w loco
keep if loco==0 & bdate_w >=tw(2020w51)
gen hh_inc=`i'
save "$dta/cf_lin_pred_`i'.dta",replace
restore

}

use "$dta/lin_pred_1", clear
forval i=2/$max {
	append using "$dta/lin_pred_`i'"
}
save "$dta/lin_pred_all", replace

use "$dta/cf_lin_pred_1", clear
forval i=2/$max {
	append using "$dta/cf_lin_pred_`i'"
}
save "$dta/cf_lin_pred_all", replace


use "$ts_data", clear
rename mom_age hh_inc // to make old code work

merge 1:1 bdate_w hh_inc using "$dta/lin_pred_all", nogen
merge 1:1 bdate_w hh_inc using "$dta/cf_lin_pred_all", nogen

forval i=1/$max {
	
poisson n_births i.loco c.bdate_w c.bdate_w#c.bdate_w i.bweek if hh_inc==`i', irr
predict pred_count_`i' if hh_inc==`i'
}
gen pred_count=pred_count_1
forval i=2/$max{
	replace pred_count=pred_count_`i' if pred_count==.
}
drop pred_count_1 - pred_count_$max
replace n_births=5 if n_births<5 // to comply with Findata (and not just Stats Finland)

*PLOT IT
tw ///
(line pred_count bdate_w if hh_inc==1, lwidth(thin) lcolor(gs10)) ///
(line lin_count bdate_w if loco==0 & hh_inc==1, lwidth(medium) lcolor(black)) ///
(line cf_lin_count bdate_w if loco==1 & hh_inc==1, lpattern(shortdash) lwidth(medium) lcolor(black)) ///
(line lin_count bdate_w if loco==1 & hh_inc==1, lpattern(solid) lwidth(medium) lcolor(black)) ///
(scatter n_births bdate_w if hh_inc==1, msize(vsmall) mcolor(ebblue%60) msym(o)) ///
, ///
xline(3170, lpattern(solid) lcolor(red) lwidth(vthin)) ///
xt("Week of Birth") ///
xlab(2860(104)3223, angle(h)) ///
ylab(0(10)50, angle(h)) ///
yt("Number of Live Births") ///
legend(order(5 "Observed "1 "Fitted" 2 "Deseasonalised Fitted" 3 "Deseasonalised Expected") col(1)) ///
title("{bf:<20}", size(medsmall)) ///
plotregion(lcolor(black)) ///
name(C1, replace) ///
scheme(white_tableau)


forvalues i=2/$max {
  local v : label (hh_inc) `i'
   display "`i' is `v'"
   }

local forlab: value label hh_inc
forvalues i = 2/$max {
	local label: label `forlab' `i'
	di "`label'" 

tw ///
(line pred_count bdate_w if hh_inc==`i', lwidth(thin) lcolor(gs10)) ///
(line lin_count bdate_w if loco==0 & hh_inc==`i', lwidth(medium) lcolor(black)) ///
(line cf_lin_count bdate_w if loco==1 & hh_inc==`i', lpattern(shortdash) lwidth(medium) lcolor(black)) ///
(line lin_count bdate_w if loco==1 & hh_inc==`i', lpattern(solid) lwidth(medium) lcolor(black)) ///
(scatter n_births bdate_w if hh_inc==`i', msize(vsmall) mcolor(ebblue%60) msym(o)) ///
, ///
xline(3170, lpattern(solid) lcolor(red) lwidth(vthin)) ///
xt("Week of Birth") ///
xlab(2860(104)3223, angle(h)) ///
ylab(0(50)400, angle(h)) ///
yt("Number of Live Births") ///
legend(order(5 "Observed "1 "Fitted" 2 "Deseasonalised Fitted" 3 "Deseasonalised Expected") col(1)) ///
title("{bf:`label'}", size(medsmall)) ///
plotregion(lcolor(black)) ///
name(C`i', replace) ///
scheme(white_tableau)

}

*combine plots
grc1leg2 C1 C2 C3 C4 C5 , ///
legendfrom(C1) ///
position(4) ring(0) lyoffset(10) lxoffset(0) ///
legscale(*1) plotregion(margin(zero)) imargin(tiny) ///
xtob1title ytol1title ///
title("Finland, Maternal Age", size(medsmall)) ///
scheme(white_tableau)

graph export "$graph/Finland_age_mom$S_DATE.svg", replace

export delimited "$dta/FI_mom_age_figures_ts.csv", replace
**# Bookmark #4

******Parity
******Parity
******Parity
clear all
global ts_data "C:\Users\moritzob\OneDrive - University of Helsinki\postdoc life helsinki\LoCo-effect\LoCo-effect Finland\dta\parity_ts_week_12 Dec 2023.dta"
use "$ts_data",clear
****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
tab parity
su parity, 
global max=r(max)
global min=r(min)
global min_1=r(min)+1
di $max
di $min
di $min_1
forval i=$min/$max {
use "$ts_data",clear
rename parity hh_inc // to make old code work
keep if hh_inc==`i'
poisson n_births i.loco c.bdate_w c.bdate_w#c.bdate_w i.bweek , irr


quietly: margins, ///
at(bdate_w=(2860(1)3223) loco=0) ///
at(bdate_w=(3170(1)3223) loco=1) ///
predict(n) ///
saving("$dta/margins_ts_`i'.dta", replace)

preserve 
use "$dta/margins_ts_`i'.dta", clear
rename _at2 bdate_w
rename _at1 loco
rename _margin lin_count
keep lin_count bdate_w loco
drop if loco==0 & bdate_w >=tw(2020w51)
gen hh_inc=`i'
save "$dta/lin_pred_`i'.dta",replace

use "$dta/margins_ts_`i'.dta", clear
rename _at2 bdate_w
rename _at1 loco
rename _margin cf_lin_count
keep cf_lin_count bdate_w loco
keep if loco==0 & bdate_w >=tw(2020w51)
gen hh_inc=`i'
save "$dta/cf_lin_pred_`i'.dta",replace
restore

}

use "$dta/lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/lin_pred_`i'"
}
save "$dta/lin_pred_all", replace

use "$dta/cf_lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/cf_lin_pred_`i'"
}
save "$dta/cf_lin_pred_all", replace


use "$ts_data", clear
rename parity hh_inc // to make old code work

merge 1:1 bdate_w hh_inc using "$dta/lin_pred_all", nogen
merge 1:1 bdate_w hh_inc using "$dta/cf_lin_pred_all", nogen

forval i=$min/$max {
	
poisson n_births i.loco c.bdate_w c.bdate_w#c.bdate_w i.bweek if hh_inc==`i', irr
predict pred_count_`i' if hh_inc==`i'
}
gen pred_count=pred_count_$min
forval i=$min_1/$max{
	replace pred_count=pred_count_`i' if pred_count==.
}
drop pred_count_$min - pred_count_$max
*PLOT IT
forvalues i=$min/$max {
  local v : label (hh_inc) `i'
   display "`i' is `v'"
   }

local forlab: value label hh_inc
forvalues i = $min/$max {
	local label: label `forlab' `i'
	di "`label'" 

tw ///
(line pred_count bdate_w if hh_inc==`i', lwidth(thin) lcolor(gs10)) ///
(line lin_count bdate_w if loco==0 & hh_inc==`i', lwidth(medium) lcolor(black)) ///
(line cf_lin_count bdate_w if loco==1 & hh_inc==`i', lpattern(shortdash) lwidth(medium) lcolor(black)) ///
(line lin_count bdate_w if loco==1 & hh_inc==`i', lpattern(solid) lwidth(medium) lcolor(black)) ///
(scatter n_births bdate_w if hh_inc==`i', msize(vsmall) mcolor(ebblue%60) msym(o)) ///
, ///
xline(3170, lpattern(solid) lcolor(red) lwidth(vthin)) ///
xt("Week of Birth") ///
xlab(2860(104)3223, angle(h)) ///
ylab(, angle(h)) ///
yt("Number of Live Births") ///
legend(order(5 "Observed "1 "Fitted" 2 "Deseasonalised Fitted" 3 "Deseasonalised Expected") col(1)) ///
title("{bf:`label'}", size(medsmall)) ///
plotregion(lcolor(black)) ///
name(C`i', replace) ///
scheme(white_tableau)

}

*combine plots
grc1leg2 C0 C1 C2 C3 C4 , ///
legendfrom(C0) ///
position(4) ring(0) lyoffset(10) lxoffset(0) ///
legscale(*1) plotregion(margin(zero)) imargin(tiny) ///
xtob1title ytol1title ///
title("Finland, Parity", size(medsmall)) ///
scheme(white_tableau)

graph export "$graph/Finland_parity_$S_DATE.svg", replace

export delimited "$dta/FI_parity_figures_ts.csv", replace

**# Bookmark #5

****************************************************
****************************************************
*---------------- Tables ---------------------------
*---------------- Tables ---------------------------


******EDUCATION
clear all
global ts_data "$dta/FI_ts"
use "$ts_data", clear
*
global variable "mom_edu_comp" // determine group
*
preserve // get numbers for table later
collapse (sum) n_births if loco==1, by($variable)
egen total_births=sum(n_births)
gen prop= n_births/total_births
save "$dta/FI_obs_$variable.dta" ,replace
restore 

****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
tab $variable
su $variable, 
global max=r(max)
global min=r(min)
global min_1=r(min)+1
di $max
di $min
di $min_1

****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=$min/$max {
use "$ts_data", clear
keep if $variable==`i'
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
gen $variable=`i'
keep $variable cf_count se_cf_count cf_count_lb cf_count_ub
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
gen $variable=`i'
keep $variable countdiff countdiff_lb countdiff_ub
save "$dta/countdiff_estimate_`i'.dta", replace
restore
}

use "$dta/cf_estimate_$min", clear
forval i=$min_1/$max {
	append using "$dta/cf_estimate_`i'"
}

merge 1:1  $variable using "$dta/FI_obs_$variable.dta", nogen
order $variable n_births cf_count se_cf_count 
egen total_cf_count=sum(cf_count)
gen cf_prop=cf_count/total_cf_count
gen propdiff=prop-cf_prop
save "$dta/FI_cf_estimate.dta", replace

use "$dta/countdiff_estimate_$min", clear
forval i=$min_1/$max {
	append using "$dta/countdiff_estimate_`i'"
}

merge 1:1  $variable using "$dta/FI_cf_estimate.dta", nogen
order $variable n_births cf_count se_cf_count 
save "$dta/FI_cf_estimate.dta", replace

*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
set seed 123456789
forval d=1/10000 {
use "$dta/FI_cf_estimate.dta", clear
keep $variable cf_count se_cf_count prop
gen cf_count_i_d=rnormal(cf_count , se_cf_count) // generate random draw d from mean SE estimated from poisson ITS for each SIMD group i
egen sum_cf_count_i_d=sum(cf_count_i_d) // sum random draws d of all groups i
gen cf_prop_i_d=cf_count_i_d/sum_cf_count_i_d // create counterfactual proportion for each group i based on draw d
gen propdiff_i_d=prop- cf_prop_i_d // get m_i_d which is the difference in proportion between observed and counterfactual from draw d
keep $variable propdiff_i_d
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
_pctile propdiff_i_d if $variable==$min, percentiles(2.5) 
return list
gen propdiff_lb=r(r1) if $variable==$min
_pctile propdiff_i_d if $variable==$min, percentiles(97.5) 
return list
gen propdiff_ub=r(r1) if $variable==$min

forval i=$min_1/$max {
_pctile propdiff_i_d if $variable==`i', percentiles(2.5) 
return list
replace propdiff_lb=r(r1) if $variable==`i'
_pctile propdiff_i_d if $variable==`i', percentiles(97.5) 
return list
replace propdiff_ub=r(r1) if $variable==`i'
}

collapse propdiff_lb propdiff_ub, by($variable)
save "$dta/FI_prop_uncertainty", replace
use "$dta/FI_cf_estimate", clear
merge 1:1 $variable using "$dta/FI_prop_uncertainty", nogen
gen country="Finland"
order country $variable n_births cf_count se_cf_count cf_count_lb cf_count_ub countdiff countdiff_lb countdiff_ub prop cf_prop propdiff propdiff_lb propdiff_ub total_births total_cf_count

save "$dta/FI_comp_diff_$variable", replace

**# Bookmark #10

******AGE 
clear all
global ts_data "C:\Users\moritzob\OneDrive - University of Helsinki\postdoc life helsinki\LoCo-effect\LoCo-effect Finland\dta\age_ts_week_12 Dec 2023.dta"
use "$ts_data", clear
*
global variable "mom_age_cat" // determine group
*
preserve // get numbers for table later
collapse (sum) n_births if loco==1, by($variable)
egen total_births=sum(n_births)
gen prop= n_births/total_births
save "$dta/FI_obs_$variable.dta" ,replace
restore 

****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
tab $variable
su $variable, 
global max=r(max)
global min=r(min)
global min_1=r(min)+1
di $max
di $min
di $min_1

****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=$min/$max {
use "$ts_data", clear
keep if $variable==`i'
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
gen $variable=`i'
keep $variable cf_count se_cf_count cf_count_lb cf_count_ub
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
gen $variable=`i'
keep $variable countdiff countdiff_lb countdiff_ub
save "$dta/countdiff_estimate_`i'.dta", replace
restore
}

use "$dta/cf_estimate_$min", clear
forval i=$min_1/$max {
	append using "$dta/cf_estimate_`i'"
}

merge 1:1  $variable using "$dta/FI_obs_$variable.dta", nogen
order $variable n_births cf_count se_cf_count 
egen total_cf_count=sum(cf_count)
gen cf_prop=cf_count/total_cf_count
gen propdiff=prop-cf_prop
save "$dta/FI_cf_estimate.dta", replace

use "$dta/countdiff_estimate_$min", clear
forval i=$min_1/$max {
	append using "$dta/countdiff_estimate_`i'"
}

merge 1:1  $variable using "$dta/FI_cf_estimate.dta", nogen
order $variable n_births cf_count se_cf_count 
save "$dta/FI_cf_estimate.dta", replace

*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
set seed 123456789
forval d=1/10000 {
use "$dta/FI_cf_estimate.dta", clear
keep $variable cf_count se_cf_count prop
gen cf_count_i_d=rnormal(cf_count , se_cf_count) // generate random draw d from mean SE estimated from poisson ITS for each SIMD group i
egen sum_cf_count_i_d=sum(cf_count_i_d) // sum random draws d of all groups i
gen cf_prop_i_d=cf_count_i_d/sum_cf_count_i_d // create counterfactual proportion for each group i based on draw d
gen propdiff_i_d=prop- cf_prop_i_d // get m_i_d which is the difference in proportion between observed and counterfactual from draw d
keep $variable propdiff_i_d
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
_pctile propdiff_i_d if $variable==$min, percentiles(2.5) 
return list
gen propdiff_lb=r(r1) if $variable==$min
_pctile propdiff_i_d if $variable==$min, percentiles(97.5) 
return list
gen propdiff_ub=r(r1) if $variable==$min

forval i=$min_1/$max {
_pctile propdiff_i_d if $variable==`i', percentiles(2.5) 
return list
replace propdiff_lb=r(r1) if $variable==`i'
_pctile propdiff_i_d if $variable==`i', percentiles(97.5) 
return list
replace propdiff_ub=r(r1) if $variable==`i'
}

collapse propdiff_lb propdiff_ub, by($variable)
save "$dta/FI_prop_uncertainty", replace
use "$dta/FI_cf_estimate", clear
merge 1:1 $variable using "$dta/FI_prop_uncertainty", nogen
gen country="Finland"
order country $variable n_births cf_count se_cf_count cf_count_lb cf_count_ub countdiff countdiff_lb countdiff_ub prop cf_prop propdiff propdiff_lb propdiff_ub total_births total_cf_count
save "$dta/FI_comp_diff_$variable", replace

**# Bookmark #11
******PARITY 
clear all
global ts_data "C:\Users\moritzob\OneDrive - University of Helsinki\postdoc life helsinki\LoCo-effect\LoCo-effect Finland\dta\parity_ts_week_12 Dec 2023.dta"
use "$ts_data", clear
*
global variable "parity" // determine group
*
preserve // get numbers for table later
collapse (sum) n_births if loco==1, by($variable)
egen total_births=sum(n_births)
gen prop= n_births/total_births
save "$dta/FI_obs_$variable.dta" ,replace
restore 

****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
tab $variable
su $variable, 
global max=r(max)
global min=r(min)
global min_1=r(min)+1
di $max
di $min
di $min_1

****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=$min/$max {
use "$ts_data", clear
keep if $variable==`i'
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
gen $variable=`i'
keep $variable cf_count se_cf_count cf_count_lb cf_count_ub
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
gen $variable=`i'
keep $variable countdiff countdiff_lb countdiff_ub
save "$dta/countdiff_estimate_`i'.dta", replace
restore
}

use "$dta/cf_estimate_$min", clear
forval i=$min_1/$max {
	append using "$dta/cf_estimate_`i'"
}

merge 1:1  $variable using "$dta/FI_obs_$variable.dta", nogen
order $variable n_births cf_count se_cf_count 
egen total_cf_count=sum(cf_count)
gen cf_prop=cf_count/total_cf_count
gen propdiff=prop-cf_prop
save "$dta/FI_cf_estimate.dta", replace

use "$dta/countdiff_estimate_$min", clear
forval i=$min_1/$max {
	append using "$dta/countdiff_estimate_`i'"
}

merge 1:1  $variable using "$dta/FI_cf_estimate.dta", nogen
order $variable n_births cf_count se_cf_count 
save "$dta/FI_cf_estimate.dta", replace

*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
set seed 123456789
forval d=1/10000 {
use "$dta/FI_cf_estimate.dta", clear
keep $variable cf_count se_cf_count prop
gen cf_count_i_d=rnormal(cf_count , se_cf_count) // generate random draw d from mean SE estimated from poisson ITS for each SIMD group i
egen sum_cf_count_i_d=sum(cf_count_i_d) // sum random draws d of all groups i
gen cf_prop_i_d=cf_count_i_d/sum_cf_count_i_d // create counterfactual proportion for each group i based on draw d
gen propdiff_i_d=prop- cf_prop_i_d // get m_i_d which is the difference in proportion between observed and counterfactual from draw d
keep $variable propdiff_i_d
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
_pctile propdiff_i_d if $variable==$min, percentiles(2.5) 
return list
gen propdiff_lb=r(r1) if $variable==$min
_pctile propdiff_i_d if $variable==$min, percentiles(97.5) 
return list
gen propdiff_ub=r(r1) if $variable==$min

forval i=$min_1/$max {
_pctile propdiff_i_d if $variable==`i', percentiles(2.5) 
return list
replace propdiff_lb=r(r1) if $variable==`i'
_pctile propdiff_i_d if $variable==`i', percentiles(97.5) 
return list
replace propdiff_ub=r(r1) if $variable==`i'
}

collapse propdiff_lb propdiff_ub, by($variable)
save "$dta/FI_prop_uncertainty", replace
use "$dta/FI_cf_estimate", clear
merge 1:1 $variable using "$dta/FI_prop_uncertainty", nogen
gen country="Finland"
order country $variable n_births cf_count se_cf_count cf_count_lb cf_count_ub countdiff countdiff_lb countdiff_ub prop cf_prop propdiff propdiff_lb propdiff_ub total_births total_cf_count
save "$dta/FI_comp_diff_$variable", replace


**# Bookmark #13

************** FINLAND TABLE ***********
use "$dta/FI_comp_diff_edu_mom_det", clear
append using "$dta/FI_comp_diff_mom_age_cat"
append using "$dta/FI_comp_diff_parity"
gen rel_count_diff=(n_births-cf_count)/(abs(cf_count))*100
gen rel_count_diff_ub=(n_births-cf_count_lb)/(abs(cf_count_lb))*100
gen rel_count_diff_lb=(n_births-cf_count_ub)/(abs(cf_count_ub))*100
order country edu_mom_det mom_age_cat parity  n_births cf_count se_cf_count cf_count_lb cf_count_ub countdiff countdiff_lb countdiff_ub rel_count_diff rel_count_diff_lb rel_count_diff_ub prop cf_prop propdiff propdiff_lb propdiff_ub total_births total_cf_count


drop se_cf_count
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

order country edu_mom_det mom_age_cat parity n_births cf_count  cf_count_ci countdiff countdiff_ci  rel_count_diff rel_diff_ci prop cf_prop propdiff propdiff_ci total_births total_cf_count


save "$dta/FI_table_profile_$S_DATE", replace
export excel using "$table\FI_table_profile_$S_DATE.xls", firstrow(variables) replace


**# Bookmark #1

******************* SWEDEN SWEDEN SWEDEN **********************
******************* SWEDEN SWEDEN SWEDEN **********************
******************* SWEDEN SWEDEN SWEDEN **********************
******************* SWEDEN SWEDEN SWEDEN **********************

**** MAIN SEC VARIABLE
**** MAIN SEC VARIABLE

clear all
global ts_data "$dta/SWE_ts"
global variable "hh_inc" // determine group
use "$ts_data"

su $variable
global max=r(max)
global min=r(min)
global min_1=r(min)+1
di $max
di $min
di $min_1

global trend "bdate_w" // insert variable names
global season "bweek"
global tw_tm "tw"
global cutoff "2020w51"


****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=$min/$max {
use "$ts_data.dta", clear
keep if $variable==`i'
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season , irr

quietly: margins, ///
at($trend=(2860(1)3223) loco=(0)) ///
at($trend=(2860(1)3223) loco=(1)) ///
predict(n) ///
saving("$dta/margins_ts_`i'.dta", replace)

preserve 
use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin lin_count
keep lin_count $trend loco
drop if loco==0 & $trend >=$tw_tm($cutoff)
drop if loco==1 & $trend <$tw_tm($cutoff)
gen $variable=`i'
save "$dta/lin_pred_`i'.dta",replace 

use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin cf_lin_count
keep cf_lin_count $trend loco
keep if loco==0 &  $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/cf_lin_pred_`i'.dta",replace
restore

}

use "$dta/lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/lin_pred_`i'"
}
save "$dta/lin_pred_all", replace

use "$dta/cf_lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/cf_lin_pred_`i'"
}
save "$dta/cf_lin_pred_all", replace


use "$ts_data", clear
merge 1:1 $trend $variable using "$dta/lin_pred_all", nogen
merge 1:1 $trend $variable using "$dta/cf_lin_pred_all", nogen

forval i=$min/$max {
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season if $variable==`i', irr
predict pred_count_`i' if $variable==`i'
}
gen pred_count=pred_count_$min
forval i=$min_1/$max{
	replace pred_count=pred_count_`i' if pred_count==.
}
drop pred_count_$min - pred_count_$max
*PLOT IT
forvalues i=$min/$max {
  local v : label ($variable) `i'
   display "`i' is `v'"
   }

local forlab: value label $variable
forvalues i = $min/$max {
	local label: label `forlab' `i'
	di "`label'" 

tw ///
(line pred_count $trend if $variable==`i', lwidth(thin) lcolor(gs10)) ///
(line lin_count $trend if loco==0 & $variable==`i', lwidth(medium) lcolor(black)) ///
(line cf_lin_count $trend if loco==1 & $variable==`i', lpattern(shortdash) lwidth(medium) lcolor(black)) ///
(line lin_count $trend if loco==1 & $variable==`i', lpattern(solid) lwidth(medium) lcolor(black)) ///
(scatter n_births $trend if $variable==`i', msize(vsmall) mcolor(ebblue%60) msym(o)) ///
, ///
xline(3170, lpattern(solid) lcolor(red) lwidth(vthin)) ///
xt("Week of Birth") ///
xlab(2860(104)3223, angle(h)) ///
ylab(, angle(h)) ///
yt("Number of Live Births") ///
legend(order(5 "Observed" 1 "Fitted" 2 "Deseasonalised Fitted" 3 "Deseasonalised Expected") row(1)) ///
title("{bf:`label'}", size(medsmall)) ///
plotregion(lcolor(black)) ///
name(C`i', replace) ///
scheme(white_tableau)

}

*combine plots
grc1leg2 C1 C2 C3 C4 C5 C6, ///
legendfrom(C1) ycommon ///
position(6) lyoffset(0) lxoffset(0) ///
legscale(*1) plotregion(margin(zero)) imargin(tiny) ///
xtob1title ytol1title ///
title("Sweden, Household Income", size(medsmall)) ///
scheme(white_tableau)

graph export "$graph/SWE_hh_inc_$S_DATE.svg", replace


**# Bookmark #1

************ Family income (not equivalised) ******************'
************ Family income (not equivalised) ******************'
************ Family income (not equivalised) ******************'
************ Family income (not equivalised) ******************'

clear all
global ts_data "$dta/SWE_ts_fam_inc"
global variable "fam_inc" // determine group
use "$ts_data"

su $variable
global max=r(max)
global min=r(min)
global min_1=r(min)+1
di $max
di $min
di $min_1

global trend "bdate_w" // insert variable names
global season "bweek"
global tw_tm "tw"
global cutoff "2020w51"


****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=$min/$max {
use "$ts_data.dta", clear
keep if $variable==`i'
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season , irr

quietly: margins, ///
at($trend=(2860(1)3223) loco=(0)) ///
at($trend=(2860(1)3223) loco=(1)) ///
predict(n) ///
saving("$dta/margins_ts_`i'.dta", replace)

preserve 
use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin lin_count
keep lin_count $trend loco
drop if loco==0 & $trend >=$tw_tm($cutoff)
drop if loco==1 & $trend <$tw_tm($cutoff)
gen $variable=`i'
save "$dta/lin_pred_`i'.dta",replace 

use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin cf_lin_count
keep cf_lin_count $trend loco
keep if loco==0 &  $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/cf_lin_pred_`i'.dta",replace
restore

}

use "$dta/lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/lin_pred_`i'"
}
save "$dta/lin_pred_all", replace

use "$dta/cf_lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/cf_lin_pred_`i'"
}
save "$dta/cf_lin_pred_all", replace


use "$ts_data", clear
merge 1:1 $trend $variable using "$dta/lin_pred_all", nogen
merge 1:1 $trend $variable using "$dta/cf_lin_pred_all", nogen

forval i=$min/$max {
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season if $variable==`i', irr
predict pred_count_`i' if $variable==`i'
}
gen pred_count=pred_count_$min
forval i=$min_1/$max{
	replace pred_count=pred_count_`i' if pred_count==.
}
drop pred_count_$min - pred_count_$max
*PLOT IT
forvalues i=$min/$max {
  local v : label ($variable) `i'
   display "`i' is `v'"
   }

local forlab: value label $variable
forvalues i = $min/$max {
	local label: label `forlab' `i'
	di "`label'" 

tw ///
(line pred_count $trend if $variable==`i', lwidth(thin) lcolor(gs10)) ///
(line lin_count $trend if loco==0 & $variable==`i', lwidth(medium) lcolor(black)) ///
(line cf_lin_count $trend if loco==1 & $variable==`i', lpattern(shortdash) lwidth(medium) lcolor(black)) ///
(line lin_count $trend if loco==1 & $variable==`i', lpattern(solid) lwidth(medium) lcolor(black)) ///
(scatter n_births $trend if $variable==`i', msize(vsmall) mcolor(ebblue%60) msym(o)) ///
, ///
xline(3170, lpattern(solid) lcolor(red) lwidth(vthin)) ///
xt("Week of Birth") ///
xlab(2860(104)3223, angle(h)) ///
ylab(, angle(h)) ///
yt("Number of Live Births") ///
legend(order(5 "Observed" 1 "Fitted" 2 "Deseasonalised Fitted" 3 "Deseasonalised Expected") row(1)) ///
title("{bf:`label'}", size(medsmall)) ///
plotregion(lcolor(black)) ///
name(C`i', replace) ///
scheme(white_tableau)

}

*combine plots
grc1leg2 C1 C2 C3 C4 C5 C6, ///
legendfrom(C1) ycommon ///
position(6) lyoffset(0) lxoffset(0) ///
legscale(*1) plotregion(margin(zero)) imargin(tiny) ///
xtob1title ytol1title ///
title("Sweden, Family Income (not equivalised)", size(medsmall)) ///
scheme(white_tableau)

graph export "$graph/SWE_fam_inc_$S_DATE.svg", replace



**# Bookmark #34
************ EDUCATION EDUCATION ******************'
************ EDUCATION EDUCATION ******************'
************ EDUCATION EDUCATION ******************'
************ EDUCATION EDUCATION ******************'

clear all
global variable "mom_edu_comp" // determine group


use "C:\Users\moritzob\OneDrive - University of Helsinki\postdoc life helsinki\LoCo-effect\LoCo-effect Sweden\dta\SWE_ts_$variable.dta",clear
save "$dta/SWE_ts_$variable",replace
global ts_data "$dta/SWE_ts_$variable"
use "$ts_data",clear

su $variable
global max=r(max)
global min=r(min)
global min_1=r(min)+1
di $max
di $min
di $min_1

global trend "bdate_w" // insert variable names
global season "bweek"
global tw_tm "tw"
global cutoff "2020w51"


****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=$min/$max {
use "$ts_data.dta", clear
keep if $variable==`i'
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season , irr

quietly: margins, ///
at($trend=(2860(1)3223) loco=(0)) ///
at($trend=(2860(1)3223) loco=(1)) ///
predict(n) ///
saving("$dta/margins_ts_`i'.dta", replace)

preserve 
use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin lin_count
keep lin_count $trend loco
drop if loco==0 & $trend >=$tw_tm($cutoff)
drop if loco==1 & $trend <$tw_tm($cutoff)
gen $variable=`i'
save "$dta/lin_pred_`i'.dta",replace

use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin cf_lin_count
keep cf_lin_count $trend loco
keep if loco==0 &  $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/cf_lin_pred_`i'.dta",replace
restore

}

use "$dta/lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/lin_pred_`i'"
}
save "$dta/lin_pred_all", replace

use "$dta/cf_lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/cf_lin_pred_`i'"
}
save "$dta/cf_lin_pred_all", replace


use "$ts_data", clear
merge 1:1 $trend $variable using "$dta/lin_pred_all", nogen
merge 1:1 $trend $variable using "$dta/cf_lin_pred_all", nogen

forval i=$min/$max {
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season if $variable==`i', irr
predict pred_count_`i' if $variable==`i'
}
gen pred_count=pred_count_$min
forval i=$min_1/$max{
	replace pred_count=pred_count_`i' if pred_count==.
}
drop pred_count_$min - pred_count_$max
*PLOT IT
forvalues i=$min/$max {
  local v : label ($variable) `i'
   display "`i' is `v'"
   }

local forlab: value label $variable
forvalues i = $min/$max {
	local label: label `forlab' `i'
	di "`label'" 

tw ///
(line pred_count $trend if $variable==`i', lwidth(thin) lcolor(gs10)) ///
(line lin_count $trend if loco==0 & $variable==`i', lwidth(medium) lcolor(black)) ///
(line cf_lin_count $trend if loco==1 & $variable==`i', lpattern(shortdash) lwidth(medium) lcolor(black)) ///
(line lin_count $trend if loco==1 & $variable==`i', lpattern(solid) lwidth(medium) lcolor(black)) ///
(scatter n_births $trend if $variable==`i', msize(vsmall) mcolor(ebblue%60) msym(o)) ///
, ///
xline(3170, lpattern(solid) lcolor(red) lwidth(vthin)) ///
xt("Week of Birth") ///
xlab(2860(104)3223, angle(h)) ///
ylab(, angle(h)) ///
yt("Number of Live Births") ///
legend(order(5 "Observed" 1 "Fitted" 2 "Deseasonalised Fitted" 3 "Deseasonalised Expected") col(1)) ///
title("{bf:`label'}", size(medsmall)) ///
plotregion(lcolor(black)) ///
name(C`i', replace) ///
scheme(white_tableau)

}

*combine plots
grc1leg2 C1 C2 C3 C4 C5, ///
legendfrom(C1) ycommon ///
position(4) ring(0) lyoffset(10) lxoffset(-5) ///
legscale(*1) plotregion(margin(zero)) imargin(tiny) ///
xtob1title ytol1title ///
title("Sweden, Maternal Education", size(medsmall)) ///
scheme(white_tableau)

graph export "$graph/SWE_mom_edu_$S_DATE.svg", replace


**# Bookmark #33

****** MOM AGE *****
****** MOM AGE *****
****** MOM AGE *****
****** MOM AGE *****
clear all
global variable "mom_age_cat" // determine group


use "C:\Users\moritzob\OneDrive - University of Helsinki\postdoc life helsinki\LoCo-effect\LoCo-effect Sweden\dta\SWE_ts_$variable.dta",clear
save "$dta/SWE_ts_$variable",replace
global ts_data "$dta/SWE_ts_$variable"
use "$ts_data",clear

su $variable
global max=r(max)
global min=r(min)
global min_1=r(min)+1
di $max
di $min
di $min_1

global trend "bdate_w" // insert variable names
global season "bweek"
global tw_tm "tw"
global cutoff "2020w51"


****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=$min/$max {
use "$ts_data.dta", clear
keep if $variable==`i'
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season , irr

quietly: margins, ///
at($trend=(2860(1)3223) loco=(0)) ///
at($trend=(2860(1)3223) loco=(1)) ///
predict(n) ///
saving("$dta/margins_ts_`i'.dta", replace)

preserve 
use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin lin_count
keep lin_count $trend loco
drop if loco==0 & $trend >=$tw_tm($cutoff)
drop if loco==1 & $trend <$tw_tm($cutoff)
gen $variable=`i'
save "$dta/lin_pred_`i'.dta",replace

use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin cf_lin_count
keep cf_lin_count $trend loco
keep if loco==0 &  $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/cf_lin_pred_`i'.dta",replace
restore

}

use "$dta/lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/lin_pred_`i'"
}
save "$dta/lin_pred_all", replace

use "$dta/cf_lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/cf_lin_pred_`i'"
}
save "$dta/cf_lin_pred_all", replace


use "$ts_data", clear
merge 1:1 $trend $variable using "$dta/lin_pred_all", nogen
merge 1:1 $trend $variable using "$dta/cf_lin_pred_all", nogen

forval i=$min/$max {
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season if $variable==`i', irr
predict pred_count_`i' if $variable==`i'
}
gen pred_count=pred_count_$min
forval i=$min_1/$max{
	replace pred_count=pred_count_`i' if pred_count==.
}
drop pred_count_$min - pred_count_$max
*PLOT IT
forvalues i=$min/$max {
  local v : label ($variable) `i'
   display "`i' is `v'"
   }

local forlab: value label $variable
forvalues i = $min/$max {
	local label: label `forlab' `i'
	di "`label'" 

tw ///
(line pred_count $trend if $variable==`i', lwidth(thin) lcolor(gs10)) ///
(line lin_count $trend if loco==0 & $variable==`i', lwidth(medium) lcolor(black)) ///
(line cf_lin_count $trend if loco==1 & $variable==`i', lpattern(shortdash) lwidth(medium) lcolor(black)) ///
(line lin_count $trend if loco==1 & $variable==`i', lpattern(solid) lwidth(medium) lcolor(black)) ///
(scatter n_births $trend if $variable==`i', msize(vsmall) mcolor(ebblue%60) msym(o)) ///
, ///
xline(3170, lpattern(solid) lcolor(red) lwidth(vthin)) ///
xt("Week of Birth") ///
xlab(2860(104)3223, angle(h)) ///
ylab(, angle(h)) ///
yt("Number of Live Births") ///
legend(order(5 "Observed" 1 "Fitted" 2 "Deseasonalised Fitted" 3 "Deseasonalised Expected") col(1)) ///
title("{bf:`label'}", size(medsmall)) ///
plotregion(lcolor(black)) ///
name(C`i', replace) ///
scheme(white_tableau)

}

*combine plots
grc1leg2 C1 C2 C3 C4 C5, ///
legendfrom(C1) ycommon ///
position(4) ring(0) lyoffset(10) lxoffset(-5) ///
legscale(*1) plotregion(margin(zero)) imargin(tiny) ///
xtob1title ytol1title ///
title("Sweden, Maternal Age", size(medsmall)) ///
scheme(white_tableau)

graph export "$graph/SWE_mom_age_$S_DATE.svg", replace



**# Bookmark #35

****************************************************
****************************************************
*---------------- Tables ---------------------------
*---------------- Tables ---------------------------

********** EDUCATION,  MATERNAL AGE  **********
********** EDUCATION,  MATERNAL AGE  **********
********** EDUCATION,  MATERNAL AGE  **********

foreach var in  fam_inc mom_edu_comp mom_age_cat  {
clear all
global variable "`var'" // determine group

global ts_data "$dta/SWE_ts_$variable"
use "$ts_data",clear

su $variable
global max=r(max)
global min=r(min)
global min_1=r(min)+1
di $max
di $min
di $min_1

global trend "bdate_w" // insert variable names
global season "bweek"
global tw_tm "tw"
global cutoff "2020w51"

*
preserve // get numbers for table later
collapse (sum) n_births if loco==1, by($variable)
egen total_births=sum(n_births)
gen prop= n_births/total_births
save "$dta/SWE_obs_$variable.dta" ,replace
restore 

****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=$min/$max {
use "$ts_data", clear
keep if $variable==`i'
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season , irr
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
gen $variable=`i'
keep $variable cf_count se_cf_count cf_count_lb cf_count_ub
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
gen $variable=`i'
keep $variable countdiff countdiff_lb countdiff_ub
save "$dta/countdiff_estimate_`i'.dta", replace
restore
}

use "$dta/cf_estimate_$min", clear
forval i=$min_1/$max {
	append using "$dta/cf_estimate_`i'"
}

merge 1:1  $variable using "$dta/SWE_obs_$variable.dta", nogen
order $variable n_births cf_count se_cf_count 
egen total_cf_count=sum(cf_count)
gen cf_prop=cf_count/total_cf_count
gen propdiff=prop-cf_prop
save "$dta/SWE_cf_estimate.dta", replace

use "$dta/countdiff_estimate_$min", clear
forval i=$min_1/$max {
	append using "$dta/countdiff_estimate_`i'"
}

merge 1:1  $variable using "$dta/SWE_cf_estimate.dta", nogen
order $variable n_births cf_count se_cf_count 
save "$dta/SWE_cf_estimate.dta", replace

*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
set seed 123456789
forval d=1/10000 {
use "$dta/SWE_cf_estimate.dta", clear
keep $variable cf_count se_cf_count prop
gen cf_count_i_d=rnormal(cf_count , se_cf_count) // generate random draw d from mean SE estimated from poisson ITS for each SIMD group i
egen sum_cf_count_i_d=sum(cf_count_i_d) // sum random draws d of all groups i
gen cf_prop_i_d=cf_count_i_d/sum_cf_count_i_d // create counterfactual proportion for each group i based on draw d
gen propdiff_i_d=prop- cf_prop_i_d // get m_i_d which is the difference in proportion between observed and counterfactual from draw d
keep $variable propdiff_i_d
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
_pctile propdiff_i_d if $variable==$min, percentiles(2.5) 
return list
gen propdiff_lb=r(r1) if $variable==$min
_pctile propdiff_i_d if $variable==$min, percentiles(97.5) 
return list
gen propdiff_ub=r(r1) if $variable==$min

forval i=$min_1/$max {
_pctile propdiff_i_d if $variable==`i', percentiles(2.5) 
return list
replace propdiff_lb=r(r1) if $variable==`i'
_pctile propdiff_i_d if $variable==`i', percentiles(97.5) 
return list
replace propdiff_ub=r(r1) if $variable==`i'
}

collapse propdiff_lb propdiff_ub, by($variable)
save "$dta/SWE_prop_uncertainty", replace
use "$dta/SWE_cf_estimate", clear
merge 1:1 $variable using "$dta/SWE_prop_uncertainty", nogen
gen country="Sweden"
order country $variable n_births cf_count se_cf_count cf_count_lb cf_count_ub countdiff countdiff_lb countdiff_ub prop cf_prop propdiff propdiff_lb propdiff_ub total_births total_cf_count
save "$dta/SWE_comp_diff_$variable", replace

}


**# Bookmark #37

****************** SWEDEN TABLE **********
****************** SWEDEN TABLE **********
****************** SWEDEN TABLE **********
use "$dta/SWE_comp_diff_mom_age_cat", clear
append using "$dta/SWE_comp_diff_mom_edu_comp"
append using "$dta/SWE_comp_diff_fam_inc"
gen rel_count_diff=(n_births-cf_count)/(abs(cf_count))*100
gen rel_count_diff_ub=(n_births-cf_count_lb)/(abs(cf_count_lb))*100
gen rel_count_diff_lb=(n_births-cf_count_ub)/(abs(cf_count_ub))*100
order country  mom_age_cat mom_edu_comp n_births cf_count se_cf_count cf_count_lb cf_count_ub countdiff countdiff_lb countdiff_ub rel_count_diff rel_count_diff_lb rel_count_diff_ub prop cf_prop propdiff propdiff_lb propdiff_ub total_births total_cf_count

drop se_cf_count
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

order country mom_age_cat mom_edu_comp n_births cf_count  cf_count_ci countdiff countdiff_ci  rel_count_diff rel_diff_ci prop cf_prop propdiff propdiff_ci total_births total_cf_count


save "$dta/SWE_table_profile_$S_DATE", replace
export excel using "$table\SWE_table_profile_$S_DATE.xls", firstrow(variables) replace


**# Bookmark #1

******************* DENMARK DENMARK DENMARK **********************
******************* DENMARK DENMARK DENMARK **********************
******************* DENMARK DENMARK DENMARK **********************
******************* DENMARK DENMARK DENMARK **********************

**** MAIN SEC VARIABLE
**** MAIN SEC VARIABLE

clear all
global ts_data "$dta/DEN_ts"
global variable "hh_inc" // determine group
use "$ts_data"

su $variable
global max=r(max)
global min=r(min)
global min_1=r(min)+1
di $max
di $min
di $min_1

global trend "bdate_w" // insert variable names
global season "bweek"
global tw_tm "tw"
global cutoff "2020w51"


****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=$min/$max {
use "$ts_data.dta", clear
keep if $variable==`i'
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season , irr

quietly: margins, ///
at($trend=(2860(1)3223) loco=(0)) ///
at($trend=(2860(1)3223) loco=(1)) ///
predict(n) ///
saving("$dta/margins_ts_`i'.dta", replace)

preserve 
use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin lin_count
keep lin_count $trend loco
drop if loco==0 & $trend >=$tw_tm($cutoff)
drop if loco==1 & $trend <$tw_tm($cutoff)
gen $variable=`i'
save "$dta/lin_pred_`i'.dta",replace 

use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin cf_lin_count
keep cf_lin_count $trend loco
keep if loco==0 &  $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/cf_lin_pred_`i'.dta",replace
restore

}

use "$dta/lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/lin_pred_`i'"
}
save "$dta/lin_pred_all", replace

use "$dta/cf_lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/cf_lin_pred_`i'"
}
save "$dta/cf_lin_pred_all", replace


use "$ts_data", clear
merge 1:1 $trend $variable using "$dta/lin_pred_all", nogen
merge 1:1 $trend $variable using "$dta/cf_lin_pred_all", nogen

forval i=$min/$max {
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season if $variable==`i', irr
predict pred_count_`i' if $variable==`i'
}
gen pred_count=pred_count_$min
forval i=$min_1/$max{
	replace pred_count=pred_count_`i' if pred_count==.
}
drop pred_count_$min - pred_count_$max
*PLOT IT
forvalues i=$min/$max {
  local v : label ($variable) `i'
   display "`i' is `v'"
   }

local forlab: value label $variable
forvalues i = $min/$max {
	local label: label `forlab' `i'
	di "`label'" 

tw ///
(line pred_count $trend if $variable==`i', lwidth(thin) lcolor(gs10)) ///
(line lin_count $trend if loco==0 & $variable==`i', lwidth(medium) lcolor(black)) ///
(line cf_lin_count $trend if loco==1 & $variable==`i', lpattern(shortdash) lwidth(medium) lcolor(black)) ///
(line lin_count $trend if loco==1 & $variable==`i', lpattern(solid) lwidth(medium) lcolor(black)) ///
(scatter n_births $trend if $variable==`i', msize(vsmall) mcolor(ebblue%60) msym(o)) ///
, ///
xline(3170, lpattern(solid) lcolor(red) lwidth(vthin)) ///
xt("Week of Birth") ///
xlab(2860(104)3223, angle(h)) ///
ylab(, angle(h)) ///
yt("Number of Live Births") ///
legend(order(5 "Observed" 1 "Fitted" 2 "Deseasonalised Fitted" 3 "Deseasonalised Expected") row(1)) ///
title("{bf:`label'}", size(medsmall)) ///
plotregion(lcolor(black)) ///
name(C`i', replace) ///
scheme(white_tableau)

}

*combine plots
grc1leg2 C1 C2 C3 C4 C5 C6, ///
legendfrom(C1) ycommon ///
position(6) lyoffset(0) lxoffset(0) ///
legscale(*1) plotregion(margin(zero)) imargin(tiny) ///
xtob1title ytol1title ///
title("Denmark, Household Income", size(medsmall)) ///
scheme(white_tableau)

graph export "$graph/DEN_hh_inc_$S_DATE.svg", replace


**# Bookmark #2

**** NON-EQUIVALISED INCOME
**** NON-EQUIVALISED INCOME

clear all
global ts_data "$dta/DEN_ts_noneq_hh_inc"
global variable "noneq_hh_inc" // determine group
use "$ts_data"

su $variable
global max=r(max)
global min=r(min)
global min_1=r(min)+1
di $max
di $min
di $min_1

global trend "bdate_w" // insert variable names
global season "bweek"
global tw_tm "tw"
global cutoff "2020w51"


****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=$min/$max {
use "$ts_data.dta", clear
keep if $variable==`i'
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season , irr

quietly: margins, ///
at($trend=(2860(1)3223) loco=(0)) ///
at($trend=(2860(1)3223) loco=(1)) ///
predict(n) ///
saving("$dta/margins_ts_`i'.dta", replace)

preserve 
use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin lin_count
keep lin_count $trend loco
drop if loco==0 & $trend >=$tw_tm($cutoff)
drop if loco==1 & $trend <$tw_tm($cutoff)
gen $variable=`i'
save "$dta/lin_pred_`i'.dta",replace 

use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin cf_lin_count
keep cf_lin_count $trend loco
keep if loco==0 &  $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/cf_lin_pred_`i'.dta",replace
restore

}

use "$dta/lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/lin_pred_`i'"
}
save "$dta/lin_pred_all", replace

use "$dta/cf_lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/cf_lin_pred_`i'"
}
save "$dta/cf_lin_pred_all", replace


use "$ts_data", clear
merge 1:1 $trend $variable using "$dta/lin_pred_all", nogen
merge 1:1 $trend $variable using "$dta/cf_lin_pred_all", nogen

forval i=$min/$max {
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season if $variable==`i', irr
predict pred_count_`i' if $variable==`i'
}
gen pred_count=pred_count_$min
forval i=$min_1/$max{
	replace pred_count=pred_count_`i' if pred_count==.
}
drop pred_count_$min - pred_count_$max
*PLOT IT
forvalues i=$min/$max {
  local v : label ($variable) `i'
   display "`i' is `v'"
   }

local forlab: value label $variable
forvalues i = $min/$max {
	local label: label `forlab' `i'
	di "`label'" 

tw ///
(line pred_count $trend if $variable==`i', lwidth(thin) lcolor(gs10)) ///
(line lin_count $trend if loco==0 & $variable==`i', lwidth(medium) lcolor(black)) ///
(line cf_lin_count $trend if loco==1 & $variable==`i', lpattern(shortdash) lwidth(medium) lcolor(black)) ///
(line lin_count $trend if loco==1 & $variable==`i', lpattern(solid) lwidth(medium) lcolor(black)) ///
(scatter n_births $trend if $variable==`i', msize(vsmall) mcolor(ebblue%60) msym(o)) ///
, ///
xline(3170, lpattern(solid) lcolor(red) lwidth(vthin)) ///
xt("Week of Birth") ///
xlab(2860(104)3223, angle(h)) ///
ylab(, angle(h)) ///
yt("Number of Live Births") ///
legend(order(5 "Observed" 1 "Fitted" 2 "Deseasonalised Fitted" 3 "Deseasonalised Expected") row(1)) ///
title("{bf:`label'}", size(medsmall)) ///
plotregion(lcolor(black)) ///
name(C`i', replace) ///
scheme(white_tableau)

}

*combine plots
grc1leg2 C1 C2 C3 C4 C5 C6, ///
legendfrom(C1) ycommon ///
position(6) lyoffset(0) lxoffset(0) ///
legscale(*1) plotregion(margin(zero)) imargin(tiny) ///
xtob1title ytol1title ///
title("Denmark, Household Income (not equivalised)", size(medsmall)) ///
scheme(white_tableau)

graph export "$graph/DEN_noneq_hh_inc_$S_DATE.svg", replace





**# Bookmark #34
************ EDUCATION EDUCATION ******************'
************ EDUCATION EDUCATION ******************'
************ EDUCATION EDUCATION ******************'
************ EDUCATION EDUCATION ******************'

clear all
global variable "mom_edu_comp" // determine group

use "$dta/DEN_ts_$variable",clear
global ts_data "$dta/DEN_ts_$variable"
use "$ts_data",clear

su $variable
global max=r(max)
global min=r(min)
global min_1=r(min)+1
di $max
di $min
di $min_1

global trend "bdate_w" // insert variable names
global season "bweek"
global tw_tm "tw"
global cutoff "2020w51"


****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=$min/$max {
use "$ts_data.dta", clear
keep if $variable==`i'
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season , irr

quietly: margins, ///
at($trend=(2860(1)3223) loco=(0)) ///
at($trend=(2860(1)3223) loco=(1)) ///
predict(n) ///
saving("$dta/margins_ts_`i'.dta", replace)

preserve 
use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin lin_count
keep lin_count $trend loco
drop if loco==0 & $trend >=$tw_tm($cutoff)
drop if loco==1 & $trend <$tw_tm($cutoff)
gen $variable=`i'
save "$dta/lin_pred_`i'.dta",replace

use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin cf_lin_count
keep cf_lin_count $trend loco
keep if loco==0 &  $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/cf_lin_pred_`i'.dta",replace
restore

}

use "$dta/lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/lin_pred_`i'"
}
save "$dta/lin_pred_all", replace

use "$dta/cf_lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/cf_lin_pred_`i'"
}
save "$dta/cf_lin_pred_all", replace


use "$ts_data", clear
merge 1:1 $trend $variable using "$dta/lin_pred_all", nogen
merge 1:1 $trend $variable using "$dta/cf_lin_pred_all", nogen

forval i=$min/$max {
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season if $variable==`i', irr
predict pred_count_`i' if $variable==`i'
}
gen pred_count=pred_count_$min
forval i=$min_1/$max{
	replace pred_count=pred_count_`i' if pred_count==.
}
drop pred_count_$min - pred_count_$max
*PLOT IT
forvalues i=$min/$max {
  local v : label ($variable) `i'
   display "`i' is `v'"
   }

local forlab: value label $variable
forvalues i = $min/$max {
	local label: label `forlab' `i'
	di "`label'" 

tw ///
(line pred_count $trend if $variable==`i', lwidth(thin) lcolor(gs10)) ///
(line lin_count $trend if loco==0 & $variable==`i', lwidth(medium) lcolor(black)) ///
(line cf_lin_count $trend if loco==1 & $variable==`i', lpattern(shortdash) lwidth(medium) lcolor(black)) ///
(line lin_count $trend if loco==1 & $variable==`i', lpattern(solid) lwidth(medium) lcolor(black)) ///
(scatter n_births $trend if $variable==`i', msize(vsmall) mcolor(ebblue%60) msym(o)) ///
, ///
xline(3170, lpattern(solid) lcolor(red) lwidth(vthin)) ///
xt("Week of Birth") ///
xlab(2860(104)3223, angle(h)) ///
ylab(, angle(h)) ///
yt("Number of Live Births") ///
legend(order(5 "Observed" 1 "Fitted" 2 "Deseasonalised Fitted" 3 "Deseasonalised Expected") row(1)) ///
title("{bf:`label'}", size(medsmall)) ///
plotregion(lcolor(black)) ///
name(C`i', replace) ///
scheme(white_tableau)

}

*combine plots
grc1leg2 C1 C2 C3 C4, ///
legendfrom(C1) ycommon ///
position(6) row(2) lyoffset(0) lxoffset(0) ///
legscale(*1) plotregion(margin(zero)) imargin(tiny) ///
xtob1title ytol1title ///
title("Denmark, Maternal Education", size(medsmall)) ///
scheme(white_tableau)

graph export "$graph/DEN_mom_edu_$S_DATE.svg", replace


**# Bookmark #33

****** MOM AGE *****
****** MOM AGE *****
****** MOM AGE *****
****** MOM AGE *****
clear all
global variable "mom_age_cat" // determine group


use "$dta/DEN_ts_$variable",clear
global ts_data "$dta/DEN_ts_$variable"
use "$ts_data",clear

su $variable
global max=r(max)
global min=r(min)
global min_1=r(min)+1
di $max
di $min
di $min_1

global trend "bdate_w" // insert variable names
global season "bweek"
global tw_tm "tw"
global cutoff "2020w51"


****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=$min/$max {
use "$ts_data.dta", clear
keep if $variable==`i'
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season , irr

quietly: margins, ///
at($trend=(2860(1)3223) loco=(0)) ///
at($trend=(2860(1)3223) loco=(1)) ///
predict(n) ///
saving("$dta/margins_ts_`i'.dta", replace)

preserve 
use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin lin_count
keep lin_count $trend loco
drop if loco==0 & $trend >=$tw_tm($cutoff)
drop if loco==1 & $trend <$tw_tm($cutoff)
gen $variable=`i'
save "$dta/lin_pred_`i'.dta",replace

use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin cf_lin_count
keep cf_lin_count $trend loco
keep if loco==0 &  $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/cf_lin_pred_`i'.dta",replace
restore

}

use "$dta/lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/lin_pred_`i'"
}
save "$dta/lin_pred_all", replace

use "$dta/cf_lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/cf_lin_pred_`i'"
}
save "$dta/cf_lin_pred_all", replace


use "$ts_data", clear
merge 1:1 $trend $variable using "$dta/lin_pred_all", nogen
merge 1:1 $trend $variable using "$dta/cf_lin_pred_all", nogen

forval i=$min/$max {
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season if $variable==`i', irr
predict pred_count_`i' if $variable==`i'
}
gen pred_count=pred_count_$min
forval i=$min_1/$max{
	replace pred_count=pred_count_`i' if pred_count==.
}
drop pred_count_$min - pred_count_$max
*PLOT IT
forvalues i=$min/$max {
  local v : label ($variable) `i'
   display "`i' is `v'"
   }

local forlab: value label $variable
forvalues i = $min/$max {
	local label: label `forlab' `i'
	di "`label'" 

tw ///
(line pred_count $trend if $variable==`i', lwidth(thin) lcolor(gs10)) ///
(line lin_count $trend if loco==0 & $variable==`i', lwidth(medium) lcolor(black)) ///
(line cf_lin_count $trend if loco==1 & $variable==`i', lpattern(shortdash) lwidth(medium) lcolor(black)) ///
(line lin_count $trend if loco==1 & $variable==`i', lpattern(solid) lwidth(medium) lcolor(black)) ///
(scatter n_births $trend if $variable==`i', msize(vsmall) mcolor(ebblue%60) msym(o)) ///
, ///
xline(3170, lpattern(solid) lcolor(red) lwidth(vthin)) ///
xt("Week of Birth") ///
xlab(2860(104)3223, angle(h)) ///
ylab(, angle(h)) ///
yt("Number of Live Births") ///
legend(order(5 "Observed" 1 "Fitted" 2 "Deseasonalised Fitted" 3 "Deseasonalised Expected") col(1)) ///
title("{bf:`label'}", size(medsmall)) ///
plotregion(lcolor(black)) ///
name(C`i', replace) ///
scheme(white_tableau)

}

*combine plots
grc1leg2 C1 C2 C3 C4 C5, ///
legendfrom(C1) ycommon ///
position(4) ring(0) lyoffset(10) lxoffset(-5) ///
legscale(*1) plotregion(margin(zero)) imargin(tiny) ///
xtob1title ytol1title ///
title("Denmark, Maternal Age", size(medsmall)) ///
scheme(white_tableau)

graph export "$graph/DEN_mom_age_$S_DATE.svg", replace

**# Bookmark #2

****** PARITY  *****
****** PARITY  *****
****** PARITY  *****
****** PARITY  *****
clear all
global variable "parity" // determine group


use "$dta/DEN_ts_$variable",clear
global ts_data "$dta/DEN_ts_$variable"
use "$ts_data",clear

su $variable
global max=r(max)
global min=r(min)
global min_1=r(min)+1
di $max
di $min
di $min_1

global trend "bdate_w" // insert variable names
global season "bweek"
global tw_tm "tw"
global cutoff "2020w51"


****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=$min/$max {
use "$ts_data.dta", clear
keep if $variable==`i'
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season , irr

quietly: margins, ///
at($trend=(2860(1)3223) loco=(0)) ///
at($trend=(2860(1)3223) loco=(1)) ///
predict(n) ///
saving("$dta/margins_ts_`i'.dta", replace)

preserve 
use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin lin_count
keep lin_count $trend loco
drop if loco==0 & $trend >=$tw_tm($cutoff)
drop if loco==1 & $trend <$tw_tm($cutoff)
gen $variable=`i'
save "$dta/lin_pred_`i'.dta",replace

use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin cf_lin_count
keep cf_lin_count $trend loco
keep if loco==0 &  $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/cf_lin_pred_`i'.dta",replace
restore

}

use "$dta/lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/lin_pred_`i'"
}
save "$dta/lin_pred_all", replace

use "$dta/cf_lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/cf_lin_pred_`i'"
}
save "$dta/cf_lin_pred_all", replace


use "$ts_data", clear
merge 1:1 $trend $variable using "$dta/lin_pred_all", nogen
merge 1:1 $trend $variable using "$dta/cf_lin_pred_all", nogen

forval i=$min/$max {
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season if $variable==`i', irr
predict pred_count_`i' if $variable==`i'
}
gen pred_count=pred_count_$min
forval i=$min_1/$max{
	replace pred_count=pred_count_`i' if pred_count==.
}
drop pred_count_$min - pred_count_$max
*PLOT IT
forvalues i=$min/$max {
  local v : label ($variable) `i'
   display "`i' is `v'"
   }

local forlab: value label $variable
forvalues i = $min/$max {
	local label: label `forlab' `i'
	di "`label'" 

tw ///
(line pred_count $trend if $variable==`i', lwidth(thin) lcolor(gs10)) ///
(line lin_count $trend if loco==0 & $variable==`i', lwidth(medium) lcolor(black)) ///
(line cf_lin_count $trend if loco==1 & $variable==`i', lpattern(shortdash) lwidth(medium) lcolor(black)) ///
(line lin_count $trend if loco==1 & $variable==`i', lpattern(solid) lwidth(medium) lcolor(black)) ///
(scatter n_births $trend if $variable==`i', msize(vsmall) mcolor(ebblue%60) msym(o)) ///
, ///
xline(3170, lpattern(solid) lcolor(red) lwidth(vthin)) ///
xt("Week of Birth") ///
xlab(2860(104)3223, angle(h)) ///
ylab(, angle(h)) ///
yt("Number of Live Births") ///
legend(order(5 "Observed" 1 "Fitted" 2 "Deseasonalised Fitted" 3 "Deseasonalised Expected") col(1)) ///
title("{bf:`label'}", size(medsmall)) ///
plotregion(lcolor(black)) ///
name(C`i', replace) ///
scheme(white_tableau)

}

*combine plots
grc1leg2 C1 C2 C3 C4 C5, ///
legendfrom(C1)  ///
position(4) ring(0) lyoffset(10) lxoffset(-5) ///
legscale(*1) plotregion(margin(zero)) imargin(tiny) ///
xtob1title ytol1title ///
title("Denmark, Parity", size(medsmall)) ///
scheme(white_tableau)

graph export "$graph/DEN_parity_$S_DATE.svg", replace

**# Bookmark #3


****************************************************
****************************************************
*---------------- Tables ---------------------------
*---------------- Tables ---------------------------

**# Bookmark #4

**********  MATERN AGE, EDUCATION, PARITY  **********
**********  MATERN AGE, EDUCATION, PARITY  **********
**********  MATERN AGE, EDUCATION, PARITY  **********

*
foreach var in noneq_hh_inc mom_age_cat mom_edu_comp parity {
clear all
global variable "`var'" // determine group

global ts_data "$dta/DEN_ts_$variable"
use "$ts_data",clear

su $variable
global max=r(max)
global min=r(min)
global min_1=r(min)+1
di $max
di $min
di $min_1

global trend "bdate_w" // insert variable names
global season "bweek"
global tw_tm "tw"
global cutoff "2020w51"

*
preserve // get numbers for table later
collapse (sum) n_births if loco==1, by($variable)
egen total_births=sum(n_births)
gen prop= n_births/total_births
save "$dta/DEN_obs_$variable.dta" ,replace
restore 

****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=$min/$max {
use "$ts_data", clear
keep if $variable==`i'
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season , irr
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
gen $variable=`i'
keep $variable cf_count se_cf_count cf_count_lb cf_count_ub
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
gen $variable=`i'
keep $variable countdiff countdiff_lb countdiff_ub
save "$dta/countdiff_estimate_`i'.dta", replace
restore
}

use "$dta/cf_estimate_$min", clear
forval i=$min_1/$max {
	append using "$dta/cf_estimate_`i'"
}

merge 1:1  $variable using "$dta/DEN_obs_$variable.dta", nogen
order $variable n_births cf_count se_cf_count 
egen total_cf_count=sum(cf_count)
gen cf_prop=cf_count/total_cf_count
gen propdiff=prop-cf_prop
save "$dta/DEN_cf_estimate.dta", replace

use "$dta/countdiff_estimate_$min", clear
forval i=$min_1/$max {
	append using "$dta/countdiff_estimate_`i'"
}

merge 1:1  $variable using "$dta/DEN_cf_estimate.dta", nogen
order $variable n_births cf_count se_cf_count 
save "$dta/DEN_cf_estimate.dta", replace

*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
set seed 123456789
forval d=1/10000 {
use "$dta/DEN_cf_estimate.dta", clear
keep $variable cf_count se_cf_count prop
gen cf_count_i_d=rnormal(cf_count , se_cf_count) // generate random draw d from mean SE estimated from poisson ITS for each SIMD group i
egen sum_cf_count_i_d=sum(cf_count_i_d) // sum random draws d of all groups i
gen cf_prop_i_d=cf_count_i_d/sum_cf_count_i_d // create counterfactual proportion for each group i based on draw d
gen propdiff_i_d=prop- cf_prop_i_d // get m_i_d which is the difference in proportion between observed and counterfactual from draw d
keep $variable propdiff_i_d
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
_pctile propdiff_i_d if $variable==$min, percentiles(2.5) 
return list
gen propdiff_lb=r(r1) if $variable==$min
_pctile propdiff_i_d if $variable==$min, percentiles(97.5) 
return list
gen propdiff_ub=r(r1) if $variable==$min

forval i=$min_1/$max {
_pctile propdiff_i_d if $variable==`i', percentiles(2.5) 
return list
replace propdiff_lb=r(r1) if $variable==`i'
_pctile propdiff_i_d if $variable==`i', percentiles(97.5) 
return list
replace propdiff_ub=r(r1) if $variable==`i'
}

collapse propdiff_lb propdiff_ub, by($variable)
save "$dta/DEN_prop_uncertainty", replace
use "$dta/DEN_cf_estimate", clear
merge 1:1 $variable using "$dta/DEN_prop_uncertainty", nogen
gen country="Denmark"
order country $variable n_births cf_count se_cf_count cf_count_lb cf_count_ub countdiff countdiff_lb countdiff_ub prop cf_prop propdiff propdiff_lb propdiff_ub total_births total_cf_count
save "$dta/DEN_comp_diff_$variable", replace

}

**# Bookmark #5

****************** DENMARK TABLE **********
****************** DENMARK TABLE **********
****************** DENMARK TABLE **********
use "$dta/DEN_comp_diff_noneq_hh_inc", clear
append using "$dta/DEN_comp_diff_mom_edu_comp"
append using "$dta/DEN_comp_diff_mom_age_cat"
append using "$dta/DEN_comp_diff_parity"

gen rel_count_diff=(n_births-cf_count)/(abs(cf_count))*100
gen rel_count_diff_ub=(n_births-cf_count_lb)/(abs(cf_count_lb))*100
gen rel_count_diff_lb=(n_births-cf_count_ub)/(abs(cf_count_ub))*100
order country  mom_age_cat mom_edu_comp n_births cf_count se_cf_count cf_count_lb cf_count_ub countdiff countdiff_lb countdiff_ub rel_count_diff rel_count_diff_lb rel_count_diff_ub prop cf_prop propdiff propdiff_lb propdiff_ub total_births total_cf_count

drop se_cf_count
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

order country noneq_hh_inc mom_edu_comp mom_age_cat parity n_births cf_count  cf_count_ci countdiff countdiff_ci  rel_count_diff rel_diff_ci prop cf_prop propdiff propdiff_ci total_births total_cf_count


save "$dta/DEN_table_profile_$S_DATE", replace
export excel using "$table\DEN_table_profile_$S_DATE.xls", firstrow(variables) replace



**# Bookmark #17

*************************** SPAIN ******************************
*************************** SPAIN ******************************
*************************** SPAIN ******************************

**** MAIN SEC VARIABLE *********
**** MAIN SEC VARIABLE *********
**** MAIN SEC VARIABLE *********
clear all
use "$dta/ESP_ts", clear
global ts_data "$dta/ESP_ts"
global variable "mom_edu_comp" // determine group
su $variable, 
global max=r(max)
global min=r(min)
global min_1=r(min)+1
di $max
di $min
di $min_1

global trend "mdate" // insert variable names
global season "month_nr"
global tw_tm "tm"
global cutoff "2020m12"

****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=$min/$max {
use "$ts_data.dta", clear
keep if $variable==`i'
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season i.d_16_17, irr

quietly: margins, ///
at($trend=(672(1)695) loco=0 d_16_17=1) ///
at($trend=(696(1)743)  loco=0 d_16_17=0) ///
at($trend=(731(1)743)  loco=1 d_16_17=0) ///
predict(n) ///
saving("$dta/margins_ts_`i'.dta", replace)

preserve 
use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin lin_count
keep lin_count $trend loco
drop if loco==0 & $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/lin_pred_`i'.dta",replace

use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin cf_lin_count
keep cf_lin_count $trend loco
keep if loco==0 &  $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/cf_lin_pred_`i'.dta",replace
restore

}

use "$dta/lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/lin_pred_`i'"
}
save "$dta/lin_pred_all", replace

use "$dta/cf_lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/cf_lin_pred_`i'"
}
save "$dta/cf_lin_pred_all", replace


use "$ts_data", clear
merge 1:1 $trend $variable using "$dta/lin_pred_all", nogen
merge 1:1 $trend $variable using "$dta/cf_lin_pred_all", nogen

forval i=$min/$max {
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season if $variable==`i', irr
predict pred_count_`i' if $variable==`i'
}
gen pred_count=pred_count_$min
forval i=$min_1/$max{
	replace pred_count=pred_count_`i' if pred_count==.
}
drop pred_count_$min - pred_count_$max
*PLOT IT
forvalues i=$min/$max {
  local v : label ($variable) `i'
   display "`i' is `v'"
   }

local forlab: value label $variable
forvalues i = $min/$max {
	local label: label `forlab' `i'
	di "`label'" 

tw ///
(line pred_count $trend if $variable==`i', lwidth(thin) lcolor(gs10)) ///
(line lin_count $trend if loco==0 & $variable==`i', lwidth(medium) lcolor(black)) ///
(line cf_lin_count $trend if loco==1 & $variable==`i', lpattern(shortdash) lwidth(medium) lcolor(black)) ///
(line lin_count $trend if loco==1 & $variable==`i', lpattern(solid) lwidth(medium) lcolor(black)) ///
(scatter n_births $trend if $variable==`i', msize(vsmall) mcolor(ebblue%60) msym(o)) ///
, ///
xline(731, lpattern(solid) lcolor(red) lwidth(vthin)) ///
xt("Month of Birth") ///
xlab(660(24)731, ) ///
ylab(, angle(h)) ///
yt("Number of Live Births") ///
legend(order(5 "Observed" 1 "Fitted" 2 "Deseasonalised Fitted" 3 "Deseasonalised Expected") row(1)) ///
title("{bf:`label'}", size(medsmall)) ///
plotregion(lcolor(black)) ///
name(C`i', replace) ///
scheme(white_tableau)

}

*combine plots
grc1leg2 C1 C2 C3 C4 , ///
legendfrom(C1) ///
position(6) lyoffset(0) lxoffset(0) ///
legscale(*1) plotregion(margin(zero)) imargin(tiny) ///
xtob1title ytol1title ///
title("Spain, Maternal Education, Women older than 25 years", size(medsmall)) ///
scheme(white_tableau)

graph export "$graph/ESP_mom_edu_comp_$S_DATE.svg", replace

**# Bookmark #46

********* MATERNAL EDUCATION IN DETAIL ***********
********* MATERNAL EDUCATION IN DETAIL ***********
********* MATERNAL EDUCATION IN DETAIL ***********
clear all
use "C:\Users\moritzob\OneDrive - University of Helsinki\postdoc life helsinki\LoCo-effect\LoCo-effect Spain Composition\dta/births_2015_2021.dta", clear
drop if EDADM<26 // drop those for which edu is not measured age<26
drop if year==2015

tab edu_mom,m
gen d_16_17=1 if year<2018 
recode d_16_17 (.=0)

global variable "edu_mom" // determine group
su $variable, 
global max=r(max)
global min=r(min)
global min_1=r(min)+1
di $max
di $min
di $min_1

global trend "mdate" // insert variable names
global season "month_nr"
global tw_tm "tm"
global cutoff "2020m12"

collapse  d_16_17 loco $season (count) n_births= year, by($trend $variable)

save "$dta/ESP_ts_$variable", replace
global ts_data "$dta/ESP_ts_$variable"


****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=$min/$max {
use "$ts_data.dta", clear
keep if $variable==`i'
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season i.d_16_17 , irr

quietly: margins, ///
at($trend=(672(1)695) loco=0 d_16_17=1) ///
at($trend=(696(1)743)  loco=0 d_16_17=0) ///
at($trend=(731(1)743)  loco=1 d_16_17=0) ///
predict(n) ///
saving("$dta/margins_ts_`i'.dta", replace)

preserve 
use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin lin_count
keep lin_count $trend loco
drop if loco==0 & $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/lin_pred_`i'.dta",replace

use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin cf_lin_count
keep cf_lin_count $trend loco
keep if loco==0 &  $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/cf_lin_pred_`i'.dta",replace
restore

}

use "$dta/lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/lin_pred_`i'"
}
save "$dta/lin_pred_all", replace

use "$dta/cf_lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/cf_lin_pred_`i'"
}
save "$dta/cf_lin_pred_all", replace


use "$ts_data", clear
merge 1:1 $trend $variable using "$dta/lin_pred_all", nogen
merge 1:1 $trend $variable using "$dta/cf_lin_pred_all", nogen

forval i=$min/$max {
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season i.d_16_17 if $variable==`i', irr
predict pred_count_`i' if $variable==`i'
}
gen pred_count=pred_count_$min
forval i=$min_1/$max{
	replace pred_count=pred_count_`i' if pred_count==.
}
drop pred_count_$min - pred_count_$max
*PLOT IT
forvalues i=$min/$max {
  local v : label ($variable) `i'
   display "`i' is `v'"
   }

local forlab: value label $variable
forvalues i = $min/$max {
	local label: label `forlab' `i'
	di "`label'" 

tw ///
(line pred_count $trend if $variable==`i', lwidth(thin) lcolor(gs10)) ///
(line lin_count $trend if loco==0 & $variable==`i', lwidth(medium) lcolor(black)) ///
(line cf_lin_count $trend if loco==1 & $variable==`i', lpattern(shortdash) lwidth(medium) lcolor(black)) ///
(line lin_count $trend if loco==1 & $variable==`i', lpattern(solid) lwidth(medium) lcolor(black)) ///
(scatter n_births $trend if $variable==`i', msize(vsmall) mcolor(ebblue%60) msym(o)) ///
, ///
xline(731, lpattern(solid) lcolor(red) lwidth(vthin)) ///
xt("Month of Birth") ///
xlab(660(24)731, ) ///
ylab(, angle(h)) ///
yt("Number of Live Births") ///
legend(order(5 "Observed" 1 "Fitted" 2 "Deseasonalised Fitted" 3 "Deseasonalised Expected") row(1)) ///
title("{bf:`label'}", size(medsmall)) ///
plotregion(lcolor(black)) ///
name(C`i', replace) ///
scheme(white_tableau)

}

*combine plots
grc1leg2 C1 C2 C3 C4 C5 C6, ///
legendfrom(C1) ///
position(6) lyoffset(0) lxoffset(0) ///
legscale(*1) plotregion(margin(zero)) imargin(tiny) ///
xtob1title ytol1title ///
title("Spain, Maternal Education, Women older than 25 years ", size(medsmall)) ///
scheme(white_tableau)

graph export "$graph/ESP_mom_edu_$S_DATE.svg", replace


**# Bookmark #47
******** HIGHEST EDU OF PARENTS ******
******** HIGHEST EDU OF PARENTS ******
******** HIGHEST EDU OF PARENTS ******

clear all
use "C:\Users\moritzob\OneDrive - University of Helsinki\postdoc life helsinki\LoCo-effect\LoCo-effect Spain Composition\dta/births_2015_2021.dta", clear
drop if EDADM<26 // drop those for which edu is not measured age<26
drop if year==2015

tab mom_dad_edu_comp,m
gen d_16_17=1 if year<2018 
recode d_16_17 (.=0)

global variable "mom_dad_edu_comp" // determine group
su $variable, 
global max=r(max)
global min=r(min)
global min_1=r(min)+1
di $max
di $min
di $min_1

global trend "mdate" // insert variable names
global season "month_nr"
global tw_tm "tm"
global cutoff "2020m12"

collapse  d_16_17 loco $season (count) n_births= year, by($trend $variable)

save "$dta/ESP_ts_$variable", replace
global ts_data "$dta/ESP_ts_$variable"


****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=$min/$max {
use "$ts_data.dta", clear
keep if $variable==`i'
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season i.d_16_17 , irr

quietly: margins, ///
at($trend=(672(1)695) loco=0 d_16_17=1) ///
at($trend=(696(1)743)  loco=0 d_16_17=0) ///
at($trend=(731(1)743)  loco=1 d_16_17=0) ///
predict(n) ///
saving("$dta/margins_ts_`i'.dta", replace)

preserve 
use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin lin_count
keep lin_count $trend loco
drop if loco==0 & $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/lin_pred_`i'.dta",replace

use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin cf_lin_count
keep cf_lin_count $trend loco
keep if loco==0 &  $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/cf_lin_pred_`i'.dta",replace
restore

}

use "$dta/lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/lin_pred_`i'"
}
save "$dta/lin_pred_all", replace

use "$dta/cf_lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/cf_lin_pred_`i'"
}
save "$dta/cf_lin_pred_all", replace


use "$ts_data", clear
merge 1:1 $trend $variable using "$dta/lin_pred_all", nogen
merge 1:1 $trend $variable using "$dta/cf_lin_pred_all", nogen

forval i=$min/$max {
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season i.d_16_17 if $variable==`i', irr
predict pred_count_`i' if $variable==`i'
}
gen pred_count=pred_count_$min
forval i=$min_1/$max{
	replace pred_count=pred_count_`i' if pred_count==.
}
drop pred_count_$min - pred_count_$max
*PLOT IT
forvalues i=$min/$max {
  local v : label ($variable) `i'
   display "`i' is `v'"
   }

local forlab: value label $variable
forvalues i = $min/$max {
	local label: label `forlab' `i'
	di "`label'" 

tw ///
(line pred_count $trend if $variable==`i', lwidth(thin) lcolor(gs10)) ///
(line lin_count $trend if loco==0 & $variable==`i', lwidth(medium) lcolor(black)) ///
(line cf_lin_count $trend if loco==1 & $variable==`i', lpattern(shortdash) lwidth(medium) lcolor(black)) ///
(line lin_count $trend if loco==1 & $variable==`i', lpattern(solid) lwidth(medium) lcolor(black)) ///
(scatter n_births $trend if $variable==`i', msize(vsmall) mcolor(ebblue%60) msym(o)) ///
, ///
xline(731, lpattern(solid) lcolor(red) lwidth(vthin)) ///
xt("Month of Birth") ///
xlab(660(24)731, ) ///
ylab(, angle(h)) ///
yt("Number of Live Births") ///
legend(order(5 "Observed" 1 "Fitted" 2 "Deseasonalised Fitted" 3 "Deseasonalised Expected") row(1)) ///
title("{bf:`label'}", size(medsmall)) ///
plotregion(lcolor(black)) ///
name(C`i', replace) ///
scheme(white_tableau)

}

*combine plots
grc1leg2 C1 C2 C3 C4 , ///
legendfrom(C1) ///
position(6) lyoffset(0) lxoffset(0) ///
legscale(*1) plotregion(margin(zero)) imargin(tiny) ///
xtob1title ytol1title ///
title("Spain, Highest Parental Education, Women older than 25 years ", size(medsmall)) ///
scheme(white_tableau)

graph export "$graph/ESP_mom_dad_edu_comp_$S_DATE.svg", replace

**# Bookmark #48
 ******* MATERNAL AGE ************
 ******* MATERNAL AGE ************
 ******* MATERNAL AGE ************
clear all
use "C:\Users\moritzob\OneDrive - University of Helsinki\postdoc life helsinki\LoCo-effect\LoCo-effect Spain Composition\dta/births_2015_2021.dta", clear
tab mom_age_cat,m
label values mom_age_cat
label define agelab2 1 "Maternal Age Under 20" 2 "20-24" 3 "25-29" 4 "30-34" 5 "35 and Above"
label values mom_age_cat agelab2

global variable "mom_age_cat" // determine group
su $variable, 
global max=r(max)
global min=r(min)
global min_1=r(min)+1
di $max
di $min
di $min_1

global trend "mdate" // insert variable names
global season "month_nr"
global tw_tm "tm"
global cutoff "2020m12"

collapse  loco $season (count) n_births= year, by($trend $variable)

save "$dta/ESP_ts_$variable", replace
global ts_data "$dta/ESP_ts_$variable"


****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=$min/$max {
use "$ts_data.dta", clear
keep if $variable==`i'
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season  , irr

quietly: margins, ///
at($trend=(660(1)743) loco=(0)) ///
at($trend=(731(1)743) loco=(1)) ///
predict(n) ///
saving("$dta/margins_ts_`i'.dta", replace)

preserve 
use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin lin_count
keep lin_count $trend loco
drop if loco==0 & $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/lin_pred_`i'.dta",replace

use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin cf_lin_count
keep cf_lin_count $trend loco
keep if loco==0 &  $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/cf_lin_pred_`i'.dta",replace
restore

}

use "$dta/lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/lin_pred_`i'"
}
save "$dta/lin_pred_all", replace

use "$dta/cf_lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/cf_lin_pred_`i'"
}
save "$dta/cf_lin_pred_all", replace


use "$ts_data", clear
merge 1:1 $trend $variable using "$dta/lin_pred_all", nogen
merge 1:1 $trend $variable using "$dta/cf_lin_pred_all", nogen

forval i=$min/$max {
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season if $variable==`i', irr
predict pred_count_`i' if $variable==`i'
}
gen pred_count=pred_count_$min
forval i=$min_1/$max{
	replace pred_count=pred_count_`i' if pred_count==.
}
drop pred_count_$min - pred_count_$max
*PLOT IT
forvalues i=$min/$max {
  local v : label ($variable) `i'
   display "`i' is `v'"
   }

local forlab: value label $variable
forvalues i = $min/$max {
	local label: label `forlab' `i'
	di "`label'" 

tw ///
(line pred_count $trend if $variable==`i', lwidth(thin) lcolor(gs10)) ///
(line lin_count $trend if loco==0 & $variable==`i', lwidth(medium) lcolor(black)) ///
(line cf_lin_count $trend if loco==1 & $variable==`i', lpattern(shortdash) lwidth(medium) lcolor(black)) ///
(line lin_count $trend if loco==1 & $variable==`i', lpattern(solid) lwidth(medium) lcolor(black)) ///
(scatter n_births $trend if $variable==`i', msize(vsmall) mcolor(ebblue%60) msym(o)) ///
, ///
xline(731, lpattern(solid) lcolor(red) lwidth(vthin)) ///
xt("Month of Birth") ///
xlab(660(24)731, ) ///
ylab(, angle(h)) ///
yt("Number of Live Births") ///
legend(order(5 "Observed" 1 "Fitted" 2 "Deseasonalised Fitted" 3 "Deseasonalised Expected") col(1)) ///
title("{bf:`label'}", size(medsmall)) ///
plotregion(lcolor(black)) ///
name(C`i', replace) ///
scheme(white_tableau)

}

*combine plots
grc1leg2 C1 C2 C3 C4 C5, ///
legendfrom(C1) ///
position(4) ring(0) lyoffset(10) lxoffset(0) ///
legscale(*1) plotregion(margin(zero)) imargin(tiny) ///
xtob1title ytol1title ///
title("Spain, Maternal Age ", size(medsmall)) ///
scheme(white_tableau)

graph export "$graph/ESP_mom_age_cat_$S_DATE.svg", replace
**# Bookmark #49

***** PARITY PARITY *****
***** PARITY PARITY *****
***** PARITY PARITY *****
clear all
use "C:\Users\moritzob\OneDrive - University of Helsinki\postdoc life helsinki\LoCo-effect\LoCo-effect Spain Composition\dta/births_2015_2021.dta", clear
tab parity,m
label define parlab 0 "Parity 0" 1 "1" 2 "2" 3 "3" 4 "4 or more"
label values parity parlab
global variable "parity" // determine group
su $variable, 
global max=r(max)
global min=r(min)
global min_1=r(min)+1
di $max
di $min
di $min_1

global trend "mdate" // insert variable names
global season "month_nr"
global tw_tm "tm"
global cutoff "2020m12"

collapse  loco $season (count) n_births= year, by($trend $variable)

save "$dta/ESP_ts_$variable", replace
global ts_data "$dta/ESP_ts_$variable"


****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=$min/$max {
use "$ts_data.dta", clear
keep if $variable==`i'
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season  , irr

quietly: margins, ///
at($trend=(660(1)743) loco=(0)) ///
at($trend=(731(1)743) loco=(1)) ///
predict(n) ///
saving("$dta/margins_ts_`i'.dta", replace)

preserve 
use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin lin_count
keep lin_count $trend loco
drop if loco==0 & $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/lin_pred_`i'.dta",replace

use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin cf_lin_count
keep cf_lin_count $trend loco
keep if loco==0 &  $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/cf_lin_pred_`i'.dta",replace
restore

}

use "$dta/lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/lin_pred_`i'"
}
save "$dta/lin_pred_all", replace

use "$dta/cf_lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/cf_lin_pred_`i'"
}
save "$dta/cf_lin_pred_all", replace


use "$ts_data", clear
merge 1:1 $trend $variable using "$dta/lin_pred_all", nogen
merge 1:1 $trend $variable using "$dta/cf_lin_pred_all", nogen

forval i=$min/$max {
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season if $variable==`i', irr
predict pred_count_`i' if $variable==`i'
}
gen pred_count=pred_count_$min
forval i=$min_1/$max{
	replace pred_count=pred_count_`i' if pred_count==.
}
drop pred_count_$min - pred_count_$max
*PLOT IT
forvalues i=$min/$max {
  local v : label ($variable) `i'
   display "`i' is `v'"
   }

local forlab: value label $variable
forvalues i = $min/$max {
	local label: label `forlab' `i'
	di "`label'" 

tw ///
(line pred_count $trend if $variable==`i', lwidth(thin) lcolor(gs10)) ///
(line lin_count $trend if loco==0 & $variable==`i', lwidth(medium) lcolor(black)) ///
(line cf_lin_count $trend if loco==1 & $variable==`i', lpattern(shortdash) lwidth(medium) lcolor(black)) ///
(line lin_count $trend if loco==1 & $variable==`i', lpattern(solid) lwidth(medium) lcolor(black)) ///
(scatter n_births $trend if $variable==`i', msize(vsmall) mcolor(ebblue%60) msym(o)) ///
, ///
xline(731, lpattern(solid) lcolor(red) lwidth(vthin)) ///
xt("Month of Birth") ///
xlab(660(24)731, ) ///
ylab(, angle(h)) ///
yt("Number of Live Births") ///
legend(order(5 "Observed" 1 "Fitted" 2 "Deseasonalised Fitted" 3 "Deseasonalised Expected") col(1)) ///
title("{bf:`label'}", size(medsmall)) ///
plotregion(lcolor(black)) ///
name(C`i', replace) ///
scheme(white_tableau)

}

*combine plots
grc1leg2 C0 C1 C2 C3 C4, ///
legendfrom(C1) ///
position(4) ring(0) lyoffset(10) lxoffset(0) ///
legscale(*1) plotregion(margin(zero)) imargin(tiny) ///
xtob1title ytol1title ///
title("Spain, Parity", size(medsmall)) ///
scheme(white_tableau)

graph export "$graph/ESP_parity_$S_DATE.svg", replace

**# Bookmark #50

****************************************************
****************************************************
*---------------- Tables ---------------------------
*---------------- Tables ---------------------------


******EDUCATION MOM DETAIL ****
******EDUCATION MOM DETAIL ****
******EDUCATION MOM DETAIL ****

clear all
*
global variable "edu_mom" // determine group
global ts_data "$dta\ESP_ts_$variable.dta"
use "$ts_data", clear

tab $variable
su $variable, 
global max=r(max)
global min=r(min)
global min_1=r(min)+1
di $max
di $min
di $min_1

global trend "mdate" // insert variable names
global season "month_nr"
global tw_tm "tm"
global cutoff "2020m12"

*
preserve // get numbers for table later
collapse (sum) n_births if loco==1, by($variable)
egen total_births=sum(n_births)
gen prop= n_births/total_births
save "$dta/ESP_obs_$variable.dta" ,replace
restore 

****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=$min/$max {
use "$ts_data", clear
keep if $variable==`i'
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season i.d_16_17, irr
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
gen $variable=`i'
keep $variable cf_count se_cf_count cf_count_lb cf_count_ub
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
gen $variable=`i'
keep $variable countdiff countdiff_lb countdiff_ub
save "$dta/countdiff_estimate_`i'.dta", replace
restore
}

use "$dta/cf_estimate_$min", clear
forval i=$min_1/$max {
	append using "$dta/cf_estimate_`i'"
}

merge 1:1  $variable using "$dta/ESP_obs_$variable.dta", nogen
order $variable n_births cf_count se_cf_count 
egen total_cf_count=sum(cf_count)
gen cf_prop=cf_count/total_cf_count
gen propdiff=prop-cf_prop
save "$dta/ESP_cf_estimate.dta", replace

use "$dta/countdiff_estimate_$min", clear
forval i=$min_1/$max {
	append using "$dta/countdiff_estimate_`i'"
}

merge 1:1  $variable using "$dta/ESP_cf_estimate.dta", nogen
order $variable n_births cf_count se_cf_count 
save "$dta/ESP_cf_estimate.dta", replace

*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
set seed 123456789
forval d=1/10000 {
use "$dta/ESP_cf_estimate.dta", clear
keep $variable cf_count se_cf_count prop
gen cf_count_i_d=rnormal(cf_count , se_cf_count) // generate random draw d from mean SE estimated from poisson ITS for each SIMD group i
egen sum_cf_count_i_d=sum(cf_count_i_d) // sum random draws d of all groups i
gen cf_prop_i_d=cf_count_i_d/sum_cf_count_i_d // create counterfactual proportion for each group i based on draw d
gen propdiff_i_d=prop- cf_prop_i_d // get m_i_d which is the difference in proportion between observed and counterfactual from draw d
keep $variable propdiff_i_d
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
_pctile propdiff_i_d if $variable==$min, percentiles(2.5) 
return list
gen propdiff_lb=r(r1) if $variable==$min
_pctile propdiff_i_d if $variable==$min, percentiles(97.5) 
return list
gen propdiff_ub=r(r1) if $variable==$min

forval i=$min_1/$max {
_pctile propdiff_i_d if $variable==`i', percentiles(2.5) 
return list
replace propdiff_lb=r(r1) if $variable==`i'
_pctile propdiff_i_d if $variable==`i', percentiles(97.5) 
return list
replace propdiff_ub=r(r1) if $variable==`i'
}

collapse propdiff_lb propdiff_ub, by($variable)
save "$dta/ESP_prop_uncertainty", replace
use "$dta/ESP_cf_estimate", clear
merge 1:1 $variable using "$dta/ESP_prop_uncertainty", nogen
gen country="Spain"
order country $variable n_births cf_count se_cf_count cf_count_lb cf_count_ub countdiff countdiff_lb countdiff_ub prop cf_prop propdiff propdiff_lb propdiff_ub total_births total_cf_count
save "$dta/ESP_comp_diff_$variable", replace

**# Bookmark #24
****** HIGHEST EDU OF BOTH PARENTS ****
****** HIGHEST EDU OF BOTH PARENTS ****
****** HIGHEST EDU OF BOTH PARENTS ****´
clear all
*
global variable "mom_dad_edu_comp" // determine group
global ts_data "$dta\ESP_ts_$variable.dta"
use "$ts_data", clear

tab $variable
su $variable, 
global max=r(max)
global min=r(min)
global min_1=r(min)+1
di $max
di $min
di $min_1

global trend "mdate" // insert variable names
global season "month_nr"
global tw_tm "tm"
global cutoff "2020m12"

*
preserve // get numbers for table later
collapse (sum) n_births if loco==1, by($variable)
egen total_births=sum(n_births)
gen prop= n_births/total_births
save "$dta/ESP_obs_$variable.dta" ,replace
restore 

****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=$min/$max {
use "$ts_data", clear
keep if $variable==`i'
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season i.d_16_17, irr
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
gen $variable=`i'
keep $variable cf_count se_cf_count cf_count_lb cf_count_ub
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
gen $variable=`i'
keep $variable countdiff countdiff_lb countdiff_ub
save "$dta/countdiff_estimate_`i'.dta", replace
restore
}

use "$dta/cf_estimate_$min", clear
forval i=$min_1/$max {
	append using "$dta/cf_estimate_`i'"
}

merge 1:1  $variable using "$dta/ESP_obs_$variable.dta", nogen
order $variable n_births cf_count se_cf_count 
egen total_cf_count=sum(cf_count)
gen cf_prop=cf_count/total_cf_count
gen propdiff=prop-cf_prop
save "$dta/ESP_cf_estimate.dta", replace

use "$dta/countdiff_estimate_$min", clear
forval i=$min_1/$max {
	append using "$dta/countdiff_estimate_`i'"
}

merge 1:1  $variable using "$dta/ESP_cf_estimate.dta", nogen
order $variable n_births cf_count se_cf_count 
save "$dta/ESP_cf_estimate.dta", replace

*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
set seed 123456789
forval d=1/10000 {
use "$dta/ESP_cf_estimate.dta", clear
keep $variable cf_count se_cf_count prop
gen cf_count_i_d=rnormal(cf_count , se_cf_count) // generate random draw d from mean SE estimated from poisson ITS for each SIMD group i
egen sum_cf_count_i_d=sum(cf_count_i_d) // sum random draws d of all groups i
gen cf_prop_i_d=cf_count_i_d/sum_cf_count_i_d // create counterfactual proportion for each group i based on draw d
gen propdiff_i_d=prop- cf_prop_i_d // get m_i_d which is the difference in proportion between observed and counterfactual from draw d
keep $variable propdiff_i_d
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
_pctile propdiff_i_d if $variable==$min, percentiles(2.5) 
return list
gen propdiff_lb=r(r1) if $variable==$min
_pctile propdiff_i_d if $variable==$min, percentiles(97.5) 
return list
gen propdiff_ub=r(r1) if $variable==$min

forval i=$min_1/$max {
_pctile propdiff_i_d if $variable==`i', percentiles(2.5) 
return list
replace propdiff_lb=r(r1) if $variable==`i'
_pctile propdiff_i_d if $variable==`i', percentiles(97.5) 
return list
replace propdiff_ub=r(r1) if $variable==`i'
}

collapse propdiff_lb propdiff_ub, by($variable)
save "$dta/ESP_prop_uncertainty", replace
use "$dta/ESP_cf_estimate", clear
merge 1:1 $variable using "$dta/ESP_prop_uncertainty", nogen
gen country="Spain"
order country $variable n_births cf_count se_cf_count cf_count_lb cf_count_ub countdiff countdiff_lb countdiff_ub prop cf_prop propdiff propdiff_lb propdiff_ub total_births total_cf_count
save "$dta/ESP_comp_diff_$variable", replace

**# Bookmark #25

********** MATERNAL AGE **********
********** MATERNAL AGE **********
********** MATERNAL AGE **********

clear all
*
global variable "mom_age_cat" // determine group
global ts_data "$dta\ESP_ts_$variable.dta"
use "$ts_data", clear

tab $variable
su $variable, 
global max=r(max)
global min=r(min)
global min_1=r(min)+1
di $max
di $min
di $min_1

global trend "mdate" // insert variable names
global season "month_nr"
global tw_tm "tm"
global cutoff "2020m12"

*
preserve // get numbers for table later
collapse (sum) n_births if loco==1, by($variable)
egen total_births=sum(n_births)
gen prop= n_births/total_births
save "$dta/ESP_obs_$variable.dta" ,replace
restore 

****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=$min/$max {
use "$ts_data", clear
keep if $variable==`i'
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season , irr
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
gen $variable=`i'
keep $variable cf_count se_cf_count cf_count_lb cf_count_ub
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
gen $variable=`i'
keep $variable countdiff countdiff_lb countdiff_ub
save "$dta/countdiff_estimate_`i'.dta", replace
restore
}

use "$dta/cf_estimate_$min", clear
forval i=$min_1/$max {
	append using "$dta/cf_estimate_`i'"
}

merge 1:1  $variable using "$dta/ESP_obs_$variable.dta", nogen
order $variable n_births cf_count se_cf_count 
egen total_cf_count=sum(cf_count)
gen cf_prop=cf_count/total_cf_count
gen propdiff=prop-cf_prop
save "$dta/ESP_cf_estimate.dta", replace

use "$dta/countdiff_estimate_$min", clear
forval i=$min_1/$max {
	append using "$dta/countdiff_estimate_`i'"
}

merge 1:1  $variable using "$dta/ESP_cf_estimate.dta", nogen
order $variable n_births cf_count se_cf_count 
save "$dta/ESP_cf_estimate.dta", replace

*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
set seed 123456789
forval d=1/10000 {
use "$dta/ESP_cf_estimate.dta", clear
keep $variable cf_count se_cf_count prop
gen cf_count_i_d=rnormal(cf_count , se_cf_count) // generate random draw d from mean SE estimated from poisson ITS for each SIMD group i
egen sum_cf_count_i_d=sum(cf_count_i_d) // sum random draws d of all groups i
gen cf_prop_i_d=cf_count_i_d/sum_cf_count_i_d // create counterfactual proportion for each group i based on draw d
gen propdiff_i_d=prop- cf_prop_i_d // get m_i_d which is the difference in proportion between observed and counterfactual from draw d
keep $variable propdiff_i_d
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
_pctile propdiff_i_d if $variable==$min, percentiles(2.5) 
return list
gen propdiff_lb=r(r1) if $variable==$min
_pctile propdiff_i_d if $variable==$min, percentiles(97.5) 
return list
gen propdiff_ub=r(r1) if $variable==$min

forval i=$min_1/$max {
_pctile propdiff_i_d if $variable==`i', percentiles(2.5) 
return list
replace propdiff_lb=r(r1) if $variable==`i'
_pctile propdiff_i_d if $variable==`i', percentiles(97.5) 
return list
replace propdiff_ub=r(r1) if $variable==`i'
}

collapse propdiff_lb propdiff_ub, by($variable)
save "$dta/ESP_prop_uncertainty", replace
use "$dta/ESP_cf_estimate", clear
merge 1:1 $variable using "$dta/ESP_prop_uncertainty", nogen
gen country="Spain"
order country $variable n_births cf_count se_cf_count cf_count_lb cf_count_ub countdiff countdiff_lb countdiff_ub prop cf_prop propdiff propdiff_lb propdiff_ub total_births total_cf_count
save "$dta/ESP_comp_diff_$variable", replace


**# Bookmark #26
********** PARITY **********
********** PARITY **********
********** PARITY **********
clear all
*
global variable "parity" // determine group
global ts_data "$dta\ESP_ts_$variable.dta"
use "$ts_data", clear

tab $variable
su $variable, 
global max=r(max)
global min=r(min)
global min_1=r(min)+1
di $max
di $min
di $min_1

global trend "mdate" // insert variable names
global season "month_nr"
global tw_tm "tm"
global cutoff "2020m12"

*
preserve // get numbers for table later
collapse (sum) n_births if loco==1, by($variable)
egen total_births=sum(n_births)
gen prop= n_births/total_births
save "$dta/ESP_obs_$variable.dta" ,replace
restore 

****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=$min/$max {
use "$ts_data", clear
keep if $variable==`i'
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season , irr
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
gen $variable=`i'
keep $variable cf_count se_cf_count cf_count_lb cf_count_ub
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
gen $variable=`i'
keep $variable countdiff countdiff_lb countdiff_ub
save "$dta/countdiff_estimate_`i'.dta", replace
restore
}

use "$dta/cf_estimate_$min", clear
forval i=$min_1/$max {
	append using "$dta/cf_estimate_`i'"
}

merge 1:1  $variable using "$dta/ESP_obs_$variable.dta", nogen
order $variable n_births cf_count se_cf_count 
egen total_cf_count=sum(cf_count)
gen cf_prop=cf_count/total_cf_count
gen propdiff=prop-cf_prop
save "$dta/ESP_cf_estimate.dta", replace

use "$dta/countdiff_estimate_$min", clear
forval i=$min_1/$max {
	append using "$dta/countdiff_estimate_`i'"
}

merge 1:1  $variable using "$dta/ESP_cf_estimate.dta", nogen
order $variable n_births cf_count se_cf_count 
save "$dta/ESP_cf_estimate.dta", replace

*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
set seed 123456789
forval d=1/10000 {
use "$dta/ESP_cf_estimate.dta", clear
keep $variable cf_count se_cf_count prop
gen cf_count_i_d=rnormal(cf_count , se_cf_count) // generate random draw d from mean SE estimated from poisson ITS for each SIMD group i
egen sum_cf_count_i_d=sum(cf_count_i_d) // sum random draws d of all groups i
gen cf_prop_i_d=cf_count_i_d/sum_cf_count_i_d // create counterfactual proportion for each group i based on draw d
gen propdiff_i_d=prop- cf_prop_i_d // get m_i_d which is the difference in proportion between observed and counterfactual from draw d
keep $variable propdiff_i_d
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
_pctile propdiff_i_d if $variable==$min, percentiles(2.5) 
return list
gen propdiff_lb=r(r1) if $variable==$min
_pctile propdiff_i_d if $variable==$min, percentiles(97.5) 
return list
gen propdiff_ub=r(r1) if $variable==$min

forval i=$min_1/$max {
_pctile propdiff_i_d if $variable==`i', percentiles(2.5) 
return list
replace propdiff_lb=r(r1) if $variable==`i'
_pctile propdiff_i_d if $variable==`i', percentiles(97.5) 
return list
replace propdiff_ub=r(r1) if $variable==`i'
}

collapse propdiff_lb propdiff_ub, by($variable)
save "$dta/ESP_prop_uncertainty", replace
use "$dta/ESP_cf_estimate", clear
merge 1:1 $variable using "$dta/ESP_prop_uncertainty", nogen
gen country="Spain"
order country $variable n_births cf_count se_cf_count cf_count_lb cf_count_ub countdiff countdiff_lb countdiff_ub prop cf_prop propdiff propdiff_lb propdiff_ub total_births total_cf_count
save "$dta/ESP_comp_diff_$variable", replace


**# Bookmark #27
************** SPAIN TABLE ***********
************** SPAIN TABLE ***********
************** SPAIN TABLE ***********

use "$dta/ESP_comp_diff_edu_mom", clear
append using "$dta/ESP_comp_diff_mom_dad_edu_comp"
append using "$dta/ESP_comp_diff_mom_age_cat"
append using "$dta/ESP_comp_diff_parity"
gen rel_count_diff=(n_births-cf_count)/(abs(cf_count))*100
gen rel_count_diff_ub=(n_births-cf_count_lb)/(abs(cf_count_lb))*100
gen rel_count_diff_lb=(n_births-cf_count_ub)/(abs(cf_count_ub))*100
order country edu_mom mom_dad_edu_comp mom_age_cat parity n_births cf_count se_cf_count cf_count_lb cf_count_ub countdiff countdiff_lb countdiff_ub rel_count_diff rel_count_diff_lb rel_count_diff_ub prop cf_prop propdiff propdiff_lb propdiff_ub total_births total_cf_count


drop se_cf_count
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

order country edu_mom mom_dad_edu_comp mom_age_cat parity n_births cf_count  cf_count_ci countdiff countdiff_ci  rel_count_diff rel_diff_ci prop cf_prop propdiff propdiff_ci total_births total_cf_count

save "$dta/ESP_table_profile_$S_DATE", replace
export excel using "$table\ESP_table_profile_$S_DATE.xls", firstrow(variables) replace


**# Bookmark #52

*********** USA USA USA*****************
*********** USA USA USA*****************
*********** USA USA USA*****************
*********** USA USA USA*****************

*** MAIN SEC VARIABLE ***
*** MAIN SEC VARIABLE ***
*** MAIN SEC VARIABLE ***
clear all
use "$dta/US_ts", clear
global ts_data "$dta/US_ts"
global variable "mom_edu_comp" // determine group
su $variable, 
global max=r(max)
global min=r(min)
global min_1=r(min)+1
di $max
di $min
di $min_1

global trend "mdate" // insert variable names
global season "month_nr"
global tw_tm "tm"
global cutoff "2020m12"

****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=$min/$max {
use "$ts_data.dta", clear
keep if $variable==`i'
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season , irr

quietly: margins, ///
at($trend=(672(1)743) loco=(0)) ///
at($trend=(731(1)743) loco=(1)) ///
predict(n) ///
saving("$dta/margins_ts_`i'.dta", replace)

preserve 
use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin lin_count
keep lin_count $trend loco
drop if loco==0 & $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/lin_pred_`i'.dta",replace

use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin cf_lin_count
keep cf_lin_count $trend loco
keep if loco==0 &  $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/cf_lin_pred_`i'.dta",replace
restore

}

use "$dta/lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/lin_pred_`i'"
}
save "$dta/lin_pred_all", replace

use "$dta/cf_lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/cf_lin_pred_`i'"
}
save "$dta/cf_lin_pred_all", replace


use "$ts_data", clear
merge 1:1 $trend $variable using "$dta/lin_pred_all", nogen
merge 1:1 $trend $variable using "$dta/cf_lin_pred_all", nogen

forval i=$min/$max {
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season if $variable==`i', irr
predict pred_count_`i' if $variable==`i'
}
gen pred_count=pred_count_$min
forval i=$min_1/$max{
	replace pred_count=pred_count_`i' if pred_count==.
}
drop pred_count_$min - pred_count_$max
*PLOT IT
forvalues i=$min/$max {
  local v : label ($variable) `i'
   display "`i' is `v'"
   }

local forlab: value label $variable
forvalues i = $min/$max {
	local label: label `forlab' `i'
	di "`label'" 

tw ///
(line pred_count $trend if $variable==`i', lwidth(thin) lcolor(gs10)) ///
(line lin_count $trend if loco==0 & $variable==`i', lwidth(medium) lcolor(black)) ///
(line cf_lin_count $trend if loco==1 & $variable==`i', lpattern(shortdash) lwidth(medium) lcolor(black)) ///
(line lin_count $trend if loco==1 & $variable==`i', lpattern(solid) lwidth(medium) lcolor(black)) ///
(scatter n_births $trend if $variable==`i', msize(vsmall) mcolor(ebblue%60) msym(o)) ///
, ///
xline(731, lpattern(solid) lcolor(red) lwidth(vthin)) ///
xt("Month of Birth") ///
xlab(660(24)731, ) ///
ylab(, angle(h)) ///
yt("Number of Live Births") ///
legend(order(5 "Observed" 1 "Fitted" 2 "Deseasonalised Fitted" 3 "Deseasonalised Expected") row(1)) ///
title("{bf:`label'}", size(medsmall)) ///
plotregion(lcolor(black)) ///
name(C`i', replace) ///
scheme(white_tableau)

}

*combine plots
grc1leg2 C1 C2 C3 C4, ///
legendfrom(C1) ///
position(6) lyoffset(0) lxoffset(0) ///
legscale(*1) plotregion(margin(zero)) imargin(tiny) ///
xtob1title ytol1title ///
title("United States, Maternal Education", size(medsmall)) ///
scheme(white_tableau)

graph export "$graph/US_mom_edu_comp_$S_DATE.svg", replace

**# Bookmark #53

*** MATERNAL EDUCATION IN MORE DETAIL****
*** MATERNAL EDUCATION IN MORE DETAIL****
*** MATERNAL EDUCATION IN MORE DETAIL****
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
*summary measure of education
tab edu_mom_det, m

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

rename edu_sum edu_mom_det // to make old code work
rename births n_births // to make code work

global variable "edu_mom_det" // determine group
su $variable, 
global max=r(max)
global min=r(min)
global min_1=r(min)+1
di $max
di $min
di $min_1
global trend "mdate" // insert variable names
global season "month_nr"
global tw_tm "tm"
global cutoff "2020m12"
save "$dta/US_ts_$variable", replace
global ts_data "$dta/US_ts_$variable"

****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=$min/$max {
use "$ts_data.dta", clear
keep if $variable==`i'
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season , irr

quietly: margins, ///
at($trend=(672(1)743) loco=(0)) ///
at($trend=(731(1)743) loco=(1)) ///
predict(n) ///
saving("$dta/margins_ts_`i'.dta", replace)

preserve 
use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin lin_count
keep lin_count $trend loco
drop if loco==0 & $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/lin_pred_`i'.dta",replace

use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin cf_lin_count
keep cf_lin_count $trend loco
keep if loco==0 &  $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/cf_lin_pred_`i'.dta",replace
restore

}

use "$dta/lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/lin_pred_`i'"
}
save "$dta/lin_pred_all", replace

use "$dta/cf_lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/cf_lin_pred_`i'"
}
save "$dta/cf_lin_pred_all", replace


use "$ts_data", clear
merge 1:1 $trend $variable using "$dta/lin_pred_all", nogen
merge 1:1 $trend $variable using "$dta/cf_lin_pred_all", nogen

forval i=$min/$max {
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season if $variable==`i', irr
predict pred_count_`i' if $variable==`i'
}
gen pred_count=pred_count_$min
forval i=$min_1/$max{
	replace pred_count=pred_count_`i' if pred_count==.
}
drop pred_count_$min - pred_count_$max
*PLOT IT
forvalues i=$min/$max {
  local v : label ($variable) `i'
   display "`i' is `v'"
   }

local forlab: value label $variable
forvalues i = $min/$max {
	local label: label `forlab' `i'
	di "`label'" 

tw ///
(line pred_count $trend if $variable==`i', lwidth(thin) lcolor(gs10)) ///
(line lin_count $trend if loco==0 & $variable==`i', lwidth(medium) lcolor(black)) ///
(line cf_lin_count $trend if loco==1 & $variable==`i', lpattern(shortdash) lwidth(medium) lcolor(black)) ///
(line lin_count $trend if loco==1 & $variable==`i', lpattern(solid) lwidth(medium) lcolor(black)) ///
(scatter n_births $trend if $variable==`i', msize(vsmall) mcolor(ebblue%60) msym(o)) ///
, ///
xline(731, lpattern(solid) lcolor(red) lwidth(vthin)) ///
xt("Month of Birth") ///
xlab(660(24)731, ) ///
ylab(, angle(h)) ///
yt("Number of Live Births") ///
legend(order(5 "Observed" 1 "Fitted" 2 "Deseasonalised Fitted" 3 "Deseasonalised Expected") row(2)) ///
title("{bf:`label'}", size(medsmall)) ///
plotregion(lcolor(black)) ///
name(C`i', replace) ///
scheme(white_tableau)

}

*combine plots
grc1leg2 C1 C2 C3 C4 C5 C6 C7, ///
legendfrom(C1) ///
position(4) ring(0) lyoffset(10) lxoffset(-10) ///
legscale(*1) plotregion(margin(zero)) imargin(tiny) ///
xtob1title ytol1title ///
title("United States, Maternal Education detailed", size(medsmall)) ///
scheme(white_tableau)

graph export "$graph/US_edu_mom_det_$S_DATE.svg", replace

**# Bookmark #56

***** DAD EDUCATION *****
***** DAD EDUCATION *****
***** DAD EDUCATION *****
import delimited "C:\Users\moritzob\OneDrive - University of Helsinki\postdoc life helsinki\LoCo-effect\LoCo-effect USA Composition\dta\US_dad_edu_2016_2022.txt", clear 
gen mdate=ym( year, monthcode)
format mdate %tm
tab mdate
rename monthcode month_nr
drop if notes=="Total"
encode fatherseducation, gen(edu_dad_det)
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
replace edu_sum=1 if edu_dad_det==1 | edu_dad_det==2 // no highschool diploma
replace edu_sum=2 if edu_dad_det==6 // highschool completed
replace edu_sum=3 if edu_dad_det==8 // some college but no degree
replace edu_sum=4 if edu_dad_det==3 // Associate degree
replace edu_sum=5 if edu_dad_det==4 // Bachelor
replace edu_sum=6 if edu_dad_det==7 | edu_dad_det==5 // Master or Doctorate
replace edu_sum=7 if edu_dad_det==9 // no known or stated

collapse  loco month_nr (sum) births, by(mdate edu_sum) 

label define edu_sum 1 "No Highschool diploma" 2 "Highschool or GED" 3 "College without Degree" 4 "Associate Degree" 5 "Bachelor's Degree" 6 "Master's or Doctorate" 7 "Unknown or not stated"
label values edu_sum edu_sum

gen dad_edu_comp=. 
replace dad_edu_comp=1 if edu_sum==1 // primary and lower secondary
replace dad_edu_comp=2 if edu_sum==2 | edu_sum==3 // upper secondary
replace dad_edu_comp=3 if edu_sum>3 & edu_sum<7 // post-secondary
replace dad_edu_comp=4 if edu_sum==7 // not known or not stated

collapse  loco month_nr (sum) births, by(mdate dad_edu_comp) 

tab dad_edu_comp,m

label define edu_sum2 1 "No Highschool diploma" 2 "Upper secondary" 3 "Post-secondary; Tertiary" 4 "Unknown or not collected"
label values dad_edu_comp edu_sum2
tab dad_edu_comp,m
rename births n_births
bysort mdate: egen total_births=total(n_births)
gen prop= n_births/ total_births

global variable "dad_edu_comp" // determine group
su $variable, 
global max=r(max)
global min=r(min)
global min_1=r(min)+1
di $max
di $min
di $min_1
global trend "mdate" // insert variable names
global season "month_nr"
global tw_tm "tm"
global cutoff "2020m12"
save "$dta/US_ts_$variable", replace
global ts_data "$dta/US_ts_$variable"

****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=$min/$max {
use "$ts_data.dta", clear
keep if $variable==`i'
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season , irr

quietly: margins, ///
at($trend=(672(1)743) loco=(0)) ///
at($trend=(731(1)743) loco=(1)) ///
predict(n) ///
saving("$dta/margins_ts_`i'.dta", replace)

preserve 
use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin lin_count
keep lin_count $trend loco
drop if loco==0 & $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/lin_pred_`i'.dta",replace

use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin cf_lin_count
keep cf_lin_count $trend loco
keep if loco==0 &  $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/cf_lin_pred_`i'.dta",replace
restore

}

use "$dta/lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/lin_pred_`i'"
}
save "$dta/lin_pred_all", replace

use "$dta/cf_lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/cf_lin_pred_`i'"
}
save "$dta/cf_lin_pred_all", replace


use "$ts_data", clear
merge 1:1 $trend $variable using "$dta/lin_pred_all", nogen
merge 1:1 $trend $variable using "$dta/cf_lin_pred_all", nogen

forval i=$min/$max {
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season if $variable==`i', irr
predict pred_count_`i' if $variable==`i'
}
gen pred_count=pred_count_$min
forval i=$min_1/$max{
	replace pred_count=pred_count_`i' if pred_count==.
}
drop pred_count_$min - pred_count_$max
*PLOT IT
forvalues i=$min/$max {
  local v : label ($variable) `i'
   display "`i' is `v'"
   }

local forlab: value label $variable
forvalues i = $min/$max {
	local label: label `forlab' `i'
	di "`label'" 

tw ///
(line pred_count $trend if $variable==`i', lwidth(thin) lcolor(gs10)) ///
(line lin_count $trend if loco==0 & $variable==`i', lwidth(medium) lcolor(black)) ///
(line cf_lin_count $trend if loco==1 & $variable==`i', lpattern(shortdash) lwidth(medium) lcolor(black)) ///
(line lin_count $trend if loco==1 & $variable==`i', lpattern(solid) lwidth(medium) lcolor(black)) ///
(scatter n_births $trend if $variable==`i', msize(vsmall) mcolor(ebblue%60) msym(o)) ///
, ///
xline(731, lpattern(solid) lcolor(red) lwidth(vthin)) ///
xt("Month of Birth") ///
xlab(660(24)731, ) ///
ylab(, angle(h)) ///
yt("Number of Live Births") ///
legend(order(5 "Observed" 1 "Fitted" 2 "Deseasonalised Fitted" 3 "Deseasonalised Expected") row(1)) ///
title("{bf:`label'}", size(medsmall)) ///
plotregion(lcolor(black)) ///
name(C`i', replace) ///
scheme(white_tableau)

}

*combine plots
grc1leg2 C1 C2 C3 C4, ///
legendfrom(C1) ///
position(6) lyoffset(0) lxoffset(0) ///
legscale(*1) plotregion(margin(zero)) imargin(tiny) ///
xtob1title ytol1title ///
title("United States, Father's Education", size(medsmall)) ///
scheme(white_tableau)

graph export "$graph/US_dad_edu_comp_$S_DATE.svg", replace

**# Bookmark #57
***** DAD EDUCATION in DETAIL *****
***** DAD EDUCATION in DETAIL *****
***** DAD EDUCATION in DETAIL *****
import delimited "C:\Users\moritzob\OneDrive - University of Helsinki\postdoc life helsinki\LoCo-effect\LoCo-effect USA Composition\dta\US_dad_edu_2016_2022.txt", clear 
gen mdate=ym( year, monthcode)
format mdate %tm
tab mdate
rename monthcode month_nr
drop if notes=="Total"
encode fatherseducation, gen(edu_dad_det)
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
replace edu_sum=1 if edu_dad_det==1 | edu_dad_det==2 // no highschool diploma
replace edu_sum=2 if edu_dad_det==6 // highschool completed
replace edu_sum=3 if edu_dad_det==8 // some college but no degree
replace edu_sum=4 if edu_dad_det==3 // Associate degree
replace edu_sum=5 if edu_dad_det==4 // Bachelor
replace edu_sum=6 if edu_dad_det==7 | edu_dad_det==5 // Master or Doctorate
replace edu_sum=7 if edu_dad_det==9 // no known or stated

collapse  loco month_nr (sum) births, by(mdate edu_sum) 

label define edu_sum 1 "No Highschool diploma" 2 "Highschool or GED" 3 "College without Degree" 4 "Associate Degree" 5 "Bachelor's Degree" 6 "Master's or Doctorate" 7 "Unknown or not stated"
label values edu_sum edu_sum

tab edu_sum,m
rename edu_sum dad_edu_det
rename births n_births
bysort mdate: egen total_births=total(n_births)
gen prop= n_births/ total_births

global variable "dad_edu_det" // determine group
su $variable, 
global max=r(max)
global min=r(min)
global min_1=r(min)+1
di $max
di $min
di $min_1
global trend "mdate" // insert variable names
global season "month_nr"
global tw_tm "tm"
global cutoff "2020m12"
save "$dta/US_ts_$variable", replace
global ts_data "$dta/US_ts_$variable"

****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=$min/$max {
use "$ts_data.dta", clear
keep if $variable==`i'
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season , irr

quietly: margins, ///
at($trend=(672(1)743) loco=(0)) ///
at($trend=(731(1)743) loco=(1)) ///
predict(n) ///
saving("$dta/margins_ts_`i'.dta", replace)

preserve 
use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin lin_count
keep lin_count $trend loco
drop if loco==0 & $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/lin_pred_`i'.dta",replace

use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin cf_lin_count
keep cf_lin_count $trend loco
keep if loco==0 &  $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/cf_lin_pred_`i'.dta",replace
restore

}

use "$dta/lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/lin_pred_`i'"
}
save "$dta/lin_pred_all", replace

use "$dta/cf_lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/cf_lin_pred_`i'"
}
save "$dta/cf_lin_pred_all", replace


use "$ts_data", clear
merge 1:1 $trend $variable using "$dta/lin_pred_all", nogen
merge 1:1 $trend $variable using "$dta/cf_lin_pred_all", nogen

forval i=$min/$max {
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season if $variable==`i', irr
predict pred_count_`i' if $variable==`i'
}
gen pred_count=pred_count_$min
forval i=$min_1/$max{
	replace pred_count=pred_count_`i' if pred_count==.
}
drop pred_count_$min - pred_count_$max
*PLOT IT
forvalues i=$min/$max {
  local v : label ($variable) `i'
   display "`i' is `v'"
   }

local forlab: value label $variable
forvalues i = $min/$max {
	local label: label `forlab' `i'
	di "`label'" 

tw ///
(line pred_count $trend if $variable==`i', lwidth(thin) lcolor(gs10)) ///
(line lin_count $trend if loco==0 & $variable==`i', lwidth(medium) lcolor(black)) ///
(line cf_lin_count $trend if loco==1 & $variable==`i', lpattern(shortdash) lwidth(medium) lcolor(black)) ///
(line lin_count $trend if loco==1 & $variable==`i', lpattern(solid) lwidth(medium) lcolor(black)) ///
(scatter n_births $trend if $variable==`i', msize(vsmall) mcolor(ebblue%60) msym(o)) ///
, ///
xline(731, lpattern(solid) lcolor(red) lwidth(vthin)) ///
xt("Month of Birth") ///
xlab(660(24)731, ) ///
ylab(, angle(h)) ///
yt("Number of Live Births") ///
legend(order(5 "Observed" 1 "Fitted" 2 "Deseasonalised Fitted" 3 "Deseasonalised Expected") row(2)) ///
title("{bf:`label'}", size(medsmall)) ///
plotregion(lcolor(black)) ///
name(C`i', replace) ///
scheme(white_tableau)

}

*combine plots
grc1leg2 C1 C2 C3 C4 C5 C6 C7, ///
legendfrom(C1) ///
position(4) ring(0) lyoffset(10) lxoffset(-10) ///
legscale(*1) plotregion(margin(zero)) imargin(tiny) ///
xtob1title ytol1title ///
title("United States, Father's Education in detail", size(medsmall)) ///
scheme(white_tableau)

graph export "$graph/US_dad_edu_det_$S_DATE.svg", replace



**# Bookmark #54

*** MATERNAL AGE ****
*** MATERNAL AGE ****
*** MATERNAL AGE ****

import delimited "C:\Users\moritzob\OneDrive - University of Helsinki\postdoc life helsinki\LoCo-effect\LoCo-effect USA Composition\dta\births_mom_age_2015_2022.txt", clear 

gen mdate=ym( year, monthcode)
format mdate %tm
tab mdate

rename monthcode month_nr
encode ageofmother9, gen(mom_age)
drop if mdate>tm(2021m12) // only include 2021 latest
gen loco=0
replace loco=1 if mdate>tm(2020m11)

*harmonise age measure
tab mom_age

gen mom_age_cat =.
replace mom_age_cat=1 if mom_age==9 | mom_age==1
replace mom_age_cat=2 if mom_age==2
replace mom_age_cat=3 if mom_age==3
replace mom_age_cat=4 if mom_age==4
replace mom_age_cat=5 if mom_age==5 | mom_age==6| mom_age==7| mom_age==8

label define agelab 1 "Maternal Age Under 20" 2 "20-24" 3 "25-29" 4 "30-34" 5 "35 and Above" 
label values mom_age_cat agelab

collapse  year loco month_nr (sum) births, by(mdate mom_age_cat) 
rename births n_births
global variable "mom_age_cat" // determine group
su $variable, 
global max=r(max)
global min=r(min)
global min_1=r(min)+1
di $max
di $min
di $min_1
global trend "mdate" // insert variable names
global season "month_nr"
global tw_tm "tm"
global cutoff "2020m12"
save "$dta/US_ts_$variable", replace
global ts_data "$dta/US_ts_$variable"

****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=$min/$max {
use "$ts_data.dta", clear
keep if $variable==`i'
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season , irr

quietly: margins, ///
at($trend=(660(1)743) loco=(0)) ///
at($trend=(731(1)743) loco=(1)) ///
predict(n) ///
saving("$dta/margins_ts_`i'.dta", replace)

preserve 
use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin lin_count
keep lin_count $trend loco
drop if loco==0 & $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/lin_pred_`i'.dta",replace

use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin cf_lin_count
keep cf_lin_count $trend loco
keep if loco==0 &  $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/cf_lin_pred_`i'.dta",replace
restore

}

use "$dta/lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/lin_pred_`i'"
}
save "$dta/lin_pred_all", replace

use "$dta/cf_lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/cf_lin_pred_`i'"
}
save "$dta/cf_lin_pred_all", replace


use "$ts_data", clear
merge 1:1 $trend $variable using "$dta/lin_pred_all", nogen
merge 1:1 $trend $variable using "$dta/cf_lin_pred_all", nogen

forval i=$min/$max {
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season if $variable==`i', irr
predict pred_count_`i' if $variable==`i'
}
gen pred_count=pred_count_$min
forval i=$min_1/$max{
	replace pred_count=pred_count_`i' if pred_count==.
}
drop pred_count_$min - pred_count_$max
*PLOT IT
forvalues i=$min/$max {
  local v : label ($variable) `i'
   display "`i' is `v'"
   }

local forlab: value label $variable
forvalues i = $min/$max {
	local label: label `forlab' `i'
	di "`label'" 

tw ///
(line pred_count $trend if $variable==`i', lwidth(thin) lcolor(gs10)) ///
(line lin_count $trend if loco==0 & $variable==`i', lwidth(medium) lcolor(black)) ///
(line cf_lin_count $trend if loco==1 & $variable==`i', lpattern(shortdash) lwidth(medium) lcolor(black)) ///
(line lin_count $trend if loco==1 & $variable==`i', lpattern(solid) lwidth(medium) lcolor(black)) ///
(scatter n_births $trend if $variable==`i', msize(vsmall) mcolor(ebblue%60) msym(o)) ///
, ///
xline(731, lpattern(solid) lcolor(red) lwidth(vthin)) ///
xt("Month of Birth") ///
xlab(660(24)731, ) ///
ylab(, angle(h)) ///
yt("Number of Live Births") ///
legend(order(5 "Observed" 1 "Fitted" 2 "Deseasonalised Fitted" 3 "Deseasonalised Expected") col(1)) ///
title("{bf:`label'}", size(medsmall)) ///
plotregion(lcolor(black)) ///
name(C`i', replace) ///
scheme(white_tableau)

}

*combine plots
grc1leg2 C1 C2 C3 C4 C5 , ///
legendfrom(C1) ///
position(4) ring(0) lyoffset(10) lxoffset(0) ///
legscale(*1) plotregion(margin(zero)) imargin(tiny) ///
xtob1title ytol1title ///
title("United States, Maternal Age", size(medsmall)) ///
scheme(white_tableau)

graph export "$graph/US_mom_age_cat_$S_DATE.svg", replace

**# Bookmark #59

****** PARITY PARITY ***************
****** PARITY PARITY ***************
****** PARITY PARITY ***************

import delimited "C:\Users\moritzob\OneDrive - University of Helsinki\postdoc life helsinki\LoCo-effect\LoCo-effect USA Composition\dta/parity_2015_2022.txt", clear

gen mdate=ym( year, monthcode)
format mdate %tm
tab mdate
rename monthcode month_nr
drop if notes=="Total"
gen parity= livebirthordercode
replace parity=5 if livebirthordercode>4
replace parity=6 if livebirthordercode==99
collapse year month_nr (sum) births, by( mdate parity) 
label define parlab 1 "Parity 0" 2 "1" 3 "2" 4 "3" 5 "4 or more" 6 "Unknown or not stated"
label values parity parlab
drop if mdate>tm(2021m12) // only include 2021 latest
gen loco=0
replace loco=1 if mdate>tm(2020m11)
rename births n_births // to make code work

global variable "parity" // determine group
su $variable, 
global max=r(max)
global min=r(min)
global min_1=r(min)+1
di $max
di $min
di $min_1
global trend "mdate" // insert variable names
global season "month_nr"
global tw_tm "tm"
global cutoff "2020m12"
save "$dta/US_ts_$variable", replace
global ts_data "$dta/US_ts_$variable"

****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=$min/$max {
use "$ts_data.dta", clear
keep if $variable==`i'
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season , irr

quietly: margins, ///
at($trend=(660(1)743) loco=(0)) ///
at($trend=(731(1)743) loco=(1)) ///
predict(n) ///
saving("$dta/margins_ts_`i'.dta", replace)

preserve 
use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin lin_count
keep lin_count $trend loco
drop if loco==0 & $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/lin_pred_`i'.dta",replace

use "$dta/margins_ts_`i'.dta", clear
rename _at2 $trend
rename _at1 loco
rename _margin cf_lin_count
keep cf_lin_count $trend loco
keep if loco==0 &  $trend >=$tw_tm($cutoff)
gen $variable=`i'
save "$dta/cf_lin_pred_`i'.dta",replace
restore

}

use "$dta/lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/lin_pred_`i'"
}
save "$dta/lin_pred_all", replace

use "$dta/cf_lin_pred_$min", clear
forval i=$min_1/$max {
	append using "$dta/cf_lin_pred_`i'"
}
save "$dta/cf_lin_pred_all", replace


use "$ts_data", clear
merge 1:1 $trend $variable using "$dta/lin_pred_all", nogen
merge 1:1 $trend $variable using "$dta/cf_lin_pred_all", nogen

forval i=$min/$max {
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season if $variable==`i', irr
predict pred_count_`i' if $variable==`i'
}
gen pred_count=pred_count_$min
forval i=$min_1/$max{
	replace pred_count=pred_count_`i' if pred_count==.
}
drop pred_count_$min - pred_count_$max
*PLOT IT
forvalues i=$min/$max {
  local v : label ($variable) `i'
   display "`i' is `v'"
   }

local forlab: value label $variable
forvalues i = $min/$max {
	local label: label `forlab' `i'
	di "`label'" 

tw ///
(line pred_count $trend if $variable==`i', lwidth(thin) lcolor(gs10)) ///
(line lin_count $trend if loco==0 & $variable==`i', lwidth(medium) lcolor(black)) ///
(line cf_lin_count $trend if loco==1 & $variable==`i', lpattern(shortdash) lwidth(medium) lcolor(black)) ///
(line lin_count $trend if loco==1 & $variable==`i', lpattern(solid) lwidth(medium) lcolor(black)) ///
(scatter n_births $trend if $variable==`i', msize(vsmall) mcolor(ebblue%60) msym(o)) ///
, ///
xline(731, lpattern(solid) lcolor(red) lwidth(vthin)) ///
xt("Month of Birth") ///
xlab(660(24)731, ) ///
ylab(, angle(h)) ///
yt("Number of Live Births") ///
legend(order(5 "Observed" 1 "Fitted" 2 "Deseasonalised Fitted" 3 "Deseasonalised Expected") row(1)) ///
title("{bf:`label'}", size(medsmall)) ///
plotregion(lcolor(black)) ///
name(C`i', replace) ///
scheme(white_tableau)

}

*combine plots
grc1leg2 C1 C2 C3 C4 C5 C6 , ///
legendfrom(C1) ///
position(6) lyoffset(0) lxoffset(0) ///
legscale(*1) plotregion(margin(zero)) imargin(tiny) ///
xtob1title ytol1title ///
title("United States, Parity", size(medsmall)) ///
scheme(white_tableau)

graph export "$graph/US_parity_$S_DATE.svg", replace

**# Bookmark #60


****************************************************
****************************************************
*---------------- Tables ---------------------------
*---------------- Tables ---------------------------


********** MATERNAL EDUCATION IN DETAIL **********
********** MATERNAL EDUCATION IN DETAIL **********
********** MATERNAL EDUCATION IN DETAIL **********

clear all
*
global variable "edu_mom_det" // determine group
global ts_data "$dta\US_ts_$variable.dta"
use "$ts_data", clear

tab $variable
su $variable, 
global max=r(max)
global min=r(min)
global min_1=r(min)+1
di $max
di $min
di $min_1

global trend "mdate" // insert variable names
global season "month_nr"
global tw_tm "tm"
global cutoff "2020m12"

*
preserve // get numbers for table later
collapse (sum) n_births if loco==1, by($variable)
egen total_births=sum(n_births)
gen prop= n_births/total_births
save "$dta/US_obs_$variable.dta" ,replace
restore 

****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=$min/$max {
use "$ts_data", clear
keep if $variable==`i'
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season , irr
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
gen $variable=`i'
keep $variable cf_count se_cf_count cf_count_lb cf_count_ub
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
gen $variable=`i'
keep $variable countdiff countdiff_lb countdiff_ub
save "$dta/countdiff_estimate_`i'.dta", replace
restore
}

use "$dta/cf_estimate_$min", clear
forval i=$min_1/$max {
	append using "$dta/cf_estimate_`i'"
}

merge 1:1  $variable using "$dta/US_obs_$variable.dta", nogen
order $variable n_births cf_count se_cf_count 
egen total_cf_count=sum(cf_count)
gen cf_prop=cf_count/total_cf_count
gen propdiff=prop-cf_prop
save "$dta/US_cf_estimate.dta", replace

use "$dta/countdiff_estimate_$min", clear
forval i=$min_1/$max {
	append using "$dta/countdiff_estimate_`i'"
}

merge 1:1  $variable using "$dta/US_cf_estimate.dta", nogen
order $variable n_births cf_count se_cf_count 
save "$dta/US_cf_estimate.dta", replace

*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
set seed 123456789
forval d=1/10000 {
use "$dta/US_cf_estimate.dta", clear
keep $variable cf_count se_cf_count prop
gen cf_count_i_d=rnormal(cf_count , se_cf_count) // generate random draw d from mean SE estimated from poisson ITS for each SIMD group i
egen sum_cf_count_i_d=sum(cf_count_i_d) // sum random draws d of all groups i
gen cf_prop_i_d=cf_count_i_d/sum_cf_count_i_d // create counterfactual proportion for each group i based on draw d
gen propdiff_i_d=prop- cf_prop_i_d // get m_i_d which is the difference in proportion between observed and counterfactual from draw d
keep $variable propdiff_i_d
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
_pctile propdiff_i_d if $variable==$min, percentiles(2.5) 
return list
gen propdiff_lb=r(r1) if $variable==$min
_pctile propdiff_i_d if $variable==$min, percentiles(97.5) 
return list
gen propdiff_ub=r(r1) if $variable==$min

forval i=$min_1/$max {
_pctile propdiff_i_d if $variable==`i', percentiles(2.5) 
return list
replace propdiff_lb=r(r1) if $variable==`i'
_pctile propdiff_i_d if $variable==`i', percentiles(97.5) 
return list
replace propdiff_ub=r(r1) if $variable==`i'
}

collapse propdiff_lb propdiff_ub, by($variable)
save "$dta/US_prop_uncertainty", replace
use "$dta/US_cf_estimate", clear
merge 1:1 $variable using "$dta/US_prop_uncertainty", nogen
gen country="United States"
order country $variable n_births cf_count se_cf_count cf_count_lb cf_count_ub countdiff countdiff_lb countdiff_ub prop cf_prop propdiff propdiff_lb propdiff_ub total_births total_cf_count
save "$dta/US_comp_diff_$variable", replace

**# Bookmark #61

********** FATHER'S EDUCATION IN DETAIL **********
********** FATHER'S EDUCATION IN DETAIL **********
********** FATHER'S EDUCATION IN DETAIL **********

clear all
*
global variable "dad_edu_det" // determine group
global ts_data "$dta\US_ts_$variable.dta"
use "$ts_data", clear

tab $variable
su $variable, 
global max=r(max)
global min=r(min)
global min_1=r(min)+1
di $max
di $min
di $min_1

global trend "mdate" // insert variable names
global season "month_nr"
global tw_tm "tm"
global cutoff "2020m12"

*
preserve // get numbers for table later
collapse (sum) n_births if loco==1, by($variable)
egen total_births=sum(n_births)
gen prop= n_births/total_births
save "$dta/US_obs_$variable.dta" ,replace
restore 

****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=$min/$max {
use "$ts_data", clear
keep if $variable==`i'
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season , irr
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
gen $variable=`i'
keep $variable cf_count se_cf_count cf_count_lb cf_count_ub
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
gen $variable=`i'
keep $variable countdiff countdiff_lb countdiff_ub
save "$dta/countdiff_estimate_`i'.dta", replace
restore
}

use "$dta/cf_estimate_$min", clear
forval i=$min_1/$max {
	append using "$dta/cf_estimate_`i'"
}

merge 1:1  $variable using "$dta/US_obs_$variable.dta", nogen
order $variable n_births cf_count se_cf_count 
egen total_cf_count=sum(cf_count)
gen cf_prop=cf_count/total_cf_count
gen propdiff=prop-cf_prop
save "$dta/US_cf_estimate.dta", replace

use "$dta/countdiff_estimate_$min", clear
forval i=$min_1/$max {
	append using "$dta/countdiff_estimate_`i'"
}

merge 1:1  $variable using "$dta/US_cf_estimate.dta", nogen
order $variable n_births cf_count se_cf_count 
save "$dta/US_cf_estimate.dta", replace

*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
set seed 123456789
forval d=1/10000 {
use "$dta/US_cf_estimate.dta", clear
keep $variable cf_count se_cf_count prop
gen cf_count_i_d=rnormal(cf_count , se_cf_count) // generate random draw d from mean SE estimated from poisson ITS for each SIMD group i
egen sum_cf_count_i_d=sum(cf_count_i_d) // sum random draws d of all groups i
gen cf_prop_i_d=cf_count_i_d/sum_cf_count_i_d // create counterfactual proportion for each group i based on draw d
gen propdiff_i_d=prop- cf_prop_i_d // get m_i_d which is the difference in proportion between observed and counterfactual from draw d
keep $variable propdiff_i_d
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
_pctile propdiff_i_d if $variable==$min, percentiles(2.5) 
return list
gen propdiff_lb=r(r1) if $variable==$min
_pctile propdiff_i_d if $variable==$min, percentiles(97.5) 
return list
gen propdiff_ub=r(r1) if $variable==$min

forval i=$min_1/$max {
_pctile propdiff_i_d if $variable==`i', percentiles(2.5) 
return list
replace propdiff_lb=r(r1) if $variable==`i'
_pctile propdiff_i_d if $variable==`i', percentiles(97.5) 
return list
replace propdiff_ub=r(r1) if $variable==`i'
}

collapse propdiff_lb propdiff_ub, by($variable)
save "$dta/US_prop_uncertainty", replace
use "$dta/US_cf_estimate", clear
merge 1:1 $variable using "$dta/US_prop_uncertainty", nogen
gen country="United States"
order country $variable n_births cf_count se_cf_count cf_count_lb cf_count_ub countdiff countdiff_lb countdiff_ub prop cf_prop propdiff propdiff_lb propdiff_ub total_births total_cf_count
save "$dta/US_comp_diff_$variable", replace

**# Bookmark #62

********** FATHER'S EDUCATION COMPARATIVE **********
********** FATHER'S EDUCATION COMPARATIVE **********
********** FATHER'S EDUCATION COMPARATIVE **********

clear all
*
global variable "dad_edu_comp" // determine group
global ts_data "$dta\US_ts_$variable.dta"
use "$ts_data", clear

tab $variable
su $variable, 
global max=r(max)
global min=r(min)
global min_1=r(min)+1
di $max
di $min
di $min_1

global trend "mdate" // insert variable names
global season "month_nr"
global tw_tm "tm"
global cutoff "2020m12"

*
preserve // get numbers for table later
collapse (sum) n_births if loco==1, by($variable)
egen total_births=sum(n_births)
gen prop= n_births/total_births
save "$dta/US_obs_$variable.dta" ,replace
restore 

****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=$min/$max {
use "$ts_data", clear
keep if $variable==`i'
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season , irr
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
gen $variable=`i'
keep $variable cf_count se_cf_count cf_count_lb cf_count_ub
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
gen $variable=`i'
keep $variable countdiff countdiff_lb countdiff_ub
save "$dta/countdiff_estimate_`i'.dta", replace
restore
}

use "$dta/cf_estimate_$min", clear
forval i=$min_1/$max {
	append using "$dta/cf_estimate_`i'"
}

merge 1:1  $variable using "$dta/US_obs_$variable.dta", nogen
order $variable n_births cf_count se_cf_count 
egen total_cf_count=sum(cf_count)
gen cf_prop=cf_count/total_cf_count
gen propdiff=prop-cf_prop
save "$dta/US_cf_estimate.dta", replace

use "$dta/countdiff_estimate_$min", clear
forval i=$min_1/$max {
	append using "$dta/countdiff_estimate_`i'"
}

merge 1:1  $variable using "$dta/US_cf_estimate.dta", nogen
order $variable n_births cf_count se_cf_count 
save "$dta/US_cf_estimate.dta", replace

*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
set seed 123456789
forval d=1/10000 {
use "$dta/US_cf_estimate.dta", clear
keep $variable cf_count se_cf_count prop
gen cf_count_i_d=rnormal(cf_count , se_cf_count) // generate random draw d from mean SE estimated from poisson ITS for each SIMD group i
egen sum_cf_count_i_d=sum(cf_count_i_d) // sum random draws d of all groups i
gen cf_prop_i_d=cf_count_i_d/sum_cf_count_i_d // create counterfactual proportion for each group i based on draw d
gen propdiff_i_d=prop- cf_prop_i_d // get m_i_d which is the difference in proportion between observed and counterfactual from draw d
keep $variable propdiff_i_d
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
_pctile propdiff_i_d if $variable==$min, percentiles(2.5) 
return list
gen propdiff_lb=r(r1) if $variable==$min
_pctile propdiff_i_d if $variable==$min, percentiles(97.5) 
return list
gen propdiff_ub=r(r1) if $variable==$min

forval i=$min_1/$max {
_pctile propdiff_i_d if $variable==`i', percentiles(2.5) 
return list
replace propdiff_lb=r(r1) if $variable==`i'
_pctile propdiff_i_d if $variable==`i', percentiles(97.5) 
return list
replace propdiff_ub=r(r1) if $variable==`i'
}

collapse propdiff_lb propdiff_ub, by($variable)
save "$dta/US_prop_uncertainty", replace
use "$dta/US_cf_estimate", clear
merge 1:1 $variable using "$dta/US_prop_uncertainty", nogen
gen country="United States"
order country $variable n_births cf_count se_cf_count cf_count_lb cf_count_ub countdiff countdiff_lb countdiff_ub prop cf_prop propdiff propdiff_lb propdiff_ub total_births total_cf_count
save "$dta/US_comp_diff_$variable", replace

**# Bookmark #63
******** MATERNAL AGE **********
******** MATERNAL AGE **********
******** MATERNAL AGE **********
******** MATERNAL AGE **********

clear all
*
global variable "mom_age_cat" // determine group
global ts_data "$dta\US_ts_$variable.dta"
use "$ts_data", clear

tab $variable
su $variable, 
global max=r(max)
global min=r(min)
global min_1=r(min)+1
di $max
di $min
di $min_1

global trend "mdate" // insert variable names
global season "month_nr"
global tw_tm "tm"
global cutoff "2020m12"

*
preserve // get numbers for table later
collapse (sum) n_births if loco==1, by($variable)
egen total_births=sum(n_births)
gen prop= n_births/total_births
save "$dta/US_obs_$variable.dta" ,replace
restore 

****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=$min/$max {
use "$ts_data", clear
keep if $variable==`i'
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season , irr
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
gen $variable=`i'
keep $variable cf_count se_cf_count cf_count_lb cf_count_ub
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
gen $variable=`i'
keep $variable countdiff countdiff_lb countdiff_ub
save "$dta/countdiff_estimate_`i'.dta", replace
restore
}

use "$dta/cf_estimate_$min", clear
forval i=$min_1/$max {
	append using "$dta/cf_estimate_`i'"
}

merge 1:1  $variable using "$dta/US_obs_$variable.dta", nogen
order $variable n_births cf_count se_cf_count 
egen total_cf_count=sum(cf_count)
gen cf_prop=cf_count/total_cf_count
gen propdiff=prop-cf_prop
save "$dta/US_cf_estimate.dta", replace

use "$dta/countdiff_estimate_$min", clear
forval i=$min_1/$max {
	append using "$dta/countdiff_estimate_`i'"
}

merge 1:1  $variable using "$dta/US_cf_estimate.dta", nogen
order $variable n_births cf_count se_cf_count 
save "$dta/US_cf_estimate.dta", replace

*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
set seed 123456789
forval d=1/10000 {
use "$dta/US_cf_estimate.dta", clear
keep $variable cf_count se_cf_count prop
gen cf_count_i_d=rnormal(cf_count , se_cf_count) // generate random draw d from mean SE estimated from poisson ITS for each SIMD group i
egen sum_cf_count_i_d=sum(cf_count_i_d) // sum random draws d of all groups i
gen cf_prop_i_d=cf_count_i_d/sum_cf_count_i_d // create counterfactual proportion for each group i based on draw d
gen propdiff_i_d=prop- cf_prop_i_d // get m_i_d which is the difference in proportion between observed and counterfactual from draw d
keep $variable propdiff_i_d
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
_pctile propdiff_i_d if $variable==$min, percentiles(2.5) 
return list
gen propdiff_lb=r(r1) if $variable==$min
_pctile propdiff_i_d if $variable==$min, percentiles(97.5) 
return list
gen propdiff_ub=r(r1) if $variable==$min

forval i=$min_1/$max {
_pctile propdiff_i_d if $variable==`i', percentiles(2.5) 
return list
replace propdiff_lb=r(r1) if $variable==`i'
_pctile propdiff_i_d if $variable==`i', percentiles(97.5) 
return list
replace propdiff_ub=r(r1) if $variable==`i'
}

collapse propdiff_lb propdiff_ub, by($variable)
save "$dta/US_prop_uncertainty", replace
use "$dta/US_cf_estimate", clear
merge 1:1 $variable using "$dta/US_prop_uncertainty", nogen
gen country="United States"
order country $variable n_births cf_count se_cf_count cf_count_lb cf_count_ub countdiff countdiff_lb countdiff_ub prop cf_prop propdiff propdiff_lb propdiff_ub total_births total_cf_count
save "$dta/US_comp_diff_$variable", replace

**# Bookmark #64

******** PARITY  **********
******** PARITY  **********
******** PARITY  **********
******** PARITY  **********

clear all
*
global variable "parity" // determine group
global ts_data "$dta\US_ts_$variable.dta"
use "$ts_data", clear

tab $variable
su $variable, 
global max=r(max)
global min=r(min)
global min_1=r(min)+1
di $max
di $min
di $min_1

global trend "mdate" // insert variable names
global season "month_nr"
global tw_tm "tm"
global cutoff "2020m12"

*
preserve // get numbers for table later
collapse (sum) n_births if loco==1, by($variable)
egen total_births=sum(n_births)
gen prop= n_births/total_births
save "$dta/US_obs_$variable.dta" ,replace
restore 

****** ESTIMATE COUNTERFACTUAL NUMBER OF BIRTHS*******
forval i=$min/$max {
use "$ts_data", clear
keep if $variable==`i'
poisson n_births i.loco c.$trend c.$trend#c.$trend i.$season , irr
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
gen $variable=`i'
keep $variable cf_count se_cf_count cf_count_lb cf_count_ub
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
gen $variable=`i'
keep $variable countdiff countdiff_lb countdiff_ub
save "$dta/countdiff_estimate_`i'.dta", replace
restore
}

use "$dta/cf_estimate_$min", clear
forval i=$min_1/$max {
	append using "$dta/cf_estimate_`i'"
}

merge 1:1  $variable using "$dta/US_obs_$variable.dta", nogen
order $variable n_births cf_count se_cf_count 
egen total_cf_count=sum(cf_count)
gen cf_prop=cf_count/total_cf_count
gen propdiff=prop-cf_prop
save "$dta/US_cf_estimate.dta", replace

use "$dta/countdiff_estimate_$min", clear
forval i=$min_1/$max {
	append using "$dta/countdiff_estimate_`i'"
}

merge 1:1  $variable using "$dta/US_cf_estimate.dta", nogen
order $variable n_births cf_count se_cf_count 
save "$dta/US_cf_estimate.dta", replace

*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
*********** GENERATE UNCERTAINTY ESTIMATES*************
set seed 123456789
forval d=1/10000 {
use "$dta/US_cf_estimate.dta", clear
keep $variable cf_count se_cf_count prop
gen cf_count_i_d=rnormal(cf_count , se_cf_count) // generate random draw d from mean SE estimated from poisson ITS for each SIMD group i
egen sum_cf_count_i_d=sum(cf_count_i_d) // sum random draws d of all groups i
gen cf_prop_i_d=cf_count_i_d/sum_cf_count_i_d // create counterfactual proportion for each group i based on draw d
gen propdiff_i_d=prop- cf_prop_i_d // get m_i_d which is the difference in proportion between observed and counterfactual from draw d
keep $variable propdiff_i_d
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
_pctile propdiff_i_d if $variable==$min, percentiles(2.5) 
return list
gen propdiff_lb=r(r1) if $variable==$min
_pctile propdiff_i_d if $variable==$min, percentiles(97.5) 
return list
gen propdiff_ub=r(r1) if $variable==$min

forval i=$min_1/$max {
_pctile propdiff_i_d if $variable==`i', percentiles(2.5) 
return list
replace propdiff_lb=r(r1) if $variable==`i'
_pctile propdiff_i_d if $variable==`i', percentiles(97.5) 
return list
replace propdiff_ub=r(r1) if $variable==`i'
}

collapse propdiff_lb propdiff_ub, by($variable)
save "$dta/US_prop_uncertainty", replace
use "$dta/US_cf_estimate", clear
merge 1:1 $variable using "$dta/US_prop_uncertainty", nogen
gen country="United States"
order country $variable n_births cf_count se_cf_count cf_count_lb cf_count_ub countdiff countdiff_lb countdiff_ub prop cf_prop propdiff propdiff_lb propdiff_ub total_births total_cf_count
save "$dta/US_comp_diff_$variable", replace

**# Bookmark #65

************** US TABLE ***************
************** US TABLE ***************
************** US TABLE ***************

use "$dta/US_comp_diff_edu_mom_det", clear
append using "$dta/US_comp_diff_dad_edu_det"
append using "$dta/US_comp_diff_dad_edu_comp"
append using "$dta/US_comp_diff_mom_age_cat"
append using "$dta/US_comp_diff_parity"
gen rel_count_diff=(n_births-cf_count)/(abs(cf_count))*100
gen rel_count_diff_ub=(n_births-cf_count_lb)/(abs(cf_count_lb))*100
gen rel_count_diff_lb=(n_births-cf_count_ub)/(abs(cf_count_ub))*100
order country edu_mom_det dad_edu_det dad_edu_comp mom_age_cat parity n_births cf_count se_cf_count cf_count_lb cf_count_ub countdiff countdiff_lb countdiff_ub rel_count_diff rel_count_diff_lb rel_count_diff_ub prop cf_prop propdiff propdiff_lb propdiff_ub total_births total_cf_count

drop se_cf_count
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

order country edu_mom_det dad_edu_det dad_edu_comp mom_age_cat parity n_births cf_count  cf_count_ci countdiff countdiff_ci  rel_count_diff rel_diff_ci prop cf_prop propdiff propdiff_ci total_births total_cf_count

save "$dta/US_table_profile_$S_DATE", replace
export excel using "$table\US_table_profile_$S_DATE.xls", firstrow(variables) replace


**# Bookmark #66

***************** SOUTH AUSTRALIA *******************
***************** SOUTH AUSTRALIA *******************
***************** SOUTH AUSTRALIA *******************
***************** SOUTH AUSTRALIA *******************

* Q5 area deprivation
graph use "C:\Users\moritzob\OneDrive - University of Helsinki\postdoc life helsinki\LoCo-effect\LoCo-effect Australia\AUS_area_deprivationQ5_IRSAD2016.gph"

graph export "$graph/AUS_area_depr_Q5_$S_DATE.svg",replace


* DEC 10 - secondary sec variable
graph use "C:\Users\moritzob\OneDrive - University of Helsinki\postdoc life helsinki\LoCo-effect\LoCo-effect Australia\AUS_area_deprivationQ10_IRSAD2016.gph"

graph export "$graph/AUS_area_depr_D10_$S_DATE.svg",replace

* Mom age	
graph use "C:\Users\moritzob\OneDrive - University of Helsinki\postdoc life helsinki\LoCo-effect\LoCo-effect Australia\AUS_mom_age.gph"

graph export "$graph/AUS_mom_age_$S_DATE.svg",replace

*Table
import delimited "C:\Users\moritzob\OneDrive - University of Helsinki\postdoc life helsinki\LoCo-effect\LoCo-effect Australia\export 12122024\AUS_comp_diff_area_deprivation_dec_IRSAD2016.csv", clear 

save "$dta/AUS_comp_diff_area_deprivation10.dta",replace

import delimited "C:\Users\moritzob\OneDrive - University of Helsinki\postdoc life helsinki\LoCo-effect\LoCo-effect Australia\export 09122024\AUS_comp_diff_mom_age_cat.csv",clear

save "$dta/AUS_comp_diff_mom_age_cat.dta",replace

use "$dta/AUS_comp_diff_area_deprivation10", clear
append using "$dta/AUS_comp_diff_mom_age_cat"

gen rel_count_diff=(n_births-cf_count)/(abs(cf_count))*100
gen rel_count_diff_ub=(n_births-cf_count_lb)/(abs(cf_count_lb))*100
gen rel_count_diff_lb=(n_births-cf_count_ub)/(abs(cf_count_ub))*100
order country area_deprivation_dec mom_age_cat  n_births cf_count se_cf_count cf_count_lb cf_count_ub countdiff countdiff_lb countdiff_ub rel_count_diff rel_count_diff_lb rel_count_diff_ub prop cf_prop propdiff propdiff_lb propdiff_ub total_births total_cf_count

drop se_cf_count
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

order country area_deprivation_dec mom_age_cat  n_births cf_count  cf_count_ci countdiff countdiff_ci  rel_count_diff rel_diff_ci prop cf_prop propdiff propdiff_ci total_births total_cf_count

save "$dta/AUS_table_profile_$S_DATE", replace
export excel using "$table\AUS_table_profile_$S_DATE.xls", firstrow(variables) replace


* Last line; you did it.

