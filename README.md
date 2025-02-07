Hi,
Thanks for your interest in our paper and the related code for the revised manuscript.
I appreciate that it is a lot of code and it might be difficult to navigate. I tried my best to describe what each chunck of code does next to the respective lines. 
If you want to see the code used for figures and the table in the revised main manuscript, go to the file R1_main_figures_tables_16012025.do. 
If you want to see the code used for everything that is in our revised supplementary material, go to the file R1_supplement_16012025.do.
We could have reduced the amount of code needed by using some additional loops and macros for each country. However, we feel that this would have made it more difficult to follow our decisions in the analysis.
This is code for Stata version 18. It has not been tested on prior versions of Stata.

Additionally, we publish our data preparation code although we cannot make the data available in this repository. Where data are available, you can find the links in the code files.
Upon request, we can possibly share the aggregated time series data we created using our restricted individual-level data access for Austria, Denmark, Finland, the Netherlands, South Australia, and Sweden.

With the code provided here, you are able to find and obtain the data for Brazil, Colombia, England, Mexico, Scotland, Spain, United States, Wales and produce the results and figures we present in the manuscript and supplement. Note that the estimations take longer for countries with bigger birth cohorts. If the you get an error message during the 10,000 random draws of each cohort composition, simply repeat this process and it should work. (Honestly, I don't know why it stops the draws on some occasions)
For Ecuador, you need to additionally obtain the Deprivation Index we used from Andrés Peralta. If you want to reproduce the results for Finland, Austria, and the Netherlands (all restricted access), please contact me and I will try to make a aggregated version of the data available.

Please don't hesitate to contact me if you have any issues finding parts of the code you are looking for. I'm happy to help. (moritz.oberndorfer@helsinki.fi)

Enjoy
