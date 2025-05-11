proc import out=cirrhosis
datafile="C:/Users/ntlmp/Desktop/Datasets/cirrhosis.csv"
dbms=csv replace;
run;

data cirrhosis;
set cirrhosis;
if Status = "D" then censored = 0;
else if Status = "C" or Status = "CL" then censored = 1;
if Stage = 1 then Stage_level = "Stage1";
else if Stage = 2 then Stage_level = "Stage2";
else if Stage = 3 then Stage_level = "Stage3";
else if Stage = 4 then Stage_level = "Stage4";
run;

proc print data=cirrhosis; run;

/* fitting overall survival curve */
proc lifetest data=cirrhosis plots=(survival);
time N_Days*censored(1);
run;

/* KM curves and log-rank test by Drug v. Placebo */
proc lifetest plots=(survival);
time N_Days*censored(1);
strata Drug;
run;

/* KM curves and log-rank test by Sex */
proc lifetest plots=(survival);
time N_Days*censored(1);
strata Sex;
run;

/* KM curves and log-rank test by Hepatomegaly */
proc lifetest plots=(survival);
time N_Days*censored(1);
strata Hepatomegaly;
run;

/* KM curves and log-rank test by Ascites */
proc lifetest plots=(survival);
time N_Days*censored(1);
strata Ascites;
run;

/* PARAMETRIC SURVIVAL ANALYSIS (fixed!) */
proc lifereg data=cirrhosis;
class Sex;
model N_Days*censored(1)=Age Sex/dist=gamma;
run;
