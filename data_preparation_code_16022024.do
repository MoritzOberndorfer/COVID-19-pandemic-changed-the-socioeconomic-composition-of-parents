/*
Have social inequalities in the COVID-19 pandemic's impact produced a selected birth cohort?
A comparison of changes in parental socioeconomic composition using population-wide administrative data of 12 countries

Code: Moritz Oberndorfer

Code for:
Data preparation for all countries in alphabetical order


*/

**# Bookmark #1
************************* AUSTRIA ******************************

**# Bookmark #1
import sas using "$dta\moritz.sas7bdat", clear

* time vars
gen mdate=ym(GEBJAHR_K, GEBMONAT_K)
format mdate %tm

gen loco=0
replace loco=1 if mdate>=tm(2020m12)

rename GEBMONAT_K month_nr
tab GEBJAHR_K,m
rename GEBJAHR_K year

****** EDUCATION **********

tab BILDUNG_M, m

gen mom_edu=.
replace mom_edu=1 if BILDUNG_M==1 // Compulsory school (ISCED 2 - lower secondary school)
replace mom_edu=2 if BILDUNG_M==2 // Apprenticeship (ISCED 3)
replace mom_edu=3 if BILDUNG_M==3 // Intermediate technical & vocational school (ISCED 3)
replace mom_edu=4 if BILDUNG_M==4 // Academic upper secondary school (ISCED 3)
replace mom_edu=5 if BILDUNG_M==5 // College for higher vocational education (ISCED 3)
replace mom_edu=6 if BILDUNG_M==6 //  Post-secondary non-tertiary vocational (ISCED 5) "Kolleg"
replace mom_edu=7 if BILDUNG_M==7 //  Post-secondary non-tertiary academic courses at tertiary institutions (ISCED 5) "Akademie"
replace mom_edu=8 if BILDUNG_M==8 //  Bachelor's, Master's, Doctoral (ISCED 6-8))
replace mom_edu=9 if BILDUNG_M==90 |  BILDUNG_M==95  //  Unknwon or not collected

tab mom_edu, m

label define edulab 1 "Compulsory school" 2 "Apprenticeship" 3 "Technical & vocational school" 4 "Academic upper secondary school" 5 "College for higher vocational education" 6 "Post-second. technical & vocational" 7 "Post-second. non-tert. academic" 8 "Tertiary (ISCED 6-8)" 9 "Unknown or not collected"

label values mom_edu edulab
tab mom_edu, m

*** COMPARATIVE EDU
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
tab mom_edu_comp, m


****** EDUCATION DAD **********

tab BILDUNG_V, m

gen dad_edu=.
replace dad_edu=1 if BILDUNG_V==1 // Compulsory school (ISCED 2 - lower secondary school)
replace dad_edu=2 if BILDUNG_V==2 // Apprenticeship (ISCED 3)
replace dad_edu=3 if BILDUNG_V==3 // Intermediate technical & vocational school (ISCED 3)
replace dad_edu=4 if BILDUNG_V==4 // Academic upper secondary school (ISCED 3)
replace dad_edu=5 if BILDUNG_V==5 // College for higher vocational education (ISCED 3)
replace dad_edu=6 if BILDUNG_V==6 //  Post-secondary non-tertiary vocational (ISCED 5) "Kolleg"
replace dad_edu=7 if BILDUNG_V==7 //  Post-secondary non-tertiary academic courses at tertiary institutions (ISCED 5) "Akademie"
replace dad_edu=8 if BILDUNG_V==8 //  Bachelor's, Master's, Doctoral (ISCED 6-8))
replace dad_edu=9 if BILDUNG_V==90 |  BILDUNG_V==95 | BILDUNG_V==99  //  Unknwon or not collected

tab dad_edu, m


label values dad_edu edulab
tab dad_edu, m


*** COMPARATIVE EDU
gen dad_edu_comp=. 
replace dad_edu_comp=1 if BILDUNG_V==1 // Compulsory school (ISCED 2 - lower secondary school)
replace dad_edu_comp=2 if BILDUNG_V==2 // Apprenticeship (ISCED 3)
replace dad_edu_comp=3 if BILDUNG_V==3 // Intermediate technical & vocational school (ISCED 3)
replace dad_edu_comp=4 if BILDUNG_V==4 // Academic upper secondary school (ISCED 3)
replace dad_edu_comp=5 if BILDUNG_V>4 & BILDUNG_V<9 // College for higher vocational edu, post-secondary vocational, post-secondary academic, Bachelor's, Master's, PhD
replace dad_edu_comp=6 if BILDUNG_V==90 |  BILDUNG_V==95  | BILDUNG_V==99 //  Unknwon or not collected

tab dad_edu_comp, m
label values dad_edu_comp edulab2
tab dad_edu_comp, m

*highest of mom and dad
gen mom_dad_edu_comp=mom_edu_comp
replace mom_dad_edu_comp=dad_edu_comp if dad_edu_comp>mom_edu_comp & dad_edu_comp!=6 // take dad's edu if his edu is higher than mom's and his is not missing
replace mom_dad_edu_comp=dad_edu_comp if dad_edu_comp!=6 & mom_edu_comp==6 // take dad edu if mom's missing
* none
tab mom_dad_edu_comp,m
tab mom_edu_comp,m
label values mom_dad_edu_comp edulab2


** MATERNAL AGE ************

tab ALTER_M, m
gen mom_age = ALTER_M
gen mom_age_cat = 1 if mom_age <20
replace mom_age_cat =2 if mom_age >19 & mom_age <25
replace mom_age_cat =3 if mom_age >24 &  mom_age<30
replace mom_age_cat =4 if mom_age >29 &  mom_age<35
replace mom_age_cat =5 if mom_age >34

tab mom_age_cat, m
label define age_lab 1 "Maternal Age Under 20" 2 "20-24" 3 "25-29" 4 "30-34" 5 "35 and Above" 6 "Missing information"
label values mom_age_cat age_lab
tab mom_age_cat,m 


*** parity****

gen parity=.
replace parity=1 if GEBF_LEB <2 // there is 0 and 1 which is both first born so parity 0. 0 has only 0.16 percent, so most likely an error in birth certificate
replace parity=2 if GEBF_LEB==2
replace parity=3 if GEBF_LEB==3
replace parity=4 if GEBF_LEB==4
replace parity=5 if GEBF_LEB>4

tab parity, m
label define parlab 1 "0 Parity" 2 "1" 3 "2" 4 "3" 5 "4 or more" 
label values parity parlab
tab parity,m 


save "$dta/Austria_births_2015", replace

**# Bookmark #2
************************* Brazil ******************************

/* GET INDIVIDUAL LEVEL DATA FROM
https://opendatasus.saude.gov.br/dataset/sistema-de-informacao-sobre-nascidos-vivos-sinasc
*/
clear all
import delimited "$dta/SINASC_2015.csv", clear
clear all
forval i=15/21 {
	import delimited  "$dta/SINASC_20`i'.csv", clear
	save "$dta/SINASC_20`i'.dta", replace
}

use "$dta/SINASC_2015.dta", clear

append using "$dta/SINASC_2016.dta", force // 
append using "$dta/SINASC_2017.dta", force //
append using "$dta/SINASC_2018.dta", force // 
append using "$dta/SINASC_2019.dta", force // 
append using "$dta/SINASC_2020.dta", force // 
append using "$dta/SINASC_2021.dta", force // 


save "$dta/SINASC_2015_2021_0611.dta", replace
**date of birth 
count if dtnasc==.
tostring dtnasc, replace format(%20.0f)
replace dtnasc = "0" + dtnasc if length(dtnasc) == 7
gen bdate_child = date(dtnasc,"DMY")
format bdate_child %td
count if bdate_child==.

gen bdate_w=wofd(bdate_child)
format bdate_w %tw
gen bdate_m=mofd(bdate_child)
format bdate_m %tm

gen bweek=week(bdate_child)

gen bmonth=month(bdate_child)
gen year=year(bdate_child)

tab year, m

/* tab year, m

       year |      Freq.     Percent        Cum.
------------+-----------------------------------
       2015 |  3,017,668       15.09       15.09
       2016 |  2,857,800       14.29       29.38
       2017 |  2,923,535       14.62       43.99
       2018 |  2,944,932       14.72       58.72
       2019 |  2,849,146       14.25       72.96
       2020 |  2,730,145       13.65       86.61
       2021 |  2,677,101       13.39      100.00
------------+-----------------------------------
      Total | 20,000,327      100.00
*/

*SAME AS TIME SERIES DATA!!! YESS



*** data prep ***
*translate a few*
gen mom_age=idademae
replace mom_age=. if mom_age==99 // implausible age
gen mom_age_cat = 1 if mom_age <20
replace mom_age_cat =2 if mom_age >19 & mom_age <25
replace mom_age_cat =3 if mom_age >24 &  mom_age<30
replace mom_age_cat =4 if mom_age >29 &  mom_age<35
replace mom_age_cat =5 if mom_age >34
replace mom_age_cat =. if idademae==. | idademae==99


tab estcivmae,m
gen mom_marital_status= estcivmae
tab mom_marital_status, m
label define ms_lab 1 "Single" 2 "Married" 3 "Widow" 4 "Divorced" 5 "Consensual union" 9 "Ignored"
label values mom_marital_status ms_lab
tab mom_marital_status, m

tab escmae,m 
gen mom_edu_years=escmae
label define edu_y 1 "None" 2 "1 to 3 years" 3 "4 to 7 years" 4 "8 to 11 years" 5 "12 and more years" 9 "Ignored"
label values mom_edu_years edu_y
tab mom_edu_years,m 

tab qtdfilvivo,m 
gen parity=qtdfilvivo
tab parity,m
replace parity=. if parity==99 // implausible value
replace parity =4 if parity >=4 & parity!=.
tab parity,m

tab gestacao, m
gen gestation=gestacao
label define gest_lab 1 "Less than 22 weeks" 2 "22 to 27 weeks" 3 "28 to 31 weeks" 4 "32 to 36 weeks" 5 "37 to 41 weeks" 6 "42 weeks and more" 9 "Ignored"
label values gestation gest_lab
tab gestation,m


tab gravidez,m 
gen singleton=gravidez
label define singl_lab 1 "Singleton" 2 "Twins" 3 "Triplets or more" 9 "Ignored"
label values singleton singl_lab
tab singleton, m

tab racacor,m 
gen mom_ethn=racacor
label define ethn_lab 1 "White" 2 "Black" 3 "Yellow" 4 "Mixed" 5 "Indigenous"
label values mom_ethn ethn_lab
tab mom_ethn, m

sum peso, d
hist peso
gen birthweight=peso
replace birthweight=. if peso==9999
sum birthweight, d


gen loco_w=0
replace loco_w =1 if bdate_w>=tw(2020w51)

*codmunres is mother's municapality of residence
gen cod_municipio=codmunres

** prep Brazil Deprivation Index **
* cod_municipo same as codmunres in SINACS?
/*
** prep Brazil Deprivation Index **
* cod_municipo same as codmunres in SINACS?

import delimited https://researchdata.gla.ac.uk/980/1/Deprivation_Brazil_2010_CensusSectors.csv,  clear 

save "$dta/BPI_2010.dta", replace
use "$dta/BPI_2010.dta", clear

*** aggregate to municipality level

* take the brazdep_measure, average over cod_municipio
*but should probably be an average weighted by population size v001p13 of the cod_sector

bysort cod_municipio: egen total_pop=sum(v001p13) // total pop of municapality
gen popshare = v001p13/total_pop // share of pop for each cod sector
bysort cod_municipio: egen sum1=sum(popshare) // just to check

replace brazdep_measure="" if brazdep_measure=="NA"
destring brazdep_measure, gen(bpi) 
gen brazdep_x_pop= bpi * popshare
bysort cod_municipio: egen bpi_muncipio=sum(brazdep_x_pop)
codebook bpi_muncipio // 5,564 unique values. nice

*aggregate to muncipalities
*duplicates report bpi_muncipio cod_municipio
keep bpi_muncipio nome_do_municipio nome_da_uf nome_grande_regiao cod_uf cod_municipio
duplicates drop  bpi_muncipio cod_municipio, force
*collapse bpi_muncipio (keep) nome_do_municipio nome_da_uf nome_grande_regiao cod_uf, by(cod_municipio)

xtile bpi_quint=bpi_muncipio, nq(5)
tab bpi_quint,m 
xtile bpi_dec=bpi_muncipio, nq(10)
tab bpi_dec,m 
*cut last digit so it merges with SINASC
rename cod_municipio cod_municipio_bpi
tostring cod_municipio_bpi, gen(cod_municipio_str)

gen  cod_municipio = substr(cod_municipio_str, 1, length(cod_municipio_str) - 1)
destring cod_municipio, replace
codebook cod_municipio

save "$dta/muncipio_bpi_2010.dta", replace

use "$dta/Births_2015_2021_AC_TO.dta", clear

merge m:1 cod_municipio using "$dta/muncipio_bpi_2010.dta"
save "$dta/Births_2015_2021_AC_TO.dta", replace


*try ranks of municapalities
import excel "$dta\Ranking-IBP_Brasil_Municipios_01122020.xls", sheet("Planilha1") firstrow clear

save "$dta/rank_municipio_2020.dta", replace
* also doesn't match, so we need to aggregate to municapality level in BPI_2010


*/
merge m:1 cod_municipio using "$dta/muncipio_bpi_2010.dta", 
* 5099 not matched. very decent
drop _merge


save "$dta/SINASC_2015_2021_0611.dta", replace




**# Bookmark #3
************************* Colombia ******************************
/*** import csv for each year and merge together
Data openly available from DANE. LINK:
https://microdatos.dane.gov.co/index.php/catalog/DEM-Microdatos#_r=1700214975152&collection=&country=&dtype=&from=2015&page=1&ps=&sid=&sk=&sort_by=title&sort_order=&to=2023&topic=&view=s&vk=
*/

forval i=2015/2021 {
	import delimited "$dta/nac`i'.csv", clear
	save "$dta/nac`i'.dta", replace
}

use "$dta/nac2015.dta", clear
forval i=2016/2021 {
append using "$dta/nac`i'.dta"
}

/* DATA DICTONIARY**
https://microdatos.dane.gov.co/index.php/catalog/696/data-dictionary/F21?file_name=nac2019
(used google translate)
We will use: year of birth, month of birth, mom age, mom edu, dad edu, ethnicity, parity
*/

*year of birth - ano
rename ano year

*month of birth - mes
rename mes month_nr
gen mdate=ym(year, month_nr)
format mdate %tm
tab mdate, m

/*ethnicity identified by parents - idpertet
1 = Indigenous
2 = Rom (Gypsy)
3 = Raizal of the San Andrés and Providencia archipelago
4 = Palenquero of San Basilio
5 = black (a ), mulatto, Afro-Colombian or Afro-descendant
6 = None of the above
9 = No information
*/
tab idpertet,m 
gen baby_ethn=idpertet
label define ethnlab 1 "Indigenous" 2 "Rom (Gitano)" 3 "Raizal of the San Andrés and Providencia archipelago" 4 "Palenquero of San Basilio" 5 "Black, mixed, Afro-Colombian, Afro-descendant" 6 "None of these" 9 "No information"
label values baby_ethn ethnlab
tab baby_ethn, m
/*Age of mother at birth - edad_madre
1 = 10-14 Years
2 = 15-19 Years
3 = 20-24 Years
4 = 25-29 Years
5 = 30-34 Years
6 = 35-39 Years
7 = 40-44 Years
8 = 45-49 Years
9 = 50-54 Years
99 = No information
*/
tab edad_madre, m

gen mom_age_cat=.
replace mom_age_cat= 1 if edad_madre==1
replace mom_age_cat= 1 if edad_madre==2
replace mom_age_cat= 2 if edad_madre==3
replace mom_age_cat= 3 if edad_madre==4
replace mom_age_cat= 4 if edad_madre==5
replace mom_age_cat= 5 if edad_madre>=6 
replace mom_age_cat= 6 if edad_madre==99

label define age_lab 1 "Maternal Age Under 20" 2 "20-24" 3 "25-29" 4 "30-34" 5 "35 and Above" 6 "Missing information"
label values mom_age_cat age_lab
tab mom_age_cat,m 


/*Mother's education - niv_edum
1 = Preescolar
2 = Básica primaria
3 = Básica secundaria
4 = Media académica o clásica
5 = Media técnica
6 = Normalista
7 = Técnica profesional
8 = Tecnológica
9 = Profesional
10 = Especialización
11 = Maestría
12 = Doctorado
13 = Ninguno
99 = Sin información
*OECD info about educational system
https://gpseducation.oecd.org/CountryProfile?primaryCountry=COL&treshold=5&topic=EO
*/

tab niv_edum year,m 
tab niv_edum mdate if year==2021
gen mom_edu=.
replace mom_edu=1 if niv_edum==1 // Pre-school ISCED 020
replace mom_edu=1 if niv_edum==2 // Primary school ISCED 1
replace mom_edu=1 if niv_edum==13 // None

replace mom_edu=2 if niv_edum==3 // Lower secondary ISCED 2
replace mom_edu=3 if niv_edum==4 // Upper secondary ISCED 3
replace mom_edu=3 if niv_edum==5 // Upper secondary ISCED 3

replace mom_edu=4 if niv_edum==6 // ISCED 4 2.5 years post-secondary = Normalista
replace mom_edu=4 if niv_edum==7 // ISCED 5 2 year short cycle tertiary = Técnica profesional
replace mom_edu=4 if niv_edum==8 // ISCED 5 2 year short cycle tertiary = Tecnológica

replace mom_edu=5 if niv_edum==9 // ISCED ? Profesional

replace mom_edu=6 if niv_edum==10 // ISCED 7 Especialización, 
replace mom_edu=6 if niv_edum==11 // ISCED 7 Maestria
replace mom_edu=6 if niv_edum==12 // ISCED 8 Doctorado

replace mom_edu=7 if niv_edum==99 // Missing information

label define edulab 1 "Primary school or lower" 2 "Lower secondary" 3 "Upper secondary" 4 "Post-secondary & short-cycle tertiary" 5 "Profesional" 6 "Equivalent to Master's or Doctorate" 7 "Missing information"

label values mom_edu edulab
tab mom_edu, m
tab mdate mom_edu if year==2020, m


*alternatively "ultcurmad" - not sure what it means

** Maternal education comparative

gen mom_edu_comp=.
replace mom_edu_comp=1 if mom_edu ==1 | mom_edu==2 // primary or secondary
replace mom_edu_comp=2 if mom_edu ==3  // upper secondary
replace mom_edu_comp=3 if mom_edu >3 & mom_edu<7  // post secondary
replace mom_edu_comp=4 if mom_edu==7  // post secondary
label define edulab2 1 "Primary or lower secondary" 2 "Upper secondary" 3 "Post-secondary; tertiary" 4 "Missing information"
label values mom_edu_comp edulab2

tab mom_edu_comp,m



/*Father's education - niv_edup*/

tab niv_edup year,m 
tab niv_edup mdate if year==2021
gen dad_edu=.
replace dad_edu=1 if niv_edup==1 // Pre-school ISCED 020
replace dad_edu=1 if niv_edup==2 // Primary school ISCED 1
replace dad_edu=1 if niv_edup==13 // None

replace dad_edu=2 if niv_edup==3 // Lower secondary ISCED 2
replace dad_edu=3 if niv_edup==4 // Upper secondary ISCED 3
replace dad_edu=3 if niv_edup==5 // Upper secondary ISCED 3

replace dad_edu=4 if niv_edup==6 // ISCED 4 2.5 years post-secondary = Normalista
replace dad_edu=4 if niv_edup==7 // ISCED 5 2 year short cycle tertiary = Técnica profesional
replace dad_edu=4 if niv_edup==8 // ISCED 5 2 year short cycle tertiary = Tecnológica

replace dad_edu=5 if niv_edup==9 // ISCED ? Profesional

replace dad_edu=6 if niv_edup==10 // ISCED 7 Especialización, 
replace dad_edu=6 if niv_edup==11 // ISCED 7 Maestria
replace dad_edu=6 if niv_edup==12 // ISCED 8 Doctorado

replace dad_edu=7 if niv_edup==99 // Missing information

label values dad_edu edulab
tab dad_edu, m
tab mdate dad_edu if year==2020, m

** Paternal education comparative


gen dad_edu_comp=.
replace dad_edu_comp=1 if dad_edu ==1 | dad_edu==2 // primary or secondary
replace dad_edu_comp=2 if dad_edu ==3  // upper secondary
replace dad_edu_comp=3 if dad_edu >3 & dad_edu<7  // post secondary
replace dad_edu_comp=4 if dad_edu==7  // post secondary
label values dad_edu_comp edulab2

tab dad_edu_comp,m


*highest of mom and dad
gen mom_dad_edu_comp=mom_edu_comp
replace mom_dad_edu_comp=dad_edu_comp if dad_edu_comp>mom_edu_comp & dad_edu_comp!=4 // take dad's edu if his edu is higher than mom's and his is not missing
replace mom_dad_edu_comp=dad_edu_comp if dad_edu_comp!=4 & mom_edu_comp==4 // take dad edu if mom's missing
label values mom_dad_edu_comp edulab2

tab mom_dad_edu_comp,m
tab mom_edu_comp,m



/*social security regime for mother's health - seg_social
1 = Contributory
2 = Subsidized
3 = Exception
4 = Special
5 = Not insured
9 = No information
*/
tab seg_social,m 

recode seg_social (9=6)

label define seclab 1 "Contributory" 2 "Subsidized" 3 "Exception" 4 "Special" 5 "Not insured" 6 "Missing information"
label values seg_social seclab

/*Number of children born alive that the mother has had including the present - n_hijosv
1-22 children
99 no information
*/
tab n_hijosv, m
gen parity=.
replace parity=1 if n_hijosv==1 // 0 parity
replace parity=2 if n_hijosv==2 // 1 parity
replace parity=3 if n_hijosv==3 // 2 parity
replace parity=4 if n_hijosv==4 // 3 parity
replace parity=5 if n_hijosv>=5 // 4 or more parity
replace parity=6 if n_hijosv==99 // missing information on parity

label define parlab 1 "0 Parity" 2 "1" 3 "2" 4 "3" 5 "4 or more" 6 "Missing information"
label values parity parlab
tab parity,m 
 
*** LoCo variables***

gen loco=0
replace loco=1 if mdate>=tm(2020m12)


gen zika=0
replace zika=1 if mdate >=tm(2016m8) & mdate <=tm(2016m12)


*save prepared data
save "$dta/colombia_births_2015.dta", replace





**# Bookmark #4
************************* Ecuador ******************************

/*** import csv for each year and merge together
https://aplicaciones3.ecuadorencifras.gob.ec/BIINEC-war/index.xhtml

Data dictonary:
Can be downloaded in same place for each data set

import delimited "$dta/ENV_2015.csv", clear
tab anio_nac
tab anio_insc
import delimited "$dta/ENV_2016.csv", clear
tab anio_nac
tab anio_insc
import delimited "$dta/ENV_2017.csv", clear
tab anio_nac
tab anio_insc
import delimited "$dta/ENV_2018.csv", clear
tab anio_nac
tab anio_insc
import delimited "$dta/ENV_2019.csv", clear
tab anio_nac
tab anio_insc
import delimited "$dta/ENV_2020.csv", clear
tab anio_nac
tab anio_insc
import delimited "$dta/ENV_2021.csv", clear
tab anio_nac
tab anio_insc
*/
forval i=15/22 {
	import delimited "$dta/ENV_20`i'.csv", clear
	tostring *, replace // set to missing if types differ - PAY ATTENTION
	save "$dta/ENV_20`i'.dta", replace
}
use "$dta/ENV_2015", clear
forval i=16/22 {
append using "$dta/ENV_20`i'.dta", force
}


************* check s ***********

tab anio_insc , m

tab anio_nac , m // how it looks like the official release. The births are a bit higher because t+ n is higher



*looks decent.

/*variables we need:
anio_nac - year of birth

mes_nac - month of birth

dia_nac - day of birth

fecha_nac - date with year-month-day (as complete as others?)

cant_res - canton of residence ; need for merge to area deprivation
- will be a lot of work to merge to area codes

edad_madre - age of mother in years

hij_viv - living children

niv_inst - level of education achieved

sabe_leer - can read and write

*/


**** time variables ***

tab mes_nac,m

gen month_nr=.
replace month_nr=1 if mes_nac=="1" | mes_nac=="Enero"
replace month_nr=2 if mes_nac=="2" | mes_nac=="Febrero"
replace month_nr=3 if mes_nac=="3" | mes_nac=="Marzo"
replace month_nr=4 if mes_nac=="4" | mes_nac=="Abril"
replace month_nr=5 if mes_nac=="5" | mes_nac=="Mayo"
replace month_nr=6 if mes_nac=="6" | mes_nac=="Junio"
replace month_nr=7 if mes_nac=="7" | mes_nac=="Julio"
replace month_nr=8 if mes_nac=="8" | mes_nac=="Agosto"
replace month_nr=9 if mes_nac=="9" | mes_nac=="Septiembre"
replace month_nr=10 if mes_nac=="10" | mes_nac=="Octubre"
replace month_nr=11 if mes_nac=="11" | mes_nac=="Noviembre"
replace month_nr=12 if mes_nac=="12" | mes_nac=="Diciembre"

tab month_nr, m

tab anio_nac,m 
destring anio_nac, gen(year)
tab year, m
drop if year<2015
drop if year==2022

destring dia_nac, gen(day)
tab day,m

gen bdate_d=dmy(day, month_nr, year)
format bdate_d %td

gen bdate_w=wofd(bdate_d)
format bdate_w %tw

gen mdate=mofd(bdate_d)
format mdate %tm

gen bweek=week(bdate_d)


gen loco=0
replace loco=1 if bdate_w>=tw(2020w51)


**Brazil zika perdiod (works better for the drops as shown in sensitvity analysis)
* zika period from August 2016 to end of Dec 2016
gen zika=0
replace zika=1 if bdate_w >=tw(2016w31) & bdate_w <=tw(2016w52)


/**** ZIKA had two waves in Ecuador. see Zika Epidemiological Report Ecuador 2017 WHO
https://www3.paho.org/hq/dmdocuments/2017/2017-phe-zika-situation-report-ecu.pdf
first wave 17th week 40th week 2016, -> exposed period is 40 weeks lagged: 2017w5 - 2017w28 
second wave 3rd week to 30th week of 2017 -> exposed perdiod: 2017w43 - 2018w18

*/
gen zika_ecu=0
replace zika_ecu=1 if bdate_w >=tw(2017w5) & bdate_w <=tw(2017m28)
replace zika_ecu=1 if bdate_w >=tw(2017w43) & bdate_w <=tw(2018m18)

*WHO declares ZIKA a public health emergency of international concern in Feb 1st 2016 which is before it hit Ecuador (see above)

gen str country="Ecuador"

*****************************************************
*****************************************************

*age of mother

tab edad_mad,m
destring edad_mad, gen(mom_age) force
tab mom_age,m
gen mom_age_cat=. 
replace mom_age_cat = 1 if mom_age <20 & mom_age!=.
replace mom_age_cat =2 if mom_age >19 & mom_age <25 & mom_age!=.
replace mom_age_cat =3 if mom_age >24 &  mom_age<30 & mom_age!=.
replace mom_age_cat =4 if mom_age >29 &  mom_age<35 & mom_age!=.
replace mom_age_cat =5 if mom_age >34 & mom_age!=.
replace mom_age_cat =6 if edad_mad=="Ignorado" | edad_mad=="Sin información"
tab mom_age_cat,m

label define age_lab 1 "Maternal Age Under 20" 2 "20-24" 3 "25-29" 4 "30-34" 5 "35 and Above" 6 "Missing information/ Ignored"
label values mom_age_cat age_lab
tab mom_age_cat,m 

*parity or living children in this case.
tab hij_viv,m 
destring hij_viv, gen(liv_child)
tab liv_child,m
replace liv_child=1 if liv_child==1 
replace liv_child=2 if liv_child==2
replace liv_child=3 if liv_child==3
replace liv_child=4 if liv_child==4
replace liv_child=5 if liv_child>4
tab liv_child,m
label define parlab 1 "0 Parity" 2 "1" 3 "2" 4 "3" 5 "4 or more" 6 "Missing information"
label values liv_child parlab
tab liv_child,m

*literacy

tab sabe_leer,m
gen read_write=.
replace read_write=1 if sabe_leer=="No"
replace read_write=2 if sabe_leer=="Si"
replace read_write=3 if sabe_leer=="Ignorado" | sabe_leer=="Sin información"

label define readlab 1 "No" 2 "Yes" 3 "Ignored or no information"
label values read_write readlab
tab read_write,m


* education 
tab niv_inst,m
/*
Centro de Alfabetización |        499        0.03        0.03
       Centro de alfabetización |      2,408        0.13        0.15
      Ciclo Post - Bachillerato |      3,635        0.19        0.34
        Ciclo Post-Bachillerato |      3,403        0.18        0.52
               Educación Básica |    387,618       20.15       20.67
 Educación Media / Bachillerato |    318,509       16.56       37.23
  Educación Media /Bachillerato |     31,836        1.66       38.89
               Educación básica |     43,291        2.25       41.14
 Educación media / bachillerato |     51,863        2.70       43.83
                        Ninguno |     26,423        1.37       45.21
                       Posgrado |        956        0.05       45.26
                      Postgrado |      4,919        0.26       45.51
                       Primaria |    241,533       12.56       58.07
                      Se ignora |     17,950        0.93       59.00
                     Secundaria |    394,603       20.52       79.52
                Sin información |     12,403        0.64       80.16
                       Superior |     93,849        4.88       85.04
      Superior no universitario |     57,250        2.98       88.02
         Superior universitario |    2
		 
		 Check ISCED sheet for Ecuador...there is none, but this info;
	https://redes.colombiaaprende.edu.co/ntg/men/micrositio_convalidaciones/Guias_/MINEDU-ecuador/niveles_educativos.html?lang=es
	
Primaria= primary
Basica= lower secondary
Educación Media / Bachillerato = Upper secondary
WHAT IS SECUNDARIA?
secundaria= education media / bachillerato
ciclo post bachillerato= post secondary non tertiary

		 
*/
*create one general
gen mom_edu=.
replace mom_edu=1 if niv_inst=="Ninguno" // None
replace mom_edu=2 if niv_inst=="Centro de Alfabetización" | niv_inst=="Centro de alfabetización" // Literacy Center
replace mom_edu=3 if niv_inst=="Primaria"
replace mom_edu=4 if niv_inst=="Educación Básica" | niv_inst=="Educación básica"
replace mom_edu=5 if niv_inst=="Secundaria"
replace mom_edu=5 if niv_inst=="Educación Media / Bachillerato" | niv_inst=="Educación Media /Bachillerato" | niv_inst=="Educación media / bachillerato"
replace mom_edu=6 if niv_inst=="Superior no universitario" | niv_inst== "Superior" | niv_inst=="Superior universitario" | niv_inst=="Ciclo Post - Bachillerato" | niv_inst=="Ciclo Post-Bachillerato"  // non-uni higher education
replace mom_edu=7 if niv_inst=="Posgrado" | niv_inst=="Postgrado"
replace mom_edu=8 if niv_inst=="Se ignora"
replace mom_edu=9 if niv_inst=="Sin información"

label define edulab 1 "None" 2 "Centro de Alfabetización" 3 "Primaria" 4 "Educación Basica" 5 "Secundaria" 6 "Higher Education" 7 "Post graduate" 8 "Ignored" 9 "No information"
label values mom_edu edulab

tab mom_edu year, m


gen mom_edu_sum=.
replace mom_edu_sum=1 if mom_edu==1 | mom_edu==9 // none and no information
replace mom_edu_sum=2 if mom_edu==2 // Centro alfabetización
replace mom_edu_sum=3 if mom_edu==3 | mom_edu==4 | mom_edu==5 // primaria, educacion bascia, secundaria
replace mom_edu_sum=4 if mom_edu==6 // Higher education
replace mom_edu_sum=5 if mom_edu==7 // Postgrad
replace mom_edu_sum=6 if mom_edu==8 // Ignored

tab mom_edu_sum year, m col
*looks like the education variable is pretty shit because inconsistent through time. 

** can we find one that is consistent in more recent years?




*******************************************************************
*******************************************************************
************* DEPRIVATION INDEX **************************
*rely on deprivation index. 
*it's a mess. how to do it?

save "$dta/Ecuador_births_2015_2021.dta",replace


*prepare canton linkfile

import excel "$dta\DIVISION POLITICO ADMINISTRATIVA 2010.xls", sheet("Sheet1") firstrow clear
keep if C1!="" & c2!=""
drop if c3!=""

*down to 229 cantons! some are in there which might not exist anymore. we keep them in case birth certificates are referring to old cantons

*combine into 4 digit code

gen canton=C1 + c2
keep C1 c2 c3 name canton
replace canton = subinstr(canton, " ", "", .)
gen CANTON=stritrim(canton)
destring CANTON, replace // merge on stringts

rename C1 first_2dig
rename c2 dig3_4

save "$dta/canton_name_code.dta", replace

use "$dta\Ecuador_depr_index.dta", clear

merge 1:1 CANTON using "$dta/canton_name_code.dta"

drop c3

*do rest by hand

*export excel using "$dta\Ecuador_cantons_depr.xls", replace firstrow(variables)



use  "$dta/Ecuador_births_2015_2021.dta",clear 
capture drop rev_name code_4digit canton_merge
tab cant_res,m 

*clean the string
*get rid of all weird letters
/*To strip off combining marks (e.g. accents, umlauts, etc.) using ustrregexra( varname , "\p{Mark}", "" ) normalizing to NFD using ustrnormalize() is necessary.*/

gen rev_name=lower(ustrto(ustrnormalize(cant_res, "nfd"), "ascii",2))
*br cant_res rev_name
tab rev_name,m
*give the numbers with 3 characters a leading zero
gen code_4digit=substr("0",1, 1) + rev_name if length(rev_name)==3
* IT WORKED!
replace rev_name = subinstr(rev_name, " ", "", .) // there are some blanks that fuck up merging later


gen canton_merge=rev_name
replace canton_merge=code_4digit if code_4digit!=""

* canton_merge contains the name without accents and all lower case. All codes are now on 4 digits.
*first merge birth register with depr index on 4 digit codes as stringts
*then merge on names
save "$dta/Ecuador_births_2015_2021.dta",replace

import excel "$dta/Ecuador_cantons_depr.xls", clear firstrow
gen rev_name=lower(ustrto(ustrnormalize(name_lowercase, "nfd"), "ascii",2))
replace rev_name = subinstr(rev_name, " ", "", .) // there are some blanks that fuck up merging later

keep CANTON index first_2dig dig3_4 name canton rev_name
drop if CANTON==""

rename CANTON canton_merge
drop if index==.
xtile quint_DPI=index , nq(5)

save "$dta/depr_rdy_formerge.dta",replace

*drums pls
use "$dta/Ecuador_births_2015_2021.dta",clear
replace canton_merge="ona" if canton_merge=="0ona"

/*okay, there are 2 olmeda cantons. 
one in Manabi= 1318
one in Loja= 1116

*/
*link table strategy
*GIVE THE NAMES THE CODE BASED ON CANTON AND PROVINCE NAME
keep prov_res canton_merge
duplicates drop prov_res canton_merge, force

duplicates report canton_merge
duplicates list canton_merge
/* cases
*code 2204 is loreto in depri index. In Birth register this code is in province Orellana and Napo. Likley to be the same as they border each other.
Loreto in Napo can be dropped
those who are 2204 will be merged to 2204 in Orellana Loreto which is correct
*/

/*
Next is canton bolivar which is a canton in Carchi and a Canton in Manabi
Bolivar, Carchi has the code = 0402
Bolivar, Manabi has the code = 1302

*/

/*
Next is olmedo, which is a canton in Province Manabi and a Canton in Province Loja
Olemdo, Manabi = 1318
Olmedo, Loja = 1116
*/

use "$dta/Ecuador_births_2015_2021.dta",clear
replace canton_merge="ona" if canton_merge=="0ona"
tab canton_merge prov_res if canton_merge=="bolivar"
replace canton_merge="0402" if canton_merge=="bolivar" & prov_res=="Carchi"
replace canton_merge="1302" if canton_merge=="bolivar" & prov_res=="Manabí"
replace rev_name="0402" if canton_merge=="0402"
replace rev_name="1302" if canton_merge=="1302"

tab canton_merge prov_res if canton_merge=="olmedo"
replace canton_merge="1116" if canton_merge=="olmedo" & prov_res=="Loja"
replace canton_merge="1318" if canton_merge=="olmedo" & prov_res=="Manabí"
replace rev_name="1116" if canton_merge=="1116"
replace rev_name="1318" if canton_merge=="1318"

tab canton_merge prov_res if canton_merge=="2204" // will be merged correctly

*2302 does not exists. 23 is one province with one canton= santo domingo
replace canton_merge="2301" if canton_merge=="2302"
replace rev_name="2301" if canton_merge=="2301"

tab rev_name

replace canton_merge="1905" if canton_merge=="yantzaza(yanzatza)" | canton_merge=="yantzaza"
replace rev_name="1905" if rev_name=="yantzaza(yanzatza)" | rev_name=="yantzaza"

replace canton_merge="1807" if canton_merge=="pelileo"
replace rev_name="1807" if canton_merge=="1807"

replace canton_merge="1808" if canton_merge=="pillaro"
replace rev_name="1808" if canton_merge=="1808"

replace canton_merge="0920" if canton_merge=="sanjacintodeyaguachi"
replace rev_name="0920" if rev_name=="sanjacintodeyaguachi"
replace canton_merge="0920" if canton_merge=="yaguachi"
replace rev_name="0920" if rev_name=="yaguachi"

replace canton_merge="0927" if canton_merge=="generalantonioelizalde(bucay)"
replace rev_name="0927" if rev_name=="generalantonioelizalde(bucay)"

replace canton_merge="0808" if canton_merge=="laconcordia"
replace rev_name="0808" if rev_name=="laconcordia"

/*
ZONAS NO DELIMITADAS
90 01 51 Las golondrinas
90	03	51	MANGA DEL CURA
90	04	51	EL PIEDRERO
*
* they have no deprivation index

8800 is born abroad as is exterior

"generalantonioelizalde(bucay)" - get rid of bucary in birth data or code 0972

"pelileo" in birth register is "san pedro de pelileo" in DPI (1807)
"pillaro" in birth register is "santiago de pillaro" in DPI (1808)
"yagauachi" in birth register is "san jacinto de yagauachi" in DPI (0920)
"yantzaza (yanzatza)" just give it "1905" in birth register

*/


merge m:1 canton_merge using "$dta/depr_rdy_formerge.dta" // merge to those which have codes

tab rev_name
preserve 
drop if _merge==1
save "$dta/births_mergedoncode.dta", replace
restore

preserve
use "$dta/depr_rdy_formerge.dta",clear
duplicates list rev_name
drop if rev_name=="bolivar" | rev_name=="olmedo"
save "$dta/depr_rdy_formerge2.dta",replace
restore

drop if _merge!=1
drop canton_merge index first_2dig dig3_4 name canton _merge quint_DPI
merge m:1 rev_name using "$dta/depr_rdy_formerge2.dta" // merge for those who have names no codes
tab rev_name if _merge!=3

/*
ZONAS NO DELIMITADAS
90 01 51 Las golondrinas
90	03	51	MANGA DEL CURA
90	04	51	EL PIEDRERO
*
* they have no deprivation index
*/
drop if _merge==2 // they are not in birth data anymore because I changed everyone to code in these cantons
** now append the other dataset with merged on code

append using "$dta/births_mergedoncode.dta"
*laconcordia missing----

*1,923,376 births - did we lose some?

*1,923,376 in Birth_2015_2021!.. We did it
tab rev_name if index==.

tab quint_DPI,m

label define dpilab 1 "Least deprived 20%" 2 "Q2" 3 "Q3" 4 "Q4" 5 "Most deprived 20%"
label values quint_DPI dpilab
save "$dta/Ecuador_births_DPI_2015_2021",replace


*fucking worked. only 703 missing on deprivation. 



**# Bookmark #5
************************* England ******************************

/*
Data was purchased in aggregated time series data. 
Now openly available at: 

https://www.ons.gov.uk/peoplepopulationandcommunity/birthsdeathsandmarriages/livebirths/adhocs/1703livebirthsbymonthofoccurrenceandimddecileenglandandwales2015to2022

*/

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


**# Bookmark #6
************************* Finland ******************************

/*
Access to individual-level data is restricted
(see country profile in supplementary material)

*/



**# Bookmark #7
************************* Mexico ******************************

/* GET INDIVIDUAL LEVEL DATA FROM INEGI
https://en.www.inegi.org.mx/programas/natalidad/#microdata


*/

/*
import dbase using "$dta\natalidad_base_datos_2015_dbf\nacim15.dbf", clear
tab ANO_NAC,m
tab ANO_REG,m

import dbase using "$dta\natalidad_base_datos_2021_dbf\nacim21.dbf", clear
tab ANO_NAC,m
tab ANO_REG,m
import dbase using "$dta\natalidad_base_datos_2022_dbf\nacim22.dbf", clear
tab ANO_NAC,m
tab ANO_REG,m
*/

***** Import dbf files
forval i=15/22 {
	
import dbase using "$dta\natalidad_base_datos_20`i'_dbf\nacim`i'.dbf", clear
save "$dta\births_20`i'.dta", replace
}

use "$dta/births_2015.dta", clear
forval i=16/22 {
append using "$dta/births_20`i'.dta", force //  DIS_RE_OAX is string and numeric
}
count // 16 586 896 .. where are the others
* 16,971,189 births
**************** prepare variables ********************
* Data dictionary*
*https://www.inegi.org.mx/rnm/index.php/catalog/806/data-dictionary/F12?file_name=NACIM21

*time variables
tab ANO_NAC,m 
tab ANO_REG,m 

**** These are the same figures they have in the 2023 release table 1 https://www.inegi.org.mx/contenidos/saladeprensa/boletines/2023/NR/NR2022.pdf


drop if ANO_NAC < 2015 //
drop if ANO_NAC==9999 
tab ANO_NAC,m
drop if ANO_NAC==2022 // only needed them for registrations
gen year=ANO_NAC
gen month_nr= MES_NACIM
replace month_nr=MES_NAC if month_nr==.
gen day= DIA_NAC

gen bdate_d= dmy(day, month_nr, year)
format bdate_d %td

br year month_nr day bdate_d if bdate_d==. // 
count if bdate_d==. // 35 missing . doesn't matter with 13.7 mill obs
gen bdate_w=wofd(bdate_d)
format bdate_w %tw
gen numweek=wofd(bdate_d)
sort numweek
gen mdate= ym(year, month_nr)
format mdate %tm

gen bweek=week(bdate_d)


gen loco_w=0
replace loco_w =1 if bdate_w>=tw(2020w51)

gen zika=0
replace zika=1 if bdate_w >=tw(2016w31) & bdate_w <=tw(2016m52)

*maternal age
tab EDAD_MADN,m
desc EDAD_MADN

gen mom_age_cat=.
replace mom_age_cat=1 if EDAD_MADN<20
replace mom_age_cat=2 if EDAD_MADN>19 & EDAD_MADN<25
replace mom_age_cat=3 if EDAD_MADN>24 & EDAD_MADN<30
replace mom_age_cat=4 if EDAD_MADN>29 & EDAD_MADN<35
replace mom_age_cat=5 if EDAD_MADN>34
replace mom_age_cat=6 if EDAD_MADN==99

tab mom_age_cat,m 
label define agel 1 "Maternal Age Under 20" 2 "20-24" 3 "25-29" 4 "30-34" 5 "35 and Above" 6 "Missing information"
label values mom_age_cat agel

*Parity 
* can use living children = hijos_vivo

tab HIJOS_VIVO,m
desc HIJOS_VIVO
gen parity=.
replace parity=1 if HIJOS_VIVO==1 // parity 0
replace parity=2 if HIJOS_VIVO==2
replace parity=3 if HIJOS_VIVO==3
replace parity=4 if HIJOS_VIVO==4
replace parity=5 if HIJOS_VIVO>=5 // 4 or more
replace parity=6 if HIJOS_VIVO==99 // misisngt
tab parity, m
label define parlab 1 "Parity 0" 2 "1" 3 "2" 4 "3" 5 "4 or more" 6 "Missing information" 
label values parity parlab

*maternal education 
* OECD educational system:
* https://gpseducation.oecd.org/CountryProfile?primaryCountry=MEX&treshold=10&topic=EO
* https://gpseducation.oecd.org/Content/MapOfEducationSystem/MEX/MEX_2011_LL.pdf
tab ESCOL_MAD,m
gen mom_edu=1 if ESCOL_MAD==1 // no schooling
replace mom_edu=2 if ESCOL_MAD==2 // From 1 to 3 years of elementary school
replace mom_edu=3 if ESCOL_MAD==3 // From 4 to 5 years of elementary school
replace mom_edu=4 if ESCOL_MAD==4 // Completed elementary school
replace mom_edu=5 if ESCOL_MAD==5 // Secundaria or equivalent. means lower secondary (ISCED 2)
replace mom_edu=6 if ESCOL_MAD==6 // preparatoria or equivalent. means upper secondary (ISCED 3)
replace mom_edu=7 if ESCOL_MAD==7 // Profesional. means also upper secondary, just vocational (ISCED 3)
replace mom_edu=8 if ESCOL_MAD==8 // Otra. Another?
replace mom_edu=9 if ESCOL_MAD==9 // Unspecified

* no post-secondary education here.

label define edulab 1 "No schooling" 2 "1-3 years elementary" 3 "4-5 years elementary" 4 "Completed elementary" 5 "Lower secondary" 6 "Upper secondary" 7 "Vocational upper secondary" 8 "Other" 9 "Unspecified"
label values mom_edu edulab

*maternal education comparative
gen mom_edu_comp=.
replace mom_edu_comp=1 if mom_edu==1 | mom_edu==2 | mom_edu==3 |mom_edu==4 
replace mom_edu_comp=2 if mom_edu==5 // lower secondary
replace mom_edu_comp=3 if mom_edu==6 | mom_edu==7 | mom_edu==8 
replace mom_edu_comp=4 if mom_edu==9 // unspecified
tab mom_edu_comp,m

label define mex_ed 1 "Elementary" 2 "Lower Secondary" 3 "Upper Secondary" 4 "Unknown"
label values mom_edu_comp mex_ed

*maternal education 
* OECD educational system:
* https://gpseducation.oecd.org/CountryProfile?primaryCountry=MEX&treshold=10&topic=EO
* https://gpseducation.oecd.org/Content/MapOfEducationSystem/MEX/MEX_2011_LL.pdf
tab ESCOL_PAD,m
gen dad_edu=1 if ESCOL_PAD==1 // no schooling
replace dad_edu=2 if ESCOL_PAD==2 // From 1 to 3 years of elementary school
replace dad_edu=3 if ESCOL_PAD==3 // From 4 to 5 years of elementary school
replace dad_edu=4 if ESCOL_PAD==4 // Completed elementary school
replace dad_edu=5 if ESCOL_PAD==5 // Secundaria or equivalent. means lower secondary (ISCED 2)
replace dad_edu=6 if ESCOL_PAD==6 // preparatoria or equivalent. means upper secondary (ISCED 3)
replace dad_edu=7 if ESCOL_PAD==7 // Profesional. means also upper secondary, just vocational (ISCED 3)
replace dad_edu=8 if ESCOL_PAD==8 // Otra. Another?
replace dad_edu=9 if ESCOL_PAD==9 // Unspecified

* no post-secondary education here.

label values dad_edu edulab

tab dad_edu,m

*paternal education comparative
gen dad_edu_comp=.
replace dad_edu_comp=1 if dad_edu==1 | dad_edu==2 | dad_edu==3 |dad_edu==4 
replace dad_edu_comp=2 if dad_edu==5 // lower secondary
replace dad_edu_comp=3 if dad_edu==6 | dad_edu==7 | dad_edu==8 
replace dad_edu_comp=4 if dad_edu==9 // unspecified
tab dad_edu_comp,m

label values dad_edu_comp mex_ed

*highest edu of parents
gen mom_dad_edu_comp=mom_edu_comp
replace mom_dad_edu_comp=dad_edu_comp if dad_edu_comp>mom_edu_comp & dad_edu_comp!=4 // take dad's edu if his edu is higher than mom's and his is not missing
replace mom_dad_edu_comp=dad_edu_comp if dad_edu_comp!=4 & mom_edu_comp==4 // take dad edu if mom's missing
label values mom_dad_edu_comp mex_ed

tab mom_dad_edu_comp,m
tab mom_edu_comp,m



save "$dta/Mexico_births_2015_2021.dta", replace


**# Bookmark #8
************************* Netherland ******************************

/*
Access to individual-level data is restricted. We aggregated individual-level data to aggregated time series (see country profiles in supplementary material)
*/

import excel "$dta\Monthly_births_counts.xlsx", sheet("Counts") firstrow clear

rename birthmonth month_nr
rename birthyear year
gen mdate=ym(year, month_nr)
format mdate %tm
rename sumQNA sumQ6
reshape long sumQ, i(mdate) j(quint_hhinc)
rename sumQ n_births
rename totalbirths total_births
keep mdate quint_hhinc n_births total_births month_nr 
gen loco =0
replace loco=1 if mdate>tm(2020m11)

save "$dta/Netherlands_births_2015_2021.dta", replace


**# Bookmark #9
************************* Scotland ******************************
import delimited "$dta/mode_of_delivery_extract_23052023.csv", clear 
* data openly available at https://scotland.shinyapps.io/phs-covid-wider-impact/ (last accessed 23/05/2023)

keep if area_name=="Scotland" & subgroup=="SIMD"

*gen date
gen date = date(month_of_discharge,"MY")
format date %td
gen mdate=mofd(date)
format mdate %tm
gen year=yofd(date)
rename births allbirths
gen month_nr=month(date)

*merge Stringency Index
merge m:1 mdate using "$dta/SI_dta08082022.dta",force
drop if _merge==2
drop _merge

replace SI=0 if SI==.
replace avg_SI_m=0 if avg_SI_m==.

encode variable, gen(SIMD)
replace SIMD=99 if SIMD==6


keep area_name month_of_discharge spontaneous assisted_vaginal csection_all csection_elec csection_emer other_not_known allbirths perc_assisted_vaginal perc_csection_all perc_csection_elec perc_csection_emer perc_spontaneous perc_other_not_known date mdate year SI date_d date_w avg_SI_m avg_SI_w month_nr SIMD 

save "C:\Users\moritzob\OneDrive - University of Helsinki\postdoc life helsinki\LoCo-effect\C-sections-Scotland-Github\dta\csec_2018_Jan2023.dta", replace

*Merge data from 2015-2018*******************************
*Merge data from 2015-2018*******************************
*Merge data from 2015-2018*******************************

import delimited "$dta/method_delivery_simd_10112022.csv", clear 
* data openly available at https://scotland.shinyapps.io/phs-covid-wider-impact/ (last accessed 14/10/2022)
*****
keep if subgroup=="SIMD"

*gen date
gen date = date(month_of_discharge,"YMD")
format date %td
gen mdate=mofd(date)
format mdate %tm
gen year=yofd(date)
*think of it as 5 time series. 1 for each SIMD
*gen SIMD
encode variable, gen(SIMD)
replace SIMD=99 if SIMD==6

sort SIMD mdate
xtset SIMD mdate
rename births allbirths
bysort mdate: egen total_births= sum(allbirths)
gen perc_allbirths= allbirths/total_births
label variable perc_allbirths "Proportion of all births"
tsset  SIMD mdate





**# Bookmark #10
************************* Spain ******************************
/*
SPAIN OPEN ACCESS DATA. Jan 2015 to Dec 2021.
data available from:
https://www.ine.es/dyngs/INEbase/en/operacion.htm?c=Estadistica_C&cid=1254736177007&menu=resultados&secc=1254736195443&idp=1254735573002#!tabs-1254736195443

prepare 2016-2021 and then append
variables:
MESPAR - month of delivery
ANOPAR - Year of delivery
SEMANAS - weeks of gestation
NACIOEM - Spanish Nationality of mother
ESTUDIOM - mother education
CAUTOM - mother's occupational code
ECIVM - mother's marital status
NUHMV - parity live birhts
EDADM - age mother in years
RELLB1	age father in years
SEXO	sex of baby
PESON	birthweight
CLASIF	dead or alive birth
ESTUDIOP	education father
CAUTOP	occupation father


*/


forval i=2016(1)2021 {
	
	use "$dta/MNPnacim_`i'.dta", clear
	**time var**
tab MESPAR, m
destring MESPAR, replace

gen mdate=ym( ANOPAR, MESPAR)
format mdate %tm
tab mdate

rename MESPAR month_nr
rename ANOPAR year

**
**EDUCATION*****
tab ESTUDIOM, m
tab mdate ESTUDIOM, m
destring ESTUDIOM, gen(edu)
tab mdate edu, m
recode edu ///
(2=1) /// illiterate+ incomplete primary
(3=1) /// primary or lower
(6=5) /// upper secondary
(7=5) /// upper secondary + non-tertiary, post-secondary education
(12=11) // master's and PhD
gen edu_mom_det=edu
replace edu_mom_det=2 if edu==4
replace edu_mom_det=3 if edu==5
replace edu_mom_det=4 if edu==8
replace edu_mom_det=5 if edu==9
replace edu_mom_det=6 if edu==10
replace edu_mom_det=7 if edu==11
replace edu_mom_det=8 if edu==99


label define edulab 1 "Primary or lower" 2 "Lower Secondary" 3 "Upper Secondary" 4 "Vocational Education" 5 "University 240 ECTS" 6 "University more than 240 ECTS" 7 "Master's or PhD" 8 "Not recorded"
label values edu_mom_det edulab
tab mdate edu_mom_det, m

*summarised
tab ESTUDIOM, m
tab mdate ESTUDIOM, m
destring ESTUDIOM, gen(edu_sum)
tab mdate edu_sum, m
recode edu_sum ///
(2=1) /// illiterate+ incomplete primary
(3=1) /// primary or lower
(6=5) /// upper secondary
(8=7) /// non-tertiary, post-secondary education + Vocational training
(10=9) /// long BA o BA
(11=9) /// master's to long bachelor's
(12=9) // PhD to master's and long bachelor's
gen edu_mom=edu_sum // 1= primary or lower
replace edu_mom=2 if edu_sum==4 // lower secondary
replace edu_mom=3 if edu_sum==5 // upper secondary
replace edu_mom=4 if edu_sum==7 // non-tertiary, post-secondary education + Vocational training
replace edu_mom=5 if edu_sum==9 // Bachelor's, Long Bachelor's, Master's, PhD
replace edu_mom=6 if edu_sum==99 // not recorded

label define edulab2 1 "Primary or Lower" 2 "Lower Secondary" 3 "Upper Secondary" 4 "Vocat. Educ.; Non-tert. Post-second." 5 "University Degree" 6 "Not recorded"
label values edu_mom edulab2
tab mdate edu_mom, m

* mom edu comparative
gen mom_edu_comp=.
replace mom_edu_comp=1 if edu_mom==1 | edu_mom==2 // primary or lower secondary
replace mom_edu_comp=2 if edu_mom==3 // upper secondary
replace mom_edu_comp=3 if edu_mom>3 & edu_mom <6 // post secondary + teriary
replace mom_edu_comp=4 if edu_mom==6 // not recorded

label define edu_sum2 1 "No Highschool diploma" 2 "Upper secondary" 3 "Post-secondary; Tertiary" 4 "Unknown or not collected"
label values mom_edu_comp edu_sum2


* DAD
tab ESTUDIOP, m
tab year ESTUDIOP, m
destring ESTUDIOP, gen(edu_sum_dad)
tab year edu_sum_dad, m
recode edu_sum_dad ///
(2=1) /// illiterate+ incomplete primary
(3=1) /// primary or lower
(6=5) /// upper secondary
(8=7) /// non-tertiary, post-secondary education + Vocational training
(10=9) /// long BA o BA
(11=9) /// master's to long bachelor's
(12=9) // PhD to master's and long bachelor's
gen edu_dad=edu_sum_dad // 1= primary or lower
replace edu_dad=2 if edu_sum_dad==4 // lower secondary
replace edu_dad=3 if edu_sum_dad==5 // upper secondary
replace edu_dad=4 if edu_sum_dad==7 // non-tertiary, post-secondary education + Vocational training
replace edu_dad=5 if edu_sum_dad==9 // Bachelor's, Long Bachelor's, Master's, PhD
replace edu_dad=6 if edu_sum_dad==99 // not recorded

*label define edulab2 1 "Primary or Lower" 2 "Lower Secondary" 3 "Upper Secondary" 4 "Vocat. Educ.; Non-tert. Post-second." 5 "University Degree" 6 "Not recorded"
label values edu_dad edulab2
tab year edu_dad, m

* dad edu comparative
gen dad_edu_comp=.
replace dad_edu_comp=1 if edu_dad==1 | edu_dad==2 // primary or lower secondary
replace dad_edu_comp=2 if edu_dad==3 // upper secondary
replace dad_edu_comp=3 if edu_dad>3 & edu_dad <6 // post secondary + teriary
replace dad_edu_comp=4 if edu_dad==6 // not recorded
label values dad_edu_comp edu_sum2

** highest edu of parents*****

*highest of mom and dad
gen mom_dad_edu_comp=mom_edu_comp
replace mom_dad_edu_comp=dad_edu_comp if dad_edu_comp>mom_edu_comp & dad_edu_comp!=4 // take dad's edu if his edu is higher than mom's and his is not missing
replace mom_dad_edu_comp=dad_edu_comp if dad_edu_comp!=4 & mom_edu_comp==4 // take dad edu if mom's missing
label values mom_dad_edu_comp edu_sum2

tab mom_edu_comp if year!=2015,m
tab dad_edu_comp if year!=2015,m
tab mom_dad_edu_comp if year!=2015,m 


***
**** Maternal AGE ****
tab EDADM, m
gen mom_age_cat=1 if EDADM<20
replace mom_age_cat=2 if EDADM>19 & EDADM<25
replace mom_age_cat=3 if EDADM>24 & EDADM<30
replace mom_age_cat=4 if EDADM>29 & EDADM<35
replace mom_age_cat=5 if EDADM>34 
label define agelab 1 "Under 20" 2 "20-24" 3 "25-29" 4 "30-34" 5 "35 and Above"
label values mom_age_cat agelab
tab mom_age_cat, m

**** PARITY***
tab NUMHV, m
gen parity=NUMHV
replace parity=4 if NUMHV>3 
tab parity, m
**
*** live births**
tab CLASIF, m
** maternal occupation**
tab mdate CAUTOM, m
** paternal occupation**
tab mdate CAUTOP, m

save "$dta/births_`i'.dta", replace

}
*create full data
use "$dta/births_2016.dta", clear
forval i=17(1)21 {
append using "$dta/births_20`i'.dta"
	
}
save "$dta/births_2016_2021.dta", replace





******* ADD 2015************
*Is ASCII file
clear all

infix str PROI 1-2	str MUNI 3-5	str MESPAR 6-7	str ANOPAR 8-11	str PROPAR 12-13	str MUNPAR 14-16	str LUGARPA 17-17	str ASISTIDO 18-18	str MULTIPLI 19-19	str NORMA 20-20	str CESAREA 21-21	str INTERSEM 22-22	str SEMANAS 23-24	str MESNACM 25-26	str AÑONACM 27-30	str NACIOEM 31-31	str NACIOXM 32-32	str PAISNACM 33-35	str CUANNACM 36-36	str PROMA 37-38	str MUNMA 39-41	str PAISNXM 42-44	str PROREM 45-46	str MUNREM 47-49	str PAISRXM 50-52	str ESTUDIOM 53-54	str CAUTOM 55-56	str ECIVM 57-57	str CASPNM 58-58	str MESMAT 59-60	str AÑOMAT 61-64	str PHECHO 65-65	str ESTABLE1 66-66	str MESEST1 67-68	str AÑOEST1 69-72	str NUMH 73-74	str NUMHV 75-76	str MESHAN 77-78	str AÑOHAN 79-82	str PROHANTE 83-84	str MUNHANTE 85-87	str PAISHANTX 88-90	str NACIOEHA 91-91	str NACIOXHA 92-92	str PAISNAHA 93-95	str MESNACP 96-97	str AÑONACP 98-101	str NACIOEP 102-102	str NACIOXP 103-103	str PAISNACP 104-106	str CUANNACP 107-107	str PROPA 108-109	str MUNPA 110-112	str PAISNXP 113-115	str DONDEP 116-116	str PROREP 117-118	str MUNREP 119-121	str PAISRXP 122-124	str ESTUDIOP 125-126	str CAUTOP 127-128	str TMUNIN 129-129	str TMUNNM 130-130	str TMUNNP 131-131	str TMUNNHA 132-132	str TMUNRM 133-133	str TMUNRP 134-134	str TPAISNACIMIENTOMADRE 135-135	str TPAISNACIMIENTOPADRE 136-136	str TPAISNACIMIENTOHIJOANTE 137-137	str TPAISRMADRE 138-138	str TPAISRPADRE 139-139	str TPAISNACIONALIDADMADRE 140-140	str TPAISNACIONALIDADPADRE 141-141	str TPAISNACIONALIDADHIJOANT 142-142	str TPAISNACIONALIDADNACIDO 143-143	str EDADM 144-145	str EDADMM 146-147	str EDADMREL 148-149	str ANOCA 150-151	str ANOREL 152-153	str INIHA 154-156	str BLANCOS 157-159	str EDADP 160-161	str NACIOEN 162-162	str NACIOXN 163-163	str PAISNACN 164-166	str SEXO 167-167	str PESON 168-171	str V24HN 172-172	str NACVN 173-173	str AUTOPSN 174-174	str MUERN 175-175	str CODCA1N 176-176	str CODCA2N 177-178	str CODCA4N 179-179	str CLASIF 180-180	str SORDENV 181-182	str NUMHVT 183-184	str TMUNPAR 185-185	str BLANCOStwo 186-202 ///
using "$dta/Anonimizado Nacimientos sin causa.A2015"


****prepare variables
tab MESPAR, m
destring MESPAR, replace
tab ANOPAR, m
destring ANOPAR, replace
gen mdate=ym( ANOPAR, MESPAR)
format mdate %tm
tab mdate

rename MESPAR month_nr
rename ANOPAR year





***
**** Maternal AGE ****
tab EDADM, m
destring EDADM, replace
tab EDADM
gen mom_age_cat=1 if EDADM<20
replace mom_age_cat=2 if EDADM>19 & EDADM<25
replace mom_age_cat=3 if EDADM>24 & EDADM<30
replace mom_age_cat=4 if EDADM>29 & EDADM<35
replace mom_age_cat=5 if EDADM>34 
label define agelab 1 "Under 20" 2 "20-24" 3 "25-29" 4 "30-34" 5 "35 and Above"
label values mom_age_cat agelab
tab mom_age_cat, m

**** PARITY***
tab NUMHV, m
destring NUMHV, replace
gen parity=NUMHV
replace parity=4 if NUMHV>3 
tab parity, m
**gestational age
destring SEMANAS, replace


*** live births**
tab CLASIF, m
** maternal occupation**
tab mdate CAUTOM, m
** paternal occupation**
tab mdate CAUTOP, m

* append to 2016-2021
save "$dta/births_2015.dta", replace

use "$dta/births_2016_2021.dta", clear

append using "$dta/births_2015.dta", force

save "$dta/births_2015_2021.dta", replace




**# Bookmark #11
************************* United States ******************************

/*
USA OPEN ACCESS DATA. Jan 2015 to Dec 2021.
data available from:
https://wonder.cdc.gov/

select: group by: year- month- mother's education? - for all ages
select: group by: year- month- father's education? - for all ages

need to use 2016 -2021 because Connecticut, New Jersey have no 2015 data**

.... age sensitivity analysis in other file
*/


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

gen str country="United States"

save "$dta/US_ts.dta", replace



**# Bookmark #12
************************* Wales ******************************

/*
Data was purchased in aggregated time series data. 
Now openly available at: 

https://www.ons.gov.uk/peoplepopulationandcommunity/birthsdeathsandmarriages/livebirths/adhocs/1703livebirthsbymonthofoccurrenceandimddecileenglandandwales2015to2022

*/

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

gen country="Wales"
save "$dta/WAL_ts.dta", replace









